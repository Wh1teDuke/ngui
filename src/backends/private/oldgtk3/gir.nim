{.deadCodeElim: on.}

from glib import Gpointer, Gboolean, GQuark, Gsize, GSsize
from gobject import GObject, GType, GObjectObj, GObjectClassObj, GParamFlags, GSignalFlags

when defined(windows):
  const LIB_GIR = "libgirepository-1.0-1.dll"
elif defined(macosx):
  const LIB_GIR = "libgirepository-1.0.dylib"
else:
  const LIB_GIR = "libgirepository-1.0.so(|.1)"

{.pragma: libgir, cdecl, dynlib: LIB_GIR.}

type
  GIBaseInfoStub* =  ptr GIBaseInfoStubObj
  GIBaseInfoStubPtr* = ptr GIBaseInfoStubObj
  GIBaseInfoStubObj* = object
    dummy1: int32
    dummy2: int32
    dummy3: Gpointer
    dummy4: Gpointer
    dummy5: Gpointer
    dummy6: uint32
    dummy7: uint32
    padding: array[4, Gpointer]

type
  GIAttributeIter* =  ptr GIAttributeIterObj
  GIAttributeIterPtr* = ptr GIAttributeIterObj
  GIAttributeIterObj* = object
    data: Gpointer
    data2: Gpointer
    data3: Gpointer
    data4: Gpointer

type
  GIBaseInfo* = GIBaseInfoStub

type
  GICallableInfo* = GIBaseInfo

type
  GIFunctionInfo* = GIBaseInfo

type
  GICallbackInfo* = GIBaseInfo

type
  GIRegisteredTypeInfo* = GIBaseInfo

type
  GIStructInfo* = GIBaseInfo

type
  GIUnionInfo* = GIBaseInfo

type
  GIEnumInfo* = GIBaseInfo

type
  GIObjectInfo* = GIBaseInfo

type
  GIInterfaceInfo* = GIBaseInfo

type
  GIConstantInfo* = GIBaseInfo

type
  GIValueInfo* = GIBaseInfo

type
  GISignalInfo* = GIBaseInfo

type
  GIVFuncInfo* = GIBaseInfo

type
  GIPropertyInfo* = GIBaseInfo

type
  GIFieldInfo* = GIBaseInfo

type
  GIArgInfo* = GIBaseInfo

type
  GITypeInfo* = GIBaseInfo

type
  GIArgument* =  ptr GIArgumentObj
  GIArgumentPtr* = ptr GIArgumentObj
  GIArgumentObj* {.union.} = object
    vBoolean*: Gboolean
    vInt8*: int8
    vUint8*: uint8
    vInt16*: int16
    vUint16*: uint16
    vInt32*: int32
    vUint32*: uint32
    vInt64*: int64
    vUint64*: uint64
    vFloat*: cfloat
    vDouble*: cdouble
    vShort*: cshort
    vUshort*: cushort
    vInt*: cint
    vUint*: cuint
    vLong*: clong
    vUlong*: culong
    vSsize*: Gssize
    vSize*: Gsize
    vString*: cstring
    vPointer*: Gpointer

type
  GIInfoType* {.size: sizeof(cint), pure.} = enum
    INVALID, FUNCTION, CALLBACK,
    STRUCT, BOXED, ENUM, FLAGS,
    OBJECT, INTERFACE, CONSTANT,
    INVALID_0, UNION, VALUE,
    SIGNAL, VFUNC, PROPERTY,
    FIELD, ARG, TYPE,
    UNRESOLVED

type
  GITransfer* {.size: sizeof(cint), pure.} = enum
    NOTHING, CONTAINER, EVERYTHING

type
  GIDirection* {.size: sizeof(cint), pure.} = enum
    `IN`, `OUT`, INOUT

type
  GIScopeType* {.size: sizeof(cint), pure.} = enum
    INVALID, CALL, ASYNC,
    NOTIFIED

type
  GITypeTag* {.size: sizeof(cint), pure.} = enum
    VOID = 0, BOOLEAN = 1, INT8 = 2,
    UINT8 = 3, INT16 = 4, UINT16 = 5,
    INT32 = 6, UINT32 = 7, INT64 = 8,
    UINT64 = 9, FLOAT = 10, DOUBLE = 11,
    GTYPE = 12, UTF8 = 13, FILENAME = 14,
    ARRAY = 15, INTERFACE = 16, GLIST = 17,
    GSLIST = 18, GHASH = 19, ERROR = 20,
    UNICHAR = 21

const
  GI_TYPE_TAG_N_TYPES* =  GITypeTag.UNICHAR.ord + 1
  # GI_TYPE_TAG_SHORT* = GITypeTag.Short_Was_Removed
  # GI_TYPE_TAG_INT* = GITypeTag.Int_Was_Removed
  # GI_TYPE_TAG_LONG* = GITypeTag.Long_Was_Removed

type
  GIArrayType* {.size: sizeof(cint), pure.} = enum
    C, ARRAY, PTR_ARRAY,
    BYTE_ARRAY

