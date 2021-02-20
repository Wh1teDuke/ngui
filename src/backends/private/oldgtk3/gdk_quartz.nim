  {.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk except cursorGetType, displayGetType, displayManagerGetType, dragContextGetType, keymapGetType, screenGetType, visualGetType, windowGetType

from glib import Gunichar

from gobject import GType

from gdk_pixbuf import GdkPixbuf

type # macosx quartz dummy objects
  NSString* = object
  NSImage* = object
  NSEvent* = object
  NSWindow* = object
  NSView* = object
  Id* = culong

when not defined(NSINTEGER_DEFINED):
  type
    NSInteger* = cint
    NSUInteger* = cuint
when not defined(CGFLOAT_DEFINED):
  type
    CGFloat* = cfloat
type
  OSXVersion* {.size: sizeof(cint), pure.} = enum
    UNSUPPORTED = 0, MIN = 4, LEOPARD = 5,
    SNOW_LEOPARD = 6, LION = 7, MOUNTAIN_LION = 8,
    NEW = 99

const
  OSX_TIGER = OSXVersion.MIN
  OSX_CURRENT = OSXVersion.MOUNTAIN_LION

proc osxVersion*(): OSXVersion {.importc: "gdk_quartz_osx_version",
    libgdk.}
proc pasteboardTypeToAtomLibgtkOnly*(`type`: ptr NSString): Atom {.
    importc: "gdk_quartz_pasteboard_type_to_atom_libgtk_only", libgdk.}
proc targetToPasteboardTypeLibgtkOnly*(target: cstring): ptr NSString {.
    importc: "gdk_quartz_target_to_pasteboard_type_libgtk_only", libgdk.}
proc toPasteboardTypeLibgtkOnly*(atom: Atom): ptr NSString {.
    importc: "gdk_quartz_atom_to_pasteboard_type_libgtk_only", libgdk.}

template typeQuartzCursor*(): untyped =
  (quartzCursorGetType())

template quartzCursor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzCursor, QuartzCursorObj))

template quartzCursorClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeQuartzCursor, QuartzCursorClass))

template isQuartzCursor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeQuartzCursor))

template isQuartzCursorClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeQuartzCursor))

template quartzCursorGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeQuartzCursor, QuartzCursorClass))

type
  QuartzCursor* =  ptr QuartzCursorObj
  QuartzCursorPtr* = ptr QuartzCursorObj
  QuartzCursorObj* = CursorObj

proc cursorGetType*(): GType {.importc: "gdk_quartz_cursor_get_type",
                                     libgdk.}

template typeQuartzDeviceCore*(): untyped =
  (quartzDeviceCoreGetType())

template quartzDeviceCore*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, typeQuartzDeviceCore, QuartzDeviceCore))

template quartzDeviceCoreClass*(c: untyped): untyped =
  (gTypeCheckClassCast(c, typeQuartzDeviceCore, QuartzDeviceCoreClass))

template isQuartzDeviceCore*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, typeQuartzDeviceCore))

template isQuartzDeviceCoreClass*(c: untyped): untyped =
  (gTypeCheckClassType(c, typeQuartzDeviceCore))

template quartzDeviceCoreGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, typeQuartzDeviceCore, QuartzDeviceCoreClass))

proc deviceCoreGetType*(): GType {.
    importc: "gdk_quartz_device_core_get_type", libgdk.}

template typeQuartzDeviceManagerCore*(): untyped =
  (quartzDeviceManagerCoreGetType())

template quartzDeviceManagerCore*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, typeQuartzDeviceManagerCore, QuartzDeviceManagerCore))

template quartzDeviceManagerCoreClass*(c: untyped): untyped =
  (gTypeCheckClassCast(c, typeQuartzDeviceManagerCore, QuartzDeviceManagerCoreClass))

template isQuartzDeviceManagerCore*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, typeQuartzDeviceManagerCore))

template isQuartzDeviceManagerCoreClass*(c: untyped): untyped =
  (gTypeCheckClassType(c, typeQuartzDeviceManagerCore))

template quartzDeviceManagerCoreGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, typeQuartzDeviceManagerCore, QuartzDeviceManagerCoreClass))

proc deviceManagerCoreGetType*(): GType {.
    importc: "gdk_quartz_device_manager_core_get_type", libgdk.}

template typeQuartzDisplay*(): untyped =
  (quartzDisplayGetType())

template quartzDisplay*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzDisplay, QuartzDisplayObj))

template quartzDisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeQuartzDisplay, QuartzDisplayClass))

template isQuartzDisplay*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeQuartzDisplay))

template isQuartzDisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeQuartzDisplay))

template quartzDisplayGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeQuartzDisplay, QuartzDisplayClass))

type
  QuartzDisplay* =  ptr QuartzDisplayObj
  QuartzDisplayPtr* = ptr QuartzDisplayObj
  QuartzDisplayObj* = DisplayObj

proc displayGetType*(): GType {.importc: "gdk_quartz_display_get_type",
                                      libgdk.}

template typeQuartzDisplayManager*(): untyped =
  (quartzDisplayManagerGetType())

template quartzDisplayManager*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzDisplayManager, QuartzDisplayManagerObj))

