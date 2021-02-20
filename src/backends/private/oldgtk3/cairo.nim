 {.deadCodeElim: on.}
include "cairo_pragma.nim"
const 
  CAIRO_HAS_TEE_SURFACE = true
  CAIRO_HAS_DRM_SURFACE = true
  CAIRO_HAS_SKIA_SURFACE = true
  CAIRO_HAS_SCRIPT_SURFACE = true
  CAIRO_HAS_XML_SURFACE = true
  CAIRO_HAS_SVG_SURFACE = true
  CAIRO_HAS_PS_SURFACE = true
  CAIRO_HAS_PDF_SURFACE = true
  CAIRO_HAS_PNG_FUNCTIONS = true

template cairo_Version_Encode*(major, minor, micro: untyped): untyped =
  ((major * 10000) + (minor * 100) + (micro * 1))

proc version*(): cint {.importc: "cairo_version", libcairo.}
proc versionString*(): cstring {.importc: "cairo_version_string", libcairo.}

type
  CairoBoolT* = distinct cint

# we should not need these constants often, because we have converters to and from Nim bool
const
  CAIRO_FALSE* = CairoBoolT(0)
  CAIRO_TRUE* = CairoBoolT(1)

converter cbool*(nimbool: bool): CairoBoolT =
  ord(nimbool).CairoBoolT

converter toBool*(cbool: CairoBoolT): bool =
  int(cbool) != 0

type
  Context* =  ptr ContextObj
  ContextPtr* = ptr ContextObj
  ContextObj* = object

type
  Surface* =  ptr SurfaceObj
  SurfacePtr* = ptr SurfaceObj
  SurfaceObj* = object

type
  Device* =  ptr DeviceObj
  DevicePtr* = ptr DeviceObj
  DeviceObj* = object

type
  Matrix* =  ptr MatrixObj
  MatrixPtr* = ptr MatrixObj
  MatrixObj* = object
    xx*: cdouble
    yx*: cdouble
    xy*: cdouble
    yy*: cdouble
    x0*: cdouble
    y0*: cdouble

converter matrixobj2matrix(m: var MatrixObj): Matrix =
  addr(m)
type
  Pattern* =  ptr PatternObj
  PatternPtr* = ptr PatternObj
  PatternObj* = object

type
  CairoDestroyFuncT* = proc (data: pointer) {.cdecl.}

type
  UserDataKey* =  ptr UserDataKeyObj
  UserDataKeyPtr* = ptr UserDataKeyObj
  UserDataKeyObj* = object
    unused: cint

type
  Status* {.size: sizeof(cint), pure.} = enum
    SUCCESS = 0, NO_MEMORY, INVALID_RESTORE,
    INVALID_POP_GROUP, NO_CURRENT_POINT,
    INVALID_MATRIX, INVALID_STATUS,
    NULL_POINTER, INVALID_STRING,
    INVALID_PATH_DATA, READ_ERROR,
    WRITE_ERROR, SURFACE_FINISHED,
    SURFACE_TYPE_MISMATCH, PATTERN_TYPE_MISMATCH,
    INVALID_CONTENT, INVALID_FORMAT,
    INVALID_VISUAL, FILE_NOT_FOUND,
    INVALID_DASH, INVALID_DSC_COMMENT,
    INVALID_INDEX, CLIP_NOT_REPRESENTABLE,
    TEMP_FILE_ERROR, INVALID_STRIDE,
    FONT_TYPE_MISMATCH, USER_FONT_IMMUTABLE,
    USER_FONT_ERROR, NEGATIVE_COUNT,
    INVALID_CLUSTERS, INVALID_SLANT,
    INVALID_WEIGHT, INVALID_SIZE,
    USER_FONT_NOT_IMPLEMENTED, DEVICE_TYPE_MISMATCH,
    DEVICE_ERROR, INVALID_MESH_CONSTRUCTION,
    DEVICE_FINISHED, JBIG2_GLOBAL_MISSING,
    PNG_ERROR, FREETYPE_ERROR,
    WIN32_GDI_ERROR, TAG_ERROR, LAST_STATUS

type
  Content* {.size: sizeof(cint), pure.} = enum
    COLOR = 0x1000, ALPHA = 0x2000,
    COLOR_ALPHA = 0x3000

type
  Format* {.size: sizeof(cint), pure.} = enum
    INVALID = - 1, ARGB32 = 0, RGB24 = 1,
    A8 = 2, A1 = 3, RGB16_565 = 4,
    RGB30 = 5

type
  CairoWriteFuncT* = proc (closure: pointer; data: ptr cuchar; length: cuint): Status {.cdecl.}

type
  CairoReadFuncT* = proc (closure: pointer; data: ptr cuchar; length: cuint): Status {.cdecl.}

type
  RectangleInt* =  ptr RectangleIntObj
  RectangleIntPtr* = ptr RectangleIntObj
  RectangleIntObj* = object
    x*: cint
    y*: cint
    width*: cint
    height*: cint

proc create*(target: Surface): Context {.importc: "cairo_create",
    libcairo.}
proc reference*(cr: Context): Context {.importc: "cairo_reference",
    libcairo.}
proc destroy*(cr: Context) {.importc: "cairo_destroy", libcairo.}
proc getReferenceCount*(cr: Context): cuint {.
    importc: "cairo_get_reference_count", libcairo.}
proc referenceCount*(cr: Context): cuint {.
    importc: "cairo_get_reference_count", libcairo.}
proc getUserData*(cr: Context; key: UserDataKey): pointer {.
    importc: "cairo_get_user_data", libcairo.}
proc userData*(cr: Context; key: UserDataKey): pointer {.
    importc: "cairo_get_user_data", libcairo.}
proc setUserData*(cr: Context; key: UserDataKey; userData: pointer;
                      destroy: CairoDestroyFuncT): Status {.
    importc: "cairo_set_user_data", libcairo.}
proc save*(cr: Context) {.importc: "cairo_save", libcairo.}
proc restore*(cr: Context) {.importc: "cairo_restore", libcairo.}
proc pushGroup*(cr: Context) {.importc: "cairo_push_group", libcairo.}
proc pushGroupWithContent*(cr: Context; content: Content) {.
    importc: "cairo_push_group_with_content", libcairo.}
proc popGroup*(cr: Context): Pattern {.importc: "cairo_pop_group",
    libcairo.}
proc popGroupToSource*(cr: Context) {.importc: "cairo_pop_group_to_source",
    libcairo.}

type
  Operator* {.size: sizeof(cint), pure.} = enum
    CLEAR, SOURCE, OVER,
    `IN`, `OUT`, ATOP,
    DEST, DEST_OVER, DEST_IN,
    DEST_OUT, DEST_ATOP, XOR,
    ADD, SATURATE, MULTIPLY,
    SCREEN, OVERLAY, DARKEN,
    LIGHTEN, COLOR_DODGE, COLOR_BURN,
    HARD_LIGHT, SOFT_LIGHT,
    DIFFERENCE, EXCLUSION, HSL_HUE,
    HSL_SATURATION, HSL_COLOR,
    HSL_LUMINOSITY

proc setOperator*(cr: Context; op: Operator) {.
    importc: "cairo_set_operator", libcairo.}

proc `operator=`*(cr: Context; op: Operator) {.
    importc: "cairo_set_operator", libcairo.}
proc setSource*(cr: Context; source: Pattern) {.
    importc: "cairo_set_source", libcairo.}
proc `source=`*(cr: Context; source: Pattern) {.
    importc: "cairo_set_source", libcairo.}
proc setSourceRgb*(cr: Context; red: cdouble; green: cdouble; blue: cdouble) {.
    importc: "cairo_set_source_rgb", libcairo.}
proc `sourceRgb=`*(cr: Context; red: cdouble; green: cdouble; blue: cdouble) {.
    importc: "cairo_set_source_rgb", libcairo.}
proc setSourceRgba*(cr: Context; red: cdouble; green: cdouble; blue: cdouble;
                        alpha: cdouble) {.importc: "cairo_set_source_rgba",
                                        libcairo.}
proc `sourceRgba=`*(cr: Context; red: cdouble; green: cdouble; blue: cdouble;
                        alpha: cdouble) {.importc: "cairo_set_source_rgba",
                                        libcairo.}
proc setSourceSurface*(cr: Context; surface: Surface; x: cdouble;
                           y: cdouble) {.importc: "cairo_set_source_surface",
                                       libcairo.}
proc `sourceSurface=`*(cr: Context; surface: Surface; x: cdouble;
                           y: cdouble) {.importc: "cairo_set_source_surface",
                                       libcairo.}
proc setTolerance*(cr: Context; tolerance: cdouble) {.
    importc: "cairo_set_tolerance", libcairo.}
proc `tolerance=`*(cr: Context; tolerance: cdouble) {.
    importc: "cairo_set_tolerance", libcairo.}

type
  Antialias* {.size: sizeof(cint), pure.} = enum
    DEFAULT, NONE, GRAY,
    SUBPIXEL, FAST, GOOD,
    BEST

proc setAntialias*(cr: Context; antialias: Antialias) {.
    importc: "cairo_set_antialias", libcairo.}

proc `antialias=`*(cr: Context; antialias: Antialias) {.
    importc: "cairo_set_antialias", libcairo.}

type
  FillRule* {.size: sizeof(cint), pure.} = enum
    WINDING, EVEN_ODD

proc setFillRule*(cr: Context; fillRule: FillRule) {.
    importc: "cairo_set_fill_rule", libcairo.}

proc `fillRule=`*(cr: Context; fillRule: FillRule) {.
    importc: "cairo_set_fill_rule", libcairo.}
proc setLineWidth*(cr: Context; width: cdouble) {.
    importc: "cairo_set_line_width", libcairo.}
proc `lineWidth=`*(cr: Context; width: cdouble) {.
    importc: "cairo_set_line_width", libcairo.}

type
  LineCap* {.size: sizeof(cint), pure.} = enum
    BUTT, ROUND, SQUARE

proc setLineCap*(cr: Context; lineCap: LineCap) {.
    importc: "cairo_set_line_cap", libcairo.}

proc `lineCap=`*(cr: Context; lineCap: LineCap) {.
    importc: "cairo_set_line_cap", libcairo.}

type
  LineJoin* {.size: sizeof(cint), pure.} = enum
    MITER, ROUND, BEVEL

proc setLineJoin*(cr: Context; lineJoin: LineJoin) {.
    importc: "cairo_set_line_join", libcairo.}