type
  GIFieldInfoFlags* {.size: sizeof(cint), pure.} = enum
    IS_READABLE = 1 shl 0, IS_WRITABLE = 1 shl 1

type
  GIVFuncInfoFlags* {.size: sizeof(cint), pure.} = enum
    MUST_CHAIN_UP = 1 shl 0, MUST_OVERRIDE = 1 shl 1,
    MUST_NOT_OVERRIDE = 1 shl 2, THROWS = 1 shl 3

type
  GIFunctionInfoFlags* {.size: sizeof(cint), pure.} = enum
    IS_METHOD = 1 shl 0, IS_CONSTRUCTOR = 1 shl 1,
    IS_GETTER = 1 shl 2, IS_SETTER = 1 shl 3,
    WRAPS_VFUNC = 1 shl 4, THROWS = 1 shl 5
  GArgument* =  ptr GArgumentObj
  GArgumentPtr* = ptr GArgumentObj
  GArgumentObj* = GIArgumentObj
  GITypelib* =  ptr GITypelibObj
  GITypelibPtr* = ptr GITypelibObj
  GITypelibObj* = object

template isArgInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Arg)

proc gArgInfoGetDirection*(info: GIArgInfo): GIDirection {.
    importc: "g_arg_info_get_direction", libgir.}
proc gArgInfoIsReturnValue*(info: GIArgInfo): Gboolean {.
    importc: "g_arg_info_is_return_value", libgir.}
proc gArgInfoIsOptional*(info: GIArgInfo): Gboolean {.
    importc: "g_arg_info_is_optional", libgir.}
proc gArgInfoIsCallerAllocates*(info: GIArgInfo): Gboolean {.
    importc: "g_arg_info_is_caller_allocates", libgir.}
proc gArgInfoMayBeNull*(info: GIArgInfo): Gboolean {.
    importc: "g_arg_info_may_be_null", libgir.}
proc gArgInfoIsSkip*(info: GIArgInfo): Gboolean {.importc: "g_arg_info_is_skip",
    libgir.}
proc gArgInfoGetOwnershipTransfer*(info: GIArgInfo): GITransfer {.
    importc: "g_arg_info_get_ownership_transfer", libgir.}
proc gArgInfoGetScope*(info: GIArgInfo): GIScopeType {.
    importc: "g_arg_info_get_scope", libgir.}
proc gArgInfoGetClosure*(info: GIArgInfo): cint {.
    importc: "g_arg_info_get_closure", libgir.}
proc gArgInfoGetDestroy*(info: GIArgInfo): cint {.
    importc: "g_arg_info_get_destroy", libgir.}
proc gArgInfoGetType*(info: GIArgInfo): GITypeInfo {.
    importc: "g_arg_info_get_type", libgir.}
proc gArgInfoLoadType*(info: GIArgInfo; `type`: GITypeInfo) {.
    importc: "g_arg_info_load_type", libgir.}

proc newGTypelib*(memory: var uint8; len: Gsize; error: var glib.GError): GITypelib {.
    importc: "g_typelib_new_from_memory", libgir.}
proc newGTypelib*(memory: ptr uint8; len: Gsize; error: var glib.GError): GITypelib {.
    importc: "g_typelib_new_from_const_memory", libgir.}
proc newGTypelib*(mfile: glib.GMappedFile; error: var glib.GError): GITypelib {.
    importc: "g_typelib_new_from_mapped_file", libgir.}
proc gTypelibFree*(typelib: GITypelib) {.importc: "g_typelib_free", libgir.}
proc gTypelibSymbol*(typelib: GITypelib; symbolName: cstring; symbol: var Gpointer): Gboolean {.
    importc: "g_typelib_symbol", libgir.}
proc gTypelibGetNamespace*(typelib: GITypelib): cstring {.
    importc: "g_typelib_get_namespace", libgir.}

template typeBaseInfo*(): untyped =
  (gBaseInfoGtypeGetType())

proc gBaseInfoGtypeGetType*(): GType {.importc: "g_base_info_gtype_get_type",
                                    libgir.}
proc gBaseInfoRef*(info: GIBaseInfo): GIBaseInfo {.importc: "g_base_info_ref",
    libgir.}
proc gBaseInfoUnref*(info: GIBaseInfo) {.importc: "g_base_info_unref", libgir.}
proc gBaseInfoGetType*(info: GIBaseInfo): GIInfoType {.
    importc: "g_base_info_get_type", libgir.}
proc gBaseInfoGetName*(info: GIBaseInfo): cstring {.
    importc: "g_base_info_get_name", libgir.}
proc gBaseInfoGetNamespace*(info: GIBaseInfo): cstring {.
    importc: "g_base_info_get_namespace", libgir.}
proc gBaseInfoIsDeprecated*(info: GIBaseInfo): Gboolean {.
    importc: "g_base_info_is_deprecated", libgir.}
proc gBaseInfoGetAttribute*(info: GIBaseInfo; name: cstring): cstring {.
    importc: "g_base_info_get_attribute", libgir.}
