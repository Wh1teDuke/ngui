
include private/ngui_common_gtk


#     v-- Set 'LAX_ERROR' to false to see fireworks
const LAX_ERROR = true
  
template bInfo(str: string) =
  echo("[NGUI_INFO] " & str & " NOT IMPLEMENTED")
template bError(str: string) =
  raiseAssert("[NGUI_ERROR] " & str & " NOT IMPLEMENTED")


# BASE ------------------------------------------


# EVENT -----------------------------------------
# included

# WIDGET ----------------------------------------
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

proc internalGetParent(this: NElement): Container = utilParent(this)

proc internalSetVisible(this: NElement, state: bool) =
  if state: this.data(gtkWidget).show()
  else: this.data(gtkWidget).hide()

proc internalGetVisible(this: NElement): bool =
  ## Get whether this element is shown or not
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetVisible(this: NElement): bool")
  else: bError("proc internalGetVisible(this: NElement): bool")

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
  this.data(gtkWidget).setTooltipText(text)

proc internalGetTooltip(this: NElement): string =
  ## Get this element's tooltip text
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetTooltip(this: NElement): string")
  else: bError("proc internalGetTooltip(this: NElement): string")

proc internalSetDestroy(this: NElement) =
  ## Destroy this element, you won't be able to reuse it
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetDestroy(this: NElement)")
  else: bError("proc internalSetDestroy(this: NElement)")

proc internalGetDestroy(this: NElement): bool =
  ## Get whether or not this element is alive
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetDestroy(this: NElement): bool")
  else: bError("proc internalGetDestroy(this: NElement): bool")

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
proc internalLen(this: Container): int = utilLen(this)

proc internalRemove(this: Container, that: NElement) =
  ## Remove element from this container. Element MUST be a child
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalRemove(this: Container, that: NElement)")
  else: bError("proc internalRemove(this: Container, that: NElement)")


proc handleMenuBarAdd(this, that: NElement) # FD
proc handleToolsAdd(this: Tools, that: NElement) # FD

proc internalAdd(this: Container, that: NElement) =  
  if this of App:
    utilChild(this, that)
    return

  # MENU/BAR
  # (Complex stuff, we need to create MenuItems in the middle)
  if (this of Menu or this of Bar) or (that of Menu):
    handleMenuBarAdd(this, that)
    return
  
  # TOOLS
  # Again, create an adapter
  if this of Tools:
    handleToolsAdd(Tools(this), that)
    return

  utilChild(this, that)
  let (thisD, thatD) = (this.data(gtkContainer), that.data(gtkWidget))

  # TODO: if not utilTryAddChild(thisD, thatD, adapters):
  if true:
    thisD.add(thatD)

  thatD.show()

proc internalReplace(container: Container, this, that: NElement) =
  ## Replace child with another element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalReplace(container: Container, this, that: NElement)")
  else: bError("proc internalReplace(container: Container, this, that: NElement)")

proc internalIndex(this: Container, that: NElement): int =
  ## Get the position of this child
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalIndex(this: Container, that: NElement): int")
  else: bError("proc internalIndex(this: Container, that: NElement): int")

proc internalGetChild(this: Container, index: int): NElement =
  utilNChild(this, index)

proc internalGetBorder(this: Container): NBorder =
  ## Get the border size of this container
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetBorder(this: Container): NBorder")
  else: bError("proc internalGetBorder(this: Container): NBorder")

proc internalSetBorder(this: Container, b: NBorder) =
  ## Set the border size of this container
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetBorder(this: Container, b: NBorder)")
  else: bError("proc internalSetBorder(this: Container, b: NBorder)")

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
  for c in utilItems(this):
    c.data(gtkWindow).showAll()
  gtk2.main() # Blocking

proc internalStop(this: App) =
  utilStopRepeat()
  gtk2.mainQuit()


# WINDOW ----------------------------------------
proc internalSetText(this: Window, text: string) =
  this.data(gtkWindow).set_title(text)

proc internalGetText(this: Window): string =
  $this.data(gtkWindow).get_title()

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



# ALERT -----------------------------------------
proc internalNewAlert(parent: Window, text: string): Alert =
  ## Create a new message dialog
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewAlert(parent: Window, text: string): Alert")
  else: bError("proc internalNewAlert(parent: Window, text: string): Alert")

proc internalRun(this: Alert) =
  ## Show this message dialog
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalRun(this: Alert)")
  else: bError("proc internalRun(this: Alert)")



