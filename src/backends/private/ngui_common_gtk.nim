includeUtils ELEMENT, CONTAINER, EVENT, TIMER, ADAPTER


# INCLUDED IN ngui_begtk3
const
  v3 = backend == beGTK3


# GTK3 START ------------------------------------  
when v3:
  include gtk3_min#oldgtk3/[gtk, glib, gobject, gdk, cairo, gdk_pixbuf]
  # TODO Remove/move this to gtk3_min
  const
    SCB          = proc(p: pointer): auto = gCALLBACK(p)
    gtkRef       = proc(w: GPointer) = discard objectRef(cast[GPointer](w))
    gtkDestroy   = proc(w: gtkWidget) = destroy(w)

  template signal(a, b, c, d: typed): auto =
    gSignalConnect(a, b, c, d)
  
  proc newLabel(): auto = newLabel("")
  proc newRadioButton(): auto = newRadioButton(group = nil)
  proc newWindow(): auto = newWindow(WindowType.TOP_LEVEL)
  proc newPopover(): auto = newPopover(nil)
  proc newFileChooser(): auto = newFileChooserDialog(nil, nil, OPEN, nil)
  proc newComboBox(): auto = newComboBox(
    cast[gtkTreeModel](newListStore(1, G_TYPE_STRING)))
  proc newBox(): auto = newBox(Orientation.Vertical, 0)
  proc newMessageDialog(): auto = newMessageDialog(
    nil,
    DialogFlags.MODAL, # TODO: TODO
    MessageType.OTHER,
    ButtonsType.CLOSE,
    nil)
  #proc loadPixbuf(file: string): GDKPixbuf =
    #var error: glib.GError
    #return newPixbufFromFile(file, error)


let # Doesn't work with const, but one day ...
  adapters = genAdapters(
    pointer(cast[gtkWidget](c).getParent())
    ,cast[gtkContainer](p).remove(cast[gtkWidget](c))
    ,cast[gtkContainer](p).add(cast[gtkWidget](c))
  )

  adaptersEventBox = genAdaptersFrom(
    adapters,
    block:
      # Adapter 1 https://developer.gnome.org/gtk3/stable/GtkEventBox.html
      let eb = newEventBox()
      addEvents(gtkWidget(eb), POINTER_MOTION_MASK.cint)
      return pointer(eb)
    ,(gtkRef(GObject(c))))

  adaptersMenuItem = genAdaptersFrom(
    # Adapter 2 https://developer.gnome.org/gtk3/stable/GtkMenuItem.html
    adapters, newMenuItem(), (gtkRef(GObject(c))))
  
  adaptersToolItem = genAdaptersFrom(
    # Adapter 3 https://developer.gnome.org/gtk3/stable/GtkToolItem.html
    adapters, newToolItem(), (gtkRef(GObject(c))))
    
  adaptersScrolledWindow = genAdaptersFrom(genAdapters(
    # Adapter 4 https://developer.gnome.org/gtk3/stable/GtkScrolledWindow.html
      block:
        # https://developer.gnome.org/gtk3/stable/GtkScrolledWindow.html#GtkScrolledWindow.description
        # "Widgets with native scrolling support, i.e. those whose classes
        # implement the GtkScrollable interface, are added directly. For other
        # types of widget, the class GtkViewport acts as an adaptor"
        var parent = getParent(gtkWidget(c))
        if pointer(parent) == nil: return
        result = pointer(parent)

        while not bool(gTypeCheckInstanceType(parent, scrolledWindowGetType())):
          parent = getParent(parent)
          if pointer(parent) == nil: return

        return pointer(parent)
      ,cast[gtkContainer](p).remove(cast[gtkWidget](c))
      ,cast[gtkContainer](p).add(cast[gtkWidget](c))
    ),
    block:
      let sw = gtkWidget(newScrolledWindow(nil, nil))
      # https://stackoverflow.com/questions/14250927/gtk-scroll-window-size-in-a-grid
      setVExpand(sw, GBoolean(true))
      setHExpand(sw, GBoolean(true))
      pointer(sw)
    ,(gtkRef(GObject(c)))
  )


var
  gtkScaleRange: STable[NID, Slice[float]]
  gtkScaleStep:  STable[NID, float]
  gtkIconified:  HashSet[NID]
  insideFCResponse: bool # More dirty HACKS

  

# ETC -------------------------------------------
template gtkAAAAAAAAAAAAAAA() {.dirty.} =
  val =
    when val is bool:   bool(addr(v).getBoolean())
    elif val is int:    int(addr(v).getInt())
    elif val is string: $(addr(v).getString())
    elif val is Pixel:
      var c: RGBA
      # https://stackoverflow.com/a/47373201
      context.get(thisD.getStateFlags(), prop, c.addr, nil)
      let p = pixel(c.red, c.green, c.blue, c.alpha)
      rgbaFree(c)
      p
      
    else: discard

  unset(v.addr)

proc invokeSatanSet(
    this: NElement, css: string, args: varargs[string, `$`]): bool =
    
  let
    # The evil that men do lives on and on
    # https://developer.gnome.org/gtk3/stable/chap-css-properties.html
    # https://developer.gnome.org/gtk3/stable/GtkStyleContext.html
    context  = this.data(gtkWidget).getStyleContext()
    provider = newCssProvider()
    css      = css % args
    
  doAssert pointer(context) != nil
  doAssert provider != nil

  var error: GError
  result = bool(provider.loadFromData(cstring(css), css.len, error))
  addProvider(context, provider, STYLE_PROVIDER_PRIORITY_USER)

proc invokeSatanGet[T](this: NElement, prop: string, val: var T) =
  let
    thisD   = this.data(gtkWidget)
    context = thisD.getStyleContext()

  when val is Pixel:
    var c: RGBA
    # https://stackoverflow.com/a/47373201
    get(context, thisD.getStateFlags(), prop, c.addr, nil)
    if c != nil:
      val = pixel(c.red, c.green, c.blue, c.alpha)
      rgbaFree(c)
    
  else:
    var v: GValueObj
    getProperty(context, prop, thisD.getStateFlags(), v.addr)
    gtkAAAAAAAAAAAAAAA()


proc gtkGet[T](this: NElement, prop: string, val: var T) =
  # https://developer.gnome.org/gobject/stable/gobject-Standard-Parameter-and-Value-Types.html
  # https://developer.gnome.org/gobject/stable/gobject-The-Base-Object-Type.html#g-object-get-property
  var v: GValueObj
  this.data(GObject).getProperty(prop, addr(v))
  gtkAAAAAAAAAAAAAAA()

proc gtkGet[T](this: NElement, prop: string): T =
  gtkGet(this, prop, result)

proc gtkSet[T](this: NElement, prop: string, val: T) =
  var v: GValueObj
  
  when val is bool:
    discard init(v, G_TYPE_BOOLEAN)
    setBoolean(v, GBoolean(val))
  elif val is int:
    discard init(v, G_TYPE_INT)
    setInt(v, val.cint)
  elif val is string:
    discard init(v, G_TYPE_STRING)
    setString(v, val.cstring)
  elif val is Pixel:
    var c: RGBAObj
    c.red = cdouble(val.r) / 255
    c.green = cdouble(val.g) / 255
    c.blue = cdouble(val.b) / 255
    c.alpha = cdouble(val.a) / 255
    setProperty(this.data(gtkWidget), prop, addr(c))
    return

  # https://developer.gnome.org/gobject/stable/gobject-The-Base-Object-Type.html#g-object-set-property
  setProperty(this.data(GObject), prop, addr(v))

type
  TMPath = object # gtkTreeModel # TODO: Move to ngui.nim
    row, column: int
    depth:       tuple[s: ptr[int], len: int]
    ti:          gtkTreeIterObj
    

proc tmPath(row, column: int): TMPath = TMPath(row: row, column: column)