proc gBaseInfoIterateAttributes*(info: GIBaseInfo;
                                `iterator`: GIAttributeIter;
                                name: cstringArray; value: cstringArray): Gboolean {.
    importc: "g_base_info_iterate_attributes", libgir.}
proc gBaseInfoGetContainer*(info: GIBaseInfo): GIBaseInfo {.
    importc: "g_base_info_get_container", libgir.}
proc gBaseInfoGetTypelib*(info: GIBaseInfo): GITypelib {.
    importc: "g_base_info_get_typelib", libgir.}
proc gBaseInfoEqual*(info1: GIBaseInfo; info2: GIBaseInfo): Gboolean {.
    importc: "g_base_info_equal", libgir.}
proc newGInfo*(`type`: GIInfoType; container: GIBaseInfo; typelib: GITypelib;
              offset: uint32): GIBaseInfo {.importc: "g_info_new", libgir.}

template isCallableInfo*(info: untyped): untyped =
  ((gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Function) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Callback) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Signal) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Vfunc))

proc gCallableInfoIsMethod*(info: GICallableInfo): Gboolean {.
    importc: "g_callable_info_is_method", libgir.}
proc gCallableInfoCanThrowGerror*(info: GICallableInfo): Gboolean {.
    importc: "g_callable_info_can_throw_gerror", libgir.}
proc gCallableInfoGetReturnType*(info: GICallableInfo): GITypeInfo {.
    importc: "g_callable_info_get_return_type", libgir.}
proc gCallableInfoLoadReturnType*(info: GICallableInfo; `type`: GITypeInfo) {.
    importc: "g_callable_info_load_return_type", libgir.}
proc gCallableInfoGetReturnAttribute*(info: GICallableInfo; name: cstring): cstring {.
    importc: "g_callable_info_get_return_attribute", libgir.}
proc gCallableInfoIterateReturnAttributes*(info: GICallableInfo;
    `iterator`: GIAttributeIter; name: cstringArray; value: cstringArray): Gboolean {.
    importc: "g_callable_info_iterate_return_attributes", libgir.}
proc gCallableInfoGetCallerOwns*(info: GICallableInfo): GITransfer {.
    importc: "g_callable_info_get_caller_owns", libgir.}
proc gCallableInfoMayReturnNull*(info: GICallableInfo): Gboolean {.
    importc: "g_callable_info_may_return_null", libgir.}
proc gCallableInfoSkipReturn*(info: GICallableInfo): Gboolean {.
    importc: "g_callable_info_skip_return", libgir.}
proc gCallableInfoGetNArgs*(info: GICallableInfo): cint {.
    importc: "g_callable_info_get_n_args", libgir.}
proc gCallableInfoGetArg*(info: GICallableInfo; n: cint): GIArgInfo {.
    importc: "g_callable_info_get_arg", libgir.}
proc gCallableInfoLoadArg*(info: GICallableInfo; n: cint; arg: GIArgInfo) {.
    importc: "g_callable_info_load_arg", libgir.}
proc gCallableInfoInvoke*(info: GICallableInfo; function: Gpointer;
                         inArgs: GIArgument; nInArgs: cint;
                         outArgs: GIArgument; nOutArgs: cint;
                         returnValue: GIArgument; isMethod: Gboolean;
                         throws: Gboolean; error: var glib.GError): Gboolean {.
    importc: "g_callable_info_invoke", libgir.}
proc gCallableInfoGetInstanceOwnershipTransfer*(info: GICallableInfo): GITransfer {.
    importc: "g_callable_info_get_instance_ownership_transfer", libgir.}

template isConstantInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Constant)

proc gConstantInfoGetType*(info: GIConstantInfo): GITypeInfo {.
    importc: "g_constant_info_get_type", libgir.}
proc gConstantInfoFreeValue*(info: GIConstantInfo; value: GIArgument) {.
    importc: "g_constant_info_free_value", libgir.}
proc gConstantInfoGetValue*(info: GIConstantInfo; value: GIArgument): cint {.
    importc: "g_constant_info_get_value", libgir.}

template isEnumInfo*(info: untyped): untyped =
  ((gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Enum) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Flags))

template isValueInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Value)

proc gEnumInfoGetNValues*(info: GIEnumInfo): cint {.
    importc: "g_enum_info_get_n_values", libgir.}
proc gEnumInfoGetValue*(info: GIEnumInfo; n: cint): GIValueInfo {.
    importc: "g_enum_info_get_value", libgir.}
proc gEnumInfoGetNMethods*(info: GIEnumInfo): cint {.
    importc: "g_enum_info_get_n_methods", libgir.}
proc gEnumInfoGetMethod*(info: GIEnumInfo; n: cint): GIFunctionInfo {.
    importc: "g_enum_info_get_method", libgir.}
proc gEnumInfoGetStorageType*(info: GIEnumInfo): GITypeTag {.
    importc: "g_enum_info_get_storage_type", libgir.}
