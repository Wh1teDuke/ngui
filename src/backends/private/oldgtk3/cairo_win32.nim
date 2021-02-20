import cairo
from windows import HDC, LOGFONTW, HFONT
const CAIRO_HAS_WIN32_FONT = true
include "cairo_pragma.nim"
proc surfaceCreate*(hdc: Hdc): Surface {.
    importc: "cairo_win32_surface_create", libcairo.}
proc surfaceCreateWithFormat*(hdc: Hdc; format: Format): Surface {.
    importc: "cairo_win32_surface_create_with_format", libcairo.}
proc printingSurfaceCreate*(hdc: Hdc): Surface {.
    importc: "cairo_win32_printing_surface_create", libcairo.}
proc surfaceCreateWithDdb*(hdc: Hdc; format: Format; width: cint;
                                    height: cint): Surface {.
    importc: "cairo_win32_surface_create_with_ddb", libcairo.}
proc surfaceCreateWithDib*(format: Format; width: cint;
                                    height: cint): Surface {.
    importc: "cairo_win32_surface_create_with_dib", libcairo.}
proc getDc*(surface: Surface): Hdc {.
    importc: "cairo_win32_surface_get_dc", libcairo.}
proc getImage*(surface: Surface): Surface {.
    importc: "cairo_win32_surface_get_image", libcairo.}
when CAIRO_HAS_WIN32_FONT:
  proc fontFaceCreateForLogfontw*(logfont: ptr Logfontw): FontFace {.
      importc: "cairo_win32_font_face_create_for_logfontw", libcairo.}
  proc fontFaceCreateForHfont*(font: Hfont): FontFace {.
      importc: "cairo_win32_font_face_create_for_hfont", libcairo.}
  proc fontFaceCreateForLogfontwHfont*(logfont: ptr Logfontw;
      font: Hfont): FontFace {.importc: "cairo_win32_font_face_create_for_logfontw_hfont",
                                     libcairo.}
  proc selectFont*(scaledFont: ScaledFont; hdc: Hdc): Status {.
      importc: "cairo_win32_scaled_font_select_font", libcairo.}
  proc doneFont*(scaledFont: ScaledFont) {.
      importc: "cairo_win32_scaled_font_done_font", libcairo.}
  proc getMetricsFactor*(scaledFont: ScaledFont): cdouble {.
      importc: "cairo_win32_scaled_font_get_metrics_factor", libcairo.}
  proc getLogicalToDevice*(
      scaledFont: ScaledFont; logicalToDevice: Matrix) {.
      importc: "cairo_win32_scaled_font_get_logical_to_device", libcairo.}
  proc getDeviceToLogical*(
      scaledFont: ScaledFont; deviceToLogical: Matrix) {.
      importc: "cairo_win32_scaled_font_get_device_to_logical", libcairo.}


