

# NELEMENT
proc tag*(this: NElement, key: string): string
proc `tag=`*(this: NElement, tag: tuple[key, value: string])

proc `[]=`*(this: NElement, key, value: string)
proc `[]=`*(this: NElement, key: string): string

proc name*(this: NElement): string
proc `name=`*(this: NElement, name: string)
proc named*[N: NElement](this: N, name: string): N

proc element*(name: string): NElement

proc tooltip*(this: NElement): string
proc `tooltip=`*(this: NElement, text: string)

proc kind*(this: NElement): NElementKind
proc id*(this: NElement): int

proc parent*(this: NElement): Container
proc hasParent*(this: NElement): bool

proc visible*(this: NElement): bool
proc `visible=`*(this: NElement, state: bool)
proc show*(this: NElement)
proc hide*(this: NElement)

proc alive*(this: NElement): bool
proc destroyed*(this: NElement): bool
proc destroy*(this: NElement)

proc tryDestroy*(this: NElement): bool {.discardable.}

proc focused*(this: NElement): bool
proc focus*(this: NElement)

proc size*(this: NElement): tuple[w, h: int]
proc `size=`*(this: NElement, size: tuple[w, h: int])

proc next*(this: NElement): NElement
proc prev*(this: NElement): NElement
proc index*(this: NElement): int

proc bgColor*(this: NElement): Pixel
proc `bgColor=`*(this: NElement, color: Pixel)

proc supports*(element: NElementKind, event: NElementEvent): bool
proc supports*(element: NElementKind, attribute: NElementAttribute): bool

proc currentEvent*(): NEventArgs
proc eventHandled*()
proc onEvent*(this: NElement, event: NElementEvent, action: NEventProc)
proc trigger*(event: NEventArgs)

proc `of`*(this: NElement, that: NElementKind): bool

proc nguiNew[N: NElement](_: typedesc[N]): N


# APP
proc getApp*: App
proc app*: App
proc run*(this: App)
proc stop*(this: App)

proc `[]`*(this: App, index: int): Window
proc `[]`*(this: App, index: BackwardsIndex): Window


# WINDOW
proc window*(text: string = "NGUI"): Window
  
proc text*(this: Window): string
proc `text=`*(this: Window, text: string)

proc resizable*(this: Window): bool
proc `resizable=`*(this: Window, state: bool)

proc position*(this: Window): tuple[x, y: int]
proc `position=`*(this: Window, position: tuple[x, y: int])
  
proc x*(this: Window): int
proc y*(this: Window): int
proc `x=`*(this: Window, x: int)
proc `y=`*(this: Window, y: int)

proc focused*(this: Window): NElement

proc icon*(this: Window): Bitmap
proc `icon=`*(this: Window, that: Bitmap)

proc decorated*(this: Window): bool
proc `decorated=`*(this: Window, v: bool)

proc minimized*(this: Window): bool
proc maximized*(this: Window): bool

proc `minimized=`*(this: Window, v: bool)
proc `maximized=`*(this: Window, v: bool)

proc modal*(this: Window): bool
proc `modal=`*(this: Window, v: bool)
proc transient*(this: Window): Window
proc `transient=`*(this, that: Window)

proc opacity*(this: Window): float
proc `opacity=`*(this: Window, o: float)

proc `[]`*(this: Window, index: int): Container
proc `[]`*(this: Window, index: BackwardsIndex): Container


# NALERT
proc alert*(title: string = "", text: string = ""): Alert

proc text*(this: Alert): string
proc `text=`*(this: Alert, text: string)

proc title*(this: Alert): string
proc `title=`*(this: Alert, text: string)

proc modal*(this: Alert): bool
proc `modal=`*(this: Alert, v: bool)
proc transient*(this: Alert): Window
proc `transient=`*(this: Alert, that: Window)

proc run*(this: Alert)


# LABEL
proc label*(text: string = ""): Label
  
proc text*(this: Label): string
proc `text=`*(this: Label, text: string)

proc wrap*(this: Label): bool
proc `wrap=`*(this: Label, state: bool)


# ENTRY
proc entry*(text: string = ""): Entry

proc text*(this: Entry): string
proc `text=`*(this: Entry, text: string)


# BUTTON
proc button*(text: string = "", onEventClick: NEventProc = nil): Button
proc button*(img: Bitmap, onEventClick: NEventProc = nil): Button

proc text*(this: Button): string
proc `text=`*(this: Button, text: string)

proc img*(this: Button): Bitmap
proc `img=`*(this: Button, img: Bitmap)


# RADIO
proc radio*(text: string = ""): Radio

