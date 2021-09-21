includeUtils ELEMENT, CONTAINER, EVENT, TIMER, ADAPTER


# INCLUDED IN ngui_begtk3, ngui_begtk2
const
  v2 = backend == beGTK2
  v3 = backend == beGTK3


# GTK3 START ------------------------------------  
when not v2:
  import oldgtk3/[gtk, glib, gobject, gdk, cairo, gdk_pixbuf]
  
  type
    gtkWindow      = gtk.Window
    gtkDialog      = gtk.Dialog
    gtkWidget      = gtk.Widget
    gtkContainer   = gtk.Container
    gtkNoteBook    = gtk.NoteBook
    gtkMenuItem    = gtk.MenuItem
    gtkMenu        = gtk.Menu
    gtkListBox     = gtk.ListBox
    gtkListBoxRow  = gtk.ListBoxRow
    gtkTextView    = gtk.TextView
    gtkTreeView    = gtk.TreeView
    gtkRadioButton = gtk.RadioButton
    gtkButton      = gtk.Button
    gtkLabel       = gtk.Label
    gtkEntry       = gtk.Entry
    gtkTextIter    = gtk.TextIter
    gtkGrid        = gtk.Grid
    gtkPopover     = gtk.PopOver
    gtkImage       = gtk.Image
    gtkCalendar    = gtk.Calendar
    gtkScale       = gtk.Scale
    gtkBox         = gtk.Box
    gtkProgressBar = gtk.ProgressBar
    gtkCheckButton = gtk.CheckButton
    gtkFileChooserDialog = gtk.FileChooser
    gtkCellLayout  = gtk.CellLayout
    gtkComboBox    = gtk.ComboBox
    gtkListStore   = gtk.ListStore
    gtkTreeStore   = gtk.TreeStore
    gtkTreeIterObj = gtk.TreeIterObj
    gtkTreeModel   = gtk.TreeModel
    gtkToolBar     = gtk.ToolBar
    gtkOrientable  = gtk.Orientable
    gtkSelectionMode = gtk.SelectionMode
    gtkTreeViewColumn = gtk.TreeViewColumn
    gtkTreePath = gtk.TreePath
    GPointer       = glib.GPointer
  
  const
    SCB          = proc(p: pointer): auto = gCALLBACK(p)
    newToolItem  = gtk.newToolItem
    newMenuItem  = proc: Widget = gtk.newMenuItem()
    gtkRef       = gobject.objectRef
    gtkDestroy   = proc(w: gtkWidget) = gtk.destroy(w)

  template signal(a, b, c, d: typed): auto =
    gSignalConnect(a, b, c, d)
  
  proc newLabel(): auto = gtk.newLabel("")
  proc newButton(): auto = gtk.newButton("")
  proc newRadioButton(): auto = gtk.newRadioButton(group = nil)
  proc newWindow(): auto = gtk.newWindow(gtk.WindowType.TOP_LEVEL)
  proc newPopover(): auto = gtk.newPopover(nil)
  proc newFileChooser(): auto =
    gtk.newFileChooserDialog(nil, nil, OPEN, nil)
  proc newComboBox(): auto = gtk.newComboBox(
    cast[gtkTreeModel](gtk.newListStore(1, G_TYPE_STRING)))
  proc newBox(): auto = gtk.newBox(Orientation.Vertical, 0)
  proc newMessageDialog(): auto = gtk.newMessageDialog(
    nil,
    gtk.DialogFlags.MODAL, # TODO: TODO
    gtk.MessageType.OTHER,
    gtk.ButtonsType.CLOSE,
    nil)
  #proc loadPixbuf(file: string): GDKPixbuf =
    #var error: glib.GError
    #return newPixbufFromFile(file, error)


let # Doesn't work with const, but one day ...
  adapters = genAdapters(
    cast[gtkWidget](c).getParent()
    ,cast[gtkContainer](p).remove(cast[gtkWidget](c))
    ,cast[gtkContainer](p).add(cast[gtkWidget](c))
  )

  adaptersEventBox = genAdaptersFrom(
    adapters,
    block:
      # Adapter 1 https://developer.gnome.org/gtk3/stable/GtkEventBox.html
      let eb = newEventBox()
      eb.addEvents(POINTER_MOTION_MASK.cint)
      return eb
    ,(discard gtkRef(cast[gtkWidget](c))))

  adaptersMenuItem = genAdaptersFrom(
    # Adapter 2 https://developer.gnome.org/gtk3/stable/GtkMenuItem.html
    adapters, newMenuItem(), (discard gtkRef(cast[gtkWidget](c))))
  
  adaptersToolItem = genAdaptersFrom(
    # Adapter 3 https://developer.gnome.org/gtk3/stable/GtkToolItem.html
    adapters, newToolItem(), (discard gtkRef(cast[gtkWidget](c))))
    
  adaptersScrolledWindow = genAdaptersFrom(genAdapters(
    # Adapter 4 https://developer.gnome.org/gtk3/stable/GtkScrolledWindow.html
      block:
        # https://developer.gnome.org/gtk3/stable/GtkScrolledWindow.html#GtkScrolledWindow.description
        # "Widgets with native scrolling support, i.e. those whose classes
        # implement the GtkScrollable interface, are added directly. For other
        # types of widget, the class GtkViewport acts as an adaptor"
        var parent = cast[gtkWidget](c).getParent()
        if parent == nil: return
        result = parent

        while not gTypeCheckInstanceType(parent, typeScrolledWindow()):
          parent = parent.getParent()
          if parent == nil: return

        return parent
      ,cast[gtkContainer](p).remove(cast[gtkWidget](c))
      ,
      block:
        when v2:
          if gTypeCheckInstanceType(p, typeScrolledWindow()):
            cast[gtkScrolledWindow](p).addWithViewport(cast[gtkWidget](c))
            return

        cast[gtkContainer](p).add(cast[gtkWidget](c))
    ),
    block:
      let sw = newScrolledWindow(nil, nil)
      # https://stackoverflow.com/questions/14250927/gtk-scroll-window-size-in-a-grid
      when not v2:
        setVExpand(sw, true)
        setHExpand(sw, true)
      sw
    ,(discard gtkRef(cast[gtkWidget](c)))
  )


