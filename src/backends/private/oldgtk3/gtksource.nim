{.deadCodeElim: on.}

when defined(windows):
  const LIB_GSV = "libgtksourceview-3.0-0.dll"
elif defined(macosx):
  const LIB_GSV = "libgtksourceview-3.0(|-0).dylib"
else:
  const LIB_GSV = "libgtksourceview-3.0.so(|.0)"

{.pragma: libgsv, cdecl, dynlib: LIB_GSV.}

from gtk import TextBufferObj, TextMarkObj, TextIter, TextBufferClassObj, TextViewObj, WindowObj, Widget, TextWindowType

from gdk import Rectangle

from glib import GList, GSList, GError, Goffset, Gpointer, Gboolean, GQuark, GDestroyNotify

from gobject import GInitiallyUnownedObj, GInitiallyUnownedClassObj, GObject, GObjectObj, GObjectClassObj, GType,
  gTypeCheckClassCast, gTypeCheckInstanceType, gTypeCheckClassType, gTypeInstanceGetClass

from gdk_pixbuf import GdkPixbuf

from cairo import Context

from gio import GFile, GMountOperation, GInputStream, GCancellable, GAsyncResult, GFileProgressCallback, GAsyncReadyCallback, GIcon, GSettingsBindFlags

type
  CompletionProposal* =  ptr CompletionProposalObj
  CompletionProposalPtr* = ptr CompletionProposalObj
  CompletionProposalObj* = object

  CompletionProvider* =  ptr CompletionProviderObj
  CompletionProviderPtr* = ptr CompletionProviderObj
  CompletionProviderObj* = object of GObjectObj

  Encoding* =  ptr EncodingObj
  EncodingPtr* = ptr EncodingObj
  EncodingObj* = object

  Style* =  ptr StyleObj
  StylePtr* = ptr StyleObj
  StyleObj*{.final.} = object of GObjectObj

  StyleSchemeChooser* =  ptr StyleSchemeChooserObj
  StyleSchemeChooserPtr* = ptr StyleSchemeChooserObj
  StyleSchemeChooserObj* = object

  UndoManager* =  ptr UndoManagerObj
  UndoManagerPtr* = ptr UndoManagerObj
  UndoManagerObj*{.final.} = object of GObjectObj

template typeCompletionContext*(): untyped =
  (completionContextGetType())

template completionContext*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionContext, CompletionContextObj))

template completionContextClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeCompletionContext, CompletionContextClassObj))

template isCompletionContext*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionContext))

template isCompletionContextClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeCompletionContext))

template completionContextGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeCompletionContext, CompletionContextClassObj))

type
  CompletionActivation* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    INTERACTIVE = 1 shl 0,
    USER_REQUESTED = 1 shl 1

type
  CompletionContext* =  ptr CompletionContextObj
  CompletionContextPtr* = ptr CompletionContextObj
  CompletionContextObj*{.final.} = object of gobject.GInitiallyUnownedObj
    priv: pointer

  CompletionContextClass* =  ptr CompletionContextClassObj
  CompletionContextClassPtr* = ptr CompletionContextClassObj
  CompletionContextClassObj*{.final.} = object of gobject.GInitiallyUnownedClassObj
    cancelled*: proc (context: CompletionContext) {.cdecl.}
    reserved1*: proc () {.cdecl.}
    reserved2*: proc () {.cdecl.}
    reserved3*: proc () {.cdecl.}

  Completion* =  ptr CompletionObj
  CompletionPtr* = ptr CompletionObj
  CompletionObj*{.final.} = object of GObjectObj
    priv: pointer

proc completionContextGetType*(): GType {.
    importc: "gtk_source_completion_context_get_type", libgsv.}
proc addProposals*(
    context: CompletionContext;
    provider: CompletionProvider; proposals: glib.GList;
    finished: Gboolean) {.importc: "gtk_source_completion_context_add_proposals",
                        libgsv.}
proc getIter*(context: CompletionContext;
                                       iter: gtk.TextIter): Gboolean {.
    importc: "gtk_source_completion_context_get_iter", libgsv.}
proc iter*(context: CompletionContext;
                                       iter: gtk.TextIter): Gboolean {.
    importc: "gtk_source_completion_context_get_iter", libgsv.}
proc getActivation*(
    context: CompletionContext): CompletionActivation {.
    importc: "gtk_source_completion_context_get_activation", libgsv.}
proc activation*(
    context: CompletionContext): CompletionActivation {.
    importc: "gtk_source_completion_context_get_activation", libgsv.}
proc newContext*(completion: Completion;
                                   position: gtk.TextIter): CompletionContext {.
    importc: "_gtk_source_completion_context_new", libgsv.}
proc cancel*(context: CompletionContext) {.
    importc: "_gtk_source_completion_context_cancel", libgsv.}

type
  CompletionInfo* =  ptr CompletionInfoObj
  CompletionInfoPtr* = ptr CompletionInfoObj
  CompletionInfoObj*{.final.} = object of gtk.WindowObj
    priv: pointer

  CompletionProviderIface* =  ptr CompletionProviderIfaceObj
  CompletionProviderIfacePtr* = ptr CompletionProviderIfaceObj
  CompletionProviderIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
    getName*: proc (provider: CompletionProvider): cstring {.cdecl.}
    getIcon*: proc (provider: CompletionProvider): gdk_pixbuf.GdkPixbuf {.cdecl.}
    getIconName*: proc (provider: CompletionProvider): cstring {.cdecl.}
    getGicon*: proc (provider: CompletionProvider): gio.GIcon {.cdecl.}
    populate*: proc (provider: CompletionProvider;
                   context: CompletionContext) {.cdecl.}
    match*: proc (provider: CompletionProvider;
                context: CompletionContext): Gboolean {.cdecl.}
    getActivation*: proc (provider: CompletionProvider): CompletionActivation {.cdecl.}
    getInfoWidget*: proc (provider: CompletionProvider;
                        proposal: CompletionProposal): gtk.Widget {.cdecl.}
    updateInfo*: proc (provider: CompletionProvider;
                     proposal: CompletionProposal;
                     info: CompletionInfo) {.cdecl.}
    getStartIter*: proc (provider: CompletionProvider;
                       context: CompletionContext;
                       proposal: CompletionProposal;
                       iter: gtk.TextIter): Gboolean {.cdecl.}
    activateProposal*: proc (provider: CompletionProvider;
                           proposal: CompletionProposal;
                           iter: gtk.TextIter): Gboolean {.cdecl.}
    getInteractiveDelay*: proc (provider: CompletionProvider): cint {.cdecl.}
    getPriority*: proc (provider: CompletionProvider): cint {.cdecl.}

template typeCompletionProvider*(): untyped =
  (completionProviderGetType())

template completionProvider*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionProvider, CompletionProviderObj))

template isCompletionProvider*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionProvider))

template completionProviderGetInterface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeCompletionProvider, CompletionProviderIfaceObj))

proc completionProviderGetType*(): GType {.
    importc: "gtk_source_completion_provider_get_type", libgsv.}
proc getName*(provider: CompletionProvider): cstring {.
    importc: "gtk_source_completion_provider_get_name", libgsv.}
proc name*(provider: CompletionProvider): cstring {.
    importc: "gtk_source_completion_provider_get_name", libgsv.}
proc getIcon*(provider: CompletionProvider): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_completion_provider_get_icon", libgsv.}
proc icon*(provider: CompletionProvider): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_completion_provider_get_icon", libgsv.}
proc getIconName*(
    provider: CompletionProvider): cstring {.
    importc: "gtk_source_completion_provider_get_icon_name", libgsv.}
proc iconName*(
    provider: CompletionProvider): cstring {.
    importc: "gtk_source_completion_provider_get_icon_name", libgsv.}
proc getGicon*(
    provider: CompletionProvider): gio.GIcon {.
    importc: "gtk_source_completion_provider_get_gicon", libgsv.}
proc gicon*(
    provider: CompletionProvider): gio.GIcon {.
    importc: "gtk_source_completion_provider_get_gicon", libgsv.}
proc populate*(
    provider: CompletionProvider;
    context: CompletionContext) {.
    importc: "gtk_source_completion_provider_populate", libgsv.}
proc getActivation*(
    provider: CompletionProvider): CompletionActivation {.
    importc: "gtk_source_completion_provider_get_activation", libgsv.}
proc activation*(
    provider: CompletionProvider): CompletionActivation {.
    importc: "gtk_source_completion_provider_get_activation", libgsv.}
proc match*(provider: CompletionProvider;
                                      context: CompletionContext): Gboolean {.
    importc: "gtk_source_completion_provider_match", libgsv.}
proc getInfoWidget*(
    provider: CompletionProvider;
    proposal: CompletionProposal): gtk.Widget {.
    importc: "gtk_source_completion_provider_get_info_widget", libgsv.}
proc infoWidget*(
    provider: CompletionProvider;
    proposal: CompletionProposal): gtk.Widget {.
    importc: "gtk_source_completion_provider_get_info_widget", libgsv.}
proc updateInfo*(
    provider: CompletionProvider;
    proposal: CompletionProposal; info: CompletionInfo) {.
    importc: "gtk_source_completion_provider_update_info", libgsv.}
proc getStartIter*(
    provider: CompletionProvider;
    context: CompletionContext;
    proposal: CompletionProposal; iter: gtk.TextIter): Gboolean {.
    importc: "gtk_source_completion_provider_get_start_iter", libgsv.}
proc startIter*(
    provider: CompletionProvider;
    context: CompletionContext;
    proposal: CompletionProposal; iter: gtk.TextIter): Gboolean {.
    importc: "gtk_source_completion_provider_get_start_iter", libgsv.}
proc activateProposal*(
    provider: CompletionProvider;
    proposal: CompletionProposal; iter: gtk.TextIter): Gboolean {.
    importc: "gtk_source_completion_provider_activate_proposal", libgsv.}
proc getInteractiveDelay*(
    provider: CompletionProvider): cint {.
    importc: "gtk_source_completion_provider_get_interactive_delay", libgsv.}
proc interactiveDelay*(
    provider: CompletionProvider): cint {.
    importc: "gtk_source_completion_provider_get_interactive_delay", libgsv.}
proc getPriority*(
    provider: CompletionProvider): cint {.
    importc: "gtk_source_completion_provider_get_priority", libgsv.}
proc priority*(
    provider: CompletionProvider): cint {.
    importc: "gtk_source_completion_provider_get_priority", libgsv.}

template typeCompletionWords*(): untyped =
  (completionWordsGetType())

template completionWords*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionWords, CompletionWordsObj))

template completionWordsClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeCompletionWords, CompletionWordsClassObj))

template isCompletionWords*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionWords))

template isCompletionWordsClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeCompletionWords))

template completionWordsGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeCompletionWords, CompletionWordsClassObj))

type
  CompletionWords* =  ptr CompletionWordsObj
  CompletionWordsPtr* = ptr CompletionWordsObj
  CompletionWordsObj*{.final.} = object of CompletionProviderObj
    priv: pointer

  CompletionWordsClass* =  ptr CompletionWordsClassObj
  CompletionWordsClassPtr* = ptr CompletionWordsClassObj
  CompletionWordsClassObj*{.final.} = object of GObjectClassObj

proc completionWordsGetType*(): GType {.
    importc: "gtk_source_completion_words_get_type", libgsv.}
proc newCompletionWords*(name: cstring; icon: gdk_pixbuf.GdkPixbuf): CompletionWords {.
    importc: "gtk_source_completion_words_new", libgsv.}
proc register*(words: CompletionWords;
                                      buffer: gtk.TextBuffer) {.
    importc: "gtk_source_completion_words_register", libgsv.}
proc unregister*(words: CompletionWords;
                                        buffer: gtk.TextBuffer) {.
    importc: "gtk_source_completion_words_unregister", libgsv.}

type
  BracketMatchType* {.size: sizeof(cint), pure.} = enum
    NONE, OUT_OF_RANGE,
    NOT_FOUND, FOUND
type
  Buffer* =  ptr BufferObj
  BufferPtr* = ptr BufferObj
  BufferObj* = object of gtk.TextBufferObj
    priv: pointer

  BufferClass* =  ptr BufferClassObj
  BufferClassPtr* = ptr BufferClassObj
  BufferClassObj* = object of gtk.TextBufferClassObj
    undo*: proc (buffer: Buffer) {.cdecl.}
    redo*: proc (buffer: Buffer) {.cdecl.}
    bracketMatched*: proc (buffer: Buffer; iter: gtk.TextIter;
                         state: BracketMatchType) {.cdecl.}
    reserved1*: proc () {.cdecl.}
    reserved2*: proc () {.cdecl.}
    reserved3*: proc () {.cdecl.}

template typeBuffer*(): untyped =
  (bufferGetType())

template buffer*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeBuffer, BufferObj))

template bufferClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeBuffer, BufferClassObj))

template isBuffer*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeBuffer))

template isBufferClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeBuffer))

template bufferGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeBuffer, BufferClassObj))

type
  ChangeCaseType* {.size: sizeof(cint), pure.} = enum
    LOWER, UPPER,
    TOGGLE, TITLE

type
  SortFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, CASE_SENSITIVE = 1 shl 0,
    REVERSE_ORDER = 1 shl 1,
    REMOVE_DUPLICATES = 1 shl 2

type
  Mark* =  ptr MarkObj
  MarkPtr* = ptr MarkObj
  MarkObj*{.final.} = object of gtk.TextMarkObj
    priv: pointer

  Language* =  ptr LanguageObj
  LanguagePtr* = ptr LanguageObj
  LanguageObj*{.final.} = object of GObjectObj
    priv: pointer

  StyleScheme* =  ptr StyleSchemeObj
  StyleSchemePtr* = ptr StyleSchemeObj
  StyleSchemeObj*{.final.} = object of GObjectObj
    priv: pointer

proc bufferGetType*(): GType {.importc: "gtk_source_buffer_get_type",
                                     libgsv.}
proc newBuffer*(table: gtk.TextTagTable): Buffer {.
    importc: "gtk_source_buffer_new", libgsv.}
proc newBuffer*(language: Language): Buffer {.
    importc: "gtk_source_buffer_new_with_language", libgsv.}
proc getHighlightSyntax*(buffer: Buffer): Gboolean {.
    importc: "gtk_source_buffer_get_highlight_syntax", libgsv.}
proc highlightSyntax*(buffer: Buffer): Gboolean {.
    importc: "gtk_source_buffer_get_highlight_syntax", libgsv.}
proc setHighlightSyntax*(buffer: Buffer;
                                       highlight: Gboolean) {.
    importc: "gtk_source_buffer_set_highlight_syntax", libgsv.}
proc `highlightSyntax=`*(buffer: Buffer;
                                       highlight: Gboolean) {.
    importc: "gtk_source_buffer_set_highlight_syntax", libgsv.}
proc getHighlightMatchingBrackets*(buffer: Buffer): Gboolean {.
    importc: "gtk_source_buffer_get_highlight_matching_brackets", libgsv.}
proc highlightMatchingBrackets*(buffer: Buffer): Gboolean {.
    importc: "gtk_source_buffer_get_highlight_matching_brackets", libgsv.}
proc setHighlightMatchingBrackets*(buffer: Buffer;
    highlight: Gboolean) {.importc: "gtk_source_buffer_set_highlight_matching_brackets",
                         libgsv.}
proc `highlightMatchingBrackets=`*(buffer: Buffer;
    highlight: Gboolean) {.importc: "gtk_source_buffer_set_highlight_matching_brackets",
                         libgsv.}
proc getMaxUndoLevels*(buffer: Buffer): cint {.
    importc: "gtk_source_buffer_get_max_undo_levels", libgsv.}
proc maxUndoLevels*(buffer: Buffer): cint {.
    importc: "gtk_source_buffer_get_max_undo_levels", libgsv.}
proc setMaxUndoLevels*(buffer: Buffer;
                                     maxUndoLevels: cint) {.
    importc: "gtk_source_buffer_set_max_undo_levels", libgsv.}
proc `maxUndoLevels=`*(buffer: Buffer;
                                     maxUndoLevels: cint) {.
    importc: "gtk_source_buffer_set_max_undo_levels", libgsv.}
proc getLanguage*(buffer: Buffer): Language {.
    importc: "gtk_source_buffer_get_language", libgsv.}
proc language*(buffer: Buffer): Language {.
    importc: "gtk_source_buffer_get_language", libgsv.}
proc setLanguage*(buffer: Buffer;
                                language: Language) {.
    importc: "gtk_source_buffer_set_language", libgsv.}
proc `language=`*(buffer: Buffer;
                                language: Language) {.
    importc: "gtk_source_buffer_set_language", libgsv.}
proc canUndo*(buffer: Buffer): Gboolean {.
    importc: "gtk_source_buffer_can_undo", libgsv.}
proc canRedo*(buffer: Buffer): Gboolean {.
    importc: "gtk_source_buffer_can_redo", libgsv.}
proc getStyleScheme*(buffer: Buffer): StyleScheme {.
    importc: "gtk_source_buffer_get_style_scheme", libgsv.}
proc styleScheme*(buffer: Buffer): StyleScheme {.
    importc: "gtk_source_buffer_get_style_scheme", libgsv.}
proc setStyleScheme*(buffer: Buffer;
                                   scheme: StyleScheme) {.
    importc: "gtk_source_buffer_set_style_scheme", libgsv.}
proc `styleScheme=`*(buffer: Buffer;
                                   scheme: StyleScheme) {.
    importc: "gtk_source_buffer_set_style_scheme", libgsv.}
proc ensureHighlight*(buffer: Buffer;
                                    start: gtk.TextIter; `end`: gtk.TextIter) {.
    importc: "gtk_source_buffer_ensure_highlight", libgsv.}
proc undo*(buffer: Buffer) {.
    importc: "gtk_source_buffer_undo", libgsv.}
proc redo*(buffer: Buffer) {.
    importc: "gtk_source_buffer_redo", libgsv.}
proc beginNotUndoableAction*(buffer: Buffer) {.
    importc: "gtk_source_buffer_begin_not_undoable_action", libgsv.}
proc endNotUndoableAction*(buffer: Buffer) {.
    importc: "gtk_source_buffer_end_not_undoable_action", libgsv.}
proc createSourceMark*(buffer: Buffer; name: cstring;
                                     category: cstring; where: gtk.TextIter): Mark {.
    importc: "gtk_source_buffer_create_source_mark", libgsv.}
proc forwardIterToSourceMark*(buffer: Buffer;
    iter: gtk.TextIter; category: cstring): Gboolean {.
    importc: "gtk_source_buffer_forward_iter_to_source_mark", libgsv.}
proc backwardIterToSourceMark*(buffer: Buffer;
    iter: gtk.TextIter; category: cstring): Gboolean {.
    importc: "gtk_source_buffer_backward_iter_to_source_mark", libgsv.}
proc getSourceMarksAtIter*(buffer: Buffer;
    iter: gtk.TextIter; category: cstring): glib.GSList {.
    importc: "gtk_source_buffer_get_source_marks_at_iter", libgsv.}
proc sourceMarksAtIter*(buffer: Buffer;
    iter: gtk.TextIter; category: cstring): glib.GSList {.
    importc: "gtk_source_buffer_get_source_marks_at_iter", libgsv.}
proc getSourceMarksAtLine*(buffer: Buffer; line: cint;
    category: cstring): glib.GSList {.importc: "gtk_source_buffer_get_source_marks_at_line",
                                 libgsv.}
