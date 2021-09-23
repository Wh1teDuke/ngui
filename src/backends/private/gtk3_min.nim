# -----------------------------------------------------------------------------
# MODIFIED FROM https://github.com/StefanSalewski/oldgtk3
# -----------------------------------------------------------------------------


const LIB_GTK =
  when defined(windows):    "libgtk-3-0.dll"
  elif defined(gtk_quartz): "libgtk-3.0.dylib"
  elif defined(macosx):     "libgtk-x11-3.0.dylib"
  else:                     "libgtk-3.so(|.0)"

{.pragma: libgtk, cdecl, dynlib: LIB_GTK.}

const LIB_GOBJ =
  when defined(windows): "libgobject-2.0-0.dll"
  elif defined(macosx):  "libgobject-2.0.dylib"
  else:                  "libgobject-2.0.so(|.0)"

{.pragma: libgobj, cdecl, dynlib: LIB_GOBJ.}

const LIB_GLIB =
  when defined(windows):  "libglib-2.0-0.dll"
  elif defined(macosx):   "libglib-2.0.dylib"
  else:                   "libglib-2.0.so(|.0)"

{.pragma: libglib, cdecl, dynlib: LIB_GLIB.}

const LIB_PIXBUF =
  when defined(windows):  "libgdk_pixbuf-2.0-0.dll"
  elif defined(macosx):   "libgdk_pixbuf-2.0.0.dylib"
  else:                   "libgdk_pixbuf-2.0.so"

{.pragma: libpixbuf, cdecl, dynlib: LIB_PIXBUF.}

const LIB_GDK =
  when defined(windows):    "libgdk-3-0.dll"
  elif defined(gtk_quartz): "libgdk-3.0.dylib"
  elif defined(macosx):     "libgdk-x11-3.0.dylib"
  else:                     "libgdk-3.so(|.0)"

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

const LIB_CAIRO =
  when defined(windows):    "libcairo-2.dll"
  elif defined(macosx):     "libcairo.dylib"
  else:                     "libcairo.so(|.2)"

{.pragma: libcairo, cdecl, dynlib: LIB_CAIRO.}


