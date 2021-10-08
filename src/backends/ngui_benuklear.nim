import private/nuklear_glfw/nuklear_glfw
import private/nuklear_glfw/glfw/wrapper as glfw
import private/solver/kiwi
import std/[random, sets]

const ngui_include_filebrowser = 1 # Sorry, but I had no choice
include ../nelements/ngui_filebrowser

includeUtils CONTAINER, ATTRIBUTES#ELEMENT, EVENT, TIMER, ADAPTER
#     v-- Set 'LAX_ERROR' to false to see fireworks
const LAX_ERROR = true
  
template beInfo(str: string) =
  echo("[NGUI_INFO] " & str & " NOT IMPLEMENTED")
template beError(str: string) =
  raiseAssert("[NGUI_ERROR] " & str & " NOT IMPLEMENTED")
template beMsg(str: string) = 
  when LAX_ERROR: beInfo(str) else: beError(str)


# BASE ------------------------------------------
var
  # LAYOUT
  elementLayout:   STable[NID, tuple[x, y, w, h: int]]
  resetLayout:     HashSet[NID]
  
  # WINDOW / ALERT
  winList:         seq[(glfw.Window, NElement)]
  winTitle:        STable[glfw.Window, string]
  winDestroyed:    HashSet[NID]
  winFocus:        HashSet[NID]
  forceRender:     HashSet[NID]
  withFocus:       STable[Window, NElement]

  # EVENTS
  eventList:       seq[(NElement, NEventArgs, NEventProc)]
  eventArgs:       NEventArgs
  mouseClick:      bool
  buttonPress:     bool
  
  repeatEvents:    STable[NRepeatHandle,
                          tuple[millis, current: int, cb: NRepeatProc]]
  
  # RADIO
  radioActive:     seq[tuple[len: int, active: NID]]
  radioGroup:      STable[Radio, int]
  
  # LIST
  listActive:      STable[NID, HashSet[NID]]
  
  # COMBOBOX
  comboOptions:    STable[NID, seq[string]]
  comboSelected:   STable[NID, int]
  
  # CHECKBOX
  checkBoxChecked: HashSet[NID]
  checkBoxText:    STable[NID, string]
  
  # CALENDAR
  calendarMarked:  STable[NID, system.set[1 .. 31]]
  
  # MENUBAR
  itemToMenu:      STable[NID, Menu]
  menuOpen:        HashSet[NID]
  menuSubOpen:     STable[NID, Menu]
  menuSep:         STable[NID, system.set[0 .. 63]]
  
  # NuklearGroupID
  ngID:            STable[NID, string]

  # IMAGE
  imgToBitmap:     STable[NID, Bitmap]
  bmpToID:         STable[Bitmap, uint32]

  # TAB
  tabLabel:        STable[NID, Label]
  tabReorderable:  HashSet[NID]
  
  # FILE_BROWSER
  fbProxy:         STable[NID, NFileBrowser]


proc nelementOf(w: glfw.Window): NElement =
  doAssert w != nil
  for a, b in items(winList):
    if a == w: return b
  raiseAssert("Window not found")

proc glfwWindowOf(e: NElement): glfw.Window =
  doAssert e != nil
  doAssert e of Window or e of Alert
  for a, b in items(winList):
    if b == e: return a
  raiseAssert("glfw.Window not found")

proc root(this: NElement): Window =
  var parent = utilParent(this)
  while parent != nil and not (parent of Window):
    parent = utilParent(parent)
  if parent of Window: return Window(parent)

proc getTransient(this: NElement): Window =
  doAssert this.kind in {neWindow, neAlert}
  utilGetAttr(this, transient)

proc setTransient(this: Nelement, that: Window) =
  let oldValue = getTransient(this)
  if oldValue != nil:
    let glfwWin = glfwWindowOf(oldValue)
    if glfwWin != nil: glfwVisible(glfwWin, true)

  doAssert this.kind in {neWindow, neAlert}
  utilSetAttr(this, transient, that)

proc destroyWindow(e: NElement) =  
  let w = glfwWindowOf(e)
  glfwClose(w)
  incl(winDestroyed, e.id)
  
proc glID(this: Bitmap): uint32 =
  if this in bmpToID: return bmpToID[this]
  bmpToId[this] = initImage(this.img[0].addr, this.w, this.h)
  return glID(this)


# NUKLEAR WRAPPER -------------------------------
type
  WidgetData =  object
    bounds:     tuple[x, y, w, h: int]
    region:     tuple[x, y, w, h: int]
    mouse:      tuple[x, y: int]
    mouseState: array[MouseButton, MouseState]
    mouseMove:  bool
    selected:   bool
    selIndex:   int
    hover:      bool
    dclick:     bool
    
template toNKBool(v: bool): nk_bool = (if v: nk_true else: nk_false)
template toBool(v: nk_bool): bool = bool(v)

proc wd(
    ctx: ptr[nk_context],
    ):   WidgetData =

  var x, y: float
  glfw.getCursorPos(getCurrentWindow(), addr(x), addr(y))

  let
    bounds = nk_widget_bounds(ctx)
    region = nk_window_get_content_region(ctx)
    hover  = toBool(nk_widget_is_hovered(ctx))
    inside = x in region.x .. region.x + region.w - 1 and
             y in region.y .. region.y + region.h - 1
    
  result.bounds = (int(bounds.x), int(bounds.y), int(bounds.w), int(bounds.h))
  result.region = (int(region.x), int(region.y), int(region.w), int(region.h))

  # MOUSE
  if inside:    
    template dclick: bool =
      toBool(nk_input_is_mouse_click_in_rect(
        addr(ctx.input), NK_BUTTON_DOUBLE, bounds))
    
    let nc = getCurrentNuklearGLFWContext()
    result.mouseState = nc.mouseState
    result.mouseMove  = hover and nc.mouseMove
    
    result.dclick = dclick()
    result.hover  = toBool(nk_widget_is_hovered(ctx))    
    result.mouse  = (int(x - bounds.x), int(y - bounds.y))

proc tooltip(c: ptr[nk_context], b: nk_rect, t: string): bool =
  result = t != "" and nk_input_is_mouse_hovering_rect(c.input.addr, b).bool
  if result: nk_tooltip(c, t)

proc drawSeparator(w: glfw.Window, wd: WidgetData) =
  let
    ctx = getContext(w).nkCtx.addr
    b   = wd.bounds

  nk_stroke_line(
    nk_window_get_canvas(ctx),
    cfloat(b.x + 10),       cfloat(b.y + b.h - 1),
    cfloat(b.x + b.w - 20), cfloat(b.y + b.h - 1),
    2, ctx.style.text.color)

proc showLabel(
    w: glfw.Window, label: string, selected, wrap: bool): WidgetData =

  let ctx = getContext(w).nkCtx.addr
  result = wd(ctx)
  
  doAssert not(selected and wrap)
  
  var s = toNKBool(selected)

  if not wrap:
    if len(label) != 0:
      discard nk_selectable_text(
        ctx, label, cint(len(label)), nk_flags(NK_TEXT_LEFT), addr(s))

    else:
      nk_spacing(ctx, 1)

  else:
    nk_text_wrap(ctx, label, cint(len(label)))

  result.selected = toBool(s)
  
proc showIconLabel(
    w: glfw.Window, img: Bitmap, label: string, selected: bool): WidgetData =

  let ctx = getContext(w).nkCtx.addr
  result = wd(ctx)
  
  var s = toNKBool(selected)

  discard nk_selectable_image_text(
    ctx,
    nk_image_id(cint(glID(img))),
    label,
    cint(len(label)),
    nk_flags(NK_TEXT_LEFT),
    addr(s))

  result.selected = toBool(s)