var
  gtkScaleRange: STable[NID, Slice[float]]
  gtkScaleStep:  STable[NID, float]
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
  
when not v2:
  proc invokeSatanSet(
      this: NElement, css: string, args: varargs[string, `$`]): bool =
      
    let
      # The evil that men do lives on and on
      # https://developer.gnome.org/gtk3/stable/chap-css-properties.html
      # https://developer.gnome.org/gtk3/stable/GtkStyleContext.html
      context  = this.data(gtkWidget).getStyleContext()
      provider = newCssProvider()
      css      = css % args
      
    doAssert context != nil
    doAssert provider != nil

    var error: GError
    result = provider.loadFromData(css, css.len, error)
    context.addProvider(
      cast[StyleProvider](provider), STYLE_PROVIDER_PRIORITY_USER)

  proc invokeSatanGet[T](this: NElement, prop: string, val: var T) =
    let
      thisD   = this.data(gtkWidget)
      context = thisD.getStyleContext()

    when val is Pixel:
      var c: RGBA
      # https://stackoverflow.com/a/47373201
      context.get(thisD.getStateFlags(), prop, c.addr, nil)
      if c != nil:
        val = pixel(c.red, c.green, c.blue, c.alpha)
        rgbaFree(c)
      
    else:
      var v: GValueObj
      context.getProperty(prop, thisD.getStateFlags(), v.addr)
      gtkAAAAAAAAAAAAAAA()


proc gtkGet[T](this: NElement, prop: string, val: var T) =
  # https://developer.gnome.org/gobject/stable/gobject-Standard-Parameter-and-Value-Types.html
  # https://developer.gnome.org/gobject/stable/gobject-The-Base-Object-Type.html#g-object-get-property
  var v: GValueObj
  this.data(gtkWidget).getProperty(prop, addr(v))
  gtkAAAAAAAAAAAAAAA()

proc gtkGet[T](this: NElement, prop: string): T =
  gtkGet(this, prop, result)

proc gtkSet[T](this: NElement, prop: string, val: T) =
  var v: GValueObj
  template getV: auto =
    when v2: addr(v) else: v
  
  when val is bool:
    discard getV.init(G_TYPE_BOOLEAN)
    getV.setBoolean(val)
  elif val is int:
    discard getV.init(G_TYPE_INT)
    v.setInt(val.cint)
  elif val is string:
    discard getV.init(G_TYPE_STRING)
    getV.setString(val.cstring)
  elif val is Pixel:
    var c: RGBAObj
    c.red = cdouble(val.r) / 255
    c.green = cdouble(val.g) / 255
    c.blue = cdouble(val.b) / 255
    c.alpha = cdouble(val.a) / 255
    this.data(gtkWidget).setProperty(prop, addr(c))
    return

  # https://developer.gnome.org/gobject/stable/gobject-The-Base-Object-Type.html#g-object-set-property
  setProperty(this.data(gtkWidget), prop, addr(v))

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
      newTreePath(cint(tmPath.row), (when v2: +1 else: -1))

    else:
      when v2: newTreePath(tmPath.depth.s, Gsize(tmPath.depth.len))
      else:    newTreePath(cast[var cint](tmPath.depth.s), Gsize(tmPath.depth.len))

