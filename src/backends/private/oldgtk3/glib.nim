{.deadCodeElim: on.}

# Note: Not all glib C macros are available in Nim yet.
# Some are converted by c2nim to templates, some manually to procs.
# Most of these should be not necessary for Nim programmers.
# We may have to add more and to test and fix some, or remove unnecessary ones completely...

from times import Time

export Time

when defined(windows):
  const LIB_GLIB* = "libglib-2.0-0.dll"
elif defined(macosx):
  const LIB_GLIB* = "libglib-2.0.dylib"
else:
  const LIB_GLIB* = "libglib-2.0.so(|.0)"

{.pragma: libglib, cdecl, dynlib: LIB_GLIB.}

const
  GLIB_H_INSIDE = true
  GLIB_COMPILATION = false
  VALIST = false
  CPLUSPLUS = false
  MINGW_H = false
  STDLIB_H = true
  G_DISABLE_DEPRECATED = false
  MSC_VER = false
  G_ATOMIC_OP_MEMORY_BARRIER_NEEDED = false
  GTK_DOC_IGNORE = false
  G_DISABLE_CHECKS = true
  G_CAN_INLINE = false
  INC_STDLIB = false
  G_ENABLE_DEBUG = false

type
  Gboolean* = distinct cint
  Gint* = cint # glib aliases which are not really needed
  Guint* = cuint
  Gshort* = cshort
  Gushort* = cushort
  Glong* = clong
  Gulong* = culong
  Gchar* = cchar
  Guchar* = cuchar
  Gfloat* = cfloat
  Gdouble* = cdouble

# we should not need these constants often, because we have converters to and from Nim bool
const
  GFALSE* = Gboolean(0)
  GTRUE* = Gboolean(1)

converter gbool*(nimbool: bool): Gboolean =
  ord(nimbool).Gboolean

converter toBool*(gbool: Gboolean): bool =
  int(gbool) != 0

const
  G_MAXUINT* = high(cuint)
  G_MAXUSHORT* = high(cushort)
  GLIB_SIZEOF_VOID_P = sizeof(pointer)
  GLIB_SIZEOF_SIZE_T* = GLIB_SIZEOF_VOID_P
  GLIB_SIZEOF_LONG* = sizeof(clong)
type
  Gssize* = int # csize # fix for Nim > 1.04 to avoid many depretaction warnings
  Gsize* = uint # csize # note: csize is signed in Nim!
  Goffset* = int64
  GPid = cint

{.warning[SmallLshouldNotBeUsed]: off.}

const
  G_MININT8* = 0x80'i8
  G_MAXINT8* = 0x7F'i8
  G_MAXUINT8* = 0xFF'u8
  G_MININT16* = 0x8000'i16
  G_MAXINT16* = 0x7FFF'i16
  G_MAXUINT16* = 0xFFFF'u16
  G_MININT32* = 0x80000000'i32
  G_MAXINT32* = 0x7FFFFFFF'i32
  G_MAXUINT32* = 0xFFFFFFFF'u32
  G_MININT64* = 0x8000000000000000'i64
  G_MAXINT64* = 0x7FFFFFFFFFFFFFFF'i64
  G_MAXUINT64* = 0xFFFFFFFFFFFFFFFF'u64

type
  Gpointer* = pointer
  Gconstpointer* = pointer
  GCompareFunc* = proc (a: Gconstpointer; b: Gconstpointer): cint {.cdecl.}
  GCompareDataFunc* = proc (a: Gconstpointer; b: Gconstpointer; userData: Gpointer): cint {.cdecl.}
  GEqualFunc* = proc (a: Gconstpointer; b: Gconstpointer): Gboolean {.cdecl.}
  GDestroyNotify* = proc (data: Gpointer) {.cdecl.}
  GFunc* = proc (data: Gpointer; userData: Gpointer) {.cdecl.}
  GHashFunc* = proc (key: Gconstpointer): cuint {.cdecl.}
  GHFunc* = proc (key: Gpointer; value: Gpointer; userData: Gpointer) {.cdecl.}

type
  GFreeFunc* = proc (data: Gpointer) {.cdecl.}

type
  GTranslateFunc* = proc (str: cstring; data: Gpointer): cstring {.cdecl.}

const
  G_E* = 2.718281828459045
  G_LN2* = 0.6931471805599453
  G_LN10* = 2.302585092994046
  G_PI* = 3.141592653589793
  G_PI_2* = 1.570796326794897
  G_PI_4* = 0.7853981633974483
  G_SQRT2* = 1.414213562373095

const
  G_LITTLE_ENDIAN* = 1234
  G_BIG_ENDIAN* = 4321
  G_PDP_ENDIAN* = 3412

template guint16SwapLeBeConstant*(val: untyped): untyped =
  (guint16(guint16(guint16(val) shr 8) or (guint16)(guint16(val) shl 8)))

template guint32SwapLeBeConstant*(val: untyped): untyped =
  (guint32(((guint32(val) and cast[uint32](0xFF)) shl 24) or
      ((guint32(val) and cast[uint32](0xFF00)) shl 8) or
      ((guint32(val) and cast[uint32](0xFF0000)) shr 8) or
      ((guint32(val) and cast[uint32](0xFF000000)) shr 24)))

