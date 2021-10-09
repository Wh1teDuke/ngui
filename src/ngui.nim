import std/[strutils, hashes, tables, times, sequtils, os]
import utils/stb

type pointer      = system.pointer
type STable[A, B] = tables.Table[A, B]


# Increment if someone complains
const version* = 0 ## Bugs counter, nothing to see here.


# TYPES -----------------------------------------
type
  NOrientation* = enum
    noHORIZONTAL noVERTICAL
  
  NSide* = enum
    nsTop nsBottom nsLeft nsRight
  
  NAmount* = enum # TODO: NSelection
    naNone naMinOne naOne naMultiple
  
  NID* = uint32

  NElementKind* = enum
    neKindInvalid
    # Important
    neApp neWindow
    # Containers
    neContainer neBubble
    neBox neComboBox neCalendar
    neTab neList neTable neTools
    neMenu neBar neTree
    # Atomic Elements
    neAtom
    neCheckBox
    neRadio neLabel neEntry neButton neAlert neImage
    neProgress neTextArea neSlider neFileChoose
    # TODO neFileChoose -> neFileBrowser

  NElementEvent* = enum
    # TODO: neRUN, neSTOP
    neNONE neCLICK neCLICK_RELEASE neMOVE
    neENTER neCHANGE neOPEN
    neFOCUS_ON neFOCUS_OFF neDESTROY
    neSHOW neHIDE neKEY_PRESS neKEY_RELEASE
    neFILE_CHOOSE_ACCEPT

  NKey* = enum
    nkNone nkEsc nkControl nkShift nkEnter
     nkA nkB nkC nkD nkE nkF nkG nkH nkI nkJ nkK nkL nkM nkN nkO nkP nkQ
     nkR nkS nkT nkU nkV nkW nkX nkY nkZ
     nk0 nk1 nk2 nk3 nk4 nk5 nk6 nk7 nk8 nk9

  NMouse* = enum
    nm1 nm2 nm3

  NElement* = ref object of RootObj
    id: NID
    kind: NElementKind

  # CONTAINERS ----------------------------------
  Container* = ref object of NElement
  Bubble* = ref object of Container
    ## .. image:: ../assets/bubble.png
  
  Box* = ref object of Container
    ## .. image:: ../assets/box.png
  
  App* = ref object of Container # TODO: Do not inherate from Container
  
  Window* = ref object of Container
    ## .. image:: ../assets/window.png

  ComboBox* = ref object of Container  # Todo: allow only images/text. Change type to Atom
    ## .. image:: ../assets/combo.png
  
  Tab* = ref object of Container
    ## .. image:: ../assets/tabs_progress_list.png
  
  List* = ref object of Container # Todo: allow only images/text. Change type to Atom
    ## .. image:: ../assets/list.png
  
  Tools* = ref object of Container
    ## .. image:: ../assets/tools.png
  
  Table* = ref object of Container # TODO See list
    ## .. image:: ../assets/table_bubble.png
  
  NTable* = Table
  
  Bar* = ref object of Container
    ## .. image:: ../assets/calendar_menu.png

  Menu* = ref object of Container
    ## .. image:: ../assets/calendar_menu.png
    
  Tree* = ref object of Container # TODO See Table


  # ATOMS ---------------------------------------
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
    img:  seq[Pixel]
    w, h: int
    #data: pointer
    path: string

  Pixel* = object
    r*, g*, b*, a*: uint8

  NElementAttribute* = enum
    naMinimized naMaximized
    naKind naVisible naHasParent naFocus naSize naOpacity
    naLen naText naToolTip naWrap naResizable naValue naOrientation
    naIndex naReorderable naName naSide naBGColor naBorderColor
    naBorder
    naModal naTransient naMode naDate naRange naStep naDecimals
    naSelected naScrolled naHeader naHeaders naRows naSelectedCells
    naImg

  Attribute* = object
    case kind*:       NElementAttribute
    of naKind:        aKind*: NElementKind
    of naText:        aText*: string
    of naToolTip:     aToolTip*: string
    of naName:        aName*: string
    of naVisible:     aVisible*: bool
    of naWrap:        aWrap*: bool
    of naDate:        aDate*: DateTime
    of naResizable:   aResizable*: bool
    of naHasParent:   aHasParent*: bool
    of naFocus:       aFocus*: bool
    of naSize:        aSize*: tuple[w, h: int]
    of naValue:       aValue*: tuple[vInt: int, vFloat: float]
    of naRange:       aRange*: Slice[float]
    of naStep:        aStep*: float
    of naOpacity:     aOpacity*: float
    of naLen:         aLen*: int
    of naDecimals:    aDecimals*: int
    of naMinimized:   aMinimized*: bool
    of naMaximized:   aMaximized*: bool
    of naOrientation: aOrientation*: NOrientation
    of naIndex:       aIndex*: int
    of naSelected:    aSelected*: int
    of naReorderable: aReorderable*: bool
    of naSide:        aSide*: NSide
    of naBGColor:     aBGColor*: Pixel
    of naBorder:      aBorder*: int
    of naBorderColor: aBorderColor*: Pixel
    of naModal:       aModal*: bool
    of naMode:        aMode*: NAmount
    of naTransient:   aTransient*: Window
    of naScrolled:    aScrolled*:  bool
    of naHeader:      aHeader: seq[tuple[kind: NCellKind, name: string]]
    of naHeaders:     aHeaders: bool
    of naRows:        aRows: seq[NRow]
    of naSelectedCells:aSelectedCells: seq[tuple[x, y: int]]
    of naImg:         aImg: Bitmap
    found*:           bool
    
  Attributes* = array[NElementAttribute, Attribute]
  
  NEventArgs* = object
    element*: NElement
    case kind*: NElementEvent:
    of neClick, neClickRelease, neMove:
      mouse*: set[NMouse]
      x*, y*: int
      selected*: int
      double*: bool
    of neChange:
      index*: int
    of neKeyPress, neKeyRelease:
      mods*: set[NKey]
      key*: NKey
    of neFILE_CHOOSE_ACCEPT:
      files*: seq[string]
    else:
      discard
  
  NEventProc* = (proc(){.closure.})
  NCMPPRoc* = (proc(a, b: NElement): int)
  
  NAsyncTextProc* = (proc(text: string) {.closure.})
  NAsyncBitmapProc* = (proc(bitmap: Bitmap) {.closure.})
  NRepeatProc* = (proc(): bool {.closure.})
  NRepeatHandle* = distinct int # TODO: Ref object

  NCellKind* = enum ckImg ckBool ckStr ckInt
  
  NCell* = object
    case kind: NCellKind:
    of ckBool: vBool*: bool
    of ckImg:  vImg*:  Bitmap
    of ckStr:  vStr*:  string
    of ckInt:  vInt*:  int
  
  NRow* = ref object
    cells*:    seq[NCell]
    children*: seq[NRow]