template withIter(tmPath: TMPath, body: untyped) =  
  block:
    var ti {.inject.}: gtkTreeIterObj
    let tPath {.inject.} = toTreePath(tmPath)

    doAssert tPath != nil

    # TODO: Pass list/tree store explicitly
    if getIter(cast[gtkTreeModel](ls), addr(ti), tPath):
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

  let raw = cast[gtkWidget](this.raw)

  utilDel(this)
  #utilDelParent(this)

  del(names, this)
  del(tags, this)
  discard utilDelAdapter(raw, adapters)

  if this of Container:
    utilRemChildrenList(Container(this))

  if this of Slider:
    del(gtkScaleRange, this.id)
    del(gtkScaleStep,  this.id)

  utilDelEventSource(raw)

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
    gtkInst  = cast[gtkWidget](utilInsertAdapter(gtkInst, adaptersEventBox))

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
      cast[gtkWidget](utilInsertAdapter(gtkInst, adaptersMenuItem))
  
  # REASON: Snowflake callback, and the first time is triggered twice
  elif this of Menu and nguiEvent in {neOpen}:
    # https://developer.gnome.org/gtk3/stable/GtkMenu.html#GtkMenu-popped-up
    nguiTrigger = SCB(
        proc(
          source, b, c: GPointer,
          d, e: bool,
          data: GPointer): bool {.cdecl.} =
      once: return # Why?!
      return triggerEvent(source, data)
    )
        
  if gtkEvent in [EVENT_TO_SIGNAL[neFILE_CHOOSE_ACCEPT]]:
    # https://docs.gtk.org/gtk3/signal.Dialog.response.html
    nguiTrigger = SCB(
        proc(source: GPointer, response: cint, data: GPointer): bool {.cdecl.} =
        
      if ResponseType(response) != (when v2: RESPONSE_ACCEPT else: ACCEPT): return
        
      var src = cast[gtkWidget](source)

      while not isFileChooser(src):
        src = getParent(src)
        doAssert src != nil
        
      insideFCResponse = on   # DANGER: dirty HACK here
      result = triggerEvent(src, data)
      insideFCResponse = off  # DANGER: dirty HACK here
    )


  # -------------------------------------
  doAssert not utilExists(nguiEvent, gtkInst) # TODO: replace old event with new one.
  utilSet(nguiEvent, gtkInst, action)
  # https://developer.gnome.org/gobject/stable/gobject-Signals.html#g-signal-connect

  discard signal(gtkInst, gtkEvent, nguiTrigger, gtkData)

proc internalTriggerEvent(event: NEventArgs) =
  raiseAssert("Not implemented")
  
  
var bmpToPixbuf: STable[Bitmap, GDKPixbuf]

proc setPixbuf(this: Bitmap, that: GdkPixBuf) =
  let b = cast[ptr[UncheckedArray[Pixel]]](getPixels(that))
  for i, p in pairs(this.img): b[i] = p

proc pixbuf(this: Bitmap): GDKPixbuf =
  result = getOrDefault(bmpToPixbuf, this, nil)
  if result == nil:
    const rgb = when v2: COLORSPACE_RGB else: GdkColorspace.RGB
    result = newPixbuf(rgb, true, 8, this.w.cint, this.h.cint)
    bmpToPixbuf[this] = result
    setPixbuf(this, result)

proc newBitmap(pixbuf: GDKPixbuf): Bitmap # FD

proc bitmap(this: GDKPixbuf): Bitmap =
  for key, value in bmpToPixbuf:
    if this == value: return key
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
  when v2:
    if state: this.data(gtkWidget).show() else: this.data(gtkWidget).hide()
  else:
    this.data(gtkWidget).setVisible(state)
  
proc internalGetVisible(this: NElement): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-visible
  if this of App: return

  return
    when v2:this.data(gtkWidget).WIDGET_VISIBLE()
    else:   bool(this.data(gtkWidget).getVisible())

proc internalGetFocus(this: NElement): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-is-focus
  this.data(gtkWidget).isFocus()

proc internalSetFocus(this: NElement) =
  let thisD = this.data(gtkWidget)
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-grab-focus
  when not v2: thisD.setCanFocus(true)
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
  
  when v2:
    let a = this.data(gtkWidget).allocation
    return (a.width.int, a.height.int)
    
  else:
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

  when not v2:
    if this of Progress:
      discard invokeSatanSet(this,
        "trough{min-width:$1px;min-height:$2px;}progress{min-height:$2px;}",
          size.w, size.h)
  
  adjustSize(this)

proc onDestroyWin(this: Window) # FD