template guint64SwapLeBeConstant*(val: untyped): untyped =
  (guint64(((guint64(val) and
      cast[uint64](int64(0xFF'i64))) shl 56) or
      ((guint64(val) and
      cast[uint64](int64(0xFF00'i64))) shl 40) or
      ((guint64(val) and
      cast[uint64](int64(0xFF0000'i64))) shl 24) or
      ((guint64(val) and
      cast[uint64](int64(0xFF000000'i64))) shl 8) or
      ((guint64(val) and
      cast[uint64](int64(0xFF00000000'i64))) shr 8) or
      ((guint64(val) and
      cast[uint64](int64(0xFF0000000000'i64))) shr 24) or
      ((guint64(val) and
      cast[uint64](int64(0xFF000000000000'i64))) shr 40) or
      ((guint64(val) and
      cast[uint64](int64(0xFF00000000000000'i64))) shr 56)))

template guint16SwapLePdp*(val: untyped): untyped =
  (guint16(val))

template guint16SwapBePdp*(val: untyped): untyped =
  (guint16Swap_Le_Be(val))

template guint32SwapLePdp*(val: untyped): untyped =
  (guint32(((guint32(val) and cast[uint32](0xFFFF)) shl 16) or
      ((guint32(val) and cast[uint32](0xFFFF0000)) shr 16)))

template guint32SwapBePdp*(val: untyped): untyped =
  (guint32(((guint32(val) and cast[uint32](0xFF00FF)) shl 8) or
      ((guint32(val) and cast[uint32](0xFF00FF00)) shr 8)))

template gint16FromLe*(val: untyped): untyped =
  (gint16To_Le(val))

template guint16FromLe*(val: untyped): untyped =
  (guint16To_Le(val))

template gint16FromBe*(val: untyped): untyped =
  (gint16To_Be(val))

template guint16FromBe*(val: untyped): untyped =
  (guint16To_Be(val))

template gint32FromLe*(val: untyped): untyped =
  (gint32To_Le(val))

template guint32FromLe*(val: untyped): untyped =
  (guint32To_Le(val))

template gint32FromBe*(val: untyped): untyped =
  (gint32To_Be(val))

template guint32FromBe*(val: untyped): untyped =
  (guint32To_Be(val))

template gint64FromLe*(val: untyped): untyped =
  (gint64To_Le(val))

template guint64FromLe*(val: untyped): untyped =
  (guint64To_Le(val))

template gint64FromBe*(val: untyped): untyped =
  (gint64To_Be(val))

template guint64FromBe*(val: untyped): untyped =
  (guint64To_Be(val))

template glongFromLe*(val: untyped): untyped =
  (glong_To_Le(val))

template gulongFromLe*(val: untyped): untyped =
  (gulong_To_Le(val))

template glongFromBe*(val: untyped): untyped =
  (glong_To_Be(val))

template gulongFromBe*(val: untyped): untyped =
  (gulong_To_Be(val))

template gintFromLe*(val: untyped): untyped =
  (gint_To_Le(val))

template guintFromLe*(val: untyped): untyped =
  (guint_To_Le(val))

template gintFromBe*(val: untyped): untyped =
  (gint_To_Be(val))

template guintFromBe*(val: untyped): untyped =
  (guint_To_Be(val))

template gsizeFromLe*(val: untyped): untyped =
  (gsize_To_Le(val))

template gssizeFromLe*(val: untyped): untyped =
  (gssize_To_Le(val))

template gsizeFromBe*(val: untyped): untyped =
  (gsize_To_Be(val))

template gssizeFromBe*(val: untyped): untyped =
  (gssize_To_Be(val))

template gNtohl*(val: untyped): untyped =
  (guint32FromBe(val))

template gNtohs*(val: untyped): untyped =
  (guint16FromBe(val))

template gHtonl*(val: untyped): untyped =
  (guint32To_Be(val))

template gHtons*(val: untyped): untyped =
  (guint16To_Be(val))

template gUintCheckedAdd*(dest, a, b: untyped): untyped =
  glib_Checked_Add_U32(dest, a, b)

template gUintCheckedMul*(dest, a, b: untyped): untyped =
  glib_Checked_Mul_U32(dest, a, b)

template gUint64CheckedAdd*(dest, a, b: untyped): untyped =
  glib_Checked_Add_U64(dest, a, b)

template gUint64CheckedMul*(dest, a, b: untyped): untyped =
  glib_Checked_Mul_U64(dest, a, b)

when GLIB_SIZEOF_SIZE_T == 8:
  template gSizeCheckedAdd*(dest, a, b: untyped): untyped =
    glib_Checked_Add_U64(dest, a, b)

  template gSizeCheckedMul*(dest, a, b: untyped): untyped =
    glib_Checked_Mul_U64(dest, a, b)

else:
  template gSizeCheckedAdd*(dest, a, b: untyped): untyped =
    glib_Checked_Add_U32(dest, a, b)

  template gSizeCheckedMul*(dest, a, b: untyped): untyped =
    glib_Checked_Mul_U32(dest, a, b)

type
  GTimeVal* =  ptr GTimeValObj
  GTimeValPtr* = ptr GTimeValObj
  GTimeValObj* = object
    tvSec*: clong
    tvUsec*: clong

type
  GBytes* =  ptr GBytesObj
  GBytesPtr* = ptr GBytesObj
  GBytesObj* = object

  GArray* =  ptr GArrayObj
  GArrayPtr* = ptr GArrayObj
  GArrayObj* = object
    data*: cstring
    len*: cuint

  GByteArray* =  ptr GByteArrayObj
  GByteArrayPtr* = ptr GByteArrayObj
  GByteArrayObj* = object
    data*: ptr uint8
    len*: cuint

  GPtrArray* =  ptr GPtrArrayObj
  GPtrArrayPtr* = ptr GPtrArrayObj
  GPtrArrayObj* = object
    pdata*: ptr Gpointer
    len*: cuint

template gArrayAppendVal*(a, v: untyped): untyped =
  appendVals(a, addr(v), 1)

template gArrayPrependVal*(a, v: untyped): untyped =
  prependVals(a, addr(v), 1)

template gArrayInsertVal*(a, i, v: untyped): untyped =
  insertVals(a, i, addr(v), 1)

template gArrayIndex*(a, t, i: untyped): untyped =
  ((cast[ptr T](cast[pointer](a.data)))[(i)])

proc newArray*(zeroTerminated: Gboolean; clear: Gboolean; elementSize: cuint): GArray {.
    importc: "g_array_new", libglib.}
proc newArraySized*(zeroTerminated: Gboolean; clear: Gboolean; elementSize: cuint;
                    reservedSize: cuint): GArray {.importc: "g_array_sized_new",
    libglib.}
proc free*(array: GArray; freeSegment: Gboolean): cstring {.
    importc: "g_array_free", libglib.}
proc `ref`*(array: GArray): GArray {.importc: "g_array_ref", libglib.}
proc unref*(array: GArray) {.importc: "g_array_unref", libglib.}
proc getElementSize*(array: GArray): cuint {.
    importc: "g_array_get_element_size", libglib.}
proc elementSize*(array: GArray): cuint {.
    importc: "g_array_get_element_size", libglib.}
proc appendVals*(array: GArray; data: Gconstpointer; len: cuint): GArray {.
    importc: "g_array_append_vals", libglib.}
proc prependVals*(array: GArray; data: Gconstpointer; len: cuint): GArray {.
    importc: "g_array_prepend_vals", libglib.}
proc insertVals*(array: GArray; index: cuint; data: Gconstpointer; len: cuint): GArray {.
    importc: "g_array_insert_vals", libglib.}
proc setSize*(array: GArray; length: cuint): GArray {.
    importc: "g_array_set_size", libglib.}
proc removeIndex*(array: GArray; index: cuint): GArray {.
    importc: "g_array_remove_index", libglib.}
proc removeIndexFast*(array: GArray; index: cuint): GArray {.
    importc: "g_array_remove_index_fast", libglib.}
proc removeRange*(array: GArray; index: cuint; length: cuint): GArray {.
    importc: "g_array_remove_range", libglib.}
proc sort*(array: GArray; compareFunc: GCompareFunc) {.
    importc: "g_array_sort", libglib.}
proc sortWithData*(array: GArray; compareFunc: GCompareDataFunc;
                        userData: Gpointer) {.importc: "g_array_sort_with_data",
    libglib.}
proc setClearFunc*(array: GArray; clearFunc: GDestroyNotify) {.
    importc: "g_array_set_clear_func", libglib.}
proc `clearFunc=`*(array: GArray; clearFunc: GDestroyNotify) {.
    importc: "g_array_set_clear_func", libglib.}

template gPtrArrayIndex*(array, index: untyped): untyped =
  (array.pdata)[index]

proc newPtrArray*(): GPtrArray {.importc: "g_ptr_array_new", libglib.}
proc newPtrArray*(elementFreeFunc: GDestroyNotify): GPtrArray {.
    importc: "g_ptr_array_new_with_free_func", libglib.}
proc newPtrArraySized*(reservedSize: cuint): GPtrArray {.
    importc: "g_ptr_array_sized_new", libglib.}
proc newPtrArray*(reservedSize: cuint; elementFreeFunc: GDestroyNotify): GPtrArray {.
    importc: "g_ptr_array_new_full", libglib.}
proc free*(array: GPtrArray; freeSeg: Gboolean): ptr Gpointer {.
    importc: "g_ptr_array_free", libglib.}
proc `ref`*(array: GPtrArray): GPtrArray {.importc: "g_ptr_array_ref",
    libglib.}
proc unref*(array: GPtrArray) {.importc: "g_ptr_array_unref", libglib.}
proc setFreeFunc*(array: GPtrArray; elementFreeFunc: GDestroyNotify) {.
    importc: "g_ptr_array_set_free_func", libglib.}
proc `freeFunc=`*(array: GPtrArray; elementFreeFunc: GDestroyNotify) {.
    importc: "g_ptr_array_set_free_func", libglib.}
proc setSize*(array: GPtrArray; length: cint) {.
    importc: "g_ptr_array_set_size", libglib.}
proc `size=`*(array: GPtrArray; length: cint) {.
    importc: "g_ptr_array_set_size", libglib.}
proc removeIndex*(array: GPtrArray; index: cuint): Gpointer {.
    importc: "g_ptr_array_remove_index", libglib.}
proc removeIndexFast*(array: GPtrArray; index: cuint): Gpointer {.
    importc: "g_ptr_array_remove_index_fast", libglib.}
proc remove*(array: GPtrArray; data: Gpointer): Gboolean {.
    importc: "g_ptr_array_remove", libglib.}
proc removeFast*(array: GPtrArray; data: Gpointer): Gboolean {.
    importc: "g_ptr_array_remove_fast", libglib.}
proc removeRange*(array: GPtrArray; index: cuint; length: cuint): GPtrArray {.
    importc: "g_ptr_array_remove_range", libglib.}
proc add*(array: GPtrArray; data: Gpointer) {.importc: "g_ptr_array_add",
    libglib.}
proc insert*(array: GPtrArray; index: cint; data: Gpointer) {.
    importc: "g_ptr_array_insert", libglib.}
proc sort*(array: GPtrArray; compareFunc: GCompareFunc) {.
    importc: "g_ptr_array_sort", libglib.}
proc sortWithData*(array: GPtrArray; compareFunc: GCompareDataFunc;
                           userData: Gpointer) {.
    importc: "g_ptr_array_sort_with_data", libglib.}
proc foreach*(array: GPtrArray; `func`: GFunc; userData: Gpointer) {.
    importc: "g_ptr_array_foreach", libglib.}
proc find*(haystack: GPtrArray; needle: Gconstpointer; index: var cuint): Gboolean {.
    importc: "g_ptr_array_find", libglib.}
proc findWithEqualFunc*(haystack: GPtrArray; needle: Gconstpointer;
                                equalFunc: GEqualFunc; index: var cuint): Gboolean {.
    importc: "g_ptr_array_find_with_equal_func", libglib.}

proc newByteArray*(): GByteArray {.importc: "g_byte_array_new", libglib.}
proc newByteArray*(data: var uint8; len: Gsize): GByteArray {.
    importc: "g_byte_array_new_take", libglib.}
proc newByteArraySized*(reservedSize: cuint): GByteArray {.
    importc: "g_byte_array_sized_new", libglib.}
proc free*(array: GByteArray; freeSegment: Gboolean): ptr uint8 {.
    importc: "g_byte_array_free", libglib.}
proc freeToBytes*(array: GByteArray): GBytes {.
    importc: "g_byte_array_free_to_bytes", libglib.}
proc `ref`*(array: GByteArray): GByteArray {.
    importc: "g_byte_array_ref", libglib.}
proc unref*(array: GByteArray) {.importc: "g_byte_array_unref",
    libglib.}
proc append*(array: GByteArray; data: var uint8; len: cuint): GByteArray {.
    importc: "g_byte_array_append", libglib.}
proc prepend*(array: GByteArray; data: var uint8; len: cuint): GByteArray {.
    importc: "g_byte_array_prepend", libglib.}
proc setSize*(array: GByteArray; length: cuint): GByteArray {.
    importc: "g_byte_array_set_size", libglib.}
proc removeIndex*(array: GByteArray; index: cuint): GByteArray {.
    importc: "g_byte_array_remove_index", libglib.}
proc removeIndexFast*(array: GByteArray; index: cuint): GByteArray {.
    importc: "g_byte_array_remove_index_fast", libglib.}
proc removeRange*(array: GByteArray; index: cuint; length: cuint): GByteArray {.
    importc: "g_byte_array_remove_range", libglib.}
proc sort*(array: GByteArray; compareFunc: GCompareFunc) {.
    importc: "g_byte_array_sort", libglib.}
proc sortWithData*(array: GByteArray; compareFunc: GCompareDataFunc;
                            userData: Gpointer) {.
    importc: "g_byte_array_sort_with_data", libglib.}

type
  GQuark* = uint32

proc quarkTryString*(string: cstring): GQuark {.importc: "g_quark_try_string",
    libglib.}
proc quarkFromStaticString*(string: cstring): GQuark {.
    importc: "g_quark_from_static_string", libglib.}
proc quarkFromString*(string: cstring): GQuark {.importc: "g_quark_from_string",
    libglib.}
proc toString*(quark: GQuark): cstring {.importc: "g_quark_to_string",
    libglib.}
proc internString*(string: cstring): cstring {.importc: "g_intern_string",
    libglib.}
proc internStaticString*(string: cstring): cstring {.
    importc: "g_intern_static_string", libglib.}

type
  GError* =  ptr GErrorObj
  GErrorPtr* = ptr GErrorObj
  GErrorObj* = object
    domain*: GQuark
    code*: cint
    message*: cstring

proc newError*(domain: GQuark; code: cint; format: cstring): GError {.varargs,
    importc: "g_error_new", libglib.}
proc newError*(domain: GQuark; code: cint; message: cstring): GError {.
    importc: "g_error_new_literal", libglib.}
when (VALIST):
  proc newError*(domain: GQuark; code: cint; format: cstring; args: VaList): GError {.
      importc: "g_error_new_valist", libglib.}
proc free*(error: GError) {.importc: "g_error_free", libglib.}
proc copy*(error: GError): GError {.importc: "g_error_copy", libglib.}
proc matches*(error: GError; domain: GQuark; code: cint): Gboolean {.
    importc: "g_error_matches", libglib.}

proc setError*(err: var GError; domain: GQuark; code: cint; format: cstring) {.
    varargs, importc: "g_set_error", libglib.}

proc `error=`*(err: var GError; domain: GQuark; code: cint; format: cstring) {.
    varargs, importc: "g_set_error", libglib.}
proc setErrorLiteral*(err: var GError; domain: GQuark; code: cint; message: cstring) {.
    importc: "g_set_error_literal", libglib.}
proc `errorLiteral=`*(err: var GError; domain: GQuark; code: cint; message: cstring) {.
    importc: "g_set_error_literal", libglib.}

proc propagateError*(dest: var GError; src: GError) {.
    importc: "g_propagate_error", libglib.}

proc clearError*(err: var GError) {.importc: "g_clear_error", libglib.}

proc prefixError*(err: var GError; format: cstring) {.varargs,
    importc: "g_prefix_error", libglib.}

proc propagatePrefixedError*(dest: var GError; src: GError; format: cstring) {.
    varargs, importc: "g_propagate_prefixed_error", libglib.}

proc getUserName*(): cstring {.importc: "g_get_user_name", libglib.}

proc userName*(): cstring {.importc: "g_get_user_name", libglib.}
proc getRealName*(): cstring {.importc: "g_get_real_name", libglib.}
proc realName*(): cstring {.importc: "g_get_real_name", libglib.}
proc getHomeDir*(): cstring {.importc: "g_get_home_dir", libglib.}
proc homeDir*(): cstring {.importc: "g_get_home_dir", libglib.}
proc getTmpDir*(): cstring {.importc: "g_get_tmp_dir", libglib.}
proc tmpDir*(): cstring {.importc: "g_get_tmp_dir", libglib.}
proc getHostName*(): cstring {.importc: "g_get_host_name", libglib.}
proc hostName*(): cstring {.importc: "g_get_host_name", libglib.}
proc getPrgname*(): cstring {.importc: "g_get_prgname", libglib.}
proc prgname*(): cstring {.importc: "g_get_prgname", libglib.}
proc setPrgname*(prgname: cstring) {.importc: "g_set_prgname", libglib.}
proc `prgname=`*(prgname: cstring) {.importc: "g_set_prgname", libglib.}
proc getApplicationName*(): cstring {.importc: "g_get_application_name", libglib.}
proc applicationName*(): cstring {.importc: "g_get_application_name", libglib.}
proc setApplicationName*(applicationName: cstring) {.
    importc: "g_set_application_name", libglib.}
proc `applicationName=`*(applicationName: cstring) {.
    importc: "g_set_application_name", libglib.}
proc reloadUserSpecialDirsCache*() {.importc: "g_reload_user_special_dirs_cache",
                                    libglib.}
proc getUserDataDir*(): cstring {.importc: "g_get_user_data_dir", libglib.}
proc userDataDir*(): cstring {.importc: "g_get_user_data_dir", libglib.}
proc getUserConfigDir*(): cstring {.importc: "g_get_user_config_dir", libglib.}
proc userConfigDir*(): cstring {.importc: "g_get_user_config_dir", libglib.}
proc getUserCacheDir*(): cstring {.importc: "g_get_user_cache_dir", libglib.}
proc userCacheDir*(): cstring {.importc: "g_get_user_cache_dir", libglib.}
proc getSystemDataDirs*(): cstringArray {.importc: "g_get_system_data_dirs",
                                        libglib.}
proc systemDataDirs*(): cstringArray {.importc: "g_get_system_data_dirs",
                                        libglib.}
when defined(windows):
  proc win32GetSystemDataDirsForModule*(addressOfFunction: proc () {.cdecl.}): cstringArray {.
      importc: "g_win32_get_system_data_dirs_for_module", libglib.}
when defined(windows) and (G_CAN_INLINE) and not (CPLUSPLUS):
  proc win32GetSystemDataDirs*(): cstringArray {.inline.} =
    return win32GetSystemDataDirsForModule(
        cast[proc ()](addr(gWin32GetSystemDataDirs)))

  const
    gGetSystemDataDirs* = gWin32GetSystemDataDirs
proc getSystemConfigDirs*(): cstringArray {.importc: "g_get_system_config_dirs",
    libglib.}
proc systemConfigDirs*(): cstringArray {.importc: "g_get_system_config_dirs",
    libglib.}
proc getUserRuntimeDir*(): cstring {.importc: "g_get_user_runtime_dir", libglib.}
proc userRuntimeDir*(): cstring {.importc: "g_get_user_runtime_dir", libglib.}

type
  GUserDirectory* {.size: sizeof(cint), pure.} = enum
    DESKTOP, DOCUMENTS,
    DOWNLOAD, MUSIC, PICTURES,
    PUBLIC_SHARE, TEMPLATES,
    VIDEOS, G_USER_N_DIRECTORIES

proc getUserSpecialDir*(directory: GUserDirectory): cstring {.
    importc: "g_get_user_special_dir", libglib.}

proc userSpecialDir*(directory: GUserDirectory): cstring {.
    importc: "g_get_user_special_dir", libglib.}

type
  GDebugKey* =  ptr GDebugKeyObj
  GDebugKeyPtr* = ptr GDebugKeyObj
  GDebugKeyObj* = object
    key*: cstring
    value*: cuint

proc parseDebugString*(string: cstring; keys: GDebugKey; nkeys: cuint): cuint {.
    importc: "g_parse_debug_string", libglib.}
proc snprintf*(string: cstring; n: culong; format: cstring): cint {.varargs,
    importc: "g_snprintf", libglib.}
when (VALIST):
  proc vsnprintf*(string: cstring; n: culong; format: cstring; args: VaList): cint {.
      importc: "g_vsnprintf", libglib.}
proc nullifyPointer*(nullifyLocation: var Gpointer) {.importc: "g_nullify_pointer",
    libglib.}
type
  GFormatSizeFlags* {.size: sizeof(cint), pure.} = enum
    DEFAULT = 0, LONG_FORMAT = 1 shl 0,
    IEC_UNITS = 1 shl 1

proc formatSizeFull*(size: uint64; flags: GFormatSizeFlags): cstring {.
    importc: "g_format_size_full", libglib.}
proc formatSize*(size: uint64): cstring {.importc: "g_format_size", libglib.}
proc formatSizeForDisplay*(size: Goffset): cstring {.
    importc: "g_format_size_for_display", libglib.}
when not (G_DISABLE_DEPRECATED):
  type
    GVoidFunc* = proc () {.cdecl.}
  template atexit*(`proc`: untyped): untyped =
    gATEXIT(`proc`)

  proc atexit*(`func`: GVoidFunc) {.importc: "g_atexit", libglib.}
  when defined(windows):
    when (MINGW_H and not (STDLIB_H)) or
        (MSC_VER and not (INC_STDLIB)):
      proc atexit*(a2: proc () {.cdecl.}): cint {.importc: "atexit", libglib.}
    template gAtexit*(`func`: untyped): untyped =
      atexit(`func`)

proc findProgramInPath*(program: cstring): cstring {.
    importc: "g_find_program_in_path", libglib.}

proc threadErrorQuark*(): GQuark {.importc: "g_thread_error_quark", libglib.}
type
  GThreadError* {.size: sizeof(cint), pure.} = enum
    AGAIN
  GThreadFunc* = proc (data: Gpointer): Gpointer {.cdecl.}
  GThread* =  ptr GThreadObj
  GThreadPtr* = ptr GThreadObj
  GThreadObj* = object

type
  GMutex* =  ptr GMutexObj
  GMutexPtr* = ptr GMutexObj
  GMutexObj* {.union.} = object
    p*: Gpointer
    i*: array[2, cuint]

  GRWLock* =  ptr GRWLockObj
  GRWLockPtr* = ptr GRWLockObj
  GRWLockObj* = object
    p*: Gpointer
    i*: array[2, cuint]

  GCond* =  ptr GCondObj
  GCondPtr* = ptr GCondObj
  GCondObj* = object
    p*: Gpointer
    i*: array[2, cuint]

  GRecMutex* =  ptr GRecMutexObj
  GRecMutexPtr* = ptr GRecMutexObj
  GRecMutexObj* = object
    p*: Gpointer
    i*: array[2, cuint]

  GPrivate* =  ptr GPrivateObj
  GPrivatePtr* = ptr GPrivateObj
  GPrivateObj* = object
    p*: Gpointer
    notify*: GDestroyNotify
    future*: array[2, Gpointer]

  GOnceStatus* {.size: sizeof(cint), pure.} = enum
    NOTCALLED, PROGRESS, READY

type
  GOnce* =  ptr GOnceObj
  GOncePtr* = ptr GOnceObj
  GOnceObj* = object
    status*: GOnceStatus
    retval*: Gpointer

proc `ref`*(thread: GThread): GThread {.importc: "g_thread_ref",
    libglib.}
proc unref*(thread: GThread) {.importc: "g_thread_unref", libglib.}
proc newThread*(name: cstring; `func`: GThreadFunc; data: Gpointer): GThread {.
    importc: "g_thread_new", libglib.}
proc newThreadTry*(name: cstring; `func`: GThreadFunc; data: Gpointer;
                   error: var GError): GThread {.importc: "g_thread_try_new",
    libglib.}
proc threadSelf*(): GThread {.importc: "g_thread_self", libglib.}
proc threadExit*(retval: Gpointer) {.importc: "g_thread_exit", libglib.}
proc join*(thread: GThread): Gpointer {.importc: "g_thread_join",
    libglib.}
proc threadYield*() {.importc: "g_thread_yield", libglib.}
proc init*(mutex: GMutex) {.importc: "g_mutex_init", libglib.}
proc clear*(mutex: GMutex) {.importc: "g_mutex_clear", libglib.}
proc lock*(mutex: GMutex) {.importc: "g_mutex_lock", libglib.}
proc trylock*(mutex: GMutex): Gboolean {.importc: "g_mutex_trylock",
    libglib.}
proc unlock*(mutex: GMutex) {.importc: "g_mutex_unlock", libglib.}
proc rwLockInit*(rwLock: GRWLock) {.importc: "g_rw_lock_init", libglib.}
proc rwLockClear*(rwLock: GRWLock) {.importc: "g_rw_lock_clear", libglib.}
proc rwLockWriterLock*(rwLock: GRWLock) {.importc: "g_rw_lock_writer_lock",
    libglib.}
proc rwLockWriterTrylock*(rwLock: GRWLock): Gboolean {.
    importc: "g_rw_lock_writer_trylock", libglib.}
proc rwLockWriterUnlock*(rwLock: GRWLock) {.importc: "g_rw_lock_writer_unlock",
    libglib.}
proc rwLockReaderLock*(rwLock: GRWLock) {.importc: "g_rw_lock_reader_lock",
    libglib.}
proc rwLockReaderTrylock*(rwLock: GRWLock): Gboolean {.
    importc: "g_rw_lock_reader_trylock", libglib.}
proc rwLockReaderUnlock*(rwLock: GRWLock) {.importc: "g_rw_lock_reader_unlock",
    libglib.}
proc init*(recMutex: GRecMutex) {.importc: "g_rec_mutex_init",
    libglib.}
proc clear*(recMutex: GRecMutex) {.importc: "g_rec_mutex_clear",
    libglib.}
proc lock*(recMutex: GRecMutex) {.importc: "g_rec_mutex_lock",
    libglib.}
proc trylock*(recMutex: GRecMutex): Gboolean {.
    importc: "g_rec_mutex_trylock", libglib.}
proc unlock*(recMutex: GRecMutex) {.importc: "g_rec_mutex_unlock",
    libglib.}
proc init*(cond: GCond) {.importc: "g_cond_init", libglib.}
proc clear*(cond: GCond) {.importc: "g_cond_clear", libglib.}
proc wait*(cond: GCond; mutex: GMutex) {.importc: "g_cond_wait", libglib.}
proc signal*(cond: GCond) {.importc: "g_cond_signal", libglib.}
proc broadcast*(cond: GCond) {.importc: "g_cond_broadcast", libglib.}
proc waitUntil*(cond: GCond; mutex: GMutex; endTime: int64): Gboolean {.
    importc: "g_cond_wait_until", libglib.}
proc get*(key: GPrivate): Gpointer {.importc: "g_private_get", libglib.}
proc set*(key: GPrivate; value: Gpointer) {.importc: "g_private_set",
    libglib.}
proc replace*(key: GPrivate; value: Gpointer) {.
    importc: "g_private_replace", libglib.}
proc impl*(once: GOnce; `func`: GThreadFunc; arg: Gpointer): Gpointer {.
    importc: "g_once_impl", libglib.}
proc onceInitEnter*(location: pointer): Gboolean {.importc: "g_once_init_enter",
    libglib.}
proc onceInitLeave*(location: pointer; result: Gsize) {.
    importc: "g_once_init_leave", libglib.}
when (G_ATOMIC_OP_MEMORY_BARRIER_NEEDED):
  template gOnce*(once, `func`, arg: untyped): untyped =
    gOnceImpl(once, `func`, arg)

else:
  template gOnce*(once, `func`, arg: untyped): untyped =
    (if (once.status == g_Once_Status_Ready): (once).retval else: gOnceImpl(once,
        (`func`), arg))

proc getNumProcessors*(): cuint {.importc: "g_get_num_processors", libglib.}

proc numProcessors*(): cuint {.importc: "g_get_num_processors", libglib.}

type
  GAsyncQueue* =  ptr GAsyncQueueObj
  GAsyncQueuePtr* = ptr GAsyncQueueObj
  GAsyncQueueObj* = object

proc newAsyncQueue*(): GAsyncQueue {.importc: "g_async_queue_new", libglib.}
proc newAsyncQueue*(itemFreeFunc: GDestroyNotify): GAsyncQueue {.
    importc: "g_async_queue_new_full", libglib.}
proc lock*(queue: GAsyncQueue) {.importc: "g_async_queue_lock",
    libglib.}
proc unlock*(queue: GAsyncQueue) {.importc: "g_async_queue_unlock",
    libglib.}
proc `ref`*(queue: GAsyncQueue): GAsyncQueue {.
    importc: "g_async_queue_ref", libglib.}
proc unref*(queue: GAsyncQueue) {.importc: "g_async_queue_unref",
    libglib.}
proc refUnlocked*(queue: GAsyncQueue) {.
    importc: "g_async_queue_ref_unlocked", libglib.}
proc unrefAndUnlock*(queue: GAsyncQueue) {.
    importc: "g_async_queue_unref_and_unlock", libglib.}
proc push*(queue: GAsyncQueue; data: Gpointer) {.
    importc: "g_async_queue_push", libglib.}
proc pushUnlocked*(queue: GAsyncQueue; data: Gpointer) {.
    importc: "g_async_queue_push_unlocked", libglib.}
proc pushSorted*(queue: GAsyncQueue; data: Gpointer;
                           `func`: GCompareDataFunc; userData: Gpointer) {.
    importc: "g_async_queue_push_sorted", libglib.}
proc pushSortedUnlocked*(queue: GAsyncQueue; data: Gpointer;
                                   `func`: GCompareDataFunc; userData: Gpointer) {.
    importc: "g_async_queue_push_sorted_unlocked", libglib.}
proc pop*(queue: GAsyncQueue): Gpointer {.
    importc: "g_async_queue_pop", libglib.}
proc popUnlocked*(queue: GAsyncQueue): Gpointer {.
    importc: "g_async_queue_pop_unlocked", libglib.}
proc tryPop*(queue: GAsyncQueue): Gpointer {.
    importc: "g_async_queue_try_pop", libglib.}
proc tryPopUnlocked*(queue: GAsyncQueue): Gpointer {.
    importc: "g_async_queue_try_pop_unlocked", libglib.}
proc timeoutPop*(queue: GAsyncQueue; timeout: uint64): Gpointer {.
    importc: "g_async_queue_timeout_pop", libglib.}
proc timeoutPopUnlocked*(queue: GAsyncQueue; timeout: uint64): Gpointer {.
    importc: "g_async_queue_timeout_pop_unlocked", libglib.}
proc length*(queue: GAsyncQueue): cint {.
    importc: "g_async_queue_length", libglib.}
proc lengthUnlocked*(queue: GAsyncQueue): cint {.
    importc: "g_async_queue_length_unlocked", libglib.}
proc sort*(queue: GAsyncQueue; `func`: GCompareDataFunc;
                     userData: Gpointer) {.importc: "g_async_queue_sort",
    libglib.}
proc sortUnlocked*(queue: GAsyncQueue; `func`: GCompareDataFunc;
                             userData: Gpointer) {.
    importc: "g_async_queue_sort_unlocked", libglib.}
proc remove*(queue: GAsyncQueue; item: Gpointer): Gboolean {.
    importc: "g_async_queue_remove", libglib.}
proc removeUnlocked*(queue: GAsyncQueue; item: Gpointer): Gboolean {.
    importc: "g_async_queue_remove_unlocked", libglib.}
proc pushFront*(queue: GAsyncQueue; item: Gpointer) {.
    importc: "g_async_queue_push_front", libglib.}
proc pushFrontUnlocked*(queue: GAsyncQueue; item: Gpointer) {.
    importc: "g_async_queue_push_front_unlocked", libglib.}
proc timedPop*(queue: GAsyncQueue; endTime: GTimeVal): Gpointer {.
    importc: "g_async_queue_timed_pop", libglib.}
proc timedPopUnlocked*(queue: GAsyncQueue; endTime: GTimeVal): Gpointer {.
    importc: "g_async_queue_timed_pop_unlocked", libglib.}

proc onErrorQuery*(prgName: cstring) {.importc: "g_on_error_query", libglib.}
proc onErrorStackTrace*(prgName: cstring) {.importc: "g_on_error_stack_trace",
    libglib.}

proc base64EncodeStep*(`in`: var cuchar; len: Gsize; breakLines: Gboolean;
                       `out`: cstring; state: var cint; save: var cint): Gsize {.
    importc: "g_base64_encode_step", libglib.}
proc base64EncodeClose*(breakLines: Gboolean; `out`: cstring; state: var cint;
                        save: var cint): Gsize {.importc: "g_base64_encode_close",
    libglib.}
proc base64Encode*(data: var cuchar; len: Gsize): cstring {.
    importc: "g_base64_encode", libglib.}
proc base64DecodeStep*(`in`: cstring; len: Gsize; `out`: var cuchar; state: var cint;
                       save: var cuint): Gsize {.importc: "g_base64_decode_step",
    libglib.}
proc base64Decode*(text: cstring; outLen: var Gsize): ptr cuchar {.
    importc: "g_base64_decode", libglib.}
proc base64DecodeInplace*(text: cstring; outLen: var Gsize): ptr cuchar {.
    importc: "g_base64_decode_inplace", libglib.}

proc bitLock*(address: var cint; lockBit: cint) {.importc: "g_bit_lock", libglib.}
proc bitTrylock*(address: var cint; lockBit: cint): Gboolean {.
    importc: "g_bit_trylock", libglib.}
proc bitUnlock*(address: var cint; lockBit: cint) {.importc: "g_bit_unlock",
    libglib.}
proc pointerBitLock*(address: pointer; lockBit: cint) {.
    importc: "g_pointer_bit_lock", libglib.}
proc pointerBitTrylock*(address: pointer; lockBit: cint): Gboolean {.
    importc: "g_pointer_bit_trylock", libglib.}
proc pointerBitUnlock*(address: pointer; lockBit: cint) {.
    importc: "g_pointer_bit_unlock", libglib.}

type
  GBookmarkFileError* {.size: sizeof(cint), pure.} = enum
    INVALID_URI, INVALID_VALUE,
    APP_NOT_REGISTERED,
    URI_NOT_FOUND, READ,
    UNKNOWN_ENCODING, WRITE,
    FILE_NOT_FOUND

proc bookmarkFileErrorQuark*(): GQuark {.importc: "g_bookmark_file_error_quark",
                                       libglib.}

type
  GBookmarkFile* =  ptr GBookmarkFileObj
  GBookmarkFilePtr* = ptr GBookmarkFileObj
  GBookmarkFileObj* = object

proc newBookmarkFile*(): GBookmarkFile {.importc: "g_bookmark_file_new",
    libglib.}
proc free*(bookmark: GBookmarkFile) {.
    importc: "g_bookmark_file_free", libglib.}
proc loadFromFile*(bookmark: GBookmarkFile; filename: cstring;
                               error: var GError): Gboolean {.
    importc: "g_bookmark_file_load_from_file", libglib.}
proc loadFromData*(bookmark: GBookmarkFile; data: cstring;
                               length: Gsize; error: var GError): Gboolean {.
    importc: "g_bookmark_file_load_from_data", libglib.}
proc loadFromDataDirs*(bookmark: GBookmarkFile; file: cstring;
                                   fullPath: cstringArray; error: var GError): Gboolean {.
    importc: "g_bookmark_file_load_from_data_dirs", libglib.}
proc toData*(bookmark: GBookmarkFile; length: var Gsize;
                         error: var GError): cstring {.
    importc: "g_bookmark_file_to_data", libglib.}
proc toFile*(bookmark: GBookmarkFile; filename: cstring;
                         error: var GError): Gboolean {.
    importc: "g_bookmark_file_to_file", libglib.}
proc setTitle*(bookmark: GBookmarkFile; uri: cstring; title: cstring) {.
    importc: "g_bookmark_file_set_title", libglib.}
proc `title=`*(bookmark: GBookmarkFile; uri: cstring; title: cstring) {.
    importc: "g_bookmark_file_set_title", libglib.}
proc getTitle*(bookmark: GBookmarkFile; uri: cstring;
                           error: var GError): cstring {.
    importc: "g_bookmark_file_get_title", libglib.}
proc title*(bookmark: GBookmarkFile; uri: cstring;
                           error: var GError): cstring {.
    importc: "g_bookmark_file_get_title", libglib.}
proc setDescription*(bookmark: GBookmarkFile; uri: cstring;
                                 description: cstring) {.
    importc: "g_bookmark_file_set_description", libglib.}
proc `description=`*(bookmark: GBookmarkFile; uri: cstring;
                                 description: cstring) {.
    importc: "g_bookmark_file_set_description", libglib.}
proc getDescription*(bookmark: GBookmarkFile; uri: cstring;
                                 error: var GError): cstring {.
    importc: "g_bookmark_file_get_description", libglib.}
proc description*(bookmark: GBookmarkFile; uri: cstring;
                                 error: var GError): cstring {.
    importc: "g_bookmark_file_get_description", libglib.}
proc setMimeType*(bookmark: GBookmarkFile; uri: cstring;
                              mimeType: cstring) {.
    importc: "g_bookmark_file_set_mime_type", libglib.}
proc `mimeType=`*(bookmark: GBookmarkFile; uri: cstring;
                              mimeType: cstring) {.
    importc: "g_bookmark_file_set_mime_type", libglib.}
proc getMimeType*(bookmark: GBookmarkFile; uri: cstring;
                              error: var GError): cstring {.
    importc: "g_bookmark_file_get_mime_type", libglib.}
proc mimeType*(bookmark: GBookmarkFile; uri: cstring;
                              error: var GError): cstring {.
    importc: "g_bookmark_file_get_mime_type", libglib.}
proc setGroups*(bookmark: GBookmarkFile; uri: cstring;
                            groups: cstringArray; length: Gsize) {.
    importc: "g_bookmark_file_set_groups", libglib.}
proc `groups=`*(bookmark: GBookmarkFile; uri: cstring;
                            groups: cstringArray; length: Gsize) {.
    importc: "g_bookmark_file_set_groups", libglib.}
proc addGroup*(bookmark: GBookmarkFile; uri: cstring; group: cstring) {.
    importc: "g_bookmark_file_add_group", libglib.}
proc hasGroup*(bookmark: GBookmarkFile; uri: cstring; group: cstring;
                           error: var GError): Gboolean {.
    importc: "g_bookmark_file_has_group", libglib.}
proc getGroups*(bookmark: GBookmarkFile; uri: cstring;
                            length: var Gsize; error: var GError): cstringArray {.
    importc: "g_bookmark_file_get_groups", libglib.}
proc groups*(bookmark: GBookmarkFile; uri: cstring;
                            length: var Gsize; error: var GError): cstringArray {.
    importc: "g_bookmark_file_get_groups", libglib.}
proc addApplication*(bookmark: GBookmarkFile; uri: cstring;
                                 name: cstring; exec: cstring) {.
    importc: "g_bookmark_file_add_application", libglib.}
proc hasApplication*(bookmark: GBookmarkFile; uri: cstring;
                                 name: cstring; error: var GError): Gboolean {.
    importc: "g_bookmark_file_has_application", libglib.}
proc getApplications*(bookmark: GBookmarkFile; uri: cstring;
                                  length: var Gsize; error: var GError): cstringArray {.
    importc: "g_bookmark_file_get_applications", libglib.}
proc applications*(bookmark: GBookmarkFile; uri: cstring;
                                  length: var Gsize; error: var GError): cstringArray {.
    importc: "g_bookmark_file_get_applications", libglib.}
proc setAppInfo*(bookmark: GBookmarkFile; uri: cstring;
                             name: cstring; exec: cstring; count: cint; stamp: times.Time;
                             error: var GError): Gboolean {.
    importc: "g_bookmark_file_set_app_info", libglib.}
proc getAppInfo*(bookmark: GBookmarkFile; uri: cstring;
                             name: cstring; exec: cstringArray; count: var cuint;
                             stamp: ptr times.Time; error: var GError): Gboolean {.
    importc: "g_bookmark_file_get_app_info", libglib.}
proc appInfo*(bookmark: GBookmarkFile; uri: cstring;
                             name: cstring; exec: cstringArray; count: var cuint;
                             stamp: ptr times.Time; error: var GError): Gboolean {.
    importc: "g_bookmark_file_get_app_info", libglib.}
proc setIsPrivate*(bookmark: GBookmarkFile; uri: cstring;
                               isPrivate: Gboolean) {.
    importc: "g_bookmark_file_set_is_private", libglib.}
proc `isPrivate=`*(bookmark: GBookmarkFile; uri: cstring;
                               isPrivate: Gboolean) {.
    importc: "g_bookmark_file_set_is_private", libglib.}
proc getIsPrivate*(bookmark: GBookmarkFile; uri: cstring;
                               error: var GError): Gboolean {.
    importc: "g_bookmark_file_get_is_private", libglib.}
proc isPrivate*(bookmark: GBookmarkFile; uri: cstring;
                               error: var GError): Gboolean {.
    importc: "g_bookmark_file_get_is_private", libglib.}
proc setIcon*(bookmark: GBookmarkFile; uri: cstring; href: cstring;
                          mimeType: cstring) {.
    importc: "g_bookmark_file_set_icon", libglib.}
proc `icon=`*(bookmark: GBookmarkFile; uri: cstring; href: cstring;
                          mimeType: cstring) {.
    importc: "g_bookmark_file_set_icon", libglib.}
proc getIcon*(bookmark: GBookmarkFile; uri: cstring;
                          href: cstringArray; mimeType: cstringArray;
                          error: var GError): Gboolean {.
    importc: "g_bookmark_file_get_icon", libglib.}
proc icon*(bookmark: GBookmarkFile; uri: cstring;
                          href: cstringArray; mimeType: cstringArray;
                          error: var GError): Gboolean {.
    importc: "g_bookmark_file_get_icon", libglib.}
proc setAdded*(bookmark: GBookmarkFile; uri: cstring; added: times.Time) {.
    importc: "g_bookmark_file_set_added", libglib.}
proc `added=`*(bookmark: GBookmarkFile; uri: cstring; added: times.Time) {.
    importc: "g_bookmark_file_set_added", libglib.}
proc getAdded*(bookmark: GBookmarkFile; uri: cstring;
                           error: var GError): times.Time {.
    importc: "g_bookmark_file_get_added", libglib.}
proc added*(bookmark: GBookmarkFile; uri: cstring;
                           error: var GError): times.Time {.
    importc: "g_bookmark_file_get_added", libglib.}
proc setModified*(bookmark: GBookmarkFile; uri: cstring;
                              modified: times.Time) {.
    importc: "g_bookmark_file_set_modified", libglib.}
proc `modified=`*(bookmark: GBookmarkFile; uri: cstring;
                              modified: times.Time) {.
    importc: "g_bookmark_file_set_modified", libglib.}
proc getModified*(bookmark: GBookmarkFile; uri: cstring;
                              error: var GError): times.Time {.
    importc: "g_bookmark_file_get_modified", libglib.}
proc modified*(bookmark: GBookmarkFile; uri: cstring;
                              error: var GError): times.Time {.
    importc: "g_bookmark_file_get_modified", libglib.}
proc setVisited*(bookmark: GBookmarkFile; uri: cstring;
                             visited: times.Time) {.
    importc: "g_bookmark_file_set_visited", libglib.}
proc `visited=`*(bookmark: GBookmarkFile; uri: cstring;
                             visited: times.Time) {.
    importc: "g_bookmark_file_set_visited", libglib.}
proc getVisited*(bookmark: GBookmarkFile; uri: cstring;
                             error: var GError): times.Time {.
    importc: "g_bookmark_file_get_visited", libglib.}
proc visited*(bookmark: GBookmarkFile; uri: cstring;
                             error: var GError): times.Time {.
    importc: "g_bookmark_file_get_visited", libglib.}
proc hasItem*(bookmark: GBookmarkFile; uri: cstring): Gboolean {.
    importc: "g_bookmark_file_has_item", libglib.}
proc getSize*(bookmark: GBookmarkFile): cint {.
    importc: "g_bookmark_file_get_size", libglib.}
proc size*(bookmark: GBookmarkFile): cint {.
    importc: "g_bookmark_file_get_size", libglib.}
proc getUris*(bookmark: GBookmarkFile; length: var Gsize): cstringArray {.
    importc: "g_bookmark_file_get_uris", libglib.}
proc uris*(bookmark: GBookmarkFile; length: var Gsize): cstringArray {.
    importc: "g_bookmark_file_get_uris", libglib.}
proc removeGroup*(bookmark: GBookmarkFile; uri: cstring;
                              group: cstring; error: var GError): Gboolean {.
    importc: "g_bookmark_file_remove_group", libglib.}
proc removeApplication*(bookmark: GBookmarkFile; uri: cstring;
                                    name: cstring; error: var GError): Gboolean {.
    importc: "g_bookmark_file_remove_application", libglib.}
proc removeItem*(bookmark: GBookmarkFile; uri: cstring;
                             error: var GError): Gboolean {.
    importc: "g_bookmark_file_remove_item", libglib.}
proc moveItem*(bookmark: GBookmarkFile; oldUri: cstring;
                           newUri: cstring; error: var GError): Gboolean {.
    importc: "g_bookmark_file_move_item", libglib.}

proc newBytes*(data: Gconstpointer; size: Gsize): GBytes {.importc: "g_bytes_new",
    libglib.}
proc newBytesTake*(data: Gpointer; size: Gsize): GBytes {.
    importc: "g_bytes_new_take", libglib.}
proc newBytesStatic*(data: Gconstpointer; size: Gsize): GBytes {.
    importc: "g_bytes_new_static", libglib.}
proc newBytes*(data: Gconstpointer; size: Gsize;
                           freeFunc: GDestroyNotify; userData: Gpointer): GBytes {.
    importc: "g_bytes_new_with_free_func", libglib.}
proc newGBytes*(bytes: GBytes; offset: Gsize; length: Gsize): GBytes {.
    importc: "g_bytes_new_from_bytes", libglib.}
proc getData*(bytes: GBytes; size: var Gsize): Gconstpointer {.
    importc: "g_bytes_get_data", libglib.}
proc data*(bytes: GBytes; size: var Gsize): Gconstpointer {.
    importc: "g_bytes_get_data", libglib.}
proc getSize*(bytes: GBytes): Gsize {.importc: "g_bytes_get_size",
    libglib.}
proc size*(bytes: GBytes): Gsize {.importc: "g_bytes_get_size",
    libglib.}
proc `ref`*(bytes: GBytes): GBytes {.importc: "g_bytes_ref", libglib.}
proc unref*(bytes: GBytes) {.importc: "g_bytes_unref", libglib.}
proc unrefToData*(bytes: GBytes; size: var Gsize): Gpointer {.
    importc: "g_bytes_unref_to_data", libglib.}
proc unrefToArray*(bytes: GBytes): GByteArray {.
    importc: "g_bytes_unref_to_array", libglib.}
proc bytesHash*(bytes: Gconstpointer): cuint {.importc: "g_bytes_hash", libglib.}
proc bytesEqual*(bytes1: Gconstpointer; bytes2: Gconstpointer): Gboolean {.
    importc: "g_bytes_equal", libglib.}
proc bytesCompare*(bytes1: Gconstpointer; bytes2: Gconstpointer): cint {.
    importc: "g_bytes_compare", libglib.}

proc getCharset*(charset: cstringArray): Gboolean {.importc: "g_get_charset",
    libglib.}

proc charset*(charset: cstringArray): Gboolean {.importc: "g_get_charset",
    libglib.}
proc getCodeset*(): cstring {.importc: "g_get_codeset", libglib.}
proc codeset*(): cstring {.importc: "g_get_codeset", libglib.}
proc getLanguageNames*(): cstringArray {.importc: "g_get_language_names",
                                       libglib.}
proc languageNames*(): cstringArray {.importc: "g_get_language_names",
                                       libglib.}
proc getLocaleVariants*(locale: cstring): cstringArray {.
    importc: "g_get_locale_variants", libglib.}
proc localeVariants*(locale: cstring): cstringArray {.
    importc: "g_get_locale_variants", libglib.}

type
  GChecksumType* {.size: sizeof(cint), pure.} = enum
    MD5, SHA1, SHA256, SHA512,
    SHA384

type
  GChecksum* =  ptr GChecksumObj
  GChecksumPtr* = ptr GChecksumObj
  GChecksumObj* = object

proc getLength*(checksumType: GChecksumType): Gssize {.
    importc: "g_checksum_type_get_length", libglib.}

proc length*(checksumType: GChecksumType): Gssize {.
    importc: "g_checksum_type_get_length", libglib.}
proc newChecksum*(checksumType: GChecksumType): GChecksum {.
    importc: "g_checksum_new", libglib.}
proc reset*(checksum: GChecksum) {.importc: "g_checksum_reset",
    libglib.}
proc copy*(checksum: GChecksum): GChecksum {.
    importc: "g_checksum_copy", libglib.}
proc free*(checksum: GChecksum) {.importc: "g_checksum_free", libglib.}
proc update*(checksum: GChecksum; data: var cuchar; length: Gssize) {.
    importc: "g_checksum_update", libglib.}
proc getString*(checksum: GChecksum): cstring {.
    importc: "g_checksum_get_string", libglib.}
proc getDigest*(checksum: GChecksum; buffer: var uint8;
                        digestLen: var Gsize) {.importc: "g_checksum_get_digest",
    libglib.}
proc computeChecksumForData*(checksumType: GChecksumType; data: var cuchar;
                             length: Gsize): cstring {.
    importc: "g_compute_checksum_for_data", libglib.}
proc computeChecksumForString*(checksumType: GChecksumType; str: cstring;
                               length: Gssize): cstring {.
    importc: "g_compute_checksum_for_string", libglib.}
proc computeChecksumForBytes*(checksumType: GChecksumType; data: GBytes): cstring {.
    importc: "g_compute_checksum_for_bytes", libglib.}

type
  GConvertError* {.size: sizeof(cint), pure.} = enum
    NO_CONVERSION, ILLEGAL_SEQUENCE,
    FAILED, PARTIAL_INPUT,
    BAD_URI, NOT_ABSOLUTE_PATH,
    NO_MEMORY

proc convertErrorQuark*(): GQuark {.importc: "g_convert_error_quark", libglib.}

type
  GIConv* =  ptr GIConvObj
  GIConvPtr* = ptr GIConvObj
  GIConvObj* = object

proc iconvOpen*(toCodeset: cstring; fromCodeset: cstring): GIConv {.
    importc: "g_iconv_open", libglib.}
proc iconv*(`converter`: GIConv; inbuf: cstringArray; inbytesLeft: var Gsize;
            outbuf: cstringArray; outbytesLeft: var Gsize): Gsize {.
    importc: "g_iconv", libglib.}
proc iconvClose*(`converter`: GIConv): cint {.importc: "g_iconv_close",
    libglib.}
proc convert*(str: cstring; len: Gssize; toCodeset: cstring; fromCodeset: cstring;
              bytesRead: var Gsize; bytesWritten: var Gsize; error: var GError): cstring {.
    importc: "g_convert", libglib.}
proc convertWithIconv*(str: cstring; len: Gssize; `converter`: GIConv;
                       bytesRead: var Gsize; bytesWritten: var Gsize;
                       error: var GError): cstring {.
    importc: "g_convert_with_iconv", libglib.}
proc convertWithFallback*(str: cstring; len: Gssize; toCodeset: cstring;
                          fromCodeset: cstring; fallback: cstring;
                          bytesRead: var Gsize; bytesWritten: var Gsize;
                          error: var GError): cstring {.
    importc: "g_convert_with_fallback", libglib.}

proc localeToUtf8*(opsysstring: cstring; len: Gssize; bytesRead: var Gsize;
                   bytesWritten: var Gsize; error: var GError): cstring {.
    importc: "g_locale_to_utf8", libglib.}
proc localeFromUtf8*(utf8string: cstring; len: Gssize; bytesRead: var Gsize;
                     bytesWritten: var Gsize; error: var GError): cstring {.
    importc: "g_locale_from_utf8", libglib.}

proc filenameToUtf8*(opsysstring: cstring; len: Gssize; bytesRead: var Gsize;
                     bytesWritten: var Gsize; error: var GError): cstring {.
    importc: "g_filename_to_utf8", libglib.}
proc filenameFromUtf8*(utf8string: cstring; len: Gssize; bytesRead: var Gsize;
                       bytesWritten: var Gsize; error: var GError): cstring {.
    importc: "g_filename_from_utf8", libglib.}
proc filenameFromUri*(uri: cstring; hostname: cstringArray; error: var GError): cstring {.
    importc: "g_filename_from_uri", libglib.}
proc filenameToUri*(filename: cstring; hostname: cstring; error: var GError): cstring {.
    importc: "g_filename_to_uri", libglib.}
proc filenameDisplayName*(filename: cstring): cstring {.
    importc: "g_filename_display_name", libglib.}
proc getFilenameCharsets*(charsets: var cstringArray): Gboolean {.
    importc: "g_get_filename_charsets", libglib.}
proc filenameCharsets*(charsets: var cstringArray): Gboolean {.
    importc: "g_get_filename_charsets", libglib.}
proc filenameDisplayBasename*(filename: cstring): cstring {.
    importc: "g_filename_display_basename", libglib.}
proc uriListExtractUris*(uriList: cstring): cstringArray {.
    importc: "g_uri_list_extract_uris", libglib.}

type
  GData* =  ptr GDataObj
  GDataPtr* = ptr GDataObj
  GDataObj* = object

  GDataForeachFunc* = proc (keyId: GQuark; data: Gpointer; userData: Gpointer) {.cdecl.}

proc init*(datalist: var GData) {.importc: "g_datalist_init", libglib.}
proc clear*(datalist: var GData) {.importc: "g_datalist_clear",
    libglib.}
proc idGetData*(datalist: var GData; keyId: GQuark): Gpointer {.
    importc: "g_datalist_id_get_data", libglib.}
proc idSetDataFull*(datalist: var GData; keyId: GQuark; data: Gpointer;
                            destroyFunc: GDestroyNotify) {.
    importc: "g_datalist_id_set_data_full", libglib.}
type
  GDuplicateFunc* = proc (data: Gpointer; userData: Gpointer): Gpointer {.cdecl.}

proc idDupData*(datalist: var GData; keyId: GQuark;
                        dupFunc: GDuplicateFunc; userData: Gpointer): Gpointer {.
    importc: "g_datalist_id_dup_data", libglib.}
proc idReplaceData*(datalist: var GData; keyId: GQuark; oldval: Gpointer;
                            newval: Gpointer; destroy: GDestroyNotify;
                            oldDestroy: ptr GDestroyNotify): Gboolean {.
    importc: "g_datalist_id_replace_data", libglib.}
proc idRemoveNoNotify*(datalist: var GData; keyId: GQuark): Gpointer {.
    importc: "g_datalist_id_remove_no_notify", libglib.}
proc foreach*(datalist: var GData; `func`: GDataForeachFunc;
                      userData: Gpointer) {.importc: "g_datalist_foreach",
    libglib.}

const
  G_DATALIST_FLAGS_MASK* = 0x3

proc setFlags*(datalist: var GData; flags: cuint) {.
    importc: "g_datalist_set_flags", libglib.}
proc unsetFlags*(datalist: var GData; flags: cuint) {.
    importc: "g_datalist_unset_flags", libglib.}
proc getFlags*(datalist: var GData): cuint {.
    importc: "g_datalist_get_flags", libglib.}
template gDatalistIdSetData*(dl, q, d: untyped): untyped =
  idSetDataFull(dl, q, d, nil)

template gDatalistIdRemoveData*(dl, q: untyped): untyped =
  idSetData(dl, q, nil)

template gDatalistSetDataFull*(dl, k, d, f: untyped): untyped =
  idSetDataFull(dl, quarkFromString(k), d, f)

template gDatalistRemoveNoNotify*(dl, k: untyped): untyped =
  idRemoveNoNotify(dl, quarkTryString(k))

template gDatalistSetData*(dl, k, d: untyped): untyped =
  setDataFull(dl, k, d, nil)

template gDatalistRemoveData*(dl, k: untyped): untyped =
  idSetData(dl, quarkTryString(k), nil)

proc datasetDestroy*(datasetLocation: Gconstpointer) {.
    importc: "g_dataset_destroy", libglib.}
proc datasetIdGetData*(datasetLocation: Gconstpointer; keyId: GQuark): Gpointer {.
    importc: "g_dataset_id_get_data", libglib.}
proc getData*(datalist: var GData; key: cstring): Gpointer {.
    importc: "g_datalist_get_data", libglib.}
proc data*(datalist: var GData; key: cstring): Gpointer {.
    importc: "g_datalist_get_data", libglib.}
proc datasetIdSetDataFull*(datasetLocation: Gconstpointer; keyId: GQuark;
                           data: Gpointer; destroyFunc: GDestroyNotify) {.
    importc: "g_dataset_id_set_data_full", libglib.}
proc datasetIdRemoveNoNotify*(datasetLocation: Gconstpointer; keyId: GQuark): Gpointer {.
    importc: "g_dataset_id_remove_no_notify", libglib.}
proc datasetForeach*(datasetLocation: Gconstpointer; `func`: GDataForeachFunc;
                     userData: Gpointer) {.importc: "g_dataset_foreach", libglib.}
template gDatasetIdSetData*(l, k, d: untyped): untyped =
  datasetIdSetDataFull(l, k, d, nil)

template gDatasetIdRemoveData*(l, k: untyped): untyped =
  datasetIdSetData(l, k, nil)

template gDatasetGetData*(l, k: untyped): untyped =
  (datasetIdGetData(l, quarkTryString(k)))

template gDatasetSetDataFull*(l, k, d, f: untyped): untyped =
  datasetIdSetDataFull(l, quarkFromString(k), d, f)

template gDatasetRemoveNoNotify*(l, k: untyped): untyped =
  datasetIdRemoveNoNotify(l, quarkTryString(k))

template gDatasetSetData*(l, k, d: untyped): untyped =
  gDatasetSetDataFull(l, k, d, nil)

template gDatasetRemoveData*(l, k: untyped): untyped =
  datasetIdSetData(l, quarkTryString(k), nil)

type
  GTime* = int32
  GDateYear* = uint16
  GDateDay* = uint8

type
  GDateDMY* {.size: sizeof(cint), pure.} = enum
    DAY = 0, MONTH = 1, YEAR = 2

type
  GDateWeekday* {.size: sizeof(cint), pure.} = enum
    BAD_WEEKDAY = 0, MONDAY = 1, TUESDAY = 2, WEDNESDAY = 3,
    THURSDAY = 4, FRIDAY = 5, SATURDAY = 6, SUNDAY = 7
  GDateMonth* {.size: sizeof(cint), pure.} = enum
    BAD_MONTH = 0, JANUARY = 1, FEBRUARY = 2, MARCH = 3,
    APRIL = 4, MAY = 5, JUNE = 6, JULY = 7, AUGUST = 8,
    SEPTEMBER = 9, OCTOBER = 10, NOVEMBER = 11, DECEMBER = 12

const
  G_DATE_BAD_JULIAN* = 0
  G_DATE_BAD_DAY* = 0
  G_DATE_BAD_YEAR* = 0

type
  GDate* =  ptr GDateObj
  GDatePtr* = ptr GDateObj
  GDateObj* = object
    julianDays* {.bitsize: 32.}: cuint
    julian* {.bitsize: 1.}: cuint
    dmy* {.bitsize: 1.}: cuint
    day* {.bitsize: 6.}: cuint
    month* {.bitsize: 4.}: cuint
    year* {.bitsize: 16.}: cuint

proc newDate*(): GDate {.importc: "g_date_new", libglib.}
proc newDate*(day: GDateDay; month: GDateMonth; year: GDateYear): GDate {.
    importc: "g_date_new_dmy", libglib.}
proc newDate*(julianDay: uint32): GDate {.importc: "g_date_new_julian",
    libglib.}
proc free*(date: GDate) {.importc: "g_date_free", libglib.}

proc valid*(date: GDate): Gboolean {.importc: "g_date_valid", libglib.}
proc validDay*(day: GDateDay): Gboolean {.importc: "g_date_valid_day",
    libglib.}
proc validMonth*(month: GDateMonth): Gboolean {.importc: "g_date_valid_month",
    libglib.}
proc validYear*(year: GDateYear): Gboolean {.importc: "g_date_valid_year",
    libglib.}
proc validWeekday*(weekday: GDateWeekday): Gboolean {.
    importc: "g_date_valid_weekday", libglib.}
proc validJulian*(julianDate: uint32): Gboolean {.
    importc: "g_date_valid_julian", libglib.}
proc validDmy*(day: GDateDay; month: GDateMonth; year: GDateYear): Gboolean {.
    importc: "g_date_valid_dmy", libglib.}
proc getWeekday*(date: GDate): GDateWeekday {.importc: "g_date_get_weekday",
    libglib.}
proc weekday*(date: GDate): GDateWeekday {.importc: "g_date_get_weekday",
    libglib.}
proc getMonth*(date: GDate): GDateMonth {.importc: "g_date_get_month",
    libglib.}
proc month*(date: GDate): GDateMonth {.importc: "g_date_get_month",
    libglib.}
proc getYear*(date: GDate): GDateYear {.importc: "g_date_get_year",
    libglib.}
proc year*(date: GDate): GDateYear {.importc: "g_date_get_year",
    libglib.}
proc getDay*(date: GDate): GDateDay {.importc: "g_date_get_day", libglib.}
proc day*(date: GDate): GDateDay {.importc: "g_date_get_day", libglib.}
proc getJulian*(date: GDate): uint32 {.importc: "g_date_get_julian",
    libglib.}
proc julian*(date: GDate): uint32 {.importc: "g_date_get_julian",
    libglib.}
proc getDayOfYear*(date: GDate): cuint {.importc: "g_date_get_day_of_year",
    libglib.}
proc dayOfYear*(date: GDate): cuint {.importc: "g_date_get_day_of_year",
    libglib.}

proc getMondayWeekOfYear*(date: GDate): cuint {.
    importc: "g_date_get_monday_week_of_year", libglib.}

proc mondayWeekOfYear*(date: GDate): cuint {.
    importc: "g_date_get_monday_week_of_year", libglib.}
proc getSundayWeekOfYear*(date: GDate): cuint {.
    importc: "g_date_get_sunday_week_of_year", libglib.}
proc sundayWeekOfYear*(date: GDate): cuint {.
    importc: "g_date_get_sunday_week_of_year", libglib.}
proc getIso8601WeekOfYear*(date: GDate): cuint {.
    importc: "g_date_get_iso8601_week_of_year", libglib.}
proc iso8601WeekOfYear*(date: GDate): cuint {.
    importc: "g_date_get_iso8601_week_of_year", libglib.}

proc clear*(date: GDate; nDates: cuint) {.importc: "g_date_clear", libglib.}

proc setParse*(date: GDate; str: cstring) {.importc: "g_date_set_parse",
    libglib.}

proc `parse=`*(date: GDate; str: cstring) {.importc: "g_date_set_parse",
    libglib.}
proc setTimeT*(date: GDate; timet: times.Time) {.importc: "g_date_set_time_t",
    libglib.}
proc `timeT=`*(date: GDate; timet: times.Time) {.importc: "g_date_set_time_t",
    libglib.}
proc setTimeVal*(date: GDate; timeval: GTimeVal) {.
    importc: "g_date_set_time_val", libglib.}
proc `timeVal=`*(date: GDate; timeval: GTimeVal) {.
    importc: "g_date_set_time_val", libglib.}
when not (G_DISABLE_DEPRECATED):
  proc setTime*(date: GDate; time: GTime) {.importc: "g_date_set_time",
      libglib.}
  proc `time=`*(date: GDate; time: GTime) {.importc: "g_date_set_time",
      libglib.}
proc setMonth*(date: GDate; month: GDateMonth) {.importc: "g_date_set_month",
    libglib.}
proc `month=`*(date: GDate; month: GDateMonth) {.importc: "g_date_set_month",
    libglib.}
proc setDay*(date: GDate; day: GDateDay) {.importc: "g_date_set_day",
    libglib.}
proc `day=`*(date: GDate; day: GDateDay) {.importc: "g_date_set_day",
    libglib.}
proc setYear*(date: GDate; year: GDateYear) {.importc: "g_date_set_year",
    libglib.}
proc `year=`*(date: GDate; year: GDateYear) {.importc: "g_date_set_year",
    libglib.}
proc setDmy*(date: GDate; day: GDateDay; month: GDateMonth; y: GDateYear) {.
    importc: "g_date_set_dmy", libglib.}
proc `dmy=`*(date: GDate; day: GDateDay; month: GDateMonth; y: GDateYear) {.
    importc: "g_date_set_dmy", libglib.}
proc setJulian*(date: GDate; julianDate: uint32) {.
    importc: "g_date_set_julian", libglib.}
proc `julian=`*(date: GDate; julianDate: uint32) {.
    importc: "g_date_set_julian", libglib.}
proc isFirstOfMonth*(date: GDate): Gboolean {.
    importc: "g_date_is_first_of_month", libglib.}
proc isLastOfMonth*(date: GDate): Gboolean {.
    importc: "g_date_is_last_of_month", libglib.}

proc addDays*(date: GDate; nDays: cuint) {.importc: "g_date_add_days",
    libglib.}
proc subtractDays*(date: GDate; nDays: cuint) {.
    importc: "g_date_subtract_days", libglib.}

proc addMonths*(date: GDate; nMonths: cuint) {.importc: "g_date_add_months",
    libglib.}
proc subtractMonths*(date: GDate; nMonths: cuint) {.
    importc: "g_date_subtract_months", libglib.}

proc addYears*(date: GDate; nYears: cuint) {.importc: "g_date_add_years",
    libglib.}
proc subtractYears*(date: GDate; nYears: cuint) {.
    importc: "g_date_subtract_years", libglib.}
proc isLeapYear*(year: GDateYear): Gboolean {.importc: "g_date_is_leap_year",
    libglib.}
proc getDaysInMonth*(month: GDateMonth; year: GDateYear): uint8 {.
    importc: "g_date_get_days_in_month", libglib.}
proc daysInMonth*(month: GDateMonth; year: GDateYear): uint8 {.
    importc: "g_date_get_days_in_month", libglib.}
proc getMondayWeeksInYear*(year: GDateYear): uint8 {.
    importc: "g_date_get_monday_weeks_in_year", libglib.}
proc mondayWeeksInYear*(year: GDateYear): uint8 {.
    importc: "g_date_get_monday_weeks_in_year", libglib.}
proc getSundayWeeksInYear*(year: GDateYear): uint8 {.
    importc: "g_date_get_sunday_weeks_in_year", libglib.}
proc sundayWeeksInYear*(year: GDateYear): uint8 {.
    importc: "g_date_get_sunday_weeks_in_year", libglib.}

proc daysBetween*(date1: GDate; date2: GDate): cint {.
    importc: "g_date_days_between", libglib.}

proc compare*(lhs: GDate; rhs: GDate): cint {.importc: "g_date_compare",
    libglib.}
proc clamp*(date: GDate; minDate: GDate; maxDate: GDate) {.
    importc: "g_date_clamp", libglib.}

proc order*(date1: GDate; date2: GDate) {.importc: "g_date_order",
    libglib.}

proc dateStrftime*(s: cstring; slen: Gsize; format: cstring; date: GDate): Gsize {.
    importc: "g_date_strftime", libglib.}
when not (G_DISABLE_DEPRECATED):
  const
    gDateWeekday* = getWeekday
    gDateMonth* = getMonth
    gDateYear* = getYear
    gDateDay* = getDay
    gDateJulian* = getJulian
    gDateDayOfYear* = getDayOfYear
    gDateMondayWeekOfYear* = getMondayWeekOfYear
    gDateSundayWeekOfYear* = getSundayWeekOfYear
    gDateDaysInMonth* = getDaysInMonth
    gDateMondayWeeksInYear* = getMondayWeeksInYear
    gDateSundayWeeksInYear* = getSundayWeeksInYear

type
  GTimeZone* =  ptr GTimeZoneObj
  GTimeZonePtr* = ptr GTimeZoneObj
  GTimeZoneObj* = object

type
  GTimeType* {.size: sizeof(cint), pure.} = enum
    STANDARD, DAYLIGHT, UNIVERSAL

proc newTimeZone*(identifier: cstring): GTimeZone {.importc: "g_time_zone_new",
    libglib.}
proc newTimeZoneUTC*(): GTimeZone {.importc: "g_time_zone_new_utc", libglib.}
proc newTimeZoneLocal*(): GTimeZone {.importc: "g_time_zone_new_local",
                                       libglib.}
proc `ref`*(tz: GTimeZone): GTimeZone {.importc: "g_time_zone_ref",
    libglib.}
proc unref*(tz: GTimeZone) {.importc: "g_time_zone_unref", libglib.}
proc findInterval*(tz: GTimeZone; `type`: GTimeType; time: int64): cint {.
    importc: "g_time_zone_find_interval", libglib.}
proc adjustTime*(tz: GTimeZone; `type`: GTimeType; time: var int64): cint {.
    importc: "g_time_zone_adjust_time", libglib.}
proc getAbbreviation*(tz: GTimeZone; interval: cint): cstring {.
    importc: "g_time_zone_get_abbreviation", libglib.}
proc abbreviation*(tz: GTimeZone; interval: cint): cstring {.
    importc: "g_time_zone_get_abbreviation", libglib.}
proc getOffset*(tz: GTimeZone; interval: cint): int32 {.
    importc: "g_time_zone_get_offset", libglib.}
proc offset*(tz: GTimeZone; interval: cint): int32 {.
    importc: "g_time_zone_get_offset", libglib.}
proc isDst*(tz: GTimeZone; interval: cint): Gboolean {.
    importc: "g_time_zone_is_dst", libglib.}

const
  G_TIME_SPAN_DAY* = (int64(86400000000'i64))

const
  G_TIME_SPAN_HOUR* = (int64(3600000000'i64))

const
  G_TIME_SPAN_MINUTE* = (int64(60000000))

const
  G_TIME_SPAN_SECOND* = (int64(1000000))

const
  G_TIME_SPAN_MILLISECOND* = (int64(1000))

type
  GTimeSpan* = int64

type
  GDateTime* =  ptr GDateTimeObj
  GDateTimePtr* = ptr GDateTimeObj
  GDateTimeObj* = object

proc unref*(datetime: GDateTime) {.importc: "g_date_time_unref",
    libglib.}
proc `ref`*(datetime: GDateTime): GDateTime {.
    importc: "g_date_time_ref", libglib.}
proc newDateTime*(tz: GTimeZone): GDateTime {.
    importc: "g_date_time_new_now", libglib.}
proc newDateTime*(): GDateTime {.importc: "g_date_time_new_now_local",
    libglib.}
proc newDateTimeNowUTC*(): GDateTime {.importc: "g_date_time_new_now_utc",
                                        libglib.}
proc newDateTimeFromUnixLocal*(t: int64): GDateTime {.
    importc: "g_date_time_new_from_unix_local", libglib.}
proc newDateTimeFromUnixUTC*(t: int64): GDateTime {.
    importc: "g_date_time_new_from_unix_utc", libglib.}
proc newDateTimeFromTimeValLocal*(tv: GTimeVal): GDateTime {.
    importc: "g_date_time_new_from_timeval_local", libglib.}
proc newDateTimeFromTimeValUTC*(tv: GTimeVal): GDateTime {.
    importc: "g_date_time_new_from_timeval_utc", libglib.}
proc newDateTime*(tz: GTimeZone; year: cint; month: cint; day: cint; hour: cint;
                  minute: cint; seconds: cdouble): GDateTime {.
    importc: "g_date_time_new", libglib.}
proc newDateTimeLocal*(year: cint; month: cint; day: cint; hour: cint; minute: cint;
                       seconds: cdouble): GDateTime {.
    importc: "g_date_time_new_local", libglib.}
proc newDateTimeUTC*(year: cint; month: cint; day: cint; hour: cint; minute: cint;
                     seconds: cdouble): GDateTime {.
    importc: "g_date_time_new_utc", libglib.}
proc add*(datetime: GDateTime; timespan: GTimeSpan): GDateTime {.
    importc: "g_date_time_add", libglib.}
proc addYears*(datetime: GDateTime; years: cint): GDateTime {.
    importc: "g_date_time_add_years", libglib.}
proc addMonths*(datetime: GDateTime; months: cint): GDateTime {.
    importc: "g_date_time_add_months", libglib.}
proc addWeeks*(datetime: GDateTime; weeks: cint): GDateTime {.
    importc: "g_date_time_add_weeks", libglib.}
proc addDays*(datetime: GDateTime; days: cint): GDateTime {.
    importc: "g_date_time_add_days", libglib.}
proc addHours*(datetime: GDateTime; hours: cint): GDateTime {.
    importc: "g_date_time_add_hours", libglib.}
proc addMinutes*(datetime: GDateTime; minutes: cint): GDateTime {.
    importc: "g_date_time_add_minutes", libglib.}
proc addSeconds*(datetime: GDateTime; seconds: cdouble): GDateTime {.
    importc: "g_date_time_add_seconds", libglib.}
proc addFull*(datetime: GDateTime; years: cint; months: cint; days: cint;
                      hours: cint; minutes: cint; seconds: cdouble): GDateTime {.
    importc: "g_date_time_add_full", libglib.}
proc dateTimeCompare*(dt1: Gconstpointer; dt2: Gconstpointer): cint {.
    importc: "g_date_time_compare", libglib.}
proc difference*(`end`: GDateTime; begin: GDateTime): GTimeSpan {.
    importc: "g_date_time_difference", libglib.}
proc dateTimeHash*(datetime: Gconstpointer): cuint {.importc: "g_date_time_hash",
    libglib.}
proc dateTimeEqual*(dt1: Gconstpointer; dt2: Gconstpointer): Gboolean {.
    importc: "g_date_time_equal", libglib.}
proc getYmd*(datetime: GDateTime; year: var cint; month: var cint;
                     day: var cint) {.importc: "g_date_time_get_ymd", libglib.}
proc getYear*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_year", libglib.}
proc year*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_year", libglib.}
proc getMonth*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_month", libglib.}
proc month*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_month", libglib.}
proc getDayOfMonth*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_day_of_month", libglib.}
proc dayOfMonth*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_day_of_month", libglib.}
proc getWeekNumberingYear*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_week_numbering_year", libglib.}
proc weekNumberingYear*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_week_numbering_year", libglib.}
proc getWeekOfYear*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_week_of_year", libglib.}
proc weekOfYear*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_week_of_year", libglib.}
proc getDayOfWeek*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_day_of_week", libglib.}
proc dayOfWeek*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_day_of_week", libglib.}
proc getDayOfYear*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_day_of_year", libglib.}
proc dayOfYear*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_day_of_year", libglib.}
proc getHour*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_hour", libglib.}
proc hour*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_hour", libglib.}
proc getMinute*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_minute", libglib.}
proc minute*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_minute", libglib.}
proc getSecond*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_second", libglib.}
proc second*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_second", libglib.}
proc getMicrosecond*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_microsecond", libglib.}
proc microsecond*(datetime: GDateTime): cint {.
    importc: "g_date_time_get_microsecond", libglib.}
proc getSeconds*(datetime: GDateTime): cdouble {.
    importc: "g_date_time_get_seconds", libglib.}
proc seconds*(datetime: GDateTime): cdouble {.
    importc: "g_date_time_get_seconds", libglib.}
proc toUnix*(datetime: GDateTime): int64 {.
    importc: "g_date_time_to_unix", libglib.}
proc toTimeval*(datetime: GDateTime; tv: GTimeVal): Gboolean {.
    importc: "g_date_time_to_timeval", libglib.}
proc getUtcOffset*(datetime: GDateTime): GTimeSpan {.
    importc: "g_date_time_get_utc_offset", libglib.}
proc utcOffset*(datetime: GDateTime): GTimeSpan {.
    importc: "g_date_time_get_utc_offset", libglib.}
proc getTimezoneAbbreviation*(datetime: GDateTime): cstring {.
    importc: "g_date_time_get_timezone_abbreviation", libglib.}
proc timezoneAbbreviation*(datetime: GDateTime): cstring {.
    importc: "g_date_time_get_timezone_abbreviation", libglib.}
proc isDaylightSavings*(datetime: GDateTime): Gboolean {.
    importc: "g_date_time_is_daylight_savings", libglib.}
proc toTimezone*(datetime: GDateTime; tz: GTimeZone): GDateTime {.
    importc: "g_date_time_to_timezone", libglib.}
proc toLocal*(datetime: GDateTime): GDateTime {.
    importc: "g_date_time_to_local", libglib.}
proc toUtc*(datetime: GDateTime): GDateTime {.
    importc: "g_date_time_to_utc", libglib.}
proc format*(datetime: GDateTime; format: cstring): cstring {.
    importc: "g_date_time_format", libglib.}

type
  GDir* =  ptr GDirObj
  GDirPtr* = ptr GDirObj
  GDirObj* = object

proc dirOpen*(path: cstring; flags: cuint; error: var GError): GDir {.
    importc: "g_dir_open", libglib.}
proc readName*(dir: GDir): cstring {.importc: "g_dir_read_name", libglib.}
proc rewind*(dir: GDir) {.importc: "g_dir_rewind", libglib.}
proc close*(dir: GDir) {.importc: "g_dir_close", libglib.}

proc getenv*(variable: cstring): cstring {.importc: "g_getenv", libglib.}
proc setenv*(variable: cstring; value: cstring; overwrite: Gboolean): Gboolean {.
    importc: "g_setenv", libglib.}
proc unsetenv*(variable: cstring) {.importc: "g_unsetenv", libglib.}
proc listenv*(): cstringArray {.importc: "g_listenv", libglib.}
proc getEnviron*(): cstringArray {.importc: "g_get_environ", libglib.}
proc environ*(): cstringArray {.importc: "g_get_environ", libglib.}
proc environGetenv*(envp: cstringArray; variable: cstring): cstring {.
    importc: "g_environ_getenv", libglib.}
proc environSetenv*(envp: cstringArray; variable: cstring; value: cstring;
                    overwrite: Gboolean): cstringArray {.
    importc: "g_environ_setenv", libglib.}
proc environUnsetenv*(envp: cstringArray; variable: cstring): cstringArray {.
    importc: "g_environ_unsetenv", libglib.}

type
  GFileError* {.size: sizeof(cint), pure.} = enum
    EXIST, ISDIR, ACCES,
    NAMETOOLONG, NOENT, NOTDIR,
    NXIO, NODEV, ROFS, TXTBSY,
    FAULT, LOOP, NOSPC, NOMEM,
    MFILE, NFILE, BADF, INVAL,
    PIPE, AGAIN, INTR, IO,
    PERM, NOSYS, FAILED

type
  GFileTest* {.size: sizeof(cint), pure.} = enum
    IS_REGULAR = 1 shl 0, IS_SYMLINK = 1 shl 1,
    IS_DIR = 1 shl 2, IS_EXECUTABLE = 1 shl 3,
    EXISTS = 1 shl 4

proc fileErrorQuark*(): GQuark {.importc: "g_file_error_quark", libglib.}

proc fileErrorFromErrno*(errNo: cint): GFileError {.
    importc: "g_file_error_from_errno", libglib.}
proc fileTest*(filename: cstring; test: GFileTest): Gboolean {.
    importc: "g_file_test", libglib.}
proc fileGetContents*(filename: cstring; contents: cstringArray; length: var Gsize;
                      error: var GError): Gboolean {.
    importc: "g_file_get_contents", libglib.}
proc fileSetContents*(filename: cstring; contents: cstring; length: Gssize;
                      error: var GError): Gboolean {.
    importc: "g_file_set_contents", libglib.}
proc fileReadLink*(filename: cstring; error: var GError): cstring {.
    importc: "g_file_read_link", libglib.}

proc mkdtemp*(tmpl: cstring): cstring {.importc: "g_mkdtemp", libglib.}
proc mkdtempFull*(tmpl: cstring; mode: cint): cstring {.importc: "g_mkdtemp_full",
    libglib.}

proc mkstemp*(tmpl: cstring): cint {.importc: "g_mkstemp", libglib.}
proc mkstempFull*(tmpl: cstring; flags: cint; mode: cint): cint {.
    importc: "g_mkstemp_full", libglib.}

proc fileOpenTmp*(tmpl: cstring; nameUsed: cstringArray; error: var GError): cint {.
    importc: "g_file_open_tmp", libglib.}
proc dirMakeTmp*(tmpl: cstring; error: var GError): cstring {.
    importc: "g_dir_make_tmp", libglib.}
proc buildPath*(separator: cstring; firstElement: cstring): cstring {.varargs,
    importc: "g_build_path", libglib.}
proc buildPathv*(separator: cstring; args: cstringArray): cstring {.
    importc: "g_build_pathv", libglib.}
proc buildFilename*(firstElement: cstring): cstring {.varargs,
    importc: "g_build_filename", libglib.}
proc buildFilenamev*(args: cstringArray): cstring {.importc: "g_build_filenamev",
    libglib.}
proc mkdirWithParents*(pathname: cstring; mode: cint): cint {.
    importc: "g_mkdir_with_parents", libglib.}
when defined(windows):
  const
    G_DIR_SEPARATOR* = '\x08'
    G_DIR_SEPARATOR_S* = "\x08"
  template gIsDirSeparator*(c: untyped): untyped =
    (c == G_DIR_SEPARATOR or (c) == '/')

  const
    G_SEARCHPATH_SEPARATOR* = ';'
    G_SEARCHPATH_SEPARATOR_S* = ";"
else:
  const
    G_DIR_SEPARATOR* = '/'
    G_DIR_SEPARATOR_S* = "/"
  template gIsDirSeparator*(c: untyped): untyped =
    (c == G_DIR_SEPARATOR)

  const
    G_SEARCHPATH_SEPARATOR* = ':'
    G_SEARCHPATH_SEPARATOR_S* = ":"
proc pathIsAbsolute*(fileName: cstring): Gboolean {.importc: "g_path_is_absolute",
    libglib.}
proc pathSkipRoot*(fileName: cstring): cstring {.importc: "g_path_skip_root",
    libglib.}
proc basename*(fileName: cstring): cstring {.importc: "g_basename", libglib.}
proc getCurrentDir*(): cstring {.importc: "g_get_current_dir", libglib.}
proc currentDir*(): cstring {.importc: "g_get_current_dir", libglib.}
proc pathGetBasename*(fileName: cstring): cstring {.importc: "g_path_get_basename",
    libglib.}
proc pathGetDirname*(fileName: cstring): cstring {.importc: "g_path_get_dirname",
    libglib.}
when not (G_DISABLE_DEPRECATED):
  const
    gDirname* = pathGetDirname

proc ipContext*(msgid: cstring; msgval: cstring): cstring {.
    importc: "g_strip_context", libglib.}
proc dgettext*(domain: cstring; msgid: cstring): cstring {.importc: "g_dgettext",
    libglib.}
proc dcgettext*(domain: cstring; msgid: cstring; category: cint): cstring {.
    importc: "g_dcgettext", libglib.}
proc dngettext*(domain: cstring; msgid: cstring; msgidPlural: cstring; n: culong): cstring {.
    importc: "g_dngettext", libglib.}
proc dpgettext*(domain: cstring; msgctxtid: cstring; msgidoffset: Gsize): cstring {.
    importc: "g_dpgettext", libglib.}
proc dpgettext2*(domain: cstring; context: cstring; msgid: cstring): cstring {.
    importc: "g_dpgettext2", libglib.}

proc free*(mem: Gpointer) {.importc: "g_free", libglib.}
proc clearPointer*(pp: var Gpointer; destroy: GDestroyNotify) {.
    importc: "g_clear_pointer", libglib.}
proc malloc*(nBytes: Gsize): Gpointer {.importc: "g_malloc", libglib.}
proc malloc0*(nBytes: Gsize): Gpointer {.importc: "g_malloc0", libglib.}
proc realloc*(mem: Gpointer; nBytes: Gsize): Gpointer {.importc: "g_realloc",
    libglib.}
proc tryMalloc*(nBytes: Gsize): Gpointer {.importc: "g_try_malloc", libglib.}
proc tryMalloc0*(nBytes: Gsize): Gpointer {.importc: "g_try_malloc0", libglib.}
proc tryRealloc*(mem: Gpointer; nBytes: Gsize): Gpointer {.importc: "g_try_realloc",
    libglib.}
proc mallocN*(nBlocks: Gsize; nBlockBytes: Gsize): Gpointer {.importc: "g_malloc_n",
    libglib.}
proc malloc0N*(nBlocks: Gsize; nBlockBytes: Gsize): Gpointer {.
    importc: "g_malloc0_n", libglib.}
proc reallocN*(mem: Gpointer; nBlocks: Gsize; nBlockBytes: Gsize): Gpointer {.
    importc: "g_realloc_n", libglib.}
proc tryMallocN*(nBlocks: Gsize; nBlockBytes: Gsize): Gpointer {.
    importc: "g_try_malloc_n", libglib.}
proc tryMalloc0N*(nBlocks: Gsize; nBlockBytes: Gsize): Gpointer {.
    importc: "g_try_malloc0_n", libglib.}
proc tryReallocN*(mem: Gpointer; nBlocks: Gsize; nBlockBytes: Gsize): Gpointer {.
    importc: "g_try_realloc_n", libglib.}

proc stealPointer*(pp: Gpointer): Gpointer {.inline.} =
  var `ptr`: ptr Gpointer
  var `ref`: Gpointer
  `ref` = `ptr`[]
  `ptr`[] = nil
  return `ref`

template gStealPointer*(pp: untyped): untyped =
  (if 0: (pp[]) else: (gStealPointer)(pp))

type
  GMemVTable* =  ptr GMemVTableObj
  GMemVTablePtr* = ptr GMemVTableObj
  GMemVTableObj* = object
    malloc*: proc (nBytes: Gsize): Gpointer {.cdecl.}
    realloc*: proc (mem: Gpointer; nBytes: Gsize): Gpointer {.cdecl.}
    free*: proc (mem: Gpointer) {.cdecl.}
    calloc*: proc (nBlocks: Gsize; nBlockBytes: Gsize): Gpointer {.cdecl.}
    tryMalloc*: proc (nBytes: Gsize): Gpointer {.cdecl.}
    tryRealloc*: proc (mem: Gpointer; nBytes: Gsize): Gpointer {.cdecl.}

proc memSetVtable*(vtable: GMemVTable) {.importc: "g_mem_set_vtable", libglib.}
proc memIsSystemMalloc*(): Gboolean {.importc: "g_mem_is_system_malloc", libglib.}

proc memProfile*() {.importc: "g_mem_profile", libglib.}

type
  GTraverseFlags* {.size: sizeof(cint), pure.} = enum
    LEAVES = 1 shl 0, NON_LEAVES = 1 shl 1,
    ALL = GTraverseFlags.LEAVES.ord or GTraverseFlags.NON_LEAVES.ord
const
  G_TRAVERSE_MASK = GTraverseFlags.ALL
  G_TRAVERSE_LEAFS = GTraverseFlags.LEAVES
  G_TRAVERSE_NON_LEAFS = GTraverseFlags.NON_LEAVES

type
  GTraverseType* {.size: sizeof(cint), pure.} = enum
    IN_ORDER, PRE_ORDER, POST_ORDER, LEVEL_ORDER
  GNodeTraverseFunc* = proc (node: GNode; data: Gpointer): Gboolean {.cdecl.}
  GNodeForeachFunc* = proc (node: GNode; data: Gpointer) {.cdecl.}

  GCopyFunc* = proc (src: Gconstpointer; data: Gpointer): Gpointer {.cdecl.}

  GNode* =  ptr GNodeObj
  GNodePtr* = ptr GNodeObj
  GNodeObj* = object
    data*: Gpointer
    next*: GNode
    prev*: GNode
    parent*: GNode
    children*: GNode

template gNodeIsRoot*(node: untyped): untyped =
  ((cast[GNode](node)).parent == nil and
      (cast[GNode](node)).prev == nil and
      (cast[GNode](node)).next == nil)

template gNodeIsLeaf*(node: untyped): untyped =
  ((cast[GNode](node)).children == nil)

proc newNode*(data: Gpointer): GNode {.importc: "g_node_new", libglib.}
proc destroy*(root: GNode) {.importc: "g_node_destroy", libglib.}
proc unlink*(node: GNode) {.importc: "g_node_unlink", libglib.}
proc copyDeep*(node: GNode; copyFunc: GCopyFunc; data: Gpointer): GNode {.
    importc: "g_node_copy_deep", libglib.}
proc copy*(node: GNode): GNode {.importc: "g_node_copy", libglib.}
proc insert*(parent: GNode; position: cint; node: GNode): GNode {.
    importc: "g_node_insert", libglib.}
proc insertBefore*(parent: GNode; sibling: GNode; node: GNode): GNode {.
    importc: "g_node_insert_before", libglib.}
proc insertAfter*(parent: GNode; sibling: GNode; node: GNode): GNode {.
    importc: "g_node_insert_after", libglib.}
proc prepend*(parent: GNode; node: GNode): GNode {.
    importc: "g_node_prepend", libglib.}
proc nNodes*(root: GNode; flags: GTraverseFlags): cuint {.
    importc: "g_node_n_nodes", libglib.}
proc getRoot*(node: GNode): GNode {.importc: "g_node_get_root", libglib.}
proc root*(node: GNode): GNode {.importc: "g_node_get_root", libglib.}
proc isAncestor*(node: GNode; descendant: GNode): Gboolean {.
    importc: "g_node_is_ancestor", libglib.}
proc depth*(node: GNode): cuint {.importc: "g_node_depth", libglib.}
proc find*(root: GNode; order: GTraverseType; flags: GTraverseFlags;
               data: Gpointer): GNode {.importc: "g_node_find", libglib.}

template gNodeAppend*(parent, node: untyped): untyped =
  insertBefore(parent, nil, node)

template gNodeInsertData*(parent, position, data: untyped): untyped =
  insert(parent, position, new(data))

template gNodeInsertDataAfter*(parent, sibling, data: untyped): untyped =
  insertAfter(parent, sibling, new(data))

template gNodeInsertDataBefore*(parent, sibling, data: untyped): untyped =
  insertBefore(parent, sibling, new(data))

template gNodePrependData*(parent, data: untyped): untyped =
  prepend(parent, new(data))

template gNodeAppendData*(parent, data: untyped): untyped =
  insertBefore(parent, nil, new(data))

proc traverse*(root: GNode; order: GTraverseType; flags: GTraverseFlags;
                   maxDepth: cint; `func`: GNodeTraverseFunc; data: Gpointer) {.
    importc: "g_node_traverse", libglib.}

proc maxHeight*(root: GNode): cuint {.importc: "g_node_max_height",
    libglib.}
proc childrenForeach*(node: GNode; flags: GTraverseFlags;
                          `func`: GNodeForeachFunc; data: Gpointer) {.
    importc: "g_node_children_foreach", libglib.}
proc reverseChildren*(node: GNode) {.importc: "g_node_reverse_children",
    libglib.}
proc nChildren*(node: GNode): cuint {.importc: "g_node_n_children",
    libglib.}
proc nthChild*(node: GNode; n: cuint): GNode {.importc: "g_node_nth_child",
    libglib.}
proc lastChild*(node: GNode): GNode {.importc: "g_node_last_child",
    libglib.}
proc findChild*(node: GNode; flags: GTraverseFlags; data: Gpointer): GNode {.
    importc: "g_node_find_child", libglib.}
proc childPosition*(node: GNode; child: GNode): cint {.
    importc: "g_node_child_position", libglib.}
proc childIndex*(node: GNode; data: Gpointer): cint {.
    importc: "g_node_child_index", libglib.}
proc firstSibling*(node: GNode): GNode {.importc: "g_node_first_sibling",
    libglib.}
proc lastSibling*(node: GNode): GNode {.importc: "g_node_last_sibling",
    libglib.}

template gNodePrevSibling*(node: untyped): untyped =
  (if (node): (cast[GNode](node)).prev else: nil)

template gNodeNextSibling*(node: untyped): untyped =
  (if (node): (cast[GNode](node)).next else: nil)

template gNodeFirstChild*(node: untyped): untyped =
  (if (node): (cast[GNode](node)).children else: nil)

type
  GList* =  ptr GListObj
  GListPtr* = ptr GListObj
  GListObj* = object
    data*: Gpointer
    next*: GList
    prev*: GList

proc listAlloc*(): GList {.importc: "g_list_alloc", libglib.}
proc free*(list: GList) {.importc: "g_list_free", libglib.}
proc free1*(list: GList) {.importc: "g_list_free_1", libglib.}
proc freeFull*(list: GList; freeFunc: GDestroyNotify) {.
    importc: "g_list_free_full", libglib.}
proc append*(list: GList; data: Gpointer): GList {.
    importc: "g_list_append", libglib.}
proc prepend*(list: GList; data: Gpointer): GList {.
    importc: "g_list_prepend", libglib.}
proc insert*(list: GList; data: Gpointer; position: cint): GList {.
    importc: "g_list_insert", libglib.}
proc insertSorted*(list: GList; data: Gpointer; `func`: GCompareFunc): GList {.
    importc: "g_list_insert_sorted", libglib.}
proc insertSortedWithData*(list: GList; data: Gpointer;
                               `func`: GCompareDataFunc; userData: Gpointer): GList {.
    importc: "g_list_insert_sorted_with_data", libglib.}
proc insertBefore*(list: GList; sibling: GList; data: Gpointer): GList {.
    importc: "g_list_insert_before", libglib.}
proc concat*(list1: GList; list2: GList): GList {.
    importc: "g_list_concat", libglib.}
proc remove*(list: GList; data: Gconstpointer): GList {.
    importc: "g_list_remove", libglib.}
proc removeAll*(list: GList; data: Gconstpointer): GList {.
    importc: "g_list_remove_all", libglib.}
proc removeLink*(list: GList; llink: GList): GList {.
    importc: "g_list_remove_link", libglib.}
proc deleteLink*(list: GList; link: GList): GList {.
    importc: "g_list_delete_link", libglib.}
proc reverse*(list: GList): GList {.importc: "g_list_reverse", libglib.}
proc copy*(list: GList): GList {.importc: "g_list_copy", libglib.}
proc copyDeep*(list: GList; `func`: GCopyFunc; userData: Gpointer): GList {.
    importc: "g_list_copy_deep", libglib.}
proc nth*(list: GList; n: cuint): GList {.importc: "g_list_nth", libglib.}
proc nthPrev*(list: GList; n: cuint): GList {.importc: "g_list_nth_prev",
    libglib.}
proc find*(list: GList; data: Gconstpointer): GList {.
    importc: "g_list_find", libglib.}
proc findCustom*(list: GList; data: Gconstpointer; `func`: GCompareFunc): GList {.
    importc: "g_list_find_custom", libglib.}
proc position*(list: GList; llink: GList): cint {.
    importc: "g_list_position", libglib.}
proc index*(list: GList; data: Gconstpointer): cint {.importc: "g_list_index",
    libglib.}
proc last*(list: GList): GList {.importc: "g_list_last", libglib.}
proc first*(list: GList): GList {.importc: "g_list_first", libglib.}
proc length*(list: GList): cuint {.importc: "g_list_length", libglib.}
proc foreach*(list: GList; `func`: GFunc; userData: Gpointer) {.
    importc: "g_list_foreach", libglib.}
proc sort*(list: GList; compareFunc: GCompareFunc): GList {.
    importc: "g_list_sort", libglib.}
proc sortWithData*(list: GList; compareFunc: GCompareDataFunc;
                       userData: Gpointer): GList {.
    importc: "g_list_sort_with_data", libglib.}
proc nthData*(list: GList; n: cuint): Gpointer {.importc: "g_list_nth_data",
    libglib.}
proc previous*(list: GList): GList {.inline.} =
  if list != nil: list.prev else: nil

proc next*(list: GList): GList {.inline.} =
  if list != nil: list.next else: nil

type
  GHashTable* =  ptr GHashTableObj
  GHashTablePtr* = ptr GHashTableObj
  GHashTableObj* = object

  GHRFunc* = proc (key: Gpointer; value: Gpointer; userData: Gpointer): Gboolean {.cdecl.}
  GHashTableIter* =  ptr GHashTableIterObj
  GHashTableIterPtr* = ptr GHashTableIterObj
  GHashTableIterObj* = object
    dummy1: Gpointer
    dummy2: Gpointer
    dummy3: Gpointer
    dummy4: cint
    dummy5: Gboolean
    dummy6: Gpointer

proc newHashTable*(hashFunc: GHashFunc; keyEqualFunc: GEqualFunc): GHashTable {.
    importc: "g_hash_table_new", libglib.}
proc newHashTable*(hashFunc: GHashFunc; keyEqualFunc: GEqualFunc;
                       keyDestroyFunc: GDestroyNotify;
                       valueDestroyFunc: GDestroyNotify): GHashTable {.
    importc: "g_hash_table_new_full", libglib.}
proc destroy*(hashTable: GHashTable) {.
    importc: "g_hash_table_destroy", libglib.}
proc insert*(hashTable: GHashTable; key: Gpointer; value: Gpointer): Gboolean {.
    importc: "g_hash_table_insert", libglib.}
proc replace*(hashTable: GHashTable; key: Gpointer; value: Gpointer): Gboolean {.
    importc: "g_hash_table_replace", libglib.}
proc add*(hashTable: GHashTable; key: Gpointer): Gboolean {.
    importc: "g_hash_table_add", libglib.}
proc remove*(hashTable: GHashTable; key: Gconstpointer): Gboolean {.
    importc: "g_hash_table_remove", libglib.}
proc removeAll*(hashTable: GHashTable) {.
    importc: "g_hash_table_remove_all", libglib.}
proc steal*(hashTable: GHashTable; key: Gconstpointer): Gboolean {.
    importc: "g_hash_table_steal", libglib.}
proc stealAll*(hashTable: GHashTable) {.
    importc: "g_hash_table_steal_all", libglib.}
proc lookup*(hashTable: GHashTable; key: Gconstpointer): Gpointer {.
    importc: "g_hash_table_lookup", libglib.}
proc contains*(hashTable: GHashTable; key: Gconstpointer): Gboolean {.
    importc: "g_hash_table_contains", libglib.}
proc lookupExtended*(hashTable: GHashTable; lookupKey: Gconstpointer;
                              origKey: ptr Gpointer; value: var Gpointer): Gboolean {.
    importc: "g_hash_table_lookup_extended", libglib.}
proc foreach*(hashTable: GHashTable; `func`: GHFunc; userData: Gpointer) {.
    importc: "g_hash_table_foreach", libglib.}
proc find*(hashTable: GHashTable; predicate: GHRFunc; userData: Gpointer): Gpointer {.
    importc: "g_hash_table_find", libglib.}
proc foreachRemove*(hashTable: GHashTable; `func`: GHRFunc;
                             userData: Gpointer): cuint {.
    importc: "g_hash_table_foreach_remove", libglib.}
proc foreachSteal*(hashTable: GHashTable; `func`: GHRFunc;
                            userData: Gpointer): cuint {.
    importc: "g_hash_table_foreach_steal", libglib.}
proc size*(hashTable: GHashTable): cuint {.
    importc: "g_hash_table_size", libglib.}
proc getKeys*(hashTable: GHashTable): GList {.
    importc: "g_hash_table_get_keys", libglib.}
proc keys*(hashTable: GHashTable): GList {.
    importc: "g_hash_table_get_keys", libglib.}
proc getValues*(hashTable: GHashTable): GList {.
    importc: "g_hash_table_get_values", libglib.}
proc values*(hashTable: GHashTable): GList {.
    importc: "g_hash_table_get_values", libglib.}
proc getKeysAsArray*(hashTable: GHashTable; length: var cuint): ptr Gpointer {.
    importc: "g_hash_table_get_keys_as_array", libglib.}
proc keysAsArray*(hashTable: GHashTable; length: var cuint): ptr Gpointer {.
    importc: "g_hash_table_get_keys_as_array", libglib.}
proc init*(iter: GHashTableIter; hashTable: GHashTable) {.
    importc: "g_hash_table_iter_init", libglib.}
proc next*(iter: GHashTableIter; key: ptr Gpointer;
                        value: ptr Gpointer): Gboolean {.
    importc: "g_hash_table_iter_next", libglib.}
proc getHashTable*(iter: GHashTableIter): GHashTable {.
    importc: "g_hash_table_iter_get_hash_table", libglib.}
proc hashTable*(iter: GHashTableIter): GHashTable {.
    importc: "g_hash_table_iter_get_hash_table", libglib.}
proc remove*(iter: GHashTableIter) {.
    importc: "g_hash_table_iter_remove", libglib.}
proc replace*(iter: GHashTableIter; value: Gpointer) {.
    importc: "g_hash_table_iter_replace", libglib.}
proc steal*(iter: GHashTableIter) {.
    importc: "g_hash_table_iter_steal", libglib.}
proc `ref`*(hashTable: GHashTable): GHashTable {.
    importc: "g_hash_table_ref", libglib.}
proc unref*(hashTable: GHashTable) {.importc: "g_hash_table_unref",
    libglib.}
when not (G_DISABLE_DEPRECATED):
  template gHashTableFreeze*(hashTable: untyped): untyped =
    (cast[nil](0))

  template gHashTableThaw*(hashTable: untyped): untyped =
    (cast[nil](0))

proc strEqual*(v1: Gconstpointer; v2: Gconstpointer): Gboolean {.
    importc: "g_str_equal", libglib.}
proc strHash*(v: Gconstpointer): cuint {.importc: "g_str_hash", libglib.}
proc intEqual*(v1: Gconstpointer; v2: Gconstpointer): Gboolean {.
    importc: "g_int_equal", libglib.}
proc intHash*(v: Gconstpointer): cuint {.importc: "g_int_hash", libglib.}
proc int64Equal*(v1: Gconstpointer; v2: Gconstpointer): Gboolean {.
    importc: "g_int64_equal", libglib.}
proc int64Hash*(v: Gconstpointer): cuint {.importc: "g_int64_hash", libglib.}
proc doubleEqual*(v1: Gconstpointer; v2: Gconstpointer): Gboolean {.
    importc: "g_double_equal", libglib.}
proc doubleHash*(v: Gconstpointer): cuint {.importc: "g_double_hash", libglib.}
proc directHash*(v: Gconstpointer): cuint {.importc: "g_direct_hash", libglib.}
proc directEqual*(v1: Gconstpointer; v2: Gconstpointer): Gboolean {.
    importc: "g_direct_equal", libglib.}

type
  GHmac* =  ptr GHmacObj
  GHmacPtr* = ptr GHmacObj
  GHmacObj* = object

proc newHmac*(digestType: GChecksumType; key: var cuchar; keyLen: Gsize): GHmac {.
    importc: "g_hmac_new", libglib.}
proc copy*(hmac: GHmac): GHmac {.importc: "g_hmac_copy", libglib.}
proc `ref`*(hmac: GHmac): GHmac {.importc: "g_hmac_ref", libglib.}
proc unref*(hmac: GHmac) {.importc: "g_hmac_unref", libglib.}
proc update*(hmac: GHmac; data: var cuchar; length: Gssize) {.
    importc: "g_hmac_update", libglib.}
proc getString*(hmac: GHmac): cstring {.importc: "g_hmac_get_string",
    libglib.}
proc getDigest*(hmac: GHmac; buffer: var uint8; digestLen: var Gsize) {.
    importc: "g_hmac_get_digest", libglib.}
proc computeHmacForData*(digestType: GChecksumType; key: var cuchar; keyLen: Gsize;
                         data: var cuchar; length: Gsize): cstring {.
    importc: "g_compute_hmac_for_data", libglib.}
proc computeHmacForString*(digestType: GChecksumType; key: var cuchar; keyLen: Gsize;
                           str: cstring; length: Gssize): cstring {.
    importc: "g_compute_hmac_for_string", libglib.}
proc computeHmacForBytes*(digestType: GChecksumType; key: GBytes;
                          data: GBytes): cstring {.
    importc: "g_compute_hmac_for_bytes", libglib.}

const
  G_HOOK_FLAG_USER_SHIFT* = 4

type
  GHookCompareFunc* = proc (newHook: GHook; sibling: GHook): cint {.cdecl.}
  GHookFindFunc* = proc (hook: GHook; data: Gpointer): Gboolean {.cdecl.}
  GHookMarshaller* = proc (hook: GHook; marshalData: Gpointer) {.cdecl.}
  GHookCheckMarshaller* = proc (hook: GHook; marshalData: Gpointer): Gboolean {.cdecl.}
  GHookFunc* = proc (data: Gpointer) {.cdecl.}
  GHookCheckFunc* = proc (data: Gpointer): Gboolean {.cdecl.}
  GHookFinalizeFunc* = proc (hookList: GHookList; hook: GHook) {.cdecl.}
  GHookFlagMask* {.size: sizeof(cint), pure.} = enum
    ACTIVE = 1 shl 0, IN_CALL = 1 shl 1,
    MSK = 0xF

  GHookList* =  ptr GHookListObj
  GHookListPtr* = ptr GHookListObj
  GHookListObj* = object
    seqId*: culong
    hookSize* {.bitsize: 16.}: cuint
    isSetup* {.bitsize: 1.}: cuint
    hooks*: GHook
    dummy3: Gpointer
    finalizeHook*: GHookFinalizeFunc
    dummy: array[2, Gpointer]

  GHook* =  ptr GHookObj
  GHookPtr* = ptr GHookObj
  GHookObj* = object
    data*: Gpointer
    next*: GHook
    prev*: GHook
    refCount*: cuint
    hookId*: culong
    flags*: cuint
    `func`*: Gpointer
    destroy*: GDestroyNotify

template gHook*(hook: untyped): untyped =
  (cast[GHook](hook))

template gHookFlags*(hook: untyped): untyped =
  (gHook(hook).flags)

template gHookActive*(hook: untyped): untyped =
  ((gHookFlags(hook) and g_Hook_Flag_Active) != 0)

template gHookInCall*(hook: untyped): untyped =
  ((gHookFlags(hook) and g_Hook_Flag_In_Call) != 0)

template gHookIsValid*(hook: untyped): untyped =
  (gHook(hook).hookId != 0 and (gHookFlags(hook) and g_Hook_Flag_Active))

template gHookIsUnlinked*(hook: untyped): untyped =
  (gHook(hook).next == nil and gHook(hook).prev == nil and
      gHook(hook).hookId == 0 and gHook(hook).refCount == 0)

proc init*(hookList: GHookList; hookSize: cuint) {.
    importc: "g_hook_list_init", libglib.}
proc clear*(hookList: GHookList) {.importc: "g_hook_list_clear",
    libglib.}
proc hookAlloc*(hookList: GHookList): GHook {.importc: "g_hook_alloc",
    libglib.}
proc hookFree*(hookList: GHookList; hook: GHook) {.importc: "g_hook_free",
    libglib.}
proc hookRef*(hookList: GHookList; hook: GHook): GHook {.
    importc: "g_hook_ref", libglib.}
proc hookUnref*(hookList: GHookList; hook: GHook) {.importc: "g_hook_unref",
    libglib.}
proc hookDestroy*(hookList: GHookList; hookId: culong): Gboolean {.
    importc: "g_hook_destroy", libglib.}
proc hookDestroyLink*(hookList: GHookList; hook: GHook) {.
    importc: "g_hook_destroy_link", libglib.}
proc hookPrepend*(hookList: GHookList; hook: GHook) {.
    importc: "g_hook_prepend", libglib.}
proc hookInsertBefore*(hookList: GHookList; sibling: GHook; hook: GHook) {.
    importc: "g_hook_insert_before", libglib.}
proc hookInsertSorted*(hookList: GHookList; hook: GHook;
                       `func`: GHookCompareFunc) {.
    importc: "g_hook_insert_sorted", libglib.}
proc hookGet*(hookList: GHookList; hookId: culong): GHook {.
    importc: "g_hook_get", libglib.}
proc hookFind*(hookList: GHookList; needValids: Gboolean; `func`: GHookFindFunc;
               data: Gpointer): GHook {.importc: "g_hook_find", libglib.}
proc hookFindData*(hookList: GHookList; needValids: Gboolean; data: Gpointer): GHook {.
    importc: "g_hook_find_data", libglib.}
proc hookFindFunc*(hookList: GHookList; needValids: Gboolean; `func`: Gpointer): GHook {.
    importc: "g_hook_find_func", libglib.}
proc hookFindFuncData*(hookList: GHookList; needValids: Gboolean;
                       `func`: Gpointer; data: Gpointer): GHook {.
    importc: "g_hook_find_func_data", libglib.}

proc hookFirstValid*(hookList: GHookList; mayBeInCall: Gboolean): GHook {.
    importc: "g_hook_first_valid", libglib.}

proc hookNextValid*(hookList: GHookList; hook: GHook; mayBeInCall: Gboolean): GHook {.
    importc: "g_hook_next_valid", libglib.}

proc compareIds*(newHook: GHook; sibling: GHook): cint {.
    importc: "g_hook_compare_ids", libglib.}

template gHookAppend*(hookList, hook: untyped): untyped =
  hookInsertBefore(hookList, nil, hook)

proc invoke*(hookList: GHookList; mayRecurse: Gboolean) {.
    importc: "g_hook_list_invoke", libglib.}

proc invokeCheck*(hookList: GHookList; mayRecurse: Gboolean) {.
    importc: "g_hook_list_invoke_check", libglib.}

proc marshal*(hookList: GHookList; mayRecurse: Gboolean;
                      marshaller: GHookMarshaller; marshalData: Gpointer) {.
    importc: "g_hook_list_marshal", libglib.}
proc marshalCheck*(hookList: GHookList; mayRecurse: Gboolean;
                           marshaller: GHookCheckMarshaller; marshalData: Gpointer) {.
    importc: "g_hook_list_marshal_check", libglib.}

proc hostnameIsNonAscii*(hostname: cstring): Gboolean {.
    importc: "g_hostname_is_non_ascii", libglib.}
proc hostnameIsAsciiEncoded*(hostname: cstring): Gboolean {.
    importc: "g_hostname_is_ascii_encoded", libglib.}
proc hostnameIsIpAddress*(hostname: cstring): Gboolean {.
    importc: "g_hostname_is_ip_address", libglib.}
proc hostnameToAscii*(hostname: cstring): cstring {.importc: "g_hostname_to_ascii",
    libglib.}
proc hostnameToUnicode*(hostname: cstring): cstring {.
    importc: "g_hostname_to_unicode", libglib.}

when defined(windows) and GLIB_SIZEOF_VOID_P == 8:
  type
    GPollFD* =  ptr GPollFDObj
    GPollFDPtr* = ptr GPollFDObj
    GPollFDObj* = object
      fd*: int64
      events*: cushort
      revents*: cushort

else:
  type
    GPollFD* =  ptr GPollFDObj
    GPollFDPtr* = ptr GPollFDObj
    GPollFDObj* = object
      fd*: cint
      events*: cushort
      revents*: cushort

type
  GPollFunc* = proc (ufds: GPollFD; nfsd: cuint; timeout: cint): cint {.cdecl.}

proc poll*(fds: GPollFD; nfds: cuint; timeout: cint): cint {.importc: "g_poll",
    libglib.}

type
  GSList* =  ptr GSListObj
  GSListPtr* = ptr GSListObj
  GSListObj* = object
    data*: Gpointer
    next*: GSList

proc slistAlloc*(): GSList {.importc: "g_slist_alloc", libglib.}
proc free*(list: GSList) {.importc: "g_slist_free", libglib.}
proc free1*(list: GSList) {.importc: "g_slist_free_1", libglib.}
proc freeFull*(list: GSList; freeFunc: GDestroyNotify) {.
    importc: "g_slist_free_full", libglib.}
proc append*(list: GSList; data: Gpointer): GSList {.
    importc: "g_slist_append", libglib.}
proc prepend*(list: GSList; data: Gpointer): GSList {.
    importc: "g_slist_prepend", libglib.}
proc insert*(list: GSList; data: Gpointer; position: cint): GSList {.
    importc: "g_slist_insert", libglib.}
proc insertSorted*(list: GSList; data: Gpointer; `func`: GCompareFunc): GSList {.
    importc: "g_slist_insert_sorted", libglib.}
proc insertSortedWithData*(list: GSList; data: Gpointer;
                                `func`: GCompareDataFunc; userData: Gpointer): GSList {.
    importc: "g_slist_insert_sorted_with_data", libglib.}
proc insertBefore*(slist: GSList; sibling: GSList; data: Gpointer): GSList {.
    importc: "g_slist_insert_before", libglib.}
proc concat*(list1: GSList; list2: GSList): GSList {.
    importc: "g_slist_concat", libglib.}
proc remove*(list: GSList; data: Gconstpointer): GSList {.
    importc: "g_slist_remove", libglib.}
proc removeAll*(list: GSList; data: Gconstpointer): GSList {.
    importc: "g_slist_remove_all", libglib.}
proc removeLink*(list: GSList; link: GSList): GSList {.
    importc: "g_slist_remove_link", libglib.}
proc deleteLink*(list: GSList; link: GSList): GSList {.
    importc: "g_slist_delete_link", libglib.}
proc reverse*(list: GSList): GSList {.importc: "g_slist_reverse",
    libglib.}
proc copy*(list: GSList): GSList {.importc: "g_slist_copy", libglib.}
proc copyDeep*(list: GSList; `func`: GCopyFunc; userData: Gpointer): GSList {.
    importc: "g_slist_copy_deep", libglib.}
proc nth*(list: GSList; n: cuint): GSList {.importc: "g_slist_nth",
    libglib.}
proc find*(list: GSList; data: Gconstpointer): GSList {.
    importc: "g_slist_find", libglib.}
proc findCustom*(list: GSList; data: Gconstpointer; `func`: GCompareFunc): GSList {.
    importc: "g_slist_find_custom", libglib.}
proc position*(list: GSList; llink: GSList): cint {.
    importc: "g_slist_position", libglib.}
proc index*(list: GSList; data: Gconstpointer): cint {.
    importc: "g_slist_index", libglib.}
proc last*(list: GSList): GSList {.importc: "g_slist_last", libglib.}
proc length*(list: GSList): cuint {.importc: "g_slist_length", libglib.}
proc foreach*(list: GSList; `func`: GFunc; userData: Gpointer) {.
    importc: "g_slist_foreach", libglib.}
proc sort*(list: GSList; compareFunc: GCompareFunc): GSList {.
    importc: "g_slist_sort", libglib.}
proc sortWithData*(list: GSList; compareFunc: GCompareDataFunc;
                        userData: Gpointer): GSList {.
    importc: "g_slist_sort_with_data", libglib.}
proc nthData*(list: GSList; n: cuint): Gpointer {.
    importc: "g_slist_nth_data", libglib.}
template gSlistNext*(slist: untyped): untyped =
  (if (slist): ((cast[GSList](slist)).next) else: nil)

const
  GLIB_SYSDEF_POLLIN* = 1
  GLIB_SYSDEF_POLLOUT* = 4
  GLIB_SYSDEF_POLLPRI* = 2
  GLIB_SYSDEF_POLLHUP* = 16
  GLIB_SYSDEF_POLLERR* = 8
  GLIB_SYSDEF_POLLNVAL* = 32

type
  GIOCondition* {.size: sizeof(cint), pure.} = enum
    IN = GLIB_SYSDEF_POLLIN, PRI = GLIB_SYSDEF_POLLPRI,
    OUT = GLIB_SYSDEF_POLLOUT, ERR = GLIB_SYSDEF_POLLERR,
    HUP = GLIB_SYSDEF_POLLHUP, NVAL = GLIB_SYSDEF_POLLNVAL

type
  GMainContext* =  ptr GMainContextObj
  GMainContextPtr* = ptr GMainContextObj
  GMainContextObj* = object

type
  GMainLoop* =  ptr GMainLoopObj
  GMainLoopPtr* = ptr GMainLoopObj
  GMainLoopObj* = object

type
  GSourcePrivateObj = object

type
  GSourceFunc* = proc (userData: Gpointer): Gboolean {.cdecl.}

type
  GChildWatchFunc* = proc (pid: GPid; status: cint; userData: Gpointer) {.cdecl.}
  GSource* =  ptr GSourceObj
  GSourcePtr* = ptr GSourceObj
  GSourceObj* = object
    callbackData*: Gpointer
    callbackFuncs*: GSourceCallbackFuncs
    sourceFuncs*: GSourceFuncs
    refCount*: cuint
    context*: GMainContext
    priority*: cint
    flags*: cuint
    sourceId*: cuint
    pollFds*: GSList
    prev*: GSource
    next*: GSource
    name*: cstring
    priv*: ptr GSourcePrivateObj

  GSourceCallbackFuncs* =  ptr GSourceCallbackFuncsObj
  GSourceCallbackFuncsPtr* = ptr GSourceCallbackFuncsObj
  GSourceCallbackFuncsObj* = object
    `ref`*: proc (cbData: Gpointer) {.cdecl.}
    unref*: proc (cbData: Gpointer) {.cdecl.}
    get*: proc (cbData: Gpointer; source: GSource; `func`: ptr GSourceFunc;
              data: var Gpointer) {.cdecl.}

  GSourceDummyMarshal* = proc () {.cdecl.}
  GSourceFuncs* =  ptr GSourceFuncsObj
  GSourceFuncsPtr* = ptr GSourceFuncsObj
  GSourceFuncsObj* = object
    prepare*: proc (source: GSource; timeout: var cint): Gboolean {.cdecl.}
    check*: proc (source: GSource): Gboolean {.cdecl.}
    dispatch*: proc (source: GSource; callback: GSourceFunc; userData: Gpointer): Gboolean {.cdecl.}
    finalize*: proc (source: GSource) {.cdecl.}
    closureCallback*: GSourceFunc
    closureMarshal*: GSourceDummyMarshal

const
  G_PRIORITY_HIGH* = - 100

const
  G_PRIORITY_DEFAULT* = 0

const
  G_PRIORITY_HIGH_IDLE* = 100

const
  G_PRIORITY_DEFAULT_IDLE* = 200

const
  G_PRIORITY_LOW* = 300

const
  G_SOURCE_REMOVE* = false

const
  G_SOURCE_CONTINUE* = true

proc newMainContext*(): GMainContext {.importc: "g_main_context_new", libglib.}
proc `ref`*(context: GMainContext): GMainContext {.
    importc: "g_main_context_ref", libglib.}
proc unref*(context: GMainContext) {.
    importc: "g_main_context_unref", libglib.}
proc mainContextDefault*(): GMainContext {.importc: "g_main_context_default",
    libglib.}
proc iteration*(context: GMainContext; mayBlock: Gboolean): Gboolean {.
    importc: "g_main_context_iteration", libglib.}
proc pending*(context: GMainContext): Gboolean {.
    importc: "g_main_context_pending", libglib.}

proc findSourceById*(context: GMainContext; sourceId: cuint): GSource {.
    importc: "g_main_context_find_source_by_id", libglib.}
proc findSourceByUserData*(context: GMainContext; userData: Gpointer): GSource {.
    importc: "g_main_context_find_source_by_user_data", libglib.}
proc findSourceByFuncsUserData*(context: GMainContext;
    funcs: GSourceFuncs; userData: Gpointer): GSource {.
    importc: "g_main_context_find_source_by_funcs_user_data", libglib.}

proc wakeup*(context: GMainContext) {.
    importc: "g_main_context_wakeup", libglib.}
proc acquire*(context: GMainContext): Gboolean {.
    importc: "g_main_context_acquire", libglib.}
proc release*(context: GMainContext) {.
    importc: "g_main_context_release", libglib.}
proc isOwner*(context: GMainContext): Gboolean {.
    importc: "g_main_context_is_owner", libglib.}
proc wait*(context: GMainContext; cond: GCond; mutex: GMutex): Gboolean {.
    importc: "g_main_context_wait", libglib.}
proc prepare*(context: GMainContext; priority: var cint): Gboolean {.
    importc: "g_main_context_prepare", libglib.}
proc query*(context: GMainContext; maxPriority: cint;
                       timeout: var cint; fds: GPollFD; nFds: cint): cint {.
    importc: "g_main_context_query", libglib.}
proc check*(context: GMainContext; maxPriority: cint;
                       fds: GPollFD; nFds: cint): Gboolean {.
    importc: "g_main_context_check", libglib.}
proc dispatch*(context: GMainContext) {.
    importc: "g_main_context_dispatch", libglib.}
proc setPollFunc*(context: GMainContext; `func`: GPollFunc) {.
    importc: "g_main_context_set_poll_func", libglib.}
proc `pollFunc=`*(context: GMainContext; `func`: GPollFunc) {.
    importc: "g_main_context_set_poll_func", libglib.}
proc getPollFunc*(context: GMainContext): GPollFunc {.
    importc: "g_main_context_get_poll_func", libglib.}
proc pollFunc*(context: GMainContext): GPollFunc {.
    importc: "g_main_context_get_poll_func", libglib.}

proc addPoll*(context: GMainContext; fd: GPollFD; priority: cint) {.
    importc: "g_main_context_add_poll", libglib.}
proc removePoll*(context: GMainContext; fd: GPollFD) {.
    importc: "g_main_context_remove_poll", libglib.}
proc mainDepth*(): cint {.importc: "g_main_depth", libglib.}
proc mainCurrentSource*(): GSource {.importc: "g_main_current_source",
                                      libglib.}

proc pushThreadDefault*(context: GMainContext) {.
    importc: "g_main_context_push_thread_default", libglib.}
proc popThreadDefault*(context: GMainContext) {.
    importc: "g_main_context_pop_thread_default", libglib.}
proc mainContextGetThreadDefault*(): GMainContext {.
    importc: "g_main_context_get_thread_default", libglib.}
proc mainContextRefThreadDefault*(): GMainContext {.
    importc: "g_main_context_ref_thread_default", libglib.}

proc newMainLoop*(context: GMainContext; isRunning: Gboolean): GMainLoop {.
    importc: "g_main_loop_new", libglib.}
proc run*(loop: GMainLoop) {.importc: "g_main_loop_run", libglib.}
proc quit*(loop: GMainLoop) {.importc: "g_main_loop_quit", libglib.}
proc `ref`*(loop: GMainLoop): GMainLoop {.importc: "g_main_loop_ref",
    libglib.}
proc unref*(loop: GMainLoop) {.importc: "g_main_loop_unref", libglib.}
proc isRunning*(loop: GMainLoop): Gboolean {.
    importc: "g_main_loop_is_running", libglib.}
proc getContext*(loop: GMainLoop): GMainContext {.
    importc: "g_main_loop_get_context", libglib.}
proc context*(loop: GMainLoop): GMainContext {.
    importc: "g_main_loop_get_context", libglib.}

proc newSource*(sourceFuncs: GSourceFuncs; structSize: cuint): GSource {.
    importc: "g_source_new", libglib.}
proc `ref`*(source: GSource): GSource {.importc: "g_source_ref",
    libglib.}
proc unref*(source: GSource) {.importc: "g_source_unref", libglib.}
proc attach*(source: GSource; context: GMainContext): cuint {.
    importc: "g_source_attach", libglib.}
proc destroy*(source: GSource) {.importc: "g_source_destroy", libglib.}
proc setPriority*(source: GSource; priority: cint) {.
    importc: "g_source_set_priority", libglib.}
proc `priority=`*(source: GSource; priority: cint) {.
    importc: "g_source_set_priority", libglib.}
proc getPriority*(source: GSource): cint {.
    importc: "g_source_get_priority", libglib.}
proc priority*(source: GSource): cint {.
    importc: "g_source_get_priority", libglib.}
proc setCanRecurse*(source: GSource; canRecurse: Gboolean) {.
    importc: "g_source_set_can_recurse", libglib.}
proc `canRecurse=`*(source: GSource; canRecurse: Gboolean) {.
    importc: "g_source_set_can_recurse", libglib.}
proc getCanRecurse*(source: GSource): Gboolean {.
    importc: "g_source_get_can_recurse", libglib.}
proc canRecurse*(source: GSource): Gboolean {.
    importc: "g_source_get_can_recurse", libglib.}
proc getId*(source: GSource): cuint {.importc: "g_source_get_id",
    libglib.}
proc id*(source: GSource): cuint {.importc: "g_source_get_id",
    libglib.}
proc getContext*(source: GSource): GMainContext {.
    importc: "g_source_get_context", libglib.}
proc context*(source: GSource): GMainContext {.
    importc: "g_source_get_context", libglib.}
proc setCallback*(source: GSource; `func`: GSourceFunc; data: Gpointer;
                        notify: GDestroyNotify) {.
    importc: "g_source_set_callback", libglib.}
proc `callback=`*(source: GSource; `func`: GSourceFunc; data: Gpointer;
                        notify: GDestroyNotify) {.
    importc: "g_source_set_callback", libglib.}
proc setFuncs*(source: GSource; funcs: GSourceFuncs) {.
    importc: "g_source_set_funcs", libglib.}
proc `funcs=`*(source: GSource; funcs: GSourceFuncs) {.
    importc: "g_source_set_funcs", libglib.}
proc isDestroyed*(source: GSource): Gboolean {.
    importc: "g_source_is_destroyed", libglib.}
proc setName*(source: GSource; name: cstring) {.
    importc: "g_source_set_name", libglib.}
proc `name=`*(source: GSource; name: cstring) {.
    importc: "g_source_set_name", libglib.}
proc getName*(source: GSource): cstring {.importc: "g_source_get_name",
    libglib.}
proc name*(source: GSource): cstring {.importc: "g_source_get_name",
    libglib.}
proc sourceSetNameById*(tag: cuint; name: cstring) {.
    importc: "g_source_set_name_by_id", libglib.}
proc setReadyTime*(source: GSource; readyTime: int64) {.
    importc: "g_source_set_ready_time", libglib.}
proc `readyTime=`*(source: GSource; readyTime: int64) {.
    importc: "g_source_set_ready_time", libglib.}
proc getReadyTime*(source: GSource): int64 {.
    importc: "g_source_get_ready_time", libglib.}
proc readyTime*(source: GSource): int64 {.
    importc: "g_source_get_ready_time", libglib.}
when defined(unix):
  proc addUnixFd*(source: GSource; fd: cint; events: GIOCondition): Gpointer {.
      importc: "g_source_add_unix_fd", libglib.}
  proc modifyUnixFd*(source: GSource; tag: Gpointer;
                           newEvents: GIOCondition) {.
      importc: "g_source_modify_unix_fd", libglib.}
  proc removeUnixFd*(source: GSource; tag: Gpointer) {.
      importc: "g_source_remove_unix_fd", libglib.}
  proc queryUnixFd*(source: GSource; tag: Gpointer): GIOCondition {.
      importc: "g_source_query_unix_fd", libglib.}

proc setCallbackIndirect*(source: GSource; callbackData: Gpointer;
                                callbackFuncs: GSourceCallbackFuncs) {.
    importc: "g_source_set_callback_indirect", libglib.}

proc `callbackIndirect=`*(source: GSource; callbackData: Gpointer;
                                callbackFuncs: GSourceCallbackFuncs) {.
    importc: "g_source_set_callback_indirect", libglib.}
proc addPoll*(source: GSource; fd: GPollFD) {.
    importc: "g_source_add_poll", libglib.}
proc removePoll*(source: GSource; fd: GPollFD) {.
    importc: "g_source_remove_poll", libglib.}
proc addChildSource*(source: GSource; childSource: GSource) {.
    importc: "g_source_add_child_source", libglib.}
proc removeChildSource*(source: GSource; childSource: GSource) {.
    importc: "g_source_remove_child_source", libglib.}
proc getCurrentTime*(source: GSource; timeval: var GTimeValObj) {.
    importc: "g_source_get_current_time", libglib.}
proc getTime*(source: GSource): int64 {.importc: "g_source_get_time",
    libglib.}
proc time*(source: GSource): int64 {.importc: "g_source_get_time",
    libglib.}

proc newIdleSource*(): GSource {.importc: "g_idle_source_new", libglib.}
proc newChildWatchSource*(pid: GPid): GSource {.
    importc: "g_child_watch_source_new", libglib.}
proc newTimeoutSource*(interval: cuint): GSource {.
    importc: "g_timeout_source_new", libglib.}
proc newTimeoutSourceSeconds*(interval: cuint): GSource {.
    importc: "g_timeout_source_new_seconds", libglib.}

proc getCurrentTime*(result: var GTimeValObj) {.importc: "g_get_current_time", libglib.}
proc getMonotonicTime*(): int64 {.importc: "g_get_monotonic_time", libglib.}
proc monotonicTime*(): int64 {.importc: "g_get_monotonic_time", libglib.}
proc getRealTime*(): int64 {.importc: "g_get_real_time", libglib.}
proc realTime*(): int64 {.importc: "g_get_real_time", libglib.}

proc sourceRemove*(tag: cuint): Gboolean {.importc: "g_source_remove", libglib.}
proc sourceRemoveByUserData*(userData: Gpointer): Gboolean {.
    importc: "g_source_remove_by_user_data", libglib.}
proc sourceRemoveByFuncsUserData*(funcs: GSourceFuncs; userData: Gpointer): Gboolean {.
    importc: "g_source_remove_by_funcs_user_data", libglib.}

proc timeoutAddFull*(priority: cint; interval: cuint; function: GSourceFunc;
                     data: Gpointer; notify: GDestroyNotify): cuint {.
    importc: "g_timeout_add_full", libglib.}
proc timeoutAdd*(interval: cuint; function: GSourceFunc; data: Gpointer): cuint {.
    importc: "g_timeout_add", libglib.}
proc timeoutAddSecondsFull*(priority: cint; interval: cuint; function: GSourceFunc;
                            data: Gpointer; notify: GDestroyNotify): cuint {.
    importc: "g_timeout_add_seconds_full", libglib.}
proc timeoutAddSeconds*(interval: cuint; function: GSourceFunc; data: Gpointer): cuint {.
    importc: "g_timeout_add_seconds", libglib.}
proc childWatchAddFull*(priority: cint; pid: GPid; function: GChildWatchFunc;
                        data: Gpointer; notify: GDestroyNotify): cuint {.
    importc: "g_child_watch_add_full", libglib.}
proc childWatchAdd*(pid: GPid; function: GChildWatchFunc; data: Gpointer): cuint {.
    importc: "g_child_watch_add", libglib.}
proc idleAdd*(function: GSourceFunc; data: Gpointer): cuint {.importc: "g_idle_add",
    libglib.}
proc idleAddFull*(priority: cint; function: GSourceFunc; data: Gpointer;
                  notify: GDestroyNotify): cuint {.importc: "g_idle_add_full",
    libglib.}
proc idleRemoveByData*(data: Gpointer): Gboolean {.
    importc: "g_idle_remove_by_data", libglib.}
proc invokeFull*(context: GMainContext; priority: cint;
                            function: GSourceFunc; data: Gpointer;
                            notify: GDestroyNotify) {.
    importc: "g_main_context_invoke_full", libglib.}
proc invoke*(context: GMainContext; function: GSourceFunc;
                        data: Gpointer) {.importc: "g_main_context_invoke",
                                        libglib.}

type
  Gunichar* = uint32

type
  Gunichar2* = uint16

type
  GUnicodeType* {.size: sizeof(cint), pure.} = enum
    CONTROL, FORMAT, UNASSIGNED,
    PRIVATE_USE, SURROGATE, LOWERCASE_LETTER,
    MODIFIER_LETTER, OTHER_LETTER, TITLECASE_LETTER,
    UPPERCASE_LETTER, SPACING_MARK, ENCLOSING_MARK,
    NON_SPACING_MARK, DECIMAL_NUMBER, LETTER_NUMBER,
    OTHER_NUMBER, CONNECT_PUNCTUATION,
    DASH_PUNCTUATION, CLOSE_PUNCTUATION,
    FINAL_PUNCTUATION, INITIAL_PUNCTUATION,
    OTHER_PUNCTUATION, OPEN_PUNCTUATION,
    CURRENCY_SYMBOL, MODIFIER_SYMBOL, MATH_SYMBOL,
    OTHER_SYMBOL, LINE_SEPARATOR,
    PARAGRAPH_SEPARATOR, SPACE_SEPARATOR

when not (G_DISABLE_DEPRECATED):
  const
    G_UNICODE_COMBINING_MARK* = GUnicodeType.SPACING_MARK

type
  GUnicodeBreakType* {.size: sizeof(cint), pure.} = enum
    MANDATORY, CARRIAGE_RETURN,
    LINE_FEED, COMBINING_MARK,
    SURROGATE, ZERO_WIDTH_SPACE,
    INSEPARABLE, NON_BREAKING_GLUE,
    CONTINGENT, SPACE, AFTER,
    BEFORE, BEFORE_AND_AFTER,
    HYPHEN, NON_STARTER,
    OPEN_PUNCTUATION, CLOSE_PUNCTUATION,
    QUOTATION, EXCLAMATION,
    IDEOGRAPHIC, NUMERIC,
    INFIX_SEPARATOR, SYMBOL,
    ALPHABETIC, PREFIX, POSTFIX,
    COMPLEX_CONTEXT, AMBIGUOUS,
    UNKNOWN, NEXT_LINE,
    WORD_JOINER, HANGUL_L_JAMO,
    HANGUL_V_JAMO, HANGUL_T_JAMO,
    HANGUL_LV_SYLLABLE, HANGUL_LVT_SYLLABLE,
    CLOSE_PARANTHESIS,
    CONDITIONAL_JAPANESE_STARTER, HEBREW_LETTER,
    REGIONAL_INDICATOR, EMOJI_BASE,
    EMOJI_MODIFIER, ZERO_WIDTH_JOINER

type
  GUnicodeScript* {.size: sizeof(cint), pure.} = enum
    INVALID_CODE = - 1, COMMON = 0,
    INHERITED, ARABIC,
    ARMENIAN, BENGALI,
    BOPOMOFO, CHEROKEE, COPTIC,
    CYRILLIC, DESERET,
    DEVANAGARI, ETHIOPIC,
    GEORGIAN, GOTHIC, GREEK,
    GUJARATI, GURMUKHI, HAN,
    HANGUL, HEBREW, HIRAGANA,
    KANNADA, KATAKANA, KHMER,
    LAO, LATIN, MALAYALAM,
    MONGOLIAN, MYANMAR, OGHAM,
    OLD_ITALIC, ORIYA, RUNIC,
    SINHALA, SYRIAC, TAMIL,
    TELUGU, THAANA, THAI,
    TIBETAN, CANADIAN_ABORIGINAL,
    YI, TAGALOG, HANUNOO,
    BUHID, TAGBANWA, BRAILLE,
    CYPRIOT, LIMBU, OSMANYA,
    SHAVIAN, LINEAR_B, TAI_LE,
    UGARITIC, NEW_TAI_LUE,
    BUGINESE, GLAGOLITIC,
    TIFINAGH, SYLOTI_NAGRI,
    OLD_PERSIAN, KHAROSHTHI,
    UNKNOWN, BALINESE,
    CUNEIFORM, PHOENICIAN,
    PHAGS_PA, NKO, KAYAH_LI,
    LEPCHA, REJANG, SUNDANESE,
    SAURASHTRA, CHAM, OL_CHIKI,
    VAI, CARIAN, LYCIAN,
    LYDIAN, AVESTAN, BAMUM,
    EGYPTIAN_HIEROGLYPHS, IMPERIAL_ARAMAIC,
    INSCRIPTIONAL_PAHLAVI,
    INSCRIPTIONAL_PARTHIAN, JAVANESE,
    KAITHI, LISU, MEETEI_MAYEK,
    OLD_SOUTH_ARABIAN, OLD_TURKIC,
    SAMARITAN, TAI_THAM,
    TAI_VIET, BATAK, BRAHMI,
    MANDAIC, CHAKMA,
    MEROITIC_CURSIVE, MEROITIC_HIEROGLYPHS,
    MIAO, SHARADA,
    SORA_SOMPENG, TAKRI,
    BASSA_VAH, CAUCASIAN_ALBANIAN,
    DUPLOYAN, ELBASAN, GRANTHA,
    KHOJKI, KHUDAWADI,
    LINEAR_A, MAHAJANI,
    MANICHAEAN, MENDE_KIKAKUI,
    MODI, MRO, NABATAEAN,
    OLD_NORTH_ARABIAN, OLD_PERMIC,
    PAHAWH_HMONG, PALMYRENE,
    PAU_CIN_HAU, PSALTER_PAHLAVI,
    SIDDHAM, TIRHUTA,
    WARANG_CITI, AHOM,
    ANATOLIAN_HIEROGLYPHS, HATRAN,
    MULTANI, OLD_HUNGARIAN,
    SIGNWRITING, ADLAM,
    BHAIKSUKI, MARCHEN, NEWA,
    OSAGE, TANGUT

proc toIso15924*(script: GUnicodeScript): uint32 {.
    importc: "g_unicode_script_to_iso15924", libglib.}
proc unicodeScriptFromIso15924*(iso15924: uint32): GUnicodeScript {.
    importc: "g_unicode_script_from_iso15924", libglib.}

proc isalnum*(c: Gunichar): Gboolean {.importc: "g_unichar_isalnum",
    libglib.}
proc isalpha*(c: Gunichar): Gboolean {.importc: "g_unichar_isalpha",
    libglib.}
proc iscntrl*(c: Gunichar): Gboolean {.importc: "g_unichar_iscntrl",
    libglib.}
proc isdigit*(c: Gunichar): Gboolean {.importc: "g_unichar_isdigit",
    libglib.}
proc isgraph*(c: Gunichar): Gboolean {.importc: "g_unichar_isgraph",
    libglib.}
proc islower*(c: Gunichar): Gboolean {.importc: "g_unichar_islower",
    libglib.}
proc isprint*(c: Gunichar): Gboolean {.importc: "g_unichar_isprint",
    libglib.}
proc ispunct*(c: Gunichar): Gboolean {.importc: "g_unichar_ispunct",
    libglib.}
proc isspace*(c: Gunichar): Gboolean {.importc: "g_unichar_isspace",
    libglib.}
proc isupper*(c: Gunichar): Gboolean {.importc: "g_unichar_isupper",
    libglib.}
proc isxdigit*(c: Gunichar): Gboolean {.importc: "g_unichar_isxdigit",
    libglib.}
proc istitle*(c: Gunichar): Gboolean {.importc: "g_unichar_istitle",
    libglib.}
proc isdefined*(c: Gunichar): Gboolean {.importc: "g_unichar_isdefined",
    libglib.}
proc iswide*(c: Gunichar): Gboolean {.importc: "g_unichar_iswide", libglib.}
proc iswideCjk*(c: Gunichar): Gboolean {.importc: "g_unichar_iswide_cjk",
    libglib.}
proc iszerowidth*(c: Gunichar): Gboolean {.importc: "g_unichar_iszerowidth",
    libglib.}
proc ismark*(c: Gunichar): Gboolean {.importc: "g_unichar_ismark", libglib.}

proc toupper*(c: Gunichar): Gunichar {.importc: "g_unichar_toupper",
    libglib.}
proc tolower*(c: Gunichar): Gunichar {.importc: "g_unichar_tolower",
    libglib.}
proc totitle*(c: Gunichar): Gunichar {.importc: "g_unichar_totitle",
    libglib.}

proc digitValue*(c: Gunichar): cint {.importc: "g_unichar_digit_value",
    libglib.}
proc xdigitValue*(c: Gunichar): cint {.importc: "g_unichar_xdigit_value",
    libglib.}

proc `type`*(c: Gunichar): GUnicodeType {.importc: "g_unichar_type", libglib.}

proc breakType*(c: Gunichar): GUnicodeBreakType {.
    importc: "g_unichar_break_type", libglib.}

proc combiningClass*(uc: Gunichar): cint {.
    importc: "g_unichar_combining_class", libglib.}
proc getMirrorChar*(ch: Gunichar; mirroredCh: ptr Gunichar): Gboolean {.
    importc: "g_unichar_get_mirror_char", libglib.}
proc mirrorChar*(ch: Gunichar; mirroredCh: ptr Gunichar): Gboolean {.
    importc: "g_unichar_get_mirror_char", libglib.}
proc getScript*(ch: Gunichar): GUnicodeScript {.
    importc: "g_unichar_get_script", libglib.}
proc script*(ch: Gunichar): GUnicodeScript {.
    importc: "g_unichar_get_script", libglib.}

proc validate*(ch: Gunichar): Gboolean {.importc: "g_unichar_validate",
    libglib.}

proc compose*(a: Gunichar; b: Gunichar; ch: ptr Gunichar): Gboolean {.
    importc: "g_unichar_compose", libglib.}
proc decompose*(ch: Gunichar; a: ptr Gunichar; b: ptr Gunichar): Gboolean {.
    importc: "g_unichar_decompose", libglib.}
proc fullyDecompose*(ch: Gunichar; compat: Gboolean; result: ptr Gunichar;
                            resultLen: Gsize): Gsize {.
    importc: "g_unichar_fully_decompose", libglib.}

const
  G_UNICHAR_MAX_DECOMPOSITION_LENGTH* = 18

proc unicodeCanonicalOrdering*(string: ptr Gunichar; len: Gsize) {.
    importc: "g_unicode_canonical_ordering", libglib.}
proc unicodeCanonicalDecomposition*(ch: Gunichar; resultLen: var Gsize): ptr Gunichar {.
    importc: "g_unicode_canonical_decomposition", libglib.}

template gUtf8NextChar*(p: untyped): untyped =
  cast[cstring]((p + gUtf8Skip[cast[ptr cuchar](p)[]]))

proc utf8GetChar*(p: cstring): Gunichar {.importc: "g_utf8_get_char", libglib.}
proc utf8GetCharValidated*(p: cstring; maxLen: Gssize): Gunichar {.
    importc: "g_utf8_get_char_validated", libglib.}
proc utf8OffsetToPointer*(str: cstring; offset: clong): cstring {.
    importc: "g_utf8_offset_to_pointer", libglib.}
proc utf8PointerToOffset*(str: cstring; pos: cstring): clong {.
    importc: "g_utf8_pointer_to_offset", libglib.}
proc utf8PrevChar*(p: cstring): cstring {.importc: "g_utf8_prev_char", libglib.}
proc utf8FindNextChar*(p: cstring; `end`: cstring): cstring {.
    importc: "g_utf8_find_next_char", libglib.}
proc utf8FindPrevChar*(str: cstring; p: cstring): cstring {.
    importc: "g_utf8_find_prev_char", libglib.}
proc utf8Strlen*(p: cstring; max: Gssize): clong {.importc: "g_utf8_strlen",
    libglib.}
proc utf8Substring*(str: cstring; startPos: clong; endPos: clong): cstring {.
    importc: "g_utf8_substring", libglib.}
proc utf8Strncpy*(dest: cstring; src: cstring; n: Gsize): cstring {.
    importc: "g_utf8_strncpy", libglib.}

proc utf8Strchr*(p: cstring; len: Gssize; c: Gunichar): cstring {.
    importc: "g_utf8_strchr", libglib.}
proc utf8Strrchr*(p: cstring; len: Gssize; c: Gunichar): cstring {.
    importc: "g_utf8_strrchr", libglib.}
proc utf8Strreverse*(str: cstring; len: Gssize): cstring {.
    importc: "g_utf8_strreverse", libglib.}
proc utf8ToUtf16*(str: cstring; len: clong; itemsRead: var clong;
                  itemsWritten: var clong; error: var GError): ptr Gunichar2 {.
    importc: "g_utf8_to_utf16", libglib.}
proc utf8ToUcs4*(str: cstring; len: clong; itemsRead: var clong;
                 itemsWritten: var clong; error: var GError): ptr Gunichar {.
    importc: "g_utf8_to_ucs4", libglib.}
proc utf8ToUcs4Fast*(str: cstring; len: clong; itemsWritten: var clong): ptr Gunichar {.
    importc: "g_utf8_to_ucs4_fast", libglib.}
proc utf16ToUcs4*(str: ptr Gunichar2; len: clong; itemsRead: var clong;
                  itemsWritten: var clong; error: var GError): ptr Gunichar {.
    importc: "g_utf16_to_ucs4", libglib.}
proc utf16ToUtf8*(str: ptr Gunichar2; len: clong; itemsRead: var clong;
                  itemsWritten: var clong; error: var GError): cstring {.
    importc: "g_utf16_to_utf8", libglib.}
proc ucs4ToUtf16*(str: ptr Gunichar; len: clong; itemsRead: var clong;
                  itemsWritten: var clong; error: var GError): ptr Gunichar2 {.
    importc: "g_ucs4_to_utf16", libglib.}
proc ucs4ToUtf8*(str: ptr Gunichar; len: clong; itemsRead: var clong;
                 itemsWritten: var clong; error: var GError): cstring {.
    importc: "g_ucs4_to_utf8", libglib.}
proc toUtf8*(c: Gunichar; outbuf: cstring): cint {.
    importc: "g_unichar_to_utf8", libglib.}
proc utf8Validate*(str: cstring; maxLen: Gssize; `end`: cstringArray): Gboolean {.
    importc: "g_utf8_validate", libglib.}
proc utf8Strup*(str: cstring; len: Gssize): cstring {.importc: "g_utf8_strup",
    libglib.}
proc utf8Strdown*(str: cstring; len: Gssize): cstring {.importc: "g_utf8_strdown",
    libglib.}
proc utf8Casefold*(str: cstring; len: Gssize): cstring {.importc: "g_utf8_casefold",
    libglib.}

type
  GNormalizeMode* {.size: sizeof(cint), pure.} = enum
    DEFAULT,
    DEFAULT_COMPOSE,
    ALL,
    ALL_COMPOSE
const
  G_NORMALIZE_NFD = GNormalizeMode.DEFAULT
  G_NORMALIZE_NFC = GNormalizeMode.DEFAULT_COMPOSE
  G_NORMALIZE_NFKD = GNormalizeMode.ALL
  G_NORMALIZE_NFKC = GNormalizeMode.ALL_COMPOSE

proc utf8Normalize*(str: cstring; len: Gssize; mode: GNormalizeMode): cstring {.
    importc: "g_utf8_normalize", libglib.}
proc utf8Collate*(str1: cstring; str2: cstring): cint {.importc: "g_utf8_collate",
    libglib.}
proc utf8CollateKey*(str: cstring; len: Gssize): cstring {.
    importc: "g_utf8_collate_key", libglib.}
proc utf8CollateKeyForFilename*(str: cstring; len: Gssize): cstring {.
    importc: "g_utf8_collate_key_for_filename", libglib.}
proc utf8MakeValid*(str: cstring; len: Gssize): cstring {.
    importc: "g_utf8_make_valid", libglib.}

type
  GString* =  ptr GStringObj
  GStringPtr* = ptr GStringObj
  GStringObj* = object
    str*: cstring
    len*: Gsize
    allocatedLen*: Gsize

proc newGString*(init: cstring): GString {.importc: "g_string_new", libglib.}
proc newGString*(init: cstring; len: Gssize): GString {.
    importc: "g_string_new_len", libglib.}
proc newStringSized*(dflSize: Gsize): GString {.importc: "g_string_sized_new",
    libglib.}
proc free*(string: GString; freeSegment: Gboolean): cstring {.
    importc: "g_string_free", libglib.}
proc freeToBytes*(string: GString): GBytes {.
    importc: "g_string_free_to_bytes", libglib.}
proc equal*(v: GString; v2: GString): Gboolean {.
    importc: "g_string_equal", libglib.}
proc hash*(str: GString): cuint {.importc: "g_string_hash", libglib.}
proc assign*(string: GString; rval: cstring): GString {.
    importc: "g_string_assign", libglib.}
proc truncate*(string: GString; len: Gsize): GString {.
    importc: "g_string_truncate", libglib.}
proc setSize*(string: GString; len: Gsize): GString {.
    importc: "g_string_set_size", libglib.}
proc insertLen*(string: GString; pos: Gssize; val: cstring; len: Gssize): GString {.
    importc: "g_string_insert_len", libglib.}
proc append*(string: GString; val: cstring): GString {.
    importc: "g_string_append", libglib.}
proc appendLen*(string: GString; val: cstring; len: Gssize): GString {.
    importc: "g_string_append_len", libglib.}
proc appendC*(string: GString; c: char): GString {.
    importc: "g_string_append_c", libglib.}
proc appendUnichar*(string: GString; wc: Gunichar): GString {.
    importc: "g_string_append_unichar", libglib.}
proc prepend*(string: GString; val: cstring): GString {.
    importc: "g_string_prepend", libglib.}
proc prependC*(string: GString; c: char): GString {.
    importc: "g_string_prepend_c", libglib.}
proc prependUnichar*(string: GString; wc: Gunichar): GString {.
    importc: "g_string_prepend_unichar", libglib.}
proc prependLen*(string: GString; val: cstring; len: Gssize): GString {.
    importc: "g_string_prepend_len", libglib.}
proc insert*(string: GString; pos: Gssize; val: cstring): GString {.
    importc: "g_string_insert", libglib.}
proc insertC*(string: GString; pos: Gssize; c: char): GString {.
    importc: "g_string_insert_c", libglib.}
proc insertUnichar*(string: GString; pos: Gssize; wc: Gunichar): GString {.
    importc: "g_string_insert_unichar", libglib.}
proc overwrite*(string: GString; pos: Gsize; val: cstring): GString {.
    importc: "g_string_overwrite", libglib.}
proc overwriteLen*(string: GString; pos: Gsize; val: cstring; len: Gssize): GString {.
    importc: "g_string_overwrite_len", libglib.}
proc erase*(string: GString; pos: Gssize; len: Gssize): GString {.
    importc: "g_string_erase", libglib.}
proc asciiDown*(string: GString): GString {.
    importc: "g_string_ascii_down", libglib.}
proc asciiUp*(string: GString): GString {.importc: "g_string_ascii_up",
    libglib.}
when (VALIST):
  proc vprintf*(string: GString; format: cstring; args: VaList) {.
      importc: "g_string_vprintf", libglib.}
proc printf*(string: GString; format: cstring) {.varargs,
    importc: "g_string_printf", libglib.}
when (VALIST):
  proc appendVprintf*(string: GString; format: cstring; args: VaList) {.
      importc: "g_string_append_vprintf", libglib.}
proc appendPrintf*(string: GString; format: cstring) {.varargs,
    importc: "g_string_append_printf", libglib.}
proc appendUriEscaped*(string: GString; unescaped: cstring;
                             reservedCharsAllowed: cstring; allowUtf8: Gboolean): GString {.
    importc: "g_string_append_uri_escaped", libglib.}

when (G_CAN_INLINE):
  proc appendCInline*(gstring: GString; c: char): GString {.inline.} =
    if gstring.len + 1 < gstring.allocatedLen:
      gstring.str[inc(gstring.len)] = c
      gstring.str[gstring.len] = 0
    else:
      stringInsertC(gstring, - 1, c)
    return gstring

  template gStringAppendC*(gstr, c: untyped): untyped =
    appendCInline(gstr, c)

proc down*(string: GString): GString {.importc: "g_string_down",
    libglib.}
proc up*(string: GString): GString {.importc: "g_string_up", libglib.}
when not (G_DISABLE_DEPRECATED):
  const
    gStringSprintf* = printf
    gStringSprintfa* = appendPrintf

type
  GIOError* {.size: sizeof(cint), pure.} = enum
    NONE, AGAIN, INVAL, UNKNOWN
  GIOChannelError* {.size: sizeof(cint), pure.} = enum
    FBIG, INVAL, IO,
    ISDIR, NOSPC, NXIO,
    OVERFLOW, PIPE,
    FAILED
  GIOStatus* {.size: sizeof(cint), pure.} = enum
    ERROR, NORMAL, EOF, AGAIN
  GSeekType* {.size: sizeof(cint), pure.} = enum
    CUR, SET, `END`
  GIOFlags* {.size: sizeof(cint), pure.} = enum
    APPEND = 1 shl 0, NONBLOCK = 1 shl 1,
    SET_MASK = GIOFlags.APPEND.ord or GIOFlags.NONBLOCK.ord,
    IS_READABLE = 1 shl 2, IS_WRITABLE = 1 shl 3,
    IS_SEEKABLE = 1 shl 4,
    MASK = (1 shl 5) - 1
const
  G_IO_FLAGS_GET_MASK = GIOFlags.MASK

type
  GIOChannel* =  ptr GIOChannelObj
  GIOChannelPtr* = ptr GIOChannelObj
  GIOChannelObj* = object
    refCount*: cint
    funcs*: GIOFuncs
    encoding*: cstring
    readCd*: GIConv
    writeCd*: GIConv
    lineTerm*: cstring
    lineTermLen*: cuint
    bufSize*: Gsize
    readBuf*: GString
    encodedReadBuf*: GString
    writeBuf*: GString
    partialWriteBuf*: array[6, char]
    useBuffer* {.bitsize: 1.}: cuint
    doEncode* {.bitsize: 1.}: cuint
    closeOnUnref* {.bitsize: 1.}: cuint
    isReadable* {.bitsize: 1.}: cuint
    isWriteable* {.bitsize: 1.}: cuint
    isSeekable* {.bitsize: 1.}: cuint
    reserved1: Gpointer
    reserved2: Gpointer

  GIOFunc* = proc (source: GIOChannel; condition: GIOCondition; data: Gpointer): Gboolean {.cdecl.}
  GIOFuncs* =  ptr GIOFuncsObj
  GIOFuncsPtr* = ptr GIOFuncsObj
  GIOFuncsObj* = object
    ioRead*: proc (channel: GIOChannel; buf: cstring; count: Gsize;
                 bytesRead: var Gsize; err: var GError): GIOStatus {.cdecl.}
    ioWrite*: proc (channel: GIOChannel; buf: cstring; count: Gsize;
                  bytesWritten: var Gsize; err: var GError): GIOStatus {.cdecl.}
    ioSeek*: proc (channel: GIOChannel; offset: int64; `type`: GSeekType;
                 err: var GError): GIOStatus {.cdecl.}
    ioClose*: proc (channel: GIOChannel; err: var GError): GIOStatus {.cdecl.}
    ioCreateWatch*: proc (channel: GIOChannel; condition: GIOCondition): GSource {.cdecl.}
    ioFree*: proc (channel: GIOChannel) {.cdecl.}
    ioSetFlags*: proc (channel: GIOChannel; flags: GIOFlags; err: var GError): GIOStatus {.cdecl.}
    ioGetFlags*: proc (channel: GIOChannel): GIOFlags {.cdecl.}

proc init*(channel: GIOChannel) {.importc: "g_io_channel_init",
    libglib.}
proc `ref`*(channel: GIOChannel): GIOChannel {.
    importc: "g_io_channel_ref", libglib.}
proc unref*(channel: GIOChannel) {.importc: "g_io_channel_unref",
    libglib.}
proc read*(channel: GIOChannel; buf: cstring; count: Gsize;
                    bytesRead: var Gsize): GIOError {.importc: "g_io_channel_read",
    libglib.}
proc write*(channel: GIOChannel; buf: cstring; count: Gsize;
                     bytesWritten: var Gsize): GIOError {.
    importc: "g_io_channel_write", libglib.}
proc seek*(channel: GIOChannel; offset: int64; `type`: GSeekType): GIOError {.
    importc: "g_io_channel_seek", libglib.}
proc close*(channel: GIOChannel) {.importc: "g_io_channel_close",
    libglib.}
proc shutdown*(channel: GIOChannel; flush: Gboolean; err: var GError): GIOStatus {.
    importc: "g_io_channel_shutdown", libglib.}
proc ioAddWatchFull*(channel: GIOChannel; priority: cint;
                     condition: GIOCondition; `func`: GIOFunc; userData: Gpointer;
                     notify: GDestroyNotify): cuint {.
    importc: "g_io_add_watch_full", libglib.}
proc ioCreateWatch*(channel: GIOChannel; condition: GIOCondition): GSource {.
    importc: "g_io_create_watch", libglib.}
proc ioAddWatch*(channel: GIOChannel; condition: GIOCondition; `func`: GIOFunc;
                 userData: Gpointer): cuint {.importc: "g_io_add_watch", libglib.}

proc setBufferSize*(channel: GIOChannel; size: Gsize) {.
    importc: "g_io_channel_set_buffer_size", libglib.}

proc `bufferSize=`*(channel: GIOChannel; size: Gsize) {.
    importc: "g_io_channel_set_buffer_size", libglib.}
proc getBufferSize*(channel: GIOChannel): Gsize {.
    importc: "g_io_channel_get_buffer_size", libglib.}
proc bufferSize*(channel: GIOChannel): Gsize {.
    importc: "g_io_channel_get_buffer_size", libglib.}
proc getBufferCondition*(channel: GIOChannel): GIOCondition {.
    importc: "g_io_channel_get_buffer_condition", libglib.}
proc bufferCondition*(channel: GIOChannel): GIOCondition {.
    importc: "g_io_channel_get_buffer_condition", libglib.}
proc setFlags*(channel: GIOChannel; flags: GIOFlags;
                        error: var GError): GIOStatus {.
    importc: "g_io_channel_set_flags", libglib.}
proc getFlags*(channel: GIOChannel): GIOFlags {.
    importc: "g_io_channel_get_flags", libglib.}
proc setLineTerm*(channel: GIOChannel; lineTerm: cstring; length: cint) {.
    importc: "g_io_channel_set_line_term", libglib.}
proc `lineTerm=`*(channel: GIOChannel; lineTerm: cstring; length: cint) {.
    importc: "g_io_channel_set_line_term", libglib.}
proc getLineTerm*(channel: GIOChannel; length: var cint): cstring {.
    importc: "g_io_channel_get_line_term", libglib.}
proc lineTerm*(channel: GIOChannel; length: var cint): cstring {.
    importc: "g_io_channel_get_line_term", libglib.}
proc setBuffered*(channel: GIOChannel; buffered: Gboolean) {.
    importc: "g_io_channel_set_buffered", libglib.}
proc `buffered=`*(channel: GIOChannel; buffered: Gboolean) {.
    importc: "g_io_channel_set_buffered", libglib.}
proc getBuffered*(channel: GIOChannel): Gboolean {.
    importc: "g_io_channel_get_buffered", libglib.}
proc buffered*(channel: GIOChannel): Gboolean {.
    importc: "g_io_channel_get_buffered", libglib.}
proc setEncoding*(channel: GIOChannel; encoding: cstring;
                           error: var GError): GIOStatus {.
    importc: "g_io_channel_set_encoding", libglib.}
proc getEncoding*(channel: GIOChannel): cstring {.
    importc: "g_io_channel_get_encoding", libglib.}
proc encoding*(channel: GIOChannel): cstring {.
    importc: "g_io_channel_get_encoding", libglib.}
proc setCloseOnUnref*(channel: GIOChannel; doClose: Gboolean) {.
    importc: "g_io_channel_set_close_on_unref", libglib.}
proc `closeOnUnref=`*(channel: GIOChannel; doClose: Gboolean) {.
    importc: "g_io_channel_set_close_on_unref", libglib.}
proc getCloseOnUnref*(channel: GIOChannel): Gboolean {.
    importc: "g_io_channel_get_close_on_unref", libglib.}
proc closeOnUnref*(channel: GIOChannel): Gboolean {.
    importc: "g_io_channel_get_close_on_unref", libglib.}
proc flush*(channel: GIOChannel; error: var GError): GIOStatus {.
    importc: "g_io_channel_flush", libglib.}
proc readLine*(channel: GIOChannel; strReturn: cstringArray;
                        length: var Gsize; terminatorPos: var Gsize;
                        error: var GError): GIOStatus {.
    importc: "g_io_channel_read_line", libglib.}
proc readLineString*(channel: GIOChannel; buffer: GString;
                              terminatorPos: var Gsize; error: var GError): GIOStatus {.
    importc: "g_io_channel_read_line_string", libglib.}
proc readToEnd*(channel: GIOChannel; strReturn: cstringArray;
                         length: var Gsize; error: var GError): GIOStatus {.
    importc: "g_io_channel_read_to_end", libglib.}
proc readChars*(channel: GIOChannel; buf: cstring; count: Gsize;
                         bytesRead: var Gsize; error: var GError): GIOStatus {.
    importc: "g_io_channel_read_chars", libglib.}
proc readUnichar*(channel: GIOChannel; thechar: ptr Gunichar;
                           error: var GError): GIOStatus {.
    importc: "g_io_channel_read_unichar", libglib.}
proc writeChars*(channel: GIOChannel; buf: cstring; count: Gssize;
                          bytesWritten: var Gsize; error: var GError): GIOStatus {.
    importc: "g_io_channel_write_chars", libglib.}
proc writeUnichar*(channel: GIOChannel; thechar: Gunichar;
                            error: var GError): GIOStatus {.
    importc: "g_io_channel_write_unichar", libglib.}
proc seekPosition*(channel: GIOChannel; offset: int64;
                            `type`: GSeekType; error: var GError): GIOStatus {.
    importc: "g_io_channel_seek_position", libglib.}
proc newIoChannel*(filename: cstring; mode: cstring; error: var GError): GIOChannel {.
    importc: "g_io_channel_new_file", libglib.}

proc ioChannelErrorQuark*(): GQuark {.importc: "g_io_channel_error_quark",
                                    libglib.}
proc ioChannelErrorFromErrno*(en: cint): GIOChannelError {.
    importc: "g_io_channel_error_from_errno", libglib.}

proc newIoChannelUnix*(fd: cint): GIOChannel {.importc: "g_io_channel_unix_new",
    libglib.}
proc unixGetFd*(channel: GIOChannel): cint {.
    importc: "g_io_channel_unix_get_fd", libglib.}

when defined(windows):
  const
    G_WIN32_MSG_HANDLE* = 19981206
  proc win32MakePollfd*(channel: GIOChannel; condition: GIOCondition;
                                 fd: GPollFD) {.
      importc: "g_io_channel_win32_make_pollfd", libglib.}
  proc ioChannelWin32Poll*(fds: GPollFD; nFds: cint; timeout: cint): cint {.
      importc: "g_io_channel_win32_poll", libglib.}
  when GLIB_SIZEOF_VOID_P == 8:
    proc newIoChannelWin32Message*(hwnd: Gsize): GIOChannel {.
        importc: "g_io_channel_win32_new_messages", libglib.}
  else:
    proc newIoChannelWin32Message*(hwnd: cuint): GIOChannel {.
        importc: "g_io_channel_win32_new_messages", libglib.}
  proc newIoChannelWin32NewFd*(fd: cint): GIOChannel {.
      importc: "g_io_channel_win32_new_fd", libglib.}
  proc win32GetFd*(channel: GIOChannel): cint {.
      importc: "g_io_channel_win32_get_fd", libglib.}
  proc newIoChannelWin32Socket*(socket: cint): GIOChannel {.
      importc: "g_io_channel_win32_new_socket", libglib.}
  proc newIoChannelWin32StreamSocket*(socket: cint): GIOChannel {.
      importc: "g_io_channel_win32_new_stream_socket", libglib.}
  proc win32SetDebug*(channel: GIOChannel; flag: Gboolean) {.
      importc: "g_io_channel_win32_set_debug", libglib.}

type
  GKeyFileError* {.size: sizeof(cint), pure.} = enum
    UNKNOWN_ENCODING, PARSE,
    NOT_FOUND, KEY_NOT_FOUND,
    GROUP_NOT_FOUND, INVALID_VALUE

proc keyFileErrorQuark*(): GQuark {.importc: "g_key_file_error_quark", libglib.}
type
  GKeyFile* =  ptr GKeyFileObj
  GKeyFilePtr* = ptr GKeyFileObj
  GKeyFileObj* = object

  GKeyFileFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, KEEP_COMMENTS = 1 shl 0,
    KEEP_TRANSLATIONS = 1 shl 1

proc newKeyFile*(): GKeyFile {.importc: "g_key_file_new", libglib.}
proc `ref`*(keyFile: GKeyFile): GKeyFile {.importc: "g_key_file_ref",
    libglib.}
proc unref*(keyFile: GKeyFile) {.importc: "g_key_file_unref", libglib.}
proc free*(keyFile: GKeyFile) {.importc: "g_key_file_free", libglib.}
proc setListSeparator*(keyFile: GKeyFile; separator: char) {.
    importc: "g_key_file_set_list_separator", libglib.}
proc `listSeparator=`*(keyFile: GKeyFile; separator: char) {.
    importc: "g_key_file_set_list_separator", libglib.}
proc loadFromFile*(keyFile: GKeyFile; file: cstring; flags: GKeyFileFlags;
                          error: var GError): Gboolean {.
    importc: "g_key_file_load_from_file", libglib.}
proc loadFromData*(keyFile: GKeyFile; data: cstring; length: Gsize;
                          flags: GKeyFileFlags; error: var GError): Gboolean {.
    importc: "g_key_file_load_from_data", libglib.}
proc loadFromBytes*(keyFile: GKeyFile; bytes: GBytes;
                           flags: GKeyFileFlags; error: var GError): Gboolean {.
    importc: "g_key_file_load_from_bytes", libglib.}
proc loadFromDirs*(keyFile: GKeyFile; file: cstring;
                          searchDirs: cstringArray; fullPath: cstringArray;
                          flags: GKeyFileFlags; error: var GError): Gboolean {.
    importc: "g_key_file_load_from_dirs", libglib.}
proc loadFromDataDirs*(keyFile: GKeyFile; file: cstring;
                              fullPath: cstringArray; flags: GKeyFileFlags;
                              error: var GError): Gboolean {.
    importc: "g_key_file_load_from_data_dirs", libglib.}
proc toData*(keyFile: GKeyFile; length: var Gsize; error: var GError): cstring {.
    importc: "g_key_file_to_data", libglib.}
proc saveToFile*(keyFile: GKeyFile; filename: cstring;
                        error: var GError): Gboolean {.
    importc: "g_key_file_save_to_file", libglib.}
proc getStartGroup*(keyFile: GKeyFile): cstring {.
    importc: "g_key_file_get_start_group", libglib.}
proc startGroup*(keyFile: GKeyFile): cstring {.
    importc: "g_key_file_get_start_group", libglib.}
proc getGroups*(keyFile: GKeyFile; length: var Gsize): cstringArray {.
    importc: "g_key_file_get_groups", libglib.}
proc groups*(keyFile: GKeyFile; length: var Gsize): cstringArray {.
    importc: "g_key_file_get_groups", libglib.}
proc getKeys*(keyFile: GKeyFile; groupName: cstring; length: var Gsize;
                     error: var GError): cstringArray {.
    importc: "g_key_file_get_keys", libglib.}
proc keys*(keyFile: GKeyFile; groupName: cstring; length: var Gsize;
                     error: var GError): cstringArray {.
    importc: "g_key_file_get_keys", libglib.}
proc hasGroup*(keyFile: GKeyFile; groupName: cstring): Gboolean {.
    importc: "g_key_file_has_group", libglib.}
proc hasKey*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                    error: var GError): Gboolean {.importc: "g_key_file_has_key",
    libglib.}
proc getValue*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                      error: var GError): cstring {.
    importc: "g_key_file_get_value", libglib.}
proc value*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                      error: var GError): cstring {.
    importc: "g_key_file_get_value", libglib.}
proc setValue*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                      value: cstring) {.importc: "g_key_file_set_value", libglib.}
proc `value=`*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                      value: cstring) {.importc: "g_key_file_set_value", libglib.}
proc getString*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                       error: var GError): cstring {.
    importc: "g_key_file_get_string", libglib.}
proc setString*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                       string: cstring) {.importc: "g_key_file_set_string",
                                        libglib.}
proc getLocaleString*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                             locale: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_locale_string", libglib.}
proc localeString*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                             locale: cstring; error: var GError): cstring {.
    importc: "g_key_file_get_locale_string", libglib.}
proc setLocaleString*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                             locale: cstring; string: cstring) {.
    importc: "g_key_file_set_locale_string", libglib.}
proc `localeString=`*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                             locale: cstring; string: cstring) {.
    importc: "g_key_file_set_locale_string", libglib.}
proc getBoolean*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                        error: var GError): Gboolean {.
    importc: "g_key_file_get_boolean", libglib.}
proc setBoolean*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                        value: Gboolean) {.importc: "g_key_file_set_boolean",
    libglib.}
proc getInteger*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                        error: var GError): cint {.
    importc: "g_key_file_get_integer", libglib.}
proc setInteger*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                        value: cint) {.importc: "g_key_file_set_integer",
                                     libglib.}
proc getInt64*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                      error: var GError): int64 {.
    importc: "g_key_file_get_int64", libglib.}
proc setInt64*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                      value: int64) {.importc: "g_key_file_set_int64", libglib.}
proc getUint64*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                       error: var GError): uint64 {.
    importc: "g_key_file_get_uint64", libglib.}
proc setUint64*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                       value: uint64) {.importc: "g_key_file_set_uint64",
                                       libglib.}
proc getDouble*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                       error: var GError): cdouble {.
    importc: "g_key_file_get_double", libglib.}
proc setDouble*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                       value: cdouble) {.importc: "g_key_file_set_double",
                                       libglib.}
proc getStringList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           length: var Gsize; error: var GError): cstringArray {.
    importc: "g_key_file_get_string_list", libglib.}
proc stringList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           length: var Gsize; error: var GError): cstringArray {.
    importc: "g_key_file_get_string_list", libglib.}
proc setStringList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           list: var cstring; length: Gsize) {.
    importc: "g_key_file_set_string_list", libglib.}
proc `stringList=`*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           list: var cstring; length: Gsize) {.
    importc: "g_key_file_set_string_list", libglib.}
proc getLocaleStringList*(keyFile: GKeyFile; groupName: cstring;
                                 key: cstring; locale: cstring; length: var Gsize;
                                 error: var GError): cstringArray {.
    importc: "g_key_file_get_locale_string_list", libglib.}
proc localeStringList*(keyFile: GKeyFile; groupName: cstring;
                                 key: cstring; locale: cstring; length: var Gsize;
                                 error: var GError): cstringArray {.
    importc: "g_key_file_get_locale_string_list", libglib.}
proc setLocaleStringList*(keyFile: GKeyFile; groupName: cstring;
                                 key: cstring; locale: cstring; list: var cstring;
                                 length: Gsize) {.
    importc: "g_key_file_set_locale_string_list", libglib.}
proc `localeStringList=`*(keyFile: GKeyFile; groupName: cstring;
                                 key: cstring; locale: cstring; list: var cstring;
                                 length: Gsize) {.
    importc: "g_key_file_set_locale_string_list", libglib.}
proc getBooleanList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                            length: var Gsize; error: var GError): ptr Gboolean {.
    importc: "g_key_file_get_boolean_list", libglib.}
proc booleanList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                            length: var Gsize; error: var GError): ptr Gboolean {.
    importc: "g_key_file_get_boolean_list", libglib.}
proc setBooleanList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                            list: var Gboolean; length: Gsize) {.
    importc: "g_key_file_set_boolean_list", libglib.}
proc `booleanList=`*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                            list: var Gboolean; length: Gsize) {.
    importc: "g_key_file_set_boolean_list", libglib.}
proc getIntegerList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                            length: var Gsize; error: var GError): ptr cint {.
    importc: "g_key_file_get_integer_list", libglib.}
proc integerList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                            length: var Gsize; error: var GError): ptr cint {.
    importc: "g_key_file_get_integer_list", libglib.}
proc setDoubleList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           list: var cdouble; length: Gsize) {.
    importc: "g_key_file_set_double_list", libglib.}
proc `doubleList=`*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           list: var cdouble; length: Gsize) {.
    importc: "g_key_file_set_double_list", libglib.}
proc getDoubleList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           length: var Gsize; error: var GError): ptr cdouble {.
    importc: "g_key_file_get_double_list", libglib.}
proc doubleList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           length: var Gsize; error: var GError): ptr cdouble {.
    importc: "g_key_file_get_double_list", libglib.}
proc setIntegerList*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                            list: var cint; length: Gsize) {.
    importc: "g_key_file_set_integer_list", libglib.}
proc `integerList=`*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                            list: var cint; length: Gsize) {.
    importc: "g_key_file_set_integer_list", libglib.}
proc setComment*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                        comment: cstring; error: var GError): Gboolean {.
    importc: "g_key_file_set_comment", libglib.}
proc getComment*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                        error: var GError): cstring {.
    importc: "g_key_file_get_comment", libglib.}
