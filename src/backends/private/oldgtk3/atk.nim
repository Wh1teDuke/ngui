{.deadCodeElim: on.}

when defined(windows):
  const LIB_ATK = "libatk-1.0-0.dll"
elif defined(macosx):
  const LIB_ATK = "libatk-1.0(|-0).dylib"
else:
  const LIB_ATK = "libatk-1.0.so(|.0)"

{.pragma: libatk, cdecl, dynlib: LIB_ATK.}

from glib import GSListObj, Gboolean, Gpointer, Gunichar

from gobject import GValue, GValueObj, GSignalEmissionHook, GType, GObject, GObjectObj, GObjectClassObj, GTypeInterfaceObj

type
  StateType* {.size: sizeof(cint), pure.} = enum
    INVALID, ACTIVE, ARMED, BUSY,
    CHECKED, DEFUNCT, EDITABLE, ENABLED,
    EXPANDABLE, EXPANDED, FOCUSABLE,
    FOCUSED, HORIZONTAL, ICONIFIED, MODAL,
    MULTI_LINE, MULTISELECTABLE, OPAQUE,
    PRESSED, RESIZABLE, SELECTABLE,
    SELECTED, SENSITIVE, SHOWING,
    SINGLE_LINE, STALE, TRANSIENT,
    VERTICAL, VISIBLE, MANAGES_DESCENDANTS,
    INDETERMINATE, TRUNCATED, REQUIRED,
    INVALID_ENTRY, SUPPORTS_AUTOCOMPLETION,
    SELECTABLE_TEXT, DEFAULT, ANIMATED,
    VISITED, CHECKABLE, HAS_POPUP,
    HAS_TOOLTIP, READ_ONLY, LAST_DEFINED
  State* = uint64

proc stateTypeRegister*(name: cstring): StateType {.
    importc: "atk_state_type_register", libatk.}
proc getName*(`type`: StateType): cstring {.
    importc: "atk_state_type_get_name", libatk.}
proc name*(`type`: StateType): cstring {.
    importc: "atk_state_type_get_name", libatk.}
proc stateTypeForName*(name: cstring): StateType {.
    importc: "atk_state_type_for_name", libatk.}

type
  RelationType* {.size: sizeof(cint), pure.} = enum
    NULL = 0, CONTROLLED_BY, CONTROLLER_FOR,
    LABEL_FOR, LABELLED_BY, MEMBER_OF,
    NODE_CHILD_OF, FLOWS_TO, FLOWS_FROM,
    SUBWINDOW_OF, EMBEDS, EMBEDDED_BY,
    POPUP_FOR, PARENT_WINDOW_OF,
    DESCRIBED_BY, DESCRIPTION_FOR,
    NODE_PARENT_OF, DETAILS, DETAILS_FOR,
    ERROR_MESSAGE, ERROR_FOR, LAST_DEFINED

type
  Role* {.size: sizeof(cint), pure.} = enum
    INVALID = 0, ACCEL_LABEL, ALERT, ANIMATION,
    ARROW, CALENDAR, CANVAS, CHECK_BOX,
    CHECK_MENU_ITEM, COLOR_CHOOSER, COLUMN_HEADER,
    COMBO_BOX, DATE_EDITOR, DESKTOP_ICON,
    DESKTOP_FRAME, DIAL, DIALOG,
    DIRECTORY_PANE, DRAWING_AREA, FILE_CHOOSER,
    FILLER, FONT_CHOOSER, FRAME, GLASS_PANE,
    HTML_CONTAINER, ICON, IMAGE,
    INTERNAL_FRAME, LABEL, LAYERED_PANE, LIST,
    LIST_ITEM, MENU, MENU_BAR, MENU_ITEM,
    OPTION_PANE, PAGE_TAB, PAGE_TAB_LIST,
    PANEL, PASSWORD_TEXT, POPUP_MENU,
    PROGRESS_BAR, PUSH_BUTTON, RADIO_BUTTON,
    RADIO_MENU_ITEM, ROOT_PANE, ROW_HEADER,
    SCROLL_BAR, SCROLL_PANE, SEPARATOR, SLIDER,
    SPLIT_PANE, SPIN_BUTTON, STATUSBAR, TABLE,
    TABLE_CELL, TABLE_COLUMN_HEADER, TABLE_ROW_HEADER,
    TEAR_OFF_MENU_ITEM, TERMINAL, TEXT,
    TOGGLE_BUTTON, TOOL_BAR, TOOL_TIP, TREE,
    TREE_TABLE, UNKNOWN, VIEWPORT, WINDOW,
    HEADER, FOOTER, PARAGRAPH, RULER,
    APPLICATION, AUTOCOMPLETE, EDITBAR,
    EMBEDDED, ENTRY, CHART, CAPTION,
    DOCUMENT_FRAME, HEADING, PAGE, SECTION,
    REDUNDANT_OBJECT, FORM, LINK,
    INPUT_METHOD_WINDOW, TABLE_ROW, TREE_ITEM,
    DOCUMENT_SPREADSHEET, DOCUMENT_PRESENTATION,
    DOCUMENT_TEXT, DOCUMENT_WEB, DOCUMENT_EMAIL,
    COMMENT, LIST_BOX, GROUPING, IMAGE_MAP,
    NOTIFICATION, INFO_BAR, LEVEL_BAR,
    TITLE_BAR, BLOCK_QUOTE, AUDIO, VIDEO,
    DEFINITION, ARTICLE, LANDMARK, LOG,
    MARQUEE, MATH, RATING, TIMER,
    DESCRIPTION_LIST, DESCRIPTION_TERM,
    DESCRIPTION_VALUE, `STATIC` MATH_FRACTION,
    MATH_ROOT, SUBSCRIPT, SUPERSCRIPT,
    FOOTNOTE, LAST_DEFINED

type
  Layer* {.size: sizeof(cint), pure.} = enum
    INVALID, BACKGROUND, CANVAS, WIDGET,
    MDI, POPUP, OVERLAY, WINDOW

type
  AttributeSet* =  ptr AttributeSetObj
  AttributeSetPtr* = ptr AttributeSetObj
  AttributeSetObj* = GSListObj

type
  Attribute* =  ptr AttributeObj
  AttributePtr* = ptr AttributeObj
  AttributeObj* = object
    name*: cstring
    value*: cstring

  RelationSet* =  ptr RelationSetObj
  RelationSetPtr* = ptr RelationSetObj
  RelationSetObj*{.final.} = object of GObjectObj
    relations*: glib.GPtrArray

  Object* =  ptr ObjectObj
  ObjectPtr* = ptr ObjectObj
  ObjectObj* = object of GObjectObj
    description*: cstring
    name*: cstring
    accessibleParent*: Object
    role*: Role
    relationSet*: RelationSet
    layer*: Layer

  PropertyValues* =  ptr PropertyValuesObj
  PropertyValuesPtr* = ptr PropertyValuesObj
  PropertyValuesObj* = object
    propertyName*: cstring
    oldValue*: gobject.GValueObj
    newValue*: gobject.GValueObj

  StateSet* =  ptr StateSetObj
  StateSetPtr* = ptr StateSetObj
  StateSetObj*{.final.} = object of GObjectObj
type
  PropertyChangeHandler* = proc (obj: Object; vals: PropertyValues) {.cdecl.}
  Implementor* =  ptr ImplementorObj
  ImplementorPtr* = ptr ImplementorObj
  ImplementorObj* = object
type
  Function* = proc (userData: Gpointer): Gboolean {.cdecl.}

  ObjectClass* =  ptr ObjectClassObj
  ObjectClassPtr* = ptr ObjectClassObj
  ObjectClassObj* = object of GObjectClassObj
    getName*: proc (accessible: Object): cstring {.cdecl.}
    getDescription*: proc (accessible: Object): cstring {.cdecl.}
    getParent*: proc (accessible: Object): Object {.cdecl.}
    getNChildren*: proc (accessible: Object): cint {.cdecl.}
    refChild*: proc (accessible: Object; i: cint): Object {.cdecl.}
    getIndexInParent*: proc (accessible: Object): cint {.cdecl.}
    refRelationSet*: proc (accessible: Object): RelationSet {.cdecl.}
    getRole*: proc (accessible: Object): Role {.cdecl.}
    getLayer*: proc (accessible: Object): Layer {.cdecl.}
    getMdiZorder*: proc (accessible: Object): cint {.cdecl.}
    refStateSet*: proc (accessible: Object): StateSet {.cdecl.}
    setName*: proc (accessible: Object; name: cstring) {.cdecl.}
    setDescription*: proc (accessible: Object; description: cstring) {.cdecl.}
    setParent*: proc (accessible: Object; parent: Object) {.cdecl.}
    setRole*: proc (accessible: Object; role: Role) {.cdecl.}
    connectPropertyChangeHandler*: proc (accessible: Object;
                                       handler: ptr PropertyChangeHandler): cuint {.cdecl.}
    removePropertyChangeHandler*: proc (accessible: Object; handlerId: cuint) {.cdecl.}
    initialize*: proc (accessible: Object; data: Gpointer) {.cdecl.}
    childrenChanged*: proc (accessible: Object; changeIndex: cuint;
                          changedChild: Gpointer) {.cdecl.}
    focusEvent*: proc (accessible: Object; focusIn: Gboolean) {.cdecl.}
    propertyChange*: proc (accessible: Object; values: PropertyValues) {.cdecl.}
    stateChange*: proc (accessible: Object; name: cstring; stateSet: Gboolean) {.cdecl.}
    visibleDataChanged*: proc (accessible: Object) {.cdecl.}
    activeDescendantChanged*: proc (accessible: Object; child: var Gpointer) {.cdecl.}
    getAttributes*: proc (accessible: Object): AttributeSet {.cdecl.}
    getObjectLocale*: proc (accessible: Object): cstring {.cdecl.}
    pad01*: Function

  ImplementorIface* =  ptr ImplementorIfaceObj
  ImplementorIfacePtr* = ptr ImplementorIfaceObj
  ImplementorIfaceObj*{.final.} = object of GTypeInterfaceObj
    refAccessible*: proc (implementor: Implementor): Object {.cdecl.}

template typeObject*(): untyped =
  (objectGetType())

template `object`*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeObject, ObjectObj))

template objectClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeObject, ObjectClassObj))

template isObject*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeObject))

template isObjectClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeObject))

template objectGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeObject, ObjectClassObj))

template typeImplementor*(): untyped =
  (implementorGetType())

template isImplementor*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeImplementor)

template implementor*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeImplementor, ImplementorObj)

template implementorGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeImplementor, ImplementorIfaceObj))

proc objectGetType*(): GType {.importc: "atk_object_get_type", libatk.}

proc implementorGetType*(): GType {.importc: "atk_implementor_get_type",
                                    libatk.}
proc refAccessible*(implementor: Implementor): Object {.
    importc: "atk_implementor_ref_accessible", libatk.}

proc getName*(accessible: Object): cstring {.
    importc: "atk_object_get_name", libatk.}

proc name*(accessible: Object): cstring {.
    importc: "atk_object_get_name", libatk.}
proc getDescription*(accessible: Object): cstring {.
    importc: "atk_object_get_description", libatk.}
proc description*(accessible: Object): cstring {.
    importc: "atk_object_get_description", libatk.}
proc getParent*(accessible: Object): Object {.
    importc: "atk_object_get_parent", libatk.}
proc parent*(accessible: Object): Object {.
    importc: "atk_object_get_parent", libatk.}
proc peekParent*(accessible: Object): Object {.
    importc: "atk_object_peek_parent", libatk.}
proc getNAccessibleChildren*(accessible: Object): cint {.
    importc: "atk_object_get_n_accessible_children", libatk.}
proc nAccessibleChildren*(accessible: Object): cint {.
    importc: "atk_object_get_n_accessible_children", libatk.}
proc refAccessibleChild*(accessible: Object; i: cint): Object {.
    importc: "atk_object_ref_accessible_child", libatk.}