proc showButton(
    w:              glfw.Window,
    label, tooltip: string,
    highLight:      bool,
    color:          Pixel,
    img:            uint32,
    ):              WidgetData =

  let
    ctx          = getContext(w).nkCtx.addr
    button_color = ctx.style.button.normal
    
  result = wd(ctx)
    
  var pushed = false
    
  if tooltip != "":
    discard tooltip(ctx, nk_widget_bounds(ctx), tooltip)
  
  if highLight:
    pushed = true
    discard nk_style_push_color(
      ctx,
      ctx.style.button.normal.data.color.addr,
      ctx.style.button.active.data.color)
    #ctx.style.button.normal = ctx.style.button.active
    
  elif color != Pixel():
    pushed = true
    discard nk_style_push_color(
      ctx,
      ctx.style.button.normal.data.color.addr,
      nk_rgb(cint(color.r), cint(color.g), cint(color.b)))
  
  result.selected =
    if img != 0:
      toBool(nk_button_image_text(
        ctx, nk_image_id(cint(img)), label, cint(len(label)),
        nk_flags(NK_TEXT_LEFT)))

    else:
      toBool(nk_button_text(ctx, label, cint(len(label))))
  
  if pushed:
    discard nk_style_pop_color(ctx)
    #ctx.style.button.normal = button_color

proc showCheckBox(
    w:        glfw.Window,
    text:     string,
    checked:  bool,
    ):        WidgetData =

  let ctx = getContext(w).nkCtx.addr
  result = wd(ctx)
  
  var c = toNKBool(checked)
  discard nk_checkbox_label(ctx, text, addr(c))
  
  result.selected = toBool(c)

proc showComboBox(
    w:        glfw.Window,
    options:  seq[string],
    selected: int,
    ):        WidgetData =
  
  let ctx = getContext(w).nkCtx.addr
  result = wd(ctx)
  
  var buffer = toBuffer(256, '\0', options)
  var s = cint(selected)

  nk_combobox_string(
    ctx,
    buffer[0].addr,
    addr(s),
    len(options).cint,
    10,
    nk_vec2(x: 200, y: 100))
  
  result.selIndex = int(s)

proc showEntry(
    w:        glfw.Window,
    text:     var string,
    max:      int,
    textArea: bool = false,
    ):        WidgetData =
  
  let ctx = addr(getContext(w).nkCtx)
  result = wd(ctx)
  
  var len: cint = text.len.cint
  if len == 0: setLen(text, 1)

  discard nk_edit_string(
    ctx,
    (if textArea: NK_EDIT_BOX else: NK_EDIT_SIMPLE.int).nk_flags,
    text[0].addr,
    len.addr,
    max.cint,
    nk_filter_default)
  
  setLen(text, len.int)

proc showImage(
    w:       glfw.Window,
    id:      uint32,
    size:    tuple[w, h: int],
    tooltip: string,
    ):       WidgetData  =

  let ctx = addr(getContext(w).nkCtx)
  result = wd(ctx)
  nk_image_show(ctx, nk_image_id(cint(id)))

  # TODO discard tooltip(nCtx, b, tooltip)


# EVENT -----------------------------------------
proc getKeys(key, mods: cint): (NKey, set[NKey]) # FD

proc triggerEvent(this: NElement, event: NElementEvent): bool =
  for el, ev, ac in items eventList:
    if el == this:
      ac()
      return true

proc eventArg(this: NElement, event: set[NElementEvent]): ptr[NEventArgs] =
  for el, ev, _ in mitems eventList:
    if ev.kind in event and el == this:
      return addr(ev)
    
proc onFocusCB(w: glfw.Window, s: int32) {.cdecl.} =
  if s.bool: incl(winFocus, nelementOf(w).id)
  else:      excl(winFocus, nelementOf(w).id)

proc onKeyCB(
    w: glfw.Window, key, scanCode, action, mods: cint) {.cdecl.} =
  
  if action == kaDown.cint: buttonPress = true

  let
    this   = nelementOf(w)
    kind   = if action == kaUp.cint: neKeyRelease else: neKeyPress
    (k, m) = getKeys(key, mods)

  eventArgs      = NEventArgs(kind: kind, element: this)
  eventArgs.key  = k
  eventArgs.mods = m

  discard triggerEvent(this, kind)
  
  var kindSet = {kind}
  if k == nkEnter and kind == neKeyPress: incl(kindSet, neEnter)
  for el, ev, ac in items eventList:
    if ev.kind in kindSet:
      eventArgs.element = el
      ac()

proc internalSetEvent(
    this: NElement, event: NElementEvent, action: NEventProc) =

  if this of FileChoose:
    add(eventList, (fbProxy[this.id].window, NEventArgs(kind: event), action))
    
  else:
    add(eventList, (this, NEventArgs(kind: event), action))

proc internalGetCurrentEvent: NEventArgs = eventArgs

proc internalEventHandled() =
  ## Stop event propagation
  beMsg("proc internalEventHandled()")
  
proc internalTriggerEvent(event: NEventArgs) =
  let args = eventArg(event.element, {event.kind})
  if args != nil: args[] = event


# NElement ----------------------------------------
proc internalInitNElement(this: var NElement) =
  var firstWindow {.global.}: glfw.Window
  
  case this.kind:
  of neApp:
    nk_glfw_init()
    firstWindow = nk_glfw_window()

  of neWindow, neAlert:
    let gW =
      if firstWindow != nil: firstWindow
      else:                  nk_glfw_window()

    firstWindow = nil
    add(winList, (gW, Window(this)))

    nk_glfw_key_cb(gW, onKeyCB)
    discard setWindowFocusCallback(gW, onFocusCB)
    winTitle[gW]   = "ngui"
    if this.kind == neAlert:
      internalSetSize(this, (DEF_WIN_SIZE, DEF_WIN_SIZE div 3))
      
    incl(resetLayout, this.id)
    discard setWindowSizeCallback(
      gW,
      cast[Windowsizefun](proc(a2: glfw.Window; a3: int32; a4: int32) =
        incl(resetLayout, nelementOf(a2).id)
    ))
      
  of neList:
    listActive[this.id] = initHashSet[NID]()
    
  of neComboBox:
    comboSelected[this.id] = 0
    comboOptions[this.id]  = @[]

  of neCalendar:
    calendarMarked[this.id] = {}    
    
  of neRadio, neBox, neButton, neLabel, neEntry, neCheckBox, neMenu, neBar,
      neTab, neTools, neImage, neProgress, neTextArea, neSlider:
    discard
    
  of neTable:
    utilSetAttr(this, Rows, @[])
    
  of neFileChoose:
    fbProxy[this.id] = nFileBrowser()
  
  else:
    raiseAssert("Not implemented: " & $this.kind)
  
  if this.kind in {neCalendar, neList, neTab, neTable}:
    ngID[this.id] = $this.id

proc internalGetParent(this: NElement): Container = utilParent(this)
proc internalGetNext(this: NElement): NElement = utilNext(this)
proc internalGetPrev(this: NElement): NElement = utilPrev(this)

proc internalSetVisible(this: NElement, state: bool) =
  if this.kind in {neWindow, neAlert}:
    let w = glfwWindowOf(this)
    glfwVisible(w, state)
    return

  beMsg("proc internalSetVisible(this: NElement, state: bool)")

proc internalGetVisible(this: NElement): bool =
  if this.kind in {neWindow, neAlert}:
    return glfwVisible(glfwWindowOf(this))

  beMsg("proc internalGetVisible(this: NElement): bool")

