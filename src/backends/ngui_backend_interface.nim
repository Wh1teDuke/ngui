# INTERFACE


# EVENT -----------------------------------------
proc internalSetEvent(this: NElement, event: NElementEvent, action: NEventProc)
  ## Attach event to this element. Cannot set more than one event per kind
proc internalGetCurrentEvent: NEventArgs
  ## Get the args from the event that is currently being dispatched
proc internalEventHandled()
  ## Stop event propagation


# WIDGET ----------------------------------------
proc internalGetOpacity(this: NElement): float
  ## Get Opacity of this element (0.0 - 1.0)
proc internalSetOpacity(this: NElement, v: float)
  ## Set Opacity of this element (0.0 - 1.0)
proc internalGetParent(this: NElement): Container
  ## Get the parent of this element OR nil if it doesn't have one
proc internalSetVisible(this: NElement, state: bool)
  ## Set whether this element is shown or not
proc internalGetVisible(this: NElement): bool
  ## Get whether this element is shown or not
proc internalGetNext(this: NElement): NElement
  ## Get the parent's next child after this one or nil
proc internalGetPrev(this: NElement): NElement
  ## Get the parent's previous child before this one or nil
proc internalGetFocus(this: NElement): bool
  ## Get whether the element has the focus or not
proc internalSetFocus(this: NElement)
  ## Set the focus on this element
proc internalGetSize(this: NElement): tuple[w, h: int]
  ## Get the size of this element
proc internalSetSize(this: NElement, size: tuple[w, h: int])
  ## Set the size of this element
proc internalSetTooltip(this: NElement, text: string)
  ## Set this element's tooltip text
proc internalGetTooltip(this: NElement): string
  ## Get this element's tooltip text
proc internalSetDestroy(this: NElement)
  ## Destroy this element, you won't be able to reuse it
proc internalGetDestroy(this: NElement): bool
  ## Get whether or not this element is alive
proc internalGetBGColor(this: NElement): Pixel
  ## Get the background color of this element
proc internalSetBGColor(this: NElement, color: Pixel)
  ## Set the background color of this element


# CONTAINER -------------------------------------
proc internalLen(this: Container): int
  ## Get the amount of NElements on this container
proc internalRemove(this: Container, that: NElement)
  ## Remove element from this container. Element MUST be a child
proc internalAdd(this: Container, that: NElement)
  ## Add element to this container. Element MUST not have a parent
proc internalReplace(container: Container, this, that: NElement)
  ## Replace child with another element
proc internalIndex(this: Container, that: NElement): int
  ## Get the position of this child
proc internalGetChild(this: Container, index: int): NElement
  ## Get child by index position
proc internalGetBorder(this: Container): NBorder
  ## Get the border size of this container
proc internalSetBorder(this: Container, b: NBorder)
  ## Set the border size of this container
proc internalAddSeparator(this: Container, dir: NOrientation)
  ## Add a visual separator after the last added child
proc internalGetBorderColor(this: Container): Pixel
  ## Get the color of this container's border
proc internalSetBorderColor(this: Container, color: Pixel)
  ## Set the color of this container's border


# APP -------------------------------------------
proc internalNewApp(): App
  ## Create and initialize the App context
proc internalRun(this: App)
  ## Start the app. Show the elements and block the thread until requested to stop
proc internalStop(this: App)
  ## Shutdown the App context


# WINDOW ----------------------------------------
proc internalNewWindow: Window
  ## Create a new Window element
proc internalSetText(this: Window, text: string)
  ## Set this window's title
proc internalGetText(this: Window): string
  ## Get this window's title
proc internalSetResizable(this: Window, state: bool)
  ## Set whether the user can resize the window or not
proc internalGetResizable(this: Window): bool
  ## Get whether the user can resize the window or not
proc internalSetPosition(this: Window, position: tuple[x, y: int])
  ## Set this window's position relative to the top left of the screen