proc internalInitNElement(this: var NElement) =  
  case this.kind:
  of neApp:
    when v2: gtk2.nim_init()
    else: gtk.initWithArgv()
    return

  of neWindow:
    # https://developer.gnome.org/gtk3/stable/GtkWindow.html
    let w = newWindow()
    this.data = w
    onDestroyWin(Window(this))
    
  of neLabel:
    # https://developer.gnome.org/gtk3/stable/GtkLabel.html
    this.data = newLabel()
    
  of neEntry:
    # https://developer.gnome.org/gtk3/stable/GtkEntry.html
    this.data = newEntry()
    
  of neButton:
    # https://developer.gnome.org/gtk3/stable/GtkButton.html
    this.data = newButton()
    
  of neRadio:
    # https://developer.gnome.org/gtk3/stable/GtkRadioButton.html
    this.data = newRadioButton()
  
  of neBubble:
    # https://developer.gnome.org/gtk3/stable/GtkPopover.html
    this.data = newPopover()
  
  of neImage:
    # https://developer.gnome.org/gtk3/stable/GtkImage.html
    this.data = newImage()
    
  of neTextArea:
    # https://developer.gnome.org/gtk3/stable/GtkTextView.html
    this.data = newTextView()
    
  of neCalendar:
    # https://developer.gnome.org/gtk3/stable/GtkCalendar.html
    this.data = newCalendar()
    
  of neSlider:
    # https://developer.gnome.org/gtk3/stable/GtkScale.html
    var s: gtkScale
    when v2: s = hscale_new(0, 100, 1)
    else:    s = newScale(Orientation.HORIZONTAL, 0, 100, 1) 
    s.setDrawValue(false)
    this.data = s
    
  of neCheckbox:
    # https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
    this.data = newCheckButton()
  
  of neFileChoose:
    # https://developer.gnome.org/gtk3/stable/GtkFileChooserDialog.html
    this.data = newFileChooser()
    discard this.data(gtkDialog).addButton("Open", 0)

  of neTab:
    # https://developer.gnome.org/gtk3/stable/GtkNotebook.html
    this.data = newNoteBook()
  
  of neBar:
    # https://developer.gnome.org/gtk3/stable/GtkMenuBar.html
    this.data = newMenuBar()
  
  of neMenu:
    # https://developer.gnome.org/gtk3/stable/GtkMenu.html
    this.data = newMenu()
  
  of neComboBox:
    # https://developer.gnome.org/gtk3/stable/GtkComboBox.html
    # TODO: Can handle more than text
    let
      c  = newComboBox()
      r  = newCellRendererText()
      cl = cast[gtkCellLayout](c)

    cl.packStart(r, true)
    cl.addAttribute(r, "text", 0)
  
    this.data = c
    
  of neProgress:
    # https://developer.gnome.org/gtk3/stable/GtkProgressBar.html
    this.data = newProgressBar()
  
  of neBox:
    # https://developer.gnome.org/gtk3/stable/GtkBox.html
    this.data = newBox()
    
  of neTable:
    # https://developer.gnome.org/gtk3/stable/GtkTreeView.html
    # https://developer.gnome.org/gtk3/stable/GtkListStore.html
    this.data = newTreeView()
    
  of neTools:
    # https://developer.gnome.org/gtk3/stable/GtkToolbar.html
    this.data = newToolBar()
    
  of neTree:
    # https://developer.gnome.org/gtk3/stable/GtkTreeView.html
    this.data = newTreeView()

  of neList:
    # https://developer.gnome.org/gtk3/stable/GtkListBox.html
    this.data = newListBox()

  of neAlert:
    # https://developer.gnome.org/gtk3/stable/GtkMessageDialog.html
    this.data = newMessageDialog()

  else:
    raiseAssert("Invalid kind: " & $this.kind)
  
  doAssert this.raw != nil

  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#GtkWidget-destroy
  discard signal(
    this.data(gtkWidget),
    "destroy",
    SCB(gtkOnDestroyClean),
    cast[GPointer](this))


# WINDOW ----------------------------------------
proc internalSetText(this: Window, text: string) =
  this.data(gtkWindow).title = text

proc internalGetText(this: Window): string =
  $this.data(gtkWindow).getTitle()

proc internalSetResizable(this: Window, state: bool) =
  this.data(gtkWindow).setResizable(state)

proc internalGetResizable(this: Window): bool =
  this.data(gtkWindow).getResizable()

proc internalSetPosition(this: Window, position: tuple[x, y: int]) =
  this.data(gtkWindow).move(position.x.cint, position.y.cint)

proc internalGetPosition(this: Window): tuple[x, y: int] =
  var x, y: cint
  
  when v2:
    var (px, py) = (Pgint(x.addr), Pgint(y.addr))
    this.data(gtkWindow).getPosition(px, py)
    
  else:
    this.data(gtkWindow).getPosition(x, y)

  return (x.int, y.int)

proc internalGetFocused(this: Window): NElement =
  let widget = this.data(gtkWindow).getFocus()
  if widget == nil: return
  return utilElement(widget)

proc internalGetIcon(this: Window): Bitmap =
  newBitmap(this.data(gtkWindow).getIcon())

proc internalSetIcon(this: Window, that: Bitmap) =
  this.data(gtkWindow).setIcon(pixbuf(that))

proc internalGetDecorated(this: Window): bool =
  bool(this.data(gtkWindow).getDecorated())
  
proc internalSetDecorated(this: Window, v: bool) =
  this.data(gtkWindow).setDecorated(v)

proc internalSetMinimized(this: Window, v: bool) =
  if v: this.data(gtkWindow).iconify()
  else: this.data(gtkWindow).deiconify()
  
proc internalGetMinimized(this: Window): bool =
  discard # TODO

proc internalSetMaximized(this: Window, v: bool) =
  if v: this.data(gtkWindow).maximize()
  else: this.data(gtkWindow).unmaximize()
  
proc internalGetMaximized(this: Window): bool =
  when v2: discard # TODO
  else: this.data(gtkWindow).isMaximized()

proc onDestroyWin(this: Window) =
  # TODO: This should be optional
  proc cb(this: gtkWidget, data: GPointer) {.cdecl.} =
    if utilLen(getApp()) <= 1: internalStop(getApp())
  discard this.data(gtkWindow).signal("destroy", SCB(cb), nil)

