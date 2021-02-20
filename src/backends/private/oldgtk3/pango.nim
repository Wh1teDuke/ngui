{.deadCodeElim: on.}

# Note: Not all pango C macros are available in Nim yet.
# Some are converted by c2nim to templates, some manually to procs.
# Most of these should be not necessary for Nim programmers.
# We may have to add more and to test and fix some, or remove unnecessary ones completely...
# pango-color-table.h and pango-script-lang-table.h is currently not included.

from glib import Gunichar,
  Gboolean, Gpointer, Gconstpointer, GList, GSList, GString, GError, GDestroyNotify, GMarkupParseContext, G_MAXUINT

from gobject import GObjectObj, GObjectClassObj, GType, GTypeModule,
  gTypeCheckClassType, gTypeCheckClassCast, gTypeCheckInstanceCast, gTypeCheckInstanceType

when defined(windows):
  const LIB_PANGO* = "libpango-1.0-0.dll"
elif defined(macosx):
  const LIB_PANGO* = "libpango-1.0.dylib"
else:
  const LIB_PANGO* = "libpango-1.0.so.0"

{.pragma: libpango, cdecl, dynlib: LIB_PANGO.}

const
  DISABLE_DEPRECATED* = false
  ENABLE_BACKEND* = true
  ENABLE_ENGINE* = true

const
  VERSION_MAJOR* = 1
  VERSION_MINOR* = 40
  VERSION_MICRO* = 7
  VERSION_STRING* = "1.40.7"

type
  Coverage* =  ptr CoverageObj
  CoveragePtr* = ptr CoverageObj
  CoverageObj* = object

type
  CoverageLevel* {.size: sizeof(cint), pure.} = enum
    NONE, FALLBACK, APPROXIMATE,
    EXACT

proc coverageNew*(): Coverage {.importc: "pango_coverage_new",
    libpango.}
proc `ref`*(coverage: Coverage): Coverage {.
    importc: "pango_coverage_ref", libpango.}
proc unref*(coverage: Coverage) {.
    importc: "pango_coverage_unref", libpango.}
proc copy*(coverage: Coverage): Coverage {.
    importc: "pango_coverage_copy", libpango.}
proc get*(coverage: Coverage; index: cint): CoverageLevel {.
    importc: "pango_coverage_get", libpango.}
proc set*(coverage: Coverage; index: cint;
                      level: CoverageLevel) {.importc: "pango_coverage_set",
    libpango.}
proc max*(coverage: Coverage; other: Coverage) {.
    importc: "pango_coverage_max", libpango.}
proc toBytes*(coverage: Coverage; bytes: var ptr cuchar;
                          nBytes: var cint) {.importc: "pango_coverage_to_bytes",
    libpango.}
proc coverageFromBytes*(bytes: var cuchar; nBytes: cint): Coverage {.
    importc: "pango_coverage_from_bytes", libpango.}

type
  Glyph* = uint32

const
  SCALE* = 1024

template pangoPixels*(d: untyped): untyped =
  ((int(d) + 512) shr 10)

template pangoPixelsFloor*(d: untyped): untyped =
  ((int(d)) shr 10)

template pangoPixelsCeil*(d: untyped): untyped =
  ((int(d) + 1023) shr 10)

template pangoUnitsRound*(d: untyped): untyped =
  ((d + (pango_Scale shr 1)) and not (pango_Scale - 1))

proc unitsFromDouble*(d: cdouble): cint {.importc: "pango_units_from_double",
    libpango.}
proc unitsToDouble*(i: cint): cdouble {.importc: "pango_units_to_double",
    libpango.}

type
  Rectangle* =  ptr RectangleObj
  RectanglePtr* = ptr RectangleObj
  RectangleObj* = object
    x*: cint
    y*: cint
    width*: cint
    height*: cint

template pangoAscent*(rect: untyped): untyped =
  (- (rect).y)

template pangoDescent*(rect: untyped): untyped =
  (rect.y + (rect).height)

template pangoLbearing*(rect: untyped): untyped =
  (rect.x)

template pangoRbearing*(rect: untyped): untyped =
  (rect.x + (rect).width)

proc extentsToPixels*(inclusive: Rectangle;
                          nearest: Rectangle) {.
    importc: "pango_extents_to_pixels", libpango.}

type
  Gravity* {.size: sizeof(cint), pure.} = enum
    SOUTH, EAST, NORTH,
    WEST, AUTO

type
  GravityHint* {.size: sizeof(cint), pure.} = enum
    NATURAL, STRONG, LINE

type
  Matrix* =  ptr MatrixObj
  MatrixPtr* = ptr MatrixObj
  MatrixObj* = object
    xx*: cdouble
    xy*: cdouble
    yx*: cdouble
    yy*: cdouble
    x0*: cdouble
    y0*: cdouble

template pangoGravityIsVertical*(gravity: untyped): untyped =
  (gravity == Gravity.East or (gravity) == Gravity.West)

template pangoGravityIsImproper*(gravity: untyped): untyped =
  (gravity == Gravity.West or (gravity) == Gravity.North)

proc toRotation*(gravity: Gravity): cdouble {.
    importc: "pango_gravity_to_rotation", libpango.}
proc gravityGetForMatrix*(matrix: Matrix): Gravity {.
    importc: "pango_gravity_get_for_matrix", libpango.}

template pangoTypeMatrix*(): untyped =
  (matrixGetType())

proc matrixGetType*(): GType {.importc: "pango_matrix_get_type", libpango.}
proc copy*(matrix: Matrix): Matrix {.
    importc: "pango_matrix_copy", libpango.}
proc free*(matrix: Matrix) {.importc: "pango_matrix_free",
    libpango.}
proc translate*(matrix: Matrix; tx: cdouble; ty: cdouble) {.
    importc: "pango_matrix_translate", libpango.}
proc scale*(matrix: Matrix; scaleX: cdouble; scaleY: cdouble) {.
    importc: "pango_matrix_scale", libpango.}
proc rotate*(matrix: Matrix; degrees: cdouble) {.
    importc: "pango_matrix_rotate", libpango.}
proc concat*(matrix: Matrix; newMatrix: Matrix) {.
    importc: "pango_matrix_concat", libpango.}
proc transformPoint*(matrix: Matrix; x: var cdouble; y: var cdouble) {.
    importc: "pango_matrix_transform_point", libpango.}
proc transformDistance*(matrix: Matrix; dx: var cdouble;
                                  dy: var cdouble) {.
    importc: "pango_matrix_transform_distance", libpango.}
proc transformRectangle*(matrix: Matrix;
                                   rect: Rectangle) {.
    importc: "pango_matrix_transform_rectangle", libpango.}
proc transformPixelRectangle*(matrix: Matrix;
                                        rect: Rectangle) {.
    importc: "pango_matrix_transform_pixel_rectangle", libpango.}
proc getFontScaleFactor*(matrix: Matrix): cdouble {.
    importc: "pango_matrix_get_font_scale_factor", libpango.}
proc fontScaleFactor*(matrix: Matrix): cdouble {.
    importc: "pango_matrix_get_font_scale_factor", libpango.}
proc getFontScaleFactors*(matrix: Matrix; xscale: var cdouble;
                                    yscale: var cdouble) {.
    importc: "pango_matrix_get_font_scale_factors", libpango.}

type
  ScriptIter* =  ptr ScriptIterObj
  ScriptIterPtr* = ptr ScriptIterObj
  ScriptIterObj* = object

type
  Script* {.size: sizeof(cint), pure.} = enum
    INVALID_CODE = - 1, COMMON = 0, INHERITED,
    ARABIC, ARMENIAN, BENGALI,
    BOPOMOFO, CHEROKEE, COPTIC,
    CYRILLIC, DESERET, DEVANAGARI,
    ETHIOPIC, GEORGIAN, GOTHIC,
    GREEK, GUJARATI, GURMUKHI,
    HAN, HANGUL, HEBREW,
    HIRAGANA, KANNADA, KATAKANA,
    KHMER, LAO, LATIN,
    MALAYALAM, MONGOLIAN, MYANMAR,
    OGHAM, OLD_ITALIC, ORIYA,
    RUNIC, SINHALA, SYRIAC,
    TAMIL, TELUGU, THAANA,
    THAI, TIBETAN, CANADIAN_ABORIGINAL,
    YI, TAGALOG, HANUNOO,
    BUHID, TAGBANWA, BRAILLE,
    CYPRIOT, LIMBU, OSMANYA,
    SHAVIAN, LINEAR_B, TAI_LE,
    UGARITIC, NEW_TAI_LUE, BUGINESE,
    GLAGOLITIC, TIFINAGH, SYLOTI_NAGRI,
    OLD_PERSIAN, KHAROSHTHI, UNKNOWN,
    BALINESE, CUNEIFORM, PHOENICIAN,
    PHAGS_PA, NKO, KAYAH_LI,
    LEPCHA, REJANG, SUNDANESE,
    SAURASHTRA, CHAM, OL_CHIKI,
    VAI, CARIAN, LYCIAN,
    LYDIAN, BATAK, BRAHMI,
    MANDAIC, CHAKMA, MEROITIC_CURSIVE,
    MEROITIC_HIEROGLYPHS, MIAO, SHARADA,
    SORA_SOMPENG, TAKRI, BASSA_VAH,
    CAUCASIAN_ALBANIAN, DUPLOYAN, ELBASAN,
    GRANTHA, KHOJKI, KHUDAWADI,
    LINEAR_A, MAHAJANI, MANICHAEAN,
    MENDE_KIKAKUI, MODI, MRO,
    NABATAEAN, OLD_NORTH_ARABIAN,
    OLD_PERMIC, PAHAWH_HMONG, PALMYRENE,
    PAU_CIN_HAU, PSALTER_PAHLAVI, SIDDHAM,
    TIRHUTA, WARANG_CITI, AHOM,
    ANATOLIAN_HIEROGLYPHS, HATRAN, MULTANI,
    OLD_HUNGARIAN, SIGNWRITING
  Language* =  ptr LanguageObj
  LanguagePtr* = ptr LanguageObj
  LanguageObj* = object

proc gravityGetForScript*(script: Script; baseGravity: Gravity;
                              hint: GravityHint): Gravity {.
    importc: "pango_gravity_get_for_script", libpango.}
proc gravityGetForScriptAndWidth*(script: Script; wide: Gboolean;
                                      baseGravity: Gravity;
                                      hint: GravityHint): Gravity {.
    importc: "pango_gravity_get_for_script_and_width", libpango.}
proc scriptForUnichar*(ch: Gunichar): Script {.
    importc: "pango_script_for_unichar", libpango.}
proc scriptIterNew*(text: cstring; length: cint): ScriptIter {.
    importc: "pango_script_iter_new", libpango.}
proc getRange*(iter: ScriptIter; start: cstringArray;
                             `end`: cstringArray; script: ptr Script) {.
    importc: "pango_script_iter_get_range", libpango.}
proc next*(iter: ScriptIter): Gboolean {.
    importc: "pango_script_iter_next", libpango.}
proc free*(iter: ScriptIter) {.
    importc: "pango_script_iter_free", libpango.}
proc getSampleLanguage*(script: Script): Language {.
    importc: "pango_script_get_sample_language", libpango.}
proc sampleLanguage*(script: Script): Language {.
    importc: "pango_script_get_sample_language", libpango.}

template pangoTypeLanguage*(): untyped =
  (languageGetType())

proc languageGetType*(): GType {.importc: "pango_language_get_type", libpango.}
proc languageFromString*(language: cstring): Language {.
    importc: "pango_language_from_string", libpango.}
proc toString*(language: Language): cstring {.
    importc: "pango_language_to_string", libpango.}

template pangoLanguageToString*(language: untyped): untyped =
  (cast[cstring](language))

proc getSampleString*(language: Language): cstring {.
    importc: "pango_language_get_sample_string", libpango.}

proc sampleString*(language: Language): cstring {.
    importc: "pango_language_get_sample_string", libpango.}
proc languageGetDefault*(): Language {.
    importc: "pango_language_get_default", libpango.}
proc matches*(language: Language; rangeList: cstring): Gboolean {.
    importc: "pango_language_matches", libpango.}
proc includesScript*(language: Language; script: Script): Gboolean {.
    importc: "pango_language_includes_script", libpango.}
proc getScripts*(language: Language; numScripts: var cint): ptr Script {.
    importc: "pango_language_get_scripts", libpango.}
proc scripts*(language: Language; numScripts: var cint): ptr Script {.
    importc: "pango_language_get_scripts", libpango.}

type
  BidiType* {.size: sizeof(cint), pure.} = enum
    L, LRE, LRO, R,
    AL, RLE, RLO,
    PDF, EN, ES,
    ET, AN, CS,
    NSM, BN, B, S,
    WS, ON

proc bidiTypeForUnichar*(ch: Gunichar): BidiType {.
    importc: "pango_bidi_type_for_unichar", libpango.}

type
  Direction* {.size: sizeof(cint), pure.} = enum
    LTR, RTL, TTB_LTR,
    TTB_RTL, WEAK_LTR, WEAK_RTL,
    NEUTRAL

proc unicharDirection*(ch: Gunichar): Direction {.
    importc: "pango_unichar_direction", libpango.}
proc findBaseDir*(text: cstring; length: cint): Direction {.
    importc: "pango_find_base_dir", libpango.}

