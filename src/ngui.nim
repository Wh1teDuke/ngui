import std/[strutils, hashes, tables, times, sequtils, os]
type pointer = system.pointer
type STable[A, B] = tables.Table[A, B]


# Increment if someone complains
const version* = 0 ## Bugs counter, nothing to see here.

# TYPES -----------------------------------------
type
  NOrientation* = enum
    noHORIZONTAL noVERTICAL
  
  NSide* = enum
    nsTop nsBottom nsLeft nsRight
  
  NAmount* = enum
    naNone naMinOne naOne naMultiple
  
  NIcon* = enum
    niFOLDER
    niFILE niFILE_OPEN
    niEXECUTABLE
  
  NID* = uint32

  NElementKind* = enum
    neKindInvalid
    # Important
    neApp neWindow
    # Containers
    neContainer neBubble
    neGrid neBox neCheckBox neComboBox neCalendar neMenu neBar
    neTab neList neFrame neTable neTools
    # Atomic Elements
    neAtom
    neRadio neLabel neEntry neButton neAlert neImage
    neProgress neTextArea neSlider neFileChoose

  NElementEvent* = enum
    neNONE neCLICK neCLICK_RELEASE neMOVE
    neENTER neCHANGE neOPEN
    neFOCUS_ON neFOCUS_OFF neDESTROY
    neSHOW neHIDE neKEY_PRESS neKEY_RELEASE

  NElementAttribute* = enum
    naMinimized naMaximized
    naKind naVisible naHasParent naFocus naSize naOpacity
    naLen naText naWrap naResizable naValue naOrientation
    naIndex naReorderable naName naSide naBGColor

  NKey* = enum
    nkNone nkEsc nkControl nkShift
    nkA nkB nkC nkD nkS nkV
    
  NMouse* = enum
    nm1 nm2 nm3
  
  NCellKind* = enum
    ckImg ckBool ckStr

  NElement* = ref object of RootObj
    id: NID
    kind: NElementKind

  Container* = ref object of NElement
  Bubble* = ref object of Container
    ## .. image:: ../assets/bubble.png
  
  Box* = ref object of Container
    ## .. image:: ../assets/box.png
  
  Grid* = ref object of Container
    ## .. image:: ../assets/grid.png
  
  App* = ref object of Container
  Window* = ref object of Container
    ## .. image:: ../assets/window.png

  ComboBox* = ref object of Container
    ## .. image:: ../assets/combo.png
  
  Menu* = ref object of Container
    ## .. image:: ../assets/calendar_menu.png
  
  Bar* = ref object of Container
    ## .. image:: ../assets/calendar_menu.png
  
  Tab* = ref object of Container
    ## .. image:: ../assets/tabs_progress_list.png
  
  List* = ref object of Container
    ## .. image:: ../assets/list.png
  
  Frame* = ref object of Container
    ## .. image:: ../assets/frame.png
  
  Tools* = ref object of Container
    ## .. image:: ../assets/tools.png
  
  Table* = ref object of Container
    ## .. image:: ../assets/table_bubble.png
  
  NTable* = Table

  Atom* = ref object of NElement
  CheckBox* = ref object of Atom
    ## .. image:: ../assets/checkbox.png
  
  Alert* = ref object of Atom
    ## .. image:: ../assets/alert.png
  
  Calendar* = ref object of Atom
    ## .. image:: ../assets/calendar_menu.png
  
  Radio* = ref object of Atom
    ## .. image:: ../assets/radio.png
  
  Entry* = ref object of Atom
    ## .. image:: ../assets/Entry.png
  
  Label* = ref object of Atom
    ## .. image:: ../assets/label.png
  
  Button* = ref object of Atom
    ## .. image:: ../assets/button.png
  
  Progress* = ref object of Atom
    ## .. image:: ../assets/progress.png
  
  TextArea* = ref object of Atom
  Slider* = ref object of Atom
    ## .. image:: ../assets/slider.png
  
  FileChoose* = ref object of Atom

  Image* = ref object of Atom
    ## .. image:: ../assets/image.png

  Bitmap* = ref object
    pixels: ptr[UncheckedArray[Pixel]]
    data: pointer
    width, height: int
    channels: int
    path: string

  Pixel* = tuple[r, g, b, a: uint8]

  Attribute* = object
    case kind*:       NElementAttribute
    of naKind:        aKind*: NElementKind
    of naText:        aText*: string
    of naName:        aName*: string
    of naVisible:     aVisible*: bool
    of naWrap:        aWrap*: bool
    of naResizable:   aResizable*: bool
    of naHasParent:   aHasParent*: bool
    of naFocus:       aFocus*: bool
    of naSize:        aSize*: tuple[w, h: int]
    of naValue:       aValue*: tuple[vInt: int, vFloat: float]
    of naOpacity:     aOpacity*: float
    of naLen:         aLen*: int
    of naMinimized:   aMinimized*: bool
    of naMaximized:   aMaximized*: bool
    of naOrientation: aOrientation*: NOrientation
    of naIndex:       aIndex*: int
    of naReorderable: aReorderable*: bool
    of naSide:        aSide*: NSide
    of naBGColor:     aBGColor*: Pixel
    found*:           bool
    
  Attributes* = array[NElementAttribute, Attribute]
  
  NEventArgs* = object
    element*: NElement
    case kind*: NElementEvent:
    of neClick, neClickRelease, neMove:
      mouse*: set[NMouse]
      x*, y*: int
    of neKeyPress, neKeyRelease:
      mods*: set[NKey]
      key*: NKey
    else:
      discard
  
  NEventProc* = (proc(){.closure.})
  NCMPPRoc* = (proc(a, b: NElement): int)
  
  NAsyncTextProc* = (proc(text: string) {.closure.})
  NAsyncBitmapProc* = (proc(bitmap: Bitmap) {.closure.})
  NRepeatProc* = (proc(): bool {.closure.})
  NRepeatHandle* = distinct int
  
  NBorder* = array[NSide, int]
  
  NTableCell* = object
    case kind: NCellKind:
    of ckBool: vBool: bool
    of ckImg:  vImg: Bitmap
    of ckStr:  vStr: string
  
  NTableRow* = object
    list: ptr[UncheckedArray[NTableCell]]
    len:  int