proc internalSetModal(this: Window, v: bool) =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-set-modal
  this.data(gtkWindow).setModal(v)

proc internalGetModal(this: Window): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-modal
  this.data(gtkWindow).getModal()
  
proc internalSetTransient(this, that: Window) =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-set-transient-for
  this.data(gtkWindow).setTransientFor(that.data(gtkWindow))

proc internalGetTransient(this: Window): Window =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-transient-for
  let w = this.data(gtkWindow).getTransientFor()
  if w != nil: return Window(utilElement(w))


# CONTAINER -------------------------------------
proc internalRemove(this: Container, that: NElement) =  
  let (thisD, thatD) = (this.data(gtkContainer), that.data(gtkWidget))
  doAssert thisD != nil and thatD != nil

  utilRemove(this, that)

  if not utilDelAdapter(thatD, adapters):
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
    let box = this.data(gtkBox)
    box.add(newSeparator(toOrientation(dir)))
  elif this of Menu:
    let menu = this.data(gtkMenu)
    menu.add(newSeparatorMenuItem())
  elif this of Tools:
    let tools = this.data(gtkToolBar)
    when v2: tools.add(newSeparator(toOrientation(dir)))
    else:    tools.add(newSeparatorToolItem())

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
  doAssert thisD != nil and thatD != nil

  var adapter = adapters # TODO: Store adapter used
  if this of Box: adapter = adaptersScrolledWindow
  
  if not utilTryAddChild(thisD, thatD, adapter):
    # https://developer.gnome.org/gtk3/stable/GtkContainer.html#gtk-container-add
    when v2:
      if this of List:
        if not (that of Label):
          raiseAssert("Cannot add this element to gtk List: " & $that.kind)
        var text = [cstring(Label(that).internalGetText)]
        discard this.data(gtkListBox).append(text.addr)

      else:
        thisD.add(thatD)
      
    else:
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
  if cast[gtkTreeModel](ls).getIter(ti.addr, tPath):
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
  this.data(gtkCheckButton).setLabel(that)

proc internalGetText(this: Checkbox): string =
  $this.data(gtkCheckButton).getLabel()

proc internalGetChecked(this: Checkbox): bool =
  this.data(gtkCheckButton).getActive()

proc internalSetChecked(this: Checkbox, v: bool) =
  this.data(gtkCheckButton).setActive(v)


# LABEL -----------------------------------------
proc internalSetText(this: Label, text: string) =
  this.data(gtkLabel).setText(text)

proc internalGetText(this: Label): string =
  $this.data(gtkLabel).getText()

proc internalSetWrap(this: Label, state: bool) =
  this.data(gtkLabel).setLineWrap(state)

proc internalGetWrap(this: Label): bool =
  this.data(gtkLabel).getLineWrap()

proc internalGetXAlign(this: Label): float =
  when v2:
    var x, y: gfloat
    var (px, py) = (Pgfloat(x.addr), Pgfloat(y.addr))
    this.data(gtkLabel).get_alignment(px, py)
    discard y
    return float(x)
    
  else:
    this.data(gtkLabel).getXAlign()

proc internalGetYAlign(this: Label): float =
  when v2:
    var x, y: gfloat
    var (px, py) = (Pgfloat(x.addr), Pgfloat(y.addr))
    this.data(gtkLabel).get_alignment(px, py)
    discard x
    return float(y)

  else:
    this.data(gtkLabel).getYAlign()
  
proc internalSetXAlign(this: Label, v: float) =
  when v2:    
    this.data(gtkLabel).set_alignment(
      gfloat(v), gfloat(internalGetYAlign(this)))
    
  else:
    this.data(gtkLabel).setXAlign(v)

proc internalSetYAlign(this: Label, v: float) =
  when v2:    
    this.data(gtkLabel).set_alignment(
      gfloat(internalGetXAlign(this)), gfloat(v))

  else:
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
    img =
      when v2: image_new_from_pixbuf(pb)
      else:    newImage(pb)

  this.data(gtkButton).setImage(img)

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
  let thisD = this.data(gtkBox)

  if state:    
    discard utilInsertAdapter(thisD, adaptersScrolledWindow)
  else:
    discard utilDelAdapter(thisD, adaptersScrolledWindow)

proc internalScrollbar(this: Box): bool =
  gTypeCheckInstanceType(
    this.data(gtkBox).getParent(),
    (when v2: TYPE_VIEWPORT() else: typeScrollable()))


# RADIO -----------------------------------------
proc internalGetText(this: Radio): string =
  $this.data(gtkRadioButton).getLabel()

proc internalSetText(this: Radio, text: string) =
  this.data(gtkRadioButton).setLabel(text)

proc internalSetGroup(radios: openArray[Radio]) =
  if len(radios) <= 1: return
  let r1 = radios[0].data(gtkRadioButton)
  for r2 in radios[1..^1]: r2.data(gtkRadioButton).joinGroup(r1)


# TEXT_AREA
proc internalSetText(this: TextArea, text: string) =
  let buffer = this.data(gtkTextView).getBuffer()
  buffer.setText(text, text.len.cint)