type
  FontDescription* =  ptr FontDescriptionObj
  FontDescriptionPtr* = ptr FontDescriptionObj
  FontDescriptionObj* = object

type
  Style* {.size: sizeof(cint), pure.} = enum
    NORMAL, OBLIQUE, ITALIC

type
  Variant* {.size: sizeof(cint), pure.} = enum
    NORMAL, SMALL_CAPS

type
  Weight* {.size: sizeof(cint), pure.} = enum
    THIN = 100, ULTRALIGHT = 200, LIGHT = 300,
    SEMILIGHT = 350, BOOK = 380, NORMAL = 400,
    MEDIUM = 500, SEMIBOLD = 600, BOLD = 700,
    ULTRABOLD = 800, HEAVY = 900,
    ULTRAHEAVY = 1000

type
  Stretch* {.size: sizeof(cint), pure.} = enum
    ULTRA_CONDENSED, EXTRA_CONDENSED,
    CONDENSED, SEMI_CONDENSED, NORMAL,
    SEMI_EXPANDED, EXPANDED,
    EXTRA_EXPANDED, ULTRA_EXPANDED

type
  FontMask* {.size: sizeof(cint), pure.} = enum
    FAMILY = 1 shl 0, STYLE = 1 shl 1,
    VARIANT = 1 shl 2, WEIGHT = 1 shl 3,
    STRETCH = 1 shl 4, SIZE = 1 shl 5,
    GRAVITY = 1 shl 6

type
  FontMetrics* =  ptr FontMetricsObj
  FontMetricsPtr* = ptr FontMetricsObj
  FontMetricsObj* = object
    refCount*: cuint
    ascent*: cint
    descent*: cint
    approximateCharWidth*: cint
    approximateDigitWidth*: cint
    underlinePosition*: cint
    underlineThickness*: cint
    strikethroughPosition*: cint
    strikethroughThickness*: cint

const
  SCALE_XX_SMALL* = cdouble(0.5787037037036999)
  SCALE_X_SMALL* = cdouble(0.6444444444444)
  SCALE_SMALL* = cdouble(0.8333333333333)
  SCALE_MEDIUM* = cdouble(1.0)
  SCALE_LARGE* = cdouble(1.2)
  SCALE_X_LARGE* = cdouble(1.4399999999999)
  SCALE_XX_LARGE* = cdouble(1.728)

template pangoTypeFontDescription*(): untyped =
  (fontDescriptionGetType())

proc fontDescriptionGetType*(): GType {.
    importc: "pango_font_description_get_type", libpango.}
proc fontDescriptionNew*(): FontDescription {.
    importc: "pango_font_description_new", libpango.}
proc copy*(desc: FontDescription): FontDescription {.
    importc: "pango_font_description_copy", libpango.}
proc copyStatic*(desc: FontDescription): FontDescription {.
    importc: "pango_font_description_copy_static", libpango.}
proc hash*(desc: FontDescription): cuint {.
    importc: "pango_font_description_hash", libpango.}
proc equal*(desc1: FontDescription;
                               desc2: FontDescription): Gboolean {.
    importc: "pango_font_description_equal", libpango.}
proc free*(desc: FontDescription) {.
    importc: "pango_font_description_free", libpango.}
proc sFree*(descs: var FontDescription; nDescs: cint) {.
    importc: "pango_font_descriptions_free", libpango.}
proc setFamily*(desc: FontDescription; family: cstring) {.
    importc: "pango_font_description_set_family", libpango.}
proc `family=`*(desc: FontDescription; family: cstring) {.
    importc: "pango_font_description_set_family", libpango.}
proc setFamilyStatic*(desc: FontDescription;
    family: cstring) {.importc: "pango_font_description_set_family_static",
                     libpango.}
proc `familyStatic=`*(desc: FontDescription;
    family: cstring) {.importc: "pango_font_description_set_family_static",
                     libpango.}
proc getFamily*(desc: FontDescription): cstring {.
    importc: "pango_font_description_get_family", libpango.}
proc family*(desc: FontDescription): cstring {.
    importc: "pango_font_description_get_family", libpango.}
proc setStyle*(desc: FontDescription; style: Style) {.
    importc: "pango_font_description_set_style", libpango.}
proc `style=`*(desc: FontDescription; style: Style) {.
    importc: "pango_font_description_set_style", libpango.}
proc getStyle*(desc: FontDescription): Style {.
    importc: "pango_font_description_get_style", libpango.}
proc style*(desc: FontDescription): Style {.
    importc: "pango_font_description_get_style", libpango.}
proc setVariant*(desc: FontDescription;
                                    variant: Variant) {.
    importc: "pango_font_description_set_variant", libpango.}
proc `variant=`*(desc: FontDescription;
                                    variant: Variant) {.
    importc: "pango_font_description_set_variant", libpango.}
proc getVariant*(desc: FontDescription): Variant {.
    importc: "pango_font_description_get_variant", libpango.}
proc variant*(desc: FontDescription): Variant {.
    importc: "pango_font_description_get_variant", libpango.}
proc setWeight*(desc: FontDescription;
                                   weight: Weight) {.
    importc: "pango_font_description_set_weight", libpango.}
proc `weight=`*(desc: FontDescription;
                                   weight: Weight) {.
    importc: "pango_font_description_set_weight", libpango.}
proc getWeight*(desc: FontDescription): Weight {.
    importc: "pango_font_description_get_weight", libpango.}
proc weight*(desc: FontDescription): Weight {.
    importc: "pango_font_description_get_weight", libpango.}
proc setStretch*(desc: FontDescription;
                                    stretch: Stretch) {.
    importc: "pango_font_description_set_stretch", libpango.}
proc `stretch=`*(desc: FontDescription;
                                    stretch: Stretch) {.
    importc: "pango_font_description_set_stretch", libpango.}
proc getStretch*(desc: FontDescription): Stretch {.
    importc: "pango_font_description_get_stretch", libpango.}
proc stretch*(desc: FontDescription): Stretch {.
    importc: "pango_font_description_get_stretch", libpango.}
proc setSize*(desc: FontDescription; size: cint) {.
    importc: "pango_font_description_set_size", libpango.}
proc `size=`*(desc: FontDescription; size: cint) {.
    importc: "pango_font_description_set_size", libpango.}
proc getSize*(desc: FontDescription): cint {.
    importc: "pango_font_description_get_size", libpango.}
proc size*(desc: FontDescription): cint {.
    importc: "pango_font_description_get_size", libpango.}
proc setAbsoluteSize*(desc: FontDescription;
    size: cdouble) {.importc: "pango_font_description_set_absolute_size",
                   libpango.}
proc `absoluteSize=`*(desc: FontDescription;
    size: cdouble) {.importc: "pango_font_description_set_absolute_size",
                   libpango.}
proc getSizeIsAbsolute*(desc: FontDescription): Gboolean {.
    importc: "pango_font_description_get_size_is_absolute", libpango.}
proc sizeIsAbsolute*(desc: FontDescription): Gboolean {.
    importc: "pango_font_description_get_size_is_absolute", libpango.}
proc setGravity*(desc: FontDescription;
                                    gravity: Gravity) {.
    importc: "pango_font_description_set_gravity", libpango.}
proc `gravity=`*(desc: FontDescription;
                                    gravity: Gravity) {.
    importc: "pango_font_description_set_gravity", libpango.}
proc getGravity*(desc: FontDescription): Gravity {.
    importc: "pango_font_description_get_gravity", libpango.}
proc gravity*(desc: FontDescription): Gravity {.
    importc: "pango_font_description_get_gravity", libpango.}
proc getSetFields*(desc: FontDescription): FontMask {.
    importc: "pango_font_description_get_set_fields", libpango.}
proc setFields*(desc: FontDescription): FontMask {.
    importc: "pango_font_description_get_set_fields", libpango.}
proc unsetFields*(desc: FontDescription;
                                     toUnset: FontMask) {.
    importc: "pango_font_description_unset_fields", libpango.}
proc merge*(desc: FontDescription;
                               descToMerge: FontDescription;
                               replaceExisting: Gboolean) {.
    importc: "pango_font_description_merge", libpango.}
proc mergeStatic*(desc: FontDescription;
                                     descToMerge: FontDescription;
                                     replaceExisting: Gboolean) {.
    importc: "pango_font_description_merge_static", libpango.}
proc betterMatch*(desc: FontDescription;
                                     oldMatch: FontDescription;
                                     newMatch: FontDescription): Gboolean {.
    importc: "pango_font_description_better_match", libpango.}
proc fontDescriptionFromString*(str: cstring): FontDescription {.
    importc: "pango_font_description_from_string", libpango.}
proc toString*(desc: FontDescription): cstring {.
    importc: "pango_font_description_to_string", libpango.}
proc toFilename*(desc: FontDescription): cstring {.
    importc: "pango_font_description_to_filename", libpango.}

template pangoTypeFontMetrics*(): untyped =
  (fontMetricsGetType())

proc fontMetricsGetType*(): GType {.importc: "pango_font_metrics_get_type",
                                      libpango.}
proc `ref`*(metrics: FontMetrics): FontMetrics {.
    importc: "pango_font_metrics_ref", libpango.}
proc unref*(metrics: FontMetrics) {.
    importc: "pango_font_metrics_unref", libpango.}
proc getAscent*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_ascent", libpango.}
proc ascent*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_ascent", libpango.}
proc getDescent*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_descent", libpango.}
proc descent*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_descent", libpango.}
proc getApproximateCharWidth*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_approximate_char_width", libpango.}
proc approximateCharWidth*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_approximate_char_width", libpango.}
proc getApproximateDigitWidth*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_approximate_digit_width", libpango.}
proc approximateDigitWidth*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_approximate_digit_width", libpango.}
proc getUnderlinePosition*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_underline_position", libpango.}
proc underlinePosition*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_underline_position", libpango.}
proc getUnderlineThickness*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_underline_thickness", libpango.}
proc underlineThickness*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_underline_thickness", libpango.}
proc getStrikethroughPosition*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_strikethrough_position", libpango.}
proc strikethroughPosition*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_strikethrough_position", libpango.}
proc getStrikethroughThickness*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_strikethrough_thickness", libpango.}
proc strikethroughThickness*(metrics: FontMetrics): cint {.
    importc: "pango_font_metrics_get_strikethrough_thickness", libpango.}
when (ENABLE_BACKEND):
  proc fontMetricsNew*(): FontMetrics {.
      importc: "pango_font_metrics_new", libpango.}
type
  FontFamily* =  ptr FontFamilyObj
  FontFamilyPtr* = ptr FontFamilyObj
  FontFamilyObj*{.final.} = object of GObjectObj

  FontFace* =  ptr FontFaceObj
  FontFacePtr* = ptr FontFaceObj
  FontFaceObj*{.final.} = object of GObjectObj

  FontFamilyClass* =  ptr FontFamilyClassObj
  FontFamilyClassPtr* = ptr FontFamilyClassObj
  FontFamilyClassObj*{.final.} = object of GObjectClassObj
    listFaces*: proc (family: FontFamily; faces: var ptr FontFace;
                    nFaces: var cint) {.cdecl.}
    getName*: proc (family: FontFamily): cstring {.cdecl.}
    isMonospace*: proc (family: FontFamily): Gboolean {.cdecl.}
    pangoReserved2*: proc () {.cdecl.}
    pangoReserved3*: proc () {.cdecl.}
    pangoReserved4*: proc () {.cdecl.}

template pangoTypeFontFamily*(): untyped =
  (fontFamilyGetType())

template pangoFontFamily*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFontFamily, FontFamilyObj))

template pangoIsFontFamily*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFontFamily))

proc fontFamilyGetType*(): GType {.importc: "pango_font_family_get_type",
                                     libpango.}
proc listFaces*(family: FontFamily;
                              faces: var ptr FontFace; nFaces: var cint) {.
    importc: "pango_font_family_list_faces", libpango.}
proc getName*(family: FontFamily): cstring {.
    importc: "pango_font_family_get_name", libpango.}
proc name*(family: FontFamily): cstring {.
    importc: "pango_font_family_get_name", libpango.}
proc isMonospace*(family: FontFamily): Gboolean {.
    importc: "pango_font_family_is_monospace", libpango.}
when (ENABLE_BACKEND):
  template pangoFontFamilyClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeFontFamily, FontFamilyClassObj))

  template pangoIsFontFamilyClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeFontFamily))

  template pangoFontFamilyGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeFontFamily, FontFamilyClassObj))

type
  FontFaceClass* =  ptr FontFaceClassObj
  FontFaceClassPtr* = ptr FontFaceClassObj
  FontFaceClassObj*{.final.} = object of GObjectClassObj
    getFaceName*: proc (face: FontFace): cstring {.cdecl.}
    describe*: proc (face: FontFace): FontDescription {.cdecl.}
    listSizes*: proc (face: FontFace; sizes: var ptr cint; nSizes: var cint) {.cdecl.}
    isSynthesized*: proc (face: FontFace): Gboolean {.cdecl.}
    pangoReserved3*: proc () {.cdecl.}
    pangoReserved4*: proc () {.cdecl.}

template pangoTypeFontFace*(): untyped =
  (fontFaceGetType())

template pangoFontFace*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFontFace, FontFaceObj))

template pangoIsFontFace*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFontFace))