proc `lineJoin=`*(cr: Context; lineJoin: LineJoin) {.
    importc: "cairo_set_line_join", libcairo.}
proc setDash*(cr: Context; dashes: var cdouble; numDashes: cint; offset: cdouble) {.
    importc: "cairo_set_dash", libcairo.}
proc `dash=`*(cr: Context; dashes: var cdouble; numDashes: cint; offset: cdouble) {.
    importc: "cairo_set_dash", libcairo.}
proc setMiterLimit*(cr: Context; limit: cdouble) {.
    importc: "cairo_set_miter_limit", libcairo.}
proc `miterLimit=`*(cr: Context; limit: cdouble) {.
    importc: "cairo_set_miter_limit", libcairo.}
proc translate*(cr: Context; tx: cdouble; ty: cdouble) {.
    importc: "cairo_translate", libcairo.}
proc scale*(cr: Context; sx: cdouble; sy: cdouble) {.importc: "cairo_scale",
    libcairo.}
proc rotate*(cr: Context; angle: cdouble) {.importc: "cairo_rotate", libcairo.}
proc transform*(cr: Context; matrix: Matrix) {.
    importc: "cairo_transform", libcairo.}
proc setMatrix*(cr: Context; matrix: Matrix) {.
    importc: "cairo_set_matrix", libcairo.}
proc `matrix=`*(cr: Context; matrix: Matrix) {.
    importc: "cairo_set_matrix", libcairo.}
proc identityMatrix*(cr: Context) {.importc: "cairo_identity_matrix",
                                        libcairo.}
proc userToDevice*(cr: Context; x: var cdouble; y: var cdouble) {.
    importc: "cairo_user_to_device", libcairo.}
proc userToDeviceDistance*(cr: Context; dx: var cdouble; dy: var cdouble) {.
    importc: "cairo_user_to_device_distance", libcairo.}
proc deviceToUser*(cr: Context; x: var cdouble; y: var cdouble) {.
    importc: "cairo_device_to_user", libcairo.}
proc deviceToUserDistance*(cr: Context; dx: var cdouble; dy: var cdouble) {.
    importc: "cairo_device_to_user_distance", libcairo.}

proc newPath*(cr: Context) {.importc: "cairo_new_path", libcairo.}
proc moveTo*(cr: Context; x: cdouble; y: cdouble) {.importc: "cairo_move_to",
    libcairo.}
proc newSubPath*(cr: Context) {.importc: "cairo_new_sub_path", libcairo.}
proc lineTo*(cr: Context; x: cdouble; y: cdouble) {.importc: "cairo_line_to",
    libcairo.}
proc curveTo*(cr: Context; x1: cdouble; y1: cdouble; x2: cdouble; y2: cdouble;
                  x3: cdouble; y3: cdouble) {.importc: "cairo_curve_to", libcairo.}
proc arc*(cr: Context; xc: cdouble; yc: cdouble; radius: cdouble; angle1: cdouble;
              angle2: cdouble) {.importc: "cairo_arc", libcairo.}
proc arcNegative*(cr: Context; xc: cdouble; yc: cdouble; radius: cdouble;
                      angle1: cdouble; angle2: cdouble) {.
    importc: "cairo_arc_negative", libcairo.}

proc relMoveTo*(cr: Context; dx: cdouble; dy: cdouble) {.
    importc: "cairo_rel_move_to", libcairo.}
proc relLineTo*(cr: Context; dx: cdouble; dy: cdouble) {.
    importc: "cairo_rel_line_to", libcairo.}
proc relCurveTo*(cr: Context; dx1: cdouble; dy1: cdouble; dx2: cdouble;
                     dy2: cdouble; dx3: cdouble; dy3: cdouble) {.
    importc: "cairo_rel_curve_to", libcairo.}
proc rectangle*(cr: Context; x: cdouble; y: cdouble; width: cdouble;
                    height: cdouble) {.importc: "cairo_rectangle", libcairo.}

proc closePath*(cr: Context) {.importc: "cairo_close_path", libcairo.}
proc pathExtents*(cr: Context; x1: var cdouble; y1: var cdouble; x2: var cdouble;
                      y2: var cdouble) {.importc: "cairo_path_extents", libcairo.}

proc paint*(cr: Context) {.importc: "cairo_paint", libcairo.}
proc paintWithAlpha*(cr: Context; alpha: cdouble) {.
    importc: "cairo_paint_with_alpha", libcairo.}
proc paint*(cr: Context; alpha: cdouble) {.
    importc: "cairo_paint_with_alpha", libcairo.}
proc mask*(cr: Context; pattern: Pattern) {.importc: "cairo_mask",
    libcairo.}
proc maskSurface*(cr: Context; surface: Surface; surfaceX: cdouble;
                      surfaceY: cdouble) {.importc: "cairo_mask_surface",
    libcairo.}
proc stroke*(cr: Context) {.importc: "cairo_stroke", libcairo.}
proc strokePreserve*(cr: Context) {.importc: "cairo_stroke_preserve",
                                        libcairo.}
proc fill*(cr: Context) {.importc: "cairo_fill", libcairo.}
proc fillPreserve*(cr: Context) {.importc: "cairo_fill_preserve", libcairo.}
proc copyPage*(cr: Context) {.importc: "cairo_copy_page", libcairo.}
proc showPage*(cr: Context) {.importc: "cairo_show_page", libcairo.}

proc inStroke*(cr: Context; x: cdouble; y: cdouble): CairoBoolT {.
    importc: "cairo_in_stroke", libcairo.}
proc inFill*(cr: Context; x: cdouble; y: cdouble): CairoBoolT {.
    importc: "cairo_in_fill", libcairo.}
proc inClip*(cr: Context; x: cdouble; y: cdouble): CairoBoolT {.
    importc: "cairo_in_clip", libcairo.}

proc strokeExtents*(cr: Context; x1: var cdouble; y1: var cdouble;
                        x2: var cdouble; y2: var cdouble) {.
    importc: "cairo_stroke_extents", libcairo.}
proc fillExtents*(cr: Context; x1: var cdouble; y1: var cdouble; x2: var cdouble;
                      y2: var cdouble) {.importc: "cairo_fill_extents", libcairo.}

proc resetClip*(cr: Context) {.importc: "cairo_reset_clip", libcairo.}
proc clip*(cr: Context) {.importc: "cairo_clip", libcairo.}
proc clipPreserve*(cr: Context) {.importc: "cairo_clip_preserve", libcairo.}
proc clipExtents*(cr: Context; x1: var cdouble; y1: var cdouble; x2: var cdouble;
                      y2: var cdouble) {.importc: "cairo_clip_extents", libcairo.}

type
  Rectangle* =  ptr RectangleObj
  RectanglePtr* = ptr RectangleObj
  RectangleObj* = object
    x*: cdouble
    y*: cdouble
    width*: cdouble
    height*: cdouble

type
  RectangleList* =  ptr RectangleListObj
  RectangleListPtr* = ptr RectangleListObj
  RectangleListObj* = object
    status*: Status
    rectangles*: Rectangle
    numRectangles*: cint

proc copyClipRectangleList*(cr: Context): RectangleList {.
    importc: "cairo_copy_clip_rectangle_list", libcairo.}
proc destroy*(rectangleList: RectangleList) {.
    importc: "cairo_rectangle_list_destroy", libcairo.}

const
  CAIRO_TAG_DEST* = "cairo.dest"
  CAIRO_TAG_LINK* = "Link"

proc tagBegin*(cr: Context; tagName: cstring; attributes: cstring) {.
    importc: "cairo_tag_begin", libcairo.}
proc tagEnd*(cr: Context; tagName: cstring) {.importc: "cairo_tag_end",
    libcairo.}

type
  ScaledFont* =  ptr ScaledFontObj
  ScaledFontPtr* = ptr ScaledFontObj
  ScaledFontObj* = object

type
  FontFace* =  ptr FontFaceObj
  FontFacePtr* = ptr FontFaceObj
  FontFaceObj* = object

type
  Glyph* =  ptr GlyphObj
  GlyphPtr* = ptr GlyphObj
  GlyphObj* = object
    index*: culong
    x*: cdouble
    y*: cdouble

proc glyphAllocate*(numGlyphs: cint): Glyph {.
    importc: "cairo_glyph_allocate", libcairo.}
proc free*(glyphs: Glyph) {.importc: "cairo_glyph_free",
    libcairo.}

type
  TextCluster* =  ptr TextClusterObj
  TextClusterPtr* = ptr TextClusterObj
  TextClusterObj* = object
    numBytes*: cint
    numGlyphs*: cint

proc textClusterAllocate*(numClusters: cint): TextCluster {.
    importc: "cairo_text_cluster_allocate", libcairo.}
proc free*(clusters: TextCluster) {.
    importc: "cairo_text_cluster_free", libcairo.}

type
  TextClusterFlags* {.size: sizeof(cint), pure.} = enum
    BACKWARD = 0x1

type
  TextExtents* =  ptr TextExtentsObj
  TextExtentsPtr* = ptr TextExtentsObj
  TextExtentsObj* = object
    xBearing*: cdouble
    yBearing*: cdouble
    width*: cdouble
    height*: cdouble
    xAdvance*: cdouble
    yAdvance*: cdouble

type
  FontExtents* =  ptr FontExtentsObj
  FontExtentsPtr* = ptr FontExtentsObj
  FontExtentsObj* = object
    ascent*: cdouble
    descent*: cdouble
    height*: cdouble
    maxXAdvance*: cdouble
    maxYAdvance*: cdouble

type
  FontSlant* {.size: sizeof(cint), pure.} = enum
    NORMAL, ITALIC, OBLIQUE

type
  FontWeight* {.size: sizeof(cint), pure.} = enum
    NORMAL, BOLD

type
  SubpixelOrder* {.size: sizeof(cint), pure.} = enum
    DEFAULT, RGB,
    BGR, VRGB, VBGR

type
  HintStyle* {.size: sizeof(cint), pure.} = enum
    DEFAULT, NONE, SLIGHT,
    MEDIUM, FULL

type
  HintMetrics* {.size: sizeof(cint), pure.} = enum
    DEFAULT, OFF, ON

type
  FontOptions* =  ptr FontOptionsObj
  FontOptionsPtr* = ptr FontOptionsObj
  FontOptionsObj* = object

proc fontOptionsCreate*(): FontOptions {.
    importc: "cairo_font_options_create", libcairo.}