proc comment*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                        error: var GError): cstring {.
    importc: "g_key_file_get_comment", libglib.}
proc removeComment*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                           error: var GError): Gboolean {.
    importc: "g_key_file_remove_comment", libglib.}
proc removeKey*(keyFile: GKeyFile; groupName: cstring; key: cstring;
                       error: var GError): Gboolean {.
    importc: "g_key_file_remove_key", libglib.}
proc removeGroup*(keyFile: GKeyFile; groupName: cstring;
                         error: var GError): Gboolean {.
    importc: "g_key_file_remove_group", libglib.}

const
  G_KEY_FILE_DESKTOP_GROUP* = "Desktop Entry"
  G_KEY_FILE_DESKTOP_KEY_TYPE* = "Type"
  G_KEY_FILE_DESKTOP_KEY_VERSION* = "Version"
  G_KEY_FILE_DESKTOP_KEY_NAME* = "Name"
  G_KEY_FILE_DESKTOP_KEY_GENERIC_NAME* = "GenericName"
  G_KEY_FILE_DESKTOP_KEY_NO_DISPLAY* = "NoDisplay"
  G_KEY_FILE_DESKTOP_KEY_COMMENT* = "Comment"
  G_KEY_FILE_DESKTOP_KEY_ICON* = "Icon"
  G_KEY_FILE_DESKTOP_KEY_HIDDEN* = "Hidden"
  G_KEY_FILE_DESKTOP_KEY_ONLY_SHOW_IN* = "OnlyShowIn"
  G_KEY_FILE_DESKTOP_KEY_NOT_SHOW_IN* = "NotShowIn"
  G_KEY_FILE_DESKTOP_KEY_TRY_EXEC* = "TryExec"
  G_KEY_FILE_DESKTOP_KEY_EXEC* = "Exec"
  G_KEY_FILE_DESKTOP_KEY_PATH* = "Path"
  G_KEY_FILE_DESKTOP_KEY_TERMINAL* = "Terminal"
  G_KEY_FILE_DESKTOP_KEY_MIME_TYPE* = "MimeType"
  G_KEY_FILE_DESKTOP_KEY_CATEGORIES* = "Categories"
  G_KEY_FILE_DESKTOP_KEY_STARTUP_NOTIFY* = "StartupNotify"
  G_KEY_FILE_DESKTOP_KEY_STARTUP_WM_CLASS* = "StartupWMClass"
  G_KEY_FILE_DESKTOP_KEY_URL* = "URL"
  G_KEY_FILE_DESKTOP_KEY_DBUS_ACTIVATABLE* = "DBusActivatable"
  G_KEY_FILE_DESKTOP_KEY_ACTIONS* = "Actions"
  G_KEY_FILE_DESKTOP_TYPE_APPLICATION* = "Application"
  G_KEY_FILE_DESKTOP_TYPE_LINK* = "Link"
  G_KEY_FILE_DESKTOP_TYPE_DIRECTORY* = "Directory"