proc tmPath(depth: openArray[int], row: int, column: int = -1): TMPath =
  TMPath(
    depth:  ((if len(depth) == 0: nil else: unsafeAddr(depth[0])), len(depth)),
    row:    row,
    column: column)

template toTreePath(tmPath: TMPath): auto =
  block:
    if isNil(tmPath.depth.s):
      newTreePath(cint(tmPath.row), -1)
    else:
      newTreePath(cast[var cint](tmPath.depth.s), Gsize(tmPath.depth.len))

template withIter(tmPath: TMPath, body: untyped) =  
  block:
    var ti {.inject.}: gtkTreeIterObj
    let tPath {.inject.} = toTreePath(tmPath)

    doAssert pointer(tPath) != nil

    # TODO: Pass list/tree store explicitly
    if bool(getIter(cast[gtkTreeModel](ls), addr(ti), tPath)):
      body

    free(tPath)

template treeChildrenLen(tmPath): int =
  var r: int
  withIter(tmPath):
    r = gtk_tree_model_iter_n_children(model, iter)
  r


# EVENTS ----------------------------------------
proc clean(this: NElement) {.cdecl.} =
  if not utilExists(this): return

  if this of Container:
    for c in utilItems(Container(this)):
      clean(c)

  let raw = gtkWidget(this.raw)

  utilDel(this)
  #utilDelParent(this)

  del(names, this)
  del(tags, this)
  discard utilDelAdapter(pointer(raw), adapters)

  if this of Container:
    utilRemChildrenList(Container(this))

  if this of Slider:
    del(gtkScaleRange, this.id)
    del(gtkScaleStep,  this.id)

  utilDelEventSource(pointer(raw))

proc gtkOnDestroyClean(_, data: GPointer) {.cdecl.} =
  clean(cast[NElement](data))

var setEventHandled: bool

proc internalEventHandled =
  setEventHandled = true

proc triggerEvent(source, data: GPointer): bool {.cdecl.} =
  let event = cast[NElementEvent](data)
  if not utilTrigger(event, source):
    raiseAssert("Event CallBack not found: " & $(event))
  result = setEventHandled
  setEventHandled = false

proc internalSetEvent(
    this: NElement, event: NElementEvent, action: NEventProc) =
  # Feast your eyes
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#GtkWidget.signals
  const EVENT_TO_SIGNAL: array[NElementEvent, string] = [
    neNone: "LET'S_DANCE",
    neClick: "button-press-event",
    neClickRelease: "button-release-event",
    neMove: "motion-notify-event",
    neEnter: "activate",
    neChange: "changed",
    neOpen: "popped-up",
    neFocusOn: "focus-in-event",
    neFocusOff: "focus-out-event",
    neDESTROY: "destroy",
    neSHOW: "show",
    neHIDE: "hide",
    neKeyPress: "key_press_event",
    neKeyRelease: "key-release-event",
    neFILE_CHOOSE_ACCEPT: "response",
  ]
  
  doAssert event notin {neNone}

  var
    nguiEvent   = event
    nguiTrigger = SCB(triggerEvent)
    gtkInst     = cast[gtkWidget](this.raw)
    gtkEvent    = EVENT_TO_SIGNAL[nguiEvent]
    gtkData     = cast[GPointer](nguiEvent)


  # -----------------------------------
  # Hack List, insert your hacks here -

  # REASON: Special user function
  if not (this of Button) and
      nguiEvent in {neFocusOff, neFocusOn, neKeyPress,
                   neKeyRelease, neClick, neClickRelease, neMove}:
    nguiTrigger = SCB(
      proc(s, _, d: GPointer): bool {.cdecl.} =
        triggerEvent(s, d)
    )
  
  # REASON: Hard to explain
  if this of Image and nguiEvent in {neClick, neClickRelease, neMove}:
    # https://developer.gnome.org/gtk3/stable/GtkImage.html#GtkImage.description
    # "Handling button press events on a GtkImage."
    gtkInst  = gtkWidget(utilInsertAdapter(pointer(gtkInst), adaptersEventBox))

  # REASON: Different name
  if this of FileChoose and nguiEvent == neClick:
    # https://developer.gnome.org/gtk3/stable/GtkDialog.html#GtkDialog-response
    gtkEvent = EVENT_TO_SIGNAL[neFILE_CHOOSE_ACCEPT]
  
  elif this of Button and nguiEvent == neClick:
    # https://developer.gnome.org/gtk3/stable/GtkButton.html#GtkButton-clicked
    gtkEvent = "clicked"
  
  elif this of Slider and nguiEvent == neChange:
    # https://developer.gnome.org/gtk3/stable/GtkRange.html#GtkRange-value-changed
    gtkEvent = "value-changed"

  elif this of Checkbox and nguiEvent == neChange:
    # https://developer.gnome.org/gtk3/stable/GtkToggleButton.html#GtkToggleButton-toggled
    gtkEvent = "toggled"
  
  elif this of List and nguiEvent in {neChange, neClick}:
    # https://developer.gnome.org/gtk3/stable/GtkListBox.html#GtkListBox-selected-rows-changed
    gtkEvent = "selected-rows-changed"

  elif this of Calendar and nguiEvent in {neChange}:
    # https://developer.gnome.org/gtk3/stable/GtkCalendar.html#GtkCalendar-day-selected
    gtkEvent = "day-selected"

  # REASON: Event applies only to TextBuffer
  elif this of TextArea and nguiEvent in {neChange}:
    # https://developer.gnome.org/gtk3/stable/GtkTextView.html#gtk-text-view-get-buffer
    # https://developer.gnome.org/gtk3/stable/GtkTextBuffer.html#GtkTextBuffer-changed
    gtkInst = cast[gtkWidget](gtkTextView(gtkInst).getBuffer())

  # REASON: onClick is triggered for old/new radio
  # elif this of Radio and nguiEvent in {neClick}: No longer a bug?!
    #nguiTrigger = SCB(proc(source, data: GPointer): bool {.cdecl.} =
      #if bool(cast[gtkRadioButton](source).getActive()):
        #return triggerEvent(source, data))

  # REASON: Labels don't really have click events, but we need this for menus
  elif this of Label and nguiEvent in {neClick}: # TODO: Handle onClick for labels outside menus
    # https://developer.gnome.org/gtk3/stable/GtkMenuItem.html#GtkMenuItem-activate
    gtkEvent = "activate"
    gtkInst  =
      gtkWidget(utilInsertAdapter(pointer(gtkInst), adaptersMenuItem))
  
  # REASON: Snowflake callback, and the first time is triggered twice
  elif this of Menu and nguiEvent in {neOpen}:
    # https://developer.gnome.org/gtk3/stable/GtkMenu.html#GtkMenu-popped-up
    nguiTrigger = SCB(
        proc(
          source, b, c: GPointer,
          d, e: GBoolean,
          data: GPointer): GBoolean {.cdecl.} =
      once: return # Why?!
      return GBoolean(triggerEvent(source, data))
    )
        
  if gtkEvent in [EVENT_TO_SIGNAL[neFILE_CHOOSE_ACCEPT]]:
    # https://docs.gtk.org/gtk3/signal.Dialog.response.html
    nguiTrigger = SCB(
        proc(source: GPointer, response: Gint, data: GPointer): GBoolean {.cdecl.} =

      if response != 0 and ResponseType(response) != ACCEPT: return
        
      var src = gtkWidget(source)

      while not bool(gTypeCheckInstanceType(src, fileChooserGetType())):
        src = getParent(src)
        doAssert pointer(src) != nil
        
      insideFCResponse = on   # DANGER: dirty HACK here
      result = GBoolean(triggerEvent(GPointer(src), data))
      insideFCResponse = off  # DANGER: dirty HACK here
    )


  # -------------------------------------
  doAssert not utilExists(nguiEvent, pointer(gtkInst)) # TODO: replace old event with new one.
  utilSet(nguiEvent, pointer(gtkInst), action)
  # https://developer.gnome.org/gobject/stable/gobject-Signals.html#g-signal-connect

  discard signal(pointer(gtkInst), cstring(gtkEvent), nguiTrigger, gtkData)

