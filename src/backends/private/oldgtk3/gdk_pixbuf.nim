{.deadCodeElim: on.}

from glib import Gpointer, Gboolean, GQuark, Gsize
from gobject import GObject, GType, GObjectObj, GObjectClassObj
from gio import GInputStream, GOutputStream, GCancellable, GAsyncResult, GAsyncReadyCallback

when defined(windows):
  const LIB_PIXBUF = "libgdk_pixbuf-2.0-0.dll"
elif defined(macosx):
  const LIB_PIXBUF = "libgdk_pixbuf-2.0.0.dylib"
else:
  const LIB_PIXBUF = "libgdk_pixbuf-2.0.so"

{.pragma: libpixbuf, cdecl, dynlib: LIB_PIXBUF.}

const
  DISABLE_DEPRECATED* = false
  ENABLE_BACKEND* = true
  GTK_DOC_IGNORE = false

type
  GModule = object # dummy object -- GModule is still missing...

type
  AlphaMode* {.size: sizeof(cint), pure.} = enum
    BILEVEL, FULL

type
  GdkColorspace* {.size: sizeof(cint), pure.} = enum
    RGB

type
  GdkPixbuf* =  ptr GdkPixbufObj
  GdkPixbufPtr* = ptr GdkPixbufObj
  GdkPixbufObj* = object of GObjectObj

template typePixbuf*(): untyped =
  (gdkPixbufGetType())

template pixbuf*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typePixbuf, GdkPixbufObj))

template isPixbuf*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typePixbuf))

type
  DestroyNotify* = proc (pixels: var cuchar; data: Gpointer) {.cdecl.}

template pixbufError*(): untyped =
  pixbufErrorQuark()

type
  Error* {.size: sizeof(cint), pure.} = enum
    CORRUPT_IMAGE, INSUFFICIENT_MEMORY,
    BAD_OPTION, UNKNOWN_TYPE,
    UNSUPPORTED_OPERATION, FAILED,
    INCOMPLETE_ANIMATION

proc errorQuark*(): GQuark {.importc: "gdk_pixbuf_error_quark", libpixbuf.}
proc pixbufGetType*(): GType {.importc: "gdk_pixbuf_get_type", libpixbuf.}

when not DISABLE_DEPRECATED:
  proc `ref`*(pixbuf: GdkPixbuf): GdkPixbuf {.
      importc: "gdk_pixbuf_ref", libpixbuf.}
  proc unref*(pixbuf: GdkPixbuf) {.importc: "gdk_pixbuf_unref",
      libpixbuf.}

proc getColorspace*(pixbuf: GdkPixbuf): GdkColorspace {.
    importc: "gdk_pixbuf_get_colorspace", libpixbuf.}

proc colorspace*(pixbuf: GdkPixbuf): GdkColorspace {.
    importc: "gdk_pixbuf_get_colorspace", libpixbuf.}
proc getNChannels*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_n_channels", libpixbuf.}
proc nChannels*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_n_channels", libpixbuf.}
proc getHasAlpha*(pixbuf: GdkPixbuf): Gboolean {.
    importc: "gdk_pixbuf_get_has_alpha", libpixbuf.}
proc hasAlpha*(pixbuf: GdkPixbuf): Gboolean {.
    importc: "gdk_pixbuf_get_has_alpha", libpixbuf.}
proc getBitsPerSample*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_bits_per_sample", libpixbuf.}
proc bitsPerSample*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_bits_per_sample", libpixbuf.}
proc getPixels*(pixbuf: GdkPixbuf): ptr cuchar {.
    importc: "gdk_pixbuf_get_pixels", libpixbuf.}
proc pixels*(pixbuf: GdkPixbuf): ptr cuchar {.
    importc: "gdk_pixbuf_get_pixels", libpixbuf.}
proc getWidth*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_width", libpixbuf.}
proc width*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_width", libpixbuf.}
proc getHeight*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_height", libpixbuf.}
proc height*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_height", libpixbuf.}
proc getRowstride*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_rowstride", libpixbuf.}
proc rowstride*(pixbuf: GdkPixbuf): cint {.
    importc: "gdk_pixbuf_get_rowstride", libpixbuf.}
proc getByteLength*(pixbuf: GdkPixbuf): Gsize {.
    importc: "gdk_pixbuf_get_byte_length", libpixbuf.}
proc byteLength*(pixbuf: GdkPixbuf): Gsize {.
    importc: "gdk_pixbuf_get_byte_length", libpixbuf.}
proc getPixelsWithLength*(pixbuf: GdkPixbuf; length: var cuint): ptr cuchar {.
    importc: "gdk_pixbuf_get_pixels_with_length", libpixbuf.}
