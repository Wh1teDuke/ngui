{.deadCodeElim: on.}

from glib import Gboolean, Gpointer, Gconstpointer, Gunichar, Gsize, GList, GSList, GQuark, GData, GSource, GVariant,
  GVariantType, GCompareFunc, GDuplicateFunc, GCompareDataFunc, GDestroyNotify, clearPointer,
  GLIB_SIZEOF_SIZE_T, GLIB_SIZEOF_LONG

import macros, strutils

const
  CPLUSPLUS = false
  G_DISABLE_CAST_CHECKS = false

# Note: Not all gobject C macros are available in Nim yet.
# Some are converted by c2nim to templates, some manually to procs.
# Most of these should be not necessary for Nim programmers.
# We may have to add more and to test and fix some, or remove unnecessary ones completely...

when defined(windows):
  const LIB_GOBJ* = "libgobject-2.0-0.dll"
elif defined(macosx):
  const LIB_GOBJ* = "libgobject-2.0.dylib"
else:
  const LIB_GOBJ* = "libgobject-2.0.so(|.0)"

{.pragma: libgobj, cdecl, dynlib: LIB_GOBJ.}

template gTypeFundamental*(`type`: untyped): untyped =
  (fundamental(`type`))

const
  G_TYPE_FUNDAMENTAL_SHIFT* = 2
const
  G_TYPE_FUNDAMENTAL_MAX* = (255 shl G_TYPE_FUNDAMENTAL_SHIFT)
when GLIB_SIZEOF_SIZE_T != GLIB_SIZEOF_LONG or not (CPLUSPLUS):
  type
    GType* = Gsize
else:
  type
    GType* = culong
template gTypeMakeFundamental*(x: untyped): untyped =
  (GType(x shl G_TYPE_FUNDAMENTAL_SHIFT))

const
  G_TYPE_INVALID* = gTypeMakeFundamental(0)

const
  G_TYPE_NONE* = gTypeMakeFundamental(1)

const
  G_TYPE_INTERF* = gTypeMakeFundamental(2)

const
  G_TYPE_CHAR* = gTypeMakeFundamental(3)

const
  G_TYPE_UCHAR* = gTypeMakeFundamental(4)

const
  G_TYPE_BOOLEAN* = gTypeMakeFundamental(5)

const
  G_TYPE_INT* = gTypeMakeFundamental(6)

const
  G_TYPE_UINT* = gTypeMakeFundamental(7)

const
  G_TYPE_LONG* = gTypeMakeFundamental(8)

const
  G_TYPE_ULONG* = gTypeMakeFundamental(9)

const
  G_TYPE_INT64* = gTypeMakeFundamental(10)

const
  G_TYPE_UINT64* = gTypeMakeFundamental(11)

const
  G_TYPE_ENUM* = gTypeMakeFundamental(12)

const
  G_TYPE_FLAG* = gTypeMakeFundamental(13)

const
  G_TYPE_FLOAT* = gTypeMakeFundamental(14)

const
  G_TYPE_DOUBLE* = gTypeMakeFundamental(15)

const
  G_TYPE_STRING* = gTypeMakeFundamental(16)

const
  G_TYPE_POINTER* = gTypeMakeFundamental(17)

const
  G_TYPE_BOXED* = gTypeMakeFundamental(18)

const
  G_TYPE_PARAM* = gTypeMakeFundamental(19)

const
  G_TYPE_OBJECT* = gTypeMakeFundamental(20)

const
  G_TYPE_VARIANT* = gTypeMakeFundamental(21)

const
  G_TYPE_RESERVED_GLIB_FIRST* = 22

const
  G_TYPE_RESERVED_GLIB_LAST* = 31

const
  G_TYPE_RESERVED_BSE_FIRST* = 32

const
  G_TYPE_RESERVED_BSE_LAST* = 48

const
  G_TYPE_RESERVED_USER_FIRST* = 49

template gTypeIsFundamental*(`type`: untyped): untyped =
  (`type` <= G_TYPE_FUNDAMENTAL_MAX)

template gTypeIsDerived*(`type`: untyped): untyped =
  (`type` > G_TYPE_FUNDAMENTAL_MAX)

template gTypeIsInterface*(`type`: untyped): untyped =
  (gTypeFundamental(`type`) == G_TYPE_INTERF)

template gTypeIsClassed*(`type`: untyped): untyped =
  (testFlags(`type`, GTypeFundamentalFlags.CLASSED))

template gTypeIsInstantiatable*(`type`: untyped): untyped =
  (testFlags(`type`, GTypeFundamentalFlags.INSTANTIATABLE))

template gTypeIsDerivable*(`type`: untyped): untyped =
  (testFlags(`type`, GTypeFundamentalFlags.DERIVABLE))

template gTypeIsDeepDerivable*(`type`: untyped): untyped =
  (testFlags(`type`, GTypeFundamentalFlags.DEEP_DERIVABLE))

template gTypeIsAbstract*(`type`: untyped): untyped =
  (testFlags(`type`, GTypeFlags.ABSTRACT))

template gTypeIsValueAbstract*(`type`: untyped): untyped =
  (testFlags(`type`, GTypeFlags.VALUE_ABSTRACT))

template gTypeIsValueType*(`type`: untyped): untyped =
  (checkIsValueType(`type`))

template gTypeHasValueTable*(`type`: untyped): untyped =
  (valueTablePeek(`type`) != nil)

type
  GTypeCValue* =  ptr GTypeCValueObj
  GTypeCValuePtr* = ptr GTypeCValueObj
  GTypeCValueObj* {.union.} = object
 
  GTypePlugin* =  ptr GTypePluginObj
  GTypePluginPtr* = ptr GTypePluginObj
  GTypePluginObj* = object
 

type
  GTypeClass* =  ptr GTypeClassObj
  GTypeClassPtr* = ptr GTypeClassObj
  GTypeClassObj*{.inheritable, pure.} = object
    gType*: GType

type
  GTypeInstance* =  ptr GTypeInstanceObj
  GTypeInstancePtr* = ptr GTypeInstanceObj
  GTypeInstanceObj*{.inheritable, pure.} = object
    gClass*: GTypeClass

type
  GTypeInterface* =  ptr GTypeInterfaceObj
  GTypeInterfacePtr* = ptr GTypeInterfaceObj
  GTypeInterfaceObj*{.inheritable, pure.} = object
    gType*: GType
    gInstanceType*: GType

type
  GTypeQuery* =  ptr GTypeQueryObj
  GTypeQueryPtr* = ptr GTypeQueryObj
  GTypeQueryObj* = object
    `type`*: GType
    typeName*: cstring
    classSize*: cuint
    instanceSize*: cuint

type
  GTypeDebugFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, OBJECTS = 1 shl 0,
    SIGNALS = 1 shl 1, INSTANCE_COUNT = 1 shl 2,
    MASK = 0x7

proc typeInit*() {.importc: "g_type_init", libgobj.}
proc typeInitWithDebugFlags*(debugFlags: GTypeDebugFlags) {.
    importc: "g_type_init_with_debug_flags", libgobj.}
proc name*(`type`: GType): cstring {.importc: "g_type_name", libgobj.}
proc qname*(`type`: GType): GQuark {.importc: "g_type_qname", libgobj.}
proc typeFromName*(name: cstring): GType {.importc: "g_type_from_name", libgobj.}
proc parent*(`type`: GType): GType {.importc: "g_type_parent", libgobj.}
proc depth*(`type`: GType): cuint {.importc: "g_type_depth", libgobj.}
proc nextBase*(leafType: GType; rootType: GType): GType {.
    importc: "g_type_next_base", libgobj.}
proc isA*(`type`: GType; isAType: GType): Gboolean {.importc: "g_type_is_a",
    libgobj.}
proc classRef*(`type`: GType): Gpointer {.importc: "g_type_class_ref",
    libgobj.}
proc classPeek*(`type`: GType): Gpointer {.importc: "g_type_class_peek",
    libgobj.}
proc classPeekStatic*(`type`: GType): Gpointer {.
    importc: "g_type_class_peek_static", libgobj.}
proc typeClassUnref*(gClass: Gpointer) {.importc: "g_type_class_unref", libgobj.}
proc typeClassPeekParent*(gClass: Gpointer): Gpointer {.
    importc: "g_type_class_peek_parent", libgobj.}
proc typeInterfacePeek*(instanceClass: Gpointer; ifaceType: GType): Gpointer {.
    importc: "g_type_interface_peek", libgobj.}
proc typeInterfacePeekParent*(gIface: Gpointer): Gpointer {.
    importc: "g_type_interface_peek_parent", libgobj.}
proc defaultInterfaceRef*(gType: GType): Gpointer {.
    importc: "g_type_default_interface_ref", libgobj.}
proc defaultInterfacePeek*(gType: GType): Gpointer {.
    importc: "g_type_default_interface_peek", libgobj.}
proc typeDefaultInterfaceUnref*(gIface: Gpointer) {.
    importc: "g_type_default_interface_unref", libgobj.}

proc children*(`type`: GType; nChildren: var cuint): ptr GType {.
    importc: "g_type_children", libgobj.}
proc interfaces*(`type`: GType; nInterfaces: var cuint): ptr GType {.
    importc: "g_type_interfaces", libgobj.}

proc setQdata*(`type`: GType; quark: GQuark; data: Gpointer) {.
    importc: "g_type_set_qdata", libgobj.}

proc `qdata=`*(`type`: GType; quark: GQuark; data: Gpointer) {.
    importc: "g_type_set_qdata", libgobj.}
proc getQdata*(`type`: GType; quark: GQuark): Gpointer {.
    importc: "g_type_get_qdata", libgobj.}
proc qdata*(`type`: GType; quark: GQuark): Gpointer {.
    importc: "g_type_get_qdata", libgobj.}
proc query*(`type`: GType; query: GTypeQuery) {.importc: "g_type_query",
    libgobj.}
proc getInstanceCount*(`type`: GType): cint {.
    importc: "g_type_get_instance_count", libgobj.}
proc instanceCount*(`type`: GType): cint {.
    importc: "g_type_get_instance_count", libgobj.}

type
  GBaseInitFunc* = proc (gClass: Gpointer) {.cdecl.}

type
  GBaseFinalizeFunc* = proc (gClass: Gpointer) {.cdecl.}

type
  GClassInitFunc* = proc (gClass: Gpointer; classData: Gpointer) {.cdecl.}

type
  GClassFinalizeFunc* = proc (gClass: Gpointer; classData: Gpointer) {.cdecl.}

type
  GInstanceInitFunc* = proc (instance: GTypeInstance; gClass: Gpointer) {.cdecl.}

type
  GInterfaceInitFunc* = proc (gIface: Gpointer; ifaceData: Gpointer) {.cdecl.}

type
  GInterfaceFinalizeFunc* = proc (gIface: Gpointer; ifaceData: Gpointer) {.cdecl.}

type
  GTypeClassCacheFunc* = proc (cacheData: Gpointer; gClass: GTypeClass): Gboolean {.cdecl.}

type
  GTypeInterfaceCheckFunc* = proc (checkData: Gpointer; gIface: Gpointer) {.cdecl.}

type
  GTypeFundamentalFlags* {.size: sizeof(cint), pure.} = enum
    CLASSED = 1 shl 0, INSTANTIATABLE = 1 shl 1,
    DERIVABLE = 1 shl 2, DEEP_DERIVABLE = 1 shl 3

type
  GTypeFlags* {.size: sizeof(cint), pure.} = enum
    ABSTRACT = 1 shl 4, VALUE_ABSTRACT = 1 shl 5

type
  INNER_C_UNION_81819396* {.union.} = object
    vInt*: cint
    vUint*: cuint
    vLong*: clong
    vUlong*: culong
    vInt64*: int64
    vUint64*: uint64
    vFloat*: cfloat
    vDouble*: cdouble
    vPointer*: Gpointer

  GValue* =  ptr GValueObj
  GValuePtr* = ptr GValueObj
  GValueObj* = object
    gType*: GType
    data*: array[2, INNER_C_UNION_81819396]
type
  GTypeInfo* =  ptr GTypeInfoObj
  GTypeInfoPtr* = ptr GTypeInfoObj
  GTypeInfoObj* = object
    classSize*: uint16
    baseInit*: GBaseInitFunc
    baseFinalize*: GBaseFinalizeFunc
    classInit*: GClassInitFunc
    classFinalize*: GClassFinalizeFunc
    classData*: Gconstpointer
    instanceSize*: uint16
    nPreallocs*: uint16
    instanceInit*: GInstanceInitFunc
    valueTable*: GTypeValueTable

  GTypeFundamentalInfo* =  ptr GTypeFundamentalInfoObj
  GTypeFundamentalInfoPtr* = ptr GTypeFundamentalInfoObj
  GTypeFundamentalInfoObj* = object
    typeFlags*: GTypeFundamentalFlags

  GInterfaceInfo* =  ptr GInterfaceInfoObj
  GInterfaceInfoPtr* = ptr GInterfaceInfoObj
  GInterfaceInfoObj* = object
    interfaceInit*: GInterfaceInitFunc
    interfaceFinalize*: GInterfaceFinalizeFunc
    interfaceData*: Gpointer

  GTypeValueTable* =  ptr GTypeValueTableObj
  GTypeValueTablePtr* = ptr GTypeValueTableObj
  GTypeValueTableObj* = object
    valueInit*: proc (value: GValue) {.cdecl.}
    valueFree*: proc (value: GValue) {.cdecl.}
    valueCopy*: proc (srcValue: GValue; destValue: GValue) {.cdecl.}
    valuePeekPointer*: proc (value: GValue): Gpointer {.cdecl.}
    collectFormat*: cstring
    collectValue*: proc (value: GValue; nCollectValues: cuint;
                       collectValues: GTypeCValue; collectFlags: cuint): cstring {.cdecl.}
    lcopyFormat*: cstring
    lcopyValue*: proc (value: GValue; nCollectValues: cuint;
                     collectValues: GTypeCValue; collectFlags: cuint): cstring {.cdecl.}

proc registerStatic*(parentType: GType; typeName: cstring; info: GTypeInfo;
                         flags: GTypeFlags): GType {.
    importc: "g_type_register_static", libgobj.}
proc registerStaticSimple*(parentType: GType; typeName: cstring;
                               classSize: cuint; classInit: GClassInitFunc;
                               instanceSize: cuint;
                               instanceInit: GInstanceInitFunc; flags: GTypeFlags): GType {.
    importc: "g_type_register_static_simple", libgobj.}
proc registerDynamic*(parentType: GType; typeName: cstring;
                          plugin: GTypePlugin; flags: GTypeFlags): GType {.
    importc: "g_type_register_dynamic", libgobj.}
proc registerFundamental*(typeId: GType; typeName: cstring; info: GTypeInfo;
                              finfo: GTypeFundamentalInfo; flags: GTypeFlags): GType {.
    importc: "g_type_register_fundamental", libgobj.}
proc addInterfaceStatic*(instanceType: GType; interfaceType: GType;
                             info: GInterfaceInfo) {.
    importc: "g_type_add_interface_static", libgobj.}