proc internalGetText(this: TextArea): string =
  var s, e: gtkTextIter
  let buffer = this.data(gtkTextView).getBuffer()
  buffer.getBounds(s, e)
  return $buffer.getText(s, e, true)


# PROGRESS --------------------------------------
proc internalValue(this: Progress): float =
  float(this.data(gtkProgressBar).getFraction())

proc internalValue(this: Progress, v: float) =
  this.data(gtkProgressBar).setFraction(v)


# CALENDAR --------------------------------------
proc internalGetDate(this: Calendar): DateTime =
  var d, m, y: cuint
  
  when v2:
    this.data(gtkCalendar).getDate(y.addr, m.addr, d.addr)
  else:
    this.data(gtkCalendar).getDate(y, m, d)

  return initDateTime(
    monthday = MonthdayRange(d), month = Month(m + 1), year = int(y),
    0, 0, 0, 0)

template discardVal(op) =
  when v2: discard op else: op

proc internalSetDate(this: Calendar, date: DateTime) =
  let c = this.data(gtkCalendar)
  discardVal c.selectMonth((date.month.int - 1).cuint, date.year.cuint)
  c.selectDay(date.monthday.cuint)

when v2:
  var marks: STable[Calendar, system.set[1 .. 31]]

proc internalMark(this: Calendar, day: int) =
  when v2:
    if this notin marks: marks[this] = {}
    incl(marks[this], day)
  discardVal this.data(gtkCalendar).markDay(day.cuint)

proc internalUnmark(this: Calendar, day: int) =
  when v2: excl(marks[this], day)
  discardVal this.data(gtkCalendar).unmarkDay(day.cuint)

proc internalClear(this: Calendar) =
  when v2: del(marks, this)
  this.data(gtkCalendar).clearMarks()

proc internalMarked(this: Calendar, day: int): bool =
  when v2: day in getOrDefault(marks, this)
  else:    this.data(gtkCalendar).getDayIsMarked(day.cuint)


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
  this.data(gtkScale).setIncrements(step.cdouble, step.cdouble)
  
proc internalGetStep(this: Slider): float = gtkScaleStep[this.id]

proc internalSetRange(this: Slider, range: Slice[float]) =
  gtkScaleRange[this.id] = range
  this.data(gtkScale).setRange(range.a.cdouble, range.b.cdouble)

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
  this.data(gtkWindow).setModal(v)

proc internalGetModal(this: Alert): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-modal
  this.data(gtkWindow).getModal()
  
proc internalSetTransient(this: Alert, that: Window) =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-set-transient-for
  this.data(gtkWindow).setTransientFor(that.data(gtkWindow))

proc internalGetTransient(this: Alert): Window =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-transient-for
  let w = this.data(gtkWindow).getTransientFor()
  if w != nil: return Window(utilElement(w))


# IMAGE -----------------------------------------
var bitmaps: STable[NID, Bitmap] # Image.bitmap

proc newBitmap(pixbuf: GDKPixbuf): Bitmap =
  # https://developer.gnome.org/gdk-pixbuf/2.36/
  if isNil(pixbuf): return
  
  discard gtkRef(cast[GPointer](pixbuf))
  
  var
    data   = pixbuf
    (w, h) = (getWidth(pixbuf), getHeight(pixbuf))
    c      = getNChannels(pixbuf)

  doAssert c in 3 .. 4
    
  if c == 3:
    const Z = when v2: 0 else: 0.cuchar
    data   = pixbuf.addAlpha(false, Z, Z, Z)

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
  when not v2:
    toNGUISelection(this.data(gtkListBox).getSelectionMode)
  else:
    toNGUISelection(this.data(gtkListBox).selection_mode)

proc internalSetMode(this: List, mode: NAmount) =
  this.data(gtkListBox).setSelectionMode(toGTKSelection(mode))

proc internalSelected(this: List, that: var seq[NElement]) =
  # TODO: Broken for GTK2. Throw everything away and use Tables instead
  when not v2:
    var r = this.data(gtkListBox).getSelectedRows()
    while r != nil:
      let d = cast[gtkListBoxRow](r.data).getChild()
      that.add(d.utilElement())
      r = r.next
    free(r)
  else:
    discard # TODO


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
          utilGetOrAddAdapter(lastD, adaptersMenuItem))
        gtkMenuItem(mItem).setSubmenu(that.data(gtkMenu))
        return

      # Sorry, but in between Bar and Menu, we need
      # a label or something, now you will die
      raiseAssert(
        "Cannot add Menu directly to Bar. Add Menu to label and " &
        "that label to Bar instead")

    # MenuBar -> CREATE(MenuItem->Menu) -> That
    else:      
      # Maybe 'that' already has a MenuItem attached
      discard utilInsertAdapter(thisD, thatD, adaptersMenuItem)

  # Menu -> CREATE(MenuItem) -> That  
  elif this of Menu:
    discard utilInsertAdapter(thisD, thatD, adaptersMenuItem)
  
  # CREATE(MenuItem) -> This -> That
  elif that of Menu:
    let mItem = cast[gtkMenuItem](
      utilGetOrAddAdapter(thisD, adaptersMenuItem))
    mItem.setSubmenu(gtkMenu(thatD))

    if utilExists(neClick, thisD) and not utilExists(neClick, mItem):
      utilSet(neClick, mItem, utilGet(neClick, thisD))
      discard signal(
        mItem, "activate", SCB(triggerEvent), cast[pointer](neClick))
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
    that.data(gtkContainer), label.data(gtkLabel))
  utilChild(this, that)
  utilChild(that, label)