proc gEnumInfoGetErrorDomain*(info: GIEnumInfo): cstring {.
    importc: "g_enum_info_get_error_domain", libgir.}
proc gValueInfoGetValue*(info: GIValueInfo): int64 {.
    importc: "g_value_info_get_value", libgir.}

template isFieldInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Field)

proc gFieldInfoGetFlags*(info: GIFieldInfo): GIFieldInfoFlags {.
    importc: "g_field_info_get_flags", libgir.}
proc gFieldInfoGetSize*(info: GIFieldInfo): cint {.
    importc: "g_field_info_get_size", libgir.}
proc gFieldInfoGetOffset*(info: GIFieldInfo): cint {.
    importc: "g_field_info_get_offset", libgir.}
proc gFieldInfoGetType*(info: GIFieldInfo): GITypeInfo {.
    importc: "g_field_info_get_type", libgir.}
proc gFieldInfoGetField*(fieldInfo: GIFieldInfo; mem: Gpointer;
                        value: GIArgument): Gboolean {.
    importc: "g_field_info_get_field", libgir.}
proc gFieldInfoSetField*(fieldInfo: GIFieldInfo; mem: Gpointer;
                        value: GIArgument): Gboolean {.
    importc: "g_field_info_set_field", libgir.}

template isFunctionInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Function)

proc gFunctionInfoGetSymbol*(info: GIFunctionInfo): cstring {.
    importc: "g_function_info_get_symbol", libgir.}
proc gFunctionInfoGetFlags*(info: GIFunctionInfo): GIFunctionInfoFlags {.
    importc: "g_function_info_get_flags", libgir.}
proc gFunctionInfoGetProperty*(info: GIFunctionInfo): GIPropertyInfo {.
    importc: "g_function_info_get_property", libgir.}
proc gFunctionInfoGetVfunc*(info: GIFunctionInfo): GIVFuncInfo {.
    importc: "g_function_info_get_vfunc", libgir.}

template invokeError*(): untyped =
  (gInvokeErrorQuark())

proc gInvokeErrorQuark*(): GQuark {.importc: "g_invoke_error_quark", libgir.}

type
  GInvokeError* {.size: sizeof(cint), pure.} = enum
    FAILED, SYMBOL_NOT_FOUND,
    ARGUMENT_MISMATCH

proc gFunctionInfoInvoke*(info: GIFunctionInfo; inArgs: GIArgument;
                         nInArgs: cint; outArgs: GIArgument; nOutArgs: cint;
                         returnValue: GIArgument; error: var glib.GError): Gboolean {.
    importc: "g_function_info_invoke", libgir.}

template isInterfaceInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Interface)

proc gInterfaceInfoGetNPrerequisites*(info: GIInterfaceInfo): cint {.
    importc: "g_interface_info_get_n_prerequisites", libgir.}
proc gInterfaceInfoGetPrerequisite*(info: GIInterfaceInfo; n: cint): GIBaseInfo {.
    importc: "g_interface_info_get_prerequisite", libgir.}
proc gInterfaceInfoGetNProperties*(info: GIInterfaceInfo): cint {.
    importc: "g_interface_info_get_n_properties", libgir.}
proc gInterfaceInfoGetProperty*(info: GIInterfaceInfo; n: cint): GIPropertyInfo {.
    importc: "g_interface_info_get_property", libgir.}
proc gInterfaceInfoGetNMethods*(info: GIInterfaceInfo): cint {.
    importc: "g_interface_info_get_n_methods", libgir.}
proc gInterfaceInfoGetMethod*(info: GIInterfaceInfo; n: cint): GIFunctionInfo {.
    importc: "g_interface_info_get_method", libgir.}
proc gInterfaceInfoFindMethod*(info: GIInterfaceInfo; name: cstring): GIFunctionInfo {.
    importc: "g_interface_info_find_method", libgir.}
proc gInterfaceInfoGetNSignals*(info: GIInterfaceInfo): cint {.
    importc: "g_interface_info_get_n_signals", libgir.}
proc gInterfaceInfoGetSignal*(info: GIInterfaceInfo; n: cint): GISignalInfo {.
    importc: "g_interface_info_get_signal", libgir.}
proc gInterfaceInfoFindSignal*(info: GIInterfaceInfo; name: cstring): GISignalInfo {.
    importc: "g_interface_info_find_signal", libgir.}
proc gInterfaceInfoGetNVfuncs*(info: GIInterfaceInfo): cint {.
    importc: "g_interface_info_get_n_vfuncs", libgir.}
proc gInterfaceInfoGetVfunc*(info: GIInterfaceInfo; n: cint): GIVFuncInfo {.
    importc: "g_interface_info_get_vfunc", libgir.}
proc gInterfaceInfoFindVfunc*(info: GIInterfaceInfo; name: cstring): GIVFuncInfo {.
    importc: "g_interface_info_find_vfunc", libgir.}
proc gInterfaceInfoGetNConstants*(info: GIInterfaceInfo): cint {.
    importc: "g_interface_info_get_n_constants", libgir.}