proc fontFaceGetType*(): GType {.importc: "pango_font_face_get_type",
                                   libpango.}
proc describe*(face: FontFace): FontDescription {.
    importc: "pango_font_face_describe", libpango.}
proc getFaceName*(face: FontFace): cstring {.
    importc: "pango_font_face_get_face_name", libpango.}
proc faceName*(face: FontFace): cstring {.
    importc: "pango_font_face_get_face_name", libpango.}
proc listSizes*(face: FontFace; sizes: var ptr cint;
                            nSizes: var cint) {.
    importc: "pango_font_face_list_sizes", libpango.}
proc isSynthesized*(face: FontFace): Gboolean {.
    importc: "pango_font_face_is_synthesized", libpango.}
when (ENABLE_BACKEND):
  template pangoFontFaceClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeFontFace, FontFaceClassObj))

  template pangoIsFontFaceClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeFontFace))

  template pangoFontFaceGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeFontFace, FontFaceClassObj))

type
  Font* =  ptr FontObj
  FontPtr* = ptr FontObj
  FontObj* = object of GObjectObj

  FontMap* =  ptr FontMapObj
  FontMapPtr* = ptr FontMapObj
  FontMapObj* = object of GObjectObj

  Engine* =  ptr EngineObj
  EnginePtr* = ptr EngineObj
  EngineObj* = object of GObjectObj

  EngineShape* =  ptr EngineShapeObj
  EngineShapePtr* = ptr EngineShapeObj
  EngineShapeObj*{.final.} = object of EngineObj

  FontClass* =  ptr FontClassObj
  FontClassPtr* = ptr FontClassObj
  FontClassObj* = object of GObjectClassObj
    describe*: proc (font: Font): FontDescription {.cdecl.}
    getCoverage*: proc (font: Font; lang: Language): Coverage {.cdecl.}
    findShaper*: proc (font: Font; lang: Language; ch: uint32): EngineShape {.cdecl.}
    getGlyphExtents*: proc (font: Font; glyph: Glyph;
                          inkRect: Rectangle;
                          logicalRect: Rectangle) {.cdecl.}
    getMetrics*: proc (font: Font; language: Language): FontMetrics {.cdecl.}
    getFontMap*: proc (font: Font): FontMap {.cdecl.}
    describeAbsolute*: proc (font: Font): FontDescription {.cdecl.}
    pangoReserved01*: proc () {.cdecl.}
    pangoReserved02*: proc () {.cdecl.}

template pangoTypeFont*(): untyped =
  (fontGetType())

template pangoFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFont, FontObj))

template pangoIsFont*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFont))

proc fontGetType*(): GType {.importc: "pango_font_get_type", libpango.}
proc describe*(font: Font): FontDescription {.
    importc: "pango_font_describe", libpango.}
proc describeWithAbsoluteSize*(font: Font): FontDescription {.
    importc: "pango_font_describe_with_absolute_size", libpango.}
proc getCoverage*(font: Font; language: Language): Coverage {.
    importc: "pango_font_get_coverage", libpango.}
proc coverage*(font: Font; language: Language): Coverage {.
    importc: "pango_font_get_coverage", libpango.}
proc findShaper*(font: Font; language: Language; ch: uint32): EngineShape {.
    importc: "pango_font_find_shaper", libpango.}
proc getMetrics*(font: Font; language: Language): FontMetrics {.
    importc: "pango_font_get_metrics", libpango.}
proc metrics*(font: Font; language: Language): FontMetrics {.
    importc: "pango_font_get_metrics", libpango.}
proc getGlyphExtents*(font: Font; glyph: Glyph;
                              inkRect: Rectangle;
                              logicalRect: Rectangle) {.
    importc: "pango_font_get_glyph_extents", libpango.}
proc getFontMap*(font: Font): FontMap {.
    importc: "pango_font_get_font_map", libpango.}
proc fontMap*(font: Font): FontMap {.
    importc: "pango_font_get_font_map", libpango.}
type
  AttrType* {.size: sizeof(cint), pure.} = enum
    INVALID, LANGUAGE, FAMILY, STYLE,
    WEIGHT, VARIANT, STRETCH, SIZE,
    FONT_DESC, FOREGROUND, BACKGROUND,
    UNDERLINE, STRIKETHROUGH, RISE,
    SHAPE, SCALE, FALLBACK,
    LETTER_SPACING, UNDERLINE_COLOR,
    STRIKETHROUGH_COLOR, ABSOLUTE_SIZE, GRAVITY,
    GRAVITY_HINT, FONT_FEATURES,
    FOREGROUND_ALPHA, BACKGROUND_ALPHA
when (ENABLE_BACKEND):
  template pangoFontClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeFont, FontClassObj))

  template pangoIsFontClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeFont))

  template pangoFontGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeFont, FontClassObj))

  const
    UNKNOWN_GLYPH_WIDTH* = 10
    UNKNOWN_GLYPH_HEIGHT* = 14

const
  GLYPH_EMPTY* = Glyph(0x0FFFFFFF)
  GLYPH_INVALID_INPUT* = Glyph(0xFFFFFFFF)
  GLYPH_UNKNOWN_FLAG* = Glyph(0x10000000)

template pangoGetUnknownGlyph*(wc: untyped): untyped =
  (pangoGlyph(wc) or pango_Glyph_Unknown_Flag)

type
  Color* =  ptr ColorObj
  ColorPtr* = ptr ColorObj
  ColorObj* = object
    red*: uint16
    green*: uint16
    blue*: uint16

  Attribute* =  ptr AttributeObj
  AttributePtr* = ptr AttributeObj
  AttributeObj*{.inheritable, pure.} = object
    klass*: AttrClass
    startIndex*: cuint
    endIndex*: cuint

  AttrClass* =  ptr AttrClassObj
  AttrClassPtr* = ptr AttrClassObj
  AttrClassObj* = object
    `type`*: AttrType
    copy*: proc (attr: Attribute): Attribute {.cdecl.}
    destroy*: proc (attr: Attribute) {.cdecl.}
    equal*: proc (attr1: Attribute; attr2: Attribute): Gboolean {.cdecl.}

type
  AttrColor* =  ptr AttrColorObj
  AttrColorPtr* = ptr AttrColorObj
  AttrColorObj*{.final.} = object of AttributeObj
    color*: ColorObj

  AttrInt* =  ptr AttrIntObj
  AttrIntPtr* = ptr AttrIntObj
  AttrIntObj*{.final.} = object of AttributeObj
    value*: cint

  AttrFloat* =  ptr AttrFloatObj
  AttrFloatPtr* = ptr AttrFloatObj
  AttrFloatObj*{.final.} = object of AttributeObj
    value*: cdouble

  AttrLanguage* =  ptr AttrLanguageObj
  AttrLanguagePtr* = ptr AttrLanguageObj
  AttrLanguageObj*{.final.} = object of AttributeObj
    value*: Language

  AttrSize* =  ptr AttrSizeObj
  AttrSizePtr* = ptr AttrSizeObj
  AttrSizeObj*{.final.} = object of AttributeObj
    size*: cint
    absolute* {.bitsize: 1.}: cuint

type
  AttrDataCopyFunc* = proc (userData: Gconstpointer): Gpointer {.cdecl.}
  AttrShape* =  ptr AttrShapeObj
  AttrShapePtr* = ptr AttrShapeObj
  AttrShapeObj*{.final.} = object of AttributeObj
    inkRect*: RectangleObj
    logicalRect*: RectangleObj
    data*: Gpointer
    copyFunc*: AttrDataCopyFunc
    destroyFunc*: GDestroyNotify

  AttrString* =  ptr AttrStringObj
  AttrStringPtr* = ptr AttrStringObj
  AttrStringObj*{.final.} = object of AttributeObj
    value*: cstring

  AttrFontDesc* =  ptr AttrFontDescObj
  AttrFontDescPtr* = ptr AttrFontDescObj
  AttrFontDescObj*{.final.} = object of AttributeObj
    desc*: FontDescription

template pangoTypeColor*(): untyped =
  (colorGetType())

proc colorGetType*(): GType {.importc: "pango_color_get_type", libpango.}
proc copy*(src: Color): Color {.
    importc: "pango_color_copy", libpango.}
proc free*(color: Color) {.importc: "pango_color_free", libpango.}
proc parse*(color: Color; spec: cstring): Gboolean {.
    importc: "pango_color_parse", libpango.}
proc toString*(color: Color): cstring {.
    importc: "pango_color_to_string", libpango.}

template pangoTypeAttrList*(): untyped =
  (attrListGetType())

type
  AttrList* =  ptr AttrListObj
  AttrListPtr* = ptr AttrListObj
  AttrListObj* = object

  AttrIterator* =  ptr AttrIteratorObj
  AttrIteratorPtr* = ptr AttrIteratorObj
  AttrIteratorObj* = object

type
  Underline* {.size: sizeof(cint), pure.} = enum
    NONE, SINGLE, DOUBLE,
    LOW, ERROR

const
  ATTR_INDEX_FROM_TEXT_BEGINNING* = 0
  ATTR_INDEX_TO_TEXT_END* = G_MAXUINT

type
  AttrFilterFunc* = proc (attribute: Attribute; userData: Gpointer): Gboolean {.cdecl.}

type
  AttrFontFeatures* =  ptr AttrFontFeaturesObj
  AttrFontFeaturesPtr* = ptr AttrFontFeaturesObj
  AttrFontFeaturesObj*{.final.} = object of AttributeObj
    features*: cstring

proc attrTypeRegister*(name: cstring): AttrType {.
    importc: "pango_attr_type_register", libpango.}
proc getName*(`type`: AttrType): cstring {.
    importc: "pango_attr_type_get_name", libpango.}
proc name*(`type`: AttrType): cstring {.
    importc: "pango_attr_type_get_name", libpango.}
proc init*(attr: Attribute; klass: AttrClass) {.
    importc: "pango_attribute_init", libpango.}
proc copy*(attr: Attribute): Attribute {.
    importc: "pango_attribute_copy", libpango.}
proc destroy*(attr: Attribute) {.
    importc: "pango_attribute_destroy", libpango.}
proc equal*(attr1: Attribute; attr2: Attribute): Gboolean {.
    importc: "pango_attribute_equal", libpango.}
proc attrLanguageNew*(language: Language): Attribute {.
    importc: "pango_attr_language_new", libpango.}
proc attrFamilyNew*(family: cstring): Attribute {.
    importc: "pango_attr_family_new", libpango.}
proc attrForegroundNew*(red: uint16; green: uint16; blue: uint16): Attribute {.
    importc: "pango_attr_foreground_new", libpango.}
proc attrBackgroundNew*(red: uint16; green: uint16; blue: uint16): Attribute {.
    importc: "pango_attr_background_new", libpango.}
proc attrSizeNew*(size: cint): Attribute {.
    importc: "pango_attr_size_new", libpango.}
proc attrSizeNewAbsolute*(size: cint): Attribute {.
    importc: "pango_attr_size_new_absolute", libpango.}
proc attrStyleNew*(style: Style): Attribute {.
    importc: "pango_attr_style_new", libpango.}
proc attrWeightNew*(weight: Weight): Attribute {.
    importc: "pango_attr_weight_new", libpango.}
proc attrVariantNew*(variant: Variant): Attribute {.
    importc: "pango_attr_variant_new", libpango.}
proc attrStretchNew*(stretch: Stretch): Attribute {.
    importc: "pango_attr_stretch_new", libpango.}
proc attrFontDescNew*(desc: FontDescription): Attribute {.
    importc: "pango_attr_font_desc_new", libpango.}
proc attrUnderlineNew*(underline: Underline): Attribute {.
    importc: "pango_attr_underline_new", libpango.}
proc attrUnderlineColorNew*(red: uint16; green: uint16; blue: uint16): Attribute {.
    importc: "pango_attr_underline_color_new", libpango.}
proc attrStrikethroughNew*(strikethrough: Gboolean): Attribute {.
    importc: "pango_attr_strikethrough_new", libpango.}
proc attrStrikethroughColorNew*(red: uint16; green: uint16; blue: uint16): Attribute {.
    importc: "pango_attr_strikethrough_color_new", libpango.}
proc attrRiseNew*(rise: cint): Attribute {.
    importc: "pango_attr_rise_new", libpango.}
proc attrScaleNew*(scaleFactor: cdouble): Attribute {.
    importc: "pango_attr_scale_new", libpango.}
proc attrFallbackNew*(enableFallback: Gboolean): Attribute {.
    importc: "pango_attr_fallback_new", libpango.}
proc attrLetterSpacingNew*(letterSpacing: cint): Attribute {.
    importc: "pango_attr_letter_spacing_new", libpango.}
proc attrShapeNew*(inkRect: Rectangle; logicalRect: Rectangle): Attribute {.
    importc: "pango_attr_shape_new", libpango.}
proc attrShapeNewWithData*(inkRect: Rectangle;
                               logicalRect: Rectangle; data: Gpointer;
                               copyFunc: AttrDataCopyFunc;
                               destroyFunc: GDestroyNotify): Attribute {.
    importc: "pango_attr_shape_new_with_data", libpango.}
proc attrGravityNew*(gravity: Gravity): Attribute {.
    importc: "pango_attr_gravity_new", libpango.}