type
  GMappedFile* =  ptr GMappedFileObj
  GMappedFilePtr* = ptr GMappedFileObj
  GMappedFileObj* = object

proc newMappedFile*(filename: cstring; writable: Gboolean; error: var GError): GMappedFile {.
    importc: "g_mapped_file_new", libglib.}
proc newMappedFile*(fd: cint; writable: Gboolean; error: var GError): GMappedFile {.
    importc: "g_mapped_file_new_from_fd", libglib.}
proc getLength*(file: GMappedFile): Gsize {.
    importc: "g_mapped_file_get_length", libglib.}
proc length*(file: GMappedFile): Gsize {.
    importc: "g_mapped_file_get_length", libglib.}
proc getContents*(file: GMappedFile): cstring {.
    importc: "g_mapped_file_get_contents", libglib.}
proc contents*(file: GMappedFile): cstring {.
    importc: "g_mapped_file_get_contents", libglib.}
proc getBytes*(file: GMappedFile): GBytes {.
    importc: "g_mapped_file_get_bytes", libglib.}
proc bytes*(file: GMappedFile): GBytes {.
    importc: "g_mapped_file_get_bytes", libglib.}
proc `ref`*(file: GMappedFile): GMappedFile {.
    importc: "g_mapped_file_ref", libglib.}
