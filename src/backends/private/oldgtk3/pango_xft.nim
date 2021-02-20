{.deadCodeElim: on.}
import pango except fontGetType, fontMapGetType, rendererGetType
from glib import Gboolean, Gpointer, Gunichar, GDestroyNotify
from gobject import GType
from xlib import PDisplay

when defined(windows): 
  const LIB_PANGO_XFT* = "libpangoxft-1.0-0.dll"
elif defined(macosx):
  const LIB_PANGO_XFT* = "libpangoxft-1.0.dylib"
else: 
  const LIB_PANGO_XFT* = "libpangoxft-1.0.so.0"

{.pragma: libpango, cdecl, dynlib: LIB_PANGO_XFT.}

type
  Picture = ptr object # dummy objects!
  FcPattern = object
  FT_Face = ptr object
  XftDraw = object
  XTrapezoid = object
  XftGlyphSpec = object
  XftFont = object
  XftColor = object

const
  XFT_NO_COMPAT* = true

type
  XftRendererPrivateObj = object

  XftRenderer* =  ptr XftRendererObj
  XftRendererPtr* = ptr XftRendererObj
  XftRendererObj*{.final.} = object of RendererObj
    display*: PDisplay
    screen*: cint
    draw*: ptr XftDraw
    priv0*: ptr XftRendererPrivateObj

  XftRendererClass* =  ptr XftRendererClassObj
  XftRendererClassPtr* = ptr XftRendererClassObj
  XftRendererClassObj*{.final.} = object of RendererClassObj
    compositeTrapezoids*: proc (xftrenderer: XftRenderer;
                              part: RenderPart; trapezoids: ptr XTrapezoid;
                              nTrapezoids: cint) {.cdecl.}
    compositeGlyphs*: proc (xftrenderer: XftRenderer; xftFont: ptr XftFont;
                          glyphs: ptr XftGlyphSpec; nGlyphs: cint) {.cdecl.}

template pangoTypeXftRenderer*(): untyped =
  (xftRendererGetType())

template pangoXftRenderer*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeXftRenderer, XftRendererObj))

template pangoIsXftRenderer*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeXftRenderer))

template pangoXftRendererClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, pangoTypeXftRenderer, XftRendererClassObj))

template pangoIsXftRendererClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, pangoTypeXftRenderer))

template pangoXftRendererGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, pangoTypeXftRenderer, XftRendererClassObj))

proc rendererGetType*(): GType {.importc: "pango_xft_renderer_get_type",
                                      libpango.}
proc rendererNew*(display: PDisplay; screen: cint): Renderer {.
    importc: "pango_xft_renderer_new", libpango.}
proc setDraw*(xftrenderer: XftRenderer; draw: ptr XftDraw) {.
    importc: "pango_xft_renderer_set_draw", libpango.}
proc `draw=`*(xftrenderer: XftRenderer; draw: ptr XftDraw) {.
    importc: "pango_xft_renderer_set_draw", libpango.}
proc setDefaultColor*(xftrenderer: XftRenderer;
                                     defaultColor: Color) {.
    importc: "pango_xft_renderer_set_default_color", libpango.}
proc `defaultColor=`*(xftrenderer: XftRenderer;
                                     defaultColor: Color) {.
    importc: "pango_xft_renderer_set_default_color", libpango.}
proc render*(draw: ptr XftDraw; color: ptr XftColor; font: Font;
                    glyphs: GlyphString; x: cint; y: cint) {.
    importc: "pango_xft_render", libpango.}
proc pictureRender*(display: PDisplay; srcPicture: Picture;
                           destPicture: Picture; font: Font;
                           glyphs: GlyphString; x: cint; y: cint) {.
    importc: "pango_xft_picture_render", libpango.}
proc renderTransformed*(draw: ptr XftDraw; color: ptr XftColor;
                               matrix: Matrix; font: Font;
                               glyphs: GlyphString; x: cint; y: cint) {.
    importc: "pango_xft_render_transformed", libpango.}
proc renderLayoutLine*(draw: ptr XftDraw; color: ptr XftColor;
                              line: LayoutLine; x: cint; y: cint) {.
    importc: "pango_xft_render_layout_line", libpango.}
proc renderLayout*(draw: ptr XftDraw; color: ptr XftColor;
                          layout: Layout; x: cint; y: cint) {.
    importc: "pango_xft_render_layout", libpango.}

template pangoTypeXftFontMap*(): untyped =
  (xftFontMapGetType())

template pangoXftFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeXftFontMap, XftFontMap))

template pangoXftIsFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeXftFontMap))

type
  PangoXftFont* =  ptr PangoXftFontObj
  PangoXftFontPtr* = ptr PangoXftFontObj
  PangoXftFontObj* = object

type
  XftSubstituteFunc* = proc (pattern: ptr FcPattern; data: Gpointer) {.cdecl.}

proc getFontMap*(display: PDisplay; screen: cint): FontMap {.
    importc: "pango_xft_get_font_map", libpango.}
proc shutdownDisplay*(display: PDisplay; screen: cint) {.
    importc: "pango_xft_shutdown_display", libpango.}
proc setDefaultSubstitute*(display: PDisplay; screen: cint;
                                  `func`: XftSubstituteFunc; data: Gpointer;
                                  notify: GDestroyNotify) {.
    importc: "pango_xft_set_default_substitute", libpango.}
proc substituteChanged*(display: PDisplay; screen: cint) {.
    importc: "pango_xft_substitute_changed", libpango.}
proc fontMapGetType*(): GType {.importc: "pango_xft_font_map_get_type",
                                     libpango.}
template pangoXftFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeXftFont, PangoXftFontObj))

template pangoTypeXftFont*(): untyped =
  (xftFontGetType())

template pangoXftIsFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeXftFont))

proc fontGetType*(): GType {.importc: "pango_xft_font_get_type", libpango.}

when (ENABLE_ENGINE):
  proc getFont*(font: Font): ptr XftFont {.
      importc: "pango_xft_font_get_font", libpango.}
  proc getDisplay*(font: Font): PDisplay {.
      importc: "pango_xft_font_get_display", libpango.}