proc attrGravityHintNew*(hint: GravityHint): Attribute {.
    importc: "pango_attr_gravity_hint_new", libpango.}
proc attrFontFeaturesNew*(features: cstring): Attribute {.
    importc: "pango_attr_font_features_new", libpango.}
proc attrForegroundAlphaNew*(alpha: uint16): Attribute {.
    importc: "pango_attr_foreground_alpha_new", libpango.}
proc attrBackgroundAlphaNew*(alpha: uint16): Attribute {.
    importc: "pango_attr_background_alpha_new", libpango.}
proc attrListGetType*(): GType {.importc: "pango_attr_list_get_type",
                                   libpango.}
proc attrListNew*(): AttrList {.importc: "pango_attr_list_new",
    libpango.}
proc `ref`*(list: AttrList): AttrList {.
    importc: "pango_attr_list_ref", libpango.}
proc unref*(list: AttrList) {.
    importc: "pango_attr_list_unref", libpango.}
proc copy*(list: AttrList): AttrList {.
    importc: "pango_attr_list_copy", libpango.}
proc insert*(list: AttrList; attr: Attribute) {.
    importc: "pango_attr_list_insert", libpango.}
proc insertBefore*(list: AttrList; attr: Attribute) {.
    importc: "pango_attr_list_insert_before", libpango.}
proc change*(list: AttrList; attr: Attribute) {.
    importc: "pango_attr_list_change", libpango.}
proc splice*(list: AttrList; other: AttrList; pos: cint;
                         len: cint) {.importc: "pango_attr_list_splice", libpango.}
proc filter*(list: AttrList; `func`: AttrFilterFunc;
                         data: Gpointer): AttrList {.
    importc: "pango_attr_list_filter", libpango.}
proc getIterator*(list: AttrList): AttrIterator {.
    importc: "pango_attr_list_get_iterator", libpango.}
proc `iterator`*(list: AttrList): AttrIterator {.
    importc: "pango_attr_list_get_iterator", libpango.}
proc range*(`iterator`: AttrIterator; start: var cint;
                            `end`: var cint) {.
    importc: "pango_attr_iterator_range", libpango.}
proc next*(`iterator`: AttrIterator): Gboolean {.
    importc: "pango_attr_iterator_next", libpango.}
proc copy*(`iterator`: AttrIterator): AttrIterator {.
    importc: "pango_attr_iterator_copy", libpango.}
proc destroy*(`iterator`: AttrIterator) {.
    importc: "pango_attr_iterator_destroy", libpango.}
proc get*(`iterator`: AttrIterator; `type`: AttrType): Attribute {.
    importc: "pango_attr_iterator_get", libpango.}
proc getFont*(`iterator`: AttrIterator;
                              desc: FontDescription;
                              language: var Language;
                              extraAttrs: var glib.GSList) {.
    importc: "pango_attr_iterator_get_font", libpango.}
proc getAttrs*(`iterator`: AttrIterator): glib.GSList {.
    importc: "pango_attr_iterator_get_attrs", libpango.}
proc attrs*(`iterator`: AttrIterator): glib.GSList {.
    importc: "pango_attr_iterator_get_attrs", libpango.}
proc parseMarkup*(markupText: cstring; length: cint; accelMarker: Gunichar;
                      attrList: var AttrList; text: cstringArray;
                      accelChar: var Gunichar; error: var glib.GError): Gboolean {.
    importc: "pango_parse_markup", libpango.}
proc markupParserNew*(accelMarker: Gunichar): glib.GMarkupParseContext {.
    importc: "pango_markup_parser_new", libpango.}
proc markupParserFinish*(context: glib.GMarkupParseContext;
                             attrList: var AttrList; text: cstringArray;
                             accelChar: var Gunichar; error: var glib.GError): Gboolean {.
    importc: "pango_markup_parser_finish", libpango.}

type
  LogAttr* =  ptr LogAttrObj
  LogAttrPtr* = ptr LogAttrObj
  LogAttrObj* = object
    isLineBreak* {.bitsize: 1.}: cuint
    isMandatoryBreak* {.bitsize: 1.}: cuint
    isCharBreak* {.bitsize: 1.}: cuint
    isWhite* {.bitsize: 1.}: cuint
    isCursorPosition* {.bitsize: 1.}: cuint
    isWordStart* {.bitsize: 1.}: cuint
    isWordEnd* {.bitsize: 1.}: cuint
    isSentenceBoundary* {.bitsize: 1.}: cuint
    isSentenceStart* {.bitsize: 1.}: cuint
    isSentenceEnd* {.bitsize: 1.}: cuint
    backspaceDeletesCharacter* {.bitsize: 1.}: cuint
    isExpandableSpace* {.bitsize: 1.}: cuint
    isWordBoundary* {.bitsize: 1.}: cuint

  EngineLang* =  ptr EngineLangObj
  EngineLangPtr* = ptr EngineLangObj
  EngineLangObj*{.final.} = object of EngineObj

  Analysis* =  ptr AnalysisObj
  AnalysisPtr* = ptr AnalysisObj
  AnalysisObj* = object
    shapeEngine*: EngineShape
    langEngine*: EngineLang
    font*: Font
    level*: uint8
    gravity*: uint8
    flags*: uint8
    script*: uint8
    language*: Language
    extraAttrs*: glib.GSList

proc `break`*(text: cstring; length: cint; analysis: Analysis;
                attrs: LogAttr; attrsLen: cint) {.importc: "pango_break",
    libpango.}
proc findParagraphBoundary*(text: cstring; length: cint;
                                paragraphDelimiterIndex: var cint;
                                nextParagraphStart: var cint) {.
    importc: "pango_find_paragraph_boundary", libpango.}
proc getLogAttrs*(text: cstring; length: cint; level: cint;
                      language: Language; logAttrs: LogAttr;
                      attrsLen: cint) {.importc: "pango_get_log_attrs", libpango.}
when (ENABLE_ENGINE):
  proc defaultBreak*(text: cstring; length: cint; analysis: Analysis;
                         attrs: LogAttr; attrsLen: cint) {.
      importc: "pango_default_break", libpango.}

const
  ANALYSIS_FLAG_CENTERED_BASELINE* = (1 shl 0)

const
  ANALYSIS_FLAG_IS_ELLIPSIS* = (1 shl 1)

type
  Fontset* =  ptr FontsetObj
  FontsetPtr* = ptr FontsetObj
  FontsetObj*{.final.} = object of GObjectObj
type
  FontsetForeachFunc* = proc (fontset: Fontset; font: Font;
                                userData: Gpointer): Gboolean {.cdecl.}

  Item* =  ptr ItemObj
  ItemPtr* = ptr ItemObj
  ItemObj* = object
    offset*: cint
    length*: cint
    numChars*: cint
    analysis*: AnalysisObj

template pangoTypeItem*(): untyped =
  (itemGetType())

proc itemGetType*(): GType {.importc: "pango_item_get_type", libpango.}
proc itemNew*(): Item {.importc: "pango_item_new", libpango.}
proc copy*(item: Item): Item {.importc: "pango_item_copy",
    libpango.}
proc free*(item: Item) {.importc: "pango_item_free", libpango.}
proc split*(orig: Item; splitIndex: cint; splitOffset: cint): Item {.
    importc: "pango_item_split", libpango.}

type

  FontsetClass* =  ptr FontsetClassObj
  FontsetClassPtr* = ptr FontsetClassObj
  FontsetClassObj*{.final.} = object of GObjectClassObj
    getFont*: proc (fontset: Fontset; wc: cuint): Font {.cdecl.}
    getMetrics*: proc (fontset: Fontset): FontMetrics {.cdecl.}
    getLanguage*: proc (fontset: Fontset): Language {.cdecl.}
    foreach*: proc (fontset: Fontset; `func`: FontsetForeachFunc;
                  data: Gpointer) {.cdecl.}
    pangoReserved1*: proc () {.cdecl.}
    pangoReserved2*: proc () {.cdecl.}
    pangoReserved3*: proc () {.cdecl.}
    pangoReserved4*: proc () {.cdecl.}

  FontsetSimple* =  ptr FontsetSimpleObj
  FontsetSimplePtr* = ptr FontsetSimpleObj
  FontsetSimpleObj* = object

template pangoTypeFontset*(): untyped =
  (fontsetGetType())

template pangoFontset*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFontset, FontsetObj))

template pangoIsFontset*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFontset))

proc fontsetGetType*(): GType {.importc: "pango_fontset_get_type", libpango.}

proc getFont*(fontset: Fontset; wc: cuint): Font {.
    importc: "pango_fontset_get_font", libpango.}

proc font*(fontset: Fontset; wc: cuint): Font {.
    importc: "pango_fontset_get_font", libpango.}
proc getMetrics*(fontset: Fontset): FontMetrics {.
    importc: "pango_fontset_get_metrics", libpango.}
proc metrics*(fontset: Fontset): FontMetrics {.
    importc: "pango_fontset_get_metrics", libpango.}
proc foreach*(fontset: Fontset;
                         `func`: FontsetForeachFunc; data: Gpointer) {.
    importc: "pango_fontset_foreach", libpango.}
when (ENABLE_BACKEND):
  template pangoFontsetClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeFontset, FontsetClassObj))

  template pangoIsFontsetClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeFontset))

  template pangoFontsetGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeFontset, FontsetClassObj))

  template pangoTypeFontsetSimple*(): untyped =
    (fontsetSimpleGetType())

  template pangoFontsetSimple*(`object`: untyped): untyped =
    (gTypeCheckInstanceCast(`object`, pangoTypeFontsetSimple, FontsetSimpleObj))

  template pangoIsFontsetSimple*(`object`: untyped): untyped =
    (gTypeCheckInstanceType(`object`, pangoTypeFontsetSimple))

  proc fontsetSimpleGetType*(): GType {.
      importc: "pango_fontset_simple_get_type", libpango.}
  proc fontsetSimpleNew*(language: Language): FontsetSimple {.
      importc: "pango_fontset_simple_new", libpango.}
  proc append*(fontset: FontsetSimple;
                                font: Font) {.
      importc: "pango_fontset_simple_append", libpango.}
  proc size*(fontset: FontsetSimple): cint {.
      importc: "pango_fontset_simple_size", libpango.}

type
  Context* =  ptr ContextObj
  ContextPtr* = ptr ContextObj
  ContextObj* = object

  FontMapClass* =  ptr FontMapClassObj
  FontMapClassPtr* = ptr FontMapClassObj
  FontMapClassObj* = object of GObjectClassObj
    loadFont*: proc (fontmap: FontMap; context: Context;
                   desc: FontDescription): Font {.cdecl.}
    listFamilies*: proc (fontmap: FontMap;
                       families: var ptr FontFamily; nFamilies: var cint) {.cdecl.}
    loadFontset*: proc (fontmap: FontMap; context: Context;
                      desc: FontDescription; language: Language): Fontset {.cdecl.}
    shapeEngineType*: cstring
    getSerial*: proc (fontmap: FontMap): cuint {.cdecl.}
    changed*: proc (fontmap: FontMap) {.cdecl.}
    pangoReserved1b*: proc () {.cdecl.}
    pangoReserved2b*: proc () {.cdecl.}

template pangoTypeFontMap*(): untyped =
  (fontMapGetType())

template pangoFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeFontMap, FontMapObj))

template pangoIsFontMap*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeFontMap))

proc fontMapGetType*(): GType {.importc: "pango_font_map_get_type", libpango.}
proc createContext*(fontmap: FontMap): Context {.
    importc: "pango_font_map_create_context", libpango.}
proc loadFont*(fontmap: FontMap; context: Context;
                          desc: FontDescription): Font {.
    importc: "pango_font_map_load_font", libpango.}
proc loadFontset*(fontmap: FontMap; context: Context;
                             desc: FontDescription;
                             language: Language): Fontset {.
    importc: "pango_font_map_load_fontset", libpango.}
proc listFamilies*(fontmap: FontMap;
                              families: var ptr FontFamily;
                              nFamilies: var cint) {.
    importc: "pango_font_map_list_families", libpango.}
proc getSerial*(fontmap: FontMap): cuint {.
    importc: "pango_font_map_get_serial", libpango.}
proc serial*(fontmap: FontMap): cuint {.
    importc: "pango_font_map_get_serial", libpango.}
proc changed*(fontmap: FontMap) {.
    importc: "pango_font_map_changed", libpango.}
when (ENABLE_BACKEND):
  template pangoFontMapClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeFontMap, FontMapClassObj))

  template pangoIsFontMapClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeFontMap))

  template pangoFontMapGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeFontMap, FontMapClassObj))

  proc getShapeEngineType*(fontmap: FontMap): cstring {.
      importc: "pango_font_map_get_shape_engine_type", libpango.}

  proc shapeEngineType*(fontmap: FontMap): cstring {.
      importc: "pango_font_map_get_shape_engine_type", libpango.}

template pangoTypeContext*(): untyped =
  (contextGetType())

template pangoContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeContext, ContextObj))

template pangoContextClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, pangoTypeContext, ContextClass))

template pangoIsContext*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeContext))

template pangoIsContextClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, pangoTypeContext))

template pangoContextGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, pangoTypeContext, ContextClass))

proc contextGetType*(): GType {.importc: "pango_context_get_type", libpango.}
proc contextNew*(): Context {.importc: "pango_context_new", libpango.}
proc changed*(context: Context) {.
    importc: "pango_context_changed", libpango.}