proc addInterfaceDynamic*(instanceType: GType; interfaceType: GType;
                              plugin: GTypePlugin) {.
    importc: "g_type_add_interface_dynamic", libgobj.}
proc interfaceAddPrerequisite*(interfaceType: GType; prerequisiteType: GType) {.
    importc: "g_type_interface_add_prerequisite", libgobj.}
proc interfacePrerequisites*(interfaceType: GType; nPrerequisites: var cuint): ptr GType {.
    importc: "g_type_interface_prerequisites", libgobj.}
proc typeClassAddPrivate*(gClass: Gpointer; privateSize: Gsize) {.
    importc: "g_type_class_add_private", libgobj.}
proc addInstancePrivate*(classType: GType; privateSize: Gsize): cint {.
    importc: "g_type_add_instance_private", libgobj.}
proc getPrivate*(instance: GTypeInstance; privateType: GType): Gpointer {.
    importc: "g_type_instance_get_private", libgobj.}
proc private*(instance: GTypeInstance; privateType: GType): Gpointer {.
    importc: "g_type_instance_get_private", libgobj.}
proc typeClassAdjustPrivateOffset*(gClass: Gpointer; privateSizeOrOffset: var cint) {.
    importc: "g_type_class_adjust_private_offset", libgobj.}
proc addClassPrivate*(classType: GType; privateSize: Gsize) {.
    importc: "g_type_add_class_private", libgobj.}
proc getPrivate*(klass: GTypeClass; privateType: GType): Gpointer {.
    importc: "g_type_class_get_private", libgobj.}
proc private*(klass: GTypeClass; privateType: GType): Gpointer {.
    importc: "g_type_class_get_private", libgobj.}
proc typeClassGetInstancePrivateOffset*(gClass: Gpointer): cint {.
    importc: "g_type_class_get_instance_private_offset", libgobj.}
proc ensure*(`type`: GType) {.importc: "g_type_ensure", libgobj.}
proc typeGetTypeRegistrationSerial*(): cuint {.
    importc: "g_type_get_type_registration_serial", libgobj.}

template gDefineTypeWithPrivate*(tn, tNU, t_P: untyped): untyped =
  gDefineTypeExtended(tn, tNU, t_P, 0, g_Add_Private(tn))

template gDefineAbstractTypeWithPrivate*(tn, tNU, t_P: untyped): untyped =
  gDefineTypeExtended(tn, tNU, t_P, GTypeFlags.ABSTRACT, g_Add_Private(tn))

template gImplementInterface*(type_Iface, ifaceInit: untyped): void =
  var gImplementInterfaceInfo: GInterfaceInfoObj
  gTypeAddInterfaceStatic(gDefineTypeId, type_Iface, addr(gImplementInterfaceInfo))

template gPrivateFieldP*(typeName, inst, fieldName: untyped): untyped =
  gStructMemberP(inst, g_Private_Offset(typeName, fieldName))

template gPrivateField*(typeName, inst, fieldType, fieldName: untyped): untyped =
  gStructMember(fieldType, inst, g_Private_Offset(typeName, fieldName))

proc getPlugin*(`type`: GType): GTypePlugin {.importc: "g_type_get_plugin",
    libgobj.}

proc plugin*(`type`: GType): GTypePlugin {.importc: "g_type_get_plugin",
    libgobj.}
proc interfaceGetPlugin*(instanceType: GType; interfaceType: GType): GTypePlugin {.
    importc: "g_type_interface_get_plugin", libgobj.}
proc typeFundamentalNext*(): GType {.importc: "g_type_fundamental_next", libgobj.}
proc fundamental*(typeId: GType): GType {.importc: "g_type_fundamental",
    libgobj.}
proc createInstance*(`type`: GType): GTypeInstance {.
    importc: "g_type_create_instance", libgobj.}
proc typeFreeInstance*(instance: GTypeInstance) {.
    importc: "g_type_free_instance", libgobj.}
proc typeAddClassCacheFunc*(cacheData: Gpointer; cacheFunc: GTypeClassCacheFunc) {.
    importc: "g_type_add_class_cache_func", libgobj.}
proc typeRemoveClassCacheFunc*(cacheData: Gpointer; cacheFunc: GTypeClassCacheFunc) {.
    importc: "g_type_remove_class_cache_func", libgobj.}
proc typeClassUnrefUncached*(gClass: Gpointer) {.
    importc: "g_type_class_unref_uncached", libgobj.}
proc typeAddInterfaceCheck*(checkData: Gpointer;
                            checkFunc: GTypeInterfaceCheckFunc) {.
    importc: "g_type_add_interface_check", libgobj.}
proc typeRemoveInterfaceCheck*(checkData: Gpointer;
                               checkFunc: GTypeInterfaceCheckFunc) {.
    importc: "g_type_remove_interface_check", libgobj.}
proc valueTablePeek*(`type`: GType): GTypeValueTable {.
    importc: "g_type_value_table_peek", libgobj.}

proc checkInstance*(instance: GTypeInstance): Gboolean {.
    importc: "g_type_check_instance", libgobj.}
proc checkInstanceCast*(instance: GTypeInstance; ifaceType: GType): GTypeInstance {.
    importc: "g_type_check_instance_cast", libgobj.}
proc checkInstanceIsA*(instance: GTypeInstance; ifaceType: GType): Gboolean {.
    importc: "g_type_check_instance_is_a", libgobj.}
proc checkInstanceIsFundamentallyA*(instance: GTypeInstance;
                                        fundamentalType: GType): Gboolean {.
    importc: "g_type_check_instance_is_fundamentally_a", libgobj.}
proc checkClassCast*(gClass: GTypeClass; isAType: GType): GTypeClass {.
    importc: "g_type_check_class_cast", libgobj.}
proc checkClassIsA*(gClass: GTypeClass; isAType: GType): Gboolean {.
    importc: "g_type_check_class_is_a", libgobj.}
proc checkIsValueType*(`type`: GType): Gboolean {.
    importc: "g_type_check_is_value_type", libgobj.}
proc checkValue*(value: GValue): Gboolean {.importc: "g_type_check_value",
    libgobj.}
proc checkValueHolds*(value: GValue; `type`: GType): Gboolean {.
    importc: "g_type_check_value_holds", libgobj.}
proc testFlags*(`type`: GType; flags: cuint): Gboolean {.
    importc: "g_type_test_flags", libgobj.}

proc typeNameFromInstance*(instance: GTypeInstance): cstring {.
    importc: "g_type_name_from_instance", libgobj.}
proc typeNameFromClass*(gClass: GTypeClass): cstring {.
    importc: "g_type_name_from_class", libgobj.}

when not (G_DISABLE_CAST_CHECKS):
  template gTypeCic*(ip, gt, ct: untyped): untyped =
    (cast[ptr ct](checkInstanceCast(cast[GTypeInstance](ip), cast[GType](gt))))

  template gTypeCcc*(cp, gt, ct: untyped): untyped =
    (cast[ptr ct](checkClassCast(cast[GTypeClass](cp), cast[GType](gt))))

else:
  template gTypeCic*(ip, gt, ct: untyped): untyped =
    (cast[ptr ct](ip))

  template gTypeCcc*(cp, gt, ct: untyped): untyped =
    (cast[ptr ct](cp))

template gTypeChi*(ip: untyped): untyped =
  (gTypeCheckInstance(cast[GTypeInstance](ip)))

template gTypeChv*(vl: untyped): untyped =
  (gTypeCheckValue(cast[GValue](vl)))

template gTypeIgc*(ip, gt, ct: untyped): untyped =
  (cast[ptr ct](((cast[GTypeInstance](ip)).gClass)))

template gTypeIgi*(ip, gt, ct: untyped): untyped =
  (cast[ptr ct](typeInterfacePeek((cast[GTypeInstance](ip)).gClass, gt)))

template gTypeCift*(ip, ft: untyped): untyped =
  (checkInstanceIsFundamentallyA(cast[GTypeInstance](ip), ft))

template gTypeCit*(ip, gt: untyped): untyped =
  (checkInstanceIsA(cast[GTypeInstance](ip), cast[GType](gt)))

template gTypeCct*(cp, gt: untyped): untyped =
  (checkClassIsA(cast[GTypeClass](cp), gt))

template gTypeCvh*(vl, gt: untyped): untyped =
  (checkValueHolds(cast[GValue](vl), gt))

template gTypeCheckInstance*(instance: untyped): untyped =
  (gTypeChi(cast[GTypeInstance](instance)))

template gTypeCheckInstanceCast*(instance, gType, cType: untyped): untyped =
  (gTypeCic(instance, gType, cType))

template gTypeCheckInstanceType*(instance, gType: untyped): untyped =
  (gTypeCit(instance, gType))

template gTypeCheckInstanceFundamentalType*(instance, gType: untyped): untyped =
  (gTypeCift(instance, gType))

template gTypeInstanceGetClass*(instance, gType, cType: untyped): untyped =
  (gTypeIgc(instance, gType, cType))

template gTypeInstanceGetInterface*(instance, gType, cType: untyped): untyped =
  (gTypeIgi(instance, gType, cType))

template gTypeCheckClassCast*(gClass, gType, cType: untyped): untyped =
  (gTypeCcc(gClass, gType, cType))

template gTypeCheckClassType*(gClass, gType: untyped): untyped =
  (gTypeCct(gClass, gType))

template gTypeCheckValue*(value: untyped): untyped =
  (gTypeChv(value))

template gTypeCheckValueType*(value, gType: untyped): untyped =
  (gTypeCvh(value, gType))

template gTypeFromInstance*(instance: untyped): untyped =
  (gTypeFromClass((cast[GTypeInstance](instance)).gClass))

template gTypeFromClass*(gClass: untyped): untyped =
  ((cast[GTypeClass](gClass)).gType)

template gTypeFromInterface*(gIface: untyped): untyped =
  ((cast[GTypeInterface](gIface)).gType)

template gTypeInstanceGetPrivate*(instance, gType, cType: untyped): untyped =
  (cast[ptr CType](gTypeInstanceGetPrivate(cast[GTypeInstance](instance), gType)))

template gTypeClassGetPrivate*(klass, gType, cType: untyped): untyped =
  (cast[ptr CType](gTypeClassGetPrivate(cast[GTypeClass](klass), gType)))
const
  G_TYPE_FLAG_RESERVED_ID_BIT* = (GType(1 shl 0))

template gTypeIsValue*(`type`: untyped): untyped =
  (checkIsValueType(`type`))

template gIsValue*(value: untyped): untyped =
  (gTypeCheckValue(value))

template gValueType*(value: untyped): untyped =
  ((cast[GValue](value)).gType)

template gValueTypeName*(value: untyped): untyped =
  (name(gValueType(value)))

template gValueHolds*(value, `type`: untyped): untyped =
  (gTypeCheckValueType(value, `type`))

type
  GValueTransform* = proc (srcValue: GValue; destValue: GValue) {.cdecl.}

proc init*(value: var GValueObj; gType: GType): GValue {.importc: "g_value_init",
    libgobj.}
proc copy*(srcValue: GValue; destValue: GValue) {.
    importc: "g_value_copy", libgobj.}
proc reset*(value: GValue): GValue {.importc: "g_value_reset", libgobj.}
proc unset*(value: GValue) {.importc: "g_value_unset", libgobj.}
proc setInstance*(value: GValue; instance: Gpointer) {.
    importc: "g_value_set_instance", libgobj.}
proc `instance=`*(value: GValue; instance: Gpointer) {.
    importc: "g_value_set_instance", libgobj.}
proc initFromInstance*(value: GValue; instance: Gpointer) {.
    importc: "g_value_init_from_instance", libgobj.}

proc fitsPointer*(value: GValue): Gboolean {.
    importc: "g_value_fits_pointer", libgobj.}
proc peekPointer*(value: GValue): Gpointer {.
    importc: "g_value_peek_pointer", libgobj.}

proc valueTypeCompatible*(srcType: GType; destType: GType): Gboolean {.
    importc: "g_value_type_compatible", libgobj.}
proc valueTypeTransformable*(srcType: GType; destType: GType): Gboolean {.
    importc: "g_value_type_transformable", libgobj.}
proc transform*(srcValue: GValue; destValue: GValue): Gboolean {.
    importc: "g_value_transform", libgobj.}
proc valueRegisterTransformFunc*(srcType: GType; destType: GType;
                                 transformFunc: GValueTransform) {.
    importc: "g_value_register_transform_func", libgobj.}

const
  G_VALUE_NOCOPY_CONTENTS* = (1 shl 27)

template gTypeIsParam*(`type`: untyped): untyped =
  (gTypeFundamental(`type`) == G_TYPE_PARAM)

template gParamSpec*(pspec: untyped): untyped =
  (gTypeCheckInstanceCast(pspec, G_TYPE_PARAM, GParamSpecObj))

when true: # when glib_Version_Max_Allowed >= glib_Version_242:
  template gIsParamSpec*(pspec: untyped): untyped =
    (gTypeCheckInstanceFundamentalType(pspec, G_TYPE_PARAM))

else:
  template gIsParamSpec*(pspec: untyped): untyped =
    (gTypeCheckInstanceType(pspec, G_TYPE_PARAM))

template gParamSpecClass*(pclass: untyped): untyped =
  (gTypeCheckClassCast(pclass, G_TYPE_PARAM, GParamSpecClassObj))

template gIsParamSpecClass*(pclass: untyped): untyped =
  (gTypeCheckClassType(pclass, G_TYPE_PARAM))

template gParamSpecGetClass*(pspec: untyped): untyped =
  (gTypeInstanceGetClass(pspec, G_TYPE_PARAM, GParamSpecClassObj))

template gParamSpecType*(pspec: untyped): untyped =
  (gTypeFromInstance(pspec))

template gParamSpecTypeName*(pspec: untyped): untyped =
  (name(gParamSpecType(pspec)))

template gParamSpecValueType*(pspec: untyped): untyped =
  (gParamSpec(pspec).valueType)

template gValueHoldsParam*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_PARAM))

type
  GParamFlags* {.size: sizeof(cint), pure.} = enum
    DEPRECATED = (1.cint shl 31)
    READABLE = 1 shl 0, WRITABLE = 1 shl 1,
    CONSTRUCT = 1 shl 2, CONSTRUCT_ONLY = 1 shl 3,
    LAX_VALIDATION = 1 shl 4, STATIC_NAME = 1 shl 5,
    STATIC_NICK = 1 shl 6, STATIC_BLURB = 1 shl 7,
    EXPLICIT_NOTIFY = 1 shl 30

const
  G_PARAM_STATIC_STRINGS* = GParamFlags(
    GParamFlags.STATIC_NAME.ord or GParamFlags.STATIC_NICK.ord or GParamFlags.STATIC_BLURB.ord)
  G_PARAM_READWRITE = GParamFlags(GParamFlags.READABLE.ord or GParamFlags.WRITABLE.ord)

const
  G_PARAM_MASK* = 0xFF

const
  G_PARAM_USER_SHIFT* = 8

type
  GParamSpecPool* =  ptr GParamSpecPoolObj
  GParamSpecPoolPtr* = ptr GParamSpecPoolObj
  GParamSpecPoolObj* = object
 