proc `$`*(this: NElementKind): string = system.`$`(this)[2..^1]
proc hash*(this: NElement): Hash = hash(this.id)
proc hash*(this: Bitmap): Hash = hash(cast[pointer](this))
proc hash*(this: NRepeatHandle): Hash = hash(int(this))
proc `==`*(this, that: NRepeatHandle): bool {.borrow.}
proc toCell(v: int):    NTableCell = NTableCell(kind: ckStr,  vStr: $v)
proc toCell(v: bool):   NTableCell = NTableCell(kind: ckBool, vBool: v)
proc toCell(v: string): NTableCell = NTableCell(kind: ckStr,  vStr: v)
proc toCell(v: Bitmap): NTableCell = NTableCell(kind: ckImg,  vImg: v)
proc pixel*(r, g, b: uint8, a: uint8 = 255): Pixel =
  (r, g, b, a)
proc pixel*(r, g, b: float, a: float = 1.0): Pixel =
  (uint8(r * 255), uint8(g * 255), uint8(b * 255), uint8(a * 255))

var
  tags:  STable[NElement, STable[string, string]]
  names: STable[NElement, string]
  init:  bool
  pApp:  App

include backends/ngui_backend

let # const
  NSEPARATOR* = NElement(kind: neKindInvalid, id: 5)

const
  nmLEFT*   = nm1
  nmMIDDLE* = nm2
  nmRIGHT*  = nm3


# NElement --------------------------------------
proc tag*(this: NElement, key: string): string =
  tags.withValue(this, elementTags):
    return getOrDefault(elementTags[], key)

proc `tag=`*(this: NElement, tag: tuple[key, value: string]) =
  tags[this][tag.key] = tag.value

proc name*(this: NElement): string = getOrDefault(names, this, "")
proc `name=`*(this: NElement, name: string) = names[this] = name

proc named*[N: NElement](this: N, name: string): N =
  this.name = name
  return this

proc opacity*(this: NElement): float = internalGetOpacity(this)
proc `opacity=`*(this: NElement, o: float) = internalSetOpacity(this, o)

proc tooltip*(this: NElement): string = internalGetTooltip(this)
proc `tooltip=`*(this: NElement, text: string) = internalSetTooltip(this, text)

proc kind*(this: NElement): NElementKind = this.kind
proc id*(this: NElement): int = int(this.id)

proc parent*(this: NElement): Container = internalGetParent(this)
proc hasParent*(this: NElement): bool = parent(this) != nil

proc visible*(this: NElement): bool = internalGetVisible(this)
proc `visible=`*(this: NElement, state: bool) = internalSetVisible(this, state)
proc show*(this: NElement) = this.visible = true 
proc hide*(this: NElement) = this.visible = false

proc alive*(this: NElement): bool = not internalGetDestroy(this)
proc destroyed*(this: NElement): bool = internalGetDestroy(this)
proc destroy*(this: NElement) = internalSetDestroy(this)
proc tryDestroy*(this: NElement): bool {.discardable.} =
  if alive(this):
    destroy(this)
    return true

proc focused*(this: NElement): bool = internalGetFocus(this)
proc focus*(this: NElement) = internalSetFocus(this)

proc size*(this: NElement): tuple[w, h: int] =
  internalGetSize(this)
proc `size=`*(this: NElement, size: tuple[w, h: int]) =
  internalSetSize(this, size)

proc next*(this: NElement): NElement = internalGetNext(this)
proc prev*(this: NElement): NElement = internalGetPrev(this)

proc index*(this: NElement): int =
  if this.hasParent: internalIndex(this.parent, this) else: -1