proc refRelationSet*(accessible: Object): RelationSet {.
    importc: "atk_object_ref_relation_set", libatk.}
proc getRole*(accessible: Object): Role {.
    importc: "atk_object_get_role", libatk.}
proc role*(accessible: Object): Role {.
    importc: "atk_object_get_role", libatk.}
proc getLayer*(accessible: Object): Layer {.
    importc: "atk_object_get_layer", libatk.}
proc layer*(accessible: Object): Layer {.
    importc: "atk_object_get_layer", libatk.}
proc getMdiZorder*(accessible: Object): cint {.
    importc: "atk_object_get_mdi_zorder", libatk.}
proc mdiZorder*(accessible: Object): cint {.
    importc: "atk_object_get_mdi_zorder", libatk.}
proc getAttributes*(accessible: Object): AttributeSet {.
    importc: "atk_object_get_attributes", libatk.}
proc attributes*(accessible: Object): AttributeSet {.
    importc: "atk_object_get_attributes", libatk.}
proc refStateSet*(accessible: Object): StateSet {.
    importc: "atk_object_ref_state_set", libatk.}
proc getIndexInParent*(accessible: Object): cint {.
    importc: "atk_object_get_index_in_parent", libatk.}
proc indexInParent*(accessible: Object): cint {.
    importc: "atk_object_get_index_in_parent", libatk.}
proc setName*(accessible: Object; name: cstring) {.
    importc: "atk_object_set_name", libatk.}
proc `name=`*(accessible: Object; name: cstring) {.
    importc: "atk_object_set_name", libatk.}
proc setDescription*(accessible: Object; description: cstring) {.
    importc: "atk_object_set_description", libatk.}
proc `description=`*(accessible: Object; description: cstring) {.
    importc: "atk_object_set_description", libatk.}
proc setParent*(accessible: Object; parent: Object) {.
    importc: "atk_object_set_parent", libatk.}
proc `parent=`*(accessible: Object; parent: Object) {.
    importc: "atk_object_set_parent", libatk.}
proc setRole*(accessible: Object; role: Role) {.
    importc: "atk_object_set_role", libatk.}
proc `role=`*(accessible: Object; role: Role) {.
    importc: "atk_object_set_role", libatk.}
proc connectPropertyChangeHandler*(accessible: Object;
    handler: ptr PropertyChangeHandler): cuint {.
    importc: "atk_object_connect_property_change_handler", libatk.}
proc removePropertyChangeHandler*(accessible: Object;
    handlerId: cuint) {.importc: "atk_object_remove_property_change_handler",
                      libatk.}
proc notifyStateChange*(accessible: Object; state: State;
                                value: Gboolean) {.
    importc: "atk_object_notify_state_change", libatk.}
proc initialize*(accessible: Object; data: Gpointer) {.
    importc: "atk_object_initialize", libatk.}
proc getName*(role: Role): cstring {.importc: "atk_role_get_name",
    libatk.}
proc name*(role: Role): cstring {.importc: "atk_role_get_name",
    libatk.}
proc roleForName*(name: cstring): Role {.importc: "atk_role_for_name",
    libatk.}

proc addRelationship*(`object`: Object;
                              relationship: RelationType; target: Object): Gboolean {.
    importc: "atk_object_add_relationship", libatk.}
proc removeRelationship*(`object`: Object;
                                 relationship: RelationType;
                                 target: Object): Gboolean {.
    importc: "atk_object_remove_relationship", libatk.}
proc getLocalizedName*(role: Role): cstring {.
    importc: "atk_role_get_localized_name", libatk.}
proc localizedName*(role: Role): cstring {.
    importc: "atk_role_get_localized_name", libatk.}
proc roleRegister*(name: cstring): Role {.importc: "atk_role_register",
    libatk.}
proc getObjectLocale*(accessible: Object): cstring {.
    importc: "atk_object_get_object_locale", libatk.}
proc objectLocale*(accessible: Object): cstring {.
    importc: "atk_object_get_object_locale", libatk.}

type
  Action* =  ptr ActionObj
  ActionPtr* = ptr ActionObj
  ActionObj* = object

  ActionIface* =  ptr ActionIfaceObj
  ActionIfacePtr* = ptr ActionIfaceObj
  ActionIfaceObj*{.final.} = object of GTypeInterfaceObj
    doAction*: proc (action: Action; i: cint): Gboolean {.cdecl.}
    getNActions*: proc (action: Action): cint {.cdecl.}
    getDescription*: proc (action: Action; i: cint): cstring {.cdecl.}
    getName*: proc (action: Action; i: cint): cstring {.cdecl.}
    getKeybinding*: proc (action: Action; i: cint): cstring {.cdecl.}
    setDescription*: proc (action: Action; i: cint; desc: cstring): Gboolean {.cdecl.}
    getLocalizedName*: proc (action: Action; i: cint): cstring {.cdecl.}

template typeAction*(): untyped =
  (actionGetType())

template isAction*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeAction)

template action*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeAction, ActionObj)

template actionGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeAction, ActionIfaceObj))

proc actionGetType*(): GType {.importc: "atk_action_get_type", libatk.}

proc doAction*(action: Action; i: cint): Gboolean {.
    importc: "atk_action_do_action", libatk.}
proc getNActions*(action: Action): cint {.
    importc: "atk_action_get_n_actions", libatk.}
proc nActions*(action: Action): cint {.
    importc: "atk_action_get_n_actions", libatk.}
proc getDescription*(action: Action; i: cint): cstring {.
    importc: "atk_action_get_description", libatk.}
proc description*(action: Action; i: cint): cstring {.
    importc: "atk_action_get_description", libatk.}
proc getName*(action: Action; i: cint): cstring {.
    importc: "atk_action_get_name", libatk.}
proc name*(action: Action; i: cint): cstring {.
    importc: "atk_action_get_name", libatk.}
proc getKeybinding*(action: Action; i: cint): cstring {.
    importc: "atk_action_get_keybinding", libatk.}
proc keybinding*(action: Action; i: cint): cstring {.
    importc: "atk_action_get_keybinding", libatk.}
proc setDescription*(action: Action; i: cint; desc: cstring): Gboolean {.
    importc: "atk_action_set_description", libatk.}

proc getLocalizedName*(action: Action; i: cint): cstring {.
    importc: "atk_action_get_localized_name", libatk.}

proc localizedName*(action: Action; i: cint): cstring {.
    importc: "atk_action_get_localized_name", libatk.}

type
  Util* =  ptr UtilObj
  UtilPtr* = ptr UtilObj
  UtilObj*{.final.} = object of GObjectObj
type
  KeySnoopFunc* = proc (event: KeyEventStruct; userData: Gpointer): cint {.cdecl.}

  KeyEventStruct* =  ptr KeyEventStructObj
  KeyEventStructPtr* = ptr KeyEventStructObj
  KeyEventStructObj* = object
    `type`*: cint
    state*: cuint
    keyval*: cuint
    length*: cint
    string*: cstring
    keycode*: uint16
    timestamp*: uint32

  UtilClass* =  ptr UtilClassObj
  UtilClassPtr* = ptr UtilClassObj
  UtilClassObj*{.final.} = object of GObjectClassObj
    addGlobalEventListener*: proc (listener: GSignalEmissionHook; eventType: cstring): cuint {.cdecl.}
    removeGlobalEventListener*: proc (listenerId: cuint) {.cdecl.}
    addKeyEventListener*: proc (listener: KeySnoopFunc; data: Gpointer): cuint {.cdecl.}
    removeKeyEventListener*: proc (listenerId: cuint) {.cdecl.}
    getRoot*: proc (): Object {.cdecl.}
    getToolkitName*: proc (): cstring {.cdecl.}
    getToolkitVersion*: proc (): cstring {.cdecl.}

template typeUtil*(): untyped =
  (utilGetType())

template isUtil*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeUtil)

template util*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeUtil, UtilObj)

template utilClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeUtil, UtilClassObj))

template isUtilClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeUtil))

template utilGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeUtil, UtilClassObj))

type
  EventListener* = proc (obj: Object) {.cdecl.}

type
  EventListenerInit* = proc () {.cdecl.}

type
  KeyEventType* {.size: sizeof(cint), pure.} = enum
    PRESS, RELEASE, LAST_DEFINED

proc utilGetType*(): GType {.importc: "atk_util_get_type", libatk.}

type
  CoordType* {.size: sizeof(cint), pure.} = enum
    XY_SCREEN, XY_WINDOW

proc addFocusTracker*(focusTracker: EventListener): cuint {.
    importc: "atk_add_focus_tracker", libatk.}
proc removeFocusTracker*(trackerId: cuint) {.
    importc: "atk_remove_focus_tracker", libatk.}
proc focusTrackerInit*(init: EventListenerInit) {.
    importc: "atk_focus_tracker_init", libatk.}
proc focusTrackerNotify*(`object`: Object) {.
    importc: "atk_focus_tracker_notify", libatk.}
proc addGlobalEventListener*(listener: GSignalEmissionHook; eventType: cstring): cuint {.
    importc: "atk_add_global_event_listener", libatk.}
proc removeGlobalEventListener*(listenerId: cuint) {.
    importc: "atk_remove_global_event_listener", libatk.}
proc addKeyEventListener*(listener: KeySnoopFunc; data: Gpointer): cuint {.
    importc: "atk_add_key_event_listener", libatk.}
proc removeKeyEventListener*(listenerId: cuint) {.
    importc: "atk_remove_key_event_listener", libatk.}
proc getRoot*(): Object {.importc: "atk_get_root", libatk.}
proc root*(): Object {.importc: "atk_get_root", libatk.}
proc getFocusObject*(): Object {.importc: "atk_get_focus_object",
                                       libatk.}
proc focusObject*(): Object {.importc: "atk_get_focus_object",
                                       libatk.}
proc getToolkitName*(): cstring {.importc: "atk_get_toolkit_name", libatk.}
proc toolkitName*(): cstring {.importc: "atk_get_toolkit_name", libatk.}
proc getToolkitVersion*(): cstring {.importc: "atk_get_toolkit_version",
                                     libatk.}
proc toolkitVersion*(): cstring {.importc: "atk_get_toolkit_version",
                                     libatk.}
proc getVersion*(): cstring {.importc: "atk_get_version", libatk.}
proc version*(): cstring {.importc: "atk_get_version", libatk.}

type
  Rectangle* =  ptr RectangleObj
  RectanglePtr* = ptr RectangleObj
  RectangleObj* = object
    x*: cint
    y*: cint
    width*: cint
    height*: cint

type
  FocusHandler* = proc (`object`: Object; focusIn: Gboolean) {.cdecl.}
  Component* =  ptr ComponentObj
  ComponentPtr* = ptr ComponentObj
  ComponentObj* = object

  ComponentIface* =  ptr ComponentIfaceObj
  ComponentIfacePtr* = ptr ComponentIfaceObj
  ComponentIfaceObj*{.final.} = object of GTypeInterfaceObj
    addFocusHandler*: proc (component: Component; handler: FocusHandler): cuint {.cdecl.}
    contains*: proc (component: Component; x: cint; y: cint;
                   coordType: CoordType): Gboolean {.cdecl.}
    refAccessibleAtPoint*: proc (component: Component; x: cint; y: cint;
                               coordType: CoordType): Object {.cdecl.}
    getExtents*: proc (component: Component; x: var cint; y: var cint;
                     width: var cint; height: var cint; coordType: CoordType) {.cdecl.}
    getPosition*: proc (component: Component; x: var cint; y: var cint;
                      coordType: CoordType) {.cdecl.}
    getSize*: proc (component: Component; width: var cint; height: var cint) {.cdecl.}
    grabFocus*: proc (component: Component): Gboolean {.cdecl.}
    removeFocusHandler*: proc (component: Component; handlerId: cuint) {.cdecl.}
    setExtents*: proc (component: Component; x: cint; y: cint; width: cint;
                     height: cint; coordType: CoordType): Gboolean {.cdecl.}
    setPosition*: proc (component: Component; x: cint; y: cint;
                      coordType: CoordType): Gboolean {.cdecl.}
    setSize*: proc (component: Component; width: cint; height: cint): Gboolean {.cdecl.}
    getLayer*: proc (component: Component): Layer {.cdecl.}
    getMdiZorder*: proc (component: Component): cint {.cdecl.}
    boundsChanged*: proc (component: Component; bounds: Rectangle) {.cdecl.}
    getAlpha*: proc (component: Component): cdouble {.cdecl.}