type
  GParamSpec* =  ptr GParamSpecObj
  GParamSpecPtr* = ptr GParamSpecObj
  GParamSpecObj* = object of GTypeInstanceObj
    name*: cstring
    flags*: GParamFlags
    valueType*: GType
    ownerType*: GType
    nick*: cstring
    blurb*: cstring
    qdata*: GData
    refCount*: cuint
    paramId*: cuint

type
  GParamSpecClass* =  ptr GParamSpecClassObj
  GParamSpecClassPtr* = ptr GParamSpecClassObj
  GParamSpecClassObj* = object of GTypeClassObj
    valueType*: GType
    finalize*: proc (pspec: GParamSpec) {.cdecl.}
    valueSetDefault*: proc (pspec: GParamSpec; value: GValue) {.cdecl.}
    valueValidate*: proc (pspec: GParamSpec; value: GValue): Gboolean {.cdecl.}
    valuesCmp*: proc (pspec: GParamSpec; value1: GValue; value2: GValue): cint {.cdecl.}
    dummy: array[4, Gpointer]

type
  GParameter* =  ptr GParameterObj
  GParameterPtr* = ptr GParameterObj
  GParameterObj* = object
    name*: cstring
    value*: GValueObj

proc `ref`*(pspec: GParamSpec): GParamSpec {.
    importc: "g_param_spec_ref", libgobj.}
proc unref*(pspec: GParamSpec) {.importc: "g_param_spec_unref",
    libgobj.}
proc sink*(pspec: GParamSpec) {.importc: "g_param_spec_sink",
    libgobj.}
proc refSink*(pspec: GParamSpec): GParamSpec {.
    importc: "g_param_spec_ref_sink", libgobj.}
proc getQdata*(pspec: GParamSpec; quark: GQuark): Gpointer {.
    importc: "g_param_spec_get_qdata", libgobj.}
proc qdata*(pspec: GParamSpec; quark: GQuark): Gpointer {.
    importc: "g_param_spec_get_qdata", libgobj.}
proc setQdata*(pspec: GParamSpec; quark: GQuark; data: Gpointer) {.
    importc: "g_param_spec_set_qdata", libgobj.}
proc `qdata=`*(pspec: GParamSpec; quark: GQuark; data: Gpointer) {.
    importc: "g_param_spec_set_qdata", libgobj.}
proc setQdataFull*(pspec: GParamSpec; quark: GQuark; data: Gpointer;
                            destroy: GDestroyNotify) {.
    importc: "g_param_spec_set_qdata_full", libgobj.}
proc `qdataFull=`*(pspec: GParamSpec; quark: GQuark; data: Gpointer;
                            destroy: GDestroyNotify) {.
    importc: "g_param_spec_set_qdata_full", libgobj.}
proc stealQdata*(pspec: GParamSpec; quark: GQuark): Gpointer {.
    importc: "g_param_spec_steal_qdata", libgobj.}
proc getRedirectTarget*(pspec: GParamSpec): GParamSpec {.
    importc: "g_param_spec_get_redirect_target", libgobj.}
proc redirectTarget*(pspec: GParamSpec): GParamSpec {.
    importc: "g_param_spec_get_redirect_target", libgobj.}
proc paramValueSetDefault*(pspec: GParamSpec; value: GValue) {.
    importc: "g_param_value_set_default", libgobj.}
proc paramValueDefaults*(pspec: GParamSpec; value: GValue): Gboolean {.
    importc: "g_param_value_defaults", libgobj.}
proc paramValueValidate*(pspec: GParamSpec; value: GValue): Gboolean {.
    importc: "g_param_value_validate", libgobj.}
proc paramValueConvert*(pspec: GParamSpec; srcValue: GValue;
                        destValue: GValue; strictValidation: Gboolean): Gboolean {.
    importc: "g_param_value_convert", libgobj.}
proc paramValuesCmp*(pspec: GParamSpec; value1: GValue; value2: GValue): cint {.
    importc: "g_param_values_cmp", libgobj.}
proc getName*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_name", libgobj.}
proc name*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_name", libgobj.}
proc getNick*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_nick", libgobj.}
proc nick*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_nick", libgobj.}
proc getBlurb*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_blurb", libgobj.}
proc blurb*(pspec: GParamSpec): cstring {.
    importc: "g_param_spec_get_blurb", libgobj.}
proc setParam*(value: GValue; param: GParamSpec) {.
    importc: "g_value_set_param", libgobj.}
proc `param=`*(value: GValue; param: GParamSpec) {.
    importc: "g_value_set_param", libgobj.}
proc getParam*(value: GValue): GParamSpec {.
    importc: "g_value_get_param", libgobj.}
proc param*(value: GValue): GParamSpec {.
    importc: "g_value_get_param", libgobj.}
proc dupParam*(value: GValue): GParamSpec {.
    importc: "g_value_dup_param", libgobj.}
proc takeParam*(value: GValue; param: GParamSpec) {.
    importc: "g_value_take_param", libgobj.}
proc setParamTakeOwnership*(value: GValue; param: GParamSpec) {.
    importc: "g_value_set_param_take_ownership", libgobj.}
proc `paramTakeOwnership=`*(value: GValue; param: GParamSpec) {.
    importc: "g_value_set_param_take_ownership", libgobj.}
proc getDefaultValue*(pspec: GParamSpec): GValue {.
    importc: "g_param_spec_get_default_value", libgobj.}
proc defaultValue*(pspec: GParamSpec): GValue {.
    importc: "g_param_spec_get_default_value", libgobj.}
proc getNameQuark*(pspec: GParamSpec): GQuark {.
    importc: "g_param_spec_get_name_quark", libgobj.}
proc nameQuark*(pspec: GParamSpec): GQuark {.
    importc: "g_param_spec_get_name_quark", libgobj.}

type
  GParamSpecTypeInfo* =  ptr GParamSpecTypeInfoObj
  GParamSpecTypeInfoPtr* = ptr GParamSpecTypeInfoObj
  GParamSpecTypeInfoObj* = object
    instanceSize*: uint16
    nPreallocs*: uint16
    instanceInit*: proc (pspec: GParamSpec) {.cdecl.}
    valueType*: GType
    finalize*: proc (pspec: GParamSpec) {.cdecl.}
    valueSetDefault*: proc (pspec: GParamSpec; value: GValue) {.cdecl.}
    valueValidate*: proc (pspec: GParamSpec; value: GValue): Gboolean {.cdecl.}
    valuesCmp*: proc (pspec: GParamSpec; value1: GValue; value2: GValue): cint {.cdecl.}

proc paramTypeRegisterStatic*(name: cstring; pspecInfo: GParamSpecTypeInfo): GType {.
    importc: "g_param_type_register_static", libgobj.}

proc paramTypeRegisterStaticConstant*(name: cstring;
                                      pspecInfo: GParamSpecTypeInfo;
                                      optType: GType): GType {.
    importc: "_g_param_type_register_static_constant", libgobj.}

proc paramSpecInternal*(paramType: GType; name: cstring; nick: cstring;
                        blurb: cstring; flags: GParamFlags): Gpointer {.
    importc: "g_param_spec_internal", libgobj.}
proc newParamSpecPool*(typePrefixing: Gboolean): GParamSpecPool {.
    importc: "g_param_spec_pool_new", libgobj.}
proc insert*(pool: GParamSpecPool; pspec: GParamSpec;
                          ownerType: GType) {.importc: "g_param_spec_pool_insert",
    libgobj.}
proc remove*(pool: GParamSpecPool; pspec: GParamSpec) {.
    importc: "g_param_spec_pool_remove", libgobj.}
proc lookup*(pool: GParamSpecPool; paramName: cstring;
                          ownerType: GType; walkAncestors: Gboolean): GParamSpec {.
    importc: "g_param_spec_pool_lookup", libgobj.}
proc listOwned*(pool: GParamSpecPool; ownerType: GType): GList {.
    importc: "g_param_spec_pool_list_owned", libgobj.}
proc list*(pool: GParamSpecPool; ownerType: GType;
                        nPspecsP: var cuint): ptr GParamSpec {.
    importc: "g_param_spec_pool_list", libgobj.}

type
  GCallback* = proc () {.cdecl.}

  GClosureNotify* = proc (data: Gpointer; closure: GClosure) {.cdecl.}

  GClosureMarshal* = proc (closure: GClosure; returnValue: GValue;
                        nParamValues: cuint; paramValues: GValue;
                        invocationHint: Gpointer; marshalData: Gpointer) {.cdecl.}

#[type
  GVaClosureMarshal* = proc (closure: GClosure; returnValue: GValue;
                          instance: Gpointer; args: VaList; marshalData: Gpointer;
                          nParams: cint; paramTypes: ptr GType) {.cdecl.}
]#

  GClosureNotifyData* =  ptr GClosureNotifyDataObj
  GClosureNotifyDataPtr* = ptr GClosureNotifyDataObj
  GClosureNotifyDataObj* = object
    data*: Gpointer
    notify*: GClosureNotify

  GClosure* =  ptr GClosureObj
  GClosurePtr* = ptr GClosureObj
  GClosureObj*{.inheritable, pure.} = object
    refCount* {.bitsize: 15.}: cuint
    metaMarshalNouse* {.bitsize: 1.}: cuint
    nGuards* {.bitsize: 1.}: cuint
    nFnotifiers* {.bitsize: 2.}: cuint
    nInotifiers* {.bitsize: 8.}: cuint
    inInotify* {.bitsize: 1.}: cuint
    floating* {.bitsize: 1.}: cuint
    derivativeFlag* {.bitsize: 1.}: cuint
    inMarshal* {.bitsize: 1.}: cuint
    isInvalid* {.bitsize: 1.}: cuint
    marshal*: proc (closure: GClosure; returnValue: GValue; nParamValues: cuint;
                  paramValues: GValue; invocationHint: Gpointer;
                  marshalData: Gpointer) {.cdecl.}
    data*: Gpointer
    notifiers*: GClosureNotifyData

  GCClosure* =  ptr GCClosureObj
  GCClosurePtr* = ptr GCClosureObj
  GCClosureObj*{.final.} = object of GClosureObj
    callback*: Gpointer

template gClosureNeedsMarshal*(closure: untyped): untyped =
  ((cast[GClosure](closure)).marshal == nil)

template gClosureNNotifiers*(cl: untyped): untyped =
  ((cl.nGuards shl 1) + (cl).nFnotifiers + (cl).nInotifiers)

template gCclosureSwapData*(cclosure: untyped): untyped =
  ((cast[GClosure](cclosure)).derivativeFlag)

#template g_Callback*(f: untyped): untyped =
#  (gCallback(f))

proc newCclosure*(callbackFunc: GCallback; userData: Gpointer;
                  destroyData: GClosureNotify): GClosure {.
    importc: "g_cclosure_new", libgobj.}
proc newCclosureSwap*(callbackFunc: GCallback; userData: Gpointer;
                      destroyData: GClosureNotify): GClosure {.
    importc: "g_cclosure_new_swap", libgobj.}
proc newSignalTypeCclosure*(itype: GType; structOffset: cuint): GClosure {.
    importc: "g_signal_type_cclosure_new", libgobj.}

proc `ref`*(closure: GClosure): GClosure {.importc: "g_closure_ref",
    libgobj.}
proc sink*(closure: GClosure) {.importc: "g_closure_sink", libgobj.}
proc unref*(closure: GClosure) {.importc: "g_closure_unref", libgobj.}

proc newClosure*(sizeofClosure: cuint; data: Gpointer): GClosure {.
    importc: "g_closure_new_simple", libgobj.}
proc addFinalizeNotifier*(closure: GClosure; notifyData: Gpointer;
                                 notifyFunc: GClosureNotify) {.
    importc: "g_closure_add_finalize_notifier", libgobj.}
proc removeFinalizeNotifier*(closure: GClosure; notifyData: Gpointer;
                                    notifyFunc: GClosureNotify) {.
    importc: "g_closure_remove_finalize_notifier", libgobj.}
proc addInvalidateNotifier*(closure: GClosure; notifyData: Gpointer;
                                   notifyFunc: GClosureNotify) {.
    importc: "g_closure_add_invalidate_notifier", libgobj.}
proc removeInvalidateNotifier*(closure: GClosure; notifyData: Gpointer;
                                      notifyFunc: GClosureNotify) {.
    importc: "g_closure_remove_invalidate_notifier", libgobj.}
proc addMarshalGuards*(closure: GClosure; preMarshalData: Gpointer;
                              preMarshalNotify: GClosureNotify;
                              postMarshalData: Gpointer;
                              postMarshalNotify: GClosureNotify) {.
    importc: "g_closure_add_marshal_guards", libgobj.}
proc setMarshal*(closure: GClosure; marshal: GClosureMarshal) {.
    importc: "g_closure_set_marshal", libgobj.}
proc `marshal=`*(closure: GClosure; marshal: GClosureMarshal) {.
    importc: "g_closure_set_marshal", libgobj.}
proc setMetaMarshal*(closure: GClosure; marshalData: Gpointer;
                            metaMarshal: GClosureMarshal) {.
    importc: "g_closure_set_meta_marshal", libgobj.}
proc `metaMarshal=`*(closure: GClosure; marshalData: Gpointer;
                            metaMarshal: GClosureMarshal) {.
    importc: "g_closure_set_meta_marshal", libgobj.}
proc invalidate*(closure: GClosure) {.importc: "g_closure_invalidate",
    libgobj.}
proc invoke*(closure: GClosure; returnValue: GValue;
                    nParamValues: cuint; paramValues: GValue;
                    invocationHint: Gpointer) {.importc: "g_closure_invoke",
    libgobj.}