proc sourceMarksAtLine*(buffer: Buffer; line: cint;
    category: cstring): glib.GSList {.importc: "gtk_source_buffer_get_source_marks_at_line",
                                 libgsv.}
proc removeSourceMarks*(buffer: Buffer;
                                      start: gtk.TextIter;
                                      `end`: gtk.TextIter; category: cstring) {.
    importc: "gtk_source_buffer_remove_source_marks", libgsv.}
proc iterHasContextClass*(buffer: Buffer;
                                        iter: gtk.TextIter;
                                        contextClass: cstring): Gboolean {.
    importc: "gtk_source_buffer_iter_has_context_class", libgsv.}
proc getContextClassesAtIter*(buffer: Buffer;
    iter: gtk.TextIter): cstringArray {.importc: "gtk_source_buffer_get_context_classes_at_iter",
                                       libgsv.}
proc contextClassesAtIter*(buffer: Buffer;
    iter: gtk.TextIter): cstringArray {.importc: "gtk_source_buffer_get_context_classes_at_iter",
                                       libgsv.}
proc iterForwardToContextClassToggle*(buffer: Buffer;
    iter: gtk.TextIter; contextClass: cstring): Gboolean {.
    importc: "gtk_source_buffer_iter_forward_to_context_class_toggle", libgsv.}
proc iterBackwardToContextClassToggle*(
    buffer: Buffer; iter: gtk.TextIter; contextClass: cstring): Gboolean {.
    importc: "gtk_source_buffer_iter_backward_to_context_class_toggle",
    libgsv.}
proc changeCase*(buffer: Buffer;
                               caseType: ChangeCaseType;
                               start: gtk.TextIter; `end`: gtk.TextIter) {.
    importc: "gtk_source_buffer_change_case", libgsv.}
proc joinLines*(buffer: Buffer; start: gtk.TextIter;
                              `end`: gtk.TextIter) {.
    importc: "gtk_source_buffer_join_lines", libgsv.}
proc sortLines*(buffer: Buffer; start: gtk.TextIter;
                              `end`: gtk.TextIter; flags: SortFlags;
                              column: cint) {.
    importc: "gtk_source_buffer_sort_lines", libgsv.}
proc getUndoManager*(buffer: Buffer): UndoManager {.
    importc: "gtk_source_buffer_get_undo_manager", libgsv.}
proc undoManager*(buffer: Buffer): UndoManager {.
    importc: "gtk_source_buffer_get_undo_manager", libgsv.}
proc setUndoManager*(buffer: Buffer;
                                   manager: UndoManager) {.
    importc: "gtk_source_buffer_set_undo_manager", libgsv.}
proc `undoManager=`*(buffer: Buffer;
                                   manager: UndoManager) {.
    importc: "gtk_source_buffer_set_undo_manager", libgsv.}
proc setImplicitTrailingNewline*(buffer: Buffer;
    implicitTrailingNewline: Gboolean) {.importc: "gtk_source_buffer_set_implicit_trailing_newline",
                                       libgsv.}
proc `implicitTrailingNewline=`*(buffer: Buffer;
    implicitTrailingNewline: Gboolean) {.importc: "gtk_source_buffer_set_implicit_trailing_newline",
                                       libgsv.}
proc getImplicitTrailingNewline*(buffer: Buffer): Gboolean {.
    importc: "gtk_source_buffer_get_implicit_trailing_newline", libgsv.}
proc implicitTrailingNewline*(buffer: Buffer): Gboolean {.
    importc: "gtk_source_buffer_get_implicit_trailing_newline", libgsv.}
proc createSourceTag*(buffer: Buffer; tagName: cstring;
                                    firstPropertyName: cstring): gtk.TextTag {.
    varargs, importc: "gtk_source_buffer_create_source_tag", libgsv.}

type
  CompletionClass* =  ptr CompletionClassObj
  CompletionClassPtr* = ptr CompletionClassObj
  CompletionClassObj*{.final.} = object of GObjectClassObj
    proposalActivated*: proc (completion: Completion;
                            provider: CompletionProvider;
                            proposal: CompletionProposal): Gboolean {.cdecl.}
    show*: proc (completion: Completion) {.cdecl.}
    hide*: proc (completion: Completion) {.cdecl.}
    populateContext*: proc (completion: Completion;
                          context: CompletionContext) {.cdecl.}
    moveCursor*: proc (completion: Completion; step: gtk.ScrollStep;
                     num: cint) {.cdecl.}
    movePage*: proc (completion: Completion; step: gtk.ScrollStep;
                   num: cint) {.cdecl.}
    activateProposal*: proc (completion: Completion) {.cdecl.}

template typeCompletion*(): untyped =
  (completionGetType())

template completion*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletion, CompletionObj))

template completionClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeCompletion, CompletionClassObj))

template isCompletion*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletion))

template isCompletionClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeCompletion))

template completionGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeCompletion, CompletionClassObj))

template completionError*(): untyped =
  (completionErrorQuark())

type
  CompletionError* {.size: sizeof(cint), pure.} = enum
    ALREADY_BOUND = 0,
    NOT_BOUND

type
  View* =  ptr ViewObj
  ViewPtr* = ptr ViewObj
  ViewObj* = object of gtk.TextViewObj
    priv: pointer

proc completionGetType*(): GType {.
    importc: "gtk_source_completion_get_type", libgsv.}
proc completionErrorQuark*(): GQuark {.
    importc: "gtk_source_completion_error_quark", libgsv.}
proc addProvider*(completion: Completion;
                                    provider: CompletionProvider;
                                    error: var glib.GError): Gboolean {.
    importc: "gtk_source_completion_add_provider", libgsv.}
proc removeProvider*(completion: Completion;
    provider: CompletionProvider; error: var glib.GError): Gboolean {.
    importc: "gtk_source_completion_remove_provider", libgsv.}
proc getProviders*(completion: Completion): glib.GList {.
    importc: "gtk_source_completion_get_providers", libgsv.}
proc providers*(completion: Completion): glib.GList {.
    importc: "gtk_source_completion_get_providers", libgsv.}
proc show*(completion: Completion;
                             providers: glib.GList;
                             context: CompletionContext): Gboolean {.
    importc: "gtk_source_completion_show", libgsv.}
proc hide*(completion: Completion) {.
    importc: "gtk_source_completion_hide", libgsv.}
proc getInfoWindow*(completion: Completion): CompletionInfo {.
    importc: "gtk_source_completion_get_info_window", libgsv.}
proc infoWindow*(completion: Completion): CompletionInfo {.
    importc: "gtk_source_completion_get_info_window", libgsv.}
proc getView*(completion: Completion): View {.
    importc: "gtk_source_completion_get_view", libgsv.}
proc view*(completion: Completion): View {.
    importc: "gtk_source_completion_get_view", libgsv.}
proc createContext*(completion: Completion;
                                      position: gtk.TextIter): CompletionContext {.
    importc: "gtk_source_completion_create_context", libgsv.}
proc moveWindow*(completion: Completion;
                                   iter: gtk.TextIter) {.
    importc: "gtk_source_completion_move_window", libgsv.}
proc blockInteractive*(completion: Completion) {.
    importc: "gtk_source_completion_block_interactive", libgsv.}
proc unblockInteractive*(completion: Completion) {.
    importc: "gtk_source_completion_unblock_interactive", libgsv.}
proc addProposals*(completion: Completion;
                                     context: CompletionContext;
                                     provider: CompletionProvider;
                                     proposals: glib.GList; finished: Gboolean) {.
    importc: "_gtk_source_completion_add_proposals", libgsv.}

type
  CompletionInfoClass* =  ptr CompletionInfoClassObj
  CompletionInfoClassPtr* = ptr CompletionInfoClassObj
  CompletionInfoClassObj*{.final.} = object of gtk.WindowClassObj
    beforeShow*: proc (info: CompletionInfo) {.cdecl.}

template typeCompletionInfo*(): untyped =
  (completionInfoGetType())

template completionInfo*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionInfo, CompletionInfoObj))

template completionInfoClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeCompletionInfo, CompletionInfoClassObj))

template isCompletionInfo*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionInfo))

template isCompletionInfoClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeCompletionInfo))

template completionInfoGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeCompletionInfo, CompletionInfoClassObj))

proc completionInfoGetType*(): GType {.
    importc: "gtk_source_completion_info_get_type", libgsv.}
proc newCompletionInfo*(): CompletionInfo {.
    importc: "gtk_source_completion_info_new", libgsv.}
proc moveToIter*(info: CompletionInfo;
                                       view: gtk.TextView; iter: gtk.TextIter) {.
    importc: "gtk_source_completion_info_move_to_iter", libgsv.}
proc setWidget*(info: CompletionInfo;
                                      widget: gtk.Widget) {.
    importc: "gtk_source_completion_info_set_widget", libgsv.}
proc `widget=`*(info: CompletionInfo;
                                      widget: gtk.Widget) {.
    importc: "gtk_source_completion_info_set_widget", libgsv.}
proc getWidget*(info: CompletionInfo): gtk.Widget {.
    importc: "gtk_source_completion_info_get_widget", libgsv.}
proc widget*(info: CompletionInfo): gtk.Widget {.
    importc: "gtk_source_completion_info_get_widget", libgsv.}
proc setXoffset*(info: CompletionInfo;
                                       xoffset: cint) {.
    importc: "_gtk_source_completion_info_set_xoffset", libgsv.}
proc `xoffset=`*(info: CompletionInfo;
                                       xoffset: cint) {.
    importc: "_gtk_source_completion_info_set_xoffset", libgsv.}

template typeCompletionItem*(): untyped =
  (completionItemGetType())

template completionItem*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionItem, CompletionItemObj))

template completionItemClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeCompletionItem, CompletionItemClassObj))

template isCompletionItem*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionItem))

template isCompletionItemClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeCompletionItem))

template completionItemGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeCompletionItem, CompletionItemClassObj))

type
  CompletionItem* =  ptr CompletionItemObj
  CompletionItemPtr* = ptr CompletionItemObj
  CompletionItemObj*{.final.} = object of GObjectObj
    priv: pointer

  CompletionItemClass* =  ptr CompletionItemClassObj
  CompletionItemClassPtr* = ptr CompletionItemClassObj
  CompletionItemClassObj*{.final.} = object of GObjectClassObj

proc completionItemGetType*(): GType {.
    importc: "gtk_source_completion_item_get_type", libgsv.}
proc newCompletionItemWithLabel*(label: cstring; text: cstring; icon: gdk_pixbuf.GdkPixbuf;
                                info: cstring): CompletionItem {.
    importc: "gtk_source_completion_item_new", libgsv.}
proc newCompletionItemWithMarkup*(markup: cstring; text: cstring;
    icon: gdk_pixbuf.GdkPixbuf; info: cstring): CompletionItem {.
    importc: "gtk_source_completion_item_new_with_markup", libgsv.}
proc newCompletionItem*(label: cstring; text: cstring;
    stock: cstring; info: cstring): CompletionItem {.
    importc: "gtk_source_completion_item_new_from_stock", libgsv.}
proc completionItemNew2*(): CompletionItem {.
    importc: "gtk_source_completion_item_new2", libgsv.}
proc setLabel*(item: CompletionItem;
                                     label: cstring) {.
    importc: "gtk_source_completion_item_set_label", libgsv.}
proc `label=`*(item: CompletionItem;
                                     label: cstring) {.
    importc: "gtk_source_completion_item_set_label", libgsv.}
proc setMarkup*(item: CompletionItem;
                                      markup: cstring) {.
    importc: "gtk_source_completion_item_set_markup", libgsv.}
proc `markup=`*(item: CompletionItem;
                                      markup: cstring) {.
    importc: "gtk_source_completion_item_set_markup", libgsv.}
proc setText*(item: CompletionItem;
                                    text: cstring) {.
    importc: "gtk_source_completion_item_set_text", libgsv.}
proc `text=`*(item: CompletionItem;
                                    text: cstring) {.
    importc: "gtk_source_completion_item_set_text", libgsv.}
proc setIcon*(item: CompletionItem;
                                    icon: gdk_pixbuf.GdkPixbuf) {.
    importc: "gtk_source_completion_item_set_icon", libgsv.}
proc `icon=`*(item: CompletionItem;
                                    icon: gdk_pixbuf.GdkPixbuf) {.
    importc: "gtk_source_completion_item_set_icon", libgsv.}
proc setIconName*(item: CompletionItem;
                                        iconName: cstring) {.
    importc: "gtk_source_completion_item_set_icon_name", libgsv.}
proc `iconName=`*(item: CompletionItem;
                                        iconName: cstring) {.
    importc: "gtk_source_completion_item_set_icon_name", libgsv.}
proc setGicon*(item: CompletionItem;
                                     gicon: gio.GIcon) {.
    importc: "gtk_source_completion_item_set_gicon", libgsv.}
proc `gicon=`*(item: CompletionItem;
                                     gicon: gio.GIcon) {.
    importc: "gtk_source_completion_item_set_gicon", libgsv.}
proc setInfo*(item: CompletionItem;
                                    info: cstring) {.
    importc: "gtk_source_completion_item_set_info", libgsv.}
proc `info=`*(item: CompletionItem;
                                    info: cstring) {.
    importc: "gtk_source_completion_item_set_info", libgsv.}

type
  CompletionProposalIface* =  ptr CompletionProposalIfaceObj
  CompletionProposalIfacePtr* = ptr CompletionProposalIfaceObj
  CompletionProposalIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
    getLabel*: proc (proposal: CompletionProposal): cstring {.cdecl.}
    getMarkup*: proc (proposal: CompletionProposal): cstring {.cdecl.}
    getText*: proc (proposal: CompletionProposal): cstring {.cdecl.}
    getIcon*: proc (proposal: CompletionProposal): gdk_pixbuf.GdkPixbuf {.cdecl.}
    getIconName*: proc (proposal: CompletionProposal): cstring {.cdecl.}
    getGicon*: proc (proposal: CompletionProposal): gio.GIcon {.cdecl.}
    getInfo*: proc (proposal: CompletionProposal): cstring {.cdecl.}
    hash*: proc (proposal: CompletionProposal): cuint {.cdecl.}
    equal*: proc (proposal: CompletionProposal;
                other: CompletionProposal): Gboolean {.cdecl.}
    changed*: proc (proposal: CompletionProposal) {.cdecl.}

template typeCompletionProposal*(): untyped =
  (completionProposalGetType())

template completionProposal*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionProposal, CompletionProposalObj))

template isCompletionProposal*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionProposal))

template completionProposalGetInterface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeCompletionProposal, CompletionProposalIfaceObj))

proc completionProposalGetType*(): GType {.
    importc: "gtk_source_completion_proposal_get_type", libgsv.}
proc getLabel*(
    proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_label", libgsv.}
proc label*(
    proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_label", libgsv.}
proc getMarkup*(
    proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_markup", libgsv.}
proc markup*(
    proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_markup", libgsv.}
proc getText*(proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_text", libgsv.}
proc text*(proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_text", libgsv.}
proc getIcon*(proposal: CompletionProposal): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_completion_proposal_get_icon", libgsv.}
proc icon*(proposal: CompletionProposal): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_completion_proposal_get_icon", libgsv.}
proc getIconName*(
    proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_icon_name", libgsv.}
proc iconName*(
    proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_icon_name", libgsv.}
proc getGicon*(
    proposal: CompletionProposal): gio.GIcon {.
    importc: "gtk_source_completion_proposal_get_gicon", libgsv.}
proc gicon*(
    proposal: CompletionProposal): gio.GIcon {.
    importc: "gtk_source_completion_proposal_get_gicon", libgsv.}
proc getInfo*(proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_info", libgsv.}
proc info*(proposal: CompletionProposal): cstring {.
    importc: "gtk_source_completion_proposal_get_info", libgsv.}
proc changed*(proposal: CompletionProposal) {.
    importc: "gtk_source_completion_proposal_changed", libgsv.}
proc hash*(proposal: CompletionProposal): cuint {.
    importc: "gtk_source_completion_proposal_hash", libgsv.}
proc equal*(proposal: CompletionProposal;
                                      other: CompletionProposal): Gboolean {.
    importc: "gtk_source_completion_proposal_equal", libgsv.}

template typeEncoding*(): untyped =
  (encodingGetType())

proc encodingGetType*(): GType {.importc: "gtk_source_encoding_get_type",
                                       libgsv.}
proc encodingGetFromCharset*(charset: cstring): Encoding {.
    importc: "gtk_source_encoding_get_from_charset", libgsv.}
proc toString*(enc: Encoding): cstring {.
    importc: "gtk_source_encoding_to_string", libgsv.}
proc getName*(enc: Encoding): cstring {.
    importc: "gtk_source_encoding_get_name", libgsv.}
proc name*(enc: Encoding): cstring {.
    importc: "gtk_source_encoding_get_name", libgsv.}
proc getCharset*(enc: Encoding): cstring {.
    importc: "gtk_source_encoding_get_charset", libgsv.}
proc charset*(enc: Encoding): cstring {.
    importc: "gtk_source_encoding_get_charset", libgsv.}
proc encodingGetUtf8*(): Encoding {.
    importc: "gtk_source_encoding_get_utf8", libgsv.}
proc encodingGetCurrent*(): Encoding {.
    importc: "gtk_source_encoding_get_current", libgsv.}
proc encodingGetAll*(): glib.GSList {.
    importc: "gtk_source_encoding_get_all", libgsv.}
proc encodingGetDefaultCandidates*(): glib.GSList {.
    importc: "gtk_source_encoding_get_default_candidates", libgsv.}

proc copy*(enc: Encoding): Encoding {.
    importc: "gtk_source_encoding_copy", libgsv.}
proc free*(enc: Encoding) {.
    importc: "gtk_source_encoding_free", libgsv.}

type
  FileClass* =  ptr FileClassObj
  FileClassPtr* = ptr FileClassObj
  FileClassObj*{.final.} = object of GObjectClassObj
    padding*: array[10, Gpointer]

  File* =  ptr FileObj
  FilePtr* = ptr FileObj
  FileObj*{.final.} = object of GObjectObj
    priv: pointer

template typeFile*(): untyped =
  (fileGetType())

template file*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeFile, FileObj))

template fileClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeFile, FileClassObj))

template isFile*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeFile))

template isFileClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeFile))

template fileGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeFile, FileClassObj))

type
  NewlineType* {.size: sizeof(cint), pure.} = enum
    LF, CR,
    CR_LF

when defined(windows):
  const
    NEWLINE_TYPE_DEFAULT* = NewlineType.CR_LF
else:
  const
    NEWLINE_TYPE_DEFAULT* = NewlineType.LF

type
  CompressionType* {.size: sizeof(cint), pure.} = enum
    NONE, GZIP

type
  MountOperationFactory* = proc (file: File; userdata: Gpointer): gio.GMountOperation {.cdecl.}

proc fileGetType*(): GType {.importc: "gtk_source_file_get_type",
                                   libgsv.}
proc newFile*(): File {.importc: "gtk_source_file_new",
    libgsv.}
proc getLocation*(file: File): gio.GFile {.
    importc: "gtk_source_file_get_location", libgsv.}
proc location*(file: File): gio.GFile {.
    importc: "gtk_source_file_get_location", libgsv.}
proc setLocation*(file: File; location: gio.GFile) {.
    importc: "gtk_source_file_set_location", libgsv.}
proc `location=`*(file: File; location: gio.GFile) {.
    importc: "gtk_source_file_set_location", libgsv.}