proc copy*(original: FontOptions): FontOptions {.
    importc: "cairo_font_options_copy", libcairo.}
proc destroy*(options: FontOptions) {.
    importc: "cairo_font_options_destroy", libcairo.}
proc status*(options: FontOptions): Status {.
    importc: "cairo_font_options_status", libcairo.}
proc merge*(options: FontOptions;
                           other: FontOptions) {.
    importc: "cairo_font_options_merge", libcairo.}
proc equal*(options: FontOptions;
                           other: FontOptions): CairoBoolT {.
    importc: "cairo_font_options_equal", libcairo.}
proc hash*(options: FontOptions): culong {.
    importc: "cairo_font_options_hash", libcairo.}
proc setAntialias*(options: FontOptions;
                                  antialias: Antialias) {.
    importc: "cairo_font_options_set_antialias", libcairo.}
proc `antialias=`*(options: FontOptions;
                                  antialias: Antialias) {.
    importc: "cairo_font_options_set_antialias", libcairo.}
proc getAntialias*(options: FontOptions): Antialias {.
    importc: "cairo_font_options_get_antialias", libcairo.}
proc antialias*(options: FontOptions): Antialias {.
    importc: "cairo_font_options_get_antialias", libcairo.}
proc setSubpixelOrder*(options: FontOptions;
                                      subpixelOrder: SubpixelOrder) {.
    importc: "cairo_font_options_set_subpixel_order", libcairo.}
proc `subpixelOrder=`*(options: FontOptions;
                                      subpixelOrder: SubpixelOrder) {.
    importc: "cairo_font_options_set_subpixel_order", libcairo.}
proc getSubpixelOrder*(options: FontOptions): SubpixelOrder {.
    importc: "cairo_font_options_get_subpixel_order", libcairo.}
proc subpixelOrder*(options: FontOptions): SubpixelOrder {.
    importc: "cairo_font_options_get_subpixel_order", libcairo.}
proc setHintStyle*(options: FontOptions;
                                  hintStyle: HintStyle) {.
    importc: "cairo_font_options_set_hint_style", libcairo.}
proc `hintStyle=`*(options: FontOptions;
                                  hintStyle: HintStyle) {.
    importc: "cairo_font_options_set_hint_style", libcairo.}
proc getHintStyle*(options: FontOptions): HintStyle {.
    importc: "cairo_font_options_get_hint_style", libcairo.}
proc hintStyle*(options: FontOptions): HintStyle {.
    importc: "cairo_font_options_get_hint_style", libcairo.}
proc setHintMetrics*(options: FontOptions;
                                    hintMetrics: HintMetrics) {.
    importc: "cairo_font_options_set_hint_metrics", libcairo.}
proc `hintMetrics=`*(options: FontOptions;
                                    hintMetrics: HintMetrics) {.
    importc: "cairo_font_options_set_hint_metrics", libcairo.}
proc getHintMetrics*(options: FontOptions): HintMetrics {.
    importc: "cairo_font_options_get_hint_metrics", libcairo.}
proc hintMetrics*(options: FontOptions): HintMetrics {.
    importc: "cairo_font_options_get_hint_metrics", libcairo.}

proc selectFontFace*(cr: Context; family: cstring; slant: FontSlant;
                         weight: FontWeight) {.
    importc: "cairo_select_font_face", libcairo.}
proc setFontSize*(cr: Context; size: cdouble) {.
    importc: "cairo_set_font_size", libcairo.}
proc `fontSize=`*(cr: Context; size: cdouble) {.
    importc: "cairo_set_font_size", libcairo.}
proc setFontMatrix*(cr: Context; matrix: Matrix) {.
    importc: "cairo_set_font_matrix", libcairo.}
proc `fontMatrix=`*(cr: Context; matrix: Matrix) {.
    importc: "cairo_set_font_matrix", libcairo.}
proc getFontMatrix*(cr: Context; matrix: var MatrixObj) {.
    importc: "cairo_get_font_matrix", libcairo.}
proc setFontOptions*(cr: Context; options: FontOptions) {.
    importc: "cairo_set_font_options", libcairo.}
proc `fontOptions=`*(cr: Context; options: FontOptions) {.
    importc: "cairo_set_font_options", libcairo.}
proc getFontOptions*(cr: Context; options: var FontOptionsObj) {.
    importc: "cairo_get_font_options", libcairo.}
proc setFontFace*(cr: Context; fontFace: FontFace) {.
    importc: "cairo_set_font_face", libcairo.}
proc `fontFace=`*(cr: Context; fontFace: FontFace) {.
    importc: "cairo_set_font_face", libcairo.}
proc getFontFace*(cr: Context): var FontFaceObj {.
    importc: "cairo_get_font_face", libcairo.}
proc fontFace*(cr: Context): var FontFaceObj {.
    importc: "cairo_get_font_face", libcairo.}
proc setScaledFont*(cr: Context; scaledFont: ScaledFont) {.
    importc: "cairo_set_scaled_font", libcairo.}
proc `scaledFont=`*(cr: Context; scaledFont: ScaledFont) {.
    importc: "cairo_set_scaled_font", libcairo.}
proc getScaledFont*(cr: Context): ScaledFont {.
    importc: "cairo_get_scaled_font", libcairo.}
proc scaledFont*(cr: Context): ScaledFont {.
    importc: "cairo_get_scaled_font", libcairo.}
proc showText*(cr: Context; utf8: cstring) {.importc: "cairo_show_text",
    libcairo.}
proc showGlyphs*(cr: Context; glyphs: Glyph; numGlyphs: cint) {.
    importc: "cairo_show_glyphs", libcairo.}
proc showTextGlyphs*(cr: Context; utf8: cstring; utf8Len: cint;
                         glyphs: Glyph; numGlyphs: cint;
                         clusters: TextCluster; numClusters: cint;
                         clusterFlags: TextClusterFlags) {.
    importc: "cairo_show_text_glyphs", libcairo.}
proc textPath*(cr: Context; utf8: cstring) {.importc: "cairo_text_path",
    libcairo.}
proc glyphPath*(cr: Context; glyphs: Glyph; numGlyphs: cint) {.
    importc: "cairo_glyph_path", libcairo.}
proc textExtents*(cr: Context; utf8: cstring; extents: TextExtents) {.
    importc: "cairo_text_extents", libcairo.}
proc glyphExtents*(cr: Context; glyphs: Glyph; numGlyphs: cint;
                       extents: TextExtents) {.
    importc: "cairo_glyph_extents", libcairo.}
proc fontExtents*(cr: Context; extents: FontExtents) {.
    importc: "cairo_font_extents", libcairo.}

proc reference*(fontFace: FontFace): FontFace {.
    importc: "cairo_font_face_reference", libcairo.}
proc destroy*(fontFace: FontFace) {.
    importc: "cairo_font_face_destroy", libcairo.}
proc getReferenceCount*(fontFace: FontFace): cuint {.
    importc: "cairo_font_face_get_reference_count", libcairo.}
proc referenceCount*(fontFace: FontFace): cuint {.
    importc: "cairo_font_face_get_reference_count", libcairo.}
proc status*(fontFace: FontFace): Status {.
    importc: "cairo_font_face_status", libcairo.}

type
  FontType* {.size: sizeof(cint), pure.} = enum
    TOY, FT, WIN32,
    QUARTZ, USER

proc getType*(fontFace: FontFace): FontType {.
    importc: "cairo_font_face_get_type", libcairo.}

proc type*(fontFace: FontFace): FontType {.
    importc: "cairo_font_face_get_type", libcairo.}
proc getUserData*(fontFace: FontFace;
                              key: UserDataKey): pointer {.
    importc: "cairo_font_face_get_user_data", libcairo.}
proc userData*(fontFace: FontFace;
                              key: UserDataKey): pointer {.
    importc: "cairo_font_face_get_user_data", libcairo.}
proc setUserData*(fontFace: FontFace;
                              key: UserDataKey; userData: pointer;
                              destroy: CairoDestroyFuncT): Status {.
    importc: "cairo_font_face_set_user_data", libcairo.}

proc scaledFontCreate*(fontFace: FontFace;
                           fontMatrix: Matrix; ctm: Matrix;
                           options: FontOptions): ScaledFont {.
    importc: "cairo_scaled_font_create", libcairo.}
proc reference*(scaledFont: ScaledFont): ScaledFont {.
    importc: "cairo_scaled_font_reference", libcairo.}
proc destroy*(scaledFont: ScaledFont) {.
    importc: "cairo_scaled_font_destroy", libcairo.}
proc getReferenceCount*(scaledFont: ScaledFont): cuint {.
    importc: "cairo_scaled_font_get_reference_count", libcairo.}
proc referenceCount*(scaledFont: ScaledFont): cuint {.
    importc: "cairo_scaled_font_get_reference_count", libcairo.}
proc status*(scaledFont: ScaledFont): Status {.
    importc: "cairo_scaled_font_status", libcairo.}
proc getType*(scaledFont: ScaledFont): FontType {.
    importc: "cairo_scaled_font_get_type", libcairo.}
proc type*(scaledFont: ScaledFont): FontType {.
    importc: "cairo_scaled_font_get_type", libcairo.}
proc getUserData*(scaledFont: ScaledFont;
                                key: UserDataKey): pointer {.
    importc: "cairo_scaled_font_get_user_data", libcairo.}
proc userData*(scaledFont: ScaledFont;
                                key: UserDataKey): pointer {.
    importc: "cairo_scaled_font_get_user_data", libcairo.}
proc setUserData*(scaledFont: ScaledFont;
                                key: UserDataKey; userData: pointer;
                                destroy: CairoDestroyFuncT): Status {.
    importc: "cairo_scaled_font_set_user_data", libcairo.}
proc extents*(scaledFont: ScaledFont;
                            extents: FontExtents) {.
    importc: "cairo_scaled_font_extents", libcairo.}
proc textExtents*(scaledFont: ScaledFont; utf8: cstring;
                                extents: TextExtents) {.
    importc: "cairo_scaled_font_text_extents", libcairo.}
proc glyphExtents*(scaledFont: ScaledFont;
                                 glyphs: Glyph; numGlyphs: cint;
                                 extents: TextExtents) {.
    importc: "cairo_scaled_font_glyph_extents", libcairo.}
proc textToGlyphs*(scaledFont: ScaledFont; x: cdouble;
                                 y: cdouble; utf8: cstring; utf8Len: cint;
                                 glyphs: var Glyph; numGlyphs: var cint;
                                 clusters: var TextCluster;
                                 numClusters: var cint;
                                 clusterFlags: var TextClusterFlags): Status {.
    importc: "cairo_scaled_font_text_to_glyphs", libcairo.}