proc gInterfaceInfoGetConstant*(info: GIInterfaceInfo; n: cint): GIConstantInfo {.
    importc: "g_interface_info_get_constant", libgir.}
proc gInterfaceInfoGetIfaceStruct*(info: GIInterfaceInfo): GIStructInfo {.
    importc: "g_interface_info_get_iface_struct", libgir.}

type
  GIObjectInfoRefFunction* = proc (`object`: pointer): pointer {.cdecl.}

type
  GIObjectInfoUnrefFunction* = proc (`object`: pointer) {.cdecl.}

type
  GIObjectInfoSetValueFunction* = proc (value: gobject.GValue; `object`: pointer) {.cdecl.}

type
  GIObjectInfoGetValueFunction* = proc (value: gobject.GValue): pointer {.cdecl.}

template isObjectInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Object)

proc gObjectInfoGetTypeName*(info: GIObjectInfo): cstring {.
    importc: "g_object_info_get_type_name", libgir.}
proc gObjectInfoGetTypeInit*(info: GIObjectInfo): cstring {.
    importc: "g_object_info_get_type_init", libgir.}
proc gObjectInfoGetAbstract*(info: GIObjectInfo): Gboolean {.
    importc: "g_object_info_get_abstract", libgir.}
proc gObjectInfoGetFundamental*(info: GIObjectInfo): Gboolean {.
    importc: "g_object_info_get_fundamental", libgir.}
proc gObjectInfoGetParent*(info: GIObjectInfo): GIObjectInfo {.
    importc: "g_object_info_get_parent", libgir.}
proc gObjectInfoGetNInterfaces*(info: GIObjectInfo): cint {.
    importc: "g_object_info_get_n_interfaces", libgir.}
proc gObjectInfoGetInterface*(info: GIObjectInfo; n: cint): GIInterfaceInfo {.
    importc: "g_object_info_get_interface", libgir.}
proc gObjectInfoGetNFields*(info: GIObjectInfo): cint {.
    importc: "g_object_info_get_n_fields", libgir.}
proc gObjectInfoGetField*(info: GIObjectInfo; n: cint): GIFieldInfo {.
    importc: "g_object_info_get_field", libgir.}
proc gObjectInfoGetNProperties*(info: GIObjectInfo): cint {.
    importc: "g_object_info_get_n_properties", libgir.}
proc gObjectInfoGetProperty*(info: GIObjectInfo; n: cint): GIPropertyInfo {.
    importc: "g_object_info_get_property", libgir.}
proc gObjectInfoGetNMethods*(info: GIObjectInfo): cint {.
    importc: "g_object_info_get_n_methods", libgir.}
proc gObjectInfoGetMethod*(info: GIObjectInfo; n: cint): GIFunctionInfo {.
    importc: "g_object_info_get_method", libgir.}
proc gObjectInfoFindMethod*(info: GIObjectInfo; name: cstring): GIFunctionInfo {.
    importc: "g_object_info_find_method", libgir.}
proc gObjectInfoFindMethodUsingInterfaces*(info: GIObjectInfo; name: cstring;
    implementor: var GIObjectInfo): GIFunctionInfo {.
    importc: "g_object_info_find_method_using_interfaces", libgir.}
proc gObjectInfoGetNSignals*(info: GIObjectInfo): cint {.
    importc: "g_object_info_get_n_signals", libgir.}
proc gObjectInfoGetSignal*(info: GIObjectInfo; n: cint): GISignalInfo {.
    importc: "g_object_info_get_signal", libgir.}
proc gObjectInfoFindSignal*(info: GIObjectInfo; name: cstring): GISignalInfo {.
    importc: "g_object_info_find_signal", libgir.}
proc gObjectInfoGetNVfuncs*(info: GIObjectInfo): cint {.
    importc: "g_object_info_get_n_vfuncs", libgir.}
proc gObjectInfoGetVfunc*(info: GIObjectInfo; n: cint): GIVFuncInfo {.
    importc: "g_object_info_get_vfunc", libgir.}
proc gObjectInfoFindVfunc*(info: GIObjectInfo; name: cstring): GIVFuncInfo {.
    importc: "g_object_info_find_vfunc", libgir.}
proc gObjectInfoFindVfuncUsingInterfaces*(info: GIObjectInfo; name: cstring;
    implementor: var GIObjectInfo): GIVFuncInfo {.
    importc: "g_object_info_find_vfunc_using_interfaces", libgir.}
proc gObjectInfoGetNConstants*(info: GIObjectInfo): cint {.
    importc: "g_object_info_get_n_constants", libgir.}
proc gObjectInfoGetConstant*(info: GIObjectInfo; n: cint): GIConstantInfo {.
    importc: "g_object_info_get_constant", libgir.}
proc gObjectInfoGetClassStruct*(info: GIObjectInfo): GIStructInfo {.
    importc: "g_object_info_get_class_struct", libgir.}
proc gObjectInfoGetRefFunction*(info: GIObjectInfo): cstring {.
    importc: "g_object_info_get_ref_function", libgir.}
