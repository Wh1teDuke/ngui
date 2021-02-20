  {.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk except appLaunchContextGetType, cursorGetType, displayGetType, displayManagerGetType, dragContextGetType, glContextGetType, keymapGetType,
  screenGetType, visualGetType, windowGetType

from glib import Gboolean

from gobject import GType

from x import TCursor

from xlib import TDisplay, TScreen, TVisual

template typeX11AppLaunchContext*(): untyped =
  (x11AppLaunchContextGetType())

template x11AppLaunchContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11AppLaunchContext, X11AppLaunchContextObj))

template x11AppLaunchContextClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11AppLaunchContext, X11AppLaunchContextClass))

template isX11AppLaunchContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11AppLaunchContext))

template isX11AppLaunchContextClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11AppLaunchContext))

template x11AppLaunchContextGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11AppLaunchContext, X11AppLaunchContextClass))

type
  X11AppLaunchContext* =  ptr X11AppLaunchContextObj
  X11AppLaunchContextPtr* = ptr X11AppLaunchContextObj
  X11AppLaunchContextObj* = AppLaunchContextObj

proc appLaunchContextGetType*(): GType {.
    importc: "gdk_x11_app_launch_context_get_type", libgdk.}

template typeX11Cursor*(): untyped =
  (x11CursorGetType())

template x11Cursor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11Cursor, X11CursorObj))

template x11CursorClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11Cursor, X11CursorClass))

template isX11Cursor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11Cursor))

template isX11CursorClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11Cursor))

template x11CursorGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11Cursor, X11CursorClass))

type
  X11Cursor* =  ptr X11CursorObj
  X11CursorPtr* = ptr X11CursorObj
  X11CursorObj* = CursorObj

proc cursorGetType*(): GType {.importc: "gdk_x11_cursor_get_type", libgdk.}
proc getXdisplay*(cursor: Cursor): ptr xlib.TDisplay {.
    importc: "gdk_x11_cursor_get_xdisplay", libgdk.}
proc getXcursor*(cursor: Cursor): x.TCursor {.
    importc: "gdk_x11_cursor_get_xcursor", libgdk.}

template cursorXdisplay*(cursor: untyped): untyped =
  (gdkX11CursorGetXdisplay(cursor))

template cursorXcursor*(cursor: untyped): untyped =
  (gdkX11CursorGetXcursor(cursor))

proc getId*(device: Device): cint {.
    importc: "gdk_x11_device_get_id", libgdk.}

template typeX11DeviceCore*(): untyped =
  (x11DeviceCoreGetType())

template x11DeviceCore*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, typeX11DeviceCore, X11DeviceCore))

template x11DeviceCoreClass*(c: untyped): untyped =
  (gTypeCheckClassCast(c, typeX11DeviceCore, X11DeviceCoreClass))

template isX11DeviceCore*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, typeX11DeviceCore))

template isX11DeviceCoreClass*(c: untyped): untyped =
  (gTypeCheckClassType(c, typeX11DeviceCore))

template x11DeviceCoreGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, typeX11DeviceCore, X11DeviceCoreClass))

proc deviceCoreGetType*(): GType {.importc: "gdk_x11_device_core_get_type",
                                      libgdk.}

template typeX11DeviceXi2*(): untyped =
  (x11DeviceXi2GetType())

template x11DeviceXi2*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, typeX11DeviceXi2, X11DeviceXI2))

template x11DeviceXi2Class*(c: untyped): untyped =
  (gTypeCheckClassCast(c, typeX11DeviceXi2, X11DeviceXI2Class))

template isX11DeviceXi2*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, typeX11DeviceXi2))

template isX11DeviceXi2Class*(c: untyped): untyped =
  (gTypeCheckClassType(c, typeX11DeviceXi2))

template x11DeviceXi2GetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, typeX11DeviceXi2, X11DeviceXI2Class))

proc deviceXi2GetType*(): GType {.importc: "gdk_x11_device_xi2_get_type",
                                     libgdk.}

proc lookup*(deviceManager: DeviceManager; deviceId: cint): Device {.
    importc: "gdk_x11_device_manager_lookup", libgdk.}

template typeX11DeviceManagerCore*(): untyped =
  (x11DeviceManagerCoreGetType())

template x11DeviceManagerCore*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, typeX11DeviceManagerCore, X11DeviceManagerCoreObj))