type
  Gboolean = distinct cint
  Gint = cint # glib aliases which are not really needed
  Guint = cuint
  Gshort = cshort
  Gushort = cushort
  Glong = clong
  Gulong = culong
  Gchar = cchar
  Guchar = char
  Gfloat = cfloat
  Gdouble = cdouble
  Gssize = int # csize # fix for Nim > 1.04 to avoid many depretaction warnings
  Gsize = uint # csize # note: csize is signed in Nim!
  GType = Gsize
  gtkFileChooser = distinct pointer
  gtkWidget      = distinct pointer
  gtkWindow      = distinct pointer
  gtkDialog      = distinct pointer
  gtkContainer   = distinct pointer
  gtkNoteBook    = distinct pointer
  gtkMenuItem    = distinct pointer
  gtkMenu        = distinct pointer
  gtkListBox     = distinct pointer
  gtkListBoxRow  = distinct pointer
  gtkTextView    = distinct pointer
  gtkTreeView    = distinct pointer
  gtkRadioButton = distinct pointer
  gtkButton      = distinct pointer
  gtkLabel       = distinct pointer
  gtkEntry       = distinct pointer
  gtkTextIter    = distinct pointer
  #gtkGrid        = distinct pointer
  gtkPopover     = distinct pointer
  gtkImage       = distinct pointer
  gtkCalendar    = distinct pointer
  gtkScale       = distinct pointer
  gtkBox         = distinct pointer
  gtkProgressBar = distinct pointer
  gtkCheckButton = distinct pointer
  gtkFileChooserDialog = distinct pointer
  gtkCellLayout  = distinct pointer
  gtkComboBox    = distinct pointer
  gtkListStore   = distinct pointer
  gtkTreeStore   = distinct pointer
  gtkTreeIterObj = TreeIterObj
  gtkTreeIter    = ptr TreeIterObj
  gtkTreeModel   = distinct pointer
  gtkToolBar     = distinct pointer
  gtkOrientable  = distinct pointer
  gtkTreeViewColumn = distinct pointer
  gtkTreeSelection = distinct pointer
  gtkTreePath = distinct pointer
  gtkEventBox = distinct pointer
  gtkMenuBar = distinct pointer
  gtkSelectionMode = SelectionMode
  gtkTextBuffer = distinct pointer
  Clipboard = distinct pointer
  gdkAtom = distinct pointer
  gtkStyleContext = distinct pointer
  
  GdkPixbuf = distinct pointer

  GPointer       = pointer  
  GCallback = proc () {.cdecl.}
  
  WindowType {.size: sizeof(cint), pure.} = enum
    TOPLEVEL, POPUP

  FileChooserAction {.size: sizeof(cint), pure.} = enum
    OPEN, SAVE,
    SELECT_FOLDER, CREATE_FOLDER
    
  Orientation {.size: sizeof(cint), pure.} = enum
    HORIZONTAL, VERTICAL
    
  DialogFlags {.size: sizeof(cint), pure.} = enum
    MODAL = 1 shl 0, DESTROY_WITH_PARENT = 1 shl 1,
    USE_HEADER_BAR = 1 shl 2
    
  MessageType {.size: sizeof(cint), pure.} = enum
    INFO, WARNING, QUESTION, ERROR,
    OTHER

  ButtonsType {.size: sizeof(cint), pure.} = enum
    NONE, OK, CLOSE, CANCEL,
    YES_NO, OK_CANCEL
  
  SelectionMode {.size: sizeof(cint), pure.} = enum
    NONE, SINGLE, BROWSE,
    MULTIPLE
    
  EventMask {.size: sizeof(cint), pure.} = enum
    EXPOSURE_MASK = 1 shl 1, POINTER_MOTION_MASK = 1 shl 2,
    POINTER_MOTION_HINT_MASK = 1 shl 3, BUTTON_MOTION_MASK = 1 shl 4,
    BUTTON1_MOTION_MASK = 1 shl 5, BUTTON2_MOTION_MASK = 1 shl 6,
    BUTTON3_MOTION_MASK = 1 shl 7, BUTTON_PRESS_MASK = 1 shl 8,
    BUTTON_RELEASE_MASK = 1 shl 9, KEY_PRESS_MASK = 1 shl 10,
    KEY_RELEASE_MASK = 1 shl 11, ENTER_NOTIFY_MASK = 1 shl 12,
    LEAVE_NOTIFY_MASK = 1 shl 13, FOCUS_CHANGE_MASK = 1 shl 14,
    STRUCTURE_MASK = 1 shl 15, PROPERTY_CHANGE_MASK = 1 shl 16,
    VISIBILITY_NOTIFY_MASK = 1 shl 17, PROXIMITY_IN_MASK = 1 shl 18,
    PROXIMITY_OUT_MASK = 1 shl 19, SUBSTRUCTURE_MASK = 1 shl 20,
    SCROLL_MASK = 1 shl 21, TOUCH_MASK = 1 shl 22,
    SMOOTH_SCROLL_MASK = 1 shl 23,
    ALL_EVENTS_MASK = 0xFFFFFE,
    TOUCHPAD_GESTURE_MASK = 1 shl 24,
    TABLET_PAD_MASK = 1 shl 25
  
  ModifierType {.size: sizeof(cint), pure.} = enum
    SHIFT_MASK = 1 shl 0, LOCK_MASK = 1 shl 1, CONTROL_MASK = 1 shl 2,
    MOD1_MASK = 1 shl 3, MOD2_MASK = 1 shl 4, MOD3_MASK = 1 shl 5,
    MOD4_MASK = 1 shl 6, MOD5_MASK = 1 shl 7, BUTTON1_MASK = 1 shl 8,
    BUTTON2_MASK = 1 shl 9, BUTTON3_MASK = 1 shl 10, BUTTON4_MASK = 1 shl 11,
    BUTTON5_MASK = 1 shl 12, MODIFIER_RESERVED_13_MASK = 1 shl 13,
    MODIFIER_RESERVED_14_MASK = 1 shl 14,
    MODIFIER_RESERVED_15_MASK = 1 shl 15,
    MODIFIER_RESERVED_16_MASK = 1 shl 16,
    MODIFIER_RESERVED_17_MASK = 1 shl 17,
    MODIFIER_RESERVED_18_MASK = 1 shl 18,
    MODIFIER_RESERVED_19_MASK = 1 shl 19,
    MODIFIER_RESERVED_20_MASK = 1 shl 20,
    MODIFIER_RESERVED_21_MASK = 1 shl 21,
    MODIFIER_RESERVED_22_MASK = 1 shl 22,
    MODIFIER_RESERVED_23_MASK = 1 shl 23,
    MODIFIER_RESERVED_24_MASK = 1 shl 24,
    MODIFIER_RESERVED_25_MASK = 1 shl 25, SUPER_MASK = 1 shl 26,
    HYPER_MASK = 1 shl 27, META_MASK = 1 shl 28,
    MODIFIER_RESERVED_29_MASK = 1 shl 29, RELEASE_MASK = 1 shl 30,
    MODIFIER_MASK = 0x5C001FFF
  
  ResponseType {.size: sizeof(cint), pure.} = enum
    HELP = - 11, APPLY = - 10, NO = - 9,
    YES = - 8, CLOSE = - 7, CANCEL = - 6,
    OK = - 5, DELETE_EVENT = - 4, ACCEPT = - 3,
    REJECT = - 2, NONE = - 1
  
  PositionType {.size: sizeof(cint), pure.} = enum
    LEFT, RIGHT, TOP, BOTTOM
  
  GConnectFlags {.size: sizeof(cint), pure.} = enum
    AFTER = 1 shl 0, SWAPPED = 1 shl 1

  GdkColorspace {.size: sizeof(cint), pure.} = enum
    RGB

  GSList =  ptr GSListObj
  GSListPtr = ptr GSListObj
  GSListObj = object
    data: Gpointer
    next: GSList
    
  GList =  ptr GListObj
  GListPtr = ptr GListObj
  GListObj = object
    data: Gpointer
    next: GList
    prev: GList
    
  TreeIter =  ptr TreeIterObj
  TreeIterPtr = ptr TreeIterObj
  TreeIterObj = object
    stamp: cint
    userData: Gpointer
    userData2: Gpointer
    userData3: Gpointer
    
  INNER_C_UNION_81819396 {.union.} = object
    vInt: cint
    vUint: cuint
    vLong: clong
    vUlong: culong
    vInt64: int64
    vUint64: uint64
    vFloat: cfloat
    vDouble: cdouble
    vPointer: Gpointer
  
  GValue =  ptr GValueObj
  GValuePtr = ptr GValueObj
  GValueObj = object
    gType: GType
    data: array[2, INNER_C_UNION_81819396]
    
  GTypeInstance = pointer
  Adjustment = pointer
  
  GObject = pointer
  GError = pointer
  GClosure = pointer

  GClosureNotify = proc(data: Gpointer; closure: GClosure) {.cdecl.}
  GDestroyNotify = proc (data: Gpointer) {.cdecl.}
  GSourceFunc = proc (userData: Gpointer): Gboolean {.cdecl.}
  
  Requisition =  ptr RequisitionObj
  RequisitionPtr = ptr RequisitionObj
  RequisitionObj = object
    width: cint
    height: cint
    
  EventType {.size: sizeof(cint), pure.} = enum
    NOTHING = - 1, DELETE = 0, DESTROY = 1, EXPOSE = 2,
    MOTION_NOTIFY = 3, BUTTON_PRESS = 4, BUTTON2_PRESS = 5,
    BUTTON3_PRESS = 6,
    BUTTON_RELEASE = 7,
    KEY_PRESS = 8, KEY_RELEASE = 9, ENTER_NOTIFY = 10, LEAVE_NOTIFY = 11,
    FOCUS_CHANGE = 12, CONFIGURE = 13, MAP = 14, UNMAP = 15,
    PROPERTY_NOTIFY = 16, SELECTION_CLEAR = 17, SELECTION_REQUEST = 18,
    SELECTION_NOTIFY = 19, PROXIMITY_IN = 20, PROXIMITY_OUT = 21,
    DRAG_ENTER = 22, DRAG_LEAVE = 23, DRAG_MOTION = 24, DRAG_STATUS = 25,
    DROP_START = 26, DROP_FINISHED = 27, CLIENT_EVENT = 28,
    VISIBILITY_NOTIFY = 29, SCROLL = 31, WINDOW_STATE = 32, SETTING = 33,
    OWNER_CHANGE = 34, GRAB_BROKEN = 35, DAMAGE = 36, TOUCH_BEGIN = 37,
    TOUCH_UPDATE = 38, TOUCH_END = 39, TOUCH_CANCEL = 40,
    TOUCHPAD_SWIPE = 41, TOUCHPAD_PINCH = 42, PAD_BUTTON_PRESS = 43,
    PAD_BUTTON_RELEASE = 44, PAD_RING = 45, PAD_STRIP = 46,
    PAD_GROUP_MODE = 47, EVENT_LAST
  
  StateFlags {.size: sizeof(cint), pure.} = enum
    FLAG_NORMAL = 0, FLAG_ACTIVE = 1 shl 0,
    FLAG_PRELIGHT = 1 shl 1, FLAG_SELECTED = 1 shl 2,
    FLAG_INSENSITIVE = 1 shl 3, FLAG_INCONSISTENT = 1 shl 4,
    FLAG_FOCUSED = 1 shl 5, FLAG_BACKDROP = 1 shl 6,
    FLAG_DIR_LTR = 1 shl 7, FLAG_DIR_RTL = 1 shl 8,
    FLAG_LINK = 1 shl 9, FLAG_VISITED = 1 shl 10,
    FLAG_CHECKED = 1 shl 11, FLAG_DROP_ACTIVE = 1 shl 12
  
  WindowState {.size: sizeof(cint), pure.} = enum
    WITHDRAWN = 1 shl 0, ICONIFIED = 1 shl 1,
    MAXIMIZED = 1 shl 2, STICKY = 1 shl 3,
    FULLSCREEN = 1 shl 4, ABOVE = 1 shl 5,
    BELOW = 1 shl 6, FOCUSED = 1 shl 7,
    TILED = 1 shl 8
    
  SettingAction {.size: sizeof(cint), pure.} = enum
    NEW, CHANGED, DELETED
  
  VisibilityState {.size: sizeof(cint), pure.} = enum
    UNOBSCURED, PARTIAL, FULLY_OBSCURED
  
  ScrollDirection {.size: sizeof(cint), pure.} = enum
    UP, DOWN, LEFT, RIGHT, SMOOTH
    
  CrossingMode {.size: sizeof(cint), pure.} = enum
    NORMAL, GRAB, UNGRAB, GTK_GRAB, GTK_UNGRAB, STATE_CHANGED,
    TOUCH_BEGIN, TOUCH_END, DEVICE_SWITCH
  
  NotifyType {.size: sizeof(cint), pure.} = enum
    ANCESTOR = 0, VIRTUAL = 1, INFERIOR = 2,
    NONLINEAR = 3, NONLINEAR_VIRTUAL = 4, UNKNOWN = 5
    
  OwnerChange {.size: sizeof(cint), pure.} = enum
    NEW_OWNER, DESTROY, CLOSE
    
  Device {.final.} = ptr object
  DragContext {.final.} = ptr object
  EventSequence = ptr object

  RectangleObj = object
    x: cint
    y: cint
    width: cint
    height: cint
    
  Region = object
  
  EventAny =  ptr EventAnyObj
  EventAnyPtr = ptr EventAnyObj
  EventAnyObj = object
    `type`: EventType
    window: Window
    sendEvent: int8

  EventExpose =  ptr EventExposeObj
  EventExposePtr = ptr EventExposeObj
  EventExposeObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    area: RectangleObj
    region: Region
    count: cint

  EventVisibility =  ptr EventVisibilityObj
  EventVisibilityPtr = ptr EventVisibilityObj
  EventVisibilityObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    state: VisibilityState

  EventMotion =  ptr EventMotionObj
  EventMotionPtr = ptr EventMotionObj
  EventMotionObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    x: cdouble
    y: cdouble
    axes: ptr cdouble
    state: cuint
    isHint: int16
    device: Device
    xRoot: cdouble
    yRoot: cdouble

  EventButton =  ptr EventButtonObj
  EventButtonPtr = ptr EventButtonObj
  EventButtonObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    x: cdouble
    y: cdouble
    axes: ptr cdouble
    state: cuint
    button: cuint
    device: Device
    xRoot: cdouble
    yRoot: cdouble

  EventTouch =  ptr EventTouchObj
  EventTouchPtr = ptr EventTouchObj
  EventTouchObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    x: cdouble
    y: cdouble
    axes: ptr cdouble
    state: cuint
    sequence: EventSequence
    emulatingPointer: Gboolean
    device: Device
    xRoot: cdouble
    yRoot: cdouble

  EventScroll =  ptr EventScrollObj
  EventScrollPtr = ptr EventScrollObj
  EventScrollObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    x: cdouble
    y: cdouble
    state: cuint
    direction: ScrollDirection
    device: Device
    xRoot: cdouble
    yRoot: cdouble
    deltaX: cdouble
    deltaY: cdouble
    isStop {.bitsize: 1.}: cuint

  EventKey =  ptr EventKeyObj
  EventKeyPtr = ptr EventKeyObj
  EventKeyObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    state: cuint
    keyval: cuint
    length: cint
    string: cstring
    hardwareKeycode: uint16
    group: uint8
    isModifier {.bitsize: 1.}: cuint

  EventCrossing =  ptr EventCrossingObj
  EventCrossingPtr = ptr EventCrossingObj
  EventCrossingObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    subwindow: Window
    time: uint32
    x: cdouble
    y: cdouble
    xRoot: cdouble
    yRoot: cdouble
    mode: CrossingMode
    detail: NotifyType
    focus: Gboolean
    state: cuint

  EventFocus =  ptr EventFocusObj
  EventFocusPtr = ptr EventFocusObj
  EventFocusObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    `in`: int16

  EventConfigure =  ptr EventConfigureObj
  EventConfigurePtr = ptr EventConfigureObj
  EventConfigureObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    x: cint
    y: cint
    width: cint
    height: cint

  EventProperty =  ptr EventPropertyObj
  EventPropertyPtr = ptr EventPropertyObj
  EventPropertyObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    atom: Atom
    time: uint32
    state: cuint

  EventSelection =  ptr EventSelectionObj
  EventSelectionPtr = ptr EventSelectionObj
  EventSelectionObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    selection: Atom
    target: Atom
    property: Atom
    time: uint32
    requestor: Window

  EventOwnerChange =  ptr EventOwnerChangeObj
  EventOwnerChangePtr = ptr EventOwnerChangeObj
  EventOwnerChangeObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    owner: Window
    reason: OwnerChange
    selection: Atom
    time: uint32
    selectionTime: uint32

  EventProximity =  ptr EventProximityObj
  EventProximityPtr = ptr EventProximityObj
  EventProximityObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    device: Device

  EventSetting =  ptr EventSettingObj
  EventSettingPtr = ptr EventSettingObj
  EventSettingObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    action: SettingAction
    name: cstring

  EventWindowState =  ptr EventWindowStateObj
  EventWindowStatePtr = ptr EventWindowStateObj
  EventWindowStateObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    changedMask: WindowState
    newWindowState: WindowState

  EventGrabBroken =  ptr EventGrabBrokenObj
  EventGrabBrokenPtr = ptr EventGrabBrokenObj
  EventGrabBrokenObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    keyboard: Gboolean
    implicit: Gboolean
    grabWindow: Window

  EventDND =  ptr EventDNDObj
  EventDNDPtr = ptr EventDNDObj
  EventDNDObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    context: DragContext
    time: uint32
    xRoot: cshort
    yRoot: cshort

  EventTouchpadSwipe =  ptr EventTouchpadSwipeObj
  EventTouchpadSwipePtr = ptr EventTouchpadSwipeObj
  EventTouchpadSwipeObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    phase: int8
    nFingers: int8
    time: uint32
    x: cdouble
    y: cdouble
    dx: cdouble
    dy: cdouble
    xRoot: cdouble
    yRoot: cdouble
    state: cuint

  EventTouchpadPinch =  ptr EventTouchpadPinchObj
  EventTouchpadPinchPtr = ptr EventTouchpadPinchObj
  EventTouchpadPinchObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    phase: int8
    nFingers: int8
    time: uint32
    x: cdouble
    y: cdouble
    dx: cdouble
    dy: cdouble
    angleDelta: cdouble
    scale: cdouble
    xRoot: cdouble
    yRoot: cdouble
    state: cuint

  EventPadButton =  ptr EventPadButtonObj
  EventPadButtonPtr = ptr EventPadButtonObj
  EventPadButtonObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    group: cuint
    button: cuint
    mode: cuint

  EventPadAxis =  ptr EventPadAxisObj
  EventPadAxisPtr = ptr EventPadAxisObj
  EventPadAxisObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    group: cuint
    index: cuint
    mode: cuint
    value: cdouble

  EventPadGroupMode =  ptr EventPadGroupModeObj
  EventPadGroupModePtr = ptr EventPadGroupModeObj
  EventPadGroupModeObj = object
    `type`: EventType
    window: Window
    sendEvent: int8
    time: uint32
    group: cuint
    mode: cuint
    
  gdkEvent = Event

  Event =  ptr EventObj
  EventPtr = ptr EventObj
  EventObj {.union.} = object
    `type`: EventType
    any: EventAnyObj
    expose: EventExposeObj
    visibility: EventVisibilityObj
    motion: EventMotionObj
    button: EventButtonObj
    touch: EventTouchObj
    scroll: EventScrollObj
    key: EventKeyObj
    crossing: EventCrossingObj
    focusChange: EventFocusObj
    configure: EventConfigureObj
    property: EventPropertyObj
    selection: EventSelectionObj
    ownerChange: EventOwnerChangeObj
    proximity: EventProximityObj
    dnd: EventDNDObj
    windowState: EventWindowStateObj
    setting: EventSettingObj
    grabBroken: EventGrabBrokenObj
    touchpadSwipe: EventTouchpadSwipeObj
    touchpadPinch: EventTouchpadPinchObj
    padButton: EventPadButtonObj
    padAxis: EventPadAxisObj
    padGroupMode: EventPadGroupModeObj
  
  RGBA =  ptr RGBAObj
  RGBAPtr = ptr RGBAObj
  RGBAObj = object
    red: cdouble
    green: cdouble
    blue: cdouble
    alpha: cdouble
  
  gdkVisual = distinct pointer
  gdkScreen = distinct pointer
  cairoContext = distinct pointer
  
  Operator {.size: sizeof(cint), pure.} = enum
    CLEAR, SOURCE, OVER,
    `IN`, `OUT`, ATOP,
    DEST, DEST_OVER, DEST_IN,
    DEST_OUT, DEST_ATOP, XOR,
    ADD, SATURATE, MULTIPLY,
    SCREEN, OVERLAY, DARKEN,
    LIGHTEN, COLOR_DODGE, COLOR_BURN,
    HARD_LIGHT, SOFT_LIGHT,
    DIFFERENCE, EXCLUSION, HSL_HUE,
    HSL_SATURATION, HSL_COLOR,
    HSL_LUMINOSITY
  
  PopoverConstraint {.size: sizeof(cint), pure.} = enum
    NONE, WINDOW
    
  ClipboardTextReceivedFunc = proc (clipboard: Clipboard; text: cstring;
                                     data: Gpointer) {.cdecl.}
  ClipboardImageReceivedFunc = proc (clipboard: Clipboard;
                                      pixbuf: GdkPixbuf; data: Gpointer) {.cdecl.}
  

