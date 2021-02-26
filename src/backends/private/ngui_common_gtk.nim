includeUtils ELEMENT, CONTAINER, EVENT, TIMER, ADAPTER


# INCLUDE IN ngui_begtkX.nim

const
  v2: bool = backend == beGTK2
  v3: bool = backend == beGTK3


# GTK2 START ------------------------------------
when v2:
  import gtk2/[gtk2, gdk2, glib2, gdk2, gdk2pixbuf, cairo]

  type
    gtkWindow      = gtk2.PWindow
    gtkDialog      = gtk2.PDialog
    gtkWidget      = gtk2.PWidget
    gtkContainer   = gtk2.PContainer
    gtkComboBox    = gtk2.PComboBox
    gtkListStore   = gtk2.PListStore
    gtkTreeIterObj = gtk2.TTreeIter
    gtkTreeModel   = gtk2.PTreeModel
    gtkRadioButton = gtk2.PRadioButton
    gtkButton      = gtk2.PButton
    gtkToolItem    = gtk2.PToolItem
    gtkGrid        = gtk2.PTable
    gtkLabel       = gtk2.PLabel
    gtkEntry       = gtk2.PEntry
    # gtkPopover     = gtk2.PPopover TODO
    gtkImage       = gtk2.PImage
    gtkTextView    = gtk2.PTextView
    gtkCalendar    = gtk2.PCalendar
    gtkScale       = gtk2.PScale
    gtkBox         = gtk2.PBox
    gtkCheckButton = gtk2.PCheckButton
    gtkFileChooserDialog = gtk2.PFileChooser
    gtkCellLayout  = gtk2.PPGtkCellLayout
    GPointer       = glib2.PGpointer
    gtkOrientable  = gtk2.PWidget
    Orientation    = gtk2.TOrientation
    GValueObj      = glib2.TGValue
    
    GDKPixbuf      = gdk2pixbuf.PPixbuf

  const
    SCB          = gtk2.SIGNAL_FUNC
    signal       = gtk2.signalConnect
    gtkDestroy   = proc(w: gtkWidget) = gtk2.destroy(w)

  proc gtkRef(w: PWidget): auto = reference(w)
  proc gtkRef(w: GPointer): auto = gObjectRef(w)
  proc newMenuItem(): auto = gtk2.menu_item_new()
  proc newEventBox(): auto = gtk2.event_box_new()
  proc newToolItem(): auto = gtk2.tool_item_new()
  proc newWindow(): auto = gtk2.window_new(gtk2.WINDOW_TOP_LEVEL)
  proc newGrid(): auto = gtk2.table_new(1, 1, true)
  proc newLabel(): auto = gtk2.label_new("")
  proc newEntry(): auto = gtk2.entry_new()
  proc newButton(): auto = gtk2.button_new()
  proc newRadioButton(): auto = gtk2.radio_button_new(nil)
  proc newImage(): auto = gtk2.image_new()
  proc newTextView(): auto = gtk2.text_view_new()
  proc newCalendar(): auto = gtk2.calendar_new()
  proc newCheckButton(): auto = gtk2.check_button_new()
  proc newPopover(): gtkWidget = raiseAssert("TODO") # cast[gtkWidget](gtk2.pop_over_new())
  proc newFileChooser(): auto = gtk2.file_chooser_dialog_new(
    nil, nil, FILE_CHOOSER_ACTION_OPEN, nil)
  proc newNoteBook(): auto = gtk2.notebook_new()
  proc newMenuBar(): auto = gtk2.menu_bar_new()
  proc newMenu(): auto = gtk2.menu_new()
  proc newComboBox(): auto = gtk2.comboBox_new_with_model(
    cast[gtkTreeModel](gtk2.list_store_new(1, G_TYPE_STRING)))
  proc newCellRendererText(): auto = gtk2.cell_renderer_text_new()
  proc newProgressBar(): auto = gtk2.progress_bar_new()
  proc newScale(): auto = gtk2.hscale_new(nil) # TODO change orientation
  proc newBox(): auto = gtk2.vbox_new(true, 0) # TODO change Orientation
  proc newTreeView(): auto = gtk2.tree_view_new()
  proc newToolBar(): auto = gtk2.tool_bar_new()
  proc newFrame(): auto = gtk2.frame_new("")
  proc newListBox(): auto = gtk2.list_new() # https://developer.gnome.org/gtk2/2.24/GtkList.html
  proc newTreePath(a, b: int): auto = gtk2.tree_path_new_from_string($a & ":" & $b)
  proc newMessageDialog(): auto = gtk2.message_dialog_new(
    nil,
    0, # https://developer.gnome.org/gtk2/2.24/GtkDialog.html#GtkDialogFlags # TODO: TODO
    MESSAGE_OTHER, # https://developer.gnome.org/gtk2/2.24/GtkMessageDialog.html#GtkMessageType
    BUTTONS_CLOSE, # https://developer.gnome.org/gtk2/2.24/GtkMessageDialog.html#GtkButtonsType
    nil)
  proc loadPixbuf(file: string): GDKPixbuf =
    var error: pointer
    return pixbuf_new_from_file(file, error)
  proc joinGroup(a, b: gtkRadioButton) =
    a.setGroup(b.getGroup())