proc setFontMap*(context: Context; fontMap: FontMap) {.
    importc: "pango_context_set_font_map", libpango.}
proc `fontMap=`*(context: Context; fontMap: FontMap) {.
    importc: "pango_context_set_font_map", libpango.}
proc getFontMap*(context: Context): FontMap {.
    importc: "pango_context_get_font_map", libpango.}
proc fontMap*(context: Context): FontMap {.
    importc: "pango_context_get_font_map", libpango.}
proc getSerial*(context: Context): cuint {.
    importc: "pango_context_get_serial", libpango.}
proc serial*(context: Context): cuint {.
    importc: "pango_context_get_serial", libpango.}
proc listFamilies*(context: Context;
                              families: var ptr FontFamily;
                              nFamilies: var cint) {.
    importc: "pango_context_list_families", libpango.}
proc loadFont*(context: Context; desc: FontDescription): Font {.
    importc: "pango_context_load_font", libpango.}
proc loadFontset*(context: Context;
                             desc: FontDescription;
                             language: Language): Fontset {.
    importc: "pango_context_load_fontset", libpango.}
proc getMetrics*(context: Context;
                            desc: FontDescription;
                            language: Language): FontMetrics {.
    importc: "pango_context_get_metrics", libpango.}
proc metrics*(context: Context;
                            desc: FontDescription;
                            language: Language): FontMetrics {.
    importc: "pango_context_get_metrics", libpango.}
proc setFontDescription*(context: Context;
                                    desc: FontDescription) {.
    importc: "pango_context_set_font_description", libpango.}
proc `fontDescription=`*(context: Context;
                                    desc: FontDescription) {.
    importc: "pango_context_set_font_description", libpango.}
proc getFontDescription*(context: Context): FontDescription {.
    importc: "pango_context_get_font_description", libpango.}
proc fontDescription*(context: Context): FontDescription {.
    importc: "pango_context_get_font_description", libpango.}
proc getLanguage*(context: Context): Language {.
    importc: "pango_context_get_language", libpango.}
proc language*(context: Context): Language {.
    importc: "pango_context_get_language", libpango.}
proc setLanguage*(context: Context; language: Language) {.
    importc: "pango_context_set_language", libpango.}
proc `language=`*(context: Context; language: Language) {.
    importc: "pango_context_set_language", libpango.}
proc setBaseDir*(context: Context; direction: Direction) {.
    importc: "pango_context_set_base_dir", libpango.}
proc `baseDir=`*(context: Context; direction: Direction) {.
    importc: "pango_context_set_base_dir", libpango.}
proc getBaseDir*(context: Context): Direction {.
    importc: "pango_context_get_base_dir", libpango.}
proc baseDir*(context: Context): Direction {.
    importc: "pango_context_get_base_dir", libpango.}
proc setBaseGravity*(context: Context; gravity: Gravity) {.
    importc: "pango_context_set_base_gravity", libpango.}
proc `baseGravity=`*(context: Context; gravity: Gravity) {.
    importc: "pango_context_set_base_gravity", libpango.}
proc getBaseGravity*(context: Context): Gravity {.
    importc: "pango_context_get_base_gravity", libpango.}
proc baseGravity*(context: Context): Gravity {.
    importc: "pango_context_get_base_gravity", libpango.}
proc getGravity*(context: Context): Gravity {.
    importc: "pango_context_get_gravity", libpango.}
proc gravity*(context: Context): Gravity {.
    importc: "pango_context_get_gravity", libpango.}
proc setGravityHint*(context: Context; hint: GravityHint) {.
    importc: "pango_context_set_gravity_hint", libpango.}
proc `gravityHint=`*(context: Context; hint: GravityHint) {.
    importc: "pango_context_set_gravity_hint", libpango.}
proc getGravityHint*(context: Context): GravityHint {.
    importc: "pango_context_get_gravity_hint", libpango.}
proc gravityHint*(context: Context): GravityHint {.
    importc: "pango_context_get_gravity_hint", libpango.}
proc setMatrix*(context: Context; matrix: Matrix) {.
    importc: "pango_context_set_matrix", libpango.}
proc `matrix=`*(context: Context; matrix: Matrix) {.
    importc: "pango_context_set_matrix", libpango.}
proc getMatrix*(context: Context): Matrix {.
    importc: "pango_context_get_matrix", libpango.}
proc matrix*(context: Context): Matrix {.
    importc: "pango_context_get_matrix", libpango.}

proc itemize*(context: Context; text: cstring; startIndex: cint;
                  length: cint; attrs: AttrList;
                  cachedIter: AttrIterator): glib.GList {.
    importc: "pango_itemize", libpango.}
proc itemizeWithBaseDir*(context: Context; baseDir: Direction;
                             text: cstring; startIndex: cint; length: cint;
                             attrs: AttrList;
                             cachedIter: AttrIterator): glib.GList {.
    importc: "pango_itemize_with_base_dir", libpango.}

type
  GlyphUnit* = int32

type
  GlyphGeometry* =  ptr GlyphGeometryObj
  GlyphGeometryPtr* = ptr GlyphGeometryObj
  GlyphGeometryObj* = object
    width*: GlyphUnit
    xOffset*: GlyphUnit
    yOffset*: GlyphUnit

type
  GlyphVisAttr* =  ptr GlyphVisAttrObj
  GlyphVisAttrPtr* = ptr GlyphVisAttrObj
  GlyphVisAttrObj* = object
    isClusterStart* {.bitsize: 1.}: cuint

type
  GlyphInfo* =  ptr GlyphInfoObj
  GlyphInfoPtr* = ptr GlyphInfoObj
  GlyphInfoObj* = object
    glyph*: Glyph
    geometry*: GlyphGeometryObj
    attr*: GlyphVisAttrObj

type
  GlyphString* =  ptr GlyphStringObj
  GlyphStringPtr* = ptr GlyphStringObj
  GlyphStringObj* = object
    numGlyphs*: cint
    glyphs*: GlyphInfo
    logClusters*: ptr cint
    space*: cint

template pangoTypeGlyphString*(): untyped =
  (glyphStringGetType())

proc glyphStringNew*(): GlyphString {.
    importc: "pango_glyph_string_new", libpango.}
proc setSize*(string: GlyphString; newLen: cint) {.
    importc: "pango_glyph_string_set_size", libpango.}
proc `size=`*(string: GlyphString; newLen: cint) {.
    importc: "pango_glyph_string_set_size", libpango.}
proc glyphStringGetType*(): GType {.importc: "pango_glyph_string_get_type",
                                      libpango.}
proc copy*(string: GlyphString): GlyphString {.
    importc: "pango_glyph_string_copy", libpango.}
proc free*(string: GlyphString) {.
    importc: "pango_glyph_string_free", libpango.}
proc extents*(glyphs: GlyphString; font: Font;
                             inkRect: Rectangle;
                             logicalRect: Rectangle) {.
    importc: "pango_glyph_string_extents", libpango.}
proc getWidth*(glyphs: GlyphString): cint {.
    importc: "pango_glyph_string_get_width", libpango.}
proc width*(glyphs: GlyphString): cint {.
    importc: "pango_glyph_string_get_width", libpango.}
proc extentsRange*(glyphs: GlyphString; start: cint;
                                  `end`: cint; font: Font;
                                  inkRect: Rectangle;
                                  logicalRect: Rectangle) {.
    importc: "pango_glyph_string_extents_range", libpango.}
proc getLogicalWidths*(glyphs: GlyphString; text: cstring;
                                      length: cint; embeddingLevel: cint;
                                      logicalWidths: var cint) {.
    importc: "pango_glyph_string_get_logical_widths", libpango.}
proc indexToX*(glyphs: GlyphString; text: cstring;
                              length: cint; analysis: Analysis; index: cint;
                              trailing: Gboolean; xPos: var cint) {.
    importc: "pango_glyph_string_index_to_x", libpango.}
proc xToIndex*(glyphs: GlyphString; text: cstring;
                              length: cint; analysis: Analysis; xPos: cint;
                              index: var cint; trailing: var cint) {.
    importc: "pango_glyph_string_x_to_index", libpango.}

proc shape*(text: cstring; length: cint; analysis: Analysis;
                glyphs: GlyphString) {.importc: "pango_shape", libpango.}
proc shapeFull*(itemText: cstring; itemLength: cint; paragraphText: cstring;
                    paragraphLength: cint; analysis: Analysis;
                    glyphs: GlyphString) {.importc: "pango_shape_full",
    libpango.}
proc reorderItems*(logicalItems: glib.GList): glib.GList {.
    importc: "pango_reorder_items", libpango.}

type
  EngineClass* =  ptr EngineClassObj
  EngineClassPtr* = ptr EngineClassObj
  EngineClassObj* = object of GObjectClassObj

when (ENABLE_ENGINE):
  const
    RENDER_TYPE_NONE* = "RenderNone"
  template pangoTypeEngine*(): untyped =
    (engineGetType())

  template pangoEngine*(`object`: untyped): untyped =
    (gTypeCheckInstanceCast(`object`, pangoTypeEngine, EngineObj))

  template pangoIsEngine*(`object`: untyped): untyped =
    (gTypeCheckInstanceType(`object`, pangoTypeEngine))

  template pangoEngineClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeEngine, EngineClassObj))

  template pangoIsEngineClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeEngine))

  template pangoEngineGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeEngine, EngineClassObj))

  type
    EngineLangClass* =  ptr EngineLangClassObj
    EngineLangClassPtr* = ptr EngineLangClassObj
    EngineLangClassObj*{.final.} = object of EngineClassObj
      scriptBreak*: proc (engine: EngineLang; text: cstring; len: cint;
                        analysis: Analysis; attrs: LogAttr;
                        attrsLen: cint) {.cdecl.}

  proc engineGetType*(): GType {.importc: "pango_engine_get_type", libpango.}
  const
    ENGINE_TYPE_LANG* = "EngineLangObj"
  template pangoTypeEngineLang*(): untyped =
    (engineLangGetType())

  template pangoEngineLang*(`object`: untyped): untyped =
    (gTypeCheckInstanceCast(`object`, pangoTypeEngineLang, EngineLangObj))

  template pangoIsEngineLang*(`object`: untyped): untyped =
    (gTypeCheckInstanceType(`object`, pangoTypeEngineLang))

  template pangoEngineLangClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeEngineLang, EngineLangClassObj))

  template pangoIsEngineLangClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeEngineLang))

  template pangoEngineLangGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeEngineLang, EngineLangClassObj))

  type
    EngineShapeClass* =  ptr EngineShapeClassObj
    EngineShapeClassPtr* = ptr EngineShapeClassObj
    EngineShapeClassObj*{.final.} = object of EngineClassObj
      scriptShape*: proc (engine: EngineShape; font: Font;
                        itemText: cstring; itemLength: cuint;
                        analysis: Analysis; glyphs: GlyphString;
                        paragraphText: cstring; paragraphLength: cuint) {.cdecl.}
      covers*: proc (engine: EngineShape; font: Font;
                   language: Language; wc: Gunichar): CoverageLevel {.cdecl.}

  proc engineLangGetType*(): GType {.importc: "pango_engine_lang_get_type",
                                       libpango.}
  const
    ENGINE_TYPE_SHAPE* = "EngineShapeObj"
  template pangoTypeEngineShape*(): untyped =
    (engineShapeGetType())

  template pangoEngineShape*(`object`: untyped): untyped =
    (gTypeCheckInstanceCast(`object`, pangoTypeEngineShape, EngineShapeObj))

  template pangoIsEngineShape*(`object`: untyped): untyped =
    (gTypeCheckInstanceType(`object`, pangoTypeEngineShape))

  template pangoEngineShapeClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, pangoTypeEngineShape, EngineShapeClassObj))

  template pangoIsEngineShapeClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, pangoTypeEngineShape))

  template pangoEngineShapeGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, pangoTypeEngineShape, EngineShapeClassObj))

  proc engineShapeGetType*(): GType {.importc: "pango_engine_shape_get_type",
                                        libpango.}
  type
    EngineScriptInfo* =  ptr EngineScriptInfoObj
    EngineScriptInfoPtr* = ptr EngineScriptInfoObj
    EngineScriptInfoObj* = object
      script*: Script
      langs*: cstring

  type
    EngineInfo* =  ptr EngineInfoObj
    EngineInfoPtr* = ptr EngineInfoObj
    EngineInfoObj* = object
      id*: cstring
      engineType*: cstring
      renderType*: cstring
      scripts*: EngineScriptInfo
      nScripts*: cint

  proc scriptEngineList*(engines: var EngineInfo; nEngines: var cint) {.
      importc: "script_engine_list", libpango.}
  proc scriptEngineInit*(module: gobject.GTypeModule) {.importc: "script_engine_init",
      libpango.}
  proc scriptEngineExit*() {.importc: "script_engine_exit", libpango.}
  proc scriptEngineCreate*(id: cstring): Engine {.
      importc: "script_engine_create", libpango.}

proc attrTypeGetType*(): GType {.importc: "pango_attr_type_get_type",
                                   libpango.}
template pangoTypeAttrType*(): untyped =
  (attrTypeGetType())

