  {.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk

from glib import Gboolean

from cairo import Surface, Region

from gobject import GType

from gio import GOutputStream

type # broadway dummy objects
  BroadwayBuffer* = object
  BroadwayServer* = object
  BroadwayOutput* = object

type
  BroadwayDisplay* =  ptr BroadwayDisplayObj
  BroadwayDisplayPtr* = ptr BroadwayDisplayObj
  BroadwayDisplayObj* = DisplayObj

template typeBroadwayDisplay*(): untyped =
  (broadwayDisplayGetType())

template broadwayDisplay*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeBroadwayDisplay, BroadwayDisplayObj))

template broadwayDisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeBroadwayDisplay, BroadwayDisplayClass))

template isBroadwayDisplay*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeBroadwayDisplay))

template isBroadwayDisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeBroadwayDisplay))

template broadwayDisplayGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeBroadwayDisplay, BroadwayDisplayClass))

proc broadwayDisplayGetType*(): GType {.importc: "gdk_broadway_display_get_type",
                                        libgdk.}
proc showKeyboard*(display: BroadwayDisplay) {.
    importc: "gdk_broadway_display_show_keyboard", libgdk.}
proc hideKeyboard*(display: BroadwayDisplay) {.
    importc: "gdk_broadway_display_hide_keyboard", libgdk.}

template typeBroadwayWindow*(): untyped =
  (broadwayWindowGetType())

template broadwayWindow*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeBroadwayWindow, BroadwayWindowObj))

template broadwayWindowClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeBroadwayWindow, BroadwayWindowClass))

template isBroadwayWindow*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeBroadwayWindow))

template isBroadwayWindowClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeBroadwayWindow))

template broadwayWindowGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeBroadwayWindow, BroadwayWindowClass))

type
  BroadwayWindow* =  ptr BroadwayWindowObj
  BroadwayWindowPtr* = ptr BroadwayWindowObj
  BroadwayWindowObj* = WindowObj

proc broadwayWindowGetType*(): GType {.importc: "gdk_broadway_window_get_type",
                                       libgdk.}
proc broadwayGetLastSeenTime*(window: Window): uint32 {.
    importc: "gdk_broadway_get_last_seen_time", libgdk.}

template typeBroadwayCursor*(): untyped =
  (broadwayCursorGetType())

template broadwayCursor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeBroadwayCursor, BroadwayCursorObj))

template broadwayCursorClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeBroadwayCursor, BroadwayCursorClass))

template isBroadwayCursor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeBroadwayCursor))

template isBroadwayCursorClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeBroadwayCursor))

template broadwayCursorGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeBroadwayCursor, BroadwayCursorClass))

type
  BroadwayCursor* =  ptr BroadwayCursorObj
  BroadwayCursorPtr* = ptr BroadwayCursorObj
  BroadwayCursorObj* = CursorObj

proc broadwayCursorGetType*(): GType {.importc: "gdk_broadway_cursor_get_type",
                                       libgdk.}

template typeBroadwayMonitor*(): untyped =
  (broadwayMonitorGetType())

template broadwayMonitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeBroadwayMonitor, BroadwayMonitor))

template isBroadwayMonitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeBroadwayMonitor))

proc broadwayMonitorGetType*(): GType {.importc: "gdk_broadway_monitor_get_type",
                                        libgdk.}

template typeBroadwayVisual*(): untyped =
  (broadwayVisualGetType())

template broadwayVisual*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeBroadwayVisual, BroadwayVisualObj))

template broadwayVisualClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeBroadwayVisual, BroadwayVisualClass))

template isBroadwayVisual*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeBroadwayVisual))

template isBroadwayVisualClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeBroadwayVisual))

template broadwayVisualGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeBroadwayVisual, BroadwayVisualClass))

type
  BroadwayVisual* =  ptr BroadwayVisualObj
  BroadwayVisualPtr* = ptr BroadwayVisualObj
  BroadwayVisualObj* = VisualObj