proc pixelsWithLength*(pixbuf: GdkPixbuf; length: var cuint): ptr cuchar {.
    importc: "gdk_pixbuf_get_pixels_with_length", libpixbuf.}
proc readPixels*(pixbuf: GdkPixbuf): ptr uint8 {.
    importc: "gdk_pixbuf_read_pixels", libpixbuf.}
proc readPixelBytes*(pixbuf: GdkPixbuf): glib.GBytes {.
    importc: "gdk_pixbuf_read_pixel_bytes", libpixbuf.}

proc newPixbuf*(colorspace: GdkColorspace; hasAlpha: Gboolean;
                  bitsPerSample: cint; width: cint; height: cint): GdkPixbuf {.
    importc: "gdk_pixbuf_new", libpixbuf.}

proc copy*(pixbuf: GdkPixbuf): GdkPixbuf {.
    importc: "gdk_pixbuf_copy", libpixbuf.}

proc newSubpixbuf*(srcPixbuf: GdkPixbuf; srcX: cint; srcY: cint;
                           width: cint; height: cint): GdkPixbuf {.
    importc: "gdk_pixbuf_new_subpixbuf", libpixbuf.}

when defined(windows):
  proc newPixbufFromFileUtf8*(filename: cstring; error: var glib.GError): GdkPixbuf {.
      importc: "gdk_pixbuf_new_from_file_utf8", libpixbuf.}
  proc newPixbufFromFileAtSizeUtf8*(filename: cstring; width: cint; height: cint;
                                      error: var glib.GError): GdkPixbuf {.
      importc: "gdk_pixbuf_new_from_file_at_size_utf8", libpixbuf.}
  proc newPixbufFromFileAtScaleUtf8*(filename: cstring; width: cint; height: cint;
                                       preserveAspectRatio: Gboolean;
                                       error: var glib.GError): GdkPixbuf {.
      importc: "gdk_pixbuf_new_from_file_at_scale_utf8", libpixbuf.}