proc `$`*(this: NElementKind): string = system.`$`(this)[2..^1]
proc hash*(this: NElement): Hash = hash(this.id)
proc hash*(this: Bitmap): Hash = hash(cast[pointer](this))
proc hash*(this: NRepeatHandle): Hash = hash(int(this))
proc `==`*(this, that: NRepeatHandle): bool {.borrow.}

var
  tags:  STable[NElement, STable[string, string]]
  names: STable[NElement, string]

let # TODO: const when implementation works
  NSEPARATOR* = NElement(kind: neKindInvalid, id: 5) ## Pseudoelement

const
  nmLEFT*   = nm1 ## Alias for nm1
  nmMIDDLE* = nm2 ## Alias for nm2
  nmRIGHT*  = nm3 ## Alias for nm3
  # TODO: FEATURE = [NElementKind, set[NElementAttribute and NElementEvent]]

include backends/ngui_backend


# NElement --------------------------------------
proc tag*(this: NElement, key: string): string =
  ## Return the value for this key attached to this element or ""
  tags.withValue(this, elementTags):
    return getOrDefault(elementTags[], key)

proc `tag=`*(this: NElement, tag: tuple[key, value: string]) =
  ## Attach a key-value string pair to this element
  tags[this][tag.key] = tag.value

proc `[]=`*(this: NElement, key, value: string) =
  ## Attach a key-value string pair to this element
  this.tag = (key, value)

proc `[]=`*(this: NElement, key: string): string =
  tag(this, key)

proc name*(this: NElement): string =
  ## Get this element's name or ""
  getOrDefault(names, this, "")

proc `name=`*(this: NElement, name: string) =
  ## Set a name for this element
  names[this] = name

proc named*[N: NElement](this: N, name: string): N =
  ## Set a name for this element and return it
  this.name = name
  return this

proc element*(name: string): NElement =
  ## Retrieves NElement by name or nil if no element with that name exists
  for e, n in pairs(names):
    if n == name: return e

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
  ## Destroy and return true only if this element is still alive
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

proc prev*(this: NElement): NElement =
  ## Get the previous element in this element's parent list of children or nil
  internalGetPrev(this)

proc index*(this: NElement): int =
  ## Return the position of this element in its parent's children list or -1
  ## If is not inside a `Container`
  if this.hasParent: internalIndex(this.parent, this) else: -1

proc bgColor*(this: NElement): Pixel =
  internalGetBGColor(this)
proc `bgColor=`*(this: NElement, color: Pixel) =
  internalSetBGColor(this, color)

proc supports*(element: NElementKind, event: NElementEvent): bool =
  discard

proc supports*(element: NElementKind, attribute: NElementAttribute): bool =
  discard

proc currentEvent*(): NEventArgs =
  ## Get current event's argument object
  internalGetCurrentEvent()

proc eventHandled*() =
  ## Stop propagating the event that is being currently processed
  internalEventHandled()

proc onEvent*(this: NElement, event: NElementEvent, action: NEventProc) =
  internalSetEvent(this, event, action)
  
proc trigger*(event: NEventArgs) =
  doAssert event.element != nil
  doAssert event.kind != neNONE
  internalTriggerEvent(event)

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
            let event {.inject, used.} = currentEvent()
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

proc nextID: NID =
  var pool {.global.}: NID = 100_000
  result = pool
  inc(pool)
  doAssert pool != 0, "Error: Too many NElements"
  