proc broadwayVisualGetType*(): GType {.importc: "gdk_broadway_visual_get_type",
                                       libgdk.}

proc broadwayBufferCreate*(width: cint; height: cint; data: var uint8; stride: cint): ptr BroadwayBuffer {.
    importc: "broadway_buffer_create", libgdk.}
proc destroy*(buffer: ptr BroadwayBuffer) {.
    importc: "broadway_buffer_destroy", libgdk.}
proc encode*(buffer: ptr BroadwayBuffer; prev: ptr BroadwayBuffer;
                          dest: glib.GString) {.importc: "broadway_buffer_encode",
    libgdk.}
proc getWidth*(buffer: ptr BroadwayBuffer): cint {.
    importc: "broadway_buffer_get_width", libgdk.}
proc width*(buffer: ptr BroadwayBuffer): cint {.
    importc: "broadway_buffer_get_width", libgdk.}
proc getHeight*(buffer: ptr BroadwayBuffer): cint {.
    importc: "broadway_buffer_get_height", libgdk.}
proc height*(buffer: ptr BroadwayBuffer): cint {.
    importc: "broadway_buffer_get_height", libgdk.}

type
  BroadwayRect* =  ptr BroadwayRectObj
  BroadwayRectPtr* = ptr BroadwayRectObj
  BroadwayRectObj* = object
    x*: int32
    y*: int32
    width*: int32
    height*: int32

  BroadwayEventType* {.size: sizeof(cint), pure.} = enum
    BUTTON_RELEASE = 'B',
    KEY_RELEASE = 'K',
    DELETE_NOTIFY = 'W',
    BUTTON_PRESS = 'b',
    SCREEN_SIZE_CHANGED = 'd',
    ENTER = 'e',
    FOCUS = 'f'
    GRAB_NOTIFY = 'g',
    KEY_PRESS = 'k',
    LEAVE = 'l',
    POINTER_MOVE = 'm',
    SCROLL = 's',
    TOUCH = 't',
    UNGRAB_NOTIFY = 'u',
    CONFIGURE_NOTIFY = 'w',
  BroadwayOpType* {.size: sizeof(cint), pure.} = enum
    DISCONNECTED = 'D',
    HIDE_SURFACE = 'H',
    AUTH_OK = 'L',
    LOWER_SURFACE = 'R',
    SHOW_SURFACE = 'S',
    PUT_BUFFER = 'b',
    DESTROY_SURFACE = 'd',
    GRAB_POINTER = 'g',
    PUT_RGB = 'i',
    SET_SHOW_KEYBOARD = 'k'
    REQUEST_AUTH = 'l',
    MOVE_RESIZE = 'm',
    SET_TRANSIENT_FOR = 'p',
    RAISE_SURFACE = 'r',
    NEW_SURFACE = 's',
    UNGRAB_POINTER = 'u',
  BroadwayInputBaseMsg* =  ptr BroadwayInputBaseMsgObj
  BroadwayInputBaseMsgPtr* = ptr BroadwayInputBaseMsgObj
  BroadwayInputBaseMsgObj{.inheritable, pure.} = object
    `type`*: uint32
    serial*: uint32
    time*: uint64

  BroadwayInputPointerMsg* =  ptr BroadwayInputPointerMsgObj
  BroadwayInputPointerMsgPtr* = ptr BroadwayInputPointerMsgObj
  BroadwayInputPointerMsgObj*{.final.} = object of BroadwayInputBaseMsgObj
    mouseWindowId*: uint32
    eventWindowId*: uint32
    rootX*: int32
    rootY*: int32
    winX*: int32
    winY*: int32
    state*: uint32

  BroadwayInputCrossingMsg* =  ptr BroadwayInputCrossingMsgObj
  BroadwayInputCrossingMsgPtr* = ptr BroadwayInputCrossingMsgObj
  BroadwayInputCrossingMsgObj* = object
    pointer*: BroadwayInputPointerMsgObj
    mode*: uint32

  BroadwayInputButtonMsg* =  ptr BroadwayInputButtonMsgObj
  BroadwayInputButtonMsgPtr* = ptr BroadwayInputButtonMsgObj
  BroadwayInputButtonMsgObj* = object
    pointer*: BroadwayInputPointerMsgObj
    button*: uint32

  BroadwayInputScrollMsg* =  ptr BroadwayInputScrollMsgObj
  BroadwayInputScrollMsgPtr* = ptr BroadwayInputScrollMsgObj
  BroadwayInputScrollMsgObj* = object
    pointer*: BroadwayInputPointerMsgObj
    dir*: int32

  BroadwayInputTouchMsg* =  ptr BroadwayInputTouchMsgObj
  BroadwayInputTouchMsgPtr* = ptr BroadwayInputTouchMsgObj
  BroadwayInputTouchMsgObj*{.final.} = object of BroadwayInputBaseMsgObj
    touchType*: uint32
    eventWindowId*: uint32
    sequenceId*: uint32
    isEmulated*: uint32
    rootX*: int32
    rootY*: int32
    winX*: int32
    winY*: int32
    state*: uint32

  BroadwayInputKeyMsg* =  ptr BroadwayInputKeyMsgObj
  BroadwayInputKeyMsgPtr* = ptr BroadwayInputKeyMsgObj
  BroadwayInputKeyMsgObj*{.final.} = object of BroadwayInputBaseMsgObj
    windowId*: uint32
    state*: uint32
    key*: int32

  BroadwayInputGrabReply* =  ptr BroadwayInputGrabReplyObj
  BroadwayInputGrabReplyPtr* = ptr BroadwayInputGrabReplyObj
  BroadwayInputGrabReplyObj*{.final.} = object of BroadwayInputBaseMsgObj
    res*: int32

  BroadwayInputConfigureNotify* =  ptr BroadwayInputConfigureNotifyObj
  BroadwayInputConfigureNotifyPtr* = ptr BroadwayInputConfigureNotifyObj
  BroadwayInputConfigureNotifyObj*{.final.} = object of BroadwayInputBaseMsgObj
    id*: int32
    x*: int32
    y*: int32
    width*: int32
    height*: int32

  BroadwayInputScreenResizeNotify* =  ptr BroadwayInputScreenResizeNotifyObj
  BroadwayInputScreenResizeNotifyPtr* = ptr BroadwayInputScreenResizeNotifyObj
  BroadwayInputScreenResizeNotifyObj*{.final.} = object of BroadwayInputBaseMsgObj
    width*: uint32
    height*: uint32

  BroadwayInputDeleteNotify* =  ptr BroadwayInputDeleteNotifyObj
  BroadwayInputDeleteNotifyPtr* = ptr BroadwayInputDeleteNotifyObj
  BroadwayInputDeleteNotifyObj*{.final.} = object of BroadwayInputBaseMsgObj
    id*: int32

  BroadwayInputFocusMsg* =  ptr BroadwayInputFocusMsgObj
  BroadwayInputFocusMsgPtr* = ptr BroadwayInputFocusMsgObj
  BroadwayInputFocusMsgObj*{.final.} = object of BroadwayInputBaseMsgObj
    newId*: int32
    oldId*: int32

  BroadwayInputMsg* =  ptr BroadwayInputMsgObj
  BroadwayInputMsgPtr* = ptr BroadwayInputMsgObj
  BroadwayInputMsgObj* {.union.} = object
    base*: BroadwayInputBaseMsgObj
    pointer*: BroadwayInputPointerMsgObj
    crossing*: BroadwayInputCrossingMsgObj
    button*: BroadwayInputButtonMsgObj
    scroll*: BroadwayInputScrollMsgObj
    touch*: BroadwayInputTouchMsgObj
    key*: BroadwayInputKeyMsgObj
    grabReply*: BroadwayInputGrabReplyObj
    configureNotify*: BroadwayInputConfigureNotifyObj
    deleteNotify*: BroadwayInputDeleteNotifyObj
    screenResizeNotify*: BroadwayInputScreenResizeNotifyObj
    focus*: BroadwayInputFocusMsgObj

  BroadwayRequestType* {.size: sizeof(cint), pure.} = enum
    NEW_WINDOW, FLUSH, SYNC,
    QUERY_MOUSE, DESTROY_WINDOW,
    SHOW_WINDOW, HIDE_WINDOW,
    SET_TRANSIENT_FOR, UPDATE,
    MOVE_RESIZE, GRAB_POINTER,
    UNGRAB_POINTER, FOCUS_WINDOW,
    SET_SHOW_KEYBOARD
  BroadwayRequestBase* =  ptr BroadwayRequestBaseObj
  BroadwayRequestBasePtr* = ptr BroadwayRequestBaseObj
  BroadwayRequestBaseObj{.inheritable, pure.} = object
    size*: uint32
    serial*: uint32
    `type`*: uint32

  BroadwayRequestFlush* =  ptr BroadwayRequestFlushObj
  BroadwayRequestFlushPtr* = ptr BroadwayRequestFlushObj
  BroadwayRequestFlushObj* = BroadwayRequestBaseObj
  BroadwayRequestSync* =  ptr BroadwayRequestSyncObj
  BroadwayRequestSyncPtr* = ptr BroadwayRequestSyncObj
  BroadwayRequestSyncObj* = BroadwayRequestBaseObj
  BroadwayRequestQueryMouse* =  ptr BroadwayRequestQueryMouseObj
  BroadwayRequestQueryMousePtr* = ptr BroadwayRequestQueryMouseObj
  BroadwayRequestQueryMouseObj* = BroadwayRequestBaseObj
  BroadwayRequestDestroyWindow* =  ptr BroadwayRequestDestroyWindowObj
  BroadwayRequestDestroyWindowPtr* = ptr BroadwayRequestDestroyWindowObj
  BroadwayRequestDestroyWindowObj*{.final.} = object of BroadwayRequestBaseObj
    id*: uint32

  BroadwayRequestShowWindow* =  ptr BroadwayRequestShowWindowObj
  BroadwayRequestShowWindowPtr* = ptr BroadwayRequestShowWindowObj
  BroadwayRequestShowWindowObj* = BroadwayRequestDestroyWindowObj
  BroadwayRequestHideWindow* =  ptr BroadwayRequestHideWindowObj
  BroadwayRequestHideWindowPtr* = ptr BroadwayRequestHideWindowObj
  BroadwayRequestHideWindowObj* = BroadwayRequestDestroyWindowObj
  BroadwayRequestFocusWindow* =  ptr BroadwayRequestFocusWindowObj
  BroadwayRequestFocusWindowPtr* = ptr BroadwayRequestFocusWindowObj
  BroadwayRequestFocusWindowObj* = BroadwayRequestDestroyWindowObj
  BroadwayRequestSetTransientFor* =  ptr BroadwayRequestSetTransientForObj
  BroadwayRequestSetTransientForPtr* = ptr BroadwayRequestSetTransientForObj
  BroadwayRequestSetTransientForObj*{.final.} = object of BroadwayRequestBaseObj
    id*: uint32
    parent*: uint32

  BroadwayRequestTranslate* =  ptr BroadwayRequestTranslateObj
  BroadwayRequestTranslatePtr* = ptr BroadwayRequestTranslateObj
  BroadwayRequestTranslateObj*{.final.} = object of BroadwayRequestBaseObj
    id*: uint32
    dx*: int32
    dy*: int32
    nRects*: uint32
    rects*: array[1, BroadwayRectObj]

  BroadwayRequestUpdate* =  ptr BroadwayRequestUpdateObj
  BroadwayRequestUpdatePtr* = ptr BroadwayRequestUpdateObj
  BroadwayRequestUpdateObj*{.final.} = object of BroadwayRequestBaseObj
    id*: uint32
    name*: array[36, char]
    width*: uint32
    height*: uint32

  BroadwayRequestGrabPointer* =  ptr BroadwayRequestGrabPointerObj
  BroadwayRequestGrabPointerPtr* = ptr BroadwayRequestGrabPointerObj
  BroadwayRequestGrabPointerObj*{.final.} = object of BroadwayRequestBaseObj
    id*: uint32
    ownerEvents*: uint32
    eventMask*: uint32
    time*: uint32

  BroadwayRequestUngrabPointer* =  ptr BroadwayRequestUngrabPointerObj
  BroadwayRequestUngrabPointerPtr* = ptr BroadwayRequestUngrabPointerObj
  BroadwayRequestUngrabPointerObj*{.final.} = object of BroadwayRequestBaseObj
    time*: uint32

  BroadwayRequestNewWindow* =  ptr BroadwayRequestNewWindowObj
  BroadwayRequestNewWindowPtr* = ptr BroadwayRequestNewWindowObj
  BroadwayRequestNewWindowObj*{.final.} = object of BroadwayRequestBaseObj
    x*: int32
    y*: int32
    width*: uint32
    height*: uint32
    isTemp*: uint32

  BroadwayRequestMoveResize* =  ptr BroadwayRequestMoveResizeObj
  BroadwayRequestMoveResizePtr* = ptr BroadwayRequestMoveResizeObj
  BroadwayRequestMoveResizeObj*{.final.} = object of BroadwayRequestBaseObj
    id*: uint32
    withMove*: uint32
    x*: int32
    y*: int32
    width*: uint32
    height*: uint32

  BroadwayRequestSetShowKeyboard* =  ptr BroadwayRequestSetShowKeyboardObj
  BroadwayRequestSetShowKeyboardPtr* = ptr BroadwayRequestSetShowKeyboardObj
  BroadwayRequestSetShowKeyboardObj*{.final.} = object of BroadwayRequestBaseObj
    showKeyboard*: uint32

  BroadwayRequest* =  ptr BroadwayRequestObj
  BroadwayRequestPtr* = ptr BroadwayRequestObj
  BroadwayRequestObj* {.union.} = object
    base*: BroadwayRequestBaseObj
    newWindow*: BroadwayRequestNewWindowObj
    flush*: BroadwayRequestFlushObj
    sync*: BroadwayRequestSyncObj
    queryMouse*: BroadwayRequestQueryMouseObj
    destroyWindow*: BroadwayRequestDestroyWindowObj
    showWindow*: BroadwayRequestShowWindowObj
    hideWindow*: BroadwayRequestHideWindowObj
    setTransientFor*: BroadwayRequestSetTransientForObj
    update*: BroadwayRequestUpdateObj
    moveResize*: BroadwayRequestMoveResizeObj
    grabPointer*: BroadwayRequestGrabPointerObj
    ungrabPointer*: BroadwayRequestUngrabPointerObj
    translate*: BroadwayRequestTranslateObj
    focusWindow*: BroadwayRequestFocusWindowObj
    setShowKeyboard*: BroadwayRequestSetShowKeyboardObj

  BroadwayReplyType* {.size: sizeof(cint), pure.} = enum
    EVENT, SYNC, QUERY_MOUSE,
    NEW_WINDOW, GRAB_POINTER,
    UNGRAB_POINTER
  BroadwayReplyBase* =  ptr BroadwayReplyBaseObj
  BroadwayReplyBasePtr* = ptr BroadwayReplyBaseObj
  BroadwayReplyBaseObj{.inheritable, pure.} = object
    size*: uint32
    inReplyTo*: uint32
    `type`*: uint32

  BroadwayReplySync* =  ptr BroadwayReplySyncObj
  BroadwayReplySyncPtr* = ptr BroadwayReplySyncObj
  BroadwayReplySyncObj* = BroadwayReplyBaseObj
  BroadwayReplyNewWindow* =  ptr BroadwayReplyNewWindowObj
  BroadwayReplyNewWindowPtr* = ptr BroadwayReplyNewWindowObj
  BroadwayReplyNewWindowObj*{.final.} = object of BroadwayReplyBaseObj
    id*: uint32

  BroadwayReplyGrabPointer* =  ptr BroadwayReplyGrabPointerObj
  BroadwayReplyGrabPointerPtr* = ptr BroadwayReplyGrabPointerObj
  BroadwayReplyGrabPointerObj*{.final.} = object of BroadwayReplyBaseObj
    status*: uint32

  BroadwayReplyUngrabPointer* =  ptr BroadwayReplyUngrabPointerObj
  BroadwayReplyUngrabPointerPtr* = ptr BroadwayReplyUngrabPointerObj
  BroadwayReplyUngrabPointerObj* = BroadwayReplyGrabPointerObj
  BroadwayReplyQueryMouse* =  ptr BroadwayReplyQueryMouseObj
  BroadwayReplyQueryMousePtr* = ptr BroadwayReplyQueryMouseObj
  BroadwayReplyQueryMouseObj*{.final.} = object of BroadwayReplyBaseObj
    toplevel*: uint32
    rootX*: int32
    rootY*: int32
    mask*: uint32

  BroadwayReplyEvent* =  ptr BroadwayReplyEventObj
  BroadwayReplyEventPtr* = ptr BroadwayReplyEventObj
  BroadwayReplyEventObj*{.final.} = object of BroadwayReplyBaseObj
    msg*: BroadwayInputMsgObj

  BroadwayReply* =  ptr BroadwayReplyObj
  BroadwayReplyPtr* = ptr BroadwayReplyObj
  BroadwayReplyObj* {.union.} = object
    base*: BroadwayReplyBaseObj
    event*: BroadwayReplyEventObj
    queryMouse*: BroadwayReplyQueryMouseObj
    newWindow*: BroadwayReplyNewWindowObj
    grabPointer*: BroadwayReplyGrabPointerObj
    ungrabPointer*: BroadwayReplyUngrabPointerObj