template typeComponent*(): untyped =
  (componentGetType())

template isComponent*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeComponent)

template component*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeComponent, ComponentObj)

template componentGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeComponent, ComponentIfaceObj))

proc rectangleGetType*(): GType {.importc: "atk_rectangle_get_type", libatk.}
template typeRectangle*(): untyped =
  (rectangleGetType())

proc componentGetType*(): GType {.importc: "atk_component_get_type", libatk.}

proc addFocusHandler*(component: Component;
                                 handler: FocusHandler): cuint {.
    importc: "atk_component_add_focus_handler", libatk.}
proc contains*(component: Component; x: cint; y: cint;
                          coordType: CoordType): Gboolean {.
    importc: "atk_component_contains", libatk.}
proc refAccessibleAtPoint*(component: Component; x: cint; y: cint;
                                      coordType: CoordType): Object {.
    importc: "atk_component_ref_accessible_at_point", libatk.}
proc getExtents*(component: Component; x: var cint; y: var cint;
                            width: var cint; height: var cint; coordType: CoordType) {.
    importc: "atk_component_get_extents", libatk.}
proc getPosition*(component: Component; x: var cint; y: var cint;
                             coordType: CoordType) {.
    importc: "atk_component_get_position", libatk.}
proc getSize*(component: Component; width: var cint;
                         height: var cint) {.importc: "atk_component_get_size",
    libatk.}
proc getLayer*(component: Component): Layer {.
    importc: "atk_component_get_layer", libatk.}
proc layer*(component: Component): Layer {.
    importc: "atk_component_get_layer", libatk.}
proc getMdiZorder*(component: Component): cint {.
    importc: "atk_component_get_mdi_zorder", libatk.}
proc mdiZorder*(component: Component): cint {.
    importc: "atk_component_get_mdi_zorder", libatk.}
proc grabFocus*(component: Component): Gboolean {.
    importc: "atk_component_grab_focus", libatk.}
proc removeFocusHandler*(component: Component; handlerId: cuint) {.
    importc: "atk_component_remove_focus_handler", libatk.}
proc setExtents*(component: Component; x: cint; y: cint; width: cint;
                            height: cint; coordType: CoordType): Gboolean {.
    importc: "atk_component_set_extents", libatk.}
proc setPosition*(component: Component; x: cint; y: cint;
                             coordType: CoordType): Gboolean {.
    importc: "atk_component_set_position", libatk.}
proc setSize*(component: Component; width: cint; height: cint): Gboolean {.
    importc: "atk_component_set_size", libatk.}
proc getAlpha*(component: Component): cdouble {.
    importc: "atk_component_get_alpha", libatk.}
proc alpha*(component: Component): cdouble {.
    importc: "atk_component_get_alpha", libatk.}

type
  Document* =  ptr DocumentObj
  DocumentPtr* = ptr DocumentObj
  DocumentObj* = object

  DocumentIface* =  ptr DocumentIfaceObj
  DocumentIfacePtr* = ptr DocumentIfaceObj
  DocumentIfaceObj*{.final.} = object of GTypeInterfaceObj
    getDocumentType*: proc (document: Document): cstring {.cdecl.}
    getDocument*: proc (document: Document): Gpointer {.cdecl.}
    getDocumentLocale*: proc (document: Document): cstring {.cdecl.}
    getDocumentAttributes*: proc (document: Document): AttributeSet {.cdecl.}
    getDocumentAttributeValue*: proc (document: Document;
                                    attributeName: cstring): cstring {.cdecl.}
    setDocumentAttribute*: proc (document: Document; attributeName: cstring;
                               attributeValue: cstring): Gboolean {.cdecl.}
    getCurrentPageNumber*: proc (document: Document): cint {.cdecl.}
    getPageCount*: proc (document: Document): cint {.cdecl.}

template typeDocument*(): untyped =
  (documentGetType())

template isDocument*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeDocument)

template document*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeDocument, DocumentObj)

template documentGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeDocument, DocumentIfaceObj))

proc documentGetType*(): GType {.importc: "atk_document_get_type", libatk.}
proc getDocumentType*(document: Document): cstring {.
    importc: "atk_document_get_document_type", libatk.}
proc documentType*(document: Document): cstring {.
    importc: "atk_document_get_document_type", libatk.}
proc getDocument*(document: Document): Gpointer {.
    importc: "atk_document_get_document", libatk.}
proc document*(document: Document): Gpointer {.
    importc: "atk_document_get_document", libatk.}
proc getLocale*(document: Document): cstring {.
    importc: "atk_document_get_locale", libatk.}
proc locale*(document: Document): cstring {.
    importc: "atk_document_get_locale", libatk.}
proc getAttributes*(document: Document): AttributeSet {.
    importc: "atk_document_get_attributes", libatk.}
proc attributes*(document: Document): AttributeSet {.
    importc: "atk_document_get_attributes", libatk.}
proc getAttributeValue*(document: Document; attributeName: cstring): cstring {.
    importc: "atk_document_get_attribute_value", libatk.}
proc attributeValue*(document: Document; attributeName: cstring): cstring {.
    importc: "atk_document_get_attribute_value", libatk.}
proc setAttributeValue*(document: Document;
                                  attributeName: cstring; attributeValue: cstring): Gboolean {.
    importc: "atk_document_set_attribute_value", libatk.}
proc getCurrentPageNumber*(document: Document): cint {.
    importc: "atk_document_get_current_page_number", libatk.}
proc currentPageNumber*(document: Document): cint {.
    importc: "atk_document_get_current_page_number", libatk.}
proc getPageCount*(document: Document): cint {.
    importc: "atk_document_get_page_count", libatk.}
proc pageCount*(document: Document): cint {.
    importc: "atk_document_get_page_count", libatk.}

type
  TextAttribute* {.size: sizeof(cint), pure.} = enum
    INVALID = 0, LEFT_MARGIN,
    RIGHT_MARGIN, INDENT, INVISIBLE,
    EDITABLE, PIXELS_ABOVE_LINES,
    PIXELS_BELOW_LINES, PIXELS_INSIDE_WRAP,
    BG_FULL_HEIGHT, RISE, UNDERLINE,
    STRIKETHROUGH, SIZE, SCALE,
    WEIGHT, LANGUAGE, FAMILY_NAME,
    BG_COLOR, FG_COLOR, BG_STIPPLE,
    FG_STIPPLE, WRAP_MODE, DIRECTION,
    JUSTIFICATION, STRETCH, VARIANT,
    STYLE, LAST_DEFINED
  Text* =  ptr TextObj
  TextPtr* = ptr TextObj
  TextObj* = object

type
  TextBoundary* {.size: sizeof(cint), pure.} = enum
    CHAR, WORD_START,
    WORD_END, SENTENCE_START,
    SENTENCE_END, LINE_START,
    LINE_END

type
  TextGranularity* {.size: sizeof(cint), pure.} = enum
    CHAR, WORD,
    SENTENCE, LINE,
    PARAGRAPH

type
  TextRectangle* =  ptr TextRectangleObj
  TextRectanglePtr* = ptr TextRectangleObj
  TextRectangleObj* = object
    x*: cint
    y*: cint
    width*: cint
    height*: cint

type
  TextRange* =  ptr TextRangeObj
  TextRangePtr* = ptr TextRangeObj
  TextRangeObj* = object
    bounds*: TextRectangleObj
    startOffset*: cint
    endOffset*: cint
    content*: cstring
type
  TextClipType* {.size: sizeof(cint), pure.} = enum
    NONE, MIN, MAX, BOTH
type
  TextIface* =  ptr TextIfaceObj
  TextIfacePtr* = ptr TextIfaceObj
  TextIfaceObj*{.final.} = object of GTypeInterfaceObj
    getText*: proc (text: Text; startOffset: cint; endOffset: cint): cstring {.cdecl.}
    getTextAfterOffset*: proc (text: Text; offset: cint;
                             boundaryType: TextBoundary; startOffset: var cint;
                             endOffset: var cint): cstring {.cdecl.}
    getTextAtOffset*: proc (text: Text; offset: cint;
                          boundaryType: TextBoundary; startOffset: var cint;
                          endOffset: var cint): cstring {.cdecl.}
    getCharacterAtOffset*: proc (text: Text; offset: cint): Gunichar {.cdecl.}
    getTextBeforeOffset*: proc (text: Text; offset: cint;
                              boundaryType: TextBoundary;
                              startOffset: var cint; endOffset: var cint): cstring {.cdecl.}
    getCaretOffset*: proc (text: Text): cint {.cdecl.}
    getRunAttributes*: proc (text: Text; offset: cint; startOffset: var cint;
                           endOffset: var cint): AttributeSet {.cdecl.}
    getDefaultAttributes*: proc (text: Text): AttributeSet {.cdecl.}
    getCharacterExtents*: proc (text: Text; offset: cint; x: var cint; y: var cint;
                              width: var cint; height: var cint; coords: CoordType) {.cdecl.}
    getCharacterCount*: proc (text: Text): cint {.cdecl.}
    getOffsetAtPoint*: proc (text: Text; x: cint; y: cint; coords: CoordType): cint {.cdecl.}
    getNSelections*: proc (text: Text): cint {.cdecl.}
    getSelection*: proc (text: Text; selectionNum: cint; startOffset: var cint;
                       endOffset: var cint): cstring {.cdecl.}
    addSelection*: proc (text: Text; startOffset: cint; endOffset: cint): Gboolean {.cdecl.}
    removeSelection*: proc (text: Text; selectionNum: cint): Gboolean {.cdecl.}
    setSelection*: proc (text: Text; selectionNum: cint; startOffset: cint;
                       endOffset: cint): Gboolean {.cdecl.}
    setCaretOffset*: proc (text: Text; offset: cint): Gboolean {.cdecl.}
    textChanged*: proc (text: Text; position: cint; length: cint) {.cdecl.}
    textCaretMoved*: proc (text: Text; location: cint) {.cdecl.}
    textSelectionChanged*: proc (text: Text) {.cdecl.}
    textAttributesChanged*: proc (text: Text) {.cdecl.}
    getRangeExtents*: proc (text: Text; startOffset: cint; endOffset: cint;
                          coordType: CoordType; rect: TextRectangle) {.cdecl.}
    getBoundedRanges*: proc (text: Text; rect: TextRectangle;
                           coordType: CoordType; xClipType: TextClipType;
                           yClipType: TextClipType): ptr TextRange {.cdecl.}
    getStringAtOffset*: proc (text: Text; offset: cint;
                            granularity: TextGranularity;
                            startOffset: var cint; endOffset: var cint): cstring {.cdecl.}

proc textAttributeRegister*(name: cstring): TextAttribute {.
    importc: "atk_text_attribute_register", libatk.}
template typeText*(): untyped =
  (textGetType())

template isText*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeText)

template text*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeText, TextObj)

template textGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeText, TextIfaceObj))

proc textRangeGetType*(): GType {.importc: "atk_text_range_get_type", libatk.}

proc textGetType*(): GType {.importc: "atk_text_get_type", libatk.}

proc getText*(text: Text; startOffset: cint; endOffset: cint): cstring {.
    importc: "atk_text_get_text", libatk.}

proc text*(text: Text; startOffset: cint; endOffset: cint): cstring {.
    importc: "atk_text_get_text", libatk.}