proc newPixbufFromFile*(filename: cstring; error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_file", libpixbuf.}
proc newPixbufFromFileAtSize*(filename: cstring; width: cint; height: cint;
                                error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_file_at_size", libpixbuf.}
proc newPixbufFromFileAtScale*(filename: cstring; width: cint; height: cint;
                                 preserveAspectRatio: Gboolean;
                                 error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_file_at_scale", libpixbuf.}
proc newPixbufFromResource*(resourcePath: cstring; error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_resource", libpixbuf.}
proc newPixbufFromResourceAtScale*(resourcePath: cstring; width: cint;
                                     height: cint; preserveAspectRatio: Gboolean;
                                     error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_resource_at_scale", libpixbuf.}
proc newPixbufFromData*(data: var cuchar; colorspace: GdkColorspace;
                          hasAlpha: Gboolean; bitsPerSample: cint; width: cint;
                          height: cint; rowstride: cint;
                          destroyFn: DestroyNotify;
                          destroyFnData: Gpointer): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_data", libpixbuf.}
proc newPixbufFromBytes*(data: glib.GBytes; colorspace: GdkColorspace;
                           hasAlpha: Gboolean; bitsPerSample: cint; width: cint;
                           height: cint; rowstride: cint): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_bytes", libpixbuf.}
proc newPixbufFromXpmData*(data: cstringArray): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_xpm_data", libpixbuf.}
when not DISABLE_DEPRECATED:
  proc newPixbufFromInline*(dataLength: cint; data: var uint8;
                              copyPixels: Gboolean; error: var glib.GError): GdkPixbuf {.
      importc: "gdk_pixbuf_new_from_inline", libpixbuf.}

proc fill*(pixbuf: GdkPixbuf; pixel: uint32) {.
    importc: "gdk_pixbuf_fill", libpixbuf.}

proc save*(pixbuf: GdkPixbuf; filename: cstring; `type`: cstring;
                   error: var glib.GError): Gboolean {.varargs,
    importc: "gdk_pixbuf_save", libpixbuf.}
proc savev*(pixbuf: GdkPixbuf; filename: cstring; `type`: cstring;
                    optionKeys: cstringArray; optionValues: cstringArray;
                    error: var glib.GError): Gboolean {.importc: "gdk_pixbuf_savev",
    libpixbuf.}
when defined(windows):
  proc savevUtf8*(pixbuf: GdkPixbuf; filename: cstring; `type`: cstring;
                          optionKeys: cstringArray; optionValues: cstringArray;
                          error: var glib.GError): Gboolean {.
      importc: "gdk_pixbuf_savev_utf8", libpixbuf.}

type
  SaveFunc* = proc (buf: cstring; count: Gsize; error: var glib.GError;
                          data: Gpointer): Gboolean {.cdecl.}

proc saveToCallback*(pixbuf: GdkPixbuf; saveFunc: SaveFunc;
                             userData: Gpointer; `type`: cstring;
                             error: var glib.GError): Gboolean {.varargs,
    importc: "gdk_pixbuf_save_to_callback", libpixbuf.}
proc saveToCallbackv*(pixbuf: GdkPixbuf; saveFunc: SaveFunc;
                              userData: Gpointer; `type`: cstring;
                              optionKeys: cstringArray;
                              optionValues: cstringArray; error: var glib.GError): Gboolean {.
    importc: "gdk_pixbuf_save_to_callbackv", libpixbuf.}

proc saveToBuffer*(pixbuf: GdkPixbuf; buffer: cstringArray;
                           bufferSize: var Gsize; `type`: cstring;
                           error: var glib.GError): Gboolean {.varargs,
    importc: "gdk_pixbuf_save_to_buffer", libpixbuf.}
proc saveToBufferv*(pixbuf: GdkPixbuf; buffer: cstringArray;
                            bufferSize: var Gsize; `type`: cstring;
                            optionKeys: cstringArray; optionValues: cstringArray;
                            error: var glib.GError): Gboolean {.
    importc: "gdk_pixbuf_save_to_bufferv", libpixbuf.}
proc newPixbufFromStream*(stream: gio.GInputStream;
                            cancellable: gio.GCancellable; error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_stream", libpixbuf.}
proc newPixbufFromStreamAsync*(stream: gio.GInputStream;
                                 cancellable: gio.GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "gdk_pixbuf_new_from_stream_async", libpixbuf.}
proc newPixbufFromStreamFinish*(asyncResult: gio.GAsyncResult;
                                  error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_stream_finish", libpixbuf.}
proc newPixbufFromStreamAtScale*(stream: gio.GInputStream; width: cint;
                                   height: cint; preserveAspectRatio: Gboolean;
                                   cancellable: gio.GCancellable;
                                   error: var glib.GError): GdkPixbuf {.
    importc: "gdk_pixbuf_new_from_stream_at_scale", libpixbuf.}
proc newPixbufFromStreamAtScaleAsync*(stream: gio.GInputStream; width: cint;
                                        height: cint;
                                        preserveAspectRatio: Gboolean;
                                        cancellable: gio.GCancellable;
                                        callback: GAsyncReadyCallback;
                                        userData: Gpointer) {.
    importc: "gdk_pixbuf_new_from_stream_at_scale_async", libpixbuf.}
proc saveToStream*(pixbuf: GdkPixbuf; stream: gio.GOutputStream;
                           `type`: cstring; cancellable: gio.GCancellable;
                           error: var glib.GError): Gboolean {.varargs,
    importc: "gdk_pixbuf_save_to_stream", libpixbuf.}
proc saveToStreamAsync*(pixbuf: GdkPixbuf; stream: gio.GOutputStream;
                                `type`: cstring; cancellable: gio.GCancellable;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.
    varargs, importc: "gdk_pixbuf_save_to_stream_async", libpixbuf.}
proc saveToStreamFinish*(asyncResult: gio.GAsyncResult;
                                 error: var glib.GError): Gboolean {.
    importc: "gdk_pixbuf_save_to_stream_finish", libpixbuf.}
proc saveToStreamvAsync*(pixbuf: GdkPixbuf; stream: gio.GOutputStream;
                                 `type`: cstring; optionKeys: cstringArray;
                                 optionValues: cstringArray;
                                 cancellable: gio.GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "gdk_pixbuf_save_to_streamv_async", libpixbuf.}
proc saveToStreamv*(pixbuf: GdkPixbuf; stream: gio.GOutputStream;
                            `type`: cstring; optionKeys: cstringArray;
                            optionValues: cstringArray;
                            cancellable: gio.GCancellable; error: var glib.GError): Gboolean {.
    importc: "gdk_pixbuf_save_to_streamv", libpixbuf.}

proc addAlpha*(pixbuf: GdkPixbuf; substituteColor: Gboolean; r: cuchar;
                       g: cuchar; b: cuchar): GdkPixbuf {.
    importc: "gdk_pixbuf_add_alpha", libpixbuf.}

proc copyArea*(srcPixbuf: GdkPixbuf; srcX: cint; srcY: cint; width: cint;
                       height: cint; destPixbuf: GdkPixbuf; destX: cint;
                       destY: cint) {.importc: "gdk_pixbuf_copy_area", libpixbuf.}

proc saturateAndPixelate*(src: GdkPixbuf; dest: GdkPixbuf;
                                  saturation: cfloat; pixelate: Gboolean) {.
    importc: "gdk_pixbuf_saturate_and_pixelate", libpixbuf.}

proc applyEmbeddedOrientation*(src: GdkPixbuf): GdkPixbuf {.
    importc: "gdk_pixbuf_apply_embedded_orientation", libpixbuf.}

proc setOption*(pixbuf: GdkPixbuf; key: cstring; value: cstring): Gboolean {.
    importc: "gdk_pixbuf_set_option", libpixbuf.}
proc getOption*(pixbuf: GdkPixbuf; key: cstring): cstring {.
    importc: "gdk_pixbuf_get_option", libpixbuf.}
proc option*(pixbuf: GdkPixbuf; key: cstring): cstring {.
    importc: "gdk_pixbuf_get_option", libpixbuf.}
proc removeOption*(pixbuf: GdkPixbuf; key: cstring): Gboolean {.
    importc: "gdk_pixbuf_remove_option", libpixbuf.}
proc getOptions*(pixbuf: GdkPixbuf): glib.GHashTable {.
    importc: "gdk_pixbuf_get_options", libpixbuf.}
proc options*(pixbuf: GdkPixbuf): glib.GHashTable {.
    importc: "gdk_pixbuf_get_options", libpixbuf.}
proc copyOptions*(srcPixbuf: GdkPixbuf; destPixbuf: GdkPixbuf): Gboolean {.
    importc: "gdk_pixbuf_copy_options", libpixbuf.}

type
  GdkInterpType* {.size: sizeof(cint), pure.} = enum
    NEAREST, TILES, BILINEAR, HYPER

type
  Rotation* {.size: sizeof(cint), pure.} = enum
    NONE = 0, COUNTERCLOCKWISE = 90,
    UPSIDEDOWN = 180, CLOCKWISE = 270

proc scale*(src: GdkPixbuf; dest: GdkPixbuf; destX: cint; destY: cint;
                    destWidth: cint; destHeight: cint; offsetX: cdouble;
                    offsetY: cdouble; scaleX: cdouble; scaleY: cdouble;
                    interpType: GdkInterpType) {.importc: "gdk_pixbuf_scale",
    libpixbuf.}
proc composite*(src: GdkPixbuf; dest: GdkPixbuf; destX: cint;
                        destY: cint; destWidth: cint; destHeight: cint;
                        offsetX: cdouble; offsetY: cdouble; scaleX: cdouble;
                        scaleY: cdouble; interpType: GdkInterpType;
                        overallAlpha: cint) {.importc: "gdk_pixbuf_composite",
    libpixbuf.}
proc compositeColor*(src: GdkPixbuf; dest: GdkPixbuf; destX: cint;
                             destY: cint; destWidth: cint; destHeight: cint;
                             offsetX: cdouble; offsetY: cdouble; scaleX: cdouble;
                             scaleY: cdouble; interpType: GdkInterpType;
                             overallAlpha: cint; checkX: cint; checkY: cint;
                             checkSize: cint; color1: uint32; color2: uint32) {.
    importc: "gdk_pixbuf_composite_color", libpixbuf.}
proc scaleSimple*(src: GdkPixbuf; destWidth: cint; destHeight: cint;
                          interpType: GdkInterpType): GdkPixbuf {.
    importc: "gdk_pixbuf_scale_simple", libpixbuf.}
proc compositeColorSimple*(src: GdkPixbuf; destWidth: cint;
                                   destHeight: cint; interpType: GdkInterpType;
                                   overallAlpha: cint; checkSize: cint;
                                   color1: uint32; color2: uint32): GdkPixbuf {.
    importc: "gdk_pixbuf_composite_color_simple", libpixbuf.}
proc rotateSimple*(src: GdkPixbuf; angle: Rotation): GdkPixbuf {.
    importc: "gdk_pixbuf_rotate_simple", libpixbuf.}
proc flip*(src: GdkPixbuf; horizontal: Gboolean): GdkPixbuf {.
    importc: "gdk_pixbuf_flip", libpixbuf.}
when ENABLE_BACKEND:
  template pixbufAnimationClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, typePixbufAnimation, AnimationClassObj))

  template isPixbufAnimationClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, typePixbufAnimation))

  template pixbufAnimationGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, typePixbufAnimation, AnimationClassObj))

  type
    Animation* =  ptr AnimationObj
    AnimationPtr* = ptr AnimationObj
    AnimationObj*{.final.} = object of GObjectObj

  type
    AnimationIter* =  ptr AnimationIterObj
    AnimationIterPtr* = ptr AnimationIterObj
    AnimationIterObj*{.final.} = object of GObjectObj

  type
    AnimationClass* =  ptr AnimationClassObj
    AnimationClassPtr* = ptr AnimationClassObj
    AnimationClassObj*{.final.} = object of GObjectClassObj
      isStaticImage*: proc (anim: Animation): Gboolean {.cdecl.}
      getStaticImage*: proc (anim: Animation): GdkPixbuf {.cdecl.}
      getSize*: proc (anim: Animation; width: var cint; height: var cint) {.cdecl.}
      getIter*: proc (anim: Animation; startTime: glib.GTimeVal): AnimationIter {.cdecl.}

  type
    AnimationIterClass* =  ptr AnimationIterClassObj
    AnimationIterClassPtr* = ptr AnimationIterClassObj
    AnimationIterClassObj*{.final.} = object of GObjectClassObj
      getDelayTime*: proc (iter: AnimationIter): cint {.cdecl.}
      getPixbuf*: proc (iter: AnimationIter): GdkPixbuf {.cdecl.}
      onCurrentlyLoadingFrame*: proc (iter: AnimationIter): Gboolean {.cdecl.}
      advance*: proc (iter: AnimationIter; currentTime: glib.GTimeVal): Gboolean {.cdecl.}

  template pixbufAnimationIterClass*(klass: untyped): untyped =
    (gTypeCheckClassCast(klass, typePixbufAnimationIter, AnimationIterClassObj))

  template isPixbufAnimationIterClass*(klass: untyped): untyped =
    (gTypeCheckClassType(klass, typePixbufAnimationIter))

  template pixbufAnimationIterGetClass*(obj: untyped): untyped =
    (gTypeInstanceGetClass(obj, typePixbufAnimationIter, AnimationIterClassObj))

  proc nonAnimGetType*(): GType {.importc: "gdk_pixbuf_non_anim_get_type",
                                        libpixbuf.}
  proc newNonAnim*(pixbuf: GdkPixbuf): Animation {.
      importc: "gdk_pixbuf_non_anim_new", libpixbuf.}

template typePixbufAnimation*(): untyped =
  (animationGetType())

template pixbufAnimation*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typePixbufAnimation, AnimationObj))