proc bgColor*(this: NElement): Pixel =
  internalGetBGColor(this)
proc `bgColor=`*(this: NElement, color: Pixel) =
  internalSetBGColor(this, color)

proc supports*(element: NElementKind, event: NElementEvent): bool =
  discard

proc supports*(element: NElementKind, attribute: NElementAttribute): bool =
  discard

proc currentEvent*(): NEventArgs = internalGetCurrentEvent()
proc eventHandled*() = internalEventHandled()

proc onEvent*(this: NElement, event: NElementEvent, action: NEventProc) =
  internalSetEvent(this, event, action)

# Ain't typing all that by.hand()
import macros
macro genAllSetEventProcs: untyped =
  result = newStmtList()

  for e in NElementEvent:
    template genEventProcs(ev: untyped) =
      proc `on ev`*(this: NElement, action: NEventProc) =
        onEvent(this, `ne ev`, action)
      template `on ev Do`*(e: NElement, action: untyped) =
        closureScope:
          let this {.inject, used.} = `e`
          onEvent(this, `ne ev`, proc {.closure.} =
            let event {.inject, used.} = ngui.currentEvent()
            `action`
          )

    let evName = ident(system.`$`(e)[2..^1])
    result.add getAst(genEventProcs(evName))

genAllSetEventProcs()

proc `of`*(this: NElement, that: NElementKind): bool =
  macro genOfProc: untyped =
    result = newStmtList()
    for k in NElementKind:
      if k == neKindInvalid: continue
      let (k, t) = (ident(system.`$`(k)), ident($k))
      result.add quote do:
        if that == `k`: return this of `t`

  genOfProc()


# APP -------------------------------------------
proc getApp*: App =
  result = pApp
  doAssert result != nil
    
proc app*(): App =
  doAssert pApp == nil
  result = internalNewApp()
  pApp = result

proc run*(this: App) =
  doAssert(not init)
  init = true
  internalRun(this)

proc `[]`*(this: App, index: int): Window =
  Window(internalGetChild(this, index))
proc `[]`*(this: App, index: BackwardsIndex): Window =
  Window(internalGetChild(this, this.internalLen - int(index))) 


# WINDOW ----------------------------------------
proc window*(text: string = "NGUI"): Window =
  result = internalNewWindow()
  internalSetText(result, text)
  
proc text*(this: Window): string = internalGetText(this)
proc `text=`*(this: Window, text: string) = internalSetText(this, text)

proc resizable*(this: Window): bool = internalGetResizable(this)
proc `resizable=`*(this: Window, state: bool) =
  internalSetResizable(this, state)

proc position*(this: Window): tuple[x, y: int] = internalGetPosition(this)
proc `position=`*(this: Window, position: tuple[x, y: int]) =
  internalSetPosition(this, position)
  
proc x*(this: Window): int = this.position.x
proc y*(this: Window): int = this.position.y
proc `x=`*(this: Window, x: int) =
  var p = this.position
  p.x = x
  this.position = p

proc `y=`*(this: Window, y: int) =
  var p = this.position
  p.y = y
  this.position = p

proc focused*(this: Window): NElement = internalGetFocused(this)

proc icon*(this: Window): Bitmap = internalGetIcon(this)
proc `icon=`*(this: Window, that: Bitmap) = internalSetIcon(this, that)

proc decorated*(this: Window): bool = internalGetDecorated(this)
proc `decorated=`*(this: Window, v: bool) = internalSetDecorated(this, v)

proc minimized*(this: Window): bool = internalGetMinimized(this)
proc maximized*(this: Window): bool = internalGetMaximized(this)

proc `minimized=`*(this: Window, v: bool) = internalSetMinimized(this, v)
proc `maximized=`*(this: Window, v: bool) = internalSetMaximized(this, v)

proc `[]`*(this: Window, index: int): Container =
  Container(internalGetChild(this, index))
proc `[]`*(this: Window, index: BackwardsIndex): Container =
  Container(internalGetChild(this, this.internalLen - int(index))) 


# NALERT ----------------------------------------
proc alert*(parent: Window, text: string) =
  internalRun(internalNewAlert(parent, text))

proc alert*(text: string) = alert(pApp[0], text)


# LABEL -----------------------------------------
proc label*(text: string = ""): Label =
  result = internalNewLabel()
  internalSetText(result, text)
  
proc text*(this: Label): string = internalGetText(this)
proc `text=`*(this: Label, text: string) = internalSetText(this, text)

proc wrap*(this: Label): bool = internalGetWrap(this)
proc `wrap=`*(this: Label, state: bool) = internalSetWrap(this, state)

proc xAlign*(this: Label): float = internalGetXAlign(this)
proc YAlign*(this: Label): float = internalGetYAlign(this)

proc `xAlign=`*(this: Label, v: float) = internalSetXAlign(this, v)
proc `yAlign=`*(this: Label, v: float) = internalSetYAlign(this, v)