template nguiNew() {.dirty.} =
  const kind = parseEnum[NElementKind](
    if typeOf(result) is NTable: "neTable" else: "ne" & $(typeOf(result)))
  
  when kind != neAPP: doAssert initialized()
  result = typeOf(result)(kind: kind, id: nextID())
  internalInitNElement(NElement(result))

  when result is Window:
    internalSetText(
      result, changeFileExt(extractFilename(getAppFilename()), ""))

proc nguiNew[N: NElement](_: typedesc[N]): N = nguiNew()


# APP -------------------------------------------
var 
  pApp:  App
  pInit: bool
  pRun:  bool


proc requiredLibsInstalled*: bool =
  result = true
  for _, found in items testDependencies(backend):
    if not found: return false

proc initialized*: bool = pApp != nil
proc running*: bool = pApp != nil and pRun

proc shutdown*(this: App) =
  ## Stop and destroy the App context. You won't be able to reuse it.
  doAssert this != nil and pApp == this and pInit
  
  stop(this)
  pApp  = nil
  pInit = false
  pRun  = false
  # TODO: internal shutdown

proc getApp*: App =
  result = pApp
  doAssert result != nil

proc app*: App =
  ## Initialize the library and create the App context. This is the
  ## main container, which can contain one or more windows.
  ## You can only call this procedure once

  doAssert pApp == nil
  nguiNew()
  pApp = result
  pInit = true

proc run*(this: App) =
  ## Display any window and listen to user input
  doAssert(not pRun)
  pRun = true
  internalRun(this)

proc stop*(this: App) =
  ## Stop the GUI loop
  if pRun: internalStop(this)
  pRun = false
  
template startApp*(body: untyped) =
  block:
    let app {.inject.} = app()
    body
    run(app)

proc `[]`*(this: App, index: int): Window =
  Window(internalGetChild(this, index))
proc `[]`*(this: App, index: BackwardsIndex): Window =
  Window(internalGetChild(this, this.internalLen - int(index)))


# WINDOW ----------------------------------------
proc window*(text: string = "NGUI"): Window =
  nguiNew()
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

proc modal*(this: Window): bool = internalGetModal(this)
proc `modal=`*(this: Window, v: bool) = internalsetModal(this, v)
proc transient*(this: Window): Window = internalGetTransient(this)
proc `transient=`*(this, that: Window) = internalsetTransient(this, that)

proc opacity*(this: Window): float = internalGetOpacity(this)
proc `opacity=`*(this: Window, o: float) = internalSetOpacity(this, o)

proc `[]`*(this: Window, index: int): Container =
  Container(internalGetChild(this, index))
proc `[]`*(this: Window, index: BackwardsIndex): Container =
  Container(internalGetChild(this, this.internalLen - int(index)))


# NALERT ----------------------------------------
proc alert*(title: string = "", text: string = ""): Alert =
  nguiNew()
  if title != "": internalSetTitle(result, title)
  if text != "": internalSetText(result, text)

proc text*(this: Alert): string = internalGetText(this)
proc `text=`*(this: Alert, text: string) = internalSetText(this, text)

proc title*(this: Alert): string = internalGetTitle(this)
proc `title=`*(this: Alert, text: string) = internalSetTitle(this, text)

proc modal*(this: Alert): bool = internalGetModal(this)
proc `modal=`*(this: Alert, v: bool) = internalsetModal(this, v)
proc transient*(this: Alert): Window = internalGetTransient(this)
proc `transient=`*(this: Alert, that: Window) = internalsetTransient(this, that)

proc run*(this: Alert) = internalRun(this)


# LABEL -----------------------------------------
proc label*(text: string = ""): Label =
  nguiNew()
  internalSetText(result, text)
  
proc text*(this: Label): string = internalGetText(this)
proc `text=`*(this: Label, text: string) = internalSetText(this, text)

proc wrap*(this: Label): bool = internalGetWrap(this)
proc `wrap=`*(this: Label, state: bool) = internalSetWrap(this, state)


# ENTRY -----------------------------------------
proc entry*(text: string = ""): Entry =
  nguiNew()
  internalSetText(result, text)

proc text*(this: Entry): string = internalGetText(this)
proc `text=`*(this: Entry, text: string) = internalSetText(this, text)
  

# BUTTON ----------------------------------------
proc button*(text: string = "", onEventClick: NEventProc = nil): Button =
  nguiNew()
  internalSetText(result, text)
  if onEventClick != nil: result.onClick(onEventClick)

proc button*(img: Bitmap, onEventClick: NEventProc = nil): Button =
  doAssert img != nil # TODO: By default, display broken synmbol img
  
  nguiNew()
  internalSetImage(result, img)
  if onEventClick != nil: result.onClick(onEventClick)

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
  nguiNew()
  if text != "": internalSetText(result, text)

proc text*(this: Radio): string = internalGetText(this)
proc `text=`*(this: Radio, text: string) = internalSetText(this, text)
  
proc group*(list: varargs[Radio]) = internalSetGroup(list)


# BUBBLE ----------------------------------------
proc bubble*(text: string = ""): Bubble =
  nguiNew()
  if text != "": add(result, label(text))

proc bubble*(child: NElement): Bubble =
  nguiNew()
  add(result, child)