proc getEncoding*(file: File): Encoding {.
    importc: "gtk_source_file_get_encoding", libgsv.}
proc encoding*(file: File): Encoding {.
    importc: "gtk_source_file_get_encoding", libgsv.}
proc getNewlineType*(file: File): NewlineType {.
    importc: "gtk_source_file_get_newline_type", libgsv.}
proc newlineType*(file: File): NewlineType {.
    importc: "gtk_source_file_get_newline_type", libgsv.}
proc getCompressionType*(file: File): CompressionType {.
    importc: "gtk_source_file_get_compression_type", libgsv.}
proc compressionType*(file: File): CompressionType {.
    importc: "gtk_source_file_get_compression_type", libgsv.}
proc setMountOperationFactory*(file: File;
    callback: MountOperationFactory; userData: Gpointer;
    notify: GDestroyNotify) {.importc: "gtk_source_file_set_mount_operation_factory",
                            libgsv.}
proc `mountOperationFactory=`*(file: File;
    callback: MountOperationFactory; userData: Gpointer;
    notify: GDestroyNotify) {.importc: "gtk_source_file_set_mount_operation_factory",
                            libgsv.}
proc checkFileOnDisk*(file: File) {.
    importc: "gtk_source_file_check_file_on_disk", libgsv.}
proc isLocal*(file: File): Gboolean {.
    importc: "gtk_source_file_is_local", libgsv.}
proc isExternallyModified*(file: File): Gboolean {.
    importc: "gtk_source_file_is_externally_modified", libgsv.}
proc isDeleted*(file: File): Gboolean {.
    importc: "gtk_source_file_is_deleted", libgsv.}
proc isReadonly*(file: File): Gboolean {.
    importc: "gtk_source_file_is_readonly", libgsv.}
proc setEncoding*(file: File;
                              encoding: Encoding) {.
    importc: "_gtk_source_file_set_encoding", libgsv.}
proc `encoding=`*(file: File;
                              encoding: Encoding) {.
    importc: "_gtk_source_file_set_encoding", libgsv.}
proc setNewlineType*(file: File;
                                 newlineType: NewlineType) {.
    importc: "_gtk_source_file_set_newline_type", libgsv.}
proc `newlineType=`*(file: File;
                                 newlineType: NewlineType) {.
    importc: "_gtk_source_file_set_newline_type", libgsv.}
proc setCompressionType*(file: File;
                                     compressionType: CompressionType) {.
    importc: "_gtk_source_file_set_compression_type", libgsv.}
proc `compressionType=`*(file: File;
                                     compressionType: CompressionType) {.
    importc: "_gtk_source_file_set_compression_type", libgsv.}
proc createMountOperation*(file: File): gio.GMountOperation {.
    importc: "_gtk_source_file_create_mount_operation", libgsv.}
proc getModificationTime*(file: File;
                                      modificationTime: glib.GTimeVal): Gboolean {.
    importc: "_gtk_source_file_get_modification_time", libgsv.}
proc modificationTime*(file: File;
                                      modificationTime: glib.GTimeVal): Gboolean {.
    importc: "_gtk_source_file_get_modification_time", libgsv.}
proc setModificationTime*(file: File;
                                      modificationTime: glib.GTimeValObj) {.
    importc: "_gtk_source_file_set_modification_time", libgsv.}
proc `modificationTime=`*(file: File;
                                      modificationTime: glib.GTimeValObj) {.
    importc: "_gtk_source_file_set_modification_time", libgsv.}
proc setExternallyModified*(file: File;
                                        externallyModified: Gboolean) {.
    importc: "_gtk_source_file_set_externally_modified", libgsv.}
proc `externallyModified=`*(file: File;
                                        externallyModified: Gboolean) {.
    importc: "_gtk_source_file_set_externally_modified", libgsv.}
proc setDeleted*(file: File; deleted: Gboolean) {.
    importc: "_gtk_source_file_set_deleted", libgsv.}
proc `deleted=`*(file: File; deleted: Gboolean) {.
    importc: "_gtk_source_file_set_deleted", libgsv.}
proc setReadonly*(file: File; readonly: Gboolean) {.
    importc: "_gtk_source_file_set_readonly", libgsv.}
proc `readonly=`*(file: File; readonly: Gboolean) {.
    importc: "_gtk_source_file_set_readonly", libgsv.}

type
  FileLoaderClass* =  ptr FileLoaderClassObj
  FileLoaderClassPtr* = ptr FileLoaderClassObj
  FileLoaderClassObj*{.final.} = object of GObjectClassObj
    padding*: array[10, Gpointer]

  FileLoader* =  ptr FileLoaderObj
  FileLoaderPtr* = ptr FileLoaderObj
  FileLoaderObj*{.final.} = object of GObjectObj
    priv: pointer

template typeFileLoader*(): untyped =
  (fileLoaderGetType())

template fileLoader*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeFileLoader, FileLoaderObj))

template fileLoaderClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeFileLoader, FileLoaderClassObj))

template isFileLoader*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeFileLoader))

template isFileLoaderClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeFileLoader))

template fileLoaderGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeFileLoader, FileLoaderClassObj))

template fileLoaderError*(): untyped =
  fileLoaderErrorQuark()

type
  FileLoaderError* {.size: sizeof(cint), pure.} = enum
    TOO_BIG,
    ENCODING_AUTO_DETECTION_FAILED,
    CONVERSION_FALLBACK

proc fileLoaderGetType*(): GType {.
    importc: "gtk_source_file_loader_get_type", libgsv.}
proc fileLoaderErrorQuark*(): GQuark {.
    importc: "gtk_source_file_loader_error_quark", libgsv.}
proc newFileLoader*(buffer: Buffer; file: File): FileLoader {.
    importc: "gtk_source_file_loader_new", libgsv.}
proc newFileLoader*(buffer: Buffer;
                                      file: File;
                                      stream: gio.GInputStream): FileLoader {.
    importc: "gtk_source_file_loader_new_from_stream", libgsv.}
proc setCandidateEncodings*(loader: FileLoader;
    candidateEncodings: glib.GSList) {.importc: "gtk_source_file_loader_set_candidate_encodings",
                                   libgsv.}
proc `candidateEncodings=`*(loader: FileLoader;
    candidateEncodings: glib.GSList) {.importc: "gtk_source_file_loader_set_candidate_encodings",
                                   libgsv.}
proc getBuffer*(loader: FileLoader): Buffer {.
    importc: "gtk_source_file_loader_get_buffer", libgsv.}
proc buffer*(loader: FileLoader): Buffer {.
    importc: "gtk_source_file_loader_get_buffer", libgsv.}
proc getFile*(loader: FileLoader): File {.
    importc: "gtk_source_file_loader_get_file", libgsv.}
proc file*(loader: FileLoader): File {.
    importc: "gtk_source_file_loader_get_file", libgsv.}
proc getLocation*(loader: FileLoader): gio.GFile {.
    importc: "gtk_source_file_loader_get_location", libgsv.}
proc location*(loader: FileLoader): gio.GFile {.
    importc: "gtk_source_file_loader_get_location", libgsv.}
proc getInputStream*(loader: FileLoader): gio.GInputStream {.
    importc: "gtk_source_file_loader_get_input_stream", libgsv.}
proc inputStream*(loader: FileLoader): gio.GInputStream {.
    importc: "gtk_source_file_loader_get_input_stream", libgsv.}
proc loadAsync*(loader: FileLoader;
                                  ioPriority: cint; cancellable: gio.GCancellable;
                                  progressCallback: GFileProgressCallback;
                                  progressCallbackData: Gpointer;
                                  progressCallbackNotify: GDestroyNotify;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "gtk_source_file_loader_load_async", libgsv.}
proc loadFinish*(loader: FileLoader;
                                   result: gio.GAsyncResult; error: var glib.GError): Gboolean {.
    importc: "gtk_source_file_loader_load_finish", libgsv.}
proc getEncoding*(loader: FileLoader): Encoding {.
    importc: "gtk_source_file_loader_get_encoding", libgsv.}
proc encoding*(loader: FileLoader): Encoding {.
    importc: "gtk_source_file_loader_get_encoding", libgsv.}
proc getNewlineType*(loader: FileLoader): NewlineType {.
    importc: "gtk_source_file_loader_get_newline_type", libgsv.}
proc newlineType*(loader: FileLoader): NewlineType {.
    importc: "gtk_source_file_loader_get_newline_type", libgsv.}
proc getCompressionType*(loader: FileLoader): CompressionType {.
    importc: "gtk_source_file_loader_get_compression_type", libgsv.}
proc compressionType*(loader: FileLoader): CompressionType {.
    importc: "gtk_source_file_loader_get_compression_type", libgsv.}

type
  FileSaver* =  ptr FileSaverObj
  FileSaverPtr* = ptr FileSaverObj
  FileSaverObj*{.final.} = object of GObjectObj
    priv: pointer

  FileSaverClass* =  ptr FileSaverClassObj
  FileSaverClassPtr* = ptr FileSaverClassObj
  FileSaverClassObj*{.final.} = object of GObjectClassObj
    padding*: array[10, Gpointer]

template typeFileSaver*(): untyped =
  (fileSaverGetType())

template fileSaver*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeFileSaver, FileSaverObj))

template fileSaverClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeFileSaver, FileSaverClassObj))

template isFileSaver*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeFileSaver))

template isFileSaverClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeFileSaver))

template fileSaverGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeFileSaver, FileSaverClassObj))

template fileSaverError*(): untyped =
  fileSaverErrorQuark()

type
  FileSaverError* {.size: sizeof(cint), pure.} = enum
    INVALID_CHARS,
    EXTERNALLY_MODIFIED

type
  FileSaverFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    IGNORE_INVALID_CHARS = 1 shl 0,
    IGNORE_MODIFICATION_TIME = 1 shl 1,
    CREATE_BACKUP = 1 shl 2

proc fileSaverGetType*(): GType {.importc: "gtk_source_file_saver_get_type",
                                        libgsv.}
proc fileSaverErrorQuark*(): GQuark {.
    importc: "gtk_source_file_saver_error_quark", libgsv.}
proc newFileSaver*(buffer: Buffer; file: File): FileSaver {.
    importc: "gtk_source_file_saver_new", libgsv.}
proc newFileSaver*(buffer: Buffer;
                                     file: File;
                                     targetLocation: gio.GFile): FileSaver {.
    importc: "gtk_source_file_saver_new_with_target", libgsv.}
proc getBuffer*(saver: FileSaver): Buffer {.
    importc: "gtk_source_file_saver_get_buffer", libgsv.}
proc buffer*(saver: FileSaver): Buffer {.
    importc: "gtk_source_file_saver_get_buffer", libgsv.}
proc getFile*(saver: FileSaver): File {.
    importc: "gtk_source_file_saver_get_file", libgsv.}
proc file*(saver: FileSaver): File {.
    importc: "gtk_source_file_saver_get_file", libgsv.}
proc getLocation*(saver: FileSaver): gio.GFile {.
    importc: "gtk_source_file_saver_get_location", libgsv.}
proc location*(saver: FileSaver): gio.GFile {.
    importc: "gtk_source_file_saver_get_location", libgsv.}
proc setEncoding*(saver: FileSaver;
                                   encoding: Encoding) {.
    importc: "gtk_source_file_saver_set_encoding", libgsv.}
proc `encoding=`*(saver: FileSaver;
                                   encoding: Encoding) {.
    importc: "gtk_source_file_saver_set_encoding", libgsv.}
proc getEncoding*(saver: FileSaver): Encoding {.
    importc: "gtk_source_file_saver_get_encoding", libgsv.}
proc encoding*(saver: FileSaver): Encoding {.
    importc: "gtk_source_file_saver_get_encoding", libgsv.}
proc setNewlineType*(saver: FileSaver;
                                      newlineType: NewlineType) {.
    importc: "gtk_source_file_saver_set_newline_type", libgsv.}
proc `newlineType=`*(saver: FileSaver;
                                      newlineType: NewlineType) {.
    importc: "gtk_source_file_saver_set_newline_type", libgsv.}
proc getNewlineType*(saver: FileSaver): NewlineType {.
    importc: "gtk_source_file_saver_get_newline_type", libgsv.}
proc newlineType*(saver: FileSaver): NewlineType {.
    importc: "gtk_source_file_saver_get_newline_type", libgsv.}
proc setCompressionType*(saver: FileSaver;
    compressionType: CompressionType) {.
    importc: "gtk_source_file_saver_set_compression_type", libgsv.}
proc `compressionType=`*(saver: FileSaver;
    compressionType: CompressionType) {.
    importc: "gtk_source_file_saver_set_compression_type", libgsv.}
proc getCompressionType*(saver: FileSaver): CompressionType {.
    importc: "gtk_source_file_saver_get_compression_type", libgsv.}
proc compressionType*(saver: FileSaver): CompressionType {.
    importc: "gtk_source_file_saver_get_compression_type", libgsv.}
proc setFlags*(saver: FileSaver;
                                flags: FileSaverFlags) {.
    importc: "gtk_source_file_saver_set_flags", libgsv.}
proc `flags=`*(saver: FileSaver;
                                flags: FileSaverFlags) {.
    importc: "gtk_source_file_saver_set_flags", libgsv.}
proc getFlags*(saver: FileSaver): FileSaverFlags {.
    importc: "gtk_source_file_saver_get_flags", libgsv.}
proc flags*(saver: FileSaver): FileSaverFlags {.
    importc: "gtk_source_file_saver_get_flags", libgsv.}
proc saveAsync*(saver: FileSaver; ioPriority: cint;
                                 cancellable: gio.GCancellable;
                                 progressCallback: GFileProgressCallback;
                                 progressCallbackData: Gpointer;
                                 progressCallbackNotify: GDestroyNotify;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "gtk_source_file_saver_save_async", libgsv.}
proc saveFinish*(saver: FileSaver;
                                  result: gio.GAsyncResult; error: var glib.GError): Gboolean {.
    importc: "gtk_source_file_saver_save_finish", libgsv.}

type
  GutterClass* =  ptr GutterClassObj
  GutterClassPtr* = ptr GutterClassObj
  GutterClassObj*{.final.} = object of GObjectClassObj

  Gutter* =  ptr GutterObj
  GutterPtr* = ptr GutterObj
  GutterObj*{.final.} = object of GObjectObj
    priv: pointer

template typeGutter*(): untyped =
  (gutterGetType())

template gutter*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeGutter, GutterObj))

template gutterClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeGutter, GutterClassObj))

template isGutter*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeGutter))

template isGutterClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeGutter))

template gutterGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeGutter, GutterClassObj))

type
  GutterRendererState* {.size: sizeof(cint), pure.} = enum
    NORMAL = 0,
    CURSOR = 1 shl 0,
    PRELIT = 1 shl 1,
    SELECTED = 1 shl 2
  GutterRenderer* =  ptr GutterRendererObj
  GutterRendererPtr* = ptr GutterRendererObj
  GutterRendererObj* = object of gobject.GInitiallyUnownedObj
    priv: pointer

proc gutterGetType*(): GType {.importc: "gtk_source_gutter_get_type",
                                     libgsv.}
proc getView*(gutter: Gutter): View {.
    importc: "gtk_source_gutter_get_view", libgsv.}
proc view*(gutter: Gutter): View {.
    importc: "gtk_source_gutter_get_view", libgsv.}
proc getWindowType*(gutter: Gutter): gtk.TextWindowType {.
    importc: "gtk_source_gutter_get_window_type", libgsv.}
proc windowType*(gutter: Gutter): gtk.TextWindowType {.
    importc: "gtk_source_gutter_get_window_type", libgsv.}
proc getWindow*(gutter: Gutter): gdk.Window {.
    importc: "gtk_source_gutter_get_window", libgsv.}
proc window*(gutter: Gutter): gdk.Window {.
    importc: "gtk_source_gutter_get_window", libgsv.}
proc insert*(gutter: Gutter;
                           renderer: GutterRenderer; position: cint): Gboolean {.
    importc: "gtk_source_gutter_insert", libgsv.}
proc reorder*(gutter: Gutter;
                            renderer: GutterRenderer; position: cint) {.
    importc: "gtk_source_gutter_reorder", libgsv.}
proc remove*(gutter: Gutter;
                           renderer: GutterRenderer) {.
    importc: "gtk_source_gutter_remove", libgsv.}
proc queueDraw*(gutter: Gutter) {.
    importc: "gtk_source_gutter_queue_draw", libgsv.}
proc setPadding*(gutter: Gutter; xpad: cint; ypad: cint) {.
    importc: "gtk_source_gutter_set_padding", libgsv.}
proc `padding=`*(gutter: Gutter; xpad: cint; ypad: cint) {.
    importc: "gtk_source_gutter_set_padding", libgsv.}
proc getPadding*(gutter: Gutter; xpad: var cint;
                               ypad: var cint) {.
    importc: "gtk_source_gutter_get_padding", libgsv.}
proc getRendererAtPos*(gutter: Gutter; x: cint; y: cint): GutterRenderer {.
    importc: "gtk_source_gutter_get_renderer_at_pos", libgsv.}
proc rendererAtPos*(gutter: Gutter; x: cint; y: cint): GutterRenderer {.
    importc: "gtk_source_gutter_get_renderer_at_pos", libgsv.}

type
  GutterRendererClass* =  ptr GutterRendererClassObj
  GutterRendererClassPtr* = ptr GutterRendererClassObj
  GutterRendererClassObj* = object of gobject.GInitiallyUnownedClassObj
    begin*: proc (renderer: GutterRenderer; cr: cairo.Context;
                backgroundArea: gdk.Rectangle; cellArea: gdk.Rectangle;
                start: gtk.TextIter; `end`: gtk.TextIter) {.cdecl.}
    draw*: proc (renderer: GutterRenderer; cr: cairo.Context;
               backgroundArea: gdk.Rectangle; cellArea: gdk.Rectangle;
               start: gtk.TextIter; `end`: gtk.TextIter;
               state: GutterRendererState) {.cdecl.}
    `end`*: proc (renderer: GutterRenderer) {.cdecl.}
    changeView*: proc (renderer: GutterRenderer;
                     oldView: gtk.TextView) {.cdecl.}
    changeBuffer*: proc (renderer: GutterRenderer;
                       oldBuffer: gtk.TextBuffer) {.cdecl.}
    queryActivatable*: proc (renderer: GutterRenderer;
                           iter: gtk.TextIter; area: gdk.Rectangle;
                           event: gdk.Event): Gboolean {.cdecl.}
    activate*: proc (renderer: GutterRenderer; iter: gtk.TextIter;
                   area: gdk.Rectangle; event: gdk.Event) {.cdecl.}
    queueDraw*: proc (renderer: GutterRenderer) {.cdecl.}
    queryTooltip*: proc (renderer: GutterRenderer;
                       iter: gtk.TextIter; area: gdk.Rectangle; x: cint; y: cint;
                       tooltip: gtk.Tooltip): Gboolean {.cdecl.}
    queryData*: proc (renderer: GutterRenderer; start: gtk.TextIter;
                    `end`: gtk.TextIter; state: GutterRendererState) {.cdecl.}

template typeGutterRenderer*(): untyped =
  (gutterRendererGetType())

template gutterRenderer*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeGutterRenderer, GutterRendererObj))

template gutterRendererClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeGutterRenderer, GutterRendererClassObj))

template isGutterRenderer*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeGutterRenderer))

template isGutterRendererClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeGutterRenderer))

template gutterRendererGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeGutterRenderer, GutterRendererClassObj))