proc internalGetFocus(this: NElement): bool =
  if this.kind in {neWindow, neAlert}: return this.id in winFocus
  
  for that in values(withFocus):
    if that == this: return true

proc internalSetFocus(this: NElement) =
  if this.kind in {neWindow, neAlert}:
    glfw.focusWindow(glfwWindowOf(this))
    return
    
  withFocus[root(this)] = this

proc internalGetSize(this: NElement): tuple[w, h: int] =
  if this.kind in {neWindow, neAlert}:
    return glfwSize(glfwWindowOf(this))
  if this.kind == neImage:
    let bm = imgToBitmap[this.id]
    return (bm.w, bm.h)
  utilGetAttr(this, Si_ze)

proc internalSetSize(this: NElement, size: tuple[w, h: int]) =
  if this.kind in {neWindow, neAlert}:
    glfwSize(glfwWindowOf(this), size)
    return
  utilSetAttr(this, size, size)

proc internalSetTooltip(this: NElement, text: string) =
  utilSetAttr(this, ToolTip, text)

proc internalGetTooltip(this: NElement): string =
  utilGetAttr(this, ToolTip)

proc internalSetDestroy(this: NElement) =
  if this of Window:
    destroyWindow(this)
    
  else:
    beMsg("proc internalSetDestroy(this: NElement)")

proc internalGetDestroy(this: NElement): bool =
  if this of FileChoose:
    return fbProxy[this.id].done
  
  if this of Window:
    return this.id in winDestroyed
  
  raiseAssert("Not implemented: " & $this.kind)

proc internalGetBGColor(this: NElement): Pixel =
  utilGetAttr(this, BGColor)

proc internalSetBGColor(this: NElement, color: Pixel) =
  utilSetAttr(this, BGColor, color)


# CONTAINER -------------------------------------
proc internalLen(this: Container): int = utilLen(this)

proc internalRemove(this: Container, that: NElement) =
  ## Remove element from this container. Element MUST be a child
  beMsg("proc internalRemove(this: Container, that: NElement)")

proc internalAdd(this: Container, that: NElement) =  
  utilChild(this, that)

proc internalReplace(container: Container, this, that: NElement) =
  ## Replace child with another element
  beMsg("proc internalReplace(container: Container, this, that: NElement)")

proc internalIndex(this: Container, that: NElement): int =
  utilChildIndex(this, that)

proc internalGetChild(this: Container, index: int): NElement =
  utilNChild(this, index)

proc internalGetBorder(this: Container): int =
  utilGetAttr(this, border)

proc internalSetBorder(this: Container, b: int) =
  utilSetAttr(this, border, b)

proc internalAddSeparator(this: Container, dir: NOrientation) =
  if this of Menu:
    var s = getOrDefault(menuSep, this.id, {})
    incl(s, utilLen(this))
    add(menuSep, this.id, s)
    return
    
  beMsg("proc internalAddSeparator(this: Container, dir: NOrientation)")

proc internalGetBorderColor(this: Container): Pixel =
  utilGetAttr(this, BorderColor)

proc internalSetBorderColor(this: Container, color: Pixel) =
  utilSetAttr(this, BorderColor, color)


# APP -------------------------------------------
proc genLayout(w: Window, size: tuple[x, y, w, h: int]) # FD

proc setLayout(this: NElement, win: glfw.Window) =
  if utilParent(this) of Bar: return
  if utilParent(this) of Menu: return

  let (x, y, w, h) = elementLayout[this.id]
  if this of Image:
    let (w, h) = internalGetSize(Image(this))
    rowLayoutSpace(win, x, y, w, h)
  else:
    rowLayoutSpace(win, x, y, w, h)

template doEvent(e: NElement, kind: NElementEvent, cb: untyped) =
  block:
    let args {.inject.} = eventArg(e, {kind})
    if args != nil:
      args.element = e
      cb

proc processCheckbox(w: glfw.Window, this: CheckBox): WidgetData =
  let wasChecked = this.id in checkBoxChecked
  
  result = showCheckBox(w, internalGetText(this), wasChecked)

  if result.selected != wasChecked:
    internalSetChecked(this, result.selected)
    let args = eventArg(this, {neChange})
    if args != nil: args.element = this

proc processCombobox(w: glfw.Window, this: ComboBox): WidgetData =
  let value = comboSelected[this.id]

  result = showComboBox(w, comboOptions[this.id], value)

  if result.selIndex != value:
    comboSelected[this.id] = result.selIndex
    let args = eventArg(this, {neChange})
    if args != nil: args.element = this

proc processTextArea(w: glfw.Window, this: TextArea): WidgetData =
  let
    text   = entryTextPtr(this)
    oldLen = len(text[])

  setLen(text[], 1_024)
  setLen(text[], oldLen)

  result = showEntry(w, text[], 1_024, textArea = true)

proc processEntry(w: glfw.Window, this: Entry): WidgetData =
  let
    text   = entryTextPtr(this)
    oldLen = len(text[])
    
  const MAX_SIZE = 1_024

  setLen(text[], MAX_SIZE)
  setLen(text[], oldLen)
  
  setLayout(this, w)

  result = showEntry(w, text[], MAX_SIZE)
  
  let newLen = len(text[])
  if newLen != oldLen:
    doEvent(this, neChange):
      discard

proc processImage(w: glfw.Window, this: Image): WidgetData =
  let bm = imgToBitmap[this.id]
  result = showImage(w, glID(bm), (bm.w, bm.h), internalGetTooltip(this))
      
  template initArgs =
    args.mouse = {}
    args.x = result.mouse.x
    args.y = result.mouse.y
    
  template initEvent(a, b) =
    doEvent(this, a):
      initArgs()
      for mb, st in result.mouseState:
        if st in b:
          incl(args.mouse, NMouse(ord(mb)))

  if result.mouseMove:
    initEvent(neMove, {msDown, msPress})

  if msPress in result.mouseState:
    initEvent(neClick, {msPress})

  if msRelease in result.mouseState:
    initEvent(neClickRelease, {msRelease})

proc processButton(w: glfw.Window, this: Button): WidgetData =  
  let
    bgColor = utilGet(this, naBGColor)
    color   = if bgColor.found: bgColor.aBGColor else: Pixel()
    bmp     = internalGetImage(this)
  
  result = showButton(
      w, internalGetText(this), internalGetTooltip(this), off, color,
      (if bmp != nil: glID(bmp) else: 0))
  
  if result.selected:
    doEvent(this, neClick):
      discard

proc process(w: glfw.Window, this: NElement, setLayout: bool): WidgetData =
  if setLayout: setLayout(this, w)

  if this of CheckBox:
    processCheckbox(w, CheckBox(this))
  elif this of ComboBox:
    processCombobox(w, ComboBox(this))
  elif this of TextArea:
    processTextArea(w, TextArea(this))
  elif this of Entry:
    processEntry(w, Entry(this))
  elif this of Image:
    processImage(w, Image(this))
  elif this of Button:
    processButton(w, Button(this))
  else:
    raiseAssert("Not Implemented: " & $this.kind)

