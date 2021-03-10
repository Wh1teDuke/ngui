
import private/niup/[niup, niupext]


includeUtils ELEMENT, CONTAINER, EVENT, TIMER, ADAPTER

const LAX_ERROR = true  
template bInfo(str: string) =
  echo("[NGUI_INFO] " & str & " NOT IMPLEMENTED")
template bError(str: string) =
  raiseAssert("[NGUI_ERROR] " & str & " NOT IMPLEMENTED")


# BASE ------------------------------------------
var
  iupRadioParent: STable[NElement, PIHandle]
  iupMenuSub:     STable[Menu, PIHandle]

template handle(this: NElement): PIHandle = this.data(PIHandle)


proc nextID: NID =
  var pool {.global.}: NID = 100_000
  result = pool
  inc(pool)
  doAssert pool != 0, "Error: Too many NElements"
  
proc invokeBeelzebubSet[T](this: PIHandle, p: string, v: T) =
  when T is string:
    let r = p in [IUP_VALUE, IUP_TITLE]
    SetAttribute(this, p, (if r: replace(v, "&", "&&") else: v))
  elif T is bool:
    SetAttribute(this, p, ["NO", "YES"][int(v)])
    #if p == IUP_VISIBLE and v: Show(this)
  elif T is NOrientation:
    SetAttribute(this, p, ["HORIZONTAL", "VERTICAL"][int(v)])
  elif T is NAmount:
    SetAttribute(this, p, ["NO", "NO", "NO", "YES"][int(v)])    
  elif T is int:
    SetAttribute(this, p, $v)
  else:
    {.fatal: "Invalid type".}

proc invokeBeelzebubGet[T](this: PIHandle, p: string, result: var T) =
  when T is string:
    result = $GetAttribute(this, p)
  elif T is bool:
    result = GetBool(this, p)
  elif T is NOrientation:  
    result =
      if GetAttribute(this, p) == "VERTICAL": noVERTICAL else: noHORIZONTAL
  elif T is NAmount:
    result =
      if GetAttribute(this, p) == "YES": naMultiple else: naNone
  elif T is int:
    result = parseInt($GetAttribute(this, p))
  elif T is (int, int):
    let
      posStr = $GetAttribute(this, p)
      m      = find(posStr, ',')
      
    result = (parseInt(posStr[0..<m]), parseInt(posStr[m+1..^1]))
    
  else:
    {.fatal: "Invalid type".}

proc invokeBeelzebubGet[T](this: NElement, p: string, result: var T) =
  invokeBeelzebubGet(this.handle, p, result)

proc invokeBeelzebubGet[T](this: PIHandle, p: string): T =
  invokeBeelzebubGet(this, p, result)
  
proc invokeBeelzebubGet[T](this: NElement, p: string): T =
  invokeBeelzebubGet(this.handle, p, result)

proc invokeBeelzebubSet[T](this: NElement, p: string, v: T) =
  invokeBeelzebubSet(this.handle, p, v)

proc listAdd(this: NElement, that: string) =
  # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuplist.html#Attributes
  let prop =
    if init: "APPENDITEM"
    else: $(parseInt($GetAttribute(this.handle, "COUNT")) + 1)

  SetAttribute(this.handle, prop, that)
  # TODO: Image

proc listSet(this: NElement, that: string, i: int) =
  # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuplist.html#Attributes
  SetAttribute(this.handle, $i, that)


# EVENT -----------------------------------------
var iupCurrentEvent: NEventArgs

proc triggerEvent(source: PIHandle, event: NElementEvent): int =
  iupCurrentEvent.element = utilElement(source)  
  if not utilTrigger(event, cast[pointer](source)):
    raiseAssert("Event CallBack not found: " & $(event))
  reset(iupCurrentEvent)
  return # TODO: Check stop propagation value

proc iupGetKeys(c: int): NKey # FD

