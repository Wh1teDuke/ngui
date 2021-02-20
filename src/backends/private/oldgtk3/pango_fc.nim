{.deadCodeElim: on.}
import pango except fontGetType, fontMapGetType
from glib import Gpointer, GSList, Gunichar, Gconstpointer, Gboolean, GDestroyNotify
from gobject import GType, GObjectObj, GObjectClassObj
{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}
type
  FT_Face = ptr object # dummy objects!
  FcPattern = object
  FcConfig = object
  FcCharSet = object

when defined(COMPILATION):
when defined(COMPILATION):
type
  FcFont* =  ptr FcFontObj
  FcFontPtr* = ptr FcFontObj
  FcFontObj*{.final.} = object of FontObj
    fontPattern*: ptr FcPattern
    fontmap*: FontMap
    priv*: Gpointer
    matrix*: MatrixObj
    description*: FontDescription
    metricsByLang*: glib.GSList
    isHinted* {.bitsize: 1.}: cuint
    isTransformed* {.bitsize: 1.}: cuint

  FcFontClass* =  ptr FcFontClassObj
  FcFontClassPtr* = ptr FcFontClassObj
  FcFontClassObj*{.final.} = object of FontClassObj
    lockFace*: proc (font: FcFont): FT_Face {.cdecl.}
    unlockFace*: proc (font: FcFont) {.cdecl.}
    hasChar*: proc (font: FcFont; wc: Gunichar): Gboolean {.cdecl.}
    getGlyph*: proc (font: FcFont; wc: Gunichar): cuint {.cdecl.}
    getUnknownGlyph*: proc (font: FcFont; wc: Gunichar): Glyph {.cdecl.}
    shutdown*: proc (font: FcFont) {.cdecl.}
    pangoReserved1*: proc () {.cdecl.}
    pangoReserved2*: proc () {.cdecl.}
    pangoReserved3*: proc () {.cdecl.}
    pangoReserved4*: proc () {.cdecl.}

template pangoTypeFcFont*(): untyped =
  (fcFontGetType())

template pangoFcFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFcFont, FcFontObj))

template pangoIsFcFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFcFont))

when (ENABLE_ENGINE) or (ENABLE_BACKEND):
  const
    RENDER_TYPE_FC* = "RenderFc"
  when (ENABLE_BACKEND):
    template pangoFcFontClass*(klass: untyped): untyped =
      (gTypeCheckClassCast(klass, pangoTypeFcFont, FcFontClassObj))

    template pangoIsFcFontClass*(klass: untyped): untyped =
      (gTypeCheckClassType(klass, pangoTypeFcFont))

    template pangoFcFontGetClass*(obj: untyped): untyped =
      (gTypeInstanceGetClass(obj, pangoTypeFcFont, FcFontClassObj))

  proc hasChar*(font: FcFont; wc: Gunichar): Gboolean {.
      importc: "pango_fc_font_has_char", libpango.}
  proc getGlyph*(font: FcFont; wc: Gunichar): cuint {.
      importc: "pango_fc_font_get_glyph", libpango.}
  proc glyph*(font: FcFont; wc: Gunichar): cuint {.
      importc: "pango_fc_font_get_glyph", libpango.}
proc fontGetType*(): GType {.importc: "pango_fc_font_get_type", libpango.}
proc lockFace*(font: FcFont): FT_Face {.
    importc: "pango_fc_font_lock_face", libpango.}
proc unlockFace*(font: FcFont) {.
    importc: "pango_fc_font_unlock_face", libpango.}

type
  FcDecoder* =  ptr FcDecoderObj
  FcDecoderPtr* = ptr FcDecoderObj
  FcDecoderObj*{.final.} = object of GObjectObj

  FcDecoderClass* =  ptr FcDecoderClassObj
  FcDecoderClassPtr* = ptr FcDecoderClassObj
  FcDecoderClassObj*{.final.} = object of GObjectClassObj
    getCharset*: proc (decoder: FcDecoder; fcfont: FcFont): ptr FcCharSet {.cdecl.}
    getGlyph*: proc (decoder: FcDecoder; fcfont: FcFont; wc: uint32): Glyph {.cdecl.}
    pangoReserved1*: proc () {.cdecl.}
    pangoReserved2*: proc () {.cdecl.}
    pangoReserved3*: proc () {.cdecl.}
    pangoReserved4*: proc () {.cdecl.}