# GTK3 START ------------------------------------  
elif v3:
  import oldgtk3/[gtk, glib, gobject, gdk, cairo, gdk_pixbuf]
  
  type
    gtkWindow      = gtk.Window
    gtkDialog      = gtk.Dialog
    gtkWidget      = gtk.Widget
    gtkContainer   = gtk.Container
    gtkTextView    = gtk.TextView
    gtkRadioButton = gtk.RadioButton
    gtkButton      = gtk.Button
    gtkLabel       = gtk.Label
    gtkEntry       = gtk.Entry
    gtkGrid        = gtk.Grid
    gtkPopover     = gtk.PopOver
    gtkImage       = gtk.Image
    gtkCalendar    = gtk.Calendar
    gtkScale       = gtk.Scale
    gtkBox         = gtk.Box
    gtkCheckButton = gtk.CheckButton
    gtkFileChooserDialog = gtk.FileChooser
    gtkCellLayout  = gtk.CellLayout
    gtkComboBox    = gtk.ComboBox
    gtkListStore   = gtk.ListStore
    gtkTreeIterObj = gtk.TreeIterObj
    gtkTreeModel   = gtk.TreeModel
    gtkOrientable  = gtk.Orientable
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
  proc newFileChooser(): auto = gtk.newFileChooserDialog(nil, nil, OPEN, nil)
  proc newComboBox(): auto = gtk.newComboBox(
    cast[gtkTreeModel](gtk.newListStore(1, G_TYPE_STRING)))
  proc newBox(): auto = gtk.newBox(Orientation.Vertical, 0)
  proc newFrame(): auto = gtk.newFrame("")
  proc newMessageDialog(): auto = gtk.newMessageDialog(
    nil,
    gtk.DialogFlags.MODAL, # TODO: TODO
    gtk.MessageType.OTHER,
    gtk.ButtonsType.CLOSE,
    nil)
  proc loadPixbuf(file: string): GDKPixbuf =
    var error: glib.GError
    return newPixbufFromFile(file, error)


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


proc nextID: NID =
  var pool {.global.}: NID = 100_000
  result = pool
  inc(pool)
  doAssert pool != 0, "Error: Too many NElements"
  

# ETC -------------------------------------------
template gtkYouAreKillingMe() {.dirty.} =
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

proc gtkGet[T](this: NElement, prop: string, val: var T) =
  # https://developer.gnome.org/gobject/stable/gobject-Standard-Parameter-and-Value-Types.html
  # https://developer.gnome.org/gobject/stable/gobject-The-Base-Object-Type.html#g-object-get-property
  var v: GValueObj
  this.data(gtkWidget).getProperty(prop, addr(v))
  gtkYouAreKillingMe()

proc gtkGet[T](this: NElement, prop: string): T =
  gtkGet(this, prop, result)

proc gtkSet[T](this: NElement, prop: string, val: T) =
  var v: GValueObj
  template getV: auto =
    when v2: addr(v) else: v
  
  when val is bool:
    discard getV.init(G_TYPE_BOOLEAN)
    v.setBoolean(val)
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
  this.data(gtkWidget).setProperty(prop, addr(v))


# EVENTS ----------------------------------------
proc clean(this: NElement) {.cdecl.} =
  if not utilExists(this): return

  if this of Container:
    for c in utilItems(Container(this)):
      clean(c)

  let raw = cast[gtkWidget](this.raw)

  utilDel(this)
  utilDelParent(this)
  del(names, this)
  del(tags, this)
  discard utilDelAdapter(raw, adapters)

  if this of Container: utilRemChildrenList(Container(this))

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
  const EVENT_TO_SIGNAL = [
    neNone: "LET'S_DANCE", neClick: "button-press-event",
    neClickRelease: "button-release-event", neMove: "motion-notify-event",
    neEnter: "activate",
    neChange: "changed", neOpen: "popped-up", neFocusOn: "focus-in-event",
    neFocusOff: "focus-out-event", neDESTROY: "destroy", neSHOW: "show",
    neHIDE: "hide", neKeyPress: "key_press_event",
    neKeyRelease: "key-release-event",
  ]

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
    gtkEvent = "response"
  
  elif this of Button and nguiEvent == neClick:
    # https://developer.gnome.org/gtk3/stable/GtkButton.html#GtkButton-clicked
    gtkEvent = "clicked"
  
  elif this of Slider and nguiEvent == neChange:
    # https://developer.gnome.org/gtk3/stable/GtkRange.html#GtkRange-value-changed
    gtkEvent = "value-changed"

  elif this of Checkbox and nguiEvent == neChange:
    # https://developer.gnome.org/gtk3/stable/GtkToggleButton.html#GtkToggleButton-toggled
    gtkEvent = "toggled"
  
  elif this of List and nguiEvent in {neChange}:
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
      return triggerEvent(source, data))

  # -------------------------------------
  doAssert not utilExists(nguiEvent, gtkInst) # TODO: replace old event with new one. I added this to debug a bug.
  utilSet(nguiEvent, gtkInst, action)
  # https://developer.gnome.org/gobject/stable/gobject-Signals.html#g-signal-connect
  discard signal(gtkInst, gtkEvent, nguiTrigger, gtkData)