template x11DeviceManagerCoreClass*(c: untyped): untyped =
  (gTypeCheckClassCast(c, typeX11DeviceManagerCore, X11DeviceManagerCoreClassObj))

template isX11DeviceManagerCore*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, typeX11DeviceManagerCore))

template isX11DeviceManagerCoreClass*(c: untyped): untyped =
  (gTypeCheckClassType(c, typeX11DeviceManagerCore))

template x11DeviceManagerCoreGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, typeX11DeviceManagerCore, X11DeviceManagerCoreClassObj))

type
  X11DeviceManagerCore* =  ptr X11DeviceManagerCoreObj
  X11DeviceManagerCorePtr* = ptr X11DeviceManagerCoreObj
  X11DeviceManagerCoreObj* = object

  X11DeviceManagerCoreClass* =  ptr X11DeviceManagerCoreClassObj
  X11DeviceManagerCoreClassPtr* = ptr X11DeviceManagerCoreClassObj
  X11DeviceManagerCoreClassObj* = object

proc deviceManagerCoreGetType*(): GType {.
    importc: "gdk_x11_device_manager_core_get_type", libgdk.}

template typeX11DeviceManagerXi2*(): untyped =
  (x11DeviceManagerXi2GetType())

template x11DeviceManagerXi2*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, typeX11DeviceManagerXi2, X11DeviceManagerXI2Obj))

template x11DeviceManagerXi2Class*(c: untyped): untyped =
  (gTypeCheckClassCast(c, typeX11DeviceManagerXi2, X11DeviceManagerXI2ClassObj))

template isX11DeviceManagerXi2*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, typeX11DeviceManagerXi2))

template isX11DeviceManagerXi2Class*(c: untyped): untyped =
  (gTypeCheckClassType(c, typeX11DeviceManagerXi2))

template x11DeviceManagerXi2GetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, typeX11DeviceManagerXi2, X11DeviceManagerXI2ClassObj))

type
  X11DeviceManagerXI2* =  ptr X11DeviceManagerXI2Obj
  X11DeviceManagerXI2Ptr* = ptr X11DeviceManagerXI2Obj
  X11DeviceManagerXI2Obj* = object

  X11DeviceManagerXI2Class* =  ptr X11DeviceManagerXI2ClassObj
  X11DeviceManagerXI2ClassPtr* = ptr X11DeviceManagerXI2ClassObj
  X11DeviceManagerXI2ClassObj* = object

proc deviceManagerXi2GetType*(): GType {.
    importc: "gdk_x11_device_manager_xi2_get_type", libgdk.}

type
  X11Display* =  ptr X11DisplayObj
  X11DisplayPtr* = ptr X11DisplayObj
  X11DisplayObj* = DisplayObj

template typeX11Display*(): untyped =
  (x11DisplayGetType())

template x11Display*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11Display, X11DisplayObj))

template x11DisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11Display, X11DisplayClass))

template isX11Display*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11Display))

template isX11DisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11Display))

template x11DisplayGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11Display, X11DisplayClass))

proc displayGetType*(): GType {.importc: "gdk_x11_display_get_type",
                                   libgdk.}
proc getXdisplay*(display: Display): ptr xlib.TDisplay {.
    importc: "gdk_x11_display_get_xdisplay", libgdk.}
template displayXdisplay*(display: untyped): untyped =
  (gdkX11DisplayGetXdisplay(display))

proc getUserTime*(display: Display): uint32 {.
    importc: "gdk_x11_display_get_user_time", libgdk.}
proc getStartupNotificationId*(display: Display): cstring {.
    importc: "gdk_x11_display_get_startup_notification_id", libgdk.}
proc setStartupNotificationId*(display: Display;
    startupId: cstring) {.importc: "gdk_x11_display_set_startup_notification_id",
                        libgdk.}
proc setCursorTheme*(display: Display; theme: cstring; size: cint) {.
    importc: "gdk_x11_display_set_cursor_theme", libgdk.}
proc broadcastStartupMessage*(display: Display;
    messageType: cstring) {.varargs,
                          importc: "gdk_x11_display_broadcast_startup_message",
                          libgdk.}
proc lookupXdisplay*(xdisplay: ptr xlib.TDisplay): Display {.
    importc: "gdk_x11_lookup_xdisplay", libgdk.}