proc cclosureMarshalGeneric*(closure: GClosure; returnGvalue: GValue;
                             nParamValues: cuint; paramValues: GValue;
                             invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_generic", libgobj.}

proc cclosureMarshalVOID_VOID*(closure: GClosure; returnValue: GValue;
                               nParamValues: cuint; paramValues: GValue;
                               invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__VOID", libgobj.}

proc cclosureMarshalVOID_BOOLEAN*(closure: GClosure; returnValue: GValue;
                                  nParamValues: cuint; paramValues: GValue;
                                  invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__BOOLEAN", libgobj.}

proc cclosureMarshalVOID_CHAR*(closure: GClosure; returnValue: GValue;
                               nParamValues: cuint; paramValues: GValue;
                               invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__CHAR", libgobj.}

proc cclosureMarshalVOID_UCHAR*(closure: GClosure; returnValue: GValue;
                                nParamValues: cuint; paramValues: GValue;
                                invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__UCHAR", libgobj.}

proc cclosureMarshalVOID_INT*(closure: GClosure; returnValue: GValue;
                              nParamValues: cuint; paramValues: GValue;
                              invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__INT", libgobj.}

proc cclosureMarshalVOID_UINT*(closure: GClosure; returnValue: GValue;
                               nParamValues: cuint; paramValues: GValue;
                               invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__UINT", libgobj.}

proc cclosureMarshalVOID_LONG*(closure: GClosure; returnValue: GValue;
                               nParamValues: cuint; paramValues: GValue;
                               invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__LONG", libgobj.}

proc cclosureMarshalVOID_ULONG*(closure: GClosure; returnValue: GValue;
                                nParamValues: cuint; paramValues: GValue;
                                invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__ULONG", libgobj.}

proc cclosureMarshalVOID_ENUM*(closure: GClosure; returnValue: GValue;
                               nParamValues: cuint; paramValues: GValue;
                               invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__ENUM", libgobj.}

proc cclosureMarshalVOID_FLAGS*(closure: GClosure; returnValue: GValue;
                                nParamValues: cuint; paramValues: GValue;
                                invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__FLAGS", libgobj.}

proc cclosureMarshalVOID_FLOAT*(closure: GClosure; returnValue: GValue;
                                nParamValues: cuint; paramValues: GValue;
                                invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__FLOAT", libgobj.}

proc cclosureMarshalVOID_DOUBLE*(closure: GClosure; returnValue: GValue;
                                 nParamValues: cuint; paramValues: GValue;
                                 invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__DOUBLE", libgobj.}

proc cclosureMarshalVOID_STRING*(closure: GClosure; returnValue: GValue;
                                 nParamValues: cuint; paramValues: GValue;
                                 invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__STRING", libgobj.}

proc cclosureMarshalVOID_PARAM*(closure: GClosure; returnValue: GValue;
                                nParamValues: cuint; paramValues: GValue;
                                invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__PARAM", libgobj.}

proc cclosureMarshalVOID_BOXED*(closure: GClosure; returnValue: GValue;
                                nParamValues: cuint; paramValues: GValue;
                                invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__BOXED", libgobj.}

proc cclosureMarshalVOID_POINTER*(closure: GClosure; returnValue: GValue;
                                  nParamValues: cuint; paramValues: GValue;
                                  invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__POINTER", libgobj.}

proc cclosureMarshalVOID_OBJECT*(closure: GClosure; returnValue: GValue;
                                 nParamValues: cuint; paramValues: GValue;
                                 invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__OBJECT", libgobj.}

proc cclosureMarshalVOID_VARIANT*(closure: GClosure; returnValue: GValue;
                                  nParamValues: cuint; paramValues: GValue;
                                  invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__VARIANT", libgobj.}

proc cclosureMarshalVOID_UINT_POINTER*(closure: GClosure;
                                       returnValue: GValue;
                                       nParamValues: cuint;
                                       paramValues: GValue;
                                       invocationHint: Gpointer;
                                       marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_VOID__UINT_POINTER", libgobj.}

proc cclosureMarshalBOOLEAN_FLAGS*(closure: GClosure; returnValue: GValue;
                                   nParamValues: cuint; paramValues: GValue;
                                   invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_BOOLEAN__FLAGS", libgobj.}
const
  gCclosureMarshalBOOL_FLAGS* = cclosureMarshalBOOLEAN_FLAGS

proc cclosureMarshalSTRING_OBJECT_POINTER*(closure: GClosure;
    returnValue: GValue; nParamValues: cuint; paramValues: GValue;
    invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_STRING__OBJECT_POINTER", libgobj.}

proc cclosureMarshalBOOLEAN_BOXED_BOXED*(closure: GClosure;
    returnValue: GValue; nParamValues: cuint; paramValues: GValue;
    invocationHint: Gpointer; marshalData: Gpointer) {.
    importc: "g_cclosure_marshal_BOOLEAN__BOXED_BOXED", libgobj.}
const
  gCclosureMarshalBOOL_BOXED_BOXED* = cclosureMarshalBOOLEAN_BOXED_BOXED

type
  GSignalCMarshaller* = GClosureMarshal

#[type
  GSignalCVaMarshaller* = GVaClosureMarshal
]#

type
  GSignalFlags* {.size: sizeof(cint), pure.} = enum
    RUN_FIRST = 1 shl 0, RUN_LAST = 1 shl 1,
    RUN_CLEANUP = 1 shl 2, NO_RECURSE = 1 shl 3,
    DETAILED = 1 shl 4, ACTION = 1 shl 5, NO_HOOKS = 1 shl 6,
    MUST_COLLECT = 1 shl 7, DEPRECATED = 1 shl 8

const
  G_SIGNAL_FLAGS_MASK* = 0x1FF

type
  GConnectFlags* {.size: sizeof(cint), pure.} = enum
    AFTER = 1 shl 0, SWAPPED = 1 shl 1

type
  GSignalMatchType* {.size: sizeof(cint), pure.} = enum
    ID = 1 shl 0, DETAIL = 1 shl 1,
    CLOSURE = 1 shl 2, FUNC = 1 shl 3,
    DATA = 1 shl 4, UNBLOCKED = 1 shl 5

const
  G_SIGNAL_MATCH_MASK* = 0x3F

const
  G_SIGNAL_TYPE_STATIC_SCOPE* = G_TYPE_FLAG_RESERVED_ID_BIT

type
  GSignalEmissionHook* = proc (ihint: GSignalInvocationHint; nParamValues: cuint;
                            paramValues: GValue; data: Gpointer): Gboolean {.cdecl.}

  GSignalAccumulator* = proc (ihint: GSignalInvocationHint;
                           returnAccu: GValue; handlerReturn: GValue;
                           data: Gpointer): Gboolean {.cdecl.}
  GSignalInvocationHint* =  ptr GSignalInvocationHintObj
  GSignalInvocationHintPtr* = ptr GSignalInvocationHintObj
  GSignalInvocationHintObj* = object
    signalId*: cuint
    detail*: GQuark
    runType*: GSignalFlags

type
  GSignalQuery* =  ptr GSignalQueryObj
  GSignalQueryPtr* = ptr GSignalQueryObj
  GSignalQueryObj* = object
    signalId*: cuint
    signalName*: cstring
    itype*: GType
    signalFlags*: GSignalFlags
    returnType*: GType
    nParams*: cuint
    paramTypes*: ptr GType

proc signalNewv*(signalName: cstring; itype: GType; signalFlags: GSignalFlags;
                 classClosure: GClosure; accumulator: GSignalAccumulator;
                 accuData: Gpointer; cMarshaller: GSignalCMarshaller;
                 returnType: GType; nParams: cuint; paramTypes: ptr GType): cuint {.
    importc: "g_signal_newv", libgobj.}
proc newSignal*(signalName: cstring; itype: GType; signalFlags: GSignalFlags;
                classOffset: cuint; accumulator: GSignalAccumulator;
                accuData: Gpointer; cMarshaller: GSignalCMarshaller;
                returnType: GType; nParams: cuint): cuint {.varargs,
    importc: "g_signal_new", libgobj.}
proc newSignal*(signalName: cstring; itype: GType;
                            signalFlags: GSignalFlags; classHandler: GCallback;
                            accumulator: GSignalAccumulator; accuData: Gpointer;
                            cMarshaller: GSignalCMarshaller; returnType: GType;
                            nParams: cuint): cuint {.varargs,
    importc: "g_signal_new_class_handler", libgobj.}
#[proc signalSetVaMarshaller*(signalId: cuint; instanceType: GType;
                            vaMarshaller: GSignalCVaMarshaller) {.
    importc: "g_signal_set_va_marshaller", libgobj.}
]#
proc signalEmitv*(instanceAndParams: GValue; signalId: cuint; detail: GQuark;
                  returnValue: GValue) {.importc: "g_signal_emitv", libgobj.}
proc signalEmit*(instance: Gpointer; signalId: cuint; detail: GQuark) {.varargs,
    importc: "g_signal_emit", libgobj.}
proc signalEmitByName*(instance: Gpointer; detailedSignal: cstring) {.varargs,
    importc: "g_signal_emit_by_name", libgobj.}
proc signalLookup*(name: cstring; itype: GType): cuint {.importc: "g_signal_lookup",
    libgobj.}
proc signalName*(signalId: cuint): cstring {.importc: "g_signal_name", libgobj.}
proc signalQuery*(signalId: cuint; query: GSignalQuery) {.
    importc: "g_signal_query", libgobj.}
proc signalListIds*(itype: GType; nIds: var cuint): ptr cuint {.
    importc: "g_signal_list_ids", libgobj.}
proc signalParseName*(detailedSignal: cstring; itype: GType; signalIdP: var cuint;
                      detailP: ptr GQuark; forceDetailQuark: Gboolean): Gboolean {.
    importc: "g_signal_parse_name", libgobj.}
proc signalGetInvocationHint*(instance: Gpointer): GSignalInvocationHint {.
    importc: "g_signal_get_invocation_hint", libgobj.}

proc signalStopEmission*(instance: Gpointer; signalId: cuint; detail: GQuark) {.
    importc: "g_signal_stop_emission", libgobj.}
proc signalStopEmissionByName*(instance: Gpointer; detailedSignal: cstring) {.
    importc: "g_signal_stop_emission_by_name", libgobj.}
proc signalAddEmissionHook*(signalId: cuint; detail: GQuark;
                            hookFunc: GSignalEmissionHook; hookData: Gpointer;
                            dataDestroy: GDestroyNotify): culong {.
    importc: "g_signal_add_emission_hook", libgobj.}
proc signalRemoveEmissionHook*(signalId: cuint; hookId: culong) {.
    importc: "g_signal_remove_emission_hook", libgobj.}

proc signalHasHandlerPending*(instance: Gpointer; signalId: cuint; detail: GQuark;
                              mayBeBlocked: Gboolean): Gboolean {.
    importc: "g_signal_has_handler_pending", libgobj.}
proc signalConnectClosureById*(instance: Gpointer; signalId: cuint; detail: GQuark;
                               closure: GClosure; after: Gboolean): culong {.
    importc: "g_signal_connect_closure_by_id", libgobj.}
proc signalConnectClosure*(instance: Gpointer; detailedSignal: cstring;
                           closure: GClosure; after: Gboolean): culong {.
    importc: "g_signal_connect_closure", libgobj.}
proc signalConnectData*(instance: Gpointer; detailedSignal: cstring;
                        cHandler: GCallback; data: Gpointer;
                        destroyData: GClosureNotify; connectFlags: GConnectFlags): culong {.
    importc: "g_signal_connect_data", libgobj.}
proc signalHandlerBlock*(instance: Gpointer; handlerId: culong) {.
    importc: "g_signal_handler_block", libgobj.}
proc signalHandlerUnblock*(instance: Gpointer; handlerId: culong) {.
    importc: "g_signal_handler_unblock", libgobj.}
proc signalHandlerDisconnect*(instance: Gpointer; handlerId: culong) {.
    importc: "g_signal_handler_disconnect", libgobj.}
proc signalHandlerIsConnected*(instance: Gpointer; handlerId: culong): Gboolean {.
    importc: "g_signal_handler_is_connected", libgobj.}
proc signalHandlerFind*(instance: Gpointer; mask: GSignalMatchType; signalId: cuint;
                        detail: GQuark; closure: GClosure; `func`: Gpointer;
                        data: Gpointer): culong {.importc: "g_signal_handler_find",
    libgobj.}
proc signalHandlersBlockMatched*(instance: Gpointer; mask: GSignalMatchType;
                                 signalId: cuint; detail: GQuark;
                                 closure: GClosure; `func`: Gpointer;
                                 data: Gpointer): cuint {.
    importc: "g_signal_handlers_block_matched", libgobj.}
proc signalHandlersUnblockMatched*(instance: Gpointer; mask: GSignalMatchType;
                                   signalId: cuint; detail: GQuark;
                                   closure: GClosure; `func`: Gpointer;
                                   data: Gpointer): cuint {.
    importc: "g_signal_handlers_unblock_matched", libgobj.}
proc signalHandlersDisconnectMatched*(instance: Gpointer; mask: GSignalMatchType;
                                      signalId: cuint; detail: GQuark;
                                      closure: GClosure; `func`: Gpointer;
                                      data: Gpointer): cuint {.
    importc: "g_signal_handlers_disconnect_matched", libgobj.}

proc signalOverrideClassClosure*(signalId: cuint; instanceType: GType;
                                 classClosure: GClosure) {.
    importc: "g_signal_override_class_closure", libgobj.}
proc signalOverrideClassHandler*(signalName: cstring; instanceType: GType;
                                 classHandler: GCallback) {.
    importc: "g_signal_override_class_handler", libgobj.}
proc signalChainFromOverridden*(instanceAndParams: GValue;
                                returnValue: GValue) {.
    importc: "g_signal_chain_from_overridden", libgobj.}
proc signalChainFromOverriddenHandler*(instance: Gpointer) {.varargs,
    importc: "g_signal_chain_from_overridden_handler", libgobj.}

template gSignalConnect*(instance, detailedSignal, cHandler, data: untyped): untyped =
  signalConnectData(instance, detailedSignal, cHandler, data, nil,
                     cast[GConnectFlags](0))

template gSignalConnectAfter*(instance, detailedSignal, cHandler, data: untyped): untyped =
  signalConnectData(instance, detailedSignal, cHandler, data, nil,
                     GConnectFlags.AFTER)

template gSignalConnectSwapped*(instance, detailedSignal, cHandler, data: untyped): untyped =
  signalConnectData(instance, detailedSignal, cHandler, data, nil,
                     GConnectFlags.SWAPPED)

template gSignalHandlersDisconnectByFunc*(instance, `func`, data: untyped): untyped =
  signalHandlersDisconnectMatched(instance, GSignalMatchType(
      GSignalMatchType.FUNC.ord or GSignalMatchType.DATA.ord), 0, 0, nil, `func`, data)

template gSignalHandlersDisconnectByData*(instance, data: untyped): untyped =
  signalHandlersDisconnectMatched(instance, GSignalMatchType.DATA, 0, 0, nil, nil,
                                   (data))

template gSignalHandlersBlockByFunc*(instance, `func`, data: untyped): untyped =
  signalHandlersBlockMatched(instance, GSignalMatchType(
      GSignalMatchType.FUNC.ord or GSignalMatchType.DATA.ord), 0, 0, nil, `func`, data)

template gSignalHandlersUnblockByFunc*(instance, `func`, data: untyped): untyped =
  gSignalHandlersUnblockMatched(instance, GSignalMatchType(
      GSignalMatchType.FUNC.ord or GSignalMatchType.DATA.ord), 0, 0, nil, `func`, data)

proc signalAccumulatorTrueHandled*(ihint: GSignalInvocationHint;
                                   returnAccu: GValue;
                                   handlerReturn: GValue; dummy: Gpointer): Gboolean {.
    importc: "g_signal_accumulator_true_handled", libgobj.}
proc signalAccumulatorFirstWins*(ihint: GSignalInvocationHint;
                                 returnAccu: GValue; handlerReturn: GValue;
                                 dummy: Gpointer): Gboolean {.
    importc: "g_signal_accumulator_first_wins", libgobj.}

proc signalHandlersDestroy*(instance: Gpointer) {.
    importc: "g_signal_handlers_destroy", libgobj.}
proc signalsDestroy*(itype: GType) {.importc: "_g_signals_destroy", libgobj.}

template gTypeDate*(): untyped =
  (dateGetType())

template gTypeStrv*(): untyped =
  (strvGetType())

template gTypeGstring*(): untyped =
  (gstringGetType())

template gTypeHashTable*(): untyped =
  (hashTableGetType())

template gTypeRegex*(): untyped =
  (regexGetType())

template gTypeMatchInfo*(): untyped =
  (matchInfoGetType())

template gTypeArray*(): untyped =
  (arrayGetType())

template gTypeByteArray*(): untyped =
  (byteArrayGetType())

template gTypePtrArray*(): untyped =
  (ptrArrayGetType())

template gTypeBytes*(): untyped =
  (bytesGetType())

template gTypeVariantType*(): untyped =
  (gVariantTypeGetGtype())

template gTypeError*(): untyped =
  (errorGetType())

template gTypeDateTime*(): untyped =
  (dateTimeGetType())

template gTypeTimeZone*(): untyped =
  (timeZoneGetType())

template gTypeIoChannel*(): untyped =
  (ioChannelGetType())

template gTypeIoCondition*(): untyped =
  (ioConditionGetType())

template gTypeVariantBuilder*(): untyped =
  (variantBuilderGetType())

template gTypeVariantDict*(): untyped =
  (variantDictGetType())

template gTypeMainLoop*(): untyped =
  (mainLoopGetType())

template gTypeMainContext*(): untyped =
  (mainContextGetType())

template gTypeSource*(): untyped =
  (sourceGetType())

template gTypePollfd*(): untyped =
  (pollfdGetType())

template gTypeMarkupParseContext*(): untyped =
  (markupParseContextGetType())

template gTypeKeyFile*(): untyped =
  (keyFileGetType())

template gTypeMappedFile*(): untyped =
  (mappedFileGetType())

template gTypeThread*(): untyped =
  (threadGetType())

template gTypeChecksum*(): untyped =
  (checksumGetType())

template gTypeOptionGroup*(): untyped =
  (optionGroupGetType())

proc dateGetType*(): GType {.importc: "g_date_get_type", libgobj.}
proc strvGetType*(): GType {.importc: "g_strv_get_type", libgobj.}
proc gstringGetType*(): GType {.importc: "g_gstring_get_type", libgobj.}
proc hashTableGetType*(): GType {.importc: "g_hash_table_get_type", libgobj.}
proc arrayGetType*(): GType {.importc: "g_array_get_type", libgobj.}
proc byteArrayGetType*(): GType {.importc: "g_byte_array_get_type", libgobj.}
proc ptrArrayGetType*(): GType {.importc: "g_ptr_array_get_type", libgobj.}
proc bytesGetType*(): GType {.importc: "g_bytes_get_type", libgobj.}
proc variantTypeGetGtype*(): GType {.importc: "g_variant_type_get_gtype",
                                   libgobj.}
proc regexGetType*(): GType {.importc: "g_regex_get_type", libgobj.}
proc matchInfoGetType*(): GType {.importc: "g_match_info_get_type", libgobj.}
proc errorGetType*(): GType {.importc: "g_error_get_type", libgobj.}
proc dateTimeGetType*(): GType {.importc: "g_date_time_get_type", libgobj.}
proc timeZoneGetType*(): GType {.importc: "g_time_zone_get_type", libgobj.}
proc ioChannelGetType*(): GType {.importc: "g_io_channel_get_type", libgobj.}
proc ioConditionGetType*(): GType {.importc: "g_io_condition_get_type", libgobj.}
proc variantBuilderGetType*(): GType {.importc: "g_variant_builder_get_type",
                                     libgobj.}
proc variantDictGetType*(): GType {.importc: "g_variant_dict_get_type", libgobj.}
proc keyFileGetType*(): GType {.importc: "g_key_file_get_type", libgobj.}
proc mainLoopGetType*(): GType {.importc: "g_main_loop_get_type", libgobj.}
proc mainContextGetType*(): GType {.importc: "g_main_context_get_type", libgobj.}
proc sourceGetType*(): GType {.importc: "g_source_get_type", libgobj.}
proc pollfdGetType*(): GType {.importc: "g_pollfd_get_type", libgobj.}
proc threadGetType*(): GType {.importc: "g_thread_get_type", libgobj.}
proc checksumGetType*(): GType {.importc: "g_checksum_get_type", libgobj.}
proc markupParseContextGetType*(): GType {.
    importc: "g_markup_parse_context_get_type", libgobj.}
proc mappedFileGetType*(): GType {.importc: "g_mapped_file_get_type", libgobj.}
proc optionGroupGetType*(): GType {.importc: "g_option_group_get_type", libgobj.}
proc variantGetGtype*(): GType {.importc: "g_variant_get_gtype", libgobj.}

template gTypeIsBoxed*(`type`: untyped): untyped =
  (gTypeFundamental(`type`) == G_TYPE_BOXED)

template gValueHoldsBoxed*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_BOXED))

type
  GBoxedCopyFunc* = proc (boxed: Gpointer): Gpointer {.cdecl.}

type
  GBoxedFreeFunc* = proc (boxed: Gpointer) {.cdecl.}

proc boxedCopy*(boxedType: GType; srcBoxed: Gconstpointer): Gpointer {.
    importc: "g_boxed_copy", libgobj.}
proc boxedFree*(boxedType: GType; boxed: Gpointer) {.importc: "g_boxed_free",
    libgobj.}
proc setBoxed*(value: GValue; vBoxed: Gconstpointer) {.
    importc: "g_value_set_boxed", libgobj.}
proc `boxed=`*(value: GValue; vBoxed: Gconstpointer) {.
    importc: "g_value_set_boxed", libgobj.}
proc setStaticBoxed*(value: GValue; vBoxed: Gconstpointer) {.
    importc: "g_value_set_static_boxed", libgobj.}
proc `staticBoxed=`*(value: GValue; vBoxed: Gconstpointer) {.
    importc: "g_value_set_static_boxed", libgobj.}
proc takeBoxed*(value: GValue; vBoxed: Gconstpointer) {.
    importc: "g_value_take_boxed", libgobj.}
proc setBoxedTakeOwnership*(value: GValue; vBoxed: Gconstpointer) {.
    importc: "g_value_set_boxed_take_ownership", libgobj.}
proc `boxedTakeOwnership=`*(value: GValue; vBoxed: Gconstpointer) {.
    importc: "g_value_set_boxed_take_ownership", libgobj.}
proc getBoxed*(value: GValue): Gpointer {.importc: "g_value_get_boxed",
    libgobj.}
proc boxed*(value: GValue): Gpointer {.importc: "g_value_get_boxed",
    libgobj.}
proc dupBoxed*(value: GValue): Gpointer {.importc: "g_value_dup_boxed",
    libgobj.}

proc boxedTypeRegisterStatic*(name: cstring; boxedCopy: GBoxedCopyFunc;
                              boxedFree: GBoxedFreeFunc): GType {.
    importc: "g_boxed_type_register_static", libgobj.}

template gTypeClosure*(): untyped =
  (closureGetType())

template gTypeValue*(): untyped =
  (valueGetType())

proc closureGetType*(): GType {.importc: "g_closure_get_type", libgobj.}
proc valueGetType*(): GType {.importc: "g_value_get_type", libgobj.}

template gTypeIsObject*(`type`: untyped): untyped =
  (gTypeFundamental(`type`) == G_TYPE_OBJECT)

template gObject*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, G_TYPE_OBJECT, GObjectObj))

template gObjectClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, G_TYPE_OBJECT, GObjectClassObj))

when true: # when glib_Version_Max_Allowed >= glib_Version_242:
  template gIsObject*(`object`: untyped): untyped =
    (gTypeCheckInstanceFundamentalType(`object`, G_TYPE_OBJECT))

else:
  template gIsObject*(`object`: untyped): untyped =
    (gTypeCheckInstanceType(`object`, G_TYPE_OBJECT))

template gIsObjectClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, G_TYPE_OBJECT))

template gObjectGetClass*(`object`: untyped): untyped =
  (gTypeInstanceGetClass(`object`, G_TYPE_OBJECT, GObjectClassObj))

template gObjectType*(`object`: untyped): untyped =
  (gTypeFromInstance(`object`))

template gObjectTypeName*(`object`: untyped): untyped =
  (name(gObjectType(`object`)))

template gObjectClassType*(class: untyped): untyped =
  (gTypeFromClass(class))

template gObjectClassName*(class: untyped): untyped =
  (name(gObjectClassType(class)))

template gValueHoldsObject*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_OBJECT))

template gTypeInitiallyUnowned*(): untyped =
  (initiallyUnownedGetType())

template gInitiallyUnowned*(`object`: untyped): untyped =
  (gTypeCheckInstanceCast(`object`, gTypeInitiallyUnowned, GInitiallyUnownedObj))

template gInitiallyUnownedClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeInitiallyUnowned, GInitiallyUnownedClassObj))

template gIsInitiallyUnowned*(`object`: untyped): untyped =
  (gTypeCheckInstanceType(`object`, gTypeInitiallyUnowned))

template gIsInitiallyUnownedClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeInitiallyUnowned))

template gInitiallyUnownedGetClass*(`object`: untyped): untyped =
  (gTypeInstanceGetClass(`object`, gTypeInitiallyUnowned, GInitiallyUnownedClassObj))

type
  GObjectConstructParam* =  ptr GObjectConstructParamObj
  GObjectConstructParamPtr* = ptr GObjectConstructParamObj
  GObjectConstructParamObj* = object
    pspec*: GParamSpec
    value*: GValue
type
  GObject* =  ptr GObjectObj
  GObjectPtr* = ptr GObjectObj
  GObjectObj* = object of GTypeInstanceObj
    refCount*: cuint
    qdata*: GData

type
  GObjectClass* =  ptr GObjectClassObj
  GObjectClassPtr* = ptr GObjectClassObj
  GObjectClassObj* = object of GTypeClassObj
    constructProperties*: GSList
    constructor*: proc (`type`: GType; nConstructProperties: cuint;
                      constructProperties: GObjectConstructParam): GObject {.cdecl.}
    setProperty*: proc (`object`: GObject; propertyId: cuint; value: GValue;
                      pspec: GParamSpec) {.cdecl.}
    getProperty*: proc (`object`: GObject; propertyId: cuint; value: GValue;
                      pspec: GParamSpec) {.cdecl.}
    dispose*: proc (`object`: GObject) {.cdecl.}
    finalize*: proc (`object`: GObject) {.cdecl.}
    dispatchPropertiesChanged*: proc (`object`: GObject; nPspecs: cuint;
                                    pspecs: var GParamSpec) {.cdecl.}
    notify*: proc (`object`: GObject; pspec: GParamSpec) {.cdecl.}
    constructed*: proc (`object`: GObject) {.cdecl.}
    flags*: Gsize
    pdummy: array[6, Gpointer]
type
  GInitiallyUnowned* =  ptr GInitiallyUnownedObj
  GInitiallyUnownedPtr* = ptr GInitiallyUnownedObj
  GInitiallyUnownedObj* = GObjectObj
  GInitiallyUnownedClass* =  ptr GInitiallyUnownedClassObj
  GInitiallyUnownedClassPtr* = ptr GInitiallyUnownedClassObj
  GInitiallyUnownedClassObj* = GObjectClassObj
type
  GObjectGetPropertyFunc* = proc (`object`: GObject; propertyId: cuint;
                               value: GValue; pspec: GParamSpec) {.cdecl.}

type
  GObjectSetPropertyFunc* = proc (`object`: GObject; propertyId: cuint;
                               value: GValue; pspec: GParamSpec) {.cdecl.}

type
  GObjectFinalizeFunc* = proc (`object`: GObject) {.cdecl.}

type
  GWeakNotify* = proc (data: Gpointer; whereTheObjectWas: GObject) {.cdecl.}

proc initiallyUnownedGetType*(): GType {.importc: "g_initially_unowned_get_type",
                                       libgobj.}
proc installProperty*(oclass: GObjectClass; propertyId: cuint;
                                 pspec: GParamSpec) {.
    importc: "g_object_class_install_property", libgobj.}
proc findProperty*(oclass: GObjectClass; propertyName: cstring): GParamSpec {.
    importc: "g_object_class_find_property", libgobj.}
proc listProperties*(oclass: GObjectClass; nProperties: var cuint): ptr GParamSpec {.
    importc: "g_object_class_list_properties", libgobj.}
proc overrideProperty*(oclass: GObjectClass; propertyId: cuint;
                                  name: cstring) {.
    importc: "g_object_class_override_property", libgobj.}
proc installProperties*(oclass: GObjectClass; nPspecs: cuint;
                                   pspecs: var GParamSpec) {.
    importc: "g_object_class_install_properties", libgobj.}
proc objectInterfaceInstallProperty*(gIface: Gpointer; pspec: GParamSpec) {.
    importc: "g_object_interface_install_property", libgobj.}
proc objectInterfaceFindProperty*(gIface: Gpointer; propertyName: cstring): GParamSpec {.
    importc: "g_object_interface_find_property", libgobj.}
proc objectInterfaceListProperties*(gIface: Gpointer; nPropertiesP: var cuint): ptr GParamSpec {.
    importc: "g_object_interface_list_properties", libgobj.}
proc objectGetType*(): GType {.importc: "g_object_get_type", libgobj.}
proc newObject*(objectType: GType; firstPropertyName: cstring): GObject {.varargs,
    importc: "g_object_new", libgobj.}
proc newObject*(objectType: GType; nProperties: cuint;
                              names: var cstring; values: GValue): GObject {.
    importc: "g_object_new_with_properties", libgobj.}
proc objectNewv*(objectType: GType; nParameters: cuint; parameters: GParameter): Gpointer {.
    importc: "g_object_newv", libgobj.}
proc objectSet*(`object`: Gpointer; firstPropertyName: cstring) {.varargs,
    importc: "g_object_set", libgobj.}
proc objectGet*(`object`: Gpointer; firstPropertyName: cstring) {.varargs,
    importc: "g_object_get", libgobj.}
proc objectConnect*(`object`: Gpointer; signalSpec: cstring): Gpointer {.varargs,
    importc: "g_object_connect", libgobj.}
proc objectDisconnect*(`object`: Gpointer; signalSpec: cstring) {.varargs,
    importc: "g_object_disconnect", libgobj.}
proc setv*(`object`: GObject; nProperties: cuint; names: var cstring;
                 values: GValue) {.importc: "g_object_setv", libgobj.}
proc getv*(`object`: GObject; nProperties: cuint; names: var cstring;
                 values: GValue) {.importc: "g_object_getv", libgobj.}
proc setProperty*(`object`: GObject; propertyName: cstring;
                        value: GValue) {.importc: "g_object_set_property",
    libgobj.}
proc `property=`*(`object`: GObject; propertyName: cstring;
                        value: GValue) {.importc: "g_object_set_property",
    libgobj.}
proc getProperty*(`object`: GObject; propertyName: cstring;
                        value: GValue) {.importc: "g_object_get_property",
    libgobj.}
proc freezeNotify*(`object`: GObject) {.
    importc: "g_object_freeze_notify", libgobj.}
proc notify*(`object`: GObject; propertyName: cstring) {.
    importc: "g_object_notify", libgobj.}
proc notifyByPspec*(`object`: GObject; pspec: GParamSpec) {.
    importc: "g_object_notify_by_pspec", libgobj.}
proc thawNotify*(`object`: GObject) {.importc: "g_object_thaw_notify",
    libgobj.}
proc objectIsFloating*(`object`: Gpointer): Gboolean {.
    importc: "g_object_is_floating", libgobj.}
proc objectRefSink*(`object`: Gpointer): Gpointer {.importc: "g_object_ref_sink",
    libgobj.}
proc objectRef*(`object`: Gpointer): Gpointer {.importc: "g_object_ref", libgobj.}
proc objectUnref*(`object`: Gpointer) {.importc: "g_object_unref", libgobj.}
proc weakRef*(`object`: GObject; notify: GWeakNotify; data: Gpointer) {.
    importc: "g_object_weak_ref", libgobj.}
proc weakUnref*(`object`: GObject; notify: GWeakNotify; data: Gpointer) {.
    importc: "g_object_weak_unref", libgobj.}
proc addWeakPointer*(`object`: GObject; weakPointerLocation: var Gpointer) {.
    importc: "g_object_add_weak_pointer", libgobj.}
proc removeWeakPointer*(`object`: GObject;
                              weakPointerLocation: var Gpointer) {.
    importc: "g_object_remove_weak_pointer", libgobj.}

type
  GToggleNotify* = proc (data: Gpointer; `object`: GObject; isLastRef: Gboolean) {.cdecl.}

proc addToggleRef*(`object`: GObject; notify: GToggleNotify; data: Gpointer) {.
    importc: "g_object_add_toggle_ref", libgobj.}
proc removeToggleRef*(`object`: GObject; notify: GToggleNotify;
                            data: Gpointer) {.
    importc: "g_object_remove_toggle_ref", libgobj.}
proc getQdata*(`object`: GObject; quark: GQuark): Gpointer {.
    importc: "g_object_get_qdata", libgobj.}
proc qdata*(`object`: GObject; quark: GQuark): Gpointer {.
    importc: "g_object_get_qdata", libgobj.}
proc setQdata*(`object`: GObject; quark: GQuark; data: Gpointer) {.
    importc: "g_object_set_qdata", libgobj.}
proc `qdata=`*(`object`: GObject; quark: GQuark; data: Gpointer) {.
    importc: "g_object_set_qdata", libgobj.}
proc setQdataFull*(`object`: GObject; quark: GQuark; data: Gpointer;
                         destroy: GDestroyNotify) {.
    importc: "g_object_set_qdata_full", libgobj.}
proc `qdataFull=`*(`object`: GObject; quark: GQuark; data: Gpointer;
                         destroy: GDestroyNotify) {.
    importc: "g_object_set_qdata_full", libgobj.}
proc stealQdata*(`object`: GObject; quark: GQuark): Gpointer {.
    importc: "g_object_steal_qdata", libgobj.}
proc dupQdata*(`object`: GObject; quark: GQuark; dupFunc: GDuplicateFunc;
                     userData: Gpointer): Gpointer {.importc: "g_object_dup_qdata",
    libgobj.}
proc replaceQdata*(`object`: GObject; quark: GQuark; oldval: Gpointer;
                         newval: Gpointer; destroy: GDestroyNotify;
                         oldDestroy: ptr GDestroyNotify): Gboolean {.
    importc: "g_object_replace_qdata", libgobj.}
proc getData*(`object`: GObject; key: cstring): Gpointer {.
    importc: "g_object_get_data", libgobj.}
proc data*(`object`: GObject; key: cstring): Gpointer {.
    importc: "g_object_get_data", libgobj.}
proc setData*(`object`: GObject; key: cstring; data: Gpointer) {.
    importc: "g_object_set_data", libgobj.}
proc `data=`*(`object`: GObject; key: cstring; data: Gpointer) {.
    importc: "g_object_set_data", libgobj.}
proc setDataFull*(`object`: GObject; key: cstring; data: Gpointer;
                        destroy: GDestroyNotify) {.
    importc: "g_object_set_data_full", libgobj.}
proc `dataFull=`*(`object`: GObject; key: cstring; data: Gpointer;
                        destroy: GDestroyNotify) {.
    importc: "g_object_set_data_full", libgobj.}
proc stealData*(`object`: GObject; key: cstring): Gpointer {.
    importc: "g_object_steal_data", libgobj.}
proc dupData*(`object`: GObject; key: cstring; dupFunc: GDuplicateFunc;
                    userData: Gpointer): Gpointer {.importc: "g_object_dup_data",
    libgobj.}
proc replaceData*(`object`: GObject; key: cstring; oldval: Gpointer;
                        newval: Gpointer; destroy: GDestroyNotify;
                        oldDestroy: ptr GDestroyNotify): Gboolean {.
    importc: "g_object_replace_data", libgobj.}
proc watchClosure*(`object`: GObject; closure: GClosure) {.
    importc: "g_object_watch_closure", libgobj.}
proc newCclosure*(callbackFunc: GCallback; `object`: GObject): GClosure {.
    importc: "g_cclosure_new_object", libgobj.}
proc newCclosureSwap*(callbackFunc: GCallback; `object`: GObject): GClosure {.
    importc: "g_cclosure_new_object_swap", libgobj.}
proc newClosure*(sizeofClosure: cuint; `object`: GObject): GClosure {.
    importc: "g_closure_new_object", libgobj.}
proc setObject*(value: GValue; vObject: Gpointer) {.
    importc: "g_value_set_object", libgobj.}
proc `object=`*(value: GValue; vObject: Gpointer) {.
    importc: "g_value_set_object", libgobj.}
proc getObject*(value: GValue): Gpointer {.importc: "g_value_get_object",
    libgobj.}
proc `object`*(value: GValue): Gpointer {.importc: "g_value_get_object",
    libgobj.}
proc dupObject*(value: GValue): Gpointer {.importc: "g_value_dup_object",
    libgobj.}
proc signalConnectObject*(instance: Gpointer; detailedSignal: cstring;
                          cHandler: GCallback; gobject: Gpointer;
                          connectFlags: GConnectFlags): culong {.
    importc: "g_signal_connect_object", libgobj.}

proc forceFloating*(`object`: GObject) {.
    importc: "g_object_force_floating", libgobj.}
proc runDispose*(`object`: GObject) {.importc: "g_object_run_dispose",
    libgobj.}
proc takeObject*(value: GValue; vObject: Gpointer) {.
    importc: "g_value_take_object", libgobj.}
proc setObjectTakeOwnership*(value: GValue; vObject: Gpointer) {.
    importc: "g_value_set_object_take_ownership", libgobj.}
proc `objectTakeOwnership=`*(value: GValue; vObject: Gpointer) {.
    importc: "g_value_set_object_take_ownership", libgobj.}
proc objectCompatControl*(what: Gsize; data: Gpointer): Gsize {.
    importc: "g_object_compat_control", libgobj.}

template gObjectWarnInvalidPropertyId*(`object`, propertyId, pspec: untyped): untyped =
  g_Object_Warn_Invalid_Pspec(`object`, "property", propertyId, pspec)

proc clearObject*(objectPtr: var GObject) {.importc: "g_clear_object", libgobj.}
template gClearObject*(objectPtr: untyped): untyped =
  clearPointer(objectPtr, gObjectUnref)

template gSetObject*(objectPtr, newObject: untyped): untyped =
  (if 0:
    (objectPtr)[] = newObject
    false else: (gSetObject)(cast[var GObject](objectPtr),
                            cast[GObject](newObject)))

type
  INNER_C_UNION_1468477625* {.union.} = object
    p*: Gpointer

  GWeakRef* =  ptr GWeakRefObj
  GWeakRefPtr* = ptr GWeakRefObj
  GWeakRefObj* = object
    priv*: INNER_C_UNION_1468477625

proc init*(weakRef: GWeakRef; `object`: Gpointer) {.
    importc: "g_weak_ref_init", libgobj.}
proc clear*(weakRef: GWeakRef) {.importc: "g_weak_ref_clear", libgobj.}
proc get*(weakRef: GWeakRef): Gpointer {.importc: "g_weak_ref_get",
    libgobj.}
proc set*(weakRef: GWeakRef; `object`: Gpointer) {.
    importc: "g_weak_ref_set", libgobj.}

template gTypeBindingFlags*(): untyped =
  (bindingFlagsGetType())

template gTypeBinding*(): untyped =
  (bindingGetType())

template gBinding*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeBinding, GBindingObj))

template gIsBinding*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeBinding))

type
  GBinding* =  ptr GBindingObj
  GBindingPtr* = ptr GBindingObj
  GBindingObj* = object
 

type
  GBindingTransformFunc* = proc (binding: GBinding; fromValue: GValue;
                              toValue: GValue; userData: Gpointer): Gboolean {.cdecl.}

type
  GBindingFlags* {.size: sizeof(cint), pure.} = enum
    DEFAULT = 0, BIDIRECTIONAL = 1 shl 0,
    SYNC_CREATE = 1 shl 1, INVERT_BOOLEAN = 1 shl 2

proc bindingFlagsGetType*(): GType {.importc: "g_binding_flags_get_type",
                                   libgobj.}
proc bindingGetType*(): GType {.importc: "g_binding_get_type", libgobj.}
proc getFlags*(binding: GBinding): GBindingFlags {.
    importc: "g_binding_get_flags", libgobj.}
proc getSource*(binding: GBinding): GObject {.
    importc: "g_binding_get_source", libgobj.}
proc source*(binding: GBinding): GObject {.
    importc: "g_binding_get_source", libgobj.}
proc getTarget*(binding: GBinding): GObject {.
    importc: "g_binding_get_target", libgobj.}
proc target*(binding: GBinding): GObject {.
    importc: "g_binding_get_target", libgobj.}
proc getSourceProperty*(binding: GBinding): cstring {.
    importc: "g_binding_get_source_property", libgobj.}
proc sourceProperty*(binding: GBinding): cstring {.
    importc: "g_binding_get_source_property", libgobj.}
proc getTargetProperty*(binding: GBinding): cstring {.
    importc: "g_binding_get_target_property", libgobj.}
proc targetProperty*(binding: GBinding): cstring {.
    importc: "g_binding_get_target_property", libgobj.}
proc unbind*(binding: GBinding) {.importc: "g_binding_unbind", libgobj.}
proc objectBindProperty*(source: Gpointer; sourceProperty: cstring;
                         target: Gpointer; targetProperty: cstring;
                         flags: GBindingFlags): GBinding {.
    importc: "g_object_bind_property", libgobj.}
proc objectBindPropertyFull*(source: Gpointer; sourceProperty: cstring;
                             target: Gpointer; targetProperty: cstring;
                             flags: GBindingFlags;
                             transformTo: GBindingTransformFunc;
                             transformFrom: GBindingTransformFunc;
                             userData: Gpointer; notify: GDestroyNotify): GBinding {.
    importc: "g_object_bind_property_full", libgobj.}
proc objectBindPropertyWithClosures*(source: Gpointer; sourceProperty: cstring;
                                     target: Gpointer; targetProperty: cstring;
                                     flags: GBindingFlags;
                                     transformTo: GClosure;
                                     transformFrom: GClosure): GBinding {.
    importc: "g_object_bind_property_with_closures", libgobj.}

template gTypeIsEnum*(`type`: untyped): untyped =
  (gTypeFundamental(`type`) == G_TYPE_ENUM)

template gEnumClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, G_TYPE_ENUM, GEnumClassObj))

template gIsEnumClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, G_TYPE_ENUM))

template gEnumClassType*(class: untyped): untyped =
  (gTypeFromClass(class))

template gEnumClassTypeName*(class: untyped): untyped =
  (name(gEnumClassType(class)))

template gTypeIsFlags*(`type`: untyped): untyped =
  (gTypeFundamental(`type`) == G_TYPE_FLAGS)

template gFlagsClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, G_TYPE_FLAGS, GFlagsClassObj))

template gIsFlagsClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, G_TYPE_FLAGS))

template gFlagsClassType*(class: untyped): untyped =
  (gTypeFromClass(class))

template gFlagsClassTypeName*(class: untyped): untyped =
  (name(gFlagsClassType(class)))

template gValueHoldsEnum*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_ENUM))

template gValueHoldsFlags*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_FLAGS))

type
  GEnumClass* =  ptr GEnumClassObj
  GEnumClassPtr* = ptr GEnumClassObj
  GEnumClassObj* = object of GTypeClassObj
    minimum*: cint
    maximum*: cint
    nValues*: cuint
    values*: GEnumValue

  GFlagsClass* =  ptr GFlagsClassObj
  GFlagsClassPtr* = ptr GFlagsClassObj
  GFlagsClassObj* = object of GTypeClassObj
    mask*: cuint
    nValues*: cuint
    values*: GFlagsValue

  GEnumValue* =  ptr GEnumValueObj
  GEnumValuePtr* = ptr GEnumValueObj
  GEnumValueObj* = object
    value*: cint
    valueName*: cstring
    valueNick*: cstring

  GFlagsValue* =  ptr GFlagsValueObj
  GFlagsValuePtr* = ptr GFlagsValueObj
  GFlagsValueObj* = object
    value*: cuint
    valueName*: cstring
    valueNick*: cstring

