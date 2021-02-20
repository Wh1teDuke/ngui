{.deadCodeElim: on.}

from glib import Gpointer, Gboolean, GQuark, Gsize, GDestroyNotify
from gobject import GObject, GType, GObjectObj, GObjectClassObj
from gio import GInputStream, GCancellable
from gdk_pixbuf import GdkPixbuf
from cairo import Context

when defined(windows):
  const LIB_RSVG = "librsvg-2.dll"
elif defined(macosx):
  const LIB_RSVG = "librsvg-2.dylib"
else:
  const LIB_RSVG = "librsvg-2.so(|.0)"

{.pragma: librsvg, cdecl, dynlib: LIB_RSVG.}

const USE_DEPRECATED = false

template typeHandle*(): untyped =
  (handleGetType())

template handle*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeHandle, HandleObj))

template handleClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeHandle, HandleClassObj))

template isHandle*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeHandle))

template isHandleClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeHandle))

template handleGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeHandle, HandleClassObj))

proc handleGetType*(): GType {.importc: "rsvg_handle_get_type", librsvg.}

type
  Error* {.size: sizeof(cint), pure.} = enum
    FAILED

template error*(): untyped =
  errorQuark()

proc errorQuark*(): GQuark {.importc: "rsvg_error_quark", librsvg.}

type
  HandleClass* =  ptr HandleClassObj
  HandleClassPtr* = ptr HandleClassObj
  HandleClassObj*{.final.} = object of GObjectClassObj
    abiPadding: array[15, Gpointer]

  Handle* =  ptr HandleObj
  HandlePtr* = ptr HandleObj
  HandleObj*{.final.} = object of GObjectObj
    priv: pointer
    abiPadding: array[15, Gpointer]

type
  DimensionData* =  ptr DimensionDataObj
  DimensionDataPtr* = ptr DimensionDataObj
  DimensionDataObj* = object
    width*: cint
    height*: cint
    em*: cdouble
    ex*: cdouble

type
  PositionData* =  ptr PositionDataObj
  PositionDataPtr* = ptr PositionDataObj
  PositionDataObj* = object
    x*: cint
    y*: cint

proc cleanup*() {.importc: "rsvg_cleanup", librsvg.}
proc setDefaultDpi*(dpi: cdouble) {.importc: "rsvg_set_default_dpi", librsvg.}
proc `defaultDpi=`*(dpi: cdouble) {.importc: "rsvg_set_default_dpi", librsvg.}
proc setDefaultDpiXY*(dpiX: cdouble; dpiY: cdouble) {.
    importc: "rsvg_set_default_dpi_x_y", librsvg.}
proc `defaultDpiXY=`*(dpiX: cdouble; dpiY: cdouble) {.
    importc: "rsvg_set_default_dpi_x_y", librsvg.}
proc setDpi*(handle: Handle; dpi: cdouble) {.
    importc: "rsvg_handle_set_dpi", librsvg.}
proc `dpi=`*(handle: Handle; dpi: cdouble) {.
    importc: "rsvg_handle_set_dpi", librsvg.}
proc setDpiXY*(handle: Handle; dpiX: cdouble; dpiY: cdouble) {.
    importc: "rsvg_handle_set_dpi_x_y", librsvg.}
proc `dpiXY=`*(handle: Handle; dpiX: cdouble; dpiY: cdouble) {.
    importc: "rsvg_handle_set_dpi_x_y", librsvg.}
proc newHandle*(): Handle {.importc: "rsvg_handle_new", librsvg.}
proc write*(handle: Handle; buf: var cuchar; count: Gsize;
                     error: var glib.GError): Gboolean {.importc: "rsvg_handle_write",
    librsvg.}
proc close*(handle: Handle; error: var glib.GError): Gboolean {.
    importc: "rsvg_handle_close", librsvg.}
proc getPixbuf*(handle: Handle): GdkPixbuf {.
    importc: "rsvg_handle_get_pixbuf", librsvg.}
proc pixbuf*(handle: Handle): GdkPixbuf {.
    importc: "rsvg_handle_get_pixbuf", librsvg.}
proc getPixbufSub*(handle: Handle; id: cstring): GdkPixbuf {.
    importc: "rsvg_handle_get_pixbuf_sub", librsvg.}
proc pixbufSub*(handle: Handle; id: cstring): GdkPixbuf {.
    importc: "rsvg_handle_get_pixbuf_sub", librsvg.}
proc getBaseUri*(handle: Handle): cstring {.
    importc: "rsvg_handle_get_base_uri", librsvg.}
proc baseUri*(handle: Handle): cstring {.
    importc: "rsvg_handle_get_base_uri", librsvg.}
proc setBaseUri*(handle: Handle; baseUri: cstring) {.
    importc: "rsvg_handle_set_base_uri", librsvg.}
proc `baseUri=`*(handle: Handle; baseUri: cstring) {.
    importc: "rsvg_handle_set_base_uri", librsvg.}
proc getDimensions*(handle: Handle;
                             dimensionData: DimensionData) {.
    importc: "rsvg_handle_get_dimensions", librsvg.}
proc getDimensionsSub*(handle: Handle;
                                dimensionData: DimensionData; id: cstring): Gboolean {.
    importc: "rsvg_handle_get_dimensions_sub", librsvg.}
proc dimensionsSub*(handle: Handle;
                                dimensionData: DimensionData; id: cstring): Gboolean {.
    importc: "rsvg_handle_get_dimensions_sub", librsvg.}
proc getPositionSub*(handle: Handle;
                              positionData: PositionData; id: cstring): Gboolean {.
    importc: "rsvg_handle_get_position_sub", librsvg.}