proc text*(this: Radio): string
proc `text=`*(this: Radio, text: string)
  
proc group*(list: varargs[Radio])


# BUBBLE
proc bubble*(text: string = ""): Bubble
proc bubble*(child: NElement): Bubble

proc attach*(this: Bubble, that: NElement)
proc attach*(this: Bubble, that: NElement, destroyAfterMs: int)


# IMAGE
proc pixel*(r, g, b: uint8, a: uint8 = 255): Pixel {.inline.}
proc pixel*(r, g, b: float, a: float = 1.0): Pixel {.inline.}

proc newBitmap*(data: string): Bitmap
proc bitmap*(file: string): Bitmap

proc save*(this: Bitmap, path, format: string): bool
proc save*(this: Bitmap, path: string): bool
proc save*(this: Bitmap): bool

proc width*(this: Bitmap): int {.inline.}
proc height*(this: Bitmap): int {.inline.}
proc size*(this: Bitmap): tuple[w, h: int]
proc len*(this: Bitmap): int
  
proc `[]`*(this: Bitmap, i: int): Pixel {.inline.}
proc `[]=`*(this: Bitmap, i: int, p: Pixel) {.inline.}
proc `[]`*(this: Bitmap, x, y: int): Pixel {.inline.}  
proc `[]=`*(this: Bitmap, x, y: int, p: Pixel) {.inline.}  
proc `[]`*(this: Bitmap, point: tuple[x, y: int]): Pixel {.inline.}
proc `[]=`*(this: Bitmap, point: tuple[x, y: int], p: Pixel) {.inline.}

proc forEach*(this: Bitmap, action: (proc(p: Pixel): Pixel))

proc copy*(this: Bitmap): Bitmap

proc image*(bitmap: Bitmap = nil): Image  
proc image*(file: string): Image

proc update*(this: Image)
proc `bitmap=`*(this: Image, that: Bitmap)
proc bitmap*(this: Image): Bitmap


# TEXT_AREA
proc textArea*(text: string = ""): TextArea

proc text*(this: TextArea): string
proc `text=`*(this: TextArea, text: string)


# CALENDAR
proc calendar*(
  date: DateTime = now(), onChangeEvent: NEventProc = nil): Calendar

proc `selected=`*(this: Calendar, date: DateTime)

proc `selected`*(this: Calendar): DateTime

proc mark*(this: Calendar, dayOfMonth: int)
proc unmark*(this: Calendar, dayOfMonth: int)
proc marked*(this: Calendar, dayOfMonth: int): bool
proc clear*(this: Calendar)


# SLIDER
proc slider*(
    range: Slice[float] = 1.0 .. 100.0,
    value: float = range.a,
    orientation: NOrientation = noHORIZONTAL,
    decimals: int = 0,
    step: float = 1): Slider

#proc range*(this: Slider): Slice[float]
proc `range=`*(this: Slider, range: Slice[float])

proc value*(this: Slider): float
proc `value=`*(this: Slider, value: float)

proc `step=`*(this: Slider, step: float)

proc decimals*(this: Slider): int
proc `decimals=`*(this: Slider, decimals: int)

proc orientation*(this: Slider): NOrientation
proc `orientation`*(this: Slider, value: NOrientation)


# FILE_CHOOSE
proc fileChoose*(
  onAccept: NEventProc,
  text:     string = "Open File",
  multiple: bool = false)


# CHECKBOX
proc checkbox*(text: string = "", checked: bool = false): Checkbox

proc text*(this: Checkbox): string
proc `text=`*(this: Checkbox, text: string)
proc checked*(this: Checkbox): bool
proc `checked=`*(this: Checkbox, v: bool)


# CONTAINER
proc len*(this: Container): int
proc high*(this: Container): int
proc empty*(this: Container): bool

proc `[]`*(this: Container, index: int): NElement
proc `[]`*(this: Container, index: BackwardsIndex): NElement

proc `[]`*[T: NElement](
    this:      Container,
    typ:       typedesc[T],
    indexList: varargs[int]): T

proc addSeparator*(this: Container)

proc add*(this: Container, that: NElement)
proc add*(this: Container, text: string)
proc add*(this: Container, one, two: NElement, list: varargs[NElement])
proc add*[N: NElement](this: Container, list: openArray[N])

proc remove*(this: Container, that: NElement)
proc removeAll*(this: Container)

proc replace(container: Container, this, that: NElement)
proc index*(this: Container, that: NElement): int
proc pop*(this: Container): NElement
proc shift*(this: Container): NElement

proc border*(this: Container): int
proc `border=`*(this: Container, border: int)