proc internalTriggerEvent(event: NEventArgs) =
  raiseAssert("Not implemented")
  
  
var bmpToPixbuf: STable[Bitmap, GDKPixbuf]

proc setPixbuf(this: Bitmap, that: GdkPixBuf) =
  let b = cast[ptr[UncheckedArray[Pixel]]](getPixels(that))
  for i, p in pairs(this.img): b[i] = p

proc pixbuf(this: Bitmap): GDKPixbuf =
  result = getOrDefault(bmpToPixbuf, this, nil)
  if pointer(result) == nil:
    const rgb = GdkColorspace.RGB
    result = newPixbuf(rgb, GBoolean(true), 8, this.w.cint, this.h.cint)
    bmpToPixbuf[this] = result
    setPixbuf(this, result)

proc newBitmap(pixbuf: GDKPixbuf): Bitmap # FD

proc bitmap(this: GDKPixbuf): Bitmap =
  for key, value in bmpToPixbuf:
    if pointer(this) == pointer(value): return key
  result = newBitmap(this)
  bmpToPixbuf[result] = this

proc updatePixbuf(this: Bitmap) = setPixbuf(this, pixbuf(this))
  
proc toOrientation(dir: NOrientation): Orientation = Orientation(dir.int)
proc toNOrientation(dir: Orientation): NOrientation = NOrientation(dir.int)

proc toGTKSelection(this: NAmount): gtkSelectionMode =
  gtkSelectionMode(this.int)

proc toNGUISelection(this: gtkSelectionMode): NAmount =
  NAmount(this.int)


# NELEMENT --------------------------------------
proc internalSetVisible(this: NElement, state: bool) =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-visible
  this.data(gtkWidget).setVisible(GBoolean(state))
  
proc internalGetVisible(this: NElement): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-visible
  if this of App: return
  return bool(this.data(gtkWidget).getVisible())

proc internalGetFocus(this: NElement): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-is-focus
  bool(this.data(gtkWidget).isFocus())

proc internalSetFocus(this: NElement) =
  let thisD = this.data(gtkWidget)
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-grab-focus
  thisD.setCanFocus(GBoolean(true))
  thisD.grabFocus()

proc internalSetTooltip(this: NElement, text: string) =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-tooltip-text
  this.data(gtkWidget).setToolTipText(text)
  
proc internalGetTooltip(this: NElement): string =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-tooltip-text
  $this.data(gtkWidget).getToolTipText()

proc internalSetDestroy(this: NElement) =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-destroy
  this.data(gtkWidget).destroy()

proc internalGetDestroy(this: NElement): bool = not utilExists(this)
proc internalGetParent(this: NElement): Container = utilParent(this)

proc internalGetNext(this: NElement): NElement = utilNext(this)
proc internalGetPrev(this: NElement): NElement = utilPrev(this)

proc adjustSize(this: NElement) =
  if this.internalGetParent() == nil: return
  
  # https://stackoverflow.com/a/9691465 Shrink Window
  let parent = this.internalGetParent()
  
  if parent of Window:
    let (w, h) = internalGetSize(this)
    # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-resize
    resize(parent.data(gtkWindow), w.cint, h.cint)
    
  adjustSize(parent)

proc internalGetSize(this: NElement): tuple[w, h: int] =
  # uggh ...
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-preferred-size
  result = (-1, -1)

  var a, b: Requisition
  this.data(gtkWidget).getPreferredSize(a, b)
  if b != nil: return (b.width.int, b.height.int)

proc internalSetSize(this: NElement, size: tuple[w, h: int]) =
  let w = this.data(gtkWidget)
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-size-request
  w.setSizeRequest(size.w.cint, size.h.cint)
  #let adapter = utilGetAdapter(w)
  #if adapter != nil:
    #cast[gtk.Widget](adapter).setSizeRequest(size.w.cint, size.h.cint)

  if this of Progress:
    discard invokeSatanSet(this,
      "trough{min-width:$1px;min-height:$2px;}progress{min-height:$2px;}",
        size.w, size.h)
  
  adjustSize(this)

proc onDestroyWin(this: Window) # FD

proc internalInitNElement(this: var NElement) =  
  case this.kind:
  of neApp:
    initWithArgv()
    return

  of neWindow:
    # https://developer.gnome.org/gtk3/stable/GtkWindow.html
    let w = newWindow()
    this.data = pointer(w)
    onDestroyWin(Window(this))
    
    # NOTE GTK3: Apparently, the only why to get this info.
    # https://docs.gtk.org/gtk3/method.Window.iconify.html#description
    # https://docs.gtk.org/gtk3/signal.Widget.window-state-event.html
    # https://docs.gtk.org/gdk3/struct.EventWindowState.html
    discard signal(
      this.data(GPointer),
      "window-state-event",
      SCB(
        proc(
            _:     gtkWidget,
            state: EventWindowState,
            id:    GPointer): GBoolean {.cdecl.} =
          let
            id  = cast[NID](id)
            ico = (int(state.newWindowState) and
                  int(WindowState.ICONIFIED)) != 0

          if ico: incl(gtkIconified, id) else: excl(gtkIconified, id)
      ),
      cast[GPointer](this.id))

  of neLabel:
    # https://developer.gnome.org/gtk3/stable/GtkLabel.html
    this.data = pointer(newLabel())
    
  of neEntry:
    # https://developer.gnome.org/gtk3/stable/GtkEntry.html
    this.data = pointer(newEntry())
    
  of neButton:
    # https://developer.gnome.org/gtk3/stable/GtkButton.html
    this.data = pointer(newButton())
    
  of neRadio:
    # https://developer.gnome.org/gtk3/stable/GtkRadioButton.html
    this.data = newRadioButton()
  
  of neBubble:
    # https://developer.gnome.org/gtk3/stable/GtkPopover.html
    this.data = pointer(newPopover())
  
  of neImage:
    # https://developer.gnome.org/gtk3/stable/GtkImage.html
    this.data = pointer(newImage())
    
  of neTextArea:
    # https://developer.gnome.org/gtk3/stable/GtkTextView.html
    this.data = pointer(newTextView())
    
  of neCalendar:
    # https://developer.gnome.org/gtk3/stable/GtkCalendar.html
    this.data = pointer(newCalendar())
    
  of neSlider:
    # https://developer.gnome.org/gtk3/stable/GtkScale.html
    let s = newScale(Orientation.HORIZONTAL, 0, 100, 1) 
    s.setDrawValue(GBoolean(false))
    this.data = pointer(s)
    
  of neCheckbox:
    # https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
    this.data = pointer(newCheckButton())
  
  of neFileChoose:
    # https://developer.gnome.org/gtk3/stable/GtkFileChooserDialog.html
    this.data = pointer(newFileChooser())
    discard addButton(this.data(gtkDialog), "Open", 0)

  of neTab:
    # https://developer.gnome.org/gtk3/stable/GtkNotebook.html
    this.data = pointer(newNoteBook())
  
  of neBar:
    # https://developer.gnome.org/gtk3/stable/GtkMenuBar.html
    this.data = pointer(newMenuBar())
  
  of neMenu:
    # https://developer.gnome.org/gtk3/stable/GtkMenu.html
    this.data = pointer(newMenu())
  
  of neComboBox:
    # https://developer.gnome.org/gtk3/stable/GtkComboBox.html
    # TODO: Can handle more than text
    let
      c  = newComboBox()
      r  = newCellRendererText()
      cl = gtkCellLayout(c)

    packStart(cl, r, GBoolean(true))
    addAttribute(cl, r, "text", 0)
  
    this.data = pointer(c)
    
  of neProgress:
    # https://developer.gnome.org/gtk3/stable/GtkProgressBar.html
    this.data = pointer(newProgressBar())
  
  of neBox:
    # https://developer.gnome.org/gtk3/stable/GtkBox.html
    this.data = pointer(newBox())
    
  of neTable:
    # https://developer.gnome.org/gtk3/stable/GtkTreeView.html
    # https://developer.gnome.org/gtk3/stable/GtkListStore.html
    this.data = pointer(newTreeView())
    
  of neTools:
    # https://developer.gnome.org/gtk3/stable/GtkToolbar.html
    this.data = pointer(newToolBar())
    
  of neTree:
    # https://developer.gnome.org/gtk3/stable/GtkTreeView.html
    this.data = pointer(newTreeView())

  of neList:
    # https://developer.gnome.org/gtk3/stable/GtkListBox.html
    this.data = pointer(newListBox())

  of neAlert:
    # https://developer.gnome.org/gtk3/stable/GtkMessageDialog.html
    this.data = newMessageDialog()

  else:
    raiseAssert("Invalid kind: " & $this.kind)
  
  doAssert this.raw != nil

  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#GtkWidget-destroy
  discard signal(
    this.data(GPointer),
    "destroy",
    SCB(gtkOnDestroyClean),
    cast[GPointer](this))