proc gObjectInfoGetRefFunctionPointer*(info: GIObjectInfo): GIObjectInfoRefFunction {.
    importc: "g_object_info_get_ref_function_pointer", libgir.}
proc gObjectInfoGetUnrefFunction*(info: GIObjectInfo): cstring {.
    importc: "g_object_info_get_unref_function", libgir.}
proc gObjectInfoGetUnrefFunctionPointer*(info: GIObjectInfo): GIObjectInfoUnrefFunction {.
    importc: "g_object_info_get_unref_function_pointer", libgir.}
proc gObjectInfoGetSetValueFunction*(info: GIObjectInfo): cstring {.
    importc: "g_object_info_get_set_value_function", libgir.}
proc gObjectInfoGetSetValueFunctionPointer*(info: GIObjectInfo): GIObjectInfoSetValueFunction {.
    importc: "g_object_info_get_set_value_function_pointer", libgir.}
proc gObjectInfoGetGetValueFunction*(info: GIObjectInfo): cstring {.
    importc: "g_object_info_get_get_value_function", libgir.}
proc gObjectInfoGetGetValueFunctionPointer*(info: GIObjectInfo): GIObjectInfoGetValueFunction {.
    importc: "g_object_info_get_get_value_function_pointer", libgir.}

template isPropertyInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Property)

proc gPropertyInfoGetFlags*(info: GIPropertyInfo): GParamFlags {.
    importc: "g_property_info_get_flags", libgir.}
proc gPropertyInfoGetType*(info: GIPropertyInfo): GITypeInfo {.
    importc: "g_property_info_get_type", libgir.}
proc gPropertyInfoGetOwnershipTransfer*(info: GIPropertyInfo): GITransfer {.
    importc: "g_property_info_get_ownership_transfer", libgir.}

template isRegisteredTypeInfo*(info: untyped): untyped =
  ((gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Boxed) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Enum) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Flags) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Interface) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Object) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Struct) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Union) or
      (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Boxed))

proc gRegisteredTypeInfoGetTypeName*(info: GIRegisteredTypeInfo): cstring {.
    importc: "g_registered_type_info_get_type_name", libgir.}
proc gRegisteredTypeInfoGetTypeInit*(info: GIRegisteredTypeInfo): cstring {.
    importc: "g_registered_type_info_get_type_init", libgir.}
proc gRegisteredTypeInfoGetGType*(info: GIRegisteredTypeInfo): GType {.
    importc: "g_registered_type_info_get_g_type", libgir.}

template isSignalInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Signal)

proc gSignalInfoGetFlags*(info: GISignalInfo): GSignalFlags {.
    importc: "g_signal_info_get_flags", libgir.}
proc gSignalInfoGetClassClosure*(info: GISignalInfo): GIVFuncInfo {.
    importc: "g_signal_info_get_class_closure", libgir.}
proc gSignalInfoTrueStopsEmit*(info: GISignalInfo): Gboolean {.
    importc: "g_signal_info_true_stops_emit", libgir.}

template isStructInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Struct)

proc gStructInfoGetNFields*(info: GIStructInfo): cint {.
    importc: "g_struct_info_get_n_fields", libgir.}
proc gStructInfoGetField*(info: GIStructInfo; n: cint): GIFieldInfo {.
    importc: "g_struct_info_get_field", libgir.}
proc gStructInfoFindField*(info: GIStructInfo; name: cstring): GIFieldInfo {.
    importc: "g_struct_info_find_field", libgir.}
proc gStructInfoGetNMethods*(info: GIStructInfo): cint {.
    importc: "g_struct_info_get_n_methods", libgir.}
proc gStructInfoGetMethod*(info: GIStructInfo; n: cint): GIFunctionInfo {.
    importc: "g_struct_info_get_method", libgir.}
proc gStructInfoFindMethod*(info: GIStructInfo; name: cstring): GIFunctionInfo {.
    importc: "g_struct_info_find_method", libgir.}
proc gStructInfoGetSize*(info: GIStructInfo): Gsize {.
    importc: "g_struct_info_get_size", libgir.}
proc gStructInfoGetAlignment*(info: GIStructInfo): Gsize {.
    importc: "g_struct_info_get_alignment", libgir.}
proc gStructInfoIsGtypeStruct*(info: GIStructInfo): Gboolean {.
    importc: "g_struct_info_is_gtype_struct", libgir.}
proc gStructInfoIsForeign*(info: GIStructInfo): Gboolean {.
    importc: "g_struct_info_is_foreign", libgir.}

template isTypeInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Type)

template typeTagIsBasic*(tag: untyped): untyped =
  (tag < GITypeTag.Array or tag == GITypeTag.Unichar)

proc gTypeTagToString*(`type`: GITypeTag): cstring {.
    importc: "g_type_tag_to_string", libgir.}
proc gInfoTypeToString*(`type`: GIInfoType): cstring {.
    importc: "g_info_type_to_string", libgir.}