proc internalGetPosition(this: Window): tuple[x, y: int]
  ## Get this window's position relative to the top left of the screen
proc internalGetFocused(this: Window): NElement
  ## Get the element within this window that has the focus
proc internalGetIcon(this: Window): Bitmap
  ## Get the icon that this window is displaying or nil
proc internalSetIcon(this: Window, that: Bitmap)
  ## Set the icon for this window
proc internalGetDecorated(this: Window): bool
  ## Get whether or not this window is displaying the border
proc internalSetDecorated(this: Window, v: bool)
  ## Set whether or not this window is displaying the border
proc internalSetMinimized(this: Window, v: bool)
  ## Set whether or not this window is minimized
proc internalGetMinimized(this: Window): bool
  ## Get whether or not this window is minimized
proc internalSetMaximized(this: Window, v: bool)
  ## Set whether or not this window is maximized
proc internalGetMaximized(this: Window): bool
  ## Get whether or not this window is maximized


# ALERT -----------------------------------------
proc internalNewAlert(parent: Window, text: string): Alert
  ## Create a new message dialog
proc internalRun(this: Alert)
  ## Show this message dialog


# LABEL -----------------------------------------
proc internalNewLabel: Label
  ## Create a new Label element
proc internalSetText(this: Label, text: string)
  ## Set this Label's content
proc internalGetText(this: Label): string
  ## Get this Label's content
proc internalSetWrap(this: Label, state: bool)
  ## Set whether or not this element is allowed to wrap the content if it becomes too big
proc internalGetWrap(this: Label): bool
  ## Get whether or not this element is allowed to wrap the content if it becomes too big
proc internalGetXAlign(this: Label): float
proc internalGetYAlign(this: Label): float
proc internalSetXAlign(this: Label, v: float)
proc internalSetYAlign(this: Label, v: float)


# ENTRY -----------------------------------------
proc internalNewEntry(): Entry
  ## Create a new Entry element
proc internalGetText(this: Entry): string
  ## Get this Entry's content
proc internalSetText(this: Entry, text: string)
  ## Set this Entry's content


# CHECKBOX --------------------------------------
proc internalNewCheckBox(): Checkbox
  ## Create a new CheckBox element
proc internalSetText(this: Checkbox, that: string)
proc internalGetText(this: Checkbox): string
proc internalGetChecked(this: Checkbox): bool
proc internalSetChecked(this: Checkbox, v: bool)


# BUTTON ----------------------------------------
proc internalNewButton(): Button 
proc internalSetText(this: Button, text: string) 
proc internalGetText(this: Button): string
proc internalSetImage(this: Button, img: Bitmap)
proc internalGetImage(this: Button): Bitmap


# RADIO -----------------------------------------
proc internalNewRadio(): Radio
proc internalSetText(this: Radio, text: string)
proc internalSetGroup(radios: openArray[Radio])


# IMAGE -----------------------------------------
proc internalNewImage(bitmap: Bitmap): Image
proc internalNewBitmap(file: string): Bitmap
proc internalGetBitmap(this: Image): Bitmap
proc internalUpdate(this: Image, that: Bitmap)
proc internalCopy(this: Bitmap): Bitmap
proc internalSave(this: Bitmap, path, format: string): bool
proc internalIconBitmap(name: string): Bitmap
proc internalIconBitmap(icon: NIcon): Bitmap


# TEXTAREA --------------------------------------
proc internalNewTextArea(): TextArea 
proc internalSetText(this: TextArea, text: string)
proc internalGetText(this: TextArea): string


# CALENDAR -------------------------------------- 
proc internalNewCalendar(): Calendar 
proc internalGetDate(this: Calendar): DateTime 
proc internalSetDate(this: Calendar, date: DateTime) 