# WINDOW ----------------------------------------
proc internalSetText(this: Window, text: string) =
  setTitle(this.data(gtkWindow), text)

proc internalGetText(this: Window): string =
  $this.data(gtkWindow).getTitle()

proc internalSetResizable(this: Window, state: bool) =
  this.data(gtkWindow).setResizable(GBoolean(state))

proc internalGetResizable(this: Window): bool =
  bool(this.data(gtkWindow).getResizable())

proc internalSetPosition(this: Window, position: tuple[x, y: int]) =
  this.data(gtkWindow).move(position.x.cint, position.y.cint)

proc internalGetPosition(this: Window): tuple[x, y: int] =
  var x, y: cint
  this.data(gtkWindow).getPosition(x, y)
  return (x.int, y.int)

proc internalGetFocused(this: Window): NElement =
  let widget = pointer(this.data(gtkWindow).getFocus())
  if widget == nil: return
  return utilElement(widget)

proc internalGetIcon(this: Window): Bitmap =
  newBitmap(this.data(gtkWindow).getIcon())

proc internalSetIcon(this: Window, that: Bitmap) =
  this.data(gtkWindow).setIcon(pixbuf(that))

proc internalGetDecorated(this: Window): bool =
  bool(this.data(gtkWindow).getDecorated())
  
proc internalSetDecorated(this: Window, v: bool) =
  this.data(gtkWindow).setDecorated(GBoolean(v))

proc internalSetMinimized(this: Window, v: bool) =
  if v: this.data(gtkWindow).iconify()
  else: this.data(gtkWindow).deiconify()
  
proc internalGetMinimized(this: Window): bool =
  this.id in gtkIconified

proc internalSetMaximized(this: Window, v: bool) =
  if v: this.data(gtkWindow).maximize()
  else: this.data(gtkWindow).unmaximize()
  
proc internalGetMaximized(this: Window): bool =
  bool(this.data(gtkWindow).isMaximized())

proc onDestroyWin(this: Window) =
  # TODO: This should be optional
  proc cb(this: gtkWidget, data: GPointer) {.cdecl.} =
    if utilLen(getApp()) <= 1: internalStop(getApp())
  discard signal(this.data(GPointer), "destroy", SCB(cb), nil)

proc internalSetModal(this: Window, v: bool) =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-set-modal
  this.data(gtkWindow).setModal(GBoolean(v))

proc internalGetModal(this: Window): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-modal
  bool(this.data(gtkWindow).getModal())
  
proc internalSetTransient(this, that: Window) =
  # https://docs.gtk.org/gtk3/method.Window.set_transient_for.html
  this.data(gtkWindow).setTransientFor(that.data(gtkWindow))

proc internalGetTransient(this: Window): Window =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-transient-for
  let w = pointer(getTransientFor(this.data(gtkWindow)))
  if w != nil: return Window(utilElement(w))


# CONTAINER -------------------------------------
proc internalRemove(this: Container, that: NElement) =  
  let (thisD, thatD) = (this.data(gtkContainer), that.data(gtkWidget))
  doAssert pointer(thisD) != nil and pointer(thatD) != nil

  utilRemove(this, that)

  if not utilDelAdapter(pointer(thatD), adapters):
    # https://developer.gnome.org/gtk3/stable/GtkContainer.html#gtk-container-remove
    thisD.remove(thatD)
    discard

  adjustSize(this)

#proc reinsert(this: NElement) = utilChildrenReinsert(this.internalGetParent())

proc internalReplace(container: Container, this, that: NElement) =
  # TODO
  raiseAssert("Not implemented YET")

proc internalIndex(this: Container, that: NElement): int =
  utilChildIndex(this, that)

proc internalGetChild(this: Container, index: int): NElement =
  utilNChild(this, index)

proc internalLen(this: Container): int = utilLen(this)

proc internalAddSeparator(this: Container, dir: NOrientation) =
  # https://developer.gnome.org/gtk3/stable/GtkSeparator.html
  # https://developer.gnome.org/gtk3/stable/GtkSeparatorMenuItem.html
  # https://developer.gnome.org/gtk3/stable/GtkSeparatorToolItem.html
  
  if this of Box:
    let box = this.data(gtkContainer)
    box.add(gtkWidget(newSeparator(toOrientation(dir))))
  elif this of Menu:
    let menu = this.data(gtkContainer)
    menu.add(gtkWidget(newSeparatorMenuItem()))
  elif this of Tools:
    let tools = this.data(gtkContainer)
    tools.add(gtkWidget(newSeparatorToolItem()))

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
  doAssert pointer(thisD) != nil and pointer(thatD) != nil

  var adapter = adapters # TODO: Store adapter used
  if this of Box: adapter = adaptersScrolledWindow
  
  if not utilTryAddChild(pointer(thisD), pointer(thatD), adapter):
    # https://developer.gnome.org/gtk3/stable/GtkContainer.html#gtk-container-add  
    thisD.add(thatD)

  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-show
  thatD.show()


# COMBOBOX --------------------------------------
proc internalGetSelectedIndex(this: ComboBox): int = # TODO 
  int(this.data(gtkComboBox).getActive())

proc internalSetSelectedIndex(this: ComboBox, i: int) =
  this.data(gtkComboBox).setActive(i.cint)

proc internalGetSelected(this: ComboBox): string =
  internalGet(this, internalGetSelectedIndex(this))

proc internalAdd(this: ComboBox, text: string) =
  let ls = cast[gtkListStore](this.data(gtkComboBox).getModel())

  var ti: gtkTreeIterObj
  ls.append(ti.addr)
  ls.set(ti.addr, 0, cstring(text), -1)

template comboBoxWithIndex(
    this: ComboBox, idx: int, body: untyped) {.dirty.} =
  let ls =
    cast[gtkListStore](this.data(gtkComboBox).getModel())

  var i = idx.cint
  var ti: gtkTreeIterObj

  let tPath = newTreePath(i, 1)
  if bool(cast[gtkTreeModel](ls).getIter(ti.addr, tPath)):
    body
  free(tPath)

proc internalSet(this: ComboBox, text: string, i: int) =
  comboBoxWithIndex(this, i):
    ls.set(ti.addr, 0, cstring(text), -1)

proc internalGet(this: ComboBox, i: int): string =
  comboBoxWithIndex(this, i):
    var v: GValueObj
    cast[gtkTreeModel](ls).getValue(ti.addr, 0, v.addr)
    result = $getString(v.addr)
    unset(v.addr)


# CHECKBOX --------------------------------------
proc internalSetText(this: Checkbox, that: string) =
  this.data(gtkButton).setLabel(that)