proc grab*(display: Display) {.importc: "gdk_x11_display_grab",
    libgdk.}
proc ungrab*(display: Display) {.
    importc: "gdk_x11_display_ungrab", libgdk.}
proc setWindowScale*(display: Display; scale: cint) {.
    importc: "gdk_x11_display_set_window_scale", libgdk.}
proc errorTrapPush*(display: Display) {.
    importc: "gdk_x11_display_error_trap_push", libgdk.}

proc errorTrapPop*(display: Display): cint {.
    importc: "gdk_x11_display_error_trap_pop", libgdk.}
proc errorTrapPopIgnored*(display: Display) {.
    importc: "gdk_x11_display_error_trap_pop_ignored", libgdk.}
proc registerStandardEventType*(display: Display; eventBase: cint;
                                     nEvents: cint) {.
    importc: "gdk_x11_register_standard_event_type", libgdk.}
proc setSmClientId*(smClientId: cstring) {.
    importc: "gdk_x11_set_sm_client_id", libgdk.}

type
  X11DisplayManager* =  ptr X11DisplayManagerObj
  X11DisplayManagerPtr* = ptr X11DisplayManagerObj
  X11DisplayManagerObj* = DisplayManagerObj

template typeX11DisplayManager*(): untyped =
  (x11DisplayManagerGetType())

template x11DisplayManager*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11DisplayManager, X11DisplayManagerObj))

template x11DisplayManagerClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11DisplayManager, X11DisplayManagerClass))

template isX11DisplayManager*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11DisplayManager))

template isX11DisplayManagerClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11DisplayManager))

template x11DisplayManagerGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11DisplayManager, X11DisplayManagerClass))

proc displayManagerGetType*(): GType {.
    importc: "gdk_x11_display_manager_get_type", libgdk.}

template typeX11DragContext*(): untyped =
  (x11DragContextGetType())

template x11DragContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11DragContext, X11DragContextObj))

template x11DragContextClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11DragContext, X11DragContextClass))

template isX11DragContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11DragContext))

template isX11DragContextClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11DragContext))

template x11DragContextGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11DragContext, X11DragContextClass))

type
  X11DragContext* =  ptr X11DragContextObj
  X11DragContextPtr* = ptr X11DragContextObj
  X11DragContextObj* = DragContextObj

proc dragContextGetType*(): GType {.importc: "gdk_x11_drag_context_get_type",
                                       libgdk.}

template typeX11GlContext*(): untyped =
  (x11GlContextGetType())

template x11GlContext*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeX11GlContext, X11GLContext))

template x11IsGlContext*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeX11GlContext))

proc glContextGetType*(): GType {.importc: "gdk_x11_gl_context_get_type",
                                     libgdk.}
proc getGlxVersion*(display: Display; major: var cint;
                                minor: var cint): Gboolean {.
    importc: "gdk_x11_display_get_glx_version", libgdk.}

type
  X11Keymap* =  ptr X11KeymapObj
  X11KeymapPtr* = ptr X11KeymapObj
  X11KeymapObj* = KeymapObj

template typeX11Keymap*(): untyped =
  (x11KeymapGetType())

template x11Keymap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11Keymap, X11KeymapObj))

template x11KeymapClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11Keymap, X11KeymapClass))

template isX11Keymap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11Keymap))

template isX11KeymapClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11Keymap))

template x11KeymapGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11Keymap, X11KeymapClass))

proc keymapGetType*(): GType {.importc: "gdk_x11_keymap_get_type", libgdk.}
proc getGroupForState*(keymap: Keymap; state: cuint): cint {.
    importc: "gdk_x11_keymap_get_group_for_state", libgdk.}
proc keyIsModifier*(keymap: Keymap; keycode: cuint): Gboolean {.
    importc: "gdk_x11_keymap_key_is_modifier", libgdk.}

template typeX11Monitor*(): untyped =
  (x11MonitorGetType())

template x11Monitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11Monitor, X11Monitor))

template isX11Monitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11Monitor))

proc monitorGetType*(): GType {.importc: "gdk_x11_monitor_get_type",
                                   libgdk.}
proc getOutput*(monitor: Monitor): x.TXID {.
    importc: "gdk_x11_monitor_get_output", libgdk.}

proc atomToXatomForDisplay*(display: Display; atom: Atom): x.TAtom {.
    importc: "gdk_x11_atom_to_xatom_for_display", libgdk.}