# ENTRY -----------------------------------------
proc entry*(text: string = ""): Entry =
  result = internalNewEntry()
  internalSetText(result, text)

proc text*(this: Entry): string = internalGetText(this)
proc `text=`*(this: Entry, text: string) = internalSetText(this, text)
  

# BUTTON ----------------------------------------
proc button*(text: string = "", onEventClick: NEventProc = nil): Button =
  result = internalNewButton()
  internalSetText(result, text)
  if onEventClick != nil: result.onClick(onEventClick)

proc button*(img: Bitmap, onEventClick: NEventProc = nil): Button =
  result = internalNewButton()
  internalSetImage(result, img)
  if onEventClick != nil: result.onClick(onEventClick)

proc button*(icon: NIcon, onEventClick: NEventProc = nil): Button =
  button(internalIconBitmap(icon), onEventClick)

template button*(text: string, onEventClickDo: untyped): Button =
  block:
    let button = button(text)
    button.onClickDo(onEventClickDo)
    button

proc text*(this: Button): string = internalGetText(this)
proc `text=`*(this: Button, text: string) = internalSetText(this, text)

proc img*(this: Button): Bitmap = internalGetImage(this)
proc `img=`*(this: Button, img: Bitmap) = internalSetImage(this, img)


# RADIO -----------------------------------------
proc radio*(text: string = ""): Radio =
  result = internalNewRadio()
  if text != "": internalSetText(result, text)

proc text*(this: Radio): string = internalGetText(this)
proc `text=`*(this: Radio, text: string) = internalSetText(this, text)
  
proc group*(list: varargs[Radio]) = internalSetGroup(list)


# BUBBLE ----------------------------------------
proc bubble*(text: string = ""): Bubble =
  result = internalNewBubble()
  if text != "": internalAdd(result, label(text))

proc bubble*(child: NElement): Bubble =
  result = internalNewBubble()
  internalAdd(result, child)

proc attach*(this: Bubble, that: NElement) =
  internalAttach(this, that)


proc later*(event: NEventProc, ms: int) # FD

proc attach*(this: Bubble, that: NElement, destroyAfterMs: int) =
  attach(this, that)
  later(proc() = tryDestroy(this), destroyAfterMs)


# IMAGE -----------------------------------------

# BITMAP --------------------
proc bitmap*(file: string): Bitmap =
  result = internalNewBitmap(file)

proc bitmap*(icon: NIcon): Bitmap =
  result = internalIconBitmap(icon)
  
proc `[]`*(this: Bitmap, i: int): Pixel {.inline.} =
  this.pixels[i]
  
proc `[]=`*(this: Bitmap, i: int, p: Pixel) {.inline.} =
  this.pixels[i] = p

proc `[]`*(this: Bitmap, x, y: int): Pixel {.inline.} =
  this[(y * this.width + x)]
  
proc `[]=`*(this: Bitmap, x, y: int, p: Pixel) {.inline.} =
  this[(y * this.width + x)] = p
  
proc `[]`*(this: Bitmap, point: tuple[x, y: int]): Pixel {.inline.} =
  this[point.x, point.y]

proc `[]=`*(this: Bitmap, point: tuple[x, y: int], p: Pixel) {.inline.} =
  this[point.x, point.y] = p

proc width*(this: Bitmap): int = this.width
proc height*(this: Bitmap): int = this.height
proc size*(this: Bitmap): tuple[w, h: int] = (w: this.width, h: this.height)
proc len*(this: Bitmap): int = this.width * this.height

iterator items*(this: Bitmap): Pixel =
  for i in 0 ..< this.height * this.width: yield this[i]

iterator mitems*(this: Bitmap): var Pixel =
  for i in 0 ..< this.height * this.width: yield this.pixels[i]

iterator pairs*(this: Bitmap): (int, Pixel) =
  for i in 0 ..< this.height * this.width: yield (i, this[i])

iterator mpairs*(this: Bitmap): (int, var Pixel) =
  for i in 0 ..< this.height * this.width: yield (i, this[i])

proc forEach*(this: Bitmap, action: (proc(p: Pixel): Pixel)) =
  for p in mitems(this): p = action(p)

proc copy*(this: Bitmap): Bitmap = internalCopy(this)

proc save*(this: Bitmap, path, format: string): bool =
  internalSave(this, path, format)

proc save*(this: Bitmap, path: string): bool =
  save(this, path, splitFile(path).ext[1..^1])

proc save*(this: Bitmap): bool =
  doAssert this.path != "", "Error: Bitmap doesn't have a path assigned"
  return save(this, this.path)

# NElement ------------------
proc image*: Image =
  result = internalNewImage(nil)

proc image*(bitmap: Bitmap): Image =
  result = internalNewImage(bitmap)
  
proc image*(file: string): Image = image(bitmap(file))