proc getFontFace*(scaledFont: ScaledFont): FontFace {.
    importc: "cairo_scaled_font_get_font_face", libcairo.}
proc fontFace*(scaledFont: ScaledFont): FontFace {.
    importc: "cairo_scaled_font_get_font_face", libcairo.}
proc getFontMatrix*(scaledFont: ScaledFont;
                                  fontMatrix: var MatrixObj) {.
    importc: "cairo_scaled_font_get_font_matrix", libcairo.}
proc getCtm*(scaledFont: ScaledFont; ctm: Matrix) {.
    importc: "cairo_scaled_font_get_ctm", libcairo.}
proc getScaleMatrix*(scaledFont: ScaledFont;
                                   scaleMatrix: var MatrixObj) {.
    importc: "cairo_scaled_font_get_scale_matrix", libcairo.}
proc getFontOptions*(scaledFont: ScaledFont;
                                   options: var FontOptionsObj) {.
    importc: "cairo_scaled_font_get_font_options", libcairo.}

proc toyFontFaceCreate*(family: cstring; slant: FontSlant;
                            weight: FontWeight): FontFace {.
    importc: "cairo_toy_font_face_create", libcairo.}
proc toyFontFaceGetFamily*(fontFace: FontFace): cstring {.
    importc: "cairo_toy_font_face_get_family", libcairo.}
proc toyFontFaceGetSlant*(fontFace: FontFace): FontSlant {.
    importc: "cairo_toy_font_face_get_slant", libcairo.}
proc toyFontFaceGetWeight*(fontFace: FontFace): FontWeight {.
    importc: "cairo_toy_font_face_get_weight", libcairo.}

proc userFontFaceCreate*(): FontFace {.
    importc: "cairo_user_font_face_create", libcairo.}

type
  CairoUserScaledFontInitFuncT* = proc (scaledFont: ScaledFont;
                                     cr: Context; extents: FontExtents): Status {.cdecl.}

type
  CairoUserScaledFontRenderGlyphFuncT* = proc (scaledFont: ScaledFont;
      glyph: culong; cr: Context; extents: TextExtents): Status {.cdecl.}

type
  CairoUserScaledFontTextToGlyphsFuncT* = proc (scaledFont: ScaledFont;
      utf8: cstring; utf8Len: cint; glyphs: var Glyph; numGlyphs: var cint;
      clusters: var TextCluster; numClusters: var cint;
      clusterFlags: var TextClusterFlags): Status {.cdecl.}

type
  CairoUserScaledFontUnicodeToGlyphFuncT* = proc (scaledFont: ScaledFont;
      unicode: culong; glyphIndex: var culong): Status {.cdecl.}

proc userFontFaceSetInitFunc*(fontFace: FontFace;
                                  initFunc: CairoUserScaledFontInitFuncT) {.
    importc: "cairo_user_font_face_set_init_func", libcairo.}
proc userFontFaceSetRenderGlyphFunc*(fontFace: FontFace;
    renderGlyphFunc: CairoUserScaledFontRenderGlyphFuncT) {.
    importc: "cairo_user_font_face_set_render_glyph_func", libcairo.}
proc userFontFaceSetTextToGlyphsFunc*(fontFace: FontFace;
    textToGlyphsFunc: CairoUserScaledFontTextToGlyphsFuncT) {.
    importc: "cairo_user_font_face_set_text_to_glyphs_func", libcairo.}
proc userFontFaceSetUnicodeToGlyphFunc*(fontFace: FontFace;
    unicodeToGlyphFunc: CairoUserScaledFontUnicodeToGlyphFuncT) {.
    importc: "cairo_user_font_face_set_unicode_to_glyph_func", libcairo.}

proc userFontFaceGetInitFunc*(fontFace: FontFace): CairoUserScaledFontInitFuncT {.
    importc: "cairo_user_font_face_get_init_func", libcairo.}
proc userFontFaceGetRenderGlyphFunc*(fontFace: FontFace): CairoUserScaledFontRenderGlyphFuncT {.
    importc: "cairo_user_font_face_get_render_glyph_func", libcairo.}
proc userFontFaceGetTextToGlyphsFunc*(fontFace: FontFace): CairoUserScaledFontTextToGlyphsFuncT {.
    importc: "cairo_user_font_face_get_text_to_glyphs_func", libcairo.}
proc userFontFaceGetUnicodeToGlyphFunc*(fontFace: FontFace): CairoUserScaledFontUnicodeToGlyphFuncT {.
    importc: "cairo_user_font_face_get_unicode_to_glyph_func", libcairo.}

proc getOperator*(cr: Context): Operator {.
    importc: "cairo_get_operator", libcairo.}

proc operator*(cr: Context): Operator {.
    importc: "cairo_get_operator", libcairo.}
proc getSource*(cr: Context): Pattern {.importc: "cairo_get_source",
    libcairo.}
proc source*(cr: Context): Pattern {.importc: "cairo_get_source",
    libcairo.}
proc getTolerance*(cr: Context): cdouble {.importc: "cairo_get_tolerance",
    libcairo.}
proc tolerance*(cr: Context): cdouble {.importc: "cairo_get_tolerance",
    libcairo.}
proc getAntialias*(cr: Context): Antialias {.
    importc: "cairo_get_antialias", libcairo.}
proc antialias*(cr: Context): Antialias {.
    importc: "cairo_get_antialias", libcairo.}
proc hasCurrentPoint*(cr: Context): CairoBoolT {.
    importc: "cairo_has_current_point", libcairo.}
proc getCurrentPoint*(cr: Context; x: var cdouble; y: var cdouble) {.
    importc: "cairo_get_current_point", libcairo.}
proc getFillRule*(cr: Context): FillRule {.
    importc: "cairo_get_fill_rule", libcairo.}
proc fillRule*(cr: Context): FillRule {.
    importc: "cairo_get_fill_rule", libcairo.}
proc getLineWidth*(cr: Context): cdouble {.importc: "cairo_get_line_width",
    libcairo.}
proc lineWidth*(cr: Context): cdouble {.importc: "cairo_get_line_width",
    libcairo.}
proc getLineCap*(cr: Context): LineCap {.importc: "cairo_get_line_cap",
    libcairo.}
proc lineCap*(cr: Context): LineCap {.importc: "cairo_get_line_cap",
    libcairo.}
proc getLineJoin*(cr: Context): LineJoin {.
    importc: "cairo_get_line_join", libcairo.}
proc lineJoin*(cr: Context): LineJoin {.
    importc: "cairo_get_line_join", libcairo.}
proc getMiterLimit*(cr: Context): cdouble {.importc: "cairo_get_miter_limit",
    libcairo.}
proc miterLimit*(cr: Context): cdouble {.importc: "cairo_get_miter_limit",
    libcairo.}
proc getDashCount*(cr: Context): cint {.importc: "cairo_get_dash_count",
    libcairo.}
proc dashCount*(cr: Context): cint {.importc: "cairo_get_dash_count",
    libcairo.}
proc getDash*(cr: Context; dashes: var cdouble; offset: var cdouble) {.
    importc: "cairo_get_dash", libcairo.}
proc getMatrix*(cr: Context; matrix: var MatrixObj) {.
    importc: "cairo_get_matrix", libcairo.}
proc getTarget*(cr: Context): Surface {.importc: "cairo_get_target",
    libcairo.}
proc target*(cr: Context): Surface {.importc: "cairo_get_target",
    libcairo.}
proc getGroupTarget*(cr: Context): Surface {.
    importc: "cairo_get_group_target", libcairo.}
proc groupTarget*(cr: Context): Surface {.
    importc: "cairo_get_group_target", libcairo.}

type
  PathDataType* {.size: sizeof(cint), pure.} = enum
    MOVE_TO, LINE_TO, CURVE_TO,
    CLOSE_PATH

type
  INNER_C_STRUCT_3330700347* = object
    `type`*: PathDataType
    length*: cint

  INNER_C_STRUCT_1651263489* = object
    x*: cdouble
    y*: cdouble

  CairoPathDataT* {.union.} = object
    header*: INNER_C_STRUCT_3330700347
    point*: INNER_C_STRUCT_1651263489

type
  Path* =  ptr PathObj
  PathPtr* = ptr PathObj
  PathObj* = object
    status*: Status
    data*: ptr CairoPathDataT
    numData*: cint

proc copyPath*(cr: Context): Path {.importc: "cairo_copy_path",
    libcairo.}
proc copyPathFlat*(cr: Context): Path {.
    importc: "cairo_copy_path_flat", libcairo.}
proc appendPath*(cr: Context; path: Path) {.
    importc: "cairo_append_path", libcairo.}
proc destroy*(path: Path) {.importc: "cairo_path_destroy",
    libcairo.}

proc status*(cr: Context): Status {.importc: "cairo_status", libcairo.}
proc toString*(status: Status): cstring {.
    importc: "cairo_status_to_string", libcairo.}

proc reference*(device: Device): Device {.
    importc: "cairo_device_reference", libcairo.}

type
  DeviceType* {.size: sizeof(cint), pure.} = enum
    INVALID = - 1, DRM, GL,
    SCRIPT, XCB, XLIB,
    XML, COGL, WIN32

proc getType*(device: Device): DeviceType {.
    importc: "cairo_device_get_type", libcairo.}

proc type*(device: Device): DeviceType {.
    importc: "cairo_device_get_type", libcairo.}
proc status*(device: Device): Status {.
    importc: "cairo_device_status", libcairo.}
proc acquire*(device: Device): Status {.
    importc: "cairo_device_acquire", libcairo.}
proc release*(device: Device) {.
    importc: "cairo_device_release", libcairo.}
proc flush*(device: Device) {.importc: "cairo_device_flush",
    libcairo.}
proc finish*(device: Device) {.importc: "cairo_device_finish",
    libcairo.}
proc destroy*(device: Device) {.
    importc: "cairo_device_destroy", libcairo.}
proc getReferenceCount*(device: Device): cuint {.
    importc: "cairo_device_get_reference_count", libcairo.}
proc referenceCount*(device: Device): cuint {.
    importc: "cairo_device_get_reference_count", libcairo.}
proc getUserData*(device: Device; key: UserDataKey): pointer {.
    importc: "cairo_device_get_user_data", libcairo.}