proc gTypeInfoIsPointer*(info: GITypeInfo): Gboolean {.
    importc: "g_type_info_is_pointer", libgir.}
proc gTypeInfoGetTag*(info: GITypeInfo): GITypeTag {.
    importc: "g_type_info_get_tag", libgir.}
proc gTypeInfoGetParamType*(info: GITypeInfo; n: cint): GITypeInfo {.
    importc: "g_type_info_get_param_type", libgir.}
proc gTypeInfoGetInterface*(info: GITypeInfo): GIBaseInfo {.
    importc: "g_type_info_get_interface", libgir.}
proc gTypeInfoGetArrayLength*(info: GITypeInfo): cint {.
    importc: "g_type_info_get_array_length", libgir.}
proc gTypeInfoGetArrayFixedSize*(info: GITypeInfo): cint {.
    importc: "g_type_info_get_array_fixed_size", libgir.}
proc gTypeInfoIsZeroTerminated*(info: GITypeInfo): Gboolean {.
    importc: "g_type_info_is_zero_terminated", libgir.}
proc gTypeInfoGetArrayType*(info: GITypeInfo): GIArrayType {.
    importc: "g_type_info_get_array_type", libgir.}

template isUnionInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Union)

proc gUnionInfoGetNFields*(info: GIUnionInfo): cint {.
    importc: "g_union_info_get_n_fields", libgir.}
proc gUnionInfoGetField*(info: GIUnionInfo; n: cint): GIFieldInfo {.
    importc: "g_union_info_get_field", libgir.}
proc gUnionInfoGetNMethods*(info: GIUnionInfo): cint {.
    importc: "g_union_info_get_n_methods", libgir.}
proc gUnionInfoGetMethod*(info: GIUnionInfo; n: cint): GIFunctionInfo {.
    importc: "g_union_info_get_method", libgir.}
proc gUnionInfoIsDiscriminated*(info: GIUnionInfo): Gboolean {.
    importc: "g_union_info_is_discriminated", libgir.}
proc gUnionInfoGetDiscriminatorOffset*(info: GIUnionInfo): cint {.
    importc: "g_union_info_get_discriminator_offset", libgir.}
proc gUnionInfoGetDiscriminatorType*(info: GIUnionInfo): GITypeInfo {.
    importc: "g_union_info_get_discriminator_type", libgir.}
proc gUnionInfoGetDiscriminator*(info: GIUnionInfo; n: cint): GIConstantInfo {.
    importc: "g_union_info_get_discriminator", libgir.}
proc gUnionInfoFindMethod*(info: GIUnionInfo; name: cstring): GIFunctionInfo {.
    importc: "g_union_info_find_method", libgir.}
proc gUnionInfoGetSize*(info: GIUnionInfo): Gsize {.
    importc: "g_union_info_get_size", libgir.}
proc gUnionInfoGetAlignment*(info: GIUnionInfo): Gsize {.
    importc: "g_union_info_get_alignment", libgir.}

template isVfuncInfo*(info: untyped): untyped =
  (gBaseInfoGetType(cast[GIBaseInfo](info)) == GIInfoType.Vfunc)

proc gVfuncInfoGetFlags*(info: GIVFuncInfo): GIVFuncInfoFlags {.
    importc: "g_vfunc_info_get_flags", libgir.}
proc gVfuncInfoGetOffset*(info: GIVFuncInfo): cint {.
    importc: "g_vfunc_info_get_offset", libgir.}
proc gVfuncInfoGetSignal*(info: GIVFuncInfo): GISignalInfo {.
    importc: "g_vfunc_info_get_signal", libgir.}
proc gVfuncInfoGetInvoker*(info: GIVFuncInfo): GIFunctionInfo {.
    importc: "g_vfunc_info_get_invoker", libgir.}
proc gVfuncInfoGetAddress*(info: GIVFuncInfo; implementorGtype: GType;
                          error: var glib.GError): Gpointer {.
    importc: "g_vfunc_info_get_address", libgir.}
proc gVfuncInfoInvoke*(info: GIVFuncInfo; implementor: GType;
                      inArgs: GIArgument; nInArgs: cint; outArgs: GIArgument;
                      nOutArgs: cint; returnValue: GIArgument;
                      error: var glib.GError): Gboolean {.
    importc: "g_vfunc_info_invoke", libgir.}

template typeIrepository*(): untyped =
  (gIrepositoryGetType())

template irepository*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, typeIrepository, gIRepository))

template irepositoryClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeIrepository, gIRepositoryClass))

template isIrepository*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, typeIrepository))

template isIrepositoryClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeIrepository))

template irepositoryGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeIrepository, gIRepositoryClass))

type
  GIRepository* =  ptr GIRepositoryObj
  GIRepositoryPtr* = ptr GIRepositoryObj
  GIRepositoryObj*{.final.} = object of GObjectObj
    priv: pointer

  GIRepositoryClass* =  ptr GIRepositoryClassObj
  GIRepositoryClassPtr* = ptr GIRepositoryClassObj
  GIRepositoryClassObj*{.final.} = object of GObjectClassObj

