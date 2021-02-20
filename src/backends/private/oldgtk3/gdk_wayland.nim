  {.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk except deviceGetType, displayGetType, windowGetType, glContextGetType

from gobject import GType

from glib import GPointer, GDestroyNotify, Gboolean

type # wayland dummy objects
  WlSeat* = object
  WlPointer* = object
  WlOutput* = object
  WlKeyboard* = object
  WlDisplay* = object
  WlCompositor* = object
  WlSurface* = object
  XdgShell* = object

type
  WaylandDevice* =  ptr WaylandDeviceObj
  WaylandDevicePtr* = ptr WaylandDeviceObj
  WaylandDeviceObj* = DeviceObj

template typeWaylandDevice*(): untyped =
  (waylandDeviceGetType())

template waylandDevice*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, typeWaylandDevice, WaylandDeviceObj))

template waylandDeviceClass*(c: untyped): untyped =
  (gTypeCheckClassCast(c, typeWaylandDevice, WaylandDeviceClass))

template isWaylandDevice*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, typeWaylandDevice))

template isWaylandDeviceClass*(c: untyped): untyped =
  (gTypeCheckClassType(c, typeWaylandDevice))

template waylandDeviceGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, typeWaylandDevice, WaylandDeviceClass))

proc deviceGetType*(): GType {.importc: "gdk_wayland_device_get_type",
                                      libgdk.}
proc getWlSeat*(device: Device): ptr WlSeat {.
    importc: "gdk_wayland_device_get_wl_seat", libgdk.}
proc getWlPointer*(device: Device): ptr WlPointer {.
    importc: "gdk_wayland_device_get_wl_pointer", libgdk.}
proc getWlKeyboard*(device: Device): ptr WlKeyboard {.
    importc: "gdk_wayland_device_get_wl_keyboard", libgdk.}
proc getWlSeat*(seat: Seat): ptr WlSeat {.
    importc: "gdk_wayland_seat_get_wl_seat", libgdk.}
proc getNodePath*(device: Device): cstring {.
    importc: "gdk_wayland_device_get_node_path", libgdk.}
proc padSetFeedback*(device: Device;
                                    element: DevicePadFeature; idx: cuint;
                                    label: cstring) {.
    importc: "gdk_wayland_device_pad_set_feedback", libgdk.}

type
  WaylandDisplay* =  ptr WaylandDisplayObj
  WaylandDisplayPtr* = ptr WaylandDisplayObj
  WaylandDisplayObj* = DisplayObj

template typeWaylandDisplay*(): untyped =
  (waylandDisplayGetType())

template waylandDisplay*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWaylandDisplay, WaylandDisplayObj))

template waylandDisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWaylandDisplay, WaylandDisplayClass))

template isWaylandDisplay*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWaylandDisplay))

template isWaylandDisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWaylandDisplay))

template waylandDisplayGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWaylandDisplay, WaylandDisplayClass))

proc displayGetType*(): GType {.importc: "gdk_wayland_display_get_type",
                                       libgdk.}
proc getWlDisplay*(display: Display): ptr WlDisplay {.
    importc: "gdk_wayland_display_get_wl_display", libgdk.}
proc getWlCompositor*(display: Display): ptr WlCompositor {.
    importc: "gdk_wayland_display_get_wl_compositor", libgdk.}
proc setCursorTheme*(display: Display; theme: cstring;
                                     size: cint) {.
    importc: "gdk_wayland_display_set_cursor_theme", libgdk.}
proc setStartupNotificationId*(display: Display;
    startupId: cstring) {.importc: "gdk_wayland_display_set_startup_notification_id",
                        libgdk.}

template typeWaylandMonitor*(): untyped =
  (waylandMonitorGetType())

template waylandMonitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWaylandMonitor, WaylandMonitor))

template isWaylandMonitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWaylandMonitor))

proc monitorGetType*(): GType {.importc: "gdk_wayland_monitor_get_type",
                                       libgdk.}
proc getWlOutput*(monitor: Monitor): ptr WlOutput {.
    importc: "gdk_wayland_monitor_get_wl_output", libgdk.}

when defined(gtk_Compilation) or defined(gdk_Compilation):
  const
    gdkWaylandSelectionAddTargets* = selectionAddTargetsLibgtkOnly
  proc selectionAddTargets*(window: Window; selection: Atom;
                                     ntargets: cuint; targets: var Atom) {.
      importc: "gdk_wayland_selection_add_targets", libgdk.}
  const
    gdkWaylandSelectionClearTargets* = selectionClearTargetsLibgtkOnly
  proc selectionClearTargets*(display: Display; selection: Atom) {.
      importc: "gdk_wayland_selection_clear_targets", libgdk.}

type
  WaylandWindow* =  ptr WaylandWindowObj
  WaylandWindowPtr* = ptr WaylandWindowObj
  WaylandWindowObj* = WindowObj

template typeWaylandWindow*(): untyped =
  (waylandWindowGetType())

template waylandWindow*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWaylandWindow, WaylandWindowObj))

template waylandWindowClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWaylandWindow, WaylandWindowClass))

template isWaylandWindow*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWaylandWindow))

template isWaylandWindowClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWaylandWindow))

template waylandWindowGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWaylandWindow, WaylandWindowClass))

proc windowGetType*(): GType {.importc: "gdk_wayland_window_get_type",
                                      libgdk.}
proc getWlSurface*(window: Window): ptr WlSurface {.
    importc: "gdk_wayland_window_get_wl_surface", libgdk.}
proc setUseCustomSurface*(window: Window) {.
    importc: "gdk_wayland_window_set_use_custom_surface", libgdk.}
proc setDbusPropertiesLibgtkOnly*(window: Window;
    applicationId: cstring; appMenuPath: cstring; menubarPath: cstring;
    windowObjectPath: cstring; applicationObjectPath: cstring;
    uniqueBusName: cstring) {.importc: "gdk_wayland_window_set_dbus_properties_libgtk_only",
                            libgdk.}
type
  WaylandWindowExported* = proc (window: Window; handle: cstring;
                                 userData: Gpointer) {.cdecl.}

proc exportHandle*(window: Window;
                                  callback: WaylandWindowExported;
                                  userData: Gpointer; destroyFunc: GDestroyNotify): Gboolean {.
    importc: "gdk_wayland_window_export_handle", libgdk.}
proc unexportHandle*(window: Window) {.
    importc: "gdk_wayland_window_unexport_handle", libgdk.}
proc setTransientForExported*(window: Window;
    parentHandleStr: cstring): Gboolean {.importc: "gdk_wayland_window_set_transient_for_exported",
                                       libgdk.}

template typeWaylandGlContext*(): untyped =
  (waylandGlContextGetType())

template waylandGlContext*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeWaylandGlContext, WaylandGLContext))

template waylandIsGlContext*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeWaylandGlContext))

proc glContextGetType*(): GType {.
    importc: "gdk_wayland_gl_context_get_type", libgdk.}