proc userData*(device: Device; key: UserDataKey): pointer {.
    importc: "cairo_device_get_user_data", libcairo.}
proc setUserData*(device: Device; key: UserDataKey;
                            userData: pointer; destroy: CairoDestroyFuncT): Status {.
    importc: "cairo_device_set_user_data", libcairo.}

proc createSimilar*(other: Surface; content: Content;
                               width: cint; height: cint): Surface {.
    importc: "cairo_surface_create_similar", libcairo.}
proc createSimilarImage*(other: Surface; format: Format;
                                    width: cint; height: cint): Surface {.
    importc: "cairo_surface_create_similar_image", libcairo.}
proc mapToImage*(surface: Surface;
                            extents: RectangleInt): Surface {.
    importc: "cairo_surface_map_to_image", libcairo.}
proc unmapImage*(surface: Surface; image: Surface) {.
    importc: "cairo_surface_unmap_image", libcairo.}
proc createForRectangle*(target: Surface; x: cdouble;
                                    y: cdouble; width: cdouble; height: cdouble): Surface {.
    importc: "cairo_surface_create_for_rectangle", libcairo.}

type
  SurfaceObserverMode* {.size: sizeof(cint), pure.} = enum
    NORMAL = 0,
    RECORD_OPERATIONS = 0x1

proc createObserver*(target: Surface;
                                mode: SurfaceObserverMode): Surface {.
    importc: "cairo_surface_create_observer", libcairo.}
type
  CairoSurfaceObserverCallbackT* = proc (observer: Surface;
                                      target: Surface; data: pointer) {.cdecl.}

proc observerAddPaintCallback*(abstractSurface: Surface;
    `func`: CairoSurfaceObserverCallbackT; data: pointer): Status {.
    importc: "cairo_surface_observer_add_paint_callback", libcairo.}
proc observerAddMaskCallback*(abstractSurface: Surface;
    `func`: CairoSurfaceObserverCallbackT; data: pointer): Status {.
    importc: "cairo_surface_observer_add_mask_callback", libcairo.}
proc observerAddFillCallback*(abstractSurface: Surface;
    `func`: CairoSurfaceObserverCallbackT; data: pointer): Status {.
    importc: "cairo_surface_observer_add_fill_callback", libcairo.}
proc observerAddStrokeCallback*(abstractSurface: Surface;
    `func`: CairoSurfaceObserverCallbackT; data: pointer): Status {.
    importc: "cairo_surface_observer_add_stroke_callback", libcairo.}
proc observerAddGlyphsCallback*(abstractSurface: Surface;
    `func`: CairoSurfaceObserverCallbackT; data: pointer): Status {.
    importc: "cairo_surface_observer_add_glyphs_callback", libcairo.}
proc observerAddFlushCallback*(abstractSurface: Surface;
    `func`: CairoSurfaceObserverCallbackT; data: pointer): Status {.
    importc: "cairo_surface_observer_add_flush_callback", libcairo.}
proc observerAddFinishCallback*(abstractSurface: Surface;
    `func`: CairoSurfaceObserverCallbackT; data: pointer): Status {.
    importc: "cairo_surface_observer_add_finish_callback", libcairo.}
proc observerPrint*(surface: Surface;
                               writeFunc: CairoWriteFuncT; closure: pointer): Status {.
    importc: "cairo_surface_observer_print", libcairo.}
proc observerElapsed*(surface: Surface): cdouble {.
    importc: "cairo_surface_observer_elapsed", libcairo.}
proc observerPrint*(device: Device; writeFunc: CairoWriteFuncT;
                              closure: pointer): Status {.
    importc: "cairo_device_observer_print", libcairo.}
proc observerElapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_elapsed", libcairo.}
proc observerPaintElapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_paint_elapsed", libcairo.}
proc observerMaskElapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_mask_elapsed", libcairo.}
proc observerFillElapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_fill_elapsed", libcairo.}
proc observerStrokeElapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_stroke_elapsed", libcairo.}
proc observerGlyphsElapsed*(device: Device): cdouble {.
    importc: "cairo_device_observer_glyphs_elapsed", libcairo.}
proc reference*(surface: Surface): Surface {.
    importc: "cairo_surface_reference", libcairo.}
proc finish*(surface: Surface) {.
    importc: "cairo_surface_finish", libcairo.}
proc destroy*(surface: Surface) {.
    importc: "cairo_surface_destroy", libcairo.}
proc getDevice*(surface: Surface): Device {.
    importc: "cairo_surface_get_device", libcairo.}
proc device*(surface: Surface): Device {.
    importc: "cairo_surface_get_device", libcairo.}
proc getReferenceCount*(surface: Surface): cuint {.
    importc: "cairo_surface_get_reference_count", libcairo.}
proc referenceCount*(surface: Surface): cuint {.
    importc: "cairo_surface_get_reference_count", libcairo.}
proc status*(surface: Surface): Status {.
    importc: "cairo_surface_status", libcairo.}

type
  SurfaceType* {.size: sizeof(cint), pure.} = enum
    IMAGE, PDF, PS,
    XLIB, XCB, GLITZ,
    QUARTZ, WIN32, BEOS,
    DIRECTFB, SVG, OS2,
    WIN32_PRINTING, QUARTZ_IMAGE,
    SCRIPT, QT,
    RECORDING, VG, GL,
    DRM, TEE, XML,
    SKIA, SUBSURFACE,
    COGL

proc getType*(surface: Surface): SurfaceType {.
    importc: "cairo_surface_get_type", libcairo.}

proc type*(surface: Surface): SurfaceType {.
    importc: "cairo_surface_get_type", libcairo.}
proc getContent*(surface: Surface): Content {.
    importc: "cairo_surface_get_content", libcairo.}
proc content*(surface: Surface): Content {.
    importc: "cairo_surface_get_content", libcairo.}
when CAIRO_HAS_PNG_FUNCTIONS:
  proc writeToPng*(surface: Surface; filename: cstring): Status {.
      importc: "cairo_surface_write_to_png", libcairo.}
  proc writeToPngStream*(surface: Surface;
                                    writeFunc: CairoWriteFuncT; closure: pointer): Status {.
      importc: "cairo_surface_write_to_png_stream", libcairo.}
proc getUserData*(surface: Surface; key: UserDataKey): pointer {.
    importc: "cairo_surface_get_user_data", libcairo.}
proc userData*(surface: Surface; key: UserDataKey): pointer {.
    importc: "cairo_surface_get_user_data", libcairo.}
proc setUserData*(surface: Surface;
                             key: UserDataKey; userData: pointer;
                             destroy: CairoDestroyFuncT): Status {.
    importc: "cairo_surface_set_user_data", libcairo.}
const
  MIME_TYPE_JPEG* = "image/jpeg"
  MIME_TYPE_PNG* = "image/png"
  MIME_TYPE_JP2* = "image/jp2"
  MIME_TYPE_URI* = "text/x-uri"
  MIME_TYPE_UNIQUE_ID* = "application/x-cairo.uuid"
  MIME_TYPE_JBIG2* = "application/x-cairo.jbig2"
  MIME_TYPE_JBIG2_GLOBAL* = "application/x-cairo.jbig2-global"
  MIME_TYPE_JBIG2_GLOBAL_ID* = "application/x-cairo.jbig2-global-id"

proc getMimeData*(surface: Surface; mimeType: cstring;
                             data: ptr ptr cuchar; length: var culong) {.
    importc: "cairo_surface_get_mime_data", libcairo.}
proc setMimeData*(surface: Surface; mimeType: cstring;
                             data: ptr cuchar; length: culong;
                             destroy: CairoDestroyFuncT; closure: pointer): Status {.
    importc: "cairo_surface_set_mime_data", libcairo.}
proc supportsMimeType*(surface: Surface; mimeType: cstring): CairoBoolT {.
    importc: "cairo_surface_supports_mime_type", libcairo.}
proc getFontOptions*(surface: Surface;
                                options: var FontOptionsObj) {.
    importc: "cairo_surface_get_font_options", libcairo.}
proc flush*(surface: Surface) {.
    importc: "cairo_surface_flush", libcairo.}
proc markDirty*(surface: Surface) {.
    importc: "cairo_surface_mark_dirty", libcairo.}
proc markDirtyRectangle*(surface: Surface; x: cint; y: cint;
                                    width: cint; height: cint) {.
    importc: "cairo_surface_mark_dirty_rectangle", libcairo.}
proc setDeviceScale*(surface: Surface; xScale: cdouble;
                                yScale: cdouble) {.
    importc: "cairo_surface_set_device_scale", libcairo.}
proc `deviceScale=`*(surface: Surface; xScale: cdouble;
                                yScale: cdouble) {.
    importc: "cairo_surface_set_device_scale", libcairo.}
proc getDeviceScale*(surface: Surface; xScale: var cdouble;
                                yScale: var cdouble) {.
    importc: "cairo_surface_get_device_scale", libcairo.}
proc setDeviceOffset*(surface: Surface; xOffset: cdouble;
                                 yOffset: cdouble) {.
    importc: "cairo_surface_set_device_offset", libcairo.}
proc `deviceOffset=`*(surface: Surface; xOffset: cdouble;
                                 yOffset: cdouble) {.
    importc: "cairo_surface_set_device_offset", libcairo.}
proc getDeviceOffset*(surface: Surface; xOffset: var cdouble;
                                 yOffset: var cdouble) {.
    importc: "cairo_surface_get_device_offset", libcairo.}
proc setFallbackResolution*(surface: Surface;
                                       xPixelsPerInch: cdouble;
                                       yPixelsPerInch: cdouble) {.
    importc: "cairo_surface_set_fallback_resolution", libcairo.}
proc `fallbackResolution=`*(surface: Surface;
                                       xPixelsPerInch: cdouble;
                                       yPixelsPerInch: cdouble) {.
    importc: "cairo_surface_set_fallback_resolution", libcairo.}
proc getFallbackResolution*(surface: Surface;
                                       xPixelsPerInch: var cdouble;
                                       yPixelsPerInch: var cdouble) {.
    importc: "cairo_surface_get_fallback_resolution", libcairo.}
proc copyPage*(surface: Surface) {.
    importc: "cairo_surface_copy_page", libcairo.}
proc showPage*(surface: Surface) {.
    importc: "cairo_surface_show_page", libcairo.}
proc hasShowTextGlyphs*(surface: Surface): CairoBoolT {.
    importc: "cairo_surface_has_show_text_glyphs", libcairo.}