type
  QuartzDisplayManager* =  ptr QuartzDisplayManagerObj
  QuartzDisplayManagerPtr* = ptr QuartzDisplayManagerObj
  QuartzDisplayManagerObj* = DisplayManagerObj

proc displayManagerGetType*(): GType {.
    importc: "gdk_quartz_display_manager_get_type", libgdk.}

template typeQuartzDragContext*(): untyped =
  (quartzDragContextGetType())

template quartzDragContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzDragContext, QuartzDragContextObj))

template quartzDragContextClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeQuartzDragContext, QuartzDragContextClass))

template isQuartzDragContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeQuartzDragContext))

template isQuartzDragContextClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeQuartzDragContext))

template quartzDragContextGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeQuartzDragContext, QuartzDragContextClass))

type
  QuartzDragContext* =  ptr QuartzDragContextObj
  QuartzDragContextPtr* = ptr QuartzDragContextObj
  QuartzDragContextObj* = DragContextObj

proc dragContextGetType*(): GType {.
    importc: "gdk_quartz_drag_context_get_type", libgdk.}
proc getDraggingInfoLibgtkOnly*(context: DragContext): Id {.
    importc: "gdk_quartz_drag_context_get_dragging_info_libgtk_only", libgdk.}

template typeQuartzKeymap*(): untyped =
  (quartzKeymapGetType())

template quartzKeymap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzKeymap, QuartzKeymapObj))

template quartzKeymapClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeQuartzKeymap, QuartzKeymapClass))

template isQuartzKeymap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeQuartzKeymap))

template isQuartzKeymapClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeQuartzKeymap))

template quartzKeymapGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeQuartzKeymap, QuartzKeymapClass))

type
  QuartzKeymap* =  ptr QuartzKeymapObj
  QuartzKeymapPtr* = ptr QuartzKeymapObj
  QuartzKeymapObj* = KeymapObj

proc keymapGetType*(): GType {.importc: "gdk_quartz_keymap_get_type",
                                     libgdk.}

template typeQuartzMonitor*(): untyped =
  (quartzMonitorGetType())

template quartzMonitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzMonitor, QuartzMonitor))

template isQuartzMonitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeQuartzMonitor))

proc monitorGetType*(): GType {.importc: "gdk_quartz_monitor_get_type",
                                      libgdk.}

template typeQuartzScreen*(): untyped =
  (quartzScreenGetType())

template quartzScreen*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzScreen, QuartzScreenObj))

template quartzScreenClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeQuartzScreen, QuartzScreenClass))

template isQuartzScreen*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeQuartzScreen))

template isQuartzScreenClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeQuartzScreen))

template quartzScreenGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeQuartzScreen, QuartzScreenClass))

type
  QuartzScreen* =  ptr QuartzScreenObj
  QuartzScreenPtr* = ptr QuartzScreenObj
  QuartzScreenObj* = ScreenObj

proc screenGetType*(): GType {.importc: "gdk_quartz_screen_get_type",
                                     libgdk.}

proc pixbufToNsImageLibgtkOnly*(pixbuf: GdkPixbuf): ptr NSImage {.
    importc: "gdk_quartz_pixbuf_to_ns_image_libgtk_only", libgdk.}
proc getNsevent*(event: Event): ptr NSEvent {.
    importc: "gdk_quartz_event_get_nsevent", libgdk.}
proc getKeyEquivalent*(key: cuint): Gunichar {.
    importc: "gdk_quartz_get_key_equivalent", libgdk.}

template typeQuartzVisual*(): untyped =
  (quartzVisualGetType())

template quartzVisual*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzVisual, QuartzVisualObj))

template quartzVisualClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeQuartzVisual, QuartzVisualClass))

template isQuartzVisual*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeQuartzVisual))

template isQuartzVisualClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeQuartzVisual))

template quartzVisualGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeQuartzVisual, QuartzVisualClass))

type
  QuartzVisual* =  ptr QuartzVisualObj
  QuartzVisualPtr* = ptr QuartzVisualObj
  QuartzVisualObj* = VisualObj

proc visualGetType*(): GType {.importc: "gdk_quartz_visual_get_type",
                                     libgdk.}

template typeQuartzWindow*(): untyped =
  (quartzWindowGetType())

template quartzWindow*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeQuartzWindow, QuartzWindowObj))

template quartzWindowClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeQuartzWindow, QuartzWindowClass))

template isQuartzWindow*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeQuartzWindow))

template isQuartzWindowClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeQuartzWindow))

template quartzWindowGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeQuartzWindow, QuartzWindowClass))

type
  QuartzWindow* =  ptr QuartzWindowObj
  QuartzWindowPtr* = ptr QuartzWindowObj
  QuartzWindowObj* = WindowObj

proc windowGetType*(): GType {.importc: "gdk_quartz_window_get_type",
                                     libgdk.}
proc getNswindow*(window: Window): ptr NSWindow {.
    importc: "gdk_quartz_window_get_nswindow", libgdk.}
proc getNsview*(window: Window): ptr NSView {.
    importc: "gdk_quartz_window_get_nsview", libgdk.}