type
  GutterRendererAlignmentMode* {.size: sizeof(cint), pure.} = enum
    CELL,
    FIRST,
    LAST

proc gutterRendererGetType*(): GType {.
    importc: "gtk_source_gutter_renderer_get_type", libgsv.}
proc begin*(renderer: GutterRenderer;
                                  cr: cairo.Context; backgroundArea: gdk.Rectangle;
                                  cellArea: gdk.Rectangle;
                                  start: gtk.TextIter; `end`: gtk.TextIter) {.
    importc: "gtk_source_gutter_renderer_begin", libgsv.}
proc draw*(renderer: GutterRenderer;
                                 cr: cairo.Context; backgroundArea: gdk.Rectangle;
                                 cellArea: gdk.Rectangle;
                                 start: gtk.TextIter; `end`: gtk.TextIter;
                                 state: GutterRendererState) {.
    importc: "gtk_source_gutter_renderer_draw", libgsv.}
proc `end`*(renderer: GutterRenderer) {.
    importc: "gtk_source_gutter_renderer_end", libgsv.}
proc getSize*(renderer: GutterRenderer): cint {.
    importc: "gtk_source_gutter_renderer_get_size", libgsv.}
proc size*(renderer: GutterRenderer): cint {.
    importc: "gtk_source_gutter_renderer_get_size", libgsv.}
proc setSize*(renderer: GutterRenderer;
                                    size: cint) {.
    importc: "gtk_source_gutter_renderer_set_size", libgsv.}
proc `size=`*(renderer: GutterRenderer;
                                    size: cint) {.
    importc: "gtk_source_gutter_renderer_set_size", libgsv.}
proc setVisible*(renderer: GutterRenderer;
                                       visible: Gboolean) {.
    importc: "gtk_source_gutter_renderer_set_visible", libgsv.}
proc `visible=`*(renderer: GutterRenderer;
                                       visible: Gboolean) {.
    importc: "gtk_source_gutter_renderer_set_visible", libgsv.}
proc getVisible*(renderer: GutterRenderer): Gboolean {.
    importc: "gtk_source_gutter_renderer_get_visible", libgsv.}
proc visible*(renderer: GutterRenderer): Gboolean {.
    importc: "gtk_source_gutter_renderer_get_visible", libgsv.}
proc getPadding*(renderer: GutterRenderer;
                                       xpad: var cint; ypad: var cint) {.
    importc: "gtk_source_gutter_renderer_get_padding", libgsv.}
proc setPadding*(renderer: GutterRenderer;
                                       xpad: cint; ypad: cint) {.
    importc: "gtk_source_gutter_renderer_set_padding", libgsv.}
proc `padding=`*(renderer: GutterRenderer;
                                       xpad: cint; ypad: cint) {.
    importc: "gtk_source_gutter_renderer_set_padding", libgsv.}
proc getAlignment*(renderer: GutterRenderer;
    xalign: var cfloat; yalign: var cfloat) {.importc: "gtk_source_gutter_renderer_get_alignment",
                                        libgsv.}
proc setAlignment*(renderer: GutterRenderer;
    xalign: cfloat; yalign: cfloat) {.importc: "gtk_source_gutter_renderer_set_alignment",
                                  libgsv.}
proc `alignment=`*(renderer: GutterRenderer;
    xalign: cfloat; yalign: cfloat) {.importc: "gtk_source_gutter_renderer_set_alignment",
                                  libgsv.}
proc setAlignmentMode*(
    renderer: GutterRenderer;
    mode: GutterRendererAlignmentMode) {.
    importc: "gtk_source_gutter_renderer_set_alignment_mode", libgsv.}
proc `alignmentMode=`*(
    renderer: GutterRenderer;
    mode: GutterRendererAlignmentMode) {.
    importc: "gtk_source_gutter_renderer_set_alignment_mode", libgsv.}
proc getWindowType*(renderer: GutterRenderer): gtk.TextWindowType {.
    importc: "gtk_source_gutter_renderer_get_window_type", libgsv.}
proc windowType*(renderer: GutterRenderer): gtk.TextWindowType {.
    importc: "gtk_source_gutter_renderer_get_window_type", libgsv.}
proc getView*(renderer: GutterRenderer): gtk.TextView {.
    importc: "gtk_source_gutter_renderer_get_view", libgsv.}
proc view*(renderer: GutterRenderer): gtk.TextView {.
    importc: "gtk_source_gutter_renderer_get_view", libgsv.}
proc getAlignmentMode*(
    renderer: GutterRenderer): GutterRendererAlignmentMode {.
    importc: "gtk_source_gutter_renderer_get_alignment_mode", libgsv.}
proc alignmentMode*(
    renderer: GutterRenderer): GutterRendererAlignmentMode {.
    importc: "gtk_source_gutter_renderer_get_alignment_mode", libgsv.}
proc getBackground*(renderer: GutterRenderer;
    color: gdk.RGBA): Gboolean {.importc: "gtk_source_gutter_renderer_get_background",
                                libgsv.}
proc background*(renderer: GutterRenderer;
    color: gdk.RGBA): Gboolean {.importc: "gtk_source_gutter_renderer_get_background",
                                libgsv.}
proc setBackground*(renderer: GutterRenderer;
    color: gdk.RGBA) {.importc: "gtk_source_gutter_renderer_set_background",
                       libgsv.}
proc `background=`*(renderer: GutterRenderer;
    color: gdk.RGBA) {.importc: "gtk_source_gutter_renderer_set_background",
                       libgsv.}

proc activate*(renderer: GutterRenderer;
                                     iter: gtk.TextIter; area: gdk.Rectangle;
                                     event: gdk.Event) {.
    importc: "gtk_source_gutter_renderer_activate", libgsv.}

proc queryActivatable*(
    renderer: GutterRenderer; iter: gtk.TextIter;
    area: gdk.Rectangle; event: gdk.Event): Gboolean {.
    importc: "gtk_source_gutter_renderer_query_activatable", libgsv.}

proc queueDraw*(renderer: GutterRenderer) {.
    importc: "gtk_source_gutter_renderer_queue_draw", libgsv.}

proc queryTooltip*(renderer: GutterRenderer;
    iter: gtk.TextIter; area: gdk.Rectangle; x: cint; y: cint;
    tooltip: gtk.Tooltip): Gboolean {.importc: "gtk_source_gutter_renderer_query_tooltip",
                                     libgsv.}

proc queryData*(renderer: GutterRenderer;
                                      start: gtk.TextIter;
                                      `end`: gtk.TextIter;
                                      state: GutterRendererState) {.
    importc: "gtk_source_gutter_renderer_query_data", libgsv.}

type
  GutterRendererTextClass* =  ptr GutterRendererTextClassObj
  GutterRendererTextClassPtr* = ptr GutterRendererTextClassObj
  GutterRendererTextClassObj*{.final.} = object of GutterRendererClassObj

  GutterRendererText* =  ptr GutterRendererTextObj
  GutterRendererTextPtr* = ptr GutterRendererTextObj
  GutterRendererTextObj*{.final.} = object of GutterRendererObj
    priv0: pointer

template typeGutterRendererText*(): untyped =
  (gutterRendererTextGetType())

template gutterRendererText*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeGutterRendererText, GutterRendererTextObj))

template gutterRendererTextClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeGutterRendererText, GutterRendererTextClassObj))

template isGutterRendererText*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeGutterRendererText))

template isGutterRendererTextClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeGutterRendererText))

template gutterRendererTextGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeGutterRendererText, GutterRendererTextClassObj))

proc gutterRendererTextGetType*(): GType {.
    importc: "gtk_source_gutter_renderer_text_get_type", libgsv.}
proc newGutterRendererText*(): GutterRenderer {.
    importc: "gtk_source_gutter_renderer_text_new", libgsv.}
proc setMarkup*(
    renderer: GutterRendererText; markup: cstring; length: cint) {.
    importc: "gtk_source_gutter_renderer_text_set_markup", libgsv.}
proc `markup=`*(
    renderer: GutterRendererText; markup: cstring; length: cint) {.
    importc: "gtk_source_gutter_renderer_text_set_markup", libgsv.}
proc setText*(renderer: GutterRendererText;
                                        text: cstring; length: cint) {.
    importc: "gtk_source_gutter_renderer_text_set_text", libgsv.}
proc `text=`*(renderer: GutterRendererText;
                                        text: cstring; length: cint) {.
    importc: "gtk_source_gutter_renderer_text_set_text", libgsv.}
proc measure*(renderer: GutterRendererText;
                                        text: cstring; width: var cint;
                                        height: var cint) {.
    importc: "gtk_source_gutter_renderer_text_measure", libgsv.}
proc measureMarkup*(
    renderer: GutterRendererText; markup: cstring; width: var cint;
    height: var cint) {.importc: "gtk_source_gutter_renderer_text_measure_markup",
                     libgsv.}

type
  GutterRendererPixbufClass* =  ptr GutterRendererPixbufClassObj
  GutterRendererPixbufClassPtr* = ptr GutterRendererPixbufClassObj
  GutterRendererPixbufClassObj*{.final.} = object of GutterRendererClassObj

  GutterRendererPixbuf* =  ptr GutterRendererPixbufObj
  GutterRendererPixbufPtr* = ptr GutterRendererPixbufObj
  GutterRendererPixbufObj*{.final.} = object of GutterRendererObj
    priv00: pointer

template typeGutterRendererPixbuf*(): untyped =
  (gutterRendererPixbufGetType())

template gutterRendererPixbuf*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeGutterRendererPixbuf, GutterRendererPixbufObj))

template gutterRendererPixbufClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeGutterRendererPixbuf, GutterRendererPixbufClassObj))

template isGutterRendererPixbuf*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeGutterRendererPixbuf))

template isGutterRendererPixbufClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeGutterRendererPixbuf))

template gutterRendererPixbufGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeGutterRendererPixbuf, GutterRendererPixbufClassObj))

proc gutterRendererPixbufGetType*(): GType {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_type", libgsv.}
proc newGutterRendererPixbuf*(): GutterRenderer {.
    importc: "gtk_source_gutter_renderer_pixbuf_new", libgsv.}
proc setPixbuf*(
    renderer: GutterRendererPixbuf; pixbuf: gdk_pixbuf.GdkPixbuf) {.
    importc: "gtk_source_gutter_renderer_pixbuf_set_pixbuf", libgsv.}
proc `pixbuf=`*(
    renderer: GutterRendererPixbuf; pixbuf: gdk_pixbuf.GdkPixbuf) {.
    importc: "gtk_source_gutter_renderer_pixbuf_set_pixbuf", libgsv.}
proc getPixbuf*(
    renderer: GutterRendererPixbuf): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_pixbuf", libgsv.}
proc pixbuf*(
    renderer: GutterRendererPixbuf): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_pixbuf", libgsv.}
proc setStockId*(
    renderer: GutterRendererPixbuf; stockId: cstring) {.
    importc: "gtk_source_gutter_renderer_pixbuf_set_stock_id", libgsv.}
proc `stockId=`*(
    renderer: GutterRendererPixbuf; stockId: cstring) {.
    importc: "gtk_source_gutter_renderer_pixbuf_set_stock_id", libgsv.}
proc getStockId*(
    renderer: GutterRendererPixbuf): cstring {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_stock_id", libgsv.}
proc stockId*(
    renderer: GutterRendererPixbuf): cstring {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_stock_id", libgsv.}
proc setGicon*(
    renderer: GutterRendererPixbuf; icon: gio.GIcon) {.
    importc: "gtk_source_gutter_renderer_pixbuf_set_gicon", libgsv.}
proc `gicon=`*(
    renderer: GutterRendererPixbuf; icon: gio.GIcon) {.
    importc: "gtk_source_gutter_renderer_pixbuf_set_gicon", libgsv.}
proc getGicon*(
    renderer: GutterRendererPixbuf): gio.GIcon {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_gicon", libgsv.}
proc gicon*(
    renderer: GutterRendererPixbuf): gio.GIcon {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_gicon", libgsv.}
proc setIconName*(
    renderer: GutterRendererPixbuf; iconName: cstring) {.
    importc: "gtk_source_gutter_renderer_pixbuf_set_icon_name", libgsv.}
proc `iconName=`*(
    renderer: GutterRendererPixbuf; iconName: cstring) {.
    importc: "gtk_source_gutter_renderer_pixbuf_set_icon_name", libgsv.}
proc getIconName*(
    renderer: GutterRendererPixbuf): cstring {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_icon_name", libgsv.}
proc iconName*(
    renderer: GutterRendererPixbuf): cstring {.
    importc: "gtk_source_gutter_renderer_pixbuf_get_icon_name", libgsv.}

type
  LanguageClass* =  ptr LanguageClassObj
  LanguageClassPtr* = ptr LanguageClassObj
  LanguageClassObj*{.final.} = object of GObjectClassObj
    reserved1*: proc () {.cdecl.}
    reserved2*: proc () {.cdecl.}

template typeLanguage*(): untyped =
  (languageGetType())

template language*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeLanguage, LanguageObj))

template languageClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeLanguage, LanguageClassObj))

template isLanguage*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeLanguage))

template isLanguageClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeLanguage))

template languageGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeLanguage, LanguageClassObj))

proc languageGetType*(): GType {.importc: "gtk_source_language_get_type",
                                       libgsv.}
proc getId*(language: Language): cstring {.
    importc: "gtk_source_language_get_id", libgsv.}
proc id*(language: Language): cstring {.
    importc: "gtk_source_language_get_id", libgsv.}
proc getName*(language: Language): cstring {.
    importc: "gtk_source_language_get_name", libgsv.}
proc name*(language: Language): cstring {.
    importc: "gtk_source_language_get_name", libgsv.}
proc getSection*(language: Language): cstring {.
    importc: "gtk_source_language_get_section", libgsv.}
proc section*(language: Language): cstring {.
    importc: "gtk_source_language_get_section", libgsv.}
proc getHidden*(language: Language): Gboolean {.
    importc: "gtk_source_language_get_hidden", libgsv.}
proc hidden*(language: Language): Gboolean {.
    importc: "gtk_source_language_get_hidden", libgsv.}
proc getMetadata*(language: Language; name: cstring): cstring {.
    importc: "gtk_source_language_get_metadata", libgsv.}
proc metadata*(language: Language; name: cstring): cstring {.
    importc: "gtk_source_language_get_metadata", libgsv.}
proc getMimeTypes*(language: Language): cstringArray {.
    importc: "gtk_source_language_get_mime_types", libgsv.}
proc mimeTypes*(language: Language): cstringArray {.
    importc: "gtk_source_language_get_mime_types", libgsv.}
proc getGlobs*(language: Language): cstringArray {.
    importc: "gtk_source_language_get_globs", libgsv.}
proc globs*(language: Language): cstringArray {.
    importc: "gtk_source_language_get_globs", libgsv.}
proc getStyleIds*(language: Language): cstringArray {.
    importc: "gtk_source_language_get_style_ids", libgsv.}
proc styleIds*(language: Language): cstringArray {.
    importc: "gtk_source_language_get_style_ids", libgsv.}
proc getStyleName*(language: Language;
                                   styleId: cstring): cstring {.
    importc: "gtk_source_language_get_style_name", libgsv.}
proc styleName*(language: Language;
                                   styleId: cstring): cstring {.
    importc: "gtk_source_language_get_style_name", libgsv.}
proc getStyleFallback*(language: Language;
                                       styleId: cstring): cstring {.
    importc: "gtk_source_language_get_style_fallback", libgsv.}
proc styleFallback*(language: Language;
                                       styleId: cstring): cstring {.
    importc: "gtk_source_language_get_style_fallback", libgsv.}

type
  LanguageManagerClass* =  ptr LanguageManagerClassObj
  LanguageManagerClassPtr* = ptr LanguageManagerClassObj
  LanguageManagerClassObj*{.final.} = object of GObjectClassObj
    reserved1*: proc () {.cdecl.}
    reserved2*: proc () {.cdecl.}
    reserved3*: proc () {.cdecl.}
    reserved4*: proc () {.cdecl.}

  LanguageManager* =  ptr LanguageManagerObj
  LanguageManagerPtr* = ptr LanguageManagerObj
  LanguageManagerObj*{.final.} = object of GObjectObj
    priv: pointer

template typeLanguageManager*(): untyped =
  (languageManagerGetType())

template languageManager*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeLanguageManager, LanguageManagerObj))

template languageManagerClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeLanguageManager, LanguageManagerClassObj))

template isLanguageManager*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeLanguageManager))

template isLanguageManagerClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeLanguageManager))

template languageManagerGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeLanguageManager, LanguageManagerClassObj))

proc languageManagerGetType*(): GType {.
    importc: "gtk_source_language_manager_get_type", libgsv.}
proc newLanguageManager*(): LanguageManager {.
    importc: "gtk_source_language_manager_new", libgsv.}
proc languageManagerGetDefault*(): LanguageManager {.
    importc: "gtk_source_language_manager_get_default", libgsv.}
proc getSearchPath*(lm: LanguageManager): cstringArray {.
    importc: "gtk_source_language_manager_get_search_path", libgsv.}
proc searchPath*(lm: LanguageManager): cstringArray {.
    importc: "gtk_source_language_manager_get_search_path", libgsv.}
proc setSearchPath*(lm: LanguageManager;
    dirs: cstringArray) {.importc: "gtk_source_language_manager_set_search_path",
                        libgsv.}
proc `searchPath=`*(lm: LanguageManager;
    dirs: cstringArray) {.importc: "gtk_source_language_manager_set_search_path",
                        libgsv.}
proc getLanguageIds*(lm: LanguageManager): cstringArray {.
    importc: "gtk_source_language_manager_get_language_ids", libgsv.}
proc languageIds*(lm: LanguageManager): cstringArray {.
    importc: "gtk_source_language_manager_get_language_ids", libgsv.}
proc getLanguage*(lm: LanguageManager;
    id: cstring): Language {.importc: "gtk_source_language_manager_get_language",
                                      libgsv.}
proc language*(lm: LanguageManager;
    id: cstring): Language {.importc: "gtk_source_language_manager_get_language",
                                      libgsv.}
proc guessLanguage*(lm: LanguageManager;
    filename: cstring; contentType: cstring): Language {.
    importc: "gtk_source_language_manager_guess_language", libgsv.}
proc languageManagerPeekDefault*(): LanguageManager {.
    importc: "_gtk_source_language_manager_peek_default", libgsv.}

type
  ViewClass* =  ptr ViewClassObj
  ViewClassPtr* = ptr ViewClassObj
  ViewClassObj* = object of gtk.TextViewClassObj
    undo*: proc (view: View) {.cdecl.}
    redo*: proc (view: View) {.cdecl.}
    lineMarkActivated*: proc (view: View; iter: gtk.TextIter;
                            event: gdk.Event) {.cdecl.}
    showCompletion*: proc (view: View) {.cdecl.}
    moveLines*: proc (view: View; copy: Gboolean; step: cint) {.cdecl.}
    moveWords*: proc (view: View; step: cint) {.cdecl.}

template typeView*(): untyped =
  (viewGetType())

template view*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeView, ViewObj))

template viewClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeView, ViewClassObj))

template isView*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeView))

template isViewClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeView))

template viewGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeView, ViewClassObj))

type
  ViewGutterPosition* {.size: sizeof(cint), pure.} = enum
    LINES = - 30,
    MARKS = - 20

type
  SmartHomeEndType* {.size: sizeof(cint), pure.} = enum
    DISABLED, BEFORE,
    AFTER, ALWAYS

