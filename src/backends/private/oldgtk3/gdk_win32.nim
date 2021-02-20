  {.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk

from windows import HWND, HGDIOBJ

from glib import Gpointer, Gboolean

from gobject import GType

template typeWin32Cursor*(): untyped =
  (win32CursorGetType())

template win32Cursor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWin32Cursor, Win32CursorObj))

template win32CursorClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWin32Cursor, Win32CursorClass))

template isWin32Cursor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWin32Cursor))

template isWin32CursorClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWin32Cursor))

template win32CursorGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWin32Cursor, Win32CursorClass))

type
  Win32Cursor* =  ptr Win32CursorObj
  Win32CursorPtr* = ptr Win32CursorObj
  Win32CursorObj* = CursorObj

proc cursorGetType*(): GType {.importc: "gdk_win32_cursor_get_type",
                                    libgdk.}

type
  Win32Display* =  ptr Win32DisplayObj
  Win32DisplayPtr* = ptr Win32DisplayObj
  Win32DisplayObj* = DisplayObj

template typeWin32Display*(): untyped =
  (win32DisplayGetType())

template win32Display*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWin32Display, Win32DisplayObj))

template win32DisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWin32Display, Win32DisplayClass))

template isWin32Display*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWin32Display))

template isWin32DisplayClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWin32Display))

template win32DisplayGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWin32Display, Win32DisplayClass))

proc displayGetType*(): GType {.importc: "gdk_win32_display_get_type",
                                     libgdk.}
proc setCursorTheme*(display: Display; name: cstring; size: cint) {.
    importc: "gdk_win32_display_set_cursor_theme", libgdk.}

type
  Win32DisplayManager* =  ptr Win32DisplayManagerObj
  Win32DisplayManagerPtr* = ptr Win32DisplayManagerObj
  Win32DisplayManagerObj* = DisplayManagerObj

template typeWin32DisplayManager*(): untyped =
  (win32DisplayManagerGetType())

template win32DisplayManager*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWin32DisplayManager, Win32DisplayManagerObj))

template win32DisplayManagerClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWin32DisplayManager, Win32DisplayManagerClass))

template isWin32DisplayManager*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWin32DisplayManager))

template isWin32DisplayManagerClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWin32DisplayManager))

template win32DisplayManagerGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWin32DisplayManager, Win32DisplayManagerClass))

proc displayManagerGetType*(): GType {.
    importc: "gdk_win32_display_manager_get_type", libgdk.}

template typeWin32DragContext*(): untyped =
  (win32DragContextGetType())

template win32DragContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWin32DragContext, Win32DragContextObj))

template win32DragContextClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWin32DragContext, Win32DragContextClass))

template isWin32DragContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWin32DragContext))

template isWin32DragContextClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWin32DragContext))

template win32DragContextGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWin32DragContext, Win32DragContextClass))

type
  Win32DragContext* =  ptr Win32DragContextObj
  Win32DragContextPtr* = ptr Win32DragContextObj
  Win32DragContextObj* = DragContextObj

proc dragContextGetType*(): GType {.
    importc: "gdk_win32_drag_context_get_type", libgdk.}

type
  Win32KeymapMatch* {.size: sizeof(cint), pure.} = enum
    WIN32_KEYMAP_MATCH_NONE, WIN32_KEYMAP_MATCH_INCOMPLETE,
    WIN32_KEYMAP_MATCH_PARTIAL, WIN32_KEYMAP_MATCH_EXACT
  Win32Keymap* =  ptr Win32KeymapObj
  Win32KeymapPtr* = ptr Win32KeymapObj
  Win32KeymapObj* = KeymapObj

template typeWin32Keymap*(): untyped =
  (win32KeymapGetType())

template win32Keymap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWin32Keymap, Win32KeymapObj))

template win32KeymapClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWin32Keymap, Win32KeymapClass))

template isWin32Keymap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWin32Keymap))

template isWin32KeymapClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWin32Keymap))

template win32KeymapGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWin32Keymap, Win32KeymapClass))

proc keymapGetType*(): GType {.importc: "gdk_win32_keymap_get_type",
                                    libgdk.}
proc checkCompose*(keymap: Win32Keymap;
                                composeBuffer: var uint16;
                                composeBufferLen: Gsize; output: var uint16;
                                outputLen: ptr Gsize): Win32KeymapMatch {.
    importc: "gdk_win32_keymap_check_compose", libgdk.}