proc update*(this: Image) = internalUpdate(this, internalGetBitmap(this))
proc `bitmap=`*(this: Image, that: Bitmap) = internalUpdate(this, that)
proc bitmap*(this: Image): Bitmap = internalGetBitmap(this)

  
# TEXT_AREA -------------------------------------
proc textArea*(text: string = ""): TextArea =
  result = internalNewTextArea()
  if text != "": internalSetText(result, text)

proc text*(this: TextArea): string = internalGetText(this)
proc `text=`*(this: TextArea, text: string) = internalSetText(this, text)


# CALENDAR --------------------------------------
proc calendar*(
    date: DateTime = now(), onChangeEvent: NEventProc = nil): Calendar =
  result = internalNewCalendar()
  internalSetDate(result, date)
  if onChangeEvent != nil: result.onChange(onChangeEvent)

proc `selected=`*(this: Calendar, date: DateTime) =
  internalSetDate(this, date)

proc `selected`*(this: Calendar): DateTime =
  internalGetDate(this)

proc mark*(this: Calendar, dayOfMonth: int) =
  internalMark(this, dayOfMonth)
proc unmark*(this: Calendar, dayOfMonth: int) =
  internalUnmark(this, dayOfMonth)
proc marked*(this: Calendar, dayOfMonth: int): bool =
  internalMarked(this, dayOfMonth)
proc clear*(this: Calendar) = internalClear(this)


# SLIDER ----------------------------------------
proc slider*(
    range: Slice[float] = 1.0 .. 100.0,
    value: float = 0,
    orientation: NOrientation = noHORIZONTAL,
    decimals: int = 0,
    step: float = 1): Slider =
  result = internalNewSlider()
  internalSetRange(result, range)
  internalSetValue(result, value)
  internalSetStep(result, step)
  internalSetDecimals(result, decimals)
  internalSetOrientation(result, orientation)

#proc range*(this: Slider): Slice[float] =
#  internalGetRange(this)
proc `range=`*(this: Slider, range: Slice[float]) =
  internalSetRange(this, range)

proc value*(this: Slider): float = internalGetValue(this)
proc `value=`*(this: Slider, value: float) = internalSetValue(this, value)

proc `step=`*(this: Slider, step: float) = internalSetStep(this, step)

proc decimals*(this: Slider): int = internalGetDecimals(this)
proc `decimals=`*(this: Slider, decimals: int) =
  internalSetDecimals(this, decimals)

proc orientation*(this: Slider): NOrientation =
  internalGetOrientation(this)
proc `orientation`*(this: Slider, value: NOrientation) =
  internalSetOrientation(this, value)


# FILECHOOSE ------------------------------------
proc fileChoose*(button: string, buttons: varargs[string]): FileChoose =
  result = internalNewFileChoose()
  internalSetButton(result, button, 0)
  for i, button in buttons: internalSetButton(result, button, i + 1)

proc run*(this: FileChoose): int = internalRun(this)

proc multiple*(this: FileChoose): bool =
  internalGetMultiple(this)

proc `multiple=`*(this: FileChoose, state: bool) =
  internalSetMultiple(this, state)

proc text*(this: FileChoose): string = internalGetText(this)
proc `text=`*(this: FileChoose, text: string) = internalSetText(this, text)
  
proc files*(this: FileChoose): seq[string] =
  internalGetFiles(this)

proc file*(this: FileChoose): string =
  let files = this.files
  if len(files) > 0: return files[0]


# CHECKBOX --------------------------------------
proc checkbox*(text: string = "", checked: bool = false): Checkbox =
  result = internalNewCheckBox()
  internalSetChecked(result, checked)
  if text != "": internalSetText(result, text)

proc text*(this: Checkbox): string = internalGetText(this)
proc `text=`*(this: Checkbox, text: string) = internalSetText(this, text)
proc checked*(this: Checkbox): bool = internalGetChecked(this)
proc `checked=`*(this: Checkbox, v: bool) = internalSetChecked(this, v)


# CONTAINER -------------------------------------
proc addSeparator*(this: Container) =
  var o: NOrientation
  
  if this of App or this of Window:
    addSeparator(internalGetChild(this, 0).Container)
    return

  elif this of Box:
    o = Box(this).internalGetOrientation

  elif this of Menu or this of Tools:
    discard # Not used

  else:
    raiseAssert("Can't add separator to container of kind " & $this.kind)
  
  internalAddSeparator(this, o)
  
proc add*(this: Container, that: NElement) =
  if that.id == NSEPARATOR.id: this.addSeparator()
  else:                        this.internalAdd(that)

proc add*(this: Container, text: string) = this.add(label(text))

proc add*(this: Container, one, two: NElement, list: varargs[NElement]) =
  # Edge case: I want to add one box and some elements AFTER said box
  # TODO: if this of Window/App ?
  if one of Container: this.add(internalNewBox())
  
  this.add(one)
  this.add(two)
  for that in list: this.add(that)

proc add*[N: NElement](this: Container, list: openArray[N]) =
  for that in list: this.add(that)

proc remove*(this: Container, that: NElement) =
  internalRemove(this, that)