when not defined(GTKSOURCEVIEW_DISABLE_DEPRECATED):
  type
    DrawSpacesFlags* {.size: sizeof(cint), pure.} = enum
      SPACE = 1 shl 0, TAB = 1 shl 1,
      NEWLINE = 1 shl 2,
      NBSP = 1 shl 3,
      LEADING = 1 shl 4,
      TEXT = 1 shl 5,
      TRAILING = 1 shl 6,
      ALL = 0x7F

type
  BackgroundPatternType* {.size: sizeof(cint), pure.} = enum
    NONE,
    GRID

type
  MarkAttributes* =  ptr MarkAttributesObj
  MarkAttributesPtr* = ptr MarkAttributesObj
  MarkAttributesObj*{.final.} = object of GObjectObj
    priv: pointer

  SpaceDrawer* =  ptr SpaceDrawerObj
  SpaceDrawerPtr* = ptr SpaceDrawerObj
  SpaceDrawerObj*{.final.} = object of GObjectObj
    priv: pointer

proc viewGetType*(): GType {.importc: "gtk_source_view_get_type",
                                   libgsv.}
proc newView*(): View {.importc: "gtk_source_view_new", libgsv.}
proc newView*(buffer: Buffer): View {.
    importc: "gtk_source_view_new_with_buffer", libgsv.}
proc setShowLineNumbers*(view: View; show: Gboolean) {.
    importc: "gtk_source_view_set_show_line_numbers", libgsv.}
proc `showLineNumbers=`*(view: View; show: Gboolean) {.
    importc: "gtk_source_view_set_show_line_numbers", libgsv.}
proc getShowLineNumbers*(view: View): Gboolean {.
    importc: "gtk_source_view_get_show_line_numbers", libgsv.}
proc showLineNumbers*(view: View): Gboolean {.
    importc: "gtk_source_view_get_show_line_numbers", libgsv.}
proc setTabWidth*(view: View; width: cuint) {.
    importc: "gtk_source_view_set_tab_width", libgsv.}
proc `tabWidth=`*(view: View; width: cuint) {.
    importc: "gtk_source_view_set_tab_width", libgsv.}
proc getTabWidth*(view: View): cuint {.
    importc: "gtk_source_view_get_tab_width", libgsv.}
proc tabWidth*(view: View): cuint {.
    importc: "gtk_source_view_get_tab_width", libgsv.}
proc setIndentWidth*(view: View; width: cint) {.
    importc: "gtk_source_view_set_indent_width", libgsv.}
proc `indentWidth=`*(view: View; width: cint) {.
    importc: "gtk_source_view_set_indent_width", libgsv.}
proc getIndentWidth*(view: View): cint {.
    importc: "gtk_source_view_get_indent_width", libgsv.}
proc indentWidth*(view: View): cint {.
    importc: "gtk_source_view_get_indent_width", libgsv.}
proc setAutoIndent*(view: View; enable: Gboolean) {.
    importc: "gtk_source_view_set_auto_indent", libgsv.}
proc `autoIndent=`*(view: View; enable: Gboolean) {.
    importc: "gtk_source_view_set_auto_indent", libgsv.}
proc getAutoIndent*(view: View): Gboolean {.
    importc: "gtk_source_view_get_auto_indent", libgsv.}
proc autoIndent*(view: View): Gboolean {.
    importc: "gtk_source_view_get_auto_indent", libgsv.}
proc setInsertSpacesInsteadOfTabs*(view: View;
    enable: Gboolean) {.importc: "gtk_source_view_set_insert_spaces_instead_of_tabs",
                      libgsv.}
proc `insertSpacesInsteadOfTabs=`*(view: View;
    enable: Gboolean) {.importc: "gtk_source_view_set_insert_spaces_instead_of_tabs",
                      libgsv.}
proc getInsertSpacesInsteadOfTabs*(view: View): Gboolean {.
    importc: "gtk_source_view_get_insert_spaces_instead_of_tabs", libgsv.}
proc insertSpacesInsteadOfTabs*(view: View): Gboolean {.
    importc: "gtk_source_view_get_insert_spaces_instead_of_tabs", libgsv.}
proc setIndentOnTab*(view: View; enable: Gboolean) {.
    importc: "gtk_source_view_set_indent_on_tab", libgsv.}
proc `indentOnTab=`*(view: View; enable: Gboolean) {.
    importc: "gtk_source_view_set_indent_on_tab", libgsv.}
proc getIndentOnTab*(view: View): Gboolean {.
    importc: "gtk_source_view_get_indent_on_tab", libgsv.}
proc indentOnTab*(view: View): Gboolean {.
    importc: "gtk_source_view_get_indent_on_tab", libgsv.}
proc indentLines*(view: View; start: gtk.TextIter;
                              `end`: gtk.TextIter) {.
    importc: "gtk_source_view_indent_lines", libgsv.}
proc unindentLines*(view: View; start: gtk.TextIter;
                                `end`: gtk.TextIter) {.
    importc: "gtk_source_view_unindent_lines", libgsv.}
proc setHighlightCurrentLine*(view: View;
    highlight: Gboolean) {.importc: "gtk_source_view_set_highlight_current_line",
                         libgsv.}
proc `highlightCurrentLine=`*(view: View;
    highlight: Gboolean) {.importc: "gtk_source_view_set_highlight_current_line",
                         libgsv.}
proc getHighlightCurrentLine*(view: View): Gboolean {.
    importc: "gtk_source_view_get_highlight_current_line", libgsv.}
proc highlightCurrentLine*(view: View): Gboolean {.
    importc: "gtk_source_view_get_highlight_current_line", libgsv.}
proc setShowRightMargin*(view: View; show: Gboolean) {.
    importc: "gtk_source_view_set_show_right_margin", libgsv.}
proc `showRightMargin=`*(view: View; show: Gboolean) {.
    importc: "gtk_source_view_set_show_right_margin", libgsv.}
proc getShowRightMargin*(view: View): Gboolean {.
    importc: "gtk_source_view_get_show_right_margin", libgsv.}
proc showRightMargin*(view: View): Gboolean {.
    importc: "gtk_source_view_get_show_right_margin", libgsv.}
proc setRightMarginPosition*(view: View; pos: cuint) {.
    importc: "gtk_source_view_set_right_margin_position", libgsv.}
proc `rightMarginPosition=`*(view: View; pos: cuint) {.
    importc: "gtk_source_view_set_right_margin_position", libgsv.}
proc getRightMarginPosition*(view: View): cuint {.
    importc: "gtk_source_view_get_right_margin_position", libgsv.}
proc rightMarginPosition*(view: View): cuint {.
    importc: "gtk_source_view_get_right_margin_position", libgsv.}
proc setShowLineMarks*(view: View; show: Gboolean) {.
    importc: "gtk_source_view_set_show_line_marks", libgsv.}
proc `showLineMarks=`*(view: View; show: Gboolean) {.
    importc: "gtk_source_view_set_show_line_marks", libgsv.}
proc getShowLineMarks*(view: View): Gboolean {.
    importc: "gtk_source_view_get_show_line_marks", libgsv.}
proc showLineMarks*(view: View): Gboolean {.
    importc: "gtk_source_view_get_show_line_marks", libgsv.}
proc setMarkAttributes*(view: View; category: cstring;
                                    attributes: MarkAttributes;
                                    priority: cint) {.
    importc: "gtk_source_view_set_mark_attributes", libgsv.}
proc `markAttributes=`*(view: View; category: cstring;
                                    attributes: MarkAttributes;
                                    priority: cint) {.
    importc: "gtk_source_view_set_mark_attributes", libgsv.}
proc getMarkAttributes*(view: View; category: cstring;
                                    priority: var cint): MarkAttributes {.
    importc: "gtk_source_view_get_mark_attributes", libgsv.}
proc markAttributes*(view: View; category: cstring;
                                    priority: var cint): MarkAttributes {.
    importc: "gtk_source_view_get_mark_attributes", libgsv.}
proc setSmartBackspace*(view: View;
                                    smartBackspace: Gboolean) {.
    importc: "gtk_source_view_set_smart_backspace", libgsv.}
proc `smartBackspace=`*(view: View;
                                    smartBackspace: Gboolean) {.
    importc: "gtk_source_view_set_smart_backspace", libgsv.}
proc getSmartBackspace*(view: View): Gboolean {.
    importc: "gtk_source_view_get_smart_backspace", libgsv.}
proc smartBackspace*(view: View): Gboolean {.
    importc: "gtk_source_view_get_smart_backspace", libgsv.}
proc setSmartHomeEnd*(view: View;
                                  smartHomeEnd: SmartHomeEndType) {.
    importc: "gtk_source_view_set_smart_home_end", libgsv.}
proc `smartHomeEnd=`*(view: View;
                                  smartHomeEnd: SmartHomeEndType) {.
    importc: "gtk_source_view_set_smart_home_end", libgsv.}
proc getSmartHomeEnd*(view: View): SmartHomeEndType {.
    importc: "gtk_source_view_get_smart_home_end", libgsv.}
proc smartHomeEnd*(view: View): SmartHomeEndType {.
    importc: "gtk_source_view_get_smart_home_end", libgsv.}
proc setDrawSpaces*(view: View;
                                flags: DrawSpacesFlags) {.
    importc: "gtk_source_view_set_draw_spaces", libgsv.}
proc `drawSpaces=`*(view: View;
                                flags: DrawSpacesFlags) {.
    importc: "gtk_source_view_set_draw_spaces", libgsv.}
proc getDrawSpaces*(view: View): DrawSpacesFlags {.
    importc: "gtk_source_view_get_draw_spaces", libgsv.}
proc drawSpaces*(view: View): DrawSpacesFlags {.
    importc: "gtk_source_view_get_draw_spaces", libgsv.}
proc getVisualColumn*(view: View; iter: gtk.TextIter): cuint {.
    importc: "gtk_source_view_get_visual_column", libgsv.}
proc visualColumn*(view: View; iter: gtk.TextIter): cuint {.
    importc: "gtk_source_view_get_visual_column", libgsv.}
proc getCompletion*(view: View): Completion {.
    importc: "gtk_source_view_get_completion", libgsv.}
proc completion*(view: View): Completion {.
    importc: "gtk_source_view_get_completion", libgsv.}
proc getGutter*(view: View; windowType: gtk.TextWindowType): Gutter {.
    importc: "gtk_source_view_get_gutter", libgsv.}
proc gutter*(view: View; windowType: gtk.TextWindowType): Gutter {.
    importc: "gtk_source_view_get_gutter", libgsv.}
proc setBackgroundPattern*(view: View; backgroundPattern: BackgroundPatternType) {.
    importc: "gtk_source_view_set_background_pattern", libgsv.}
proc `backgroundPattern=`*(view: View; backgroundPattern: BackgroundPatternType) {.
    importc: "gtk_source_view_set_background_pattern", libgsv.}
proc getBackgroundPattern*(view: View): BackgroundPatternType {.
    importc: "gtk_source_view_get_background_pattern", libgsv.}
proc backgroundPattern*(view: View): BackgroundPatternType {.
    importc: "gtk_source_view_get_background_pattern", libgsv.}
proc getSpaceDrawer*(view: View): SpaceDrawer {.
    importc: "gtk_source_view_get_space_drawer", libgsv.}
proc spaceDrawer*(view: View): SpaceDrawer {.
    importc: "gtk_source_view_get_space_drawer", libgsv.}

type
  MapClass* =  ptr MapClassObj
  MapClassPtr* = ptr MapClassObj
  MapClassObj*{.final.} = object of ViewClassObj
    padding*: array[10, Gpointer]

  Map* =  ptr MapObj
  MapPtr* = ptr MapObj
  MapObj*{.final.} = object of ViewObj

template typeMap*(): untyped =
  (mapGetType())

template map*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeMap, MapObj))

template mapClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeMap, MapClassObj))

template isMap*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeMap))

template isMapClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeMap))

template mapGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeMap, MapClassObj))

proc mapGetType*(): GType {.importc: "gtk_source_map_get_type", libgsv.}
proc newMap*(): Map {.importc: "gtk_source_map_new", libgsv.}
proc setView*(map: Map; view: View) {.
    importc: "gtk_source_map_set_view", libgsv.}
proc `view=`*(map: Map; view: View) {.
    importc: "gtk_source_map_set_view", libgsv.}
proc getView*(map: Map): View {.
    importc: "gtk_source_map_get_view", libgsv.}
proc view*(map: Map): View {.
    importc: "gtk_source_map_get_view", libgsv.}

type
  MarkClass* =  ptr MarkClassObj
  MarkClassPtr* = ptr MarkClassObj
  MarkClassObj*{.final.} = object of gtk.TextMarkClassObj
    reserved1*: proc () {.cdecl.}
    reserved2*: proc () {.cdecl.}

template typeMark*(): untyped =
  (markGetType())

template mark*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeMark, MarkObj))

template markClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeMark, MarkClassObj))

template isMark*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeMark))

template isMarkClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeMark))

template markGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeMark, MarkClassObj))

proc markGetType*(): GType {.importc: "gtk_source_mark_get_type",
                                   libgsv.}
proc newMark*(name: cstring; category: cstring): Mark {.
    importc: "gtk_source_mark_new", libgsv.}
proc getCategory*(mark: Mark): cstring {.
    importc: "gtk_source_mark_get_category", libgsv.}
proc category*(mark: Mark): cstring {.
    importc: "gtk_source_mark_get_category", libgsv.}
proc next*(mark: Mark; category: cstring): Mark {.
    importc: "gtk_source_mark_next", libgsv.}
proc prev*(mark: Mark; category: cstring): Mark {.
    importc: "gtk_source_mark_prev", libgsv.}

type
  MarkAttributesClass* =  ptr MarkAttributesClassObj
  MarkAttributesClassPtr* = ptr MarkAttributesClassObj
  MarkAttributesClassObj*{.final.} = object of GObjectClassObj

template typeMarkAttributes*(): untyped =
  (markAttributesGetType())

template markAttributes*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeMarkAttributes, MarkAttributesObj))

template markAttributesClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeMarkAttributes, MarkAttributesClassObj))

template isMarkAttributes*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeMarkAttributes))

template isMarkAttributesClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeMarkAttributes))

template markAttributesGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeMarkAttributes, MarkAttributesClassObj))

proc markAttributesGetType*(): GType {.
    importc: "gtk_source_mark_attributes_get_type", libgsv.}
proc newMarkAttributes*(): MarkAttributes {.
    importc: "gtk_source_mark_attributes_new", libgsv.}
proc setBackground*(
    attributes: MarkAttributes; background: gdk.RGBA) {.
    importc: "gtk_source_mark_attributes_set_background", libgsv.}
proc `background=`*(
    attributes: MarkAttributes; background: gdk.RGBA) {.
    importc: "gtk_source_mark_attributes_set_background", libgsv.}
proc getBackground*(
    attributes: MarkAttributes; background: gdk.RGBA): Gboolean {.
    importc: "gtk_source_mark_attributes_get_background", libgsv.}
proc background*(
    attributes: MarkAttributes; background: gdk.RGBA): Gboolean {.
    importc: "gtk_source_mark_attributes_get_background", libgsv.}
proc setStockId*(attributes: MarkAttributes;
                                       stockId: cstring) {.
    importc: "gtk_source_mark_attributes_set_stock_id", libgsv.}
proc `stockId=`*(attributes: MarkAttributes;
                                       stockId: cstring) {.
    importc: "gtk_source_mark_attributes_set_stock_id", libgsv.}
proc getStockId*(attributes: MarkAttributes): cstring {.
    importc: "gtk_source_mark_attributes_get_stock_id", libgsv.}
proc stockId*(attributes: MarkAttributes): cstring {.
    importc: "gtk_source_mark_attributes_get_stock_id", libgsv.}
proc setIconName*(attributes: MarkAttributes;
                                        iconName: cstring) {.
    importc: "gtk_source_mark_attributes_set_icon_name", libgsv.}
proc `iconName=`*(attributes: MarkAttributes;
                                        iconName: cstring) {.
    importc: "gtk_source_mark_attributes_set_icon_name", libgsv.}
proc getIconName*(attributes: MarkAttributes): cstring {.
    importc: "gtk_source_mark_attributes_get_icon_name", libgsv.}
proc iconName*(attributes: MarkAttributes): cstring {.
    importc: "gtk_source_mark_attributes_get_icon_name", libgsv.}
proc setGicon*(attributes: MarkAttributes;
                                     gicon: gio.GIcon) {.
    importc: "gtk_source_mark_attributes_set_gicon", libgsv.}
proc `gicon=`*(attributes: MarkAttributes;
                                     gicon: gio.GIcon) {.
    importc: "gtk_source_mark_attributes_set_gicon", libgsv.}
proc getGicon*(attributes: MarkAttributes): gio.GIcon {.
    importc: "gtk_source_mark_attributes_get_gicon", libgsv.}
proc gicon*(attributes: MarkAttributes): gio.GIcon {.
    importc: "gtk_source_mark_attributes_get_gicon", libgsv.}
proc setPixbuf*(attributes: MarkAttributes;
                                      pixbuf: gdk_pixbuf.GdkPixbuf) {.
    importc: "gtk_source_mark_attributes_set_pixbuf", libgsv.}
proc `pixbuf=`*(attributes: MarkAttributes;
                                      pixbuf: gdk_pixbuf.GdkPixbuf) {.
    importc: "gtk_source_mark_attributes_set_pixbuf", libgsv.}
proc getPixbuf*(attributes: MarkAttributes): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_mark_attributes_get_pixbuf", libgsv.}
proc pixbuf*(attributes: MarkAttributes): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_mark_attributes_get_pixbuf", libgsv.}
proc renderIcon*(attributes: MarkAttributes;
                                       widget: gtk.Widget; size: cint): gdk_pixbuf.GdkPixbuf {.
    importc: "gtk_source_mark_attributes_render_icon", libgsv.}
proc getTooltipText*(
    attributes: MarkAttributes; mark: Mark): cstring {.
    importc: "gtk_source_mark_attributes_get_tooltip_text", libgsv.}
proc tooltipText*(
    attributes: MarkAttributes; mark: Mark): cstring {.
    importc: "gtk_source_mark_attributes_get_tooltip_text", libgsv.}
proc getTooltipMarkup*(
    attributes: MarkAttributes; mark: Mark): cstring {.
    importc: "gtk_source_mark_attributes_get_tooltip_markup", libgsv.}
proc tooltipMarkup*(
    attributes: MarkAttributes; mark: Mark): cstring {.
    importc: "gtk_source_mark_attributes_get_tooltip_markup", libgsv.}

type
  PrintCompositorClass* =  ptr PrintCompositorClassObj
  PrintCompositorClassPtr* = ptr PrintCompositorClassObj
  PrintCompositorClassObj*{.final.} = object of GObjectClassObj
    reserved1*: proc () {.cdecl.}
    reserved2*: proc () {.cdecl.}

  PrintCompositor* =  ptr PrintCompositorObj
  PrintCompositorPtr* = ptr PrintCompositorObj
  PrintCompositorObj*{.final.} = object of GObjectObj
    priv: pointer

template typePrintCompositor*(): untyped =
  (printCompositorGetType())

template printCompositor*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typePrintCompositor, PrintCompositorObj))

template printCompositorClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typePrintCompositor, PrintCompositorClassObj))

template isPrintCompositor*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typePrintCompositor))

template isPrintCompositorClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typePrintCompositor))

template printCompositorGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typePrintCompositor, PrintCompositorClassObj))

proc printCompositorGetType*(): GType {.
    importc: "gtk_source_print_compositor_get_type", libgsv.}
proc newPrintCompositor*(buffer: Buffer): PrintCompositor {.
    importc: "gtk_source_print_compositor_new", libgsv.}
proc newPrintCompositor*(view: View): PrintCompositor {.
    importc: "gtk_source_print_compositor_new_from_view", libgsv.}
proc getBuffer*(compositor: PrintCompositor): Buffer {.
    importc: "gtk_source_print_compositor_get_buffer", libgsv.}
proc buffer*(compositor: PrintCompositor): Buffer {.
    importc: "gtk_source_print_compositor_get_buffer", libgsv.}
proc setTabWidth*(
    compositor: PrintCompositor; width: cuint) {.
    importc: "gtk_source_print_compositor_set_tab_width", libgsv.}
proc `tabWidth=`*(
    compositor: PrintCompositor; width: cuint) {.
    importc: "gtk_source_print_compositor_set_tab_width", libgsv.}
proc getTabWidth*(
    compositor: PrintCompositor): cuint {.
    importc: "gtk_source_print_compositor_get_tab_width", libgsv.}
proc tabWidth*(
    compositor: PrintCompositor): cuint {.
    importc: "gtk_source_print_compositor_get_tab_width", libgsv.}
proc setWrapMode*(
    compositor: PrintCompositor; wrapMode: gtk.WrapMode) {.
    importc: "gtk_source_print_compositor_set_wrap_mode", libgsv.}
proc `wrapMode=`*(
    compositor: PrintCompositor; wrapMode: gtk.WrapMode) {.
    importc: "gtk_source_print_compositor_set_wrap_mode", libgsv.}
proc getWrapMode*(
    compositor: PrintCompositor): gtk.WrapMode {.
    importc: "gtk_source_print_compositor_get_wrap_mode", libgsv.}
proc wrapMode*(
    compositor: PrintCompositor): gtk.WrapMode {.
    importc: "gtk_source_print_compositor_get_wrap_mode", libgsv.}
proc setHighlightSyntax*(
    compositor: PrintCompositor; highlight: Gboolean) {.
    importc: "gtk_source_print_compositor_set_highlight_syntax", libgsv.}
proc `highlightSyntax=`*(
    compositor: PrintCompositor; highlight: Gboolean) {.
    importc: "gtk_source_print_compositor_set_highlight_syntax", libgsv.}
proc getHighlightSyntax*(
    compositor: PrintCompositor): Gboolean {.
    importc: "gtk_source_print_compositor_get_highlight_syntax", libgsv.}
proc highlightSyntax*(
    compositor: PrintCompositor): Gboolean {.
    importc: "gtk_source_print_compositor_get_highlight_syntax", libgsv.}
proc setPrintLineNumbers*(
    compositor: PrintCompositor; interval: cuint) {.
    importc: "gtk_source_print_compositor_set_print_line_numbers", libgsv.}
proc `printLineNumbers=`*(
    compositor: PrintCompositor; interval: cuint) {.
    importc: "gtk_source_print_compositor_set_print_line_numbers", libgsv.}
proc getPrintLineNumbers*(
    compositor: PrintCompositor): cuint {.
    importc: "gtk_source_print_compositor_get_print_line_numbers", libgsv.}
proc printLineNumbers*(
    compositor: PrintCompositor): cuint {.
    importc: "gtk_source_print_compositor_get_print_line_numbers", libgsv.}
proc setBodyFontName*(
    compositor: PrintCompositor; fontName: cstring) {.
    importc: "gtk_source_print_compositor_set_body_font_name", libgsv.}
proc `bodyFontName=`*(
    compositor: PrintCompositor; fontName: cstring) {.
    importc: "gtk_source_print_compositor_set_body_font_name", libgsv.}
proc getBodyFontName*(
    compositor: PrintCompositor): cstring {.
    importc: "gtk_source_print_compositor_get_body_font_name", libgsv.}
proc bodyFontName*(
    compositor: PrintCompositor): cstring {.
    importc: "gtk_source_print_compositor_get_body_font_name", libgsv.}
proc setLineNumbersFontName*(
    compositor: PrintCompositor; fontName: cstring) {.
    importc: "gtk_source_print_compositor_set_line_numbers_font_name", libgsv.}
proc `lineNumbersFontName=`*(
    compositor: PrintCompositor; fontName: cstring) {.
    importc: "gtk_source_print_compositor_set_line_numbers_font_name", libgsv.}
proc getLineNumbersFontName*(
    compositor: PrintCompositor): cstring {.
    importc: "gtk_source_print_compositor_get_line_numbers_font_name", libgsv.}
proc lineNumbersFontName*(
    compositor: PrintCompositor): cstring {.
    importc: "gtk_source_print_compositor_get_line_numbers_font_name", libgsv.}
proc setHeaderFontName*(
    compositor: PrintCompositor; fontName: cstring) {.
    importc: "gtk_source_print_compositor_set_header_font_name", libgsv.}
proc `headerFontName=`*(
    compositor: PrintCompositor; fontName: cstring) {.
    importc: "gtk_source_print_compositor_set_header_font_name", libgsv.}
proc getHeaderFontName*(
    compositor: PrintCompositor): cstring {.
    importc: "gtk_source_print_compositor_get_header_font_name", libgsv.}
proc headerFontName*(
    compositor: PrintCompositor): cstring {.
    importc: "gtk_source_print_compositor_get_header_font_name", libgsv.}
proc setFooterFontName*(
    compositor: PrintCompositor; fontName: cstring) {.
    importc: "gtk_source_print_compositor_set_footer_font_name", libgsv.}
proc `footerFontName=`*(
    compositor: PrintCompositor; fontName: cstring) {.
    importc: "gtk_source_print_compositor_set_footer_font_name", libgsv.}
proc getFooterFontName*(
    compositor: PrintCompositor): cstring {.
    importc: "gtk_source_print_compositor_get_footer_font_name", libgsv.}
proc footerFontName*(
    compositor: PrintCompositor): cstring {.
    importc: "gtk_source_print_compositor_get_footer_font_name", libgsv.}
proc getTopMargin*(
    compositor: PrintCompositor; unit: gtk.Unit): cdouble {.
    importc: "gtk_source_print_compositor_get_top_margin", libgsv.}
proc topMargin*(
    compositor: PrintCompositor; unit: gtk.Unit): cdouble {.
    importc: "gtk_source_print_compositor_get_top_margin", libgsv.}
proc setTopMargin*(
    compositor: PrintCompositor; margin: cdouble; unit: gtk.Unit) {.
    importc: "gtk_source_print_compositor_set_top_margin", libgsv.}
proc `topMargin=`*(
    compositor: PrintCompositor; margin: cdouble; unit: gtk.Unit) {.
    importc: "gtk_source_print_compositor_set_top_margin", libgsv.}
proc getBottomMargin*(
    compositor: PrintCompositor; unit: gtk.Unit): cdouble {.
    importc: "gtk_source_print_compositor_get_bottom_margin", libgsv.}
proc bottomMargin*(
    compositor: PrintCompositor; unit: gtk.Unit): cdouble {.
    importc: "gtk_source_print_compositor_get_bottom_margin", libgsv.}
proc setBottomMargin*(
    compositor: PrintCompositor; margin: cdouble; unit: gtk.Unit) {.
    importc: "gtk_source_print_compositor_set_bottom_margin", libgsv.}
proc `bottomMargin=`*(
    compositor: PrintCompositor; margin: cdouble; unit: gtk.Unit) {.
    importc: "gtk_source_print_compositor_set_bottom_margin", libgsv.}
proc getLeftMargin*(
    compositor: PrintCompositor; unit: gtk.Unit): cdouble {.
    importc: "gtk_source_print_compositor_get_left_margin", libgsv.}
proc leftMargin*(
    compositor: PrintCompositor; unit: gtk.Unit): cdouble {.
    importc: "gtk_source_print_compositor_get_left_margin", libgsv.}
proc setLeftMargin*(
    compositor: PrintCompositor; margin: cdouble; unit: gtk.Unit) {.
    importc: "gtk_source_print_compositor_set_left_margin", libgsv.}
proc `leftMargin=`*(
    compositor: PrintCompositor; margin: cdouble; unit: gtk.Unit) {.
    importc: "gtk_source_print_compositor_set_left_margin", libgsv.}
proc getRightMargin*(
    compositor: PrintCompositor; unit: gtk.Unit): cdouble {.
    importc: "gtk_source_print_compositor_get_right_margin", libgsv.}
proc rightMargin*(
    compositor: PrintCompositor; unit: gtk.Unit): cdouble {.
    importc: "gtk_source_print_compositor_get_right_margin", libgsv.}
proc setRightMargin*(
    compositor: PrintCompositor; margin: cdouble; unit: gtk.Unit) {.
    importc: "gtk_source_print_compositor_set_right_margin", libgsv.}
proc `rightMargin=`*(
    compositor: PrintCompositor; margin: cdouble; unit: gtk.Unit) {.
    importc: "gtk_source_print_compositor_set_right_margin", libgsv.}
proc setPrintHeader*(
    compositor: PrintCompositor; print: Gboolean) {.
    importc: "gtk_source_print_compositor_set_print_header", libgsv.}
proc `printHeader=`*(
    compositor: PrintCompositor; print: Gboolean) {.
    importc: "gtk_source_print_compositor_set_print_header", libgsv.}
proc getPrintHeader*(
    compositor: PrintCompositor): Gboolean {.
    importc: "gtk_source_print_compositor_get_print_header", libgsv.}
proc printHeader*(
    compositor: PrintCompositor): Gboolean {.
    importc: "gtk_source_print_compositor_get_print_header", libgsv.}
proc setPrintFooter*(
    compositor: PrintCompositor; print: Gboolean) {.
    importc: "gtk_source_print_compositor_set_print_footer", libgsv.}
proc `printFooter=`*(
    compositor: PrintCompositor; print: Gboolean) {.
    importc: "gtk_source_print_compositor_set_print_footer", libgsv.}
proc getPrintFooter*(
    compositor: PrintCompositor): Gboolean {.
    importc: "gtk_source_print_compositor_get_print_footer", libgsv.}
proc printFooter*(
    compositor: PrintCompositor): Gboolean {.
    importc: "gtk_source_print_compositor_get_print_footer", libgsv.}
proc setHeaderFormat*(
    compositor: PrintCompositor; separator: Gboolean; left: cstring;
    center: cstring; right: cstring) {.importc: "gtk_source_print_compositor_set_header_format",
                                   libgsv.}
proc `headerFormat=`*(
    compositor: PrintCompositor; separator: Gboolean; left: cstring;
    center: cstring; right: cstring) {.importc: "gtk_source_print_compositor_set_header_format",
                                   libgsv.}
proc setFooterFormat*(
    compositor: PrintCompositor; separator: Gboolean; left: cstring;
    center: cstring; right: cstring) {.importc: "gtk_source_print_compositor_set_footer_format",
                                   libgsv.}
proc `footerFormat=`*(
    compositor: PrintCompositor; separator: Gboolean; left: cstring;
    center: cstring; right: cstring) {.importc: "gtk_source_print_compositor_set_footer_format",
                                   libgsv.}
proc getNPages*(compositor: PrintCompositor): cint {.
    importc: "gtk_source_print_compositor_get_n_pages", libgsv.}
proc nPages*(compositor: PrintCompositor): cint {.
    importc: "gtk_source_print_compositor_get_n_pages", libgsv.}
proc paginate*(compositor: PrintCompositor;
                                      context: gtk.PrintContext): Gboolean {.
    importc: "gtk_source_print_compositor_paginate", libgsv.}
proc getPaginationProgress*(
    compositor: PrintCompositor): cdouble {.
    importc: "gtk_source_print_compositor_get_pagination_progress", libgsv.}
proc paginationProgress*(
    compositor: PrintCompositor): cdouble {.
    importc: "gtk_source_print_compositor_get_pagination_progress", libgsv.}
proc drawPage*(compositor: PrintCompositor;
                                      context: gtk.PrintContext; pageNr: cint) {.
    importc: "gtk_source_print_compositor_draw_page", libgsv.}

template typeRegion*(): untyped =
  (regionGetType())

proc regionGetType*(): GType {.importc: "gtk_source_region_get_type",
                                     libgsv.}
type
  Region* =  ptr RegionObj
  RegionPtr* = ptr RegionObj
  RegionObj*{.final.} = object of GObjectObj

  RegionClass* =  ptr RegionClassObj
  RegionClassPtr* = ptr RegionClassObj
  RegionClassObj*{.final.} = object of GObjectClassObj
    padding*: array[8, Gpointer]

proc gtk_Source_Region_Class*(`ptr`: Gpointer): RegionClass {.inline.} =
  return gTypeCheckClassCast(`ptr`, regionGetType(),
                                RegionClassObj)

proc gtk_Source_Is_Region*(`ptr`: Gpointer): Gboolean {.inline.} =
  return gTypeCheckInstanceType(`ptr`, regionGetType())

proc gtk_Source_Is_Region_Class*(`ptr`: Gpointer): Gboolean {.inline.} =
  return gTypeCheckClassType(`ptr`, regionGetType())

proc gtk_Source_Region_Get_Class*(`ptr`: Gpointer): RegionClass {.inline.} =
  return gTypeInstanceGetClass(`ptr`, regionGetType(),
                                  RegionClassObj)

type
  RegionIter* =  ptr RegionIterObj
  RegionIterPtr* = ptr RegionIterObj
  RegionIterObj* = object
    dummy1: Gpointer
    dummy2: uint32
    dummy3: Gpointer

proc newRegion*(buffer: gtk.TextBuffer): Region {.
    importc: "gtk_source_region_new", libgsv.}
proc getBuffer*(region: Region): gtk.TextBuffer {.
    importc: "gtk_source_region_get_buffer", libgsv.}
proc buffer*(region: Region): gtk.TextBuffer {.
    importc: "gtk_source_region_get_buffer", libgsv.}
proc addSubregion*(region: Region;
                                 start: gtk.TextIter; `end`: gtk.TextIter) {.
    importc: "gtk_source_region_add_subregion", libgsv.}
proc addRegion*(region: Region;
                              regionToAdd: Region) {.
    importc: "gtk_source_region_add_region", libgsv.}
proc subtractSubregion*(region: Region;
                                      start: gtk.TextIter;
                                      `end`: gtk.TextIter) {.
    importc: "gtk_source_region_subtract_subregion", libgsv.}
proc subtractRegion*(region: Region;
                                   regionToSubtract: Region) {.
    importc: "gtk_source_region_subtract_region", libgsv.}
proc intersectSubregion*(region: Region;
                                       start: gtk.TextIter;
                                       `end`: gtk.TextIter): Region {.
    importc: "gtk_source_region_intersect_subregion", libgsv.}
proc intersectRegion*(region1: Region;
                                    region2: Region): Region {.
    importc: "gtk_source_region_intersect_region", libgsv.}
proc isEmpty*(region: Region): Gboolean {.
    importc: "gtk_source_region_is_empty", libgsv.}
proc getBounds*(region: Region; start: gtk.TextIter;
                              `end`: gtk.TextIter): Gboolean {.
    importc: "gtk_source_region_get_bounds", libgsv.}
proc bounds*(region: Region; start: gtk.TextIter;
                              `end`: gtk.TextIter): Gboolean {.
    importc: "gtk_source_region_get_bounds", libgsv.}
proc getStartRegionIter*(region: Region;
                                       iter: RegionIter) {.
    importc: "gtk_source_region_get_start_region_iter", libgsv.}
proc isEnd*(iter: RegionIter): Gboolean {.
    importc: "gtk_source_region_iter_is_end", libgsv.}
proc next*(iter: RegionIter): Gboolean {.
    importc: "gtk_source_region_iter_next", libgsv.}
proc getSubregion*(iter: RegionIter;
                                     start: gtk.TextIter; `end`: gtk.TextIter): Gboolean {.
    importc: "gtk_source_region_iter_get_subregion", libgsv.}
proc subregion*(iter: RegionIter;
                                     start: gtk.TextIter; `end`: gtk.TextIter): Gboolean {.
    importc: "gtk_source_region_iter_get_subregion", libgsv.}
proc toString*(region: Region): cstring {.
    importc: "gtk_source_region_to_string", libgsv.}

type
  SearchContextClass* =  ptr SearchContextClassObj
  SearchContextClassPtr* = ptr SearchContextClassObj
  SearchContextClassObj*{.final.} = object of GObjectClassObj
    padding*: array[10, Gpointer]

  SearchContext* =  ptr SearchContextObj
  SearchContextPtr* = ptr SearchContextObj
  SearchContextObj*{.final.} = object of GObjectObj
    priv: pointer

template typeSearchContext*(): untyped =
  (searchContextGetType())

template searchContext*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeSearchContext, SearchContextObj))

template searchContextClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeSearchContext, SearchContextClassObj))

template isSearchContext*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeSearchContext))

template isSearchContextClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeSearchContext))

template searchContextGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeSearchContext, SearchContextClassObj))

type
  SearchSettings* =  ptr SearchSettingsObj
  SearchSettingsPtr* = ptr SearchSettingsObj
  SearchSettingsObj*{.final.} = object of GObjectObj
    priv: pointer

proc searchContextGetType*(): GType {.
    importc: "gtk_source_search_context_get_type", libgsv.}
proc newSearchContext*(buffer: Buffer;
                               settings: SearchSettings): SearchContext {.
    importc: "gtk_source_search_context_new", libgsv.}
proc getBuffer*(search: SearchContext): Buffer {.
    importc: "gtk_source_search_context_get_buffer", libgsv.}
proc buffer*(search: SearchContext): Buffer {.
    importc: "gtk_source_search_context_get_buffer", libgsv.}
proc getSettings*(search: SearchContext): SearchSettings {.
    importc: "gtk_source_search_context_get_settings", libgsv.}
proc settings*(search: SearchContext): SearchSettings {.
    importc: "gtk_source_search_context_get_settings", libgsv.}
proc setSettings*(search: SearchContext;
                                       settings: SearchSettings) {.
    importc: "gtk_source_search_context_set_settings", libgsv.}
proc `settings=`*(search: SearchContext;
                                       settings: SearchSettings) {.
    importc: "gtk_source_search_context_set_settings", libgsv.}
proc getHighlight*(search: SearchContext): Gboolean {.
    importc: "gtk_source_search_context_get_highlight", libgsv.}
proc highlight*(search: SearchContext): Gboolean {.
    importc: "gtk_source_search_context_get_highlight", libgsv.}
proc setHighlight*(search: SearchContext;
                                        highlight: Gboolean) {.
    importc: "gtk_source_search_context_set_highlight", libgsv.}
proc `highlight=`*(search: SearchContext;
                                        highlight: Gboolean) {.
    importc: "gtk_source_search_context_set_highlight", libgsv.}
proc getMatchStyle*(search: SearchContext): Style {.
    importc: "gtk_source_search_context_get_match_style", libgsv.}
proc matchStyle*(search: SearchContext): Style {.
    importc: "gtk_source_search_context_get_match_style", libgsv.}
proc setMatchStyle*(search: SearchContext;
    matchStyle: Style) {.importc: "gtk_source_search_context_set_match_style",
                                   libgsv.}
proc `matchStyle=`*(search: SearchContext;
    matchStyle: Style) {.importc: "gtk_source_search_context_set_match_style",
                                   libgsv.}