proc internalGetText(this: Checkbox): string =
  $this.data(gtkButton).getLabel()

proc internalGetChecked(this: Checkbox): bool =
  bool(this.data(gtkCheckButton).getActive())

proc internalSetChecked(this: Checkbox, v: bool) =
  this.data(gtkCheckButton).setActive(GBoolean(v))


# LABEL -----------------------------------------
proc internalSetText(this: Label, text: string) =
  this.data(gtkLabel).setText(text)

proc internalGetText(this: Label): string =
  $this.data(gtkLabel).getText()

proc internalSetWrap(this: Label, state: bool) =
  this.data(gtkLabel).setLineWrap(GBoolean(state))

proc internalGetWrap(this: Label): bool =
  bool(this.data(gtkLabel).getLineWrap())

proc internalGetXAlign(this: Label): float =
  this.data(gtkLabel).getXAlign()

proc internalGetYAlign(this: Label): float =
  this.data(gtkLabel).getYAlign()
  
proc internalSetXAlign(this: Label, v: float) =
  this.data(gtkLabel).setXAlign(v)

proc internalSetYAlign(this: Label, v: float) =
  this.data(gtkLabel).setYAlign(v)


# ENTRY -----------------------------------------
proc internalGetText(this: Entry): string =
  $this.data(gtkEntry).getText()

proc internalSetText(this: Entry, text: string) =
  this.data(gtkEntry).setText(text)


# BUTTON ----------------------------------------
proc internalSetImage(this: Button, img: Bitmap) =
  let
    pb  = pixbuf(img)
    img = newImage(pb)

  setImage(this.data(gtkButton), img)

proc internalGetImage(this: Button): Bitmap =
  newBitmap(gtkImage(this.data(gtkButton).getImage()).getPixbuf())

proc internalSetText(this: Button, text: string) =
  doAssert this.raw != nil
  this.data(gtkButton).setLabel(text)
  
proc internalGetText(this: Button): string =
  $this.data(gtkButton).getLabel()


# BOX -------------------------------------------
proc internalGetOrientation(this: Box): NOrientation =
  toNOrientation(this.data(gtkOrientable).getOrientation())

proc internalSetOrientation(this: Box, value: NOrientation) =
  this.data(gtkOrientable).setOrientation(toOrientation(value))

proc internalSetSpacing(this: Box, spacing: int) =
  this.data(gtkBox).setSpacing(spacing.cint)

proc internalScrollbar(this: Box, state: bool) =
  let thisD = this.data(pointer)

  if state:    
    discard utilInsertAdapter(thisD, adaptersScrolledWindow)
  else:
    discard utilDelAdapter(thisD, adaptersScrolledWindow)

proc internalScrollbar(this: Box): bool =
  bool(gTypeCheckInstanceType(
    getParent(this.data(gtkWidget)), scrollableGetType()))


# RADIO -----------------------------------------
proc internalGetText(this: Radio): string =
  $this.data(gtkButton).getLabel()

proc internalSetText(this: Radio, text: string) =
  this.data(gtkButton).setLabel(text)

proc internalSetGroup(radios: openArray[Radio]) =
  if len(radios) <= 1: return
  let r1 = radios[0].data(gtkRadioButton)
  for r2 in radios[1..^1]: r2.data(gtkRadioButton).joinGroup(r1)


# TEXT_AREA
proc internalSetText(this: TextArea, text: string) =
  let buffer = this.data(gtkTextView).getBuffer()
  setText(buffer, text, text.len.cint)

proc internalGetText(this: TextArea): string =
  var s, e: gtkTextIter
  let buffer = this.data(gtkTextView).getBuffer()
  getBounds(buffer, s, e)
  return $getText(buffer, s, e, GBoolean(true))


# PROGRESS --------------------------------------
proc internalValue(this: Progress): float =
  float(this.data(gtkProgressBar).getFraction())

proc internalValue(this: Progress, v: float) =
  this.data(gtkProgressBar).setFraction(v)


# CALENDAR --------------------------------------
proc internalGetDate(this: Calendar): DateTime =
  var d, m, y: cuint
  getDate(this.data(gtkCalendar), y, m, d)

  return dateTime(
    monthday = MonthdayRange(d), month = Month(m + 1), year = int(y),
    0, 0, 0, 0)

proc internalSetDate(this: Calendar, date: DateTime) =
  let c = this.data(gtkCalendar)
  c.selectMonth((date.month.int - 1).cuint, date.year.cuint)
  c.selectDay(date.monthday.cuint)

proc internalMark(this: Calendar, day: int) =
  this.data(gtkCalendar).markDay(day.cuint)

proc internalUnmark(this: Calendar, day: int) =
  this.data(gtkCalendar).unmarkDay(day.cuint)

proc internalClear(this: Calendar) =
  this.data(gtkCalendar).clearMarks()

proc internalMarked(this: Calendar, day: int): bool =
  bool(getDayIsMarked(this.data(gtkCalendar), day.cuint))


# SLIDER ----------------------------------------
proc internalSetValue(this: Slider, value: float) =
  this.data(gtkScale).setValue(value.cdouble)

proc internalGetValue(this: Slider): float =
  this.data(gtkScale).getValue().float

proc internalGetDecimals(this: Slider): int =
  this.data(gtkScale).getDigits().int

proc internalSetDecimals(this: Slider, decimals: int) =
  this.data(gtkScale).setDigits(decimals.cint)

proc internalSetStep(this: Slider, step: float) =
  gtkScaleStep[this.id] = step
  setIncrements(this.data(gtkScale), step.cdouble, step.cdouble)
  
proc internalGetStep(this: Slider): float = gtkScaleStep[this.id]

proc internalSetRange(this: Slider, range: Slice[float]) =
  gtkScaleRange[this.id] = range
  setRange(this.data(gtkScale), range.a.cdouble, range.b.cdouble)

proc internalGetRange(this: Slider): Slice[float] = gtkScaleRange[this.id]
  
proc internalGetOrientation(this: Slider): NOrientation =
  toNOrientation(this.data(gtkOrientable).getOrientation())

proc internalSetOrientation(this: Slider, value: NOrientation) =
  this.data(gtkOrientable).setOrientation(toOrientation(value))


# ALERT -----------------------------------------
# SET/GET Text https://developer.gnome.org/gtk3/stable/GtkMessageDialog.html#GtkMessageDialog--text

proc internalRun(this: Alert) =
  discard run(this.data(gtkDialog))
  gtkDestroy(this.data(gtkWidget))

proc internalSetText(this: Alert, text: string) =
  gtkSet(this, "secondary-text", text)
  
proc internalGetText(this: Alert): string =
  gtkGet(this, "secondary-text", result)

proc internalSetTitle(this: Alert, text: string) =
  gtkSet(this, "text", text)
  
proc internalGetTitle(this: Alert): string =
  gtkGet(this, "text", result)

proc internalSetModal(this: Alert, v: bool) =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-set-modal
  this.data(gtkWindow).setModal(GBoolean(v))

proc internalGetModal(this: Alert): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-modal
  bool(this.data(gtkWindow).getModal())
  
proc internalSetTransient(this: Alert, that: Window) =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-set-transient-for
  this.data(gtkWindow).setTransientFor(that.data(gtkWindow))

proc internalGetTransient(this: Alert): Window =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-transient-for
  let w = pointer(getTransientFor(this.data(gtkWindow)))
  if w != nil: return Window(utilElement(w))


# IMAGE -----------------------------------------
var bitmaps: STable[NID, Bitmap] # Image.bitmap