template pangoTypeFcDecoder*(): untyped =
  (fcDecoderGetType())

template pangoFcDecoder*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFcDecoder, FcDecoderObj))

template pangoIsFcDecoder*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFcDecoder))

template pangoFcDecoderClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, pangoTypeFcDecoder, FcDecoderClassObj))

template pangoIsFcDecoderClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, pangoTypeFcDecoder))

template pangoFcDecoderGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, pangoTypeFcDecoder, FcDecoderClassObj))

proc decoderGetType*(): GType {.importc: "pango_fc_decoder_get_type",
                                    libpango.}
proc getCharset*(decoder: FcDecoder; fcfont: FcFont): ptr FcCharSet {.
    importc: "pango_fc_decoder_get_charset", libpango.}
proc charset*(decoder: FcDecoder; fcfont: FcFont): ptr FcCharSet {.
    importc: "pango_fc_decoder_get_charset", libpango.}
proc getGlyph*(decoder: FcDecoder; fcfont: FcFont;
                            wc: uint32): Glyph {.
    importc: "pango_fc_decoder_get_glyph", libpango.}
proc glyph*(decoder: FcDecoder; fcfont: FcFont;
                            wc: uint32): Glyph {.
    importc: "pango_fc_decoder_get_glyph", libpango.}

when (ENABLE_BACKEND):
  type
    FcFontsetKey* =  ptr FcFontsetKeyObj
    FcFontsetKeyPtr* = ptr FcFontsetKeyObj
    FcFontsetKeyObj* = object

  proc getLanguage*(key: FcFontsetKey): Language {.
      importc: "pango_fc_fontset_key_get_language", libpango.}

  proc language*(key: FcFontsetKey): Language {.
      importc: "pango_fc_fontset_key_get_language", libpango.}
  proc getDescription*(key: FcFontsetKey): FontDescription {.
      importc: "pango_fc_fontset_key_get_description", libpango.}
  proc description*(key: FcFontsetKey): FontDescription {.
      importc: "pango_fc_fontset_key_get_description", libpango.}
  proc getMatrix*(key: FcFontsetKey): Matrix {.
      importc: "pango_fc_fontset_key_get_matrix", libpango.}
  proc matrix*(key: FcFontsetKey): Matrix {.
      importc: "pango_fc_fontset_key_get_matrix", libpango.}
  proc getAbsoluteSize*(key: FcFontsetKey): cdouble {.
      importc: "pango_fc_fontset_key_get_absolute_size", libpango.}
  proc absoluteSize*(key: FcFontsetKey): cdouble {.
      importc: "pango_fc_fontset_key_get_absolute_size", libpango.}
  proc getResolution*(key: FcFontsetKey): cdouble {.
      importc: "pango_fc_fontset_key_get_resolution", libpango.}
  proc resolution*(key: FcFontsetKey): cdouble {.
      importc: "pango_fc_fontset_key_get_resolution", libpango.}
  proc getContextKey*(key: FcFontsetKey): Gpointer {.
      importc: "pango_fc_fontset_key_get_context_key", libpango.}
  proc contextKey*(key: FcFontsetKey): Gpointer {.
      importc: "pango_fc_fontset_key_get_context_key", libpango.}
  type
    FcFontKey* =  ptr FcFontKeyObj
    FcFontKeyPtr* = ptr FcFontKeyObj
    FcFontKeyObj* = object

  proc getPattern*(key: FcFontKey): ptr FcPattern {.
      importc: "pango_fc_font_key_get_pattern", libpango.}

  proc pattern*(key: FcFontKey): ptr FcPattern {.
      importc: "pango_fc_font_key_get_pattern", libpango.}
  proc getMatrix*(key: FcFontKey): Matrix {.
      importc: "pango_fc_font_key_get_matrix", libpango.}
  proc matrix*(key: FcFontKey): Matrix {.
      importc: "pango_fc_font_key_get_matrix", libpango.}
  proc getContextKey*(key: FcFontKey): Gpointer {.
      importc: "pango_fc_font_key_get_context_key", libpango.}
  proc contextKey*(key: FcFontKey): Gpointer {.
      importc: "pango_fc_font_key_get_context_key", libpango.}