proc imageSurfaceCreate*(format: Format; width: cint; height: cint): Surface {.
    importc: "cairo_image_surface_create", libcairo.}
proc strideForWidth*(format: Format; width: cint): cint {.
    importc: "cairo_format_stride_for_width", libcairo.}
proc imageSurfaceCreateForData*(data: ptr cuchar; format: Format;
                                    width: cint; height: cint; stride: cint): Surface {.
    importc: "cairo_image_surface_create_for_data", libcairo.}
proc imageSurfaceGetData*(surface: Surface): ptr cuchar {.
    importc: "cairo_image_surface_get_data", libcairo.}
proc imageSurfaceGetFormat*(surface: Surface): Format {.
    importc: "cairo_image_surface_get_format", libcairo.}
proc imageSurfaceGetWidth*(surface: Surface): cint {.
    importc: "cairo_image_surface_get_width", libcairo.}
proc imageSurfaceGetHeight*(surface: Surface): cint {.
    importc: "cairo_image_surface_get_height", libcairo.}
proc imageSurfaceGetStride*(surface: Surface): cint {.
    importc: "cairo_image_surface_get_stride", libcairo.}
when CAIRO_HAS_PNG_FUNCTIONS:
  proc imageSurfaceCreateFromPng*(filename: cstring): Surface {.
      importc: "cairo_image_surface_create_from_png", libcairo.}
  proc imageSurfaceCreateFromPngStream*(readFunc: CairoReadFuncT;
      closure: pointer): Surface {.
      importc: "cairo_image_surface_create_from_png_stream", libcairo.}

proc recordingSurfaceCreate*(content: Content;
                                 extents: Rectangle): Surface {.
    importc: "cairo_recording_surface_create", libcairo.}
proc recordingSurfaceInkExtents*(surface: Surface; x0: var cdouble;
                                     y0: var cdouble; width: var cdouble;
                                     height: var cdouble) {.
    importc: "cairo_recording_surface_ink_extents", libcairo.}
proc recordingSurfaceGetExtents*(surface: Surface;
                                     extents: Rectangle): CairoBoolT {.
    importc: "cairo_recording_surface_get_extents", libcairo.}

type
  CairoRasterSourceAcquireFuncT* = proc (pattern: Pattern;
                                      callbackData: pointer;
                                      target: Surface;
                                      extents: RectangleInt): Surface {.cdecl.}

type
  CairoRasterSourceReleaseFuncT* = proc (pattern: Pattern;
                                      callbackData: pointer;
                                      surface: Surface) {.cdecl.}

type
  CairoRasterSourceSnapshotFuncT* = proc (pattern: Pattern;
                                       callbackData: pointer): Status {.cdecl.}

type
  CairoRasterSourceCopyFuncT* = proc (pattern: Pattern;
                                   callbackData: pointer; other: Pattern): Status {.cdecl.}

type
  CairoRasterSourceFinishFuncT* = proc (pattern: Pattern;
                                     callbackData: pointer) {.cdecl.}

proc patternCreateRasterSource*(userData: pointer; content: Content;
                                    width: cint; height: cint): Pattern {.
    importc: "cairo_pattern_create_raster_source", libcairo.}
proc rasterSourcePatternSetCallbackData*(pattern: Pattern;
    data: pointer) {.importc: "cairo_raster_source_pattern_set_callback_data",
                   libcairo.}
proc rasterSourcePatternGetCallbackData*(pattern: Pattern): pointer {.
    importc: "cairo_raster_source_pattern_get_callback_data", libcairo.}
proc rasterSourcePatternSetAcquire*(pattern: Pattern;
                                        acquire: CairoRasterSourceAcquireFuncT;
                                        release: CairoRasterSourceReleaseFuncT) {.
    importc: "cairo_raster_source_pattern_set_acquire", libcairo.}
proc rasterSourcePatternGetAcquire*(pattern: Pattern; acquire: ptr CairoRasterSourceAcquireFuncT;
    release: ptr CairoRasterSourceReleaseFuncT) {.
    importc: "cairo_raster_source_pattern_get_acquire", libcairo.}
proc rasterSourcePatternSetSnapshot*(pattern: Pattern;
    snapshot: CairoRasterSourceSnapshotFuncT) {.
    importc: "cairo_raster_source_pattern_set_snapshot", libcairo.}
proc rasterSourcePatternGetSnapshot*(pattern: Pattern): CairoRasterSourceSnapshotFuncT {.
    importc: "cairo_raster_source_pattern_get_snapshot", libcairo.}
proc rasterSourcePatternSetCopy*(pattern: Pattern;
                                     copy: CairoRasterSourceCopyFuncT) {.
    importc: "cairo_raster_source_pattern_set_copy", libcairo.}
proc rasterSourcePatternGetCopy*(pattern: Pattern): CairoRasterSourceCopyFuncT {.
    importc: "cairo_raster_source_pattern_get_copy", libcairo.}
proc rasterSourcePatternSetFinish*(pattern: Pattern;
                                       finish: CairoRasterSourceFinishFuncT) {.
    importc: "cairo_raster_source_pattern_set_finish", libcairo.}
proc rasterSourcePatternGetFinish*(pattern: Pattern): CairoRasterSourceFinishFuncT {.
    importc: "cairo_raster_source_pattern_get_finish", libcairo.}

proc patternCreateRgb*(red: cdouble; green: cdouble; blue: cdouble): Pattern {.
    importc: "cairo_pattern_create_rgb", libcairo.}
proc patternCreateRgba*(red: cdouble; green: cdouble; blue: cdouble;
                            alpha: cdouble): Pattern {.
    importc: "cairo_pattern_create_rgba", libcairo.}
proc patternCreateForSurface*(surface: Surface): Pattern {.
    importc: "cairo_pattern_create_for_surface", libcairo.}
proc patternCreateLinear*(x0: cdouble; y0: cdouble; x1: cdouble; y1: cdouble): Pattern {.
    importc: "cairo_pattern_create_linear", libcairo.}
proc patternCreateRadial*(cx0: cdouble; cy0: cdouble; radius0: cdouble;
                              cx1: cdouble; cy1: cdouble; radius1: cdouble): Pattern {.
    importc: "cairo_pattern_create_radial", libcairo.}
proc patternCreateMesh*(): Pattern {.
    importc: "cairo_pattern_create_mesh", libcairo.}
proc reference*(pattern: Pattern): Pattern {.
    importc: "cairo_pattern_reference", libcairo.}
proc destroy*(pattern: Pattern) {.
    importc: "cairo_pattern_destroy", libcairo.}
proc getReferenceCount*(pattern: Pattern): cuint {.
    importc: "cairo_pattern_get_reference_count", libcairo.}
proc referenceCount*(pattern: Pattern): cuint {.
    importc: "cairo_pattern_get_reference_count", libcairo.}
proc status*(pattern: Pattern): Status {.
    importc: "cairo_pattern_status", libcairo.}
proc getUserData*(pattern: Pattern; key: UserDataKey): pointer {.
    importc: "cairo_pattern_get_user_data", libcairo.}
proc userData*(pattern: Pattern; key: UserDataKey): pointer {.
    importc: "cairo_pattern_get_user_data", libcairo.}
proc setUserData*(pattern: Pattern;
                             key: UserDataKey; userData: pointer;
                             destroy: CairoDestroyFuncT): Status {.
    importc: "cairo_pattern_set_user_data", libcairo.}

type
  PatternType* {.size: sizeof(cint), pure.} = enum
    SOLID, SURFACE,
    LINEAR, RADIAL, MESH,
    RASTER_SOURCE

proc getType*(pattern: Pattern): PatternType {.
    importc: "cairo_pattern_get_type", libcairo.}

proc type*(pattern: Pattern): PatternType {.
    importc: "cairo_pattern_get_type", libcairo.}
proc addColorStopRgb*(pattern: Pattern; offset: cdouble;
                                 red: cdouble; green: cdouble; blue: cdouble) {.
    importc: "cairo_pattern_add_color_stop_rgb", libcairo.}
proc addColorStopRgba*(pattern: Pattern; offset: cdouble;
                                  red: cdouble; green: cdouble; blue: cdouble;
                                  alpha: cdouble) {.
    importc: "cairo_pattern_add_color_stop_rgba", libcairo.}
proc meshPatternBeginPatch*(pattern: Pattern) {.
    importc: "cairo_mesh_pattern_begin_patch", libcairo.}
proc meshPatternEndPatch*(pattern: Pattern) {.
    importc: "cairo_mesh_pattern_end_patch", libcairo.}
proc meshPatternCurveTo*(pattern: Pattern; x1: cdouble; y1: cdouble;
                             x2: cdouble; y2: cdouble; x3: cdouble; y3: cdouble) {.
    importc: "cairo_mesh_pattern_curve_to", libcairo.}
proc meshPatternLineTo*(pattern: Pattern; x: cdouble; y: cdouble) {.
    importc: "cairo_mesh_pattern_line_to", libcairo.}
proc meshPatternMoveTo*(pattern: Pattern; x: cdouble; y: cdouble) {.
    importc: "cairo_mesh_pattern_move_to", libcairo.}
proc meshPatternSetControlPoint*(pattern: Pattern; pointNum: cuint;
                                     x: cdouble; y: cdouble) {.
    importc: "cairo_mesh_pattern_set_control_point", libcairo.}
proc meshPatternSetCornerColorRgb*(pattern: Pattern;
                                       cornerNum: cuint; red: cdouble;
                                       green: cdouble; blue: cdouble) {.
    importc: "cairo_mesh_pattern_set_corner_color_rgb", libcairo.}
proc meshPatternSetCornerColorRgba*(pattern: Pattern;
                                        cornerNum: cuint; red: cdouble;
                                        green: cdouble; blue: cdouble;
                                        alpha: cdouble) {.
    importc: "cairo_mesh_pattern_set_corner_color_rgba", libcairo.}
proc setMatrix*(pattern: Pattern; matrix: Matrix) {.
    importc: "cairo_pattern_set_matrix", libcairo.}
proc `matrix=`*(pattern: Pattern; matrix: Matrix) {.
    importc: "cairo_pattern_set_matrix", libcairo.}
proc getMatrix*(pattern: Pattern; matrix: var MatrixObj) {.
    importc: "cairo_pattern_get_matrix", libcairo.}

type
  Extend* {.size: sizeof(cint), pure.} = enum
    NONE, REPEAT, REFLECT, PAD