proc processElement(w: glfw.Window, this, parent: NElement) =
  proc processChildren(w: glfw.Window, this: Container) =
    for child in utilItems(this):
      processElement(w, child, this)

  ifElement this, Window:
    let (wW, wH) = internalGetSize(this)
    withWindow(w, (0, 0, wW, wH), getTransient(this) != nil):
      let hasMenu =
        utilLen(this) > 0 and
        utilLen(Container(utilNChild(this, 0))) > 0 and
        utilNChild(Container(utilNChild(this, 0)), 0) of Bar
      
      if hasMenu:
        let box = Container(utilNChild(this, 0))
        processElement(w, utilNChild(box, 0), box)
        genLayout(this, rowLayoutSpaceBegin(w))
        for child in utilItems(box):
          if child of Bar: continue
          processElement(w, child, box)
        
      else:
        genLayout(this, rowLayoutSpaceBegin(w))
        processChildren(w, this)

      rowLayoutSpaceEnd(w)
    return

  ifElement this, Alert:
    let (wW, wH) = internalGetSize(this)
    withWindow(w, (0, 0, wW, wH), noInput = false):
      rowLayoutDynamic(w, 1)
      discard showLabel(w, internalGetText(this), false, true)
      if showButton(w, "Accept", "", off, Pixel(), 0).selected: destroyWindow(this)

    return

  ifElement this, Box:    
    #case internalGetOrientation(this):
    #of noVERTICAL:
      #for child in utilItems(this):
        #if child.kind in {neBar, neCalendar, neBox, neImage}:
          #discard # They will set the layout
        #else: rowLayoutDynamic(w, 1)
        #processElement(w, child, this)
      
    #of noHORIZONTAL:
      #rowLayoutDynamic(w, utilLen(this))
      #for child in utilItems(this): processElement(w, child, this)
      
    for child in utilItems(this):
      processElement(w, child, this)

    return
  
  ifElement this, NTable:
    setLayout(this, w)
    withGroup(w, ngID[this.id]):
      const MAX = 31

      var
        emptyTitle: set[0 .. MAX]
        isImg:      set[0 .. MAX]
        isStr:      set[0 .. MAX]
        imgIcon:    set[0 .. MAX]
        
      for i, (k, n) in internalHeader(this):
        if n == "":    incl(emptyTitle, i)
        if k == ckImg: incl(isImg,      i)
        elif k == ckStr: incl(isStr,    i)
        
      if len(emptyTitle) != len(internalHeader(this)):
        for i in 1 ..< len(internalHeader(this)):
          if i in isStr and i - 1 in isImg and i in emptyTitle:
            incl(imgIcon, i)

      var selected: seq[tuple[x, y: int]]
      internalGet(this, selected)
      
      rowLayoutDynamic(w, len(internalHeader(this)) - len(imgIcon))
      
      # Header
      if internalHeaders(this):
        for i, (_, n) in internalHeader(this):
          if n == "": continue
          discard showLabel(w, n, off, off)

      # Rows
      for y, row in internalRows(this):        
        var rowSel = false
        for x, c in row.cells:
          rowSel = rowSel or (x, y) in selected
          if rowSel: break
        
        for x, c in row.cells:
          var
            sel1 = rowSel or (x, y) in selected
            sel2 = sel1
            wd: WidgetData
          
          case c.kind:
          of ckStr:
            if x in imgIcon:
              wd = showIconLabel(w, row.cells[x - 1].vImg, c.vStr, sel2)
            else:
              wd = showLabel(w, c.vStr, sel2, off)
            
          of ckInt:
            # TODO: Int overload
            wd = showLabel(w, $c.vInt, sel2, off)

          of ckBool:
            wd = showCheckBox(w, "", c.vBool)

          of ckImg:
            if x + 1 notin imgIcon:
              let bm = c.vImg
              discard showImage(w, glID(bm), (bm.w, bm.h), "")
            continue
            
          sel2 = wd.selected
          
          if wd.dclick:
            sel2 = true
            doEvent(this, neCLICK, (args.double = true))

          if sel1 == sel2: continue
          rowSel = sel2

          for x, c in row.cells:
            let
              point  = (x, y)
              wasSel = point in selected

            if rowSel != wasSel:
              if rowSel: add(selected, point)
              else:      del(selected, find(selected, point))

      internalSet(this, selected)

    return
  
  ifElement this, Tools:    
    setLayout(this, w)
    processChildren(w, this)
    return
  
  ifElement this, List:
    setLayout(this, w)
    withGroup(w, ngID[this.id]):
      rowLayoutDynamic(w, 1)
      processChildren(w, this)
    return
  
  ifElement this, Bar:
    withBar(w, utilLen(this)):
      for child in utilItems(this):
        if child.kind == neLabel:
          # https://github.com/vurtun/nuklear/issues/346#issuecomment-281431155
          # No submenu cascading, that's why we have this mess.

          let
            label     = internalGetText(Label(child))
            thisMenu  = itemToMenu[child.id]

          var menu = thisMenu
          while menu.id in menuSubOpen: menu = menuSubOpen[menu.id]

          let
            subMenu = menu != thisMenu
            h       = (utilLen(menu) + int(subMenu)) * 50

          var
            inside  = false
            clicked = false

          #setLayout(this, w)
          withBarEntry(label, (w: 100, h: h)):
            inside = true

            if subMenu:
              if showLabel(w, "..", off, off).selected:
                inside = false

            processChildren(w, menu)
            for c in utilItems(menu):              
              let arg = eventArg(c, {neClick})
              clicked = arg != nil and arg.element != nil
              if clicked:
                menuClose()
                break

          if not clicked and inside:
            if menu.id notin menuOpen:
              incl(menuOpen, menu.id)
              doEvent(menu, neOpen):
                discard

          else:
            excl(menuOpen, menu.id)
            var m = thisMenu
            
            if clicked:
              while m.id in menuSubOpen:
                let sub = menuSubOpen[m.id]
                del(menuSubOpen, m.id)
                m = sub

            elif subMenu:              
              while true:
                let sub = menuSubOpen[m.id]
                if sub != menu:
                  m = sub
                  continue

                del(menuSubOpen, m.id)
                break
    
    return
  
  ifElement this, Tab:
    let
      side   = internalGetSide(this)
      si     = internalGetSelectedIndex(this)
      child  = utilNChild(this, si)
      region = elementLayout[this.id]

    var i = -1
    
    setLayout(this, w)
    
    withTab(w, ngID[this.id], region):
      for child in utilItems(this):
        inc(i)

        let
          label = tabLabel[child.id]
          s:    tuple[x, y, w, h: int] = 
            case side:
            of nsTOP:    (region.x + 50 * i, region.y, 50, 25)
            of nsBOTTOM: (region.x + 50 * i, region.y + region.h - 25, 50, 25)
            of nsLEFT:   (region.x, region.y + 25 * i, 50, 25)
            of nsRIGHT:  (region.x + region.h - 50, region.y + 25 * i, 50, 25)

        rowLayoutSpace(w, s.x, s.y, s.w, s.h)
        if showButton(
            w,
            internalGetText(label),
            internalGetTooltip(label),
            i == si, Pixel(), 0).selected:
          
          internalSetSelectedIndex(this, i)
          doEvent(this, neClick):
            discard
    do:
      setLayout(child, w)
      processElement(w, child, this)
    return

  ifElement this, Image:
    discard process(w, this, true)
    return
  
  #ifElement this, Menu:
    #for child in utilItems(this):
      #if child.kind == neLabel:
        #if showMenuItemLabel(w, Label(child).internalGetText):
          #discard
  
  ifElement this, Button:
    discard process(w, this, true)
    return
  
  ifElement this, Radio:
    var entry: ptr[type(radioActive[0])]
    if this in radioGroup:
      entry = radioActive[radioGroup[this]].addr

    let active = entry != nil and entry.active == this.id

    setLayout(this, w)
    if showRadio(w, internalGetText(this), active):
      if entry != nil and entry.active != this.id:
        entry.active = this.id
        let args = eventArg(this, {neClick})
        if args != nil: args.element = this

    return
  
  ifElement this, Label:
    let
      inList   = parent of List
      wrap     = internalGetWrap(this)
      selected = inList and
        this.id in listActive[parent.id]

    var
      sel:  bool = selected
      sep:  bool = false

    if parent of Menu:
      sep = (utilChildIndex(Menu(parent), this) + 1) in
        getOrDefault(menuSep, parent.id, {})

    if not inList: setLayout(this, w)
    
    let wd = showLabel(w, internalGetText(this), sel, wrap)
    if sep: drawSeparator(w, wd)
    
    sel = wd.selected
    
    let click = sel xor selected
        
    if click:
      let args = eventArg(this, {neClick})
      if args != nil: args.element = this

      let menu = getOrDefault(itemToMenu, this.id)
      if menu != nil:
        if parent.kind == neMenu:
          menuSubOpen[parent.id] = menu
        else:
          incl(menuOpen, menu.id)
                
      
    #utilSetAttr(this, Size, s)
    
    if click and parent of List:
      let
        set   = listActive[parent.id].addr
        isOn  = this.id in set[]
        isOff = not isOn
        
      template labelOn   = incl(set[], this.id)
      template labelOff  = excl(set[], this.id)
      template labelSwap =
        if isOn: labelOff() else: labelOn()
      
      if click:
        let args = eventArg(parent, {neClick})
        if args != nil: args.element = parent

      case internalGetMode(List(parent)):
      of naNone:
        labelSwap()
      of naMinOne:
        if len(set[]) > 1: labelSwap()
        elif isOff: labelOn()
      of naOne:
        if isOff:
          clear(set[])
          labelOn()
      of naMultiple:
        labelSwap()

    return

  ifElement this, Progress:
    setLayout(this, w)
    var v = internalValue(this)
    if showProgress(w, v, false):
      doEvent(this, neChange):
        discard
    return
  
  ifElement this, Slider:
    setLayout(this, w)
    let
      s = internalGetStep(this)
      r = internalGetRange(this)
      
    var v = internalGetValue(this)
    if showSlider(w, v, r, s):
      internalSetValue(this, v)
      doEvent(this, neChange):
        discard
    return
  
  ifElement this, Entry:
    discard process(w, this, true)
    return

  ifElement this, TextArea:
    discard process(w, this, true)
    return
  
  ifElement this, Checkbox:
    discard process(w, this, true)
    return

  ifElement this, ComboBox:
    discard process(w, this, true)
    return
  
  ifElement this, Calendar:
    let oldDate = internalGetDate(this)
    var date = oldDate
    setLayout(this, w)
    let clicked = showCalendar(w, ngID[this.id], calendarMarked[this.id], date)
    if oldDate != date or clicked:
      internalSetDate(this, date)
      let args = eventArg(this, {neChange})
      if args != nil: args.element = this
    return
  