proc positionSub*(handle: Handle;
                              positionData: PositionData; id: cstring): Gboolean {.
    importc: "rsvg_handle_get_position_sub", librsvg.}
proc hasSub*(handle: Handle; id: cstring): Gboolean {.
    importc: "rsvg_handle_has_sub", librsvg.}

type
  HandleFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, UNLIMITED = 1 shl 0,
    KEEP_IMAGE_DATA = 1 shl 1

proc newHandle*(flags: HandleFlags): Handle {.
    importc: "rsvg_handle_new_with_flags", librsvg.}
proc setBaseGfile*(handle: Handle; baseFile: gio.GFile) {.
    importc: "rsvg_handle_set_base_gfile", librsvg.}
proc `baseGfile=`*(handle: Handle; baseFile: gio.GFile) {.
    importc: "rsvg_handle_set_base_gfile", librsvg.}
proc readStreamSync*(handle: Handle; stream: gio.GInputStream;
                              cancellable: gio.GCancellable; error: var glib.GError): Gboolean {.
    importc: "rsvg_handle_read_stream_sync", librsvg.}
proc newHandle*(file: gio.GFile; flags: HandleFlags;
                                cancellable: gio.GCancellable;
                                error: var glib.GError): Handle {.
    importc: "rsvg_handle_new_from_gfile_sync", librsvg.}
proc newHandle*(inputStream: gio.GInputStream;
                                 baseFile: gio.GFile; flags: HandleFlags;
                                 cancellable: gio.GCancellable;
                                 error: var glib.GError): Handle {.
    importc: "rsvg_handle_new_from_stream_sync", librsvg.}
proc newHandle*(data: ptr uint8; dataLen: Gsize; error: var glib.GError): Handle {.
    importc: "rsvg_handle_new_from_data", librsvg.}
proc newHandle*(fileName: cstring; error: var glib.GError): Handle {.
    importc: "rsvg_handle_new_from_file", librsvg.}
proc internalSetTesting*(handle: Handle; testing: Gboolean) {.
    importc: "rsvg_handle_internal_set_testing", librsvg.}

when not USE_DEPRECATED: # Deprecated APIs. Do not use!
  proc init*() {.importc: "rsvg_init", librsvg.}
  proc term*() {.importc: "rsvg_term", librsvg.}
  proc free*(handle: Handle) {.importc: "rsvg_handle_free",
      librsvg.}
  type
    SizeFunc* = proc (width: var cint; height: var cint; userData: Gpointer) {.cdecl.}
  proc setSizeCallback*(handle: Handle; sizeFunc: SizeFunc;
                                 userData: Gpointer;
                                 userDataDestroy: GDestroyNotify) {.
      importc: "rsvg_handle_set_size_callback", librsvg.}
  proc `sizeCallback=`*(handle: Handle; sizeFunc: SizeFunc;
                                 userData: Gpointer;
                                 userDataDestroy: GDestroyNotify) {.
      importc: "rsvg_handle_set_size_callback", librsvg.}
  proc pixbufFromFile*(fileName: cstring; error: var glib.GError): GdkPixbuf {.
      importc: "rsvg_pixbuf_from_file", librsvg.}
  proc pixbufFromFileAtZoom*(fileName: cstring; xZoom: cdouble; yZoom: cdouble;
                                error: var glib.GError): GdkPixbuf {.
      importc: "rsvg_pixbuf_from_file_at_zoom", librsvg.}
  proc pixbufFromFileAtSize*(fileName: cstring; width: cint; height: cint;
                                error: var glib.GError): GdkPixbuf {.
      importc: "rsvg_pixbuf_from_file_at_size", librsvg.}
  proc pixbufFromFileAtMaxSize*(fileName: cstring; maxWidth: cint;
                                   maxHeight: cint; error: var glib.GError): GdkPixbuf {.
      importc: "rsvg_pixbuf_from_file_at_max_size", librsvg.}
  proc pixbufFromFileAtZoomWithMax*(fileName: cstring; xZoom: cdouble;
                                       yZoom: cdouble; maxWidth: cint;
                                       maxHeight: cint; error: var glib.GError): GdkPixbuf {.
      importc: "rsvg_pixbuf_from_file_at_zoom_with_max", librsvg.}
  proc getTitle*(handle: Handle): cstring {.
      importc: "rsvg_handle_get_title", librsvg.}
  proc title*(handle: Handle): cstring {.
      importc: "rsvg_handle_get_title", librsvg.}
  proc getDesc*(handle: Handle): cstring {.
      importc: "rsvg_handle_get_desc", librsvg.}
  proc desc*(handle: Handle): cstring {.
      importc: "rsvg_handle_get_desc", librsvg.}
  proc getMetadata*(handle: Handle): cstring {.
      importc: "rsvg_handle_get_metadata", librsvg.}
  proc metadata*(handle: Handle): cstring {.
      importc: "rsvg_handle_get_metadata", librsvg.}

proc errorGetType*(): GType {.importc: "rsvg_error_get_type", librsvg.}
template typeError*(): untyped =
  (errorGetType())

proc handleFlagsGetType*(): GType {.importc: "rsvg_handle_flags_get_type",
                                     librsvg.}
template typeHandleFlags*(): untyped =
  (handleFlagsGetType())

proc renderCairo*(handle: Handle; cr: cairo.Context): Gboolean {.
    importc: "rsvg_handle_render_cairo", librsvg.}
proc renderCairoSub*(handle: Handle; cr: cairo.Context; id: cstring): Gboolean {.
    importc: "rsvg_handle_render_cairo_sub", librsvg.}