proc internalSetEvent(this: NElement, event: NElementEvent, action: NEventProc) = 
  proc cbKeyPress(this: PIHandle, c: int): int =
    iupCurrentEvent = NEventArgs(kind: neKeyPress, key: iupGetKeys(c))
    return triggerEvent(this, neKeyPress)
    
  proc cbClick(this: PIHandle): int =
    iupCurrentEvent = NEventArgs(kind: neClick)
    return triggerEvent(this, neClick)
  
  proc cbChange(this: PIHandle): int =
    iupCurrentEvent = NEventArgs(kind: neChange)
    return triggerEvent(this, neChange)
  
  proc cbRadioClick(this: PIHandle, state: int): int =
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuptoggle.html#Callbacks
    if state != 1: return
    iupCurrentEvent = NEventArgs(kind: neClick)
    return triggerEvent(this, neClick)
    
  proc cbListChange(this: PIHandle, text: cstring, i, state: int): int =
    if iupCurrentEvent.kind == neNone:
      iupCurrentEvent = NEventArgs(kind: neChange, index: i - 1)
    else:
      iupCurrentEvent.selected = i - 1
    return triggerEvent(this, neChange)
    
  proc cbListClick(this: PIHandle, text: cstring, i, state: int): int =
    if state != 1: return
    return cbListChange(this, text, i, state)
  
  proc cbTextChange(this: PIHandle, c: int, text: cstring): int =
    iupCurrentEvent = NEventArgs(kind: neChange)
    return triggerEvent(this, neChange)
  
  proc cbTextEnter(this: PIHandle, c: int): int =
    if c == K_CR:
      iupCurrentEvent = NEventArgs(kind: neEnter)
      return triggerEvent(this, neEnter)
  
  proc cbCheckboxChange(this: PIHandle, s: int): int =
    iupCurrentEvent = NEventArgs(kind: neChange)
    return triggerEvent(this, neChange)
  
  proc cbMenuOpen(this: PIHandle) =
    iupCurrentEvent = NEventArgs(kind: neOpen)
    discard triggerEvent(this, neOpen)

  var
    cb:   ICallback = nil
    name: string    = ""

  template setCB(this) = cb = cast[ICallBack](this)

  case event:
  of neKeyPress:
    name = IUP_K_ANY
    setCB(cbKeyPress)
    
  of neChange:
    name = IUP_ACTION

    if this of List:       setCB(cbListChange)
    elif this of ComboBox: setCB(cbListClick)
    elif this of Entry:    setCB(cbTextChange)
    elif this of CheckBox: setCB(cbCheckboxChange)
    elif this of Calendar:
      name = "VALUECHANGED_CB"
      setCB(cbChange)
  
  of neClick:
    name = IUP_ACTION
    if this of Radio:  setCB(cbRadioClick)
    elif this of List: setCB(cbListClick)
    else:              setCB(cbClick)
    
  of neEnter:
    name = IUP_K_ANY
    setCB(cbTextEnter)
  
  of neOpen:
    name = IUP_OPEN_CB
    setCB(cbMenuOpen)

  else:
    discard

  doAssert cb != nil and name != "", $(cb, name, event, this)

  utilSet(event, this.handle, action)
  SetCallBack(this.handle, name, cb)

proc internalGetCurrentEvent: NEventArgs = iupCurrentEvent

proc internalEventHandled() =
  ## Stop event propagation
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalEventHandled()")
  else: bError("proc internalEventHandled()")


# NElement ----------------------------------------
proc internalNewNElement(kind: NElementKind): NElement =
  # TODO: Pass instantiated elment
  doAssert kind != neKindInvalid
  
  result    = newElement(kind)
  result.id = nextID()

  case kind:
  of neAPP:
    niupext.Open()
    return
  
  of neWindow:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/dlg/iupdialog.html
    result.data = niup.Dialog(nil)
  
  of neButton:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iupbutton.html
    result.data = niup.Button("", "")
    
  of neBox:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iupgridbox.html
    result.data = niup.GridBox(nil)
    invokeBeelzebubSet(result, IUP_ORIENTATION, noVERTICAL)
    invokeBeelzebubSet(result, "EXPANDCHILDREN", true)
    invokeBeelzebubSet(result, "NUMDIV", 100) # HACK
    
  of neList:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuplist.html
    result.data = niup.List(nil)
  
  of neBar:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iupmenu.html
    result.data = niup.Menu(nil)
  
  of neMenu:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iupmenu.html
    result.data = niup.Menu(nil)
  
  of neComboBox:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuplist.html
    result.data = niup.List(nil)
    invokeBeelzebubSet(result, IUP_DROPDOWN, true)
    
  of neCheckBox:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuptoggle.html
    result.data = niup.Toggle(nil, nil)

  of neRadio:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iupradio.html
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuptoggle.html
    # https://webserver2.tecgraf.puc-rio.br/iup/examples/C/radio.c
    result.data = niup.Toggle(nil, nil)
    
  of neLabel:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuplabel.html
    result.data = niup.Label("")
  
  of neEntry:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/elem/iuptext.html
    result.data = niup.Text("")
    
  of neCalendar:
    # https://www.tecgraf.puc-rio.br/iup/en/elem/iupcalendar.html
    result.data = niup.Calendar()
  
  of neAlert:
    # https://webserver2.tecgraf.puc-rio.br/iup/en/dlg/iupmessagedlg.html
    result.data = niup.MessageDlg()
  
  else:
    discard

  doAssert result.raw != nil, $kind
  # TODO: On Destroy, clean data

proc internalGetDestroy(this: NElement): bool = not utilExists(this)

proc internalGetParent(this: NElement): Container = utilParent(this)

proc internalSetVisible(this: NElement, state: bool) =
  invokeBeelzebubSet(this, IUP_VISIBLE, true)
  if state and this of Window: Show(this.handle)

