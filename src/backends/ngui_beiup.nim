
import private/niup/[niup, niupext]


includeUtils ELEMENT, CONTAINER, EVENT, TIMER, ADAPTER

const LAX_ERROR = true  
template bInfo(str: string) =
  echo("[NGUI_INFO] " & str & " NOT IMPLEMENTED")
template bError(str: string) =
  raiseAssert("[NGUI_ERROR] " & str & " NOT IMPLEMENTED")


proc nextID: NID =
  var pool {.global.}: NID = 100_000
  result = pool
  inc(pool)
  doAssert pool != 0, "Error: Too many NElements"
  
proc invokeBeelzebubSet[T](this: NElement, p: string, v: T) =
  let thisD = this.data(PIHandle)
  when T is string:
    SetAttribute(thisD, p, v)
  elif T is bool:
    SetAttribute(thisD, p, ["NO", "YES"][int(v)])
    if p == IUP_VISIBLE and v: Show(thisD)
  else:
    {.fatal: "Invalid type".}

proc invokeBeelzebubGet[T](this: NElement, p: string, result: var T) =
  when T is string:
    result = $GetAttribute(this.data(PIHandle), p)
  elif T is bool:
    result = GetBool(this.data(PIHandle), p)
  else:
    {.fatal: "Invalid type".}


# EVENT -----------------------------------------
var iupCurrentEvent: NEventArgs

proc triggerEvent(source: PIHandle, event: NElementEvent) =
  iupCurrentEvent.element = utilElement(source)
  if not utilTrigger(event, cast[pointer](source)):
    raiseAssert("Event CallBack not found: " & $(event))
  reset(iupCurrentEvent)
  
proc iupGetKeys(c: int): NKey # FD

proc internalSetEvent(this: NElement, event: NElementEvent, action: NEventProc) = 
  proc cbKeyPress(this: PIHandle, c: int): int =
    iupCurrentEvent = NEventArgs(kind: neKeyPress, key: iupGetKeys(c))
    triggerEvent(this, neKeyPress)
  
  var
    cb:   ICallback
    name: string
  
  case event:
  of neKeyPress:
    name = IUP_K_ANY
    cb = cast[ICallback](cbKeyPress)

  else:
    discard

  doAssert cb != nil
  doAssert name != ""

  utilSet(event, this.data(PIHandle), action)
  SetCallBack(this.data(PIHandle), name, cb)

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
    result.data = niup.Dialog(nil)
  
  else:
    discard

  doAssert result.kind != neKindInvalid

proc internalGetOpacity(this: NElement): float =
  ## Get Opacity of this element (0.0 - 1.0)
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetOpacity(this: NElement): float")
  else: bError("proc internalGetOpacity(this: NElement): float")

proc internalSetOpacity(this: NElement, v: float) =
  ## Set Opacity of this element (0.0 - 1.0)
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetOpacity(this: NElement, v: float)")
  else: bError("proc internalSetOpacity(this: NElement, v: float)")

proc internalGetDestroy(this: NElement): bool = not utilExists(this)

proc internalGetParent(this: NElement): Container = utilParent(this)

proc internalSetVisible(this: NElement, state: bool) =
  invokeBeelzebubSet(this, IUP_VISIBLE, true)

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
  ## Set this element's tooltip text
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetTooltip(this: NElement, text: string)")
  else: bError("proc internalSetTooltip(this: NElement, text: string)")

proc internalGetTooltip(this: NElement): string =
  ## Get this element's tooltip text
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetTooltip(this: NElement): string")
  else: bError("proc internalGetTooltip(this: NElement): string")

proc internalSetDestroy(this: NElement) = Destroy(this.data(PIHandle))

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

proc internalAdd(this: Container, that: NElement) =
  if this of App:
    utilChild(this, that)
    return

  ## MENU/BAR
  ## (Complex stuff, we need to create MenuItems in the middle)
  #if (this of Menu or this of Bar) or (that of Menu):
    #handleMenuBarAdd(this, that)
    #return
  
  ## TOOLS
  ## Again, create an adapter
  #if this of Tools:
    #handleToolsAdd(Tools(this), that)
    #return
  
  #utilChild(this, that)
  let (thisD, thatD) = (this.data(PIHandle), that.data(PIHandle))
  
  #if not utilTryAddChild(thisD, thatD, adapters):
    #thisD.add(thatD)
  
  #thatD.show()
  discard thisD.Append(thatD)
  invokeBeelzebubSet(that, IUP_VISIBLE, true)


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
  ## Add a visual separator after the last added child
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAddSeparator(this: Container, dir: NOrientation)")
  else: bError("proc internalAddSeparator(this: Container, dir: NOrientation)")

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
  ## Set whether the user can resize the window or not
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetResizable(this: Window, state: bool)")
  else: bError("proc internalSetResizable(this: Window, state: bool)")

proc internalGetResizable(this: Window): bool =
  ## Get whether the user can resize the window or not
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetResizable(this: Window): bool")
  else: bError("proc internalGetResizable(this: Window): bool")