# SLIDER ----------------------------------------
proc internalNewSlider(): Slider
proc internalSetDecimals(this: Slider, decimals: int)
proc internalGetDecimals(this: Slider): int
proc internalSetRange(this: Slider, range: Slice[float])
proc internalSetStep(this: Slider, step: float)
proc internalGetValue(this: Slider): float
proc internalSetValue(this: Slider, value: float)
proc internalGetOrientation(this: Slider): NOrientation
proc internalSetOrientation(this: Slider, value: NOrientation)


# FILECHOOSE ------------------------------------
proc internalNewFileChoose(): FileChoose
proc internalSetMultiple(this: FileChoose, state: bool)
proc internalGetMultiple(this: FileChoose): bool
proc internalGetFiles(this: FileChoose): seq[string]
proc internalSetText(this: FileChoose, text: string)
proc internalGetText(this: FileChoose): string
proc internalSetButton(this: FileChoose, button: string, index: int)
proc internalRun(this: FileChoose): int


# BAR -------------------------------------------
proc internalNewBar(): Bar 


# MENU ------------------------------------------
proc internalNewMenu(): Menu 


# TABLE -----------------------------------------
proc internalNewTable(): NTable
proc internalAdd(this: Table, that: NTableRow)
proc internalSet(this: Table, that: NTableCell, x, y: int)
proc internalGet(this: Table, x, y: int): NTableCell
proc internalHeader(this: NTable, headers: openArray[string])
proc internalHeaders(this: NTable): bool
proc internalHeaders(this: NTable, v: bool)


# COMBOBOX --------------------------------------
proc internalNewComboBox(): ComboBox 
proc internalAdd(this: ComboBox, text: string) 
proc internalSet(this: ComboBox, text: string, i: int) 
proc internalGetSelected(this: ComboBox): string 
proc internalGetSelectedIndex(this: ComboBox): int 
proc internalSetSelectedIndex(this: ComboBox, i: int)


# PROGRESS --------------------------------------
proc internalNewProgress(): Progress 
proc internalValue(this: Progress): float 
proc internalValue(this: Progress, v: float)


# BOX ------------------------------------------- 
proc internalNewBox(): Box 
proc internalSetSpacing(this: Box, spacing: int) 
proc internalGetOrientation(this: Box): NOrientation
proc internalSetOrientation(this: Box, value: NOrientation)
proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int) 


# GRID ------------------------------------------
proc internalNewGrid(): Grid 
proc internalAdd(this: Grid, that: NElement, r, c, w, h: int) 


# TAB -------------------------------------------
proc internalNewTab(): Tab 
proc internalAdd(this: Tab, that: Container, label: Label)
proc internalGetSide(this: Tab): NSide
proc internalSetSide(this: Tab, side: NSide)


# LIST ------------------------------------------
proc internalNewList(): List 
proc internalGetMode(this: List): NAmount 
proc internalSetMode(this: List, mode: NAmount) 
proc internalCmp(this: List, that: NCMPProc) 
proc internalSelected(this: List, that: var seq[NElement]) 


# FRAME -----------------------------------------
proc internalNewFrame(): Frame 
proc internalSetText(this: Frame, text: string) 
proc internalGetText(this: Frame): string


# TOOLS -----------------------------------------
proc internalNewTools(): Tools
proc internalGetOrientation(this: Tools): NOrientation
proc internalSetOrientation(this: Tools, value: NOrientation)
#proc internalAdd(this: Tools, value: NOrientation)


# TIMER -----------------------------------------
proc internalStop(this: NRepeatHandle)
proc internalSetTime(this: var NRepeatHandle, ms: int) 


# CLIPBOARD -------------------------------------
proc internalClipboardClear()
proc internalClipboardSet(text: string)
proc internalClipboardSet(img: Bitmap)
proc internalClipboardGetText: string
proc internalClipboardGetImg: Bitmap
proc internalClipboardAsyncGet(action: NAsyncTextProc)
proc internalClipboardAsyncGet(action: NAsyncBitmapProc)