proc underlineGetType*(): GType {.importc: "pango_underline_get_type",
                                    libpango.}
template pangoTypeUnderline*(): untyped =
  (underlineGetType())

proc bidiTypeGetType*(): GType {.importc: "pango_bidi_type_get_type",
                                   libpango.}
template pangoTypeBidiType*(): untyped =
  (bidiTypeGetType())

proc directionGetType*(): GType {.importc: "pango_direction_get_type",
                                    libpango.}
template pangoTypeDirection*(): untyped =
  (directionGetType())

proc coverageLevelGetType*(): GType {.importc: "pango_coverage_level_get_type",
                                        libpango.}
template pangoTypeCoverageLevel*(): untyped =
  (coverageLevelGetType())

proc styleGetType*(): GType {.importc: "pango_style_get_type", libpango.}
template pangoTypeStyle*(): untyped =
  (styleGetType())

proc variantGetType*(): GType {.importc: "pango_variant_get_type", libpango.}
template pangoTypeVariant*(): untyped =
  (variantGetType())

proc weightGetType*(): GType {.importc: "pango_weight_get_type", libpango.}
template pangoTypeWeight*(): untyped =
  (weightGetType())

proc stretchGetType*(): GType {.importc: "pango_stretch_get_type", libpango.}
template pangoTypeStretch*(): untyped =
  (stretchGetType())

proc fontMaskGetType*(): GType {.importc: "pango_font_mask_get_type",
                                   libpango.}
template pangoTypeFontMask*(): untyped =
  (fontMaskGetType())

proc gravityGetType*(): GType {.importc: "pango_gravity_get_type", libpango.}
template pangoTypeGravity*(): untyped =
  (gravityGetType())

proc gravityHintGetType*(): GType {.importc: "pango_gravity_hint_get_type",
                                      libpango.}
template pangoTypeGravityHint*(): untyped =
  (gravityHintGetType())

proc alignmentGetType*(): GType {.importc: "pango_alignment_get_type",
                                    libpango.}
template pangoTypeAlignment*(): untyped =
  (alignmentGetType())

proc wrapModeGetType*(): GType {.importc: "pango_wrap_mode_get_type",
                                   libpango.}
template pangoTypeWrapMode*(): untyped =
  (wrapModeGetType())

proc ellipsizeModeGetType*(): GType {.importc: "pango_ellipsize_mode_get_type",
                                        libpango.}
template pangoTypeEllipsizeMode*(): untyped =
  (ellipsizeModeGetType())

proc renderPartGetType*(): GType {.importc: "pango_render_part_get_type",
                                     libpango.}
template pangoTypeRenderPart*(): untyped =
  (renderPartGetType())

proc scriptGetType*(): GType {.importc: "pango_script_get_type", libpango.}
template pangoTypeScript*(): untyped =
  (scriptGetType())

proc tabAlignGetType*(): GType {.importc: "pango_tab_align_get_type",
                                   libpango.}
template pangoTypeTabAlign*(): untyped =
  (tabAlignGetType())

type
  GlyphItem* =  ptr GlyphItemObj
  GlyphItemPtr* = ptr GlyphItemObj
  GlyphItemObj* = object
    item*: Item
    glyphs*: GlyphString

template pangoTypeGlyphItem*(): untyped =
  (glyphItemGetType())

proc glyphItemGetType*(): GType {.importc: "pango_glyph_item_get_type",
                                    libpango.}
proc split*(orig: GlyphItem; text: cstring; splitIndex: cint): GlyphItem {.
    importc: "pango_glyph_item_split", libpango.}
proc copy*(orig: GlyphItem): GlyphItem {.
    importc: "pango_glyph_item_copy", libpango.}
proc free*(glyphItem: GlyphItem) {.
    importc: "pango_glyph_item_free", libpango.}
proc applyAttrs*(glyphItem: GlyphItem; text: cstring;
                              list: AttrList): glib.GSList {.
    importc: "pango_glyph_item_apply_attrs", libpango.}
proc letterSpace*(glyphItem: GlyphItem; text: cstring;
                               logAttrs: LogAttr; letterSpacing: cint) {.
    importc: "pango_glyph_item_letter_space", libpango.}
proc getLogicalWidths*(glyphItem: GlyphItem; text: cstring;
                                    logicalWidths: var cint) {.
    importc: "pango_glyph_item_get_logical_widths", libpango.}

type
  GlyphItemIter* =  ptr GlyphItemIterObj
  GlyphItemIterPtr* = ptr GlyphItemIterObj
  GlyphItemIterObj* = object
    glyphItem*: GlyphItem
    text*: cstring
    startGlyph*: cint
    startIndex*: cint
    startChar*: cint
    endGlyph*: cint
    endIndex*: cint
    endChar*: cint

template pangoTypeGlyphItemIter*(): untyped =
  (glyphItemIterGetType())

proc glyphItemIterGetType*(): GType {.importc: "pango_glyph_item_iter_get_type",
                                        libpango.}
proc copy*(orig: GlyphItemIter): GlyphItemIter {.
    importc: "pango_glyph_item_iter_copy", libpango.}
proc free*(iter: GlyphItemIter) {.
    importc: "pango_glyph_item_iter_free", libpango.}
proc initStart*(iter: GlyphItemIter;
                                 glyphItem: GlyphItem; text: cstring): Gboolean {.
    importc: "pango_glyph_item_iter_init_start", libpango.}
proc initEnd*(iter: GlyphItemIter;
                               glyphItem: GlyphItem; text: cstring): Gboolean {.
    importc: "pango_glyph_item_iter_init_end", libpango.}
proc nextCluster*(iter: GlyphItemIter): Gboolean {.
    importc: "pango_glyph_item_iter_next_cluster", libpango.}
proc prevCluster*(iter: GlyphItemIter): Gboolean {.
    importc: "pango_glyph_item_iter_prev_cluster", libpango.}

type
  TabArray* =  ptr TabArrayObj
  TabArrayPtr* = ptr TabArrayObj
  TabArrayObj* = object

type
  TabAlign* {.size: sizeof(cint), pure.} = enum
    LEFT

template pangoTypeTabArray*(): untyped =
  (tabArrayGetType())

proc tabArrayNew*(initialSize: cint; positionsInPixels: Gboolean): TabArray {.
    importc: "pango_tab_array_new", libpango.}
proc tabArrayNewWithPositions*(size: cint; positionsInPixels: Gboolean;
                                   firstAlignment: TabAlign;
                                   firstPosition: cint): TabArray {.
    varargs, importc: "pango_tab_array_new_with_positions", libpango.}
proc tabArrayGetType*(): GType {.importc: "pango_tab_array_get_type",
                                   libpango.}
proc copy*(src: TabArray): TabArray {.
    importc: "pango_tab_array_copy", libpango.}
proc free*(tabArray: TabArray) {.
    importc: "pango_tab_array_free", libpango.}
proc getSize*(tabArray: TabArray): cint {.
    importc: "pango_tab_array_get_size", libpango.}
proc size*(tabArray: TabArray): cint {.
    importc: "pango_tab_array_get_size", libpango.}
proc resize*(tabArray: TabArray; newSize: cint) {.
    importc: "pango_tab_array_resize", libpango.}
proc setTab*(tabArray: TabArray; tabIndex: cint;
                         alignment: TabAlign; location: cint) {.
    importc: "pango_tab_array_set_tab", libpango.}
proc `tab=`*(tabArray: TabArray; tabIndex: cint;
                         alignment: TabAlign; location: cint) {.
    importc: "pango_tab_array_set_tab", libpango.}
proc getTab*(tabArray: TabArray; tabIndex: cint;
                         alignment: ptr TabAlign; location: var cint) {.
    importc: "pango_tab_array_get_tab", libpango.}
proc getTabs*(tabArray: TabArray;
                          alignments: ptr ptr TabAlign; locations: var ptr cint) {.
    importc: "pango_tab_array_get_tabs", libpango.}
proc getPositionsInPixels*(tabArray: TabArray): Gboolean {.
    importc: "pango_tab_array_get_positions_in_pixels", libpango.}
proc positionsInPixels*(tabArray: TabArray): Gboolean {.
    importc: "pango_tab_array_get_positions_in_pixels", libpango.}

type
  Layout* =  ptr LayoutObj
  LayoutPtr* = ptr LayoutObj
  LayoutObj* = object

type
  LayoutRun* =  ptr LayoutRunObj
  LayoutRunPtr* = ptr LayoutRunObj
  LayoutRunObj* = GlyphItemObj

type
  Alignment* {.size: sizeof(cint), pure.} = enum
    ALIGN_LEFT, ALIGN_CENTER, ALIGN_RIGHT

type
  WrapMode* {.size: sizeof(cint), pure.} = enum
    WORD, CHAR, WORD_CHAR

type
  EllipsizeMode* {.size: sizeof(cint), pure.} = enum
    NONE, START, MIDDLE,
    `END`
type
  RenderPart* {.size: sizeof(cint), pure.} = enum
    FOREGROUND, BACKGROUND,
    UNDERLINE, STRIKETHROUGH

type
  LayoutLine* =  ptr LayoutLineObj
  LayoutLinePtr* = ptr LayoutLineObj
  LayoutLineObj* = object
    layout*: Layout
    startIndex*: cint
    length*: cint
    runs*: glib.GSList
    isParagraphStart* {.bitsize: 1.}: cuint
    resolvedDir* {.bitsize: 3.}: cuint

template pangoTypeLayout*(): untyped =
  (layoutGetType())

template pangoLayout*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeLayout, LayoutObj))

template pangoLayoutClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, pangoTypeLayout, LayoutClass))

template pangoIsLayout*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeLayout))

template pangoIsLayoutClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, pangoTypeLayout))

template pangoLayoutGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, pangoTypeLayout, LayoutClass))

proc layoutGetType*(): GType {.importc: "pango_layout_get_type", libpango.}
proc layoutNew*(context: Context): Layout {.
    importc: "pango_layout_new", libpango.}
proc copy*(src: Layout): Layout {.
    importc: "pango_layout_copy", libpango.}
proc getContext*(layout: Layout): Context {.
    importc: "pango_layout_get_context", libpango.}
proc context*(layout: Layout): Context {.
    importc: "pango_layout_get_context", libpango.}
proc setAttributes*(layout: Layout; attrs: AttrList) {.
    importc: "pango_layout_set_attributes", libpango.}
proc `attributes=`*(layout: Layout; attrs: AttrList) {.
    importc: "pango_layout_set_attributes", libpango.}
proc getAttributes*(layout: Layout): AttrList {.
    importc: "pango_layout_get_attributes", libpango.}
proc attributes*(layout: Layout): AttrList {.
    importc: "pango_layout_get_attributes", libpango.}
proc setText*(layout: Layout; text: cstring; length: cint) {.
    importc: "pango_layout_set_text", libpango.}
proc `text=`*(layout: Layout; text: cstring; length: cint) {.
    importc: "pango_layout_set_text", libpango.}
proc getText*(layout: Layout): cstring {.
    importc: "pango_layout_get_text", libpango.}
proc text*(layout: Layout): cstring {.
    importc: "pango_layout_get_text", libpango.}
proc getCharacterCount*(layout: Layout): cint {.
    importc: "pango_layout_get_character_count", libpango.}
proc characterCount*(layout: Layout): cint {.
    importc: "pango_layout_get_character_count", libpango.}
proc setMarkup*(layout: Layout; markup: cstring; length: cint) {.
    importc: "pango_layout_set_markup", libpango.}
proc `markup=`*(layout: Layout; markup: cstring; length: cint) {.
    importc: "pango_layout_set_markup", libpango.}
proc setMarkupWithAccel*(layout: Layout; markup: cstring;
                                   length: cint; accelMarker: Gunichar;
                                   accelChar: var Gunichar) {.
    importc: "pango_layout_set_markup_with_accel", libpango.}
proc `markupWithAccel=`*(layout: Layout; markup: cstring;
                                   length: cint; accelMarker: Gunichar;
                                   accelChar: var Gunichar) {.
    importc: "pango_layout_set_markup_with_accel", libpango.}
proc setFontDescription*(layout: Layout;
                                   desc: FontDescription) {.
    importc: "pango_layout_set_font_description", libpango.}
proc `fontDescription=`*(layout: Layout;
                                   desc: FontDescription) {.
    importc: "pango_layout_set_font_description", libpango.}
proc getFontDescription*(layout: Layout): FontDescription {.
    importc: "pango_layout_get_font_description", libpango.}
proc fontDescription*(layout: Layout): FontDescription {.
    importc: "pango_layout_get_font_description", libpango.}
proc setWidth*(layout: Layout; width: cint) {.
    importc: "pango_layout_set_width", libpango.}
proc `width=`*(layout: Layout; width: cint) {.
    importc: "pango_layout_set_width", libpango.}
proc getWidth*(layout: Layout): cint {.
    importc: "pango_layout_get_width", libpango.}
proc width*(layout: Layout): cint {.
    importc: "pango_layout_get_width", libpango.}
proc setHeight*(layout: Layout; height: cint) {.
    importc: "pango_layout_set_height", libpango.}
proc `height=`*(layout: Layout; height: cint) {.
    importc: "pango_layout_set_height", libpango.}
proc getHeight*(layout: Layout): cint {.
    importc: "pango_layout_get_height", libpango.}