const
  G_TYPE_FUNDAMENTAL_SHIFT = 2
  G_TYPE_FUNDAMENTAL_MAX = (255 shl G_TYPE_FUNDAMENTAL_SHIFT)
include gtk3_min_keys


template gTypeMakeFundamental(x: untyped): untyped =
  (GType(x shl G_TYPE_FUNDAMENTAL_SHIFT))

const
  G_TYPE_INVALID = gTypeMakeFundamental(0)
  G_TYPE_NONE = gTypeMakeFundamental(1)
  G_TYPE_INTERF = gTypeMakeFundamental(2)
  G_TYPE_CHAR = gTypeMakeFundamental(3)
  G_TYPE_UCHAR = gTypeMakeFundamental(4)
  G_TYPE_BOOLEAN = gTypeMakeFundamental(5)
  G_TYPE_INT = gTypeMakeFundamental(6)
  G_TYPE_UINT = gTypeMakeFundamental(7)
  G_TYPE_LONG = gTypeMakeFundamental(8)
  G_TYPE_ULONG = gTypeMakeFundamental(9)
  G_TYPE_INT64 = gTypeMakeFundamental(10)
  G_TYPE_UINT64 = gTypeMakeFundamental(11)
  G_TYPE_ENUM = gTypeMakeFundamental(12)
  G_TYPE_FLAG = gTypeMakeFundamental(13)
  G_TYPE_FLOAT = gTypeMakeFundamental(14)
  G_TYPE_DOUBLE = gTypeMakeFundamental(15)
  G_TYPE_STRING = gTypeMakeFundamental(16)
  G_TYPE_POINTER = gTypeMakeFundamental(17)
  G_TYPE_BOXED = gTypeMakeFundamental(18)
  G_TYPE_PARAM = gTypeMakeFundamental(19)
  G_TYPE_OBJECT = gTypeMakeFundamental(20)
  G_TYPE_VARIANT = gTypeMakeFundamental(21)
  
  STYLE_PROVIDER_PRIORITY_FALLBACK = 1
  STYLE_PROVIDER_PRIORITY_THEME = 200
  STYLE_PROVIDER_PRIORITY_SETTINGS = 400
  STYLE_PROVIDER_PRIORITY_APPLICATION = 600
  STYLE_PROVIDER_PRIORITY_USER = 800
  