proc getCharacterAtOffset*(text: Text; offset: cint): Gunichar {.
    importc: "atk_text_get_character_at_offset", libatk.}
proc characterAtOffset*(text: Text; offset: cint): Gunichar {.
    importc: "atk_text_get_character_at_offset", libatk.}
proc getTextAfterOffset*(text: Text; offset: cint;
                               boundaryType: TextBoundary;
                               startOffset: var cint; endOffset: var cint): cstring {.
    importc: "atk_text_get_text_after_offset", libatk.}
proc textAfterOffset*(text: Text; offset: cint;
                               boundaryType: TextBoundary;
                               startOffset: var cint; endOffset: var cint): cstring {.
    importc: "atk_text_get_text_after_offset", libatk.}
proc getTextAtOffset*(text: Text; offset: cint;
                            boundaryType: TextBoundary; startOffset: var cint;
                            endOffset: var cint): cstring {.
    importc: "atk_text_get_text_at_offset", libatk.}
proc textAtOffset*(text: Text; offset: cint;
                            boundaryType: TextBoundary; startOffset: var cint;
                            endOffset: var cint): cstring {.
    importc: "atk_text_get_text_at_offset", libatk.}
proc getTextBeforeOffset*(text: Text; offset: cint;
                                boundaryType: TextBoundary;
                                startOffset: var cint; endOffset: var cint): cstring {.
    importc: "atk_text_get_text_before_offset", libatk.}
proc textBeforeOffset*(text: Text; offset: cint;
                                boundaryType: TextBoundary;
                                startOffset: var cint; endOffset: var cint): cstring {.
    importc: "atk_text_get_text_before_offset", libatk.}
proc getStringAtOffset*(text: Text; offset: cint;
                              granularity: TextGranularity;
                              startOffset: var cint; endOffset: var cint): cstring {.
    importc: "atk_text_get_string_at_offset", libatk.}
proc stringAtOffset*(text: Text; offset: cint;
                              granularity: TextGranularity;
                              startOffset: var cint; endOffset: var cint): cstring {.
    importc: "atk_text_get_string_at_offset", libatk.}
proc getCaretOffset*(text: Text): cint {.
    importc: "atk_text_get_caret_offset", libatk.}
proc caretOffset*(text: Text): cint {.
    importc: "atk_text_get_caret_offset", libatk.}
proc getCharacterExtents*(text: Text; offset: cint; x: var cint;
                                y: var cint; width: var cint; height: var cint;
                                coords: CoordType) {.
    importc: "atk_text_get_character_extents", libatk.}
proc getRunAttributes*(text: Text; offset: cint; startOffset: var cint;
                             endOffset: var cint): AttributeSet {.
    importc: "atk_text_get_run_attributes", libatk.}
proc runAttributes*(text: Text; offset: cint; startOffset: var cint;
                             endOffset: var cint): AttributeSet {.
    importc: "atk_text_get_run_attributes", libatk.}
proc getDefaultAttributes*(text: Text): AttributeSet {.
    importc: "atk_text_get_default_attributes", libatk.}
proc defaultAttributes*(text: Text): AttributeSet {.
    importc: "atk_text_get_default_attributes", libatk.}
proc getCharacterCount*(text: Text): cint {.
    importc: "atk_text_get_character_count", libatk.}
proc characterCount*(text: Text): cint {.
    importc: "atk_text_get_character_count", libatk.}
proc getOffsetAtPoint*(text: Text; x: cint; y: cint; coords: CoordType): cint {.
    importc: "atk_text_get_offset_at_point", libatk.}
proc offsetAtPoint*(text: Text; x: cint; y: cint; coords: CoordType): cint {.
    importc: "atk_text_get_offset_at_point", libatk.}
proc getNSelections*(text: Text): cint {.
    importc: "atk_text_get_n_selections", libatk.}
proc nSelections*(text: Text): cint {.
    importc: "atk_text_get_n_selections", libatk.}
proc getSelection*(text: Text; selectionNum: cint;
                         startOffset: var cint; endOffset: var cint): cstring {.
    importc: "atk_text_get_selection", libatk.}
proc selection*(text: Text; selectionNum: cint;
                         startOffset: var cint; endOffset: var cint): cstring {.
    importc: "atk_text_get_selection", libatk.}
proc addSelection*(text: Text; startOffset: cint; endOffset: cint): Gboolean {.
    importc: "atk_text_add_selection", libatk.}
proc removeSelection*(text: Text; selectionNum: cint): Gboolean {.
    importc: "atk_text_remove_selection", libatk.}
proc setSelection*(text: Text; selectionNum: cint; startOffset: cint;
                         endOffset: cint): Gboolean {.
    importc: "atk_text_set_selection", libatk.}
proc setCaretOffset*(text: Text; offset: cint): Gboolean {.
    importc: "atk_text_set_caret_offset", libatk.}
proc getRangeExtents*(text: Text; startOffset: cint; endOffset: cint;
                            coordType: CoordType; rect: var TextRectangleObj) {.
    importc: "atk_text_get_range_extents", libatk.}
proc getBoundedRanges*(text: Text; rect: TextRectangle;
                             coordType: CoordType; xClipType: TextClipType;
                             yClipType: TextClipType): ptr TextRange {.
    importc: "atk_text_get_bounded_ranges", libatk.}
proc boundedRanges*(text: Text; rect: TextRectangle;
                             coordType: CoordType; xClipType: TextClipType;
                             yClipType: TextClipType): ptr TextRange {.
    importc: "atk_text_get_bounded_ranges", libatk.}
proc textFreeRanges*(ranges: var TextRange) {.
    importc: "atk_text_free_ranges", libatk.}
proc free*(attribSet: AttributeSet) {.
    importc: "atk_attribute_set_free", libatk.}
proc getName*(attr: TextAttribute): cstring {.
    importc: "atk_text_attribute_get_name", libatk.}
proc name*(attr: TextAttribute): cstring {.
    importc: "atk_text_attribute_get_name", libatk.}
proc textAttributeForName*(name: cstring): TextAttribute {.
    importc: "atk_text_attribute_for_name", libatk.}
proc getValue*(attr: TextAttribute; index: cint): cstring {.
    importc: "atk_text_attribute_get_value", libatk.}
proc value*(attr: TextAttribute; index: cint): cstring {.
    importc: "atk_text_attribute_get_value", libatk.}

type
  EditableText* =  ptr EditableTextObj
  EditableTextPtr* = ptr EditableTextObj
  EditableTextObj* = object

  EditableTextIface* =  ptr EditableTextIfaceObj
  EditableTextIfacePtr* = ptr EditableTextIfaceObj
  EditableTextIfaceObj*{.final.} = object of GTypeInterfaceObj
    setRunAttributes*: proc (text: EditableText;
                           attribSet: AttributeSet; startOffset: cint;
                           endOffset: cint): Gboolean {.cdecl.}
    setTextContents*: proc (text: EditableText; string: cstring) {.cdecl.}
    insertText*: proc (text: EditableText; string: cstring; length: cint;
                     position: var cint) {.cdecl.}
    copyText*: proc (text: EditableText; startPos: cint; endPos: cint) {.cdecl.}
    cutText*: proc (text: EditableText; startPos: cint; endPos: cint) {.cdecl.}
    deleteText*: proc (text: EditableText; startPos: cint; endPos: cint) {.cdecl.}
    pasteText*: proc (text: EditableText; position: cint) {.cdecl.}

template typeEditableText*(): untyped =
  (editableTextGetType())

template isEditableText*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeEditableText)

template editableText*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeEditableText, EditableTextObj)

template editableTextGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeEditableText, EditableTextIfaceObj))

proc editableTextGetType*(): GType {.importc: "atk_editable_text_get_type",
                                     libatk.}
proc setRunAttributes*(text: EditableText;
                                     attribSet: AttributeSet;
                                     startOffset: cint; endOffset: cint): Gboolean {.
    importc: "atk_editable_text_set_run_attributes", libatk.}
proc setTextContents*(text: EditableText; string: cstring) {.
    importc: "atk_editable_text_set_text_contents", libatk.}
proc `textContents=`*(text: EditableText; string: cstring) {.
    importc: "atk_editable_text_set_text_contents", libatk.}
proc insertText*(text: EditableText; string: cstring;
                               length: cint; position: var cint) {.
    importc: "atk_editable_text_insert_text", libatk.}
proc copyText*(text: EditableText; startPos: cint; endPos: cint) {.
    importc: "atk_editable_text_copy_text", libatk.}
proc cutText*(text: EditableText; startPos: cint; endPos: cint) {.
    importc: "atk_editable_text_cut_text", libatk.}
proc deleteText*(text: EditableText; startPos: cint;
                               endPos: cint) {.
    importc: "atk_editable_text_delete_text", libatk.}
proc pasteText*(text: EditableText; position: cint) {.
    importc: "atk_editable_text_paste_text", libatk.}

proc hyperlinkStateFlagsGetType*(): GType {.
    importc: "atk_hyperlink_state_flags_get_type", libatk.}
template typeHyperlinkStateFlags*(): untyped =
  (hyperlinkStateFlagsGetType())

proc roleGetType*(): GType {.importc: "atk_role_get_type", libatk.}
template typeRole*(): untyped =
  (roleGetType())

proc layerGetType*(): GType {.importc: "atk_layer_get_type", libatk.}
template typeLayer*(): untyped =
  (layerGetType())

proc relationTypeGetType*(): GType {.importc: "atk_relation_type_get_type",
                                     libatk.}
template typeRelationType*(): untyped =
  (relationTypeGetType())

proc stateTypeGetType*(): GType {.importc: "atk_state_type_get_type", libatk.}
template typeStateType*(): untyped =
  (stateTypeGetType())

proc textAttributeGetType*(): GType {.importc: "atk_text_attribute_get_type",
                                      libatk.}
template typeTextAttribute*(): untyped =
  (textAttributeGetType())

proc textBoundaryGetType*(): GType {.importc: "atk_text_boundary_get_type",
                                     libatk.}
template typeTextBoundary*(): untyped =
  (textBoundaryGetType())

proc textGranularityGetType*(): GType {.importc: "atk_text_granularity_get_type",
                                        libatk.}
template typeTextGranularity*(): untyped =
  (textGranularityGetType())

proc textClipTypeGetType*(): GType {.importc: "atk_text_clip_type_get_type",
                                     libatk.}
template typeTextClipType*(): untyped =
  (textClipTypeGetType())

proc keyEventTypeGetType*(): GType {.importc: "atk_key_event_type_get_type",
                                     libatk.}
template typeKeyEventType*(): untyped =
  (keyEventTypeGetType())

proc coordTypeGetType*(): GType {.importc: "atk_coord_type_get_type", libatk.}
template typeCoordType*(): untyped =
  (coordTypeGetType())

proc valueTypeGetType*(): GType {.importc: "atk_value_type_get_type", libatk.}
template typeValueType*(): untyped =
  (valueTypeGetType())

type
  GObjectAccessibleClass* =  ptr GObjectAccessibleClassObj
  GObjectAccessibleClassPtr* = ptr GObjectAccessibleClassObj
  GObjectAccessibleClassObj*{.final.} = object of ObjectClassObj
    pad1*: Function
    pad2*: Function

  GObjectAccessible* =  ptr GObjectAccessibleObj
  GObjectAccessiblePtr* = ptr GObjectAccessibleObj
  GObjectAccessibleObj*{.final.} = object of ObjectObj

template typeGobjectAccessible*(): untyped =
  (gobjectAccessibleGetType())

template gobjectAccessible*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeGobjectAccessible, GObjectAccessibleObj))

template gobjectAccessibleClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeGobjectAccessible, GObjectAccessibleClassObj))

template isGobjectAccessible*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeGobjectAccessible))

template isGobjectAccessibleClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeGobjectAccessible))

template gobjectAccessibleGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeGobjectAccessible, GObjectAccessibleClassObj))