proc setExtend*(pattern: Pattern; extend: Extend) {.
    importc: "cairo_pattern_set_extend", libcairo.}

proc `extend=`*(pattern: Pattern; extend: Extend) {.
    importc: "cairo_pattern_set_extend", libcairo.}
proc getExtend*(pattern: Pattern): Extend {.
    importc: "cairo_pattern_get_extend", libcairo.}
proc extend*(pattern: Pattern): Extend {.
    importc: "cairo_pattern_get_extend", libcairo.}

type
  Filter* {.size: sizeof(cint), pure.} = enum
    FAST, GOOD, BEST, NEAREST,
    BILINEAR, GAUSSIAN

proc setFilter*(pattern: Pattern; filter: Filter) {.
    importc: "cairo_pattern_set_filter", libcairo.}

proc `filter=`*(pattern: Pattern; filter: Filter) {.
    importc: "cairo_pattern_set_filter", libcairo.}
proc getFilter*(pattern: Pattern): Filter {.
    importc: "cairo_pattern_get_filter", libcairo.}
proc filter*(pattern: Pattern): Filter {.
    importc: "cairo_pattern_get_filter", libcairo.}
proc getRgba*(pattern: Pattern; red: var cdouble;
                         green: var cdouble; blue: var cdouble; alpha: var cdouble): Status {.
    importc: "cairo_pattern_get_rgba", libcairo.}
proc rgba*(pattern: Pattern; red: var cdouble;
                         green: var cdouble; blue: var cdouble; alpha: var cdouble): Status {.
    importc: "cairo_pattern_get_rgba", libcairo.}
proc getSurface*(pattern: Pattern;
                            surface: var Surface): Status {.
    importc: "cairo_pattern_get_surface", libcairo.}
proc surface*(pattern: Pattern;
                            surface: var Surface): Status {.
    importc: "cairo_pattern_get_surface", libcairo.}
proc getColorStopRgba*(pattern: Pattern; index: cint;
                                  offset: var cdouble; red: var cdouble;
                                  green: var cdouble; blue: var cdouble;
                                  alpha: var cdouble): Status {.
    importc: "cairo_pattern_get_color_stop_rgba", libcairo.}
proc colorStopRgba*(pattern: Pattern; index: cint;
                                  offset: var cdouble; red: var cdouble;
                                  green: var cdouble; blue: var cdouble;
                                  alpha: var cdouble): Status {.
    importc: "cairo_pattern_get_color_stop_rgba", libcairo.}
proc getColorStopCount*(pattern: Pattern; count: var cint): Status {.
    importc: "cairo_pattern_get_color_stop_count", libcairo.}
proc colorStopCount*(pattern: Pattern; count: var cint): Status {.
    importc: "cairo_pattern_get_color_stop_count", libcairo.}
proc getLinearPoints*(pattern: Pattern; x0: var cdouble;
                                 y0: var cdouble; x1: var cdouble; y1: var cdouble): Status {.
    importc: "cairo_pattern_get_linear_points", libcairo.}
proc linearPoints*(pattern: Pattern; x0: var cdouble;
                                 y0: var cdouble; x1: var cdouble; y1: var cdouble): Status {.
    importc: "cairo_pattern_get_linear_points", libcairo.}
proc getRadialCircles*(pattern: Pattern; x0: var cdouble;
                                  y0: var cdouble; r0: var cdouble; x1: var cdouble;
                                  y1: var cdouble; r1: var cdouble): Status {.
    importc: "cairo_pattern_get_radial_circles", libcairo.}
proc radialCircles*(pattern: Pattern; x0: var cdouble;
                                  y0: var cdouble; r0: var cdouble; x1: var cdouble;
                                  y1: var cdouble; r1: var cdouble): Status {.
    importc: "cairo_pattern_get_radial_circles", libcairo.}
proc meshPatternGetPatchCount*(pattern: Pattern; count: var cuint): Status {.
    importc: "cairo_mesh_pattern_get_patch_count", libcairo.}
proc meshPatternGetPath*(pattern: Pattern; patchNum: cuint): Path {.
    importc: "cairo_mesh_pattern_get_path", libcairo.}
proc meshPatternGetCornerColorRgba*(pattern: Pattern;
                                        patchNum: cuint; cornerNum: cuint;
                                        red: var cdouble; green: var cdouble;
                                        blue: var cdouble; alpha: var cdouble): Status {.
    importc: "cairo_mesh_pattern_get_corner_color_rgba", libcairo.}
proc meshPatternGetControlPoint*(pattern: Pattern; patchNum: cuint;
                                     pointNum: cuint; x: var cdouble; y: var cdouble): Status {.
    importc: "cairo_mesh_pattern_get_control_point", libcairo.}

proc init*(matrix: Matrix; xx: cdouble; yx: cdouble; xy: cdouble;
                     yy: cdouble; x0: cdouble; y0: cdouble) {.
    importc: "cairo_matrix_init", libcairo.}
proc initIdentity*(matrix: Matrix) {.
    importc: "cairo_matrix_init_identity", libcairo.}
proc initTranslate*(matrix: Matrix; tx: cdouble; ty: cdouble) {.
    importc: "cairo_matrix_init_translate", libcairo.}
proc initScale*(matrix: Matrix; sx: cdouble; sy: cdouble) {.
    importc: "cairo_matrix_init_scale", libcairo.}
proc initRotate*(matrix: Matrix; radians: cdouble) {.
    importc: "cairo_matrix_init_rotate", libcairo.}
proc translate*(matrix: Matrix; tx: cdouble; ty: cdouble) {.
    importc: "cairo_matrix_translate", libcairo.}
proc scale*(matrix: Matrix; sx: cdouble; sy: cdouble) {.
    importc: "cairo_matrix_scale", libcairo.}
proc rotate*(matrix: Matrix; radians: cdouble) {.
    importc: "cairo_matrix_rotate", libcairo.}
proc invert*(matrix: Matrix): Status {.
    importc: "cairo_matrix_invert", libcairo.}
proc multiply*(result: Matrix; a: Matrix;
                         b: Matrix) {.importc: "cairo_matrix_multiply",
    libcairo.}
proc transformDistance*(matrix: Matrix; dx: var cdouble;
                                  dy: var cdouble) {.
    importc: "cairo_matrix_transform_distance", libcairo.}
proc transformPoint*(matrix: Matrix; x: var cdouble;
                               y: var cdouble) {.
    importc: "cairo_matrix_transform_point", libcairo.}

type
  Region* =  ptr RegionObj
  RegionPtr* = ptr RegionObj
  RegionObj* = object

type
  RegionOverlap* {.size: sizeof(cint), pure.} = enum
    `IN`, `OUT`, PART

proc regionCreate*(): Region {.importc: "cairo_region_create",
    libcairo.}
proc regionCreateRectangle*(rectangle: RectangleInt): Region {.
    importc: "cairo_region_create_rectangle", libcairo.}
proc regionCreateRectangles*(rects: RectangleInt; count: cint): Region {.
    importc: "cairo_region_create_rectangles", libcairo.}
proc copy*(original: Region): Region {.
    importc: "cairo_region_copy", libcairo.}
proc reference*(region: Region): Region {.
    importc: "cairo_region_reference", libcairo.}
proc destroy*(region: Region) {.
    importc: "cairo_region_destroy", libcairo.}
proc equal*(a: Region; b: Region): CairoBoolT {.
    importc: "cairo_region_equal", libcairo.}
proc status*(region: Region): Status {.
    importc: "cairo_region_status", libcairo.}
proc getExtents*(region: Region;
                           extents: var RectangleIntObj) {.
    importc: "cairo_region_get_extents", libcairo.}
proc numRectangles*(region: Region): cint {.
    importc: "cairo_region_num_rectangles", libcairo.}
proc getRectangle*(region: Region; nth: cint;
                             rectangle: var RectangleIntObj) {.
    importc: "cairo_region_get_rectangle", libcairo.}
proc isEmpty*(region: Region): CairoBoolT {.
    importc: "cairo_region_is_empty", libcairo.}
proc containsRectangle*(region: Region;
                                  rectangle: RectangleInt): RegionOverlap {.
    importc: "cairo_region_contains_rectangle", libcairo.}
proc containsPoint*(region: Region; x: cint; y: cint): CairoBoolT {.
    importc: "cairo_region_contains_point", libcairo.}
proc translate*(region: Region; dx: cint; dy: cint) {.
    importc: "cairo_region_translate", libcairo.}
proc subtract*(dst: Region; other: Region): Status {.
    importc: "cairo_region_subtract", libcairo.}
proc subtractRectangle*(dst: Region;
                                  rectangle: RectangleInt): Status {.
    importc: "cairo_region_subtract_rectangle", libcairo.}
proc intersect*(dst: Region; other: Region): Status {.
    importc: "cairo_region_intersect", libcairo.}
proc intersectRectangle*(dst: Region;
                                   rectangle: RectangleInt): Status {.
    importc: "cairo_region_intersect_rectangle", libcairo.}
proc union*(dst: Region; other: Region): Status {.
    importc: "cairo_region_union", libcairo.}
proc unionRectangle*(dst: Region;
                               rectangle: RectangleInt): Status {.
    importc: "cairo_region_union_rectangle", libcairo.}
proc xor_op*(dst: Region; other: Region): Status {.
    importc: "cairo_region_xor", libcairo.}
proc xorRectangle*(dst: Region;
                             rectangle: RectangleInt): Status {.
    importc: "cairo_region_xor_rectangle", libcairo.}

proc debugResetStaticData*() {.importc: "cairo_debug_reset_static_data",
                                  libcairo.}