type
  BroadwayWSOpCode* {.size: sizeof(cint), pure.} = enum
    CONTINUATION = 0, TEXT = 1, BINARY = 2,
    CNX_CLOSE = 8, CNX_PING = 9,
    CNX_PONG = 0xA

proc newBroadwayOutput*(`out`: gio.GOutputStream; serial: uint32): ptr BroadwayOutput {.
    importc: "broadway_output_new", libgdk.}
proc free*(output: ptr BroadwayOutput) {.
    importc: "broadway_output_free", libgdk.}
proc flush*(output: ptr BroadwayOutput): cint {.
    importc: "broadway_output_flush", libgdk.}
proc hasError*(output: ptr BroadwayOutput): cint {.
    importc: "broadway_output_has_error", libgdk.}
proc setNextSerial*(output: ptr BroadwayOutput; serial: uint32) {.
    importc: "broadway_output_set_next_serial", libgdk.}
proc `nextSerial=`*(output: ptr BroadwayOutput; serial: uint32) {.
    importc: "broadway_output_set_next_serial", libgdk.}
proc getNextSerial*(output: ptr BroadwayOutput): uint32 {.
    importc: "broadway_output_get_next_serial", libgdk.}
proc nextSerial*(output: ptr BroadwayOutput): uint32 {.
    importc: "broadway_output_get_next_serial", libgdk.}