proc height*(layout: Layout): cint {.
    importc: "pango_layout_get_height", libpango.}
proc setWrap*(layout: Layout; wrap: WrapMode) {.
    importc: "pango_layout_set_wrap", libpango.}
proc `wrap=`*(layout: Layout; wrap: WrapMode) {.
    importc: "pango_layout_set_wrap", libpango.}
proc getWrap*(layout: Layout): WrapMode {.
    importc: "pango_layout_get_wrap", libpango.}
proc wrap*(layout: Layout): WrapMode {.
    importc: "pango_layout_get_wrap", libpango.}
proc isWrapped*(layout: Layout): Gboolean {.
    importc: "pango_layout_is_wrapped", libpango.}
proc setIndent*(layout: Layout; indent: cint) {.
    importc: "pango_layout_set_indent", libpango.}
proc `indent=`*(layout: Layout; indent: cint) {.
    importc: "pango_layout_set_indent", libpango.}
proc getIndent*(layout: Layout): cint {.
    importc: "pango_layout_get_indent", libpango.}
proc indent*(layout: Layout): cint {.
    importc: "pango_layout_get_indent", libpango.}
proc setSpacing*(layout: Layout; spacing: cint) {.
    importc: "pango_layout_set_spacing", libpango.}
proc `spacing=`*(layout: Layout; spacing: cint) {.
    importc: "pango_layout_set_spacing", libpango.}
proc getSpacing*(layout: Layout): cint {.
    importc: "pango_layout_get_spacing", libpango.}
proc spacing*(layout: Layout): cint {.
    importc: "pango_layout_get_spacing", libpango.}
proc setJustify*(layout: Layout; justify: Gboolean) {.
    importc: "pango_layout_set_justify", libpango.}
proc `justify=`*(layout: Layout; justify: Gboolean) {.
    importc: "pango_layout_set_justify", libpango.}
proc getJustify*(layout: Layout): Gboolean {.
    importc: "pango_layout_get_justify", libpango.}
proc justify*(layout: Layout): Gboolean {.
    importc: "pango_layout_get_justify", libpango.}
proc setAutoDir*(layout: Layout; autoDir: Gboolean) {.
    importc: "pango_layout_set_auto_dir", libpango.}
proc `autoDir=`*(layout: Layout; autoDir: Gboolean) {.
    importc: "pango_layout_set_auto_dir", libpango.}
proc getAutoDir*(layout: Layout): Gboolean {.
    importc: "pango_layout_get_auto_dir", libpango.}
proc autoDir*(layout: Layout): Gboolean {.
    importc: "pango_layout_get_auto_dir", libpango.}
proc setAlignment*(layout: Layout; alignment: Alignment) {.
    importc: "pango_layout_set_alignment", libpango.}
proc `alignment=`*(layout: Layout; alignment: Alignment) {.
    importc: "pango_layout_set_alignment", libpango.}
proc getAlignment*(layout: Layout): Alignment {.
    importc: "pango_layout_get_alignment", libpango.}
proc alignment*(layout: Layout): Alignment {.
    importc: "pango_layout_get_alignment", libpango.}
proc setTabs*(layout: Layout; tabs: TabArray) {.
    importc: "pango_layout_set_tabs", libpango.}
proc `tabs=`*(layout: Layout; tabs: TabArray) {.
    importc: "pango_layout_set_tabs", libpango.}
proc getTabs*(layout: Layout): TabArray {.
    importc: "pango_layout_get_tabs", libpango.}
proc tabs*(layout: Layout): TabArray {.
    importc: "pango_layout_get_tabs", libpango.}
proc setSingleParagraphMode*(layout: Layout; setting: Gboolean) {.
    importc: "pango_layout_set_single_paragraph_mode", libpango.}
proc `singleParagraphMode=`*(layout: Layout; setting: Gboolean) {.
    importc: "pango_layout_set_single_paragraph_mode", libpango.}
proc getSingleParagraphMode*(layout: Layout): Gboolean {.
    importc: "pango_layout_get_single_paragraph_mode", libpango.}
proc singleParagraphMode*(layout: Layout): Gboolean {.
    importc: "pango_layout_get_single_paragraph_mode", libpango.}
proc setEllipsize*(layout: Layout; ellipsize: EllipsizeMode) {.
    importc: "pango_layout_set_ellipsize", libpango.}
proc `ellipsize=`*(layout: Layout; ellipsize: EllipsizeMode) {.
    importc: "pango_layout_set_ellipsize", libpango.}
proc getEllipsize*(layout: Layout): EllipsizeMode {.
    importc: "pango_layout_get_ellipsize", libpango.}
proc ellipsize*(layout: Layout): EllipsizeMode {.
    importc: "pango_layout_get_ellipsize", libpango.}
proc isEllipsized*(layout: Layout): Gboolean {.
    importc: "pango_layout_is_ellipsized", libpango.}
proc getUnknownGlyphsCount*(layout: Layout): cint {.
    importc: "pango_layout_get_unknown_glyphs_count", libpango.}
proc unknownGlyphsCount*(layout: Layout): cint {.
    importc: "pango_layout_get_unknown_glyphs_count", libpango.}
proc contextChanged*(layout: Layout) {.
    importc: "pango_layout_context_changed", libpango.}
proc getSerial*(layout: Layout): cuint {.
    importc: "pango_layout_get_serial", libpango.}
proc serial*(layout: Layout): cuint {.
    importc: "pango_layout_get_serial", libpango.}
proc getLogAttrs*(layout: Layout; attrs: var LogAttr;
                            nAttrs: var cint) {.
    importc: "pango_layout_get_log_attrs", libpango.}
proc getLogAttrsReadonly*(layout: Layout; nAttrs: var cint): LogAttr {.
    importc: "pango_layout_get_log_attrs_readonly", libpango.}
proc logAttrsReadonly*(layout: Layout; nAttrs: var cint): LogAttr {.
    importc: "pango_layout_get_log_attrs_readonly", libpango.}
proc indexToPos*(layout: Layout; index: cint;
                           pos: Rectangle) {.
    importc: "pango_layout_index_to_pos", libpango.}
proc indexToLineX*(layout: Layout; index: cint;
                             trailing: Gboolean; line: var cint; xPos: var cint) {.
    importc: "pango_layout_index_to_line_x", libpango.}
proc getCursorPos*(layout: Layout; index: cint;
                             strongPos: Rectangle;
                             weakPos: Rectangle) {.
    importc: "pango_layout_get_cursor_pos", libpango.}
proc moveCursorVisually*(layout: Layout; strong: Gboolean;
                                   oldIndex: cint; oldTrailing: cint;
                                   direction: cint; newIndex: var cint;
                                   newTrailing: var cint) {.
    importc: "pango_layout_move_cursor_visually", libpango.}
proc xyToIndex*(layout: Layout; x: cint; y: cint; index: var cint;
                          trailing: var cint): Gboolean {.
    importc: "pango_layout_xy_to_index", libpango.}
proc getExtents*(layout: Layout; inkRect: Rectangle;
                           logicalRect: Rectangle) {.
    importc: "pango_layout_get_extents", libpango.}
proc getPixelExtents*(layout: Layout;
                                inkRect: Rectangle;
                                logicalRect: Rectangle) {.
    importc: "pango_layout_get_pixel_extents", libpango.}
proc getSize*(layout: Layout; width: var cint; height: var cint) {.
    importc: "pango_layout_get_size", libpango.}
proc getPixelSize*(layout: Layout; width: var cint;
                             height: var cint) {.
    importc: "pango_layout_get_pixel_size", libpango.}
proc getBaseline*(layout: Layout): cint {.
    importc: "pango_layout_get_baseline", libpango.}
proc baseline*(layout: Layout): cint {.
    importc: "pango_layout_get_baseline", libpango.}
proc getLineCount*(layout: Layout): cint {.
    importc: "pango_layout_get_line_count", libpango.}
proc lineCount*(layout: Layout): cint {.
    importc: "pango_layout_get_line_count", libpango.}
proc getLine*(layout: Layout; line: cint): LayoutLine {.
    importc: "pango_layout_get_line", libpango.}
proc line*(layout: Layout; line: cint): LayoutLine {.
    importc: "pango_layout_get_line", libpango.}
proc getLineReadonly*(layout: Layout; line: cint): LayoutLine {.
    importc: "pango_layout_get_line_readonly", libpango.}
proc lineReadonly*(layout: Layout; line: cint): LayoutLine {.
    importc: "pango_layout_get_line_readonly", libpango.}
proc getLines*(layout: Layout): glib.GSList {.
    importc: "pango_layout_get_lines", libpango.}
proc lines*(layout: Layout): glib.GSList {.
    importc: "pango_layout_get_lines", libpango.}
proc getLinesReadonly*(layout: Layout): glib.GSList {.
    importc: "pango_layout_get_lines_readonly", libpango.}
proc linesReadonly*(layout: Layout): glib.GSList {.
    importc: "pango_layout_get_lines_readonly", libpango.}
template pangoTypeLayoutLine*(): untyped =
  (layoutLineGetType())

proc layoutLineGetType*(): GType {.importc: "pango_layout_line_get_type",
                                     libpango.}
proc `ref`*(line: LayoutLine): LayoutLine {.
    importc: "pango_layout_line_ref", libpango.}
proc unref*(line: LayoutLine) {.
    importc: "pango_layout_line_unref", libpango.}
proc xToIndex*(line: LayoutLine; xPos: cint; index: var cint;
                             trailing: var cint): Gboolean {.
    importc: "pango_layout_line_x_to_index", libpango.}
proc indexToX*(line: LayoutLine; index: cint;
                             trailing: Gboolean; xPos: var cint) {.
    importc: "pango_layout_line_index_to_x", libpango.}
proc getXRanges*(line: LayoutLine; startIndex: cint;
                               endIndex: cint; ranges: var ptr cint; nRanges: var cint) {.
    importc: "pango_layout_line_get_x_ranges", libpango.}
proc getExtents*(line: LayoutLine;
                               inkRect: Rectangle;
                               logicalRect: Rectangle) {.
    importc: "pango_layout_line_get_extents", libpango.}
proc getPixelExtents*(layoutLine: LayoutLine;
                                    inkRect: Rectangle;
                                    logicalRect: Rectangle) {.
    importc: "pango_layout_line_get_pixel_extents", libpango.}
type
  LayoutIter* =  ptr LayoutIterObj
  LayoutIterPtr* = ptr LayoutIterObj
  LayoutIterObj* = object

template pangoTypeLayoutIter*(): untyped =
  (layoutIterGetType())

proc layoutIterGetType*(): GType {.importc: "pango_layout_iter_get_type",
                                     libpango.}
proc getIter*(layout: Layout): LayoutIter {.
    importc: "pango_layout_get_iter", libpango.}
proc iter*(layout: Layout): LayoutIter {.
    importc: "pango_layout_get_iter", libpango.}
proc copy*(iter: LayoutIter): LayoutIter {.
    importc: "pango_layout_iter_copy", libpango.}
proc free*(iter: LayoutIter) {.
    importc: "pango_layout_iter_free", libpango.}
proc getIndex*(iter: LayoutIter): cint {.
    importc: "pango_layout_iter_get_index", libpango.}
proc index*(iter: LayoutIter): cint {.
    importc: "pango_layout_iter_get_index", libpango.}
proc getRun*(iter: LayoutIter): LayoutRun {.
    importc: "pango_layout_iter_get_run", libpango.}
proc run*(iter: LayoutIter): LayoutRun {.
    importc: "pango_layout_iter_get_run", libpango.}
proc getRunReadonly*(iter: LayoutIter): LayoutRun {.
    importc: "pango_layout_iter_get_run_readonly", libpango.}
proc runReadonly*(iter: LayoutIter): LayoutRun {.
    importc: "pango_layout_iter_get_run_readonly", libpango.}
proc getLine*(iter: LayoutIter): LayoutLine {.
    importc: "pango_layout_iter_get_line", libpango.}
proc line*(iter: LayoutIter): LayoutLine {.
    importc: "pango_layout_iter_get_line", libpango.}
proc getLineReadonly*(iter: LayoutIter): LayoutLine {.
    importc: "pango_layout_iter_get_line_readonly", libpango.}
proc lineReadonly*(iter: LayoutIter): LayoutLine {.
    importc: "pango_layout_iter_get_line_readonly", libpango.}
proc atLastLine*(iter: LayoutIter): Gboolean {.
    importc: "pango_layout_iter_at_last_line", libpango.}
proc getLayout*(iter: LayoutIter): Layout {.
    importc: "pango_layout_iter_get_layout", libpango.}
proc layout*(iter: LayoutIter): Layout {.
    importc: "pango_layout_iter_get_layout", libpango.}
proc nextChar*(iter: LayoutIter): Gboolean {.
    importc: "pango_layout_iter_next_char", libpango.}
proc nextCluster*(iter: LayoutIter): Gboolean {.
    importc: "pango_layout_iter_next_cluster", libpango.}
proc nextRun*(iter: LayoutIter): Gboolean {.
    importc: "pango_layout_iter_next_run", libpango.}
proc nextLine*(iter: LayoutIter): Gboolean {.
    importc: "pango_layout_iter_next_line", libpango.}
proc getCharExtents*(iter: LayoutIter;
                                   logicalRect: Rectangle) {.
    importc: "pango_layout_iter_get_char_extents", libpango.}