proc internalSetPosition(this: Window, position: tuple[x, y: int]) =
  ## Set this window's position relative to the top left of the screen
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetPosition(this: Window, position: tuple[x, y: int])")
  else: bError("proc internalSetPosition(this: Window, position: tuple[x, y: int])")

proc internalGetPosition(this: Window): tuple[x, y: int] =
  ## Get this window's position relative to the top left of the screen
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetPosition(this: Window): tuple[x, y: int]")
  else: bError("proc internalGetPosition(this: Window): tuple[x, y: int]")

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
  ## Get whether or not this window is minimized
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetMinimized(this: Window): bool")
  else: bError("proc internalGetMinimized(this: Window): bool")

proc internalSetMaximized(this: Window, v: bool) =
  ## Set whether or not this window is maximized
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetMaximized(this: Window, v: bool)")
  else: bError("proc internalSetMaximized(this: Window, v: bool)")

proc internalGetMaximized(this: Window): bool =
  ## Get whether or not this window is maximized
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetMaximized(this: Window): bool")
  else: bError("proc internalGetMaximized(this: Window): bool")

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
  ## Set a parent window. This window will appear on top of parent
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetTransient(this, that: Window)")
  else: bError("proc internalSetTransient(this, that: Window)")

proc internalGetTransient(this: Window): Window =
  ## Return parent (transient) window if any
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetTransient(this: Window): Window")
  else: bError("proc internalGetTransient(this: Window): Window")



# ALERT -----------------------------------------
proc internalRun(this: Alert) =
  ## Show this message dialog
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalRun(this: Alert)")
  else: bError("proc internalRun(this: Alert)")

proc internalSetModal(this: Alert, v: bool) =
  ## Set whether or not user can interact with other windows
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetModal(this: Alert, v: bool)")
  else: bError("proc internalSetModal(this: Alert, v: bool)")

proc internalGetModal(this: Alert): bool =
  ## Get whether or not user can interact with other windows
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetModal(this: Alert): bool")
  else: bError("proc internalGetModal(this: Alert): bool")

proc internalSetTransient(this: Alert, that: Window) =
  ## Set a parent window. This alert will appear on top of parent
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetTransient(this: Alert, that: Window)")
  else: bError("proc internalSetTransient(this: Alert, that: Window)")

proc internalGetTransient(this: Alert): Window =
  ## Return parent (transient) window if any
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetTransient(this: Alert): Window")
  else: bError("proc internalGetTransient(this: Alert): Window")

proc internalSetText(this: Alert, text: string) =
  ## Set this Alert's text content
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Alert, text: string)")
  else: bError("proc internalSetText(this: Alert, text: string)")

proc internalGetText(this: Alert): string =
  ## Get this Alert's text content
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: Alert): string")
  else: bError("proc internalGetText(this: Alert): string")

proc internalSetTitle(this: Alert, text: string) =
  ## Set this Alert's title
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetTitle(this: Alert, text: string)")
  else: bError("proc internalSetTitle(this: Alert, text: string)")

proc internalGetTitle(this: Alert): string =
  ## Get this Alert's title
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetTitle(this: Alert): string")
  else: bError("proc internalGetTitle(this: Alert): string")



# LABEL -----------------------------------------
proc internalSetText(this: Label, text: string) =
  ## Set this Label's content
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Label, text: string)")
  else: bError("proc internalSetText(this: Label, text: string)")

proc internalGetText(this: Label): string =
  ## Get this Label's content
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: Label): string")
  else: bError("proc internalGetText(this: Label): string")

proc internalSetWrap(this: Label, state: bool) =
  ## Set whether or not this element is allowed to wrap the content if it becomes too big
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetWrap(this: Label, state: bool)")
  else: bError("proc internalSetWrap(this: Label, state: bool)")

proc internalGetWrap(this: Label): bool =
  ## Get whether or not this element is allowed to wrap the content if it becomes too big
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetWrap(this: Label): bool")
  else: bError("proc internalGetWrap(this: Label): bool")

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
  ## Get this Entry's content
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: Entry): string")
  else: bError("proc internalGetText(this: Entry): string")

proc internalSetText(this: Entry, text: string) =
  ## Set this Entry's content
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Entry, text: string)")
  else: bError("proc internalSetText(this: Entry, text: string)")



# CHECKBOX --------------------------------------
proc internalSetText(this: Checkbox, that: string) =
  ## Set this CheckBox's text
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Checkbox, that: string)")
  else: bError("proc internalSetText(this: Checkbox, that: string)")

proc internalGetText(this: Checkbox): string =
  ## Get this CheckBox's text
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: Checkbox): string")
  else: bError("proc internalGetText(this: Checkbox): string")

proc internalGetChecked(this: Checkbox): bool =
  ## Get whether or not this CheckBox is checked
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetChecked(this: Checkbox): bool")
  else: bError("proc internalGetChecked(this: Checkbox): bool")