proc unref*(file: GMappedFile) {.importc: "g_mapped_file_unref",
    libglib.}
proc free*(file: GMappedFile) {.importc: "g_mapped_file_free",
    libglib.}

type
  GMarkupError* {.size: sizeof(cint), pure.} = enum
    BAD_UTF8, EMPTY, PARSE,
    UNKNOWN_ELEMENT, UNKNOWN_ATTRIBUTE,
    INVALID_CONTENT, MISSING_ATTRIBUTE

proc markupErrorQuark*(): GQuark {.importc: "g_markup_error_quark", libglib.}

type
  GMarkupParseFlags* {.size: sizeof(cint), pure.} = enum
    DO_NOT_USE_THIS_UNSUPPORTED_FLAG = 1 shl 0,
    TREAT_CDATA_AS_TEXT = 1 shl 1, PREFIX_ERROR_POSITION = 1 shl 2,
    IGNORE_QUALIFIED = 1 shl 3

type
  GMarkupParseContext* =  ptr GMarkupParseContextObj
  GMarkupParseContextPtr* = ptr GMarkupParseContextObj
  GMarkupParseContextObj* = object

type
  GMarkupParser* =  ptr GMarkupParserObj
  GMarkupParserPtr* = ptr GMarkupParserObj
  GMarkupParserObj* = object
    startElement*: proc (context: GMarkupParseContext; elementName: cstring;
                       attributeNames: cstringArray;
                       attributeValues: cstringArray; userData: Gpointer;
                       error: var GError) {.cdecl.}
    endElement*: proc (context: GMarkupParseContext; elementName: cstring;
                     userData: Gpointer; error: var GError) {.cdecl.}
    text*: proc (context: GMarkupParseContext; text: cstring; textLen: Gsize;
               userData: Gpointer; error: var GError) {.cdecl.}
    passthrough*: proc (context: GMarkupParseContext; passthroughText: cstring;
                      textLen: Gsize; userData: Gpointer; error: var GError) {.cdecl.}
    error*: proc (context: GMarkupParseContext; error: GError;
                userData: Gpointer) {.cdecl.}

proc newMarkupParseContext*(parser: GMarkupParser; flags: GMarkupParseFlags;
                            userData: Gpointer; userDataDnotify: GDestroyNotify): GMarkupParseContext {.
    importc: "g_markup_parse_context_new", libglib.}
proc `ref`*(context: GMarkupParseContext): GMarkupParseContext {.
    importc: "g_markup_parse_context_ref", libglib.}
proc unref*(context: GMarkupParseContext) {.
    importc: "g_markup_parse_context_unref", libglib.}
proc free*(context: GMarkupParseContext) {.
    importc: "g_markup_parse_context_free", libglib.}
proc parse*(context: GMarkupParseContext; text: cstring;
                              textLen: Gssize; error: var GError): Gboolean {.
    importc: "g_markup_parse_context_parse", libglib.}
proc push*(context: GMarkupParseContext;
                             parser: GMarkupParser; userData: Gpointer) {.
    importc: "g_markup_parse_context_push", libglib.}
proc pop*(context: GMarkupParseContext): Gpointer {.
    importc: "g_markup_parse_context_pop", libglib.}
proc endParse*(context: GMarkupParseContext;
                                 error: var GError): Gboolean {.
    importc: "g_markup_parse_context_end_parse", libglib.}
proc getElement*(context: GMarkupParseContext): cstring {.
    importc: "g_markup_parse_context_get_element", libglib.}
proc element*(context: GMarkupParseContext): cstring {.
    importc: "g_markup_parse_context_get_element", libglib.}
proc getElementStack*(context: GMarkupParseContext): GSList {.
    importc: "g_markup_parse_context_get_element_stack", libglib.}
proc elementStack*(context: GMarkupParseContext): GSList {.
    importc: "g_markup_parse_context_get_element_stack", libglib.}

proc getPosition*(context: GMarkupParseContext;
                                    lineNumber: var cint; charNumber: var cint) {.
    importc: "g_markup_parse_context_get_position", libglib.}
proc getUserData*(context: GMarkupParseContext): Gpointer {.
    importc: "g_markup_parse_context_get_user_data", libglib.}
proc userData*(context: GMarkupParseContext): Gpointer {.
    importc: "g_markup_parse_context_get_user_data", libglib.}

proc markupEscapeText*(text: cstring; length: Gssize): cstring {.
    importc: "g_markup_escape_text", libglib.}
proc markupPrintfEscaped*(format: cstring): cstring {.varargs,
    importc: "g_markup_printf_escaped", libglib.}
when (VALIST):
  proc markupVprintfEscaped*(format: cstring; args: VaList): cstring {.
      importc: "g_markup_vprintf_escaped", libglib.}
type
  GMarkupCollectType* {.size: sizeof(cint), pure.} = enum
    INVALID, STRING, STRDUP,
    BOOLEAN, TRISTATE,
    OPTIONAL = (1 shl 16)

proc markupCollectAttributes*(elementName: cstring; attributeNames: cstringArray;
                              attributeValues: cstringArray;
                              error: var GError; firstType: GMarkupCollectType;
                              firstAttr: cstring): Gboolean {.varargs,
    importc: "g_markup_collect_attributes", libglib.}

type
  GVariantType* =  ptr GVariantTypeObj
  GVariantTypePtr* = ptr GVariantTypeObj
  GVariantTypeObj* = object

const
  G_VARIANT_TYPE_BOOLEAN* = (cast[GVariantType]("b".cstring))

const
  G_VARIANT_TYPE_BYTE* = (cast[GVariantType]("y".cstring))