proc atomIntern(atomName: cstring; onlyIfExists: Gboolean): gdkAtom {.
    importc: "gdk_atom_intern", libgdk.}
proc clipboardGet(selection: gdkAtom): Clipboard {.importc: "gtk_clipboard_get", libgtk.}
proc clear(clipboard: Clipboard) {.importc: "gtk_clipboard_clear", libgtk.}
proc setText(clipboard: Clipboard; text: cstring; len: cint) {.importc: "gtk_clipboard_set_text", libgtk.}
proc setImage(clipboard: Clipboard; pixbuf: GdkPixbuf) {.importc: "gtk_clipboard_set_image", libgtk.}
proc waitForText(clipboard: Clipboard): cstring {.importc: "gtk_clipboard_wait_for_text", libgtk.}
proc waitForImage(clipboard: Clipboard): GdkPixbuf {.importc: "gtk_clipboard_wait_for_image", libgtk.}
proc requestImage(clipboard: Clipboard;
                              callback: ClipboardImageReceivedFunc;
                              userData: Gpointer) {.
    importc: "gtk_clipboard_request_image", libgtk.}
proc requestText(clipboard: Clipboard;
                             callback: ClipboardTextReceivedFunc;
                             userData: Gpointer) {.
    importc: "gtk_clipboard_request_text", libgtk.}

proc timeoutAdd(interval: cuint; function: GSourceFunc; data: Gpointer): cuint {.
    importc: "g_timeout_add", libglib.}
proc sourceRemove(tag: cuint): Gboolean {.importc: "g_source_remove", libglib.}

proc getCurrentEvent(): gdkEvent {.importc: "gtk_get_current_event",
                                       libgtk.}
proc getEventWidget(event: gdkEvent): gtkWidget {.importc: "gtk_get_event_widget", libgtk.}
proc getState(event: gdkEvent; state: var ModifierType): Gboolean {.
    importc: "gdk_event_get_state", libgdk.}

proc rgbaFree(rgba: RGBA) {.importc: "gdk_rgba_free", libgdk.}

proc getScreen(widget: gtkWidget): gdkScreen {.importc: "gtk_widget_get_screen", libgtk.}
proc getRgbaVisual(screen: gdkScreen): gdkVisual {.
    importc: "gdk_screen_get_rgba_visual", libgdk.}
proc setSourceRgba(cr: cairoContext; red: cdouble; green: cdouble; blue: cdouble;
                        alpha: cdouble) {.importc: "cairo_set_source_rgba",
                                        libcairo.}
proc setOperator(cr: cairoContext; op: Operator) {.
    importc: "cairo_set_operator", libcairo.}