template isPixbufAnimation*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typePixbufAnimation))

template typePixbufAnimationIter*(): untyped =
  (animationIterGetType())

template pixbufAnimationIter*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typePixbufAnimationIter, AnimationIterObj))

template isPixbufAnimationIter*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typePixbufAnimationIter))

proc animationGetType*(): GType {.importc: "gdk_pixbuf_animation_get_type",
                                        libpixbuf.}
when defined(windows):
  proc newAnimationUtf8*(filename: cstring; error: var glib.GError): Animation {.
      importc: "gdk_pixbuf_animation_new_from_file_utf8", libpixbuf.}
proc newAnimation*(filename: cstring; error: var glib.GError): Animation {.
    importc: "gdk_pixbuf_animation_new_from_file", libpixbuf.}
proc newAnimation*(stream: gio.GInputStream;
                                     cancellable: gio.GCancellable;
                                     error: var glib.GError): Animation {.
    importc: "gdk_pixbuf_animation_new_from_stream", libpixbuf.}
proc newAnimation*(stream: gio.GInputStream;
    cancellable: gio.GCancellable; callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "gdk_pixbuf_animation_new_from_stream_async", libpixbuf.}
proc newAnimation*(asyncResult: gio.GAsyncResult;
    error: var glib.GError): Animation {.
    importc: "gdk_pixbuf_animation_new_from_stream_finish", libpixbuf.}