proc getRegexError*(search: SearchContext): glib.GError {.
    importc: "gtk_source_search_context_get_regex_error", libgsv.}
proc regexError*(search: SearchContext): glib.GError {.
    importc: "gtk_source_search_context_get_regex_error", libgsv.}
proc getOccurrencesCount*(
    search: SearchContext): cint {.
    importc: "gtk_source_search_context_get_occurrences_count", libgsv.}
proc occurrencesCount*(
    search: SearchContext): cint {.
    importc: "gtk_source_search_context_get_occurrences_count", libgsv.}
proc getOccurrencePosition*(
    search: SearchContext; matchStart: gtk.TextIter;
    matchEnd: gtk.TextIter): cint {.importc: "gtk_source_search_context_get_occurrence_position",
                                   libgsv.}
proc occurrencePosition*(
    search: SearchContext; matchStart: gtk.TextIter;
    matchEnd: gtk.TextIter): cint {.importc: "gtk_source_search_context_get_occurrence_position",
                                   libgsv.}
proc forward*(search: SearchContext;
                                   iter: gtk.TextIter;
                                   matchStart: gtk.TextIter;
                                   matchEnd: gtk.TextIter): Gboolean {.
    importc: "gtk_source_search_context_forward", libgsv.}
proc forward2*(search: SearchContext;
                                    iter: gtk.TextIter;
                                    matchStart: gtk.TextIter;
                                    matchEnd: gtk.TextIter;
                                    hasWrappedAround: var Gboolean): Gboolean {.
    importc: "gtk_source_search_context_forward2", libgsv.}
proc forwardAsync*(search: SearchContext;
                                        iter: gtk.TextIter;
                                        cancellable: gio.GCancellable;
                                        callback: GAsyncReadyCallback;
                                        userData: Gpointer) {.
    importc: "gtk_source_search_context_forward_async", libgsv.}
proc forwardFinish*(search: SearchContext;
    result: gio.GAsyncResult; matchStart: gtk.TextIter; matchEnd: gtk.TextIter;
    error: var glib.GError): Gboolean {.importc: "gtk_source_search_context_forward_finish",
                                  libgsv.}
proc forwardFinish2*(search: SearchContext;
    result: gio.GAsyncResult; matchStart: gtk.TextIter; matchEnd: gtk.TextIter;
    hasWrappedAround: var Gboolean; error: var glib.GError): Gboolean {.
    importc: "gtk_source_search_context_forward_finish2", libgsv.}
proc backward*(search: SearchContext;
                                    iter: gtk.TextIter;
                                    matchStart: gtk.TextIter;
                                    matchEnd: gtk.TextIter): Gboolean {.
    importc: "gtk_source_search_context_backward", libgsv.}
proc backward2*(search: SearchContext;
                                     iter: gtk.TextIter;
                                     matchStart: gtk.TextIter;
                                     matchEnd: gtk.TextIter;
                                     hasWrappedAround: var Gboolean): Gboolean {.
    importc: "gtk_source_search_context_backward2", libgsv.}
proc backwardAsync*(search: SearchContext;
    iter: gtk.TextIter; cancellable: gio.GCancellable;
    callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "gtk_source_search_context_backward_async", libgsv.}
proc backwardFinish*(search: SearchContext;
    result: gio.GAsyncResult; matchStart: gtk.TextIter; matchEnd: gtk.TextIter;
    error: var glib.GError): Gboolean {.importc: "gtk_source_search_context_backward_finish",
                                  libgsv.}
proc backwardFinish2*(search: SearchContext;
    result: gio.GAsyncResult; matchStart: gtk.TextIter; matchEnd: gtk.TextIter;
    hasWrappedAround: var Gboolean; error: var glib.GError): Gboolean {.
    importc: "gtk_source_search_context_backward_finish2", libgsv.}
proc replace*(search: SearchContext;
                                   matchStart: gtk.TextIter;
                                   matchEnd: gtk.TextIter; replace: cstring;
                                   replaceLength: cint; error: var glib.GError): Gboolean {.
    importc: "gtk_source_search_context_replace", libgsv.}
proc replace2*(search: SearchContext;
                                    matchStart: gtk.TextIter;
                                    matchEnd: gtk.TextIter; replace: cstring;
                                    replaceLength: cint; error: var glib.GError): Gboolean {.
    importc: "gtk_source_search_context_replace2", libgsv.}
proc replaceAll*(search: SearchContext;
                                      replace: cstring; replaceLength: cint;
                                      error: var glib.GError): cuint {.
    importc: "gtk_source_search_context_replace_all", libgsv.}
proc updateHighlight*(search: SearchContext;
    start: gtk.TextIter; `end`: gtk.TextIter; synchronous: Gboolean) {.
    importc: "_gtk_source_search_context_update_highlight", libgsv.}

type
  SearchSettingsClass* =  ptr SearchSettingsClassObj
  SearchSettingsClassPtr* = ptr SearchSettingsClassObj
  SearchSettingsClassObj*{.final.} = object of GObjectClassObj
    padding*: array[10, Gpointer]

template typeSearchSettings*(): untyped =
  (searchSettingsGetType())

template searchSettings*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeSearchSettings, SearchSettingsObj))

template searchSettingsClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeSearchSettings, SearchSettingsClassObj))

template isSearchSettings*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeSearchSettings))

template isSearchSettingsClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeSearchSettings))

template searchSettingsGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeSearchSettings, SearchSettingsClassObj))

proc searchSettingsGetType*(): GType {.
    importc: "gtk_source_search_settings_get_type", libgsv.}
proc newSearchSettings*(): SearchSettings {.
    importc: "gtk_source_search_settings_new", libgsv.}
proc setSearchText*(settings: SearchSettings;
    searchText: cstring) {.importc: "gtk_source_search_settings_set_search_text",
                         libgsv.}
proc `searchText=`*(settings: SearchSettings;
    searchText: cstring) {.importc: "gtk_source_search_settings_set_search_text",
                         libgsv.}
proc getSearchText*(settings: SearchSettings): cstring {.
    importc: "gtk_source_search_settings_get_search_text", libgsv.}
proc searchText*(settings: SearchSettings): cstring {.
    importc: "gtk_source_search_settings_get_search_text", libgsv.}
proc setCaseSensitive*(
    settings: SearchSettings; caseSensitive: Gboolean) {.
    importc: "gtk_source_search_settings_set_case_sensitive", libgsv.}
proc `caseSensitive=`*(
    settings: SearchSettings; caseSensitive: Gboolean) {.
    importc: "gtk_source_search_settings_set_case_sensitive", libgsv.}
proc getCaseSensitive*(
    settings: SearchSettings): Gboolean {.
    importc: "gtk_source_search_settings_get_case_sensitive", libgsv.}
proc caseSensitive*(
    settings: SearchSettings): Gboolean {.
    importc: "gtk_source_search_settings_get_case_sensitive", libgsv.}
proc setAtWordBoundaries*(
    settings: SearchSettings; atWordBoundaries: Gboolean) {.
    importc: "gtk_source_search_settings_set_at_word_boundaries", libgsv.}
proc `atWordBoundaries=`*(
    settings: SearchSettings; atWordBoundaries: Gboolean) {.
    importc: "gtk_source_search_settings_set_at_word_boundaries", libgsv.}
proc getAtWordBoundaries*(
    settings: SearchSettings): Gboolean {.
    importc: "gtk_source_search_settings_get_at_word_boundaries", libgsv.}
proc atWordBoundaries*(
    settings: SearchSettings): Gboolean {.
    importc: "gtk_source_search_settings_get_at_word_boundaries", libgsv.}
proc setWrapAround*(settings: SearchSettings;
    wrapAround: Gboolean) {.importc: "gtk_source_search_settings_set_wrap_around",
                          libgsv.}
proc `wrapAround=`*(settings: SearchSettings;
    wrapAround: Gboolean) {.importc: "gtk_source_search_settings_set_wrap_around",
                          libgsv.}
proc getWrapAround*(settings: SearchSettings): Gboolean {.
    importc: "gtk_source_search_settings_get_wrap_around", libgsv.}
proc wrapAround*(settings: SearchSettings): Gboolean {.
    importc: "gtk_source_search_settings_get_wrap_around", libgsv.}
proc setRegexEnabled*(
    settings: SearchSettings; regexEnabled: Gboolean) {.
    importc: "gtk_source_search_settings_set_regex_enabled", libgsv.}
proc `regexEnabled=`*(
    settings: SearchSettings; regexEnabled: Gboolean) {.
    importc: "gtk_source_search_settings_set_regex_enabled", libgsv.}
proc getRegexEnabled*(
    settings: SearchSettings): Gboolean {.
    importc: "gtk_source_search_settings_get_regex_enabled", libgsv.}
proc regexEnabled*(
    settings: SearchSettings): Gboolean {.
    importc: "gtk_source_search_settings_get_regex_enabled", libgsv.}

type
  SpaceDrawerClass* =  ptr SpaceDrawerClassObj
  SpaceDrawerClassPtr* = ptr SpaceDrawerClassObj
  SpaceDrawerClassObj*{.final.} = object of GObjectClassObj
    padding*: array[20, Gpointer]

template typeSpaceDrawer*(): untyped =
  (spaceDrawerGetType())

template spaceDrawer*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeSpaceDrawer, SpaceDrawerObj))

template spaceDrawerClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeSpaceDrawer, SpaceDrawerClassObj))

template isSpaceDrawer*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeSpaceDrawer))

template isSpaceDrawerClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeSpaceDrawer))

template spaceDrawerGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeSpaceDrawer, SpaceDrawerClassObj))

type
  SpaceTypeFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, SPACE = 1 shl 0,
    TAB = 1 shl 1, NEWLINE = 1 shl 2,
    NBSP = 1 shl 3, ALL = 0xF

type
  SpaceLocationFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    LEADING = 1 shl 0,
    INSIDE_TEXT = 1 shl 1,
    TRAILING = 1 shl 2,
    ALL = 0x7

proc spaceDrawerGetType*(): GType {.
    importc: "gtk_source_space_drawer_get_type", libgsv.}
proc newSpaceDrawer*(): SpaceDrawer {.
    importc: "gtk_source_space_drawer_new", libgsv.}
proc getTypesForLocations*(drawer: SpaceDrawer;
    locations: SpaceLocationFlags): SpaceTypeFlags {.
    importc: "gtk_source_space_drawer_get_types_for_locations", libgsv.}
proc typesForLocations*(drawer: SpaceDrawer;
    locations: SpaceLocationFlags): SpaceTypeFlags {.
    importc: "gtk_source_space_drawer_get_types_for_locations", libgsv.}
proc setTypesForLocations*(drawer: SpaceDrawer;
    locations: SpaceLocationFlags; types: SpaceTypeFlags) {.
    importc: "gtk_source_space_drawer_set_types_for_locations", libgsv.}
proc `typesForLocations=`*(drawer: SpaceDrawer;
    locations: SpaceLocationFlags; types: SpaceTypeFlags) {.
    importc: "gtk_source_space_drawer_set_types_for_locations", libgsv.}
proc getMatrix*(drawer: SpaceDrawer): glib.GVariant {.
    importc: "gtk_source_space_drawer_get_matrix", libgsv.}
proc matrix*(drawer: SpaceDrawer): glib.GVariant {.
    importc: "gtk_source_space_drawer_get_matrix", libgsv.}
proc setMatrix*(drawer: SpaceDrawer;
                                   matrix: glib.GVariant) {.
    importc: "gtk_source_space_drawer_set_matrix", libgsv.}
proc `matrix=`*(drawer: SpaceDrawer;
                                   matrix: glib.GVariant) {.
    importc: "gtk_source_space_drawer_set_matrix", libgsv.}
proc getEnableMatrix*(drawer: SpaceDrawer): Gboolean {.
    importc: "gtk_source_space_drawer_get_enable_matrix", libgsv.}
proc enableMatrix*(drawer: SpaceDrawer): Gboolean {.
    importc: "gtk_source_space_drawer_get_enable_matrix", libgsv.}
proc setEnableMatrix*(drawer: SpaceDrawer;
    enableMatrix: Gboolean) {.importc: "gtk_source_space_drawer_set_enable_matrix",
                            libgsv.}
proc `enableMatrix=`*(drawer: SpaceDrawer;
    enableMatrix: Gboolean) {.importc: "gtk_source_space_drawer_set_enable_matrix",
                            libgsv.}
proc bindMatrixSetting*(drawer: SpaceDrawer;
    settings: gio.GSettings; key: cstring; flags: GSettingsBindFlags) {.
    importc: "gtk_source_space_drawer_bind_matrix_setting", libgsv.}

template typeStyle*(): untyped =
  (styleGetType())

template style*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeStyle, StyleObj))

template isStyle*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeStyle))

template styleClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeStyle, StyleClass))

template isStyleClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeStyle))

template styleGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeStyle, StyleClass))

proc styleGetType*(): GType {.importc: "gtk_source_style_get_type",
                                    libgsv.}
proc copy*(style: Style): Style {.
    importc: "gtk_source_style_copy", libgsv.}
proc apply*(style: Style; tag: gtk.TextTag) {.
    importc: "gtk_source_style_apply", libgsv.}

type
  StyleSchemeClass* =  ptr StyleSchemeClassObj
  StyleSchemeClassPtr* = ptr StyleSchemeClassObj
  StyleSchemeClassObj*{.final.} = object of GObjectClassObj
    reserved1*: proc () {.cdecl.}
    reserved2*: proc () {.cdecl.}

template typeStyleScheme*(): untyped =
  (styleSchemeGetType())

template styleScheme*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeStyleScheme, StyleSchemeObj))

template styleSchemeClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeStyleScheme, StyleSchemeClassObj))

template isStyleScheme*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeStyleScheme))

template isStyleSchemeClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeStyleScheme))

template styleSchemeGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeStyleScheme, StyleSchemeClassObj))

proc styleSchemeGetType*(): GType {.
    importc: "gtk_source_style_scheme_get_type", libgsv.}
proc getId*(scheme: StyleScheme): cstring {.
    importc: "gtk_source_style_scheme_get_id", libgsv.}
proc id*(scheme: StyleScheme): cstring {.
    importc: "gtk_source_style_scheme_get_id", libgsv.}
proc getName*(scheme: StyleScheme): cstring {.
    importc: "gtk_source_style_scheme_get_name", libgsv.}
proc name*(scheme: StyleScheme): cstring {.
    importc: "gtk_source_style_scheme_get_name", libgsv.}
proc getDescription*(scheme: StyleScheme): cstring {.
    importc: "gtk_source_style_scheme_get_description", libgsv.}
proc description*(scheme: StyleScheme): cstring {.
    importc: "gtk_source_style_scheme_get_description", libgsv.}
proc getAuthors*(scheme: StyleScheme): cstringArray {.
    importc: "gtk_source_style_scheme_get_authors", libgsv.}
proc authors*(scheme: StyleScheme): cstringArray {.
    importc: "gtk_source_style_scheme_get_authors", libgsv.}
proc getFilename*(scheme: StyleScheme): cstring {.
    importc: "gtk_source_style_scheme_get_filename", libgsv.}
proc filename*(scheme: StyleScheme): cstring {.
    importc: "gtk_source_style_scheme_get_filename", libgsv.}
proc getStyle*(scheme: StyleScheme;
                                  styleId: cstring): Style {.
    importc: "gtk_source_style_scheme_get_style", libgsv.}
proc style*(scheme: StyleScheme;
                                  styleId: cstring): Style {.
    importc: "gtk_source_style_scheme_get_style", libgsv.}
proc newStyleScheme*(filename: cstring): StyleScheme {.
    importc: "_gtk_source_style_scheme_new_from_file", libgsv.}
proc styleSchemeGetDefault*(): StyleScheme {.
    importc: "_gtk_source_style_scheme_get_default", libgsv.}
proc getParentId*(scheme: StyleScheme): cstring {.
    importc: "_gtk_source_style_scheme_get_parent_id", libgsv.}
proc parentId*(scheme: StyleScheme): cstring {.
    importc: "_gtk_source_style_scheme_get_parent_id", libgsv.}
proc setParent*(scheme: StyleScheme;
                                   parentScheme: StyleScheme) {.
    importc: "_gtk_source_style_scheme_set_parent", libgsv.}
proc `parent=`*(scheme: StyleScheme;
                                   parentScheme: StyleScheme) {.
    importc: "_gtk_source_style_scheme_set_parent", libgsv.}
proc apply*(scheme: StyleScheme;
                               view: View) {.
    importc: "_gtk_source_style_scheme_apply", libgsv.}
proc unapply*(scheme: StyleScheme;
                                 view: View) {.
    importc: "_gtk_source_style_scheme_unapply", libgsv.}
proc getMatchingBracketsStyle*(
    scheme: StyleScheme): Style {.
    importc: "_gtk_source_style_scheme_get_matching_brackets_style", libgsv.}
proc matchingBracketsStyle*(
    scheme: StyleScheme): Style {.
    importc: "_gtk_source_style_scheme_get_matching_brackets_style", libgsv.}
proc getRightMarginStyle*(scheme: StyleScheme): Style {.
    importc: "_gtk_source_style_scheme_get_right_margin_style", libgsv.}
proc rightMarginStyle*(scheme: StyleScheme): Style {.
    importc: "_gtk_source_style_scheme_get_right_margin_style", libgsv.}
proc getDrawSpacesStyle*(scheme: StyleScheme): Style {.
    importc: "_gtk_source_style_scheme_get_draw_spaces_style", libgsv.}
proc drawSpacesStyle*(scheme: StyleScheme): Style {.
    importc: "_gtk_source_style_scheme_get_draw_spaces_style", libgsv.}
proc getCurrentLineColor*(scheme: StyleScheme;
    color: gdk.RGBA): Gboolean {.importc: "_gtk_source_style_scheme_get_current_line_color",
                                libgsv.}
proc currentLineColor*(scheme: StyleScheme;
    color: gdk.RGBA): Gboolean {.importc: "_gtk_source_style_scheme_get_current_line_color",
                                libgsv.}
proc getBackgroundPatternColor*(
    scheme: StyleScheme; color: gdk.RGBA): Gboolean {.
    importc: "_gtk_source_style_scheme_get_background_pattern_color", libgsv.}
proc backgroundPatternColor*(
    scheme: StyleScheme; color: gdk.RGBA): Gboolean {.
    importc: "_gtk_source_style_scheme_get_background_pattern_color", libgsv.}

type
  StyleSchemeChooserInterface* =  ptr StyleSchemeChooserInterfaceObj
  StyleSchemeChooserInterfacePtr* = ptr StyleSchemeChooserInterfaceObj
  StyleSchemeChooserInterfaceObj* = object of gobject.GTypeInterfaceObj
    getStyleScheme*: proc (chooser: StyleSchemeChooser): StyleScheme {.cdecl.}
    setStyleScheme*: proc (chooser: StyleSchemeChooser;
                         scheme: StyleScheme) {.cdecl.}
    padding*: array[12, Gpointer]

template typeStyleSchemeChooser*(): untyped =
  (styleSchemeChooserGetType())

template styleSchemeChooser*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeStyleSchemeChooser, StyleSchemeChooserObj))

template isStyleSchemeChooser*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeStyleSchemeChooser))

template styleSchemeChooserGetIface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, typeStyleSchemeChooser, StyleSchemeChooserInterfaceObj))

proc styleSchemeChooserGetType*(): GType {.
    importc: "gtk_source_style_scheme_chooser_get_type", libgsv.}