proc internalGetVisible(this: NElement): bool =
  invokeBeelzebubGet(this, IUP_VISIBLE, result)

proc internalGetNext(this: NElement): NElement =
  ## Get the parent's next child after this one or nil
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetNext(this: NElement): NElement")
  else: bError("proc internalGetNext(this: NElement): NElement")

proc internalGetPrev(this: NElement): NElement =
  ## Get the parent's previous child before this one or nil
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetPrev(this: NElement): NElement")
  else: bError("proc internalGetPrev(this: NElement): NElement")

proc internalGetFocus(this: NElement): bool =
  ## Get whether the element has the focus or not
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetFocus(this: NElement): bool")
  else: bError("proc internalGetFocus(this: NElement): bool")

proc internalSetFocus(this: NElement) =
  ## Set the focus on this element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetFocus(this: NElement)")
  else: bError("proc internalSetFocus(this: NElement)")

proc internalGetSize(this: NElement): tuple[w, h: int] =
  ## Get the size of this element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetSize(this: NElement): tuple[w, h: int]")
  else: bError("proc internalGetSize(this: NElement): tuple[w, h: int]")

proc internalSetSize(this: NElement, size: tuple[w, h: int]) =
  ## Set the size of this element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetSize(this: NElement, size: tuple[w, h: int])")
  else: bError("proc internalSetSize(this: NElement, size: tuple[w, h: int])")

proc internalSetTooltip(this: NElement, text: string) =
  invokeBeelzebubSet(this, IUP_TIP, text)

proc internalGetTooltip(this: NElement): string =
  invokeBeelzebubGet(this, IUP_TIP, result)

proc internalSetDestroy(this: NElement) = Destroy(this.handle)

proc internalGetBGColor(this: NElement): Pixel =
  ## Get the background color of this element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetBGColor(this: NElement): Pixel")
  else: bError("proc internalGetBGColor(this: NElement): Pixel")

proc internalSetBGColor(this: NElement, color: Pixel) =
  ## Set the background color of this element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetBGColor(this: NElement, color: Pixel)")
  else: bError("proc internalSetBGColor(this: NElement, color: Pixel)")


# CONTAINER -------------------------------------
proc internalIndex(this: Container, that: NElement): int =
  utilChildIndex(this, that)

proc internalGetChild(this: Container, index: int): NElement =
  utilNChild(this, index)

proc internalLen(this: Container): int = utilLen(this)

proc internalRemove(this: Container, that: NElement) =
  ## Remove element from this container. Element MUST be a child
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalRemove(this: Container, that: NElement)")
  else: bError("proc internalRemove(this: Container, that: NElement)")

proc handleMenuBarAdd(this, that: NElement) # FD

proc internalAdd(this: Container, that: NElement) =
  if this of App:
    utilChild(this, that)
    return
  
  ## TOOLS
  ## Again, create an adapter
  #if this of Tools:
    #handleToolsAdd(Tools(this), that)
    #return

  # echo "DEBUG ", (this.kind, that.kind)
  ## MENU/BAR
  if (this of Menu or this of Bar) or (that of Menu):
    handleMenuBarAdd(this, that)
    return

  utilChild(this, that)
  let (thisD, thatD) = (this.handle, that.handle)
  
  if that of Bar:
    # Can only be added to Dialog
    let name = "iup_main_menu" & $rand(100_000)
    niup.SetHandle(name, thatD)

    var p: Container = this
    while p != nil and not (p of Window):
      p = utilParent(p)
      
    if p != nil:
      invokeBeelzebubSet(p.handle, IUP_MENU, name)

    else:
      discard # TODO: Set callback on run to append menu
    
    return
  
  elif that of Radio:
    # TODO: Create new group if radio not in table
    # TODO: Regroup
    let radioParent = iupRadioParent[that]
    if niup.GetParent(radioParent) == nil:
      doAssert thisD.Append(radioParent) == thisD
  
  #if not utilTryAddChild(thisD, thatD, adapters):
    #thisD.add(thatD)
    
  elif this of List:
    if that of Label:
      listAdd(this, Label(that).internalGetText)
    else:
      discard # TODO IMAGE
    return
    
  else:
    doAssert thisD.Append(thatD) == thisD

  niup.Map(thatD)
  niup.Refresh(thisD)

proc internalReplace(container: Container, this, that: NElement) =
  ## Replace child with another element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalReplace(container: Container, this, that: NElement)")
  else: bError("proc internalReplace(container: Container, this, that: NElement)")

proc internalGetBorder(this: Container): int =
  ## Get the border size of this container
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetBorder(this: Container): int")
  else: bError("proc internalGetBorder(this: Container): int")

proc internalSetBorder(this: Container, b: int) =
  ## Set the border size of this container
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetBorder(this: Container, b: int)")
  else: bError("proc internalSetBorder(this: Container, b: int)")