proc paint(cr: cairoContext) {.importc: "cairo_paint", libcairo.}
proc setAppPaintable(widget: gtkWidget; appPaintable: Gboolean) {.
    importc: "gtk_widget_set_app_paintable", libgtk.}

template gCallback(f: untyped): untyped = cast[GCallback](f)


proc newWindow(`type`: WindowType): gtkWindow {.importc: "gtk_window_new", libgtk.}
proc newBox(orientation: Orientation; spacing: cint): gtkBox {.importc: "gtk_box_new", libgtk.}
proc newScale(orientation: Orientation; min: cdouble; max: cdouble;
                          step: cdouble): gtkScale {.
    importc: "gtk_scale_new_with_range", libgtk.}
proc newToolItem(): pointer {.importc: "gtk_tool_item_new", libgtk.}
proc newMenuItem(): pointer {.importc: "gtk_menu_item_new", libgtk.}
proc newLabel(str: cstring): gtkLabel {.importc: "gtk_label_new", libgtk.}
proc newCalendar(): gtkCalendar {.importc: "gtk_calendar_new", libgtk.}
proc newButton(): pointer {.importc: "gtk_button_new", libgtk.}
proc newNotebook(): gtkNotebook {.importc: "gtk_notebook_new", libgtk.}
proc newRadioButton(group: GSList): pointer {.importc: "gtk_radio_button_new", libgtk.}
proc newTextView(): gtkTextView {.importc: "gtk_text_view_new", libgtk.}
proc newPopover(relativeTo: gtkWidget): gtkPopOver {.importc: "gtk_popover_new", libgtk.}
proc newComboBox(model: gtkTreeModel): gtkComboBox {.importc: "gtk_combo_box_new_with_model", libgtk.}
proc newListBox(): gtkListBox {.importc: "gtk_list_box_new", libgtk.}
proc newMenuBar(): gtkMenuBar {.importc: "gtk_menu_bar_new", libgtk.}
proc newImage(): gtkImage {.importc: "gtk_image_new", libgtk.}
proc newImage(pixbuf: GdkPixbuf): gtkImage {.
    importc: "gtk_image_new_from_pixbuf", libgtk.}
proc newCheckButton(): gtkCheckButton {.importc: "gtk_check_button_new", libgtk.}
proc newSeparator(orientation: Orientation): pointer {.
    importc: "gtk_separator_new", libgtk.}
proc newSeparatorMenuItem(): pointer {.
    importc: "gtk_separator_menu_item_new", libgtk.}
proc newSeparatorToolItem(): pointer {.
    importc: "gtk_separator_tool_item_new", libgtk.}
proc newMenu(): gtkMenu {.importc: "gtk_menu_new", libgtk.}
proc newTreeView(): gtkTreeView {.importc: "gtk_tree_view_new", libgtk.}

proc newToolbar(): gtkToolbar {.importc: "gtk_toolbar_new", libgtk.}
proc newFileChooserDialog(title: cstring; parent: Window;
                             action: FileChooserAction;
                             firstButtonText: cstring): gtkFileChooser {.varargs,
    importc: "gtk_file_chooser_dialog_new", libgtk.}
proc newCellRendererText(): pointer {.
    importc: "gtk_cell_renderer_text_new", libgtk.}
proc newCellRendererToggle(): pointer {.
    importc: "gtk_cell_renderer_toggle_new", libgtk.}
proc newCellRendererPixbuf(): pointer {.
    importc: "gtk_cell_renderer_pixbuf_new", libgtk.}
proc newMessageDialog(parent: gtkWindow; flags: DialogFlags;
                         `type`: MessageType; buttons: ButtonsType;
                         messageFormat: cstring): pointer {.varargs,
    importc: "gtk_message_dialog_new", libgtk.}
proc newEntry(): gtkEntry {.importc: "gtk_entry_new", libgtk.}
proc newProgressBar(): gtkProgressBar {.importc: "gtk_progress_bar_new",
                                       libgtk.}
proc newEventBox(): gtkEventBox {.importc: "gtk_event_box_new", libgtk.}
proc newScrolledWindow(hadjustment: Adjustment;
                          vadjustment: Adjustment): pointer {.
    importc: "gtk_scrolled_window_new", libgtk.}

proc getBuffer(textView: gtkTextView): gtkTextBuffer {.importc: "gtk_text_view_get_buffer", libgtk.}
proc getBounds(buffer: gtkTextBuffer; start: gtkTextIter;
                            `end`: gtkTextIter) {.
    importc: "gtk_text_buffer_get_bounds", libgtk.}
proc getText(buffer: gtkTextBuffer; start: gtkTextIter;
                          `end`: gtkTextIter; includeHiddenChars: Gboolean): cstring {.
    importc: "gtk_text_buffer_get_text", libgtk.}

proc setSpacing(box: gtkBox; spacing: cint) {.importc: "gtk_box_set_spacing", libgtk.}

proc getStateFlags(widget: gtkWidget): StateFlags {.importc: "gtk_widget_get_state_flags", libgtk.}
proc getParent(widget: gtkWidget): gtkWidget {.importc: "gtk_widget_get_parent", libgtk.}
proc add(container: gtkContainer; widget: gtkWidget) {.importc: "gtk_container_add", libgtk.}
proc remove(container: gtkContainer; widget: gtkWidget) {.importc: "gtk_container_remove", libgtk.}

proc addEvents(widget: gtkWidget; events: cint) {.importc: "gtk_widget_add_events", libgtk.}
proc addButton(dialog: gtkDialog; buttonText: cstring; responseId: cint): gtkButton {.
    importc: "gtk_dialog_add_button", libgtk.}
proc run(dialog: gtkDialog): cint {.importc: "gtk_dialog_run", libgtk.}

proc getModel(treeView: gtkTreeView): gtkTreeModel {.
    importc: "gtk_tree_view_get_model", libgtk.}
proc listStoreNewv(nColumns: cint; types: ptr GType): gtkListStore {.
    importc: "gtk_list_store_newv", libgtk.}
proc treeStoreNewv(nColumns: cint; types: ptr GType): gtkTreeStore {.
    importc: "gtk_tree_store_newv", libgtk.}
proc newTreeViewColumn(): gtkTreeViewColumn {.
    importc: "gtk_tree_view_column_new", libgtk.}
proc packStart(treeColumn: gtkTreeViewColumn;
                                cell: pointer; expand: Gboolean) {.
    importc: "gtk_tree_view_column_pack_start", libgtk.}
proc addAttribute(treeColumn: gtkTreeViewColumn;
                                   cellRenderer: pointer;
                                   attribute: cstring; column: cint) {.
    importc: "gtk_tree_view_column_add_attribute", libgtk.}
proc setTitle(treeColumn: gtkTreeViewColumn; title: cstring) {.
    importc: "gtk_tree_view_column_set_title", libgtk.}
proc append(treeStore: gtkTreeStore; iter: gtkTreeIter;
                        parent: gtkTreeIter) {.
    importc: "gtk_tree_store_append", libgtk.}
proc remove(listStore: gtkListStore; iter: gtkTreeIter): Gboolean {.
    importc: "gtk_list_store_remove", libgtk.}
proc remove(treeStore: gtkTreeStore; iter: gtkTreeIter): Gboolean {.
    importc: "gtk_tree_store_remove", libgtk.}