proc newAnimation*(resourcePath: cstring;
                                       error: var glib.GError): Animation {.
    importc: "gdk_pixbuf_animation_new_from_resource", libpixbuf.}
when not DISABLE_DEPRECATED:
  proc `ref`*(animation: Animation): Animation {.
      importc: "gdk_pixbuf_animation_ref", libpixbuf.}
  proc unref*(animation: Animation) {.
      importc: "gdk_pixbuf_animation_unref", libpixbuf.}
proc getWidth*(animation: Animation): cint {.
    importc: "gdk_pixbuf_animation_get_width", libpixbuf.}
proc width*(animation: Animation): cint {.
    importc: "gdk_pixbuf_animation_get_width", libpixbuf.}
proc getHeight*(animation: Animation): cint {.
    importc: "gdk_pixbuf_animation_get_height", libpixbuf.}
proc height*(animation: Animation): cint {.
    importc: "gdk_pixbuf_animation_get_height", libpixbuf.}
proc isStaticImage*(animation: Animation): Gboolean {.
    importc: "gdk_pixbuf_animation_is_static_image", libpixbuf.}
proc getStaticImage*(animation: Animation): GdkPixbuf {.
    importc: "gdk_pixbuf_animation_get_static_image", libpixbuf.}
proc staticImage*(animation: Animation): GdkPixbuf {.
    importc: "gdk_pixbuf_animation_get_static_image", libpixbuf.}
proc getIter*(animation: Animation;
                               startTime: glib.GTimeVal): AnimationIter {.
    importc: "gdk_pixbuf_animation_get_iter", libpixbuf.}