when CAIRO_HAS_PDF_SURFACE:
  type
    PdfVersion* {.size: sizeof(cint), pure.} = enum
      V1_4, V1_5
  proc pdfSurfaceCreate*(filename: cstring; widthInPoints: cdouble;
                             heightInPoints: cdouble): Surface {.
      importc: "cairo_pdf_surface_create", libcairo.}
  proc pdfSurfaceCreateForStream*(writeFunc: CairoWriteFuncT;
                                      closure: pointer; widthInPoints: cdouble;
                                      heightInPoints: cdouble): Surface {.
      importc: "cairo_pdf_surface_create_for_stream", libcairo.}
  proc pdfSurfaceRestrictToVersion*(surface: Surface;
                                        version: PdfVersion) {.
      importc: "cairo_pdf_surface_restrict_to_version", libcairo.}
  proc pdfGetVersions*(versions: ptr ptr PdfVersion; numVersions: var cint) {.
      importc: "cairo_pdf_get_versions", libcairo.}
  proc toString*(version: PdfVersion): cstring {.
      importc: "cairo_pdf_version_to_string", libcairo.}
  proc pdfSurfaceSetSize*(surface: Surface; widthInPoints: cdouble;
                              heightInPoints: cdouble) {.
      importc: "cairo_pdf_surface_set_size", libcairo.}
  type
    PdfOutlineFlags* {.size: sizeof(cint), pure.} = enum
      FLAG_OPEN = 0x1,
      FLAG_BOLD = 0x2,
      FLAG_ITALIC = 0x4
  const
    CAIRO_PDF_OUTLINE_ROOT* = 0
  proc pdfSurfaceAddOutline*(surface: Surface; parentId: cint;
                                 utf8: cstring; dest: cstring;
                                 flags: PdfOutlineFlags): cint {.
      importc: "cairo_pdf_surface_add_outline", libcairo.}
  type
    PdfMetadata* {.size: sizeof(cint), pure.} = enum
      TITLE, AUTHOR,
      SUBJECT, KEYWORDS,
      CREATOR, CREATE_DATE,
      MOD_DATE
  proc pdfSurfaceSetMetadata*(surface: Surface;
                                  metadata: PdfMetadata; utf8: cstring) {.
      importc: "cairo_pdf_surface_set_metadata", libcairo.}
  proc pdfSurfaceSetPageLabel*(surface: Surface; utf8: cstring) {.
      importc: "cairo_pdf_surface_set_page_label", libcairo.}
  proc pdfSurfaceSetThumbnailSize*(surface: Surface; width: cint;
                                       height: cint) {.
      importc: "cairo_pdf_surface_set_thumbnail_size", libcairo.}

when CAIRO_HAS_PS_SURFACE:
  type
    PS_Level* {.size: sizeof(cint), pure.} = enum
      L2, L3
  proc psSurfaceCreate*(filename: cstring; widthInPoints: cdouble;
                            heightInPoints: cdouble): Surface {.
      importc: "cairo_ps_surface_create", libcairo.}
  proc psSurfaceCreateForStream*(writeFunc: CairoWriteFuncT; closure: pointer;
                                     widthInPoints: cdouble;
                                     heightInPoints: cdouble): Surface {.
      importc: "cairo_ps_surface_create_for_stream", libcairo.}
  proc psSurfaceRestrictToLevel*(surface: Surface;
                                     level: PsLevel) {.
      importc: "cairo_ps_surface_restrict_to_level", libcairo.}
  proc psGetLevels*(levels: ptr ptr PsLevel; numLevels: var cint) {.
      importc: "cairo_ps_get_levels", libcairo.}
  proc toString*(level: PsLevel): cstring {.
      importc: "cairo_ps_level_to_string", libcairo.}
  proc psSurfaceSetEps*(surface: Surface; eps: CairoBoolT) {.
      importc: "cairo_ps_surface_set_eps", libcairo.}
  proc psSurfaceGetEps*(surface: Surface): CairoBoolT {.
      importc: "cairo_ps_surface_get_eps", libcairo.}
  proc psSurfaceSetSize*(surface: Surface; widthInPoints: cdouble;
                             heightInPoints: cdouble) {.
      importc: "cairo_ps_surface_set_size", libcairo.}
  proc psSurfaceDscComment*(surface: Surface; comment: cstring) {.
      importc: "cairo_ps_surface_dsc_comment", libcairo.}
  proc psSurfaceDscBeginSetup*(surface: Surface) {.
      importc: "cairo_ps_surface_dsc_begin_setup", libcairo.}
  proc psSurfaceDscBeginPageSetup*(surface: Surface) {.
      importc: "cairo_ps_surface_dsc_begin_page_setup", libcairo.}

when CAIRO_HAS_SVG_SURFACE:
  type
    SvgVersion* {.size: sizeof(cint), pure.} = enum
      V1_1, V1_2
  proc svgSurfaceCreate*(filename: cstring; widthInPoints: cdouble;
                             heightInPoints: cdouble): Surface {.
      importc: "cairo_svg_surface_create", libcairo.}
  proc svgSurfaceCreateForStream*(writeFunc: CairoWriteFuncT;
                                      closure: pointer; widthInPoints: cdouble;
                                      heightInPoints: cdouble): Surface {.
      importc: "cairo_svg_surface_create_for_stream", libcairo.}
  proc svgSurfaceRestrictToVersion*(surface: Surface;
                                        version: SvgVersion) {.
      importc: "cairo_svg_surface_restrict_to_version", libcairo.}
  proc svgGetVersions*(versions: ptr ptr SvgVersion; numVersions: var cint) {.
      importc: "cairo_svg_get_versions", libcairo.}
  proc toString*(version: SvgVersion): cstring {.
      importc: "cairo_svg_version_to_string", libcairo.}

when CAIRO_HAS_XML_SURFACE:
  proc xmlCreate*(filename: cstring): Device {.
      importc: "cairo_xml_create", libcairo.}
  proc xmlCreateForStream*(writeFunc: CairoWriteFuncT; closure: pointer): Device {.
      importc: "cairo_xml_create_for_stream", libcairo.}
  proc xmlSurfaceCreate*(xml: Device; content: Content;
                             width: cdouble; height: cdouble): Surface {.
      importc: "cairo_xml_surface_create", libcairo.}
  proc xmlForRecordingSurface*(xml: Device;
                                   surface: Surface): Status {.
      importc: "cairo_xml_for_recording_surface", libcairo.}

when CAIRO_HAS_SCRIPT_SURFACE:
  type
    ScriptMode* {.size: sizeof(cint), pure.} = enum
      ASCII, BINARY
  proc scriptCreate*(filename: cstring): Device {.
      importc: "cairo_script_create", libcairo.}
  proc scriptCreateForStream*(writeFunc: CairoWriteFuncT; closure: pointer): Device {.
      importc: "cairo_script_create_for_stream", libcairo.}
  proc scriptWriteComment*(script: Device; comment: cstring; len: cint) {.
      importc: "cairo_script_write_comment", libcairo.}
  proc scriptSetMode*(script: Device; mode: ScriptMode) {.
      importc: "cairo_script_set_mode", libcairo.}
  proc scriptGetMode*(script: Device): ScriptMode {.
      importc: "cairo_script_get_mode", libcairo.}
  proc scriptSurfaceCreate*(script: Device; content: Content;
                                width: cdouble; height: cdouble): Surface {.
      importc: "cairo_script_surface_create", libcairo.}
  proc scriptSurfaceCreateForTarget*(script: Device;
      target: Surface): Surface {.
      importc: "cairo_script_surface_create_for_target", libcairo.}
  proc scriptFromRecordingSurface*(script: Device;
                                       recordingSurface: Surface): Status {.
      importc: "cairo_script_from_recording_surface", libcairo.}

when CAIRO_HAS_SKIA_SURFACE:
  proc skiaSurfaceCreate*(format: Format; width: cint; height: cint): Surface {.
      importc: "cairo_skia_surface_create", libcairo.}
  proc skiaSurfaceCreateForData*(data: ptr cuchar; format: Format;
                                     width: cint; height: cint; stride: cint): Surface {.
      importc: "cairo_skia_surface_create_for_data", libcairo.}

when CAIRO_HAS_DRM_SURFACE:
  type
    UdevDevice* = object
  proc drmDeviceGet*(device: ptr UdevDevice): Device {.
      importc: "cairo_drm_device_get", libcairo.}
  proc drmDeviceGetForFd*(fd: cint): Device {.
      importc: "cairo_drm_device_get_for_fd", libcairo.}
  proc drmDeviceDefault*(): Device {.
      importc: "cairo_drm_device_default", libcairo.}
  proc drmDeviceGetFd*(device: Device): cint {.
      importc: "cairo_drm_device_get_fd", libcairo.}
  proc drmDeviceThrottle*(device: Device) {.
      importc: "cairo_drm_device_throttle", libcairo.}
  proc drmSurfaceCreate*(device: Device; format: Format;
                             width: cint; height: cint): Surface {.
      importc: "cairo_drm_surface_create", libcairo.}
  proc drmSurfaceCreateForName*(device: Device; name: cuint;
                                    format: Format; width: cint; height: cint;
                                    stride: cint): Surface {.
      importc: "cairo_drm_surface_create_for_name", libcairo.}
  proc drmSurfaceCreateFromCacheableImage*(device: Device;
      surface: Surface): Surface {.
      importc: "cairo_drm_surface_create_from_cacheable_image", libcairo.}
  proc drmSurfaceEnableScanOut*(surface: Surface): Status {.
      importc: "cairo_drm_surface_enable_scan_out", libcairo.}
  proc drmSurfaceGetHandle*(surface: Surface): cuint {.
      importc: "cairo_drm_surface_get_handle", libcairo.}
  proc drmSurfaceGetName*(surface: Surface): cuint {.
      importc: "cairo_drm_surface_get_name", libcairo.}
  proc drmSurfaceGetFormat*(surface: Surface): Format {.
      importc: "cairo_drm_surface_get_format", libcairo.}
  proc drmSurfaceGetWidth*(surface: Surface): cint {.
      importc: "cairo_drm_surface_get_width", libcairo.}
  proc drmSurfaceGetHeight*(surface: Surface): cint {.
      importc: "cairo_drm_surface_get_height", libcairo.}
  proc drmSurfaceGetStride*(surface: Surface): cint {.
      importc: "cairo_drm_surface_get_stride", libcairo.}
  proc drmSurfaceMapToImage*(surface: Surface): Surface {.
      importc: "cairo_drm_surface_map_to_image", libcairo.}
  proc drmSurfaceUnmap*(drmSurface: Surface;
                            imageSurface: Surface) {.
      importc: "cairo_drm_surface_unmap", libcairo.}

when CAIRO_HAS_TEE_SURFACE:
  proc teeSurfaceCreate*(master: Surface): Surface {.
      importc: "cairo_tee_surface_create", libcairo.}
  proc teeSurfaceAdd*(surface: Surface; target: Surface) {.
      importc: "cairo_tee_surface_add", libcairo.}
  proc teeSurfaceRemove*(surface: Surface; target: Surface) {.
      importc: "cairo_tee_surface_remove", libcairo.}
  proc teeSurfaceIndex*(surface: Surface; index: cuint): Surface {.
      importc: "cairo_tee_surface_index", libcairo.}

