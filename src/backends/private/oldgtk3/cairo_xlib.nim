import cairo
from x import TDrawable, TPixmap
from xlib import PDisplay, PScreen, PVisual
include "cairo_pragma.nim"
proc surfaceCreate*(dpy: PDisplay; drawable: TDrawable;
                            visual: PVisual; width: cint; height: cint): Surface {.
    importc: "cairo_xlib_surface_create", libcairo.}
proc surfaceCreateForBitmap*(dpy: PDisplay; bitmap: TPixmap;
                                     screen: PScreen; width: cint; height: cint): Surface {.
    importc: "cairo_xlib_surface_create_for_bitmap", libcairo.}
proc setSize*(surface: Surface; width: cint; height: cint) {.
    importc: "cairo_xlib_surface_set_size", libcairo.}
proc setDrawable*(surface: Surface; drawable: TDrawable;
                                 width: cint; height: cint) {.
    importc: "cairo_xlib_surface_set_drawable", libcairo.}
proc getDisplay*(surface: Surface): PDisplay {.
    importc: "cairo_xlib_surface_get_display", libcairo.}
proc getDrawable*(surface: Surface): TDrawable {.
    importc: "cairo_xlib_surface_get_drawable", libcairo.}
proc getScreen*(surface: Surface): PScreen {.
    importc: "cairo_xlib_surface_get_screen", libcairo.}
proc getVisual*(surface: Surface): PVisual {.
    importc: "cairo_xlib_surface_get_visual", libcairo.}
proc getDepth*(surface: Surface): cint {.
    importc: "cairo_xlib_surface_get_depth", libcairo.}
proc getWidth*(surface: Surface): cint {.
    importc: "cairo_xlib_surface_get_width", libcairo.}
proc getHeight*(surface: Surface): cint {.
    importc: "cairo_xlib_surface_get_height", libcairo.}
proc debugCapXrenderVersion*(device: Device;
    majorVersion: cint; minorVersion: cint) {.
    importc: "cairo_xlib_device_debug_cap_xrender_version", libcairo.}
proc debugSetPrecision*(device: Device; precision: cint) {.
    importc: "cairo_xlib_device_debug_set_precision", libcairo.}
proc debugGetPrecision*(device: Device): cint {.
    importc: "cairo_xlib_device_debug_get_precision", libcairo.}