proc len*(this: Container): int = internalLen(this)

proc replace(container: Container, this, that: NElement) =
  internalReplace(container, this, that)

proc `[]`*(this: Container, index: int): NElement =
  internalGetChild(this, index)
proc `[]`*(this: Container, index: BackwardsIndex): NElement =
  internalGetChild(this, this.len - int(index))

iterator items*(this: Container): NElement =
  for i in 0 ..< this.len: yield this[i]

proc index*(this: Container, that: NElement): int =
  internalIndex(this, that)
  
proc pop*(this: Container): NElement = internalRemove(this, this[^1])

proc shift*(this: Container): NElement = internalRemove(this, this[0])

proc border*(this: Container): NBorder = internalGetBorder(this)

proc `border=`*(this: Container, border: NBorder) =
  internalSetBorder(this, border)

proc `border=`*(this: Container, b: int) =
  internalSetBorder(this, [b, b, b, b])

proc border*(top, bottom, left, right: int): NBorder =
  [top, bottom, left, right]

proc borderColor*(this: Container): Pixel =
  internalGetBorderColor(this)
proc `borderColor=`*(this: Container, color: Pixel) =
  internalSetBorderColor(this, color)


# BAR -------------------------------------------
proc bar*(): Bar =
  result = internalNewBar()

#proc add*(this: Bar, label: NElement, menu: Menu) =
  #internalAdd()
  

# MENU ------------------------------------------
proc menu*(): Menu =
  result = internalNewMenu()
  
proc add*(this: NElement, that: Menu) =
  handleMenuBarAdd(this, that)


# COMBOBOX --------------------------------------
proc add*(this: ComboBox, text: string, selected: bool = false) =
  internalAdd(this, text)
  if selected: internalSetSelectedIndex(this, internalLen(this) - 1)

proc comboBox*(textList: varargs[string], selected: int = -1): ComboBox =
  result = internalNewComboBox()
  for text in textList: result.add(text)
  internalSetSelectedIndex(result, selected)

proc `[]=`*(this: ComboBox, i: int, text: string) = internalSet(this, text, i)
proc `[]`*(this: ComboBox, i: int): string = internalGet(this, i)

proc selected*(this: ComboBox): string = internalGetSelected(this)

proc index*(this: ComboBox): int = internalGetSelectedIndex(this)


# PROGRESS --------------------------------------
proc progress*(v: float = 0.0): Progress =
  result = internalNewProgress()
  internalValue(result, v)

proc value*(this: Progress): float = internalValue(this)
proc `value=`*(this: Progress, v: float) = internalValue(this, v)


#  BOX ------------------------------------------
proc box*(
    elements: openArray[NElement],
    orientation: NOrientation = noVERTICAL,
    spacing: int = 0): Box =

  result = internalNewBox()
  internalSetOrientation(result, orientation)
  internalSetSpacing(result, spacing)
  for e in elements: result.add(e)

proc box*(elements: varargs[NElement]): Box = box(elements, noVERTICAL, 0)
proc vbox*(children: varargs[NElement]): Box = box(children, noVERTICAL, 0)
proc hbox*(children: varargs[NElement]): Box = box(children, noHORIZONTAL, 0)

proc orientation*(this: Box): NOrientation =
  internalGetOrientation(this)
proc `orientation=`*(this: Box, value: NOrientation) =
  internalSetOrientation(this, value)

proc add*(this: Box, that: NElement, expand, fill: bool, padding: int) =
  internalAdd(this, that, expand, fill, padding)


# TABLE -----------------------------------------
proc table*(): NTable =
  result = internalNewTable()

proc addRow(this: NTable, values: varargs[NTableCell]) =
  var
    list {.global.}: seq[NTableCell]
    row: NTableRow

  setLen(list, 0)
  for v in values: list.add(v)
  row.list = cast[ptr[UncheckedArray[NTableCell]]](list[0].addr)
  row.len  = len(list)
  internalAdd(this, row)
  
proc headers*(this: NTable): bool = internalHeaders(this)
proc `headers=`*(this: NTable, v: bool) = internalHeaders(this, v)

proc th*(this: NTable, values: varargs[string]) = internalHeader(this, values)

macro tr*(this: NTable, values: varargs[typed]) =
  template call(f) = addRow(f)
  template row(f) = toCell(f)
  
  result = getAst(call(this))
  for v in values: result.add(getAst(row(v)))

template head*(this: NTable, values: varargs[string]) = th(this, values)
template row*(this: NTable, values: varargs[untyped]) = tr(this, values)

template `[]=`*(this: NTable, x, y: int, that: typed) =
  internalSet(this, toCell(that), x, y)

template `[]=`*(this: NTable, p: tuple[x, y: int], that: typed) =
  internalSet(this, toCell(that), p[0], p[1])