proc attach*(this: Bubble, that: NElement) =
  internalAttach(this, that)

proc attach*(this: Bubble, that: NElement, destroyAfterMs: int) =
  attach(this, that)
  later(proc() = tryDestroy(this), destroyAfterMs)


# IMAGE -----------------------------------------
# BITMAP --------------------
proc pixel*(r, g, b: uint8, a: uint8 = 255): Pixel {.inline.} = 
  Pixel(r: r, g: g, b: b, a: a)

proc pixel*(r, g, b: float, a: float = 1.0): Pixel {.inline.} =
  result.r = uint8(r * 255)
  result.g = uint8(g * 255)
  result.b = uint8(b * 255)
  result.a = uint8(a * 255)

proc newBitmap*(data: string): Bitmap =
  var x, y, chans: cint

  let buff = cast[ptr[UncheckedArray[Pixel]]](
    stbi_load_from_memory(
      data[0].unsafeAddr, data.len.cint, x, y, chans, 4))
  
  result = Bitmap(w: x.int, h: y.int)
  result.img.setLen(result.w * result.h)

  for i, p in mpairs(result.img): p = buff[i]
  stbi_image_free(cast[pointer](buff))

proc bitmap*(file: string): Bitmap =
  result = newBitmap(readFile(file))
  result.path = file

proc save*(this: Bitmap, path, format: string): bool =
  let
    fn        = cstring(path & format)
    (w, h, c) = (this.w.cint, this.h.cint, 4.cint)
    data      = this.img[0].unsafeAddr
  
  case format:
  of "png":         stbi_write_png(fn, w, h, c, data, 4 * w) != 0
  of "jpg", "jpeg": stbi_write_jpg(fn, w, h, c, data, 80) != 0
  of "bmp":         stbi_write_bmp(fn, w, h, c, data) != 0
  of "tga":         stbi_write_tga(fn, w, h, c, data) != 0
  else:             false

proc save*(this: Bitmap, path: string): bool =
  save(this, path, toLowerAscii(splitFile(path).ext[1..^1]))

proc save*(this: Bitmap): bool =
  doAssert this.path != "", "Error: Bitmap doesn't have a path assigned"
  return save(this, this.path)

proc width*(this: Bitmap): int {.inline.} = this.w
proc height*(this: Bitmap): int {.inline.} = this.h
proc size*(this: Bitmap): tuple[w, h: int] = (w: this.w, h: this.h)
proc len*(this: Bitmap): int = this.w * this.h
  
proc `[]`*(this: Bitmap, i: int): Pixel {.inline.} =
  this.img[i]
  
proc `[]=`*(this: Bitmap, i: int, p: Pixel) {.inline.} =
  this.img[i] = p

proc `[]`*(this: Bitmap, x, y: int): Pixel {.inline.} =
  this[(y * this.w + x)]
  
proc `[]=`*(this: Bitmap, x, y: int, p: Pixel) {.inline.} =
  this[(y * this.w + x)] = p
  
proc `[]`*(this: Bitmap, point: tuple[x, y: int]): Pixel {.inline.} =
  this[point.x, point.y]

proc `[]=`*(this: Bitmap, point: tuple[x, y: int], p: Pixel) {.inline.} =
  this[point.x, point.y] = p

iterator items*(this: Bitmap): Pixel =
  for i in 0 ..< this.h * this.w: yield this[i]

iterator mitems*(this: Bitmap): var Pixel =
  for i in 0 ..< this.h * this.w: yield this.img[i]

iterator pairs*(this: Bitmap): (int, Pixel) =
  for i in 0 ..< this.h * this.w: yield (i, this[i])

iterator mpairs*(this: Bitmap): (int, var Pixel) =
  for i in 0 ..< this.h * this.w: yield (i, this[i])

proc forEach*(this: Bitmap, action: (proc(p: Pixel): Pixel)) =
  for p in mitems(this): p = action(p)

proc copy*(this: Bitmap): Bitmap =
  result      = Bitmap()
  result.w    = this.w
  result.h    = this.h
  result.img  = this.img
  result.path = this.path


# NElement ------------------
proc image*(bitmap: Bitmap = nil): Image =
  nguiNew()
  if bitmap != nil: internalUpdate(result, bitmap)
  
proc image*(file: string): Image = image(bitmap(file))

proc update*(this: Image) = internalUpdate(this, internalGetBitmap(this))
proc `bitmap=`*(this: Image, that: Bitmap) = internalUpdate(this, that)
proc bitmap*(this: Image): Bitmap = internalGetBitmap(this)

  
# TEXT_AREA -------------------------------------
proc textArea*(text: string = ""): TextArea =
  nguiNew()
  if text != "": internalSetText(result, text)

proc text*(this: TextArea): string = internalGetText(this)
proc `text=`*(this: TextArea, text: string) = internalSetText(this, text)


# CALENDAR --------------------------------------
proc calendar*(
    date: DateTime = now(), onChangeEvent: NEventProc = nil): Calendar =
  nguiNew()
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
    value: float = range.a,
    orientation: NOrientation = noHORIZONTAL,
    decimals: int = 0,
    step: float = 1): Slider =
  nguiNew()
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
proc fileChoose*(
    onAccept: NEventProc,
    text:     string = "Open File",
    multiple: bool = false) =
  
  let fc = nguiNew(FileChoose)
  if text != "": internalSetText(fc, text)
  internalSetMultiple(fc, multiple)
  onEvent(fc, neFileChooseAccept, onAccept)
  internalRun(fc)