proc internalSetReorderable(this: Tab, v: bool) =
  let thisD = this.data(gtkNoteBook)
  for i in 0 ..< internalLen(this): # :-/
    let c = internalGetChild(this, i)
    thisD.setTabReorderable(c.data(gtkWidget), v)

proc internalGetReorderable(this: Tab): bool =
  if internalLen(this) == 0: return
  return this.data(gtkNoteBook)
    .getTabReorderable(internalGetChild(this, 0).data(gtkWidget))

proc internalGetSide(this: Tab): NSide =
  [nsLeft, nsRight, nsTop, nsBottom][
    int(this.data(gtkNoteBook).getTabPos())]

proc internalSetSide(this: Tab, side: NSide) =  
  when v2:
    # GTK2 doesn't support left/right sides?
    let p = guint([0, 1, 0, 1][int(side)])

  else:
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
  discard utilInsertAdapter(thisD, thatD, adaptersToolItem)
  utilChild(this, that)
  

# Table/Tree Common -----------------------------

var tableMeta: STable[NID, tuple[
    columns: int,
    header:  seq[tuple[kind: NCellKind, name: string]],
  ]]

proc pbType: auto =
  when v2:
    return TYPE_PIXBUF()

  else:
    proc hackGetPixbufType: GType =
      var t {.global.}: GType
      once:
        let pb = newPixbuf(GdkColorspace.RGB, false, 8, 1, 1)
        t = gObjectType(pb)
        objectUnref(pb)
        
      return t
    
    return hackGetPixbufType()
  
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
  let gvt = (when v2: G_VALUE_TYPE(v.addr) else: gValueType(v.addr))

  if gvt == G_TYPE_STRING:
    result = toCell($getString(v.addr))
  elif gvt == G_TYPE_INT:
    result = toCell(getInt(v.addr))
  elif gvt == G_TYPE_BOOLEAN:
   result = toCell(getBoolean(v.addr))
  elif gvt == pbType():
    result = NCell(kind: ckImg)
    
    template holdsPointer: bool =
      # Good job
      (when v2: G_TYPE_CHECK_VALUE_TYPE else: g_TYPE_CHECK_VALUE_TYPE)(
        v.addr, G_TYPE_POINTER)
    
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
    if getIter(ls, ti.addr, tPath):
      tableSet(this, ls, ti, that, path.column)

proc tableGet(ls: gtkTreeModel, path: TMPath): NCell =
  withIter path:
    if getIter(ls, ti.addr, tPath):
      result = tableGet(ls, ti, path.column)

proc toGType(this: NCellKind): GType =
  case this:
  of ckInt:  G_TYPE_INT
  of ckStr:  G_TYPE_STRING
  of ckBool: G_TYPE_BOOLEAN
  of ckImg:  pbType()

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
    if this of NTable: listStoreNewv(list.len.cint, addr(list[0]))
    else:              treeStoreNewv(list.len.cint, addr(list[0]))

  var lastColumn: gtkTreeViewColumn
  for i, (kind, name) in header:
    template add(newRenderer, t) =
      let
        renderer = newRenderer()
        append   = visible and name == ""
        column =
          if append: lastColumn else: newTreeViewColumn()

      doAssert column != nil
      lastColumn = column

      when v2:
        columnPackStart(column, renderer, false)
        columnAddAttribute(column, renderer, t, cint(i))

      else:
        packStart(column, renderer, false)
        addAttribute(column, renderer, t, cint(i))

      if not append:
        # append renderer to last column, not column to tree view
        when v2:
          columnSetTitle(column, name)

        else:
          setTitle(column, name)
        doAssert bool(appendColumn(tv, column))

    case kind:
    of ckStr, ckInt:
      add(newCellRendererText,   "text")
    of ckBool:
      add(newCellRendererToggle, "active")
    of ckImg:
      add(newCellRendererPixbuf, "pixbuf")

  setModel(tv, cast[gtkTreeModel](ls))
  setHeadersVisible(tv, visible)
  
  # Meta data
  tableMeta[this.id] = (
    columns: len(header),
    header:  @header)