proc getClusterExtents*(iter: LayoutIter;
                                      inkRect: Rectangle;
                                      logicalRect: Rectangle) {.
    importc: "pango_layout_iter_get_cluster_extents", libpango.}
proc getRunExtents*(iter: LayoutIter;
                                  inkRect: Rectangle;
                                  logicalRect: Rectangle) {.
    importc: "pango_layout_iter_get_run_extents", libpango.}
proc getLineExtents*(iter: LayoutIter;
                                   inkRect: Rectangle;
                                   logicalRect: Rectangle) {.
    importc: "pango_layout_iter_get_line_extents", libpango.}

proc getLineYrange*(iter: LayoutIter; y0: var cint;
                                  y1: var cint) {.
    importc: "pango_layout_iter_get_line_yrange", libpango.}
proc getLayoutExtents*(iter: LayoutIter;
                                     inkRect: Rectangle;
                                     logicalRect: Rectangle) {.
    importc: "pango_layout_iter_get_layout_extents", libpango.}
proc getBaseline*(iter: LayoutIter): cint {.
    importc: "pango_layout_iter_get_baseline", libpango.}
proc baseline*(iter: LayoutIter): cint {.
    importc: "pango_layout_iter_get_baseline", libpango.}

type
  RendererPrivateObj = object

  Renderer* =  ptr RendererObj
  RendererPtr* = ptr RendererObj
  RendererObj* = object of GObjectObj
    underline*: Underline
    strikethrough*: Gboolean
    activeCount*: cint
    matrix*: Matrix
    priv*: ptr RendererPrivateObj

  RendererClass* =  ptr RendererClassObj
  RendererClassPtr* = ptr RendererClassObj
  RendererClassObj* = object of GObjectClassObj
    drawGlyphs*: proc (renderer: Renderer; font: Font;
                     glyphs: GlyphString; x: cint; y: cint) {.cdecl.}
    drawRectangle*: proc (renderer: Renderer; part: RenderPart; x: cint;
                        y: cint; width: cint; height: cint) {.cdecl.}
    drawErrorUnderline*: proc (renderer: Renderer; x: cint; y: cint;
                             width: cint; height: cint) {.cdecl.}
    drawShape*: proc (renderer: Renderer; attr: AttrShape; x: cint;
                    y: cint) {.cdecl.}
    drawTrapezoid*: proc (renderer: Renderer; part: RenderPart;
                        y1: cdouble; x11: cdouble; x21: cdouble; y2: cdouble;
                        x12: cdouble; x22: cdouble) {.cdecl.}
    drawGlyph*: proc (renderer: Renderer; font: Font;
                    glyph: Glyph; x: cdouble; y: cdouble) {.cdecl.}
    partChanged*: proc (renderer: Renderer; part: RenderPart) {.cdecl.}
    begin*: proc (renderer: Renderer) {.cdecl.}
    `end`*: proc (renderer: Renderer) {.cdecl.}
    prepareRun*: proc (renderer: Renderer; run: LayoutRun) {.cdecl.}
    drawGlyphItem*: proc (renderer: Renderer; text: cstring;
                        glyphItem: GlyphItem; x: cint; y: cint) {.cdecl.}
    pangoReserved2*: proc () {.cdecl.}
    pangoReserved3*: proc () {.cdecl.}
    pangoReserved4*: proc () {.cdecl.}

template pangoTypeRenderer*(): untyped =
  (rendererGetType())

template pangoRenderer*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, pangoTypeRenderer, RendererObj))

template pangoIsRenderer*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, pangoTypeRenderer))

template pangoRendererClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, pangoTypeRenderer, RendererClassObj))

template pangoIsRendererClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, pangoTypeRenderer))

template pangoRendererGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, pangoTypeRenderer, RendererClassObj))

proc rendererGetType*(): GType {.importc: "pango_renderer_get_type", libpango.}
proc drawLayout*(renderer: Renderer; layout: Layout;
                             x: cint; y: cint) {.
    importc: "pango_renderer_draw_layout", libpango.}
proc drawLayoutLine*(renderer: Renderer;
                                 line: LayoutLine; x: cint; y: cint) {.
    importc: "pango_renderer_draw_layout_line", libpango.}
proc drawGlyphs*(renderer: Renderer; font: Font;
                             glyphs: GlyphString; x: cint; y: cint) {.
    importc: "pango_renderer_draw_glyphs", libpango.}
proc drawGlyphItem*(renderer: Renderer; text: cstring;
                                glyphItem: GlyphItem; x: cint; y: cint) {.
    importc: "pango_renderer_draw_glyph_item", libpango.}
proc drawRectangle*(renderer: Renderer; part: RenderPart;
                                x: cint; y: cint; width: cint; height: cint) {.
    importc: "pango_renderer_draw_rectangle", libpango.}
proc drawErrorUnderline*(renderer: Renderer; x: cint; y: cint;
                                     width: cint; height: cint) {.
    importc: "pango_renderer_draw_error_underline", libpango.}
proc drawTrapezoid*(renderer: Renderer; part: RenderPart;
                                y1: cdouble; x11: cdouble; x21: cdouble; y2: cdouble;
                                x12: cdouble; x22: cdouble) {.
    importc: "pango_renderer_draw_trapezoid", libpango.}
proc drawGlyph*(renderer: Renderer; font: Font;
                            glyph: Glyph; x: cdouble; y: cdouble) {.
    importc: "pango_renderer_draw_glyph", libpango.}
proc activate*(renderer: Renderer) {.
    importc: "pango_renderer_activate", libpango.}
proc deactivate*(renderer: Renderer) {.
    importc: "pango_renderer_deactivate", libpango.}
proc partChanged*(renderer: Renderer; part: RenderPart) {.
    importc: "pango_renderer_part_changed", libpango.}
proc setColor*(renderer: Renderer; part: RenderPart;
                           color: Color) {.
    importc: "pango_renderer_set_color", libpango.}
proc `color=`*(renderer: Renderer; part: RenderPart;
                           color: Color) {.
    importc: "pango_renderer_set_color", libpango.}
proc getColor*(renderer: Renderer; part: RenderPart): Color {.
    importc: "pango_renderer_get_color", libpango.}
proc color*(renderer: Renderer; part: RenderPart): Color {.
    importc: "pango_renderer_get_color", libpango.}
proc setAlpha*(renderer: Renderer; part: RenderPart;
                           alpha: uint16) {.importc: "pango_renderer_set_alpha",
    libpango.}
proc `alpha=`*(renderer: Renderer; part: RenderPart;
                           alpha: uint16) {.importc: "pango_renderer_set_alpha",
    libpango.}
proc getAlpha*(renderer: Renderer; part: RenderPart): uint16 {.
    importc: "pango_renderer_get_alpha", libpango.}
proc alpha*(renderer: Renderer; part: RenderPart): uint16 {.
    importc: "pango_renderer_get_alpha", libpango.}
proc setMatrix*(renderer: Renderer; matrix: Matrix) {.
    importc: "pango_renderer_set_matrix", libpango.}
proc `matrix=`*(renderer: Renderer; matrix: Matrix) {.
    importc: "pango_renderer_set_matrix", libpango.}
proc getMatrix*(renderer: Renderer): Matrix {.
    importc: "pango_renderer_get_matrix", libpango.}
proc matrix*(renderer: Renderer): Matrix {.
    importc: "pango_renderer_get_matrix", libpango.}
proc getLayout*(renderer: Renderer): Layout {.
    importc: "pango_renderer_get_layout", libpango.}
proc layout*(renderer: Renderer): Layout {.
    importc: "pango_renderer_get_layout", libpango.}
proc getLayoutLine*(renderer: Renderer): LayoutLine {.
    importc: "pango_renderer_get_layout_line", libpango.}
proc layoutLine*(renderer: Renderer): LayoutLine {.
    importc: "pango_renderer_get_layout_line", libpango.}

proc splitFileList*(str: cstring): cstringArray {.
    importc: "pango_split_file_list", libpango.}
proc trimString*(str: cstring): cstring {.importc: "pango_trim_string",
    libpango.}
proc readLine*(stream: ptr File; str: glib.GString): cint {.
    importc: "pango_read_line", libpango.}
proc skipSpace*(pos: cstringArray): Gboolean {.importc: "pango_skip_space",
    libpango.}
proc scanWord*(pos: cstringArray; `out`: glib.GString): Gboolean {.
    importc: "pango_scan_word", libpango.}
proc scanString*(pos: cstringArray; `out`: glib.GString): Gboolean {.
    importc: "pango_scan_string", libpango.}
proc scanInt*(pos: cstringArray; `out`: var cint): Gboolean {.
    importc: "pango_scan_int", libpango.}
when (ENABLE_BACKEND):
  proc configKeyGetSystem*(key: cstring): cstring {.
      importc: "pango_config_key_get_system", libpango.}
  proc configKeyGet*(key: cstring): cstring {.importc: "pango_config_key_get",
      libpango.}
  proc lookupAliases*(fontname: cstring; families: ptr cstringArray;
                          nFamilies: var cint) {.importc: "pango_lookup_aliases",
      libpango.}
proc parseEnum*(`type`: GType; str: cstring; value: var cint; warn: Gboolean;
                    possibleValues: cstringArray): Gboolean {.
    importc: "pango_parse_enum", libpango.}

proc parseStyle*(str: cstring; style: var Style; warn: Gboolean): Gboolean {.
    importc: "pango_parse_style", libpango.}
proc parseVariant*(str: cstring; variant: var Variant; warn: Gboolean): Gboolean {.
    importc: "pango_parse_variant", libpango.}
proc parseWeight*(str: cstring; weight: var Weight; warn: Gboolean): Gboolean {.
    importc: "pango_parse_weight", libpango.}
proc parseStretch*(str: cstring; stretch: var Stretch; warn: Gboolean): Gboolean {.
    importc: "pango_parse_stretch", libpango.}
when (ENABLE_BACKEND):
  proc getSysconfSubdirectory*(): cstring {.
      importc: "pango_get_sysconf_subdirectory", libpango.}
  proc sysconfSubdirectory*(): cstring {.
      importc: "pango_get_sysconf_subdirectory", libpango.}
  proc getLibSubdirectory*(): cstring {.importc: "pango_get_lib_subdirectory",
      libpango.}
  proc libSubdirectory*(): cstring {.importc: "pango_get_lib_subdirectory",
      libpango.}

proc quantizeLineGeometry*(thickness: var cint; position: var cint) {.
    importc: "pango_quantize_line_geometry", libpango.}

proc log2visGetEmbeddingLevels*(text: cstring; length: cint;
                                    pbaseDir: var Direction): ptr uint8 {.
    importc: "pango_log2vis_get_embedding_levels", libpango.}

proc isZeroWidth*(ch: Gunichar): Gboolean {.importc: "pango_is_zero_width",
    libpango.}

template pangoVersionEncode*(major, minor, micro: untyped): untyped =
  ((major * 10000) + (minor * 100) + (micro * 1))

const
  VERSION* = pangoVersionEncode(VERSION_MAJOR, VERSION_MINOR,
                                      VERSION_MICRO)

template pangoVersionCheck*(major, minor, micro: untyped): untyped =
  (pango_Version >= pangoVersionEncode(major, minor, micro))

proc version*(): cint {.importc: "pango_version", libpango.}

proc versionString*(): cstring {.importc: "pango_version_string", libpango.}

proc versionCheck*(requiredMajor: cint; requiredMinor: cint; requiredMicro: cint): cstring {.
    importc: "pango_version_check", libpango.}

template i*(string: untyped): untyped =
  gInternStaticString(string)

proc shapeShape*(text: cstring; nChars: cuint; shapeInk: Rectangle;
                     shapeLogical: Rectangle; glyphs: GlyphString) {.
    importc: "_pango_shape_shape", libpango.}
proc shapeGetExtents*(nChars: cint; shapeInk: Rectangle;
                          shapeLogical: Rectangle;
                          inkRect: Rectangle;
                          logicalRect: Rectangle) {.
    importc: "_pango_shape_get_extents", libpango.}

when (ENABLE_BACKEND):
  type
    Map* =  ptr MapObj
    MapPtr* = ptr MapObj
    MapObj* = object

  type
    IncludedModule* =  ptr IncludedModuleObj
    IncludedModulePtr* = ptr IncludedModuleObj
    IncludedModuleObj* = object
      list*: proc (engines: var EngineInfo; nEngines: var cint) {.cdecl.}
      init*: proc (module: gobject.GTypeModule) {.cdecl.}
      exit*: proc () {.cdecl.}
      create*: proc (id: cstring): Engine {.cdecl.}

  proc findMap*(language: Language; engineTypeId: cuint;
                    renderTypeId: cuint): Map {.importc: "pango_find_map",
      libpango.}
  proc getEngine*(map: Map; script: Script): Engine {.
      importc: "pango_map_get_engine", libpango.}
  proc engine*(map: Map; script: Script): Engine {.
      importc: "pango_map_get_engine", libpango.}
  proc getEngines*(map: Map; script: Script;
                          exactEngines: var glib.GSList;
                          fallbackEngines: var glib.GSList) {.
      importc: "pango_map_get_engines", libpango.}
  proc moduleRegister*(module: IncludedModule) {.
      importc: "pango_module_register", libpango.}