proc newSurface*(output: ptr BroadwayOutput; id: cint; x: cint; y: cint;
                              w: cint; h: cint; isTemp: Gboolean) {.
    importc: "broadway_output_new_surface", libgdk.}
proc disconnected*(output: ptr BroadwayOutput) {.
    importc: "broadway_output_disconnected", libgdk.}
proc showSurface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_show_surface", libgdk.}
proc hideSurface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_hide_surface", libgdk.}
proc raiseSurface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_raise_surface", libgdk.}
proc lowerSurface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_lower_surface", libgdk.}
proc destroySurface*(output: ptr BroadwayOutput; id: cint) {.
    importc: "broadway_output_destroy_surface", libgdk.}
proc moveResizeSurface*(output: ptr BroadwayOutput; id: cint;
                                     hasPos: Gboolean; x: cint; y: cint;
                                     hasSize: Gboolean; w: cint; h: cint) {.
    importc: "broadway_output_move_resize_surface", libgdk.}
proc setTransientFor*(output: ptr BroadwayOutput; id: cint;
                                   parentId: cint) {.
    importc: "broadway_output_set_transient_for", libgdk.}
proc `transientFor=`*(output: ptr BroadwayOutput; id: cint;
                                   parentId: cint) {.
    importc: "broadway_output_set_transient_for", libgdk.}