proc newBitmap(pixbuf: GDKPixbuf): Bitmap =
  # https://developer.gnome.org/gdk-pixbuf/2.36/
  if pointer(pixbuf) == nil: return
  
  gtkRef(GObject(pixbuf))
  
  var
    data   = pixbuf
    (w, h) = (getWidth(pixbuf), getHeight(pixbuf))
    c      = getNChannels(pixbuf)

  doAssert c in 3 .. 4
    
  if c == 3:
    const Z = 0.char
    data   = addAlpha(pixbuf, GBoolean(false), Z, Z, Z)

  result = Bitmap(w: w, h: h)
  result.img.setLen(w * h)
  let pixels = cast[ptr[UncheckedArray[Pixel]]](data.getPixels())
  for i, p in mpairs(result.img): p = pixels[i]

proc internalGetBitmap(this: Image): Bitmap =
  bitmaps[this.id]

proc internalUpdate(this: Image, that: Bitmap) =
  updatePixbuf(that)
  bitmaps[this.id] = that
  setFromPixbuf(this.data(gtkImage), pixbuf(that))


# FILECHOOSE ------------------------------------
proc internalSetMultiple(this: FileChoose, state: bool) =
  gtkSet(this, "select-multiple", state)

proc internalGetMultiple(this: FileChoose): bool =
  gtkGet(this, "select-multiple", result)

proc internalSetText(this: FileChoose, text: string) =
  this.data(gtkWindow).setTitle(text)

proc internalGetText(this: FileChoose): string =
  $this.data(gtkWindow).getTitle()

proc internalRun(this: FileChoose) =
  discard run(this.data(gtkDialog))
  destroy(this.data(gtkWidget))


# LIST ------------------------------------------
proc internalGetMode(this: List): NAmount =
  toNGUISelection(this.data(gtkListBox).getSelectionMode)

proc internalSetMode(this: List, mode: NAmount) =
  this.data(gtkListBox).setSelectionMode(toGTKSelection(mode))

proc internalSelected(this: List, that: var seq[NElement]) =
  var r = this.data(gtkListBox).getSelectedRows()
  while r != nil:
    let d = cast[gtkListBoxRow](r.data).getChild()
    add(that, utilElement(pointer(d)))
    r = r.next
  free(r)


# MENU ------------------------------------------
proc handleMenuBarAdd(this, that: NElement) =
  # BAR / MENU ----------------------
  # GTKMenuBar/GTKMenu hierarchy:
  # MenuBar -> [MenuItem] -> Menu -> [MenuItem] -> Widgets
  # https://developer.gnome.org/gtk3/stable/GtkMenuItem.html
  # ---------------------------------

  let (thisD, thatD) = (this.data(gtkContainer), that.data(gtkWidget))

  if this of Bar:
    # MenuBar -> CREATE(MenuItem) -> Menu
    if that of Menu:
      
      # Maybe 'this' has a MenuItem attached already somewhere ...
      let
        last  = utilNChild(Bar(this), utilLen(Bar(this)) - 1)
        lastD = cast[gtkWidget](last.raw)
        
      if last != nil:
        # TODO: What if returns EventBox?
        let mItem = cast[gtkMenuItem](
          utilGetOrAddAdapter(pointer(lastD), adaptersMenuItem))
        setSubmenu(gtkMenuItem(mItem), that.data(gtkMenu))
        return

      # Sorry, but in between Bar and Menu, we need
      # a label or something, now you will die
      raiseAssert(
        "Cannot add Menu directly to Bar. Add Menu to label and " &
        "that label to Bar instead")

    # MenuBar -> CREATE(MenuItem->Menu) -> That
    else:      
      # Maybe 'that' already has a MenuItem attached
      discard utilInsertAdapter(
        pointer(thisD), pointer(thatD), adaptersMenuItem)

  # Menu -> CREATE(MenuItem) -> That  
  elif this of Menu:
    discard utilInsertAdapter(
      pointer(thisD), pointer(thatD), adaptersMenuItem)
  
  # CREATE(MenuItem) -> This -> That
  elif that of Menu:
    let mItem = cast[gtkMenuItem](
      utilGetOrAddAdapter(pointer(thisD), adaptersMenuItem))
    setSubmenu(mItem, gtkMenu(thatD))

    if utilExists(neClick, pointer(thisD)) and
        not utilExists(neClick, pointer(mItem)):
      utilSet(neClick, pointer(mItem), utilGet(neClick, pointer(thisD)))
      discard signal(
        GPointer(mItem), "activate", SCB(triggerEvent), cast[pointer](neClick))
    return

  else:
    # Should never by triggered by client code
    raiseAssert("NOOOOOOOOOOOOOOOOOOOOOO!")

  utilChild(Container(this), that)

proc internalAdd(this: NElement, that: Menu) =
  handleMenuBarAdd(this, that)


# TAB -------------------------------------------
proc internalAdd(this: Tab, that: Container, label: Label) =
  discard this.data(gtkNoteBook).appendPage(
    that.data(gtkWidget), label.data(gtkWidget))
  utilChild(this, that)
  utilChild(that, label)

proc internalSetReorderable(this: Tab, v: bool) =
  let thisD = this.data(gtkNoteBook)
  for i in 0 ..< internalLen(this): # :-/
    let c = internalGetChild(this, i)
    setTabReorderable(thisD, c.data(gtkWidget), GBoolean(v))

proc internalGetReorderable(this: Tab): bool =
  if internalLen(this) == 0: return
  return bool(this.data(gtkNoteBook)
    .getTabReorderable(internalGetChild(this, 0).data(gtkWidget)))

proc internalGetSide(this: Tab): NSide =
  [nsLeft, nsRight, nsTop, nsBottom][
    int(this.data(gtkNoteBook).getTabPos())]

proc internalSetSide(this: Tab, side: NSide) =  
  let p = [PositionType.TOP, PositionType.BOTTOM,
    PositionType.LEFT, PositionType.RIGHT][int(side)]

  this.data(gtkNoteBook).setTabPos(p)

proc internalGetSelectedIndex(this: Tab): int =
  int(getCurrentPage(this.data(gtkNoteBook)))
  
proc internalSetSelectedIndex(this: Tab, i: int) =
  setCurrentPage(this.data(gtkNoteBook), cint(i))


# TOOLS -----------------------------------------
proc internalGetOrientation(this: Tools): NOrientation =
  toNOrientation(this.data(gtkOrientable).getOrientation())

proc internalSetOrientation(this: Tools, value: NOrientation) =
  this.data(gtkOrientable).setOrientation(toOrientation(value))

proc handleToolsAdd(this: Tools, that: NElement) =
  # TOOLS ---------------------------
  # GTKToolBar hierarchy:
  # ToolBar -> [ToolItem] -> Widget
  # https://developer.gnome.org/gtk3/stable/GtkToolItem.html
  # ---------------------------------
  
  let (thisD, thatD) = (this.data(gtkToolBar), that.data(gtkWidget))
  discard utilInsertAdapter(pointer(thisD), pointer(thatD), adaptersToolItem)
  utilChild(this, that)
  

# Table/Tree Common -----------------------------

var tableMeta: STable[NID, tuple[
    columns: int,
    header:  seq[tuple[kind: NCellKind, name: string]],
  ]]
  
template storeAction(this: NElement, body: untyped) =
  # TODO: Rename to withStore
  if this of NTable: 
    let ls {.inject.} = cast[gtkListStore](ls)
    body
  else: 
    let ls {.inject.} = cast[gtkTreeStore](ls)
    body

proc tableGet(ls: gtkTreeModel, ti: var gtkTreeIterObj, x: int): NCell =
  # TODO: tableGet/tableSet rename to modelGet/modelSet
  var v: GValueObj
  getValue(ls, ti.addr, x.cint, v.addr)
  let gvt = gValueType(v.addr)

  if gvt == G_TYPE_STRING:
    result = toCell($getString(v.addr))
  elif gvt == G_TYPE_INT:
    result = toCell(getInt(v.addr))
  elif gvt == G_TYPE_BOOLEAN:
   result = toCell(bool(getBoolean(v.addr)))
  elif gvt == pixbufGetType():
    result = NCell(kind: ckImg)
    
    template holdsPointer: bool =
      bool(checkValueHolds(cast[GValue](v.addr), G_TYPE_POINTER))
    
    if holdsPointer():
      let
        pb  = cast[GdkPixBuf](getPointer(v.addr))
        bmp = bitmap(pb)

      result = toCell(bmp)
  else:
    raiseAssert("Cell Type not implemented in gtk3: ")

  unset(v.addr)

