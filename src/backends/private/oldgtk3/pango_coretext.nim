{.deadCodeElim: on.}
import pango except fontGetType, fontMapGetType
from glib import GHashTable, Gpointer, Gconstpointer, Gboolean
from gobject import GType
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  CTFontRef = ptr object # dummy objects!
  CTFontDescriptorRef = ptr object

type
  CoreTextFontClass* =  ptr CoreTextFontClassObj
  CoreTextFontClassPtr* = ptr CoreTextFontClassObj
  CoreTextFontClassObj*{.final.} = object of FontClassObj
    pangoReserved1*: proc () {.cdecl.}
    pangoReserved2*: proc () {.cdecl.}
    pangoReserved3*: proc () {.cdecl.}
    pangoReserved4*: proc () {.cdecl.}

  CoreTextFontPrivateObj = object

  CoreTextFont* =  ptr CoreTextFontObj
  CoreTextFontPtr* = ptr CoreTextFontObj
  CoreTextFontObj*{.final.} = object of FontObj
    priv*: ptr CoreTextFontPrivateObj

template pangoTypeCoreTextFont*(): untyped =
  (coreTextFontGetType())

template pangoCoreTextFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeCoreTextFont, CoreTextFontObj))

template pangoIsCoreTextFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeCoreTextFont))

when (ENABLE_ENGINE) or (ENABLE_BACKEND):
  const
    RENDER_TYPE_CORE_TEXT* = "RenderCoreText"
  when (ENABLE_BACKEND):
    template pangoCoreTextFontClass*(klass: untyped): untyped =
      (gTypeCheckClassCast(klass, pangoTypeCoreTextFont, CoreTextFontClassObj))

    template pangoIsCoreTextFontClass*(klass: untyped): untyped =
      (gTypeCheckClassType(klass, pangoTypeCoreTextFont))

    template pangoCoreTextFontGetClass*(obj: untyped): untyped =
      (gTypeInstanceGetClass(obj, pangoTypeCoreTextFont, CoreTextFontClassObj))

  proc getCtfont*(font: CoreTextFont): CTFontRef {.
      importc: "pango_core_text_font_get_ctfont", libpango.}

  proc ctfont*(font: CoreTextFont): CTFontRef {.
      importc: "pango_core_text_font_get_ctfont", libpango.}
proc coreTextFontGetType*(): GType {.importc: "pango_core_text_font_get_type",
                                       libpango.}

type
  CoreTextFontMap* =  ptr CoreTextFontMapObj
  CoreTextFontMapPtr* = ptr CoreTextFontMapObj
  CoreTextFontMapObj* = object of FontMapObj
    serial0*: cuint
    fontsetHash*: glib.GHashTable
    fontHash*: glib.GHashTable
    families*: glib.GHashTable

  CoreTextFontKey* =  ptr CoreTextFontKeyObj
  CoreTextFontKeyPtr* = ptr CoreTextFontKeyObj
  CoreTextFontKeyObj* = object

  CoreTextFontMapClass* =  ptr CoreTextFontMapClassObj
  CoreTextFontMapClassPtr* = ptr CoreTextFontMapClassObj
  CoreTextFontMapClassObj*{.final.} = object of FontMapClassObj
    contextKeyGet*: proc (ctfontmap: CoreTextFontMap;
                        context: Context): Gconstpointer {.cdecl.}
    contextKeyCopy*: proc (ctfontmap: CoreTextFontMap; key: Gconstpointer): Gpointer {.cdecl.}
    contextKeyFree*: proc (ctfontmap: CoreTextFontMap; key: Gpointer) {.cdecl.}
    contextKeyHash*: proc (ctfontmap: CoreTextFontMap; key: Gconstpointer): uint32 {.cdecl.}
    contextKeyEqual*: proc (ctfontmap: CoreTextFontMap; keyA: Gconstpointer;
                          keyB: Gconstpointer): Gboolean {.cdecl.}
    createFont*: proc (fontmap: CoreTextFontMap;
                     key: CoreTextFontKey): CoreTextFont {.cdecl.}
    getResolution*: proc (fontmap: CoreTextFontMap;
                        context: Context): cdouble {.cdecl.}

template pangoTypeCoreTextFontMap*(): untyped =
  (coreTextFontMapGetType())

template pangoCoreTextFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeCoreTextFontMap, CoreTextFontMapObj))

template pangoCoreTextIsFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeCoreTextFontMap))

template pangoCoreTextFontMapClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, pangoTypeCoreTextFontMap, CoreTextFontMapClassObj))

template pangoIsCoreTextFontMapClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, pangoTypeCoreTextFontMap))

template pangoCoreTextFontMapGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, pangoTypeCoreTextFontMap, CoreTextFontMapClassObj))

type
  CoreTextFace* =  ptr CoreTextFaceObj
  CoreTextFacePtr* = ptr CoreTextFaceObj
  CoreTextFaceObj* = object

proc coreTextFontMapGetType*(): GType {.
    importc: "pango_core_text_font_map_get_type", libpango.}
proc setFontMap*(afont: CoreTextFont;
                                 fontmap: CoreTextFontMap) {.
    importc: "_pango_core_text_font_set_font_map", libpango.}
proc `fontMap=`*(afont: CoreTextFont;
                                 fontmap: CoreTextFontMap) {.
    importc: "_pango_core_text_font_set_font_map", libpango.}