proc internalAddSeparator(this: Container, dir: NOrientation) =
  if this of Menu or this of Bar:
    discard this.handle.Append(niup.Separator())

proc internalGetBorderColor(this: Container): Pixel =
  ## Get the color of this container's border
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetBorderColor(this: Container): Pixel")
  else: bError("proc internalGetBorderColor(this: Container): Pixel")

proc internalSetBorderColor(this: Container, color: Pixel) =
  ## Set the color of this container's border
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetBorderColor(this: Container, color: Pixel)")
  else: bError("proc internalSetBorderColor(this: Container, color: Pixel)")


# APP -------------------------------------------
proc internalRun(this: App) =
  niup.MainLoop()

proc internalStop(this: App) =
  ## Shutdown the App context
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalStop(this: App)")
  else: bError("proc internalStop(this: App)")


# WINDOW ----------------------------------------
proc internalSetText(this: Window, text: string) =
  invokeBeelzebubSet(this, IUP_TITLE, text)

proc internalGetText(this: Window): string =
  invokeBeelzebubGet(this, IUP_TITLE, result)

proc internalSetResizable(this: Window, state: bool) =
  invokeBeelzebubSet(this, IUP_RESIZE, state)

proc internalGetResizable(this: Window): bool =
  invokeBeelzebubGet(this, IUP_RESIZE, result)

proc internalSetPosition(this: Window, position: tuple[x, y: int]) =
  niup.ShowXY(this.handle, position.x.cint, position.y.cint)

proc internalGetPosition(this: Window): tuple[x, y: int] =
  invokeBeelzebubGet(this, "SCREENPOSITION", result)

proc internalGetFocused(this: Window): NElement =
  ## Get the element within this window that has the focus
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetFocused(this: Window): NElement")
  else: bError("proc internalGetFocused(this: Window): NElement")

proc internalGetIcon(this: Window): Bitmap =
  ## Get the icon that this window is displaying or nil
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetIcon(this: Window): Bitmap")
  else: bError("proc internalGetIcon(this: Window): Bitmap")

proc internalSetIcon(this: Window, that: Bitmap) =
  ## Set the icon for this window
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetIcon(this: Window, that: Bitmap)")
  else: bError("proc internalSetIcon(this: Window, that: Bitmap)")

proc internalGetDecorated(this: Window): bool =
  ## Get whether or not this window is displaying the border
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetDecorated(this: Window): bool")
  else: bError("proc internalGetDecorated(this: Window): bool")

proc internalSetDecorated(this: Window, v: bool) =
  ## Set whether or not this window is displaying the border
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetDecorated(this: Window, v: bool)")
  else: bError("proc internalSetDecorated(this: Window, v: bool)")

proc internalSetMinimized(this: Window, v: bool) =
  ## Set whether or not this window is minimized
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetMinimized(this: Window, v: bool)")
  else: bError("proc internalSetMinimized(this: Window, v: bool)")

proc internalGetMinimized(this: Window): bool =
  invokeBeelzebubGet(this, "MINIMIZED", result)

proc internalSetMaximized(this: Window, v: bool) =
  ## Set whether or not this window is maximized
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetMaximized(this: Window, v: bool)")
  else: bError("proc internalSetMaximized(this: Window, v: bool)")

proc internalGetMaximized(this: Window): bool =
  invokeBeelzebubGet(this, "MAXIMIZED", result)

proc internalSetModal(this: Window, v: bool) =
  ## Set whether or not user can interact with other windows
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetModal(this: Window, v: bool)")
  else: bError("proc internalSetModal(this: Window, v: bool)")

proc internalGetModal(this: Window): bool =
  ## Get whether or not user can interact with other windows
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetModal(this: Window): bool")
  else: bError("proc internalGetModal(this: Window): bool")

proc internalSetTransient(this, that: Window) =
  if this notin tags: tags[this] = initTable[string, string]()
  
  let name = "iup_parent_name" & $rand(100_000)
  tags[this]["iup_parent_name"] = name
  niup.SetHandle(name, that.handle)
  invokeBeelzebubSet(this, IUP_PARENTDIALOG, name)

proc internalGetTransient(this: Window): Window =
  let parent = invokeBeelzebubGet[string](this, IUP_PARENTDIALOG)
  if parent == "": return

  for element, tagTable in tags:
    for key, value in tagTable:
      if value == parent:
        return Window(element)

proc internalGetOpacity(this: Window): float =
  # https://webserver2.tecgraf.puc-rio.br/iup/en/dlg/iupdialog.html#Attributes
  return float(invokeBeelzebubGet[int](this, "OPACITY")) / 255

proc internalSetOpacity(this: Window, v: float) =
  invokeBeelzebubSet(this, "OPACITY", int(v * 255))


# ALERT -----------------------------------------
proc internalRun(this: Alert) =
  niup.Popup(this.handle, IUP_CURRENT, IUP_CURRENT)