type
  GIRepositoryLoadFlags* {.size: sizeof(cint), pure.} = enum
    LAZY = 1 shl 0

proc gIrepositoryGetType*(): GType {.importc: "g_irepository_get_type", libgir.}
proc gIrepositoryGetDefault*(): GIRepository {.
    importc: "g_irepository_get_default", libgir.}
proc gIrepositoryPrependSearchPath*(directory: cstring) {.
    importc: "g_irepository_prepend_search_path", libgir.}
proc gIrepositoryPrependLibraryPath*(directory: cstring) {.
    importc: "g_irepository_prepend_library_path", libgir.}
proc gIrepositoryGetSearchPath*(): glib.GSList {.
    importc: "g_irepository_get_search_path", libgir.}
proc gIrepositoryLoadTypelib*(repository: GIRepository; typelib: GITypelib;
                             flags: GIRepositoryLoadFlags; error: var glib.GError): cstring {.
    importc: "g_irepository_load_typelib", libgir.}
proc gIrepositoryIsRegistered*(repository: GIRepository; namespace: cstring;
                              version: cstring): Gboolean {.
    importc: "g_irepository_is_registered", libgir.}
proc gIrepositoryFindByName*(repository: GIRepository; namespace: cstring;
                            name: cstring): GIBaseInfo {.
    importc: "g_irepository_find_by_name", libgir.}
proc gIrepositoryEnumerateVersions*(repository: GIRepository; namespace: cstring): glib.GList {.
    importc: "g_irepository_enumerate_versions", libgir.}
proc gIrepositoryRequire*(repository: GIRepository; namespace: cstring;
                         version: cstring; flags: GIRepositoryLoadFlags;
                         error: var glib.GError): GITypelib {.
    importc: "g_irepository_require", libgir.}
proc gIrepositoryRequirePrivate*(repository: GIRepository; typelibDir: cstring;
                                namespace: cstring; version: cstring;
                                flags: GIRepositoryLoadFlags;
                                error: var glib.GError): GITypelib {.
    importc: "g_irepository_require_private", libgir.}
proc gIrepositoryGetImmediateDependencies*(repository: GIRepository;
    namespace: cstring): cstringArray {.importc: "g_irepository_get_immediate_dependencies",
                                     libgir.}
proc gIrepositoryGetDependencies*(repository: GIRepository; namespace: cstring): cstringArray {.
    importc: "g_irepository_get_dependencies", libgir.}
proc gIrepositoryGetLoadedNamespaces*(repository: GIRepository): cstringArray {.
    importc: "g_irepository_get_loaded_namespaces", libgir.}
proc gIrepositoryFindByGtype*(repository: GIRepository; gtype: GType): GIBaseInfo {.
    importc: "g_irepository_find_by_gtype", libgir.}
proc gIrepositoryGetNInfos*(repository: GIRepository; namespace: cstring): cint {.
    importc: "g_irepository_get_n_infos", libgir.}
proc gIrepositoryGetInfo*(repository: GIRepository; namespace: cstring;
                         index: cint): GIBaseInfo {.
    importc: "g_irepository_get_info", libgir.}
proc gIrepositoryFindByErrorDomain*(repository: GIRepository; domain: GQuark): GIEnumInfo {.
    importc: "g_irepository_find_by_error_domain", libgir.}
proc gIrepositoryGetTypelibPath*(repository: GIRepository; namespace: cstring): cstring {.
    importc: "g_irepository_get_typelib_path", libgir.}
proc gIrepositoryGetSharedLibrary*(repository: GIRepository; namespace: cstring): cstring {.
    importc: "g_irepository_get_shared_library", libgir.}
proc gIrepositoryGetCPrefix*(repository: GIRepository; namespace: cstring): cstring {.
    importc: "g_irepository_get_c_prefix", libgir.}
proc gIrepositoryGetVersion*(repository: GIRepository; namespace: cstring): cstring {.
    importc: "g_irepository_get_version", libgir.}
proc gIrepositoryGetOptionGroup*(): glib.GOptionGroup {.
    importc: "g_irepository_get_option_group", libgir.}
proc gIrepositoryDump*(arg: cstring; error: var glib.GError): Gboolean {.
    importc: "g_irepository_dump", libgir.}

type
  GIRepositoryError* {.size: sizeof(cint), pure.} = enum
    TYPELIB_NOT_FOUND,
    NAMESPACE_MISMATCH,
    NAMESPACE_VERSION_CONFLICT,
    LIBRARY_NOT_FOUND

template irepositoryError*(): untyped =
  (gIrepositoryErrorQuark())

proc gIrepositoryErrorQuark*(): GQuark {.importc: "g_irepository_error_quark",
                                      libgir.}

proc giCclosureMarshalGeneric*(closure: gobject.GClosure; returnGvalue: gobject.GValue;
                              nParamValues: cuint; paramValues: gobject.GValue;
                              invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "gi_cclosure_marshal_generic", libgir.}

