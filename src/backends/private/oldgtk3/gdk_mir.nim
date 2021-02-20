  {.deadCodeElim: on.}

{.pragma: libgdk, cdecl, dynlib: LIB_GDK.}

import gdk

from gobject import GType

type # unity mir dummy objects
  MirConnection* = object
  MirSurface* = object

template typeMirDisplay*(): untyped =
  (mirDisplayGetType())

template isMirDisplay*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeMirDisplay))

template typeMirGlContext*(): untyped =
  (mirGlContextGetType())

template mirIsGlContext*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeMirGlContext))

template typeMirWindow*(): untyped =
  (mirWindowGetType())

template isMirWindow*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeMirWindow))

proc mirDisplayGetType*(): GType {.importc: "gdk_mir_display_get_type",
                                   libgdk.}
proc mirDisplayGetMirConnection*(display: Display): ptr MirConnection {.
    importc: "gdk_mir_display_get_mir_connection", libgdk.}
proc mirWindowGetType*(): GType {.importc: "gdk_mir_window_get_type", libgdk.}
proc mirWindowGetMirSurface*(window: Window): ptr MirSurface {.
    importc: "gdk_mir_window_get_mir_surface", libgdk.}
proc mirGlContextGetType*(): GType {.importc: "gdk_mir_gl_context_get_type",
                                     libgdk.}