proc xatomToAtomForDisplay*(display: Display; xatom: x.TAtom): Atom {.
    importc: "gdk_x11_xatom_to_atom_for_display", libgdk.}
proc getXatomByNameForDisplay*(display: Display; atomName: cstring): x.TAtom {.
    importc: "gdk_x11_get_xatom_by_name_for_display", libgdk.}
proc getXatomNameForDisplay*(display: Display; xatom: x.TAtom): cstring {.
    importc: "gdk_x11_get_xatom_name_for_display", libgdk.}
proc toXatom*(atom: Atom): x.TAtom {.importc: "gdk_x11_atom_to_xatom",
    libgdk.}
proc atomToAtom*(xatom: x.TAtom): Atom {.importc: "gdk_x11_xatom_to_atom",
    libgdk.}
proc getXatomByName*(atomName: cstring): x.TAtom {.
    importc: "gdk_x11_get_xatom_by_name", libgdk.}
proc getXatomName*(xatom: x.TAtom): cstring {.importc: "gdk_x11_get_xatom_name",
    libgdk.}

template typeX11Screen*(): untyped =
  (x11ScreenGetType())

template x11Screen*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11Screen, X11ScreenObj))

template x11ScreenClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11Screen, X11ScreenClass))

template isX11Screen*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11Screen))

template isX11ScreenClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11Screen))

template x11ScreenGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11Screen, X11ScreenClass))

type
  X11Screen* =  ptr X11ScreenObj
  X11ScreenPtr* = ptr X11ScreenObj
  X11ScreenObj* = ScreenObj

proc screenGetType*(): GType {.importc: "gdk_x11_screen_get_type", libgdk.}
proc getXscreen*(screen: Screen): ptr xlib.TScreen {.
    importc: "gdk_x11_screen_get_xscreen", libgdk.}
proc getScreenNumber*(screen: Screen): cint {.
    importc: "gdk_x11_screen_get_screen_number", libgdk.}
proc getWindowManagerName*(screen: Screen): cstring {.
    importc: "gdk_x11_screen_get_window_manager_name", libgdk.}
proc getDefaultScreen*(): cint {.importc: "gdk_x11_get_default_screen",
                                    libgdk.}

template screenXdisplay*(screen: untyped): untyped =
  (gdkX11DisplayGetXdisplay(gdkScreenGetDisplay(screen)))

template screenXscreen*(screen: untyped): untyped =
  (gdkX11ScreenGetXscreen(screen))

template screenXnumber*(screen: untyped): untyped =
  (gdkX11ScreenGetScreenNumber(screen))

proc supportsNetWmHint*(screen: Screen; property: Atom): Gboolean {.
    importc: "gdk_x11_screen_supports_net_wm_hint", libgdk.}
proc getMonitorOutput*(screen: Screen; monitorNum: cint): x.TXID {.
    importc: "gdk_x11_screen_get_monitor_output", libgdk.}
proc getNumberOfDesktops*(screen: Screen): uint32 {.
    importc: "gdk_x11_screen_get_number_of_desktops", libgdk.}
proc getCurrentDesktop*(screen: Screen): uint32 {.
    importc: "gdk_x11_screen_get_current_desktop", libgdk.}

proc textPropertyToTextList*(display: Display;
    encoding: Atom; format: cint; text: var cuchar; length: cint;
    list: var cstringArray): cint {.importc: "gdk_x11_display_text_property_to_text_list",
                                libgdk.}
proc freeTextList*(list: cstringArray) {.importc: "gdk_x11_free_text_list",
    libgdk.}
proc stringToCompoundText*(display: Display; str: cstring;
                                       encoding: var Atom; format: var cint;
                                       ctext: var ptr cuchar; length: var cint): cint {.
    importc: "gdk_x11_display_string_to_compound_text", libgdk.}
proc utf8ToCompoundText*(display: Display; str: cstring;
                                     encoding: var Atom; format: var cint;
                                     ctext: var ptr cuchar; length: var cint): Gboolean {.
    importc: "gdk_x11_display_utf8_to_compound_text", libgdk.}
proc freeCompoundText*(ctext: var cuchar) {.
    importc: "gdk_x11_free_compound_text", libgdk.}

proc getDefaultRootXwindow*(): x.TWindow {.
    importc: "gdk_x11_get_default_root_xwindow", libgdk.}