# LABEL -----------------------------------------
proc internalNewLabel: Label =
  ## Create a new Label element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewLabel: Label")
  else: bError("proc internalNewLabel: Label")

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
proc internalNewEntry(): Entry =
  ## Create a new Entry element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewEntry(): Entry")
  else: bError("proc internalNewEntry(): Entry")

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
proc internalNewCheckBox(): Checkbox =
  ## Create a new CheckBox element
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewCheckBox(): Checkbox")
  else: bError("proc internalNewCheckBox(): Checkbox")

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
proc internalNewButton(): Button  =
  result = Button(kind: neButton, id: nextID())
  result.data = button_new()
  onCreate(result)  

proc internalSetText(this: Button, text: string) =
  this.data(gtkButton).setLabel(text)

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
proc internalNewRadio(): Radio =
  result = Radio(kind: neRADIO, id: nextID())
  let r = radio_button_new(nil)
  result.data = r
  onCreate(result)

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
proc internalNewBubble(): Bubble =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewBubble(): Bubble")
  else: bError("proc internalNewBubble(): Bubble")

proc internalAttach(this: Bubble, that: NElement) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAttach(this: Bubble, that: NElement)")
  else: bError("proc internalAttach(this: Bubble, that: NElement)")



# IMAGE -----------------------------------------
proc internalNewImage(bitmap: Bitmap): Image =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewImage(bitmap: Bitmap): Image")
  else: bError("proc internalNewImage(bitmap: Bitmap): Image")

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
proc internalNewTextArea(): TextArea  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewTextArea(): TextArea ")
  else: bError("proc internalNewTextArea(): TextArea ")

proc internalSetText(this: TextArea, text: string) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: TextArea, text: string)")
  else: bError("proc internalSetText(this: TextArea, text: string)")

proc internalGetText(this: TextArea): string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: TextArea): string")
  else: bError("proc internalGetText(this: TextArea): string")



# CALENDAR -------------------------------------- 
proc internalNewCalendar(): Calendar  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewCalendar(): Calendar ")
  else: bError("proc internalNewCalendar(): Calendar ")

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
proc internalNewSlider(): Slider =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewSlider(): Slider")
  else: bError("proc internalNewSlider(): Slider")

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
proc internalNewFileChoose(): FileChoose =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewFileChoose(): FileChoose")
  else: bError("proc internalNewFileChoose(): FileChoose")

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
proc internalNewBar(): Bar  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewBar(): Bar ")
  else: bError("proc internalNewBar(): Bar ")



# MENU ------------------------------------------
proc internalNewMenu(): Menu =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewMenu(): Menu")
  else: bError("proc internalNewMenu(): Menu")

proc handleMenuBarAdd(this, that: NElement) =
  raiseAssert("Not implemented")

proc internalAdd(this: NElement, that: Menu) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: NElement, that: Menu)")
  else: bError("proc internalAdd(this: NElement, that: Menu)")


# TABLE -----------------------------------------
proc internalNewTable(): NTable =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewTable(): NTable")
  else: bError("proc internalNewTable(): NTable")

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
proc internalNewComboBox(): ComboBox  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewComboBox(): ComboBox ")
  else: bError("proc internalNewComboBox(): ComboBox ")

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
proc internalNewProgress(): Progress  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewProgress(): Progress ")
  else: bError("proc internalNewProgress(): Progress ")

proc internalValue(this: Progress): float  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalValue(this: Progress): float ")
  else: bError("proc internalValue(this: Progress): float ")

proc internalValue(this: Progress, v: float) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalValue(this: Progress, v: float)")
  else: bError("proc internalValue(this: Progress, v: float)")


# BOX ------------------------------------------- 
proc internalNewBox(): Box  =
  result = Box(kind: neBox, id: nextID())
  result.data = vbox_new(true, 0)
  onCreate(result)

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

proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int)  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int) ")
  else: bError("proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int) ")



# GRID ------------------------------------------
proc internalNewGrid(): Grid  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewGrid(): Grid ")
  else: bError("proc internalNewGrid(): Grid ")

proc internalAdd(this: Grid, that: NElement, r, c, w, h: int)  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: Grid, that: NElement, r, c, w, h: int) ")
  else: bError("proc internalAdd(this: Grid, that: NElement, r, c, w, h: int) ")



