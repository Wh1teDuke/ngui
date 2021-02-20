{.deadCodeElim: on.}
import pango except fontGetType, fontMapGetType
from glib import Gpointer, GDestroyNotify
from gobject import GType

when defined(windows): 
  const LIB_PANGO_FT2* = "libpangoft2-1.0-0.dll"
elif defined(macosx):
  const LIB_PANGO_FT2* = "libpangoft2-1.0.dylib"
else: 
  const LIB_PANGO_FT2* = "libpangoft2-1.0.so.0"

{.pragma: libpango, cdecl, dynlib: LIB_PANGO_FT2.}

type
  FT_Face = ptr object # dummy objects!
  FcPattern = object
  FT_Bitmap = object

type
  FT2FontMap* =  ptr FT2FontMapObj
  FT2FontMapPtr* = ptr FT2FontMapObj
  FT2FontMapObj* = object

template pangoTypeFt2FontMap*(): untyped =
  (ft2FontMapGetType())

template pangoFt2FontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFt2FontMap, FT2FontMapObj))

template pangoFt2IsFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFt2FontMap))

type
  FT2SubstituteFunc* = proc (pattern: ptr FcPattern; data: Gpointer) {.cdecl.}

proc render*(bitmap: ptr FT_Bitmap; font: Font;
                    glyphs: GlyphString; x: cint; y: cint) {.
    importc: "pango_ft2_render", libpango.}
proc renderTransformed*(bitmap: ptr FT_Bitmap; matrix: Matrix;
                               font: Font; glyphs: GlyphString;
                               x: cint; y: cint) {.
    importc: "pango_ft2_render_transformed", libpango.}
proc renderLayoutLine*(bitmap: ptr FT_Bitmap; line: LayoutLine;
                              x: cint; y: cint) {.
    importc: "pango_ft2_render_layout_line", libpango.}
proc renderLayoutLineSubpixel*(bitmap: ptr FT_Bitmap;
                                      line: LayoutLine; x: cint; y: cint) {.
    importc: "pango_ft2_render_layout_line_subpixel", libpango.}
proc renderLayout*(bitmap: ptr FT_Bitmap; layout: Layout; x: cint;
                          y: cint) {.importc: "pango_ft2_render_layout", libpango.}
proc renderLayoutSubpixel*(bitmap: ptr FT_Bitmap; layout: Layout;
                                  x: cint; y: cint) {.
    importc: "pango_ft2_render_layout_subpixel", libpango.}
proc fontMapGetType*(): GType {.importc: "pango_ft2_font_map_get_type",
                                     libpango.}
proc fontMapNew*(): FontMap {.importc: "pango_ft2_font_map_new",
    libpango.}
proc fontMapSetResolution*(fontmap: FT2FontMap; dpiX: cdouble;
                                  dpiY: cdouble) {.
    importc: "pango_ft2_font_map_set_resolution", libpango.}
proc fontMapSetDefaultSubstitute*(fontmap: FT2FontMap;
    `func`: FT2SubstituteFunc; data: Gpointer; notify: GDestroyNotify) {.
    importc: "pango_ft2_font_map_set_default_substitute", libpango.}
proc fontMapSubstituteChanged*(fontmap: FT2FontMap) {.
    importc: "pango_ft2_font_map_substitute_changed", libpango.}

