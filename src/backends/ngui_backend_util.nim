# TOP (Table Oriented Programming)


when defined(NGUI_DEF_UTIL_ELEMENT):
  # NElement -> Backend pointer
  var utilData: STable[NElement, pointer]
  
  proc raw(this: NElement): pointer = getOrDefault(utilData, this)
  proc data[T](this: NElement, _: typedesc[T]): T = cast[T](raw(this))
  proc `data=`(this: NElement, that: ptr) = utilData[this] = pointer(that)
  
  proc utilElement(this: pointer): NElement =
    for k, v in utilData:
      if v == this: return k

  proc utilExists(this: NElement): bool = this in utilData
  
  proc utilDel(this: NElement) = del(utilData, this)

when defined(NGUI_DEF_UTIL_CONTAINER):
  var
    # NGUI Child -> NGUI Parent
    utilParents:  STable[NElement, Container]
    # NGUI Parent -> NGUI Children
    utilChildren: STable[Container, seq[NElement]]
  
  proc utilParent(this: NElement): Container =
    getOrDefault(utilParents, this, nil)
  
  proc utilParent(this: NElement, parent: Container) =
    if isNil(parent): del(utilParents, this) else: utilParents[this] = parent

  proc utilRemove(this: Container, that: NElement) =
    doAssert NElement(this) == that.internalGetParent()
    let cChildren = addr(utilChildren[this])
    cChildren[].delete(cChildren[].find(that))
    that.utilParent nil      
    if len(cChildren[]) == 0: del(utilChildren, this)

  proc utilDelParent(this: NElement) =
    del(utilParents, this)

  proc utilChild(this: Container, that: NElement) =
    if this notin utilChildren: utilChildren[this] = @[that]
    else: utilChildren[this].add(that)
    that.utilParent this
  
  proc utilRemChildrenList(this: Container) = del(utilChildren, this)
    
  iterator utilItems(this: Container): NElement =
    for c in getOrDefault(utilChildren, this, @[]): yield c
    
  proc utilNext(this: NElement): NElement =
    let parent = this.internalGetParent
    if parent == nil: return
    var returnNext = false
    for child in utilChildren[parent]:
      if returnNext: return child
      returnNext = child.id == this.id
    return nil
  
  proc utilPrev(this: NElement): NElement =
    let parent = this.internalGetParent
    if parent == nil: return
    var prev: NElement = nil
    for child in utilChildren[parent]:
      if child.id == this.id: return prev
      prev = child
    return nil
  
  proc utilChildrenReinsert(this: Container) =
    let list = utilChildren[this]
    for ne in list: internalRemove(this, ne)
    for ne in list: internalAdd(this, ne)

  proc utilNChild(this: Container, n: int): NElement =
    utilChildren.withValue(this, that):
      if len(that[]) > n: return that[n]
    
  proc utilChildIndex(this: Container, that: NElement): int =
    result = -1
    utilChildren.withValue(this, list):
      for i, c in list[]:
        if c == that: return i
  
  proc utilLen(this: Container): int =
    if this in utilChildren: return len(utilChildren[this])
  
when defined(NGUI_DEF_UTIL_EVENT):
  var
    # NGUI Event -> {BackendPointer, CallBack}
    utilEvents:        array[NElementEvent, STable[pointer, NEventProc]]
  
  proc utilTrigger(event: NElementEvent, source: pointer): bool =
    if len(utilEvents[event]) == 0: return
    if source notin utilEvents[event]: return
    utilEvents[event][source]()
    return true

  proc utilDel(event: NElementEvent, p: pointer) =
    del(utilEvents[event], p)
  
  proc utilGet(event: NElementEvent, p: pointer): NEventProc =
    utilEvents[event][p]
  
  proc utilDelEventSource(p: pointer) =
    for kind in NElementEvent: utilDel(kind, p)
    
  proc utilExists(event: NElementEvent, p: pointer): bool =
    p in utilEvents[event]
    
  proc utilSet(event: NElementEvent, p: pointer, a: NEventProc) =
    utilEvents[event][p] = a

when defined(NGUI_DEF_UTIL_TIMER):
  # Timeout
  var utilRepeat: seq[
    tuple[handle: NRepeatHandle, hook: int, action: NRepeatProc]]
    
  template getBy(f): int =
    var idx = -1
    for i, e in utilRepeat:
      if e.f != f: continue
      idx = i
      break
    idx
    
  proc utilNextRepeatID: int =
    var id {.global.} : int
    inc(id)
    return id
  
  proc utilGet(handle: NRepeatHandle): NRepeatProc =
    utilRepeat[getBy(handle)].action
  
  proc utilDel(handle: NRepeatHandle) =
    del(utilRepeat, getBy(handle))

  proc utilTrigger(hook: int): bool =
    result = utilRepeat[getBy(hook)].action()
    if not result: del(utilRepeat, getBy(hook))

  proc utilRepeatAdd(event: NRepeatProc, handle: NRepeatHandle, rid: int) =
    utilRepeat.add((handle, rid, event))
    
  proc utilStopRepeat =
    for i in countDown(high(utilRepeat), 0):
      internalStop(utilRepeat[i].handle)