#proc fileChoose*(text: string = "Open File"): FileChoose =
  #nguiNew()
  #if text != "": internalSetText(result, text)
  #internalRun(fc)


# CHECKBOX --------------------------------------
proc checkbox*(text: string = "", checked: bool = false): Checkbox =
  nguiNew()
  internalSetChecked(result, checked)
  if text != "": internalSetText(result, text)

proc text*(this: Checkbox): string = internalGetText(this)
proc `text=`*(this: Checkbox, text: string) = internalSetText(this, text)
proc checked*(this: Checkbox): bool = internalGetChecked(this)
proc `checked=`*(this: Checkbox, v: bool) = internalSetChecked(this, v)


# CONTAINER -------------------------------------
proc len*(this: Container): int = internalLen(this)
proc high*(this: Container): int = len(this) - 1
proc empty*(this: Container): bool = len(this) == 0

proc `[]`*(this: Container, index: int): NElement =
  result = internalGetChild(this, index)
  doAssert result != nil, $(this, index)

proc `[]`*[T: NElement](
    this:      Container,
    typ:       typedesc[T],
    indexList: varargs[int]): T =

  var parent = this
  for i, idx in indexList:
    let e = parent[idx]
    if i == high(indexList): return type(result)(e)
    parent = Container(e)

proc `[]`*(this: Container, index: BackwardsIndex): NElement =
  this[this.len - int(index)]

iterator items*(this: Container): NElement =
  for i in 0 ..< this.len: yield this[i]

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

proc onAdd(this: Container, that: NElement) =
  # Edge case: I want to add one box and some elements AFTER said box

  if empty(this) and
      ((this of App and not(that of Window)) or (this of Window)):
    let b = nguiNew(Box)
    internalSetOrientation(b, noVERTICAL)
    add(this, b)

  doAssert this != nil and that != nil
  doAssert that.internalGetParent == nil
  doAssert this.id != 0 and that.id != 0

  doAssert not(this of Bar and that of Menu),
    "Don't add menu directly to bar. Instead do Bar -> Label -> Menu"
  
  if that of Bar and not (this of App or this of Window):
    doAssert internalLen(this) == 0,
      "Bar must be the first element to be added, but this " &
      "container has " & $internalLen(this) & " element(s)"
    
  proc insertBox(this: Container, that: NElement) =
    let box = nguiNew(Box)
    internalSetOrientation(box, noVERTICAL)
    onAdd(box, that)
    onAdd(this, box)
  
  if this of List:
    doAssert that of Label or that of Image
  
  if that of FileChoose:
    raiseAssert(
      "FileChoose element cannot be added to any container. Use 'run' instead")

  if this of Tab:    
    if that of Container:
      if that in names:
        let label = nguiNew(Label)
        internalSetText(label, names[that])
        Tab(this).internalAdd(Container(that), label)
        return

    else:
      insertBox(this, that)
      return

  if this of Window:
    if not (that of Box) or len(this) > 0:
      if len(this) == 0:
        let b = nguiNew(Box)
        internalSetOrientation(b, noVERTICAL)
        onAdd(Window(this), b)

      onAdd(Window(this)[0], that)
      return

  if this of App:    
    if not(that of Window):
      if len(this) == 0:
        let w = nguiNew(Window)
        onAdd(this, w)
        
      onAdd(App(this)[0], that)
      return
    
    else:
      discard # Window(that).show()

  internalAdd(this, that)

proc add*(this: Container, that: NElement) =
  ## Add that element to this container. Elements con only
  ## have one parent.
  
  if that.id == NSEPARATOR.id: this.addSeparator()
  else:                        this.onAdd(that)

proc add*(this: Container, text: string) = add(this, label(text))

proc add*(this: Container, one, two: NElement, list: varargs[NElement]) =
  add(this, one)
  add(this, two)
  for that in list: add(this, that)

proc add*[N: NElement](this: Container, list: openArray[N]) =
  for that in list: add(this, that)

proc remove*(this: Container, that: NElement) =
  ## Remove that element from this container. The container must be
  ## the parent of the element
  internalRemove(this, that)

proc removeAll*(this: Container) =
  if this of NTable:
    internalClear(NTable(this))
    return

  for i in countDown(high(this), 0):
    remove(this, this[i])

proc replace(container: Container, this, that: NElement) =
  internalReplace(container, this, that)

proc index*(this: Container, that: NElement): int =
  ## Get the position of that element relative its parent's children list
  ## or -1 if the container is no the parent.
  internalIndex(this, that)

proc pop*(this: Container): NElement =
  ## Remove the last element from this container's children list and 
  ## return it, or nil if there are no elements
  internalRemove(this, this[^1])

proc shift*(this: Container): NElement =
  ## Remove the first element from this container's children list and 
  ## return it, or nil if there are no elements
  internalRemove(this, this[0])

proc border*(this: Container): int = internalGetBorder(this)