# WIDGET ----------------------------------------
proc onDestroyWin(this: Window) # FD

proc internalNewNElement(kind: NElementKind): NElement =
  doAssert kind != neKindInvalid
  
  result    = newElement(kind)
  result.id = nextID()

  doAssert result.kind != neKindInvalid
  
  case kind:
  of neApp:
    when v2: gtk2.nim_init()
    elif v3: gtk.initWithArgv()
    return

  of neWindow:
    # https://developer.gnome.org/gtk3/stable/GtkWindow.html
    let w = newWindow()
    result.data = w
    onDestroyWin(Window(result))
    
  of neGrid:
    # https://developer.gnome.org/gtk3/unstable/GtkGrid.html
    result.data = newGrid()
    
  of neLabel:
    # https://developer.gnome.org/gtk3/stable/GtkLabel.html
    result.data = newLabel()
    
  of neEntry:
    # https://developer.gnome.org/gtk3/stable/GtkEntry.html
    result.data = newEntry()
    
  of neButton:
    # https://developer.gnome.org/gtk3/stable/GtkButton.html
    result.data = newButton()
    
  of neRadio:
    # https://developer.gnome.org/gtk3/stable/GtkRadioButton.html
    result.data = newRadioButton()
  
  of neBubble:
    # https://developer.gnome.org/gtk3/stable/GtkPopover.html
    result.data = newPopover()
  
  of neImage:
    # https://developer.gnome.org/gtk3/stable/GtkImage.html
    result.data = newImage()
    
  of neTextArea:
    # https://developer.gnome.org/gtk3/stable/GtkTextView.html
    result.data = newTextView()
    
  of neCalendar:
    # https://developer.gnome.org/gtk3/stable/GtkCalendar.html
    result.data = newCalendar()
    
  of neSlider:
    # https://developer.gnome.org/gtk3/stable/GtkScale.html
    var s: gtkScale
    when v3:  s = newScale(Orientation.HORIZONTAL, 0, 100, 1)
    else:     raiseAssert("Bad luck blue eyes") # TODO
    s.setDrawValue(false)
    result.data = s
    
  of neCheckbox:
    # https://developer.gnome.org/gtk3/stable/GtkCheckButton.html
    result.data = newCheckButton()
  
  of neFileChoose:
    # https://developer.gnome.org/gtk3/stable/GtkFileChooserDialog.html
    result.data = newFileChooser()
    
  of neTab:
    # https://developer.gnome.org/gtk3/stable/GtkNotebook.html
    result.data = newNoteBook()
  
  of neBar:
    # https://developer.gnome.org/gtk3/stable/GtkMenuBar.html
    result.data = newMenuBar()
  
  of neMenu:
    # https://developer.gnome.org/gtk3/stable/GtkMenu.html
    result.data = newMenu()
  
  of neComboBox:
    # https://developer.gnome.org/gtk3/stable/GtkComboBox.html
    # TODO: Can handle more than text
    let
      c  = newComboBox()
      r  = newCellRendererText()
      cl = cast[gtkCellLayout](c)

    cl.packStart(r, true)
    cl.addAttribute(r, "text", 0)
  
    result.data = c
    
  of neProgress:
    # https://developer.gnome.org/gtk3/stable/GtkProgressBar.html
    result.data = newProgressBar()
  
  of neBox:
    # https://developer.gnome.org/gtk3/stable/GtkBox.html
    result.data = newBox()
    
  of neTable:
    # https://developer.gnome.org/gtk3/stable/GtkTreeView.html
    # https://developer.gnome.org/gtk3/stable/GtkListStore.html
    result.data = newTreeView()
    
  of neTools:
    # https://developer.gnome.org/gtk3/stable/GtkToolbar.html
    result.data = newToolBar()
    
  of neFrame:
    # https://developer.gnome.org/gtk3/stable/GtkFrame.html
    result.data = newFrame()
    
  of neList:
    # https://developer.gnome.org/gtk3/stable/GtkListBox.html
    result.data = newListBox()
  
  of neAlert:
    # https://developer.gnome.org/gtk3/stable/GtkMessageDialog.html
    result.data = newMessageDialog()

  else:
    raiseAssert("Invalid kind: " & $kind)
  
  doAssert result.raw != nil

  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#GtkWidget-destroy
  discard signal(
    result.data(gtkWidget),
    "destroy",
    SCB(gtkOnDestroyClean),
    cast[GPointer](result))