when defined(NGUI_DEF_UTIL_ADAPTER):
  type
    InitAdapterProc = proc(): pointer {.closure.}
    GetParentProc   = proc(p: pointer): pointer {.closure.}
    RemChildProc    = proc(p, c: pointer) {.closure.}
    AddChildProc    = proc(p, c: pointer) {.closure.}
    BefReinsertProc = proc(c: pointer) {.closure.}
    AdapterProcs    = tuple
      ini:          InitAdapterProc
      get:          GetParentProc
      bef:          BefReinsertProc
      rem:          RemChildProc
      add:          AddChildProc

  var elementAdapter: STable[pointer, pointer]
  
  proc utilGetOrNewAdapter(this: pointer, ini: InitAdapterProc): pointer =
    if this notin elementAdapter: elementAdapter[this] = ini()
    return elementAdapter[this]

  proc utilGetOrAddAdapter(this: pointer, procs: AdapterProcs): pointer =
    if this notin elementAdapter:
      let adaptor = procs.ini()
      procs.add(adaptor, this)
      elementAdapter[this] = adaptor
    return elementAdapter[this]
  
  proc utilGetAdapter(this: pointer): pointer =
    getOrDefault(elementAdapter, this, nil)

  proc utilInsertAdapter(
      parent, child: pointer, adapterProcs: AdapterProcs): pointer =

    let
      adapter   = utilGetOrNewAdapter(child, adapterProcs.ini)
      oldParent = adapterProcs.get(child)
      
    # Case 1, child has no parent: Add adaptor    
    if oldParent == nil:
      adapterProcs.add(adapter, child)
      if parent != nil: adapterProcs.add(parent, adapter)

    # Case 2.1, child has parent, but is adapter
    elif oldParent == adapter:
      # Case 2.1.1: new parent
      if parent != nil: adapterProcs.add(parent, adapter)

    # Case 2.2, child has parent, insert adaptor
    else:
      adapterProcs.bef(child)
      adapterProcs.rem(oldParent, child)
      adapterProcs.add(adapter, child)
      if parent != nil: adapterProcs.add(parent, adapter)

    return adapter
  
  proc utilInsertAdapter(child: pointer, procs: AdapterProcs): pointer =
    utilInsertAdapter(nil, child, procs)
    
  proc utilTryAddChild(parent, child: pointer, procs: AdapterProcs): bool =
    if child notin elementAdapter: return
    discard utilInsertAdapter(parent, child, procs)
    return true
      
  proc utilDelAdapter(child: pointer, adapters: AdapterProcs): bool =
    # TODO: Be able to remove specific adapters
    var adapter = adapters.get(child)
    if adapter == nil: return

    adapters.rem(adapter, child)

    while true:
      var found = false
      for v in values(elementAdapter):
        if v != adapter: continue
        del(elementAdapter, adapter)
        let child = adapter
        adapter = adapters.get(child)
        adapters.rem(adapter, child)
        found = true
        break
      
      if not found: break
      
    return true
      
  template genAdapters(gB, rB, aB: untyped): AdapterProcs {.dirty.} =
    block:
      var procs: AdapterProcs
      procs.ini = InitAdapterProc(proc(): pointer = raiseAssert("Never ever"))
      procs.bef = BefReinsertProc(proc(c: pointer) = raiseAssert("Never ever"))
      procs.get = GetParentProc(proc(c: pointer): pointer = gB)
      procs.rem = RemChildProc(proc(p, c: pointer) = rB)
      procs.add = AddChildProc(proc(p, c: pointer) = aB)
      procs
  
  template genAdaptersFrom(base: AdapterProcs, iB, bB: untyped): AdapterProcs {.dirty.} =
    block:
      var procs: AdapterProcs
      procs.ini = InitAdapterProc(proc(): pointer = iB)
      procs.bef = BefReinsertProc(proc(c: pointer) = bB)
      procs.get = GetParentProc(proc(c: pointer): pointer = base.get(c))
      procs.rem = RemChildProc(proc(p, c: pointer) = base.rem(p, c))
      procs.add = AddChildProc(proc(p, c: pointer) = base.add(p, c))
      procs