proc iter*(animation: Animation;
                               startTime: glib.GTimeVal): AnimationIter {.
    importc: "gdk_pixbuf_animation_get_iter", libpixbuf.}
proc animationIterGetType*(): GType {.
    importc: "gdk_pixbuf_animation_iter_get_type", libpixbuf.}
proc getDelayTime*(iter: AnimationIter): cint {.
    importc: "gdk_pixbuf_animation_iter_get_delay_time", libpixbuf.}
proc delayTime*(iter: AnimationIter): cint {.
    importc: "gdk_pixbuf_animation_iter_get_delay_time", libpixbuf.}
proc getPixbuf*(iter: AnimationIter): GdkPixbuf {.
    importc: "gdk_pixbuf_animation_iter_get_pixbuf", libpixbuf.}
proc pixbuf*(iter: AnimationIter): GdkPixbuf {.
    importc: "gdk_pixbuf_animation_iter_get_pixbuf", libpixbuf.}
proc onCurrentlyLoadingFrame*(
    iter: AnimationIter): Gboolean {.
    importc: "gdk_pixbuf_animation_iter_on_currently_loading_frame", libpixbuf.}
proc advance*(iter: AnimationIter;
                                   currentTime: glib.GTimeVal): Gboolean {.
    importc: "gdk_pixbuf_animation_iter_advance", libpixbuf.}

type
  SimpleAnim* =  ptr SimpleAnimObj
  SimpleAnimPtr* = ptr SimpleAnimObj
  SimpleAnimObj* = object

template typePixbufSimpleAnim*(): untyped =
  (simpleAnimGetType())

template pixbufSimpleAnim*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typePixbufSimpleAnim, SimpleAnimObj))

template isPixbufSimpleAnim*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typePixbufSimpleAnim))

template pixbufSimpleAnimClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typePixbufSimpleAnim, SimpleAnimClass))

template isPixbufSimpleAnimClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typePixbufSimpleAnim))

template pixbufSimpleAnimGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typePixbufSimpleAnim, SimpleAnimClass))

proc simpleAnimGetType*(): GType {.
    importc: "gdk_pixbuf_simple_anim_get_type", libpixbuf.}
proc simpleAnimIterGetType*(): GType {.
    importc: "gdk_pixbuf_simple_anim_iter_get_type", libpixbuf.}
proc newSimpleAnim*(width: cint; height: cint; rate: cfloat): SimpleAnim {.
    importc: "gdk_pixbuf_simple_anim_new", libpixbuf.}
proc addFrame*(animation: SimpleAnim;
                                 pixbuf: GdkPixbuf) {.
    importc: "gdk_pixbuf_simple_anim_add_frame", libpixbuf.}
proc setLoop*(animation: SimpleAnim; loop: Gboolean) {.
    importc: "gdk_pixbuf_simple_anim_set_loop", libpixbuf.}
proc `loop=`*(animation: SimpleAnim; loop: Gboolean) {.
    importc: "gdk_pixbuf_simple_anim_set_loop", libpixbuf.}
proc getLoop*(animation: SimpleAnim): Gboolean {.
    importc: "gdk_pixbuf_simple_anim_get_loop", libpixbuf.}
proc loop*(animation: SimpleAnim): Gboolean {.
    importc: "gdk_pixbuf_simple_anim_get_loop", libpixbuf.}