proc putBuffer*(output: ptr BroadwayOutput; id: cint;
                             prevBuffer: ptr BroadwayBuffer;
                             buffer: ptr BroadwayBuffer) {.
    importc: "broadway_output_put_buffer", libgdk.}
proc grabPointer*(output: ptr BroadwayOutput; id: cint;
                               ownerEvent: Gboolean) {.
    importc: "broadway_output_grab_pointer", libgdk.}
proc ungrabPointer*(output: ptr BroadwayOutput): uint32 {.
    importc: "broadway_output_ungrab_pointer", libgdk.}
proc pong*(output: ptr BroadwayOutput) {.
    importc: "broadway_output_pong", libgdk.}
proc setShowKeyboard*(output: ptr BroadwayOutput; show: Gboolean) {.
    importc: "broadway_output_set_show_keyboard", libgdk.}
proc `showKeyboard=`*(output: ptr BroadwayOutput; show: Gboolean) {.
    importc: "broadway_output_set_show_keyboard", libgdk.}

proc broadwayEventsGotInput*(message: BroadwayInputMsg; clientId: int32) {.
    importc: "broadway_events_got_input", libgdk.}
template broadway_Type_Server*(): untyped =
  (broadwayServerGetType())

template broadway_Server*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, broadway_Type_Server, broadwayServer))