proc enumGetValue*(enumClass: GEnumClass; value: cint): GEnumValue {.
    importc: "g_enum_get_value", libgobj.}
proc enumGetValueByName*(enumClass: GEnumClass; name: cstring): GEnumValue {.
    importc: "g_enum_get_value_by_name", libgobj.}
proc enumGetValueByNick*(enumClass: GEnumClass; nick: cstring): GEnumValue {.
    importc: "g_enum_get_value_by_nick", libgobj.}
proc flagsGetFirstValue*(flagsClass: GFlagsClass; value: cuint): GFlagsValue {.
    importc: "g_flags_get_first_value", libgobj.}
proc flagsGetValueByName*(flagsClass: GFlagsClass; name: cstring): GFlagsValue {.
    importc: "g_flags_get_value_by_name", libgobj.}
proc flagsGetValueByNick*(flagsClass: GFlagsClass; nick: cstring): GFlagsValue {.
    importc: "g_flags_get_value_by_nick", libgobj.}
proc enumToString*(gEnumType: GType; value: cint): cstring {.
    importc: "g_enum_to_string", libgobj.}
proc flagsToString*(flagsType: GType; value: cuint): cstring {.
    importc: "g_flags_to_string", libgobj.}
proc setEnum*(value: var GValueObj; vEnum: cint) {.importc: "g_value_set_enum",
    libgobj.}
proc getEnum*(value: GValue): cint {.importc: "g_value_get_enum", libgobj.}
proc setFlags*(value: var GValueObj; vFlags: cuint) {.importc: "g_value_set_flags",
    libgobj.}
proc getFlags*(value: GValue): cuint {.importc: "g_value_get_flags",
    libgobj.}

proc enumRegisterStatic*(name: cstring; constStaticValues: GEnumValue): GType {.
    importc: "g_enum_register_static", libgobj.}
proc flagsRegisterStatic*(name: cstring; constStaticValues: GFlagsValue): GType {.
    importc: "g_flags_register_static", libgobj.}