proc internalSetModal(this: Alert, v: bool) = discard

proc internalGetModal(this: Alert): bool = internalGetTransient(this) != nil

proc internalSetTransient(this: Alert, that: Window) =
  if this notin tags: tags[this] = initTable[string, string]()
  
  let name = "iup_parent_name" & $rand(100_000)
  tags[this]["iup_parent_name"] = name
  niup.SetHandle(name, that.handle)
  invokeBeelzebubSet(this, IUP_PARENTDIALOG, name)

proc internalGetTransient(this: Alert): Window =
  let parent = invokeBeelzebubGet[string](this, IUP_PARENTDIALOG)
  if parent == "": return

  for element, tagTable in tags:
    for key, value in tagTable:
      if value == parent:
        return Window(element)

proc internalSetText(this: Alert, text: string) =
  invokeBeelzebubSet(this, IUP_VALUE, text)

proc internalGetText(this: Alert): string =
  invokeBeelzebubGet(this, IUP_VALUE, result)

proc internalSetTitle(this: Alert, text: string) =
  invokeBeelzebubSet(this, IUP_TITLE, text)

proc internalGetTitle(this: Alert): string =
  invokeBeelzebubGet(this, IUP_TITLE, result)


# LABEL -----------------------------------------
proc internalSetText(this: Label, text: string) =
  invokeBeelzebubSet(this, IUP_TITLE, text)

proc internalGetText(this: Label): string =
  invokeBeelzebubGet(this, IUP_TITLE, result)

proc internalSetWrap(this: Label, state: bool) =
  invokeBeelzebubSet(this, "WORDWRAP", state)

proc internalGetWrap(this: Label): bool =
  invokeBeelzebubGet(this, "WORDWRAP", result)

proc internalGetXAlign(this: Label): float =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetXAlign(this: Label): float")
  else: bError("proc internalGetXAlign(this: Label): float")

proc internalGetYAlign(this: Label): float =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetYAlign(this: Label): float")
  else: bError("proc internalGetYAlign(this: Label): float")

proc internalSetXAlign(this: Label, v: float) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetXAlign(this: Label, v: float)")
  else: bError("proc internalSetXAlign(this: Label, v: float)")

proc internalSetYAlign(this: Label, v: float) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetYAlign(this: Label, v: float)")
  else: bError("proc internalSetYAlign(this: Label, v: float)")


# ENTRY -----------------------------------------
proc internalGetText(this: Entry): string =
  invokeBeelzebubGet(this, IUP_VALUE, result)

proc internalSetText(this: Entry, text: string) =
  invokeBeelzebubSet(this, IUP_VALUE, text)


# CHECKBOX --------------------------------------
proc internalSetText(this: Checkbox, that: string) =
  invokeBeelzebubSet(this, IUP_TITLE, that)

proc internalGetText(this: Checkbox): string =
  invokeBeelzebubGet(this, IUP_TITLE, result)

proc internalGetChecked(this: Checkbox): bool =
  GetAttribute(this.handle, IUP_VALUE) == "ON"

proc internalSetChecked(this: Checkbox, v: bool) =
  SetAttribute(this.handle, IUP_VALUE, ["OFF", "ON"][int(v)])


# BUTTON ----------------------------------------
proc internalSetText(this: Button, text: string) =
  invokeBeelzebubSet(this, IUP_TITLE, text)

proc internalGetText(this: Button): string =
  invokeBeelzebubGet(this, IUP_TITLE, result)

proc internalSetImage(this: Button, img: Bitmap) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetImage(this: Button, img: Bitmap)")
  else: bError("proc internalSetImage(this: Button, img: Bitmap)")

proc internalGetImage(this: Button): Bitmap =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetImage(this: Button): Bitmap")
  else: bError("proc internalGetImage(this: Button): Bitmap")


# RADIO -----------------------------------------
proc internalSetText(this: Radio, text: string) =
  invokeBeelzebubSet(this, IUP_TITLE, text)

proc internalGetText(this: Radio): string =
  invokeBeelzebubGet(this, IUP_TITLE, result)

proc internalSetGroup(radios: openArray[Radio]) =
  # https://webserver2.tecgraf.puc-rio.br/iup/examples/C/radio.c
  
  let
    box   = niup.VBox(nil)
    radio = niup.Radio(box)
  
  for r in radios:
    iupRadioParent[r] = radio
    discard box.Append(r.handle)


# BUBBLE ----------------------------------------
proc internalAttach(this: Bubble, that: NElement) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAttach(this: Bubble, that: NElement)")
  else: bError("proc internalAttach(this: Bubble, that: NElement)")


# IMAGE -----------------------------------------
proc internalNewBitmap(file: string): Bitmap =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewBitmap(file: string): Bitmap")
  else: bError("proc internalNewBitmap(file: string): Bitmap")