proc clear(listStore: gtkListStore) {.importc: "gtk_list_store_clear", libgtk.}
proc clear(treeStore: gtkTreeStore) {.importc: "gtk_tree_store_clear", libgtk.}
proc appendColumn(treeView: gtkTreeView;
                             column: gtkTreeViewColumn): cint {.
    importc: "gtk_tree_view_append_column", libgtk.}
proc setModel(treeView: gtkTreeView; model: gtkTreeModel) {.
    importc: "gtk_tree_view_set_model", libgtk.}
proc setHeadersVisible(treeView: gtkTreeView;
                                  headersVisible: Gboolean) {.
    importc: "gtk_tree_view_set_headers_visible", libgtk.}
proc getHeadersVisible(treeView: gtkTreeView): Gboolean {.
    importc: "gtk_tree_view_get_headers_visible", libgtk.}
proc getSelection(treeView: gtkTreeView): gtkTreeSelection {.
    importc: "gtk_tree_view_get_selection", libgtk.}
proc iterNChildren(treeModel: gtkTreeModel; iter: gtkTreeIter): cint {.
    importc: "gtk_tree_model_iter_n_children", libgtk.}
proc setMode(selection: gtkTreeSelection;
                             `type`: SelectionMode) {.
    importc: "gtk_tree_selection_set_mode", libgtk.}
proc getMode(selection: gtkTreeSelection): SelectionMode {.
    importc: "gtk_tree_selection_get_mode", libgtk.}
proc getSelectedRows(selection: gtkTreeSelection;
                                     model: var gtkTreeModel): GList {.
    importc: "gtk_tree_selection_get_selected_rows", libgtk.}
proc getDepth(path: gtkTreePath): cint {.importc: "gtk_tree_path_get_depth", libgtk.}
proc getIndices(path: gtkTreePath): ptr cint {.importc: "gtk_tree_path_get_indices", libgtk.}

proc freeFull(list: GList; freeFunc: GDestroyNotify) {.importc: "g_list_free_full", libglib.}

proc setValue(range: gtkScale; value: cdouble) {.importc: "gtk_range_set_value", libgtk.}
proc getValue(range: gtkScale): cdouble {.importc: "gtk_range_get_value", libgtk.}
proc setIncrements(range: gtkScale; step: cdouble; page: cdouble) {.
    importc: "gtk_range_set_increments", libgtk.}
proc setRange(range: gtkScale; min: cdouble; max: cdouble) {.
    importc: "gtk_range_set_range", libgtk.}
proc getDigits(scale: gtkScale): cint {.importc: "gtk_scale_get_digits", libgtk.}
proc setDigits(scale: gtkScale; digits: cint) {.importc: "gtk_scale_set_digits", libgtk.}

proc getDayIsMarked(calendar: gtkCalendar; day: cuint): Gboolean {.
    importc: "gtk_calendar_get_day_is_marked", libgtk.}
proc markDay(calendar: gtkCalendar; day: cuint) {.importc: "gtk_calendar_mark_day", libgtk.}
proc unmarkDay(calendar: gtkCalendar; day: cuint) {.importc: "gtk_calendar_unmark_day", libgtk.}
proc clearMarks(calendar: gtkCalendar) {.importc: "gtk_calendar_clear_marks", libgtk.}
proc selectDay(calendar: gtkCalendar; day: cuint) {.importc: "gtk_calendar_select_day", libgtk.}
proc selectMonth(calendar: gtkCalendar; month: cuint; year: cuint) {.
    importc: "gtk_calendar_select_month", libgtk.}
proc getDate(calendar: gtkCalendar; year: var cuint; month: var cuint;
                        day: var cuint) {.importc: "gtk_calendar_get_date",
                                       libgtk.}

proc getFilenames(chooser: gtkFileChooser): GSList {.
    importc: "gtk_file_chooser_get_filenames", libgtk.}

proc setFraction(pbar: gtkProgressBar; fraction: cdouble) {.importc: "gtk_progress_bar_set_fraction", libgtk.}
proc getFraction(pbar: gtkProgressBar): cdouble {.importc: "gtk_progress_bar_get_fraction", libgtk.}
                         
proc newListStore(nColumns: cint): pointer {.varargs, importc: "gtk_list_store_new", libgtk.}

proc resize(window: gtkWindow; width: cint; height: cint) {.
    importc: "gtk_window_resize", libgtk.}
proc getPreferredSize(widget: gtkWidget;
                               minimumSize: Requisition;
                               naturalSize: Requisition) {.
    importc: "gtk_widget_get_preferred_size", libgtk.}
proc setSizeRequest(widget: gtkWidget; width: cint; height: cint) {.
    importc: "gtk_widget_set_size_request", libgtk.}
proc getPosition(window: gtkWindow; rootX: var cint; rootY: var cint) {.
    importc: "gtk_window_get_position", libgtk.}
proc getFocus(window: gtkWindow): gtkWidget {.importc: "gtk_window_get_focus", libgtk.}

proc setImage(button: gtkButton; image: gtkImage) {.importc: "gtk_button_set_image", libgtk.}
proc getImage(button: gtkButton): gtkImage {.importc: "gtk_button_get_image", libgtk.}
proc getPixbuf(image: gtkImage): GdkPixbuf {.importc: "gtk_image_get_pixbuf", libgtk.}

proc setFromPixbuf(image: gtkImage; pixbuf: GdkPixbuf) {.
    importc: "gtk_image_set_from_pixbuf", libgtk.}

proc destroy(widget: gtkWidget) {.importc: "gtk_widget_destroy", libgtk.}
proc objectRef(`object`: Gpointer): Gpointer {.importc: "g_object_ref", libgobj.}
proc objectUnref(`object`: Gpointer) {.importc: "g_object_unref", libgobj.}
proc setVisible(widget: gtkWidget; visible: Gboolean) {.
    importc: "gtk_widget_set_visible", libgtk.}
proc getVisible(widget: gtkWidget): Gboolean {.
    importc: "gtk_widget_get_visible", libgtk.}
proc isFocus(widget: gtkWidget): Gboolean {.importc: "gtk_widget_is_focus", libgtk.}
proc grabFocus(widget: gtkWidget) {.importc: "gtk_widget_grab_focus", libgtk.}
proc setCanFocus(widget: gtkWidget; canFocus: Gboolean) {.
    importc: "gtk_widget_set_can_focus", libgtk.}
proc setTooltipText(widget: gtkWidget; text: cstring) {.
    importc: "gtk_widget_set_tooltip_text", libgtk.}
proc getTooltipText(widget: gtkWidget): cstring {.
    importc: "gtk_widget_get_tooltip_text", libgtk.}
proc showAll(widget: gtkWidget) {.importc: "gtk_widget_show_all",
    libgtk.}

proc getSelectionMode(box: gtkListBox): SelectionMode {.
    importc: "gtk_list_box_get_selection_mode", libgtk.}
proc setSelectionMode(box: gtkListBox; mode: SelectionMode) {.
    importc: "gtk_list_box_set_selection_mode", libgtk.}
proc getSelectedRows(box: gtkListBox): GList {.
    importc: "gtk_list_box_get_selected_rows", libgtk.}
proc getChild(bin: gtkListBoxRow): gtkWidget {.importc: "gtk_bin_get_child",
    libgtk.}