template typeWin32Screen*(): untyped =
  (win32ScreenGetType())

template win32Screen*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWin32Screen, Win32ScreenObj))

template win32ScreenClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWin32Screen, Win32ScreenClass))

template isWin32Screen*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWin32Screen))

template isWin32ScreenClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWin32Screen))

template win32ScreenGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWin32Screen, Win32ScreenClass))

type
  Win32Screen* =  ptr Win32ScreenObj
  Win32ScreenPtr* = ptr Win32ScreenObj
  Win32ScreenObj* = ScreenObj

proc screenGetType*(): GType {.importc: "gdk_win32_screen_get_type",
                                    libgdk.}

template typeWin32Window*(): untyped =
  (win32WindowGetType())

template win32Window*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWin32Window, Win32WindowObj))

template win32WindowClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeWin32Window, Win32WindowClass))

template isWin32Window*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWin32Window))

template isWin32WindowClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeWin32Window))

template win32WindowGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeWin32Window, Win32WindowClass))

type
  Win32Window* =  ptr Win32WindowObj
  Win32WindowPtr* = ptr Win32WindowObj
  Win32WindowObj* = WindowObj

proc windowGetType*(): GType {.importc: "gdk_win32_window_get_type",
                                    libgdk.}

when INSIDE_GDK_WIN32: # when defined(INSIDE_GDK_WIN32):
  template windowHwnd*(win: untyped): untyped =
    (gdk_Window_Impl_Win32(win.impl).handle)

else:
  template windowHwnd*(d: untyped): untyped =
    (gdkWin32WindowGetHandle(d))

when not defined(GET_XBUTTON_WPARAM):
  template get_Xbutton_Wparam*(w: untyped): untyped =
    (hiword(w))

proc isWin32*(window: Window): Gboolean {.
    importc: "gdk_win32_window_is_win32", libgdk.}
proc getImplHwnd*(window: Window): Hwnd {.
    importc: "gdk_win32_window_get_impl_hwnd", libgdk.}

proc handleTableLookup*(handle: Hwnd): Gpointer {.
    importc: "gdk_win32_handle_table_lookup", libgdk.}

proc getHandle*(window: Window): Hgdiobj {.
    importc: "gdk_win32_window_get_handle", libgdk.}
proc selectionAddTargets*(owner: Window; selection: Atom;
                                 nTargets: cint; targets: var Atom) {.
    importc: "gdk_win32_selection_add_targets", libgdk.}
proc newWin32WindowForeign*(display: Display; anid: Hwnd): Window {.
    importc: "gdk_win32_window_foreign_new_for_display", libgdk.}
proc windowLookupForDisplay*(display: Display; anid: Hwnd): Window {.
    importc: "gdk_win32_window_lookup_for_display", libgdk.}
when defined(inside_Gdk_Win32) or defined(gdk_Compilation) or
    defined(gtk_Compilation):
  proc iconToPixbufLibgtkOnly*(hicon: Hicon; xHot: var cdouble;
                                      yHot: var cdouble): GdkPixbuf {.
      importc: "gdk_win32_icon_to_pixbuf_libgtk_only", libgdk.}
  proc pixbufToHiconLibgtkOnly*(pixbuf: GdkPixbuf): Hicon {.
      importc: "gdk_win32_pixbuf_to_hicon_libgtk_only", libgdk.}
  proc setModalDialogLibgtkOnly*(window: Hwnd) {.
      importc: "gdk_win32_set_modal_dialog_libgtk_only", libgdk.}

template typeWin32Monitor*(): untyped =
  (win32MonitorGetType())

template win32Monitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeWin32Monitor, Win32MonitorObj))

template isWin32Monitor*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeWin32Monitor))

type
  Win32Monitor* =  ptr Win32MonitorObj
  Win32MonitorPtr* = ptr Win32MonitorObj
  Win32MonitorObj* = MonitorObj

proc monitorGetType*(): GType {.importc: "gdk_win32_monitor_get_type",
                                     libgdk.}

template typeWin32GlContext*(): untyped =
  (win32GlContextGetType())

template win32GlContext*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeWin32GlContext, Win32GLContext))

template win32IsGlContext*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeWin32GlContext))

proc glContextGetType*(): GType {.importc: "gdk_win32_gl_context_get_type",
                                       libgdk.}
proc getWglVersion*(display: Display; major: var cint;
                                  minor: var cint): Gboolean {.
    importc: "gdk_win32_display_get_wgl_version", libgdk.}