proc tableSet(
    this: NElement,
    ls:   gtkTreeModel,
    ti:   var gtkTreeIterObj,
    that: NCell,
    x:    int) =

  doAssert this of NTable or this of Tree
  let old = tableGet(ls, ti, x)

  template setV(v) {.dirty.} =
    storeAction(this, set(ls, ti.addr, x.cint, v, -1))

  case that.kind:
  of ckInt:  setV(that.vInt)
  of ckStr:  setV(cstring(that.vStr))
  of ckBool: setV(that.vBool)
  of ckImg:  setV(pixbuf(that.vImg))

proc tableSet(this: NElement, ls: gtkTreeModel, that: NCell, path: TMPath) =
  withIter path:
    if bool(getIter(ls, ti.addr, tPath)):
      tableSet(this, ls, ti, that, path.column)

proc tableGet(ls: gtkTreeModel, path: TMPath): NCell =
  withIter path:
    if bool(getIter(ls, ti.addr, tPath)):
      result = tableGet(ls, ti, path.column)

proc toGType(this: NCellKind): GType =
  case this:
  of ckInt:  G_TYPE_INT
  of ckStr:  G_TYPE_STRING
  of ckBool: G_TYPE_BOOLEAN
  of ckImg:  pixbufGetType()

proc setHeaders(
    this:   NElement,
    header: openArray[(NCellKind, string)]) =

  doAssert this of NTable or this of Tree
  let tv = this.data(gtkTreeView)

  var
    list: seq[GType]
    visible = false

  for k, n in items(header):
    add(list, toGType(k))
    visible = visible or n != ""

  let ls =
    if this of NTable: gtkTreeModel(listStoreNewv(list.len.cint, addr(list[0])))
    else:              gtkTreeModel(treeStoreNewv(list.len.cint, addr(list[0])))

  var lastColumn: gtkTreeViewColumn
  for i, (kind, name) in header:
    template add(newRenderer, t) =
      let
        renderer = newRenderer()
        append   = visible and name == ""
        column =
          if append: lastColumn else: newTreeViewColumn()

      doAssert pointer(column) != nil
      lastColumn = column

      packStart(column, renderer, GBoolean(false))
      addAttribute(column, renderer, t, cint(i))

      if not append:
        # append renderer to last column, not column to tree view
        setTitle(column, cstring(name))
        doAssert bool(appendColumn(tv, column))

    case kind:
    of ckStr, ckInt:
      add(newCellRendererText,   "text")
    of ckBool:
      add(newCellRendererToggle, "active")
    of ckImg:
      add(newCellRendererPixbuf, "pixbuf")

  setModel(tv, ls)
  setHeadersVisible(tv, GBoolean(visible))
  
  # Meta data
  tableMeta[this.id] = (
    columns: len(header),
    header:  @header)

proc onAdd(this: NElement, that: NRow, path: TMPath) =
  doAssert this of NTable or this of Tree
 
  let
    tv = this.data(gtkTreeView)
    ls = tv.getModel()

  doAssert pointer(ls) != nil

  var ti: gtkTreeIterObj
  
  # TABLE -----------------------------
  if this of NTable:
    discard path
    let ls = gtkListStore(ls)
    append(ls, ti.addr)

  # TREE ------------------------------
  else:
    # https://en.wikibooks.org/wiki/GTK%2B_By_Example/Tree_View/Tree_Models#Adding_Rows_to_a_Tree_Store
    let ls = gtkTreeStore(ls)
    
    if path.depth.len == 0:
      append(ls, ti.addr, nil)

    else:
      var ti2: gtkTreeIterObj
      let tPath = toTreePath(path)

      doAssert bool(getIter(gtkTreeModel(ls), ti2.addr, tPath))
      append(ls, ti.addr, ti2.addr)
      free(tPath)
  # -----------------------------------
    
  for i in 0 ..< that.len:
    tableSet(this, ls, ti, that.cells[i], i)

proc onSet(this: NElement, that: NCell, path: TMPath) =
  tableSet(this, getModel(this.data(gtkTreeView)), that, path)

proc onGet(this: NElement, path: TMPath): NCell =
  tableGet(getModel(this.data(gtkTreeView)), path)

proc onClear(this: NElement, path: TMPath) =
  let ls = this.data(gtkTreeView).getModel()
  withIter path:
    storeAction this:
      discard remove(ls, ti.addr)


# TABLE -----------------------------------------
proc internalAdd(this: NTable, that: NRow) =
  doAssert that.len > 0
  onAdd(this, that, TMPath())

proc internalSet(this: NTable, that: NCell, x, y: int) =
  onSet(this, that, tmPath(row = y, column = x))

proc internalClear(this: NTable, row: int) =
  onClear(this, tmPath(row = row, column = -1))

proc internalClear(this: NTable) =
  # https://developer.gnome.org/gtk3/stable/GtkTreeStore.html#gtk-tree-store-clear

  let
    tv = this.data(gtkTreeView)
    ls = tv.getModel()

  clear(cast[gtkListStore](ls))
  
proc internalGet(this: NTable, x, y: int): NCell =
  onGet(this, tmPath(row = y, column = x))
  
proc internalGet(this: NTable, y: int): NRow =
  let
    tv = this.data(gtkTreeView)
    ls = tv.getModel()
    c  = tableMeta[this.id].columns
    
  result = NRow()

  for x in 0 ..< c:
    add(result.cells, internalGet(this, x, y))

proc internalSet(this: NTable, that: NRow, y: int) =
  for x, that in that.cells: internalSet(this, that, x, y)

proc internalRows(this: NTable, that: openArray[NRow]) =
  for row in that: internalAdd(this, row)
  
proc internalRows(this: NTable): seq[NRow] =  
  let
    tv = this.data(gtkTreeView)
    ls = tv.getModel()
    t  = int(iterNChildren(ls, nil))

  for y in 0 ..< t:
    add(result, internalGet(this, y))

proc internalSelected(this: NTable): tuple[x, y: int] =
  discard

proc internalHeader(
    this: NTable, header: openArray[tuple[kind: NCellKind, name: string]]) =
  setHeaders(this, header)

proc internalHeader(this: NTable): seq[tuple[kind: NCellKind, name: string]] =
  tableMeta[this.id].header

proc internalHeaders(this: NTable): bool =
  bool(this.data(gtkTreeView).getHeadersVisible())

proc internalHeaders(this: NTable, v: bool) =
  this.data(gtkTreeView).setHeadersVisible(GBoolean(v))

proc internalSetSelection(this: NTable, mode: NAmount) =
  let sm = getSelection(this.data(gtkTreeView))
  sm.setMode(toGTKSelection(mode))

proc internalGetSelection(this: NTable): NAmount =
  let sm = getSelection(this.data(gtkTreeView))
  return toNGUISelection(sm.getMode())

proc internalSet(this: NTable, that: openArray[tuple[x, y: int]]) =
  discard

proc internalGet(this: NTable, that: var seq[tuple[x, y: int]]) =
  # https://developer.gnome.org/gtk3/stable/GtkTreeSelection.html#gtk-tree-selection-get-selected-rows

  var
    model: gtkTreeModel
    r = this.data(gtkTreeView).getSelection().getSelectedRows(model)

  while r != nil:
    let
      tPath = cast[gtkTreePath](r.data)
      len   = int(getDepth(tPath))
    
    r = r.next

    # https://developer.gnome.org/gtk3/stable/GtkTreeModel.html#gtk-tree-path-get-indices
    let idxList = cast[ptr[UncheckedArray[cint]]](getIndices(tPath)) # Don't free
    for i in 0 ..< len:
      add(that, (-1, int(idxList[i])))

  freeFull(r, cast[GDestroyNotify](freetp))
  free(r)