proc `border=`*(this: Container, border: int) = internalSetBorder(this, border)

proc borderColor*(this: Container): Pixel =
  internalGetBorderColor(this)

proc `borderColor=`*(this: Container, color: Pixel) =
  internalSetBorderColor(this, color)


# BAR -------------------------------------------
proc bar*(): Bar =
  nguiNew()

proc add*(this: Bar, name: string, menu: Menu) =
  let label = label(name)
  internalAdd(label, menu)
  add(this, label)
  

# MENU ------------------------------------------
proc menu*(): Menu =
  nguiNew()
  
proc add*(this: NElement, that: Menu): NElement {.discardable.} =
  internalAdd(this, that)
  return this


# COMBOBOX --------------------------------------
proc add*(this: ComboBox, text: string, selected: bool = false) =
  internalAdd(this, text)
  if selected: internalSetSelectedIndex(this, internalLen(this) - 1)

proc comboBox*(textList: varargs[string], selected: int = -1): ComboBox =
  nguiNew()
  for text in textList: internalAdd(result, text)
  internalSetSelectedIndex(result, selected)

proc `[]=`*(this: ComboBox, i: int, text: string) = internalSet(this, text, i)
proc `[]`*(this: ComboBox, i: int): string = internalGet(this, i)

proc selected*(this: ComboBox): string = internalGetSelected(this)

proc selectedIndex*(this: ComboBox): int =
  ## Get the index of the selected child.
  internalGetSelectedIndex(this)


# PROGRESS --------------------------------------
proc progress*(v: float = 0.0): Progress =
  nguiNew()
  internalValue(result, v)

proc value*(this: Progress): float =
  internalValue(this)
proc `value=`*(this: Progress, v: float) =
  internalValue(this, clamp(v, 0.0, 1.0))


# BOX -------------------------------------------
proc box*(
    elements:    openArray[NElement],
    orientation: NOrientation = noVERTICAL,
    ): Box =

  nguiNew()
  internalSetOrientation(result, orientation)
  for e in elements: result.add(e)

proc box*(elements: varargs[NElement]): Box = box(elements, noVERTICAL)
proc vbox*(children: varargs[NElement]): Box = box(children, noVERTICAL)
proc hbox*(children: varargs[NElement]): Box = box(children, noHORIZONTAL)

proc orientation*(this: Box): NOrientation =
  internalGetOrientation(this)
proc `orientation=`*(this: Box, value: NOrientation) =
  internalSetOrientation(this, value)

proc `scrolled=`*(this: Box, state: bool) = internalScrollbar(this, state)
proc scrolled*(this: Box): bool = internalScrollbar(this)


# COMMON TABLE/TREE -----------------------------
proc `$`*(c: NCell): string =
  case c.kind:
  of ckInt:  $c.vInt
  of ckBool: $c.vBool
  of ckImg:  $(w: c.vImg.w, h: c.vImg.h)
  of ckStr:  c.vStr

proc toCell*(v: int):    NCell = NCell(kind: ckInt,  vInt:  v)
proc toCell*(v: bool):   NCell = NCell(kind: ckBool, vBool: v)
proc toCell*(v: string): NCell = NCell(kind: ckStr,  vStr:  v)
proc toCell*(v: Bitmap): NCell = NCell(kind: ckImg,  vImg:  v)
proc toCell*(v: NCell):  NCell = v

# TODO: typed -> NCellType
macro toNCellArray(values: untyped): array =
  result = newNimNode(nnkBracket)
  
  template call(a) = toCell(a)
  for v in values: add(result, getAst(call(v)))

template toNRow*(values: varargs[typed]): NRow =
  NRow(cells: @(toNCellArray(values)))

proc add*(this: NTable | Tree, values: NRow) = internalAdd(this, values)

proc add*(this: NTable | Tree, values: openArray[NCell]) =
  add(this, NRow(cells: @values))

template head*(this: NTable | Tree, values: varargs[string]) = th(this, values)

proc headers*(this: NTable | Tree): bool = internalHeaders(this)
proc `headers=`*(this: NTable | Tree, v: bool) = internalHeaders(this, v)

proc len*(this: NRow): int = this.cells.len


# TABLE -----------------------------------------
proc table*(header: openArray[(NCellKind, string)]): NTable =
  nguiNew()
  internalHeader(result, header)
  internalHeaders(result, true)

proc table*(header: openArray[NCellKind]): NTable =
  var h = newSeq[(NCellKind, string)](len(header))
  for i, e in mpairs(h): e = (header[i], "")
  return table(header = h)

proc `[]=`*(this: NTable, x, y: int, that: NCell) =
  internalSet(this, that, x, y)

template `[]=`*(this: NTable, x, y: int, that: typed) =
  this[x, y] = toCell(that)

template `[]=`*(this: NTable, p: tuple[x, y: int], that: typed) =
  this[p[0], p[1]] = toCell(that)
  
proc `[]`*(this: NTable, x, y: int): NCell =
  internalGet(this, x, y)

proc `[]`*(this: NTable, p: tuple[x, y: int]): NCell =
  internalGet(this, p.x, p.y)

template row*(this: NTable, values: varargs[untyped]) =
  internalAdd(this, toNRow(values))
  