template cell*(this: NTable, x, y: int, body: untyped) =
  block:
    let c = internalGet(this, x, y)

    template ofImg(v, op: untyped) {.used.} =
      if c.kind == ckImg:
        let `v` = c.vImg
        op
    template ofStr(v, op: untyped) {.used.} =
      if c.kind == ckStr:
        let `v` = c.vStr
        op
    template ofBool(v, op: untyped) {.used.} =
      if c.kind == ckBool:
        let `v` = c.vBool
        op

    body

template cell*(this: NTable, p: tuple[x, y: int], body: untyped) =
  cell(this, p[0], p[1], body)


# GRID ------------------------------------------
proc add*(
    this: Grid,
    that: NElement,
    row: int = -1,
    column: int = 0,
    width: int = 1,
    height: int = 1) =

  let row = if row == -1: internalLen(this) else: row
  internalAdd(this, that, row, column, width, height)

proc add*(
    this: Grid,
    elements: openArray[NElement],
    row: int = -1,
    firstColumn: int = 0,
    width: int = 1,
    height: int = 1) =
  let row = if row == -1: internalLen(this) else: row
  for i, element in elements:
    this.add(element, row, firstColumn + i, width, height)

proc grid*(
    elements: varargs[NElement],
    row: int = -1,
    firstColumn: int = 0,
    width: int = 1,
    height: int = 1): Grid =
  result = internalNewGrid()
  result.add(elements, row, firstColumn, width, height)


# TAB -------------------------------------------
proc tab*(): Tab =
  result = internalNewTab()

proc add*(this: Tab, that: Container, label: Label) =
  internalAdd(this, that, label)

proc reorderable*(this: Tab): bool = internalGetReorderable(this)
proc `reorderable=`*(this: Tab, v: bool) = internalSetReorderable(this, v)

proc side*(this: Tab): NSide = internalGetSide(this)
proc `side=`*(this: Tab, side: NSide) = internalSetSide(this, side)

#proc index*(this: Tab, that: Container): int =
  #internalIndex(this, that)


# LIST ------------------------------------------
proc list*(mode: NAmount = naOne): List =
  result = internalNewList()
  internalSetMode(result, mode)

proc mode*(this: List): NAmount = internalGetMode(this)
proc `mode=`*(this: List, mode: NAmount) = internalSetMode(this, mode)

proc sort*(this: List, cmp: NCMPPRoc) = internalCmp(this, cmp)

proc selected*(this: List, that: var seq[NElement]) =
  internalSelected(this, that)

proc selected*(this: List): seq[NElement] = selected(this, result)


# FRAME -----------------------------------------
proc frame*(text: string, list: varargs[NElement]): Frame =
  result = internalNewFrame()
  if text != "": internalSetText(result, text)
  for element in list: result.add(element)

proc frame*(list: varargs[NElement]): Frame =
  frame("", list)

proc text*(this: Frame): string = internalGetText(this)
proc `text=`*(this: Frame, text: string) = internalSetText(this, text)


# TOOLS -----------------------------------------
proc tools*: Tools =
  result = internalNewTools()

proc orientation*(this: Tools): NOrientation =
  internalGetOrientation(this)
proc `orientation=`*(this: Tools, value: NOrientation) =
  internalSetOrientation(this, value)


# ATTRIBUTE -------------------------------------
proc get*(this: NElement, that: NElementAttribute): Attribute =
  result = Attribute(kind: that, found: false)
  template g(n, v) =
    result.n     = v
    result.found = true
  template gt(t: typedesc, n, v: untyped) =
    if this of t:
      result.n     = t(this).v
      result.found = true

  case that:
  of naKind:        g(aKind, this.kind)
  of naBGColor:     g(aBGColor, this.bgColor)
  of naName:
    if this in names: g(aName, names[this])
  of naIndex:       g(aIndex, this.index)
  of naHasParent:   g(aHasParent, this.hasParent)
  of naFocus:       g(aFocus, this.focused)
  of naSize:        g(aSize, this.size)
  of naOpacity:     g(aOpacity, this.opacity)
  of naVisible:     g(aVisible, internalGetVisible(this))
  of naMaximized:   gt(Window, aMaximized, internalGetMaximized)
  of naMinimized:   gt(Window, aMinimized, internalGetMinimized)
  of naLen:         gt(Container, aLen, internalLen)
  of naReorderable: gt(Tab, aReorderable, internalGetReorderable)
  of naSide:        gt(Tab, aSide, internalGetSide)
  of naOrientation:
    template gt(t) = gt(t, aOrientation, internalGetOrientation)
    gt(Box); gt(Slider); gt(Tools)
  of naText:
    template gt(t) = gt(t, aText, internalGetText)
    gt(Window); gt(Button); gt(Label); gt(Radio); gt(Entry);
  of naWrap:      gt(Label, aWrap, internalGetWrap)
  of naResizable: gt(Window, aResizable, internalGetResizable)
  of naValue:
    if this of Slider:
      let v = internalGetValue(Slider(this))
      g(aValue, (int(v), v))

proc has*(this: NElement, that: NElementAttribute): bool =
  get(this, that).found