template broadway_Server_Class*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, broadway_Type_Server, broadwayServerClass))

template broadway_Is_Server*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, broadway_Type_Server))

template broadway_Is_Server_Class*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, broadway_Type_Server))

template broadway_Server_Get_Class*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, broadway_Type_Server, broadwayServerClass))

proc newBroadwayServer*(address: cstring; port: cint; sslCert: cstring;
                       sslKey: cstring; error: var glib.GError): ptr BroadwayServer {.
    importc: "broadway_server_new", libgdk.}
proc newBroadwayServerOnUnixSocket*(address: cstring; error: var glib.GError): ptr BroadwayServer {.
    importc: "broadway_server_on_unix_socket_new", libgdk.}
proc hasClient*(server: ptr BroadwayServer): Gboolean {.
    importc: "broadway_server_has_client", libgdk.}
proc flush*(server: ptr BroadwayServer) {.
    importc: "broadway_server_flush", libgdk.}
proc sync*(server: ptr BroadwayServer) {.
    importc: "broadway_server_sync", libgdk.}
proc getScreenSize*(server: ptr BroadwayServer; width: var uint32;
                                 height: var uint32) {.
    importc: "broadway_server_get_screen_size", libgdk.}
proc getNextSerial*(server: ptr BroadwayServer): uint32 {.
    importc: "broadway_server_get_next_serial", libgdk.}