const
  G_VARIANT_TYPE_INT16* = (cast[GVariantType]("n".cstring))

const
  G_VARIANT_TYPE_UINT16* = (cast[GVariantType]("q".cstring))

const
  G_VARIANT_TYPE_INT32* = (cast[GVariantType]("i".cstring))

const
  G_VARIANT_TYPE_UINT32* = (cast[GVariantType]("u".cstring))

const
  G_VARIANT_TYPE_INT64* = (cast[GVariantType]("x".cstring))

const
  G_VARIANT_TYPE_UINT64* = (cast[GVariantType]("t".cstring))

const
  G_VARIANT_TYPE_DOUBLE* = (cast[GVariantType]("d".cstring))

const
  G_VARIANT_TYPE_STRING* = (cast[GVariantType]("s".cstring))

const
  G_VARIANT_TYPE_OBJECT_PATH* = (cast[GVariantType]("o".cstring))

const
  G_VARIANT_TYPE_SIGNATURE* = (cast[GVariantType]("g".cstring))

const
  G_VARIANT_TYPE_VARIANT* = (cast[GVariantType]("v".cstring))

const
  G_VARIANT_TYPE_HANDLE* = (cast[GVariantType]("h".cstring))

const
  G_VARIANT_TYPE_UNIT* = (cast[GVariantType]("()".cstring))

const
  G_VARIANT_TYPE_ANY* = (cast[GVariantType]("*".cstring))

const
  G_VARIANT_TYPE_BASIC* = (cast[GVariantType]("?".cstring))

const
  G_VARIANT_TYPE_MAYBE* = (cast[GVariantType]("m*".cstring))

const
  G_VARIANT_TYPE_ARRAY* = (cast[GVariantType]("a*".cstring))

const
  G_VARIANT_TYPE_TUPLE* = (cast[GVariantType]("r".cstring))

const
  G_VARIANT_TYPE_DICT_ENTRY* = (cast[GVariantType]("{?*}".cstring))

const
  G_VARIANT_TYPE_DICTIONARY* = (cast[GVariantType]("a{?*}".cstring))

const
  G_VARIANT_TYPE_STRING_ARRAY* = (cast[GVariantType]("as".cstring))

const
  G_VARIANT_TYPE_OBJECT_PATH_ARRAY* = (cast[GVariantType]("ao".cstring))

const
  G_VARIANT_TYPE_BYTESTRING* = (cast[GVariantType]("ay".cstring))

const
  G_VARIANT_TYPE_BYTESTRING_ARRAY* = (cast[GVariantType]("aay".cstring))

const
  G_VARIANT_TYPE_VARDICT* = (cast[GVariantType]("a{sv}".cstring))

when not (G_DISABLE_CHECKS):
  template gVariantType*(typeString: untyped): untyped =
    (variantTypeChecked(typeString))

else:
  template gVariantType*(typeString: untyped): untyped =
    (cast[GVariantType](typeString))

proc variantTypeStringIsValid*(typeString: cstring): Gboolean {.
    importc: "g_variant_type_string_is_valid", libglib.}
proc variantTypeStringScan*(string: cstring; limit: cstring; endptr: cstringArray): Gboolean {.
    importc: "g_variant_type_string_scan", libglib.}

proc free*(`type`: GVariantType) {.importc: "g_variant_type_free",
    libglib.}
proc copy*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_copy", libglib.}
proc newVariantType*(typeString: cstring): GVariantType {.
    importc: "g_variant_type_new", libglib.}

proc getStringLength*(`type`: GVariantType): Gsize {.
    importc: "g_variant_type_get_string_length", libglib.}

proc stringLength*(`type`: GVariantType): Gsize {.
    importc: "g_variant_type_get_string_length", libglib.}
proc peekString*(`type`: GVariantType): cstring {.
    importc: "g_variant_type_peek_string", libglib.}
proc dupString*(`type`: GVariantType): cstring {.
    importc: "g_variant_type_dup_string", libglib.}

proc isDefinite*(`type`: GVariantType): Gboolean {.
    importc: "g_variant_type_is_definite", libglib.}
proc isContainer*(`type`: GVariantType): Gboolean {.
    importc: "g_variant_type_is_container", libglib.}
proc isBasic*(`type`: GVariantType): Gboolean {.
    importc: "g_variant_type_is_basic", libglib.}
proc isMaybe*(`type`: GVariantType): Gboolean {.
    importc: "g_variant_type_is_maybe", libglib.}
proc isArray*(`type`: GVariantType): Gboolean {.
    importc: "g_variant_type_is_array", libglib.}
proc isTuple*(`type`: GVariantType): Gboolean {.
    importc: "g_variant_type_is_tuple", libglib.}
proc isDictEntry*(`type`: GVariantType): Gboolean {.
    importc: "g_variant_type_is_dict_entry", libglib.}
proc isVariant*(`type`: GVariantType): Gboolean {.
    importc: "g_variant_type_is_variant", libglib.}

proc variantTypeHash*(`type`: Gconstpointer): cuint {.
    importc: "g_variant_type_hash", libglib.}
proc variantTypeEqual*(type1: Gconstpointer; type2: Gconstpointer): Gboolean {.
    importc: "g_variant_type_equal", libglib.}

proc isSubtypeOf*(`type`: GVariantType; supertype: GVariantType): Gboolean {.
    importc: "g_variant_type_is_subtype_of", libglib.}

proc element*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_element", libglib.}
proc first*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_first", libglib.}
proc next*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_next", libglib.}
proc nItems*(`type`: GVariantType): Gsize {.
    importc: "g_variant_type_n_items", libglib.}
proc key*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_key", libglib.}
proc value*(`type`: GVariantType): GVariantType {.
    importc: "g_variant_type_value", libglib.}

proc newArray*(element: GVariantType): GVariantType {.
    importc: "g_variant_type_new_array", libglib.}
proc newMaybe*(element: GVariantType): GVariantType {.
    importc: "g_variant_type_new_maybe", libglib.}
proc newTuple*(items: var GVariantType; length: cint): GVariantType {.
    importc: "g_variant_type_new_tuple", libglib.}
proc newDictEntry*(key: GVariantType; value: GVariantType): GVariantType {.
    importc: "g_variant_type_new_dict_entry", libglib.}

proc variantTypeChecked*(a2: cstring): GVariantType {.
    importc: "g_variant_type_checked_", libglib.}

type
  GVariant* =  ptr GVariantObj
  GVariantPtr* = ptr GVariantObj
  GVariantObj* = object

  GVariantClass* {.size: sizeof(cint), pure.} = enum
    TUPLE = '(',
    ARRAY = 'a',
    BOOLEAN = 'b',
    DOUBLE = 'd',
    SIGNATURE = 'g',
    HANDLE = 'h',
    INT32 = 'i',
    MAYBE = 'm',
    INT16 = 'n',
    OBJECT_PATH = 'o',
    UINT16 = 'q',
    STRING = 's',
    UINT64 = 't',
    UINT32 = 'u',
    VARIANT = 'v',
    INT64 = 'x',
    BYTE = 'y',
    DICT_ENTRY = '{'

proc unref*(value: GVariant) {.importc: "g_variant_unref", libglib.}
proc `ref`*(value: GVariant): GVariant {.importc: "g_variant_ref",
    libglib.}
proc refSink*(value: GVariant): GVariant {.
    importc: "g_variant_ref_sink", libglib.}
proc isFloating*(value: GVariant): Gboolean {.
    importc: "g_variant_is_floating", libglib.}
proc takeRef*(value: GVariant): GVariant {.
    importc: "g_variant_take_ref", libglib.}
proc getType*(value: GVariant): GVariantType {.
    importc: "g_variant_get_type", libglib.}
proc type*(value: GVariant): GVariantType {.
    importc: "g_variant_get_type", libglib.}
proc getTypeString*(value: GVariant): cstring {.
    importc: "g_variant_get_type_string", libglib.}
proc typeString*(value: GVariant): cstring {.
    importc: "g_variant_get_type_string", libglib.}
proc isOfType*(value: GVariant; `type`: GVariantType): Gboolean {.
    importc: "g_variant_is_of_type", libglib.}
proc isContainer*(value: GVariant): Gboolean {.
    importc: "g_variant_is_container", libglib.}
proc classify*(value: GVariant): GVariantClass {.
    importc: "g_variant_classify", libglib.}
proc variantNewBoolean*(value: Gboolean): GVariant {.
    importc: "g_variant_new_boolean", libglib.}
proc variantNewByte*(value: cuchar): GVariant {.importc: "g_variant_new_byte",
    libglib.}
proc variantNewInt16*(value: int16): GVariant {.importc: "g_variant_new_int16",
    libglib.}
proc variantNewUint16*(value: uint16): GVariant {.
    importc: "g_variant_new_uint16", libglib.}
proc variantNewInt32*(value: int32): GVariant {.importc: "g_variant_new_int32",
    libglib.}
proc variantNewUint32*(value: uint32): GVariant {.
    importc: "g_variant_new_uint32", libglib.}
proc variantNewInt64*(value: int64): GVariant {.importc: "g_variant_new_int64",
    libglib.}
proc variantNewUint64*(value: uint64): GVariant {.
    importc: "g_variant_new_uint64", libglib.}
proc variantNewHandle*(value: int32): GVariant {.
    importc: "g_variant_new_handle", libglib.}
proc variantNewDouble*(value: cdouble): GVariant {.
    importc: "g_variant_new_double", libglib.}
proc variantNewString*(string: cstring): GVariant {.
    importc: "g_variant_new_string", libglib.}
proc variantNewTakeString*(string: cstring): GVariant {.
    importc: "g_variant_new_take_string", libglib.}
proc variantNewPrintf*(formatString: cstring): GVariant {.varargs,
    importc: "g_variant_new_printf", libglib.}
proc variantNewObjectPath*(objectPath: cstring): GVariant {.
    importc: "g_variant_new_object_path", libglib.}
proc variantIsObjectPath*(string: cstring): Gboolean {.
    importc: "g_variant_is_object_path", libglib.}
proc variantNewSignature*(signature: cstring): GVariant {.
    importc: "g_variant_new_signature", libglib.}
proc variantIsSignature*(string: cstring): Gboolean {.
    importc: "g_variant_is_signature", libglib.}
proc newGVariant*(value: GVariant): GVariant {.
    importc: "g_variant_new_variant", libglib.}
proc variantNewStrv*(strv: cstringArray; length: Gssize): GVariant {.
    importc: "g_variant_new_strv", libglib.}
proc variantNewObjv*(strv: cstringArray; length: Gssize): GVariant {.
    importc: "g_variant_new_objv", libglib.}
proc variantNewBytestring*(string: cstring): GVariant {.
    importc: "g_variant_new_bytestring", libglib.}
proc variantNewBytestringArray*(strv: cstringArray; length: Gssize): GVariant {.
    importc: "g_variant_new_bytestring_array", libglib.}
proc variantNewFixedArray*(elementType: GVariantType; elements: Gconstpointer;
                           nElements: Gsize; elementSize: Gsize): GVariant {.
    importc: "g_variant_new_fixed_array", libglib.}
proc getBoolean*(value: GVariant): Gboolean {.
    importc: "g_variant_get_boolean", libglib.}
proc getByte*(value: GVariant): cuchar {.importc: "g_variant_get_byte",
    libglib.}
proc byte*(value: GVariant): cuchar {.importc: "g_variant_get_byte",
    libglib.}
proc getInt16*(value: GVariant): int16 {.importc: "g_variant_get_int16",
    libglib.}
proc int16*(value: GVariant): int16 {.importc: "g_variant_get_int16",
    libglib.}
proc getUint16*(value: GVariant): uint16 {.
    importc: "g_variant_get_uint16", libglib.}
proc uint16*(value: GVariant): uint16 {.
    importc: "g_variant_get_uint16", libglib.}
proc getInt32*(value: GVariant): int32 {.importc: "g_variant_get_int32",
    libglib.}
proc int32*(value: GVariant): int32 {.importc: "g_variant_get_int32",
    libglib.}
proc getUint32*(value: GVariant): uint32 {.
    importc: "g_variant_get_uint32", libglib.}
proc uint32*(value: GVariant): uint32 {.
    importc: "g_variant_get_uint32", libglib.}
proc getInt64*(value: GVariant): int64 {.importc: "g_variant_get_int64",
    libglib.}
proc getUint64*(value: GVariant): uint64 {.
    importc: "g_variant_get_uint64", libglib.}
proc getHandle*(value: GVariant): int32 {.
    importc: "g_variant_get_handle", libglib.}
proc handle*(value: GVariant): int32 {.
    importc: "g_variant_get_handle", libglib.}
proc getDouble*(value: GVariant): cdouble {.
    importc: "g_variant_get_double", libglib.}
proc getVariant*(value: GVariant): GVariant {.
    importc: "g_variant_get_variant", libglib.}
proc variant*(value: GVariant): GVariant {.
    importc: "g_variant_get_variant", libglib.}
proc getString*(value: GVariant; length: var Gsize): cstring {.
    importc: "g_variant_get_string", libglib.}
proc dupString*(value: GVariant; length: var Gsize): cstring {.
    importc: "g_variant_dup_string", libglib.}
proc getStrv*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_get_strv", libglib.}
proc strv*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_get_strv", libglib.}
proc dupStrv*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_dup_strv", libglib.}
proc getObjv*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_get_objv", libglib.}
proc objv*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_get_objv", libglib.}
proc dupObjv*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_dup_objv", libglib.}
proc getBytestring*(value: GVariant): cstring {.
    importc: "g_variant_get_bytestring", libglib.}
proc bytestring*(value: GVariant): cstring {.
    importc: "g_variant_get_bytestring", libglib.}
proc dupBytestring*(value: GVariant; length: var Gsize): cstring {.
    importc: "g_variant_dup_bytestring", libglib.}
proc getBytestringArray*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_get_bytestring_array", libglib.}
proc bytestringArray*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_get_bytestring_array", libglib.}
proc dupBytestringArray*(value: GVariant; length: var Gsize): cstringArray {.
    importc: "g_variant_dup_bytestring_array", libglib.}
proc variantNewMaybe*(childType: GVariantType; child: GVariant): GVariant {.
    importc: "g_variant_new_maybe", libglib.}
proc variantNewArray*(childType: GVariantType; children: var GVariant;
                      nChildren: Gsize): GVariant {.
    importc: "g_variant_new_array", libglib.}
proc newTuple*(children: var GVariant; nChildren: Gsize): GVariant {.
    importc: "g_variant_new_tuple", libglib.}
proc newDictEntry*(key: GVariant; value: GVariant): GVariant {.
    importc: "g_variant_new_dict_entry", libglib.}
proc getMaybe*(value: GVariant): GVariant {.
    importc: "g_variant_get_maybe", libglib.}
proc maybe*(value: GVariant): GVariant {.
    importc: "g_variant_get_maybe", libglib.}
proc nChildren*(value: GVariant): Gsize {.
    importc: "g_variant_n_children", libglib.}
proc getChild*(value: GVariant; index: Gsize; formatString: cstring) {.
    varargs, importc: "g_variant_get_child", libglib.}
proc getChildValue*(value: GVariant; index: Gsize): GVariant {.
    importc: "g_variant_get_child_value", libglib.}
proc childValue*(value: GVariant; index: Gsize): GVariant {.
    importc: "g_variant_get_child_value", libglib.}
proc lookup*(dictionary: GVariant; key: cstring; formatString: cstring): Gboolean {.
    varargs, importc: "g_variant_lookup", libglib.}
proc lookupValue*(dictionary: GVariant; key: cstring;
                         expectedType: GVariantType): GVariant {.
    importc: "g_variant_lookup_value", libglib.}
proc getFixedArray*(value: GVariant; nElements: var Gsize;
                           elementSize: Gsize): Gconstpointer {.
    importc: "g_variant_get_fixed_array", libglib.}
proc fixedArray*(value: GVariant; nElements: var Gsize;
                           elementSize: Gsize): Gconstpointer {.
    importc: "g_variant_get_fixed_array", libglib.}
proc getSize*(value: GVariant): Gsize {.importc: "g_variant_get_size",
    libglib.}
proc size*(value: GVariant): Gsize {.importc: "g_variant_get_size",
    libglib.}
proc getData*(value: GVariant): Gconstpointer {.
    importc: "g_variant_get_data", libglib.}
proc data*(value: GVariant): Gconstpointer {.
    importc: "g_variant_get_data", libglib.}
proc getDataAsBytes*(value: GVariant): GBytes {.
    importc: "g_variant_get_data_as_bytes", libglib.}
proc dataAsBytes*(value: GVariant): GBytes {.
    importc: "g_variant_get_data_as_bytes", libglib.}
proc store*(value: GVariant; data: Gpointer) {.importc: "g_variant_store",
    libglib.}
proc print*(value: GVariant; typeAnnotate: Gboolean): cstring {.
    importc: "g_variant_print", libglib.}
proc printString*(value: GVariant; string: GString;
                         typeAnnotate: Gboolean): GString {.
    importc: "g_variant_print_string", libglib.}
proc variantHash*(value: Gconstpointer): cuint {.importc: "g_variant_hash",
    libglib.}
proc variantEqual*(one: Gconstpointer; two: Gconstpointer): Gboolean {.
    importc: "g_variant_equal", libglib.}
proc getNormalForm*(value: GVariant): GVariant {.
    importc: "g_variant_get_normal_form", libglib.}
proc normalForm*(value: GVariant): GVariant {.
    importc: "g_variant_get_normal_form", libglib.}
proc isNormalForm*(value: GVariant): Gboolean {.
    importc: "g_variant_is_normal_form", libglib.}
proc byteswap*(value: GVariant): GVariant {.
    importc: "g_variant_byteswap", libglib.}
proc variantNewFromBytes*(`type`: GVariantType; bytes: GBytes;
                          trusted: Gboolean): GVariant {.
    importc: "g_variant_new_from_bytes", libglib.}
proc variantNewFromData*(`type`: GVariantType; data: Gconstpointer; size: Gsize;
                         trusted: Gboolean; notify: GDestroyNotify;
                         userData: Gpointer): GVariant {.
    importc: "g_variant_new_from_data", libglib.}
type
  GVariantIter* =  ptr GVariantIterObj
  GVariantIterPtr* = ptr GVariantIterObj
  GVariantIterObj* = object
    x*: array[16, Gsize]

proc newIter*(value: GVariant): GVariantIter {.
    importc: "g_variant_iter_new", libglib.}
proc init*(iter: GVariantIter; value: GVariant): Gsize {.
    importc: "g_variant_iter_init", libglib.}
proc copy*(iter: GVariantIter): GVariantIter {.
    importc: "g_variant_iter_copy", libglib.}
proc nChildren*(iter: GVariantIter): Gsize {.
    importc: "g_variant_iter_n_children", libglib.}
proc free*(iter: GVariantIter) {.importc: "g_variant_iter_free",
    libglib.}
proc nextValue*(iter: GVariantIter): GVariant {.
    importc: "g_variant_iter_next_value", libglib.}
proc next*(iter: GVariantIter; formatString: cstring): Gboolean {.
    varargs, importc: "g_variant_iter_next", libglib.}
proc loop*(iter: GVariantIter; formatString: cstring): Gboolean {.
    varargs, importc: "g_variant_iter_loop", libglib.}
type
  INNER_C_STRUCT_594656511* =  ptr INNER_C_STRUCT_594656511Obj
  INNER_C_STRUCT_594656511Ptr* = ptr INNER_C_STRUCT_594656511Obj
  INNER_C_STRUCT_594656511Obj* = object
    partialMagic*: Gsize
    `type`*: GVariantType
    y*: array[14, Gsize]

  INNER_C_UNION_4109036607* {.union.} = object
    s*: INNER_C_STRUCT_594656511Obj
    x*: array[16, Gsize]

  GVariantBuilder* =  ptr GVariantBuilderObj
  GVariantBuilderPtr* = ptr GVariantBuilderObj
  GVariantBuilderObj* = object
    u*: INNER_C_UNION_4109036607

  GVariantParseError* {.size: sizeof(cint), pure.} = enum
    FAILED, BASIC_TYPE_EXPECTED,
    CANNOT_INFER_TYPE,
    DEFINITE_TYPE_EXPECTED,
    INPUT_NOT_AT_END,
    INVALID_CHARACTER,
    INVALID_FORMAT_STRING,
    INVALID_OBJECT_PATH,
    INVALID_SIGNATURE,
    INVALID_TYPE_STRING,
    NO_COMMON_TYPE,
    NUMBER_OUT_OF_RANGE,
    NUMBER_TOO_BIG, TYPE_ERROR,
    UNEXPECTED_TOKEN,
    UNKNOWN_KEYWORD,
    UNTERMINATED_STRING_CONSTANT,
    VALUE_EXPECTED

proc variantParserGetErrorQuark*(): GQuark {.
    importc: "g_variant_parser_get_error_quark", libglib.}
proc variantParseErrorQuark*(): GQuark {.importc: "g_variant_parse_error_quark",
                                       libglib.}

proc newVariantBuilder*(`type`: GVariantType): GVariantBuilder {.
    importc: "g_variant_builder_new", libglib.}
proc unref*(builder: GVariantBuilder) {.
    importc: "g_variant_builder_unref", libglib.}
proc `ref`*(builder: GVariantBuilder): GVariantBuilder {.
    importc: "g_variant_builder_ref", libglib.}
proc init*(builder: GVariantBuilder; `type`: GVariantType) {.
    importc: "g_variant_builder_init", libglib.}
proc `end`*(builder: GVariantBuilder): GVariant {.
    importc: "g_variant_builder_end", libglib.}
proc clear*(builder: GVariantBuilder) {.
    importc: "g_variant_builder_clear", libglib.}
proc open*(builder: GVariantBuilder; `type`: GVariantType) {.
    importc: "g_variant_builder_open", libglib.}
proc close*(builder: GVariantBuilder) {.
    importc: "g_variant_builder_close", libglib.}
proc addValue*(builder: GVariantBuilder; value: GVariant) {.
    importc: "g_variant_builder_add_value", libglib.}
proc add*(builder: GVariantBuilder; formatString: cstring) {.
    varargs, importc: "g_variant_builder_add", libglib.}
proc addParsed*(builder: GVariantBuilder; format: cstring) {.
    varargs, importc: "g_variant_builder_add_parsed", libglib.}
proc variantNew*(formatString: cstring): GVariant {.varargs,
    importc: "g_variant_new", libglib.}
proc get*(value: GVariant; formatString: cstring) {.varargs,
    importc: "g_variant_get", libglib.}
when (VALIST):
  proc variantNewVa*(formatString: cstring; endptr: cstringArray; app: ptr VaList): GVariant {.
      importc: "g_variant_new_va", libglib.}
  proc getVa*(value: GVariant; formatString: cstring;
                     endptr: cstringArray; app: ptr VaList) {.
      importc: "g_variant_get_va", libglib.}
  proc checkFormatString*(value: GVariant; formatString: cstring;
                                 copyOnly: Gboolean): Gboolean {.
      importc: "g_variant_check_format_string", libglib.}
when (VALIST):
  proc variantParse*(`type`: GVariantType; text: cstring; limit: cstring;
                     endptr: cstringArray; error: var GError): GVariant {.
      importc: "g_variant_parse", libglib.}
  proc variantNewParsed*(format: cstring): GVariant {.varargs,
      importc: "g_variant_new_parsed", libglib.}
  proc variantNewParsedVa*(format: cstring; app: ptr VaList): GVariant {.
      importc: "g_variant_new_parsed_va", libglib.}
proc variantParseErrorPrintContext*(error: GError; sourceStr: cstring): cstring {.
    importc: "g_variant_parse_error_print_context", libglib.}
proc variantCompare*(one: Gconstpointer; two: Gconstpointer): cint {.
    importc: "g_variant_compare", libglib.}
type
  INNER_C_STRUCT_2791128003* =  ptr INNER_C_STRUCT_2791128003Obj
  INNER_C_STRUCT_2791128003Ptr* = ptr INNER_C_STRUCT_2791128003Obj
  INNER_C_STRUCT_2791128003Obj* = object
    asv*: GVariant
    partialMagic*: Gsize
    y*: array[14, Gsize]

  INNER_C_UNION_2010540800* {.union.} = object
    s*: INNER_C_STRUCT_2791128003Obj
    x*: array[16, Gsize]

  GVariantDict* =  ptr GVariantDictObj
  GVariantDictPtr* = ptr GVariantDictObj
  GVariantDictObj* = object
    u*: INNER_C_UNION_2010540800

proc newDict*(fromAsv: GVariant): GVariantDict {.
    importc: "g_variant_dict_new", libglib.}
proc init*(dict: GVariantDict; fromAsv: GVariant) {.
    importc: "g_variant_dict_init", libglib.}
proc lookup*(dict: GVariantDict; key: cstring; formatString: cstring): Gboolean {.
    varargs, importc: "g_variant_dict_lookup", libglib.}
proc lookupValue*(dict: GVariantDict; key: cstring;
                             expectedType: GVariantType): GVariant {.
    importc: "g_variant_dict_lookup_value", libglib.}
proc contains*(dict: GVariantDict; key: cstring): Gboolean {.
    importc: "g_variant_dict_contains", libglib.}
proc insert*(dict: GVariantDict; key: cstring; formatString: cstring) {.
    varargs, importc: "g_variant_dict_insert", libglib.}
proc insertValue*(dict: GVariantDict; key: cstring;
                             value: GVariant) {.
    importc: "g_variant_dict_insert_value", libglib.}
proc remove*(dict: GVariantDict; key: cstring): Gboolean {.
    importc: "g_variant_dict_remove", libglib.}
proc clear*(dict: GVariantDict) {.importc: "g_variant_dict_clear",
    libglib.}
proc `end`*(dict: GVariantDict): GVariant {.
    importc: "g_variant_dict_end", libglib.}
proc `ref`*(dict: GVariantDict): GVariantDict {.
    importc: "g_variant_dict_ref", libglib.}
proc unref*(dict: GVariantDict) {.importc: "g_variant_dict_unref",
    libglib.}

when (VALIST):
  proc printfStringUpperBound*(format: cstring; args: VaList): Gsize {.
      importc: "g_printf_string_upper_bound", libglib.}

const
  G_LOG_LEVEL_USER_SHIFT* = 8

type
  GLogLevelFlags* {.size: sizeof(cint), pure.} = enum
    MASK = not(3)
    FLAG_RECURSION = 1 shl 0, FLAG_FATAL = 1 shl 1,
    LEVEL_ERROR = 1 shl 2,
    FATAL_MASK = GLogLevelFlags.FLAG_RECURSION.ord or GLogLevelFlags.LEVEL_ERROR.ord
    LEVEL_CRITICAL = 1 shl 3,
    LEVEL_WARNING = 1 shl 4, LEVEL_MESSAGE = 1 shl 5,
    LEVEL_INFO = 1 shl 6, LEVEL_DEBUG = 1 shl 7

type
  GLogFunc* = proc (logDomain: cstring; logLevel: GLogLevelFlags; message: cstring;
                 userData: Gpointer) {.cdecl.}

proc logSetHandler*(logDomain: cstring; logLevels: GLogLevelFlags;
                    logFunc: GLogFunc; userData: Gpointer): cuint {.
    importc: "g_log_set_handler", libglib.}
proc logSetHandlerFull*(logDomain: cstring; logLevels: GLogLevelFlags;
                        logFunc: GLogFunc; userData: Gpointer;
                        destroy: GDestroyNotify): cuint {.
    importc: "g_log_set_handler_full", libglib.}
proc logRemoveHandler*(logDomain: cstring; handlerId: cuint) {.
    importc: "g_log_remove_handler", libglib.}
proc logDefaultHandler*(logDomain: cstring; logLevel: GLogLevelFlags;
                        message: cstring; unusedData: Gpointer) {.
    importc: "g_log_default_handler", libglib.}
proc logSetDefaultHandler*(logFunc: GLogFunc; userData: Gpointer): GLogFunc {.
    importc: "g_log_set_default_handler", libglib.}
proc log*(logDomain: cstring; logLevel: GLogLevelFlags; format: cstring) {.varargs,
    importc: "g_log", libglib.}
when (VALIST):
  proc logv*(logDomain: cstring; logLevel: GLogLevelFlags; format: cstring;
             args: VaList) {.importc: "g_logv", libglib.}
proc logSetFatalMask*(logDomain: cstring; fatalMask: GLogLevelFlags): GLogLevelFlags {.
    importc: "g_log_set_fatal_mask", libglib.}
proc logSetAlwaysFatal*(fatalMask: GLogLevelFlags): GLogLevelFlags {.
    importc: "g_log_set_always_fatal", libglib.}

type
  GLogWriterOutput* {.size: sizeof(cint), pure.} = enum
    UNHANDLED = 0, HANDLED = 1

type
  GLogField* =  ptr GLogFieldObj
  GLogFieldPtr* = ptr GLogFieldObj
  GLogFieldObj* = object
    key*: cstring
    value*: Gconstpointer
    length*: Gssize

type
  GLogWriterFunc* = proc (logLevel: GLogLevelFlags; fields: GLogField;
                       nFields: Gsize; userData: Gpointer): GLogWriterOutput {.cdecl.}

proc logStructured*(logDomain: cstring; logLevel: GLogLevelFlags) {.varargs,
    importc: "g_log_structured", libglib.}
proc logStructuredArray*(logLevel: GLogLevelFlags; fields: GLogField;
                         nFields: Gsize) {.importc: "g_log_structured_array",
    libglib.}
proc logVariant*(logDomain: cstring; logLevel: GLogLevelFlags; fields: GVariant) {.
    importc: "g_log_variant", libglib.}
proc logSetWriterFunc*(`func`: GLogWriterFunc; userData: Gpointer;
                       userDataFree: GDestroyNotify) {.
    importc: "g_log_set_writer_func", libglib.}
proc logWriterSupportsColor*(outputFd: cint): Gboolean {.
    importc: "g_log_writer_supports_color", libglib.}
proc logWriterIsJournald*(outputFd: cint): Gboolean {.
    importc: "g_log_writer_is_journald", libglib.}
proc logWriterFormatFields*(logLevel: GLogLevelFlags; fields: GLogField;
                            nFields: Gsize; useColor: Gboolean): cstring {.
    importc: "g_log_writer_format_fields", libglib.}
proc logWriterJournald*(logLevel: GLogLevelFlags; fields: GLogField;
                        nFields: Gsize; userData: Gpointer): GLogWriterOutput {.
    importc: "g_log_writer_journald", libglib.}
proc logWriterStandardStreams*(logLevel: GLogLevelFlags; fields: GLogField;
                               nFields: Gsize; userData: Gpointer): GLogWriterOutput {.
    importc: "g_log_writer_standard_streams", libglib.}
proc logWriterDefault*(logLevel: GLogLevelFlags; fields: GLogField;
                       nFields: Gsize; userData: Gpointer): GLogWriterOutput {.
    importc: "g_log_writer_default", libglib.}

template gDebugHere*(): untyped =
  gLogStructured(g_Log_Domain, g_Log_Level_Debug, "CODE_FILE", file, "CODE_LINE",
                 g_Stringify(line), "CODE_FUNC", g_Strfunc, "MESSAGE", "%",
                 g_Gint64Format, ": %s", gGetMonotonicTime(), g_Strloc)

proc logFallbackHandler*(logDomain: cstring; logLevel: GLogLevelFlags;
                         message: cstring; unusedData: Gpointer) {.
    importc: "_g_log_fallback_handler", libglib.}

proc returnIfFailWarning*(logDomain: cstring; prettyFunction: cstring;
                          expression: cstring) {.
    importc: "g_return_if_fail_warning", libglib.}
proc warnMessage*(domain: cstring; file: cstring; line: cint; `func`: cstring;
                  warnexpr: cstring) {.importc: "g_warn_message", libglib.}
proc assertWarning*(logDomain: cstring; file: cstring; line: cint;
                    prettyFunction: cstring; expression: cstring) {.
    importc: "g_assert_warning", libglib.}

type
  GPrintFunc* = proc (string: cstring) {.cdecl.}

proc print*(format: cstring) {.varargs, importc: "g_print", libglib.}
proc setPrintHandler*(`func`: GPrintFunc): GPrintFunc {.
    importc: "g_set_print_handler", libglib.}
proc printerr*(format: cstring) {.varargs, importc: "g_printerr", libglib.}
proc setPrinterrHandler*(`func`: GPrintFunc): GPrintFunc {.
    importc: "g_set_printerr_handler", libglib.}

type
  GOptionContext* =  ptr GOptionContextObj
  GOptionContextPtr* = ptr GOptionContextObj
  GOptionContextObj* = object

type
  GOptionGroup* =  ptr GOptionGroupObj
  GOptionGroupPtr* = ptr GOptionGroupObj
  GOptionGroupObj* = object

type
  GOptionFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, HIDDEN = 1 shl 0,
    IN_MAIN = 1 shl 1, REVERSE = 1 shl 2,
    NO_ARG = 1 shl 3, FILENAME = 1 shl 4,
    OPTIONAL_ARG = 1 shl 5, NOALIAS = 1 shl 6

type
  GOptionArg* {.size: sizeof(cint), pure.} = enum
    NONE, STRING, INT,
    CALLBACK, FILENAME, STRING_ARRAY,
    FILENAME_ARRAY, DOUBLE, INT64

type
  GOptionArgFunc* = proc (optionName: cstring; value: cstring; data: Gpointer;
                       error: var GError): Gboolean {.cdecl.}

type
  GOptionParseFunc* = proc (context: GOptionContext; group: GOptionGroup;
                         data: Gpointer; error: var GError): Gboolean {.cdecl.}

type
  GOptionErrorFunc* = proc (context: GOptionContext; group: GOptionGroup;
                         data: Gpointer; error: var GError) {.cdecl.}

type
  GOptionError* {.size: sizeof(cint), pure.} = enum
    UNKNOWN_OPTION, BAD_VALUE, FAILED

proc optionErrorQuark*(): GQuark {.importc: "g_option_error_quark", libglib.}

type
  GOptionEntry* =  ptr GOptionEntryObj
  GOptionEntryPtr* = ptr GOptionEntryObj
  GOptionEntryObj* = object
    longName*: cstring
    shortName*: char
    flags*: cint
    arg*: GOptionArg
    argData*: Gpointer
    description*: cstring
    argDescription*: cstring

const
  G_OPTION_REMAINING* = ""

proc newOptionContext*(parameterString: cstring): GOptionContext {.
    importc: "g_option_context_new", libglib.}
proc setSummary*(context: GOptionContext; summary: cstring) {.
    importc: "g_option_context_set_summary", libglib.}
proc `summary=`*(context: GOptionContext; summary: cstring) {.
    importc: "g_option_context_set_summary", libglib.}
proc getSummary*(context: GOptionContext): cstring {.
    importc: "g_option_context_get_summary", libglib.}
proc summary*(context: GOptionContext): cstring {.
    importc: "g_option_context_get_summary", libglib.}
proc setDescription*(context: GOptionContext; description: cstring) {.
    importc: "g_option_context_set_description", libglib.}
proc `description=`*(context: GOptionContext; description: cstring) {.
    importc: "g_option_context_set_description", libglib.}
proc getDescription*(context: GOptionContext): cstring {.
    importc: "g_option_context_get_description", libglib.}
proc description*(context: GOptionContext): cstring {.
    importc: "g_option_context_get_description", libglib.}
proc free*(context: GOptionContext) {.
    importc: "g_option_context_free", libglib.}
proc setHelpEnabled*(context: GOptionContext;
                                  helpEnabled: Gboolean) {.
    importc: "g_option_context_set_help_enabled", libglib.}
proc `helpEnabled=`*(context: GOptionContext;
                                  helpEnabled: Gboolean) {.
    importc: "g_option_context_set_help_enabled", libglib.}
proc getHelpEnabled*(context: GOptionContext): Gboolean {.
    importc: "g_option_context_get_help_enabled", libglib.}
proc helpEnabled*(context: GOptionContext): Gboolean {.
    importc: "g_option_context_get_help_enabled", libglib.}
proc setIgnoreUnknownOptions*(context: GOptionContext;
    ignoreUnknown: Gboolean) {.importc: "g_option_context_set_ignore_unknown_options",
                             libglib.}
proc `ignoreUnknownOptions=`*(context: GOptionContext;
    ignoreUnknown: Gboolean) {.importc: "g_option_context_set_ignore_unknown_options",
                             libglib.}
proc getIgnoreUnknownOptions*(context: GOptionContext): Gboolean {.
    importc: "g_option_context_get_ignore_unknown_options", libglib.}
proc ignoreUnknownOptions*(context: GOptionContext): Gboolean {.
    importc: "g_option_context_get_ignore_unknown_options", libglib.}
proc setStrictPosix*(context: GOptionContext;
                                  strictPosix: Gboolean) {.
    importc: "g_option_context_set_strict_posix", libglib.}
proc `strictPosix=`*(context: GOptionContext;
                                  strictPosix: Gboolean) {.
    importc: "g_option_context_set_strict_posix", libglib.}
proc getStrictPosix*(context: GOptionContext): Gboolean {.
    importc: "g_option_context_get_strict_posix", libglib.}
proc strictPosix*(context: GOptionContext): Gboolean {.
    importc: "g_option_context_get_strict_posix", libglib.}
proc addMainEntries*(context: GOptionContext;
                                  entries: GOptionEntry;
                                  translationDomain: cstring) {.
    importc: "g_option_context_add_main_entries", libglib.}
proc parse*(context: GOptionContext; argc: var cint;
                         argv: var cstringArray; error: var GError): Gboolean {.
    importc: "g_option_context_parse", libglib.}