proc enumCompleteTypeInfo*(gEnumType: GType; info: GTypeInfo;
                           constValues: GEnumValue) {.
    importc: "g_enum_complete_type_info", libgobj.}
proc flagsCompleteTypeInfo*(gFlagsType: GType; info: GTypeInfo;
                            constValues: GFlagsValue) {.
    importc: "g_flags_complete_type_info", libgobj.}

type
  GParamSpecChar* =  ptr GParamSpecCharObj
  GParamSpecCharPtr* = ptr GParamSpecCharObj
  GParamSpecCharObj*{.final.} = object of GParamSpecObj
    minimum*: int8
    maximum*: int8
    defaultValue*: int8

type
  GParamSpecUChar* =  ptr GParamSpecUCharObj
  GParamSpecUCharPtr* = ptr GParamSpecUCharObj
  GParamSpecUCharObj*{.final.} = object of GParamSpecObj
    minimum*: uint8
    maximum*: uint8
    defaultValue*: uint8

type
  GParamSpecBoolean* =  ptr GParamSpecBooleanObj
  GParamSpecBooleanPtr* = ptr GParamSpecBooleanObj
  GParamSpecBooleanObj*{.final.} = object of GParamSpecObj
    defaultValue*: Gboolean

type
  GParamSpecInt* =  ptr GParamSpecIntObj
  GParamSpecIntPtr* = ptr GParamSpecIntObj
  GParamSpecIntObj*{.final.} = object of GParamSpecObj
    minimum*: cint
    maximum*: cint
    defaultValue*: cint

type
  GParamSpecUInt* =  ptr GParamSpecUIntObj
  GParamSpecUIntPtr* = ptr GParamSpecUIntObj
  GParamSpecUIntObj*{.final.} = object of GParamSpecObj
    minimum*: cuint
    maximum*: cuint
    defaultValue*: cuint

type
  GParamSpecLong* =  ptr GParamSpecLongObj
  GParamSpecLongPtr* = ptr GParamSpecLongObj
  GParamSpecLongObj*{.final.} = object of GParamSpecObj
    minimum*: clong
    maximum*: clong
    defaultValue*: clong

type
  GParamSpecULong* =  ptr GParamSpecULongObj
  GParamSpecULongPtr* = ptr GParamSpecULongObj
  GParamSpecULongObj*{.final.} = object of GParamSpecObj
    minimum*: culong
    maximum*: culong
    defaultValue*: culong

type
  GParamSpecInt64* =  ptr GParamSpecInt64Obj
  GParamSpecInt64Ptr* = ptr GParamSpecInt64Obj
  GParamSpecInt64Obj*{.final.} = object of GParamSpecObj
    minimum*: int64
    maximum*: int64
    defaultValue*: int64

type
  GParamSpecUInt64* =  ptr GParamSpecUInt64Obj
  GParamSpecUInt64Ptr* = ptr GParamSpecUInt64Obj
  GParamSpecUInt64Obj*{.final.} = object of GParamSpecObj
    minimum*: uint64
    maximum*: uint64
    defaultValue*: uint64

type
  GParamSpecUnichar* =  ptr GParamSpecUnicharObj
  GParamSpecUnicharPtr* = ptr GParamSpecUnicharObj
  GParamSpecUnicharObj*{.final.} = object of GParamSpecObj
    defaultValue*: Gunichar

type
  GParamSpecEnum* =  ptr GParamSpecEnumObj
  GParamSpecEnumPtr* = ptr GParamSpecEnumObj
  GParamSpecEnumObj*{.final.} = object of GParamSpecObj
    enumClass*: GEnumClass
    defaultValue*: cint

type
  GParamSpecFlags* =  ptr GParamSpecFlagsObj
  GParamSpecFlagsPtr* = ptr GParamSpecFlagsObj
  GParamSpecFlagsObj*{.final.} = object of GParamSpecObj
    flagsClass*: GFlagsClass
    defaultValue*: cuint

type
  GParamSpecFloat* =  ptr GParamSpecFloatObj
  GParamSpecFloatPtr* = ptr GParamSpecFloatObj
  GParamSpecFloatObj*{.final.} = object of GParamSpecObj
    minimum*: cfloat
    maximum*: cfloat
    defaultValue*: cfloat
    epsilon*: cfloat

type
  GParamSpecDouble* =  ptr GParamSpecDoubleObj
  GParamSpecDoublePtr* = ptr GParamSpecDoubleObj
  GParamSpecDoubleObj*{.final.} = object of GParamSpecObj
    minimum*: cdouble
    maximum*: cdouble
    defaultValue*: cdouble
    epsilon*: cdouble

type
  GParamSpecString* =  ptr GParamSpecStringObj
  GParamSpecStringPtr* = ptr GParamSpecStringObj
  GParamSpecStringObj*{.final.} = object of GParamSpecObj
    defaultValue*: cstring
    csetFirst*: cstring
    csetNth*: cstring
    substitutor*: char
    nullFoldIfEmpty* {.bitsize: 1.}: cuint
    ensureNonNull* {.bitsize: 1.}: cuint

type
  GParamSpecParam* =  ptr GParamSpecParamObj
  GParamSpecParamPtr* = ptr GParamSpecParamObj
  GParamSpecParamObj*{.final.} = object of GParamSpecObj

type
  GParamSpecBoxed* =  ptr GParamSpecBoxedObj
  GParamSpecBoxedPtr* = ptr GParamSpecBoxedObj
  GParamSpecBoxedObj*{.final.} = object of GParamSpecObj

type
  GParamSpecPointer* =  ptr GParamSpecPointerObj
  GParamSpecPointerPtr* = ptr GParamSpecPointerObj
  GParamSpecPointerObj*{.final.} = object of GParamSpecObj

type
  GParamSpecValueArray* =  ptr GParamSpecValueArrayObj
  GParamSpecValueArrayPtr* = ptr GParamSpecValueArrayObj
  GParamSpecValueArrayObj*{.final.} = object of GParamSpecObj
    elementSpec*: GParamSpec
    fixedNElements*: cuint

type
  GParamSpecObject* =  ptr GParamSpecObjectObj
  GParamSpecObjectPtr* = ptr GParamSpecObjectObj
  GParamSpecObjectObj*{.final.} = object of GParamSpecObj

type
  GParamSpecOverride* =  ptr GParamSpecOverrideObj
  GParamSpecOverridePtr* = ptr GParamSpecOverrideObj
  GParamSpecOverrideObj*{.final.} = object of GParamSpecObj
    overridden*: GParamSpec

type
  GParamSpecGType* =  ptr GParamSpecGTypeObj
  GParamSpecGTypePtr* = ptr GParamSpecGTypeObj
  GParamSpecGTypeObj*{.final.} = object of GParamSpecObj
    isAType*: GType

type
  GParamSpecVariant* =  ptr GParamSpecVariantObj
  GParamSpecVariantPtr* = ptr GParamSpecVariantObj
  GParamSpecVariantObj*{.final.} = object of GParamSpecObj
    `type`*: GVariantType
    defaultValue*: GVariant
    padding: array[4, Gpointer]

proc paramSpecChar*(name: cstring; nick: cstring; blurb: cstring; minimum: int8;
                    maximum: int8; defaultValue: int8; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_char", libgobj.}
proc paramSpecUchar*(name: cstring; nick: cstring; blurb: cstring; minimum: uint8;
                     maximum: uint8; defaultValue: uint8; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_uchar", libgobj.}
proc paramSpecBoolean*(name: cstring; nick: cstring; blurb: cstring;
                       defaultValue: Gboolean; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_boolean", libgobj.}
proc paramSpecInt*(name: cstring; nick: cstring; blurb: cstring; minimum: cint;
                   maximum: cint; defaultValue: cint; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_int", libgobj.}
proc paramSpecUint*(name: cstring; nick: cstring; blurb: cstring; minimum: cuint;
                    maximum: cuint; defaultValue: cuint; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_uint", libgobj.}
proc paramSpecLong*(name: cstring; nick: cstring; blurb: cstring; minimum: clong;
                    maximum: clong; defaultValue: clong; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_long", libgobj.}
proc paramSpecUlong*(name: cstring; nick: cstring; blurb: cstring; minimum: culong;
                     maximum: culong; defaultValue: culong; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_ulong", libgobj.}
proc paramSpecInt64*(name: cstring; nick: cstring; blurb: cstring; minimum: int64;
                     maximum: int64; defaultValue: int64; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_int64", libgobj.}
proc paramSpecUint64*(name: cstring; nick: cstring; blurb: cstring; minimum: uint64;
                      maximum: uint64; defaultValue: uint64; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_uint64", libgobj.}
proc paramSpecUnichar*(name: cstring; nick: cstring; blurb: cstring;
                       defaultValue: Gunichar; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_unichar", libgobj.}
proc paramSpecEnum*(name: cstring; nick: cstring; blurb: cstring; enumType: GType;
                    defaultValue: cint; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_enum", libgobj.}
proc paramSpecFlags*(name: cstring; nick: cstring; blurb: cstring; flagsType: GType;
                     defaultValue: cuint; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_flags", libgobj.}
proc paramSpecFloat*(name: cstring; nick: cstring; blurb: cstring; minimum: cfloat;
                     maximum: cfloat; defaultValue: cfloat; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_float", libgobj.}
proc paramSpecDouble*(name: cstring; nick: cstring; blurb: cstring; minimum: cdouble;
                      maximum: cdouble; defaultValue: cdouble; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_double", libgobj.}
proc paramSpecString*(name: cstring; nick: cstring; blurb: cstring;
                      defaultValue: cstring; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_string", libgobj.}
proc paramSpecParam*(name: cstring; nick: cstring; blurb: cstring; paramType: GType;
                     flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_param", libgobj.}
proc paramSpecBoxed*(name: cstring; nick: cstring; blurb: cstring; boxedType: GType;
                     flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_boxed", libgobj.}
proc paramSpecPointer*(name: cstring; nick: cstring; blurb: cstring;
                       flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_pointer", libgobj.}
proc paramSpecValueArray*(name: cstring; nick: cstring; blurb: cstring;
                          elementSpec: GParamSpec; flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_value_array", libgobj.}
proc paramSpecObject*(name: cstring; nick: cstring; blurb: cstring; objectType: GType;
                      flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_object", libgobj.}
proc paramSpecOverride*(name: cstring; overridden: GParamSpec): GParamSpec {.
    importc: "g_param_spec_override", libgobj.}
proc paramSpecGtype*(name: cstring; nick: cstring; blurb: cstring; isAType: GType;
                     flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_gtype", libgobj.}
proc paramSpecVariant*(name: cstring; nick: cstring; blurb: cstring;
                       `type`: GVariantType; defaultValue: glib.GVariant;
                       flags: GParamFlags): GParamSpec {.
    importc: "g_param_spec_variant", libgobj.}

proc setClosure*(source: GSource; closure: GClosure) {.
    importc: "g_source_set_closure", libgobj.}

proc `closure=`*(source: GSource; closure: GClosure) {.
    importc: "g_source_set_closure", libgobj.}
proc setDummyCallback*(source: GSource) {.
    importc: "g_source_set_dummy_callback", libgobj.}
proc `dummyCallback=`*(source: GSource) {.
    importc: "g_source_set_dummy_callback", libgobj.}

template gTypeTypeModule*(): untyped =
  (typeModuleGetType())

template gTypeModule*(module: untyped): untyped =
  (gTypeCheckInstanceCast(module, gTypeTypeModule, GTypeModuleObj))

template gTypeModuleClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeTypeModule, GTypeModuleClassObj))

template gIsTypeModule*(module: untyped): untyped =
  (gTypeCheckInstanceType(module, gTypeTypeModule))

template gIsTypeModuleClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeTypeModule))

template gTypeModuleGetClass*(module: untyped): untyped =
  (gTypeInstanceGetClass(module, gTypeTypeModule, GTypeModuleClassObj))

type
  GTypeModule* =  ptr GTypeModuleObj
  GTypeModulePtr* = ptr GTypeModuleObj
  GTypeModuleObj*{.final.} = object of GObjectObj
    useCount*: cuint
    typeInfos*: GSList
    interfaceInfos*: GSList
    name*: cstring

type
  GTypeModuleClass* =  ptr GTypeModuleClassObj
  GTypeModuleClassPtr* = ptr GTypeModuleClassObj
  GTypeModuleClassObj*{.final.} = object of GObjectClassObj
    load*: proc (module: GTypeModule): Gboolean {.cdecl.}
    unload*: proc (module: GTypeModule) {.cdecl.}
    reserved1: proc () {.cdecl.}
    reserved2: proc () {.cdecl.}
    reserved3: proc () {.cdecl.}
    reserved4: proc () {.cdecl.}

template gImplementInterfaceDynamic*(type_Iface, ifaceInit: untyped): void =
  var gImplementInterfaceInfo: GInterfaceInfoObj
  addInterface(typeModule, gDefineTypeId, type_Iface,
                          addr(gImplementInterfaceInfo))

proc typeModuleGetType*(): GType {.importc: "g_type_module_get_type", libgobj.}
proc use*(module: GTypeModule): Gboolean {.
    importc: "g_type_module_use", libgobj.}
proc unuse*(module: GTypeModule) {.importc: "g_type_module_unuse",
    libgobj.}
proc setName*(module: GTypeModule; name: cstring) {.
    importc: "g_type_module_set_name", libgobj.}
proc `name=`*(module: GTypeModule; name: cstring) {.
    importc: "g_type_module_set_name", libgobj.}
proc registerType*(module: GTypeModule; parentType: GType;
                             typeName: cstring; typeInfo: GTypeInfo;
                             flags: GTypeFlags): GType {.
    importc: "g_type_module_register_type", libgobj.}
proc addInterface*(module: GTypeModule; instanceType: GType;
                             interfaceType: GType;
                             interfaceInfo: GInterfaceInfo) {.
    importc: "g_type_module_add_interface", libgobj.}
proc registerEnum*(module: GTypeModule; name: cstring;
                             constStaticValues: GEnumValue): GType {.
    importc: "g_type_module_register_enum", libgobj.}
proc registerFlags*(module: GTypeModule; name: cstring;
                              constStaticValues: GFlagsValue): GType {.
    importc: "g_type_module_register_flags", libgobj.}

template gTypeTypePlugin*(): untyped =
  (typePluginGetType())

template gTypePlugin*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTypePlugin, GTypePluginObj))

template gTypePluginClass*(vtable: untyped): untyped =
  (gTypeCheckClassCast(vtable, gTypeTypePlugin, GTypePluginClassObj))

template gIsTypePlugin*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTypePlugin))

template gIsTypePluginClass*(vtable: untyped): untyped =
  (gTypeCheckClassType(vtable, gTypeTypePlugin))

template gTypePluginGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeTypePlugin, GTypePluginClassObj))

type
  GTypePluginUse* = proc (plugin: GTypePlugin) {.cdecl.}

type
  GTypePluginUnuse* = proc (plugin: GTypePlugin) {.cdecl.}

type
  GTypePluginCompleteTypeInfo* = proc (plugin: GTypePlugin; gType: GType;
                                    info: GTypeInfo;
                                    valueTable: GTypeValueTable) {.cdecl.}

type
  GTypePluginCompleteInterfaceInfo* = proc (plugin: GTypePlugin;
      instanceType: GType; interfaceType: GType; info: GInterfaceInfo) {.cdecl.}

type
  GTypePluginClass* =  ptr GTypePluginClassObj
  GTypePluginClassPtr* = ptr GTypePluginClassObj
  GTypePluginClassObj* = object of GTypeInterfaceObj
    usePlugin*: GTypePluginUse
    unusePlugin*: GTypePluginUnuse
    completeTypeInfo*: GTypePluginCompleteTypeInfo
    completeInterfaceInfo*: GTypePluginCompleteInterfaceInfo

proc typePluginGetType*(): GType {.importc: "g_type_plugin_get_type", libgobj.}
proc use*(plugin: GTypePlugin) {.importc: "g_type_plugin_use",
    libgobj.}
proc unuse*(plugin: GTypePlugin) {.importc: "g_type_plugin_unuse",
    libgobj.}
proc completeTypeInfo*(plugin: GTypePlugin; gType: GType;
                                 info: GTypeInfo;
                                 valueTable: GTypeValueTable) {.
    importc: "g_type_plugin_complete_type_info", libgobj.}
proc completeInterfaceInfo*(plugin: GTypePlugin; instanceType: GType;
                                      interfaceType: GType;
                                      info: GInterfaceInfo) {.
    importc: "g_type_plugin_complete_interface_info", libgobj.}

template gTypeValueArray*(): untyped =
  (valueArrayGetType())

type
  GValueArray* =  ptr GValueArrayObj
  GValueArrayPtr* = ptr GValueArrayObj
  GValueArrayObj* = object
    nValues*: cuint
    values*: GValue
    nPrealloced*: cuint

proc valueArrayGetType*(): GType {.importc: "g_value_array_get_type", libgobj.}
proc getNth*(valueArray: GValueArray; index: cuint): GValue {.
    importc: "g_value_array_get_nth", libgobj.}
proc nth*(valueArray: GValueArray; index: cuint): GValue {.
    importc: "g_value_array_get_nth", libgobj.}
proc newValueArray*(nPrealloced: cuint): GValueArray {.
    importc: "g_value_array_new", libgobj.}
proc free*(valueArray: GValueArray) {.importc: "g_value_array_free",
    libgobj.}
proc copy*(valueArray: GValueArray): GValueArray {.
    importc: "g_value_array_copy", libgobj.}
proc prepend*(valueArray: GValueArray; value: GValue): GValueArray {.
    importc: "g_value_array_prepend", libgobj.}
proc append*(valueArray: GValueArray; value: GValue): GValueArray {.
    importc: "g_value_array_append", libgobj.}
proc insert*(valueArray: GValueArray; index: cuint; value: GValue): GValueArray {.
    importc: "g_value_array_insert", libgobj.}
proc remove*(valueArray: GValueArray; index: cuint): GValueArray {.
    importc: "g_value_array_remove", libgobj.}
proc sort*(valueArray: GValueArray; compareFunc: GCompareFunc): GValueArray {.
    importc: "g_value_array_sort", libgobj.}
proc sortWithData*(valueArray: GValueArray;
                             compareFunc: GCompareDataFunc; userData: Gpointer): GValueArray {.
    importc: "g_value_array_sort_with_data", libgobj.}

template gValueHoldsChar*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_CHAR))

template gValueHoldsUchar*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_UCHAR))

template gValueHoldsBoolean*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_BOOLEAN))

template gValueHoldsInt*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_INT))

template gValueHoldsUint*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_UINT))

template gValueHoldsLong*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_LONG))