type
  FcFontMapPrivateObj = object

  FcFontMap* =  ptr FcFontMapObj
  FcFontMapPtr* = ptr FcFontMapObj
  FcFontMapObj*{.final.} = object of FontMapObj
    priv*: ptr FcFontMapPrivateObj

  FcFontMapClass* =  ptr FcFontMapClassObj
  FcFontMapClassPtr* = ptr FcFontMapClassObj
  FcFontMapClassObj*{.final.} = object of FontMapClassObj
    defaultSubstitute*: proc (fontmap: FcFontMap; pattern: ptr FcPattern) {.cdecl.}
    newFont*: proc (fontmap: FcFontMap; pattern: ptr FcPattern): FcFont {.cdecl.}
    getResolution*: proc (fcfontmap: FcFontMap; context: Context): cdouble {.cdecl.}
    contextKeyGet*: proc (fcfontmap: FcFontMap; context: Context): Gconstpointer {.cdecl.}
    contextKeyCopy*: proc (fcfontmap: FcFontMap; key: Gconstpointer): Gpointer {.cdecl.}
    contextKeyFree*: proc (fcfontmap: FcFontMap; key: Gpointer) {.cdecl.}
    contextKeyHash*: proc (fcfontmap: FcFontMap; key: Gconstpointer): uint32 {.cdecl.}
    contextKeyEqual*: proc (fcfontmap: FcFontMap; keyA: Gconstpointer;
                          keyB: Gconstpointer): Gboolean {.cdecl.}
    fontsetKeySubstitute*: proc (fontmap: FcFontMap;
                               fontsetkey: FcFontsetKey;
                               pattern: ptr FcPattern) {.cdecl.}
    createFont*: proc (fontmap: FcFontMap; fontkey: FcFontKey): FcFont {.cdecl.}
    pangoReserved1*: proc () {.cdecl.}
    pangoReserved2*: proc () {.cdecl.}
    pangoReserved3*: proc () {.cdecl.}
    pangoReserved4*: proc () {.cdecl.}

template pangoTypeFcFontMap*(): untyped =
  (fcFontMapGetType())

template pangoFcFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFcFontMap, FcFontMapObj))

template pangoIsFcFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFcFontMap))

when (ENABLE_BACKEND):
  template pangoFcFontMapClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeFcFontMap, FcFontMapClassObj))

  template pangoIsFcFontMapClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeFcFontMap))

  template pangoFcFontMapGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeFcFontMap, FcFontMapClassObj))

  proc shutdown*(fcfontmap: FcFontMap) {.
      importc: "pango_fc_font_map_shutdown", libpango.}
proc fontMapGetType*(): GType {.importc: "pango_fc_font_map_get_type",
                                    libpango.}
proc cacheClear*(fcfontmap: FcFontMap) {.
    importc: "pango_fc_font_map_cache_clear", libpango.}
proc configChanged*(fcfontmap: FcFontMap) {.
    importc: "pango_fc_font_map_config_changed", libpango.}
proc setConfig*(fcfontmap: FcFontMap; fcconfig: ptr FcConfig) {.
    importc: "pango_fc_font_map_set_config", libpango.}
proc `config=`*(fcfontmap: FcFontMap; fcconfig: ptr FcConfig) {.
    importc: "pango_fc_font_map_set_config", libpango.}
proc getConfig*(fcfontmap: FcFontMap): ptr FcConfig {.
    importc: "pango_fc_font_map_get_config", libpango.}
proc config*(fcfontmap: FcFontMap): ptr FcConfig {.
    importc: "pango_fc_font_map_get_config", libpango.}

type
  FcDecoderFindFunc* = proc (pattern: ptr FcPattern; userData: Gpointer): FcDecoder {.cdecl.}

proc addDecoderFindFunc*(fcfontmap: FcFontMap;
                                      findfunc: FcDecoderFindFunc;
                                      userData: Gpointer; dnotify: GDestroyNotify) {.
    importc: "pango_fc_font_map_add_decoder_find_func", libpango.}
proc findDecoder*(fcfontmap: FcFontMap;
                               pattern: ptr FcPattern): FcDecoder {.
    importc: "pango_fc_font_map_find_decoder", libpango.}
proc fontDescriptionFromPattern*(pattern: ptr FcPattern;
                                       includeSize: Gboolean): FontDescription {.
    importc: "pango_fc_font_description_from_pattern", libpango.}

const
  FC_GRAVITY* = "pangogravity"

const
  FC_VERSION* = "pangoversion"

const
  FC_PRGNAME* = "prgname"

const
  FC_FONT_FEATURES* = "fontfeatures"