proc gobjectAccessibleGetType*(): GType {.
    importc: "atk_gobject_accessible_get_type", libatk.}
proc gobjectAccessibleForObject*(obj: GObject): Object {.
    importc: "atk_gobject_accessible_for_object", libatk.}
proc gobjectAccessibleGetObject*(obj: GObjectAccessible): GObject {.
    importc: "atk_gobject_accessible_get_object", libatk.}

type
  HyperlinkStateFlags* {.size: sizeof(cint), pure.} = enum
    IS_INLINE = 1 shl 0

type
  Hyperlink* =  ptr HyperlinkObj
  HyperlinkPtr* = ptr HyperlinkObj
  HyperlinkObj*{.final.} = object of GObjectObj

  HyperlinkClass* =  ptr HyperlinkClassObj
  HyperlinkClassPtr* = ptr HyperlinkClassObj
  HyperlinkClassObj*{.final.} = object of GObjectClassObj
    getUri*: proc (link: Hyperlink; i: cint): cstring {.cdecl.}
    getObject*: proc (link: Hyperlink; i: cint): Object {.cdecl.}
    getEndIndex*: proc (link: Hyperlink): cint {.cdecl.}
    getStartIndex*: proc (link: Hyperlink): cint {.cdecl.}
    isValid*: proc (link: Hyperlink): Gboolean {.cdecl.}
    getNAnchors*: proc (link: Hyperlink): cint {.cdecl.}
    linkState*: proc (link: Hyperlink): cuint {.cdecl.}
    isSelectedLink*: proc (link: Hyperlink): Gboolean {.cdecl.}
    linkActivated*: proc (link: Hyperlink) {.cdecl.}
    pad1*: Function

template typeHyperlink*(): untyped =
  (hyperlinkGetType())

template hyperlink*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeHyperlink, HyperlinkObj))

template hyperlinkClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeHyperlink, HyperlinkClassObj))

template isHyperlink*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeHyperlink))

template isHyperlinkClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeHyperlink))

template hyperlinkGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeHyperlink, HyperlinkClassObj))

proc hyperlinkGetType*(): GType {.importc: "atk_hyperlink_get_type", libatk.}
proc getUri*(link: Hyperlink; i: cint): cstring {.
    importc: "atk_hyperlink_get_uri", libatk.}
proc uri*(link: Hyperlink; i: cint): cstring {.
    importc: "atk_hyperlink_get_uri", libatk.}
proc getObject*(link: Hyperlink; i: cint): Object {.
    importc: "atk_hyperlink_get_object", libatk.}
proc `object`*(link: Hyperlink; i: cint): Object {.
    importc: "atk_hyperlink_get_object", libatk.}
proc getEndIndex*(link: Hyperlink): cint {.
    importc: "atk_hyperlink_get_end_index", libatk.}
proc endIndex*(link: Hyperlink): cint {.
    importc: "atk_hyperlink_get_end_index", libatk.}
proc getStartIndex*(link: Hyperlink): cint {.
    importc: "atk_hyperlink_get_start_index", libatk.}
proc startIndex*(link: Hyperlink): cint {.
    importc: "atk_hyperlink_get_start_index", libatk.}
proc isValid*(link: Hyperlink): Gboolean {.
    importc: "atk_hyperlink_is_valid", libatk.}
proc isInline*(link: Hyperlink): Gboolean {.
    importc: "atk_hyperlink_is_inline", libatk.}
proc getNAnchors*(link: Hyperlink): cint {.
    importc: "atk_hyperlink_get_n_anchors", libatk.}
proc nAnchors*(link: Hyperlink): cint {.
    importc: "atk_hyperlink_get_n_anchors", libatk.}
proc isSelectedLink*(link: Hyperlink): Gboolean {.
    importc: "atk_hyperlink_is_selected_link", libatk.}

type
  HyperlinkImpl* =  ptr HyperlinkImplObj
  HyperlinkImplPtr* = ptr HyperlinkImplObj
  HyperlinkImplObj* = object

  HyperlinkImplIface* =  ptr HyperlinkImplIfaceObj
  HyperlinkImplIfacePtr* = ptr HyperlinkImplIfaceObj
  HyperlinkImplIfaceObj*{.final.} = object of GTypeInterfaceObj
    getHyperlink*: proc (impl: HyperlinkImpl): Hyperlink {.cdecl.}

template typeHyperlinkImpl*(): untyped =
  (hyperlinkImplGetType())

template isHyperlinkImpl*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeHyperlinkImpl)

template hyperlinkImpl*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeHyperlinkImpl, HyperlinkImplObj)

template hyperlinkImplGetIface*(obj: untyped): untyped =
  gTypeInstanceGetInterface(obj, typeHyperlinkImpl,
                                atkHyperlinkImplIface)

proc hyperlinkImplGetType*(): GType {.importc: "atk_hyperlink_impl_get_type",
                                      libatk.}
proc getHyperlink*(impl: HyperlinkImpl): Hyperlink {.
    importc: "atk_hyperlink_impl_get_hyperlink", libatk.}
proc hyperlink*(impl: HyperlinkImpl): Hyperlink {.
    importc: "atk_hyperlink_impl_get_hyperlink", libatk.}

type
  Hypertext* =  ptr HypertextObj
  HypertextPtr* = ptr HypertextObj
  HypertextObj* = object

  HypertextIface* =  ptr HypertextIfaceObj
  HypertextIfacePtr* = ptr HypertextIfaceObj
  HypertextIfaceObj*{.final.} = object of GTypeInterfaceObj
    getLink*: proc (hypertext: Hypertext; linkIndex: cint): Hyperlink {.cdecl.}
    getNLinks*: proc (hypertext: Hypertext): cint {.cdecl.}
    getLinkIndex*: proc (hypertext: Hypertext; charIndex: cint): cint {.cdecl.}
    linkSelected*: proc (hypertext: Hypertext; linkIndex: cint) {.cdecl.}

template typeHypertext*(): untyped =
  (hypertextGetType())

template isHypertext*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeHypertext)

template hypertext*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeHypertext, HypertextObj)

template hypertextGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeHypertext, HypertextIfaceObj))

proc hypertextGetType*(): GType {.importc: "atk_hypertext_get_type", libatk.}
proc getLink*(hypertext: Hypertext; linkIndex: cint): Hyperlink {.
    importc: "atk_hypertext_get_link", libatk.}
proc link*(hypertext: Hypertext; linkIndex: cint): Hyperlink {.
    importc: "atk_hypertext_get_link", libatk.}
proc getNLinks*(hypertext: Hypertext): cint {.
    importc: "atk_hypertext_get_n_links", libatk.}
proc nLinks*(hypertext: Hypertext): cint {.
    importc: "atk_hypertext_get_n_links", libatk.}
proc getLinkIndex*(hypertext: Hypertext; charIndex: cint): cint {.
    importc: "atk_hypertext_get_link_index", libatk.}
proc linkIndex*(hypertext: Hypertext; charIndex: cint): cint {.
    importc: "atk_hypertext_get_link_index", libatk.}

type
  Image* =  ptr ImageObj
  ImagePtr* = ptr ImageObj
  ImageObj* = object

  ImageIface* =  ptr ImageIfaceObj
  ImageIfacePtr* = ptr ImageIfaceObj
  ImageIfaceObj*{.final.} = object of GTypeInterfaceObj
    getImagePosition*: proc (image: Image; x: var cint; y: var cint;
                           coordType: CoordType) {.cdecl.}
    getImageDescription*: proc (image: Image): cstring {.cdecl.}
    getImageSize*: proc (image: Image; width: var cint; height: var cint) {.cdecl.}
    setImageDescription*: proc (image: Image; description: cstring): Gboolean {.cdecl.}
    getImageLocale*: proc (image: Image): cstring {.cdecl.}

template typeImage*(): untyped =
  (imageGetType())

template isImage*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeImage)

template image*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeImage, ImageObj)

template imageGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeImage, ImageIfaceObj))

proc imageGetType*(): GType {.importc: "atk_image_get_type", libatk.}
proc getImageDescription*(image: Image): cstring {.
    importc: "atk_image_get_image_description", libatk.}
proc imageDescription*(image: Image): cstring {.
    importc: "atk_image_get_image_description", libatk.}
proc getImageSize*(image: Image; width: var cint; height: var cint) {.
    importc: "atk_image_get_image_size", libatk.}
proc setImageDescription*(image: Image; description: cstring): Gboolean {.
    importc: "atk_image_set_image_description", libatk.}
proc getImagePosition*(image: Image; x: var cint; y: var cint;
                              coordType: CoordType) {.
    importc: "atk_image_get_image_position", libatk.}
proc getImageLocale*(image: Image): cstring {.
    importc: "atk_image_get_image_locale", libatk.}
proc imageLocale*(image: Image): cstring {.
    importc: "atk_image_get_image_locale", libatk.}

type
  NoOpObject* =  ptr NoOpObjectObj
  NoOpObjectPtr* = ptr NoOpObjectObj
  NoOpObjectObj*{.final.} = object of ObjectObj

  NoOpObjectClass* =  ptr NoOpObjectClassObj
  NoOpObjectClassPtr* = ptr NoOpObjectClassObj
  NoOpObjectClassObj*{.final.} = object of ObjectClassObj

template typeNoOpObject*(): untyped =
  (noOpObjectGetType())

template noOpObject*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeNoOpObject, NoOpObjectObj))

template noOpObjectClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeNoOpObject, NoOpObjectClassObj))

template isNoOpObject*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeNoOpObject))

template isNoOpObjectClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeNoOpObject))

template noOpObjectGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeNoOpObject, NoOpObjectClassObj))

proc noOpObjectGetType*(): GType {.importc: "atk_no_op_object_get_type",
                                   libatk.}
proc noOpObjectNew*(obj: GObject): NoOpObject {.
    importc: "atk_no_op_object_new", libatk.}

type
  ObjectFactory* =  ptr ObjectFactoryObj
  ObjectFactoryPtr* = ptr ObjectFactoryObj
  ObjectFactoryObj* = object of GObjectObj

  ObjectFactoryClass* =  ptr ObjectFactoryClassObj
  ObjectFactoryClassPtr* = ptr ObjectFactoryClassObj
  ObjectFactoryClassObj* = object of GObjectClassObj
    createAccessible*: proc (obj: GObject): Object {.cdecl.}
    invalidate*: proc (factory: ObjectFactory) {.cdecl.}
    getAccessibleType*: proc (): GType {.cdecl.}
    pad1*: Function
    pad2*: Function

template typeObjectFactory*(): untyped =
  (objectFactoryGetType())

template objectFactory*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeObjectFactory, ObjectFactoryObj))

template objectFactoryClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeObjectFactory, ObjectFactoryClassObj))

template isObjectFactory*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeObjectFactory))

template isObjectFactoryClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeObjectFactory))

template objectFactoryGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeObjectFactory, ObjectFactoryClassObj))

proc objectFactoryGetType*(): GType {.importc: "atk_object_factory_get_type",
                                      libatk.}
proc createAccessible*(factory: ObjectFactory;
                                      obj: GObject): Object {.
    importc: "atk_object_factory_create_accessible", libatk.}
proc invalidate*(factory: ObjectFactory) {.
    importc: "atk_object_factory_invalidate", libatk.}
proc getAccessibleType*(factory: ObjectFactory): GType {.
    importc: "atk_object_factory_get_accessible_type", libatk.}
proc accessibleType*(factory: ObjectFactory): GType {.
    importc: "atk_object_factory_get_accessible_type", libatk.}

type
  NoOpObjectFactoryClass* =  ptr NoOpObjectFactoryClassObj
  NoOpObjectFactoryClassPtr* = ptr NoOpObjectFactoryClassObj
  NoOpObjectFactoryClassObj*{.final.} = object of ObjectFactoryClassObj

  NoOpObjectFactory* =  ptr NoOpObjectFactoryObj
  NoOpObjectFactoryPtr* = ptr NoOpObjectFactoryObj
  NoOpObjectFactoryObj*{.final.} = object of ObjectFactoryObj