proc nextSerial*(server: ptr BroadwayServer): uint32 {.
    importc: "broadway_server_get_next_serial", libgdk.}
proc getLastSeenTime*(server: ptr BroadwayServer): uint32 {.
    importc: "broadway_server_get_last_seen_time", libgdk.}
proc lastSeenTime*(server: ptr BroadwayServer): uint32 {.
    importc: "broadway_server_get_last_seen_time", libgdk.}
proc lookaheadEvent*(server: ptr BroadwayServer; types: cstring): Gboolean {.
    importc: "broadway_server_lookahead_event", libgdk.}
proc queryMouse*(server: ptr BroadwayServer; toplevel: var uint32;
                              rootX: var int32; rootY: var int32; mask: var uint32) {.
    importc: "broadway_server_query_mouse", libgdk.}
proc grabPointer*(server: ptr BroadwayServer; clientId: cint; id: cint;
                               ownerEvents: Gboolean; eventMask: uint32;
                               time: uint32): uint32 {.
    importc: "broadway_server_grab_pointer", libgdk.}
proc ungrabPointer*(server: ptr BroadwayServer; time: uint32): uint32 {.
    importc: "broadway_server_ungrab_pointer", libgdk.}
proc getMouseToplevel*(server: ptr BroadwayServer): int32 {.
    importc: "broadway_server_get_mouse_toplevel", libgdk.}