# WINDOW ----------------------------------------
proc onDestroyWin(this: Window) =
  # TODO: This should be optional
  proc cb(this: gtkWidget, data: GPointer) {.cdecl.} =
    if utilLen(pApp) == 1: internalStop(pApp)
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
proc reinsert(this: NElement) = utilChildrenReinsert(this.internalGetParent())

proc internalReplace(container: Container, this, that: NElement) =
  # TODO
  raiseAssert("Not implemented YET")

proc internalIndex(this: Container, that: NElement): int =
  utilChildIndex(this, that)

proc internalGetChild(this: Container, index: int): NElement =
  utilNChild(this, index)

proc internalLen(this: Container): int = utilLen(this)


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

  if cast[gtkTreeModel](ls).getIter(ti.addr, newTreePath(i, 1)):
    body

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


# ENTRY -----------------------------------------
proc internalGetText(this: Entry): string =
  $this.data(gtkEntry).getText()

proc internalSetText(this: Entry, text: string) =
  this.data(gtkEntry).setText(text)


# BUTTON ----------------------------------------
proc internalSetText(this: Button, text: string) =
  this.data(gtkButton).setLabel(text)
  
proc internalGetText(this: Button): string =
  $this.data(gtkButton).getLabel()


# BOX -------------------------------------------
proc internalGetOrientation(this: Box): NOrientation =
  NOrientation(this.data(gtkOrientable).getOrientation())

proc internalSetOrientation(this: Box, value: NOrientation) =
  this.data(gtkOrientable).setOrientation(Orientation(value))

proc internalSetSpacing(this: Box, spacing: int) =
  this.data(gtkBox).setSpacing(spacing.cint)


# RADIO -----------------------------------------
proc internalGetText(this: Radio): string =
  $this.data(gtkRadioButton).getLabel()

proc internalSetText(this: Radio, text: string) =
  this.data(gtkRadioButton).setLabel(text)

proc internalSetGroup(radios: openArray[Radio]) =
  if len(radios) <= 1: return
  let r1 = radios[0].data(gtkRadioButton)
  for r2 in radios[1..^1]: r2.data(gtkRadioButton).joinGroup(r1)


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
  var marks: STable[Calendar, set[1 .. 31]]

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
    pixels = getPixels(pixbuf)
    (w, h) = (getWidth(pixbuf), getHeight(pixbuf))
    c      = getNChannels(pixbuf)
    
  doAssert c in 3 .. 4
    
  if c == 3:
    const Z = when v2: 0 else: 0.cuchar
    data   = pixbuf.addAlpha(false, Z, Z, Z)
    pixels = data.getPixels()

  return Bitmap(
    width: w, height: h,
    pixels: cast[ptr[UncheckedArray[Pixel]]](pixels),
    data: pointer(data),
    channels: 4)

proc internalNewBitmap(file: string): Bitmap =
  result = newBitmap(loadPixbuf(file))
  if not isNil(result): result.path = file

proc internalGetBitmap(this: Image): Bitmap =
  bitmaps[this.id]

proc internalUpdate(this: Image, that: Bitmap) =
  bitmaps[this.id] = that
  setFromPixbuf(this.data(gtkImage), cast[GDKPixbuf](that.data))

proc internalCopy(this: Bitmap): Bitmap =
  newBitmap(copy(pixbuf = cast[GDKPixbuf](this.data)))

proc internalSave(this: Bitmap, path, format: string): bool =
  when v2: (var error: pointer)
  else:    (var error: GError)
  return cast[GDKPixbuf](this.data).save(path, format, error, nil)

proc internalIconBitmap(name: string): Bitmap =
  # https://developer.gnome.org/gtk3/stable/GtkIconTheme.html#gtk-icon-theme-load-icon
  when v2: (var error: pointer)
  else:    (var error: GError)
  return newBitmap(loadIcon(
    iconThemeGetDefault(),
    name,
    15.cint,
    GENERIC_FALLBACK,
    error))

proc internalIconBitmap(icon: NIcon): Bitmap =
  internalIconBitmap(
    # https://developer.gnome.org/icon-naming-spec/#names
    case icon:
    of niFolder:     "folder"
    of niFile:       "text-x-generic"
    of niFileOpen:   "document-open"
    of niExecutable: "application-x-executable"
  )