when ENABLE_BACKEND:
  type
    ModuleSizeFunc* = proc (width: var cint; height: var cint;
                                  userData: Gpointer) {.cdecl.}
  type
    ModulePreparedFunc* = proc (pixbuf: GdkPixbuf;
                                      anim: Animation;
                                      userData: Gpointer) {.cdecl.}
  type
    ModuleUpdatedFunc* = proc (pixbuf: GdkPixbuf; x: cint; y: cint;
                                     width: cint; height: cint; userData: Gpointer) {.cdecl.}
  type
    ModulePattern* =  ptr ModulePatternObj
    ModulePatternPtr* = ptr ModulePatternObj
    ModulePatternObj* = object
      prefix*: cstring
      mask*: cstring
      relevance*: cint

  type
    Module* =  ptr ModuleObj
    ModulePtr* = ptr ModuleObj
    ModuleObj* = object
      moduleName*: cstring
      modulePath*: cstring
      module*: ptr GModule
      info*: Format
      load*: proc (f: ptr File; error: var glib.GError): GdkPixbuf {.cdecl.}
      loadXpmData*: proc (data: cstringArray): GdkPixbuf {.cdecl.}
      beginLoad*: proc (sizeFunc: ModuleSizeFunc;
                      prepareFunc: ModulePreparedFunc;
                      updateFunc: ModuleUpdatedFunc; userData: Gpointer;
                      error: var glib.GError): Gpointer {.cdecl.}
      stopLoad*: proc (context: Gpointer; error: var glib.GError): Gboolean {.cdecl.}
      loadIncrement*: proc (context: Gpointer; buf: var cuchar; size: cuint;
                          error: var glib.GError): Gboolean {.cdecl.}
      loadAnimation*: proc (f: ptr File; error: var glib.GError): Animation {.cdecl.}
      save*: proc (f: ptr File; pixbuf: GdkPixbuf; paramKeys: cstringArray;
                 paramValues: cstringArray; error: var glib.GError): Gboolean {.cdecl.}
      saveToCallback*: proc (saveFunc: SaveFunc; userData: Gpointer;
                           pixbuf: GdkPixbuf; optionKeys: cstringArray;
                           optionValues: cstringArray; error: var glib.GError): Gboolean {.cdecl.}
      isSaveOptionSupported*: proc (optionKey: cstring): Gboolean {.cdecl.}
      reserved1: proc () {.cdecl.}
      reserved2: proc () {.cdecl.}
      reserved3: proc () {.cdecl.}
      reserved4: proc () {.cdecl.}

    ModuleFillVtableFunc* = proc (module: Module) {.cdecl.}

    ModuleFillInfoFunc* = proc (info: Format) {.cdecl.}

    FormatFlags* {.size: sizeof(cint), pure.} = enum
      WRITABLE = 1 shl 0, SCALABLE = 1 shl 1,
      THREADSAFE = 1 shl 2

    Format* =  ptr FormatObj
    FormatPtr* = ptr FormatObj
    FormatObj* = object
      name*: cstring
      signature*: ModulePattern
      domain*: cstring
      description*: cstring
      mimeTypes*: cstringArray
      extensions*: cstringArray
      flags*: uint32
      disabled*: Gboolean
      license*: cstring

type
  Loader* =  ptr LoaderObj
  LoaderPtr* = ptr LoaderObj
  LoaderObj*{.final.} = object of GObjectObj
    priv*: Gpointer

  LoaderClass* =  ptr LoaderClassObj
  LoaderClassPtr* = ptr LoaderClassObj
  LoaderClassObj*{.final.} = object of GObjectClassObj
    sizePrepared*: proc (loader: Loader; width: cint; height: cint) {.cdecl.}
    areaPrepared*: proc (loader: Loader) {.cdecl.}
    areaUpdated*: proc (loader: Loader; x: cint; y: cint; width: cint;
                      height: cint) {.cdecl.}
    closed*: proc (loader: Loader) {.cdecl.}

template typePixbufLoader*(): untyped =
  (loaderGetType())

template pixbufLoader*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typePixbufLoader, LoaderObj))

template pixbufLoaderClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typePixbufLoader, LoaderClassObj))

template isPixbufLoader*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typePixbufLoader))

template isPixbufLoaderClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typePixbufLoader))

template pixbufLoaderGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typePixbufLoader, LoaderClassObj))

proc formatGetType*(): GType {.importc: "gdk_pixbuf_format_get_type",
                                     libpixbuf.}
proc getFormats*(): glib.GSList {.importc: "gdk_pixbuf_get_formats",
                                      libpixbuf.}
proc formats*(): glib.GSList {.importc: "gdk_pixbuf_get_formats",
                                      libpixbuf.}
proc getName*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_name", libpixbuf.}
proc name*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_name", libpixbuf.}
proc getDescription*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_description", libpixbuf.}
proc description*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_description", libpixbuf.}
proc getMimeTypes*(format: Format): cstringArray {.
    importc: "gdk_pixbuf_format_get_mime_types", libpixbuf.}
proc mimeTypes*(format: Format): cstringArray {.
    importc: "gdk_pixbuf_format_get_mime_types", libpixbuf.}
proc getExtensions*(format: Format): cstringArray {.
    importc: "gdk_pixbuf_format_get_extensions", libpixbuf.}
proc extensions*(format: Format): cstringArray {.
    importc: "gdk_pixbuf_format_get_extensions", libpixbuf.}
proc isSaveOptionSupported*(format: Format;
    optionKey: cstring): Gboolean {.importc: "gdk_pixbuf_format_is_save_option_supported",
                                 libpixbuf.}
proc isWritable*(format: Format): Gboolean {.
    importc: "gdk_pixbuf_format_is_writable", libpixbuf.}
proc isScalable*(format: Format): Gboolean {.
    importc: "gdk_pixbuf_format_is_scalable", libpixbuf.}
proc isDisabled*(format: Format): Gboolean {.
    importc: "gdk_pixbuf_format_is_disabled", libpixbuf.}
proc setDisabled*(format: Format; disabled: Gboolean) {.
    importc: "gdk_pixbuf_format_set_disabled", libpixbuf.}