proc borderColor*(this: Container): Pixel
proc `borderColor=`*(this: Container, color: Pixel)


# BAR
proc bar*(): Bar

proc add*(this: Bar, name: string, menu: Menu)
  

# MENU
proc menu*(): Menu
  
proc add*(this: NElement, that: Menu): NElement {.discardable.}


# COMBOBOX
proc add*(this: ComboBox, text: string, selected: bool = false)

proc comboBox*(textList: varargs[string], selected: int = -1): ComboBox

proc `[]=`*(this: ComboBox, i: int, text: string)
proc `[]`*(this: ComboBox, i: int): string

proc selected*(this: ComboBox): string
proc selectedIndex*(this: ComboBox): int


# PROGRESS
proc progress*(v: float = 0.0): Progress

proc value*(this: Progress): float
proc `value=`*(this: Progress, v: float)


# BOX
proc box*(
    elements:    openArray[NElement],
    orientation: NOrientation = noVERTICAL,
    ): Box

proc box*(elements: varargs[NElement]): Box
proc vbox*(children: varargs[NElement]): Box
proc hbox*(children: varargs[NElement]): Box

proc orientation*(this: Box): NOrientation
proc `orientation=`*(this: Box, value: NOrientation)

proc `scrolled=`*(this: Box, state: bool)
proc scrolled*(this: Box): bool


# COMMON TABLE/TREE
proc `$`*(c: NCell): string

proc toCell*(v: int):    NCell
proc toCell*(v: bool):   NCell
proc toCell*(v: string): NCell
proc toCell*(v: Bitmap): NCell

proc add*(this: NTable | Tree, values: NRow)
proc add*(this: NTable | Tree, values: openArray[NCell])

proc headers*(this: NTable | Tree): bool
proc `headers=`*(this: NTable | Tree, v: bool)

proc len*(this: NRow): int


# TABLE
proc table*(header: openArray[(NCellKind, string)]): NTable
proc table*(header: openArray[NCellKind]): NTable
  
proc `[]`*(this: NTable, x, y: int): NCell
proc `[]`*(this: NTable, p: tuple[x, y: int]): NCell
  
proc mode*(this: NTable): NAmount
proc `mode=`*(this: NTable, mode: NAmount)

proc columns*(this: NTable): int

proc selected*(this: NTable): seq[tuple[x, y: int]]
proc `selected=`*(this: NTable, list: openArray[tuple[x, y: int]])
  
proc selectedCells*(this: NTable): seq[NCell]
proc selectedRows*(this: NTable): seq[NRow]


# TREE
proc tree*(header: openArray[(NCellKind, string)]): Tree
proc tree*(header: openArray[NCellKind]): Tree

proc `[]`*(this: Tree, depth: openArray[int], column: int): NCell


# TAB
proc tab*(reorderable: bool = false): Tab

proc add*(this: Tab, that: Container, label: Label)

proc reorderable*(this: Tab): bool
proc `reorderable=`*(this: Tab, v: bool)

proc side*(this: Tab): NSide
proc `side=`*(this: Tab, side: NSide)


# LIST
proc list*(mode: NAmount = naOne): List

proc mode*(this: List): NAmount
proc `mode=`*(this: List, mode: NAmount)

proc selected*(this: List, that: var seq[NElement])
proc selected*(this: List): seq[NElement]


# TOOLS
proc tools*: Tools

proc orientation*(this: Tools): NOrientation
proc `orientation=`*(this: Tools, value: NOrientation)


# ATTRIBUTE
proc get*(this: NElement, that: NElementAttribute): Attribute
proc has*(this: NElement, that: NElementAttribute): bool
proc set*(this: NElement, that: Attribute)

proc attributes*(this: NElement): Attributes

proc `$`*(this: Attribute): string
proc `$`*(this: NElement): string

proc treeStr*(
    this:    NElement,
    pad:     string = "",
    debug:   bool = false): string

# proc toJson*(this: Attributes | NElement): JSonNode
# proc toNElement*(this: JSonNode): NElement


# TIMERS
proc repeat*(event: NRepeatProc, ms: int): NRepeatHandle

proc setTime*(this: var NRepeatHandle, ms: int)

proc stop*(this: NRepeatHandle)

proc later*(event: NEventProc, ms: int)


# CLIPBOARD
proc clipboardClear*
proc clipboardSet*(text: string)
proc clipboardSet*(img: Bitmap)
proc clipboardGetText*: string
proc clipboardGetBitmap*: Bitmap
proc clipboardAsyncGet*(action: NAsyncTextProc)
proc clipboardAsyncGet*(action: NAsyncBitmapProc)
