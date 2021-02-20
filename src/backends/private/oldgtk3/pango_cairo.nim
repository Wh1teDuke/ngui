{.deadCodeElim: on.}
import pango except fontGetType, fontMapGetType
from cairo import Context, Font_type, Font_options, Scaled_Font
from glib import Gboolean, Gpointer, GDestroyNotify
from gobject import GType

when defined(windows): 
  const LIB_PANGO_CAIRO* = "libpangocairo-1.0-0.dll"
elif defined(macosx):
  const LIB_PANGO_CAIRO* = "libpangocairo-1.0.dylib"
else: 
  const LIB_PANGO_CAIRO* = "libpangocairo-1.0.so.0"

{.pragma: libpango, cdecl, dynlib: LIB_PANGO_CAIRO.}

type
  CairoFont* =  ptr CairoFontObj
  CairoFontPtr* = ptr CairoFontObj
  CairoFontObj* = object

template pangoTypeCairoFont*(): untyped =
  (cairoFontGetType())

template pangoCairoFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeCairoFont, CairoFontObj))

template pangoIsCairoFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeCairoFont))

type
  CairoFontMap* =  ptr CairoFontMapObj
  CairoFontMapPtr* = ptr CairoFontMapObj
  CairoFontMapObj* = object

template pangoTypeCairoFontMap*(): untyped =
  (cairoFontMapGetType())

template pangoCairoFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeCairoFontMap, CairoFontMapObj))

template pangoIsCairoFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeCairoFontMap))

type
  CairoShapeRendererFunc* = proc (cr: cairo.Context; attr: AttrShape;
                                    doPath: Gboolean; data: Gpointer) {.cdecl.}

proc fontMapGetType*(): GType {.importc: "pango_cairo_font_map_get_type",
                                       libpango.}
proc fontMapNew*(): FontMap {.
    importc: "pango_cairo_font_map_new", libpango.}
proc fontMapNewForFontType*(fonttype: cairo.FontType): FontMap {.
    importc: "pango_cairo_font_map_new_for_font_type", libpango.}
proc fontMapGetDefault*(): FontMap {.
    importc: "pango_cairo_font_map_get_default", libpango.}
proc setDefault*(fontmap: CairoFontMap) {.
    importc: "pango_cairo_font_map_set_default", libpango.}
proc `default=`*(fontmap: CairoFontMap) {.
    importc: "pango_cairo_font_map_set_default", libpango.}
proc getFontType*(fontmap: CairoFontMap): cairo.FontType {.
    importc: "pango_cairo_font_map_get_font_type", libpango.}
proc fontType*(fontmap: CairoFontMap): cairo.FontType {.
    importc: "pango_cairo_font_map_get_font_type", libpango.}
proc setResolution*(fontmap: CairoFontMap; dpi: cdouble) {.
    importc: "pango_cairo_font_map_set_resolution", libpango.}
proc `resolution=`*(fontmap: CairoFontMap; dpi: cdouble) {.
    importc: "pango_cairo_font_map_set_resolution", libpango.}
proc getResolution*(fontmap: CairoFontMap): cdouble {.
    importc: "pango_cairo_font_map_get_resolution", libpango.}
proc resolution*(fontmap: CairoFontMap): cdouble {.
    importc: "pango_cairo_font_map_get_resolution", libpango.}

proc fontGetType*(): GType {.importc: "pango_cairo_font_get_type",
                                    libpango.}
proc getScaledFont*(font: CairoFont): cairo.ScaledFont {.
    importc: "pango_cairo_font_get_scaled_font", libpango.}
proc scaledFont*(font: CairoFont): cairo.ScaledFont {.
    importc: "pango_cairo_font_get_scaled_font", libpango.}

proc updateContext*(cr: cairo.Context; context: pango.Context) {.
    importc: "pango_cairo_update_context", libpango.}
proc setFontOptions*(context: pango.Context;
                                     options: cairo.FontOptions) {.
    importc: "pango_cairo_context_set_font_options", libpango.}
proc getFontOptions*(context: pango.Context): cairo.FontOptions {.
    importc: "pango_cairo_context_get_font_options", libpango.}
proc setResolution*(context: pango.Context; dpi: cdouble) {.
    importc: "pango_cairo_context_set_resolution", libpango.}
proc getResolution*(context: pango.Context): cdouble {.
    importc: "pango_cairo_context_get_resolution", libpango.}
proc setShapeRenderer*(context: pango.Context;
                                       `func`: CairoShapeRendererFunc;
                                       data: Gpointer; dnotify: GDestroyNotify) {.
    importc: "pango_cairo_context_set_shape_renderer", libpango.}
proc getShapeRenderer*(context: pango.Context;
                                       data: var Gpointer): CairoShapeRendererFunc {.
    importc: "pango_cairo_context_get_shape_renderer", libpango.}

proc createContext*(cr: cairo.Context): pango.Context {.
    importc: "pango_cairo_create_context", libpango.}
proc createLayout*(cr: cairo.Context): Layout {.
    importc: "pango_cairo_create_layout", libpango.}
proc updateLayout*(cr: cairo.Context; layout: Layout) {.
    importc: "pango_cairo_update_layout", libpango.}

proc showGlyphString*(cr: cairo.Context; font: Font;
                               glyphs: GlyphString) {.
    importc: "pango_cairo_show_glyph_string", libpango.}
proc showGlyphItem*(cr: cairo.Context; text: cstring;
                             glyphItem: GlyphItem) {.
    importc: "pango_cairo_show_glyph_item", libpango.}
proc showLayoutLine*(cr: cairo.Context; line: LayoutLine) {.
    importc: "pango_cairo_show_layout_line", libpango.}
proc showLayout*(cr: cairo.Context; layout: Layout) {.
    importc: "pango_cairo_show_layout", libpango.}
proc showErrorUnderline*(cr: cairo.Context; x: cdouble; y: cdouble;
                                  width: cdouble; height: cdouble) {.
    importc: "pango_cairo_show_error_underline", libpango.}

proc glyphStringPath*(cr: cairo.Context; font: Font;
                               glyphs: GlyphString) {.
    importc: "pango_cairo_glyph_string_path", libpango.}
proc layoutLinePath*(cr: cairo.Context; line: LayoutLine) {.
    importc: "pango_cairo_layout_line_path", libpango.}
proc layoutPath*(cr: cairo.Context; layout: Layout) {.
    importc: "pango_cairo_layout_path", libpango.}
proc errorUnderlinePath*(cr: cairo.Context; x: cdouble; y: cdouble;
                                  width: cdouble; height: cdouble) {.
    importc: "pango_cairo_error_underline_path", libpango.}