proc mouseToplevel*(server: ptr BroadwayServer): int32 {.
    importc: "broadway_server_get_mouse_toplevel", libgdk.}
proc setShowKeyboard*(server: ptr BroadwayServer; show: Gboolean) {.
    importc: "broadway_server_set_show_keyboard", libgdk.}
proc `showKeyboard=`*(server: ptr BroadwayServer; show: Gboolean) {.
    importc: "broadway_server_set_show_keyboard", libgdk.}
proc newWindow*(server: ptr BroadwayServer; x: cint; y: cint; width: cint;
                             height: cint; isTemp: Gboolean): uint32 {.
    importc: "broadway_server_new_window", libgdk.}
proc destroyWindow*(server: ptr BroadwayServer; id: cint) {.
    importc: "broadway_server_destroy_window", libgdk.}
proc windowShow*(server: ptr BroadwayServer; id: cint): Gboolean {.
    importc: "broadway_server_window_show", libgdk.}
proc windowHide*(server: ptr BroadwayServer; id: cint): Gboolean {.
    importc: "broadway_server_window_hide", libgdk.}
proc windowRaise*(server: ptr BroadwayServer; id: cint) {.
    importc: "broadway_server_window_raise", libgdk.}
proc windowLower*(server: ptr BroadwayServer; id: cint) {.
    importc: "broadway_server_window_lower", libgdk.}
proc windowSetTransientFor*(server: ptr BroadwayServer; id: cint;
    parent: cint) {.importc: "broadway_server_window_set_transient_for", libgdk.}
proc windowTranslate*(server: ptr BroadwayServer; id: cint;
                                   area: cairo.Region; dx: cint; dy: cint): Gboolean {.
    importc: "broadway_server_window_translate", libgdk.}
proc broadwayServerCreateSurface*(width: cint; height: cint): cairo.Surface {.
    importc: "broadway_server_create_surface", libgdk.}
proc windowUpdate*(server: ptr BroadwayServer; id: cint;
                                surface: cairo.Surface) {.
    importc: "broadway_server_window_update", libgdk.}
proc windowMoveResize*(server: ptr BroadwayServer; id: cint;
                                    withMove: Gboolean; x: cint; y: cint; width: cint;
                                    height: cint): Gboolean {.
    importc: "broadway_server_window_move_resize", libgdk.}
proc focusWindow*(server: ptr BroadwayServer; newFocusedWindow: cint) {.
    importc: "broadway_server_focus_window", libgdk.}
proc openSurface*(server: ptr BroadwayServer; id: uint32;
                               name: cstring; width: cint; height: cint): cairo.Surface {.
    importc: "broadway_server_open_surface", libgdk.}