var stopApp = false

proc internalRun(this: App) =
  stopApp = false

  var
    transient: HashSet[NID]
    repeatDel: HashSet[NRepeatHandle]
    now:       float = epochTime()
    diff:      int
    
  for _, w in items(winList):
    internalSetVisible(w, true)

  while not stopApp:
    diff = int((epochTime() - now) * 1_000)
    now  = epochTime()

    template forEachWin(body) =
      for i in countDown(high(winList), 0):
        let (gW {.inject.}, w {.inject.}) = winList[i]
        if w.id in winDestroyed: continue
        body

    clear(transient)
    for gW, w in items(winList):
      let tw = getTransient(w)
      if tw == nil: continue
      incl(transient, tw.id)
      if internalGetFocus(tw):
        internalSetFocus(w)
        
    glfw.pollEvents()
    
    # Event
    for h, (ms, current, cb) in mpairs(repeatEvents):
      current += diff
      if current >= ms:
        current -= ms
        if not cb(): incl(repeatDel, h)
    
    for i in countDown(high(eventList), 0):
      let (_, args, action) = eventList[i]
      if args.element == nil: continue

      eventArgs = args
      action()
      eventList[i][1].element = nil

    reset(eventArgs)

    # https://discourse.glfw.org/t/how-to-create-multiple-window/1398/2
    forEachWin:
      # glfw -> nk Input
      nk_glfw_new_frame(gW, w.id in transient)

      # Process (Trigger Events + NK Render)
      processElement(gW, w, this)
      if this.id in winDestroyed: continue

      buttonPress = false # In theory, nothing.

    forEachWin:
      # Render (nk -> opengl draw)      
      nk_glfw_render(gW, w.id in forceRender)
      glfw.swapBuffers(gW)
      endFrame(gW)

    # Remove old windows
    for id in winDestroyed:
      for i, (glfwWin, win) in winList:
        if win.id == id:
          delete(winList, i)
          break
        
    # Remove old Events
    for h in repeatDel:
      del(repeatEvents, h)
      
    if len(winDestroyed) != 0 and len(winList) == 0:
      stopApp = true

    clear(repeatDel)
    clear(winDestroyed)
    clear(forceRender)

    # ------
    sleep(20)

proc internalStop(this: App) =
  stopApp = true


# WINDOW ----------------------------------------
proc setText(this: Window | Alert, text: string) =
  let w = glfwWindowOf(this)
  glfwTitle(w, text)
  winTitle[w] = text

proc getText(this: Window | Alert): string = winTitle[glfwWindowOf(this)]

proc internalSetText(this: Window, text: string) = setText(this, text)
proc internalGetText(this: Window): string = getText(this)

proc internalSetResizable(this: Window, state: bool) =
  glfwResizable(glfwWindowOf(this), state)

proc internalGetResizable(this: Window): bool =
  glfwResizable(glfwWindowOf(this))
  
proc setPosition(this: Window | Alert, p: tuple[x, y: int]) =
  glfw.setWindowPos(glfwWindowOf(this), p.x.cint, p.y.cint)

proc getPosition(this: Window | Alert): tuple[x, y: int] =
  var x, y: int32
  glfw.getWindowPos(glfwWindowOf(this), x.addr, y.addr)
  return (int(x), int(y))

proc internalSetPosition(this: Window, position: tuple[x, y: int]) =
  setPosition(this, position)

proc internalGetPosition(this: Window): tuple[x, y: int] =
  getPosition(this)

proc internalGetFocused(this: Window): NElement =
  ## Get the element within this window that has the focus
  beMsg("proc internalGetFocused(this: Window): NElement")

proc internalGetIcon(this: Window): Bitmap =
  ## Get the icon that this window is displaying or nil
  beMsg("proc internalGetIcon(this: Window): Bitmap")

proc internalSetIcon(this: Window, that: Bitmap) =
  glfwIcon(glfwWindowOf(this), (that.w, that.h), that.img[0].addr)

proc internalGetDecorated(this: Window): bool =
  ## Get whether or not this window is displaying the border
  beMsg("proc internalGetDecorated(this: Window): bool")

proc internalSetDecorated(this: Window, v: bool) =
  ## Set whether or not this window is displaying the border
  beMsg("proc internalSetDecorated(this: Window, v: bool)")

proc internalSetMinimized(this: Window, v: bool) =
  ## Set whether or not this window is minimized
  beMsg("proc internalSetMinimized(this: Window, v: bool)")

proc internalGetMinimized(this: Window): bool =
  ## Get whether or not this window is minimized
  beMsg("proc internalGetMinimized(this: Window): bool")

proc internalSetMaximized(this: Window, v: bool) =
  ## Set whether or not this window is maximized
  beMsg("proc internalSetMaximized(this: Window, v: bool)")

proc internalGetMaximized(this: Window): bool =
  ## Get whether or not this window is maximized
  beMsg("proc internalGetMaximized(this: Window): bool")

proc internalSetModal(this: Window, v: bool) =
  ## Set whether or not user can interact with other windows
  beMsg("proc internalSetModal(this: Window, v: bool)")