proc mode*(this: NTable): NAmount = internalGetSelection(this)
proc `mode=`*(this: NTable, mode: NAmount) = internalSetSelection(this, mode)

proc columns*(this: NTable): int = len(internalHeader(this))

proc selected*(this: NTable): seq[tuple[x, y: int]] =
  internalGet(this, result)

proc `selected=`*(this: NTable, list: openArray[tuple[x, y: int]]) =
  internalSet(this, list)
  
proc selectedCells*(this: NTable): seq[NCell] =
  for s in selected(this):
    add(result, this[s])

proc selectedRows*(this: NTable): seq[NRow] =
  for (_, y) in selected(this):
    let r = internalGet(this, y)
    if r notin result: add(result, r)


# TREE ------------------------------------------
proc tree*(header: openArray[(NCellKind, string)]): Tree =
  nguiNew()
  internalHeader(result, header)
  internalHeaders(result, true)

proc tree*(header: openArray[NCellKind]): Tree =
  var h = newSeq[(NCellKind, string)](len(header))
  for i, e in mpairs(h): e = (header[i], "")
  return tree(h)

template row*(this: Tree, depth: openArray[int], values: varargs[untyped]) =
  internalAdd(this, toNRow(values), depth)

template row*(this: Tree, values: varargs[untyped]) =
  internalAdd(this, toNRow(values), [])

template `[]=`*(this: Tree, depth: openArray[int], column: int, that: typed) =
  internalSet(this, toCell(that), depth, column)

proc `[]`*(this: Tree, depth: openArray[int], column: int): NCell =
  internalGet(this, depth, column)


# TAB -------------------------------------------
proc tab*(reorderable: bool = false): Tab =
  ## Creates a new Tab element (Menu of Tabs)
  nguiNew()
  internalSetReorderable(result, reorderable)

proc add*(this: Tab, that: Container, label: Label) =
  doAssert this != nil
  doAssert that != nil
  doAssert label != nil
  internalAdd(this, that, label)

proc reorderable*(this: Tab): bool = internalGetReorderable(this)
proc `reorderable=`*(this: Tab, v: bool) = internalSetReorderable(this, v)

proc side*(this: Tab): NSide = internalGetSide(this)
proc `side=`*(this: Tab, side: NSide) = internalSetSide(this, side)


# LIST ------------------------------------------
proc list*(mode: NAmount = naOne): List =
  nguiNew()
  internalSetMode(result, mode)

proc mode*(this: List): NAmount = internalGetMode(this)
proc `mode=`*(this: List, mode: NAmount) = internalSetMode(this, mode)

proc selected*(this: List, that: var seq[NElement]) =
  internalSelected(this, that)

proc selected*(this: List): seq[NElement] = selected(this, result)


# TOOLS -----------------------------------------
proc tools*: Tools =
  nguiNew()

proc orientation*(this: Tools): NOrientation =
  ## Get the orientation of this Tools element
  internalGetOrientation(this)

proc `orientation=`*(this: Tools, value: NOrientation) =
  ## Set the orientation of this Tools element
  internalSetOrientation(this, value)


# ATTRIBUTE -------------------------------------
proc get*(this: NElement, that: NElementAttribute): Attribute =
  ## Find the attribute value of this element. If `attribute.found` is `false`,
  ## then this element doesn't support it.
  result = Attribute(kind: that)
  template g(n: untyped, v) {.dirty.} =
    result.n     = v
    result.found = true
  template gt(t: typedesc, n, v: untyped) {.dirty.} =
    if this of t:
      result.n     = t(this).v
      result.found = true

  case that:
  of naKind:        g(aKind, this.kind)
  of naBGColor:     g(aBGColor, this.bgColor)
  of naBorderColor: gt(Container, aBorderColor, internalGetBorderColor)
  of naToolTip:     g(aToolTip, this.tooltip)
  of naName:
    if this in names: g(aName, names[this])
  of naIndex:       g(aIndex, this.index)
  of naHasParent:   g(aHasParent, this.hasParent)
  of naFocus:       g(aFocus, this.focused)
  of naSize:        g(aSize, this.size)
  of naOpacity:     gt(Window, aOpacity, internalGetOpacity)
  of naVisible:     g(aVisible, internalGetVisible(this))
  of naMaximized:   gt(Window, aMaximized, internalGetMaximized)
  of naMinimized:   gt(Window, aMinimized, internalGetMinimized)
  of naLen:         gt(Container, aLen, internalLen)
  of naBorder:      gt(Container, aBorder, internalGetBorder)
  of naReorderable: gt(Tab, aReorderable, internalGetReorderable)
  of naSide:        gt(Tab, aSide, internalGetSide)
  of naModal:       gt(Window, aModal, internalGetModal)
  of naDate:        gt(Calendar, aDate, internalGetDate)
  of naImg:         gt(Button, aImg, internalGetImage)
  of naMode:
    gt(List, aMode, internalGetMode)
    template gt(t) = gt(t, aMode, internalGetSelection)
    gt(NTable); gt(Tree);

  of naTransient:   gt(Window, aTransient, internalGetTransient)
  of naStep:        gt(Slider, aStep, internalGetStep)
  of naDecimals:    gt(Slider, aDecimals, internalGetDecimals)
  of naScrolled:    gt(Box, aScrolled, internalScrollbar)
  of naHeader:
    template gt(t) = gt(t, aHeader, internalHeader)
    gt(NTable); gt(Tree);
  of naHeaders:
    template gt(t) = gt(t, aHeaders, internalHeaders)
    gt(NTable); gt(Tree);
  of naRows:
    template gt(t) = gt(t, aRows, internalRows)
    gt(NTable); gt(Tree);
  of naSelectedCells:
    if this of NTable:
      internalGet(NTable(this), result.aSelectedCells)
      result.found = true
  of naSelected:
    template gt(t) = gt(t, aSelected, internalGetSelectedIndex)
    gt(Tab)
  of naOrientation:
    template gt(t) = gt(t, aOrientation, internalGetOrientation)
    gt(Box); gt(Slider); gt(Tools)
  of naText:
    template gt(t) = gt(t, aText, internalGetText)
    gt(Window); gt(Button); gt(Label); gt(Radio); gt(Entry);
  of naWrap:      gt(Label, aWrap, internalGetWrap)
  of naResizable: gt(Window, aResizable, internalGetResizable)
  of naRange:     gt(Slider, aRange, internalGetRange)
  of naValue:
    if this of Slider:
      let v = internalGetValue(Slider(this))
      g(aValue, (int(v), v))