proc parseStrv*(context: GOptionContext;
                             arguments: var cstringArray; error: var GError): Gboolean {.
    importc: "g_option_context_parse_strv", libglib.}
proc setTranslateFunc*(context: GOptionContext;
                                    `func`: GTranslateFunc; data: Gpointer;
                                    destroyNotify: GDestroyNotify) {.
    importc: "g_option_context_set_translate_func", libglib.}
proc `translateFunc=`*(context: GOptionContext;
                                    `func`: GTranslateFunc; data: Gpointer;
                                    destroyNotify: GDestroyNotify) {.
    importc: "g_option_context_set_translate_func", libglib.}
proc setTranslationDomain*(context: GOptionContext;
                                        domain: cstring) {.
    importc: "g_option_context_set_translation_domain", libglib.}
proc `translationDomain=`*(context: GOptionContext;
                                        domain: cstring) {.
    importc: "g_option_context_set_translation_domain", libglib.}
proc addGroup*(context: GOptionContext; group: GOptionGroup) {.
    importc: "g_option_context_add_group", libglib.}
proc setMainGroup*(context: GOptionContext;
                                group: GOptionGroup) {.
    importc: "g_option_context_set_main_group", libglib.}
proc `mainGroup=`*(context: GOptionContext;
                                group: GOptionGroup) {.
    importc: "g_option_context_set_main_group", libglib.}
proc getMainGroup*(context: GOptionContext): GOptionGroup {.
    importc: "g_option_context_get_main_group", libglib.}
proc mainGroup*(context: GOptionContext): GOptionGroup {.
    importc: "g_option_context_get_main_group", libglib.}
proc getHelp*(context: GOptionContext; mainHelp: Gboolean;
                           group: GOptionGroup): cstring {.
    importc: "g_option_context_get_help", libglib.}
proc help*(context: GOptionContext; mainHelp: Gboolean;
                           group: GOptionGroup): cstring {.
    importc: "g_option_context_get_help", libglib.}
proc newOptionGroup*(name: cstring; description: cstring; helpDescription: cstring;
                     userData: Gpointer; destroy: GDestroyNotify): GOptionGroup {.
    importc: "g_option_group_new", libglib.}
proc setParseHooks*(group: GOptionGroup;
                               preParseFunc: GOptionParseFunc;
                               postParseFunc: GOptionParseFunc) {.
    importc: "g_option_group_set_parse_hooks", libglib.}
proc `parseHooks=`*(group: GOptionGroup;
                               preParseFunc: GOptionParseFunc;
                               postParseFunc: GOptionParseFunc) {.
    importc: "g_option_group_set_parse_hooks", libglib.}
proc setErrorHook*(group: GOptionGroup; errorFunc: GOptionErrorFunc) {.
    importc: "g_option_group_set_error_hook", libglib.}
proc `errorHook=`*(group: GOptionGroup; errorFunc: GOptionErrorFunc) {.
    importc: "g_option_group_set_error_hook", libglib.}
proc free*(group: GOptionGroup) {.importc: "g_option_group_free",
    libglib.}
proc `ref`*(group: GOptionGroup): GOptionGroup {.
    importc: "g_option_group_ref", libglib.}
proc unref*(group: GOptionGroup) {.importc: "g_option_group_unref",
    libglib.}
proc addEntries*(group: GOptionGroup; entries: GOptionEntry) {.
    importc: "g_option_group_add_entries", libglib.}
proc setTranslateFunc*(group: GOptionGroup; `func`: GTranslateFunc;
                                  data: Gpointer; destroyNotify: GDestroyNotify) {.
    importc: "g_option_group_set_translate_func", libglib.}
proc `translateFunc=`*(group: GOptionGroup; `func`: GTranslateFunc;
                                  data: Gpointer; destroyNotify: GDestroyNotify) {.
    importc: "g_option_group_set_translate_func", libglib.}
proc setTranslationDomain*(group: GOptionGroup; domain: cstring) {.
    importc: "g_option_group_set_translation_domain", libglib.}
proc `translationDomain=`*(group: GOptionGroup; domain: cstring) {.
    importc: "g_option_group_set_translation_domain", libglib.}

type
  GPatternSpec* =  ptr GPatternSpecObj
  GPatternSpecPtr* = ptr GPatternSpecObj
  GPatternSpecObj* = object

proc newPatternSpec*(pattern: cstring): GPatternSpec {.
    importc: "g_pattern_spec_new", libglib.}
proc free*(pspec: GPatternSpec) {.importc: "g_pattern_spec_free",
    libglib.}
proc equal*(pspec1: GPatternSpec; pspec2: GPatternSpec): Gboolean {.
    importc: "g_pattern_spec_equal", libglib.}
proc patternMatch*(pspec: GPatternSpec; stringLength: cuint; string: cstring;
                   stringReversed: cstring): Gboolean {.importc: "g_pattern_match",
    libglib.}
proc patternMatchString*(pspec: GPatternSpec; string: cstring): Gboolean {.
    importc: "g_pattern_match_string", libglib.}
proc patternMatchSimple*(pattern: cstring; string: cstring): Gboolean {.
    importc: "g_pattern_match_simple", libglib.}

proc spacedPrimesClosest*(num: cuint): cuint {.importc: "g_spaced_primes_closest",
    libglib.}

proc qsortWithData*(pbase: Gconstpointer; totalElems: cint; size: Gsize;
                    compareFunc: GCompareDataFunc; userData: Gpointer) {.
    importc: "g_qsort_with_data", libglib.}

type
  GQueue* =  ptr GQueueObj
  GQueuePtr* = ptr GQueueObj
  GQueueObj* = object
    head*: GList
    tail*: GList
    length*: cuint

proc newQueue*(): GQueue {.importc: "g_queue_new", libglib.}
proc free*(queue: GQueue) {.importc: "g_queue_free", libglib.}
proc freeFull*(queue: GQueue; freeFunc: GDestroyNotify) {.
    importc: "g_queue_free_full", libglib.}
proc init*(queue: GQueue) {.importc: "g_queue_init", libglib.}
proc clear*(queue: GQueue) {.importc: "g_queue_clear", libglib.}
proc isEmpty*(queue: GQueue): Gboolean {.importc: "g_queue_is_empty",
    libglib.}
proc getLength*(queue: GQueue): cuint {.importc: "g_queue_get_length",
    libglib.}
proc length*(queue: GQueue): cuint {.importc: "g_queue_get_length",
    libglib.}
proc reverse*(queue: GQueue) {.importc: "g_queue_reverse", libglib.}
proc copy*(queue: GQueue): GQueue {.importc: "g_queue_copy", libglib.}
proc foreach*(queue: GQueue; `func`: GFunc; userData: Gpointer) {.
    importc: "g_queue_foreach", libglib.}
proc find*(queue: GQueue; data: Gconstpointer): GList {.
    importc: "g_queue_find", libglib.}
proc findCustom*(queue: GQueue; data: Gconstpointer; `func`: GCompareFunc): GList {.
    importc: "g_queue_find_custom", libglib.}
proc sort*(queue: GQueue; compareFunc: GCompareDataFunc; userData: Gpointer) {.
    importc: "g_queue_sort", libglib.}
proc pushHead*(queue: GQueue; data: Gpointer) {.
    importc: "g_queue_push_head", libglib.}
proc pushTail*(queue: GQueue; data: Gpointer) {.
    importc: "g_queue_push_tail", libglib.}
proc pushNth*(queue: GQueue; data: Gpointer; n: cint) {.
    importc: "g_queue_push_nth", libglib.}
proc popHead*(queue: GQueue): Gpointer {.importc: "g_queue_pop_head",
    libglib.}
proc popTail*(queue: GQueue): Gpointer {.importc: "g_queue_pop_tail",
    libglib.}
proc popNth*(queue: GQueue; n: cuint): Gpointer {.importc: "g_queue_pop_nth",
    libglib.}
proc peekHead*(queue: GQueue): Gpointer {.importc: "g_queue_peek_head",
    libglib.}
proc peekTail*(queue: GQueue): Gpointer {.importc: "g_queue_peek_tail",
    libglib.}
proc peekNth*(queue: GQueue; n: cuint): Gpointer {.
    importc: "g_queue_peek_nth", libglib.}
proc index*(queue: GQueue; data: Gconstpointer): cint {.
    importc: "g_queue_index", libglib.}
proc remove*(queue: GQueue; data: Gconstpointer): Gboolean {.
    importc: "g_queue_remove", libglib.}
proc removeAll*(queue: GQueue; data: Gconstpointer): cuint {.
    importc: "g_queue_remove_all", libglib.}
proc insertBefore*(queue: GQueue; sibling: GList; data: Gpointer) {.
    importc: "g_queue_insert_before", libglib.}
proc insertAfter*(queue: GQueue; sibling: GList; data: Gpointer) {.
    importc: "g_queue_insert_after", libglib.}
proc insertSorted*(queue: GQueue; data: Gpointer; `func`: GCompareDataFunc;
                        userData: Gpointer) {.importc: "g_queue_insert_sorted",
    libglib.}
proc pushHeadLink*(queue: GQueue; link: GList) {.
    importc: "g_queue_push_head_link", libglib.}
proc pushTailLink*(queue: GQueue; link: GList) {.
    importc: "g_queue_push_tail_link", libglib.}
proc pushNthLink*(queue: GQueue; n: cint; link: GList) {.
    importc: "g_queue_push_nth_link", libglib.}
proc popHeadLink*(queue: GQueue): GList {.
    importc: "g_queue_pop_head_link", libglib.}
proc popTailLink*(queue: GQueue): GList {.
    importc: "g_queue_pop_tail_link", libglib.}
proc popNthLink*(queue: GQueue; n: cuint): GList {.
    importc: "g_queue_pop_nth_link", libglib.}
proc peekHeadLink*(queue: GQueue): GList {.
    importc: "g_queue_peek_head_link", libglib.}
proc peekTailLink*(queue: GQueue): GList {.
    importc: "g_queue_peek_tail_link", libglib.}
proc peekNthLink*(queue: GQueue; n: cuint): GList {.
    importc: "g_queue_peek_nth_link", libglib.}
proc linkIndex*(queue: GQueue; link: GList): cint {.
    importc: "g_queue_link_index", libglib.}
proc unlink*(queue: GQueue; link: GList) {.importc: "g_queue_unlink",
    libglib.}
proc deleteLink*(queue: GQueue; link: GList) {.
    importc: "g_queue_delete_link", libglib.}

type
  GRand* =  ptr GRandObj
  GRandPtr* = ptr GRandObj
  GRandObj* = object

proc newRand*(seed: uint32): GRand {.importc: "g_rand_new_with_seed",
    libglib.}
proc newRand*(seed: var uint32; seedLength: cuint): GRand {.
    importc: "g_rand_new_with_seed_array", libglib.}
proc newRand*(): GRand {.importc: "g_rand_new", libglib.}
proc free*(rand: GRand) {.importc: "g_rand_free", libglib.}
proc copy*(rand: GRand): GRand {.importc: "g_rand_copy", libglib.}
proc setSeed*(rand: GRand; seed: uint32) {.importc: "g_rand_set_seed",
    libglib.}
proc `seed=`*(rand: GRand; seed: uint32) {.importc: "g_rand_set_seed",
    libglib.}
proc setSeedArray*(rand: GRand; seed: var uint32; seedLength: cuint) {.
    importc: "g_rand_set_seed_array", libglib.}
proc `seedArray=`*(rand: GRand; seed: var uint32; seedLength: cuint) {.
    importc: "g_rand_set_seed_array", libglib.}
proc gRandInt*(rand: GRand): uint32 {.importc: "g_rand_int",
    libglib.}
proc gRandBoolean*(rand: GRand): Gboolean {.inline.} =
  cast[Gboolean]((cast[int32](g_rand_int(rand)) and (1 shl 15)) shr 15)
proc intRange*(rand: GRand; begin: int32; `end`: int32): int32 {.
    importc: "g_rand_int_range", libglib.}
proc doubleRange*(rand: GRand; begin: cdouble; `end`: cdouble): cdouble {.
    importc: "g_rand_double_range", libglib.}
proc randomSetSeed*(seed: uint32) {.importc: "g_random_set_seed", libglib.}
template gRandomBoolean*(): untyped =
  ((randomInt() and (1 shl 15)) != 0)

proc randomInt*(): uint32 {.importc: "g_random_int", libglib.}
proc randomIntRange*(begin: int32; `end`: int32): int32 {.
    importc: "g_random_int_range", libglib.}
proc randomDouble*(): cdouble {.importc: "g_random_double", libglib.}
proc randomDoubleRange*(begin: cdouble; `end`: cdouble): cdouble {.
    importc: "g_random_double_range", libglib.}

type
  GRegexError* {.size: sizeof(cint), pure.} = enum
    COMPILE, OPTIMIZE, REPLACE,
    MATCH, INTERNAL,
    STRAY_BACKSLASH = 101, MISSING_CONTROL_CHAR = 102,
    UNRECOGNIZED_ESCAPE = 103,
    QUANTIFIERS_OUT_OF_ORDER = 104,
    QUANTIFIER_TOO_BIG = 105,
    UNTERMINATED_CHARACTER_CLASS = 106,
    INVALID_ESCAPE_IN_CHARACTER_CLASS = 107,
    RANGE_OUT_OF_ORDER = 108, NOTHING_TO_REPEAT = 109,
    UNRECOGNIZED_CHARACTER = 112,
    POSIX_NAMED_CLASS_OUTSIDE_CLASS = 113,
    UNMATCHED_PARENTHESIS = 114,
    INEXISTENT_SUBPATTERN_REFERENCE = 115,
    UNTERMINATED_COMMENT = 118,
    EXPRESSION_TOO_LARGE = 120, MEMORY_ERROR = 121,
    VARIABLE_LENGTH_LOOKBEHIND = 125,
    MALFORMED_CONDITION = 126,
    TOO_MANY_CONDITIONAL_BRANCHES = 127,
    ASSERTION_EXPECTED = 128,
    UNKNOWN_POSIX_CLASS_NAME = 130,
    POSIX_COLLATING_ELEMENTS_NOT_SUPPORTED = 131,
    HEX_CODE_TOO_LARGE = 134, INVALID_CONDITION = 135,
    SINGLE_BYTE_MATCH_IN_LOOKBEHIND = 136,
    INFINITE_LOOP = 140,
    MISSING_SUBPATTERN_NAME_TERMINATOR = 142,
    DUPLICATE_SUBPATTERN_NAME = 143,
    MALFORMED_PROPERTY = 146, UNKNOWN_PROPERTY = 147,
    SUBPATTERN_NAME_TOO_LONG = 148,
    TOO_MANY_SUBPATTERNS = 149,
    INVALID_OCTAL_VALUE = 151,
    TOO_MANY_BRANCHES_IN_DEFINE = 154,
    DEFINE_REPETION = 155,
    INCONSISTENT_NEWLINE_OPTIONS = 156,
    MISSING_BACK_REFERENCE = 157,
    INVALID_RELATIVE_REFERENCE = 158,
    BACKTRACKING_CONTROL_VERB_ARGUMENT_FORBIDDEN = 159,
    UNKNOWN_BACKTRACKING_CONTROL_VERB = 160,
    NUMBER_TOO_BIG = 161,
    MISSING_SUBPATTERN_NAME = 162, MISSING_DIGIT = 163,
    INVALID_DATA_CHARACTER = 164,
    EXTRA_SUBPATTERN_NAME = 165,
    BACKTRACKING_CONTROL_VERB_ARGUMENT_REQUIRED = 166,
    INVALID_CONTROL_CHAR = 168, MISSING_NAME = 169,
    NOT_SUPPORTED_IN_CLASS = 171,
    TOO_MANY_FORWARD_REFERENCES = 172,
    NAME_TOO_LONG = 175,
    CHARACTER_VALUE_TOO_LARGE = 176

proc regexErrorQuark*(): GQuark {.importc: "g_regex_error_quark", libglib.}

type
  GRegexCompileFlags* {.size: sizeof(cint), pure.} = enum
    CASELESS = 1 shl 0, MULTILINE = 1 shl 1, DOTALL = 1 shl 2,
    EXTENDED = 1 shl 3, ANCHORED = 1 shl 4,
    DOLLAR_ENDONLY = 1 shl 5, UNGREEDY = 1 shl 9, RAW = 1 shl 11,
    NO_AUTO_CAPTURE = 1 shl 12, OPTIMIZE = 1 shl 13,
    FIRSTLINE = 1 shl 18, DUPNAMES = 1 shl 19,
    NEWLINE_CR = 1 shl 20, NEWLINE_LF = 1 shl 21,
    NEWLINE_CRLF = GRegexCompileFlags.Newline_Cr.ord or GRegexCompileFlags.Newline_Lf.ord,
    NEWLINE_ANYCRLF = GRegexCompileFlags.Newline_Cr.ord or 1 shl 22,
    BSR_ANYCRLF = 1 shl 23, JAVASCRIPT_COMPAT = 1 shl 25

type
  GRegexMatchFlags* {.size: sizeof(cint), pure.} = enum
    ANCHORED = 1 shl 4, NOTBOL = 1 shl 7,
    NOTEOL = 1 shl 8, NOTEMPTY = 1 shl 10,
    PARTIAL = 1 shl 15, NEWLINE_CR = 1 shl 20,
    NEWLINE_LF = 1 shl 21,
    NEWLINE_CRLF = (GRegexMatchFlags.Newline_Cr.ord or GRegexMatchFlags.Newline_Lf.ord)
    NEWLINE_ANY = 1 shl 22,
    NEWLINE_ANYCRLF = (GRegexMatchFlags.Newline_Cr.ord or GRegexMatchFlags.Newline_Any.ord)
    BSR_ANYCRLF = 1 shl 23,
    BSR_ANY = 1 shl 24,
    PARTIAL_HARD = 1 shl 27, NOTEMPTY_ATSTART = 1 shl 28

const
  G_REGEX_MATCH_PARTIAL_SOFT = GRegexMatchFlags.PARTIAL

type
  GRegex* =  ptr GRegexObj
  GRegexPtr* = ptr GRegexObj
  GRegexObj* = object

type
  GMatchInfo* =  ptr GMatchInfoObj
  GMatchInfoPtr* = ptr GMatchInfoObj
  GMatchInfoObj* = object

type
  GRegexEvalCallback* = proc (matchInfo: GMatchInfo; result: GString;
                           userData: Gpointer): Gboolean {.cdecl.}

proc newRegex*(pattern: cstring; compileOptions: GRegexCompileFlags;
               matchOptions: GRegexMatchFlags; error: var GError): GRegex {.
    importc: "g_regex_new", libglib.}
proc `ref`*(regex: GRegex): GRegex {.importc: "g_regex_ref", libglib.}
proc unref*(regex: GRegex) {.importc: "g_regex_unref", libglib.}
proc getPattern*(regex: GRegex): cstring {.importc: "g_regex_get_pattern",
    libglib.}
proc pattern*(regex: GRegex): cstring {.importc: "g_regex_get_pattern",
    libglib.}
proc getMaxBackref*(regex: GRegex): cint {.
    importc: "g_regex_get_max_backref", libglib.}
proc maxBackref*(regex: GRegex): cint {.
    importc: "g_regex_get_max_backref", libglib.}
proc getCaptureCount*(regex: GRegex): cint {.
    importc: "g_regex_get_capture_count", libglib.}
proc captureCount*(regex: GRegex): cint {.
    importc: "g_regex_get_capture_count", libglib.}
proc getHasCrOrLf*(regex: GRegex): Gboolean {.
    importc: "g_regex_get_has_cr_or_lf", libglib.}
proc hasCrOrLf*(regex: GRegex): Gboolean {.
    importc: "g_regex_get_has_cr_or_lf", libglib.}
proc getMaxLookbehind*(regex: GRegex): cint {.
    importc: "g_regex_get_max_lookbehind", libglib.}
proc maxLookbehind*(regex: GRegex): cint {.
    importc: "g_regex_get_max_lookbehind", libglib.}
proc getStringNumber*(regex: GRegex; name: cstring): cint {.
    importc: "g_regex_get_string_number", libglib.}
proc stringNumber*(regex: GRegex; name: cstring): cint {.
    importc: "g_regex_get_string_number", libglib.}
proc regexEscapeString*(string: cstring; length: cint): cstring {.
    importc: "g_regex_escape_string", libglib.}
proc regexEscapeNul*(string: cstring; length: cint): cstring {.
    importc: "g_regex_escape_nul", libglib.}
proc getCompileFlags*(regex: GRegex): GRegexCompileFlags {.
    importc: "g_regex_get_compile_flags", libglib.}
proc compileFlags*(regex: GRegex): GRegexCompileFlags {.
    importc: "g_regex_get_compile_flags", libglib.}
proc getMatchFlags*(regex: GRegex): GRegexMatchFlags {.
    importc: "g_regex_get_match_flags", libglib.}
proc matchFlags*(regex: GRegex): GRegexMatchFlags {.
    importc: "g_regex_get_match_flags", libglib.}

proc regexMatchSimple*(pattern: cstring; string: cstring;
                       compileOptions: GRegexCompileFlags;
                       matchOptions: GRegexMatchFlags): Gboolean {.
    importc: "g_regex_match_simple", libglib.}
proc match*(regex: GRegex; string: cstring; matchOptions: GRegexMatchFlags;
                 matchInfo: var GMatchInfo): Gboolean {.importc: "g_regex_match",
    libglib.}
proc matchFull*(regex: GRegex; string: cstring; stringLen: Gssize;
                     startPosition: cint; matchOptions: GRegexMatchFlags;
                     matchInfo: var GMatchInfo; error: var GError): Gboolean {.
    importc: "g_regex_match_full", libglib.}
proc matchAll*(regex: GRegex; string: cstring;
                    matchOptions: GRegexMatchFlags; matchInfo: var GMatchInfo): Gboolean {.
    importc: "g_regex_match_all", libglib.}
proc matchAllFull*(regex: GRegex; string: cstring; stringLen: Gssize;
                        startPosition: cint; matchOptions: GRegexMatchFlags;
                        matchInfo: var GMatchInfo; error: var GError): Gboolean {.
    importc: "g_regex_match_all_full", libglib.}

proc regexSplitSimple*(pattern: cstring; string: cstring;
                       compileOptions: GRegexCompileFlags;
                       matchOptions: GRegexMatchFlags): cstringArray {.
    importc: "g_regex_split_simple", libglib.}
proc split*(regex: GRegex; string: cstring; matchOptions: GRegexMatchFlags): cstringArray {.
    importc: "g_regex_split", libglib.}
proc splitFull*(regex: GRegex; string: cstring; stringLen: Gssize;
                     startPosition: cint; matchOptions: GRegexMatchFlags;
                     maxTokens: cint; error: var GError): cstringArray {.
    importc: "g_regex_split_full", libglib.}

proc replace*(regex: GRegex; string: cstring; stringLen: Gssize;
                   startPosition: cint; replacement: cstring;
                   matchOptions: GRegexMatchFlags; error: var GError): cstring {.
    importc: "g_regex_replace", libglib.}
proc replaceLiteral*(regex: GRegex; string: cstring; stringLen: Gssize;
                          startPosition: cint; replacement: cstring;
                          matchOptions: GRegexMatchFlags; error: var GError): cstring {.
    importc: "g_regex_replace_literal", libglib.}
proc replaceEval*(regex: GRegex; string: cstring; stringLen: Gssize;
                       startPosition: cint; matchOptions: GRegexMatchFlags;
                       eval: GRegexEvalCallback; userData: Gpointer;
                       error: var GError): cstring {.
    importc: "g_regex_replace_eval", libglib.}
proc regexCheckReplacement*(replacement: cstring; hasReferences: var Gboolean;
                            error: var GError): Gboolean {.
    importc: "g_regex_check_replacement", libglib.}

proc getRegex*(matchInfo: GMatchInfo): GRegex {.
    importc: "g_match_info_get_regex", libglib.}

proc regex*(matchInfo: GMatchInfo): GRegex {.
    importc: "g_match_info_get_regex", libglib.}
proc getString*(matchInfo: GMatchInfo): cstring {.
    importc: "g_match_info_get_string", libglib.}
proc `ref`*(matchInfo: GMatchInfo): GMatchInfo {.
    importc: "g_match_info_ref", libglib.}
proc unref*(matchInfo: GMatchInfo) {.importc: "g_match_info_unref",
    libglib.}
proc free*(matchInfo: GMatchInfo) {.importc: "g_match_info_free",
    libglib.}
proc next*(matchInfo: GMatchInfo; error: var GError): Gboolean {.
    importc: "g_match_info_next", libglib.}
proc matches*(matchInfo: GMatchInfo): Gboolean {.
    importc: "g_match_info_matches", libglib.}
proc getMatchCount*(matchInfo: GMatchInfo): cint {.
    importc: "g_match_info_get_match_count", libglib.}
proc matchCount*(matchInfo: GMatchInfo): cint {.
    importc: "g_match_info_get_match_count", libglib.}
proc isPartialMatch*(matchInfo: GMatchInfo): Gboolean {.
    importc: "g_match_info_is_partial_match", libglib.}
proc expandReferences*(matchInfo: GMatchInfo; stringToExpand: cstring;
                                error: var GError): cstring {.
    importc: "g_match_info_expand_references", libglib.}
proc fetch*(matchInfo: GMatchInfo; matchNum: cint): cstring {.
    importc: "g_match_info_fetch", libglib.}
proc fetchPos*(matchInfo: GMatchInfo; matchNum: cint;
                        startPos: var cint; endPos: var cint): Gboolean {.
    importc: "g_match_info_fetch_pos", libglib.}
proc fetchNamed*(matchInfo: GMatchInfo; name: cstring): cstring {.
    importc: "g_match_info_fetch_named", libglib.}
proc fetchNamedPos*(matchInfo: GMatchInfo; name: cstring;
                             startPos: var cint; endPos: var cint): Gboolean {.
    importc: "g_match_info_fetch_named_pos", libglib.}
proc fetchAll*(matchInfo: GMatchInfo): cstringArray {.
    importc: "g_match_info_fetch_all", libglib.}

const
  G_CSET_A_2_Z_U* = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  G_CSET_a_2_Z_L* = "abcdefghijklmnopqrstuvwxyz"
  G_CSET_DIGITS* = "0123456789"
  G_CSET_LATINC* = "\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD8\xD9\xDA\xDB\xDC\xDD\xDE"
  G_CSET_LATINS* = "\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF"

type
  GErrorType* {.size: sizeof(cint), pure.} = enum
    UNKNOWN, UNEXP_EOF, UNEXP_EOF_IN_STRING,
    UNEXP_EOF_IN_COMMENT, NON_DIGIT_IN_CONST, DIGIT_RADIX,
    FLOAT_RADIX, FLOAT_MALFORMED

type
  GTokenType* {.size: sizeof(cint), pure.} = enum
    EOF = 0, LEFT_PAREN = '(', RIGHT_PAREN = ')',
    COMMA = ',',
    EQUAL_SIGN = '=',
    LEFT_BRACE = '[', RIGHT_BRACE = ']',
    LEFT_CURLY = '{', RIGHT_CURLY = '}',
    NONE = 256,
    ERROR, CHAR, BINARY, OCTAL, INT,
    HEX, FLOAT, STRING, SYMBOL,
    IDENTIFIER, IDENTIFIER_NULL, COMMENT_SINGLE,
    COMMENT_MULTI, LAST

type
  GTokenValue* =  ptr GTokenValueObj
  GTokenValuePtr* = ptr GTokenValueObj
  GTokenValueObj* {.union.} = object
    vSymbol*: Gpointer
    vIdentifier*: cstring
    vBinary*: culong
    vOctal*: culong
    vInt*: culong
    vInt64*: uint64
    vFloat*: cdouble
    vHex*: culong
    vString*: cstring
    vComment*: cstring
    vChar*: cuchar
    vError*: cuint

  GScannerConfig* =  ptr GScannerConfigObj
  GScannerConfigPtr* = ptr GScannerConfigObj
  GScannerConfigObj* = object
    csetSkipCharacters*: cstring
    csetIdentifierFirst*: cstring
    csetIdentifierNth*: cstring
    cpairCommentSingle*: cstring
    caseSensitive* {.bitsize: 1.}: cuint
    skipCommentMulti* {.bitsize: 1.}: cuint
    skipCommentSingle* {.bitsize: 1.}: cuint
    scanCommentMulti* {.bitsize: 1.}: cuint
    scanIdentifier* {.bitsize: 1.}: cuint
    scanIdentifier1char* {.bitsize: 1.}: cuint
    scanIdentifierNULL* {.bitsize: 1.}: cuint
    scanSymbols* {.bitsize: 1.}: cuint
    scanBinary* {.bitsize: 1.}: cuint
    scanOctal* {.bitsize: 1.}: cuint
    scanFloat* {.bitsize: 1.}: cuint
    scanHex* {.bitsize: 1.}: cuint
    scanHexDollar* {.bitsize: 1.}: cuint
    scanStringSq* {.bitsize: 1.}: cuint
    scanStringDq* {.bitsize: 1.}: cuint
    numbers2Int* {.bitsize: 1.}: cuint
    int2Float* {.bitsize: 1.}: cuint
    identifier2String* {.bitsize: 1.}: cuint
    char2Token* {.bitsize: 1.}: cuint
    symbol2Token* {.bitsize: 1.}: cuint
    scope0Fallback* {.bitsize: 1.}: cuint
    storeInt64* {.bitsize: 1.}: cuint
    paddingDummy*: cuint

  GScanner* =  ptr GScannerObj
  GScannerPtr* = ptr GScannerObj
  GScannerObj* = object
    userData*: Gpointer
    maxParseErrors*: cuint
    parseErrors*: cuint
    inputName*: cstring
    qdata*: GData
    config*: GScannerConfig
    token*: GTokenType
    value*: GTokenValueObj
    line*: cuint
    position*: cuint
    nextToken*: GTokenType
    nextValue*: GTokenValueObj
    nextLine*: cuint
    nextPosition*: cuint
    symbolTable*: GHashTable
    inputFd*: cint
    text*: cstring
    textEnd*: cstring
    buffer*: cstring
    scopeId*: cuint
    msgHandler*: GScannerMsgFunc
  GScannerMsgFunc* = proc (scanner: GScanner; message: cstring; error: Gboolean) {.cdecl.}

proc newScanner*(configTempl: GScannerConfig): GScanner {.
    importc: "g_scanner_new", libglib.}
proc destroy*(scanner: GScanner) {.importc: "g_scanner_destroy",
    libglib.}
proc inputFile*(scanner: GScanner; inputFd: cint) {.
    importc: "g_scanner_input_file", libglib.}
proc syncFileOffset*(scanner: GScanner) {.
    importc: "g_scanner_sync_file_offset", libglib.}
proc inputText*(scanner: GScanner; text: cstring; textLen: cuint) {.
    importc: "g_scanner_input_text", libglib.}
proc getNextToken*(scanner: GScanner): GTokenType {.
    importc: "g_scanner_get_next_token", libglib.}
proc nextToken*(scanner: GScanner): GTokenType {.
    importc: "g_scanner_get_next_token", libglib.}
proc peekNextToken*(scanner: GScanner): GTokenType {.
    importc: "g_scanner_peek_next_token", libglib.}
proc curToken*(scanner: GScanner): GTokenType {.
    importc: "g_scanner_cur_token", libglib.}
proc curValue*(scanner: GScanner): GTokenValueObj {.
    importc: "g_scanner_cur_value", libglib.}
proc curLine*(scanner: GScanner): cuint {.importc: "g_scanner_cur_line",
    libglib.}
proc curPosition*(scanner: GScanner): cuint {.
    importc: "g_scanner_cur_position", libglib.}
proc eof*(scanner: GScanner): Gboolean {.importc: "g_scanner_eof",
    libglib.}
proc setScope*(scanner: GScanner; scopeId: cuint): cuint {.
    importc: "g_scanner_set_scope", libglib.}
proc scopeAddSymbol*(scanner: GScanner; scopeId: cuint; symbol: cstring;
                            value: Gpointer) {.
    importc: "g_scanner_scope_add_symbol", libglib.}
proc scopeRemoveSymbol*(scanner: GScanner; scopeId: cuint; symbol: cstring) {.
    importc: "g_scanner_scope_remove_symbol", libglib.}
proc scopeLookupSymbol*(scanner: GScanner; scopeId: cuint; symbol: cstring): Gpointer {.
    importc: "g_scanner_scope_lookup_symbol", libglib.}
proc scopeForeachSymbol*(scanner: GScanner; scopeId: cuint;
                                `func`: GHFunc; userData: Gpointer) {.
    importc: "g_scanner_scope_foreach_symbol", libglib.}
proc lookupSymbol*(scanner: GScanner; symbol: cstring): Gpointer {.
    importc: "g_scanner_lookup_symbol", libglib.}
proc unexpToken*(scanner: GScanner; expectedToken: GTokenType;
                        identifierSpec: cstring; symbolSpec: cstring;
                        symbolName: cstring; message: cstring; isError: cint) {.
    importc: "g_scanner_unexp_token", libglib.}
proc error*(scanner: GScanner; format: cstring) {.varargs,
    importc: "g_scanner_error", libglib.}
proc warn*(scanner: GScanner; format: cstring) {.varargs,
    importc: "g_scanner_warn", libglib.}

type
  GSequence* =  ptr GSequenceObj
  GSequencePtr* = ptr GSequenceObj
  GSequenceObj* = object

  GSequenceIter* =  ptr GSequenceIterObj
  GSequenceIterPtr* = ptr GSequenceIterObj
  GSequenceIterObj* = object

  GSequenceIterCompareFunc* = proc (a: GSequenceIter; b: GSequenceIter;
                                 data: Gpointer): cint {.cdecl.}

proc newSequence*(dataDestroy: GDestroyNotify): GSequence {.
    importc: "g_sequence_new", libglib.}
proc free*(seq: GSequence) {.importc: "g_sequence_free", libglib.}
proc getLength*(seq: GSequence): cint {.
    importc: "g_sequence_get_length", libglib.}
proc length*(seq: GSequence): cint {.
    importc: "g_sequence_get_length", libglib.}
proc foreach*(seq: GSequence; `func`: GFunc; userData: Gpointer) {.
    importc: "g_sequence_foreach", libglib.}
proc sequenceForeachRange*(begin: GSequenceIter; `end`: GSequenceIter;
                           `func`: GFunc; userData: Gpointer) {.
    importc: "g_sequence_foreach_range", libglib.}
proc sort*(seq: GSequence; cmpFunc: GCompareDataFunc; cmpData: Gpointer) {.
    importc: "g_sequence_sort", libglib.}
proc sortIter*(seq: GSequence; cmpFunc: GSequenceIterCompareFunc;
                       cmpData: Gpointer) {.importc: "g_sequence_sort_iter",
    libglib.}
proc isEmpty*(seq: GSequence): Gboolean {.
    importc: "g_sequence_is_empty", libglib.}

proc getBeginIter*(seq: GSequence): GSequenceIter {.
    importc: "g_sequence_get_begin_iter", libglib.}

proc beginIter*(seq: GSequence): GSequenceIter {.
    importc: "g_sequence_get_begin_iter", libglib.}
proc getEndIter*(seq: GSequence): GSequenceIter {.
    importc: "g_sequence_get_end_iter", libglib.}
proc endIter*(seq: GSequence): GSequenceIter {.
    importc: "g_sequence_get_end_iter", libglib.}
proc getIterAtPos*(seq: GSequence; pos: cint): GSequenceIter {.
    importc: "g_sequence_get_iter_at_pos", libglib.}
proc iterAtPos*(seq: GSequence; pos: cint): GSequenceIter {.
    importc: "g_sequence_get_iter_at_pos", libglib.}
proc append*(seq: GSequence; data: Gpointer): GSequenceIter {.
    importc: "g_sequence_append", libglib.}
proc prepend*(seq: GSequence; data: Gpointer): GSequenceIter {.
    importc: "g_sequence_prepend", libglib.}
proc sequenceInsertBefore*(iter: GSequenceIter; data: Gpointer): GSequenceIter {.
    importc: "g_sequence_insert_before", libglib.}
proc sequenceMove*(src: GSequenceIter; dest: GSequenceIter) {.
    importc: "g_sequence_move", libglib.}
proc sequenceSwap*(a: GSequenceIter; b: GSequenceIter) {.
    importc: "g_sequence_swap", libglib.}
proc insertSorted*(seq: GSequence; data: Gpointer;
                           cmpFunc: GCompareDataFunc; cmpData: Gpointer): GSequenceIter {.
    importc: "g_sequence_insert_sorted", libglib.}
proc insertSortedIter*(seq: GSequence; data: Gpointer;
                               iterCmp: GSequenceIterCompareFunc;
                               cmpData: Gpointer): GSequenceIter {.
    importc: "g_sequence_insert_sorted_iter", libglib.}
proc sequenceSortChanged*(iter: GSequenceIter; cmpFunc: GCompareDataFunc;
                          cmpData: Gpointer) {.importc: "g_sequence_sort_changed",
    libglib.}
proc sequenceSortChangedIter*(iter: GSequenceIter;
                              iterCmp: GSequenceIterCompareFunc; cmpData: Gpointer) {.
    importc: "g_sequence_sort_changed_iter", libglib.}
proc sequenceRemove*(iter: GSequenceIter) {.importc: "g_sequence_remove",
    libglib.}
proc sequenceRemoveRange*(begin: GSequenceIter; `end`: GSequenceIter) {.
    importc: "g_sequence_remove_range", libglib.}
proc sequenceMoveRange*(dest: GSequenceIter; begin: GSequenceIter;
                        `end`: GSequenceIter) {.
    importc: "g_sequence_move_range", libglib.}