template typeNoOpObjectFactory*(): untyped =
  (noOpObjectFactoryGetType())

template noOpObjectFactory*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeNoOpObjectFactory, NoOpObjectFactoryObj))

template noOpObjectFactoryClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeNoOpObjectFactory, NoOpObjectFactoryClassObj))

template isNoOpObjectFactory*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeNoOpObjectFactory))

template isNoOpObjectFactoryClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeNoOpObjectFactory))

template noOpObjectFactoryGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeNoOpObjectFactory, NoOpObjectFactoryClassObj))

proc noOpObjectFactoryGetType*(): GType {.
    importc: "atk_no_op_object_factory_get_type", libatk.}
proc noOpObjectFactoryNew*(): ObjectFactory {.
    importc: "atk_no_op_object_factory_new", libatk.}

type
  Plug* =  ptr PlugObj
  PlugPtr* = ptr PlugObj
  PlugObj*{.final.} = object of ObjectObj

  PlugClass* =  ptr PlugClassObj
  PlugClassPtr* = ptr PlugClassObj
  PlugClassObj*{.final.} = object of ObjectClassObj
    getObjectId*: proc (obj: Plug): cstring {.cdecl.}

template typePlug*(): untyped =
  (plugGetType())

template plug*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typePlug, PlugObj))

template isPlug*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typePlug))

template plugClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typePlug, PlugClassObj))

template isPlugClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typePlug))

template plugGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typePlug, PlugClassObj))

proc plugGetType*(): GType {.importc: "atk_plug_get_type", libatk.}
proc plugNew*(): Plug {.importc: "atk_plug_new", libatk.}
proc getId*(plug: Plug): cstring {.importc: "atk_plug_get_id",
    libatk.}
proc id*(plug: Plug): cstring {.importc: "atk_plug_get_id",
    libatk.}

template typeRange*(): untyped =
  (rangeGetType())

type
  Range* =  ptr RangeObj
  RangePtr* = ptr RangeObj
  RangeObj* = object

proc rangeGetType*(): GType {.importc: "atk_range_get_type", libatk.}
proc copy*(src: Range): Range {.importc: "atk_range_copy",
    libatk.}
proc free*(range: Range) {.importc: "atk_range_free", libatk.}
proc getLowerLimit*(range: Range): cdouble {.
    importc: "atk_range_get_lower_limit", libatk.}
proc lowerLimit*(range: Range): cdouble {.
    importc: "atk_range_get_lower_limit", libatk.}
proc getUpperLimit*(range: Range): cdouble {.
    importc: "atk_range_get_upper_limit", libatk.}
proc upperLimit*(range: Range): cdouble {.
    importc: "atk_range_get_upper_limit", libatk.}
proc getDescription*(range: Range): cstring {.
    importc: "atk_range_get_description", libatk.}
proc description*(range: Range): cstring {.
    importc: "atk_range_get_description", libatk.}
proc rangeNew*(lowerLimit: cdouble; upperLimit: cdouble; description: cstring): Range {.
    importc: "atk_range_new", libatk.}

type
  Registry* =  ptr RegistryObj
  RegistryPtr* = ptr RegistryObj
  RegistryObj*{.final.} = object of GObjectObj
    factoryTypeRegistry*: glib.GHashTable
    factorySingletonCache*: glib.GHashTable

  RegistryClass* =  ptr RegistryClassObj
  RegistryClassPtr* = ptr RegistryClassObj
  RegistryClassObj*{.final.} = object of GObjectClassObj

template typeRegistry*(): untyped =
  (registryGetType())

template registry*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeRegistry, RegistryObj))

template registryClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeRegistry, RegistryClassObj))

template isRegistry*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeRegistry))

template isRegistryClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeRegistry))

template registryGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeRegistry, RegistryClassObj))

proc registryGetType*(): GType {.importc: "atk_registry_get_type", libatk.}
proc setFactoryType*(registry: Registry; `type`: GType;
                               factoryType: GType) {.
    importc: "atk_registry_set_factory_type", libatk.}
proc `factoryType=`*(registry: Registry; `type`: GType;
                               factoryType: GType) {.
    importc: "atk_registry_set_factory_type", libatk.}
proc getFactoryType*(registry: Registry; `type`: GType): GType {.
    importc: "atk_registry_get_factory_type", libatk.}
proc factoryType*(registry: Registry; `type`: GType): GType {.
    importc: "atk_registry_get_factory_type", libatk.}
proc getFactory*(registry: Registry; `type`: GType): ObjectFactory {.
    importc: "atk_registry_get_factory", libatk.}
proc factory*(registry: Registry; `type`: GType): ObjectFactory {.
    importc: "atk_registry_get_factory", libatk.}
proc getDefaultRegistry*(): Registry {.
    importc: "atk_get_default_registry", libatk.}
proc defaultRegistry*(): Registry {.
    importc: "atk_get_default_registry", libatk.}

type
  RelationClass* =  ptr RelationClassObj
  RelationClassPtr* = ptr RelationClassObj
  RelationClassObj*{.final.} = object of GObjectClassObj

  Relation* =  ptr RelationObj
  RelationPtr* = ptr RelationObj
  RelationObj*{.final.} = object of GObjectObj
    target*: glib.GPtrArray
    relationship*: RelationType

template typeRelation*(): untyped =
  (relationGetType())

template relation*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeRelation, RelationObj))

template relationClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeRelation, RelationClassObj))

template isRelation*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeRelation))

template isRelationClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeRelation))

template relationGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeRelation, RelationClassObj))

proc relationGetType*(): GType {.importc: "atk_relation_get_type", libatk.}
proc relationTypeRegister*(name: cstring): RelationType {.
    importc: "atk_relation_type_register", libatk.}
proc getName*(`type`: RelationType): cstring {.
    importc: "atk_relation_type_get_name", libatk.}
proc name*(`type`: RelationType): cstring {.
    importc: "atk_relation_type_get_name", libatk.}
proc relationTypeForName*(name: cstring): RelationType {.
    importc: "atk_relation_type_for_name", libatk.}

proc relationNew*(targets: var Object; nTargets: cint;
                    relationship: RelationType): Relation {.
    importc: "atk_relation_new", libatk.}

proc getRelationType*(relation: Relation): RelationType {.
    importc: "atk_relation_get_relation_type", libatk.}

proc relationType*(relation: Relation): RelationType {.
    importc: "atk_relation_get_relation_type", libatk.}

proc getTarget*(relation: Relation): glib.GPtrArray {.
    importc: "atk_relation_get_target", libatk.}

proc target*(relation: Relation): glib.GPtrArray {.
    importc: "atk_relation_get_target", libatk.}
proc addTarget*(relation: Relation; target: Object) {.
    importc: "atk_relation_add_target", libatk.}
proc removeTarget*(relation: Relation; target: Object): Gboolean {.
    importc: "atk_relation_remove_target", libatk.}

type
  RelationSetClass* =  ptr RelationSetClassObj
  RelationSetClassPtr* = ptr RelationSetClassObj
  RelationSetClassObj*{.final.} = object of GObjectClassObj
    pad1*: Function
    pad2*: Function

template typeRelationSet*(): untyped =
  (relationSetGetType())

template relationSet*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeRelationSet, RelationSetObj))

template relationSetClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeRelationSet, RelationSetClassObj))

template isRelationSet*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeRelationSet))

template isRelationSetClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeRelationSet))

template relationSetGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeRelationSet, RelationSetClassObj))

proc relationSetGetType*(): GType {.importc: "atk_relation_set_get_type",
                                    libatk.}
proc relationSetNew*(): RelationSet {.importc: "atk_relation_set_new",
    libatk.}
proc contains*(set: RelationSet; relationship: RelationType): Gboolean {.
    importc: "atk_relation_set_contains", libatk.}
proc containsTarget*(set: RelationSet;
                                  relationship: RelationType;
                                  target: Object): Gboolean {.
    importc: "atk_relation_set_contains_target", libatk.}
proc remove*(set: RelationSet; relation: Relation) {.
    importc: "atk_relation_set_remove", libatk.}
proc add*(set: RelationSet; relation: Relation) {.
    importc: "atk_relation_set_add", libatk.}
proc getNRelations*(set: RelationSet): cint {.
    importc: "atk_relation_set_get_n_relations", libatk.}
proc nRelations*(set: RelationSet): cint {.
    importc: "atk_relation_set_get_n_relations", libatk.}
proc getRelation*(set: RelationSet; i: cint): Relation {.
    importc: "atk_relation_set_get_relation", libatk.}
proc relation*(set: RelationSet; i: cint): Relation {.
    importc: "atk_relation_set_get_relation", libatk.}
proc getRelationByType*(set: RelationSet;
                                     relationship: RelationType): Relation {.
    importc: "atk_relation_set_get_relation_by_type", libatk.}
proc relationByType*(set: RelationSet;
                                     relationship: RelationType): Relation {.
    importc: "atk_relation_set_get_relation_by_type", libatk.}
proc addRelationByType*(set: RelationSet;
                                     relationship: RelationType;
                                     target: Object) {.
    importc: "atk_relation_set_add_relation_by_type", libatk.}

type
  Selection* =  ptr SelectionObj
  SelectionPtr* = ptr SelectionObj
  SelectionObj* = object

  SelectionIface* =  ptr SelectionIfaceObj
  SelectionIfacePtr* = ptr SelectionIfaceObj
  SelectionIfaceObj*{.final.} = object of GTypeInterfaceObj
    addSelection*: proc (selection: Selection; i: cint): Gboolean {.cdecl.}
    clearSelection*: proc (selection: Selection): Gboolean {.cdecl.}
    refSelection*: proc (selection: Selection; i: cint): Object {.cdecl.}
    getSelectionCount*: proc (selection: Selection): cint {.cdecl.}
    isChildSelected*: proc (selection: Selection; i: cint): Gboolean {.cdecl.}
    removeSelection*: proc (selection: Selection; i: cint): Gboolean {.cdecl.}
    selectAllSelection*: proc (selection: Selection): Gboolean {.cdecl.}
    selectionChanged*: proc (selection: Selection) {.cdecl.}

template typeSelection*(): untyped =
  (selectionGetType())

template isSelection*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeSelection)

template selection*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeSelection, SelectionObj)

template selectionGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeSelection, SelectionIfaceObj))

proc selectionGetType*(): GType {.importc: "atk_selection_get_type", libatk.}
proc addSelection*(selection: Selection; i: cint): Gboolean {.
    importc: "atk_selection_add_selection", libatk.}
proc clearSelection*(selection: Selection): Gboolean {.
    importc: "atk_selection_clear_selection", libatk.}
proc refSelection*(selection: Selection; i: cint): Object {.
    importc: "atk_selection_ref_selection", libatk.}
proc getSelectionCount*(selection: Selection): cint {.
    importc: "atk_selection_get_selection_count", libatk.}
proc selectionCount*(selection: Selection): cint {.
    importc: "atk_selection_get_selection_count", libatk.}
proc isChildSelected*(selection: Selection; i: cint): Gboolean {.
    importc: "atk_selection_is_child_selected", libatk.}
proc removeSelection*(selection: Selection; i: cint): Gboolean {.
    importc: "atk_selection_remove_selection", libatk.}
proc selectAllSelection*(selection: Selection): Gboolean {.
    importc: "atk_selection_select_all_selection", libatk.}

type
  Socket* =  ptr SocketObj
  SocketPtr* = ptr SocketObj
  SocketObj*{.final.} = object of ObjectObj
    embeddedPlugId*: cstring

  SocketClass* =  ptr SocketClassObj
  SocketClassPtr* = ptr SocketClassObj
  SocketClassObj*{.final.} = object of ObjectClassObj
    embed*: proc (obj: Socket; plugId: cstring) {.cdecl.}