proc internalSetChecked(this: Checkbox, v: bool) =
  ## Set whether or not this CheckBox is checked
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetChecked(this: Checkbox, v: bool)")
  else: bError("proc internalSetChecked(this: Checkbox, v: bool)")



# BUTTON ----------------------------------------
proc internalSetText(this: Button, text: string) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Button, text: string)")
  else: bError("proc internalSetText(this: Button, text: string)")

proc internalGetText(this: Button): string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: Button): string")
  else: bError("proc internalGetText(this: Button): string")

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
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Radio, text: string)")
  else: bError("proc internalSetText(this: Radio, text: string)")

proc internalGetText(this: Radio): string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: Radio): string")
  else: bError("proc internalGetText(this: Radio): string")

proc internalSetGroup(radios: openArray[Radio]) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetGroup(radios: openArray[Radio])")
  else: bError("proc internalSetGroup(radios: openArray[Radio])")



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
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetDate(this: Calendar): DateTime ")
  else: bError("proc internalGetDate(this: Calendar): DateTime ")

proc internalSetDate(this: Calendar, date: DateTime) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetDate(this: Calendar, date: DateTime)")
  else: bError("proc internalSetDate(this: Calendar, date: DateTime)")

proc internalMark(this: Calendar, day: int) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalMark(this: Calendar, day: int)")
  else: bError("proc internalMark(this: Calendar, day: int)")

proc internalUnmark(this: Calendar, day: int) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalUnmark(this: Calendar, day: int)")
  else: bError("proc internalUnmark(this: Calendar, day: int)")

proc internalMarked(this: Calendar, day: int): bool =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalMarked(this: Calendar, day: int): bool")
  else: bError("proc internalMarked(this: Calendar, day: int): bool")

proc internalClear(this: Calendar) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalClear(this: Calendar)")
  else: bError("proc internalClear(this: Calendar)")



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



# BAR -------------------------------------------


# MENU ------------------------------------------
proc internalAdd(this: NElement, that: Menu) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: NElement, that: Menu)")
  else: bError("proc internalAdd(this: NElement, that: Menu)")



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
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: ComboBox, text: string) ")
  else: bError("proc internalAdd(this: ComboBox, text: string) ")

proc internalSet(this: ComboBox, text: string, i: int) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSet(this: ComboBox, text: string, i: int)")
  else: bError("proc internalSet(this: ComboBox, text: string, i: int)")

proc internalGet(this: ComboBox, i: int): string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGet(this: ComboBox, i: int): string")
  else: bError("proc internalGet(this: ComboBox, i: int): string")

proc internalGetSelected(this: ComboBox): string  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetSelected(this: ComboBox): string ")
  else: bError("proc internalGetSelected(this: ComboBox): string ")

proc internalGetSelectedIndex(this: ComboBox): int  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetSelectedIndex(this: ComboBox): int ")
  else: bError("proc internalGetSelectedIndex(this: ComboBox): int ")

proc internalSetSelectedIndex(this: ComboBox, i: int) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetSelectedIndex(this: ComboBox, i: int)")
  else: bError("proc internalSetSelectedIndex(this: ComboBox, i: int)")



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
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetSpacing(this: Box, spacing: int) ")
  else: bError("proc internalSetSpacing(this: Box, spacing: int) ")

proc internalGetOrientation(this: Box): NOrientation =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetOrientation(this: Box): NOrientation")
  else: bError("proc internalGetOrientation(this: Box): NOrientation")

proc internalSetOrientation(this: Box, value: NOrientation) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetOrientation(this: Box, value: NOrientation)")
  else: bError("proc internalSetOrientation(this: Box, value: NOrientation)")



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
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetMode(this: List): NAmount")
  else: bError("proc internalGetMode(this: List): NAmount")

proc internalSetMode(this: List, mode: NAmount) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetMode(this: List, mode: NAmount)")
  else: bError("proc internalSetMode(this: List, mode: NAmount)")

proc internalSelected(this: List, that: var seq[NElement]) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSelected(this: List, that: var seq[NElement])")
  else: bError("proc internalSelected(this: List, that: var seq[NElement])")



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



#proc internalAdd(this: Tools, value: NOrientation)


# TIMERS -----------------------------------------
proc internalRepeat(event: NRepeatProc, ms: int): NRepeatHandle =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalRepeat(event: NRepeatProc, ms: int): NRepeatHandle")
  else: bError("proc internalRepeat(event: NRepeatProc, ms: int): NRepeatHandle")

proc internalStop(this: NRepeatHandle) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalStop(this: NRepeatHandle)")
  else: bError("proc internalStop(this: NRepeatHandle)")

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
  const
    K_A = K_lowera
    K_Z = K_lowerz
  
  case c:
  of K_ESC:        nkEsc
  of K_0 .. K_9:   NKey((c - K_0) + int(nk0))
  of K_A .. K_Z:   NKey((c - K_A) + int(nkA))
  else:            nkNone