proc internalGetBitmap(this: Image): Bitmap =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetBitmap(this: Image): Bitmap")
  else: bError("proc internalGetBitmap(this: Image): Bitmap")

proc internalUpdate(this: Image, that: Bitmap) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalUpdate(this: Image, that: Bitmap)")
  else: bError("proc internalUpdate(this: Image, that: Bitmap)")

proc internalCopy(this: Bitmap): Bitmap =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalCopy(this: Bitmap): Bitmap")
  else: bError("proc internalCopy(this: Bitmap): Bitmap")

proc internalSave(this: Bitmap, path, format: string): bool =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSave(this: Bitmap, path, format: string): bool")
  else: bError("proc internalSave(this: Bitmap, path, format: string): bool")

proc internalIconBitmap(name: string): Bitmap =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalIconBitmap(name: string): Bitmap")
  else: bError("proc internalIconBitmap(name: string): Bitmap")

proc internalIconBitmap(icon: NIcon): Bitmap =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalIconBitmap(icon: NIcon): Bitmap")
  else: bError("proc internalIconBitmap(icon: NIcon): Bitmap")


# TEXTAREA --------------------------------------
proc internalSetText(this: TextArea, text: string) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: TextArea, text: string)")
  else: bError("proc internalSetText(this: TextArea, text: string)")

proc internalGetText(this: TextArea): string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: TextArea): string")
  else: bError("proc internalGetText(this: TextArea): string")


# CALENDAR --------------------------------------
proc internalGetDate(this: Calendar): DateTime  =
  parse(invokeBeelzebubGet[string](this, IUP_VALUE), "yyyy/M/d")

proc internalSetDate(this: Calendar, date: DateTime) =
  invokeBeelzebubSet(this, IUP_VALUE, format(date, "yyyy/M/d"))

proc internalMark(this: Calendar, day: int)  {.notSupported.}

proc internalUnmark(this: Calendar, day: int)  {.notSupported.}

proc internalMarked(this: Calendar, day: int): bool  {.notSupported.}

proc internalClear(this: Calendar) {.notSupported.}


# SLIDER ----------------------------------------
proc internalSetDecimals(this: Slider, decimals: int) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetDecimals(this: Slider, decimals: int)")
  else: bError("proc internalSetDecimals(this: Slider, decimals: int)")

proc internalGetDecimals(this: Slider): int =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetDecimals(this: Slider): int")
  else: bError("proc internalGetDecimals(this: Slider): int")

proc internalSetRange(this: Slider, range: Slice[float]) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetRange(this: Slider, range: Slice[float])")
  else: bError("proc internalSetRange(this: Slider, range: Slice[float])")

proc internalSetStep(this: Slider, step: float) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetStep(this: Slider, step: float)")
  else: bError("proc internalSetStep(this: Slider, step: float)")

proc internalGetValue(this: Slider): float =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetValue(this: Slider): float")
  else: bError("proc internalGetValue(this: Slider): float")

proc internalSetValue(this: Slider, value: float) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetValue(this: Slider, value: float)")
  else: bError("proc internalSetValue(this: Slider, value: float)")

proc internalGetOrientation(this: Slider): NOrientation =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetOrientation(this: Slider): NOrientation")
  else: bError("proc internalGetOrientation(this: Slider): NOrientation")

proc internalSetOrientation(this: Slider, value: NOrientation) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetOrientation(this: Slider, value: NOrientation)")
  else: bError("proc internalSetOrientation(this: Slider, value: NOrientation)")


# FILECHOOSE ------------------------------------
proc internalSetMultiple(this: FileChoose, state: bool) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetMultiple(this: FileChoose, state: bool)")
  else: bError("proc internalSetMultiple(this: FileChoose, state: bool)")

proc internalGetMultiple(this: FileChoose): bool =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetMultiple(this: FileChoose): bool")
  else: bError("proc internalGetMultiple(this: FileChoose): bool")

proc internalGetFiles(this: FileChoose): seq[string] =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetFiles(this: FileChoose): seq[string]")
  else: bError("proc internalGetFiles(this: FileChoose): seq[string]")

proc internalSetText(this: FileChoose, text: string) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: FileChoose, text: string)")
  else: bError("proc internalSetText(this: FileChoose, text: string)")

proc internalGetText(this: FileChoose): string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: FileChoose): string")
  else: bError("proc internalGetText(this: FileChoose): string")

proc internalSetButton(this: FileChoose, button: string, index: int) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetButton(this: FileChoose, button: string, index: int)")
  else: bError("proc internalSetButton(this: FileChoose, button: string, index: int)")

proc internalRun(this: FileChoose): int =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalRun(this: FileChoose): int")
  else: bError("proc internalRun(this: FileChoose): int")