template typeSocket*(): untyped =
  (socketGetType())

template socket*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeSocket, SocketObj))

template isSocket*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeSocket))

template socketClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeSocket, SocketClassObj))

template isSocketClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeSocket))

template socketGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeSocket, SocketClassObj))

proc socketGetType*(): GType {.importc: "atk_socket_get_type", libatk.}
proc socketNew*(): Socket {.importc: "atk_socket_new", libatk.}
proc embed*(obj: Socket; plugId: cstring) {.
    importc: "atk_socket_embed", libatk.}
proc isOccupied*(obj: Socket): Gboolean {.
    importc: "atk_socket_is_occupied", libatk.}

type
  StateSetClass* =  ptr StateSetClassObj
  StateSetClassPtr* = ptr StateSetClassObj
  StateSetClassObj*{.final.} = object of GObjectClassObj

template typeStateSet*(): untyped =
  (stateSetGetType())

template stateSet*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeStateSet, StateSetObj))

template stateSetClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeStateSet, StateSetClassObj))

template isStateSet*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeStateSet))

template isStateSetClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeStateSet))

template stateSetGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeStateSet, StateSetClassObj))

proc stateSetGetType*(): GType {.importc: "atk_state_set_get_type", libatk.}
proc stateSetNew*(): StateSet {.importc: "atk_state_set_new", libatk.}
proc isEmpty*(set: StateSet): Gboolean {.
    importc: "atk_state_set_is_empty", libatk.}
proc addState*(set: StateSet; `type`: StateType): Gboolean {.
    importc: "atk_state_set_add_state", libatk.}
proc addStates*(set: StateSet; types: ptr StateType; nTypes: cint) {.
    importc: "atk_state_set_add_states", libatk.}
proc clearStates*(set: StateSet) {.
    importc: "atk_state_set_clear_states", libatk.}
proc containsState*(set: StateSet; `type`: StateType): Gboolean {.
    importc: "atk_state_set_contains_state", libatk.}
proc containsStates*(set: StateSet; types: ptr StateType;
                               nTypes: cint): Gboolean {.
    importc: "atk_state_set_contains_states", libatk.}
proc removeState*(set: StateSet; `type`: StateType): Gboolean {.
    importc: "atk_state_set_remove_state", libatk.}
proc andSets*(set: StateSet; compareSet: StateSet): StateSet {.
    importc: "atk_state_set_and_sets", libatk.}
proc orSets*(set: StateSet; compareSet: StateSet): StateSet {.
    importc: "atk_state_set_or_sets", libatk.}
proc xorSets*(set: StateSet; compareSet: StateSet): StateSet {.
    importc: "atk_state_set_xor_sets", libatk.}

type
  StreamableContent* =  ptr StreamableContentObj
  StreamableContentPtr* = ptr StreamableContentObj
  StreamableContentObj* = object

  StreamableContentIface* =  ptr StreamableContentIfaceObj
  StreamableContentIfacePtr* = ptr StreamableContentIfaceObj
  StreamableContentIfaceObj*{.final.} = object of GTypeInterfaceObj
    getNMimeTypes*: proc (streamable: StreamableContent): cint {.cdecl.}
    getMimeType*: proc (streamable: StreamableContent; i: cint): cstring {.cdecl.}
    getStream*: proc (streamable: StreamableContent; mimeType: cstring): glib.GIOChannel {.cdecl.}
    getUri*: proc (streamable: StreamableContent; mimeType: cstring): cstring {.cdecl.}
    pad1*: Function
    pad2*: Function
    pad3*: Function

template typeStreamableContent*(): untyped =
  (streamableContentGetType())

template isStreamableContent*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeStreamableContent))

template streamableContent*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeStreamableContent, StreamableContentObj))

template streamableContentGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeStreamableContent, StreamableContentIfaceObj))

proc streamableContentGetType*(): GType {.
    importc: "atk_streamable_content_get_type", libatk.}
proc getNMimeTypes*(streamable: StreamableContent): cint {.
    importc: "atk_streamable_content_get_n_mime_types", libatk.}
proc nMimeTypes*(streamable: StreamableContent): cint {.
    importc: "atk_streamable_content_get_n_mime_types", libatk.}
proc getMimeType*(streamable: StreamableContent; i: cint): cstring {.
    importc: "atk_streamable_content_get_mime_type", libatk.}
proc mimeType*(streamable: StreamableContent; i: cint): cstring {.
    importc: "atk_streamable_content_get_mime_type", libatk.}
proc getStream*(streamable: StreamableContent;
                                   mimeType: cstring): glib.GIOChannel {.
    importc: "atk_streamable_content_get_stream", libatk.}
proc stream*(streamable: StreamableContent;
                                   mimeType: cstring): glib.GIOChannel {.
    importc: "atk_streamable_content_get_stream", libatk.}
proc getUri*(streamable: StreamableContent;
                                mimeType: cstring): cstring {.
    importc: "atk_streamable_content_get_uri", libatk.}
proc uri*(streamable: StreamableContent;
                                mimeType: cstring): cstring {.
    importc: "atk_streamable_content_get_uri", libatk.}

type
  Table* =  ptr TableObj
  TablePtr* = ptr TableObj
  TableObj* = object

  TableIface* =  ptr TableIfaceObj
  TableIfacePtr* = ptr TableIfaceObj
  TableIfaceObj*{.final.} = object of GTypeInterfaceObj
    refAt*: proc (table: Table; row: cint; column: cint): Object {.cdecl.}
    getIndexAt*: proc (table: Table; row: cint; column: cint): cint {.cdecl.}
    getColumnAtIndex*: proc (table: Table; index: cint): cint {.cdecl.}
    getRowAtIndex*: proc (table: Table; index: cint): cint {.cdecl.}
    getNColumns*: proc (table: Table): cint {.cdecl.}
    getNRows*: proc (table: Table): cint {.cdecl.}
    getColumnExtentAt*: proc (table: Table; row: cint; column: cint): cint {.cdecl.}
    getRowExtentAt*: proc (table: Table; row: cint; column: cint): cint {.cdecl.}
    getCaption*: proc (table: Table): Object {.cdecl.}
    getColumnDescription*: proc (table: Table; column: cint): cstring {.cdecl.}
    getColumnHeader*: proc (table: Table; column: cint): Object {.cdecl.}
    getRowDescription*: proc (table: Table; row: cint): cstring {.cdecl.}
    getRowHeader*: proc (table: Table; row: cint): Object {.cdecl.}
    getSummary*: proc (table: Table): Object {.cdecl.}
    setCaption*: proc (table: Table; caption: Object) {.cdecl.}
    setColumnDescription*: proc (table: Table; column: cint;
                               description: cstring) {.cdecl.}
    setColumnHeader*: proc (table: Table; column: cint; header: Object) {.cdecl.}
    setRowDescription*: proc (table: Table; row: cint; description: cstring) {.cdecl.}
    setRowHeader*: proc (table: Table; row: cint; header: Object) {.cdecl.}
    setSummary*: proc (table: Table; accessible: Object) {.cdecl.}
    getSelectedColumns*: proc (table: Table; selected: var ptr cint): cint {.cdecl.}
    getSelectedRows*: proc (table: Table; selected: var ptr cint): cint {.cdecl.}
    isColumnSelected*: proc (table: Table; column: cint): Gboolean {.cdecl.}
    isRowSelected*: proc (table: Table; row: cint): Gboolean {.cdecl.}
    isSelected*: proc (table: Table; row: cint; column: cint): Gboolean {.cdecl.}
    addRowSelection*: proc (table: Table; row: cint): Gboolean {.cdecl.}
    removeRowSelection*: proc (table: Table; row: cint): Gboolean {.cdecl.}
    addColumnSelection*: proc (table: Table; column: cint): Gboolean {.cdecl.}
    removeColumnSelection*: proc (table: Table; column: cint): Gboolean {.cdecl.}
    rowInserted*: proc (table: Table; row: cint; numInserted: cint) {.cdecl.}
    columnInserted*: proc (table: Table; column: cint; numInserted: cint) {.cdecl.}
    rowDeleted*: proc (table: Table; row: cint; numDeleted: cint) {.cdecl.}
    columnDeleted*: proc (table: Table; column: cint; numDeleted: cint) {.cdecl.}
    rowReordered*: proc (table: Table) {.cdecl.}
    columnReordered*: proc (table: Table) {.cdecl.}
    modelChanged*: proc (table: Table) {.cdecl.}

template typeTable*(): untyped =
  (tableGetType())

template isTable*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeTable)

template table*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeTable, TableObj)

template tableGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeTable, TableIfaceObj))

proc tableGetType*(): GType {.importc: "atk_table_get_type", libatk.}
proc refAt*(table: Table; row: cint; column: cint): Object {.
    importc: "atk_table_ref_at", libatk.}
proc getIndexAt*(table: Table; row: cint; column: cint): cint {.
    importc: "atk_table_get_index_at", libatk.}
proc indexAt*(table: Table; row: cint; column: cint): cint {.
    importc: "atk_table_get_index_at", libatk.}
proc getColumnAtIndex*(table: Table; index: cint): cint {.
    importc: "atk_table_get_column_at_index", libatk.}
proc columnAtIndex*(table: Table; index: cint): cint {.
    importc: "atk_table_get_column_at_index", libatk.}
proc getRowAtIndex*(table: Table; index: cint): cint {.
    importc: "atk_table_get_row_at_index", libatk.}
proc rowAtIndex*(table: Table; index: cint): cint {.
    importc: "atk_table_get_row_at_index", libatk.}
proc getNColumns*(table: Table): cint {.
    importc: "atk_table_get_n_columns", libatk.}
proc nColumns*(table: Table): cint {.
    importc: "atk_table_get_n_columns", libatk.}
proc getNRows*(table: Table): cint {.importc: "atk_table_get_n_rows",
    libatk.}
proc nRows*(table: Table): cint {.importc: "atk_table_get_n_rows",
    libatk.}
proc getColumnExtentAt*(table: Table; row: cint; column: cint): cint {.
    importc: "atk_table_get_column_extent_at", libatk.}
proc columnExtentAt*(table: Table; row: cint; column: cint): cint {.
    importc: "atk_table_get_column_extent_at", libatk.}
proc getRowExtentAt*(table: Table; row: cint; column: cint): cint {.
    importc: "atk_table_get_row_extent_at", libatk.}
proc rowExtentAt*(table: Table; row: cint; column: cint): cint {.
    importc: "atk_table_get_row_extent_at", libatk.}
proc getCaption*(table: Table): Object {.
    importc: "atk_table_get_caption", libatk.}
proc caption*(table: Table): Object {.
    importc: "atk_table_get_caption", libatk.}
proc getColumnDescription*(table: Table; column: cint): cstring {.
    importc: "atk_table_get_column_description", libatk.}
proc columnDescription*(table: Table; column: cint): cstring {.
    importc: "atk_table_get_column_description", libatk.}
proc getColumnHeader*(table: Table; column: cint): Object {.
    importc: "atk_table_get_column_header", libatk.}
proc columnHeader*(table: Table; column: cint): Object {.
    importc: "atk_table_get_column_header", libatk.}
proc getRowDescription*(table: Table; row: cint): cstring {.
    importc: "atk_table_get_row_description", libatk.}
proc rowDescription*(table: Table; row: cint): cstring {.
    importc: "atk_table_get_row_description", libatk.}
proc getRowHeader*(table: Table; row: cint): Object {.
    importc: "atk_table_get_row_header", libatk.}
proc rowHeader*(table: Table; row: cint): Object {.
    importc: "atk_table_get_row_header", libatk.}
proc getSummary*(table: Table): Object {.
    importc: "atk_table_get_summary", libatk.}
proc summary*(table: Table): Object {.
    importc: "atk_table_get_summary", libatk.}
proc setCaption*(table: Table; caption: Object) {.
    importc: "atk_table_set_caption", libatk.}