proc internalGetModal(this: Window): bool =
  ## Get whether or not user can interact with other windows
  beMsg("proc internalGetModal(this: Window): bool")

proc internalSetTransient(this, that: Window) = setTransient(this, that)

proc internalGetTransient(this: Window): Window = getTransient(this)

proc internalGetOpacity(this: Window): float =
  result = 1.0 # Default value
  utilGetAttr(this, opacity)

proc internalSetOpacity(this: Window, v: float) =
  utilSetAttr(this, opacity, v)


# ALERT -----------------------------------------
proc internalRun(this: Alert) =
  let tw = internalGetTransient(this)
  if tw != nil: setPosition(this, getPosition(tw))
  internalSetVisible(this, true)

proc internalSetModal(this: Alert, v: bool) =
  ## Set whether or not user can interact with other windows
  beMsg("proc internalSetModal(this: Alert, v: bool)")

proc internalGetModal(this: Alert): bool =
  ## Get whether or not user can interact with other windows
  beMsg("proc internalGetModal(this: Alert): bool")

proc internalSetTransient(this: Alert, that: Window) = setTransient(this, that)
proc internalGetTransient(this: Alert): Window = getTransient(this)

proc internalSetText(this: Alert, text: string) = utilSetAttr(this, text, text)
proc internalGetText(this: Alert): string = utilGetAttr(this, text)
proc internalSetTitle(this: Alert, text: string) = setText(this, text)
proc internalGetTitle(this: Alert): string = getText(this)


# LABEL -----------------------------------------
proc internalSetText(this: Label, text: string) = utilSetAttr(this, text, text)
proc internalGetText(this: Label): string = utilGetAttr(this, text)

proc internalSetWrap(this: Label, state: bool) = utilSetAttr(this, wrap, state)
proc internalGetWrap(this: Label): bool = utilGetAttr(this, wrap)


# ENTRY -----------------------------------------
proc internalGetText(this: Entry): string = utilGetAttr(this, text)
proc internalSetText(this: Entry, text: string) = utilSetAttr(this, text, text)


# CHECKBOX --------------------------------------
proc internalSetText(this: Checkbox, that: string) =
  checkBoxText[this.id] = that

proc internalGetText(this: Checkbox): string =
  getOrDefault(checkBoxText, this.id)

proc internalGetChecked(this: Checkbox): bool =
  this.id in checkBoxChecked

proc internalSetChecked(this: Checkbox, v: bool) =
  if v: incl(checkBoxChecked, this.id)
  else: excl(checkBoxChecked, this.id)


# BUTTON ----------------------------------------
proc internalSetText(this: Button, text: string) =
  utilSetAttr(this, text, text)

proc internalGetText(this: Button): string =
  utilGetAttr(this, text)

proc internalSetImage(this: Button, img: Bitmap) =
  utilSetAttr(this, Img, img)

proc internalGetImage(this: Button): Bitmap =
  utilGetAttr(this, Img)


# RADIO -----------------------------------------
proc internalSetText(this: Radio, text: string) =
  utilSetAttr(this, text, text)

proc internalGetText(this: Radio): string =
  utilGetAttr(this, text)

proc remGroup(this: Radio) =
  if this notin radioGroup: return

  let i = radioGroup[this]
  del(radioGroup, this)
  dec(radioActive[i].len)
  assert radioActive[i].len >= 0

proc internalSetGroup(radios: openArray[Radio]) =
  for radio in radios: remGroup(radio)
    
  var idx = -1
  for i, (len, active) in radioActive:
    if len == 0:
      idx = i
      break
  
  if idx == -1:
    idx = len(radioActive)
    setLen(radioActive, idx + 1)
    
  let entry = radioActive[idx].addr
  entry.len    = len(radios)
  entry.active = radios[0].id
  for radio in radios: radioGroup[radio] = idx


# BUBBLE ----------------------------------------
proc internalAttach(this: Bubble, that: NElement) =
  beMsg("proc internalAttach(this: Bubble, that: NElement)")


# IMAGE -----------------------------------------
proc internalGetBitmap(this: Image): Bitmap = imgToBitmap[this.id]

proc internalUpdate(this: Image, that: Bitmap) =
  bmpToID[that] = 
    if this.id in imgToBitmap or that in bmpToID:
      updateImage(bmpToID[that], that.img[0].addr, that.w, that.h)
    else:
      initImage(that.img[0].addr, that.w, that.h)

  imgToBitmap[this.id] = that
  
  let parent = root(this)
  if parent != nil: incl(forceRender, parent.id)

proc internalIconBitmap(name: string): Bitmap =
  beMsg("proc internalIconBitmap(name: string): Bitmap")


# TEXTAREA --------------------------------------
proc internalSetText(this: TextArea, text: string) = utilSetAttr(this, Text, text)
proc internalGetText(this: TextArea): string = utilGetAttr(this, Text)


# CALENDAR --------------------------------------
proc internalGetDate(this: Calendar): DateTime = utilGetAttr(this, Date)
proc internalSetDate(this: Calendar, date: DateTime) = utilSetAttr(this, Date, date)
proc internalMark(this: Calendar, day: int) = incl(calendarMarked[this.id], day)
proc internalUnmark(this: Calendar, day: int) = excl(calendarMarked[this.id], day)
proc internalMarked(this: Calendar, day: int): bool = day in calendarMarked[this.id]
proc internalClear(this: Calendar) = calendarMarked[this.id] = {}


# SLIDER ----------------------------------------
proc internalSetDecimals(this: Slider, decimals: int) =
  utilSetAttr(this, Decimals, decimals)

proc internalGetDecimals(this: Slider): int =
  utilGetAttr(this, Decimals)

proc internalSetRange(this: Slider, range: Slice[float]) =
  utilSetAttr(this, range, range)
  
proc internalGetRange(this: Slider): Slice[float] =
  utilGetAttr(this, range)

proc internalSetStep(this: Slider, step: float) =
  utilSetAttr(this, Step, step)

proc internalGetStep(this: Slider): float =
  utilGetAttr(this, Step)

proc internalGetValue(this: Slider): float = utilGetAttr(this, Value)

proc internalSetValue(this: Slider, value: float) =
  utilSetAttr(this, Value, (value.int, value))

proc internalGetOrientation(this: Slider): NOrientation =
  utilGetAttr(this, Orientation)

proc internalSetOrientation(this: Slider, value: NOrientation) =
  utilSetAttr(this, Orientation, value)


# FILECHOOSE ------------------------------------
proc internalSetMultiple(this: FileChoose, state: bool) =
  fbProxy[this.id].mode =
    (if state: naMultiple else: naOne)

proc internalSetText(this: FileChoose, text: string) =
  fbProxy[this.id].text = text
  
proc internalRun(this: FileChoose) =
  show(fbProxy[this.id])


# MENU ------------------------------------------
proc internalAdd(this: NElement, that: Menu) = itemToMenu[this.id] = that


# TABLE -----------------------------------------
proc internalAdd(this: NTable, that: NRow) =
  if utilHasAttr(this, naRows):
    utilWithAttr(this, naRows, add(attr.aRows, that))
  else:
    internalRows(this, @[that])
  
proc internalRows(this: NTable, that: openArray[NRow]) =
  utilSetAttr(this, Rows, @that)

proc internalRows(this: NTable): seq[NRow] =
  utilGetAttr(this, Rows)

proc internalClear(this: NTable, row: int) =
  utilWithAttr(this, naRows):
    delete(attr.aRows, row)
    if len(attr.aRows) == 0: 
      internalClear(this)

proc internalClear(this: NTable) =
  incl(resetLayout, root(this).id)
  utilRemAttr(this, naRows)
  utilRemAttr(this, naSelectedCells)