proc search*(seq: GSequence; data: Gpointer; cmpFunc: GCompareDataFunc;
                     cmpData: Gpointer): GSequenceIter {.
    importc: "g_sequence_search", libglib.}
proc searchIter*(seq: GSequence; data: Gpointer;
                         iterCmp: GSequenceIterCompareFunc; cmpData: Gpointer): GSequenceIter {.
    importc: "g_sequence_search_iter", libglib.}
proc lookup*(seq: GSequence; data: Gpointer; cmpFunc: GCompareDataFunc;
                     cmpData: Gpointer): GSequenceIter {.
    importc: "g_sequence_lookup", libglib.}
proc lookupIter*(seq: GSequence; data: Gpointer;
                         iterCmp: GSequenceIterCompareFunc; cmpData: Gpointer): GSequenceIter {.
    importc: "g_sequence_lookup_iter", libglib.}

proc sequenceGet*(iter: GSequenceIter): Gpointer {.importc: "g_sequence_get",
    libglib.}
proc sequenceSet*(iter: GSequenceIter; data: Gpointer) {.
    importc: "g_sequence_set", libglib.}

proc isBegin*(iter: GSequenceIter): Gboolean {.
    importc: "g_sequence_iter_is_begin", libglib.}
proc isEnd*(iter: GSequenceIter): Gboolean {.
    importc: "g_sequence_iter_is_end", libglib.}
proc next*(iter: GSequenceIter): GSequenceIter {.
    importc: "g_sequence_iter_next", libglib.}
proc prev*(iter: GSequenceIter): GSequenceIter {.
    importc: "g_sequence_iter_prev", libglib.}
proc getPosition*(iter: GSequenceIter): cint {.
    importc: "g_sequence_iter_get_position", libglib.}
proc position*(iter: GSequenceIter): cint {.
    importc: "g_sequence_iter_get_position", libglib.}
proc move*(iter: GSequenceIter; delta: cint): GSequenceIter {.
    importc: "g_sequence_iter_move", libglib.}
proc getSequence*(iter: GSequenceIter): GSequence {.
    importc: "g_sequence_iter_get_sequence", libglib.}
proc sequence*(iter: GSequenceIter): GSequence {.
    importc: "g_sequence_iter_get_sequence", libglib.}

proc compare*(a: GSequenceIter; b: GSequenceIter): cint {.
    importc: "g_sequence_iter_compare", libglib.}
proc sequenceRangeGetMidpoint*(begin: GSequenceIter; `end`: GSequenceIter): GSequenceIter {.
    importc: "g_sequence_range_get_midpoint", libglib.}

type
  GShellError* {.size: sizeof(cint), pure.} = enum
    BAD_QUOTING, EMPTY_STRING, FAILED

proc shellErrorQuark*(): GQuark {.importc: "g_shell_error_quark", libglib.}
proc shellQuote*(unquotedString: cstring): cstring {.importc: "g_shell_quote",
    libglib.}
proc shellUnquote*(quotedString: cstring; error: var GError): cstring {.
    importc: "g_shell_unquote", libglib.}
proc shellParseArgv*(commandLine: cstring; argcp: var cint; argvp: var cstringArray;
                     error: var GError): Gboolean {.
    importc: "g_shell_parse_argv", libglib.}

proc sliceAlloc*(blockSize: Gsize): Gpointer {.importc: "g_slice_alloc", libglib.}
proc sliceAlloc0*(blockSize: Gsize): Gpointer {.importc: "g_slice_alloc0",
    libglib.}
proc sliceCopy*(blockSize: Gsize; memBlock: Gconstpointer): Gpointer {.
    importc: "g_slice_copy", libglib.}
proc sliceFree1*(blockSize: Gsize; memBlock: Gpointer) {.importc: "g_slice_free1",
    libglib.}
proc sliceFreeChainWithOffset*(blockSize: Gsize; memChain: Gpointer;
                               nextOffset: Gsize) {.
    importc: "g_slice_free_chain_with_offset", libglib.}

type
  GSliceConfig* {.size: sizeof(cint), pure.} = enum
    ALWAYS_MALLOC = 1, BYPASS_MAGAZINES,
    WORKING_SET_MSECS, COLOR_INCREMENT,
    CHUNK_SIZES, CONTENTION_COUNTER

proc sliceSetConfig*(ckey: GSliceConfig; value: int64) {.
    importc: "g_slice_set_config", libglib.}
proc sliceGetConfig*(ckey: GSliceConfig): int64 {.importc: "g_slice_get_config",
    libglib.}
proc sliceGetConfigState*(ckey: GSliceConfig; address: int64; nValues: var cuint): ptr int64 {.
    importc: "g_slice_get_config_state", libglib.}
when (G_ENABLE_DEBUG):
  proc sliceDebugTreeStatistics*() {.importc: "g_slice_debug_tree_statistics",
                                    libglib.}

type
  GSpawnError* {.size: sizeof(cint), pure.} = enum
    FORK, READ, CHDIR,
    ACCES, PERM, TOO_BIG,
    NOEXEC, NAMETOOLONG, NOENT,
    NOMEM, NOTDIR, LOOP,
    TXTBUSY, IO, NFILE,
    MFILE, INVAL, ISDIR,
    LIBBAD, FAILED

type
  GSpawnChildSetupFunc* = proc (userData: Gpointer) {.cdecl.}

type
  GSpawnFlags* {.size: sizeof(cint), pure.} = enum
    DEFAULT = 0, LEAVE_DESCRIPTORS_OPEN = 1 shl 0,
    DO_NOT_REAP_CHILD = 1 shl 1, SEARCH_PATH = 1 shl 2,
    STDOUT_TO_DEV_NULL = 1 shl 3, STDERR_TO_DEV_NULL = 1 shl 4,
    CHILD_INHERITS_STDIN = 1 shl 5, FILE_AND_ARGV_ZERO = 1 shl 6,
    SEARCH_PATH_FROM_ENVP = 1 shl 7, CLOEXEC_PIPES = 1 shl 8

proc spawnErrorQuark*(): GQuark {.importc: "g_spawn_error_quark", libglib.}
proc spawnExitErrorQuark*(): GQuark {.importc: "g_spawn_exit_error_quark",
                                    libglib.}
proc spawnAsync*(workingDirectory: cstring; argv: cstringArray; envp: cstringArray;
                 flags: GSpawnFlags; childSetup: GSpawnChildSetupFunc;
                 userData: Gpointer; childPid: ptr GPid; error: var GError): Gboolean {.
    importc: "g_spawn_async", libglib.}

proc spawnAsyncWithPipes*(workingDirectory: cstring; argv: cstringArray;
                          envp: cstringArray; flags: GSpawnFlags;
                          childSetup: GSpawnChildSetupFunc; userData: Gpointer;
                          childPid: ptr GPid; standardInput: var cint;
                          standardOutput: var cint; standardError: var cint;
                          error: var GError): Gboolean {.
    importc: "g_spawn_async_with_pipes", libglib.}

proc spawnSync*(workingDirectory: cstring; argv: cstringArray; envp: cstringArray;
                flags: GSpawnFlags; childSetup: GSpawnChildSetupFunc;
                userData: Gpointer; standardOutput: cstringArray;
                standardError: cstringArray; exitStatus: var cint;
                error: var GError): Gboolean {.importc: "g_spawn_sync", libglib.}
proc spawnCommandLineSync*(commandLine: cstring; standardOutput: cstringArray;
                           standardError: cstringArray; exitStatus: var cint;
                           error: var GError): Gboolean {.
    importc: "g_spawn_command_line_sync", libglib.}
proc spawnCommandLineAsync*(commandLine: cstring; error: var GError): Gboolean {.
    importc: "g_spawn_command_line_async", libglib.}
proc spawnCheckExitStatus*(exitStatus: cint; error: var GError): Gboolean {.
    importc: "g_spawn_check_exit_status", libglib.}
proc spawnClosePid*(pid: GPid) {.importc: "g_spawn_close_pid", libglib.}

type
  GAsciiType* {.size: sizeof(cint), pure.} = enum
    ALNUM = 1 shl 0, ALPHA = 1 shl 1, CNTRL = 1 shl 2,
    DIGIT = 1 shl 3, GRAPH = 1 shl 4, LOWER = 1 shl 5,
    PRINT = 1 shl 6, PUNCT = 1 shl 7, SPACE = 1 shl 8,
    UPPER = 1 shl 9, XDIGIT = 1 shl 10

template gAsciiIsalnum*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Alnum) != 0)

template gAsciiIsalpha*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Alpha) != 0)

template gAsciiIscntrl*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Cntrl) != 0)

template gAsciiIsdigit*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Digit) != 0)

template gAsciiIsgraph*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Graph) != 0)

template gAsciiIslower*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Lower) != 0)

template gAsciiIsprint*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Print) != 0)

template gAsciiIspunct*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Punct) != 0)

template gAsciiIsspace*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Space) != 0)

template gAsciiIsupper*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Upper) != 0)

template gAsciiIsxdigit*(c: untyped): untyped =
  ((gAsciiTable[(guchar)(c)] and g_Ascii_Xdigit) != 0)

proc asciiTolower*(c: char): char {.importc: "g_ascii_tolower", libglib.}
proc asciiToupper*(c: char): char {.importc: "g_ascii_toupper", libglib.}
proc asciiDigitValue*(c: char): cint {.importc: "g_ascii_digit_value", libglib.}
proc asciiXdigitValue*(c: char): cint {.importc: "g_ascii_xdigit_value", libglib.}

const
  G_STR_DELIMITERS* = "_-|> <."

proc delimit*(string: cstring; delimiters: cstring; newDelimiter: char): cstring {.
    importc: "g_strdelimit", libglib.}
proc canon*(string: cstring; validChars: cstring; substitutor: char): cstring {.
    importc: "g_strcanon", libglib.}
proc strerror*(errnum: cint): cstring {.importc: "g_strerror", libglib.}
proc strsignal*(signum: cint): cstring {.importc: "g_strsignal", libglib.}
proc reverse*(string: cstring): cstring {.importc: "g_strreverse", libglib.}
proc lcpy*(dest: cstring; src: cstring; destSize: Gsize): Gsize {.
    importc: "g_strlcpy", libglib.}
proc lcat*(dest: cstring; src: cstring; destSize: Gsize): Gsize {.
    importc: "g_strlcat", libglib.}
proc strLen*(haystack: cstring; haystackLen: Gssize; needle: cstring): cstring {.
    importc: "g_strstr_len", libglib.}
proc rstr*(haystack: cstring; needle: cstring): cstring {.importc: "g_strrstr",
    libglib.}
proc rstrLen*(haystack: cstring; haystackLen: Gssize; needle: cstring): cstring {.
    importc: "g_strrstr_len", libglib.}
proc hasSuffix*(str: cstring; suffix: cstring): Gboolean {.
    importc: "g_str_has_suffix", libglib.}
proc hasPrefix*(str: cstring; prefix: cstring): Gboolean {.
    importc: "g_str_has_prefix", libglib.}

proc tod*(nptr: cstring; endptr: cstringArray): cdouble {.importc: "g_strtod",
    libglib.}
proc asciiStrtod*(nptr: cstring; endptr: cstringArray): cdouble {.
    importc: "g_ascii_strtod", libglib.}
proc asciiStrtoull*(nptr: cstring; endptr: cstringArray; base: cuint): uint64 {.
    importc: "g_ascii_strtoull", libglib.}
proc asciiStrtoll*(nptr: cstring; endptr: cstringArray; base: cuint): int64 {.
    importc: "g_ascii_strtoll", libglib.}

const
  G_ASCII_DTOSTR_BUF_SIZE* = (29 + 10)

proc asciiDtostr*(buffer: cstring; bufLen: cint; d: cdouble): cstring {.
    importc: "g_ascii_dtostr", libglib.}
proc asciiFormatd*(buffer: cstring; bufLen: cint; format: cstring; d: cdouble): cstring {.
    importc: "g_ascii_formatd", libglib.}

proc chug*(string: cstring): cstring {.importc: "g_strchug", libglib.}

proc chomp*(string: cstring): cstring {.importc: "g_strchomp", libglib.}

template gStrstrip*(string: untyped): untyped =
  gStrchomp(gStrchug(string))

proc asciiStrcasecmp*(s1: cstring; s2: cstring): cint {.
    importc: "g_ascii_strcasecmp", libglib.}
proc asciiStrncasecmp*(s1: cstring; s2: cstring; n: Gsize): cint {.
    importc: "g_ascii_strncasecmp", libglib.}
proc asciiStrdown*(str: cstring; len: Gssize): cstring {.importc: "g_ascii_strdown",
    libglib.}
proc asciiStrup*(str: cstring; len: Gssize): cstring {.importc: "g_ascii_strup",
    libglib.}
proc isAscii*(str: cstring): Gboolean {.importc: "g_str_is_ascii", libglib.}
proc casecmp*(s1: cstring; s2: cstring): cint {.importc: "g_strcasecmp", libglib.}
proc ncasecmp*(s1: cstring; s2: cstring; n: cuint): cint {.importc: "g_strncasecmp",
    libglib.}
proc down*(string: cstring): cstring {.importc: "g_strdown", libglib.}
proc up*(string: cstring): cstring {.importc: "g_strup", libglib.}

proc dup*(str: cstring): cstring {.importc: "g_strdup", libglib.}
proc dupPrintf*(format: cstring): cstring {.varargs, importc: "g_strdup_printf",
    libglib.}
when (VALIST):
  proc strdupVprintf*(format: cstring; args: VaList): cstring {.
      importc: "g_strdup_vprintf", libglib.}
proc ndup*(str: cstring; n: Gsize): cstring {.importc: "g_strndup", libglib.}
proc strnfill*(length: Gsize; fillChar: char): cstring {.importc: "g_strnfill",
    libglib.}
proc concat*(string1: cstring): cstring {.varargs, importc: "g_strconcat",
    libglib.}
proc join*(separator: cstring): cstring {.varargs, importc: "g_strjoin",
    libglib.}

proc compress*(source: cstring): cstring {.importc: "g_strcompress", libglib.}

proc escape*(source: cstring; exceptions: cstring): cstring {.
    importc: "g_strescape", libglib.}
proc memdup*(mem: Gconstpointer; byteSize: cuint): Gpointer {.importc: "g_memdup",
    libglib.}

type
  GStrv* = cstringArray

proc split*(string: cstring; delimiter: cstring; maxTokens: cint): cstringArray {.
    importc: "g_strsplit", libglib.}
proc splitSet*(string: cstring; delimiters: cstring; maxTokens: cint): cstringArray {.
    importc: "g_strsplit_set", libglib.}
proc joinv*(separator: cstring; strArray: cstringArray): cstring {.
    importc: "g_strjoinv", libglib.}
proc strfreev*(strArray: cstringArray) {.importc: "g_strfreev", libglib.}
proc strdupv*(strArray: cstringArray): cstringArray {.importc: "g_strdupv",
    libglib.}
proc strvLength*(strArray: cstringArray): cuint {.importc: "g_strv_length",
    libglib.}
proc stpcpy*(dest: cstring; src: cstring): cstring {.importc: "g_stpcpy", libglib.}
proc toAscii*(str: cstring; fromLocale: cstring): cstring {.
    importc: "g_str_to_ascii", libglib.}
proc tokenizeAndFold*(string: cstring; translitLocale: cstring;
                         asciiAlternates: var cstringArray): cstringArray {.
    importc: "g_str_tokenize_and_fold", libglib.}
proc matchString*(searchTerm: cstring; potentialHit: cstring;
                     acceptAlternates: Gboolean): Gboolean {.
    importc: "g_str_match_string", libglib.}
proc strvContains*(strv: cstringArray; str: cstring): Gboolean {.
    importc: "g_strv_contains", libglib.}

type
  GNumberParserError* {.size: sizeof(cint), pure.} = enum
    INVALID, OUT_OF_BOUNDS

proc numberParserErrorQuark*(): GQuark {.importc: "g_number_parser_error_quark",
                                       libglib.}
proc asciiStringToSigned*(str: cstring; base: cuint; min: int64; max: int64;
                          outNum: var int64; error: var GError): Gboolean {.
    importc: "g_ascii_string_to_signed", libglib.}
proc asciiStringToUnsigned*(str: cstring; base: cuint; min: uint64; max: uint64;
                            outNum: var uint64; error: var GError): Gboolean {.
    importc: "g_ascii_string_to_unsigned", libglib.}

type
  GStringChunk* =  ptr GStringChunkObj
  GStringChunkPtr* = ptr GStringChunkObj
  GStringChunkObj* = object

proc newStringChunk*(size: Gsize): GStringChunk {.importc: "g_string_chunk_new",
    libglib.}
proc free*(chunk: GStringChunk) {.importc: "g_string_chunk_free",
    libglib.}
proc clear*(chunk: GStringChunk) {.importc: "g_string_chunk_clear",
    libglib.}
proc insert*(chunk: GStringChunk; string: cstring): cstring {.
    importc: "g_string_chunk_insert", libglib.}
proc insertLen*(chunk: GStringChunk; string: cstring; len: Gssize): cstring {.
    importc: "g_string_chunk_insert_len", libglib.}
proc insertConst*(chunk: GStringChunk; string: cstring): cstring {.
    importc: "g_string_chunk_insert_const", libglib.}

type
  GTestCase* =  ptr GTestCaseObj
  GTestCasePtr* = ptr GTestCaseObj
  GTestCaseObj* = object

  GTestSuite* =  ptr GTestSuiteObj
  GTestSuitePtr* = ptr GTestSuiteObj
  GTestSuiteObj* = object

  GTestFunc* = proc () {.cdecl.}
  GTestDataFunc* = proc (userData: Gconstpointer) {.cdecl.}
  GTestFixtureFunc* = proc (fixture: Gpointer; userData: Gconstpointer) {.cdecl.}

proc cmp0*(str1: cstring; str2: cstring): cint {.importc: "g_strcmp0", libglib.}

proc testMinimizedResult*(minimizedQuantity: cdouble; format: cstring) {.varargs,
    importc: "g_test_minimized_result", libglib.}
proc testMaximizedResult*(maximizedQuantity: cdouble; format: cstring) {.varargs,
    importc: "g_test_maximized_result", libglib.}

proc testInit*(argc: var cint; argv: var cstringArray) {.varargs,
    importc: "g_test_init", libglib.}

template gTestInitialized*(): untyped =
  (gTestConfigVars.testInitialized)

template gTestQuick*(): untyped =
  (gTestConfigVars.testQuick)

template gTestSlow*(): untyped =
  (not gTestConfigVars.testQuick)

template gTestThorough*(): untyped =
  (not gTestConfigVars.testQuick)

template gTestPerf*(): untyped =
  (gTestConfigVars.testPerf)

template gTestVerbose*(): untyped =
  (gTestConfigVars.testVerbose)

template gTestQuiet*(): untyped =
  (gTestConfigVars.testQuiet)

template gTestUndefined*(): untyped =
  (gTestConfigVars.testUndefined)

proc testSubprocess*(): Gboolean {.importc: "g_test_subprocess", libglib.}

proc testRun*(): cint {.importc: "g_test_run", libglib.}

proc testAddFunc*(testpath: cstring; testFunc: GTestFunc) {.
    importc: "g_test_add_func", libglib.}
proc testAddDataFunc*(testpath: cstring; testData: Gconstpointer;
                      testFunc: GTestDataFunc) {.importc: "g_test_add_data_func",
    libglib.}
proc testAddDataFuncFull*(testpath: cstring; testData: Gpointer;
                          testFunc: GTestDataFunc; dataFreeFunc: GDestroyNotify) {.
    importc: "g_test_add_data_func_full", libglib.}

proc testFail*() {.importc: "g_test_fail", libglib.}
proc testIncomplete*(msg: cstring) {.importc: "g_test_incomplete", libglib.}
proc testSkip*(msg: cstring) {.importc: "g_test_skip", libglib.}
proc testFailed*(): Gboolean {.importc: "g_test_failed", libglib.}
proc testSetNonfatalAssertions*() {.importc: "g_test_set_nonfatal_assertions",
                                   libglib.}

proc testMessage*(format: cstring) {.varargs, importc: "g_test_message", libglib.}
proc testBugBase*(uriPattern: cstring) {.importc: "g_test_bug_base", libglib.}
proc testBug*(bugUriSnippet: cstring) {.importc: "g_test_bug", libglib.}

proc testTimerStart*() {.importc: "g_test_timer_start", libglib.}
proc testTimerElapsed*(): cdouble {.importc: "g_test_timer_elapsed", libglib.}

proc testTimerLast*(): cdouble {.importc: "g_test_timer_last", libglib.}

proc testQueueFree*(gfreePointer: Gpointer) {.importc: "g_test_queue_free",
    libglib.}
proc testQueueDestroy*(destroyFunc: GDestroyNotify; destroyData: Gpointer) {.
    importc: "g_test_queue_destroy", libglib.}
template gTestQueueUnref*(gobject: untyped): untyped =
  testQueueDestroy(gObjectUnref, gobject)

type
  GTestTrapFlags* {.size: sizeof(cint), pure.} = enum
    SILENCE_STDOUT = 1 shl 7, SILENCE_STDERR = 1 shl 8,
    INHERIT_STDIN = 1 shl 9

proc testTrapFork*(usecTimeout: uint64; testTrapFlags: GTestTrapFlags): Gboolean {.
    importc: "g_test_trap_fork", libglib.}
type
  GTestSubprocessFlags* {.size: sizeof(cint), pure.} = enum
    INHERIT_STDIN = 1 shl 0,
    INHERIT_STDOUT = 1 shl 1,
    INHERIT_STDERR = 1 shl 2

proc testTrapSubprocess*(testPath: cstring; usecTimeout: uint64;
                         testFlags: GTestSubprocessFlags) {.
    importc: "g_test_trap_subprocess", libglib.}
proc testTrapHasPassed*(): Gboolean {.importc: "g_test_trap_has_passed", libglib.}
proc testTrapReachedTimeout*(): Gboolean {.importc: "g_test_trap_reached_timeout",
    libglib.}

template gTestRandBit*(): untyped =
  (0 != (testRandInt() and (1 shl 15)))

proc testRandInt*(): int32 {.importc: "g_test_rand_int", libglib.}
proc testRandIntRange*(begin: int32; `end`: int32): int32 {.
    importc: "g_test_rand_int_range", libglib.}
proc testRandDouble*(): cdouble {.importc: "g_test_rand_double", libglib.}
proc testRandDoubleRange*(rangeStart: cdouble; rangeEnd: cdouble): cdouble {.
    importc: "g_test_rand_double_range", libglib.}

proc testCreateCase*(testName: cstring; dataSize: Gsize; testData: Gconstpointer;
                     dataSetup: GTestFixtureFunc; dataTest: GTestFixtureFunc;
                     dataTeardown: GTestFixtureFunc): GTestCase {.
    importc: "g_test_create_case", libglib.}
proc testCreateSuite*(suiteName: cstring): GTestSuite {.
    importc: "g_test_create_suite", libglib.}
proc testGetRoot*(): GTestSuite {.importc: "g_test_get_root", libglib.}
proc add*(suite: GTestSuite; testCase: GTestCase) {.
    importc: "g_test_suite_add", libglib.}
proc addSuite*(suite: GTestSuite; nestedsuite: GTestSuite) {.
    importc: "g_test_suite_add_suite", libglib.}
proc testRunSuite*(suite: GTestSuite): cint {.importc: "g_test_run_suite",
    libglib.}
proc testTrapAssertions*(domain: cstring; file: cstring; line: cint; `func`: cstring;
                         assertionFlags: uint64; pattern: cstring) {.
    importc: "g_test_trap_assertions", libglib.}
proc assertionMessage*(domain: cstring; file: cstring; line: cint; `func`: cstring;
                       message: cstring) {.importc: "g_assertion_message",
    libglib.}
proc assertionMessageExpr*(domain: cstring; file: cstring; line: cint;
                           `func`: cstring; expr: cstring) {.
    importc: "g_assertion_message_expr", libglib.}
proc assertionMessageCmpstr*(domain: cstring; file: cstring; line: cint;
                             `func`: cstring; expr: cstring; arg1: cstring;
                             cmp: cstring; arg2: cstring) {.
    importc: "g_assertion_message_cmpstr", libglib.}
proc assertionMessageCmpnum*(domain: cstring; file: cstring; line: cint;
                             `func`: cstring; expr: cstring; arg1: clongdouble;
                             cmp: cstring; arg2: clongdouble; numtype: char) {.
    importc: "g_assertion_message_cmpnum", libglib.}
proc assertionMessageError*(domain: cstring; file: cstring; line: cint;
                            `func`: cstring; expr: cstring; error: GError;
                            errorDomain: GQuark; errorCode: cint) {.
    importc: "g_assertion_message_error", libglib.}
proc testAddVtable*(testpath: cstring; dataSize: Gsize; testData: Gconstpointer;
                    dataSetup: GTestFixtureFunc; dataTest: GTestFixtureFunc;
                    dataTeardown: GTestFixtureFunc) {.
    importc: "g_test_add_vtable", libglib.}
type
  GTestConfig* =  ptr GTestConfigObj
  GTestConfigPtr* = ptr GTestConfigObj
  GTestConfigObj* = object
    testInitialized*: Gboolean
    testQuick*: Gboolean
    testPerf*: Gboolean
    testVerbose*: Gboolean
    testQuiet*: Gboolean
    testUndefined*: Gboolean

type
  GTestLogType* {.size: sizeof(cint), pure.} = enum
    NONE, ERROR, START_BINARY,
    LIST_CASE, SKIP_CASE, START_CASE,
    STOP_CASE, MIN_RESULT, MAX_RESULT,
    MESSAGE, START_SUITE, STOP_SUITE
  GTestLogMsg* =  ptr GTestLogMsgObj
  GTestLogMsgPtr* = ptr GTestLogMsgObj
  GTestLogMsgObj* = object
    logType*: GTestLogType
    nStrings*: cuint
    strings*: cstringArray
    nNums*: cuint
    nums*: ptr clongdouble

  GTestLogBuffer* =  ptr GTestLogBufferObj
  GTestLogBufferPtr* = ptr GTestLogBufferObj
  GTestLogBufferObj* = object
    data*: GString
    msgs*: GSList

proc name*(logType: GTestLogType): cstring {.
    importc: "g_test_log_type_name", libglib.}
proc newTestLogBuffer*(): GTestLogBuffer {.importc: "g_test_log_buffer_new",
    libglib.}
proc free*(tbuffer: GTestLogBuffer) {.
    importc: "g_test_log_buffer_free", libglib.}
proc push*(tbuffer: GTestLogBuffer; nBytes: cuint; bytes: var uint8) {.
    importc: "g_test_log_buffer_push", libglib.}
proc pop*(tbuffer: GTestLogBuffer): GTestLogMsg {.
    importc: "g_test_log_buffer_pop", libglib.}
proc free*(tmsg: GTestLogMsg) {.importc: "g_test_log_msg_free",
    libglib.}

type
  GTestLogFatalFunc* = proc (logDomain: cstring; logLevel: GLogLevelFlags;
                          message: cstring; userData: Gpointer): Gboolean {.cdecl.}

proc testLogSetFatalHandler*(logFunc: GTestLogFatalFunc; userData: Gpointer) {.
    importc: "g_test_log_set_fatal_handler", libglib.}
proc testExpectMessage*(logDomain: cstring; logLevel: GLogLevelFlags;
                        pattern: cstring) {.importc: "g_test_expect_message",
    libglib.}
proc testAssertExpectedMessagesInternal*(domain: cstring; file: cstring; line: cint;
    `func`: cstring) {.importc: "g_test_assert_expected_messages_internal",
                     libglib.}
type
  GTestFileType* {.size: sizeof(cint), pure.} = enum
    DIST, BUILT

proc testBuildFilename*(fileType: GTestFileType; firstPath: cstring): cstring {.
    varargs, importc: "g_test_build_filename", libglib.}
proc testGetDir*(fileType: GTestFileType): cstring {.importc: "g_test_get_dir",
    libglib.}
proc testGetFilename*(fileType: GTestFileType; firstPath: cstring): cstring {.
    varargs, importc: "g_test_get_filename", libglib.}
template gTestAssertExpectedMessages*(): untyped =
  testAssertExpectedMessagesInternal(g_Log_Domain, file, line, g_Strfunc)

type
  GThreadPool* =  ptr GThreadPoolObj
  GThreadPoolPtr* = ptr GThreadPoolObj
  GThreadPoolObj* = object
    `func`*: GFunc
    userData*: Gpointer
    exclusive*: Gboolean

proc newThreadPool*(`func`: GFunc; userData: Gpointer; maxThreads: cint;
                    exclusive: Gboolean; error: var GError): GThreadPool {.
    importc: "g_thread_pool_new", libglib.}
proc free*(pool: GThreadPool; immediate: Gboolean; wait: Gboolean) {.
    importc: "g_thread_pool_free", libglib.}
proc push*(pool: GThreadPool; data: Gpointer; error: var GError): Gboolean {.
    importc: "g_thread_pool_push", libglib.}
proc unprocessed*(pool: GThreadPool): cuint {.
    importc: "g_thread_pool_unprocessed", libglib.}
proc setSortFunction*(pool: GThreadPool; `func`: GCompareDataFunc;
                                userData: Gpointer) {.
    importc: "g_thread_pool_set_sort_function", libglib.}
proc `sortFunction=`*(pool: GThreadPool; `func`: GCompareDataFunc;
                                userData: Gpointer) {.
    importc: "g_thread_pool_set_sort_function", libglib.}
proc moveToFront*(pool: GThreadPool; data: Gpointer): Gboolean {.
    importc: "g_thread_pool_move_to_front", libglib.}
proc setMaxThreads*(pool: GThreadPool; maxThreads: cint;
                              error: var GError): Gboolean {.
    importc: "g_thread_pool_set_max_threads", libglib.}
proc getMaxThreads*(pool: GThreadPool): cint {.
    importc: "g_thread_pool_get_max_threads", libglib.}
proc maxThreads*(pool: GThreadPool): cint {.
    importc: "g_thread_pool_get_max_threads", libglib.}
proc getNumThreads*(pool: GThreadPool): cuint {.
    importc: "g_thread_pool_get_num_threads", libglib.}
proc numThreads*(pool: GThreadPool): cuint {.
    importc: "g_thread_pool_get_num_threads", libglib.}
proc threadPoolSetMaxUnusedThreads*(maxThreads: cint) {.
    importc: "g_thread_pool_set_max_unused_threads", libglib.}
proc threadPoolGetMaxUnusedThreads*(): cint {.
    importc: "g_thread_pool_get_max_unused_threads", libglib.}
proc threadPoolGetNumUnusedThreads*(): cuint {.
    importc: "g_thread_pool_get_num_unused_threads", libglib.}
proc threadPoolStopUnusedThreads*() {.importc: "g_thread_pool_stop_unused_threads",
                                     libglib.}
proc threadPoolSetMaxIdleTime*(interval: cuint) {.
    importc: "g_thread_pool_set_max_idle_time", libglib.}
proc threadPoolGetMaxIdleTime*(): cuint {.importc: "g_thread_pool_get_max_idle_time",
                                        libglib.}

type
  GTimer* =  ptr GTimerObj
  GTimerPtr* = ptr GTimerObj
  GTimerObj* = object

const
  G_USEC_PER_SEC* = 1000000

proc newTimer*(): GTimer {.importc: "g_timer_new", libglib.}
proc destroy*(timer: GTimer) {.importc: "g_timer_destroy", libglib.}
proc start*(timer: GTimer) {.importc: "g_timer_start", libglib.}
proc stop*(timer: GTimer) {.importc: "g_timer_stop", libglib.}
proc reset*(timer: GTimer) {.importc: "g_timer_reset", libglib.}
proc `continue`*(timer: GTimer) {.importc: "g_timer_continue", libglib.}
proc elapsed*(timer: GTimer; microseconds: ptr culong): cdouble {.
    importc: "g_timer_elapsed", libglib.}
proc usleep*(microseconds: culong) {.importc: "g_usleep", libglib.}
proc add*(time: GTimeVal; microseconds: clong) {.
    importc: "g_time_val_add", libglib.}
proc timeValFromIso8601*(isoDate: cstring; time: GTimeVal): Gboolean {.
    importc: "g_time_val_from_iso8601", libglib.}
proc toIso8601*(time: GTimeVal): cstring {.
    importc: "g_time_val_to_iso8601", libglib.}

type
  GTrashStack* =  ptr GTrashStackObj
  GTrashStackPtr* = ptr GTrashStackObj
  GTrashStackObj* = object
    next*: GTrashStack

proc push*(stackP: var GTrashStack; dataP: Gpointer) {.
    importc: "g_trash_stack_push", libglib.}
proc pop*(stackP: var GTrashStack): Gpointer {.
    importc: "g_trash_stack_pop", libglib.}
proc peek*(stackP: var GTrashStack): Gpointer {.
    importc: "g_trash_stack_peek", libglib.}
proc height*(stackP: var GTrashStack): cuint {.
    importc: "g_trash_stack_height", libglib.}

type
  GTree* =  ptr GTreeObj
  GTreePtr* = ptr GTreeObj
  GTreeObj* = object

  GTraverseFunc* = proc (key: Gpointer; value: Gpointer; data: Gpointer): Gboolean {.cdecl.}

proc newTree*(keyCompareFunc: GCompareFunc): GTree {.importc: "g_tree_new",
    libglib.}
proc newTree*(keyCompareFunc: GCompareDataFunc; keyCompareData: Gpointer): GTree {.
    importc: "g_tree_new_with_data", libglib.}
proc newTree*(keyCompareFunc: GCompareDataFunc; keyCompareData: Gpointer;
                  keyDestroyFunc: GDestroyNotify; valueDestroyFunc: GDestroyNotify): GTree {.
    importc: "g_tree_new_full", libglib.}
proc `ref`*(tree: GTree): GTree {.importc: "g_tree_ref", libglib.}
proc unref*(tree: GTree) {.importc: "g_tree_unref", libglib.}
proc destroy*(tree: GTree) {.importc: "g_tree_destroy", libglib.}
proc insert*(tree: GTree; key: Gpointer; value: Gpointer) {.
    importc: "g_tree_insert", libglib.}
proc replace*(tree: GTree; key: Gpointer; value: Gpointer) {.
    importc: "g_tree_replace", libglib.}
proc remove*(tree: GTree; key: Gconstpointer): Gboolean {.
    importc: "g_tree_remove", libglib.}
proc steal*(tree: GTree; key: Gconstpointer): Gboolean {.
    importc: "g_tree_steal", libglib.}
proc lookup*(tree: GTree; key: Gconstpointer): Gpointer {.
    importc: "g_tree_lookup", libglib.}
proc lookupExtended*(tree: GTree; lookupKey: Gconstpointer;
                         origKey: ptr Gpointer; value: var Gpointer): Gboolean {.
    importc: "g_tree_lookup_extended", libglib.}
proc foreach*(tree: GTree; `func`: GTraverseFunc; userData: Gpointer) {.
    importc: "g_tree_foreach", libglib.}
proc traverse*(tree: GTree; traverseFunc: GTraverseFunc;
                   traverseType: GTraverseType; userData: Gpointer) {.
    importc: "g_tree_traverse", libglib.}
proc search*(tree: GTree; searchFunc: GCompareFunc; userData: Gconstpointer): Gpointer {.
    importc: "g_tree_search", libglib.}
proc height*(tree: GTree): cint {.importc: "g_tree_height", libglib.}
proc nnodes*(tree: GTree): cint {.importc: "g_tree_nnodes", libglib.}

const
  G_URI_RESERVED_CHARS_GENERIC_DELIMITERS* = ":/?#[]@"

const
  G_URI_RESERVED_CHARS_SUBCOMPONENT_DELIMITERS* = "!$&\'()*+,;="

proc uriUnescapeString*(escapedString: cstring; illegalCharacters: cstring): cstring {.
    importc: "g_uri_unescape_string", libglib.}
proc uriUnescapeSegment*(escapedString: cstring; escapedStringEnd: cstring;
                         illegalCharacters: cstring): cstring {.
    importc: "g_uri_unescape_segment", libglib.}
proc uriParseScheme*(uri: cstring): cstring {.importc: "g_uri_parse_scheme",
    libglib.}
proc uriEscapeString*(unescaped: cstring; reservedCharsAllowed: cstring;
                      allowUtf8: Gboolean): cstring {.
    importc: "g_uri_escape_string", libglib.}

proc uuidStringIsValid*(str: cstring): Gboolean {.
    importc: "g_uuid_string_is_valid", libglib.}
proc uuidStringRandom*(): cstring {.importc: "g_uuid_string_random", libglib.}

proc glibCheckVersion*(requiredMajor: cuint; requiredMinor: cuint;
                      requiredMicro: cuint): cstring {.
    importc: "glib_check_version", libglib.}
template glibCheckVersion*(major, minor, micro: untyped): untyped =
  (glib_Major_Version > major or
      (glib_Major_Version == major and glib_Minor_Version > minor) or
      (glib_Major_Version == major and glib_Minor_Version == minor and
      glib_Micro_Version >= micro))
# manual extensions for glib.nim
#
converter ghtio2ghti*(i: var GHashTableIterObj): GHashTableIter =
  addr(i)

const G_LOG_DOMAIN* = cast[ptr cchar](0)

proc critical*(format: cstring) {.varargs.} =
  glib.log(G_LOG_DOMAIN, GLogLevelFlags.LEVEL_CRITICAL, format)

proc gNot*(gb: Gboolean): Gboolean = Gboolean(GTRUE.cint - gb.cint)