# BAR/MENU --------------------------------------
proc labelToSubmenu(this: Label, menu: Menu): (bool, PIHandle) =  
  let h = this.handle
  if GetClassName(h) == "submenu":
    if menu == nil: return (true, h)

    let submenu = niup.Submenu(
      invokeBeelzebubGet[string](h, IUP_TITLE), menu.handle)
    iupMenuSub[menu] = submenu
    niup.Destroy(h)
    
    return (true, submenu)
  
  let submenu = niup.Submenu(internalGetText(Label(this)), menu.handle)
  if menu != nil: iupMenuSub[menu] = submenu
  this.data = submenu
  result = (menu != nil, submenu)
  
  # Problem: we may have already created an Item control for this
  # We need to find our father and update the value
  if GetClassName(h) == "item":
    let parent = GetParent(h)
    doAssert niup.Insert(parent, h, submenu) == parent
    niup.Detach(h)

  #niup.Destroy(h)

proc handleMenuBarAdd(this, that: NElement) =  
  let
    (thisD, thatD) = (this.handle, that.handle)
    #(thisC, thatC) = (GetClassName(thisD), GetClassName(thatD))

  # Label -> Item
  if this of Menu and that of Label:
    let item = niup.Item(internalGetText(Label(that)), nil)
    # niup.Destroy(that.handle)
    that.data = item
    utilChild(Container(this), that)
    doAssert thisD.Append(item) == thisD
    niup.Map(item)
    niup.Refresh(thisD)

  # Bar -> Submenu
  if this of Bar and that of Label:
    let (_, submenu) = labelToSubmenu(Label(that), nil)
    utilChild(Container(this), that)
    doAssert thisD.Append(submenu) == thisD
    niup.Map(submenu)
    niup.Refresh(thisD)
    return

proc internalAdd(this: NElement, that: Menu) =
  if this of Label:
    # TODO: What if 'this' is Image
    discard labelToSubmenu(Label(this), that)


# TABLE -----------------------------------------
proc internalAdd(this: Table, that: NTableRow) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: Table, that: NTableRow)")
  else: bError("proc internalAdd(this: Table, that: NTableRow)")

proc internalSet(this: Table, that: NTableCell, x, y: int) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSet(this: Table, that: NTableCell, x, y: int)")
  else: bError("proc internalSet(this: Table, that: NTableCell, x, y: int)")

proc internalGet(this: Table, x, y: int): NTableCell =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGet(this: Table, x, y: int): NTableCell")
  else: bError("proc internalGet(this: Table, x, y: int): NTableCell")

proc internalHeader(this: NTable, headers: openArray[string]) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalHeader(this: NTable, headers: openArray[string])")
  else: bError("proc internalHeader(this: NTable, headers: openArray[string])")

proc internalHeaders(this: NTable): bool =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalHeaders(this: NTable): bool")
  else: bError("proc internalHeaders(this: NTable): bool")

proc internalHeaders(this: NTable, v: bool) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalHeaders(this: NTable, v: bool)")
  else: bError("proc internalHeaders(this: NTable, v: bool)")


# COMBOBOX -------------------------------------- 
proc internalAdd(this: ComboBox, text: string)  =
  listAdd(this, text)

proc internalSet(this: ComboBox, text: string, i: int) =
  listSet(this, text, i + 1)

proc internalGet(this: ComboBox, i: int): string =
  $GetAttribute(this.handle, "VALUESTRING")

proc internalGetSelected(this: ComboBox): string  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetSelected(this: ComboBox): string ")
  else: bError("proc internalGetSelected(this: ComboBox): string ")

proc internalGetSelectedIndex(this: ComboBox): int  =
  invokeBeelzebubGet[int](this, IUP_VALUE) - 1

proc internalSetSelectedIndex(this: ComboBox, i: int) =
  invokeBeelzebubSet(this, IUP_VALUE, $(i + 1))


# PROGRESS --------------------------------------
proc internalValue(this: Progress): float  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalValue(this: Progress): float ")
  else: bError("proc internalValue(this: Progress): float ")

proc internalValue(this: Progress, v: float) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalValue(this: Progress, v: float)")
  else: bError("proc internalValue(this: Progress, v: float)")


# BOX ------------------------------------------- 
proc internalSetSpacing(this: Box, spacing: int)  =
  invokeBeelzebubSet(this, IUP_GAP, spacing)

proc internalGetOrientation(this: Box): NOrientation =
  invokeBeelzebubGet(this, IUP_ORIENTATION, result)

proc internalSetOrientation(this: Box, value: NOrientation) =
  invokeBeelzebubSet(this, IUP_ORIENTATION, value)


# GRID ------------------------------------------
proc internalAdd(this: Grid, that: NElement, r, c, w, h: int)  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: Grid, that: NElement, r, c, w, h: int) ")
  else: bError("proc internalAdd(this: Grid, that: NElement, r, c, w, h: int) ")


# TAB -------------------------------------------
proc internalAdd(this: Tab, that: Container, label: Label) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: Tab, that: Container, label: Label)")
  else: bError("proc internalAdd(this: Tab, that: Container, label: Label)")