proc set*(this: NElement, that: Attribute) =
  template s(t, p: typed, v: untyped) =
    if this of t: t(this).p(v)
  template s(p: typed, v: untyped) =
    this.p(v)
  
  case that.kind:
  of naVisible:     s(internalSetVisible, that.aVisible)
  of naBGColor:     s(internalSetBGColor, that.aBGColor)
  of naFocus:       this.internalSetFocus()
  of naName:        this.name = that.aName
  of naSize:        s(internalSetSize, that.aSize)
  of naOpacity:     s(internalSetOpacity, that.aOpacity)
  of naValue:       s(Slider, internalSetValue, that.aValue.vFloat)
  of naText:        s(Label, internalSetText, that.aText)
  of naMinimized:   s(Window, internalSetMinimized, that.aMinimized)
  of naMaximized:   s(Window, internalSetMaximized, that.aMaximized)
  of naReorderable: s(Tab, internalSetReorderable, that.aReorderable)
  of naSide:        s(Tab, internalSetSide, that.aSide)
  of naOrientation:
    s(Box,    internalSetOrientation, that.aOrientation)
    s(Slider, internalSetOrientation, that.aOrientation)
    s(Tools,  internalSetOrientation, that.aOrientation)
  of naLen:
    if this of Container:
      let this = Container(this)
      while that.aLen < internalLen(this):
        discard this.pop
  of naKind, naHasParent:
    raiseAssert("Can't change this value: " & $that.kind)
  else:
    raiseAssert("Not Implemented: " & $that.kind)

proc attributes*(this: NElement): Attributes =
  for attrKind in NElementAttribute:
    result[attrKind] = this.get(attrKind)

proc `$`*(this: Attribute): string =
  if not this.found: return "[" & $this.kind & "] NOT FOUND"
  let s = system.`$`(this)
  return s[(s.find(", a") + 3) .. (s.find(", found:") - 1)]

proc `$`*(this: NElement): string =
  let attrs = attributes(this)
  result = $attrs[naKind].aKind & "("
  
  for kind, attr in attrs:
    if not attr.found: continue
    if kind == naKind: continue
    result &= $attr & ", "

  setLen(result, len(result) - 2)
  result &= ")"

proc element*(kind: NElementKind): NElement =
  case kind:
  # VALID
  of neApp:        app()
  of neWindow:     window()
  of neBox:        box()
  of neList:       list()
  of neGrid:       grid()
  of neTab:        tab()
  of neMenu:       menu()
  of neBar:        bar()
  of neFrame:      frame()
  of neRadio:      radio()
  of neButton:     button()
  of neComboBox:   comboBox()
  of neCalendar:   calendar()
  of neImage:      image()
  of neProgress:   progress()
  of neTextArea:   textArea()
  of neLabel:      label()
  of neEntry:      entry()
  of neSlider:     slider()
  of neCheckBox:   checkbox()
  of neTable:      table()
  of neTools:      tools()
  of neBubble:     bubble()
  # INVALID
  of neAlert, neFileChoose, neContainer, neAtom, neKindInvalid:
    raiseAssert("Can't create element of " & $kind & " using this method")

proc element*(this: Attributes): NElement =
  result = element(this[naKind].aKind)
  for attrKind in NElementAttribute:
    if attrKind == naKind: continue
    let attr = this[attrKind]
    if attr.found: result.set(attr)  

# proc toJson*(this: Attributes | NElement): JSonNode
# proc toNElement*(this: JSonNode): NElement


# TIMERS ----------------------------------------
proc repeat*(event: NRepeatProc, ms: int): NRepeatHandle =
  internalRepeat(event, ms)

proc setTime*(this: var NRepeatHandle, ms: int) = internalSetTime(this, ms)

proc stop*(this: NRepeatHandle) = internalStop(this)

template repeatDo*(ms: int, body: untyped): NRepeatHandle =
  block:
    var h: NRepeatHandle
    
    closureScope:    
      template setTime(newMs: int) {.used.} = setTime(h, newMs)
      template stop {.used.} = return false
      h = repeat((proc: bool = (result = true; body)), ms)

    h

proc later*(event: NEventProc, ms: int) =
  discard repeatDo ms:
    event()
    return false

template laterDo*(ms: int, body: untyped) =
  later(proc(){.closure.} = body, ms)


# CLIPBOARD -------------------------------------
proc clipboardClear* = internalClipboardClear()
proc clipboardSet*(text: string) = internalClipboardSet(text)
proc clipboardSet*(img: Bitmap) = internalClipboardSet(img)
proc clipboardGetText*: string = internalClipboardGetText()
proc clipboardGetBitmap*: Bitmap = internalClipboardGetImg()
proc clipboardAsyncGet*(action: NAsyncTextProc) =
  internalClipboardAsyncGet(action)
proc clipboardAsyncGet*(action: NAsyncBitmapProc) =
  internalClipboardAsyncGet(action)