proc internalHeader(
    this: NTable, header: openArray[tuple[kind: NCellKind, name: string]]) =
  utilSetAttr(this, Header, @header)
  
proc internalHeader(this: NTable): seq[tuple[kind: NCellKind, name: string]] =
  utilGetAttr(this, Header)

proc internalHeaders(this: NTable): bool = utilGetAttr(this, Headers)
proc internalHeaders(this: NTable, v: bool) = utilSetAttr(this, Headers, v)

proc internalSetSelection(this: NTable, mode: NAmount) =
  utilSetAttr(this, Mode, mode)
  
proc internalGetSelection(this: NTable): NAmount =
  utilGetAttr(this, Mode)

proc internalGet(this: NTable, that: var seq[tuple[x, y: int]]) =
  utilWithAttr(this, naSelectedCells, (that = attr.aSelectedCells))

proc internalSet(this: NTable, that: openArray[tuple[x, y: int]]) =
  if utilHasAttr(this, naSelectedCells):
    utilWithAttr(this, naSelectedCells, (attr.aSelectedCells = @that))
  else:
    utilSetAttr(this, SelectedCells, @that)

proc internalSet(this: NTable, that: NRow, y: int) =
  utilWithAttr(this, naRows, (attr.aRows[y] = that))

proc internalGet(this: NTable, y: int): NRow =
  utilWithAttr(this, naRows, (result = attr.aRows[y]))

proc internalSet(this: NTable, that: NCell, x, y: int) =
  utilWithAttr(this, naRows, (attr.aRows[y].cells[x] = that))

proc internalGet(this: NTable, x, y: int): NCell =
  utilWithAttr(this, naRows, (result = attr.aRows[y].cells[x]))


# TREE ------------------------------------------
proc internalAdd(this: Tree, that: NRow, depth: openArray[int]) {.notSupported.}

proc internalRows(this: Tree, that: openArray[NRow]) =
  utilSetAttr(this, Rows, @that)

proc internalRows(this: Tree): seq[NRow] =
  utilGetAttr(this, Rows)

proc internalSet(this: Tree, that: NCell, depth: openArray[int], column: int) {.notSupported.}
proc internalGet(this: Tree, depth: openArray[int], column: int): NCell{.notSupported.}
proc internalSetSelection(this: Tree, mode: NAmount) {.notSupported.}
proc internalGetSelection(this: Tree): NAmount {.notSupported.}
proc internalHeader(this: Tree, header: openArray[tuple[kind: NCellKind, name: string]]) {.notSupported.}
proc internalHeader(this: Tree): seq[tuple[kind: NCellKind, name: string]] =
  discard
  
proc internalClear(this: Tree) =
  utilRemAttr(this, naRows)
  
proc internalHeaders(this: Tree): bool = utilGetAttr(this, Headers)
proc internalHeaders(this: Tree, v: bool) = utilSetAttr(this, Headers, v)


# COMBOBOX -------------------------------------- 
proc internalAdd(this: ComboBox, text: string)  =
  add(comboOptions[this.id], text)

proc internalSet(this: ComboBox, text: string, i: int) =
  comboOptions[this.id][i] = text

proc internalGet(this: ComboBox, i: int): string =
  comboOptions[this.id][i]

proc internalGetSelected(this: ComboBox): string  =
  comboOptions[this.id][comboSelected[this.id]]

proc internalGetSelectedIndex(this: ComboBox): int  =
  comboSelected[this.id]

proc internalSetSelectedIndex(this: ComboBox, i: int) =
  comboSelected[this.id] = i


# PROGRESS --------------------------------------
proc internalValue(this: Progress): float  = utilGetAttr(this, Value)
proc internalValue(this: Progress, v: float) = utilSetAttr(this, Value, (v.int, v))


# BOX -------------------------------------------
proc internalGetOrientation(this: Box): NOrientation =
  utilGetAttr(this, Orientation)

proc internalSetOrientation(this: Box, value: NOrientation) =
  utilSetAttr(this, Orientation, value)
  
proc internalScrollbar(this: Box, state: bool) =
  utilSetAttr(this, Scrolled, state)

proc internalScrollbar(this: Box): bool =
  utilGetAttr(this, Scrolled)


# TAB -------------------------------------------
proc internalAdd(this: Tab, that: Container, label: Label) =
  utilChild(this, that)
  add(tabLabel, that.id, label)

proc internalSetReorderable(this: Tab, v: bool) =
  if v: incl(tabReorderable, this.id) else: excl(tabReorderable, this.id)

proc internalGetReorderable(this: Tab): bool = this.id in tabReorderable

proc internalGetSide(this: Tab): NSide =
  utilGetAttr(this, side)

proc internalSetSide(this: Tab, side: NSide) =
  utilSetAttr(this, side, side)

proc internalGetSelectedIndex(this: Tab): int =
  utilGetAttr(this, Selected)
  
proc internalSetSelectedIndex(this: Tab, i: int) =
  if i == internalGetSelectedIndex(this): return
  utilSetAttr(this, Selected, i)
  incl(resetLayout, root(this).id)


# LIST ------------------------------------------
proc internalGetMode(this: List): NAmount = utilGetAttr(this, Mode)
proc internalSetMode(this: List, mode: NAmount) = utilSetAttr(this, Mode, mode)

proc internalSelected(this: List, that: var seq[NElement]) =
  let s = listActive[this.id].addr
  for child in utilItems(this):
    if child.id in s[]: add(that, child)


# TOOLS -----------------------------------------
proc internalGetOrientation(this: Tools): NOrientation =
  utilGetAttr(this, Orientation)

proc internalSetOrientation(this: Tools, value: NOrientation) =
  utilSetAttr(this, Orientation, value)


# TIMERS -----------------------------------------
proc internalRepeat(event: NRepeatProc, ms: int): NRepeatHandle =
  result = rand(10_000_000).NRepeatHandle # TODO: !!!
  repeatEvents[result] = (ms, 0, event)

proc internalStop(this: NRepeatHandle) =
  del(repeatEvents, this)

proc internalSetTime(this: var NRepeatHandle, ms: int) =
  repeatEvents[this].millis = ms


# CLIPBOARD -------------------------------------
proc internalClipboardClear() =
  beMsg("proc internalClipboardClear()")

proc internalClipboardSet(text: string) =
  beMsg("proc internalClipboardSet(text: string)")

proc internalClipboardSet(img: Bitmap) =
  beMsg("proc internalClipboardSet(img: Bitmap)")

proc internalClipboardGetText: string =
  beMsg("proc internalClipboardGetText: string")

proc internalClipboardGetImg: Bitmap =
  beMsg("proc internalClipboardGetImg: Bitmap")

proc internalClipboardAsyncGet(action: NAsyncTextProc) =
  beMsg("proc internalClipboardAsyncGet(action: NAsyncTextProc)")

proc internalClipboardAsyncGet(action: NAsyncBitmapProc) =
  beMsg("proc internalClipboardAsyncGet(action: NAsyncBitmapProc)")


# ETC -------------------------------------------
proc getKeys(key, mods: cint): (NKey, set[NKey]) =
  let k =
    case key.Key:
    of key0 .. key9:      NKey(key - key0.cint + int(nk0))
    of keyA .. keyZ:      NKey(key - keyA.cint + int(nkA))
    of keyEnter:          nkEnter
    of keyEscape:         nkEsc

    of keyRightControl:   nkControl
    of keyLeftControl:    nkControl
    of keyRightShift:     nkShift
    of keyLeftShift:      nkShift
    else:                 nkNone

  let mods = cast[set[glfw.ModifierKey]](mods)
  var m: set[NKey]
  
  template setMod(a, b) =
    if a in mods: incl(m, b)
    
  setMod(mkShift,   nkShift)
  setMod(mkCtrl, nkControl)

  return (k, m)