proc has*(this: NElement, that: NElementAttribute): bool =
  ## Returns whether or not this element supports the attribute
  get(this, that).found

proc set*(this: NElement, that: Attribute) =
  ## Set attribute value of this element, or do nothing if the element doesn't
  ## support it.

  template s(t, p: typed, v: untyped) =
    if this of t: t(this).p(v)
  template s(p: typed, v: untyped) =
    this.p(v)
  
  case that.kind:
  of naVisible:     s(internalSetVisible, that.aVisible)
  of naBGColor:     s(internalSetBGColor, that.aBGColor)
  of naBorderColor: s(Container, internalSetBorderColor, that.aBorderColor)
  of naBorder:      s(Container, internalSetBorder, that.aBorder)
  of naFocus:       this.internalSetFocus()
  of naName:        this.name = that.aName
  of naToolTip:     s(internalSetTooltip, that.aToolTip)
  of naSize:        s(internalSetSize, that.aSize)
  of naOpacity:     s(Window, internalSetOpacity, that.aOpacity)
  of naValue:       s(Slider, internalSetValue, that.aValue.vFloat)
  of naRange:       s(Slider, internalSetRange, that.aRange)
  of naText:        s(Label, internalSetText, that.aText)
  of naMinimized:   s(Window, internalSetMinimized, that.aMinimized)
  of naMaximized:   s(Window, internalSetMaximized, that.aMaximized)
  of naReorderable: s(Tab, internalSetReorderable, that.aReorderable)
  of naModal:       s(Window, internalsetModal, that.aModal)
  of naMode:
    s(List, internalSetMode, that.aMode)
    template s(t) = s(t, internalSetSelection, that.aMode)
    s(NTable); s(Tree);
    
  of naTransient:   s(Window, internalsetTransient, that.aTransient)
  of naSide:        s(Tab, internalSetSide, that.aSide)
  of naStep:        s(Slider, internalSetStep, that.aStep)
  of naDecimals:    s(Slider, internalSetDecimals, that.aDecimals)
  of naDate:        s(Calendar, internalSetDate, that.aDate)
  of naScrolled:    s(Box, internalScrollbar, that.aScrolled)
  of naImg:         s(Button, internalSetImage, that.aImg)
  of naHeader:
    s(NTable, internalHeader, that.aHeader)
    s(Tree,   internalHeader, that.aHeader)
  of naHeaders:
    s(NTable, internalHeaders, that.aHeaders)
    s(Tree,   internalHeaders, that.aHeaders)
  of naRows:
    s(NTable, internalRows, that.aRows)
    s(Tree,   internalRows, that.aRows)
  of naSelectedCells:
    s(NTable, internalSet, that.aSelectedCells)
  of naSelected:
    s(Tab,    internalSetSelectedIndex, that.aSelected)
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
  ## Returns a list of attributes from this element. Attributes not supported
  ## will set their `found` field to false
  for attrKind in NElementAttribute:
    result[attrKind] = get(this, attrKind)

proc `$`*(this: Attribute): string =
  if not this.found: return "[" & $this.kind & "] NOT FOUND"
  let s = system.`$`(this)
  return s[(s.find(", a") + 3) .. (s.find(", found:") - 1)]

proc `$`*(this: NElement): string =
  if this == nil: return "NElement(nil)"
  
  let attrs = attributes(this)
  result = $attrs[naKind].aKind
  
  for kind, attr in attrs:
    if not attr.found: continue
    if kind == naKind: continue
    result &= "\l  " & $attr

proc treeStr*(
    this:    NElement,
    pad:     string = "",
    debug:   bool = false): string =

  result = pad & $this.kind & " "

  if debug: result &= $(
    ID:   this.id,
    size: internalGetSize(this),
  )

  if this of Container:
    for child in Container(this):
      result &= "\l" & treeStr(child, pad & "|  ", debug)

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