proc internalSetReorderable(this: Tab, v: bool) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetReorderable(this: Tab, v: bool)")
  else: bError("proc internalSetReorderable(this: Tab, v: bool)")

proc internalGetReorderable(this: Tab): bool =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetReorderable(this: Tab): bool")
  else: bError("proc internalGetReorderable(this: Tab): bool")

proc internalGetSide(this: Tab): NSide =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetSide(this: Tab): NSide")
  else: bError("proc internalGetSide(this: Tab): NSide")

proc internalSetSide(this: Tab, side: NSide) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetSide(this: Tab, side: NSide)")
  else: bError("proc internalSetSide(this: Tab, side: NSide)")


# LIST ------------------------------------------
proc internalGetMode(this: List): NAmount =
  invokeBeelzebubGet(this, "MULTIPLE", result)

proc internalSetMode(this: List, mode: NAmount) =
  invokeBeelzebubSet(this, "MULTIPLE", mode)

proc internalSelected(this: List, that: var seq[NElement]) =
  case internalGetMode(this):
  of naMultiple:
    discard # TODO
    
  else:
    let i = parseInt($GetAttribute(this.handle, "VALUE"))
    if i != 0: add(that, internalGetChild(this, i - 1))


# FRAME -----------------------------------------
proc internalSetText(this: Frame, text: string) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Frame, text: string)")
  else: bError("proc internalSetText(this: Frame, text: string)")

proc internalGetText(this: Frame): string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: Frame): string")
  else: bError("proc internalGetText(this: Frame): string")


# TOOLS -----------------------------------------
proc internalGetOrientation(this: Tools): NOrientation =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetOrientation(this: Tools): NOrientation")
  else: bError("proc internalGetOrientation(this: Tools): NOrientation")

proc internalSetOrientation(this: Tools, value: NOrientation) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetOrientation(this: Tools, value: NOrientation)")
  else: bError("proc internalSetOrientation(this: Tools, value: NOrientation)")


# TIMERS -----------------------------------------
var iupHandles: seq[(NRepeatHandle, PIHandle, NRepeatProc)]

proc onTimeOut(this: PIHandle): int =
  var i = -1
  for n, (_, h, _) in iupHandles:
    if h != this: continue
    i = n
    break
    
  if i != -1:
    if not iupHandles[i][2](): internalStop(iupHandles[i][0])

proc internalRepeat(event: NRepeatProc, ms: int): NRepeatHandle =
  let t = Timer()
  SetCallBack(t, "ACTION_CB", cast[ICallBack](onTimeOut))
  invokeBeelzebubSet(t, IUP_TIME, $ms)
  invokeBeelzebubSet(t, IUP_RUN, true)
  add(iupHandles, (cast[NRepeatHandle](t), t, event))
  return iupHandles[^1][0]

proc internalStop(this: NRepeatHandle) =
  for i, (r, h, _) in iupHandles:
    if r != this: continue
    Destroy(h)
    delete(iupHandles, i)
    break

proc internalSetTime(this: var NRepeatHandle, ms: int) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetTime(this: var NRepeatHandle, ms: int)")
  else: bError("proc internalSetTime(this: var NRepeatHandle, ms: int)")



# CLIPBOARD -------------------------------------
proc internalClipboardClear() =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalClipboardClear()")
  else: bError("proc internalClipboardClear()")

proc internalClipboardSet(text: string) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalClipboardSet(text: string)")
  else: bError("proc internalClipboardSet(text: string)")

proc internalClipboardSet(img: Bitmap) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalClipboardSet(img: Bitmap)")
  else: bError("proc internalClipboardSet(img: Bitmap)")

proc internalClipboardGetText: string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalClipboardGetText: string")
  else: bError("proc internalClipboardGetText: string")

proc internalClipboardGetImg: Bitmap =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalClipboardGetImg: Bitmap")
  else: bError("proc internalClipboardGetImg: Bitmap")

proc internalClipboardAsyncGet(action: NAsyncTextProc) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalClipboardAsyncGet(action: NAsyncTextProc)")
  else: bError("proc internalClipboardAsyncGet(action: NAsyncTextProc)")

proc internalClipboardAsyncGet(action: NAsyncBitmapProc) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalClipboardAsyncGet(action: NAsyncBitmapProc)")
  else: bError("proc internalClipboardAsyncGet(action: NAsyncBitmapProc)")


# EVENTS ----------------------------------------
proc iupGetKeys(c: int): NKey =
  # https://webserver2.tecgraf.puc-rio.br/iup/en/attrib/key.html
  const
    K_A = K_lowera
    K_Z = K_lowerz
  
  case c:
  of K_ESC:        nkEsc
  of K_0 .. K_9:   NKey((c - K_0) + int(nk0))
  of K_A .. K_Z:   NKey((c - K_A) + int(nkA))
  else:            nkNone