proc setTitle(window: gtkWindow; title: cstring) {.
    importc: "gtk_window_set_title", libgtk.}
proc getTitle(window: gtkWindow): cstring {.
    importc: "gtk_window_get_title", libgtk.}
proc setResizable(window: gtkWindow; resizable: Gboolean) {.
    importc: "gtk_window_set_resizable", libgtk.}
proc getResizable(window: gtkWindow): Gboolean {.
    importc: "gtk_window_get_resizable", libgtk.}
proc move(window: gtkWindow; x: cint; y: cint) {.
    importc: "gtk_window_move", libgtk.}
proc getIcon(window: gtkWindow): GdkPixbuf {.
    importc: "gtk_window_get_icon", libgtk.}
proc setIcon(window: gtkWindow; icon: GdkPixbuf) {.
    importc: "gtk_window_set_icon", libgtk.}
proc getDecorated(window: gtkWindow): Gboolean {.
    importc: "gtk_window_get_decorated", libgtk.}
proc setDecorated(window: gtkWindow; setting: Gboolean) {.
    importc: "gtk_window_set_decorated", libgtk.}
proc iconify(window: gtkWindow) {.importc: "gtk_window_iconify",
    libgtk.}
proc deiconify(window: gtkWindow) {.importc: "gtk_window_deiconify",
    libgtk.}
proc maximize(window: gtkWindow) {.importc: "gtk_window_maximize",
    libgtk.}
proc unmaximize(window: gtkWindow) {.importc: "gtk_window_unmaximize",
    libgtk.}
proc isMaximized(window: gtkWindow): Gboolean {.
    importc: "gtk_window_is_maximized", libgtk.}
proc setModal(window: gtkWindow; modal: Gboolean) {.
    importc: "gtk_window_set_modal", libgtk.}
proc getModal(window: gtkWindow): Gboolean {.
    importc: "gtk_window_get_modal", libgtk.}
proc setTransientFor(window: gtkWindow; parent: gtkWindow) {.
    importc: "gtk_window_set_transient_for", libgtk.}
proc getTransientFor(window: gtkWindow): gtkWindow {.
    importc: "gtk_window_get_transient_for", libgtk.}

proc getOrientation(orientable: gtkOrientable): Orientation {.
    importc: "gtk_orientable_get_orientation", libgtk.}
proc setOrientation(orientable: gtkOrientable;
                                 orientation: Orientation) {.
    importc: "gtk_orientable_set_orientation", libgtk.}

proc get(context: gtkStyleContext; state: StateFlags) {.
    varargs, importc: "gtk_style_context_get", libgtk.}

proc getActive(comboBox: gtkComboBox): cint {.
    importc: "gtk_combo_box_get_active", libgtk.}
proc setActive(comboBox: gtkComboBox; index: cint) {.
    importc: "gtk_combo_box_set_active", libgtk.}
proc getModel(comboBox: gtkComboBox): gtkTreeModel {.
    importc: "gtk_combo_box_get_model", libgtk.}

proc append(listStore: gtkListStore; iter: gtkTreeIter) {.
    importc: "gtk_list_store_append", libgtk.}
proc set(listStore: gtkListStore; iter: gtkTreeIter) {.varargs,
    importc: "gtk_list_store_set", libgtk.}
proc set*(treeStore: gtkTreeStore; iter: gtkTreeIter) {.varargs,
    importc: "gtk_tree_store_set", libgtk.}
proc newTreePath(indices: var cint; length: Gsize): gtkTreePath {.
    importc: "gtk_tree_path_new_from_indicesv", libgtk.}
proc newTreePath(firstIndex: cint): gtkTreePath {.varargs,
    importc: "gtk_tree_path_new_from_indices", libgtk.}
proc getIter(treeModel: gtkTreeModel; iter: gtkTreeIter;
                         path: gtkTreePath): Gboolean {.
    importc: "gtk_tree_model_get_iter", libgtk.}
proc getValue(treeModel: gtkTreeModel; iter: gtkTreeIter;
                          column: cint; value: GValue) {.
    importc: "gtk_tree_model_get_value", libgtk.}
proc free(iter: gtkTreeIter) {.importc: "gtk_tree_iter_free",
    libgtk.}
proc free(path: gtkTreePath) {.importc: "gtk_tree_path_free",
    libgtk.}
proc freetp(path: gtkTreePath) = free(path) # Workaround https://github.com/nim-lang/Nim/issues/18886
proc free(list: GList) {.importc: "g_list_free", libglib.}
proc free(list: GSList) {.importc: "g_slist_free", libglib.}
proc free(event: Event) {.importc: "gdk_event_free", libgdk.}
proc free(mem: Gpointer) {.importc: "g_free", libglib.}

proc packStart(cellLayout: gtkCellLayout;
                            cell: pointer; expand: Gboolean) {.
    importc: "gtk_cell_layout_pack_start", libgtk.}
proc addAttribute(cellLayout: gtkCellLayout;
                               cell: pointer; attribute: cstring;
                               column: cint) {.
    importc: "gtk_cell_layout_add_attribute", libgtk.}
                               
proc setSubmenu(menuItem: gtkMenuItem; submenu: gtkMenu) {.
    importc: "gtk_menu_item_set_submenu", libgtk.}
                               
proc setLabel(button: gtkButton; label: cstring) {.importc: "gtk_button_set_label", libgtk.}
proc getLabel(button: gtkButton): cstring {.importc: "gtk_button_get_label", libgtk.}
proc getActive(toggleButton: gtkCheckButton): Gboolean {.
    importc: "gtk_toggle_button_get_active", libgtk.}
proc setActive(toggleButton: gtkCheckButton; isActive: Gboolean) {.
    importc: "gtk_toggle_button_set_active", libgtk.}

proc setRelativeTo(popover: gtkPopover; relativeTo: gtkWidget) {.importc: "gtk_popover_set_relative_to", libgtk.}

proc setConstrainTo(popover: gtkPopover;
                              constraint: PopoverConstraint) {.
    importc: "gtk_popover_set_constrain_to", libgtk.}

proc joinGroup(radioButton: gtkRadioButton;
                             groupSource: gtkRadioButton) {.
    importc: "gtk_radio_button_join_group", libgtk.}

proc setText(label: gtkLabel; str: cstring) {.
    importc: "gtk_label_set_text", libgtk.}
proc getText(label: gtkLabel): cstring {.importc: "gtk_label_get_text",
    libgtk.}
proc setLineWrap(label: gtkLabel; wrap: Gboolean) {.
    importc: "gtk_label_set_line_wrap", libgtk.}
proc getLineWrap(label: gtkLabel): Gboolean {.
    importc: "gtk_label_get_line_wrap", libgtk.}
proc setXalign(label: gtkLabel; xalign: cfloat) {.
    importc: "gtk_label_set_xalign", libgtk.}
proc getXalign(label: gtkLabel): cfloat {.
    importc: "gtk_label_get_xalign", libgtk.}
proc setYalign(label: gtkLabel; yalign: cfloat) {.
    importc: "gtk_label_set_yalign", libgtk.}
proc getYalign(label: gtkLabel): cfloat {.
    importc: "gtk_label_get_yalign", libgtk.}

