{.deadCodeElim: on.}
import pango except fontGetType, fontMapGetType
from glib import Gunichar, Gboolean
from windows import HDC, HFONT, PLOGFONTA, LOGFONTW
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}

const
  STRICT* = true

const
  RENDER_TYPE_WIN32* = "RenderWin32"

proc render*(hdc: Hdc; font: Font; glyphs: GlyphString;
                      x: cint; y: cint) {.importc: "pango_win32_render", libpango.}
proc renderLayoutLine*(hdc: Hdc; line: LayoutLine; x: cint; y: cint) {.
    importc: "pango_win32_render_layout_line", libpango.}
proc renderLayout*(hdc: Hdc; layout: Layout; x: cint; y: cint) {.
    importc: "pango_win32_render_layout", libpango.}
proc renderTransformed*(hdc: Hdc; matrix: Matrix;
                                 font: Font; glyphs: GlyphString;
                                 x: cint; y: cint) {.
    importc: "pango_win32_render_transformed", libpango.}
when (ENABLE_ENGINE):
  proc getGlyphIndex*(font: Font; wc: Gunichar): cint {.
      importc: "pango_win32_font_get_glyph_index", libpango.}
  proc getDc*(): Hdc {.importc: "pango_win32_get_dc", libpango.}
  proc getDebugFlag*(): Gboolean {.importc: "pango_win32_get_debug_flag",
      libpango.}
  proc selectFont*(font: Font; hdc: Hdc): Gboolean {.
      importc: "pango_win32_font_select_font", libpango.}
  proc doneFont*(font: Font) {.
      importc: "pango_win32_font_done_font", libpango.}
  proc getMetricsFactor*(font: Font): cdouble {.
      importc: "pango_win32_font_get_metrics_factor", libpango.}

type
  Win32FontCache* =  ptr Win32FontCacheObj
  Win32FontCachePtr* = ptr Win32FontCacheObj
  Win32FontCacheObj* = object

proc fontCacheNew*(): Win32FontCache {.
    importc: "pango_win32_font_cache_new", libpango.}
proc free*(cache: Win32FontCache) {.
    importc: "pango_win32_font_cache_free", libpango.}
proc load*(cache: Win32FontCache; logfont: ptr Logfonta): Hfont {.
    importc: "pango_win32_font_cache_load", libpango.}
proc loadw*(cache: Win32FontCache; logfont: ptr Logfontw): Hfont {.
    importc: "pango_win32_font_cache_loadw", libpango.}
proc unload*(cache: Win32FontCache; hfont: Hfont) {.
    importc: "pango_win32_font_cache_unload", libpango.}
proc fontMapForDisplay*(): FontMap {.
    importc: "pango_win32_font_map_for_display", libpango.}
proc shutdownDisplay*() {.importc: "pango_win32_shutdown_display",
                                  libpango.}
proc getFontCache*(fontMap: FontMap): Win32FontCache {.
    importc: "pango_win32_font_map_get_font_cache", libpango.}
proc logfont*(font: Font): ptr Logfonta {.
    importc: "pango_win32_font_logfont", libpango.}
proc logfontw*(font: Font): ptr Logfontw {.
    importc: "pango_win32_font_logfontw", libpango.}
proc fontDescriptionFromLogfont*(lfp: ptr Logfonta): FontDescription {.
    importc: "pango_win32_font_description_from_logfont", libpango.}
proc fontDescriptionFromLogfontw*(lfp: ptr Logfontw): FontDescription {.
    importc: "pango_win32_font_description_from_logfontw", libpango.}