proc getSize(this: NElement): tuple[w, h: int] =
  const
    DEF_H = 29

  result = internalGetSize(this)
  if result != (0, 0): return

  if this of Image:
    return internalGetSize(this)

  # TODO: Font size
  if this of Bar:
    return (10_000, DEF_H)
  if this of Calendar:
    return (10_000, 220)
  if this of Button:
    result = (15 * internalGetText(Button(this)).len, DEF_H)
    let bmp = internalGetImage(Button(this))
    if bmp != nil:
      result.w += bmp.w
      result.h = max(result.h, bmp.h)
      
    result.w = max(result.w, DEF_H)
    return
    
  if this of Radio:
    return (15 * internalGetText(Radio(this)).len, DEF_H)
  if this of Label:
    return (15 * internalGetText(Label(this)).len, DEF_H)
  if this.kind in {neEntry, neComboBox, neCheckBox, neSlider}:
    return (10_000, DEF_H)
  if this of NTable:
    let this = NTable(this)
    for r in internalRows(this):
      var rs: tuple[w, h: int]
      rs.w = 10_000
      for c in r.cells:
        case c.kind:
        of ckBool, ckStr, ckInt:
          rs.h = max(rs.h, DEF_H)
        of ckImg:
          rs.h = max(rs.h, c.vImg.h)
          
      result.w = max(rs.w, result.w)
      result.h+= rs.h
    return

  if this of Container:
    var orientation = noVERTICAL
    if this of Tools:
      orientation = internalGetOrientation(Tools(this))
    elif this of Box:
      orientation = internalGetOrientation(Box(this))

    for c in utilItems(Container(this)):
      let (w, h) = getSize(c)

      case orientation:
      of noVERTICAL:
        result.w = max(result.w, w)
        result.h += h
      of noHORIZONTAL:
        result.w += w
        result.h = max(result.h, h)

proc genLayout(w: Window, size: tuple[x, y, w, h: int]) =
  if w.id notin resetLayout: return
  excl(resetLayout, w.id)
  if utilLen(w) == 0: return
  
  type VarList = STable[NID, tuple[x, y, w, h: Variable]]
  var vars: VarList

  let S = newSolver()
  
  const # TODO: allow customization
    X_M = 6  # X Margin
    Y_M = 4  # Y Margin
    W_M = 22 # Width Margin
    H_M = 14 # Height Margin
    E_M = 4  # Element Margin
    S_M = 30 # Group Width Margin
  
  # Add Constraints
  proc addConstraints(this: NElement, S: Solver, vars: var VarList) =
    let x, y, w, h = newVariable()
    vars[this.id] = (x, y, w, h)

    if this of Menu: return
    if this of List: return
    if this of NTable: return
    if not(this of Container) or this of ComboBox or this of Bar:
      return

    let
      this = Container(this)
      len  = utilLen(this)

    if len == 0: return
  
    if len == 1 and utilNChild(this, 0) of Container:
      addConstraints(utilNChild(this, 0), S, vars)
      let c = vars[utilNChild(this, 0).id]

      S.addConstraint(c.x == x + X_M)
      S.addConstraint(c.y == y + Y_M)
      S.addConstraint(c.w == w - W_M)
      S.addConstraint(c.h == h - H_M)
      return
    
    if this of Tab:
      let
        this = Tab(this)
        side = internalGetSide(this) # Header side, not Content
        i    = internalGetSelectedIndex(this) # Content
      
      addConstraints(utilNChild(this, i), S, vars)
      let c = vars[utilNChild(this, i).id]
      
      const
        TAB_H_WIDTH  = 50
        TAB_H_HEIGHT = 25
      
      case side:
      of nsBOTTOM: S.addConstraint(c.y + c.h == y + h - TAB_H_HEIGHT)
      of nsTOP:    S.addConstraint(c.y == y + TAB_H_HEIGHT)
      of nsLEFT:   S.addConstraint(c.x == x + TAB_H_WIDTH)
      of nsRIGHT:  S.addConstraint(c.x + c.w == x + w - TAB_H_WIDTH)

      if side != nsBOTTOM: S.addConstraint(c.y + c.h == y + h)
      if side != nsRIGHT:  S.addConstraint(c.x + c.w == x + w)
      if side != nsLEFT:   S.addConstraint(c.x == x)
      if side != nsTOP:    S.addConstraint(c.y == y)
      return
      
    let dir =
      if this.kind notin {neBox, neTools}:
        noVERTICAL
      else:
        if this of Box: internalGetOrientation(Box(this))
        else:           internalGetOrientation(Tools(this))

    var i = -1
    let am = if this of List: S_M else: 0
    var X_M = X_M.float
    var W_M = W_M.float
    if this of TOols:
      X_M = -X_M
      W_M = 0
    
    for e in utilItems(this):
      inc(i)
      addConstraints(e, S, vars)
      let ve = vars[e.id]

      if dir == noVERTICAL:
        S.addConstraint(ve.x == x + X_M)
        S.addConstraint(ve.w == w - (W_M + float(am)))
        if i == 0:
          S.addConstraint(
            if e of Bar: ve.y == 0 else: ve.y == y + Y_M)
        if i == len - 1 and not(e of Bar) and e of Container:
          S.addConstraint(ve.y + ve.h == (y + Y_M + h) - H_M)
      else:
        S.addConstraint(ve.y == y + Y_M)
        S.addConstraint(ve.h == h - H_M)
        if i == 0:       S.addConstraint(ve.x == x + X_M)
        if i == len - 1: S.addConstraint(ve.x + ve.w == (x + X_M + w) - W_M)

    for i in 0 .. len - 2:
      let (v1, v2) =
        (vars[utilNChild(this, i).id], vars[utilNChild(this, i + 1).id])
      if dir == noVERTICAL: S.addConstraint(v1.y + v1.h == v2.y + E_M)
      else:                 S.addConstraint(v1.x + v1.w == v2.x + E_M)

  addConstraints(utilNChild(w, 0), S, vars)
  
  proc addSuggestions(this: NElement, S: Solver, vars: VarList) =
    if this of Container and not(
        this of NTable or this of Menu or this of List or this of Bar):
      if this of Tab:
        let c = utilNChild(Tab(this), internalGetSelectedIndex(Tab(this)))
        addSuggestions(c, S, vars)
        
      else:
        for c in utilItems(Container(this)):
          addSuggestions(c, S, vars)

    template suggest(v: Variable, value: typed) =
      S.addEditVariable(v, STRONG)
      S.suggestValue(v, value.float)

    let
      (_, _, w, h) = vars[this.id]
      size         = getSize(this)

    w.suggest(size.w)
    h.suggest(size.h)
  
  addSuggestions(utilNChild(w, 0), S, vars)

  block:
    let (x, y, w, h) = vars[utilNChild(w, 0).id]
    S.addConstraint(x == size.x.float)
    S.addConstraint(y == size.y.float)
    S.addConstraint(w == size.w.float)
    S.addConstraint(h == size.h.float)

  S.updateVariables()
  for id, (x, y, w, h) in pairs(vars):
    elementLayout[id] = (
      x.value.int, y.value.int, w.value.int, h.value.int,)
    
  
  proc debug(this: NElement, p: string = "") {.used.} =
    if this.id notin elementLayout: return
    echo(p, (this.kind, elementLayout[this.id]))
    if not(this of Container): return
    for c in utilItems(Container(this)): debug(c, p & "  ")
    
  # debug(utilNChild(w, 0))