template gValueHoldsUlong*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_ULONG))

template gValueHoldsInt64*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_INT64))

template gValueHoldsUint64*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_UINT64))

template gValueHoldsFloat*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_FLOAT))

template gValueHoldsDouble*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_DOUBLE))

template gValueHoldsString*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_STRING))

template gValueHoldsPointer*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_POINTER))

template gTypeGtype*(): untyped =
  (gtypeGetType())

template gValueHoldsGtype*(value: untyped): untyped =
  (gTypeCheckValueType(value, gTypeGtype))

template gValueHoldsVariant*(value: untyped): untyped =
  (gTypeCheckValueType(value, G_TYPE_VARIANT))

proc setChar*(value: var GValueObj; vChar: char) {.importc: "g_value_set_char",
    libgobj.}
proc getChar*(value: GValue): char {.importc: "g_value_get_char", libgobj.}
proc setSchar*(value: var GValueObj; vChar: int8) {.importc: "g_value_set_schar",
    libgobj.}
proc getSchar*(value: GValue): int8 {.importc: "g_value_get_schar",
    libgobj.}
proc setUchar*(value: var GValueObj; vUchar: cuchar) {.
    importc: "g_value_set_uchar", libgobj.}
proc getUchar*(value: GValue): cuchar {.importc: "g_value_get_uchar",
    libgobj.}
proc setBoolean*(value: var GValueObj; vBoolean: Gboolean) {.
    importc: "g_value_set_boolean", libgobj.}
proc getBoolean*(value: GValue): Gboolean {.importc: "g_value_get_boolean",
    libgobj.}
proc setInt*(value: var GValueObj; vInt: cint) {.importc: "g_value_set_int",
    libgobj.}
proc getInt*(value: GValue): cint {.importc: "g_value_get_int", libgobj.}
proc setUint*(value: var GValueObj; vUint: cuint) {.importc: "g_value_set_uint",
    libgobj.}
proc getUint*(value: GValue): cuint {.importc: "g_value_get_uint",
    libgobj.}
proc setLong*(value: var GValueObj; vLong: clong) {.importc: "g_value_set_long",
    libgobj.}
proc getLong*(value: GValue): clong {.importc: "g_value_get_long",
    libgobj.}
proc setUlong*(value: var GValueObj; vUlong: culong) {.
    importc: "g_value_set_ulong", libgobj.}
proc getUlong*(value: GValue): culong {.importc: "g_value_get_ulong",
    libgobj.}
proc setInt64*(value: var GValueObj; vInt64: int64) {.
    importc: "g_value_set_int64", libgobj.}
proc getInt64*(value: GValue): int64 {.importc: "g_value_get_int64",
    libgobj.}
proc setUint64*(value: var GValueObj; vUint64: uint64) {.
    importc: "g_value_set_uint64", libgobj.}
proc getUint64*(value: GValue): uint64 {.importc: "g_value_get_uint64",
    libgobj.}
proc setFloat*(value: var GValueObj; vFloat: cfloat) {.
    importc: "g_value_set_float", libgobj.}
proc getFloat*(value: GValue): cfloat {.importc: "g_value_get_float",
    libgobj.}
proc setDouble*(value: var GValueObj; vDouble: cdouble) {.
    importc: "g_value_set_double", libgobj.}
proc getDouble*(value: GValue): cdouble {.importc: "g_value_get_double",
    libgobj.}
proc setString*(value: var GValueObj; vString: cstring) {.
    importc: "g_value_set_string", libgobj.}
proc setStaticString*(value: GValue; vString: cstring) {.
    importc: "g_value_set_static_string", libgobj.}
proc `staticString=`*(value: GValue; vString: cstring) {.
    importc: "g_value_set_static_string", libgobj.}
proc getString*(value: GValue): cstring {.importc: "g_value_get_string",
    libgobj.}
proc dupString*(value: GValue): cstring {.importc: "g_value_dup_string",
    libgobj.}
proc setPointer*(value: GValue; vPointer: Gpointer) {.
    importc: "g_value_set_pointer", libgobj.}
proc getPointer*(value: GValue): Gpointer {.importc: "g_value_get_pointer",
    libgobj.}
proc gtypeGetType*(): GType {.importc: "g_gtype_get_type", libgobj.}
proc setGtype*(value: GValue; vGtype: GType) {.importc: "g_value_set_gtype",
    libgobj.}
proc `gtype=`*(value: GValue; vGtype: GType) {.importc: "g_value_set_gtype",
    libgobj.}
proc getGtype*(value: GValue): GType {.importc: "g_value_get_gtype",
    libgobj.}
proc gtype*(value: GValue): GType {.importc: "g_value_get_gtype",
    libgobj.}
proc setVariant*(value: GValue; variant: GVariant) {.
    importc: "g_value_set_variant", libgobj.}
proc `variant=`*(value: GValue; variant: GVariant) {.
    importc: "g_value_set_variant", libgobj.}
proc takeVariant*(value: GValue; variant: GVariant) {.
    importc: "g_value_take_variant", libgobj.}
proc getVariant*(value: GValue): GVariant {.
    importc: "g_value_get_variant", libgobj.}
proc variant*(value: GValue): GVariant {.
    importc: "g_value_get_variant", libgobj.}
proc dupVariant*(value: GValue): GVariant {.
    importc: "g_value_dup_variant", libgobj.}

proc pointerTypeRegisterStatic*(name: cstring): GType {.
    importc: "g_pointer_type_register_static", libgobj.}

proc strdupValueContents*(value: GValue): cstring {.
    importc: "g_strdup_value_contents", libgobj.}
proc takeString*(value: GValue; vString: cstring) {.
    importc: "g_value_take_string", libgobj.}
proc setStringTakeOwnership*(value: GValue; vString: cstring) {.
    importc: "g_value_set_string_take_ownership", libgobj.}
proc `stringTakeOwnership=`*(value: GValue; vString: cstring) {.
    importc: "g_value_set_string_take_ownership", libgobj.}

type
  Gchararray* = cstring

# manual extensions for gobject.nim
#

template gCallback*(f: untyped): untyped =
  cast[GCallback](f)

# typeIface: The GType of the interface to add
# ifaceInit: The interface init function
proc implementInterfaceStr*(typeIface, ifaceInit: string): string {.cdecl.} =
  """
var gImplementInterfaceInfo = GInterfaceInfoObj(interfaceInit: cast[GInterfaceInitFunc](\$2),
                                                     interfaceFinalize: nil,
                                                     interfaceData: nil)
addInterfaceStatic(gDefineTypeId, \$1, addr(gImplementInterfaceInfo))

""" % [typeIface, ifaceInit]

# Below is the original C description -- but we use nep1 style 
# tn: The name of the new type, in Camel case.
# t: The name of the new type, in lowercase, with words separated by _.
# tp: The GType of the parent type.
# f: GTypeFlags to pass to gTypeRegisterStatic()
# c: Custom code that gets inserted in the *GetType() function.
macro gDefineTypeExtended*(tn, t, tp, f, c: static[string]): void =
  var
    cc = indent("\n" & c, 4)
    s = """

proc $2Init(self: $1) {.cdecl.}
proc $2ClassInit(klass: $1Class) {.cdecl.}
var $2ParentClass: Gpointer = nil
var $1PrivateOffset: cint
proc $2ClassInternInit(klass: Gpointer) {.cdecl.} =
  $2ParentClass = typeClassPeekParent(klass)
  if $1PrivateOffset != 0:
    typeClassAdjustPrivateOffset(klass, $1PrivateOffset)

  $2ClassInit(cast[$1Class](klass))
  
proc $2GetInstancePrivate(self: $1): $1Private {.cdecl.} =
  return cast[$1Private](gStructMemberP(self, $1PrivateOffset))

proc $2GetType*(): GType {.cdecl.} =
  var gDefineTypeIdVolatile {.global.}: Gsize = 0
  if onceInitEnter(addr(gDefineTypeIdVolatile)):
    var gDefineTypeId: GType = registerStaticSimple($3,
                                      internStaticString("$1"),
                                      sizeof($1ClassObj).cuint,
                                      cast[GClassInitFunc]($2ClassInternInit),
                                      sizeof($1Obj).cuint,
                                      cast[GInstanceInitFunc]($2Init),
                                      cast[GTypeFlags]($4))
    $5
    onceInitLeave(addr(gDefineTypeIdVolatile), gDefineTypeId)
  return gDefineTypeIdVolatile

""" % [tn, t, tp, f, cc]
  #echo s
  result = parseStmt(s)

macro gDefineTypeExtendedNoPriv*(tn, t, tp, f: static[string]): void =
  var
    s = """

proc $2Init(self: $1) {.cdecl.}
proc $2ClassInit(klass: $1Class) {.cdecl.}
var $2ParentClass: Gpointer = nil
proc $2ClassInternInit(klass: Gpointer) {.cdecl.} =
  $2ParentClass = typeClassPeekParent(klass)

  $2ClassInit(cast[$1Class](klass))
  
proc $2GetType*(): GType {.cdecl.} =
  var gDefineTypeIdVolatile {.global.}: Gsize = 0
  if onceInitEnter(addr(gDefineTypeIdVolatile)):
    var gDefineTypeId: GType = registerStaticSimple($3,
                                      internStaticString("$1"),
                                      sizeof($1ClassObj).cuint,
                                      cast[GClassInitFunc]($2ClassInternInit),
                                      sizeof($1Obj).cuint,
                                      cast[GInstanceInitFunc]($2Init),
                                      cast[GTypeFlags]($4))
    onceInitLeave(addr(gDefineTypeIdVolatile), gDefineTypeId)
  return gDefineTypeIdVolatile

""" % [tn, t, tp, f]
  #echo s
  result = parseStmt(s)

template gDefineTypeExtended*(tn, tp, f: untyped; c: string) =
  const tnn = astToStr(tn)
  const t = toLowerAscii(tnn[0]) & substr(tnn, 1)
  when c == "":
    gDefineTypeExtendedNoPriv(tnn, t, astToStr(tp), astToStr(f))
  else:
    gDefineTypeExtended(tnn, t, astToStr(tp), astToStr(f), c)

template offsetof*(typ, field): untyped = (var dummy: typ; cast[system.int](addr(dummy.field)) - cast[system.int](addr(dummy)))

template gStructOffset*(typ, field): untyped = (var dummy: `typ Obj`; clong(cast[system.int](addr(dummy.field)) - cast[system.int](addr(dummy))))

template gPrivateOffset*(typ, field): untyped = (var dummy: `typ PrivateObj`; clong(`typ privateOffset` + cast[system.int](addr(dummy.field)) - cast[system.int](addr(dummy))))

template gStructMemberP*(structP, structOffset): untyped =
  (cast[Gpointer]((cast[system.int](structP) + (clong)(structOffset))))

template gDefineTypeExtendedClassInit*(TypeName, typeName): string =
  """
  proc $2ClassInternInit(klass: Gpointer) {.cdecl.} =
    $2ParentClass = gTypeClassPeekParent (klass)
    if $1PrivateOffset != 0:
      gTypeClassAdjustPrivateIffset(klass, addr $1PrivateOffset)
    $2ClassInit(cast[ptr $1Class](klass))

""" % [TypeName, typeName]

template gAddPrivate*(TypeName): untyped =
  `TypeName privateOffset` = addInstancePrivate(gDefineTypeId, sizeof(`TypeName PrivateObj`))

template gDefineType*(TN, TP): untyped =
  gDefineTypeExtended(TN, TP, 0, "")

template gDefineTypeWithPrivate*(TN, TP): untyped =
  gDefineTypeExtended(TN, TP, 0, "gAddPrivate(" & astToStr(TN) & ")")