proc onAdd(this: NElement, that: NRow, path: TMPath) =
  doAssert this of NTable or this of Tree
 
  let
    tv = this.data(gtkTreeView)
    ls = tv.getModel()

  doAssert ls != nil

  var ti: gtkTreeIterObj
  
  # TABLE -----------------------------
  if this of NTable:
    discard path
    let ls = cast[gtkListStore](ls)
    append(ls, ti.addr)

  # TREE ------------------------------
  else:
    # https://en.wikibooks.org/wiki/GTK%2B_By_Example/Tree_View/Tree_Models#Adding_Rows_to_a_Tree_Store
    let ls = cast[gtkTreeStore](ls)
    
    if path.depth.len == 0:
      append(ls, ti.addr, nil)

    else:
      var ti2: gtkTreeIterObj
      let tPath = toTreePath(path)

      doAssert cast[gtkTreeModel](ls).getIter(ti2.addr, tPath)
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
      when v2: remove(ls, ti.addr)
      else:    discard remove(ls, ti.addr)


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
  this.data(gtkTreeView).getHeadersVisible()

proc internalHeaders(this: NTable, v: bool) =
  this.data(gtkTreeView).setHeadersVisible(v)

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
    model: (when v2: ptr[gtkTreeModel] else: gtkTreeModel)
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

  when v2:
    # https://developer.gnome.org/gtk2/stable/GtkTreeSelection.html#gtk-tree-selection-get-selected-rows
    foreach(r, cast[TGFunc](gtk_tree_path_free), nil)
  else:
    freeFull(r, GDestroyNotify(free))

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
  this.data(gtkTreeView).getHeadersVisible()

proc internalHeaders(this: Tree, v: bool) =
  this.data(gtkTreeView).setHeadersVisible(v)

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
  
  clear(cast[gtkTreeStore](ts))


# CLIPBOARD -------------------------------------
proc getCB: Clipboard =
  when v2:
    clipboard_get(SELECTION_CLIPBOARD())
  else:
    # https://developer.gnome.org/gtk3/stable/gtk3-Clipboards.html
    var acb {.global.}: gdk.Atom
    once: acb = atomIntern("CLIPBOARD", true)
    return clipboardGet(acb)
  
template C: Clipboard = getCB()

proc internalClipboardClear = C.clear()
proc internalClipboardSet(text: string) = C.setText(text, text.len.cint)
proc internalClipboardSet(img: Bitmap) = C.setImage(pixbuf(img))

proc internalClipboardGetText: string =
  let txt = C.waitForText()
  if txt == nil: return
  result = $txt
  free(txt)

proc internalClipboardGetImg: Bitmap =
  let img = C.waitForImage()
  if img == nil: return
  result = newBitmap(cast[GdkPixBuf](img))
  objectUnref(img)
      

# TIMERS ----------------------------------------
proc internalRepeat(event: NRepeatProc, ms: int): NRepeatHandle =  
  # https://developer.gnome.org/gtk-tutorial/stable/c1759.html
  proc cb(a: GPointer): (when v2: bool else: GBoolean) {.cdecl.} =
    utilTrigger(cast[int](a))
  when v2: (const timeoutAdd = gtimeoutAdd)
  
  let rid = utilNextRepeatID()
  result = timeoutAdd(
    interval = cuint(ms),
    function = when v2: cast[gtk2.TFunction](cb) else: GSourceFunc(cb),
    data     = cast[GPointer](rid),
  ).NRepeatHandle

  utilRepeatAdd(event, result, rid)

proc internalStop(this: NRepeatHandle) =
  when v2: (const sourceRemove = gSourceRemove)
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
    nElement  = utilElement(widget)
    eventType =
      when v2: cast[PEventAny](e).`type`
      else: e.`type`

  # FileChoose Event
  if insideFCResponse and eventType == BUTTON_RELEASE:
    # HACK in the GTK
    
    var w = widget
    while not isFileChooser(w):
      w = getParent(w)
      doAssert w != nil

    result = NEventArgs(element: utilElement(w), kind: neFILE_CHOOSE_ACCEPT)
    var list = getFilenames(cast[gtkFileChooserDialog](w))

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
      let e = cast[(when v2: PEventButton else: EventButton)](e)
      
      if e.button == 1: result.mouse.incl(nm1)
      if e.button == 2: result.mouse.incl(nm2)
      if e.button == 3: result.mouse.incl(nm3)
      result.double = eventType == BUTTON2_PRESS
      
    else:
      var st: (when v2: TModifierType else: ModifierType)
      if e.getState((when v2: st.addr else: st)):
        template setMouse(a, b) =
          if (int(st) and int(a)) != 0: result.mouse.incl(b)

        setMouse(BUTTON1_MASK, nm1)
        setMouse(BUTTON2_MASK, nm2)
        setMouse(BUTTON3_MASK, nm3)

    when v2:
      let e = cast[PEventButton](e)
      result.x = e.x.int
      result.y = e.y.int

    else:
      result.x = e.button.x.int
      result.y = e.button.y.int

  of KEY_PRESS, KEY_RELEASE:    
    let
      keyVal = (when v2: cast[PEventKey](e) else: e.key).keyval
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

    var st: (when v2: TModifierType else: ModifierType)
    if e.getState((when v2: st.addr else: st)):
      template mapMod(mt: typed, k: NKey) =
        if (int(st) and int(mt)) != 0: result.mods.incl(k)

      mapMod(CONTROL_MASK, nkControl)
      mapMod(SHIFT_MASK,   nkShift)

  else: discard

  result.element = nElement
  free(e)