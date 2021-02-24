includeUtils ELEMENT, CONTAINER, EVENT, TIMER, ADAPTER



# INCLUDE

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
    gtkTextView    = gtk2.PTextView
    gtkRadioButton = gtk2.PRadioButton
    gtkButton      = gtk2.PButton
    gtkToolItem    = gtk2.PToolItem
    GPointer       = glib2.PGpointer

  const
    SCB          = gtk2.SIGNAL_FUNC
    signal       = gtk2.signalConnect

  proc gtkRef(w: PWidget): auto = reference(w)
  proc newMenuItem(): auto = gtk2.menu_item_new()
  proc newEventBox(): auto = gtk2.event_box_new()
  proc newToolItem(): auto = gtk2.tool_item_new()


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
    GPointer       = glib.GPointer
  
  const
    SCB          = proc(p: pointer): auto = gCALLBACK(p)
    newToolItem  = gtk.newToolItem
    newMenuItem  = proc: Widget = gtk.newMenuItem()
    gtkRef       = gobject.objectRef

  template signal(a, b, c, d: typed): auto =
    gSignalConnect(a, b, c, d)


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