# TREE ------------------------------------------
proc internalAdd(this: Tree, that: NRow, depth: openArray[int]) =
  doAssert that.len > 0
  let path = tmPath(depth, row = -1)
  onAdd(this, that, path)

proc internalSet(this: Tree, that: NCell, depth: openArray[int], column: int) =
  let path = tmPath(depth = depth, row = -1, column = column)
  onSet(this, that, path)

proc internalGet(this: Tree, depth: openArray[int], column: int): NCell =
  # TODO: arg 'subTree: bool = false'
  let path = tmPath(depth, row = -1, column = column)
  onGet(this, path)

proc internalGet(this: Tree, y: int): NRow =
  # TODO: arg 'subTree: bool = false'
  # TODO: depth

  let
    tv = this.data(gtkTreeView)
    ls = tv.getModel()
    c  = tableMeta[this.id].columns
    
  result = NRow()

  for x in 0 ..< c:
    # treeChildrenLen(depth)
    add(result.cells, internalGet(this, [y], x))

proc internalRows(this: Tree, that: openArray[NRow]) =
  for row in that: internalAdd(this, row, [])

proc internalRows(this: Tree): seq[NRow] =
  let
    tv = this.data(gtkTreeView)
    ls = tv.getModel()
    t  = int(iterNChildren(ls, nil))

  for y in 0 ..< t:
    add(result, internalGet(this, y))

proc internalHeader(
    this: Tree, header: openArray[tuple[kind: NCellKind, name: string]]) =
  setHeaders(this, header)

proc internalHeader(this: Tree): seq[tuple[kind: NCellKind, name: string]] =
  tableMeta[this.id].header

proc internalHeaders(this: Tree): bool =
  bool(this.data(gtkTreeView).getHeadersVisible())

proc internalHeaders(this: Tree, v: bool) =
  this.data(gtkTreeView).setHeadersVisible(GBoolean(v))

proc internalSetSelection(this: Tree, mode: NAmount) =
  let sm = getSelection(this.data(gtkTreeView))
  sm.setMode(toGTKSelection(mode))
  
proc internalGetSelection(this: Tree): NAmount =
  let sm = getSelection(this.data(gtkTreeView))
  return toNGUISelection(sm.getMode())

proc internalClear(this: Tree) =
  # https://developer.gnome.org/gtk3/stable/GtkTreeStore.html#gtk-tree-store-clear

  let
    tv = this.data(gtkTreeView)
    ts = tv.getModel()
  
  clear(gtkTreeStore(ts))


# CLIPBOARD -------------------------------------
proc getCB: Clipboard =
  # https://developer.gnome.org/gtk3/stable/gtk3-Clipboards.html
  var acb {.global.}: gdkAtom
  once: acb = atomIntern("CLIPBOARD", GBoolean(true))
  return clipboardGet(acb)
  
template C: Clipboard = getCB()

proc internalClipboardClear = C.clear()
proc internalClipboardSet(text: string) = C.setText(text, text.len.cint)
proc internalClipboardSet(img: Bitmap) = C.setImage(pixbuf(img))

proc internalClipboardGetText: string =
  let txt = C.waitForText()
  if txt == nil: return
  result = $txt
  dealloc(txt) # TODO: Is dealloc right?

proc internalClipboardGetImg: Bitmap =
  let img = C.waitForImage()
  if pointer(img) == nil: return
  result = newBitmap(cast[GdkPixBuf](img))
  objectUnref(GPointer(img))
      

# TIMERS ----------------------------------------
proc internalRepeat(event: NRepeatProc, ms: int): NRepeatHandle =  
  # https://developer.gnome.org/gtk-tutorial/stable/c1759.html
  proc cb(a: GPointer): GBoolean {.cdecl.} = GBoolean(utilTrigger(cast[int](a)))
  
  let rid = utilNextRepeatID()
  result = timeoutAdd(
    interval = cuint(ms),
    function = GSourceFunc(cb),
    data     = cast[GPointer](rid),
  ).NRepeatHandle

  utilRepeatAdd(event, result, rid)

proc internalStop(this: NRepeatHandle) =
  discard sourceRemove(this.cuint)
  utilDel(this)

proc internalSetTime(this: var NRepeatHandle, ms: int) =
  let event = utilGet(this)
  internalStop(this)
  this = internalRepeat(event, ms)


# EVENTS: THE SECOND COMING ---------------------
proc internalGetCurrentEvent: NEventArgs =
  # TODO: This needs to be set manually and not called directly through 'currentEvent'

  # https://developer.gnome.org/gtk3/stable/gtk3-General.html
  # https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html
  let e = getCurrentEvent()
  if e == nil: return

  let
    widget    = e.getEventWidget()
    nElement  = utilElement(pointer(widget))
    eventType = e.`type`

  # FileChoose Event
  if insideFCResponse and eventType == BUTTON_RELEASE:
    # HACK in the GTK
    
    var w = widget
    while not bool(gTypeCheckInstanceType(w, fileChooserGetType())):
      w = getParent(w)
      doAssert pointer(w) != nil

    result = NEventArgs(
      element: utilElement(pointer(w)), kind: neFILE_CHOOSE_ACCEPT)
    var list = getFilenames(gtkFileChooser(w))

    while list != nil:
      let name = cast[cstring](list.data)
      add(result.files, $name)
      free(list.data)
      list = list.next

    free(list)
    free(e)
    return

  case eventType:
  of BUTTON3_PRESS, BUTTON2_PRESS, BUTTON_PRESS, BUTTON_RELEASE, MOTION_NOTIFY:
    template setkind(a, b) =
      if eventType == a: result = NEventArgs(kind: b)
      
    setKind(BUTTON_PRESS,   neClick)
    setKind(BUTTON_RELEASE, neClickRelease)
    setKind(MOTION_NOTIFY,  neMove)
    
    if result.kind == neNONE:
      result = NEventArgs(kind: neClick)
    
    if eventType in {BUTTON_PRESS, BUTTON2_PRESS, BUTTON_RELEASE}:
      let e = cast[EventButton](e)
      
      if e.button == 1: result.mouse.incl(nm1)
      if e.button == 2: result.mouse.incl(nm2)
      if e.button == 3: result.mouse.incl(nm3)
      result.double = eventType == BUTTON2_PRESS
      
    else:
      var st: ModifierType
      if bool(e.getState(st)):
        template setMouse(a, b) =
          if (int(st) and int(a)) != 0: result.mouse.incl(b)

        setMouse(BUTTON1_MASK, nm1)
        setMouse(BUTTON2_MASK, nm2)
        setMouse(BUTTON3_MASK, nm3)

    result.x = e.button.x.int
    result.y = e.button.y.int

  of KEY_PRESS, KEY_RELEASE:    
    let
      keyVal = (e.key).keyval
      key    =
        case keyVal:
        of KEY_a .. KEY_z: NKey((int(keyVal) - int(Key_a)) + int(nkA))
        of KEY_0 .. KEY_9: NKey((int(keyVal) - int(Key_0)) + int(nk0))
        of KEY_ESCAPE:     nkEsc
        of KEY_RETURN:     nkEnter
        else:              nkNone

    result =
      if eventType == KEY_PRESS: NEventArgs(kind: neKeyPress, key: key)
      else: NEventArgs(kind: neKeyRelease, key: key)

    var st: ModifierType
    if bool(e.getState(st)):
      template mapMod(mt: typed, k: NKey) =
        if (int(st) and int(mt)) != 0: result.mods.incl(k)

      mapMod(CONTROL_MASK, nkControl)
      mapMod(SHIFT_MASK,   nkShift)

  else: discard

  result.element = nElement
  free(e)