proc `caption=`*(table: Table; caption: Object) {.
    importc: "atk_table_set_caption", libatk.}
proc setColumnDescription*(table: Table; column: cint;
                                  description: cstring) {.
    importc: "atk_table_set_column_description", libatk.}
proc `columnDescription=`*(table: Table; column: cint;
                                  description: cstring) {.
    importc: "atk_table_set_column_description", libatk.}
proc setColumnHeader*(table: Table; column: cint; header: Object) {.
    importc: "atk_table_set_column_header", libatk.}
proc `columnHeader=`*(table: Table; column: cint; header: Object) {.
    importc: "atk_table_set_column_header", libatk.}
proc setRowDescription*(table: Table; row: cint; description: cstring) {.
    importc: "atk_table_set_row_description", libatk.}
proc `rowDescription=`*(table: Table; row: cint; description: cstring) {.
    importc: "atk_table_set_row_description", libatk.}
proc setRowHeader*(table: Table; row: cint; header: Object) {.
    importc: "atk_table_set_row_header", libatk.}
proc `rowHeader=`*(table: Table; row: cint; header: Object) {.
    importc: "atk_table_set_row_header", libatk.}
proc setSummary*(table: Table; accessible: Object) {.
    importc: "atk_table_set_summary", libatk.}
proc `summary=`*(table: Table; accessible: Object) {.
    importc: "atk_table_set_summary", libatk.}
proc getSelectedColumns*(table: Table; selected: var ptr cint): cint {.
    importc: "atk_table_get_selected_columns", libatk.}
proc selectedColumns*(table: Table; selected: var ptr cint): cint {.
    importc: "atk_table_get_selected_columns", libatk.}
proc getSelectedRows*(table: Table; selected: var ptr cint): cint {.
    importc: "atk_table_get_selected_rows", libatk.}
proc selectedRows*(table: Table; selected: var ptr cint): cint {.
    importc: "atk_table_get_selected_rows", libatk.}
proc isColumnSelected*(table: Table; column: cint): Gboolean {.
    importc: "atk_table_is_column_selected", libatk.}
proc isRowSelected*(table: Table; row: cint): Gboolean {.
    importc: "atk_table_is_row_selected", libatk.}
proc isSelected*(table: Table; row: cint; column: cint): Gboolean {.
    importc: "atk_table_is_selected", libatk.}
proc addRowSelection*(table: Table; row: cint): Gboolean {.
    importc: "atk_table_add_row_selection", libatk.}
proc removeRowSelection*(table: Table; row: cint): Gboolean {.
    importc: "atk_table_remove_row_selection", libatk.}
proc addColumnSelection*(table: Table; column: cint): Gboolean {.
    importc: "atk_table_add_column_selection", libatk.}
proc removeColumnSelection*(table: Table; column: cint): Gboolean {.
    importc: "atk_table_remove_column_selection", libatk.}

type
  TableCell* =  ptr TableCellObj
  TableCellPtr* = ptr TableCellObj
  TableCellObj* = object

  TableCellIface* =  ptr TableCellIfaceObj
  TableCellIfacePtr* = ptr TableCellIfaceObj
  TableCellIfaceObj*{.final.} = object of GTypeInterfaceObj
    getColumnSpan*: proc (cell: TableCell): cint {.cdecl.}
    getColumnHeaderCells*: proc (cell: TableCell): glib.GPtrArray {.cdecl.}
    getPosition*: proc (cell: TableCell; row: var cint; column: var cint): Gboolean {.cdecl.}
    getRowSpan*: proc (cell: TableCell): cint {.cdecl.}
    getRowHeaderCells*: proc (cell: TableCell): glib.GPtrArray {.cdecl.}
    getRowColumnSpan*: proc (cell: TableCell; row: var cint; column: var cint;
                           rowSpan: var cint; columnSpan: var cint): Gboolean {.cdecl.}
    getTable*: proc (cell: TableCell): Object {.cdecl.}

template typeTableCell*(): untyped =
  (tableCellGetType())

template isTableCell*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeTableCell)

template tableCell*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeTableCell, TableCellObj)

template tableCellGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeTableCell, TableCellIfaceObj))

proc tableCellGetType*(): GType {.importc: "atk_table_cell_get_type", libatk.}
proc getColumnSpan*(cell: TableCell): cint {.
    importc: "atk_table_cell_get_column_span", libatk.}
proc columnSpan*(cell: TableCell): cint {.
    importc: "atk_table_cell_get_column_span", libatk.}
proc getColumnHeaderCells*(cell: TableCell): glib.GPtrArray {.
    importc: "atk_table_cell_get_column_header_cells", libatk.}
proc columnHeaderCells*(cell: TableCell): glib.GPtrArray {.
    importc: "atk_table_cell_get_column_header_cells", libatk.}
proc getPosition*(cell: TableCell; row: var cint; column: var cint): Gboolean {.
    importc: "atk_table_cell_get_position", libatk.}
proc position*(cell: TableCell; row: var cint; column: var cint): Gboolean {.
    importc: "atk_table_cell_get_position", libatk.}
proc getRowSpan*(cell: TableCell): cint {.
    importc: "atk_table_cell_get_row_span", libatk.}
proc rowSpan*(cell: TableCell): cint {.
    importc: "atk_table_cell_get_row_span", libatk.}
proc getRowHeaderCells*(cell: TableCell): glib.GPtrArray {.
    importc: "atk_table_cell_get_row_header_cells", libatk.}
proc rowHeaderCells*(cell: TableCell): glib.GPtrArray {.
    importc: "atk_table_cell_get_row_header_cells", libatk.}
proc getRowColumnSpan*(cell: TableCell; row: var cint;
                                  column: var cint; rowSpan: var cint;
                                  columnSpan: var cint): Gboolean {.
    importc: "atk_table_cell_get_row_column_span", libatk.}
proc rowColumnSpan*(cell: TableCell; row: var cint;
                                  column: var cint; rowSpan: var cint;
                                  columnSpan: var cint): Gboolean {.
    importc: "atk_table_cell_get_row_column_span", libatk.}
proc getTable*(cell: TableCell): Object {.
    importc: "atk_table_cell_get_table", libatk.}
proc table*(cell: TableCell): Object {.
    importc: "atk_table_cell_get_table", libatk.}

type
  Misc* =  ptr MiscObj
  MiscPtr* = ptr MiscObj
  MiscObj*{.final.} = object of GObjectObj

  MiscClass* =  ptr MiscClassObj
  MiscClassPtr* = ptr MiscClassObj
  MiscClassObj*{.final.} = object of GObjectClassObj
    threadsEnter*: proc (misc: Misc) {.cdecl.}
    threadsLeave*: proc (misc: Misc) {.cdecl.}
    vfuncs*: array[32, Gpointer]

template typeMisc*(): untyped =
  (miscGetType())

template isMisc*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeMisc)

template misc*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeMisc, MiscObj)

template miscClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeMisc, MiscClassObj))

template isMiscClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeMisc))

template miscGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeMisc, MiscClassObj))

proc miscGetType*(): GType {.importc: "atk_misc_get_type", libatk.}
proc threadsEnter*(misc: Misc) {.importc: "atk_misc_threads_enter",
    libatk.}
proc threadsLeave*(misc: Misc) {.importc: "atk_misc_threads_leave",
    libatk.}
proc miscGetInstance*(): Misc {.importc: "atk_misc_get_instance",
                                      libatk.}

type
  Value* =  ptr ValueObj
  ValuePtr* = ptr ValueObj
  ValueObj* = object

  ValueIface* =  ptr ValueIfaceObj
  ValueIfacePtr* = ptr ValueIfaceObj
  ValueIfaceObj*{.final.} = object of GTypeInterfaceObj
    getCurrentValue*: proc (obj: Value; value: GValue) {.cdecl.}
    getMaximumValue*: proc (obj: Value; value: GValue) {.cdecl.}
    getMinimumValue*: proc (obj: Value; value: GValue) {.cdecl.}
    setCurrentValue*: proc (obj: Value; value: GValue): Gboolean {.cdecl.}
    getMinimumIncrement*: proc (obj: Value; value: GValue) {.cdecl.}
    getValueAndText*: proc (obj: Value; value: var cdouble; text: cstringArray) {.cdecl.}
    getRange*: proc (obj: Value): Range {.cdecl.}
    getIncrement*: proc (obj: Value): cdouble {.cdecl.}
    getSubRanges*: proc (obj: Value): glib.GSList {.cdecl.}
    setValue*: proc (obj: Value; newValue: cdouble) {.cdecl.}

template typeValue*(): untyped =
  (valueGetType())

template isValue*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeValue)

template value*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeValue, ValueObj)

template valueGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeValue, ValueIfaceObj))

type
  ValueType* {.size: sizeof(cint), pure.} = enum
    VERY_WEAK, WEAK, ACCEPTABLE, STRONG,
    VERY_STRONG, VERY_LOW, LOW, MEDIUM,
    HIGH, VERY_HIGH, VERY_BAD, BAD,
    GOOD, VERY_GOOD, BEST, LAST_DEFINED

proc valueGetType*(): GType {.importc: "atk_value_get_type", libatk.}
proc getCurrentValue*(obj: Value; value: var GValueObj) {.
    importc: "atk_value_get_current_value", libatk.}
proc getMaximumValue*(obj: Value; value: var GValueObj) {.
    importc: "atk_value_get_maximum_value", libatk.}
proc getMinimumValue*(obj: Value; value: var GValueObj) {.
    importc: "atk_value_get_minimum_value", libatk.}
proc setCurrentValue*(obj: Value; value: var GValueObj): Gboolean {.
    importc: "atk_value_set_current_value", libatk.}
proc getMinimumIncrement*(obj: Value; value: var GValueObj) {.
    importc: "atk_value_get_minimum_increment", libatk.}
proc getValueAndText*(obj: Value; value: var cdouble; text: cstringArray) {.
    importc: "atk_value_get_value_and_text", libatk.}
proc getRange*(obj: Value): Range {.
    importc: "atk_value_get_range", libatk.}
proc range*(obj: Value): Range {.
    importc: "atk_value_get_range", libatk.}
proc getIncrement*(obj: Value): cdouble {.
    importc: "atk_value_get_increment", libatk.}
proc increment*(obj: Value): cdouble {.
    importc: "atk_value_get_increment", libatk.}
proc getSubRanges*(obj: Value): glib.GSList {.
    importc: "atk_value_get_sub_ranges", libatk.}
proc subRanges*(obj: Value): glib.GSList {.
    importc: "atk_value_get_sub_ranges", libatk.}
proc setValue*(obj: Value; newValue: cdouble) {.
    importc: "atk_value_set_value", libatk.}
proc `value=`*(obj: Value; newValue: cdouble) {.
    importc: "atk_value_set_value", libatk.}

proc getName*(valueType: ValueType): cstring {.
    importc: "atk_value_type_get_name", libatk.}

proc name*(valueType: ValueType): cstring {.
    importc: "atk_value_type_get_name", libatk.}
proc getLocalizedName*(valueType: ValueType): cstring {.
    importc: "atk_value_type_get_localized_name", libatk.}
proc localizedName*(valueType: ValueType): cstring {.
    importc: "atk_value_type_get_localized_name", libatk.}

type
  WindowIface* =  ptr WindowIfaceObj
  WindowIfacePtr* = ptr WindowIfaceObj
  WindowIfaceObj*{.final.} = object of GTypeInterfaceObj

template typeWindow*(): untyped =
  (windowGetType())

template isWindow*(obj: untyped): untyped =
  gTypeCheckInstanceType(obj, typeWindow)

template window*(obj: untyped): untyped =
  gTypeCheckInstanceCast(obj, typeWindow, WindowObj)

template windowGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeWindow, WindowIfaceObj))

type
  Window* =  ptr WindowObj
  WindowPtr* = ptr WindowObj
  WindowObj* = object

proc windowGetType*(): GType {.importc: "atk_window_get_type", libatk.}