# TAB -------------------------------------------
proc internalNewTab(): Tab  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewTab(): Tab ")
  else: bError("proc internalNewTab(): Tab ")

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
proc internalNewList(): List  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewList(): List ")
  else: bError("proc internalNewList(): List ")

proc internalGetMode(this: List): NAmount  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetMode(this: List): NAmount ")
  else: bError("proc internalGetMode(this: List): NAmount ")

proc internalSetMode(this: List, mode: NAmount)  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetMode(this: List, mode: NAmount) ")
  else: bError("proc internalSetMode(this: List, mode: NAmount) ")

proc internalCmp(this: List, that: NCMPProc)  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalCmp(this: List, that: NCMPProc) ")
  else: bError("proc internalCmp(this: List, that: NCMPProc) ")

proc internalSelected(this: List, that: var seq[NElement])  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSelected(this: List, that: var seq[NElement]) ")
  else: bError("proc internalSelected(this: List, that: var seq[NElement]) ")



# FRAME -----------------------------------------
proc internalNewFrame(): Frame  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewFrame(): Frame ")
  else: bError("proc internalNewFrame(): Frame ")

proc internalSetText(this: Frame, text: string)  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Frame, text: string) ")
  else: bError("proc internalSetText(this: Frame, text: string) ")

proc internalGetText(this: Frame): string =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetText(this: Frame): string")
  else: bError("proc internalGetText(this: Frame): string")



# TOOLS -----------------------------------------
proc internalNewTools(): Tools =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalNewTools(): Tools")
  else: bError("proc internalNewTools(): Tools")

proc internalGetOrientation(this: Tools): NOrientation =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetOrientation(this: Tools): NOrientation")
  else: bError("proc internalGetOrientation(this: Tools): NOrientation")

proc internalSetOrientation(this: Tools, value: NOrientation) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetOrientation(this: Tools, value: NOrientation)")
  else: bError("proc internalSetOrientation(this: Tools, value: NOrientation)")

proc handleToolsAdd(this: Tools, that: NElement) =
  raiseAssert("Not Implemented")

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


# EVENTS AGAIN ----------------------------------
proc internalGetCurrentEvent: NEventArgs =
  # https://developer.gnome.org/gtk3/stable/gtk3-General.html
  # https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html
  let e = getCurrentEvent()
  if e == nil: return
  #[ TODO
  case e.`type`:
  of BUTTON_PRESS, BUTTON_RELEASE, MOTION_NOTIFY:
    template setkind(a, b) =
      if e.`type` == a: result = NEventArgs(kind: b)
      
    setKind(BUTTON_PRESS,   neClick)
    setKind(BUTTON_RELEASE, neClickRelease)
    setKind(MOTION_NOTIFY,  neMove)
    
    if e.`type` in {BUTTON_PRESS, BUTTON_RELEASE}:
      let e = cast[EventButton](e)
      
      if e.button == 1: result.mouse.incl(nm1)
      if e.button == 2: result.mouse.incl(nm2)
      if e.button == 3: result.mouse.incl(nm3)
      
    else:
      var st: ModifierType
      if e.getState(st):      
        template setMouse(a, b) =
          if (int(st) and int(a)) != 0: result.mouse.incl(b)

        setMouse(BUTTON1_MASK, nm1)
        setMouse(BUTTON2_MASK, nm2)
        setMouse(BUTTON3_MASK, nm3)

    result.x = e.button.x.int
    result.y = e.button.y.int

  of KEY_PRESS, KEY_RELEASE:
    let key =
      case e.key.keyval:
      of KEY_ESCAPE: nkEsc
      of KEY_a: nkA
      of KEY_b: nkB
      of KEY_c: nkC
      of KEY_d: nkD
      of KEY_v: nkV
      of KEY_s: nkS
      else: nkNone

    result =
      if e.`type` == KEY_PRESS: NEventArgs(kind: neKeyPress, key: key)
      else: NEventArgs(kind: neKeyRelease, key: key)

    var st: ModifierType
    if e.getState(st):
      template mapMod(mt: ModifierType, k: NKey) =
        if (int(st) and int(mt)) != 0: result.mods.incl(k)

      mapMod(CONTROL_MASK, nkControl)
      mapMod(SHIFT_MASK, nkShift)

  else: discard

  result.element = utilElement(e.getEventWidget())
  gdk.free(e)]#