proc setFace*(afont: CoreTextFont;
                              aface: CoreTextFace) {.
    importc: "_pango_core_text_font_set_face", libpango.}
proc `face=`*(afont: CoreTextFont;
                              aface: CoreTextFace) {.
    importc: "_pango_core_text_font_set_face", libpango.}
proc getFace*(font: CoreTextFont): CoreTextFace {.
    importc: "_pango_core_text_font_get_face", libpango.}
proc face*(font: CoreTextFont): CoreTextFace {.
    importc: "_pango_core_text_font_get_face", libpango.}
proc getContextKey*(afont: CoreTextFont): Gpointer {.
    importc: "_pango_core_text_font_get_context_key", libpango.}
proc contextKey*(afont: CoreTextFont): Gpointer {.
    importc: "_pango_core_text_font_get_context_key", libpango.}
proc setContextKey*(afont: CoreTextFont;
                                    contextKey: Gpointer) {.
    importc: "_pango_core_text_font_set_context_key", libpango.}
proc `contextKey=`*(afont: CoreTextFont;
                                    contextKey: Gpointer) {.
    importc: "_pango_core_text_font_set_context_key", libpango.}
proc setFontKey*(font: CoreTextFont;
                                 key: CoreTextFontKey) {.
    importc: "_pango_core_text_font_set_font_key", libpango.}
proc `fontKey=`*(font: CoreTextFont;
                                 key: CoreTextFontKey) {.
    importc: "_pango_core_text_font_set_font_key", libpango.}
proc setCtfont*(font: CoreTextFont; fontRef: CTFontRef) {.
    importc: "_pango_core_text_font_set_ctfont", libpango.}
proc `ctfont=`*(font: CoreTextFont; fontRef: CTFontRef) {.
    importc: "_pango_core_text_font_set_ctfont", libpango.}
proc coreTextFontDescriptionFromCtFontDescriptor*(desc: CTFontDescriptorRef): FontDescription {.
    importc: "_pango_core_text_font_description_from_ct_font_descriptor",
    libpango.}
proc getAbsoluteSize*(key: CoreTextFontKey): cint {.
    importc: "pango_core_text_font_key_get_absolute_size", libpango.}
proc absoluteSize*(key: CoreTextFontKey): cint {.
    importc: "pango_core_text_font_key_get_absolute_size", libpango.}
proc getResolution*(key: CoreTextFontKey): cdouble {.
    importc: "pango_core_text_font_key_get_resolution", libpango.}
proc resolution*(key: CoreTextFontKey): cdouble {.
    importc: "pango_core_text_font_key_get_resolution", libpango.}
proc getSyntheticItalic*(key: CoreTextFontKey): Gboolean {.
    importc: "pango_core_text_font_key_get_synthetic_italic", libpango.}
proc syntheticItalic*(key: CoreTextFontKey): Gboolean {.
    importc: "pango_core_text_font_key_get_synthetic_italic", libpango.}
proc getContextKey*(key: CoreTextFontKey): Gpointer {.
    importc: "pango_core_text_font_key_get_context_key", libpango.}
proc contextKey*(key: CoreTextFontKey): Gpointer {.
    importc: "pango_core_text_font_key_get_context_key", libpango.}
proc getMatrix*(key: CoreTextFontKey): Matrix {.
    importc: "pango_core_text_font_key_get_matrix", libpango.}
proc matrix*(key: CoreTextFontKey): Matrix {.
    importc: "pango_core_text_font_key_get_matrix", libpango.}
proc getGravity*(key: CoreTextFontKey): Gravity {.
    importc: "pango_core_text_font_key_get_gravity", libpango.}
proc gravity*(key: CoreTextFontKey): Gravity {.
    importc: "pango_core_text_font_key_get_gravity", libpango.}
proc getCtfontdescriptor*(key: CoreTextFontKey): CTFontDescriptorRef {.
    importc: "pango_core_text_font_key_get_ctfontdescriptor", libpango.}
proc ctfontdescriptor*(key: CoreTextFontKey): CTFontDescriptorRef {.
    importc: "pango_core_text_font_key_get_ctfontdescriptor", libpango.}
proc coreTextShape*(font: Font; text: cstring; length: cint;
                        analysis: Analysis; glyphs: GlyphString;
                        paragraphText: cstring; paragraphLength: cuint) {.
    importc: "_pango_core_text_shape", libpango.}

type
  CairoCoreTextFontMap* =  ptr CairoCoreTextFontMapObj
  CairoCoreTextFontMapPtr* = ptr CairoCoreTextFontMapObj
  CairoCoreTextFontMapObj*{.final.} = object of CoreTextFontMapObj
    serial*: cuint
    dpi*: cdouble

template pangoTypeCairoCoreTextFontMap*(): untyped =
  (cairoCoreTextFontMapGetType())

template pangoCairoCoreTextFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeCairoCoreTextFontMap, CairoCoreTextFontMapObj))

template pangoIsCairoCoreTextFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeCairoCoreTextFontMap))

proc cairoCoreTextFontMapGetType*(): GType {.
    importc: "pango_cairo_core_text_font_map_get_type", libpango.}
proc cairoCoreTextFontNew*(cafontmap: CairoCoreTextFontMap;
                               key: CoreTextFontKey): CoreTextFont {.
    importc: "_pango_cairo_core_text_font_new", libpango.}