proc getDefaultXdisplay*(): ptr xlib.TDisplay {.
    importc: "gdk_x11_get_default_xdisplay", libgdk.}

template rootWindow*(): untyped =
  (gdkX11GetDefaultRootXwindow())

template xidToPointer*(xid: untyped): untyped =
  guint_To_Pointer(xid)

template pointerToXid*(pointer: untyped): untyped =
  gpointer_To_Uint(pointer)

proc grabServer*() {.importc: "gdk_x11_grab_server", libgdk.}
proc ungrabServer*() {.importc: "gdk_x11_ungrab_server", libgdk.}

template typeX11Visual*(): untyped =
  (x11VisualGetType())

template x11Visual*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11Visual, X11VisualObj))

template x11VisualClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11Visual, X11VisualClass))

template isX11Visual*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11Visual))

template isX11VisualClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11Visual))

template x11VisualGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11Visual, X11VisualClass))

type
  X11Visual* =  ptr X11VisualObj
  X11VisualPtr* = ptr X11VisualObj
  X11VisualObj* = VisualObj

proc visualGetType*(): GType {.importc: "gdk_x11_visual_get_type", libgdk.}
proc getXvisual*(visual: Visual): ptr xlib.TVisual {.
    importc: "gdk_x11_visual_get_xvisual", libgdk.}
template visualXvisual*(visual: untyped): untyped =
  (gdkX11VisualGetXvisual(visual))

proc lookupVisual*(screen: Screen; xvisualid: x.TVisualID): Visual {.
    importc: "gdk_x11_screen_lookup_visual", libgdk.}

template typeX11Window*(): untyped =
  (x11WindowGetType())

template x11Window*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeX11Window, X11WindowObj))

template x11WindowClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeX11Window, X11WindowClass))

template isX11Window*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeX11Window))

template isX11WindowClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeX11Window))

template x11WindowGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeX11Window, X11WindowClass))

type
  X11Window* =  ptr X11WindowObj
  X11WindowPtr* = ptr X11WindowObj
  X11WindowObj* = WindowObj

proc windowGetType*(): GType {.importc: "gdk_x11_window_get_type", libgdk.}
proc getXid*(window: Window): x.TWindow {.
    importc: "gdk_x11_window_get_xid", libgdk.}
proc setUserTime*(window: Window; timestamp: uint32) {.
    importc: "gdk_x11_window_set_user_time", libgdk.}
proc setUtf8Property*(window: Window; name: cstring; value: cstring) {.
    importc: "gdk_x11_window_set_utf8_property", libgdk.}
proc setThemeVariant*(window: Window; variant: cstring) {.
    importc: "gdk_x11_window_set_theme_variant", libgdk.}
proc setFrameExtents*(window: Window; left: cint; right: cint;
                                 top: cint; bottom: cint) {.
    importc: "gdk_x11_window_set_frame_extents", libgdk.}
proc setHideTitlebarWhenMaximized*(window: Window;
    hideTitlebarWhenMaximized: Gboolean) {.
    importc: "gdk_x11_window_set_hide_titlebar_when_maximized", libgdk.}
proc moveToCurrentDesktop*(window: Window) {.
    importc: "gdk_x11_window_move_to_current_desktop", libgdk.}
proc getDesktop*(window: Window): uint32 {.
    importc: "gdk_x11_window_get_desktop", libgdk.}
proc moveToDesktop*(window: Window; desktop: uint32) {.
    importc: "gdk_x11_window_move_to_desktop", libgdk.}
proc setFrameSyncEnabled*(window: Window;
                                     frameSyncEnabled: Gboolean) {.
    importc: "gdk_x11_window_set_frame_sync_enabled", libgdk.}

template windowXdisplay*(win: untyped): untyped =
  (displayXdisplay(gdkWindowGetDisplay(win)))

template windowXid*(win: untyped): untyped =
  (gdkX11WindowGetXid(win))

proc getServerTime*(window: Window): uint32 {.
    importc: "gdk_x11_get_server_time", libgdk.}
proc newX11WindowForeign*(display: Display; window: x.TWindow): Window {.
    importc: "gdk_x11_window_foreign_new_for_display", libgdk.}
proc windowLookupForDisplay*(display: Display; window: x.TWindow): Window {.
    importc: "gdk_x11_window_lookup_for_display", libgdk.}