proc getStyleScheme*(
    chooser: StyleSchemeChooser): StyleScheme {.
    importc: "gtk_source_style_scheme_chooser_get_style_scheme", libgsv.}
proc styleScheme*(
    chooser: StyleSchemeChooser): StyleScheme {.
    importc: "gtk_source_style_scheme_chooser_get_style_scheme", libgsv.}
proc setStyleScheme*(
    chooser: StyleSchemeChooser; scheme: StyleScheme) {.
    importc: "gtk_source_style_scheme_chooser_set_style_scheme", libgsv.}
proc `styleScheme=`*(
    chooser: StyleSchemeChooser; scheme: StyleScheme) {.
    importc: "gtk_source_style_scheme_chooser_set_style_scheme", libgsv.}

type
  StyleSchemeChooserButtonClass* =  ptr StyleSchemeChooserButtonClassObj
  StyleSchemeChooserButtonClassPtr* = ptr StyleSchemeChooserButtonClassObj
  StyleSchemeChooserButtonClassObj*{.final.} = object of gtk.ButtonClassObj

  StyleSchemeChooserButton* =  ptr StyleSchemeChooserButtonObj
  StyleSchemeChooserButtonPtr* = ptr StyleSchemeChooserButtonObj
  StyleSchemeChooserButtonObj*{.final.} = object of gtk.ButtonObj

template typeStyleSchemeChooserButton*(): untyped =
  (styleSchemeChooserButtonGetType())

template styleSchemeChooserButton*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeStyleSchemeChooserButton, StyleSchemeChooserButtonObj))

template styleSchemeChooserButtonClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeStyleSchemeChooserButton, StyleSchemeChooserButtonClassObj))

template isStyleSchemeChooserButton*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeStyleSchemeChooserButton))

template isStyleSchemeChooserButtonClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeStyleSchemeChooserButton))

template styleSchemeChooserButtonGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeStyleSchemeChooserButton, StyleSchemeChooserButtonClassObj))

proc styleSchemeChooserButtonGetType*(): GType {.
    importc: "gtk_source_style_scheme_chooser_button_get_type", libgsv.}
proc newStyleSchemeChooserButton*(): StyleSchemeChooserButton {.
    importc: "gtk_source_style_scheme_chooser_button_new", libgsv.}

type
  StyleSchemeChooserWidget* =  ptr StyleSchemeChooserWidgetObj
  StyleSchemeChooserWidgetPtr* = ptr StyleSchemeChooserWidgetObj
  StyleSchemeChooserWidgetObj*{.final.} = object of gtk.BinObj

  StyleSchemeChooserWidgetClass* =  ptr StyleSchemeChooserWidgetClassObj
  StyleSchemeChooserWidgetClassPtr* = ptr StyleSchemeChooserWidgetClassObj
  StyleSchemeChooserWidgetClassObj*{.final.} = object of gtk.BinClassObj

template typeStyleSchemeChooserWidget*(): untyped =
  (styleSchemeChooserWidgetGetType())

template styleSchemeChooserWidget*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeStyleSchemeChooserWidget, StyleSchemeChooserWidgetObj))

template styleSchemeChooserWidgetClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeStyleSchemeChooserWidget, StyleSchemeChooserWidgetClassObj))

template isStyleSchemeChooserWidget*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeStyleSchemeChooserWidget))

template isStyleSchemeChooserWidgetClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeStyleSchemeChooserWidget))

template styleSchemeChooserWidgetGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeStyleSchemeChooserWidget, StyleSchemeChooserWidgetClassObj))

proc styleSchemeChooserWidgetGetType*(): GType {.
    importc: "gtk_source_style_scheme_chooser_widget_get_type", libgsv.}
proc newStyleSchemeChooserWidget*(): StyleSchemeChooserWidget {.
    importc: "gtk_source_style_scheme_chooser_widget_new", libgsv.}

type
  StyleSchemeManager* =  ptr StyleSchemeManagerObj
  StyleSchemeManagerPtr* = ptr StyleSchemeManagerObj
  StyleSchemeManagerObj*{.final.} = object of GObjectObj
    priv: pointer

  StyleSchemeManagerClass* =  ptr StyleSchemeManagerClassObj
  StyleSchemeManagerClassPtr* = ptr StyleSchemeManagerClassObj
  StyleSchemeManagerClassObj*{.final.} = object of GObjectClassObj
    reserved1*: proc () {.cdecl.}
    reserved2*: proc () {.cdecl.}
    reserved3*: proc () {.cdecl.}
    reserved4*: proc () {.cdecl.}

template typeStyleSchemeManager*(): untyped =
  (styleSchemeManagerGetType())

template styleSchemeManager*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeStyleSchemeManager, StyleSchemeManagerObj))

template styleSchemeManagerClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeStyleSchemeManager, StyleSchemeManagerClassObj))

template isStyleSchemeManager*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeStyleSchemeManager))

template isStyleSchemeManagerClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeStyleSchemeManager))

template styleSchemeManagerGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeStyleSchemeManager, StyleSchemeManagerClassObj))

proc styleSchemeManagerGetType*(): GType {.
    importc: "gtk_source_style_scheme_manager_get_type", libgsv.}
proc newStyleSchemeManager*(): StyleSchemeManager {.
    importc: "gtk_source_style_scheme_manager_new", libgsv.}
proc styleSchemeManagerGetDefault*(): StyleSchemeManager {.
    importc: "gtk_source_style_scheme_manager_get_default", libgsv.}
proc setSearchPath*(
    manager: StyleSchemeManager; path: cstringArray) {.
    importc: "gtk_source_style_scheme_manager_set_search_path", libgsv.}
proc `searchPath=`*(
    manager: StyleSchemeManager; path: cstringArray) {.
    importc: "gtk_source_style_scheme_manager_set_search_path", libgsv.}
proc appendSearchPath*(
    manager: StyleSchemeManager; path: cstring) {.
    importc: "gtk_source_style_scheme_manager_append_search_path", libgsv.}
proc prependSearchPath*(
    manager: StyleSchemeManager; path: cstring) {.
    importc: "gtk_source_style_scheme_manager_prepend_search_path", libgsv.}
proc getSearchPath*(
    manager: StyleSchemeManager): cstringArray {.
    importc: "gtk_source_style_scheme_manager_get_search_path", libgsv.}
proc searchPath*(
    manager: StyleSchemeManager): cstringArray {.
    importc: "gtk_source_style_scheme_manager_get_search_path", libgsv.}
proc forceRescan*(
    manager: StyleSchemeManager) {.
    importc: "gtk_source_style_scheme_manager_force_rescan", libgsv.}
proc getSchemeIds*(
    manager: StyleSchemeManager): cstringArray {.
    importc: "gtk_source_style_scheme_manager_get_scheme_ids", libgsv.}
proc schemeIds*(
    manager: StyleSchemeManager): cstringArray {.
    importc: "gtk_source_style_scheme_manager_get_scheme_ids", libgsv.}
proc getScheme*(
    manager: StyleSchemeManager; schemeId: cstring): StyleScheme {.
    importc: "gtk_source_style_scheme_manager_get_scheme", libgsv.}
proc scheme*(
    manager: StyleSchemeManager; schemeId: cstring): StyleScheme {.
    importc: "gtk_source_style_scheme_manager_get_scheme", libgsv.}
proc styleSchemeManagerPeekDefault*(): StyleSchemeManager {.
    importc: "_gtk_source_style_scheme_manager_peek_default", libgsv.}

template typeTag*(): untyped =
  (tagGetType())

proc tagGetType*(): GType {.importc: "gtk_source_tag_get_type", libgsv.}
type
  Tag* =  ptr TagObj
  TagPtr* = ptr TagObj
  TagObj*{.final.} = object of gtk.TextTagObj

  TagClass* =  ptr TagClassObj
  TagClassPtr* = ptr TagClassObj
  TagClassObj*{.final.} = object of gtk.TextTagClassObj
    padding*: array[10, Gpointer]

proc gtk_Source_Tag_Class*(`ptr`: Gpointer): TagClass {.inline.} =
  return gTypeCheckClassCast(`ptr`, tagGetType(), TagClassObj)

proc gtk_Source_Is_Tag*(`ptr`: Gpointer): Gboolean {.inline.} =
  return gTypeCheckInstanceType(`ptr`, tagGetType())

proc gtk_Source_Is_Tag_Class*(`ptr`: Gpointer): Gboolean {.inline.} =
  return gTypeCheckClassType(`ptr`, tagGetType())

proc gtk_Source_Tag_Get_Class*(`ptr`: Gpointer): TagClass {.inline.} =
  return gTypeInstanceGetClass(`ptr`, tagGetType(), TagClassObj)

proc newTag*(name: cstring): gtk.TextTag {.importc: "gtk_source_tag_new",
    libgsv.}

type
  UndoManagerIface* =  ptr UndoManagerIfaceObj
  UndoManagerIfacePtr* = ptr UndoManagerIfaceObj
  UndoManagerIfaceObj*{.final.} = object of gobject.GTypeInterfaceObj
    canUndo*: proc (manager: UndoManager): Gboolean {.cdecl.}
    canRedo*: proc (manager: UndoManager): Gboolean {.cdecl.}
    undo*: proc (manager: UndoManager) {.cdecl.}
    redo*: proc (manager: UndoManager) {.cdecl.}
    beginNotUndoableAction*: proc (manager: UndoManager) {.cdecl.}
    endNotUndoableAction*: proc (manager: UndoManager) {.cdecl.}
    canUndoChanged*: proc (manager: UndoManager) {.cdecl.}
    canRedoChanged*: proc (manager: UndoManager) {.cdecl.}

template typeUndoManager*(): untyped =
  (undoManagerGetType())

template undoManager*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeUndoManager, UndoManagerObj))

template isUndoManager*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeUndoManager))

template undoManagerGetInterface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, typeUndoManager, UndoManagerIfaceObj))

proc undoManagerGetType*(): GType {.
    importc: "gtk_source_undo_manager_get_type", libgsv.}
proc canUndo*(manager: UndoManager): Gboolean {.
    importc: "gtk_source_undo_manager_can_undo", libgsv.}
proc canRedo*(manager: UndoManager): Gboolean {.
    importc: "gtk_source_undo_manager_can_redo", libgsv.}
proc undo*(manager: UndoManager) {.
    importc: "gtk_source_undo_manager_undo", libgsv.}
proc redo*(manager: UndoManager) {.
    importc: "gtk_source_undo_manager_redo", libgsv.}
proc beginNotUndoableAction*(
    manager: UndoManager) {.importc: "gtk_source_undo_manager_begin_not_undoable_action",
                                      libgsv.}
proc endNotUndoableAction*(manager: UndoManager) {.
    importc: "gtk_source_undo_manager_end_not_undoable_action", libgsv.}
proc canUndoChanged*(manager: UndoManager) {.
    importc: "gtk_source_undo_manager_can_undo_changed", libgsv.}
proc canRedoChanged*(manager: UndoManager) {.
    importc: "gtk_source_undo_manager_can_redo_changed", libgsv.}

proc utilsUnescapeSearchText*(text: cstring): cstring {.
    importc: "gtk_source_utils_unescape_search_text", libgsv.}
proc utilsEscapeSearchText*(text: cstring): cstring {.
    importc: "gtk_source_utils_escape_search_text", libgsv.}

template typeCompletionWordsProposal*(): untyped =
  (completionWordsProposalGetType())

template completionWordsProposal*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionWordsProposal, CompletionWordsProposalObj))

template completionWordsProposalClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeCompletionWordsProposal, CompletionWordsProposalClassObj))

template isCompletionWordsProposal*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionWordsProposal))

template isCompletionWordsProposalClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeCompletionWordsProposal))

template completionWordsProposalGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeCompletionWordsProposal, CompletionWordsProposalClassObj))

type
  CompletionWordsProposal* =  ptr CompletionWordsProposalObj
  CompletionWordsProposalPtr* = ptr CompletionWordsProposalObj
  CompletionWordsProposalObj*{.final.} = object of GObjectObj
    priv: pointer

  CompletionWordsProposalClass* =  ptr CompletionWordsProposalClassObj
  CompletionWordsProposalClassPtr* = ptr CompletionWordsProposalClassObj
  CompletionWordsProposalClassObj*{.final.} = object of GObjectClassObj

proc completionWordsProposalGetType*(): GType {.
    importc: "gtk_source_completion_words_proposal_get_type", libgsv.}
proc newCompletionWordsProposal*(word: cstring): CompletionWordsProposal {.
    importc: "gtk_source_completion_words_proposal_new", libgsv.}
proc getWord*(
    proposal: CompletionWordsProposal): cstring {.
    importc: "gtk_source_completion_words_proposal_get_word", libgsv.}
proc word*(
    proposal: CompletionWordsProposal): cstring {.
    importc: "gtk_source_completion_words_proposal_get_word", libgsv.}
proc use*(
    proposal: CompletionWordsProposal) {.
    importc: "gtk_source_completion_words_proposal_use", libgsv.}
proc unuse*(
    proposal: CompletionWordsProposal) {.
    importc: "gtk_source_completion_words_proposal_unuse", libgsv.}

template typeCompletionWordsLibrary*(): untyped =
  (completionWordsLibraryGetType())

template completionWordsLibrary*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionWordsLibrary, CompletionWordsLibraryObj))

template completionWordsLibraryClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeCompletionWordsLibrary, CompletionWordsLibraryClassObj))

template isCompletionWordsLibrary*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionWordsLibrary))

template isCompletionWordsLibraryClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeCompletionWordsLibrary))

template completionWordsLibraryGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeCompletionWordsLibrary, CompletionWordsLibraryClassObj))

type
  CompletionWordsLibrary* =  ptr CompletionWordsLibraryObj
  CompletionWordsLibraryPtr* = ptr CompletionWordsLibraryObj
  CompletionWordsLibraryObj*{.final.} = object of GObjectObj
    priv: pointer

  CompletionWordsLibraryClass* =  ptr CompletionWordsLibraryClassObj
  CompletionWordsLibraryClassPtr* = ptr CompletionWordsLibraryClassObj
  CompletionWordsLibraryClassObj*{.final.} = object of GObjectClassObj

proc completionWordsLibraryGetType*(): GType {.
    importc: "gtk_source_completion_words_library_get_type", libgsv.}
proc newCompletionWordsLibrary*(): CompletionWordsLibrary {.
    importc: "gtk_source_completion_words_library_new", libgsv.}

proc find*(
    library: CompletionWordsLibrary;
    proposal: CompletionWordsProposal): glib.GSequenceIter {.
    importc: "gtk_source_completion_words_library_find", libgsv.}
proc findFirst*(
    library: CompletionWordsLibrary; word: cstring; len: cint): glib.GSequenceIter {.
    importc: "gtk_source_completion_words_library_find_first", libgsv.}
proc completionWordsLibraryFindNext*(iter: glib.GSequenceIter;
    word: cstring; len: cint): glib.GSequenceIter {.
    importc: "gtk_source_completion_words_library_find_next", libgsv.}

proc completionWordsLibraryGetProposal*(iter: glib.GSequenceIter): CompletionWordsProposal {.
    importc: "gtk_source_completion_words_library_get_proposal", libgsv.}

proc addWord*(
    library: CompletionWordsLibrary; word: cstring): CompletionWordsProposal {.
    importc: "gtk_source_completion_words_library_add_word", libgsv.}
proc removeWord*(
    library: CompletionWordsLibrary;
    proposal: CompletionWordsProposal) {.
    importc: "gtk_source_completion_words_library_remove_word", libgsv.}
proc isLocked*(
    library: CompletionWordsLibrary): Gboolean {.
    importc: "gtk_source_completion_words_library_is_locked", libgsv.}
proc lock*(
    library: CompletionWordsLibrary) {.
    importc: "gtk_source_completion_words_library_lock", libgsv.}
proc unlock*(
    library: CompletionWordsLibrary) {.
    importc: "gtk_source_completion_words_library_unlock", libgsv.}

template typeCompletionWordsBuffer*(): untyped =
  (completionWordsBufferGetType())

template completionWordsBuffer*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, typeCompletionWordsBuffer, CompletionWordsBufferObj))

template completionWordsBufferClass*(klass: untyped): untyped =
  (gTypeCheckClassCast(klass, typeCompletionWordsBuffer, CompletionWordsBufferClassObj))

template isCompletionWordsBuffer*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, typeCompletionWordsBuffer))

template isCompletionWordsBufferClass*(klass: untyped): untyped =
  (gTypeCheckClassType(klass, typeCompletionWordsBuffer))

template completionWordsBufferGetClass*(obj: untyped): untyped =
  (gTypeInstanceGetClass(obj, typeCompletionWordsBuffer, CompletionWordsBufferClassObj))

type
  CompletionWordsBuffer* =  ptr CompletionWordsBufferObj
  CompletionWordsBufferPtr* = ptr CompletionWordsBufferObj
  CompletionWordsBufferObj*{.final.} = object of GObjectObj
    priv: pointer

  CompletionWordsBufferClass* =  ptr CompletionWordsBufferClassObj
  CompletionWordsBufferClassPtr* = ptr CompletionWordsBufferClassObj
  CompletionWordsBufferClassObj*{.final.} = object of GObjectClassObj

proc completionWordsBufferGetType*(): GType {.
    importc: "gtk_source_completion_words_buffer_get_type", libgsv.}
proc newCompletionWordsBuffer*(library: CompletionWordsLibrary;
                                       buffer: gtk.TextBuffer): CompletionWordsBuffer {.
    importc: "gtk_source_completion_words_buffer_new", libgsv.}
proc getBuffer*(
    buffer: CompletionWordsBuffer): gtk.TextBuffer {.
    importc: "gtk_source_completion_words_buffer_get_buffer", libgsv.}
proc buffer*(
    buffer: CompletionWordsBuffer): gtk.TextBuffer {.
    importc: "gtk_source_completion_words_buffer_get_buffer", libgsv.}
proc setScanBatchSize*(
    buffer: CompletionWordsBuffer; size: cuint) {.
    importc: "gtk_source_completion_words_buffer_set_scan_batch_size", libgsv.}
proc `scanBatchSize=`*(
    buffer: CompletionWordsBuffer; size: cuint) {.
    importc: "gtk_source_completion_words_buffer_set_scan_batch_size", libgsv.}
proc setMinimumWordSize*(
    buffer: CompletionWordsBuffer; size: cuint) {.
    importc: "gtk_source_completion_words_buffer_set_minimum_word_size",
    libgsv.}
proc `minimumWordSize=`*(
    buffer: CompletionWordsBuffer; size: cuint) {.
    importc: "gtk_source_completion_words_buffer_set_minimum_word_size",
    libgsv.}

proc completionWordsUtilsScanWords*(text: cstring; minimumWordSize: cuint): glib.GSList {.
    importc: "_gtk_source_completion_words_utils_scan_words", libgsv.}
proc completionWordsUtilsGetEndWord*(text: cstring): cstring {.
    importc: "_gtk_source_completion_words_utils_get_end_word", libgsv.}
proc completionWordsUtilsAdjustRegion*(start: gtk.TextIter;
    `end`: gtk.TextIter) {.importc: "_gtk_source_completion_words_utils_adjust_region",
                           libgsv.}
proc completionWordsUtilsCheckScanRegion*(start: gtk.TextIter;
    `end`: gtk.TextIter) {.importc: "_gtk_source_completion_words_utils_check_scan_region",
                           libgsv.}