proc appendPage(notebook: gtkNotebook; child: gtkWidget;
                           tabLabel: gtkWidget): cint {.
    importc: "gtk_notebook_append_page", libgtk.}
proc setTabReorderable(notebook: gtkNotebook; child: gtkWidget;
                                  reorderable: Gboolean) {.
    importc: "gtk_notebook_set_tab_reorderable", libgtk.}
proc getTabReorderable(notebook: gtkNotebook; child: gtkWidget): Gboolean {.
    importc: "gtk_notebook_get_tab_reorderable", libgtk.}
proc getTabPos(notebook: gtkNotebook): PositionType {.
    importc: "gtk_notebook_get_tab_pos", libgtk.}
proc setTabPos(notebook: gtkNotebook; pos: PositionType) {.
    importc: "gtk_notebook_set_tab_pos", libgtk.}
proc getCurrentPage(notebook: gtkNotebook): cint {.
    importc: "gtk_notebook_get_current_page", libgtk.}
proc setCurrentPage(notebook: gtkNotebook; pageNum: cint) {.
    importc: "gtk_notebook_set_current_page", libgtk.}

proc getText(entry: gtkEntry): cstring {.importc: "gtk_entry_get_text",
    libgtk.}
proc setText(entry: gtkEntry; text: cstring) {.
    importc: "gtk_entry_set_text", libgtk.}

proc setVisual(widget: gtkWidget; visual: gdkVisual) {.
    importc: "gtk_widget_set_visual", libgtk.}

proc setDrawValue(scale: gtkScale; drawValue: Gboolean) {.
    importc: "gtk_scale_set_draw_value", libgtk.}

proc getProperty(context: gtkStyleContext; property: cstring;
                                state: StateFlags; value: GValue) {.
    importc: "gtk_style_context_get_property", libgtk.}
proc getStyleContext(widget: gtkWidget): gtkStyleContext {.importc: "gtk_widget_get_style_context", libgtk.}

proc newCssProvider(): pointer {.importc: "gtk_css_provider_new", libgtk.}
proc loadFromData(cssProvider: pointer; data: cstring;
                                length: Gssize; error: var GError): Gboolean {.
    importc: "gtk_css_provider_load_from_data", libgtk.}
proc addProvider(context: gtkStyleContext;
                                provider: pointer; priority: cuint) {.
    importc: "gtk_style_context_add_provider", libgtk.}

proc setVexpand(widget: gtkWidget; expand: Gboolean) {.importc: "gtk_widget_set_vexpand", libgtk.}
proc setHexpand(widget: gtkWidget; expand: Gboolean) {.importc: "gtk_widget_set_hexpand", libgtk.}

proc setText(buffer: gtkTextBuffer; text: cstring; len: cint) {.
    importc: "gtk_text_buffer_set_text", libgtk.}

proc show(widget: gtkWidget) {.importc: "gtk_widget_show", libgtk.}
proc getOpacity(widget: gtkWidget): cdouble {.importc: "gtk_widget_get_opacity", libgtk.}
proc setOpacity(widget: gtkWidget; opacity: cdouble) {.importc: "gtk_widget_set_opacity", libgtk.}

proc checkInstanceIsA(instance: GTypeInstance; ifaceType: GType): Gboolean {.
    importc: "g_type_check_instance_is_a", libgobj.}

template gTypeCit(ip, gt: untyped): untyped =
  (checkInstanceIsA(cast[GTypeInstance](ip), cast[GType](gt)))

template gTypeCheckInstanceType(instance, gType: untyped): untyped =
  (gTypeCit(instance, gType))
  
proc scrolledWindowGetType(): GType {.importc: "gtk_scrolled_window_get_type",
                                       libgtk.}
proc fileChooserGetType(): GType {.importc: "gtk_file_chooser_get_type",
                                    libgtk.}
proc scrollableGetType(): GType {.importc: "gtk_scrollable_get_type", libgtk.}
proc pixbufGetType(): GType {.importc: "gdk_pixbuf_get_type", libpixbuf.}

proc checkValueHolds(value: GValue; `type`: GType): Gboolean {.
    importc: "g_type_check_value_holds", libgobj.}
template gValueType(value: untyped): untyped = ((cast[GValue](value)).gType)
proc init(value: var GValueObj; gType: GType): GValue {.importc: "g_value_init",
    libgobj.}
proc unset(value: GValue) {.importc: "g_value_unset", libgobj.}
proc setProperty(`object`: GObject; propertyName: cstring;
                        value: GValue) {.importc: "g_object_set_property",
    libgobj.}
proc getProperty(`object`: GObject; propertyName: cstring;
  value: GValue) {.importc: "g_object_get_property",libgobj.}
proc getString(value: GValue): cstring {.importc: "g_value_get_string",
    libgobj.}
proc setString(value: var GValueObj; vString: cstring) {.
    importc: "g_value_set_string", libgobj.}
proc setBoolean(value: var GValueObj; vBoolean: Gboolean) {.
    importc: "g_value_set_boolean", libgobj.}
proc getBoolean(value: GValue): Gboolean {.importc: "g_value_get_boolean",
    libgobj.}
proc setInt(value: var GValueObj; vInt: cint) {.importc: "g_value_set_int",
    libgobj.}
proc getInt(value: GValue): cint {.importc: "g_value_get_int", libgobj.}
proc getPointer(value: GValue): Gpointer {.importc: "g_value_get_pointer",
    libgobj.}

proc signalConnectData(instance: Gpointer; detailedSignal: cstring;
                        cHandler: GCallback; data: Gpointer;
                        destroyData: GClosureNotify; connectFlags: GConnectFlags): culong {.
    importc: "g_signal_connect_data", libgobj.}

template gSignalConnect(instance, detailedSignal, cHandler, data: untyped): untyped =
  signalConnectData(instance, detailedSignal, cHandler, data, nil,
                     cast[GConnectFlags](0))

proc getPixels(pixbuf: GdkPixbuf): ptr char {.importc: "gdk_pixbuf_get_pixels", libpixbuf.}
proc newPixbuf(colorspace: GdkColorspace; hasAlpha: Gboolean;
                  bitsPerSample: cint; width: cint; height: cint): GdkPixbuf {.
    importc: "gdk_pixbuf_new", libpixbuf.}
proc getWidth(pixbuf: GdkPixbuf): cint {.importc: "gdk_pixbuf_get_width", libpixbuf.}
proc getHeight(pixbuf: GdkPixbuf): cint {.importc: "gdk_pixbuf_get_height", libpixbuf.}
proc getNChannels(pixbuf: GdkPixbuf): cint {.importc: "gdk_pixbuf_get_n_channels", libpixbuf.}
proc addAlpha(pixbuf: GdkPixbuf; substituteColor: Gboolean; r: char;
                       g: char; b: char): GdkPixbuf {.
    importc: "gdk_pixbuf_add_alpha", libpixbuf.}

proc gtkMain() {.importc: "gtk_main", libgtk.}
proc gtkMainQuit() {.importc: "gtk_main_quit", libgtk.}

proc init(argc: var cint; argv: var cstringArray) {.importc: "gtk_init", libgtk.}

proc initWithArgv() =
  var
    cmdLine{.importc.}: cstringArray
    cmdCount{.importc.}: cint
  init(cmdCount, cmdLine)