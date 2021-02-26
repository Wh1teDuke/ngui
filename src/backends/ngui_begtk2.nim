
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
proc internalRun(this: Alert) =
  ## Show this message dialog
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalRun(this: Alert)")
  else: bError("proc internalRun(this: Alert)")

proc internalSetModal(this: Alert, v: bool) =
  raiseAssert("SET MODAL TODO")

proc internalGetModal(this: Alert): bool =
  raiseAssert("GET MODAL TODO")
  
proc internalSetTransient(this: Alert, that: Window) =
  raiseAssert("SET TRANSIENT TODO")

proc internalGetTransient(this: Alert): Window =
  raiseAssert("GET TRANSIENT TODO")


# LABEL -----------------------------------------
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



# CHECKBOX --------------------------------------


# BUTTON ----------------------------------------
proc internalSetImage(this: Button, img: Bitmap) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetImage(this: Button, img: Bitmap)")
  else: bError("proc internalSetImage(this: Button, img: Bitmap)")

proc internalGetImage(this: Button): Bitmap =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetImage(this: Button): Bitmap")
  else: bError("proc internalGetImage(this: Button): Bitmap")


# RADIO -----------------------------------------


# BUBBLE ----------------------------------------
proc internalAttach(this: Bubble, that: NElement) =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAttach(this: Bubble, that: NElement)")
  else: bError("proc internalAttach(this: Bubble, that: NElement)")


# IMAGE -----------------------------------------


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
proc handleMenuBarAdd(this, that: NElement) =
  raiseAssert("Not implemented")

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
proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int)  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int) ")
  else: bError("proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int) ")


# GRID ------------------------------------------
proc internalAdd(this: Grid, that: NElement, r, c, w, h: int)  =
  let
    thisD         = this.data(gtkGrid)
    (r, c, w, h)  = (guint(r), guint(c), guint(w), guint(h))

  var tR, tC: guint
  # https://developer.gnome.org/gtk2/2.24/GtkTable.html#gtk-table-get-size
  thisD.getSize(tR, tC)
  # https://developer.gnome.org/gtk2/2.24/GtkTable.html#gtk-table-resize
  if r + h > tR or c + w > tC: thisD.resize(max(tR, r + h), max(tC, c + w))
  # https://developer.gnome.org/gtk2/2.24/GtkTable.html#gtk-table-attach

  thisD.attachDefaults(that.data(gtkWidget), c, c + w, r, r + h)
  utilChild(this, that)


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
proc internalSetText(this: Frame, text: string)  =
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetText(this: Frame, text: string) ")
  else: bError("proc internalSetText(this: Frame, text: string) ")

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