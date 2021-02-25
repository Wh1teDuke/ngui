includeUtils ELEMENT, CONTAINER, EVENT, TIMER, ADAPTER


# INCLUDE IN ngui_begtkX.nim

const
  v2: bool = backend == beGTK2
  v3: bool = backend == beGTK3


# GTK2 START ------------------------------------
when v2:
  import gtk2/[gtk2, gdk2, glib2]

  type
    gtkWindow      = gtk2.PWindow
    gtkWidget      = gtk2.PWidget
    gtkContainer   = gtk2.PContainer
    gtkRadioButton = gtk2.PRadioButton
    gtkButton      = gtk2.PButton
    gtkToolItem    = gtk2.PToolItem
    gtkGrid        = gtk2.PGrid
    gtkLabel       = gtk2.PLabel
    gtkPopover     = gtk2.PPopover
    gtkImage       = gtk2.PImage
    gtkTextView    = gtk2.PTextView
    gtkCalendar    = gtk2.PCalendar
    gtkScale       = gtk2.PScale
    gtkBox         = gtk2.PBox
    GtkCheckButton = gtk2.PCheckButton
    GPointer       = glib2.PGpointer

  const
    SCB          = gtk2.SIGNAL_FUNC
    signal       = gtk2.signalConnect

  proc gtkRef(w: PWidget): auto = reference(w)
  proc newMenuItem(): auto = gtk2.menu_item_new()
  proc newEventBox(): auto = gtk2.event_box_new()
  proc newToolItem(): auto = gtk2.tool_item_new()
  proc newWindow(): auto = gtk2.window_new(gtk2.WINDOW_TOP_LEVEL)
  proc newGrid(): auto = cast[gtkWidget](gtk2.grid_new())
  proc newLabel(): auto = gtk2.label_new("")
  proc newEntry(): auto = gtk2.entry_new()
  proc newButton(): auto = gtk2.button_new()
  proc newRadioButton(): auto = gtk2.radio_button_new(nil)
  proc newImage(): auto = gtk2.image_new()
  proc newTextView(): auto = gtk2.text_view_new()
  proc newCalendar(): auto = gtk2.calendar_new()
  proc newScale(): auto = gtk2.hscale_new(nil) # TODO
  proc newCheckButton(): auto = gtk2.check_button_new()
  proc newPopover(): auto = cast[gtkWidget](gtk2.pop_over_new())


# GTK3 START ------------------------------------  
elif v3:
  import oldgtk3/[gtk, glib, gobject, gdk, cairo, gdk_pixbuf]
  
  type
    gtkWindow      = gtk.Window
    gtkWidget      = gtk.Widget
    gtkContainer   = gtk.Container
    gtkTextView    = gtk.TextView
    gtkRadioButton = gtk.RadioButton
    gtkButton      = gtk.Button
    gtkGrid        = gtk.Grid
    gtkPopover     = gtk.PopOver
    gtkImage       = gtk.Image
    gtkTextView    = gtk.TextView
    gtkCalendar    = gtk.Calendar
    gtkScale       = gtk.Scale
    gtkBox         = gtk.Box
    GtkCheckButton = gtk.CheckButton
    GPointer       = glib.GPointer
  
  const
    SCB          = proc(p: pointer): auto = gCALLBACK(p)
    newToolItem  = gtk.newToolItem
    newMenuItem  = proc: Widget = gtk.newMenuItem()
    gtkRef       = gobject.objectRef

  template signal(a, b, c, d: typed): auto =
    gSignalConnect(a, b, c, d)
  
  proc newLabel(): auto = gtk.newLabel("")
  proc newButton(): auto = gtk.newButton("")
  proc newRadioButton(): auto = gtk.newRadioButton("")
  proc newWindow(): auto = gtk.newWindow(gtk.WindowType.TOP_LEVEL)
  proc newPopover(): auto = gtk.newPopover(nil)


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

proc internalSetEvent(this: NElement, event: NElementEvent, action: NEventProc) =
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

    #discard this.data(gtk2Window).signalConnect(
    #"destroy", SCB(cb), nil)

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
  elif this of Radio and nguiEvent in {neClick}:
    nguiTrigger = SCB(proc(source, data: GPointer): bool {.cdecl.} =
      if bool(cast[gtkRadioButton](source).getActive()):
        return triggerEvent(source, data))

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
  result    = newElement(kind)
  result.id = nextID()
  
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
    result.data = newFileChooserDialog(nil, nil, OPEN, nil)
    
  of neTab:
    # https://developer.gnome.org/gtk3/stable/GtkNotebook.html
    result.data = newNoteBook()
  
  of neBar:
    # https://developer.gnome.org/gtk3/stable/GtkMenuBar.html
    result.data = gtk.newMenuBar()
  
  of neMenu:
    # https://developer.gnome.org/gtk3/stable/GtkMenu.html
    result.data = gtk.newMenu()
  
  of neComboBox:
    # https://developer.gnome.org/gtk3/stable/GtkComboBox.html
    # TODO: Can handle more than text
    let c = newComboBox(
      cast[TreeModel](newListStore(1, G_TYPE_STRING)))
  
    let r = newCellRendererText()
    cast[gtk.CellLayout](c).packStart(r, true)
    cast[gtk.CellLayout](c).addAttribute(r, "text", 0)
  
    result.data = c
    
  of neProgress:
    # https://developer.gnome.org/gtk3/stable/GtkProgressBar.html
    result.data = newProgressBar()
  
  of neBox:
    # https://developer.gnome.org/gtk3/stable/GtkBox.html
    result.data = newBox(Orientation.Vertical, 0)
    
  of neTable:
    # https://developer.gnome.org/gtk3/stable/GtkTreeView.html
    # https://developer.gnome.org/gtk3/stable/GtkListStore.html
    result.data = newTreeView()
    
  of neTools:
    # https://developer.gnome.org/gtk3/stable/GtkToolbar.html
    result.data = newToolBar()
    
  of neFrame:
    # https://developer.gnome.org/gtk3/stable/GtkFrame.html
    result.data = newFrame("")
    
  of neList:
    # https://developer.gnome.org/gtk3/stable/GtkListBox.html
    result.data = newListBox()
  
  of neAlert:
    # https://developer.gnome.org/gtk3/stable/GtkMessageDialog.html
    result.data = newMessageDialog(
      nil,
      gtk.DialogFlags.MODAL, # TODO: TODO
      gtk.MessageType.OTHER,
      gtk.ButtonsType.CLOSE,
      nil)

  else:
    raiseAssert("Invalid kind: " & $kind)
  
  doAssert result.data != nil

  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#GtkWidget-destroy
  discard gSignalConnect(
    result.raw, "destroy", SCB(gtkOnDestroyClean), cast[GPointer](result))


# WINDOW ----------------------------------------
proc onDestroyWin(this: Window) =
  # TODO: This should be optional
  proc cb(this: gtkWidget, data: GPointer) {.cdecl.} =
    if utilLen(pApp) == 1: internalStop(pApp)
  discard this.data(gtkWindow).signal("destroy", SCB(cb), nil)