proc `disabled=`*(format: Format; disabled: Gboolean) {.
    importc: "gdk_pixbuf_format_set_disabled", libpixbuf.}
proc getLicense*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_license", libpixbuf.}
proc license*(format: Format): cstring {.
    importc: "gdk_pixbuf_format_get_license", libpixbuf.}
proc getFileInfo*(filename: cstring; width: var cint; height: var cint): Format {.
    importc: "gdk_pixbuf_get_file_info", libpixbuf.}
proc fileInfo*(filename: cstring; width: var cint; height: var cint): Format {.
    importc: "gdk_pixbuf_get_file_info", libpixbuf.}
proc getFileInfoAsync*(filename: cstring; cancellable: gio.GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "gdk_pixbuf_get_file_info_async", libpixbuf.}
proc getFileInfoFinish*(asyncResult: gio.GAsyncResult; width: var cint;
                                height: var cint; error: var glib.GError): Format {.
    importc: "gdk_pixbuf_get_file_info_finish", libpixbuf.}
proc fileInfoFinish*(asyncResult: gio.GAsyncResult; width: var cint;
                                height: var cint; error: var glib.GError): Format {.
    importc: "gdk_pixbuf_get_file_info_finish", libpixbuf.}
proc copy*(format: Format): Format {.
    importc: "gdk_pixbuf_format_copy", libpixbuf.}
proc free*(format: Format) {.
    importc: "gdk_pixbuf_format_free", libpixbuf.}
proc loaderGetType*(): GType {.importc: "gdk_pixbuf_loader_get_type",
                                     libpixbuf.}
proc newLoader*(): Loader {.importc: "gdk_pixbuf_loader_new",
    libpixbuf.}
proc newLoader*(imageType: cstring; error: var glib.GError): Loader {.
    importc: "gdk_pixbuf_loader_new_with_type", libpixbuf.}
proc newLoader*(mimeType: cstring; error: var glib.GError): Loader {.
    importc: "gdk_pixbuf_loader_new_with_mime_type", libpixbuf.}
proc setSize*(loader: Loader; width: cint; height: cint) {.
    importc: "gdk_pixbuf_loader_set_size", libpixbuf.}
proc `size=`*(loader: Loader; width: cint; height: cint) {.
    importc: "gdk_pixbuf_loader_set_size", libpixbuf.}
proc write*(loader: Loader; buf: var cuchar; count: Gsize;
                          error: var glib.GError): Gboolean {.
    importc: "gdk_pixbuf_loader_write", libpixbuf.}
proc writeBytes*(loader: Loader; buffer: glib.GBytes;
                               error: var glib.GError): Gboolean {.
    importc: "gdk_pixbuf_loader_write_bytes", libpixbuf.}
proc getPixbuf*(loader: Loader): GdkPixbuf {.
    importc: "gdk_pixbuf_loader_get_pixbuf", libpixbuf.}
proc pixbuf*(loader: Loader): GdkPixbuf {.
    importc: "gdk_pixbuf_loader_get_pixbuf", libpixbuf.}
proc getAnimation*(loader: Loader): Animation {.
    importc: "gdk_pixbuf_loader_get_animation", libpixbuf.}
proc animation*(loader: Loader): Animation {.
    importc: "gdk_pixbuf_loader_get_animation", libpixbuf.}
proc close*(loader: Loader; error: var glib.GError): Gboolean {.
    importc: "gdk_pixbuf_loader_close", libpixbuf.}
proc getFormat*(loader: Loader): Format {.
    importc: "gdk_pixbuf_loader_get_format", libpixbuf.}
proc format*(loader: Loader): Format {.
    importc: "gdk_pixbuf_loader_get_format", libpixbuf.}

proc alphaModeGetType*(): GType {.importc: "gdk_pixbuf_alpha_mode_get_type",
                                        libpixbuf.}
template typePixbufAlphaMode*(): untyped =
  (alphaModeGetType())

proc gdkColorspaceGetType*(): GType {.importc: "gdk_colorspace_get_type", libpixbuf.}
template typeColorspace*(): untyped =
  (gdkColorspaceGetType())

proc errorGetType*(): GType {.importc: "gdk_pixbuf_error_get_type",
                                    libpixbuf.}
template typePixbufError*(): untyped =
  (errorGetType())

proc gdkInterpTypeGetType*(): GType {.importc: "gdk_interp_type_get_type",
                                   libpixbuf.}
template typeInterpType*(): untyped =
  (gdkInterpTypeGetType())

proc rotationGetType*(): GType {.importc: "gdk_pixbuf_rotation_get_type",
                                       libpixbuf.}
template typePixbufRotation*(): untyped =
  (rotationGetType())

