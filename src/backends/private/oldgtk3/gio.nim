{.deadCodeElim: on.}

when defined(windows):
  const LIB_GIO = "libgio-2.0-0.dll"
elif defined(macosx):
  const LIB_GIO = "libgio-2.0(|-0).dylib"
else:
  const LIB_GIO = "libgio-2.0.so(|.0)"

{.pragma: libgio, cdecl, dynlib: LIB_GIO.}

from gobject import GObject, GType, GTypeInterface, GTypeInterfaceObj, GObjectClass, GCallback, GObjectObj, GObjectClassObj, GValue, GValueObj, GClosure,
  gTypeCheckInstanceCast, gTypeCheckInstanceType, gTypeInstanceGetInterface, gTypeCheckClassCast, gTypeCheckClassType, gTypeInstanceGetClass, isA

from glib import Gpointer, Gboolean, Goffset, Gsize, Gssize, Gconstpointer, GList, GBytes,
  GDestroyNotify, GVariantType, GVariant, GError, GOptionGroup,
  GIOCondition, GOptionFlags, GOptionArg, GQuark, GSeekType, GSourceFunc, GCompareDataFunc, GSpawnChildSetupFunc

when defined(unix):
  from posix import Pid, Uid

# from glibconfig.h.win32
const
  GLIB_SYSDEF_AF_UNIX = 1
  GLIB_SYSDEF_AF_INET = 2
  GLIB_SYSDEF_AF_INET6 = 23
  GLIB_SYSDEF_MSG_OOB = 1
  GLIB_SYSDEF_MSG_PEEK = 2
  GLIB_SYSDEF_MSG_DONTROUTE = 4

type
  GAppInfoCreateFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, NEEDS_TERMINAL = 1 shl 0,
    SUPPORTS_URIS = 1 shl 1,
    SUPPORTS_STARTUP_NOTIFICATION = 1 shl 2

type
  GConverterFlags* {.size: sizeof(cint), pure.} = enum
    NO_FLAGS = 0, INPUT_AT_END = 1 shl 0,
    FLUSH = 1 shl 1

type
  GConverterResult* {.size: sizeof(cint), pure.} = enum
    ERROR = 0, CONVERTED = 1, FINISHED = 2,
    FLUSHED = 3

type
  GDataStreamByteOrder* {.size: sizeof(cint), pure.} = enum
    BIG_ENDIAN, LITTLE_ENDIAN,
    HOST_ENDIAN

type
  GDataStreamNewlineType* {.size: sizeof(cint), pure.} = enum
    LF, CR,
    CR_LF, ANY

type
  GFileAttributeType* {.size: sizeof(cint), pure.} = enum
    INVALID = 0, STRING,
    BYTE_STRING, BOOLEAN,
    UINT32, INT32,
    UINT64, INT64,
    OBJECT, STRINGV

type
  GFileAttributeInfoFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    COPY_WITH_FILE = 1 shl 0,
    COPY_WHEN_MOVED = 1 shl 1

type
  GFileAttributeStatus* {.size: sizeof(cint), pure.} = enum
    UNSET = 0, SET,
    ERROR_SETTING

type
  GFileQueryInfoFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, NOFOLLOW_SYMLINKS = 1 shl 0

type
  GFileCreateFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, PRIVATE = 1 shl 0,
    REPLACE_DESTINATION = 1 shl 1

type
  GFileMeasureFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, REPORT_ANY_ERROR = 1 shl 1,
    APPARENT_SIZE = 1 shl 2, NO_XDEV = 1 shl 3

type
  GMountMountFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0

type
  GMountUnmountFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, FORCE = 1 shl 0

type
  GDriveStartFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0

type
  GDriveStartStopType* {.size: sizeof(cint), pure.} = enum
    UNKNOWN, SHUTDOWN,
    NETWORK, MULTIDISK,
    PASSWORD

type
  GFileCopyFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, OVERWRITE = 1 shl 0,
    BACKUP = 1 shl 1, NOFOLLOW_SYMLINKS = 1 shl 2,
    ALL_METADATA = 1 shl 3,
    NO_FALLBACK_FOR_MOVE = 1 shl 4,
    TARGET_DEFAULT_PERMS = 1 shl 5

type
  GFileMonitorFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, WATCH_MOUNTS = 1 shl 0,
    SEND_MOVED = 1 shl 1,
    WATCH_HARD_LINKS = 1 shl 2,
    WATCH_MOVES = 1 shl 3

type
  GFileType* {.size: sizeof(cint), pure.} = enum
    UNKNOWN = 0, REGULAR, DIRECTORY,
    SYMBOLIC_LINK, SPECIAL, SHORTCUT,
    MOUNTABLE

type
  GFilesystemPreviewType* {.size: sizeof(cint), pure.} = enum
    IF_ALWAYS = 0, IF_LOCAL,
    NEVER

type
  GFileMonitorEvent* {.size: sizeof(cint), pure.} = enum
    CHANGED, CHANGES_DONE_HINT,
    DELETED, CREATED,
    ATTRIBUTE_CHANGED, PRE_UNMOUNT,
    UNMOUNTED, MOVED,
    RENAMED, MOVED_IN,
    MOVED_OUT

type
  GIOErrorEnum* {.size: sizeof(cint), pure.} = enum
    FAILED, NOT_FOUND, EXISTS,
    IS_DIRECTORY, NOT_DIRECTORY, NOT_EMPTY,
    NOT_REGULAR_FILE, NOT_SYMBOLIC_LINK,
    NOT_MOUNTABLE_FILE, FILENAME_TOO_LONG,
    INVALID_FILENAME, TOO_MANY_LINKS, NO_SPACE,
    INVALID_ARGUMENT, PERMISSION_DENIED,
    NOT_SUPPORTED, NOT_MOUNTED, ALREADY_MOUNTED,
    CLOSED, CANCELLED, PENDING,
    READ_ONLY, CANT_CREATE_BACKUP, WRONG_ETAG,
    TIMED_OUT, WOULD_RECURSE, BUSY,
    WOULD_BLOCK, HOST_NOT_FOUND, WOULD_MERGE,
    FAILED_HANDLED, TOO_MANY_OPEN_FILES,
    NOT_INITIALIZED, ADDRESS_IN_USE,
    PARTIAL_INPUT, INVALID_DATA, DBUS_ERROR,
    HOST_UNREACHABLE, NETWORK_UNREACHABLE,
    CONNECTION_REFUSED, PROXY_FAILED,
    PROXY_AUTH_FAILED, PROXY_NEED_AUTH,
    PROXY_NOT_ALLOWED, BROKEN_PIPE,
    NOT_CONNECTED, MESSAGE_TOO_LARGE
const
    G_IO_ERROR_CONNECTION_CLOSED = GIOErrorEnum.BROKEN_PIPE

type
  GAskPasswordFlags* {.size: sizeof(cint), pure.} = enum
    NEED_PASSWORD = 1 shl 0,
    NEED_USERNAME = 1 shl 1, NEED_DOMAIN = 1 shl 2,
    SAVING_SUPPORTED = 1 shl 3,
    ANONYMOUS_SUPPORTED = 1 shl 4

type
  GPasswordSave* {.size: sizeof(cint), pure.} = enum
    NEVER, FOR_SESSION,
    PERMANENTLY

type
  GMountOperationResult* {.size: sizeof(cint), pure.} = enum
    HANDLED, ABORTED,
    UNHANDLED

type
  GOutputStreamSpliceFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    CLOSE_SOURCE = 1 shl 0,
    CLOSE_TARGET = 1 shl 1

type
  GIOStreamSpliceFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, CLOSE_STREAM1 = 1 shl 0,
    CLOSE_STREAM2 = 1 shl 1,
    WAIT_FOR_BOTH = 1 shl 2

type
  GEmblemOrigin* {.size: sizeof(cint), pure.} = enum
    UNKNOWN, DEVICE, LIVEMETADATA,
    TAG

type
  GResolverError* {.size: sizeof(cint), pure.} = enum
    NOT_FOUND, TEMPORARY_FAILURE,
    INTERNAL

type
  GResolverRecordType* {.size: sizeof(cint), pure.} = enum
    SRV = 1, MX, TXT,
    SOA, NS

type
  GResourceError* {.size: sizeof(cint), pure.} = enum
    NOT_FOUND, INTERNAL

type
  GResourceFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, COMPRESSED = 1 shl 0

type
  GResourceLookupFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0

type
  GSocketFamily* {.size: sizeof(cint), pure.} = enum
    INVALID, UNIX = GLIB_SYSDEF_AF_UNIX,
    IPV4 = GLIB_SYSDEF_AF_INET,
    IPV6 = GLIB_SYSDEF_AF_INET6

type
  GSocketType* {.size: sizeof(cint), pure.} = enum
    INVALID, STREAM, DATAGRAM,
    SEQPACKET

type
  GSocketMsgFlags* {.size: sizeof(cint), pure.} = enum
    NONE, OOB = GLIB_SYSDEF_MSG_OOB,
    PEEK = GLIB_SYSDEF_MSG_PEEK,
    DONTROUTE = GLIB_SYSDEF_MSG_DONTROUTE

type
  GSocketProtocol* {.size: sizeof(cint), pure.} = enum
    UNKNOWN = - 1, DEFAULT = 0,
    TCP = 6, UDP = 17,
    SCTP = 132

type
  GZlibCompressorFormat* {.size: sizeof(cint), pure.} = enum
    ZLIB, GZIP,
    RAW

type
  GUnixSocketAddressType* {.size: sizeof(cint), pure.} = enum
    INVALID, ANONYMOUS,
    PATH, ABSTRACT,
    ABSTRACT_PADDED

type
  GBusType* {.size: sizeof(cint), pure.} = enum
    STARTER = - 1, NONE = 0, SYSTEM = 1,
    SESSION = 2

type
  GBusNameOwnerFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    ALLOW_REPLACEMENT = 1 shl 0,
    REPLACE = 1 shl 1

type
  GBusNameWatcherFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    AUTO_START = 1 shl 0

type
  GDBusProxyFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    DO_NOT_LOAD_PROPERTIES = 1 shl 0,
    DO_NOT_CONNECT_SIGNALS = 1 shl 1,
    DO_NOT_AUTO_START = 1 shl 2,
    GET_INVALIDATED_PROPERTIES = 1 shl 3,
    DO_NOT_AUTO_START_AT_CONSTRUCTION = 1 shl 4

type
  GDBusError* {.size: sizeof(cint), pure.} = enum
    FAILED, NO_MEMORY, SERVICE_UNKNOWN,
    NAME_HAS_NO_OWNER, NO_REPLY, IO_ERROR,
    BAD_ADDRESS, NOT_SUPPORTED,
    LIMITS_EXCEEDED, ACCESS_DENIED,
    AUTH_FAILED, NO_SERVER, TIMEOUT,
    NO_NETWORK, ADDRESS_IN_USE,
    DISCONNECTED, INVALID_ARGS,
    FILE_NOT_FOUND, FILE_EXISTS,
    UNKNOWN_METHOD, TIMED_OUT,
    MATCH_RULE_NOT_FOUND, MATCH_RULE_INVALID,
    SPAWN_EXEC_FAILED, SPAWN_FORK_FAILED,
    SPAWN_CHILD_EXITED, SPAWN_CHILD_SIGNALED,
    SPAWN_FAILED, SPAWN_SETUP_FAILED,
    SPAWN_CONFIG_INVALID, SPAWN_SERVICE_INVALID,
    SPAWN_SERVICE_NOT_FOUND, SPAWN_PERMISSIONS_INVALID,
    SPAWN_FILE_INVALID, SPAWN_NO_MEMORY,
    UNIX_PROCESS_ID_UNKNOWN, INVALID_SIGNATURE,
    INVALID_FILE_CONTENT,
    SELINUX_SECURITY_CONTEXT_UNKNOWN,
    ADT_AUDIT_DATA_UNKNOWN, OBJECT_PATH_IN_USE,
    UNKNOWN_OBJECT, UNKNOWN_INTERFACE,
    UNKNOWN_PROPERTY, PROPERTY_READ_ONLY

type
  GDBusConnectionFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    AUTHENTICATION_CLIENT = 1 shl 0,
    AUTHENTICATION_SERVER = 1 shl 1,
    AUTHENTICATION_ALLOW_ANONYMOUS = 1 shl 2,
    MESSAGE_BUS_CONNECTION = 1 shl 3,
    DELAY_MESSAGE_PROCESSING = 1 shl 4

type
  GDBusCapabilityFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    UNIX_FD_PASSING = 1 shl 0

type
  GDBusCallFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, NO_AUTO_START = 1 shl 0,
    ALLOW_INTERACTIVE_AUTHORIZATION = 1 shl 1

type
  GDBusMessageType* {.size: sizeof(cint), pure.} = enum
    INVALID, METHOD_CALL,
    METHOD_RETURN, ERROR,
    SIGNAL

type
  GDBusMessageFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    NO_REPLY_EXPECTED = 1 shl 0,
    NO_AUTO_START = 1 shl 1,
    ALLOW_INTERACTIVE_AUTHORIZATION = 1 shl 2

type
  GDBusMessageHeaderField* {.size: sizeof(cint), pure.} = enum
    INVALID, PATH,
    INTERFACE, MEMBER,
    ERROR_NAME,
    REPLY_SERIAL,
    DESTINATION, SENDER,
    SIGNATURE,
    NUM_UNIX_FDS

type
  GDBusPropertyInfoFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    READABLE = 1 shl 0,
    WRITABLE = 1 shl 1

type
  GDBusSubtreeFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    DISPATCH_TO_UNENUMERATED_NODES = 1 shl 0

type
  GDBusServerFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, RUN_IN_THREAD = 1 shl 0,
    AUTHENTICATION_ALLOW_ANONYMOUS = 1 shl 1

type
  GDBusSignalFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, NO_MATCH_RULE = 1 shl 0,
    MATCH_ARG0_NAMESPACE = 1 shl 1,
    MATCH_ARG0_PATH = 1 shl 2

type
  GDBusSendMessageFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    PRESERVE_SERIAL = 1 shl 0

type
  GCredentialsType* {.size: sizeof(cint), pure.} = enum
    INVALID, LINUX_UCRED,
    FREEBSD_CMSGCRED, OPENBSD_SOCKPEERCRED,
    SOLARIS_UCRED, NETBSD_UNPCBID

type
  GDBusMessageByteOrder* {.size: sizeof(cint), pure.} = enum
    BIG_ENDIAN = 'B',
    LITTLE_ENDIAN = 'l'

type
  GApplicationFlags* {.size: sizeof(cint), pure.} = enum
    NONE, IS_SERVICE = 1 shl 0,
    IS_LAUNCHER = 1 shl 1, HANDLES_OPEN = 1 shl 2,
    HANDLES_COMMAND_LINE = 1 shl 3,
    SEND_ENVIRONMENT = 1 shl 4, NON_UNIQUE = 1 shl 5,
    CAN_OVERRIDE_APP_ID = 1 shl 6

type
  GTlsError* {.size: sizeof(cint), pure.} = enum
    UNAVAILABLE, MISC, BAD_CERTIFICATE,
    NOT_TLS, HANDSHAKE, CERTIFICATE_REQUIRED,
    EOF

type
  GTlsCertificateFlags* {.size: sizeof(cint), pure.} = enum
    UNKNOWN_CA = 1 shl 0,
    BAD_IDENTITY = 1 shl 1,
    NOT_ACTIVATED = 1 shl 2,
    EXPIRED = 1 shl 3, REVOKED = 1 shl 4,
    INSECURE = 1 shl 5,
    GENERIC_ERROR = 1 shl 6,
    VALIDATE_ALL = 0x7F

type
  GTlsAuthenticationMode* {.size: sizeof(cint), pure.} = enum
    NONE, REQUESTED,
    REQUIRED

type
  GTlsRehandshakeMode* {.size: sizeof(cint), pure.} = enum
    NEVER, SAFELY, UNSAFELY

type
  GTlsPasswordFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, RETRY = 1 shl 1,
    MANY_TRIES = 1 shl 2, FINAL_TRY = 1 shl 3

type
  GTlsInteractionResult* {.size: sizeof(cint), pure.} = enum
    UNHANDLED, HANDLED,
    FAILED

type
  GDBusInterfaceSkeletonFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, HANDLE_METHOD_INVOCATIONS_IN_THREAD = (
        1 shl 0)

type
  GDBusObjectManagerClientFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0,
    DO_NOT_AUTO_START = 1 shl 0

type
  GTlsDatabaseVerifyFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0

type
  GTlsDatabaseLookupFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, KEYPAIR = 1

type
  GTlsCertificateRequestFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0

type
  GIOModuleScopeFlags* {.size: sizeof(cint), pure.} = enum
    NONE, BLOCK_DUPLICATES

type
  GSocketClientEvent* {.size: sizeof(cint), pure.} = enum
    RESOLVING, RESOLVED,
    CONNECTING, CONNECTED,
    PROXY_NEGOTIATING, PROXY_NEGOTIATED,
    TLS_HANDSHAKING, TLS_HANDSHAKED,
    COMPLETE

type
  GSocketListenerEvent* {.size: sizeof(cint), pure.} = enum
    BINDING, BOUND,
    LISTENING, LISTENED

type
  GTestDBusFlags* {.size: sizeof(cint), pure.} = enum
    DBUS_NONE = 0

type
  GSubprocessFlags* {.size: sizeof(cint), pure.} = enum
    NONE = 0, STDIN_PIPE = 1 shl 0,
    STDIN_INHERIT = 1 shl 1,
    STDOUT_PIPE = 1 shl 2,
    STDOUT_SILENCE = 1 shl 3,
    STDERR_PIPE = 1 shl 4,
    STDERR_SILENCE = 1 shl 5,
    STDERR_MERGE = 1 shl 6,
    INHERIT_FDS = 1 shl 7

type
  GNotificationPriority* {.size: sizeof(cint), pure.} = enum
    NORMAL, LOW,
    HIGH, URGENT

type
  GNetworkConnectivity* {.size: sizeof(cint), pure.} = enum
    LOCAL = 1, LIMITED = 2,
    PORTAL = 3, FULL = 4

type
  GAppInfo* =  ptr GAppInfoObj
  GAppInfoPtr* = ptr GAppInfoObj
  GAppInfoObj* = object

type
  GAsyncResult* =  ptr GAsyncResultObj
  GAsyncResultPtr* = ptr GAsyncResultObj
  GAsyncResultObj* = object

type
  GAsyncInitable* =  ptr GAsyncInitableObj
  GAsyncInitablePtr* = ptr GAsyncInitableObj
  GAsyncInitableObj* = object

  GCharsetConverter* =  ptr GCharsetConverterObj
  GCharsetConverterPtr* = ptr GCharsetConverterObj
  GCharsetConverterObj* = object

  GConverter* =  ptr GConverterObj
  GConverterPtr* = ptr GConverterObj
  GConverterObj* = object

  GDatagramBased* =  ptr GDatagramBasedObj
  GDatagramBasedPtr* = ptr GDatagramBasedObj
  GDatagramBasedObj* = object

  GSimplePermission* =  ptr GSimplePermissionObj
  GSimplePermissionPtr* = ptr GSimplePermissionObj
  GSimplePermissionObj* = object

  GZlibCompressor* =  ptr GZlibCompressorObj
  GZlibCompressorPtr* = ptr GZlibCompressorObj
  GZlibCompressorObj* = object

  GZlibDecompressor* =  ptr GZlibDecompressorObj
  GZlibDecompressorPtr* = ptr GZlibDecompressorObj
  GZlibDecompressorObj* = object

  GRemoteActionGroup* =  ptr GRemoteActionGroupObj
  GRemoteActionGroupPtr* = ptr GRemoteActionGroupObj
  GRemoteActionGroupObj* = object

  GDBusActionGroup* =  ptr GDBusActionGroupObj
  GDBusActionGroupPtr* = ptr GDBusActionGroupObj
  GDBusActionGroupObj* = object

  GActionMap* =  ptr GActionMapObj
  GActionMapPtr* = ptr GActionMapObj
  GActionMapObj* = object

  GActionGroup* =  ptr GActionGroupObj
  GActionGroupPtr* = ptr GActionGroupObj
  GActionGroupObj* = object

  GPropertyAction* =  ptr GPropertyActionObj
  GPropertyActionPtr* = ptr GPropertyActionObj
  GPropertyActionObj* = object

  GSimpleAction* =  ptr GSimpleActionObj
  GSimpleActionPtr* = ptr GSimpleActionObj
  GSimpleActionObj* = object

  GAction* =  ptr GActionObj
  GActionPtr* = ptr GActionObj
  GActionObj* = object

  GSettingsBackend* =  ptr GSettingsBackendObj
  GSettingsBackendPtr* = ptr GSettingsBackendObj
  GSettingsBackendObj* = object

  GNotification* =  ptr GNotificationObj
  GNotificationPtr* = ptr GNotificationObj
  GNotificationObj* = object

type
  GDrive* =  ptr GDriveObj
  GDrivePtr* = ptr GDriveObj
  GDriveObj* = object

type
  GFile* =  ptr GFileObj
  GFilePtr* = ptr GFileObj
  GFileObj* = object

  GFileArray* = ptr array[0 .. 255, GFile]

type
  GFileInfo* =  ptr GFileInfoObj
  GFileInfoPtr* = ptr GFileInfoObj
  GFileInfoObj* = object

type
  GFileAttributeMatcher* =  ptr GFileAttributeMatcherObj
  GFileAttributeMatcherPtr* = ptr GFileAttributeMatcherObj
  GFileAttributeMatcherObj* = object

  GFileDescriptorBased* =  ptr GFileDescriptorBasedObj
  GFileDescriptorBasedPtr* = ptr GFileDescriptorBasedObj
  GFileDescriptorBasedObj* = object

  GFileIcon* =  ptr GFileIconObj
  GFileIconPtr* = ptr GFileIconObj
  GFileIconObj* = object

  GFilenameCompleter* =  ptr GFilenameCompleterObj
  GFilenameCompleterPtr* = ptr GFilenameCompleterObj
  GFilenameCompleterObj* = object

  GIcon* =  ptr GIconObj
  GIconPtr* = ptr GIconObj
  GIconObj* = object

type
  GInitable* =  ptr GInitableObj
  GInitablePtr* = ptr GInitableObj
  GInitableObj* = object

  GIOModule* =  ptr GIOModuleObj
  GIOModulePtr* = ptr GIOModuleObj
  GIOModuleObj* = object

  GIOExtensionPoint* =  ptr GIOExtensionPointObj
  GIOExtensionPointPtr* = ptr GIOExtensionPointObj
  GIOExtensionPointObj* = object

  GIOExtension* =  ptr GIOExtensionObj
  GIOExtensionPtr* = ptr GIOExtensionObj
  GIOExtensionObj* = object

type
  GIOSchedulerJob* =  ptr GIOSchedulerJobObj
  GIOSchedulerJobPtr* = ptr GIOSchedulerJobObj
  GIOSchedulerJobObj* = object

  GIOStreamAdapter* =  ptr GIOStreamAdapterObj
  GIOStreamAdapterPtr* = ptr GIOStreamAdapterObj
  GIOStreamAdapterObj* = object

  GLoadableIcon* =  ptr GLoadableIconObj
  GLoadableIconPtr* = ptr GLoadableIconObj
  GLoadableIconObj* = object

type
  GBytesIcon* =  ptr GBytesIconObj
  GBytesIconPtr* = ptr GBytesIconObj
  GBytesIconObj* = object

type
  GMount* =  ptr GMountObj
  GMountPtr* = ptr GMountObj
  GMountObj* = object

type
  GNetworkMonitor* =  ptr GNetworkMonitorObj
  GNetworkMonitorPtr* = ptr GNetworkMonitorObj
  GNetworkMonitorObj* = object

  GSimpleIOStream* =  ptr GSimpleIOStreamObj
  GSimpleIOStreamPtr* = ptr GSimpleIOStreamObj
  GSimpleIOStreamObj* = object

  GPollableInputStream* =  ptr GPollableInputStreamObj
  GPollableInputStreamPtr* = ptr GPollableInputStreamObj
  GPollableInputStreamObj* = object

type
  GPollableOutputStream* =  ptr GPollableOutputStreamObj
  GPollableOutputStreamPtr* = ptr GPollableOutputStreamObj
  GPollableOutputStreamObj* = object

type
  GResource* =  ptr GResourceObj
  GResourcePtr* = ptr GResourceObj
  GResourceObj* = object

  GSeekable* =  ptr GSeekableObj
  GSeekablePtr* = ptr GSeekableObj
  GSeekableObj* = object

  GSimpleAsyncResult* =  ptr GSimpleAsyncResultObj
  GSimpleAsyncResultPtr* = ptr GSimpleAsyncResultObj
  GSimpleAsyncResultObj* = object

type
  GSocketConnectable* =  ptr GSocketConnectableObj
  GSocketConnectablePtr* = ptr GSocketConnectableObj
  GSocketConnectableObj* = object

  GSrvTarget* =  ptr GSrvTargetObj
  GSrvTargetPtr* = ptr GSrvTargetObj
  GSrvTargetObj* = object

  GTask* =  ptr GTaskObj
  GTaskPtr* = ptr GTaskObj
  GTaskObj* = object

type
  GDtlsConnection* =  ptr GDtlsConnectionObj
  GDtlsConnectionPtr* = ptr GDtlsConnectionObj
  GDtlsConnectionObj* = object

  GDtlsClientConnection* =  ptr GDtlsClientConnectionObj
  GDtlsClientConnectionPtr* = ptr GDtlsClientConnectionObj
  GDtlsClientConnectionObj* = object

type
  GThemedIcon* =  ptr GThemedIconObj
  GThemedIconPtr* = ptr GThemedIconObj
  GThemedIconObj* = object

  GTlsClientConnection* =  ptr GTlsClientConnectionObj
  GTlsClientConnectionPtr* = ptr GTlsClientConnectionObj
  GTlsClientConnectionObj* = object

type
  GTlsFileDatabase* =  ptr GTlsFileDatabaseObj
  GTlsFileDatabasePtr* = ptr GTlsFileDatabaseObj
  GTlsFileDatabaseObj* = object

  GTlsServerConnection* =  ptr GTlsServerConnectionObj
  GTlsServerConnectionPtr* = ptr GTlsServerConnectionObj
  GTlsServerConnectionObj* = object

type
  GProxyResolver* =  ptr GProxyResolverObj
  GProxyResolverPtr* = ptr GProxyResolverObj
  GProxyResolverObj* = object

  GProxy* =  ptr GProxyObj
  GProxyPtr* = ptr GProxyObj
  GProxyObj* = object

type
  GVolume* =  ptr GVolumeObj
  GVolumePtr* = ptr GVolumeObj
  GVolumeObj* = object
type
  GSocketClass* =  ptr GSocketClassObj
  GSocketClassPtr* = ptr GSocketClassObj
  GSocketClassObj*{.final.} = object of GObjectClassObj
    gReserved11*: proc () {.cdecl.}
    gReserved12*: proc () {.cdecl.}
    gReserved13*: proc () {.cdecl.}
    gReserved14*: proc () {.cdecl.}
    gReserved15*: proc () {.cdecl.}
    gReserved16*: proc () {.cdecl.}
    gReserved17*: proc () {.cdecl.}
    gReserved18*: proc () {.cdecl.}
    gReserved19*: proc () {.cdecl.}
    gReserved10*: proc () {.cdecl.}

  GSocket* =  ptr GSocketObj
  GSocketPtr* = ptr GSocketObj
  GSocketObj*{.final.} = object of GObjectObj
    priv1: pointer
type
  GCancellable* =  ptr GCancellableObj
  GCancellablePtr* = ptr GCancellableObj
  GCancellableObj*{.final.} = object of GObjectObj
    priv2: pointer

  GCancellableClass* =  ptr GCancellableClassObj
  GCancellableClassPtr* = ptr GCancellableClassObj
  GCancellableClassObj*{.final.} = object of GObjectClassObj
    cancelled*: proc (cancellable: GCancellable) {.cdecl.}
    gReserved21*: proc () {.cdecl.}
    gReserved22*: proc () {.cdecl.}
    gReserved23*: proc () {.cdecl.}
    gReserved24*: proc () {.cdecl.}
    gReserved25*: proc () {.cdecl.}

type
  GAsyncReadyCallback* = proc (sourceObject: GObject; res: GAsyncResult;
                            userData: Gpointer) {.cdecl.}

type
  GFileProgressCallback* = proc (currentNumBytes: Goffset; totalNumBytes: Goffset;
                              userData: Gpointer) {.cdecl.}

type
  GFileReadMoreCallback* = proc (fileContents: cstring; fileSize: Goffset;
                              callbackData: Gpointer): Gboolean {.cdecl.}

type
  GFileMeasureProgressCallback* = proc (reporting: Gboolean; currentSize: uint64;
                                     numDirs: uint64; numFiles: uint64;
                                     userData: Gpointer) {.cdecl.}

type
  GIOSchedulerJobFunc* = proc (job: GIOSchedulerJob;
                            cancellable: GCancellable; userData: Gpointer): Gboolean {.cdecl.}

type
  GSimpleAsyncThreadFunc* = proc (res: GSimpleAsyncResult; `object`: GObject;
                               cancellable: GCancellable) {.cdecl.}

type
  GSocketSourceFunc* = proc (socket: GSocket; condition: GIOCondition;
                          userData: Gpointer): Gboolean {.cdecl.}

type
  GDatagramBasedSourceFunc* = proc (datagramBased: GDatagramBased;
                                 condition: GIOCondition; userData: Gpointer): Gboolean {.cdecl.}

type
  GInputVector* =  ptr GInputVectorObj
  GInputVectorPtr* = ptr GInputVectorObj
  GInputVectorObj* = object
    buffer*: Gpointer
    size*: Gsize
type
  GSocketControlMessageClass* =  ptr GSocketControlMessageClassObj
  GSocketControlMessageClassPtr* = ptr GSocketControlMessageClassObj
  GSocketControlMessageClassObj*{.final.} = object of GObjectClassObj
    getSize*: proc (message: GSocketControlMessage): Gsize {.cdecl.}
    getLevel*: proc (message: GSocketControlMessage): cint {.cdecl.}
    getType*: proc (message: GSocketControlMessage): cint {.cdecl.}
    serialize*: proc (message: GSocketControlMessage; data: Gpointer) {.cdecl.}
    deserialize*: proc (level: cint; `type`: cint; size: Gsize; data: Gpointer): GSocketControlMessage {.cdecl.}
    gReserved31*: proc () {.cdecl.}
    gReserved32*: proc () {.cdecl.}
    gReserved33*: proc () {.cdecl.}
    gReserved34*: proc () {.cdecl.}
    gReserved35*: proc () {.cdecl.}

  GSocketControlMessage* =  ptr GSocketControlMessageObj
  GSocketControlMessagePtr* = ptr GSocketControlMessageObj
  GSocketControlMessageObj*{.final.} = object of GObjectObj
    priv3: pointer

type
  GSocketAddress* =  ptr GSocketAddressObj
  GSocketAddressPtr* = ptr GSocketAddressObj
  GSocketAddressObj* = object of GObjectObj

  GSocketAddressClass* =  ptr GSocketAddressClassObj
  GSocketAddressClassPtr* = ptr GSocketAddressClassObj
  GSocketAddressClassObj* = object of GObjectClassObj
    getFamily*: proc (address: GSocketAddress): GSocketFamily {.cdecl.}
    getNativeSize*: proc (address: GSocketAddress): Gssize {.cdecl.}
    toNative*: proc (address: GSocketAddress; dest: Gpointer; destlen: Gsize;
                   error: var GError): Gboolean {.cdecl.}
type
  GInputMessage* =  ptr GInputMessageObj
  GInputMessagePtr* = ptr GInputMessageObj
  GInputMessageObj* = object
    address*: ptr GSocketAddress
    vectors*: GInputVector
    numVectors*: cuint
    bytesReceived*: Gsize
    flags*: cint
    controlMessages*: var ptr GSocketControlMessage
    numControlMessages*: ptr cuint

type
  GOutputVector* =  ptr GOutputVectorObj
  GOutputVectorPtr* = ptr GOutputVectorObj
  GOutputVectorObj* = object
    buffer*: Gconstpointer
    size*: Gsize

type
  GOutputMessage* =  ptr GOutputMessageObj
  GOutputMessagePtr* = ptr GOutputMessageObj
  GOutputMessageObj* = object
    address*: GSocketAddress
    vectors*: GOutputVector
    numVectors*: cuint
    bytesSent*: cuint
    controlMessages*: ptr GSocketControlMessage
    numControlMessages*: cuint

  GCredentials* =  ptr GCredentialsObj
  GCredentialsPtr* = ptr GCredentialsObj
  GCredentialsObj* = object

  GUnixCredentialsMessage* =  ptr GUnixCredentialsMessageObj
  GUnixCredentialsMessagePtr* = ptr GUnixCredentialsMessageObj
  GUnixCredentialsMessageObj* = object

  GUnixFDList* =  ptr GUnixFDListObj
  GUnixFDListPtr* = ptr GUnixFDListObj
  GUnixFDListObj* = object

  GDBusMessage* =  ptr GDBusMessageObj
  GDBusMessagePtr* = ptr GDBusMessageObj
  GDBusMessageObj* = object

  GDBusConnection* =  ptr GDBusConnectionObj
  GDBusConnectionPtr* = ptr GDBusConnectionObj
  GDBusConnectionObj* = object

  GDBusMethodInvocation* =  ptr GDBusMethodInvocationObj
  GDBusMethodInvocationPtr* = ptr GDBusMethodInvocationObj
  GDBusMethodInvocationObj* = object

  GDBusServer* =  ptr GDBusServerObj
  GDBusServerPtr* = ptr GDBusServerObj
  GDBusServerObj* = object

  GDBusAuthObserver* =  ptr GDBusAuthObserverObj
  GDBusAuthObserverPtr* = ptr GDBusAuthObserverObj
  GDBusAuthObserverObj* = object

type
  GCancellableSourceFunc* = proc (cancellable: GCancellable; userData: Gpointer): Gboolean {.cdecl.}

type
  GPollableSourceFunc* = proc (pollableStream: GObject; userData: Gpointer): Gboolean {.cdecl.}
  GDBusInterface* =  ptr GDBusInterfaceObj
  GDBusInterfacePtr* = ptr GDBusInterfaceObj
  GDBusInterfaceObj* = object

type
  GDBusObject* =  ptr GDBusObjectObj
  GDBusObjectPtr* = ptr GDBusObjectObj
  GDBusObjectObj* = object

type
  GDBusObjectManager* =  ptr GDBusObjectManagerObj
  GDBusObjectManagerPtr* = ptr GDBusObjectManagerObj
  GDBusObjectManagerObj* = object
type
  GDBusProxy* =  ptr GDBusProxyObj
  GDBusProxyPtr* = ptr GDBusProxyObj
  GDBusProxyObj*{.final.} = object of GObjectObj
    priv4: pointer

type
  GDBusProxyClass* =  ptr GDBusProxyClassObj
  GDBusProxyClassPtr* = ptr GDBusProxyClassObj
  GDBusProxyClassObj*{.final.} = object of GObjectClassObj
    gPropertiesChanged*: proc (proxy: GDBusProxy;
                             changedProperties: GVariant;
                             invalidatedProperties: cstringArray) {.cdecl.}
    gSignal*: proc (proxy: GDBusProxy; senderName: cstring; signalName: cstring;
                  parameters: GVariant) {.cdecl.}
    padding*: array[32, Gpointer]
type
  GDBusObjectProxy* =  ptr GDBusObjectProxyObj
  GDBusObjectProxyPtr* = ptr GDBusObjectProxyObj
  GDBusObjectProxyObj*{.final.} = object of GObjectObj
    priv5: pointer

type
  GDBusObjectProxyClass* =  ptr GDBusObjectProxyClassObj
  GDBusObjectProxyClassPtr* = ptr GDBusObjectProxyClassObj
  GDBusObjectProxyClassObj*{.final.} = object of GObjectClassObj
    padding*: array[8, Gpointer]
type
  GDBusObjectManagerClient* =  ptr GDBusObjectManagerClientObj
  GDBusObjectManagerClientPtr* = ptr GDBusObjectManagerClientObj
  GDBusObjectManagerClientObj*{.final.} = object of GObjectObj
    priv6: pointer

type
  GDBusObjectManagerClientClass* =  ptr GDBusObjectManagerClientClassObj
  GDBusObjectManagerClientClassPtr* = ptr GDBusObjectManagerClientClassObj
  GDBusObjectManagerClientClassObj*{.final.} = object of GObjectClassObj
    interfaceProxySignal*: proc (manager: GDBusObjectManagerClient;
                               objectProxy: GDBusObjectProxy;
                               interfaceProxy: GDBusProxy; senderName: cstring;
                               signalName: cstring; parameters: GVariant) {.cdecl.}
    interfaceProxyPropertiesChanged*: proc (manager: GDBusObjectManagerClient;
        objectProxy: GDBusObjectProxy; interfaceProxy: GDBusProxy;
        changedProperties: GVariant; invalidatedProperties: cstringArray) {.cdecl.}
    padding*: array[8, Gpointer]

type
  GDBusProxyTypeFunc* = proc (manager: GDBusObjectManagerClient;
                           objectPath: cstring; interfaceName: cstring;
                           userData: Gpointer): GType {.cdecl.}
  GTestDBus* =  ptr GTestDBusObj
  GTestDBusPtr* = ptr GTestDBusObj
  GTestDBusObj* = object

type
  GSubprocess* =  ptr GSubprocessObj
  GSubprocessPtr* = ptr GSubprocessObj
  GSubprocessObj* = object

type
  GSubprocessLauncher* =  ptr GSubprocessLauncherObj
  GSubprocessLauncherPtr* = ptr GSubprocessLauncherObj
  GSubprocessLauncherObj* = object

template gTypeAction*(): untyped =
  (actionGetType())

template gAction*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeAction, GActionObj))

template gIsAction*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeAction))

template gActionGetIface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeAction, GActionInterfaceObj))

type
  GActionInterface* =  ptr GActionInterfaceObj
  GActionInterfacePtr* = ptr GActionInterfaceObj
  GActionInterfaceObj*{.final.} = object of GTypeInterfaceObj
    getName*: proc (action: GAction): cstring {.cdecl.}
    getParameterType*: proc (action: GAction): GVariantType {.cdecl.}
    getStateType*: proc (action: GAction): GVariantType {.cdecl.}
    getStateHint*: proc (action: GAction): GVariant {.cdecl.}
    getEnabled*: proc (action: GAction): Gboolean {.cdecl.}
    getState*: proc (action: GAction): GVariant {.cdecl.}
    changeState*: proc (action: GAction; value: GVariant) {.cdecl.}
    activate*: proc (action: GAction; parameter: GVariant) {.cdecl.}

proc actionGetType*(): GType {.importc: "g_action_get_type", libgio.}
proc getName*(action: GAction): cstring {.importc: "g_action_get_name",
    libgio.}
proc name*(action: GAction): cstring {.importc: "g_action_get_name",
    libgio.}
proc getParameterType*(action: GAction): GVariantType {.
    importc: "g_action_get_parameter_type", libgio.}
proc parameterType*(action: GAction): GVariantType {.
    importc: "g_action_get_parameter_type", libgio.}
proc getStateType*(action: GAction): GVariantType {.
    importc: "g_action_get_state_type", libgio.}
proc stateType*(action: GAction): GVariantType {.
    importc: "g_action_get_state_type", libgio.}
proc getStateHint*(action: GAction): GVariant {.
    importc: "g_action_get_state_hint", libgio.}
proc stateHint*(action: GAction): GVariant {.
    importc: "g_action_get_state_hint", libgio.}
proc getEnabled*(action: GAction): Gboolean {.
    importc: "g_action_get_enabled", libgio.}
proc enabled*(action: GAction): Gboolean {.
    importc: "g_action_get_enabled", libgio.}
proc getState*(action: GAction): GVariant {.
    importc: "g_action_get_state", libgio.}
proc state*(action: GAction): GVariant {.
    importc: "g_action_get_state", libgio.}
proc changeState*(action: GAction; value: GVariant) {.
    importc: "g_action_change_state", libgio.}
proc activate*(action: GAction; parameter: GVariant) {.
    importc: "g_action_activate", libgio.}
proc actionNameIsValid*(actionName: cstring): Gboolean {.
    importc: "g_action_name_is_valid", libgio.}
proc actionParseDetailedName*(detailedName: cstring; actionName: cstringArray;
                              targetValue: var GVariant; error: var GError): Gboolean {.
    importc: "g_action_parse_detailed_name", libgio.}
proc actionPrintDetailedName*(actionName: cstring; targetValue: GVariant): cstring {.
    importc: "g_action_print_detailed_name", libgio.}

template gTypeActionGroup*(): untyped =
  (actionGroupGetType())

template gActionGroup*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeActionGroup, GActionGroupObj))

template gIsActionGroup*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeActionGroup))

template gActionGroupGetIface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeActionGroup, GActionGroupInterfaceObj))

type
  GActionGroupInterface* =  ptr GActionGroupInterfaceObj
  GActionGroupInterfacePtr* = ptr GActionGroupInterfaceObj
  GActionGroupInterfaceObj*{.final.} = object of GTypeInterfaceObj
    hasAction*: proc (actionGroup: GActionGroup; actionName: cstring): Gboolean {.cdecl.}
    listActions*: proc (actionGroup: GActionGroup): cstringArray {.cdecl.}
    getActionEnabled*: proc (actionGroup: GActionGroup; actionName: cstring): Gboolean {.cdecl.}
    getActionParameterType*: proc (actionGroup: GActionGroup; actionName: cstring): GVariantType {.cdecl.}
    getActionStateType*: proc (actionGroup: GActionGroup; actionName: cstring): GVariantType {.cdecl.}
    getActionStateHint*: proc (actionGroup: GActionGroup; actionName: cstring): GVariant {.cdecl.}
    getActionState*: proc (actionGroup: GActionGroup; actionName: cstring): GVariant {.cdecl.}
    changeActionState*: proc (actionGroup: GActionGroup; actionName: cstring;
                            value: GVariant) {.cdecl.}
    activateAction*: proc (actionGroup: GActionGroup; actionName: cstring;
                         parameter: GVariant) {.cdecl.}
    actionAdded*: proc (actionGroup: GActionGroup; actionName: cstring) {.cdecl.}
    actionRemoved*: proc (actionGroup: GActionGroup; actionName: cstring) {.cdecl.}
    actionEnabledChanged*: proc (actionGroup: GActionGroup; actionName: cstring;
                               enabled: Gboolean) {.cdecl.}
    actionStateChanged*: proc (actionGroup: GActionGroup; actionName: cstring;
                             state: GVariant) {.cdecl.}
    queryAction*: proc (actionGroup: GActionGroup; actionName: cstring;
                      enabled: var Gboolean; parameterType: var GVariantType;
                      stateType: var GVariantType; stateHint: var GVariant;
                      state: var GVariant): Gboolean {.cdecl.}

proc actionGroupGetType*(): GType {.importc: "g_action_group_get_type", libgio.}
proc hasAction*(actionGroup: GActionGroup; actionName: cstring): Gboolean {.
    importc: "g_action_group_has_action", libgio.}
proc listActions*(actionGroup: GActionGroup): cstringArray {.
    importc: "g_action_group_list_actions", libgio.}
proc getActionParameterType*(actionGroup: GActionGroup;
                                        actionName: cstring): GVariantType {.
    importc: "g_action_group_get_action_parameter_type", libgio.}
proc actionParameterType*(actionGroup: GActionGroup;
                                        actionName: cstring): GVariantType {.
    importc: "g_action_group_get_action_parameter_type", libgio.}
proc getActionStateType*(actionGroup: GActionGroup;
                                    actionName: cstring): GVariantType {.
    importc: "g_action_group_get_action_state_type", libgio.}
proc actionStateType*(actionGroup: GActionGroup;
                                    actionName: cstring): GVariantType {.
    importc: "g_action_group_get_action_state_type", libgio.}
proc getActionStateHint*(actionGroup: GActionGroup;
                                    actionName: cstring): GVariant {.
    importc: "g_action_group_get_action_state_hint", libgio.}
proc actionStateHint*(actionGroup: GActionGroup;
                                    actionName: cstring): GVariant {.
    importc: "g_action_group_get_action_state_hint", libgio.}
proc getActionEnabled*(actionGroup: GActionGroup;
                                  actionName: cstring): Gboolean {.
    importc: "g_action_group_get_action_enabled", libgio.}
proc actionEnabled*(actionGroup: GActionGroup;
                                  actionName: cstring): Gboolean {.
    importc: "g_action_group_get_action_enabled", libgio.}
proc getActionState*(actionGroup: GActionGroup; actionName: cstring): GVariant {.
    importc: "g_action_group_get_action_state", libgio.}
proc actionState*(actionGroup: GActionGroup; actionName: cstring): GVariant {.
    importc: "g_action_group_get_action_state", libgio.}
proc changeActionState*(actionGroup: GActionGroup;
                                   actionName: cstring; value: GVariant) {.
    importc: "g_action_group_change_action_state", libgio.}
proc activateAction*(actionGroup: GActionGroup; actionName: cstring;
                                parameter: GVariant) {.
    importc: "g_action_group_activate_action", libgio.}

proc actionAdded*(actionGroup: GActionGroup; actionName: cstring) {.
    importc: "g_action_group_action_added", libgio.}
proc actionRemoved*(actionGroup: GActionGroup; actionName: cstring) {.
    importc: "g_action_group_action_removed", libgio.}
proc actionEnabledChanged*(actionGroup: GActionGroup;
                                      actionName: cstring; enabled: Gboolean) {.
    importc: "g_action_group_action_enabled_changed", libgio.}
proc actionStateChanged*(actionGroup: GActionGroup;
                                    actionName: cstring; state: GVariant) {.
    importc: "g_action_group_action_state_changed", libgio.}
proc queryAction*(actionGroup: GActionGroup; actionName: cstring;
                             enabled: var Gboolean;
                             parameterType: var GVariantType;
                             stateType: var GVariantType;
                             stateHint: var GVariant; state: var GVariant): Gboolean {.
    importc: "g_action_group_query_action", libgio.}

proc dbusConnectionExportActionGroup*(connection: GDBusConnection;
                                      objectPath: cstring;
                                      actionGroup: GActionGroup;
                                      error: var GError): cuint {.
    importc: "g_dbus_connection_export_action_group", libgio.}
proc dbusConnectionUnexportActionGroup*(connection: GDBusConnection;
                                        exportId: cuint) {.
    importc: "g_dbus_connection_unexport_action_group", libgio.}

template gTypeActionMap*(): untyped =
  (actionMapGetType())

template gActionMap*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeActionMap, GActionMapObj))

template gIsActionMap*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeActionMap))

template gActionMapGetIface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeActionMap, GActionMapInterfaceObj))

type
  GActionMapInterface* =  ptr GActionMapInterfaceObj
  GActionMapInterfacePtr* = ptr GActionMapInterfaceObj
  GActionMapInterfaceObj*{.final.} = object of GTypeInterfaceObj
    lookupAction*: proc (actionMap: GActionMap; actionName: cstring): GAction {.cdecl.}
    addAction*: proc (actionMap: GActionMap; action: GAction) {.cdecl.}
    removeAction*: proc (actionMap: GActionMap; actionName: cstring) {.cdecl.}

  GActionEntry* =  ptr GActionEntryObj
  GActionEntryPtr* = ptr GActionEntryObj
  GActionEntryObj* = object
    name*: cstring
    activate*: proc (action: GSimpleAction; parameter: GVariant;
                   userData: Gpointer) {.cdecl.}
    parameterType*: cstring
    state*: cstring
    changeState*: proc (action: GSimpleAction; value: GVariant;
                      userData: Gpointer) {.cdecl.}
    padding*: array[3, Gsize]

proc actionMapGetType*(): GType {.importc: "g_action_map_get_type", libgio.}
proc lookupAction*(actionMap: GActionMap; actionName: cstring): GAction {.
    importc: "g_action_map_lookup_action", libgio.}
proc addAction*(actionMap: GActionMap; action: GAction) {.
    importc: "g_action_map_add_action", libgio.}
proc removeAction*(actionMap: GActionMap; actionName: cstring) {.
    importc: "g_action_map_remove_action", libgio.}
proc addActionEntries*(actionMap: GActionMap;
                                entries: GActionEntry; nEntries: cint;
                                userData: Gpointer) {.
    importc: "g_action_map_add_action_entries", libgio.}

template gTypeAppInfo*(): untyped =
  (appInfoGetType())

template gAppInfo*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeAppInfo, GAppInfoObj))

template gIsAppInfo*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeAppInfo))

template gAppInfoGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeAppInfo, GAppInfoIfaceObj))

template gTypeAppLaunchContext*(): untyped =
  (appLaunchContextGetType())

template gAppLaunchContext*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeAppLaunchContext, GAppLaunchContextObj))

template gAppLaunchContextClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeAppLaunchContext, GAppLaunchContextClassObj))

template gIsAppLaunchContext*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeAppLaunchContext))

template gIsAppLaunchContextClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeAppLaunchContext))

template gAppLaunchContextGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeAppLaunchContext, GAppLaunchContextClassObj))

type
  GAppLaunchContext* =  ptr GAppLaunchContextObj
  GAppLaunchContextPtr* = ptr GAppLaunchContextObj
  GAppLaunchContextObj*{.final.} = object of GObjectObj
    priv7: pointer

  GAppLaunchContextClass* =  ptr GAppLaunchContextClassObj
  GAppLaunchContextClassPtr* = ptr GAppLaunchContextClassObj
  GAppLaunchContextClassObj*{.final.} = object of GObjectClassObj
    getDisplay*: proc (context: GAppLaunchContext; info: GAppInfo;
                     files: GList): cstring {.cdecl.}
    getStartupNotifyId*: proc (context: GAppLaunchContext; info: GAppInfo;
                             files: GList): cstring {.cdecl.}
    launchFailed*: proc (context: GAppLaunchContext; startupNotifyId: cstring) {.cdecl.}
    launched*: proc (context: GAppLaunchContext; info: GAppInfo;
                   platformData: GVariant) {.cdecl.}
    gReserved41*: proc () {.cdecl.}
    gReserved42*: proc () {.cdecl.}
    gReserved43*: proc () {.cdecl.}
    gReserved44*: proc () {.cdecl.}

type
  GAppInfoIface* =  ptr GAppInfoIfaceObj
  GAppInfoIfacePtr* = ptr GAppInfoIfaceObj
  GAppInfoIfaceObj*{.final.} = object of GTypeInterfaceObj
    dup*: proc (appinfo: GAppInfo): GAppInfo {.cdecl.}
    equal*: proc (appinfo1: GAppInfo; appinfo2: GAppInfo): Gboolean {.cdecl.}
    getId*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    getName*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    getDescription*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    getExecutable*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    getIcon*: proc (appinfo: GAppInfo): GIcon {.cdecl.}
    launch*: proc (appinfo: GAppInfo; files: GList;
                 launchContext: GAppLaunchContext; error: var GError): Gboolean {.cdecl.}
    supportsUris*: proc (appinfo: GAppInfo): Gboolean {.cdecl.}
    supportsFiles*: proc (appinfo: GAppInfo): Gboolean {.cdecl.}
    launchUris*: proc (appinfo: GAppInfo; uris: GList;
                     launchContext: GAppLaunchContext; error: var GError): Gboolean {.cdecl.}
    shouldShow*: proc (appinfo: GAppInfo): Gboolean {.cdecl.}
    setAsDefaultForType*: proc (appinfo: GAppInfo; contentType: cstring;
                              error: var GError): Gboolean {.cdecl.}
    setAsDefaultForExtension*: proc (appinfo: GAppInfo; extension: cstring;
                                   error: var GError): Gboolean {.cdecl.}
    addSupportsType*: proc (appinfo: GAppInfo; contentType: cstring;
                          error: var GError): Gboolean {.cdecl.}
    canRemoveSupportsType*: proc (appinfo: GAppInfo): Gboolean {.cdecl.}
    removeSupportsType*: proc (appinfo: GAppInfo; contentType: cstring;
                             error: var GError): Gboolean {.cdecl.}
    canDelete*: proc (appinfo: GAppInfo): Gboolean {.cdecl.}
    doDelete*: proc (appinfo: GAppInfo): Gboolean {.cdecl.}
    getCommandline*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    getDisplayName*: proc (appinfo: GAppInfo): cstring {.cdecl.}
    setAsLastUsedForType*: proc (appinfo: GAppInfo; contentType: cstring;
                               error: var GError): Gboolean {.cdecl.}
    getSupportedTypes*: proc (appinfo: GAppInfo): cstringArray {.cdecl.}

proc appInfoGetType*(): GType {.importc: "g_app_info_get_type", libgio.}
proc appInfoCreateFromCommandline*(commandline: cstring; applicationName: cstring;
                                   flags: GAppInfoCreateFlags;
                                   error: var GError): GAppInfo {.
    importc: "g_app_info_create_from_commandline", libgio.}
proc dup*(appinfo: GAppInfo): GAppInfo {.importc: "g_app_info_dup",
    libgio.}
proc equal*(appinfo1: GAppInfo; appinfo2: GAppInfo): Gboolean {.
    importc: "g_app_info_equal", libgio.}
proc getId*(appinfo: GAppInfo): cstring {.importc: "g_app_info_get_id",
    libgio.}
proc id*(appinfo: GAppInfo): cstring {.importc: "g_app_info_get_id",
    libgio.}
proc getName*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_name", libgio.}
proc name*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_name", libgio.}
proc getDisplayName*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_display_name", libgio.}
proc displayName*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_display_name", libgio.}
proc getDescription*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_description", libgio.}
proc description*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_description", libgio.}
proc getExecutable*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_executable", libgio.}
proc executable*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_executable", libgio.}
proc getCommandline*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_commandline", libgio.}
proc commandline*(appinfo: GAppInfo): cstring {.
    importc: "g_app_info_get_commandline", libgio.}
proc getIcon*(appinfo: GAppInfo): GIcon {.
    importc: "g_app_info_get_icon", libgio.}
proc icon*(appinfo: GAppInfo): GIcon {.
    importc: "g_app_info_get_icon", libgio.}
proc launch*(appinfo: GAppInfo; files: GList;
                    launchContext: GAppLaunchContext; error: var GError): Gboolean {.
    importc: "g_app_info_launch", libgio.}
proc supportsUris*(appinfo: GAppInfo): Gboolean {.
    importc: "g_app_info_supports_uris", libgio.}
proc supportsFiles*(appinfo: GAppInfo): Gboolean {.
    importc: "g_app_info_supports_files", libgio.}
proc launchUris*(appinfo: GAppInfo; uris: GList;
                        launchContext: GAppLaunchContext; error: var GError): Gboolean {.
    importc: "g_app_info_launch_uris", libgio.}
proc shouldShow*(appinfo: GAppInfo): Gboolean {.
    importc: "g_app_info_should_show", libgio.}
proc setAsDefaultForType*(appinfo: GAppInfo; contentType: cstring;
                                 error: var GError): Gboolean {.
    importc: "g_app_info_set_as_default_for_type", libgio.}
proc setAsDefaultForExtension*(appinfo: GAppInfo; extension: cstring;
                                      error: var GError): Gboolean {.
    importc: "g_app_info_set_as_default_for_extension", libgio.}
proc addSupportsType*(appinfo: GAppInfo; contentType: cstring;
                             error: var GError): Gboolean {.
    importc: "g_app_info_add_supports_type", libgio.}
proc canRemoveSupportsType*(appinfo: GAppInfo): Gboolean {.
    importc: "g_app_info_can_remove_supports_type", libgio.}
proc removeSupportsType*(appinfo: GAppInfo; contentType: cstring;
                                error: var GError): Gboolean {.
    importc: "g_app_info_remove_supports_type", libgio.}
proc getSupportedTypes*(appinfo: GAppInfo): cstringArray {.
    importc: "g_app_info_get_supported_types", libgio.}
proc supportedTypes*(appinfo: GAppInfo): cstringArray {.
    importc: "g_app_info_get_supported_types", libgio.}
proc canDelete*(appinfo: GAppInfo): Gboolean {.
    importc: "g_app_info_can_delete", libgio.}
proc delete*(appinfo: GAppInfo): Gboolean {.importc: "g_app_info_delete",
    libgio.}
proc setAsLastUsedForType*(appinfo: GAppInfo; contentType: cstring;
                                  error: var GError): Gboolean {.
    importc: "g_app_info_set_as_last_used_for_type", libgio.}
proc appInfoGetAll*(): GList {.importc: "g_app_info_get_all", libgio.}
proc appInfoGetAllForType*(contentType: cstring): GList {.
    importc: "g_app_info_get_all_for_type", libgio.}
proc appInfoGetRecommendedForType*(contentType: cstring): GList {.
    importc: "g_app_info_get_recommended_for_type", libgio.}
proc appInfoGetFallbackForType*(contentType: cstring): GList {.
    importc: "g_app_info_get_fallback_for_type", libgio.}
proc appInfoResetTypeAssociations*(contentType: cstring) {.
    importc: "g_app_info_reset_type_associations", libgio.}
proc appInfoGetDefaultForType*(contentType: cstring; mustSupportUris: Gboolean): GAppInfo {.
    importc: "g_app_info_get_default_for_type", libgio.}
proc appInfoGetDefaultForUriScheme*(uriScheme: cstring): GAppInfo {.
    importc: "g_app_info_get_default_for_uri_scheme", libgio.}
proc appInfoLaunchDefaultForUri*(uri: cstring;
                                 launchContext: GAppLaunchContext;
                                 error: var GError): Gboolean {.
    importc: "g_app_info_launch_default_for_uri", libgio.}
proc appInfoLaunchDefaultForUriAsync*(uri: cstring;
                                      launchContext: GAppLaunchContext;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      userData: Gpointer) {.
    importc: "g_app_info_launch_default_for_uri_async", libgio.}
proc appInfoLaunchDefaultForUriFinish*(result: GAsyncResult;
                                       error: var GError): Gboolean {.
    importc: "g_app_info_launch_default_for_uri_finish", libgio.}

proc appLaunchContextGetType*(): GType {.importc: "g_app_launch_context_get_type",
                                       libgio.}
proc newAppLaunchContext*(): GAppLaunchContext {.
    importc: "g_app_launch_context_new", libgio.}
proc setenv*(context: GAppLaunchContext; variable: cstring;
                             value: cstring) {.
    importc: "g_app_launch_context_setenv", libgio.}
proc unsetenv*(context: GAppLaunchContext; variable: cstring) {.
    importc: "g_app_launch_context_unsetenv", libgio.}
proc getEnvironment*(context: GAppLaunchContext): cstringArray {.
    importc: "g_app_launch_context_get_environment", libgio.}
proc environment*(context: GAppLaunchContext): cstringArray {.
    importc: "g_app_launch_context_get_environment", libgio.}
proc getDisplay*(context: GAppLaunchContext;
                                 info: GAppInfo; files: GList): cstring {.
    importc: "g_app_launch_context_get_display", libgio.}
proc display*(context: GAppLaunchContext;
                                 info: GAppInfo; files: GList): cstring {.
    importc: "g_app_launch_context_get_display", libgio.}
proc getStartupNotifyId*(context: GAppLaunchContext;
    info: GAppInfo; files: GList): cstring {.
    importc: "g_app_launch_context_get_startup_notify_id", libgio.}
proc startupNotifyId*(context: GAppLaunchContext;
    info: GAppInfo; files: GList): cstring {.
    importc: "g_app_launch_context_get_startup_notify_id", libgio.}
proc launchFailed*(context: GAppLaunchContext;
                                   startupNotifyId: cstring) {.
    importc: "g_app_launch_context_launch_failed", libgio.}
template gTypeAppInfoMonitor*(): untyped =
  (appInfoMonitorGetType())

template gAppInfoMonitor*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeAppInfoMonitor, GAppInfoMonitorObj))

template gIsAppInfoMonitor*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeAppInfoMonitor))

type
  GAppInfoMonitor* =  ptr GAppInfoMonitorObj
  GAppInfoMonitorPtr* = ptr GAppInfoMonitorObj
  GAppInfoMonitorObj* = object

proc appInfoMonitorGetType*(): GType {.importc: "g_app_info_monitor_get_type",
                                     libgio.}
proc appInfoMonitorGet*(): GAppInfoMonitor {.importc: "g_app_info_monitor_get",
    libgio.}

template gTypeApplication*(): untyped =
  gio.applicationGetType()

template gApplication*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeApplication, GApplicationObj))

template gApplicationClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeApplication, GApplicationClassObj))

template gIsApplication*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeApplication))

template gIsApplicationClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeApplication))

template gApplicationGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeApplication, GApplicationClassObj))

type
  GInputStream* =  ptr GInputStreamObj
  GInputStreamPtr* = ptr GInputStreamObj
  GInputStreamObj* = object of GObjectObj
    priv8: pointer

  GInputStreamClass* =  ptr GInputStreamClassObj
  GInputStreamClassPtr* = ptr GInputStreamClassObj
  GInputStreamClassObj* = object of GObjectClassObj
    readFn*: proc (stream: GInputStream; buffer: pointer; count: Gsize;
                 cancellable: GCancellable; error: var GError): Gssize {.cdecl.}
    skip*: proc (stream: GInputStream; count: Gsize; cancellable: GCancellable;
               error: var GError): Gssize {.cdecl.}
    closeFn*: proc (stream: GInputStream; cancellable: GCancellable;
                  error: var GError): Gboolean {.cdecl.}
    readAsync*: proc (stream: GInputStream; buffer: pointer; count: Gsize;
                    ioPriority: cint; cancellable: GCancellable;
                    callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    readFinish*: proc (stream: GInputStream; result: GAsyncResult;
                     error: var GError): Gssize {.cdecl.}
    skipAsync*: proc (stream: GInputStream; count: Gsize; ioPriority: cint;
                    cancellable: GCancellable; callback: GAsyncReadyCallback;
                    userData: Gpointer) {.cdecl.}
    skipFinish*: proc (stream: GInputStream; result: GAsyncResult;
                     error: var GError): Gssize {.cdecl.}
    closeAsync*: proc (stream: GInputStream; ioPriority: cint;
                     cancellable: GCancellable; callback: GAsyncReadyCallback;
                     userData: Gpointer) {.cdecl.}
    closeFinish*: proc (stream: GInputStream; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    gReserved51*: proc () {.cdecl.}
    gReserved52*: proc () {.cdecl.}
    gReserved53*: proc () {.cdecl.}
    gReserved54*: proc () {.cdecl.}
    gReserved55*: proc () {.cdecl.}
type
  GApplicationCommandLine* =  ptr GApplicationCommandLineObj
  GApplicationCommandLinePtr* = ptr GApplicationCommandLineObj
  GApplicationCommandLineObj*{.final.} = object of GObjectObj
    priv9: pointer

  GApplicationCommandLineClass* =  ptr GApplicationCommandLineClassObj
  GApplicationCommandLineClassPtr* = ptr GApplicationCommandLineClassObj
  GApplicationCommandLineClassObj*{.final.} = object of GObjectClassObj
    printLiteral*: proc (cmdline: GApplicationCommandLine; message: cstring) {.cdecl.}
    printerrLiteral*: proc (cmdline: GApplicationCommandLine; message: cstring) {.cdecl.}
    getStdin*: proc (cmdline: GApplicationCommandLine): GInputStream {.cdecl.}
    padding*: array[11, Gpointer]
type
  GApplication* =  ptr GApplicationObj
  GApplicationPtr* = ptr GApplicationObj
  GApplicationObj* = object of GObjectObj
    priv10: pointer

  GApplicationClass* =  ptr GApplicationClassObj
  GApplicationClassPtr* = ptr GApplicationClassObj
  GApplicationClassObj* = object of GObjectClassObj
    startup*: proc (application: GApplication) {.cdecl.}
    activate*: proc (application: GApplication) {.cdecl.}
    open*: proc (application: GApplication; files: GFileArray; nFiles: cint;
               hint: cstring) {.cdecl.}
    commandLine*: proc (application: GApplication;
                      commandLine: GApplicationCommandLine): cint {.cdecl.}
    localCommandLine*: proc (application: GApplication;
                           arguments: ptr cstringArray; exitStatus: var cint): Gboolean {.cdecl.}
    beforeEmit*: proc (application: GApplication; platformData: GVariant) {.cdecl.}
    afterEmit*: proc (application: GApplication; platformData: GVariant) {.cdecl.}
    addPlatformData*: proc (application: GApplication;
                          builder: glib.GVariantBuilder) {.cdecl.}
    quitMainloop*: proc (application: GApplication) {.cdecl.}
    runMainloop*: proc (application: GApplication) {.cdecl.}
    shutdown*: proc (application: GApplication) {.cdecl.}
    dbusRegister*: proc (application: GApplication;
                       connection: GDBusConnection; objectPath: cstring;
                       error: var GError): Gboolean {.cdecl.}
    dbusUnregister*: proc (application: GApplication;
                         connection: GDBusConnection; objectPath: cstring) {.cdecl.}
    handleLocalOptions*: proc (application: GApplication;
                             options: glib.GVariantDict): cint {.cdecl.}
    padding*: array[8, Gpointer]

proc applicationGetType*(): GType {.importc: "g_application_get_type", libgio.}
proc applicationIdIsValid*(applicationId: cstring): Gboolean {.
    importc: "g_application_id_is_valid", libgio.}
proc newApplication*(applicationId: cstring; flags: GApplicationFlags): GApplication {.
    importc: "g_application_new", libgio.}
proc getApplicationId*(application: GApplication): cstring {.
    importc: "g_application_get_application_id", libgio.}
proc applicationId*(application: GApplication): cstring {.
    importc: "g_application_get_application_id", libgio.}
proc setApplicationId*(application: GApplication;
                                  applicationId: cstring) {.
    importc: "g_application_set_application_id", libgio.}
proc `applicationId=`*(application: GApplication;
                                  applicationId: cstring) {.
    importc: "g_application_set_application_id", libgio.}
proc getDbusConnection*(application: GApplication): GDBusConnection {.
    importc: "g_application_get_dbus_connection", libgio.}
proc dbusConnection*(application: GApplication): GDBusConnection {.
    importc: "g_application_get_dbus_connection", libgio.}
proc getDbusObjectPath*(application: GApplication): cstring {.
    importc: "g_application_get_dbus_object_path", libgio.}
proc dbusObjectPath*(application: GApplication): cstring {.
    importc: "g_application_get_dbus_object_path", libgio.}
proc getInactivityTimeout*(application: GApplication): cuint {.
    importc: "g_application_get_inactivity_timeout", libgio.}
proc inactivityTimeout*(application: GApplication): cuint {.
    importc: "g_application_get_inactivity_timeout", libgio.}
proc setInactivityTimeout*(application: GApplication;
                                      inactivityTimeout: cuint) {.
    importc: "g_application_set_inactivity_timeout", libgio.}
proc `inactivityTimeout=`*(application: GApplication;
                                      inactivityTimeout: cuint) {.
    importc: "g_application_set_inactivity_timeout", libgio.}
proc getFlags*(application: GApplication): GApplicationFlags {.
    importc: "g_application_get_flags", libgio.}
proc setFlags*(application: GApplication; flags: GApplicationFlags) {.
    importc: "g_application_set_flags", libgio.}
proc getResourceBasePath*(application: GApplication): cstring {.
    importc: "g_application_get_resource_base_path", libgio.}
proc resourceBasePath*(application: GApplication): cstring {.
    importc: "g_application_get_resource_base_path", libgio.}
proc setResourceBasePath*(application: GApplication;
                                     resourcePath: cstring) {.
    importc: "g_application_set_resource_base_path", libgio.}
proc `resourceBasePath=`*(application: GApplication;
                                     resourcePath: cstring) {.
    importc: "g_application_set_resource_base_path", libgio.}
proc setActionGroup*(application: GApplication;
                                actionGroup: GActionGroup) {.
    importc: "g_application_set_action_group", libgio.}
proc `actionGroup=`*(application: GApplication;
                                actionGroup: GActionGroup) {.
    importc: "g_application_set_action_group", libgio.}
proc addMainOptionEntries*(application: GApplication;
                                      entries: glib.GOptionEntry) {.
    importc: "g_application_add_main_option_entries", libgio.}
proc addMainOption*(application: GApplication; longName: cstring;
                               shortName: char; flags: GOptionFlags;
                               arg: GOptionArg; description: cstring;
                               argDescription: cstring) {.
    importc: "g_application_add_main_option", libgio.}
proc addOptionGroup*(application: GApplication;
                                group: glib.GOptionGroup) {.
    importc: "g_application_add_option_group", libgio.}
proc getIsRegistered*(application: GApplication): Gboolean {.
    importc: "g_application_get_is_registered", libgio.}
proc isRegistered*(application: GApplication): Gboolean {.
    importc: "g_application_get_is_registered", libgio.}
proc getIsRemote*(application: GApplication): Gboolean {.
    importc: "g_application_get_is_remote", libgio.}
proc isRemote*(application: GApplication): Gboolean {.
    importc: "g_application_get_is_remote", libgio.}
proc register*(application: GApplication;
                          cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_application_register", libgio.}
proc hold*(application: GApplication) {.
    importc: "g_application_hold", libgio.}
proc release*(application: GApplication) {.
    importc: "g_application_release", libgio.}
proc activate*(application: GApplication) {.
    importc: "g_application_activate", libgio.}
proc open*(application: GApplication; files: GFileArray;
                      nFiles: cint; hint: cstring) {.importc: "g_application_open",
    libgio.}
proc run*(application: GApplication; argc: cint; argv: cstringArray): cint {.
    importc: "g_application_run", libgio.}
proc quit*(application: GApplication) {.
    importc: "g_application_quit", libgio.}
proc applicationGetDefault*(): GApplication {.
    importc: "g_application_get_default", libgio.}
proc setDefault*(application: GApplication) {.
    importc: "g_application_set_default", libgio.}
proc `default=`*(application: GApplication) {.
    importc: "g_application_set_default", libgio.}
proc markBusy*(application: GApplication) {.
    importc: "g_application_mark_busy", libgio.}
proc unmarkBusy*(application: GApplication) {.
    importc: "g_application_unmark_busy", libgio.}
proc getIsBusy*(application: GApplication): Gboolean {.
    importc: "g_application_get_is_busy", libgio.}
proc isBusy*(application: GApplication): Gboolean {.
    importc: "g_application_get_is_busy", libgio.}
proc sendNotification*(application: GApplication; id: cstring;
                                  notification: GNotification) {.
    importc: "g_application_send_notification", libgio.}
proc withdrawNotification*(application: GApplication; id: cstring) {.
    importc: "g_application_withdraw_notification", libgio.}
proc bindBusyProperty*(application: GApplication;
                                  `object`: Gpointer; property: cstring) {.
    importc: "g_application_bind_busy_property", libgio.}
proc unbindBusyProperty*(application: GApplication;
                                    `object`: Gpointer; property: cstring) {.
    importc: "g_application_unbind_busy_property", libgio.}

template gTypeApplicationCommandLine*(): untyped =
  (applicationCommandLineGetType())

template gApplicationCommandLine*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeApplicationCommandLine, GApplicationCommandLineObj))

template gApplicationCommandLineClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeApplicationCommandLine, GApplicationCommandLineClassObj))

template gIsApplicationCommandLine*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeApplicationCommandLine))

template gIsApplicationCommandLineClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeApplicationCommandLine))

template gApplicationCommandLineGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeApplicationCommandLine, GApplicationCommandLineClassObj))

proc applicationCommandLineGetType*(): GType {.
    importc: "g_application_command_line_get_type", libgio.}
proc getArguments*(cmdline: GApplicationCommandLine;
    argc: var cint): cstringArray {.importc: "g_application_command_line_get_arguments",
                                libgio.}
proc arguments*(cmdline: GApplicationCommandLine;
    argc: var cint): cstringArray {.importc: "g_application_command_line_get_arguments",
                                libgio.}
proc getOptionsDict*(cmdline: GApplicationCommandLine): glib.GVariantDict {.
    importc: "g_application_command_line_get_options_dict", libgio.}
proc optionsDict*(cmdline: GApplicationCommandLine): glib.GVariantDict {.
    importc: "g_application_command_line_get_options_dict", libgio.}
proc getStdin*(cmdline: GApplicationCommandLine): GInputStream {.
    importc: "g_application_command_line_get_stdin", libgio.}
proc stdin*(cmdline: GApplicationCommandLine): GInputStream {.
    importc: "g_application_command_line_get_stdin", libgio.}
proc getEnviron*(cmdline: GApplicationCommandLine): cstringArray {.
    importc: "g_application_command_line_get_environ", libgio.}
proc environ*(cmdline: GApplicationCommandLine): cstringArray {.
    importc: "g_application_command_line_get_environ", libgio.}
proc getenv*(cmdline: GApplicationCommandLine;
                                   name: cstring): cstring {.
    importc: "g_application_command_line_getenv", libgio.}
proc getCwd*(cmdline: GApplicationCommandLine): cstring {.
    importc: "g_application_command_line_get_cwd", libgio.}
proc cwd*(cmdline: GApplicationCommandLine): cstring {.
    importc: "g_application_command_line_get_cwd", libgio.}
proc getIsRemote*(cmdline: GApplicationCommandLine): Gboolean {.
    importc: "g_application_command_line_get_is_remote", libgio.}
proc isRemote*(cmdline: GApplicationCommandLine): Gboolean {.
    importc: "g_application_command_line_get_is_remote", libgio.}
proc print*(cmdline: GApplicationCommandLine;
                                  format: cstring) {.varargs,
    importc: "g_application_command_line_print", libgio.}
proc printerr*(cmdline: GApplicationCommandLine;
                                     format: cstring) {.varargs,
    importc: "g_application_command_line_printerr", libgio.}
proc getExitStatus*(cmdline: GApplicationCommandLine): cint {.
    importc: "g_application_command_line_get_exit_status", libgio.}
proc exitStatus*(cmdline: GApplicationCommandLine): cint {.
    importc: "g_application_command_line_get_exit_status", libgio.}
proc setExitStatus*(cmdline: GApplicationCommandLine;
    exitStatus: cint) {.importc: "g_application_command_line_set_exit_status",
                      libgio.}
proc `exitStatus=`*(cmdline: GApplicationCommandLine;
    exitStatus: cint) {.importc: "g_application_command_line_set_exit_status",
                      libgio.}
proc getPlatformData*(cmdline: GApplicationCommandLine): GVariant {.
    importc: "g_application_command_line_get_platform_data", libgio.}
proc platformData*(cmdline: GApplicationCommandLine): GVariant {.
    importc: "g_application_command_line_get_platform_data", libgio.}
proc createFileForArg*(
    cmdline: GApplicationCommandLine; arg: cstring): GFile {.
    importc: "g_application_command_line_create_file_for_arg", libgio.}

template gTypeInitable*(): untyped =
  (initableGetType())

template gInitable*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeInitable, GInitableObj))

template gIsInitable*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeInitable))

template gInitableGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeInitable, GInitableIfaceObj))

template gTypeIsInitable*(`type`: untyped): untyped =
  (isA(`type`, gTypeInitable))

type
  GInitableIface* =  ptr GInitableIfaceObj
  GInitableIfacePtr* = ptr GInitableIfaceObj
  GInitableIfaceObj*{.final.} = object of GTypeInterfaceObj
    init*: proc (initable: GInitable; cancellable: GCancellable;
               error: var GError): Gboolean {.cdecl.}

proc initableGetType*(): GType {.importc: "g_initable_get_type", libgio.}
proc init*(initable: GInitable; cancellable: GCancellable;
                   error: var GError): Gboolean {.importc: "g_initable_init",
    libgio.}
proc newInitable*(objectType: GType; cancellable: GCancellable;
                  error: var GError; firstPropertyName: cstring): Gpointer {.
    varargs, importc: "g_initable_new", libgio.}
proc initableNewv*(objectType: GType; nParameters: cuint;
                   parameters: gobject.GParameter; cancellable: GCancellable;
                   error: var GError): Gpointer {.importc: "g_initable_newv",
    libgio.}
discard """
proc newInitable*(objectType: GType; firstPropertyName: cstring;
                        varArgs: VaList; cancellable: GCancellable;
                        error: var GError): GObject {.
    importc: "g_initable_new_valist", libgio.}
"""

template gTypeAsyncInitable*(): untyped =
  (asyncInitableGetType())

template gAsyncInitable*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeAsyncInitable, GAsyncInitableObj))

template gIsAsyncInitable*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeAsyncInitable))

template gAsyncInitableGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeAsyncInitable, GAsyncInitableIfaceObj))

template gTypeIsAsyncInitable*(`type`: untyped): untyped =
  (isA(`type`, gTypeAsyncInitable))

type
  GAsyncInitableIface* =  ptr GAsyncInitableIfaceObj
  GAsyncInitableIfacePtr* = ptr GAsyncInitableIfaceObj
  GAsyncInitableIfaceObj*{.final.} = object of GTypeInterfaceObj
    initAsync*: proc (initable: GAsyncInitable; ioPriority: cint;
                    cancellable: GCancellable; callback: GAsyncReadyCallback;
                    userData: Gpointer) {.cdecl.}
    initFinish*: proc (initable: GAsyncInitable; res: GAsyncResult;
                     error: var GError): Gboolean {.cdecl.}

proc asyncInitableGetType*(): GType {.importc: "g_async_initable_get_type",
                                    libgio.}
proc initAsync*(initable: GAsyncInitable; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_async_initable_init_async", libgio.}
proc initFinish*(initable: GAsyncInitable; res: GAsyncResult;
                              error: var GError): Gboolean {.
    importc: "g_async_initable_init_finish", libgio.}
proc newAsyncInitable*(objectType: GType; ioPriority: cint;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; userData: Gpointer;
                            firstPropertyName: cstring) {.varargs,
    importc: "g_async_initable_new_async", libgio.}
proc asyncInitableNewvAsync*(objectType: GType; nParameters: cuint;
                             parameters: gobject.GParameter; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_async_initable_newv_async", libgio.}
discard """
proc newAsyncInitable*(objectType: GType; firstPropertyName: cstring;
                                  varArgs: VaList; ioPriority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_async_initable_new_valist_async", libgio.}
"""
proc newFinish*(initable: GAsyncInitable; res: GAsyncResult;
                             error: var GError): GObject {.
    importc: "g_async_initable_new_finish", libgio.}

template gTypeAsyncResult*(): untyped =
  (asyncResultGetType())

template gAsyncResult*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeAsyncResult, GAsyncResultObj))

template gIsAsyncResult*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeAsyncResult))

template gAsyncResultGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeAsyncResult, GAsyncResultIfaceObj))

type
  GAsyncResultIface* =  ptr GAsyncResultIfaceObj
  GAsyncResultIfacePtr* = ptr GAsyncResultIfaceObj
  GAsyncResultIfaceObj*{.final.} = object of GTypeInterfaceObj
    getUserData*: proc (res: GAsyncResult): Gpointer {.cdecl.}
    getSourceObject*: proc (res: GAsyncResult): GObject {.cdecl.}
    isTagged*: proc (res: GAsyncResult; sourceTag: Gpointer): Gboolean {.cdecl.}

proc asyncResultGetType*(): GType {.importc: "g_async_result_get_type", libgio.}
proc getUserData*(res: GAsyncResult): Gpointer {.
    importc: "g_async_result_get_user_data", libgio.}
proc userData*(res: GAsyncResult): Gpointer {.
    importc: "g_async_result_get_user_data", libgio.}
proc getSourceObject*(res: GAsyncResult): GObject {.
    importc: "g_async_result_get_source_object", libgio.}
proc sourceObject*(res: GAsyncResult): GObject {.
    importc: "g_async_result_get_source_object", libgio.}
proc legacyPropagateError*(res: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_async_result_legacy_propagate_error", libgio.}
proc isTagged*(res: GAsyncResult; sourceTag: Gpointer): Gboolean {.
    importc: "g_async_result_is_tagged", libgio.}

template gTypeInputStream*(): untyped =
  (inputStreamGetType())

template gInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeInputStream, GInputStreamObj))

template gInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeInputStream, GInputStreamClassObj))

template gIsInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeInputStream))

template gIsInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeInputStream))

template gInputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeInputStream, GInputStreamClassObj))

proc inputStreamGetType*(): GType {.importc: "g_input_stream_get_type", libgio.}
proc read*(stream: GInputStream; buffer: pointer; count: Gsize;
                      cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_input_stream_read", libgio.}
proc readAll*(stream: GInputStream; buffer: pointer; count: Gsize;
                         bytesRead: var Gsize; cancellable: GCancellable;
                         error: var GError): Gboolean {.
    importc: "g_input_stream_read_all", libgio.}
proc readBytes*(stream: GInputStream; count: Gsize;
                           cancellable: GCancellable; error: var GError): glib.GBytes {.
    importc: "g_input_stream_read_bytes", libgio.}
proc skip*(stream: GInputStream; count: Gsize;
                      cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_input_stream_skip", libgio.}
proc close*(stream: GInputStream; cancellable: GCancellable;
                       error: var GError): Gboolean {.
    importc: "g_input_stream_close", libgio.}
proc readAsync*(stream: GInputStream; buffer: pointer; count: Gsize;
                           ioPriority: cint; cancellable: GCancellable;
                           callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_input_stream_read_async", libgio.}
proc readFinish*(stream: GInputStream; result: GAsyncResult;
                            error: var GError): Gssize {.
    importc: "g_input_stream_read_finish", libgio.}
proc readAllAsync*(stream: GInputStream; buffer: pointer;
                              count: Gsize; ioPriority: cint;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_input_stream_read_all_async", libgio.}
proc readAllFinish*(stream: GInputStream; result: GAsyncResult;
                               bytesRead: var Gsize; error: var GError): Gboolean {.
    importc: "g_input_stream_read_all_finish", libgio.}
proc readBytesAsync*(stream: GInputStream; count: Gsize;
                                ioPriority: cint; cancellable: GCancellable;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_input_stream_read_bytes_async", libgio.}
proc readBytesFinish*(stream: GInputStream;
                                 result: GAsyncResult; error: var GError): glib.GBytes {.
    importc: "g_input_stream_read_bytes_finish", libgio.}
proc skipAsync*(stream: GInputStream; count: Gsize; ioPriority: cint;
                           cancellable: GCancellable;
                           callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_input_stream_skip_async", libgio.}
proc skipFinish*(stream: GInputStream; result: GAsyncResult;
                            error: var GError): Gssize {.
    importc: "g_input_stream_skip_finish", libgio.}
proc closeAsync*(stream: GInputStream; ioPriority: cint;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_input_stream_close_async", libgio.}
proc closeFinish*(stream: GInputStream; result: GAsyncResult;
                             error: var GError): Gboolean {.
    importc: "g_input_stream_close_finish", libgio.}

proc isClosed*(stream: GInputStream): Gboolean {.
    importc: "g_input_stream_is_closed", libgio.}
proc hasPending*(stream: GInputStream): Gboolean {.
    importc: "g_input_stream_has_pending", libgio.}
proc setPending*(stream: GInputStream; error: var GError): Gboolean {.
    importc: "g_input_stream_set_pending", libgio.}
proc clearPending*(stream: GInputStream) {.
    importc: "g_input_stream_clear_pending", libgio.}

template gTypeFilterInputStream*(): untyped =
  (filterInputStreamGetType())

template gFilterInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFilterInputStream, GFilterInputStreamObj))

template gFilterInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFilterInputStream, GFilterInputStreamClassObj))

template gIsFilterInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFilterInputStream))

template gIsFilterInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFilterInputStream))

template gFilterInputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFilterInputStream, GFilterInputStreamClassObj))

type
  GFilterInputStream* =  ptr GFilterInputStreamObj
  GFilterInputStreamPtr* = ptr GFilterInputStreamObj
  GFilterInputStreamObj* = object of GInputStreamObj
    baseStream*: GInputStream

  GFilterInputStreamClass* =  ptr GFilterInputStreamClassObj
  GFilterInputStreamClassPtr* = ptr GFilterInputStreamClassObj
  GFilterInputStreamClassObj* = object of GInputStreamClassObj
    gReserved61*: proc () {.cdecl.}
    gReserved62*: proc () {.cdecl.}
    gReserved63*: proc () {.cdecl.}

proc filterInputStreamGetType*(): GType {.importc: "g_filter_input_stream_get_type",
                                        libgio.}
proc getBaseStream*(stream: GFilterInputStream): GInputStream {.
    importc: "g_filter_input_stream_get_base_stream", libgio.}
proc baseStream*(stream: GFilterInputStream): GInputStream {.
    importc: "g_filter_input_stream_get_base_stream", libgio.}
proc getCloseBaseStream*(stream: GFilterInputStream): Gboolean {.
    importc: "g_filter_input_stream_get_close_base_stream", libgio.}
proc closeBaseStream*(stream: GFilterInputStream): Gboolean {.
    importc: "g_filter_input_stream_get_close_base_stream", libgio.}
proc setCloseBaseStream*(stream: GFilterInputStream;
    closeBase: Gboolean) {.importc: "g_filter_input_stream_set_close_base_stream",
                         libgio.}
proc `closeBaseStream=`*(stream: GFilterInputStream;
    closeBase: Gboolean) {.importc: "g_filter_input_stream_set_close_base_stream",
                         libgio.}

template gTypeBufferedInputStream*(): untyped =
  (bufferedInputStreamGetType())

template gBufferedInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeBufferedInputStream, GBufferedInputStreamObj))

template gBufferedInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeBufferedInputStream, GBufferedInputStreamClassObj))

template gIsBufferedInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeBufferedInputStream))

template gIsBufferedInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeBufferedInputStream))

template gBufferedInputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeBufferedInputStream, GBufferedInputStreamClassObj))

type
  GBufferedInputStream* =  ptr GBufferedInputStreamObj
  GBufferedInputStreamPtr* = ptr GBufferedInputStreamObj
  GBufferedInputStreamObj* = object of GFilterInputStreamObj
    priv11: pointer

  GBufferedInputStreamClass* =  ptr GBufferedInputStreamClassObj
  GBufferedInputStreamClassPtr* = ptr GBufferedInputStreamClassObj
  GBufferedInputStreamClassObj* = object of GFilterInputStreamClassObj
    fill*: proc (stream: GBufferedInputStream; count: Gssize;
               cancellable: GCancellable; error: var GError): Gssize {.cdecl.}
    fillAsync*: proc (stream: GBufferedInputStream; count: Gssize;
                    ioPriority: cint; cancellable: GCancellable;
                    callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    fillFinish*: proc (stream: GBufferedInputStream; result: GAsyncResult;
                     error: var GError): Gssize {.cdecl.}
    gReserved71*: proc () {.cdecl.}
    gReserved72*: proc () {.cdecl.}
    gReserved73*: proc () {.cdecl.}
    gReserved74*: proc () {.cdecl.}
    gReserved75*: proc () {.cdecl.}

proc bufferedInputStreamGetType*(): GType {.
    importc: "g_buffered_input_stream_get_type", libgio.}
proc newBufferedInputStream*(baseStream: GInputStream): GInputStream {.
    importc: "g_buffered_input_stream_new", libgio.}
proc newBufferedInputStream*(baseStream: GInputStream; size: Gsize): GInputStream {.
    importc: "g_buffered_input_stream_new_sized", libgio.}
proc getBufferSize*(stream: GBufferedInputStream): Gsize {.
    importc: "g_buffered_input_stream_get_buffer_size", libgio.}
proc bufferSize*(stream: GBufferedInputStream): Gsize {.
    importc: "g_buffered_input_stream_get_buffer_size", libgio.}
proc setBufferSize*(stream: GBufferedInputStream;
                                       size: Gsize) {.
    importc: "g_buffered_input_stream_set_buffer_size", libgio.}
proc `bufferSize=`*(stream: GBufferedInputStream;
                                       size: Gsize) {.
    importc: "g_buffered_input_stream_set_buffer_size", libgio.}
proc getAvailable*(stream: GBufferedInputStream): Gsize {.
    importc: "g_buffered_input_stream_get_available", libgio.}
proc available*(stream: GBufferedInputStream): Gsize {.
    importc: "g_buffered_input_stream_get_available", libgio.}
proc peek*(stream: GBufferedInputStream; buffer: pointer;
                              offset: Gsize; count: Gsize): Gsize {.
    importc: "g_buffered_input_stream_peek", libgio.}
proc peekBuffer*(stream: GBufferedInputStream;
                                    count: var Gsize): pointer {.
    importc: "g_buffered_input_stream_peek_buffer", libgio.}
proc fill*(stream: GBufferedInputStream; count: Gssize;
                              cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_buffered_input_stream_fill", libgio.}
proc fillAsync*(stream: GBufferedInputStream; count: Gssize;
                                   ioPriority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_buffered_input_stream_fill_async", libgio.}
proc fillFinish*(stream: GBufferedInputStream;
                                    result: GAsyncResult; error: var GError): Gssize {.
    importc: "g_buffered_input_stream_fill_finish", libgio.}
proc readByte*(stream: GBufferedInputStream;
                                  cancellable: GCancellable;
                                  error: var GError): cint {.
    importc: "g_buffered_input_stream_read_byte", libgio.}

template gTypeOutputStream*(): untyped =
  (outputStreamGetType())

template gOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeOutputStream, GOutputStreamObj))

template gOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeOutputStream, GOutputStreamClassObj))

template gIsOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeOutputStream))

template gIsOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeOutputStream))

template gOutputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeOutputStream, GOutputStreamClassObj))

type
  GOutputStream* =  ptr GOutputStreamObj
  GOutputStreamPtr* = ptr GOutputStreamObj
  GOutputStreamObj* = object of GObjectObj
    priv12: pointer

  GOutputStreamClass* =  ptr GOutputStreamClassObj
  GOutputStreamClassPtr* = ptr GOutputStreamClassObj
  GOutputStreamClassObj* = object of GObjectClassObj
    writeFn*: proc (stream: GOutputStream; buffer: pointer; count: Gsize;
                  cancellable: GCancellable; error: var GError): Gssize {.cdecl.}
    splice*: proc (stream: GOutputStream; source: GInputStream;
                 flags: GOutputStreamSpliceFlags; cancellable: GCancellable;
                 error: var GError): Gssize {.cdecl.}
    flush*: proc (stream: GOutputStream; cancellable: GCancellable;
                error: var GError): Gboolean {.cdecl.}
    closeFn*: proc (stream: GOutputStream; cancellable: GCancellable;
                  error: var GError): Gboolean {.cdecl.}
    writeAsync*: proc (stream: GOutputStream; buffer: pointer; count: Gsize;
                     ioPriority: cint; cancellable: GCancellable;
                     callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    writeFinish*: proc (stream: GOutputStream; result: GAsyncResult;
                      error: var GError): Gssize {.cdecl.}
    spliceAsync*: proc (stream: GOutputStream; source: GInputStream;
                      flags: GOutputStreamSpliceFlags; ioPriority: cint;
                      cancellable: GCancellable; callback: GAsyncReadyCallback;
                      userData: Gpointer) {.cdecl.}
    spliceFinish*: proc (stream: GOutputStream; result: GAsyncResult;
                       error: var GError): Gssize {.cdecl.}
    flushAsync*: proc (stream: GOutputStream; ioPriority: cint;
                     cancellable: GCancellable; callback: GAsyncReadyCallback;
                     userData: Gpointer) {.cdecl.}
    flushFinish*: proc (stream: GOutputStream; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    closeAsync*: proc (stream: GOutputStream; ioPriority: cint;
                     cancellable: GCancellable; callback: GAsyncReadyCallback;
                     userData: Gpointer) {.cdecl.}
    closeFinish*: proc (stream: GOutputStream; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    gReserved81*: proc () {.cdecl.}
    gReserved82*: proc () {.cdecl.}
    gReserved83*: proc () {.cdecl.}
    gReserved84*: proc () {.cdecl.}
    gReserved85*: proc () {.cdecl.}
    gReserved86*: proc () {.cdecl.}
    gReserved87*: proc () {.cdecl.}
    gReserved88*: proc () {.cdecl.}

proc outputStreamGetType*(): GType {.importc: "g_output_stream_get_type",
                                   libgio.}
proc write*(stream: GOutputStream; buffer: pointer; count: Gsize;
                        cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_output_stream_write", libgio.}
proc writeAll*(stream: GOutputStream; buffer: pointer; count: Gsize;
                           bytesWritten: var Gsize; cancellable: GCancellable;
                           error: var GError): Gboolean {.
    importc: "g_output_stream_write_all", libgio.}
proc printf*(stream: GOutputStream; bytesWritten: var Gsize;
                         cancellable: GCancellable; error: var GError;
                         format: cstring): Gboolean {.varargs,
    importc: "g_output_stream_printf", libgio.}
discard """
proc vprintf*(stream: GOutputStream; bytesWritten: var Gsize;
                          cancellable: GCancellable; error: var GError;
                          format: cstring; args: VaList): Gboolean {.
    importc: "g_output_stream_vprintf", libgio.}
"""
proc writeBytes*(stream: GOutputStream; bytes: glib.GBytes;
                             cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_output_stream_write_bytes", libgio.}
proc splice*(stream: GOutputStream; source: GInputStream;
                         flags: GOutputStreamSpliceFlags;
                         cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_output_stream_splice", libgio.}
proc flush*(stream: GOutputStream; cancellable: GCancellable;
                        error: var GError): Gboolean {.
    importc: "g_output_stream_flush", libgio.}
proc close*(stream: GOutputStream; cancellable: GCancellable;
                        error: var GError): Gboolean {.
    importc: "g_output_stream_close", libgio.}
proc writeAsync*(stream: GOutputStream; buffer: pointer;
                             count: Gsize; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_output_stream_write_async", libgio.}
proc writeFinish*(stream: GOutputStream; result: GAsyncResult;
                              error: var GError): Gssize {.
    importc: "g_output_stream_write_finish", libgio.}
proc writeAllAsync*(stream: GOutputStream; buffer: pointer;
                                count: Gsize; ioPriority: cint;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_output_stream_write_all_async", libgio.}
proc writeAllFinish*(stream: GOutputStream;
                                 result: GAsyncResult; bytesWritten: var Gsize;
                                 error: var GError): Gboolean {.
    importc: "g_output_stream_write_all_finish", libgio.}
proc writeBytesAsync*(stream: GOutputStream; bytes: glib.GBytes;
                                  ioPriority: cint; cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_output_stream_write_bytes_async", libgio.}
proc writeBytesFinish*(stream: GOutputStream;
                                   result: GAsyncResult; error: var GError): Gssize {.
    importc: "g_output_stream_write_bytes_finish", libgio.}
proc spliceAsync*(stream: GOutputStream; source: GInputStream;
                              flags: GOutputStreamSpliceFlags; ioPriority: cint;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_output_stream_splice_async", libgio.}
proc spliceFinish*(stream: GOutputStream; result: GAsyncResult;
                               error: var GError): Gssize {.
    importc: "g_output_stream_splice_finish", libgio.}
proc flushAsync*(stream: GOutputStream; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_output_stream_flush_async", libgio.}
proc flushFinish*(stream: GOutputStream; result: GAsyncResult;
                              error: var GError): Gboolean {.
    importc: "g_output_stream_flush_finish", libgio.}
proc closeAsync*(stream: GOutputStream; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_output_stream_close_async", libgio.}
proc closeFinish*(stream: GOutputStream; result: GAsyncResult;
                              error: var GError): Gboolean {.
    importc: "g_output_stream_close_finish", libgio.}
proc isClosed*(stream: GOutputStream): Gboolean {.
    importc: "g_output_stream_is_closed", libgio.}
proc isClosing*(stream: GOutputStream): Gboolean {.
    importc: "g_output_stream_is_closing", libgio.}
proc hasPending*(stream: GOutputStream): Gboolean {.
    importc: "g_output_stream_has_pending", libgio.}
proc setPending*(stream: GOutputStream; error: var GError): Gboolean {.
    importc: "g_output_stream_set_pending", libgio.}
proc clearPending*(stream: GOutputStream) {.
    importc: "g_output_stream_clear_pending", libgio.}

template gTypeFilterOutputStream*(): untyped =
  (filterOutputStreamGetType())

template gFilterOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFilterOutputStream, GFilterOutputStreamObj))

template gFilterOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFilterOutputStream, GFilterOutputStreamClassObj))

template gIsFilterOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFilterOutputStream))

template gIsFilterOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFilterOutputStream))

template gFilterOutputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFilterOutputStream, GFilterOutputStreamClassObj))

type
  GFilterOutputStream* =  ptr GFilterOutputStreamObj
  GFilterOutputStreamPtr* = ptr GFilterOutputStreamObj
  GFilterOutputStreamObj* = object of GOutputStreamObj
    baseStream*: GOutputStream

  GFilterOutputStreamClass* =  ptr GFilterOutputStreamClassObj
  GFilterOutputStreamClassPtr* = ptr GFilterOutputStreamClassObj
  GFilterOutputStreamClassObj* = object of GOutputStreamClassObj
    gReserved91*: proc () {.cdecl.}
    gReserved92*: proc () {.cdecl.}
    gReserved93*: proc () {.cdecl.}

proc filterOutputStreamGetType*(): GType {.
    importc: "g_filter_output_stream_get_type", libgio.}
proc getBaseStream*(stream: GFilterOutputStream): GOutputStream {.
    importc: "g_filter_output_stream_get_base_stream", libgio.}
proc baseStream*(stream: GFilterOutputStream): GOutputStream {.
    importc: "g_filter_output_stream_get_base_stream", libgio.}
proc getCloseBaseStream*(stream: GFilterOutputStream): Gboolean {.
    importc: "g_filter_output_stream_get_close_base_stream", libgio.}
proc closeBaseStream*(stream: GFilterOutputStream): Gboolean {.
    importc: "g_filter_output_stream_get_close_base_stream", libgio.}
proc setCloseBaseStream*(stream: GFilterOutputStream;
    closeBase: Gboolean) {.importc: "g_filter_output_stream_set_close_base_stream",
                         libgio.}
proc `closeBaseStream=`*(stream: GFilterOutputStream;
    closeBase: Gboolean) {.importc: "g_filter_output_stream_set_close_base_stream",
                         libgio.}

template gTypeBufferedOutputStream*(): untyped =
  (bufferedOutputStreamGetType())

template gBufferedOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeBufferedOutputStream, GBufferedOutputStreamObj))

template gBufferedOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeBufferedOutputStream, GBufferedOutputStreamClassObj))

template gIsBufferedOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeBufferedOutputStream))

template gIsBufferedOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeBufferedOutputStream))

template gBufferedOutputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeBufferedOutputStream, GBufferedOutputStreamClassObj))

type
  GBufferedOutputStream* =  ptr GBufferedOutputStreamObj
  GBufferedOutputStreamPtr* = ptr GBufferedOutputStreamObj
  GBufferedOutputStreamObj*{.final.} = object of GFilterOutputStreamObj
    priv13: pointer

  GBufferedOutputStreamClass* =  ptr GBufferedOutputStreamClassObj
  GBufferedOutputStreamClassPtr* = ptr GBufferedOutputStreamClassObj
  GBufferedOutputStreamClassObj*{.final.} = object of GFilterOutputStreamClassObj
    gReserved101*: proc () {.cdecl.}
    gReserved102*: proc () {.cdecl.}

proc bufferedOutputStreamGetType*(): GType {.
    importc: "g_buffered_output_stream_get_type", libgio.}
proc newBufferedOutputStream*(baseStream: GOutputStream): GOutputStream {.
    importc: "g_buffered_output_stream_new", libgio.}
proc newBufferedOutputStream*(baseStream: GOutputStream; size: Gsize): GOutputStream {.
    importc: "g_buffered_output_stream_new_sized", libgio.}
proc getBufferSize*(stream: GBufferedOutputStream): Gsize {.
    importc: "g_buffered_output_stream_get_buffer_size", libgio.}
proc bufferSize*(stream: GBufferedOutputStream): Gsize {.
    importc: "g_buffered_output_stream_get_buffer_size", libgio.}
proc setBufferSize*(stream: GBufferedOutputStream;
                                        size: Gsize) {.
    importc: "g_buffered_output_stream_set_buffer_size", libgio.}
proc `bufferSize=`*(stream: GBufferedOutputStream;
                                        size: Gsize) {.
    importc: "g_buffered_output_stream_set_buffer_size", libgio.}
proc getAutoGrow*(stream: GBufferedOutputStream): Gboolean {.
    importc: "g_buffered_output_stream_get_auto_grow", libgio.}
proc autoGrow*(stream: GBufferedOutputStream): Gboolean {.
    importc: "g_buffered_output_stream_get_auto_grow", libgio.}
proc setAutoGrow*(stream: GBufferedOutputStream;
                                      autoGrow: Gboolean) {.
    importc: "g_buffered_output_stream_set_auto_grow", libgio.}
proc `autoGrow=`*(stream: GBufferedOutputStream;
                                      autoGrow: Gboolean) {.
    importc: "g_buffered_output_stream_set_auto_grow", libgio.}

template gTypeBytesIcon*(): untyped =
  (bytesIconGetType())

template gBytesIcon*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeBytesIcon, GBytesIconObj))

template gIsBytesIcon*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeBytesIcon))

proc bytesIconGetType*(): GType {.importc: "g_bytes_icon_get_type", libgio.}
proc newIcon*(bytes: glib.GBytes): GIcon {.importc: "g_bytes_icon_new",
    libgio.}
proc getBytes*(icon: GBytesIcon): glib.GBytes {.
    importc: "g_bytes_icon_get_bytes", libgio.}
proc bytes*(icon: GBytesIcon): glib.GBytes {.
    importc: "g_bytes_icon_get_bytes", libgio.}

template gTypeCancellable*(): untyped =
  (cancellableGetType())

template gCancellable*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeCancellable, GCancellableObj))

template gCancellableClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeCancellable, GCancellableClassObj))

template gIsCancellable*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeCancellable))

template gIsCancellableClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeCancellable))

template gCancellableGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeCancellable, GCancellableClassObj))

proc cancellableGetType*(): GType {.importc: "g_cancellable_get_type", libgio.}
proc newCancellable*(): GCancellable {.importc: "g_cancellable_new", libgio.}

proc isCancelled*(cancellable: GCancellable): Gboolean {.
    importc: "g_cancellable_is_cancelled", libgio.}
proc setErrorIfCancelled*(cancellable: GCancellable;
                                     error: var GError): Gboolean {.
    importc: "g_cancellable_set_error_if_cancelled", libgio.}
proc getFd*(cancellable: GCancellable): cint {.
    importc: "g_cancellable_get_fd", libgio.}
proc fd*(cancellable: GCancellable): cint {.
    importc: "g_cancellable_get_fd", libgio.}
proc makePollfd*(cancellable: GCancellable; pollfd: glib.GPollFD): Gboolean {.
    importc: "g_cancellable_make_pollfd", libgio.}
proc releaseFd*(cancellable: GCancellable) {.
    importc: "g_cancellable_release_fd", libgio.}
proc newSource*(cancellable: GCancellable): glib.GSource {.
    importc: "g_cancellable_source_new", libgio.}
proc cancellableGetCurrent*(): GCancellable {.
    importc: "g_cancellable_get_current", libgio.}
proc pushCurrent*(cancellable: GCancellable) {.
    importc: "g_cancellable_push_current", libgio.}
proc popCurrent*(cancellable: GCancellable) {.
    importc: "g_cancellable_pop_current", libgio.}
proc reset*(cancellable: GCancellable) {.
    importc: "g_cancellable_reset", libgio.}
proc connect*(cancellable: GCancellable; callback: GCallback;
                         data: Gpointer; dataDestroyFunc: GDestroyNotify): culong {.
    importc: "g_cancellable_connect", libgio.}
proc disconnect*(cancellable: GCancellable; handlerId: culong) {.
    importc: "g_cancellable_disconnect", libgio.}

proc cancel*(cancellable: GCancellable) {.
    importc: "g_cancellable_cancel", libgio.}

template gTypeConverter*(): untyped =
  (converterGetType())

template gConverter*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeConverter, GConverterObj))

template gIsConverter*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeConverter))

template gConverterGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeConverter, GConverterIfaceObj))

type
  GConverterIface* =  ptr GConverterIfaceObj
  GConverterIfacePtr* = ptr GConverterIfaceObj
  GConverterIfaceObj*{.final.} = object of GTypeInterfaceObj
    convert*: proc (`converter`: GConverter; inbuf: pointer; inbufSize: Gsize;
                  outbuf: pointer; outbufSize: Gsize; flags: GConverterFlags;
                  bytesRead: var Gsize; bytesWritten: var Gsize; error: var GError): GConverterResult {.cdecl.}
    reset*: proc (`converter`: GConverter) {.cdecl.}

proc converterGetType*(): GType {.importc: "g_converter_get_type", libgio.}
proc convert*(`converter`: GConverter; inbuf: pointer; inbufSize: Gsize;
                       outbuf: pointer; outbufSize: Gsize; flags: GConverterFlags;
                       bytesRead: var Gsize; bytesWritten: var Gsize;
                       error: var GError): GConverterResult {.
    importc: "g_converter_convert", libgio.}
proc reset*(`converter`: GConverter) {.importc: "g_converter_reset",
    libgio.}

template gTypeCharsetConverter*(): untyped =
  (charsetConverterGetType())

template gCharsetConverter*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeCharsetConverter, GCharsetConverterObj))

template gCharsetConverterClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeCharsetConverter, GCharsetConverterClassObj))

template gIsCharsetConverter*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeCharsetConverter))

template gIsCharsetConverterClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeCharsetConverter))

template gCharsetConverterGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeCharsetConverter, GCharsetConverterClassObj))

type
  GCharsetConverterClass* =  ptr GCharsetConverterClassObj
  GCharsetConverterClassPtr* = ptr GCharsetConverterClassObj
  GCharsetConverterClassObj*{.final.} = object of GObjectClassObj

proc charsetConverterGetType*(): GType {.importc: "g_charset_converter_get_type",
                                       libgio.}
proc newCharsetConverter*(toCharset: cstring; fromCharset: cstring;
                          error: var GError): GCharsetConverter {.
    importc: "g_charset_converter_new", libgio.}
proc setUseFallback*(`converter`: GCharsetConverter;
                                     useFallback: Gboolean) {.
    importc: "g_charset_converter_set_use_fallback", libgio.}
proc `useFallback=`*(`converter`: GCharsetConverter;
                                     useFallback: Gboolean) {.
    importc: "g_charset_converter_set_use_fallback", libgio.}
proc getUseFallback*(`converter`: GCharsetConverter): Gboolean {.
    importc: "g_charset_converter_get_use_fallback", libgio.}
proc useFallback*(`converter`: GCharsetConverter): Gboolean {.
    importc: "g_charset_converter_get_use_fallback", libgio.}
proc getNumFallbacks*(`converter`: GCharsetConverter): cuint {.
    importc: "g_charset_converter_get_num_fallbacks", libgio.}
proc numFallbacks*(`converter`: GCharsetConverter): cuint {.
    importc: "g_charset_converter_get_num_fallbacks", libgio.}

proc contentTypeEquals*(type1: cstring; type2: cstring): Gboolean {.
    importc: "g_content_type_equals", libgio.}
proc contentTypeIsA*(`type`: cstring; supertype: cstring): Gboolean {.
    importc: "g_content_type_is_a", libgio.}
proc contentTypeIsMimeType*(`type`: cstring; mimeType: cstring): Gboolean {.
    importc: "g_content_type_is_mime_type", libgio.}
proc contentTypeIsUnknown*(`type`: cstring): Gboolean {.
    importc: "g_content_type_is_unknown", libgio.}
proc contentTypeGetDescription*(`type`: cstring): cstring {.
    importc: "g_content_type_get_description", libgio.}
proc contentTypeGetMimeType*(`type`: cstring): cstring {.
    importc: "g_content_type_get_mime_type", libgio.}
proc contentTypeGetIcon*(`type`: cstring): GIcon {.
    importc: "g_content_type_get_icon", libgio.}
proc contentTypeGetSymbolicIcon*(`type`: cstring): GIcon {.
    importc: "g_content_type_get_symbolic_icon", libgio.}
proc contentTypeGetGenericIconName*(`type`: cstring): cstring {.
    importc: "g_content_type_get_generic_icon_name", libgio.}
proc contentTypeCanBeExecutable*(`type`: cstring): Gboolean {.
    importc: "g_content_type_can_be_executable", libgio.}
proc contentTypeFromMimeType*(mimeType: cstring): cstring {.
    importc: "g_content_type_from_mime_type", libgio.}
proc contentTypeGuess*(filename: cstring; data: var cuchar; dataSize: Gsize;
                       resultUncertain: var Gboolean): cstring {.
    importc: "g_content_type_guess", libgio.}
proc contentTypeGuessForTree*(root: GFile): cstringArray {.
    importc: "g_content_type_guess_for_tree", libgio.}
proc contentTypesGetRegistered*(): GList {.
    importc: "g_content_types_get_registered", libgio.}

template gTypeConverterInputStream*(): untyped =
  (converterInputStreamGetType())

template gConverterInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeConverterInputStream, GConverterInputStreamObj))

template gConverterInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeConverterInputStream, GConverterInputStreamClassObj))

template gIsConverterInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeConverterInputStream))

template gIsConverterInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeConverterInputStream))

template gConverterInputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeConverterInputStream, GConverterInputStreamClassObj))

type
  GConverterInputStream* =  ptr GConverterInputStreamObj
  GConverterInputStreamPtr* = ptr GConverterInputStreamObj
  GConverterInputStreamObj*{.final.} = object of GFilterInputStreamObj
    priv14: pointer

  GConverterInputStreamClass* =  ptr GConverterInputStreamClassObj
  GConverterInputStreamClassPtr* = ptr GConverterInputStreamClassObj
  GConverterInputStreamClassObj*{.final.} = object of GFilterInputStreamClassObj
    gReserved111*: proc () {.cdecl.}
    gReserved112*: proc () {.cdecl.}
    gReserved113*: proc () {.cdecl.}
    gReserved114*: proc () {.cdecl.}
    gReserved115*: proc () {.cdecl.}

proc converterInputStreamGetType*(): GType {.
    importc: "g_converter_input_stream_get_type", libgio.}
proc newConverterInputStream*(baseStream: GInputStream;
                              `converter`: GConverter): GInputStream {.
    importc: "g_converter_input_stream_new", libgio.}
proc getConverter*(converterStream: GConverterInputStream): GConverter {.
    importc: "g_converter_input_stream_get_converter", libgio.}
proc `converter`*(converterStream: GConverterInputStream): GConverter {.
    importc: "g_converter_input_stream_get_converter", libgio.}

template gTypeConverterOutputStream*(): untyped =
  (converterOutputStreamGetType())

template gConverterOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeConverterOutputStream, GConverterOutputStreamObj))

template gConverterOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeConverterOutputStream, GConverterOutputStreamClassObj))

template gIsConverterOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeConverterOutputStream))

template gIsConverterOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeConverterOutputStream))

template gConverterOutputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeConverterOutputStream, GConverterOutputStreamClassObj))

type
  GConverterOutputStream* =  ptr GConverterOutputStreamObj
  GConverterOutputStreamPtr* = ptr GConverterOutputStreamObj
  GConverterOutputStreamObj*{.final.} = object of GFilterOutputStreamObj
    priv15: pointer

  GConverterOutputStreamClass* =  ptr GConverterOutputStreamClassObj
  GConverterOutputStreamClassPtr* = ptr GConverterOutputStreamClassObj
  GConverterOutputStreamClassObj*{.final.} = object of GFilterOutputStreamClassObj
    gReserved121*: proc () {.cdecl.}
    gReserved122*: proc () {.cdecl.}
    gReserved123*: proc () {.cdecl.}
    gReserved124*: proc () {.cdecl.}
    gReserved125*: proc () {.cdecl.}

proc converterOutputStreamGetType*(): GType {.
    importc: "g_converter_output_stream_get_type", libgio.}
proc newConverterOutputStream*(baseStream: GOutputStream;
                               `converter`: GConverter): GOutputStream {.
    importc: "g_converter_output_stream_new", libgio.}
proc getConverter*(converterStream: GConverterOutputStream): GConverter {.
    importc: "g_converter_output_stream_get_converter", libgio.}
proc `converter`*(converterStream: GConverterOutputStream): GConverter {.
    importc: "g_converter_output_stream_get_converter", libgio.}

template gTypeCredentials*(): untyped =
  (credentialsGetType())

template gCredentials*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeCredentials, GCredentialsObj))

template gCredentialsClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeCredentials, GCredentialsClassObj))

template gCredentialsGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeCredentials, GCredentialsClassObj))

template gIsCredentials*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeCredentials))

template gIsCredentialsClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeCredentials))

type
  GCredentialsClass* =  ptr GCredentialsClassObj
  GCredentialsClassPtr* = ptr GCredentialsClassObj
  GCredentialsClassObj* = object

proc credentialsGetType*(): GType {.importc: "g_credentials_get_type", libgio.}
proc newCredentials*(): GCredentials {.importc: "g_credentials_new", libgio.}
proc toString*(credentials: GCredentials): cstring {.
    importc: "g_credentials_to_string", libgio.}
proc getNative*(credentials: GCredentials;
                           nativeType: GCredentialsType): Gpointer {.
    importc: "g_credentials_get_native", libgio.}
proc native*(credentials: GCredentials;
                           nativeType: GCredentialsType): Gpointer {.
    importc: "g_credentials_get_native", libgio.}
proc setNative*(credentials: GCredentials;
                           nativeType: GCredentialsType; native: Gpointer) {.
    importc: "g_credentials_set_native", libgio.}
proc `native=`*(credentials: GCredentials;
                           nativeType: GCredentialsType; native: Gpointer) {.
    importc: "g_credentials_set_native", libgio.}
proc isSameUser*(credentials: GCredentials;
                            otherCredentials: GCredentials;
                            error: var GError): Gboolean {.
    importc: "g_credentials_is_same_user", libgio.}
when defined(unix):
  proc getUnixPid*(credentials: GCredentials; error: var GError): Pid {.
      importc: "g_credentials_get_unix_pid", libgio.}
  proc unixPid*(credentials: GCredentials; error: var GError): Pid {.
      importc: "g_credentials_get_unix_pid", libgio.}
  proc getUnixUser*(credentials: GCredentials; error: var GError): Uid {.
      importc: "g_credentials_get_unix_user", libgio.}
  proc unixUser*(credentials: GCredentials; error: var GError): Uid {.
      importc: "g_credentials_get_unix_user", libgio.}
  proc setUnixUser*(credentials: GCredentials; uid: Uid;
                               error: var GError): Gboolean {.
      importc: "g_credentials_set_unix_user", libgio.}

template gTypeDatagramBased*(): untyped =
  (datagramBasedGetType())

template gDatagramBased*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeDatagramBased, GDatagramBasedObj))

template gIsDatagramBased*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeDatagramBased))

template gDatagramBasedGetIface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeDatagramBased, GDatagramBasedInterfaceObj))

template gTypeIsDatagramBased*(`type`: untyped): untyped =
  (isA(`type`, gTypeDatagramBased))

type
  GDatagramBasedInterface* =  ptr GDatagramBasedInterfaceObj
  GDatagramBasedInterfacePtr* = ptr GDatagramBasedInterfaceObj
  GDatagramBasedInterfaceObj*{.final.} = object of GTypeInterfaceObj
    receiveMessages*: proc (datagramBased: GDatagramBased;
                          messages: GInputMessage; numMessages: cuint;
                          flags: cint; timeout: int64;
                          cancellable: GCancellable; error: var GError): cint {.cdecl.}
    sendMessages*: proc (datagramBased: GDatagramBased;
                       messages: GOutputMessage; numMessages: cuint; flags: cint;
                       timeout: int64; cancellable: GCancellable;
                       error: var GError): cint {.cdecl.}
    createSource*: proc (datagramBased: GDatagramBased; condition: GIOCondition;
                       cancellable: GCancellable): glib.GSource {.cdecl.}
    conditionCheck*: proc (datagramBased: GDatagramBased; condition: GIOCondition): GIOCondition {.cdecl.}
    conditionWait*: proc (datagramBased: GDatagramBased; condition: GIOCondition;
                        timeout: int64; cancellable: GCancellable;
                        error: var GError): Gboolean {.cdecl.}

proc datagramBasedGetType*(): GType {.importc: "g_datagram_based_get_type",
                                    libgio.}
proc receiveMessages*(datagramBased: GDatagramBased;
                                   messages: GInputMessage; numMessages: cuint;
                                   flags: cint; timeout: int64;
                                   cancellable: GCancellable;
                                   error: var GError): cint {.
    importc: "g_datagram_based_receive_messages", libgio.}
proc sendMessages*(datagramBased: GDatagramBased;
                                messages: GOutputMessage; numMessages: cuint;
                                flags: cint; timeout: int64;
                                cancellable: GCancellable;
                                error: var GError): cint {.
    importc: "g_datagram_based_send_messages", libgio.}
proc createSource*(datagramBased: GDatagramBased;
                                condition: GIOCondition;
                                cancellable: GCancellable): glib.GSource {.
    importc: "g_datagram_based_create_source", libgio.}
proc conditionCheck*(datagramBased: GDatagramBased;
                                  condition: GIOCondition): GIOCondition {.
    importc: "g_datagram_based_condition_check", libgio.}
proc conditionWait*(datagramBased: GDatagramBased;
                                 condition: GIOCondition; timeout: int64;
                                 cancellable: GCancellable;
                                 error: var GError): Gboolean {.
    importc: "g_datagram_based_condition_wait", libgio.}

template gTypeDataInputStream*(): untyped =
  (dataInputStreamGetType())

template gDataInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDataInputStream, GDataInputStreamObj))

template gDataInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeDataInputStream, GDataInputStreamClassObj))

template gIsDataInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDataInputStream))

template gIsDataInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeDataInputStream))

template gDataInputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeDataInputStream, GDataInputStreamClassObj))

type
  GDataInputStream* =  ptr GDataInputStreamObj
  GDataInputStreamPtr* = ptr GDataInputStreamObj
  GDataInputStreamObj*{.final.} = object of GBufferedInputStreamObj
    priv16: pointer

  GDataInputStreamClass* =  ptr GDataInputStreamClassObj
  GDataInputStreamClassPtr* = ptr GDataInputStreamClassObj
  GDataInputStreamClassObj*{.final.} = object of GBufferedInputStreamClassObj
    gReserved131*: proc () {.cdecl.}
    gReserved132*: proc () {.cdecl.}
    gReserved133*: proc () {.cdecl.}
    gReserved134*: proc () {.cdecl.}
    gReserved135*: proc () {.cdecl.}

proc dataInputStreamGetType*(): GType {.importc: "g_data_input_stream_get_type",
                                      libgio.}
proc newDataInputStream*(baseStream: GInputStream): GDataInputStream {.
    importc: "g_data_input_stream_new", libgio.}
proc setByteOrder*(stream: GDataInputStream;
                                  order: GDataStreamByteOrder) {.
    importc: "g_data_input_stream_set_byte_order", libgio.}
proc `byteOrder=`*(stream: GDataInputStream;
                                  order: GDataStreamByteOrder) {.
    importc: "g_data_input_stream_set_byte_order", libgio.}
proc getByteOrder*(stream: GDataInputStream): GDataStreamByteOrder {.
    importc: "g_data_input_stream_get_byte_order", libgio.}
proc byteOrder*(stream: GDataInputStream): GDataStreamByteOrder {.
    importc: "g_data_input_stream_get_byte_order", libgio.}
proc setNewlineType*(stream: GDataInputStream;
                                    `type`: GDataStreamNewlineType) {.
    importc: "g_data_input_stream_set_newline_type", libgio.}
proc `newlineType=`*(stream: GDataInputStream;
                                    `type`: GDataStreamNewlineType) {.
    importc: "g_data_input_stream_set_newline_type", libgio.}
proc getNewlineType*(stream: GDataInputStream): GDataStreamNewlineType {.
    importc: "g_data_input_stream_get_newline_type", libgio.}
proc newlineType*(stream: GDataInputStream): GDataStreamNewlineType {.
    importc: "g_data_input_stream_get_newline_type", libgio.}
proc readByte*(stream: GDataInputStream;
                              cancellable: GCancellable; error: var GError): cuchar {.
    importc: "g_data_input_stream_read_byte", libgio.}
proc readInt16*(stream: GDataInputStream;
                               cancellable: GCancellable; error: var GError): int16 {.
    importc: "g_data_input_stream_read_int16", libgio.}
proc readUint16*(stream: GDataInputStream;
                                cancellable: GCancellable;
                                error: var GError): uint16 {.
    importc: "g_data_input_stream_read_uint16", libgio.}
proc readInt32*(stream: GDataInputStream;
                               cancellable: GCancellable; error: var GError): int32 {.
    importc: "g_data_input_stream_read_int32", libgio.}
proc readUint32*(stream: GDataInputStream;
                                cancellable: GCancellable;
                                error: var GError): uint32 {.
    importc: "g_data_input_stream_read_uint32", libgio.}
proc readInt64*(stream: GDataInputStream;
                               cancellable: GCancellable; error: var GError): int64 {.
    importc: "g_data_input_stream_read_int64", libgio.}
proc readUint64*(stream: GDataInputStream;
                                cancellable: GCancellable;
                                error: var GError): uint64 {.
    importc: "g_data_input_stream_read_uint64", libgio.}
proc readLine*(stream: GDataInputStream; length: var Gsize;
                              cancellable: GCancellable; error: var GError): cstring {.
    importc: "g_data_input_stream_read_line", libgio.}
proc readLineUtf8*(stream: GDataInputStream; length: var Gsize;
                                  cancellable: GCancellable;
                                  error: var GError): cstring {.
    importc: "g_data_input_stream_read_line_utf8", libgio.}
proc readLineAsync*(stream: GDataInputStream; ioPriority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_data_input_stream_read_line_async", libgio.}
proc readLineFinish*(stream: GDataInputStream;
                                    result: GAsyncResult; length: var Gsize;
                                    error: var GError): cstring {.
    importc: "g_data_input_stream_read_line_finish", libgio.}
proc readLineFinishUtf8*(stream: GDataInputStream;
                                        result: GAsyncResult;
                                        length: var Gsize; error: var GError): cstring {.
    importc: "g_data_input_stream_read_line_finish_utf8", libgio.}
proc readUntil*(stream: GDataInputStream; stopChars: cstring;
                               length: var Gsize; cancellable: GCancellable;
                               error: var GError): cstring {.
    importc: "g_data_input_stream_read_until", libgio.}
proc readUntilAsync*(stream: GDataInputStream;
                                    stopChars: cstring; ioPriority: cint;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    userData: Gpointer) {.
    importc: "g_data_input_stream_read_until_async", libgio.}
proc readUntilFinish*(stream: GDataInputStream;
                                     result: GAsyncResult; length: var Gsize;
                                     error: var GError): cstring {.
    importc: "g_data_input_stream_read_until_finish", libgio.}
proc readUpto*(stream: GDataInputStream; stopChars: cstring;
                              stopCharsLen: Gssize; length: var Gsize;
                              cancellable: GCancellable; error: var GError): cstring {.
    importc: "g_data_input_stream_read_upto", libgio.}
proc readUptoAsync*(stream: GDataInputStream;
                                   stopChars: cstring; stopCharsLen: Gssize;
                                   ioPriority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_data_input_stream_read_upto_async", libgio.}
proc readUptoFinish*(stream: GDataInputStream;
                                    result: GAsyncResult; length: var Gsize;
                                    error: var GError): cstring {.
    importc: "g_data_input_stream_read_upto_finish", libgio.}

template gTypeDataOutputStream*(): untyped =
  (dataOutputStreamGetType())

template gDataOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDataOutputStream, GDataOutputStreamObj))

template gDataOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeDataOutputStream, GDataOutputStreamClassObj))

template gIsDataOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDataOutputStream))

template gIsDataOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeDataOutputStream))

template gDataOutputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeDataOutputStream, GDataOutputStreamClassObj))

type
  GDataOutputStream* =  ptr GDataOutputStreamObj
  GDataOutputStreamPtr* = ptr GDataOutputStreamObj
  GDataOutputStreamObj*{.final.} = object of GFilterOutputStreamObj
    priv17: pointer

  GDataOutputStreamClass* =  ptr GDataOutputStreamClassObj
  GDataOutputStreamClassPtr* = ptr GDataOutputStreamClassObj
  GDataOutputStreamClassObj*{.final.} = object of GFilterOutputStreamClassObj
    gReserved141*: proc () {.cdecl.}
    gReserved142*: proc () {.cdecl.}
    gReserved143*: proc () {.cdecl.}
    gReserved144*: proc () {.cdecl.}
    gReserved145*: proc () {.cdecl.}

proc dataOutputStreamGetType*(): GType {.importc: "g_data_output_stream_get_type",
                                       libgio.}
proc newDataOutputStream*(baseStream: GOutputStream): GDataOutputStream {.
    importc: "g_data_output_stream_new", libgio.}
proc setByteOrder*(stream: GDataOutputStream;
                                   order: GDataStreamByteOrder) {.
    importc: "g_data_output_stream_set_byte_order", libgio.}
proc `byteOrder=`*(stream: GDataOutputStream;
                                   order: GDataStreamByteOrder) {.
    importc: "g_data_output_stream_set_byte_order", libgio.}
proc getByteOrder*(stream: GDataOutputStream): GDataStreamByteOrder {.
    importc: "g_data_output_stream_get_byte_order", libgio.}
proc byteOrder*(stream: GDataOutputStream): GDataStreamByteOrder {.
    importc: "g_data_output_stream_get_byte_order", libgio.}
proc putByte*(stream: GDataOutputStream; data: cuchar;
                              cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_data_output_stream_put_byte", libgio.}
proc putInt16*(stream: GDataOutputStream; data: int16;
                               cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_data_output_stream_put_int16", libgio.}
proc putUint16*(stream: GDataOutputStream; data: uint16;
                                cancellable: GCancellable;
                                error: var GError): Gboolean {.
    importc: "g_data_output_stream_put_uint16", libgio.}
proc putInt32*(stream: GDataOutputStream; data: int32;
                               cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_data_output_stream_put_int32", libgio.}
proc putUint32*(stream: GDataOutputStream; data: uint32;
                                cancellable: GCancellable;
                                error: var GError): Gboolean {.
    importc: "g_data_output_stream_put_uint32", libgio.}
proc putInt64*(stream: GDataOutputStream; data: int64;
                               cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_data_output_stream_put_int64", libgio.}
proc putUint64*(stream: GDataOutputStream; data: uint64;
                                cancellable: GCancellable;
                                error: var GError): Gboolean {.
    importc: "g_data_output_stream_put_uint64", libgio.}
proc putString*(stream: GDataOutputStream; str: cstring;
                                cancellable: GCancellable;
                                error: var GError): Gboolean {.
    importc: "g_data_output_stream_put_string", libgio.}

type
  GIOStream* =  ptr GIOStreamObj
  GIOStreamPtr* = ptr GIOStreamObj
  GIOStreamObj* = object of GObjectObj
    priv18: pointer

  GIOStreamClass* =  ptr GIOStreamClassObj
  GIOStreamClassPtr* = ptr GIOStreamClassObj
  GIOStreamClassObj* = object of GObjectClassObj
    getInputStream*: proc (stream: GIOStream): GInputStream {.cdecl.}
    getOutputStream*: proc (stream: GIOStream): GOutputStream {.cdecl.}
    closeFn*: proc (stream: GIOStream; cancellable: GCancellable;
                  error: var GError): Gboolean {.cdecl.}
    closeAsync*: proc (stream: GIOStream; ioPriority: cint;
                     cancellable: GCancellable; callback: GAsyncReadyCallback;
                     userData: Gpointer) {.cdecl.}
    closeFinish*: proc (stream: GIOStream; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    gReserved151*: proc () {.cdecl.}
    gReserved152*: proc () {.cdecl.}
    gReserved153*: proc () {.cdecl.}
    gReserved154*: proc () {.cdecl.}
    gReserved155*: proc () {.cdecl.}
    gReserved156*: proc () {.cdecl.}
    gReserved157*: proc () {.cdecl.}
    gReserved158*: proc () {.cdecl.}
    gReserved159*: proc () {.cdecl.}
    gReserved10*: proc () {.cdecl.}
proc dbusAddressEscapeValue*(string: cstring): cstring {.
    importc: "g_dbus_address_escape_value", libgio.}
proc dbusIsAddress*(string: cstring): Gboolean {.importc: "g_dbus_is_address",
    libgio.}
proc dbusIsSupportedAddress*(string: cstring; error: var GError): Gboolean {.
    importc: "g_dbus_is_supported_address", libgio.}
proc dbusAddressGetStream*(address: cstring; cancellable: GCancellable;
                           callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_address_get_stream", libgio.}
proc dbusAddressGetStreamFinish*(res: GAsyncResult; outGuid: cstringArray;
                                 error: var GError): GIOStream {.
    importc: "g_dbus_address_get_stream_finish", libgio.}
proc dbusAddressGetStreamSync*(address: cstring; outGuid: cstringArray;
                               cancellable: GCancellable; error: var GError): GIOStream {.
    importc: "g_dbus_address_get_stream_sync", libgio.}
proc dbusAddressGetForBusSync*(busType: GBusType; cancellable: GCancellable;
                               error: var GError): cstring {.
    importc: "g_dbus_address_get_for_bus_sync", libgio.}

template gTypeDbusAuthObserver*(): untyped =
  (dbusAuthObserverGetType())

template gDbusAuthObserver*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusAuthObserver, GDBusAuthObserverObj))

template gIsDbusAuthObserver*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusAuthObserver))

proc dbusAuthObserverGetType*(): GType {.importc: "g_dbus_auth_observer_get_type",
                                       libgio.}
proc newDbusAuthObserver*(): GDBusAuthObserver {.
    importc: "g_dbus_auth_observer_new", libgio.}
proc dbusAuthObserverAuthorizeAuthenticatedPeer*(
    observer: GDBusAuthObserver; stream: GIOStream;
    credentials: GCredentials): Gboolean {.
    importc: "g_dbus_auth_observer_authorize_authenticated_peer", libgio.}
proc dbusAuthObserverAllowMechanism*(observer: GDBusAuthObserver;
                                     mechanism: cstring): Gboolean {.
    importc: "g_dbus_auth_observer_allow_mechanism", libgio.}

template gTypeDbusConnection*(): untyped =
  (dbusConnectionGetType())

template gDbusConnection*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusConnection, GDBusConnectionObj))

template gIsDbusConnection*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusConnection))

proc dbusConnectionGetType*(): GType {.importc: "g_dbus_connection_get_type",
                                     libgio.}

proc busGet*(busType: GBusType; cancellable: GCancellable;
             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_bus_get", libgio.}
proc busGetFinish*(res: GAsyncResult; error: var GError): GDBusConnection {.
    importc: "g_bus_get_finish", libgio.}
proc busGetSync*(busType: GBusType; cancellable: GCancellable;
                 error: var GError): GDBusConnection {.
    importc: "g_bus_get_sync", libgio.}

proc dbusConnectionNew*(stream: GIOStream; guid: cstring;
                        flags: GDBusConnectionFlags;
                        observer: GDBusAuthObserver;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_connection_new", libgio.}
proc dbusConnectionNewFinish*(res: GAsyncResult; error: var GError): GDBusConnection {.
    importc: "g_dbus_connection_new_finish", libgio.}
proc dbusConnectionNewSync*(stream: GIOStream; guid: cstring;
                            flags: GDBusConnectionFlags;
                            observer: GDBusAuthObserver;
                            cancellable: GCancellable; error: var GError): GDBusConnection {.
    importc: "g_dbus_connection_new_sync", libgio.}
proc dbusConnectionNewForAddress*(address: cstring; flags: GDBusConnectionFlags;
                                  observer: GDBusAuthObserver;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_dbus_connection_new_for_address", libgio.}
proc dbusConnectionNewForAddressFinish*(res: GAsyncResult;
                                        error: var GError): GDBusConnection {.
    importc: "g_dbus_connection_new_for_address_finish", libgio.}
proc dbusConnectionNewForAddressSync*(address: cstring;
                                      flags: GDBusConnectionFlags;
                                      observer: GDBusAuthObserver;
                                      cancellable: GCancellable;
                                      error: var GError): GDBusConnection {.
    importc: "g_dbus_connection_new_for_address_sync", libgio.}

proc dbusConnectionStartMessageProcessing*(connection: GDBusConnection) {.
    importc: "g_dbus_connection_start_message_processing", libgio.}
proc dbusConnectionIsClosed*(connection: GDBusConnection): Gboolean {.
    importc: "g_dbus_connection_is_closed", libgio.}
proc dbusConnectionGetStream*(connection: GDBusConnection): GIOStream {.
    importc: "g_dbus_connection_get_stream", libgio.}
proc dbusConnectionGetGuid*(connection: GDBusConnection): cstring {.
    importc: "g_dbus_connection_get_guid", libgio.}
proc dbusConnectionGetUniqueName*(connection: GDBusConnection): cstring {.
    importc: "g_dbus_connection_get_unique_name", libgio.}
proc dbusConnectionGetPeerCredentials*(connection: GDBusConnection): GCredentials {.
    importc: "g_dbus_connection_get_peer_credentials", libgio.}
proc dbusConnectionGetLastSerial*(connection: GDBusConnection): uint32 {.
    importc: "g_dbus_connection_get_last_serial", libgio.}
proc dbusConnectionGetExitOnClose*(connection: GDBusConnection): Gboolean {.
    importc: "g_dbus_connection_get_exit_on_close", libgio.}
proc dbusConnectionSetExitOnClose*(connection: GDBusConnection;
                                   exitOnClose: Gboolean) {.
    importc: "g_dbus_connection_set_exit_on_close", libgio.}
proc dbusConnectionGetCapabilities*(connection: GDBusConnection): GDBusCapabilityFlags {.
    importc: "g_dbus_connection_get_capabilities", libgio.}

proc dbusConnectionClose*(connection: GDBusConnection;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_connection_close", libgio.}
proc dbusConnectionCloseFinish*(connection: GDBusConnection;
                                res: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_dbus_connection_close_finish", libgio.}
proc dbusConnectionCloseSync*(connection: GDBusConnection;
                              cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_dbus_connection_close_sync", libgio.}

proc dbusConnectionFlush*(connection: GDBusConnection;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_connection_flush", libgio.}
proc dbusConnectionFlushFinish*(connection: GDBusConnection;
                                res: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_dbus_connection_flush_finish", libgio.}
proc dbusConnectionFlushSync*(connection: GDBusConnection;
                              cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_dbus_connection_flush_sync", libgio.}

proc dbusConnectionSendMessage*(connection: GDBusConnection;
                                message: GDBusMessage;
                                flags: GDBusSendMessageFlags;
                                outSerial: var uint32; error: var GError): Gboolean {.
    importc: "g_dbus_connection_send_message", libgio.}
proc dbusConnectionSendMessageWithReply*(connection: GDBusConnection;
    message: GDBusMessage; flags: GDBusSendMessageFlags; timeoutMsec: cint;
    outSerial: var uint32; cancellable: GCancellable;
    callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_connection_send_message_with_reply", libgio.}
proc dbusConnectionSendMessageWithReplyFinish*(connection: GDBusConnection;
    res: GAsyncResult; error: var GError): GDBusMessage {.
    importc: "g_dbus_connection_send_message_with_reply_finish", libgio.}
proc dbusConnectionSendMessageWithReplySync*(connection: GDBusConnection;
    message: GDBusMessage; flags: GDBusSendMessageFlags; timeoutMsec: cint;
    outSerial: var uint32; cancellable: GCancellable; error: var GError): GDBusMessage {.
    importc: "g_dbus_connection_send_message_with_reply_sync", libgio.}

proc dbusConnectionEmitSignal*(connection: GDBusConnection;
                               destinationBusName: cstring; objectPath: cstring;
                               interfaceName: cstring; signalName: cstring;
                               parameters: GVariant; error: var GError): Gboolean {.
    importc: "g_dbus_connection_emit_signal", libgio.}
proc dbusConnectionCall*(connection: GDBusConnection; busName: cstring;
                         objectPath: cstring; interfaceName: cstring;
                         methodName: cstring; parameters: GVariant;
                         replyType: GVariantType; flags: GDBusCallFlags;
                         timeoutMsec: cint; cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_connection_call", libgio.}
proc dbusConnectionCallFinish*(connection: GDBusConnection;
                               res: GAsyncResult; error: var GError): GVariant {.
    importc: "g_dbus_connection_call_finish", libgio.}
proc dbusConnectionCallSync*(connection: GDBusConnection; busName: cstring;
                             objectPath: cstring; interfaceName: cstring;
                             methodName: cstring; parameters: GVariant;
                             replyType: GVariantType; flags: GDBusCallFlags;
                             timeoutMsec: cint; cancellable: GCancellable;
                             error: var GError): GVariant {.
    importc: "g_dbus_connection_call_sync", libgio.}
proc dbusConnectionCallWithUnixFdList*(connection: GDBusConnection;
                                       busName: cstring; objectPath: cstring;
                                       interfaceName: cstring;
                                       methodName: cstring;
                                       parameters: GVariant;
                                       replyType: GVariantType;
                                       flags: GDBusCallFlags; timeoutMsec: cint;
                                       fdList: GUnixFDList;
                                       cancellable: GCancellable;
                                       callback: GAsyncReadyCallback;
                                       userData: Gpointer) {.
    importc: "g_dbus_connection_call_with_unix_fd_list", libgio.}
proc dbusConnectionCallWithUnixFdListFinish*(connection: GDBusConnection;
    outFdList: var GUnixFDList; res: GAsyncResult; error: var GError): GVariant {.
    importc: "g_dbus_connection_call_with_unix_fd_list_finish", libgio.}
proc dbusConnectionCallWithUnixFdListSync*(connection: GDBusConnection;
    busName: cstring; objectPath: cstring; interfaceName: cstring;
    methodName: cstring; parameters: GVariant; replyType: GVariantType;
    flags: GDBusCallFlags; timeoutMsec: cint; fdList: GUnixFDList;
    outFdList: var GUnixFDList; cancellable: GCancellable;
    error: var GError): GVariant {.importc: "g_dbus_connection_call_with_unix_fd_list_sync",
                                     libgio.}

type
  GDBusInterfaceMethodCallFunc* = proc (connection: GDBusConnection;
                                     sender: cstring; objectPath: cstring;
                                     interfaceName: cstring; methodName: cstring;
                                     parameters: GVariant;
                                     invocation: GDBusMethodInvocation;
                                     userData: Gpointer) {.cdecl.}

type
  GDBusInterfaceGetPropertyFunc* = proc (connection: GDBusConnection;
                                      sender: cstring; objectPath: cstring;
                                      interfaceName: cstring;
                                      propertyName: cstring;
                                      error: var GError; userData: Gpointer): GVariant {.cdecl.}

type
  GDBusInterfaceSetPropertyFunc* = proc (connection: GDBusConnection;
                                      sender: cstring; objectPath: cstring;
                                      interfaceName: cstring;
                                      propertyName: cstring; value: GVariant;
                                      error: var GError; userData: Gpointer): Gboolean {.cdecl.}

type
  GDBusInterfaceVTable* =  ptr GDBusInterfaceVTableObj
  GDBusInterfaceVTablePtr* = ptr GDBusInterfaceVTableObj
  GDBusInterfaceVTableObj* = object
    methodCall*: GDBusInterfaceMethodCallFunc
    getProperty*: GDBusInterfaceGetPropertyFunc
    setProperty*: GDBusInterfaceSetPropertyFunc
    padding*: array[8, Gpointer]

type
  GDBusAnnotationInfo* =  ptr GDBusAnnotationInfoObj
  GDBusAnnotationInfoPtr* = ptr GDBusAnnotationInfoObj
  GDBusAnnotationInfoObj* = object
    refCount*: cint
    key*: cstring
    value*: cstring
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusArgInfo* =  ptr GDBusArgInfoObj
  GDBusArgInfoPtr* = ptr GDBusArgInfoObj
  GDBusArgInfoObj* = object
    refCount*: cint
    name*: cstring
    signature*: cstring
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusMethodInfo* =  ptr GDBusMethodInfoObj
  GDBusMethodInfoPtr* = ptr GDBusMethodInfoObj
  GDBusMethodInfoObj* = object
    refCount*: cint
    name*: cstring
    inArgs*: ptr GDBusArgInfo
    outArgs*: ptr GDBusArgInfo
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusSignalInfo* =  ptr GDBusSignalInfoObj
  GDBusSignalInfoPtr* = ptr GDBusSignalInfoObj
  GDBusSignalInfoObj* = object
    refCount*: cint
    name*: cstring
    args*: ptr GDBusArgInfo
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusPropertyInfo* =  ptr GDBusPropertyInfoObj
  GDBusPropertyInfoPtr* = ptr GDBusPropertyInfoObj
  GDBusPropertyInfoObj* = object
    refCount*: cint
    name*: cstring
    signature*: cstring
    flags*: GDBusPropertyInfoFlags
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusInterfaceInfo* =  ptr GDBusInterfaceInfoObj
  GDBusInterfaceInfoPtr* = ptr GDBusInterfaceInfoObj
  GDBusInterfaceInfoObj* = object
    refCount*: cint
    name*: cstring
    methods*: ptr GDBusMethodInfo
    signals*: ptr GDBusSignalInfo
    properties*: ptr GDBusPropertyInfo
    annotations*: ptr GDBusAnnotationInfo

type
  GDBusNodeInfo* =  ptr GDBusNodeInfoObj
  GDBusNodeInfoPtr* = ptr GDBusNodeInfoObj
  GDBusNodeInfoObj* = object
    refCount*: cint
    path*: cstring
    interfaces*: ptr GDBusInterfaceInfo
    nodes*: ptr GDBusNodeInfo
    annotations*: ptr GDBusAnnotationInfo

proc dbusConnectionRegisterObject*(connection: GDBusConnection;
                                   objectPath: cstring;
                                   interfaceInfo: GDBusInterfaceInfo;
                                   vtable: GDBusInterfaceVTable;
                                   userData: Gpointer;
                                   userDataFreeFunc: GDestroyNotify;
                                   error: var GError): cuint {.
    importc: "g_dbus_connection_register_object", libgio.}
proc dbusConnectionRegisterObjectWithClosures*(connection: GDBusConnection;
    objectPath: cstring; interfaceInfo: GDBusInterfaceInfo;
    methodCallClosure: GClosure; getPropertyClosure: GClosure;
    setPropertyClosure: GClosure; error: var GError): cuint {.
    importc: "g_dbus_connection_register_object_with_closures", libgio.}
proc dbusConnectionUnregisterObject*(connection: GDBusConnection;
                                     registrationId: cuint): Gboolean {.
    importc: "g_dbus_connection_unregister_object", libgio.}

type
  GDBusSubtreeEnumerateFunc* = proc (connection: GDBusConnection; sender: cstring;
                                  objectPath: cstring; userData: Gpointer): cstringArray {.cdecl.}

type
  GDBusSubtreeIntrospectFunc* = proc (connection: GDBusConnection;
                                   sender: cstring; objectPath: cstring;
                                   node: cstring; userData: Gpointer): ptr GDBusInterfaceInfo {.cdecl.}

type
  GDBusSubtreeDispatchFunc* = proc (connection: GDBusConnection; sender: cstring;
                                 objectPath: cstring; interfaceName: cstring;
                                 node: cstring; outUserData: var Gpointer;
                                 userData: Gpointer): GDBusInterfaceVTable {.cdecl.}

type
  GDBusSubtreeVTable* =  ptr GDBusSubtreeVTableObj
  GDBusSubtreeVTablePtr* = ptr GDBusSubtreeVTableObj
  GDBusSubtreeVTableObj* = object
    enumerate*: GDBusSubtreeEnumerateFunc
    introspect*: GDBusSubtreeIntrospectFunc
    dispatch*: GDBusSubtreeDispatchFunc
    padding*: array[8, Gpointer]

proc dbusConnectionRegisterSubtree*(connection: GDBusConnection;
                                    objectPath: cstring;
                                    vtable: GDBusSubtreeVTable;
                                    flags: GDBusSubtreeFlags; userData: Gpointer;
                                    userDataFreeFunc: GDestroyNotify;
                                    error: var GError): cuint {.
    importc: "g_dbus_connection_register_subtree", libgio.}
proc dbusConnectionUnregisterSubtree*(connection: GDBusConnection;
                                      registrationId: cuint): Gboolean {.
    importc: "g_dbus_connection_unregister_subtree", libgio.}

type
  GDBusSignalCallback* = proc (connection: GDBusConnection; senderName: cstring;
                            objectPath: cstring; interfaceName: cstring;
                            signalName: cstring; parameters: GVariant;
                            userData: Gpointer) {.cdecl.}

proc dbusConnectionSignalSubscribe*(connection: GDBusConnection;
                                    sender: cstring; interfaceName: cstring;
                                    member: cstring; objectPath: cstring;
                                    arg0: cstring; flags: GDBusSignalFlags;
                                    callback: GDBusSignalCallback;
                                    userData: Gpointer;
                                    userDataFreeFunc: GDestroyNotify): cuint {.
    importc: "g_dbus_connection_signal_subscribe", libgio.}
proc dbusConnectionSignalUnsubscribe*(connection: GDBusConnection;
                                      subscriptionId: cuint) {.
    importc: "g_dbus_connection_signal_unsubscribe", libgio.}

type
  GDBusMessageFilterFunction* = proc (connection: GDBusConnection;
                                   message: GDBusMessage; incoming: Gboolean;
                                   userData: Gpointer): GDBusMessage {.cdecl.}

proc dbusConnectionAddFilter*(connection: GDBusConnection;
                              filterFunction: GDBusMessageFilterFunction;
                              userData: Gpointer; userDataFreeFunc: GDestroyNotify): cuint {.
    importc: "g_dbus_connection_add_filter", libgio.}
proc dbusConnectionRemoveFilter*(connection: GDBusConnection; filterId: cuint) {.
    importc: "g_dbus_connection_remove_filter", libgio.}

template gDbusError*(): untyped =
  gDbusErrorQuark()

proc dbusErrorQuark*(): GQuark {.importc: "g_dbus_error_quark", libgio.}

proc dbusErrorIsRemoteError*(error: GError): Gboolean {.
    importc: "g_dbus_error_is_remote_error", libgio.}
proc dbusErrorGetRemoteError*(error: GError): cstring {.
    importc: "g_dbus_error_get_remote_error", libgio.}
proc dbusErrorStripRemoteError*(error: GError): Gboolean {.
    importc: "g_dbus_error_strip_remote_error", libgio.}

type
  GDBusErrorEntry* =  ptr GDBusErrorEntryObj
  GDBusErrorEntryPtr* = ptr GDBusErrorEntryObj
  GDBusErrorEntryObj* = object
    errorCode*: cint
    dbusErrorName*: cstring

proc dbusErrorRegisterError*(errorDomain: GQuark; errorCode: cint;
                             dbusErrorName: cstring): Gboolean {.
    importc: "g_dbus_error_register_error", libgio.}
proc dbusErrorUnregisterError*(errorDomain: GQuark; errorCode: cint;
                               dbusErrorName: cstring): Gboolean {.
    importc: "g_dbus_error_unregister_error", libgio.}
proc dbusErrorRegisterErrorDomain*(errorDomainQuarkName: cstring;
                                   quarkVolatile: var Gsize;
                                   entries: GDBusErrorEntry; numEntries: cuint) {.
    importc: "g_dbus_error_register_error_domain", libgio.}

proc newDbusError*(dbusErrorName: cstring; dbusErrorMessage: cstring): GError {.
    importc: "g_dbus_error_new_for_dbus_error", libgio.}
proc dbusErrorSetDbusError*(error: var GError; dbusErrorName: cstring;
                            dbusErrorMessage: cstring; format: cstring) {.varargs,
    importc: "g_dbus_error_set_dbus_error", libgio.}
discard """
proc dbusErrorSetDbusErrorValist*(error: var GError; dbusErrorName: cstring;
                                  dbusErrorMessage: cstring; format: cstring;
                                  varArgs: VaList) {.
    importc: "g_dbus_error_set_dbus_error_valist", libgio.}
"""
proc dbusErrorEncodeGerror*(error: GError): cstring {.
    importc: "g_dbus_error_encode_gerror", libgio.}

proc dbusAnnotationInfoLookup*(annotations: var GDBusAnnotationInfo;
                               name: cstring): cstring {.
    importc: "g_dbus_annotation_info_lookup", libgio.}
proc dbusInterfaceInfoLookupMethod*(info: GDBusInterfaceInfo; name: cstring): GDBusMethodInfo {.
    importc: "g_dbus_interface_info_lookup_method", libgio.}
proc dbusInterfaceInfoLookupSignal*(info: GDBusInterfaceInfo; name: cstring): GDBusSignalInfo {.
    importc: "g_dbus_interface_info_lookup_signal", libgio.}
proc dbusInterfaceInfoLookupProperty*(info: GDBusInterfaceInfo; name: cstring): GDBusPropertyInfo {.
    importc: "g_dbus_interface_info_lookup_property", libgio.}
proc dbusInterfaceInfoCacheBuild*(info: GDBusInterfaceInfo) {.
    importc: "g_dbus_interface_info_cache_build", libgio.}
proc dbusInterfaceInfoCacheRelease*(info: GDBusInterfaceInfo) {.
    importc: "g_dbus_interface_info_cache_release", libgio.}
proc dbusInterfaceInfoGenerateXml*(info: GDBusInterfaceInfo; indent: cuint;
                                   stringBuilder: glib.GString) {.
    importc: "g_dbus_interface_info_generate_xml", libgio.}
proc newDbusNodeInfo*(xmlData: cstring; error: var GError): GDBusNodeInfo {.
    importc: "g_dbus_node_info_new_for_xml", libgio.}
proc dbusNodeInfoLookupInterface*(info: GDBusNodeInfo; name: cstring): GDBusInterfaceInfo {.
    importc: "g_dbus_node_info_lookup_interface", libgio.}
proc dbusNodeInfoGenerateXml*(info: GDBusNodeInfo; indent: cuint;
                              stringBuilder: glib.GString) {.
    importc: "g_dbus_node_info_generate_xml", libgio.}
proc dbusNodeInfoRef*(info: GDBusNodeInfo): GDBusNodeInfo {.
    importc: "g_dbus_node_info_ref", libgio.}
proc dbusInterfaceInfoRef*(info: GDBusInterfaceInfo): GDBusInterfaceInfo {.
    importc: "g_dbus_interface_info_ref", libgio.}
proc dbusMethodInfoRef*(info: GDBusMethodInfo): GDBusMethodInfo {.
    importc: "g_dbus_method_info_ref", libgio.}
proc dbusSignalInfoRef*(info: GDBusSignalInfo): GDBusSignalInfo {.
    importc: "g_dbus_signal_info_ref", libgio.}
proc dbusPropertyInfoRef*(info: GDBusPropertyInfo): GDBusPropertyInfo {.
    importc: "g_dbus_property_info_ref", libgio.}
proc dbusArgInfoRef*(info: GDBusArgInfo): GDBusArgInfo {.
    importc: "g_dbus_arg_info_ref", libgio.}
proc dbusAnnotationInfoRef*(info: GDBusAnnotationInfo): GDBusAnnotationInfo {.
    importc: "g_dbus_annotation_info_ref", libgio.}
proc dbusNodeInfoUnref*(info: GDBusNodeInfo) {.
    importc: "g_dbus_node_info_unref", libgio.}
proc dbusInterfaceInfoUnref*(info: GDBusInterfaceInfo) {.
    importc: "g_dbus_interface_info_unref", libgio.}
proc dbusMethodInfoUnref*(info: GDBusMethodInfo) {.
    importc: "g_dbus_method_info_unref", libgio.}
proc dbusSignalInfoUnref*(info: GDBusSignalInfo) {.
    importc: "g_dbus_signal_info_unref", libgio.}
proc dbusPropertyInfoUnref*(info: GDBusPropertyInfo) {.
    importc: "g_dbus_property_info_unref", libgio.}
proc dbusArgInfoUnref*(info: GDBusArgInfo) {.importc: "g_dbus_arg_info_unref",
    libgio.}
proc dbusAnnotationInfoUnref*(info: GDBusAnnotationInfo) {.
    importc: "g_dbus_annotation_info_unref", libgio.}

template gTypeDbusNodeInfo*(): untyped =
  (dbusNodeInfoGetType())

template gTypeDbusInterfaceInfo*(): untyped =
  (dbusInterfaceInfoGetType())

template gTypeDbusMethodInfo*(): untyped =
  (dbusMethodInfoGetType())

template gTypeDbusSignalInfo*(): untyped =
  (dbusSignalInfoGetType())

template gTypeDbusPropertyInfo*(): untyped =
  (dbusPropertyInfoGetType())

template gTypeDbusArgInfo*(): untyped =
  (dbusArgInfoGetType())

template gTypeDbusAnnotationInfo*(): untyped =
  (dbusAnnotationInfoGetType())

proc dbusNodeInfoGetType*(): GType {.importc: "g_dbus_node_info_get_type",
                                   libgio.}
proc dbusInterfaceInfoGetType*(): GType {.importc: "g_dbus_interface_info_get_type",
                                        libgio.}
proc dbusMethodInfoGetType*(): GType {.importc: "g_dbus_method_info_get_type",
                                     libgio.}
proc dbusSignalInfoGetType*(): GType {.importc: "g_dbus_signal_info_get_type",
                                     libgio.}
proc dbusPropertyInfoGetType*(): GType {.importc: "g_dbus_property_info_get_type",
                                       libgio.}
proc dbusArgInfoGetType*(): GType {.importc: "g_dbus_arg_info_get_type", libgio.}
proc dbusAnnotationInfoGetType*(): GType {.
    importc: "g_dbus_annotation_info_get_type", libgio.}

template gTypeDbusMessage*(): untyped =
  (dbusMessageGetType())

template gDbusMessage*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusMessage, GDBusMessageObj))

template gIsDbusMessage*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusMessage))

proc dbusMessageGetType*(): GType {.importc: "g_dbus_message_get_type", libgio.}
proc newDbusMessage*(): GDBusMessage {.importc: "g_dbus_message_new", libgio.}
proc newDbusMessage*(path: cstring; `interface`: cstring; signal: cstring): GDBusMessage {.
    importc: "g_dbus_message_new_signal", libgio.}
proc newDbusMessage*(name: cstring; path: cstring; `interface`: cstring;
                               `method`: cstring): GDBusMessage {.
    importc: "g_dbus_message_new_method_call", libgio.}
proc newDbusMessage*(methodCallMessage: GDBusMessage): GDBusMessage {.
    importc: "g_dbus_message_new_method_reply", libgio.}
proc newDbusMessage*(methodCallMessage: GDBusMessage;
                                errorName: cstring; errorMessageFormat: cstring): GDBusMessage {.
    varargs, importc: "g_dbus_message_new_method_error", libgio.}
discard """
proc newDbusMessage*(methodCallMessage: GDBusMessage;
                                      errorName: cstring;
                                      errorMessageFormat: cstring; varArgs: VaList): GDBusMessage {.
    importc: "g_dbus_message_new_method_error_valist", libgio.}
"""
proc newDbusMessage*(methodCallMessage: GDBusMessage;
                                       errorName: cstring; errorMessage: cstring): GDBusMessage {.
    importc: "g_dbus_message_new_method_error_literal", libgio.}
proc dbusMessagePrint*(message: GDBusMessage; indent: cuint): cstring {.
    importc: "g_dbus_message_print", libgio.}
proc dbusMessageGetLocked*(message: GDBusMessage): Gboolean {.
    importc: "g_dbus_message_get_locked", libgio.}
proc dbusMessageLock*(message: GDBusMessage) {.importc: "g_dbus_message_lock",
    libgio.}
proc dbusMessageCopy*(message: GDBusMessage; error: var GError): GDBusMessage {.
    importc: "g_dbus_message_copy", libgio.}
proc dbusMessageGetByteOrder*(message: GDBusMessage): GDBusMessageByteOrder {.
    importc: "g_dbus_message_get_byte_order", libgio.}
proc dbusMessageSetByteOrder*(message: GDBusMessage;
                              byteOrder: GDBusMessageByteOrder) {.
    importc: "g_dbus_message_set_byte_order", libgio.}
proc dbusMessageGetMessageType*(message: GDBusMessage): GDBusMessageType {.
    importc: "g_dbus_message_get_message_type", libgio.}
proc dbusMessageSetMessageType*(message: GDBusMessage; `type`: GDBusMessageType) {.
    importc: "g_dbus_message_set_message_type", libgio.}
proc dbusMessageGetFlags*(message: GDBusMessage): GDBusMessageFlags {.
    importc: "g_dbus_message_get_flags", libgio.}
proc dbusMessageSetFlags*(message: GDBusMessage; flags: GDBusMessageFlags) {.
    importc: "g_dbus_message_set_flags", libgio.}
proc dbusMessageGetSerial*(message: GDBusMessage): uint32 {.
    importc: "g_dbus_message_get_serial", libgio.}
proc dbusMessageSetSerial*(message: GDBusMessage; serial: uint32) {.
    importc: "g_dbus_message_set_serial", libgio.}
proc dbusMessageGetHeader*(message: GDBusMessage;
                           headerField: GDBusMessageHeaderField): GVariant {.
    importc: "g_dbus_message_get_header", libgio.}
proc dbusMessageSetHeader*(message: GDBusMessage;
                           headerField: GDBusMessageHeaderField;
                           value: GVariant) {.
    importc: "g_dbus_message_set_header", libgio.}
proc dbusMessageGetHeaderFields*(message: GDBusMessage): ptr cuchar {.
    importc: "g_dbus_message_get_header_fields", libgio.}
proc dbusMessageGetBody*(message: GDBusMessage): GVariant {.
    importc: "g_dbus_message_get_body", libgio.}
proc dbusMessageSetBody*(message: GDBusMessage; body: GVariant) {.
    importc: "g_dbus_message_set_body", libgio.}
proc dbusMessageGetUnixFdList*(message: GDBusMessage): GUnixFDList {.
    importc: "g_dbus_message_get_unix_fd_list", libgio.}
proc dbusMessageSetUnixFdList*(message: GDBusMessage; fdList: GUnixFDList) {.
    importc: "g_dbus_message_set_unix_fd_list", libgio.}
proc dbusMessageGetReplySerial*(message: GDBusMessage): uint32 {.
    importc: "g_dbus_message_get_reply_serial", libgio.}
proc dbusMessageSetReplySerial*(message: GDBusMessage; value: uint32) {.
    importc: "g_dbus_message_set_reply_serial", libgio.}
proc dbusMessageGetInterface*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_interface", libgio.}
proc dbusMessageSetInterface*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_interface", libgio.}
proc dbusMessageGetMember*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_member", libgio.}
proc dbusMessageSetMember*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_member", libgio.}
proc dbusMessageGetPath*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_path", libgio.}
proc dbusMessageSetPath*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_path", libgio.}
proc dbusMessageGetSender*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_sender", libgio.}
proc dbusMessageSetSender*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_sender", libgio.}
proc dbusMessageGetDestination*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_destination", libgio.}
proc dbusMessageSetDestination*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_destination", libgio.}
proc dbusMessageGetErrorName*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_error_name", libgio.}
proc dbusMessageSetErrorName*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_error_name", libgio.}
proc dbusMessageGetSignature*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_signature", libgio.}
proc dbusMessageSetSignature*(message: GDBusMessage; value: cstring) {.
    importc: "g_dbus_message_set_signature", libgio.}
proc dbusMessageGetNumUnixFds*(message: GDBusMessage): uint32 {.
    importc: "g_dbus_message_get_num_unix_fds", libgio.}
proc dbusMessageSetNumUnixFds*(message: GDBusMessage; value: uint32) {.
    importc: "g_dbus_message_set_num_unix_fds", libgio.}
proc dbusMessageGetArg0*(message: GDBusMessage): cstring {.
    importc: "g_dbus_message_get_arg0", libgio.}
proc newDbusMessage*(blob: var cuchar; blobLen: Gsize;
                             capabilities: GDBusCapabilityFlags;
                             error: var GError): GDBusMessage {.
    importc: "g_dbus_message_new_from_blob", libgio.}
proc dbusMessageBytesNeeded*(blob: var cuchar; blobLen: Gsize; error: var GError): Gssize {.
    importc: "g_dbus_message_bytes_needed", libgio.}
proc dbusMessageToBlob*(message: GDBusMessage; outSize: var Gsize;
                        capabilities: GDBusCapabilityFlags; error: var GError): ptr cuchar {.
    importc: "g_dbus_message_to_blob", libgio.}
proc dbusMessageToGerror*(message: GDBusMessage; error: var GError): Gboolean {.
    importc: "g_dbus_message_to_gerror", libgio.}

template gTypeDbusMethodInvocation*(): untyped =
  (dbusMethodInvocationGetType())

template gDbusMethodInvocation*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusMethodInvocation, GDBusMethodInvocationObj))

template gIsDbusMethodInvocation*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusMethodInvocation))

proc dbusMethodInvocationGetType*(): GType {.
    importc: "g_dbus_method_invocation_get_type", libgio.}
proc dbusMethodInvocationGetSender*(invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_sender", libgio.}
proc dbusMethodInvocationGetObjectPath*(invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_object_path", libgio.}
proc dbusMethodInvocationGetInterfaceName*(invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_interface_name", libgio.}
proc dbusMethodInvocationGetMethodName*(invocation: GDBusMethodInvocation): cstring {.
    importc: "g_dbus_method_invocation_get_method_name", libgio.}
proc dbusMethodInvocationGetMethodInfo*(invocation: GDBusMethodInvocation): GDBusMethodInfo {.
    importc: "g_dbus_method_invocation_get_method_info", libgio.}
proc dbusMethodInvocationGetPropertyInfo*(invocation: GDBusMethodInvocation): GDBusPropertyInfo {.
    importc: "g_dbus_method_invocation_get_property_info", libgio.}
proc dbusMethodInvocationGetConnection*(invocation: GDBusMethodInvocation): GDBusConnection {.
    importc: "g_dbus_method_invocation_get_connection", libgio.}
proc dbusMethodInvocationGetMessage*(invocation: GDBusMethodInvocation): GDBusMessage {.
    importc: "g_dbus_method_invocation_get_message", libgio.}
proc dbusMethodInvocationGetParameters*(invocation: GDBusMethodInvocation): GVariant {.
    importc: "g_dbus_method_invocation_get_parameters", libgio.}
proc dbusMethodInvocationGetUserData*(invocation: GDBusMethodInvocation): Gpointer {.
    importc: "g_dbus_method_invocation_get_user_data", libgio.}
proc dbusMethodInvocationReturnValue*(invocation: GDBusMethodInvocation;
                                      parameters: GVariant) {.
    importc: "g_dbus_method_invocation_return_value", libgio.}
proc dbusMethodInvocationReturnValueWithUnixFdList*(
    invocation: GDBusMethodInvocation; parameters: GVariant;
    fdList: GUnixFDList) {.importc: "g_dbus_method_invocation_return_value_with_unix_fd_list",
                            libgio.}
proc dbusMethodInvocationReturnError*(invocation: GDBusMethodInvocation;
                                      domain: GQuark; code: cint; format: cstring) {.
    varargs, importc: "g_dbus_method_invocation_return_error", libgio.}
discard """
proc dbusMethodInvocationReturnErrorValist*(
    invocation: GDBusMethodInvocation; domain: GQuark; code: cint; format: cstring;
    varArgs: VaList) {.importc: "g_dbus_method_invocation_return_error_valist",
                     libgio.}
"""
proc dbusMethodInvocationReturnErrorLiteral*(
    invocation: GDBusMethodInvocation; domain: GQuark; code: cint; message: cstring) {.
    importc: "g_dbus_method_invocation_return_error_literal", libgio.}
proc dbusMethodInvocationReturnGerror*(invocation: GDBusMethodInvocation;
                                       error: GError) {.
    importc: "g_dbus_method_invocation_return_gerror", libgio.}
proc dbusMethodInvocationTakeError*(invocation: GDBusMethodInvocation;
                                    error: GError) {.
    importc: "g_dbus_method_invocation_take_error", libgio.}
proc dbusMethodInvocationReturnDbusError*(invocation: GDBusMethodInvocation;
    errorName: cstring; errorMessage: cstring) {.
    importc: "g_dbus_method_invocation_return_dbus_error", libgio.}

type
  GBusAcquiredCallback* = proc (connection: GDBusConnection; name: cstring;
                             userData: Gpointer) {.cdecl.}

type
  GBusNameAcquiredCallback* = proc (connection: GDBusConnection; name: cstring;
                                 userData: Gpointer) {.cdecl.}

type
  GBusNameLostCallback* = proc (connection: GDBusConnection; name: cstring;
                             userData: Gpointer) {.cdecl.}

proc busOwnName*(busType: GBusType; name: cstring; flags: GBusNameOwnerFlags;
                 busAcquiredHandler: GBusAcquiredCallback;
                 nameAcquiredHandler: GBusNameAcquiredCallback;
                 nameLostHandler: GBusNameLostCallback; userData: Gpointer;
                 userDataFreeFunc: GDestroyNotify): cuint {.
    importc: "g_bus_own_name", libgio.}
proc busOwnNameOnConnection*(connection: GDBusConnection; name: cstring;
                             flags: GBusNameOwnerFlags;
                             nameAcquiredHandler: GBusNameAcquiredCallback;
                             nameLostHandler: GBusNameLostCallback;
                             userData: Gpointer; userDataFreeFunc: GDestroyNotify): cuint {.
    importc: "g_bus_own_name_on_connection", libgio.}
proc busOwnNameWithClosures*(busType: GBusType; name: cstring;
                             flags: GBusNameOwnerFlags;
                             busAcquiredClosure: GClosure;
                             nameAcquiredClosure: GClosure;
                             nameLostClosure: GClosure): cuint {.
    importc: "g_bus_own_name_with_closures", libgio.}
proc busOwnNameOnConnectionWithClosures*(connection: GDBusConnection;
    name: cstring; flags: GBusNameOwnerFlags; nameAcquiredClosure: GClosure;
    nameLostClosure: GClosure): cuint {.importc: "g_bus_own_name_on_connection_with_closures",
                                        libgio.}
proc busUnownName*(ownerId: cuint) {.importc: "g_bus_unown_name", libgio.}

type
  GBusNameAppearedCallback* = proc (connection: GDBusConnection; name: cstring;
                                 nameOwner: cstring; userData: Gpointer) {.cdecl.}

type
  GBusNameVanishedCallback* = proc (connection: GDBusConnection; name: cstring;
                                 userData: Gpointer) {.cdecl.}

proc busWatchName*(busType: GBusType; name: cstring; flags: GBusNameWatcherFlags;
                   nameAppearedHandler: GBusNameAppearedCallback;
                   nameVanishedHandler: GBusNameVanishedCallback;
                   userData: Gpointer; userDataFreeFunc: GDestroyNotify): cuint {.
    importc: "g_bus_watch_name", libgio.}
proc busWatchNameOnConnection*(connection: GDBusConnection; name: cstring;
                               flags: GBusNameWatcherFlags;
                               nameAppearedHandler: GBusNameAppearedCallback;
                               nameVanishedHandler: GBusNameVanishedCallback;
                               userData: Gpointer;
                               userDataFreeFunc: GDestroyNotify): cuint {.
    importc: "g_bus_watch_name_on_connection", libgio.}
proc busWatchNameWithClosures*(busType: GBusType; name: cstring;
                               flags: GBusNameWatcherFlags;
                               nameAppearedClosure: GClosure;
                               nameVanishedClosure: GClosure): cuint {.
    importc: "g_bus_watch_name_with_closures", libgio.}
proc busWatchNameOnConnectionWithClosures*(connection: GDBusConnection;
    name: cstring; flags: GBusNameWatcherFlags; nameAppearedClosure: GClosure;
    nameVanishedClosure: GClosure): cuint {.
    importc: "g_bus_watch_name_on_connection_with_closures", libgio.}
proc busUnwatchName*(watcherId: cuint) {.importc: "g_bus_unwatch_name", libgio.}

template gTypeDbusProxy*(): untyped =
  (dbusProxyGetType())

template gDbusProxy*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusProxy, GDBusProxyObj))

template gDbusProxyClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeDbusProxy, GDBusProxyClassObj))

template gDbusProxyGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeDbusProxy, GDBusProxyClassObj))

template gIsDbusProxy*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusProxy))

template gIsDbusProxyClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeDbusProxy))

proc dbusProxyGetType*(): GType {.importc: "g_dbus_proxy_get_type", libgio.}
proc dbusProxyNew*(connection: GDBusConnection; flags: GDBusProxyFlags;
                   info: GDBusInterfaceInfo; name: cstring; objectPath: cstring;
                   interfaceName: cstring; cancellable: GCancellable;
                   callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_proxy_new", libgio.}
proc dbusProxyNewFinish*(res: GAsyncResult; error: var GError): GDBusProxy {.
    importc: "g_dbus_proxy_new_finish", libgio.}
proc dbusProxyNewSync*(connection: GDBusConnection; flags: GDBusProxyFlags;
                       info: GDBusInterfaceInfo; name: cstring;
                       objectPath: cstring; interfaceName: cstring;
                       cancellable: GCancellable; error: var GError): GDBusProxy {.
    importc: "g_dbus_proxy_new_sync", libgio.}
proc dbusProxyNewForBus*(busType: GBusType; flags: GDBusProxyFlags;
                         info: GDBusInterfaceInfo; name: cstring;
                         objectPath: cstring; interfaceName: cstring;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_proxy_new_for_bus", libgio.}
proc dbusProxyNewForBusFinish*(res: GAsyncResult; error: var GError): GDBusProxy {.
    importc: "g_dbus_proxy_new_for_bus_finish", libgio.}
proc dbusProxyNewForBusSync*(busType: GBusType; flags: GDBusProxyFlags;
                             info: GDBusInterfaceInfo; name: cstring;
                             objectPath: cstring; interfaceName: cstring;
                             cancellable: GCancellable; error: var GError): GDBusProxy {.
    importc: "g_dbus_proxy_new_for_bus_sync", libgio.}
proc dbusProxyGetConnection*(proxy: GDBusProxy): GDBusConnection {.
    importc: "g_dbus_proxy_get_connection", libgio.}
proc dbusProxyGetFlags*(proxy: GDBusProxy): GDBusProxyFlags {.
    importc: "g_dbus_proxy_get_flags", libgio.}
proc dbusProxyGetName*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_name", libgio.}
proc dbusProxyGetNameOwner*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_name_owner", libgio.}
proc dbusProxyGetObjectPath*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_object_path", libgio.}
proc dbusProxyGetInterfaceName*(proxy: GDBusProxy): cstring {.
    importc: "g_dbus_proxy_get_interface_name", libgio.}
proc dbusProxyGetDefaultTimeout*(proxy: GDBusProxy): cint {.
    importc: "g_dbus_proxy_get_default_timeout", libgio.}
proc dbusProxySetDefaultTimeout*(proxy: GDBusProxy; timeoutMsec: cint) {.
    importc: "g_dbus_proxy_set_default_timeout", libgio.}
proc dbusProxyGetInterfaceInfo*(proxy: GDBusProxy): GDBusInterfaceInfo {.
    importc: "g_dbus_proxy_get_interface_info", libgio.}
proc dbusProxySetInterfaceInfo*(proxy: GDBusProxy; info: GDBusInterfaceInfo) {.
    importc: "g_dbus_proxy_set_interface_info", libgio.}
proc dbusProxyGetCachedProperty*(proxy: GDBusProxy; propertyName: cstring): GVariant {.
    importc: "g_dbus_proxy_get_cached_property", libgio.}
proc dbusProxySetCachedProperty*(proxy: GDBusProxy; propertyName: cstring;
                                 value: GVariant) {.
    importc: "g_dbus_proxy_set_cached_property", libgio.}
proc dbusProxyGetCachedPropertyNames*(proxy: GDBusProxy): cstringArray {.
    importc: "g_dbus_proxy_get_cached_property_names", libgio.}
proc dbusProxyCall*(proxy: GDBusProxy; methodName: cstring;
                    parameters: GVariant; flags: GDBusCallFlags;
                    timeoutMsec: cint; cancellable: GCancellable;
                    callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_proxy_call", libgio.}
proc dbusProxyCallFinish*(proxy: GDBusProxy; res: GAsyncResult;
                          error: var GError): GVariant {.
    importc: "g_dbus_proxy_call_finish", libgio.}
proc dbusProxyCallSync*(proxy: GDBusProxy; methodName: cstring;
                        parameters: GVariant; flags: GDBusCallFlags;
                        timeoutMsec: cint; cancellable: GCancellable;
                        error: var GError): GVariant {.
    importc: "g_dbus_proxy_call_sync", libgio.}
proc dbusProxyCallWithUnixFdList*(proxy: GDBusProxy; methodName: cstring;
                                  parameters: GVariant; flags: GDBusCallFlags;
                                  timeoutMsec: cint; fdList: GUnixFDList;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_dbus_proxy_call_with_unix_fd_list", libgio.}
proc dbusProxyCallWithUnixFdListFinish*(proxy: GDBusProxy;
                                        outFdList: var GUnixFDList;
                                        res: GAsyncResult;
                                        error: var GError): GVariant {.
    importc: "g_dbus_proxy_call_with_unix_fd_list_finish", libgio.}
proc dbusProxyCallWithUnixFdListSync*(proxy: GDBusProxy; methodName: cstring;
                                      parameters: GVariant;
                                      flags: GDBusCallFlags; timeoutMsec: cint;
                                      fdList: GUnixFDList;
                                      outFdList: var GUnixFDList;
                                      cancellable: GCancellable;
                                      error: var GError): GVariant {.
    importc: "g_dbus_proxy_call_with_unix_fd_list_sync", libgio.}

template gTypeDbusServer*(): untyped =
  (dbusServerGetType())

template gDbusServer*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusServer, GDBusServerObj))

template gIsDbusServer*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusServer))

proc dbusServerGetType*(): GType {.importc: "g_dbus_server_get_type", libgio.}
proc newDbusServer*(address: cstring; flags: GDBusServerFlags; guid: cstring;
                        observer: GDBusAuthObserver;
                        cancellable: GCancellable; error: var GError): GDBusServer {.
    importc: "g_dbus_server_new_sync", libgio.}
proc dbusServerGetClientAddress*(server: GDBusServer): cstring {.
    importc: "g_dbus_server_get_client_address", libgio.}
proc dbusServerGetGuid*(server: GDBusServer): cstring {.
    importc: "g_dbus_server_get_guid", libgio.}
proc dbusServerGetFlags*(server: GDBusServer): GDBusServerFlags {.
    importc: "g_dbus_server_get_flags", libgio.}
proc dbusServerStart*(server: GDBusServer) {.importc: "g_dbus_server_start",
    libgio.}
proc dbusServerStop*(server: GDBusServer) {.importc: "g_dbus_server_stop",
    libgio.}
proc dbusServerIsActive*(server: GDBusServer): Gboolean {.
    importc: "g_dbus_server_is_active", libgio.}

proc dbusIsGuid*(string: cstring): Gboolean {.importc: "g_dbus_is_guid", libgio.}
proc dbusGenerateGuid*(): cstring {.importc: "g_dbus_generate_guid", libgio.}
proc dbusIsName*(string: cstring): Gboolean {.importc: "g_dbus_is_name", libgio.}
proc dbusIsUniqueName*(string: cstring): Gboolean {.
    importc: "g_dbus_is_unique_name", libgio.}
proc dbusIsMemberName*(string: cstring): Gboolean {.
    importc: "g_dbus_is_member_name", libgio.}
proc dbusIsInterfaceName*(string: cstring): Gboolean {.
    importc: "g_dbus_is_interface_name", libgio.}
proc dbusGvariantToGvalue*(value: GVariant; outGvalue: GValue) {.
    importc: "g_dbus_gvariant_to_gvalue", libgio.}
proc dbusGvalueToGvariant*(gvalue: GValue; `type`: GVariantType): GVariant {.
    importc: "g_dbus_gvalue_to_gvariant", libgio.}

template gTypeDrive*(): untyped =
  (driveGetType())

template gDrive*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeDrive, GDriveObj))

template gIsDrive*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeDrive))

template gDriveGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeDrive, GDriveIfaceObj))

type
  GMountOperation* =  ptr GMountOperationObj
  GMountOperationPtr* = ptr GMountOperationObj
  GMountOperationObj* = object of GObjectObj
    priv19: pointer

  GMountOperationClass* =  ptr GMountOperationClassObj
  GMountOperationClassPtr* = ptr GMountOperationClassObj
  GMountOperationClassObj* = object of GObjectClassObj
    askPassword*: proc (op: GMountOperation; message: cstring;
                      defaultUser: cstring; defaultDomain: cstring;
                      flags: GAskPasswordFlags) {.cdecl.}
    askQuestion*: proc (op: GMountOperation; message: cstring; choices: ptr cstring) {.cdecl.}
    reply*: proc (op: GMountOperation; result: GMountOperationResult) {.cdecl.}
    aborted*: proc (op: GMountOperation) {.cdecl.}
    showProcesses*: proc (op: GMountOperation; message: cstring;
                        processes: glib.GArray; choices: ptr cstring) {.cdecl.}
    showUnmountProgress*: proc (op: GMountOperation; message: cstring;
                              timeLeft: int64; bytesLeft: int64) {.cdecl.}
    gReserved161*: proc () {.cdecl.}
    gReserved162*: proc () {.cdecl.}
    gReserved163*: proc () {.cdecl.}
    gReserved164*: proc () {.cdecl.}
    gReserved165*: proc () {.cdecl.}
    gReserved166*: proc () {.cdecl.}
    gReserved167*: proc () {.cdecl.}
    gReserved168*: proc () {.cdecl.}
    gReserved169*: proc () {.cdecl.}
type
  GDriveIface* =  ptr GDriveIfaceObj
  GDriveIfacePtr* = ptr GDriveIfaceObj
  GDriveIfaceObj*{.final.} = object of GTypeInterfaceObj
    changed*: proc (drive: GDrive) {.cdecl.}
    disconnected*: proc (drive: GDrive) {.cdecl.}
    ejectButton*: proc (drive: GDrive) {.cdecl.}
    getName*: proc (drive: GDrive): cstring {.cdecl.}
    getIcon*: proc (drive: GDrive): GIcon {.cdecl.}
    hasVolumes*: proc (drive: GDrive): Gboolean {.cdecl.}
    getVolumes*: proc (drive: GDrive): GList {.cdecl.}
    isMediaRemovable*: proc (drive: GDrive): Gboolean {.cdecl.}
    hasMedia*: proc (drive: GDrive): Gboolean {.cdecl.}
    isMediaCheckAutomatic*: proc (drive: GDrive): Gboolean {.cdecl.}
    canEject*: proc (drive: GDrive): Gboolean {.cdecl.}
    canPollForMedia*: proc (drive: GDrive): Gboolean {.cdecl.}
    eject*: proc (drive: GDrive; flags: GMountUnmountFlags;
                cancellable: GCancellable; callback: GAsyncReadyCallback;
                userData: Gpointer) {.cdecl.}
    ejectFinish*: proc (drive: GDrive; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    pollForMedia*: proc (drive: GDrive; cancellable: GCancellable;
                       callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    pollForMediaFinish*: proc (drive: GDrive; result: GAsyncResult;
                             error: var GError): Gboolean {.cdecl.}
    getIdentifier*: proc (drive: GDrive; kind: cstring): cstring {.cdecl.}
    enumerateIdentifiers*: proc (drive: GDrive): cstringArray {.cdecl.}
    getStartStopType*: proc (drive: GDrive): GDriveStartStopType {.cdecl.}
    canStart*: proc (drive: GDrive): Gboolean {.cdecl.}
    canStartDegraded*: proc (drive: GDrive): Gboolean {.cdecl.}
    start*: proc (drive: GDrive; flags: GDriveStartFlags;
                mountOperation: GMountOperation; cancellable: GCancellable;
                callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    startFinish*: proc (drive: GDrive; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    canStop*: proc (drive: GDrive): Gboolean {.cdecl.}
    stop*: proc (drive: GDrive; flags: GMountUnmountFlags;
               mountOperation: GMountOperation; cancellable: GCancellable;
               callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    stopFinish*: proc (drive: GDrive; result: GAsyncResult;
                     error: var GError): Gboolean {.cdecl.}
    stopButton*: proc (drive: GDrive) {.cdecl.}
    ejectWithOperation*: proc (drive: GDrive; flags: GMountUnmountFlags;
                             mountOperation: GMountOperation;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    ejectWithOperationFinish*: proc (drive: GDrive; result: GAsyncResult;
                                   error: var GError): Gboolean {.cdecl.}
    getSortKey*: proc (drive: GDrive): cstring {.cdecl.}
    getSymbolicIcon*: proc (drive: GDrive): GIcon {.cdecl.}
    isRemovable*: proc (drive: GDrive): Gboolean {.cdecl.}

proc driveGetType*(): GType {.importc: "g_drive_get_type", libgio.}
proc getName*(drive: GDrive): cstring {.importc: "g_drive_get_name",
    libgio.}
proc name*(drive: GDrive): cstring {.importc: "g_drive_get_name",
    libgio.}
proc getIcon*(drive: GDrive): GIcon {.importc: "g_drive_get_icon",
    libgio.}
proc icon*(drive: GDrive): GIcon {.importc: "g_drive_get_icon",
    libgio.}
proc getSymbolicIcon*(drive: GDrive): GIcon {.
    importc: "g_drive_get_symbolic_icon", libgio.}
proc symbolicIcon*(drive: GDrive): GIcon {.
    importc: "g_drive_get_symbolic_icon", libgio.}
proc hasVolumes*(drive: GDrive): Gboolean {.importc: "g_drive_has_volumes",
    libgio.}
proc getVolumes*(drive: GDrive): GList {.importc: "g_drive_get_volumes",
    libgio.}
proc volumes*(drive: GDrive): GList {.importc: "g_drive_get_volumes",
    libgio.}
proc isRemovable*(drive: GDrive): Gboolean {.
    importc: "g_drive_is_removable", libgio.}
proc isMediaRemovable*(drive: GDrive): Gboolean {.
    importc: "g_drive_is_media_removable", libgio.}
proc hasMedia*(drive: GDrive): Gboolean {.importc: "g_drive_has_media",
    libgio.}
proc isMediaCheckAutomatic*(drive: GDrive): Gboolean {.
    importc: "g_drive_is_media_check_automatic", libgio.}
proc canPollForMedia*(drive: GDrive): Gboolean {.
    importc: "g_drive_can_poll_for_media", libgio.}
proc canEject*(drive: GDrive): Gboolean {.importc: "g_drive_can_eject",
    libgio.}
proc eject*(drive: GDrive; flags: GMountUnmountFlags;
                 cancellable: GCancellable; callback: GAsyncReadyCallback;
                 userData: Gpointer) {.importc: "g_drive_eject", libgio.}
proc ejectFinish*(drive: GDrive; result: GAsyncResult;
                       error: var GError): Gboolean {.
    importc: "g_drive_eject_finish", libgio.}
proc pollForMedia*(drive: GDrive; cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_drive_poll_for_media", libgio.}
proc pollForMediaFinish*(drive: GDrive; result: GAsyncResult;
                              error: var GError): Gboolean {.
    importc: "g_drive_poll_for_media_finish", libgio.}
proc getIdentifier*(drive: GDrive; kind: cstring): cstring {.
    importc: "g_drive_get_identifier", libgio.}
proc identifier*(drive: GDrive; kind: cstring): cstring {.
    importc: "g_drive_get_identifier", libgio.}
proc enumerateIdentifiers*(drive: GDrive): cstringArray {.
    importc: "g_drive_enumerate_identifiers", libgio.}
proc getStartStopType*(drive: GDrive): GDriveStartStopType {.
    importc: "g_drive_get_start_stop_type", libgio.}
proc startStopType*(drive: GDrive): GDriveStartStopType {.
    importc: "g_drive_get_start_stop_type", libgio.}
proc canStart*(drive: GDrive): Gboolean {.importc: "g_drive_can_start",
    libgio.}
proc canStartDegraded*(drive: GDrive): Gboolean {.
    importc: "g_drive_can_start_degraded", libgio.}
proc start*(drive: GDrive; flags: GDriveStartFlags;
                 mountOperation: GMountOperation;
                 cancellable: GCancellable; callback: GAsyncReadyCallback;
                 userData: Gpointer) {.importc: "g_drive_start", libgio.}
proc startFinish*(drive: GDrive; result: GAsyncResult;
                       error: var GError): Gboolean {.
    importc: "g_drive_start_finish", libgio.}
proc canStop*(drive: GDrive): Gboolean {.importc: "g_drive_can_stop",
    libgio.}
proc stop*(drive: GDrive; flags: GMountUnmountFlags;
                mountOperation: GMountOperation; cancellable: GCancellable;
                callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_drive_stop", libgio.}
proc stopFinish*(drive: GDrive; result: GAsyncResult;
                      error: var GError): Gboolean {.
    importc: "g_drive_stop_finish", libgio.}
proc ejectWithOperation*(drive: GDrive; flags: GMountUnmountFlags;
                              mountOperation: GMountOperation;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_drive_eject_with_operation", libgio.}
proc ejectWithOperationFinish*(drive: GDrive; result: GAsyncResult;
                                    error: var GError): Gboolean {.
    importc: "g_drive_eject_with_operation_finish", libgio.}
proc getSortKey*(drive: GDrive): cstring {.importc: "g_drive_get_sort_key",
    libgio.}
proc sortKey*(drive: GDrive): cstring {.importc: "g_drive_get_sort_key",
    libgio.}

template gTypeDtlsConnection*(): untyped =
  (dtlsConnectionGetType())

template gDtlsConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeDtlsConnection, GDtlsConnectionObj))

template gIsDtlsConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeDtlsConnection))

template gDtlsConnectionGetInterface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeDtlsConnection, GDtlsConnectionInterfaceObj))

type
  GTlsCertificate* =  ptr GTlsCertificateObj
  GTlsCertificatePtr* = ptr GTlsCertificateObj
  GTlsCertificateObj*{.final.} = object of GObjectObj
    priv20: pointer

  GTlsCertificateClass* =  ptr GTlsCertificateClassObj
  GTlsCertificateClassPtr* = ptr GTlsCertificateClassObj
  GTlsCertificateClassObj*{.final.} = object of GObjectClassObj
    verify*: proc (cert: GTlsCertificate; identity: GSocketConnectable;
                 trustedCa: GTlsCertificate): GTlsCertificateFlags {.cdecl.}
    padding*: array[8, Gpointer]
type
  GDtlsConnectionInterface* =  ptr GDtlsConnectionInterfaceObj
  GDtlsConnectionInterfacePtr* = ptr GDtlsConnectionInterfaceObj
  GDtlsConnectionInterfaceObj*{.final.} = object of GTypeInterfaceObj
    acceptCertificate*: proc (connection: GDtlsConnection;
                            peerCert: GTlsCertificate;
                            errors: GTlsCertificateFlags): Gboolean {.cdecl.}
    handshake*: proc (conn: GDtlsConnection; cancellable: GCancellable;
                    error: var GError): Gboolean {.cdecl.}
    handshakeAsync*: proc (conn: GDtlsConnection; ioPriority: cint;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    handshakeFinish*: proc (conn: GDtlsConnection; result: GAsyncResult;
                          error: var GError): Gboolean {.cdecl.}
    shutdown*: proc (conn: GDtlsConnection; shutdownRead: Gboolean;
                   shutdownWrite: Gboolean; cancellable: GCancellable;
                   error: var GError): Gboolean {.cdecl.}
    shutdownAsync*: proc (conn: GDtlsConnection; shutdownRead: Gboolean;
                        shutdownWrite: Gboolean; ioPriority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    shutdownFinish*: proc (conn: GDtlsConnection; result: GAsyncResult;
                         error: var GError): Gboolean {.cdecl.}
type
  GTlsConnection* =  ptr GTlsConnectionObj
  GTlsConnectionPtr* = ptr GTlsConnectionObj
  GTlsConnectionObj*{.final.} = object of GIOStreamObj
    priv21: pointer

  GTlsConnectionClass* =  ptr GTlsConnectionClassObj
  GTlsConnectionClassPtr* = ptr GTlsConnectionClassObj
  GTlsConnectionClassObj*{.final.} = object of GIOStreamClassObj
    acceptCertificate*: proc (connection: GTlsConnection;
                            peerCert: GTlsCertificate;
                            errors: GTlsCertificateFlags): Gboolean {.cdecl.}
    handshake*: proc (conn: GTlsConnection; cancellable: GCancellable;
                    error: var GError): Gboolean {.cdecl.}
    handshakeAsync*: proc (conn: GTlsConnection; ioPriority: cint;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    handshakeFinish*: proc (conn: GTlsConnection; result: GAsyncResult;
                          error: var GError): Gboolean {.cdecl.}
    padding*: array[8, Gpointer]
type
  GTlsPassword* =  ptr GTlsPasswordObj
  GTlsPasswordPtr* = ptr GTlsPasswordObj
  GTlsPasswordObj*{.final.} = object of GObjectObj
    priv22: pointer

type
  GTlsPasswordClass* =  ptr GTlsPasswordClassObj
  GTlsPasswordClassPtr* = ptr GTlsPasswordClassObj
  GTlsPasswordClassObj*{.final.} = object of GObjectClassObj
    getValue*: proc (password: GTlsPassword; length: var Gsize): ptr cuchar {.cdecl.}
    setValue*: proc (password: GTlsPassword; value: var cuchar; length: Gssize;
                   destroy: GDestroyNotify) {.cdecl.}
    getDefaultWarning*: proc (password: GTlsPassword): cstring {.cdecl.}
    padding*: array[4, Gpointer]
type
  GTlsInteraction* =  ptr GTlsInteractionObj
  GTlsInteractionPtr* = ptr GTlsInteractionObj
  GTlsInteractionObj*{.final.} = object of GObjectObj
    priv23: pointer

  GTlsInteractionClass* =  ptr GTlsInteractionClassObj
  GTlsInteractionClassPtr* = ptr GTlsInteractionClassObj
  GTlsInteractionClassObj*{.final.} = object of GObjectClassObj
    askPassword*: proc (interaction: GTlsInteraction; password: GTlsPassword;
                      cancellable: GCancellable; error: var GError): GTlsInteractionResult {.cdecl.}
    askPasswordAsync*: proc (interaction: GTlsInteraction;
                           password: GTlsPassword;
                           cancellable: GCancellable;
                           callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    askPasswordFinish*: proc (interaction: GTlsInteraction;
                            result: GAsyncResult; error: var GError): GTlsInteractionResult {.cdecl.}
    requestCertificate*: proc (interaction: GTlsInteraction;
                             connection: GTlsConnection;
                             flags: GTlsCertificateRequestFlags;
                             cancellable: GCancellable; error: var GError): GTlsInteractionResult {.cdecl.}
    requestCertificateAsync*: proc (interaction: GTlsInteraction;
                                  connection: GTlsConnection;
                                  flags: GTlsCertificateRequestFlags;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.cdecl.}
    requestCertificateFinish*: proc (interaction: GTlsInteraction;
                                   result: GAsyncResult; error: var GError): GTlsInteractionResult {.cdecl.}
    padding*: array[21, Gpointer]
type
  GTlsDatabase* =  ptr GTlsDatabaseObj
  GTlsDatabasePtr* = ptr GTlsDatabaseObj
  GTlsDatabaseObj*{.final.} = object of GObjectObj
    priv24: pointer

  GTlsDatabaseClass* =  ptr GTlsDatabaseClassObj
  GTlsDatabaseClassPtr* = ptr GTlsDatabaseClassObj
  GTlsDatabaseClassObj*{.final.} = object of GObjectClassObj
    verifyChain*: proc (self: GTlsDatabase; chain: GTlsCertificate;
                      purpose: cstring; identity: GSocketConnectable;
                      interaction: GTlsInteraction;
                      flags: GTlsDatabaseVerifyFlags;
                      cancellable: GCancellable; error: var GError): GTlsCertificateFlags {.cdecl.}
    verifyChainAsync*: proc (self: GTlsDatabase; chain: GTlsCertificate;
                           purpose: cstring; identity: GSocketConnectable;
                           interaction: GTlsInteraction;
                           flags: GTlsDatabaseVerifyFlags;
                           cancellable: GCancellable;
                           callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    verifyChainFinish*: proc (self: GTlsDatabase; result: GAsyncResult;
                            error: var GError): GTlsCertificateFlags {.cdecl.}
    createCertificateHandle*: proc (self: GTlsDatabase;
                                  certificate: GTlsCertificate): cstring {.cdecl.}
    lookupCertificateForHandle*: proc (self: GTlsDatabase; handle: cstring;
                                     interaction: GTlsInteraction;
                                     flags: GTlsDatabaseLookupFlags;
                                     cancellable: GCancellable;
                                     error: var GError): GTlsCertificate {.cdecl.}
    lookupCertificateForHandleAsync*: proc (self: GTlsDatabase; handle: cstring;
        interaction: GTlsInteraction; flags: GTlsDatabaseLookupFlags;
        cancellable: GCancellable; callback: GAsyncReadyCallback;
        userData: Gpointer) {.cdecl.}
    lookupCertificateForHandleFinish*: proc (self: GTlsDatabase;
        result: GAsyncResult; error: var GError): GTlsCertificate {.cdecl.}
    lookupCertificateIssuer*: proc (self: GTlsDatabase;
                                  certificate: GTlsCertificate;
                                  interaction: GTlsInteraction;
                                  flags: GTlsDatabaseLookupFlags;
                                  cancellable: GCancellable;
                                  error: var GError): GTlsCertificate {.cdecl.}
    lookupCertificateIssuerAsync*: proc (self: GTlsDatabase;
                                       certificate: GTlsCertificate;
                                       interaction: GTlsInteraction;
                                       flags: GTlsDatabaseLookupFlags;
                                       cancellable: GCancellable;
                                       callback: GAsyncReadyCallback;
                                       userData: Gpointer) {.cdecl.}
    lookupCertificateIssuerFinish*: proc (self: GTlsDatabase;
                                        result: GAsyncResult;
                                        error: var GError): GTlsCertificate {.cdecl.}
    lookupCertificatesIssuedBy*: proc (self: GTlsDatabase;
                                     issuerRawDn: glib.GByteArray;
                                     interaction: GTlsInteraction;
                                     flags: GTlsDatabaseLookupFlags;
                                     cancellable: GCancellable;
                                     error: var GError): GList {.cdecl.}
    lookupCertificatesIssuedByAsync*: proc (self: GTlsDatabase;
        issuerRawDn: glib.GByteArray; interaction: GTlsInteraction;
        flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
        callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    lookupCertificatesIssuedByFinish*: proc (self: GTlsDatabase;
        result: GAsyncResult; error: var GError): GList {.cdecl.}
    padding*: array[16, Gpointer]

proc dtlsConnectionGetType*(): GType {.importc: "g_dtls_connection_get_type",
                                     libgio.}
proc setDatabase*(conn: GDtlsConnection;
                                database: GTlsDatabase) {.
    importc: "g_dtls_connection_set_database", libgio.}
proc `database=`*(conn: GDtlsConnection;
                                database: GTlsDatabase) {.
    importc: "g_dtls_connection_set_database", libgio.}
proc getDatabase*(conn: GDtlsConnection): GTlsDatabase {.
    importc: "g_dtls_connection_get_database", libgio.}
proc database*(conn: GDtlsConnection): GTlsDatabase {.
    importc: "g_dtls_connection_get_database", libgio.}
proc setCertificate*(conn: GDtlsConnection;
                                   certificate: GTlsCertificate) {.
    importc: "g_dtls_connection_set_certificate", libgio.}
proc `certificate=`*(conn: GDtlsConnection;
                                   certificate: GTlsCertificate) {.
    importc: "g_dtls_connection_set_certificate", libgio.}
proc getCertificate*(conn: GDtlsConnection): GTlsCertificate {.
    importc: "g_dtls_connection_get_certificate", libgio.}
proc certificate*(conn: GDtlsConnection): GTlsCertificate {.
    importc: "g_dtls_connection_get_certificate", libgio.}
proc setInteraction*(conn: GDtlsConnection;
                                   interaction: GTlsInteraction) {.
    importc: "g_dtls_connection_set_interaction", libgio.}
proc `interaction=`*(conn: GDtlsConnection;
                                   interaction: GTlsInteraction) {.
    importc: "g_dtls_connection_set_interaction", libgio.}
proc getInteraction*(conn: GDtlsConnection): GTlsInteraction {.
    importc: "g_dtls_connection_get_interaction", libgio.}
proc interaction*(conn: GDtlsConnection): GTlsInteraction {.
    importc: "g_dtls_connection_get_interaction", libgio.}
proc getPeerCertificate*(conn: GDtlsConnection): GTlsCertificate {.
    importc: "g_dtls_connection_get_peer_certificate", libgio.}
proc peerCertificate*(conn: GDtlsConnection): GTlsCertificate {.
    importc: "g_dtls_connection_get_peer_certificate", libgio.}
proc getPeerCertificateErrors*(conn: GDtlsConnection): GTlsCertificateFlags {.
    importc: "g_dtls_connection_get_peer_certificate_errors", libgio.}
proc peerCertificateErrors*(conn: GDtlsConnection): GTlsCertificateFlags {.
    importc: "g_dtls_connection_get_peer_certificate_errors", libgio.}
proc setRequireCloseNotify*(conn: GDtlsConnection;
    requireCloseNotify: Gboolean) {.importc: "g_dtls_connection_set_require_close_notify",
                                  libgio.}
proc `requireCloseNotify=`*(conn: GDtlsConnection;
    requireCloseNotify: Gboolean) {.importc: "g_dtls_connection_set_require_close_notify",
                                  libgio.}
proc getRequireCloseNotify*(conn: GDtlsConnection): Gboolean {.
    importc: "g_dtls_connection_get_require_close_notify", libgio.}
proc requireCloseNotify*(conn: GDtlsConnection): Gboolean {.
    importc: "g_dtls_connection_get_require_close_notify", libgio.}
proc setRehandshakeMode*(conn: GDtlsConnection;
                                       mode: GTlsRehandshakeMode) {.
    importc: "g_dtls_connection_set_rehandshake_mode", libgio.}
proc `rehandshakeMode=`*(conn: GDtlsConnection;
                                       mode: GTlsRehandshakeMode) {.
    importc: "g_dtls_connection_set_rehandshake_mode", libgio.}
proc getRehandshakeMode*(conn: GDtlsConnection): GTlsRehandshakeMode {.
    importc: "g_dtls_connection_get_rehandshake_mode", libgio.}
proc rehandshakeMode*(conn: GDtlsConnection): GTlsRehandshakeMode {.
    importc: "g_dtls_connection_get_rehandshake_mode", libgio.}
proc handshake*(conn: GDtlsConnection;
                              cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_dtls_connection_handshake", libgio.}
proc handshakeAsync*(conn: GDtlsConnection; ioPriority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_dtls_connection_handshake_async", libgio.}
proc handshakeFinish*(conn: GDtlsConnection;
                                    result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_dtls_connection_handshake_finish", libgio.}
proc shutdown*(conn: GDtlsConnection; shutdownRead: Gboolean;
                             shutdownWrite: Gboolean;
                             cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_dtls_connection_shutdown", libgio.}
proc shutdownAsync*(conn: GDtlsConnection;
                                  shutdownRead: Gboolean; shutdownWrite: Gboolean;
                                  ioPriority: cint; cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_dtls_connection_shutdown_async", libgio.}
proc shutdownFinish*(conn: GDtlsConnection;
                                   result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_dtls_connection_shutdown_finish", libgio.}
proc close*(conn: GDtlsConnection; cancellable: GCancellable;
                          error: var GError): Gboolean {.
    importc: "g_dtls_connection_close", libgio.}
proc closeAsync*(conn: GDtlsConnection; ioPriority: cint;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dtls_connection_close_async", libgio.}
proc closeFinish*(conn: GDtlsConnection;
                                result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_dtls_connection_close_finish", libgio.}

proc emitAcceptCertificate*(conn: GDtlsConnection;
    peerCert: GTlsCertificate; errors: GTlsCertificateFlags): Gboolean {.
    importc: "g_dtls_connection_emit_accept_certificate", libgio.}

template gTypeDtlsClientConnection*(): untyped =
  (dtlsClientConnectionGetType())

template gDtlsClientConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeDtlsClientConnection, GDtlsClientConnectionObj))

template gIsDtlsClientConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeDtlsClientConnection))

template gDtlsClientConnectionGetInterface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeDtlsClientConnection, GDtlsClientConnectionInterfaceObj))

type
  GDtlsClientConnectionInterface* =  ptr GDtlsClientConnectionInterfaceObj
  GDtlsClientConnectionInterfacePtr* = ptr GDtlsClientConnectionInterfaceObj
  GDtlsClientConnectionInterfaceObj*{.final.} = object of GTypeInterfaceObj

proc dtlsClientConnectionGetType*(): GType {.
    importc: "g_dtls_client_connection_get_type", libgio.}
proc newDtlsClientConnection*(baseSocket: GDatagramBased;
                              serverIdentity: GSocketConnectable;
                              error: var GError): GDatagramBased {.
    importc: "g_dtls_client_connection_new", libgio.}
proc getValidationFlags*(conn: GDtlsClientConnection): GTlsCertificateFlags {.
    importc: "g_dtls_client_connection_get_validation_flags", libgio.}
proc validationFlags*(conn: GDtlsClientConnection): GTlsCertificateFlags {.
    importc: "g_dtls_client_connection_get_validation_flags", libgio.}
proc setValidationFlags*(conn: GDtlsClientConnection;
    flags: GTlsCertificateFlags) {.importc: "g_dtls_client_connection_set_validation_flags",
                                 libgio.}
proc `validationFlags=`*(conn: GDtlsClientConnection;
    flags: GTlsCertificateFlags) {.importc: "g_dtls_client_connection_set_validation_flags",
                                 libgio.}
proc getServerIdentity*(conn: GDtlsClientConnection): GSocketConnectable {.
    importc: "g_dtls_client_connection_get_server_identity", libgio.}
proc serverIdentity*(conn: GDtlsClientConnection): GSocketConnectable {.
    importc: "g_dtls_client_connection_get_server_identity", libgio.}
proc setServerIdentity*(conn: GDtlsClientConnection;
    identity: GSocketConnectable) {.importc: "g_dtls_client_connection_set_server_identity",
                                     libgio.}
proc `serverIdentity=`*(conn: GDtlsClientConnection;
    identity: GSocketConnectable) {.importc: "g_dtls_client_connection_set_server_identity",
                                     libgio.}
proc getAcceptedCas*(conn: GDtlsClientConnection): GList {.
    importc: "g_dtls_client_connection_get_accepted_cas", libgio.}
proc acceptedCas*(conn: GDtlsClientConnection): GList {.
    importc: "g_dtls_client_connection_get_accepted_cas", libgio.}

template gTypeDtlsServerConnection*(): untyped =
  (dtlsServerConnectionGetType())

template gDtlsServerConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeDtlsServerConnection, GDtlsServerConnection))

template gIsDtlsServerConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeDtlsServerConnection))

template gDtlsServerConnectionGetInterface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeDtlsServerConnection, GDtlsServerConnectionInterfaceObj))

type
  GDtlsServerConnectionInterface* =  ptr GDtlsServerConnectionInterfaceObj
  GDtlsServerConnectionInterfacePtr* = ptr GDtlsServerConnectionInterfaceObj
  GDtlsServerConnectionInterfaceObj*{.final.} = object of GTypeInterfaceObj

proc dtlsServerConnectionGetType*(): GType {.
    importc: "g_dtls_server_connection_get_type", libgio.}
proc newDtlsServerConnection*(baseSocket: GDatagramBased;
                              certificate: GTlsCertificate;
                              error: var GError): GDatagramBased {.
    importc: "g_dtls_server_connection_new", libgio.}

template gTypeIcon*(): untyped =
  (iconGetType())

template gIcon*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeIcon, GIconObj))

template gIsIcon*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeIcon))

template gIconGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeIcon, GIconIfaceObj))

type
  GIconIface* =  ptr GIconIfaceObj
  GIconIfacePtr* = ptr GIconIfaceObj
  GIconIfaceObj*{.final.} = object of GTypeInterfaceObj
    hash*: proc (icon: GIcon): cuint {.cdecl.}
    equal*: proc (icon1: GIcon; icon2: GIcon): Gboolean {.cdecl.}
    toTokens*: proc (icon: GIcon; tokens: glib.GPtrArray; outVersion: var cint): Gboolean {.cdecl.}
    fromTokens*: proc (tokens: cstringArray; numTokens: cint; version: cint;
                     error: var GError): GIcon {.cdecl.}
    serialize*: proc (icon: GIcon): GVariant {.cdecl.}

proc iconGetType*(): GType {.importc: "g_icon_get_type", libgio.}
proc iconHash*(icon: Gconstpointer): cuint {.importc: "g_icon_hash", libgio.}
proc equal*(icon1: GIcon; icon2: GIcon): Gboolean {.
    importc: "g_icon_equal", libgio.}
proc toString*(icon: GIcon): cstring {.importc: "g_icon_to_string",
    libgio.}
proc newIcon*(str: cstring; error: var GError): GIcon {.
    importc: "g_icon_new_for_string", libgio.}
proc serialize*(icon: GIcon): GVariant {.importc: "g_icon_serialize",
    libgio.}
proc iconDeserialize*(value: GVariant): GIcon {.
    importc: "g_icon_deserialize", libgio.}

template gTypeEmblem*(): untyped =
  (emblemGetType())

template gEmblem*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeEmblem, GEmblemObj))

template gEmblemClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeEmblem, GEmblemClassObj))

template gIsEmblem*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeEmblem))

template gIsEmblemClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeEmblem))

template gEmblemGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeEmblem, GEmblemClassObj))

type
  GEmblem* =  ptr GEmblemObj
  GEmblemPtr* = ptr GEmblemObj
  GEmblemObj* = object

  GEmblemClass* =  ptr GEmblemClassObj
  GEmblemClassPtr* = ptr GEmblemClassObj
  GEmblemClassObj* = object

proc emblemGetType*(): GType {.importc: "g_emblem_get_type", libgio.}
proc newEmblem*(icon: GIcon): GEmblem {.importc: "g_emblem_new", libgio.}
proc newEmblem*(icon: GIcon; origin: GEmblemOrigin): GEmblem {.
    importc: "g_emblem_new_with_origin", libgio.}
proc getIcon*(emblem: GEmblem): GIcon {.importc: "g_emblem_get_icon",
    libgio.}
proc icon*(emblem: GEmblem): GIcon {.importc: "g_emblem_get_icon",
    libgio.}
proc getOrigin*(emblem: GEmblem): GEmblemOrigin {.
    importc: "g_emblem_get_origin", libgio.}
proc origin*(emblem: GEmblem): GEmblemOrigin {.
    importc: "g_emblem_get_origin", libgio.}

template gTypeEmblemedIcon*(): untyped =
  (emblemedIconGetType())

template gEmblemedIcon*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeEmblemedIcon, GEmblemedIconObj))

template gEmblemedIconClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeEmblemedIcon, GEmblemedIconClassObj))

template gIsEmblemedIcon*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeEmblemedIcon))

template gIsEmblemedIconClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeEmblemedIcon))

template gEmblemedIconGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeEmblemedIcon, GEmblemedIconClassObj))

type
  GEmblemedIcon* =  ptr GEmblemedIconObj
  GEmblemedIconPtr* = ptr GEmblemedIconObj
  GEmblemedIconObj* = object of GObjectObj
    priv25: pointer

  GEmblemedIconClass* =  ptr GEmblemedIconClassObj
  GEmblemedIconClassPtr* = ptr GEmblemedIconClassObj
  GEmblemedIconClassObj* = object of GObjectClassObj

proc emblemedIconGetType*(): GType {.importc: "g_emblemed_icon_get_type",
                                   libgio.}
proc newEmblemedIcon*(icon: GIcon; emblem: GEmblem): GIcon {.
    importc: "g_emblemed_icon_new", libgio.}
proc getIcon*(emblemed: GEmblemedIcon): GIcon {.
    importc: "g_emblemed_icon_get_icon", libgio.}
proc icon*(emblemed: GEmblemedIcon): GIcon {.
    importc: "g_emblemed_icon_get_icon", libgio.}
proc getEmblems*(emblemed: GEmblemedIcon): GList {.
    importc: "g_emblemed_icon_get_emblems", libgio.}
proc emblems*(emblemed: GEmblemedIcon): GList {.
    importc: "g_emblemed_icon_get_emblems", libgio.}
proc addEmblem*(emblemed: GEmblemedIcon; emblem: GEmblem) {.
    importc: "g_emblemed_icon_add_emblem", libgio.}
proc clearEmblems*(emblemed: GEmblemedIcon) {.
    importc: "g_emblemed_icon_clear_emblems", libgio.}

type
  GFileAttributeInfo* =  ptr GFileAttributeInfoObj
  GFileAttributeInfoPtr* = ptr GFileAttributeInfoObj
  GFileAttributeInfoObj* = object
    name*: cstring
    `type`*: GFileAttributeType
    flags*: GFileAttributeInfoFlags

type
  GFileAttributeInfoList* =  ptr GFileAttributeInfoListObj
  GFileAttributeInfoListPtr* = ptr GFileAttributeInfoListObj
  GFileAttributeInfoListObj* = object
    infos*: GFileAttributeInfo
    nInfos*: cint

template gTypeFileAttributeInfoList*(): untyped =
  (fileAttributeInfoListGetType())

proc fileAttributeInfoListGetType*(): GType {.
    importc: "g_file_attribute_info_list_get_type", libgio.}
proc newFileAttributeInfoList*(): GFileAttributeInfoList {.
    importc: "g_file_attribute_info_list_new", libgio.}
proc `ref`*(list: GFileAttributeInfoList): GFileAttributeInfoList {.
    importc: "g_file_attribute_info_list_ref", libgio.}
proc unref*(list: GFileAttributeInfoList) {.
    importc: "g_file_attribute_info_list_unref", libgio.}
proc dup*(list: GFileAttributeInfoList): GFileAttributeInfoList {.
    importc: "g_file_attribute_info_list_dup", libgio.}
proc lookup*(list: GFileAttributeInfoList; name: cstring): GFileAttributeInfo {.
    importc: "g_file_attribute_info_list_lookup", libgio.}
proc add*(list: GFileAttributeInfoList; name: cstring;
                               `type`: GFileAttributeType;
                               flags: GFileAttributeInfoFlags) {.
    importc: "g_file_attribute_info_list_add", libgio.}

template gTypeFileEnumerator*(): untyped =
  (fileEnumeratorGetType())

template gFileEnumerator*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFileEnumerator, GFileEnumeratorObj))

template gFileEnumeratorClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFileEnumerator, GFileEnumeratorClassObj))

template gIsFileEnumerator*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFileEnumerator))

template gIsFileEnumeratorClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFileEnumerator))

template gFileEnumeratorGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFileEnumerator, GFileEnumeratorClassObj))

type
  GFileEnumerator* =  ptr GFileEnumeratorObj
  GFileEnumeratorPtr* = ptr GFileEnumeratorObj
  GFileEnumeratorObj*{.final.} = object of GObjectObj
    priv26: pointer

  GFileEnumeratorClass* =  ptr GFileEnumeratorClassObj
  GFileEnumeratorClassPtr* = ptr GFileEnumeratorClassObj
  GFileEnumeratorClassObj*{.final.} = object of GObjectClassObj
    nextFile*: proc (enumerator: GFileEnumerator; cancellable: GCancellable;
                   error: var GError): GFileInfo {.cdecl.}
    closeFn*: proc (enumerator: GFileEnumerator; cancellable: GCancellable;
                  error: var GError): Gboolean {.cdecl.}
    nextFilesAsync*: proc (enumerator: GFileEnumerator; numFiles: cint;
                         ioPriority: cint; cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    nextFilesFinish*: proc (enumerator: GFileEnumerator;
                          result: GAsyncResult; error: var GError): GList {.cdecl.}
    closeAsync*: proc (enumerator: GFileEnumerator; ioPriority: cint;
                     cancellable: GCancellable; callback: GAsyncReadyCallback;
                     userData: Gpointer) {.cdecl.}
    closeFinish*: proc (enumerator: GFileEnumerator; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    gReserved171*: proc () {.cdecl.}
    gReserved172*: proc () {.cdecl.}
    gReserved173*: proc () {.cdecl.}
    gReserved174*: proc () {.cdecl.}
    gReserved175*: proc () {.cdecl.}
    gReserved176*: proc () {.cdecl.}
    gReserved177*: proc () {.cdecl.}

proc fileEnumeratorGetType*(): GType {.importc: "g_file_enumerator_get_type",
                                     libgio.}
proc nextFile*(enumerator: GFileEnumerator;
                             cancellable: GCancellable; error: var GError): GFileInfo {.
    importc: "g_file_enumerator_next_file", libgio.}
proc close*(enumerator: GFileEnumerator;
                          cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_enumerator_close", libgio.}
proc nextFilesAsync*(enumerator: GFileEnumerator; numFiles: cint;
                                   ioPriority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_file_enumerator_next_files_async", libgio.}
proc nextFilesFinish*(enumerator: GFileEnumerator;
                                    result: GAsyncResult; error: var GError): GList {.
    importc: "g_file_enumerator_next_files_finish", libgio.}
proc closeAsync*(enumerator: GFileEnumerator; ioPriority: cint;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_enumerator_close_async", libgio.}
proc closeFinish*(enumerator: GFileEnumerator;
                                result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_file_enumerator_close_finish", libgio.}
proc isClosed*(enumerator: GFileEnumerator): Gboolean {.
    importc: "g_file_enumerator_is_closed", libgio.}
proc hasPending*(enumerator: GFileEnumerator): Gboolean {.
    importc: "g_file_enumerator_has_pending", libgio.}
proc setPending*(enumerator: GFileEnumerator; pending: Gboolean) {.
    importc: "g_file_enumerator_set_pending", libgio.}
proc `pending=`*(enumerator: GFileEnumerator; pending: Gboolean) {.
    importc: "g_file_enumerator_set_pending", libgio.}
proc getContainer*(enumerator: GFileEnumerator): GFile {.
    importc: "g_file_enumerator_get_container", libgio.}
proc container*(enumerator: GFileEnumerator): GFile {.
    importc: "g_file_enumerator_get_container", libgio.}
proc getChild*(enumerator: GFileEnumerator; info: GFileInfo): GFile {.
    importc: "g_file_enumerator_get_child", libgio.}
proc child*(enumerator: GFileEnumerator; info: GFileInfo): GFile {.
    importc: "g_file_enumerator_get_child", libgio.}
proc iterate*(direnum: GFileEnumerator;
                            outInfo: var GFileInfo; outChild: var GFile;
                            cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_enumerator_iterate", libgio.}

template gTypeFile*(): untyped =
  (fileGetType())

template gFile*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeFile, GFileObj))

template gIsFile*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeFile))

template gFileGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeFile, GFileIfaceObj))

type
  GFileInputStream* =  ptr GFileInputStreamObj
  GFileInputStreamPtr* = ptr GFileInputStreamObj
  GFileInputStreamObj*{.final.} = object of GInputStreamObj
    priv27: pointer

  GFileInputStreamClass* =  ptr GFileInputStreamClassObj
  GFileInputStreamClassPtr* = ptr GFileInputStreamClassObj
  GFileInputStreamClassObj*{.final.} = object of GInputStreamClassObj
    tell*: proc (stream: GFileInputStream): Goffset {.cdecl.}
    canSeek*: proc (stream: GFileInputStream): Gboolean {.cdecl.}
    seek*: proc (stream: GFileInputStream; offset: Goffset; `type`: GSeekType;
               cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    queryInfo*: proc (stream: GFileInputStream; attributes: cstring;
                    cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    queryInfoAsync*: proc (stream: GFileInputStream; attributes: cstring;
                         ioPriority: cint; cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    queryInfoFinish*: proc (stream: GFileInputStream; result: GAsyncResult;
                          error: var GError): GFileInfo {.cdecl.}
    gReserved181*: proc () {.cdecl.}
    gReserved182*: proc () {.cdecl.}
    gReserved183*: proc () {.cdecl.}
    gReserved184*: proc () {.cdecl.}
    gReserved185*: proc () {.cdecl.}
type
  GFileOutputStream* =  ptr GFileOutputStreamObj
  GFileOutputStreamPtr* = ptr GFileOutputStreamObj
  GFileOutputStreamObj*{.final.} = object of GOutputStreamObj
    priv28: pointer

  GFileOutputStreamClass* =  ptr GFileOutputStreamClassObj
  GFileOutputStreamClassPtr* = ptr GFileOutputStreamClassObj
  GFileOutputStreamClassObj*{.final.} = object of GOutputStreamClassObj
    tell*: proc (stream: GFileOutputStream): Goffset {.cdecl.}
    canSeek*: proc (stream: GFileOutputStream): Gboolean {.cdecl.}
    seek*: proc (stream: GFileOutputStream; offset: Goffset; `type`: GSeekType;
               cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    canTruncate*: proc (stream: GFileOutputStream): Gboolean {.cdecl.}
    truncateFn*: proc (stream: GFileOutputStream; size: Goffset;
                     cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    queryInfo*: proc (stream: GFileOutputStream; attributes: cstring;
                    cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    queryInfoAsync*: proc (stream: GFileOutputStream; attributes: cstring;
                         ioPriority: cint; cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    queryInfoFinish*: proc (stream: GFileOutputStream; result: GAsyncResult;
                          error: var GError): GFileInfo {.cdecl.}
    getEtag*: proc (stream: GFileOutputStream): cstring {.cdecl.}
    gReserved191*: proc () {.cdecl.}
    gReserved192*: proc () {.cdecl.}
    gReserved193*: proc () {.cdecl.}
    gReserved194*: proc () {.cdecl.}
    gReserved195*: proc () {.cdecl.}
type
  GFileMonitor* =  ptr GFileMonitorObj
  GFileMonitorPtr* = ptr GFileMonitorObj
  GFileMonitorObj*{.final.} = object of GObjectObj
    priv29: pointer

  GFileMonitorClass* =  ptr GFileMonitorClassObj
  GFileMonitorClassPtr* = ptr GFileMonitorClassObj
  GFileMonitorClassObj*{.final.} = object of GObjectClassObj
    changed*: proc (monitor: GFileMonitor; file: GFile; otherFile: GFile;
                  eventType: GFileMonitorEvent) {.cdecl.}
    cancel*: proc (monitor: GFileMonitor): Gboolean {.cdecl.}
    gReserved201*: proc () {.cdecl.}
    gReserved202*: proc () {.cdecl.}
    gReserved203*: proc () {.cdecl.}
    gReserved204*: proc () {.cdecl.}
    gReserved205*: proc () {.cdecl.}

type
  GFileIOStream* =  ptr GFileIOStreamObj
  GFileIOStreamPtr* = ptr GFileIOStreamObj
  GFileIOStreamObj*{.final.} = object of GIOStreamObj
    priv30: pointer

  GFileIOStreamClass* =  ptr GFileIOStreamClassObj
  GFileIOStreamClassPtr* = ptr GFileIOStreamClassObj
  GFileIOStreamClassObj*{.final.} = object of GIOStreamClassObj
    tell*: proc (stream: GFileIOStream): Goffset {.cdecl.}
    canSeek*: proc (stream: GFileIOStream): Gboolean {.cdecl.}
    seek*: proc (stream: GFileIOStream; offset: Goffset; `type`: GSeekType;
               cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    canTruncate*: proc (stream: GFileIOStream): Gboolean {.cdecl.}
    truncateFn*: proc (stream: GFileIOStream; size: Goffset;
                     cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    queryInfo*: proc (stream: GFileIOStream; attributes: cstring;
                    cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    queryInfoAsync*: proc (stream: GFileIOStream; attributes: cstring;
                         ioPriority: cint; cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    queryInfoFinish*: proc (stream: GFileIOStream; result: GAsyncResult;
                          error: var GError): GFileInfo {.cdecl.}
    getEtag*: proc (stream: GFileIOStream): cstring {.cdecl.}
    gReserved211*: proc () {.cdecl.}
    gReserved212*: proc () {.cdecl.}
    gReserved213*: proc () {.cdecl.}
    gReserved214*: proc () {.cdecl.}
    gReserved215*: proc () {.cdecl.}
type
  GFileIface* =  ptr GFileIfaceObj
  GFileIfacePtr* = ptr GFileIfaceObj
  GFileIfaceObj*{.final.} = object of GTypeInterfaceObj
    dup*: proc (file: GFile): GFile {.cdecl.}
    hash*: proc (file: GFile): cuint {.cdecl.}
    equal*: proc (file1: GFile; file2: GFile): Gboolean {.cdecl.}
    isNative*: proc (file: GFile): Gboolean {.cdecl.}
    hasUriScheme*: proc (file: GFile; uriScheme: cstring): Gboolean {.cdecl.}
    getUriScheme*: proc (file: GFile): cstring {.cdecl.}
    getBasename*: proc (file: GFile): cstring {.cdecl.}
    getPath*: proc (file: GFile): cstring {.cdecl.}
    getUri*: proc (file: GFile): cstring {.cdecl.}
    getParseName*: proc (file: GFile): cstring {.cdecl.}
    getParent*: proc (file: GFile): GFile {.cdecl.}
    prefixMatches*: proc (prefix: GFile; file: GFile): Gboolean {.cdecl.}
    getRelativePath*: proc (parent: GFile; descendant: GFile): cstring {.cdecl.}
    resolveRelativePath*: proc (file: GFile; relativePath: cstring): GFile {.cdecl.}
    getChildForDisplayName*: proc (file: GFile; displayName: cstring;
                                 error: var GError): GFile {.cdecl.}
    enumerateChildren*: proc (file: GFile; attributes: cstring;
                            flags: GFileQueryInfoFlags;
                            cancellable: GCancellable; error: var GError): GFileEnumerator {.cdecl.}
    enumerateChildrenAsync*: proc (file: GFile; attributes: cstring;
                                 flags: GFileQueryInfoFlags; ioPriority: cint;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    enumerateChildrenFinish*: proc (file: GFile; res: GAsyncResult;
                                  error: var GError): GFileEnumerator {.cdecl.}
    queryInfo*: proc (file: GFile; attributes: cstring; flags: GFileQueryInfoFlags;
                    cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    queryInfoAsync*: proc (file: GFile; attributes: cstring;
                         flags: GFileQueryInfoFlags; ioPriority: cint;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    queryInfoFinish*: proc (file: GFile; res: GAsyncResult;
                          error: var GError): GFileInfo {.cdecl.}
    queryFilesystemInfo*: proc (file: GFile; attributes: cstring;
                              cancellable: GCancellable; error: var GError): GFileInfo {.cdecl.}
    queryFilesystemInfoAsync*: proc (file: GFile; attributes: cstring;
                                   ioPriority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.cdecl.}
    queryFilesystemInfoFinish*: proc (file: GFile; res: GAsyncResult;
                                    error: var GError): GFileInfo {.cdecl.}
    findEnclosingMount*: proc (file: GFile; cancellable: GCancellable;
                             error: var GError): GMount {.cdecl.}
    findEnclosingMountAsync*: proc (file: GFile; ioPriority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.cdecl.}
    findEnclosingMountFinish*: proc (file: GFile; res: GAsyncResult;
                                   error: var GError): GMount {.cdecl.}
    setDisplayName*: proc (file: GFile; displayName: cstring;
                         cancellable: GCancellable; error: var GError): GFile {.cdecl.}
    setDisplayNameAsync*: proc (file: GFile; displayName: cstring;
                              ioPriority: cint; cancellable: GCancellable;
                              callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    setDisplayNameFinish*: proc (file: GFile; res: GAsyncResult;
                               error: var GError): GFile {.cdecl.}
    querySettableAttributes*: proc (file: GFile; cancellable: GCancellable;
                                  error: var GError): GFileAttributeInfoList {.cdecl.}
    querySettableAttributesAsync*: proc () {.cdecl.}
    querySettableAttributesFinish*: proc () {.cdecl.}
    queryWritableNamespaces*: proc (file: GFile; cancellable: GCancellable;
                                  error: var GError): GFileAttributeInfoList {.cdecl.}
    queryWritableNamespacesAsync*: proc () {.cdecl.}
    queryWritableNamespacesFinish*: proc () {.cdecl.}
    setAttribute*: proc (file: GFile; attribute: cstring;
                       `type`: GFileAttributeType; valueP: Gpointer;
                       flags: GFileQueryInfoFlags; cancellable: GCancellable;
                       error: var GError): Gboolean {.cdecl.}
    setAttributesFromInfo*: proc (file: GFile; info: GFileInfo;
                                flags: GFileQueryInfoFlags;
                                cancellable: GCancellable;
                                error: var GError): Gboolean {.cdecl.}
    setAttributesAsync*: proc (file: GFile; info: GFileInfo;
                             flags: GFileQueryInfoFlags; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    setAttributesFinish*: proc (file: GFile; result: GAsyncResult;
                              info: var GFileInfo; error: var GError): Gboolean {.cdecl.}
    readFn*: proc (file: GFile; cancellable: GCancellable; error: var GError): GFileInputStream {.cdecl.}
    readAsync*: proc (file: GFile; ioPriority: cint; cancellable: GCancellable;
                    callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    readFinish*: proc (file: GFile; res: GAsyncResult; error: var GError): GFileInputStream {.cdecl.}
    appendTo*: proc (file: GFile; flags: GFileCreateFlags;
                   cancellable: GCancellable; error: var GError): GFileOutputStream {.cdecl.}
    appendToAsync*: proc (file: GFile; flags: GFileCreateFlags; ioPriority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    appendToFinish*: proc (file: GFile; res: GAsyncResult; error: var GError): GFileOutputStream {.cdecl.}
    create*: proc (file: GFile; flags: GFileCreateFlags;
                 cancellable: GCancellable; error: var GError): GFileOutputStream {.cdecl.}
    createAsync*: proc (file: GFile; flags: GFileCreateFlags; ioPriority: cint;
                      cancellable: GCancellable; callback: GAsyncReadyCallback;
                      userData: Gpointer) {.cdecl.}
    createFinish*: proc (file: GFile; res: GAsyncResult; error: var GError): GFileOutputStream {.cdecl.}
    replace*: proc (file: GFile; etag: cstring; makeBackup: Gboolean;
                  flags: GFileCreateFlags; cancellable: GCancellable;
                  error: var GError): GFileOutputStream {.cdecl.}
    replaceAsync*: proc (file: GFile; etag: cstring; makeBackup: Gboolean;
                       flags: GFileCreateFlags; ioPriority: cint;
                       cancellable: GCancellable;
                       callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    replaceFinish*: proc (file: GFile; res: GAsyncResult; error: var GError): GFileOutputStream {.cdecl.}
    deleteFile*: proc (file: GFile; cancellable: GCancellable;
                     error: var GError): Gboolean {.cdecl.}
    deleteFileAsync*: proc (file: GFile; ioPriority: cint;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    deleteFileFinish*: proc (file: GFile; result: GAsyncResult;
                           error: var GError): Gboolean {.cdecl.}
    trash*: proc (file: GFile; cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    trashAsync*: proc (file: GFile; ioPriority: cint;
                     cancellable: GCancellable; callback: GAsyncReadyCallback;
                     userData: Gpointer) {.cdecl.}
    trashFinish*: proc (file: GFile; result: GAsyncResult; error: var GError): Gboolean {.cdecl.}
    makeDirectory*: proc (file: GFile; cancellable: GCancellable;
                        error: var GError): Gboolean {.cdecl.}
    makeDirectoryAsync*: proc (file: GFile; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    makeDirectoryFinish*: proc (file: GFile; result: GAsyncResult;
                              error: var GError): Gboolean {.cdecl.}
    makeSymbolicLink*: proc (file: GFile; symlinkValue: cstring;
                           cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    makeSymbolicLinkAsync*: proc () {.cdecl.}
    makeSymbolicLinkFinish*: proc () {.cdecl.}
    copy*: proc (source: GFile; destination: GFile; flags: GFileCopyFlags;
               cancellable: GCancellable;
               progressCallback: GFileProgressCallback;
               progressCallbackData: Gpointer; error: var GError): Gboolean {.cdecl.}
    copyAsync*: proc (source: GFile; destination: GFile; flags: GFileCopyFlags;
                    ioPriority: cint; cancellable: GCancellable;
                    progressCallback: GFileProgressCallback;
                    progressCallbackData: Gpointer; callback: GAsyncReadyCallback;
                    userData: Gpointer) {.cdecl.}
    copyFinish*: proc (file: GFile; res: GAsyncResult; error: var GError): Gboolean {.cdecl.}
    move*: proc (source: GFile; destination: GFile; flags: GFileCopyFlags;
               cancellable: GCancellable;
               progressCallback: GFileProgressCallback;
               progressCallbackData: Gpointer; error: var GError): Gboolean {.cdecl.}
    moveAsync*: proc () {.cdecl.}
    moveFinish*: proc () {.cdecl.}
    mountMountable*: proc (file: GFile; flags: GMountMountFlags;
                         mountOperation: GMountOperation;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    mountMountableFinish*: proc (file: GFile; result: GAsyncResult;
                               error: var GError): GFile {.cdecl.}
    unmountMountable*: proc (file: GFile; flags: GMountUnmountFlags;
                           cancellable: GCancellable;
                           callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    unmountMountableFinish*: proc (file: GFile; result: GAsyncResult;
                                 error: var GError): Gboolean {.cdecl.}
    ejectMountable*: proc (file: GFile; flags: GMountUnmountFlags;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    ejectMountableFinish*: proc (file: GFile; result: GAsyncResult;
                               error: var GError): Gboolean {.cdecl.}
    mountEnclosingVolume*: proc (location: GFile; flags: GMountMountFlags;
                               mountOperation: GMountOperation;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    mountEnclosingVolumeFinish*: proc (location: GFile; result: GAsyncResult;
                                     error: var GError): Gboolean {.cdecl.}
    monitorDir*: proc (file: GFile; flags: GFileMonitorFlags;
                     cancellable: GCancellable; error: var GError): GFileMonitor {.cdecl.}
    monitorFile*: proc (file: GFile; flags: GFileMonitorFlags;
                      cancellable: GCancellable; error: var GError): GFileMonitor {.cdecl.}
    openReadwrite*: proc (file: GFile; cancellable: GCancellable;
                        error: var GError): GFileIOStream {.cdecl.}
    openReadwriteAsync*: proc (file: GFile; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    openReadwriteFinish*: proc (file: GFile; res: GAsyncResult;
                              error: var GError): GFileIOStream {.cdecl.}
    createReadwrite*: proc (file: GFile; flags: GFileCreateFlags;
                          cancellable: GCancellable; error: var GError): GFileIOStream {.cdecl.}
    createReadwriteAsync*: proc (file: GFile; flags: GFileCreateFlags;
                               ioPriority: cint; cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    createReadwriteFinish*: proc (file: GFile; res: GAsyncResult;
                                error: var GError): GFileIOStream {.cdecl.}
    replaceReadwrite*: proc (file: GFile; etag: cstring; makeBackup: Gboolean;
                           flags: GFileCreateFlags; cancellable: GCancellable;
                           error: var GError): GFileIOStream {.cdecl.}
    replaceReadwriteAsync*: proc (file: GFile; etag: cstring; makeBackup: Gboolean;
                                flags: GFileCreateFlags; ioPriority: cint;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    replaceReadwriteFinish*: proc (file: GFile; res: GAsyncResult;
                                 error: var GError): GFileIOStream {.cdecl.}
    startMountable*: proc (file: GFile; flags: GDriveStartFlags;
                         startOperation: GMountOperation;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    startMountableFinish*: proc (file: GFile; result: GAsyncResult;
                               error: var GError): Gboolean {.cdecl.}
    stopMountable*: proc (file: GFile; flags: GMountUnmountFlags;
                        mountOperation: GMountOperation;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    stopMountableFinish*: proc (file: GFile; result: GAsyncResult;
                              error: var GError): Gboolean {.cdecl.}
    supportsThreadContexts*: Gboolean
    unmountMountableWithOperation*: proc (file: GFile; flags: GMountUnmountFlags;
                                        mountOperation: GMountOperation;
                                        cancellable: GCancellable;
                                        callback: GAsyncReadyCallback;
                                        userData: Gpointer) {.cdecl.}
    unmountMountableWithOperationFinish*: proc (file: GFile;
        result: GAsyncResult; error: var GError): Gboolean {.cdecl.}
    ejectMountableWithOperation*: proc (file: GFile; flags: GMountUnmountFlags;
                                      mountOperation: GMountOperation;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      userData: Gpointer) {.cdecl.}
    ejectMountableWithOperationFinish*: proc (file: GFile;
        result: GAsyncResult; error: var GError): Gboolean {.cdecl.}
    pollMountable*: proc (file: GFile; cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    pollMountableFinish*: proc (file: GFile; result: GAsyncResult;
                              error: var GError): Gboolean {.cdecl.}
    measureDiskUsage*: proc (file: GFile; flags: GFileMeasureFlags;
                           cancellable: GCancellable;
                           progressCallback: GFileMeasureProgressCallback;
                           progressData: Gpointer; diskUsage: var uint64;
                           numDirs: var uint64; numFiles: var uint64;
                           error: var GError): Gboolean {.cdecl.}
    measureDiskUsageAsync*: proc (file: GFile; flags: GFileMeasureFlags;
                                ioPriority: cint; cancellable: GCancellable;
                                progressCallback: GFileMeasureProgressCallback;
                                progressData: Gpointer;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    measureDiskUsageFinish*: proc (file: GFile; result: GAsyncResult;
                                 diskUsage: var uint64; numDirs: var uint64;
                                 numFiles: var uint64; error: var GError): Gboolean {.cdecl.}

proc fileGetType*(): GType {.importc: "g_file_get_type", libgio.}
proc newFileForPath*(path: cstring): GFile {.importc: "g_file_new_for_path",
    libgio.}
proc newFileForURI*(uri: cstring): GFile {.importc: "g_file_new_for_uri",
    libgio.}
proc newFileForCommandlineArg*(arg: cstring): GFile {.
    importc: "g_file_new_for_commandline_arg", libgio.}
proc newFile*(arg: cstring; cwd: cstring): GFile {.
    importc: "g_file_new_for_commandline_arg_and_cwd", libgio.}
proc newFile*(tmpl: cstring; iostream: var GFileIOStream; error: var GError): GFile {.
    importc: "g_file_new_tmp", libgio.}
proc fileParseName*(parseName: cstring): GFile {.importc: "g_file_parse_name",
    libgio.}
proc dup*(file: GFile): GFile {.importc: "g_file_dup", libgio.}
proc fileHash*(file: Gconstpointer): cuint {.importc: "g_file_hash", libgio.}
proc equal*(file1: GFile; file2: GFile): Gboolean {.
    importc: "g_file_equal", libgio.}
proc getBasename*(file: GFile): cstring {.importc: "g_file_get_basename",
    libgio.}
proc basename*(file: GFile): cstring {.importc: "g_file_get_basename",
    libgio.}
proc getPath*(file: GFile): cstring {.importc: "g_file_get_path", libgio.}
proc path*(file: GFile): cstring {.importc: "g_file_get_path", libgio.}
proc getUri*(file: GFile): cstring {.importc: "g_file_get_uri", libgio.}
proc uri*(file: GFile): cstring {.importc: "g_file_get_uri", libgio.}
proc getParseName*(file: GFile): cstring {.importc: "g_file_get_parse_name",
    libgio.}
proc parseName*(file: GFile): cstring {.importc: "g_file_get_parse_name",
    libgio.}
proc getParent*(file: GFile): GFile {.importc: "g_file_get_parent",
    libgio.}
proc parent*(file: GFile): GFile {.importc: "g_file_get_parent",
    libgio.}
proc hasParent*(file: GFile; parent: GFile): Gboolean {.
    importc: "g_file_has_parent", libgio.}
proc getChild*(file: GFile; name: cstring): GFile {.
    importc: "g_file_get_child", libgio.}
proc child*(file: GFile; name: cstring): GFile {.
    importc: "g_file_get_child", libgio.}
proc getChildForDisplayName*(file: GFile; displayName: cstring;
                                 error: var GError): GFile {.
    importc: "g_file_get_child_for_display_name", libgio.}
proc childForDisplayName*(file: GFile; displayName: cstring;
                                 error: var GError): GFile {.
    importc: "g_file_get_child_for_display_name", libgio.}
proc hasPrefix*(file: GFile; prefix: GFile): Gboolean {.
    importc: "g_file_has_prefix", libgio.}
proc getRelativePath*(parent: GFile; descendant: GFile): cstring {.
    importc: "g_file_get_relative_path", libgio.}
proc relativePath*(parent: GFile; descendant: GFile): cstring {.
    importc: "g_file_get_relative_path", libgio.}
proc resolveRelativePath*(file: GFile; relativePath: cstring): GFile {.
    importc: "g_file_resolve_relative_path", libgio.}
proc isNative*(file: GFile): Gboolean {.importc: "g_file_is_native",
    libgio.}
proc hasUriScheme*(file: GFile; uriScheme: cstring): Gboolean {.
    importc: "g_file_has_uri_scheme", libgio.}
proc getUriScheme*(file: GFile): cstring {.importc: "g_file_get_uri_scheme",
    libgio.}
proc uriScheme*(file: GFile): cstring {.importc: "g_file_get_uri_scheme",
    libgio.}
proc read*(file: GFile; cancellable: GCancellable; error: var GError): GFileInputStream {.
    importc: "g_file_read", libgio.}
proc readAsync*(file: GFile; ioPriority: cint; cancellable: GCancellable;
                    callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_read_async", libgio.}
proc readFinish*(file: GFile; res: GAsyncResult; error: var GError): GFileInputStream {.
    importc: "g_file_read_finish", libgio.}
proc appendTo*(file: GFile; flags: GFileCreateFlags;
                   cancellable: GCancellable; error: var GError): GFileOutputStream {.
    importc: "g_file_append_to", libgio.}
proc create*(file: GFile; flags: GFileCreateFlags;
                 cancellable: GCancellable; error: var GError): GFileOutputStream {.
    importc: "g_file_create", libgio.}
proc replace*(file: GFile; etag: cstring; makeBackup: Gboolean;
                  flags: GFileCreateFlags; cancellable: GCancellable;
                  error: var GError): GFileOutputStream {.
    importc: "g_file_replace", libgio.}
proc appendToAsync*(file: GFile; flags: GFileCreateFlags; ioPriority: cint;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_append_to_async", libgio.}
proc appendToFinish*(file: GFile; res: GAsyncResult; error: var GError): GFileOutputStream {.
    importc: "g_file_append_to_finish", libgio.}
proc createAsync*(file: GFile; flags: GFileCreateFlags; ioPriority: cint;
                      cancellable: GCancellable; callback: GAsyncReadyCallback;
                      userData: Gpointer) {.importc: "g_file_create_async",
    libgio.}
proc createFinish*(file: GFile; res: GAsyncResult; error: var GError): GFileOutputStream {.
    importc: "g_file_create_finish", libgio.}
proc replaceAsync*(file: GFile; etag: cstring; makeBackup: Gboolean;
                       flags: GFileCreateFlags; ioPriority: cint;
                       cancellable: GCancellable;
                       callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_replace_async", libgio.}
proc replaceFinish*(file: GFile; res: GAsyncResult; error: var GError): GFileOutputStream {.
    importc: "g_file_replace_finish", libgio.}
proc openReadwrite*(file: GFile; cancellable: GCancellable;
                        error: var GError): GFileIOStream {.
    importc: "g_file_open_readwrite", libgio.}
proc openReadwriteAsync*(file: GFile; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_open_readwrite_async", libgio.}
proc openReadwriteFinish*(file: GFile; res: GAsyncResult;
                              error: var GError): GFileIOStream {.
    importc: "g_file_open_readwrite_finish", libgio.}
proc createReadwrite*(file: GFile; flags: GFileCreateFlags;
                          cancellable: GCancellable; error: var GError): GFileIOStream {.
    importc: "g_file_create_readwrite", libgio.}
proc createReadwriteAsync*(file: GFile; flags: GFileCreateFlags;
                               ioPriority: cint; cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_create_readwrite_async", libgio.}
proc createReadwriteFinish*(file: GFile; res: GAsyncResult;
                                error: var GError): GFileIOStream {.
    importc: "g_file_create_readwrite_finish", libgio.}
proc replaceReadwrite*(file: GFile; etag: cstring; makeBackup: Gboolean;
                           flags: GFileCreateFlags; cancellable: GCancellable;
                           error: var GError): GFileIOStream {.
    importc: "g_file_replace_readwrite", libgio.}
proc replaceReadwriteAsync*(file: GFile; etag: cstring; makeBackup: Gboolean;
                                flags: GFileCreateFlags; ioPriority: cint;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_replace_readwrite_async", libgio.}
proc replaceReadwriteFinish*(file: GFile; res: GAsyncResult;
                                 error: var GError): GFileIOStream {.
    importc: "g_file_replace_readwrite_finish", libgio.}
proc queryExists*(file: GFile; cancellable: GCancellable): Gboolean {.
    importc: "g_file_query_exists", libgio.}
proc queryFileType*(file: GFile; flags: GFileQueryInfoFlags;
                        cancellable: GCancellable): GFileType {.
    importc: "g_file_query_file_type", libgio.}
proc queryInfo*(file: GFile; attributes: cstring; flags: GFileQueryInfoFlags;
                    cancellable: GCancellable; error: var GError): GFileInfo {.
    importc: "g_file_query_info", libgio.}
proc queryInfoAsync*(file: GFile; attributes: cstring;
                         flags: GFileQueryInfoFlags; ioPriority: cint;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_query_info_async", libgio.}
proc queryInfoFinish*(file: GFile; res: GAsyncResult;
                          error: var GError): GFileInfo {.
    importc: "g_file_query_info_finish", libgio.}
proc queryFilesystemInfo*(file: GFile; attributes: cstring;
                              cancellable: GCancellable; error: var GError): GFileInfo {.
    importc: "g_file_query_filesystem_info", libgio.}
proc queryFilesystemInfoAsync*(file: GFile; attributes: cstring;
                                   ioPriority: cint;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_file_query_filesystem_info_async", libgio.}
proc queryFilesystemInfoFinish*(file: GFile; res: GAsyncResult;
                                    error: var GError): GFileInfo {.
    importc: "g_file_query_filesystem_info_finish", libgio.}
proc findEnclosingMount*(file: GFile; cancellable: GCancellable;
                             error: var GError): GMount {.
    importc: "g_file_find_enclosing_mount", libgio.}
proc findEnclosingMountAsync*(file: GFile; ioPriority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_file_find_enclosing_mount_async", libgio.}
proc findEnclosingMountFinish*(file: GFile; res: GAsyncResult;
                                   error: var GError): GMount {.
    importc: "g_file_find_enclosing_mount_finish", libgio.}
proc enumerateChildren*(file: GFile; attributes: cstring;
                            flags: GFileQueryInfoFlags;
                            cancellable: GCancellable; error: var GError): GFileEnumerator {.
    importc: "g_file_enumerate_children", libgio.}
proc enumerateChildrenAsync*(file: GFile; attributes: cstring;
                                 flags: GFileQueryInfoFlags; ioPriority: cint;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_enumerate_children_async", libgio.}
proc enumerateChildrenFinish*(file: GFile; res: GAsyncResult;
                                  error: var GError): GFileEnumerator {.
    importc: "g_file_enumerate_children_finish", libgio.}
proc setDisplayName*(file: GFile; displayName: cstring;
                         cancellable: GCancellable; error: var GError): GFile {.
    importc: "g_file_set_display_name", libgio.}
proc setDisplayNameAsync*(file: GFile; displayName: cstring;
                              ioPriority: cint; cancellable: GCancellable;
                              callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_set_display_name_async", libgio.}
proc `displayNameAsync=`*(file: GFile; displayName: cstring;
                              ioPriority: cint; cancellable: GCancellable;
                              callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_set_display_name_async", libgio.}
proc setDisplayNameFinish*(file: GFile; res: GAsyncResult;
                               error: var GError): GFile {.
    importc: "g_file_set_display_name_finish", libgio.}
proc delete*(file: GFile; cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_delete", libgio.}
proc deleteAsync*(file: GFile; ioPriority: cint;
                      cancellable: GCancellable; callback: GAsyncReadyCallback;
                      userData: Gpointer) {.importc: "g_file_delete_async",
    libgio.}
proc deleteFinish*(file: GFile; result: GAsyncResult;
                       error: var GError): Gboolean {.
    importc: "g_file_delete_finish", libgio.}
proc trash*(file: GFile; cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_trash", libgio.}
proc trashAsync*(file: GFile; ioPriority: cint;
                     cancellable: GCancellable; callback: GAsyncReadyCallback;
                     userData: Gpointer) {.importc: "g_file_trash_async",
    libgio.}
proc trashFinish*(file: GFile; result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_file_trash_finish", libgio.}
proc copy*(source: GFile; destination: GFile; flags: GFileCopyFlags;
               cancellable: GCancellable;
               progressCallback: GFileProgressCallback;
               progressCallbackData: Gpointer; error: var GError): Gboolean {.
    importc: "g_file_copy", libgio.}
proc copyAsync*(source: GFile; destination: GFile; flags: GFileCopyFlags;
                    ioPriority: cint; cancellable: GCancellable;
                    progressCallback: GFileProgressCallback;
                    progressCallbackData: Gpointer; callback: GAsyncReadyCallback;
                    userData: Gpointer) {.importc: "g_file_copy_async", libgio.}
proc copyFinish*(file: GFile; res: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_file_copy_finish", libgio.}
proc move*(source: GFile; destination: GFile; flags: GFileCopyFlags;
               cancellable: GCancellable;
               progressCallback: GFileProgressCallback;
               progressCallbackData: Gpointer; error: var GError): Gboolean {.
    importc: "g_file_move", libgio.}
proc makeDirectory*(file: GFile; cancellable: GCancellable;
                        error: var GError): Gboolean {.
    importc: "g_file_make_directory", libgio.}
proc makeDirectoryAsync*(file: GFile; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_make_directory_async", libgio.}
proc makeDirectoryFinish*(file: GFile; result: GAsyncResult;
                              error: var GError): Gboolean {.
    importc: "g_file_make_directory_finish", libgio.}
proc makeDirectoryWithParents*(file: GFile; cancellable: GCancellable;
                                   error: var GError): Gboolean {.
    importc: "g_file_make_directory_with_parents", libgio.}
proc makeSymbolicLink*(file: GFile; symlinkValue: cstring;
                           cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_make_symbolic_link", libgio.}
proc querySettableAttributes*(file: GFile; cancellable: GCancellable;
                                  error: var GError): GFileAttributeInfoList {.
    importc: "g_file_query_settable_attributes", libgio.}
proc queryWritableNamespaces*(file: GFile; cancellable: GCancellable;
                                  error: var GError): GFileAttributeInfoList {.
    importc: "g_file_query_writable_namespaces", libgio.}
proc setAttribute*(file: GFile; attribute: cstring;
                       `type`: GFileAttributeType; valueP: Gpointer;
                       flags: GFileQueryInfoFlags; cancellable: GCancellable;
                       error: var GError): Gboolean {.
    importc: "g_file_set_attribute", libgio.}
proc setAttributesFromInfo*(file: GFile; info: GFileInfo;
                                flags: GFileQueryInfoFlags;
                                cancellable: GCancellable;
                                error: var GError): Gboolean {.
    importc: "g_file_set_attributes_from_info", libgio.}
proc setAttributesAsync*(file: GFile; info: GFileInfo;
                             flags: GFileQueryInfoFlags; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_set_attributes_async", libgio.}
proc `attributesAsync=`*(file: GFile; info: GFileInfo;
                             flags: GFileQueryInfoFlags; ioPriority: cint;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_set_attributes_async", libgio.}
proc setAttributesFinish*(file: GFile; result: GAsyncResult;
                              info: var GFileInfo; error: var GError): Gboolean {.
    importc: "g_file_set_attributes_finish", libgio.}
proc setAttributeString*(file: GFile; attribute: cstring; value: cstring;
                             flags: GFileQueryInfoFlags;
                             cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_set_attribute_string", libgio.}
proc setAttributeByteString*(file: GFile; attribute: cstring; value: cstring;
                                 flags: GFileQueryInfoFlags;
                                 cancellable: GCancellable;
                                 error: var GError): Gboolean {.
    importc: "g_file_set_attribute_byte_string", libgio.}
proc setAttributeUint32*(file: GFile; attribute: cstring; value: uint32;
                             flags: GFileQueryInfoFlags;
                             cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_set_attribute_uint32", libgio.}
proc setAttributeInt32*(file: GFile; attribute: cstring; value: int32;
                            flags: GFileQueryInfoFlags;
                            cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_set_attribute_int32", libgio.}
proc setAttributeUint64*(file: GFile; attribute: cstring; value: uint64;
                             flags: GFileQueryInfoFlags;
                             cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_set_attribute_uint64", libgio.}
proc setAttributeInt64*(file: GFile; attribute: cstring; value: int64;
                            flags: GFileQueryInfoFlags;
                            cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_set_attribute_int64", libgio.}
proc mountEnclosingVolume*(location: GFile; flags: GMountMountFlags;
                               mountOperation: GMountOperation;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_mount_enclosing_volume", libgio.}
proc mountEnclosingVolumeFinish*(location: GFile; result: GAsyncResult;
                                     error: var GError): Gboolean {.
    importc: "g_file_mount_enclosing_volume_finish", libgio.}
proc mountMountable*(file: GFile; flags: GMountMountFlags;
                         mountOperation: GMountOperation;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_mount_mountable", libgio.}
proc mountMountableFinish*(file: GFile; result: GAsyncResult;
                               error: var GError): GFile {.
    importc: "g_file_mount_mountable_finish", libgio.}
proc unmountMountable*(file: GFile; flags: GMountUnmountFlags;
                           cancellable: GCancellable;
                           callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_unmount_mountable", libgio.}
proc unmountMountableFinish*(file: GFile; result: GAsyncResult;
                                 error: var GError): Gboolean {.
    importc: "g_file_unmount_mountable_finish", libgio.}
proc unmountMountableWithOperation*(file: GFile; flags: GMountUnmountFlags;
                                        mountOperation: GMountOperation;
                                        cancellable: GCancellable;
                                        callback: GAsyncReadyCallback;
                                        userData: Gpointer) {.
    importc: "g_file_unmount_mountable_with_operation", libgio.}
proc unmountMountableWithOperationFinish*(file: GFile;
    result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_file_unmount_mountable_with_operation_finish", libgio.}
proc ejectMountable*(file: GFile; flags: GMountUnmountFlags;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_eject_mountable", libgio.}
proc ejectMountableFinish*(file: GFile; result: GAsyncResult;
                               error: var GError): Gboolean {.
    importc: "g_file_eject_mountable_finish", libgio.}
proc ejectMountableWithOperation*(file: GFile; flags: GMountUnmountFlags;
                                      mountOperation: GMountOperation;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      userData: Gpointer) {.
    importc: "g_file_eject_mountable_with_operation", libgio.}
proc ejectMountableWithOperationFinish*(file: GFile;
    result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_file_eject_mountable_with_operation_finish", libgio.}
proc copyAttributes*(source: GFile; destination: GFile;
                         flags: GFileCopyFlags; cancellable: GCancellable;
                         error: var GError): Gboolean {.
    importc: "g_file_copy_attributes", libgio.}
proc monitorDirectory*(file: GFile; flags: GFileMonitorFlags;
                           cancellable: GCancellable; error: var GError): GFileMonitor {.
    importc: "g_file_monitor_directory", libgio.}
proc monitorFile*(file: GFile; flags: GFileMonitorFlags;
                      cancellable: GCancellable; error: var GError): GFileMonitor {.
    importc: "g_file_monitor_file", libgio.}
proc monitor*(file: GFile; flags: GFileMonitorFlags;
                  cancellable: GCancellable; error: var GError): GFileMonitor {.
    importc: "g_file_monitor", libgio.}
proc measureDiskUsage*(file: GFile; flags: GFileMeasureFlags;
                           cancellable: GCancellable;
                           progressCallback: GFileMeasureProgressCallback;
                           progressData: Gpointer; diskUsage: var uint64;
                           numDirs: var uint64; numFiles: var uint64;
                           error: var GError): Gboolean {.
    importc: "g_file_measure_disk_usage", libgio.}
proc measureDiskUsageAsync*(file: GFile; flags: GFileMeasureFlags;
                                ioPriority: cint; cancellable: GCancellable;
                                progressCallback: GFileMeasureProgressCallback;
                                progressData: Gpointer;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_measure_disk_usage_async", libgio.}
proc measureDiskUsageFinish*(file: GFile; result: GAsyncResult;
                                 diskUsage: var uint64; numDirs: var uint64;
                                 numFiles: var uint64; error: var GError): Gboolean {.
    importc: "g_file_measure_disk_usage_finish", libgio.}
proc startMountable*(file: GFile; flags: GDriveStartFlags;
                         startOperation: GMountOperation;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_start_mountable", libgio.}
proc startMountableFinish*(file: GFile; result: GAsyncResult;
                               error: var GError): Gboolean {.
    importc: "g_file_start_mountable_finish", libgio.}
proc stopMountable*(file: GFile; flags: GMountUnmountFlags;
                        mountOperation: GMountOperation;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_stop_mountable", libgio.}
proc stopMountableFinish*(file: GFile; result: GAsyncResult;
                              error: var GError): Gboolean {.
    importc: "g_file_stop_mountable_finish", libgio.}
proc pollMountable*(file: GFile; cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_poll_mountable", libgio.}
proc pollMountableFinish*(file: GFile; result: GAsyncResult;
                              error: var GError): Gboolean {.
    importc: "g_file_poll_mountable_finish", libgio.}

proc queryDefaultHandler*(file: GFile; cancellable: GCancellable;
                              error: var GError): GAppInfo {.
    importc: "g_file_query_default_handler", libgio.}
proc loadContents*(file: GFile; cancellable: GCancellable;
                       contents: var cstring; length: var Gsize;
                       etagOut: cstringArray; error: var GError): Gboolean {.
    importc: "g_file_load_contents", libgio.}
proc loadContentsAsync*(file: GFile; cancellable: GCancellable;
                            callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_load_contents_async", libgio.}
proc loadContentsFinish*(file: GFile; res: GAsyncResult;
                             contents: var cstring; length: var Gsize;
                             etagOut: cstringArray; error: var GError): Gboolean {.
    importc: "g_file_load_contents_finish", libgio.}
proc loadPartialContentsAsync*(file: GFile; cancellable: GCancellable;
                                   readMoreCallback: GFileReadMoreCallback;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_file_load_partial_contents_async", libgio.}
proc loadPartialContentsFinish*(file: GFile; res: GAsyncResult;
                                    contents: var cstring; length: var Gsize;
                                    etagOut: cstringArray; error: var GError): Gboolean {.
    importc: "g_file_load_partial_contents_finish", libgio.}
proc replaceContents*(file: GFile; contents: cstring; length: Gsize;
                          etag: cstring; makeBackup: Gboolean;
                          flags: GFileCreateFlags; newEtag: cstringArray;
                          cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_file_replace_contents", libgio.}
proc replaceContentsAsync*(file: GFile; contents: cstring; length: Gsize;
                               etag: cstring; makeBackup: Gboolean;
                               flags: GFileCreateFlags;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_replace_contents_async", libgio.}
proc replaceContentsBytesAsync*(file: GFile; contents: glib.GBytes;
                                    etag: cstring; makeBackup: Gboolean;
                                    flags: GFileCreateFlags;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    userData: Gpointer) {.
    importc: "g_file_replace_contents_bytes_async", libgio.}
proc replaceContentsFinish*(file: GFile; res: GAsyncResult;
                                newEtag: cstringArray; error: var GError): Gboolean {.
    importc: "g_file_replace_contents_finish", libgio.}
proc supportsThreadContexts*(file: GFile): Gboolean {.
    importc: "g_file_supports_thread_contexts", libgio.}

template gTypeFileIcon*(): untyped =
  (fileIconGetType())

template gFileIcon*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFileIcon, GFileIconObj))

template gFileIconClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFileIcon, GFileIconClassObj))

template gIsFileIcon*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFileIcon))

template gIsFileIconClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFileIcon))

template gFileIconGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFileIcon, GFileIconClassObj))

type
  GFileIconClass* =  ptr GFileIconClassObj
  GFileIconClassPtr* = ptr GFileIconClassObj
  GFileIconClassObj* = object

proc fileIconGetType*(): GType {.importc: "g_file_icon_get_type", libgio.}
proc newIcon*(file: GFile): GIcon {.importc: "g_file_icon_new", libgio.}
proc getFile*(icon: GFileIcon): GFile {.
    importc: "g_file_icon_get_file", libgio.}
proc file*(icon: GFileIcon): GFile {.
    importc: "g_file_icon_get_file", libgio.}

template gTypeFileInfo*(): untyped =
  (fileInfoGetType())

template gFileInfo*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFileInfo, GFileInfoObj))

template gFileInfoClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFileInfo, GFileInfoClassObj))

template gIsFileInfo*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFileInfo))

template gIsFileInfoClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFileInfo))

template gFileInfoGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFileInfo, GFileInfoClassObj))

type
  GFileInfoClass* =  ptr GFileInfoClassObj
  GFileInfoClassPtr* = ptr GFileInfoClassObj
  GFileInfoClassObj* = object

const
  G_FILE_ATTRIBUTE_STANDARD_TYPE* = "standard::type"

const
  G_FILE_ATTRIBUTE_STANDARD_IS_HIDDEN* = "standard::is-hidden"

const
  G_FILE_ATTRIBUTE_STANDARD_IS_BACKUP* = "standard::is-backup"

const
  G_FILE_ATTRIBUTE_STANDARD_IS_SYMLINK* = "standard::is-symlink"

const
  G_FILE_ATTRIBUTE_STANDARD_IS_VIRTUAL* = "standard::is-virtual"

const
  G_FILE_ATTRIBUTE_STANDARD_IS_VOLATILE* = "standard::is-volatile"

const
  G_FILE_ATTRIBUTE_STANDARD_NAME* = "standard::name"

const
  G_FILE_ATTRIBUTE_STANDARD_DISPLAY_NAME* = "standard::display-name"

const
  G_FILE_ATTRIBUTE_STANDARD_EDIT_NAME* = "standard::edit-name"

const
  G_FILE_ATTRIBUTE_STANDARD_COPY_NAME* = "standard::copy-name"

const
  G_FILE_ATTRIBUTE_STANDARD_DESCRIPTION* = "standard::description"

const
  G_FILE_ATTRIBUTE_STANDARD_ICON* = "standard::icon"

const
  G_FILE_ATTRIBUTE_STANDARD_SYMBOLIC_ICON* = "standard::symbolic-icon"

const
  G_FILE_ATTRIBUTE_STANDARD_CONTENT_TYPE* = "standard::content-type"

const
  G_FILE_ATTRIBUTE_STANDARD_FAST_CONTENT_TYPE* = "standard::fast-content-type"

const
  G_FILE_ATTRIBUTE_STANDARD_SIZE* = "standard::size"

const
  G_FILE_ATTRIBUTE_STANDARD_ALLOCATED_SIZE* = "standard::allocated-size"

const
  G_FILE_ATTRIBUTE_STANDARD_SYMLINK_TARGET* = "standard::symlink-target"

const
  G_FILE_ATTRIBUTE_STANDARD_TARGET_URI* = "standard::target-uri"

const
  G_FILE_ATTRIBUTE_STANDARD_SORT_ORDER* = "standard::sort-order"

const
  G_FILE_ATTRIBUTE_ETAG_VALUE* = "etag::value"

const
  G_FILE_ATTRIBUTE_ID_FILE* = "id::file"

const
  G_FILE_ATTRIBUTE_ID_FILESYSTEM* = "id::filesystem"

const
  G_FILE_ATTRIBUTE_ACCESS_CAN_READ* = "access::can-read"

const
  G_FILE_ATTRIBUTE_ACCESS_CAN_WRITE* = "access::can-write"

const
  G_FILE_ATTRIBUTE_ACCESS_CAN_EXECUTE* = "access::can-execute"

const
  G_FILE_ATTRIBUTE_ACCESS_CAN_DELETE* = "access::can-delete"

const
  G_FILE_ATTRIBUTE_ACCESS_CAN_TRASH* = "access::can-trash"

const
  G_FILE_ATTRIBUTE_ACCESS_CAN_RENAME* = "access::can-rename"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_MOUNT* = "mountable::can-mount"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_UNMOUNT* = "mountable::can-unmount"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_EJECT* = "mountable::can-eject"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_UNIX_DEVICE* = "mountable::unix-device"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_UNIX_DEVICE_FILE* = "mountable::unix-device-file"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_HAL_UDI* = "mountable::hal-udi"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_START* = "mountable::can-start"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_START_DEGRADED* = "mountable::can-start-degraded"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_STOP* = "mountable::can-stop"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_START_STOP_TYPE* = "mountable::start-stop-type"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_CAN_POLL* = "mountable::can-poll"

const
  G_FILE_ATTRIBUTE_MOUNTABLE_IS_MEDIA_CHECK_AUTOMATIC* = "mountable::is-media-check-automatic"

const
  G_FILE_ATTRIBUTE_TIME_MODIFIED* = "time::modified"

const
  G_FILE_ATTRIBUTE_TIME_MODIFIED_USEC* = "time::modified-usec"

const
  G_FILE_ATTRIBUTE_TIME_ACCESS* = "time::access"

const
  G_FILE_ATTRIBUTE_TIME_ACCESS_USEC* = "time::access-usec"

const
  G_FILE_ATTRIBUTE_TIME_CHANGED* = "time::changed"

const
  G_FILE_ATTRIBUTE_TIME_CHANGED_USEC* = "time::changed-usec"

const
  G_FILE_ATTRIBUTE_TIME_CREATED* = "time::created"

const
  G_FILE_ATTRIBUTE_TIME_CREATED_USEC* = "time::created-usec"

const
  G_FILE_ATTRIBUTE_UNIX_DEVICE* = "unix::device"

const
  G_FILE_ATTRIBUTE_UNIX_INODE* = "unix::inode"

const
  G_FILE_ATTRIBUTE_UNIX_MODE* = "unix::mode"

const
  G_FILE_ATTRIBUTE_UNIX_NLINK* = "unix::nlink"

const
  G_FILE_ATTRIBUTE_UNIX_UID* = "unix::uid"

const
  G_FILE_ATTRIBUTE_UNIX_GID* = "unix::gid"

const
  G_FILE_ATTRIBUTE_UNIX_RDEV* = "unix::rdev"

const
  G_FILE_ATTRIBUTE_UNIX_BLOCK_SIZE* = "unix::block-size"

const
  G_FILE_ATTRIBUTE_UNIX_BLOCKS* = "unix::blocks"

const
  G_FILE_ATTRIBUTE_UNIX_IS_MOUNTPOINT* = "unix::is-mountpoint"

const
  G_FILE_ATTRIBUTE_DOS_IS_ARCHIVE* = "dos::is-archive"

const
  G_FILE_ATTRIBUTE_DOS_IS_SYSTEM* = "dos::is-system"

const
  G_FILE_ATTRIBUTE_OWNER_USER* = "owner::user"

const
  G_FILE_ATTRIBUTE_OWNER_USER_REAL* = "owner::user-real"

const
  G_FILE_ATTRIBUTE_OWNER_GROUP* = "owner::group"

const
  G_FILE_ATTRIBUTE_THUMBNAIL_PATH* = "thumbnail::path"

const
  G_FILE_ATTRIBUTE_THUMBNAILING_FAILED* = "thumbnail::failed"

const
  G_FILE_ATTRIBUTE_THUMBNAIL_IS_VALID* = "thumbnail::is-valid"

const
  G_FILE_ATTRIBUTE_PREVIEW_ICON* = "preview::icon"

const
  G_FILE_ATTRIBUTE_FILESYSTEM_SIZE* = "filesystem::size"

const
  G_FILE_ATTRIBUTE_FILESYSTEM_FREE* = "filesystem::free"

const
  G_FILE_ATTRIBUTE_FILESYSTEM_USED* = "filesystem::used"

const
  G_FILE_ATTRIBUTE_FILESYSTEM_TYPE* = "filesystem::type"

const
  G_FILE_ATTRIBUTE_FILESYSTEM_READONLY* = "filesystem::readonly"

const
  G_FILE_ATTRIBUTE_FILESYSTEM_USE_PREVIEW* = "filesystem::use-preview"

const
  G_FILE_ATTRIBUTE_FILESYSTEM_REMOTE* = "filesystem::remote"

const
  G_FILE_ATTRIBUTE_GVFS_BACKEND* = "gvfs::backend"

const
  G_FILE_ATTRIBUTE_SELINUX_CONTEXT* = "selinux::context"

const
  G_FILE_ATTRIBUTE_TRASH_ITEM_COUNT* = "trash::item-count"

const
  G_FILE_ATTRIBUTE_TRASH_ORIG_PATH* = "trash::orig-path"

const
  G_FILE_ATTRIBUTE_TRASH_DELETION_DATE* = "trash::deletion-date"

const
  G_FILE_ATTRIBUTE_RECENT_MODIFIED* = "recent::modified"

proc fileInfoGetType*(): GType {.importc: "g_file_info_get_type", libgio.}
proc newFileInfo*(): GFileInfo {.importc: "g_file_info_new", libgio.}
proc dup*(other: GFileInfo): GFileInfo {.importc: "g_file_info_dup",
    libgio.}
proc copyInto*(srcInfo: GFileInfo; destInfo: GFileInfo) {.
    importc: "g_file_info_copy_into", libgio.}
proc hasAttribute*(info: GFileInfo; attribute: cstring): Gboolean {.
    importc: "g_file_info_has_attribute", libgio.}
proc hasNamespace*(info: GFileInfo; nameSpace: cstring): Gboolean {.
    importc: "g_file_info_has_namespace", libgio.}
proc listAttributes*(info: GFileInfo; nameSpace: cstring): cstringArray {.
    importc: "g_file_info_list_attributes", libgio.}
proc getAttributeData*(info: GFileInfo; attribute: cstring;
                               `type`: ptr GFileAttributeType;
                               valuePp: var Gpointer;
                               status: ptr GFileAttributeStatus): Gboolean {.
    importc: "g_file_info_get_attribute_data", libgio.}
proc attributeData*(info: GFileInfo; attribute: cstring;
                               `type`: ptr GFileAttributeType;
                               valuePp: var Gpointer;
                               status: ptr GFileAttributeStatus): Gboolean {.
    importc: "g_file_info_get_attribute_data", libgio.}
proc getAttributeType*(info: GFileInfo; attribute: cstring): GFileAttributeType {.
    importc: "g_file_info_get_attribute_type", libgio.}
proc attributeType*(info: GFileInfo; attribute: cstring): GFileAttributeType {.
    importc: "g_file_info_get_attribute_type", libgio.}
proc removeAttribute*(info: GFileInfo; attribute: cstring) {.
    importc: "g_file_info_remove_attribute", libgio.}
proc getAttributeStatus*(info: GFileInfo; attribute: cstring): GFileAttributeStatus {.
    importc: "g_file_info_get_attribute_status", libgio.}
proc attributeStatus*(info: GFileInfo; attribute: cstring): GFileAttributeStatus {.
    importc: "g_file_info_get_attribute_status", libgio.}
proc setAttributeStatus*(info: GFileInfo; attribute: cstring;
                                 status: GFileAttributeStatus): Gboolean {.
    importc: "g_file_info_set_attribute_status", libgio.}
proc getAttributeAsString*(info: GFileInfo; attribute: cstring): cstring {.
    importc: "g_file_info_get_attribute_as_string", libgio.}
proc attributeAsString*(info: GFileInfo; attribute: cstring): cstring {.
    importc: "g_file_info_get_attribute_as_string", libgio.}
proc getAttributeString*(info: GFileInfo; attribute: cstring): cstring {.
    importc: "g_file_info_get_attribute_string", libgio.}
proc attributeString*(info: GFileInfo; attribute: cstring): cstring {.
    importc: "g_file_info_get_attribute_string", libgio.}
proc getAttributeByteString*(info: GFileInfo; attribute: cstring): cstring {.
    importc: "g_file_info_get_attribute_byte_string", libgio.}
proc attributeByteString*(info: GFileInfo; attribute: cstring): cstring {.
    importc: "g_file_info_get_attribute_byte_string", libgio.}
proc getAttributeBoolean*(info: GFileInfo; attribute: cstring): Gboolean {.
    importc: "g_file_info_get_attribute_boolean", libgio.}
proc attributeBoolean*(info: GFileInfo; attribute: cstring): Gboolean {.
    importc: "g_file_info_get_attribute_boolean", libgio.}
proc getAttributeUint32*(info: GFileInfo; attribute: cstring): uint32 {.
    importc: "g_file_info_get_attribute_uint32", libgio.}
proc attributeUint32*(info: GFileInfo; attribute: cstring): uint32 {.
    importc: "g_file_info_get_attribute_uint32", libgio.}
proc getAttributeInt32*(info: GFileInfo; attribute: cstring): int32 {.
    importc: "g_file_info_get_attribute_int32", libgio.}
proc attributeInt32*(info: GFileInfo; attribute: cstring): int32 {.
    importc: "g_file_info_get_attribute_int32", libgio.}
proc getAttributeUint64*(info: GFileInfo; attribute: cstring): uint64 {.
    importc: "g_file_info_get_attribute_uint64", libgio.}
proc attributeUint64*(info: GFileInfo; attribute: cstring): uint64 {.
    importc: "g_file_info_get_attribute_uint64", libgio.}
proc getAttributeInt64*(info: GFileInfo; attribute: cstring): int64 {.
    importc: "g_file_info_get_attribute_int64", libgio.}
proc attributeInt64*(info: GFileInfo; attribute: cstring): int64 {.
    importc: "g_file_info_get_attribute_int64", libgio.}
proc getAttributeObject*(info: GFileInfo; attribute: cstring): GObject {.
    importc: "g_file_info_get_attribute_object", libgio.}
proc attributeObject*(info: GFileInfo; attribute: cstring): GObject {.
    importc: "g_file_info_get_attribute_object", libgio.}
proc getAttributeStringv*(info: GFileInfo; attribute: cstring): cstringArray {.
    importc: "g_file_info_get_attribute_stringv", libgio.}
proc attributeStringv*(info: GFileInfo; attribute: cstring): cstringArray {.
    importc: "g_file_info_get_attribute_stringv", libgio.}
proc setAttribute*(info: GFileInfo; attribute: cstring;
                           `type`: GFileAttributeType; valueP: Gpointer) {.
    importc: "g_file_info_set_attribute", libgio.}
proc `attribute=`*(info: GFileInfo; attribute: cstring;
                           `type`: GFileAttributeType; valueP: Gpointer) {.
    importc: "g_file_info_set_attribute", libgio.}
proc setAttributeString*(info: GFileInfo; attribute: cstring;
                                 attrValue: cstring) {.
    importc: "g_file_info_set_attribute_string", libgio.}
proc `attributeString=`*(info: GFileInfo; attribute: cstring;
                                 attrValue: cstring) {.
    importc: "g_file_info_set_attribute_string", libgio.}
proc setAttributeByteString*(info: GFileInfo; attribute: cstring;
                                     attrValue: cstring) {.
    importc: "g_file_info_set_attribute_byte_string", libgio.}
proc `attributeByteString=`*(info: GFileInfo; attribute: cstring;
                                     attrValue: cstring) {.
    importc: "g_file_info_set_attribute_byte_string", libgio.}
proc setAttributeBoolean*(info: GFileInfo; attribute: cstring;
                                  attrValue: Gboolean) {.
    importc: "g_file_info_set_attribute_boolean", libgio.}
proc `attributeBoolean=`*(info: GFileInfo; attribute: cstring;
                                  attrValue: Gboolean) {.
    importc: "g_file_info_set_attribute_boolean", libgio.}
proc setAttributeUint32*(info: GFileInfo; attribute: cstring;
                                 attrValue: uint32) {.
    importc: "g_file_info_set_attribute_uint32", libgio.}
proc `attributeUint32=`*(info: GFileInfo; attribute: cstring;
                                 attrValue: uint32) {.
    importc: "g_file_info_set_attribute_uint32", libgio.}
proc setAttributeInt32*(info: GFileInfo; attribute: cstring;
                                attrValue: int32) {.
    importc: "g_file_info_set_attribute_int32", libgio.}
proc `attributeInt32=`*(info: GFileInfo; attribute: cstring;
                                attrValue: int32) {.
    importc: "g_file_info_set_attribute_int32", libgio.}
proc setAttributeUint64*(info: GFileInfo; attribute: cstring;
                                 attrValue: uint64) {.
    importc: "g_file_info_set_attribute_uint64", libgio.}
proc `attributeUint64=`*(info: GFileInfo; attribute: cstring;
                                 attrValue: uint64) {.
    importc: "g_file_info_set_attribute_uint64", libgio.}
proc setAttributeInt64*(info: GFileInfo; attribute: cstring;
                                attrValue: int64) {.
    importc: "g_file_info_set_attribute_int64", libgio.}
proc `attributeInt64=`*(info: GFileInfo; attribute: cstring;
                                attrValue: int64) {.
    importc: "g_file_info_set_attribute_int64", libgio.}
proc setAttributeObject*(info: GFileInfo; attribute: cstring;
                                 attrValue: GObject) {.
    importc: "g_file_info_set_attribute_object", libgio.}
proc `attributeObject=`*(info: GFileInfo; attribute: cstring;
                                 attrValue: GObject) {.
    importc: "g_file_info_set_attribute_object", libgio.}
proc setAttributeStringv*(info: GFileInfo; attribute: cstring;
                                  attrValue: cstringArray) {.
    importc: "g_file_info_set_attribute_stringv", libgio.}
proc `attributeStringv=`*(info: GFileInfo; attribute: cstring;
                                  attrValue: cstringArray) {.
    importc: "g_file_info_set_attribute_stringv", libgio.}
proc clearStatus*(info: GFileInfo) {.
    importc: "g_file_info_clear_status", libgio.}

proc getDeletionDate*(info: GFileInfo): glib.GDateTime {.
    importc: "g_file_info_get_deletion_date", libgio.}

proc deletionDate*(info: GFileInfo): glib.GDateTime {.
    importc: "g_file_info_get_deletion_date", libgio.}
proc getFileType*(info: GFileInfo): GFileType {.
    importc: "g_file_info_get_file_type", libgio.}
proc fileType*(info: GFileInfo): GFileType {.
    importc: "g_file_info_get_file_type", libgio.}
proc getIsHidden*(info: GFileInfo): Gboolean {.
    importc: "g_file_info_get_is_hidden", libgio.}
proc isHidden*(info: GFileInfo): Gboolean {.
    importc: "g_file_info_get_is_hidden", libgio.}
proc getIsBackup*(info: GFileInfo): Gboolean {.
    importc: "g_file_info_get_is_backup", libgio.}
proc isBackup*(info: GFileInfo): Gboolean {.
    importc: "g_file_info_get_is_backup", libgio.}
proc getIsSymlink*(info: GFileInfo): Gboolean {.
    importc: "g_file_info_get_is_symlink", libgio.}
proc isSymlink*(info: GFileInfo): Gboolean {.
    importc: "g_file_info_get_is_symlink", libgio.}
proc getName*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_name", libgio.}
proc name*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_name", libgio.}
proc getDisplayName*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_display_name", libgio.}
proc displayName*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_display_name", libgio.}
proc getEditName*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_edit_name", libgio.}
proc editName*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_edit_name", libgio.}
proc getIcon*(info: GFileInfo): GIcon {.
    importc: "g_file_info_get_icon", libgio.}
proc icon*(info: GFileInfo): GIcon {.
    importc: "g_file_info_get_icon", libgio.}
proc getSymbolicIcon*(info: GFileInfo): GIcon {.
    importc: "g_file_info_get_symbolic_icon", libgio.}
proc symbolicIcon*(info: GFileInfo): GIcon {.
    importc: "g_file_info_get_symbolic_icon", libgio.}
proc getContentType*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_content_type", libgio.}
proc contentType*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_content_type", libgio.}
proc getSize*(info: GFileInfo): Goffset {.
    importc: "g_file_info_get_size", libgio.}
proc size*(info: GFileInfo): Goffset {.
    importc: "g_file_info_get_size", libgio.}
proc getModificationTime*(info: GFileInfo; result: var glib.GTimeValObj) {.
    importc: "g_file_info_get_modification_time", libgio.}
proc getSymlinkTarget*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_symlink_target", libgio.}
proc symlinkTarget*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_symlink_target", libgio.}
proc getEtag*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_etag", libgio.}
proc etag*(info: GFileInfo): cstring {.
    importc: "g_file_info_get_etag", libgio.}
proc getSortOrder*(info: GFileInfo): int32 {.
    importc: "g_file_info_get_sort_order", libgio.}
proc sortOrder*(info: GFileInfo): int32 {.
    importc: "g_file_info_get_sort_order", libgio.}
proc setAttributeMask*(info: GFileInfo; mask: GFileAttributeMatcher) {.
    importc: "g_file_info_set_attribute_mask", libgio.}
proc `attributeMask=`*(info: GFileInfo; mask: GFileAttributeMatcher) {.
    importc: "g_file_info_set_attribute_mask", libgio.}
proc unsetAttributeMask*(info: GFileInfo) {.
    importc: "g_file_info_unset_attribute_mask", libgio.}

proc setFileType*(info: GFileInfo; `type`: GFileType) {.
    importc: "g_file_info_set_file_type", libgio.}

proc `fileType=`*(info: GFileInfo; `type`: GFileType) {.
    importc: "g_file_info_set_file_type", libgio.}
proc setIsHidden*(info: GFileInfo; isHidden: Gboolean) {.
    importc: "g_file_info_set_is_hidden", libgio.}
proc `isHidden=`*(info: GFileInfo; isHidden: Gboolean) {.
    importc: "g_file_info_set_is_hidden", libgio.}
proc setIsSymlink*(info: GFileInfo; isSymlink: Gboolean) {.
    importc: "g_file_info_set_is_symlink", libgio.}
proc `isSymlink=`*(info: GFileInfo; isSymlink: Gboolean) {.
    importc: "g_file_info_set_is_symlink", libgio.}
proc setName*(info: GFileInfo; name: cstring) {.
    importc: "g_file_info_set_name", libgio.}
proc `name=`*(info: GFileInfo; name: cstring) {.
    importc: "g_file_info_set_name", libgio.}
proc setDisplayName*(info: GFileInfo; displayName: cstring) {.
    importc: "g_file_info_set_display_name", libgio.}
proc `displayName=`*(info: GFileInfo; displayName: cstring) {.
    importc: "g_file_info_set_display_name", libgio.}
proc setEditName*(info: GFileInfo; editName: cstring) {.
    importc: "g_file_info_set_edit_name", libgio.}
proc `editName=`*(info: GFileInfo; editName: cstring) {.
    importc: "g_file_info_set_edit_name", libgio.}
proc setIcon*(info: GFileInfo; icon: GIcon) {.
    importc: "g_file_info_set_icon", libgio.}
proc `icon=`*(info: GFileInfo; icon: GIcon) {.
    importc: "g_file_info_set_icon", libgio.}
proc setSymbolicIcon*(info: GFileInfo; icon: GIcon) {.
    importc: "g_file_info_set_symbolic_icon", libgio.}
proc `symbolicIcon=`*(info: GFileInfo; icon: GIcon) {.
    importc: "g_file_info_set_symbolic_icon", libgio.}
proc setContentType*(info: GFileInfo; contentType: cstring) {.
    importc: "g_file_info_set_content_type", libgio.}
proc `contentType=`*(info: GFileInfo; contentType: cstring) {.
    importc: "g_file_info_set_content_type", libgio.}
proc setSize*(info: GFileInfo; size: Goffset) {.
    importc: "g_file_info_set_size", libgio.}
proc `size=`*(info: GFileInfo; size: Goffset) {.
    importc: "g_file_info_set_size", libgio.}
proc setModificationTime*(info: GFileInfo; mtime: glib.GTimeVal) {.
    importc: "g_file_info_set_modification_time", libgio.}
proc `modificationTime=`*(info: GFileInfo; mtime: glib.GTimeVal) {.
    importc: "g_file_info_set_modification_time", libgio.}
proc setSymlinkTarget*(info: GFileInfo; symlinkTarget: cstring) {.
    importc: "g_file_info_set_symlink_target", libgio.}
proc `symlinkTarget=`*(info: GFileInfo; symlinkTarget: cstring) {.
    importc: "g_file_info_set_symlink_target", libgio.}
proc setSortOrder*(info: GFileInfo; sortOrder: int32) {.
    importc: "g_file_info_set_sort_order", libgio.}
proc `sortOrder=`*(info: GFileInfo; sortOrder: int32) {.
    importc: "g_file_info_set_sort_order", libgio.}
template gTypeFileAttributeMatcher*(): untyped =
  (fileAttributeMatcherGetType())

proc fileAttributeMatcherGetType*(): GType {.
    importc: "g_file_attribute_matcher_get_type", libgio.}
proc newFileAttributeMatcher*(attributes: cstring): GFileAttributeMatcher {.
    importc: "g_file_attribute_matcher_new", libgio.}
proc `ref`*(matcher: GFileAttributeMatcher): GFileAttributeMatcher {.
    importc: "g_file_attribute_matcher_ref", libgio.}
proc unref*(matcher: GFileAttributeMatcher) {.
    importc: "g_file_attribute_matcher_unref", libgio.}
proc subtract*(matcher: GFileAttributeMatcher;
                                   subtract: GFileAttributeMatcher): GFileAttributeMatcher {.
    importc: "g_file_attribute_matcher_subtract", libgio.}
proc matches*(matcher: GFileAttributeMatcher;
                                  attribute: cstring): Gboolean {.
    importc: "g_file_attribute_matcher_matches", libgio.}
proc matchesOnly*(matcher: GFileAttributeMatcher;
                                      attribute: cstring): Gboolean {.
    importc: "g_file_attribute_matcher_matches_only", libgio.}
proc enumerateNamespace*(matcher: GFileAttributeMatcher;
    ns: cstring): Gboolean {.importc: "g_file_attribute_matcher_enumerate_namespace",
                          libgio.}
proc enumerateNext*(matcher: GFileAttributeMatcher): cstring {.
    importc: "g_file_attribute_matcher_enumerate_next", libgio.}
proc toString*(matcher: GFileAttributeMatcher): cstring {.
    importc: "g_file_attribute_matcher_to_string", libgio.}

template gTypeFileInputStream*(): untyped =
  (fileInputStreamGetType())

template gFileInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFileInputStream, GFileInputStreamObj))

template gFileInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFileInputStream, GFileInputStreamClassObj))

template gIsFileInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFileInputStream))

template gIsFileInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFileInputStream))

template gFileInputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFileInputStream, GFileInputStreamClassObj))

proc fileInputStreamGetType*(): GType {.importc: "g_file_input_stream_get_type",
                                      libgio.}
proc queryInfo*(stream: GFileInputStream; attributes: cstring;
                               cancellable: GCancellable; error: var GError): GFileInfo {.
    importc: "g_file_input_stream_query_info", libgio.}
proc queryInfoAsync*(stream: GFileInputStream;
                                    attributes: cstring; ioPriority: cint;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    userData: Gpointer) {.
    importc: "g_file_input_stream_query_info_async", libgio.}
proc queryInfoFinish*(stream: GFileInputStream;
                                     result: GAsyncResult;
                                     error: var GError): GFileInfo {.
    importc: "g_file_input_stream_query_info_finish", libgio.}

template gIoError*(): untyped =
  gIoErrorQuark()

proc ioErrorQuark*(): GQuark {.importc: "g_io_error_quark", libgio.}
proc ioErrorFromErrno*(errNo: cint): GIOErrorEnum {.
    importc: "g_io_error_from_errno", libgio.}
when defined(windows):
  proc ioErrorFromWin32Error*(errorCode: cint): GIOErrorEnum {.
      importc: "g_io_error_from_win32_error", libgio.}

template gTypeIoStream*(): untyped =
  (ioStreamGetType())

template gIoStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeIoStream, GIOStreamObj))

template gIoStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeIoStream, GIOStreamClassObj))

template gIsIoStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeIoStream))

template gIsIoStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeIoStream))

template gIoStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeIoStream, GIOStreamClassObj))

proc ioStreamGetType*(): GType {.importc: "g_io_stream_get_type", libgio.}
proc ioStreamGetInputStream*(stream: GIOStream): GInputStream {.
    importc: "g_io_stream_get_input_stream", libgio.}
proc ioStreamGetOutputStream*(stream: GIOStream): GOutputStream {.
    importc: "g_io_stream_get_output_stream", libgio.}
proc ioStreamSpliceAsync*(stream1: GIOStream; stream2: GIOStream;
                          flags: GIOStreamSpliceFlags; ioPriority: cint;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_io_stream_splice_async", libgio.}
proc ioStreamSpliceFinish*(result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_io_stream_splice_finish", libgio.}
proc ioStreamClose*(stream: GIOStream; cancellable: GCancellable;
                    error: var GError): Gboolean {.importc: "g_io_stream_close",
    libgio.}
proc ioStreamCloseAsync*(stream: GIOStream; ioPriority: cint;
                         cancellable: GCancellable;
                         callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_io_stream_close_async", libgio.}
proc ioStreamCloseFinish*(stream: GIOStream; result: GAsyncResult;
                          error: var GError): Gboolean {.
    importc: "g_io_stream_close_finish", libgio.}
proc ioStreamIsClosed*(stream: GIOStream): Gboolean {.
    importc: "g_io_stream_is_closed", libgio.}
proc ioStreamHasPending*(stream: GIOStream): Gboolean {.
    importc: "g_io_stream_has_pending", libgio.}
proc ioStreamSetPending*(stream: GIOStream; error: var GError): Gboolean {.
    importc: "g_io_stream_set_pending", libgio.}
proc ioStreamClearPending*(stream: GIOStream) {.
    importc: "g_io_stream_clear_pending", libgio.}

template gTypeFileIoStream*(): untyped =
  (fileIoStreamGetType())

template gFileIoStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFileIoStream, GFileIOStreamObj))

template gFileIoStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFileIoStream, GFileIOStreamClassObj))

template gIsFileIoStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFileIoStream))

template gIsFileIoStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFileIoStream))

template gFileIoStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFileIoStream, GFileIOStreamClassObj))

proc fileIoStreamGetType*(): GType {.importc: "g_file_io_stream_get_type",
                                   libgio.}
proc fileIoStreamQueryInfo*(stream: GFileIOStream; attributes: cstring;
                            cancellable: GCancellable; error: var GError): GFileInfo {.
    importc: "g_file_io_stream_query_info", libgio.}
proc fileIoStreamQueryInfoAsync*(stream: GFileIOStream; attributes: cstring;
                                 ioPriority: cint; cancellable: GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_file_io_stream_query_info_async", libgio.}
proc fileIoStreamQueryInfoFinish*(stream: GFileIOStream;
                                  result: GAsyncResult; error: var GError): GFileInfo {.
    importc: "g_file_io_stream_query_info_finish", libgio.}
proc fileIoStreamGetEtag*(stream: GFileIOStream): cstring {.
    importc: "g_file_io_stream_get_etag", libgio.}

template gTypeFileMonitor*(): untyped =
  (fileMonitorGetType())

template gFileMonitor*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFileMonitor, GFileMonitorObj))

template gFileMonitorClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFileMonitor, GFileMonitorClassObj))

template gIsFileMonitor*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFileMonitor))

template gIsFileMonitorClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFileMonitor))

template gFileMonitorGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFileMonitor, GFileMonitorClassObj))

proc fileMonitorGetType*(): GType {.importc: "g_file_monitor_get_type", libgio.}
proc cancel*(monitor: GFileMonitor): Gboolean {.
    importc: "g_file_monitor_cancel", libgio.}
proc isCancelled*(monitor: GFileMonitor): Gboolean {.
    importc: "g_file_monitor_is_cancelled", libgio.}
proc setRateLimit*(monitor: GFileMonitor; limitMsecs: cint) {.
    importc: "g_file_monitor_set_rate_limit", libgio.}
proc `rateLimit=`*(monitor: GFileMonitor; limitMsecs: cint) {.
    importc: "g_file_monitor_set_rate_limit", libgio.}

proc emitEvent*(monitor: GFileMonitor; child: GFile;
                           otherFile: GFile; eventType: GFileMonitorEvent) {.
    importc: "g_file_monitor_emit_event", libgio.}

template gTypeFilenameCompleter*(): untyped =
  (filenameCompleterGetType())

template gFilenameCompleter*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFilenameCompleter, GFilenameCompleterObj))

template gFilenameCompleterClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFilenameCompleter, GFilenameCompleterClassObj))

template gFilenameCompleterGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFilenameCompleter, GFilenameCompleterClassObj))

template gIsFilenameCompleter*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFilenameCompleter))

template gIsFilenameCompleterClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFilenameCompleter))

type
  GFilenameCompleterClass* =  ptr GFilenameCompleterClassObj
  GFilenameCompleterClassPtr* = ptr GFilenameCompleterClassObj
  GFilenameCompleterClassObj*{.final.} = object of GObjectClassObj
    gotCompletionData*: proc (filenameCompleter: GFilenameCompleter) {.cdecl.}
    gReserved221*: proc () {.cdecl.}
    gReserved222*: proc () {.cdecl.}
    gReserved223*: proc () {.cdecl.}

proc filenameCompleterGetType*(): GType {.importc: "g_filename_completer_get_type",
                                        libgio.}
proc newFilenameCompleter*(): GFilenameCompleter {.
    importc: "g_filename_completer_new", libgio.}
proc getCompletionSuffix*(completer: GFilenameCompleter;
    initialText: cstring): cstring {.importc: "g_filename_completer_get_completion_suffix",
                                  libgio.}
proc completionSuffix*(completer: GFilenameCompleter;
    initialText: cstring): cstring {.importc: "g_filename_completer_get_completion_suffix",
                                  libgio.}
proc getCompletions*(completer: GFilenameCompleter;
                                      initialText: cstring): cstringArray {.
    importc: "g_filename_completer_get_completions", libgio.}
proc completions*(completer: GFilenameCompleter;
                                      initialText: cstring): cstringArray {.
    importc: "g_filename_completer_get_completions", libgio.}
proc setDirsOnly*(completer: GFilenameCompleter;
                                   dirsOnly: Gboolean) {.
    importc: "g_filename_completer_set_dirs_only", libgio.}
proc `dirsOnly=`*(completer: GFilenameCompleter;
                                   dirsOnly: Gboolean) {.
    importc: "g_filename_completer_set_dirs_only", libgio.}

template gTypeFileOutputStream*(): untyped =
  (fileOutputStreamGetType())

template gFileOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeFileOutputStream, GFileOutputStreamObj))

template gFileOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeFileOutputStream, GFileOutputStreamClassObj))

template gIsFileOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeFileOutputStream))

template gIsFileOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeFileOutputStream))

template gFileOutputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeFileOutputStream, GFileOutputStreamClassObj))

proc fileOutputStreamGetType*(): GType {.importc: "g_file_output_stream_get_type",
                                       libgio.}
proc queryInfo*(stream: GFileOutputStream; attributes: cstring;
                                cancellable: GCancellable;
                                error: var GError): GFileInfo {.
    importc: "g_file_output_stream_query_info", libgio.}
proc queryInfoAsync*(stream: GFileOutputStream;
                                     attributes: cstring; ioPriority: cint;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     userData: Gpointer) {.
    importc: "g_file_output_stream_query_info_async", libgio.}
proc queryInfoFinish*(stream: GFileOutputStream;
                                      result: GAsyncResult;
                                      error: var GError): GFileInfo {.
    importc: "g_file_output_stream_query_info_finish", libgio.}
proc getEtag*(stream: GFileOutputStream): cstring {.
    importc: "g_file_output_stream_get_etag", libgio.}
proc etag*(stream: GFileOutputStream): cstring {.
    importc: "g_file_output_stream_get_etag", libgio.}

template gTypeInetAddress*(): untyped =
  (inetAddressGetType())

template gInetAddress*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeInetAddress, GInetAddressObj))

template gInetAddressClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeInetAddress, GInetAddressClassObj))

template gIsInetAddress*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeInetAddress))

template gIsInetAddressClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeInetAddress))

template gInetAddressGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeInetAddress, GInetAddressClassObj))

type
  GInetAddress* =  ptr GInetAddressObj
  GInetAddressPtr* = ptr GInetAddressObj
  GInetAddressObj*{.final.} = object of GObjectObj
    priv31: pointer

  GInetAddressClass* =  ptr GInetAddressClassObj
  GInetAddressClassPtr* = ptr GInetAddressClassObj
  GInetAddressClassObj*{.final.} = object of GObjectClassObj
    toString*: proc (address: GInetAddress): cstring {.cdecl.}
    toBytes*: proc (address: GInetAddress): ptr uint8 {.cdecl.}

proc inetAddressGetType*(): GType {.importc: "g_inet_address_get_type", libgio.}
proc newInetAddress*(string: cstring): GInetAddress {.
    importc: "g_inet_address_new_from_string", libgio.}
proc newInetAddress*(bytes: var uint8; family: GSocketFamily): GInetAddress {.
    importc: "g_inet_address_new_from_bytes", libgio.}
proc newInetAddressLoopback*(family: GSocketFamily): GInetAddress {.
    importc: "g_inet_address_new_loopback", libgio.}
proc newInetAddressAny*(family: GSocketFamily): GInetAddress {.
    importc: "g_inet_address_new_any", libgio.}
proc equal*(address: GInetAddress; otherAddress: GInetAddress): Gboolean {.
    importc: "g_inet_address_equal", libgio.}
proc toString*(address: GInetAddress): cstring {.
    importc: "g_inet_address_to_string", libgio.}
proc toBytes*(address: GInetAddress): ptr uint8 {.
    importc: "g_inet_address_to_bytes", libgio.}
proc getNativeSize*(address: GInetAddress): Gsize {.
    importc: "g_inet_address_get_native_size", libgio.}
proc nativeSize*(address: GInetAddress): Gsize {.
    importc: "g_inet_address_get_native_size", libgio.}
proc getFamily*(address: GInetAddress): GSocketFamily {.
    importc: "g_inet_address_get_family", libgio.}
proc family*(address: GInetAddress): GSocketFamily {.
    importc: "g_inet_address_get_family", libgio.}
proc getIsAny*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_any", libgio.}
proc isAny*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_any", libgio.}
proc getIsLoopback*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_loopback", libgio.}
proc isLoopback*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_loopback", libgio.}
proc getIsLinkLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_link_local", libgio.}
proc isLinkLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_link_local", libgio.}
proc getIsSiteLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_site_local", libgio.}
proc isSiteLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_site_local", libgio.}
proc getIsMulticast*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_multicast", libgio.}
proc isMulticast*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_multicast", libgio.}
proc getIsMcGlobal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_global", libgio.}
proc isMcGlobal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_global", libgio.}
proc getIsMcLinkLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_link_local", libgio.}
proc isMcLinkLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_link_local", libgio.}
proc getIsMcNodeLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_node_local", libgio.}
proc isMcNodeLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_node_local", libgio.}
proc getIsMcOrgLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_org_local", libgio.}
proc isMcOrgLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_org_local", libgio.}
proc getIsMcSiteLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_site_local", libgio.}
proc isMcSiteLocal*(address: GInetAddress): Gboolean {.
    importc: "g_inet_address_get_is_mc_site_local", libgio.}

template gTypeInetAddressMask*(): untyped =
  (inetAddressMaskGetType())

template gInetAddressMask*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeInetAddressMask, GInetAddressMaskObj))

template gInetAddressMaskClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeInetAddressMask, GInetAddressMaskClassObj))

template gIsInetAddressMask*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeInetAddressMask))

template gIsInetAddressMaskClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeInetAddressMask))

template gInetAddressMaskGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeInetAddressMask, GInetAddressMaskClassObj))

type
  GInetAddressMask* =  ptr GInetAddressMaskObj
  GInetAddressMaskPtr* = ptr GInetAddressMaskObj
  GInetAddressMaskObj*{.final.} = object of GObjectObj
    priv32: pointer

  GInetAddressMaskClass* =  ptr GInetAddressMaskClassObj
  GInetAddressMaskClassPtr* = ptr GInetAddressMaskClassObj
  GInetAddressMaskClassObj*{.final.} = object of GObjectClassObj

proc inetAddressMaskGetType*(): GType {.importc: "g_inet_address_mask_get_type",
                                      libgio.}
proc newMask*(`addr`: GInetAddress; length: cuint;
                         error: var GError): GInetAddressMask {.
    importc: "g_inet_address_mask_new", libgio.}
proc newInetAddressMask*(maskString: cstring; error: var GError): GInetAddressMask {.
    importc: "g_inet_address_mask_new_from_string", libgio.}
proc toString*(mask: GInetAddressMask): cstring {.
    importc: "g_inet_address_mask_to_string", libgio.}
proc getFamily*(mask: GInetAddressMask): GSocketFamily {.
    importc: "g_inet_address_mask_get_family", libgio.}
proc family*(mask: GInetAddressMask): GSocketFamily {.
    importc: "g_inet_address_mask_get_family", libgio.}
proc getAddress*(mask: GInetAddressMask): GInetAddress {.
    importc: "g_inet_address_mask_get_address", libgio.}
proc address*(mask: GInetAddressMask): GInetAddress {.
    importc: "g_inet_address_mask_get_address", libgio.}
proc getLength*(mask: GInetAddressMask): cuint {.
    importc: "g_inet_address_mask_get_length", libgio.}
proc length*(mask: GInetAddressMask): cuint {.
    importc: "g_inet_address_mask_get_length", libgio.}
proc matches*(mask: GInetAddressMask; address: GInetAddress): Gboolean {.
    importc: "g_inet_address_mask_matches", libgio.}
proc equal*(mask: GInetAddressMask; mask2: GInetAddressMask): Gboolean {.
    importc: "g_inet_address_mask_equal", libgio.}

template gTypeSocketAddress*(): untyped =
  (socketAddressGetType())

template gSocketAddress*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeSocketAddress, GSocketAddressObj))

template gSocketAddressClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeSocketAddress, GSocketAddressClassObj))

template gIsSocketAddress*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeSocketAddress))

template gIsSocketAddressClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeSocketAddress))

template gSocketAddressGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeSocketAddress, GSocketAddressClassObj))

proc socketAddressGetType*(): GType {.importc: "g_socket_address_get_type",
                                    libgio.}
proc getFamily*(address: GSocketAddress): GSocketFamily {.
    importc: "g_socket_address_get_family", libgio.}
proc family*(address: GSocketAddress): GSocketFamily {.
    importc: "g_socket_address_get_family", libgio.}
proc newSocketAddress*(native: Gpointer; len: Gsize): GSocketAddress {.
    importc: "g_socket_address_new_from_native", libgio.}
proc toNative*(address: GSocketAddress; dest: Gpointer;
                            destlen: Gsize; error: var GError): Gboolean {.
    importc: "g_socket_address_to_native", libgio.}
proc getNativeSize*(address: GSocketAddress): Gssize {.
    importc: "g_socket_address_get_native_size", libgio.}
proc nativeSize*(address: GSocketAddress): Gssize {.
    importc: "g_socket_address_get_native_size", libgio.}

template gTypeInetSocketAddress*(): untyped =
  (inetSocketAddressGetType())

template gInetSocketAddress*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeInetSocketAddress, GInetSocketAddressObj))

template gInetSocketAddressClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeInetSocketAddress, GInetSocketAddressClassObj))

template gIsInetSocketAddress*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeInetSocketAddress))

template gIsInetSocketAddressClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeInetSocketAddress))

template gInetSocketAddressGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeInetSocketAddress, GInetSocketAddressClassObj))

type
  GInetSocketAddress* =  ptr GInetSocketAddressObj
  GInetSocketAddressPtr* = ptr GInetSocketAddressObj
  GInetSocketAddressObj* = object of GSocketAddressObj
    priv33: pointer

  GInetSocketAddressClass* =  ptr GInetSocketAddressClassObj
  GInetSocketAddressClassPtr* = ptr GInetSocketAddressClassObj
  GInetSocketAddressClassObj* = object of GSocketAddressClassObj

proc inetSocketAddressGetType*(): GType {.importc: "g_inet_socket_address_get_type",
                                        libgio.}
proc newInetSocketAddress*(address: GInetAddress; port: uint16): GSocketAddress {.
    importc: "g_inet_socket_address_new", libgio.}
proc newInetSocketAddress*(address: cstring; port: cuint): GSocketAddress {.
    importc: "g_inet_socket_address_new_from_string", libgio.}
proc getAddress*(address: GInetSocketAddress): GInetAddress {.
    importc: "g_inet_socket_address_get_address", libgio.}
proc address*(address: GInetSocketAddress): GInetAddress {.
    importc: "g_inet_socket_address_get_address", libgio.}
proc getPort*(address: GInetSocketAddress): uint16 {.
    importc: "g_inet_socket_address_get_port", libgio.}
proc port*(address: GInetSocketAddress): uint16 {.
    importc: "g_inet_socket_address_get_port", libgio.}
proc getFlowinfo*(address: GInetSocketAddress): uint32 {.
    importc: "g_inet_socket_address_get_flowinfo", libgio.}
proc flowinfo*(address: GInetSocketAddress): uint32 {.
    importc: "g_inet_socket_address_get_flowinfo", libgio.}
proc getScopeId*(address: GInetSocketAddress): uint32 {.
    importc: "g_inet_socket_address_get_scope_id", libgio.}
proc scopeId*(address: GInetSocketAddress): uint32 {.
    importc: "g_inet_socket_address_get_scope_id", libgio.}

proc appInfoCreateFlagsGetType*(): GType {.
    importc: "g_app_info_create_flags_get_type", libgio.}
template gTypeAppInfoCreateFlags*(): untyped =
  (appInfoCreateFlagsGetType())

proc converterFlagsGetType*(): GType {.importc: "g_converter_flags_get_type",
                                     libgio.}
template gTypeConverterFlags*(): untyped =
  (converterFlagsGetType())

proc converterResultGetType*(): GType {.importc: "g_converter_result_get_type",
                                      libgio.}
template gTypeConverterResult*(): untyped =
  (converterResultGetType())

proc dataStreamByteOrderGetType*(): GType {.
    importc: "g_data_stream_byte_order_get_type", libgio.}
template gTypeDataStreamByteOrder*(): untyped =
  (dataStreamByteOrderGetType())

proc dataStreamNewlineTypeGetType*(): GType {.
    importc: "g_data_stream_newline_type_get_type", libgio.}
template gTypeDataStreamNewlineType*(): untyped =
  (dataStreamNewlineTypeGetType())

proc fileAttributeTypeGetType*(): GType {.importc: "g_file_attribute_type_get_type",
                                        libgio.}
template gTypeFileAttributeType*(): untyped =
  (fileAttributeTypeGetType())

proc fileAttributeInfoFlagsGetType*(): GType {.
    importc: "g_file_attribute_info_flags_get_type", libgio.}
template gTypeFileAttributeInfoFlags*(): untyped =
  (fileAttributeInfoFlagsGetType())

proc fileAttributeStatusGetType*(): GType {.
    importc: "g_file_attribute_status_get_type", libgio.}
template gTypeFileAttributeStatus*(): untyped =
  (fileAttributeStatusGetType())

proc fileQueryInfoFlagsGetType*(): GType {.
    importc: "g_file_query_info_flags_get_type", libgio.}
template gTypeFileQueryInfoFlags*(): untyped =
  (fileQueryInfoFlagsGetType())

proc fileCreateFlagsGetType*(): GType {.importc: "g_file_create_flags_get_type",
                                      libgio.}
template gTypeFileCreateFlags*(): untyped =
  (fileCreateFlagsGetType())

proc fileMeasureFlagsGetType*(): GType {.importc: "g_file_measure_flags_get_type",
                                       libgio.}
template gTypeFileMeasureFlags*(): untyped =
  (fileMeasureFlagsGetType())

proc mountMountFlagsGetType*(): GType {.importc: "g_mount_mount_flags_get_type",
                                      libgio.}
template gTypeMountMountFlags*(): untyped =
  (mountMountFlagsGetType())

proc mountUnmountFlagsGetType*(): GType {.importc: "g_mount_unmount_flags_get_type",
                                        libgio.}
template gTypeMountUnmountFlags*(): untyped =
  (mountUnmountFlagsGetType())

proc driveStartFlagsGetType*(): GType {.importc: "g_drive_start_flags_get_type",
                                      libgio.}
template gTypeDriveStartFlags*(): untyped =
  (driveStartFlagsGetType())

proc driveStartStopTypeGetType*(): GType {.
    importc: "g_drive_start_stop_type_get_type", libgio.}
template gTypeDriveStartStopType*(): untyped =
  (driveStartStopTypeGetType())

proc fileCopyFlagsGetType*(): GType {.importc: "g_file_copy_flags_get_type",
                                    libgio.}
template gTypeFileCopyFlags*(): untyped =
  (fileCopyFlagsGetType())

proc fileMonitorFlagsGetType*(): GType {.importc: "g_file_monitor_flags_get_type",
                                       libgio.}
template gTypeFileMonitorFlags*(): untyped =
  (fileMonitorFlagsGetType())

proc fileTypeGetType*(): GType {.importc: "g_file_type_get_type", libgio.}
template gTypeFileType*(): untyped =
  (fileTypeGetType())

proc filesystemPreviewTypeGetType*(): GType {.
    importc: "g_filesystem_preview_type_get_type", libgio.}
template gTypeFilesystemPreviewType*(): untyped =
  (filesystemPreviewTypeGetType())

proc fileMonitorEventGetType*(): GType {.importc: "g_file_monitor_event_get_type",
                                       libgio.}
template gTypeFileMonitorEvent*(): untyped =
  (fileMonitorEventGetType())

proc ioErrorEnumGetType*(): GType {.importc: "g_io_error_enum_get_type", libgio.}
template gTypeIoErrorEnum*(): untyped =
  (ioErrorEnumGetType())

proc askPasswordFlagsGetType*(): GType {.importc: "g_ask_password_flags_get_type",
                                       libgio.}
template gTypeAskPasswordFlags*(): untyped =
  (askPasswordFlagsGetType())

proc passwordSaveGetType*(): GType {.importc: "g_password_save_get_type",
                                   libgio.}
template gTypePasswordSave*(): untyped =
  (passwordSaveGetType())

proc mountOperationResultGetType*(): GType {.
    importc: "g_mount_operation_result_get_type", libgio.}
template gTypeMountOperationResult*(): untyped =
  (mountOperationResultGetType())

proc outputStreamSpliceFlagsGetType*(): GType {.
    importc: "g_output_stream_splice_flags_get_type", libgio.}
template gTypeOutputStreamSpliceFlags*(): untyped =
  (outputStreamSpliceFlagsGetType())

proc ioStreamSpliceFlagsGetType*(): GType {.
    importc: "g_io_stream_splice_flags_get_type", libgio.}
template gTypeIoStreamSpliceFlags*(): untyped =
  (ioStreamSpliceFlagsGetType())

proc emblemOriginGetType*(): GType {.importc: "g_emblem_origin_get_type",
                                   libgio.}
template gTypeEmblemOrigin*(): untyped =
  (emblemOriginGetType())

proc resolverErrorGetType*(): GType {.importc: "g_resolver_error_get_type",
                                    libgio.}
template gTypeResolverError*(): untyped =
  (resolverErrorGetType())

proc resolverRecordTypeGetType*(): GType {.
    importc: "g_resolver_record_type_get_type", libgio.}
template gTypeResolverRecordType*(): untyped =
  (resolverRecordTypeGetType())

proc resourceErrorGetType*(): GType {.importc: "g_resource_error_get_type",
                                    libgio.}
template gTypeResourceError*(): untyped =
  (resourceErrorGetType())

proc resourceFlagsGetType*(): GType {.importc: "g_resource_flags_get_type",
                                    libgio.}
template gTypeResourceFlags*(): untyped =
  (resourceFlagsGetType())

proc resourceLookupFlagsGetType*(): GType {.
    importc: "g_resource_lookup_flags_get_type", libgio.}
template gTypeResourceLookupFlags*(): untyped =
  (resourceLookupFlagsGetType())

proc socketFamilyGetType*(): GType {.importc: "g_socket_family_get_type",
                                   libgio.}
template gTypeSocketFamily*(): untyped =
  (socketFamilyGetType())

proc socketTypeGetType*(): GType {.importc: "g_socket_type_get_type", libgio.}
template gTypeSocketType*(): untyped =
  (socketTypeGetType())

proc socketMsgFlagsGetType*(): GType {.importc: "g_socket_msg_flags_get_type",
                                     libgio.}
template gTypeSocketMsgFlags*(): untyped =
  (socketMsgFlagsGetType())

proc socketProtocolGetType*(): GType {.importc: "g_socket_protocol_get_type",
                                     libgio.}
template gTypeSocketProtocol*(): untyped =
  (socketProtocolGetType())

proc zlibCompressorFormatGetType*(): GType {.
    importc: "g_zlib_compressor_format_get_type", libgio.}
template gTypeZlibCompressorFormat*(): untyped =
  (zlibCompressorFormatGetType())

proc unixSocketAddressTypeGetType*(): GType {.
    importc: "g_unix_socket_address_type_get_type", libgio.}
template gTypeUnixSocketAddressType*(): untyped =
  (unixSocketAddressTypeGetType())

proc busTypeGetType*(): GType {.importc: "g_bus_type_get_type", libgio.}
template gTypeBusType*(): untyped =
  (busTypeGetType())

proc busNameOwnerFlagsGetType*(): GType {.importc: "g_bus_name_owner_flags_get_type",
                                        libgio.}
template gTypeBusNameOwnerFlags*(): untyped =
  (busNameOwnerFlagsGetType())

proc busNameWatcherFlagsGetType*(): GType {.
    importc: "g_bus_name_watcher_flags_get_type", libgio.}
template gTypeBusNameWatcherFlags*(): untyped =
  (busNameWatcherFlagsGetType())

proc dbusProxyFlagsGetType*(): GType {.importc: "g_dbus_proxy_flags_get_type",
                                     libgio.}
template gTypeDbusProxyFlags*(): untyped =
  (dbusProxyFlagsGetType())

proc dbusErrorGetType*(): GType {.importc: "g_dbus_error_get_type", libgio.}
template gTypeDbusError*(): untyped =
  (dbusErrorGetType())

proc dbusConnectionFlagsGetType*(): GType {.
    importc: "g_dbus_connection_flags_get_type", libgio.}
template gTypeDbusConnectionFlags*(): untyped =
  (dbusConnectionFlagsGetType())

proc dbusCapabilityFlagsGetType*(): GType {.
    importc: "g_dbus_capability_flags_get_type", libgio.}
template gTypeDbusCapabilityFlags*(): untyped =
  (dbusCapabilityFlagsGetType())

proc dbusCallFlagsGetType*(): GType {.importc: "g_dbus_call_flags_get_type",
                                    libgio.}
template gTypeDbusCallFlags*(): untyped =
  (dbusCallFlagsGetType())

proc dbusMessageTypeGetType*(): GType {.importc: "g_dbus_message_type_get_type",
                                      libgio.}
template gTypeDbusMessageType*(): untyped =
  (dbusMessageTypeGetType())

proc dbusMessageFlagsGetType*(): GType {.importc: "g_dbus_message_flags_get_type",
                                       libgio.}
template gTypeDbusMessageFlags*(): untyped =
  (dbusMessageFlagsGetType())

proc dbusMessageHeaderFieldGetType*(): GType {.
    importc: "g_dbus_message_header_field_get_type", libgio.}
template gTypeDbusMessageHeaderField*(): untyped =
  (dbusMessageHeaderFieldGetType())

proc dbusPropertyInfoFlagsGetType*(): GType {.
    importc: "g_dbus_property_info_flags_get_type", libgio.}
template gTypeDbusPropertyInfoFlags*(): untyped =
  (dbusPropertyInfoFlagsGetType())

proc dbusSubtreeFlagsGetType*(): GType {.importc: "g_dbus_subtree_flags_get_type",
                                       libgio.}
template gTypeDbusSubtreeFlags*(): untyped =
  (dbusSubtreeFlagsGetType())

proc dbusServerFlagsGetType*(): GType {.importc: "g_dbus_server_flags_get_type",
                                      libgio.}
template gTypeDbusServerFlags*(): untyped =
  (dbusServerFlagsGetType())

proc dbusSignalFlagsGetType*(): GType {.importc: "g_dbus_signal_flags_get_type",
                                      libgio.}
template gTypeDbusSignalFlags*(): untyped =
  (dbusSignalFlagsGetType())

proc dbusSendMessageFlagsGetType*(): GType {.
    importc: "g_dbus_send_message_flags_get_type", libgio.}
template gTypeDbusSendMessageFlags*(): untyped =
  (dbusSendMessageFlagsGetType())

proc credentialsTypeGetType*(): GType {.importc: "g_credentials_type_get_type",
                                      libgio.}
template gTypeCredentialsType*(): untyped =
  (credentialsTypeGetType())

proc dbusMessageByteOrderGetType*(): GType {.
    importc: "g_dbus_message_byte_order_get_type", libgio.}
template gTypeDbusMessageByteOrder*(): untyped =
  (dbusMessageByteOrderGetType())

proc applicationFlagsGetType*(): GType {.importc: "g_application_flags_get_type",
                                       libgio.}
template gTypeApplicationFlags*(): untyped =
  (applicationFlagsGetType())

proc tlsErrorGetType*(): GType {.importc: "g_tls_error_get_type", libgio.}
template gTypeTlsError*(): untyped =
  (tlsErrorGetType())

proc tlsCertificateFlagsGetType*(): GType {.
    importc: "g_tls_certificate_flags_get_type", libgio.}
template gTypeTlsCertificateFlags*(): untyped =
  (tlsCertificateFlagsGetType())

proc tlsAuthenticationModeGetType*(): GType {.
    importc: "g_tls_authentication_mode_get_type", libgio.}
template gTypeTlsAuthenticationMode*(): untyped =
  (tlsAuthenticationModeGetType())

proc tlsRehandshakeModeGetType*(): GType {.
    importc: "g_tls_rehandshake_mode_get_type", libgio.}
template gTypeTlsRehandshakeMode*(): untyped =
  (tlsRehandshakeModeGetType())

proc tlsPasswordFlagsGetType*(): GType {.importc: "g_tls_password_flags_get_type",
                                       libgio.}
template gTypeTlsPasswordFlags*(): untyped =
  (tlsPasswordFlagsGetType())

proc tlsInteractionResultGetType*(): GType {.
    importc: "g_tls_interaction_result_get_type", libgio.}
template gTypeTlsInteractionResult*(): untyped =
  (tlsInteractionResultGetType())

proc dbusInterfaceSkeletonFlagsGetType*(): GType {.
    importc: "g_dbus_interface_skeleton_flags_get_type", libgio.}
template gTypeDbusInterfaceSkeletonFlags*(): untyped =
  (dbusInterfaceSkeletonFlagsGetType())

proc dbusObjectManagerClientFlagsGetType*(): GType {.
    importc: "g_dbus_object_manager_client_flags_get_type", libgio.}
template gTypeDbusObjectManagerClientFlags*(): untyped =
  (dbusObjectManagerClientFlagsGetType())

proc tlsDatabaseVerifyFlagsGetType*(): GType {.
    importc: "g_tls_database_verify_flags_get_type", libgio.}
template gTypeTlsDatabaseVerifyFlags*(): untyped =
  (tlsDatabaseVerifyFlagsGetType())

proc tlsDatabaseLookupFlagsGetType*(): GType {.
    importc: "g_tls_database_lookup_flags_get_type", libgio.}
template gTypeTlsDatabaseLookupFlags*(): untyped =
  (tlsDatabaseLookupFlagsGetType())

proc tlsCertificateRequestFlagsGetType*(): GType {.
    importc: "g_tls_certificate_request_flags_get_type", libgio.}
template gTypeTlsCertificateRequestFlags*(): untyped =
  (tlsCertificateRequestFlagsGetType())

proc ioModuleScopeFlagsGetType*(): GType {.
    importc: "g_io_module_scope_flags_get_type", libgio.}
template gTypeIoModuleScopeFlags*(): untyped =
  (ioModuleScopeFlagsGetType())

proc socketClientEventGetType*(): GType {.importc: "g_socket_client_event_get_type",
                                        libgio.}
template gTypeSocketClientEvent*(): untyped =
  (socketClientEventGetType())

proc socketListenerEventGetType*(): GType {.
    importc: "g_socket_listener_event_get_type", libgio.}
template gTypeSocketListenerEvent*(): untyped =
  (socketListenerEventGetType())

proc testDbusFlagsGetType*(): GType {.importc: "g_test_dbus_flags_get_type",
                                    libgio.}
template gTypeTestDbusFlags*(): untyped =
  (testDbusFlagsGetType())

proc subprocessFlagsGetType*(): GType {.importc: "g_subprocess_flags_get_type",
                                      libgio.}
template gTypeSubprocessFlags*(): untyped =
  (subprocessFlagsGetType())

proc notificationPriorityGetType*(): GType {.
    importc: "g_notification_priority_get_type", libgio.}
template gTypeNotificationPriority*(): untyped =
  (notificationPriorityGetType())

proc networkConnectivityGetType*(): GType {.
    importc: "g_network_connectivity_get_type", libgio.}
template gTypeNetworkConnectivity*(): untyped =
  (networkConnectivityGetType())

proc settingsBindFlagsGetType*(): GType {.importc: "g_settings_bind_flags_get_type",
                                        libgio.}
template gTypeSettingsBindFlags*(): untyped =
  (settingsBindFlagsGetType())

type
  GIOModuleScope* =  ptr GIOModuleScopeObj
  GIOModuleScopePtr* = ptr GIOModuleScopeObj
  GIOModuleScopeObj* = object

proc newIoModuleScope*(flags: GIOModuleScopeFlags): GIOModuleScope {.
    importc: "g_io_module_scope_new", libgio.}
proc ioModuleScopeFree*(scope: GIOModuleScope) {.
    importc: "g_io_module_scope_free", libgio.}
proc ioModuleScopeBlock*(scope: GIOModuleScope; basename: cstring) {.
    importc: "g_io_module_scope_block", libgio.}
template gIoTypeModule*(): untyped =
  (ioModuleGetType())

template gIoModule*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gIoTypeModule, gIOModule))

template gIoModuleClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gIoTypeModule, gIOModuleClass))

template gIoIsModule*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gIoTypeModule))

template gIoIsModuleClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gIoTypeModule))

template gIoModuleGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gIoTypeModule, gIOModuleClass))

type
  GIOModuleClass* =  ptr GIOModuleClassObj
  GIOModuleClassPtr* = ptr GIOModuleClassObj
  GIOModuleClassObj* = object

proc ioModuleGetType*(): GType {.importc: "g_io_module_get_type", libgio.}
proc newIoModule*(filename: cstring): GIOModule {.importc: "g_io_module_new",
    libgio.}
proc ioModulesScanAllInDirectory*(dirname: cstring) {.
    importc: "g_io_modules_scan_all_in_directory", libgio.}
proc ioModulesLoadAllInDirectory*(dirname: cstring): GList {.
    importc: "g_io_modules_load_all_in_directory", libgio.}
proc ioModulesScanAllInDirectoryWithScope*(dirname: cstring;
    scope: GIOModuleScope) {.importc: "g_io_modules_scan_all_in_directory_with_scope",
                              libgio.}
proc ioModulesLoadAllInDirectoryWithScope*(dirname: cstring;
    scope: GIOModuleScope): GList {.importc: "g_io_modules_load_all_in_directory_with_scope",
                                       libgio.}
proc ioExtensionPointRegister*(name: cstring): GIOExtensionPoint {.
    importc: "g_io_extension_point_register", libgio.}
proc ioExtensionPointLookup*(name: cstring): GIOExtensionPoint {.
    importc: "g_io_extension_point_lookup", libgio.}
proc ioExtensionPointSetRequiredType*(extensionPoint: GIOExtensionPoint;
                                      `type`: GType) {.
    importc: "g_io_extension_point_set_required_type", libgio.}
proc ioExtensionPointGetRequiredType*(extensionPoint: GIOExtensionPoint): GType {.
    importc: "g_io_extension_point_get_required_type", libgio.}
proc ioExtensionPointGetExtensions*(extensionPoint: GIOExtensionPoint): GList {.
    importc: "g_io_extension_point_get_extensions", libgio.}
proc ioExtensionPointGetExtensionByName*(extensionPoint: GIOExtensionPoint;
    name: cstring): GIOExtension {.importc: "g_io_extension_point_get_extension_by_name",
                                   libgio.}
proc ioExtensionPointImplement*(extensionPointName: cstring; `type`: GType;
                                extensionName: cstring; priority: cint): GIOExtension {.
    importc: "g_io_extension_point_implement", libgio.}
proc ioExtensionGetType*(extension: GIOExtension): GType {.
    importc: "g_io_extension_get_type", libgio.}
proc ioExtensionGetName*(extension: GIOExtension): cstring {.
    importc: "g_io_extension_get_name", libgio.}
proc ioExtensionGetPriority*(extension: GIOExtension): cint {.
    importc: "g_io_extension_get_priority", libgio.}
proc ioExtensionRefClass*(extension: GIOExtension): gobject.GTypeClass {.
    importc: "g_io_extension_ref_class", libgio.}

proc ioModuleLoad*(module: GIOModule) {.importc: "g_io_module_load", libgio.}

proc ioModuleUnload*(module: GIOModule) {.importc: "g_io_module_unload",
    libgio.}

proc ioModuleQuery*(): cstringArray {.importc: "g_io_module_query", libgio.}

proc ioSchedulerPushJob*(jobFunc: GIOSchedulerJobFunc; userData: Gpointer;
                         notify: GDestroyNotify; ioPriority: cint;
                         cancellable: GCancellable) {.
    importc: "g_io_scheduler_push_job", libgio.}
proc ioSchedulerCancelAllJobs*() {.importc: "g_io_scheduler_cancel_all_jobs",
                                  libgio.}
proc ioSchedulerJobSendToMainloop*(job: GIOSchedulerJob; `func`: GSourceFunc;
                                   userData: Gpointer; notify: GDestroyNotify): Gboolean {.
    importc: "g_io_scheduler_job_send_to_mainloop", libgio.}
proc ioSchedulerJobSendToMainloopAsync*(job: GIOSchedulerJob;
                                        `func`: GSourceFunc; userData: Gpointer;
                                        notify: GDestroyNotify) {.
    importc: "g_io_scheduler_job_send_to_mainloop_async", libgio.}

template gTypeLoadableIcon*(): untyped =
  (loadableIconGetType())

template gLoadableIcon*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeLoadableIcon, GLoadableIconObj))

template gIsLoadableIcon*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeLoadableIcon))

template gLoadableIconGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeLoadableIcon, GLoadableIconIfaceObj))

type
  GLoadableIconIface* =  ptr GLoadableIconIfaceObj
  GLoadableIconIfacePtr* = ptr GLoadableIconIfaceObj
  GLoadableIconIfaceObj*{.final.} = object of GTypeInterfaceObj
    load*: proc (icon: GLoadableIcon; size: cint; `type`: cstringArray;
               cancellable: GCancellable; error: var GError): GInputStream {.cdecl.}
    loadAsync*: proc (icon: GLoadableIcon; size: cint;
                    cancellable: GCancellable; callback: GAsyncReadyCallback;
                    userData: Gpointer) {.cdecl.}
    loadFinish*: proc (icon: GLoadableIcon; res: GAsyncResult;
                     `type`: cstringArray; error: var GError): GInputStream {.cdecl.}

proc loadableIconGetType*(): GType {.importc: "g_loadable_icon_get_type",
                                   libgio.}
proc load*(icon: GLoadableIcon; size: cint; `type`: cstringArray;
                       cancellable: GCancellable; error: var GError): GInputStream {.
    importc: "g_loadable_icon_load", libgio.}
proc loadAsync*(icon: GLoadableIcon; size: cint;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_loadable_icon_load_async", libgio.}
proc loadFinish*(icon: GLoadableIcon; res: GAsyncResult;
                             `type`: cstringArray; error: var GError): GInputStream {.
    importc: "g_loadable_icon_load_finish", libgio.}

template gTypeMemoryInputStream*(): untyped =
  (memoryInputStreamGetType())

template gMemoryInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeMemoryInputStream, GMemoryInputStreamObj))

template gMemoryInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeMemoryInputStream, GMemoryInputStreamClassObj))

template gIsMemoryInputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeMemoryInputStream))

template gIsMemoryInputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeMemoryInputStream))

template gMemoryInputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeMemoryInputStream, GMemoryInputStreamClassObj))

type
  GMemoryInputStream* =  ptr GMemoryInputStreamObj
  GMemoryInputStreamPtr* = ptr GMemoryInputStreamObj
  GMemoryInputStreamObj*{.final.} = object of GInputStreamObj
    priv34: pointer

  GMemoryInputStreamClass* =  ptr GMemoryInputStreamClassObj
  GMemoryInputStreamClassPtr* = ptr GMemoryInputStreamClassObj
  GMemoryInputStreamClassObj*{.final.} = object of GInputStreamClassObj
    gReserved231*: proc () {.cdecl.}
    gReserved232*: proc () {.cdecl.}
    gReserved233*: proc () {.cdecl.}
    gReserved234*: proc () {.cdecl.}
    gReserved235*: proc () {.cdecl.}

proc memoryInputStreamGetType*(): GType {.importc: "g_memory_input_stream_get_type",
                                        libgio.}
proc newMemoryInputStream*(): GInputStream {.
    importc: "g_memory_input_stream_new", libgio.}
proc newMemoryInputStream*(data: pointer; len: Gssize;
                                   destroy: GDestroyNotify): GInputStream {.
    importc: "g_memory_input_stream_new_from_data", libgio.}
proc newMemoryInputStream*(bytes: glib.GBytes): GInputStream {.
    importc: "g_memory_input_stream_new_from_bytes", libgio.}
proc addData*(stream: GMemoryInputStream; data: pointer;
                               len: Gssize; destroy: GDestroyNotify) {.
    importc: "g_memory_input_stream_add_data", libgio.}
proc addBytes*(stream: GMemoryInputStream; bytes: glib.GBytes) {.
    importc: "g_memory_input_stream_add_bytes", libgio.}

template gTypeMemoryOutputStream*(): untyped =
  (memoryOutputStreamGetType())

template gMemoryOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeMemoryOutputStream, GMemoryOutputStreamObj))

template gMemoryOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeMemoryOutputStream, GMemoryOutputStreamClassObj))

template gIsMemoryOutputStream*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeMemoryOutputStream))

template gIsMemoryOutputStreamClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeMemoryOutputStream))

template gMemoryOutputStreamGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeMemoryOutputStream, GMemoryOutputStreamClassObj))

type
  GMemoryOutputStream* =  ptr GMemoryOutputStreamObj
  GMemoryOutputStreamPtr* = ptr GMemoryOutputStreamObj
  GMemoryOutputStreamObj*{.final.} = object of GOutputStreamObj
    priv35: pointer

  GMemoryOutputStreamClass* =  ptr GMemoryOutputStreamClassObj
  GMemoryOutputStreamClassPtr* = ptr GMemoryOutputStreamClassObj
  GMemoryOutputStreamClassObj*{.final.} = object of GOutputStreamClassObj
    gReserved241*: proc () {.cdecl.}
    gReserved242*: proc () {.cdecl.}
    gReserved243*: proc () {.cdecl.}
    gReserved244*: proc () {.cdecl.}
    gReserved245*: proc () {.cdecl.}

type
  GReallocFunc* = proc (data: Gpointer; size: Gsize): Gpointer {.cdecl.}

proc memoryOutputStreamGetType*(): GType {.
    importc: "g_memory_output_stream_get_type", libgio.}
proc newMemoryOutputStream*(data: Gpointer; size: Gsize;
                            reallocFunction: GReallocFunc;
                            destroyFunction: GDestroyNotify): GOutputStream {.
    importc: "g_memory_output_stream_new", libgio.}
proc newMemoryOutputStream*(): GOutputStream {.
    importc: "g_memory_output_stream_new_resizable", libgio.}
proc getData*(ostream: GMemoryOutputStream): Gpointer {.
    importc: "g_memory_output_stream_get_data", libgio.}
proc data*(ostream: GMemoryOutputStream): Gpointer {.
    importc: "g_memory_output_stream_get_data", libgio.}
proc getSize*(ostream: GMemoryOutputStream): Gsize {.
    importc: "g_memory_output_stream_get_size", libgio.}
proc size*(ostream: GMemoryOutputStream): Gsize {.
    importc: "g_memory_output_stream_get_size", libgio.}
proc getDataSize*(ostream: GMemoryOutputStream): Gsize {.
    importc: "g_memory_output_stream_get_data_size", libgio.}
proc dataSize*(ostream: GMemoryOutputStream): Gsize {.
    importc: "g_memory_output_stream_get_data_size", libgio.}
proc stealData*(ostream: GMemoryOutputStream): Gpointer {.
    importc: "g_memory_output_stream_steal_data", libgio.}
proc stealAsBytes*(ostream: GMemoryOutputStream): glib.GBytes {.
    importc: "g_memory_output_stream_steal_as_bytes", libgio.}

template gTypeMount*(): untyped =
  (mountGetType())

template gMount*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeMount, GMountObj))

template gIsMount*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeMount))

template gMountGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeMount, GMountIfaceObj))

type
  GMountIface* =  ptr GMountIfaceObj
  GMountIfacePtr* = ptr GMountIfaceObj
  GMountIfaceObj*{.final.} = object of GTypeInterfaceObj
    changed*: proc (mount: GMount) {.cdecl.}
    unmounted*: proc (mount: GMount) {.cdecl.}
    getRoot*: proc (mount: GMount): GFile {.cdecl.}
    getName*: proc (mount: GMount): cstring {.cdecl.}
    getIcon*: proc (mount: GMount): GIcon {.cdecl.}
    getUuid*: proc (mount: GMount): cstring {.cdecl.}
    getVolume*: proc (mount: GMount): GVolume {.cdecl.}
    getDrive*: proc (mount: GMount): GDrive {.cdecl.}
    canUnmount*: proc (mount: GMount): Gboolean {.cdecl.}
    canEject*: proc (mount: GMount): Gboolean {.cdecl.}
    unmount*: proc (mount: GMount; flags: GMountUnmountFlags;
                  cancellable: GCancellable; callback: GAsyncReadyCallback;
                  userData: Gpointer) {.cdecl.}
    unmountFinish*: proc (mount: GMount; result: GAsyncResult;
                        error: var GError): Gboolean {.cdecl.}
    eject*: proc (mount: GMount; flags: GMountUnmountFlags;
                cancellable: GCancellable; callback: GAsyncReadyCallback;
                userData: Gpointer) {.cdecl.}
    ejectFinish*: proc (mount: GMount; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    remount*: proc (mount: GMount; flags: GMountMountFlags;
                  mountOperation: GMountOperation;
                  cancellable: GCancellable; callback: GAsyncReadyCallback;
                  userData: Gpointer) {.cdecl.}
    remountFinish*: proc (mount: GMount; result: GAsyncResult;
                        error: var GError): Gboolean {.cdecl.}
    guessContentType*: proc (mount: GMount; forceRescan: Gboolean;
                           cancellable: GCancellable;
                           callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    guessContentTypeFinish*: proc (mount: GMount; result: GAsyncResult;
                                 error: var GError): cstringArray {.cdecl.}
    guessContentTypeSync*: proc (mount: GMount; forceRescan: Gboolean;
                               cancellable: GCancellable; error: var GError): cstringArray {.cdecl.}
    preUnmount*: proc (mount: GMount) {.cdecl.}
    unmountWithOperation*: proc (mount: GMount; flags: GMountUnmountFlags;
                               mountOperation: GMountOperation;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    unmountWithOperationFinish*: proc (mount: GMount; result: GAsyncResult;
                                     error: var GError): Gboolean {.cdecl.}
    ejectWithOperation*: proc (mount: GMount; flags: GMountUnmountFlags;
                             mountOperation: GMountOperation;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    ejectWithOperationFinish*: proc (mount: GMount; result: GAsyncResult;
                                   error: var GError): Gboolean {.cdecl.}
    getDefaultLocation*: proc (mount: GMount): GFile {.cdecl.}
    getSortKey*: proc (mount: GMount): cstring {.cdecl.}
    getSymbolicIcon*: proc (mount: GMount): GIcon {.cdecl.}

proc mountGetType*(): GType {.importc: "g_mount_get_type", libgio.}
proc getRoot*(mount: GMount): GFile {.importc: "g_mount_get_root",
    libgio.}
proc root*(mount: GMount): GFile {.importc: "g_mount_get_root",
    libgio.}
proc getDefaultLocation*(mount: GMount): GFile {.
    importc: "g_mount_get_default_location", libgio.}
proc defaultLocation*(mount: GMount): GFile {.
    importc: "g_mount_get_default_location", libgio.}
proc getName*(mount: GMount): cstring {.importc: "g_mount_get_name",
    libgio.}
proc name*(mount: GMount): cstring {.importc: "g_mount_get_name",
    libgio.}
proc getIcon*(mount: GMount): GIcon {.importc: "g_mount_get_icon",
    libgio.}
proc icon*(mount: GMount): GIcon {.importc: "g_mount_get_icon",
    libgio.}
proc getSymbolicIcon*(mount: GMount): GIcon {.
    importc: "g_mount_get_symbolic_icon", libgio.}
proc symbolicIcon*(mount: GMount): GIcon {.
    importc: "g_mount_get_symbolic_icon", libgio.}
proc getUuid*(mount: GMount): cstring {.importc: "g_mount_get_uuid",
    libgio.}
proc uuid*(mount: GMount): cstring {.importc: "g_mount_get_uuid",
    libgio.}
proc getVolume*(mount: GMount): GVolume {.importc: "g_mount_get_volume",
    libgio.}
proc volume*(mount: GMount): GVolume {.importc: "g_mount_get_volume",
    libgio.}
proc getDrive*(mount: GMount): GDrive {.importc: "g_mount_get_drive",
    libgio.}
proc drive*(mount: GMount): GDrive {.importc: "g_mount_get_drive",
    libgio.}
proc canUnmount*(mount: GMount): Gboolean {.importc: "g_mount_can_unmount",
    libgio.}
proc canEject*(mount: GMount): Gboolean {.importc: "g_mount_can_eject",
    libgio.}
proc unmount*(mount: GMount; flags: GMountUnmountFlags;
                   cancellable: GCancellable; callback: GAsyncReadyCallback;
                   userData: Gpointer) {.importc: "g_mount_unmount", libgio.}
proc unmountFinish*(mount: GMount; result: GAsyncResult;
                         error: var GError): Gboolean {.
    importc: "g_mount_unmount_finish", libgio.}
proc eject*(mount: GMount; flags: GMountUnmountFlags;
                 cancellable: GCancellable; callback: GAsyncReadyCallback;
                 userData: Gpointer) {.importc: "g_mount_eject", libgio.}
proc ejectFinish*(mount: GMount; result: GAsyncResult;
                       error: var GError): Gboolean {.
    importc: "g_mount_eject_finish", libgio.}
proc remount*(mount: GMount; flags: GMountMountFlags;
                   mountOperation: GMountOperation;
                   cancellable: GCancellable; callback: GAsyncReadyCallback;
                   userData: Gpointer) {.importc: "g_mount_remount", libgio.}
proc remountFinish*(mount: GMount; result: GAsyncResult;
                         error: var GError): Gboolean {.
    importc: "g_mount_remount_finish", libgio.}
proc guessContentType*(mount: GMount; forceRescan: Gboolean;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_mount_guess_content_type", libgio.}
proc guessContentTypeFinish*(mount: GMount; result: GAsyncResult;
                                  error: var GError): cstringArray {.
    importc: "g_mount_guess_content_type_finish", libgio.}
proc guessContentTypeSync*(mount: GMount; forceRescan: Gboolean;
                                cancellable: GCancellable;
                                error: var GError): cstringArray {.
    importc: "g_mount_guess_content_type_sync", libgio.}
proc isShadowed*(mount: GMount): Gboolean {.importc: "g_mount_is_shadowed",
    libgio.}
proc shadow*(mount: GMount) {.importc: "g_mount_shadow", libgio.}
proc unshadow*(mount: GMount) {.importc: "g_mount_unshadow", libgio.}
proc unmountWithOperation*(mount: GMount; flags: GMountUnmountFlags;
                                mountOperation: GMountOperation;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_mount_unmount_with_operation", libgio.}
proc unmountWithOperationFinish*(mount: GMount; result: GAsyncResult;
                                      error: var GError): Gboolean {.
    importc: "g_mount_unmount_with_operation_finish", libgio.}
proc ejectWithOperation*(mount: GMount; flags: GMountUnmountFlags;
                              mountOperation: GMountOperation;
                              cancellable: GCancellable;
                              callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_mount_eject_with_operation", libgio.}
proc ejectWithOperationFinish*(mount: GMount; result: GAsyncResult;
                                    error: var GError): Gboolean {.
    importc: "g_mount_eject_with_operation_finish", libgio.}
proc getSortKey*(mount: GMount): cstring {.importc: "g_mount_get_sort_key",
    libgio.}
proc sortKey*(mount: GMount): cstring {.importc: "g_mount_get_sort_key",
    libgio.}

template gTypeMountOperation*(): untyped =
  (mountOperationGetType())

template gMountOperation*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeMountOperation, GMountOperationObj))

template gMountOperationClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeMountOperation, GMountOperationClassObj))

template gIsMountOperation*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeMountOperation))

template gIsMountOperationClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeMountOperation))

template gMountOperationGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeMountOperation, GMountOperationClassObj))

proc mountOperationGetType*(): GType {.importc: "g_mount_operation_get_type",
                                     libgio.}
proc newMountOperation*(): GMountOperation {.importc: "g_mount_operation_new",
    libgio.}
proc getUsername*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_username", libgio.}
proc username*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_username", libgio.}
proc setUsername*(op: GMountOperation; username: cstring) {.
    importc: "g_mount_operation_set_username", libgio.}
proc `username=`*(op: GMountOperation; username: cstring) {.
    importc: "g_mount_operation_set_username", libgio.}
proc getPassword*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_password", libgio.}
proc password*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_password", libgio.}
proc setPassword*(op: GMountOperation; password: cstring) {.
    importc: "g_mount_operation_set_password", libgio.}
proc `password=`*(op: GMountOperation; password: cstring) {.
    importc: "g_mount_operation_set_password", libgio.}
proc getAnonymous*(op: GMountOperation): Gboolean {.
    importc: "g_mount_operation_get_anonymous", libgio.}
proc anonymous*(op: GMountOperation): Gboolean {.
    importc: "g_mount_operation_get_anonymous", libgio.}
proc setAnonymous*(op: GMountOperation; anonymous: Gboolean) {.
    importc: "g_mount_operation_set_anonymous", libgio.}
proc `anonymous=`*(op: GMountOperation; anonymous: Gboolean) {.
    importc: "g_mount_operation_set_anonymous", libgio.}
proc getDomain*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_domain", libgio.}
proc domain*(op: GMountOperation): cstring {.
    importc: "g_mount_operation_get_domain", libgio.}
proc setDomain*(op: GMountOperation; domain: cstring) {.
    importc: "g_mount_operation_set_domain", libgio.}
proc `domain=`*(op: GMountOperation; domain: cstring) {.
    importc: "g_mount_operation_set_domain", libgio.}
proc getPasswordSave*(op: GMountOperation): GPasswordSave {.
    importc: "g_mount_operation_get_password_save", libgio.}
proc passwordSave*(op: GMountOperation): GPasswordSave {.
    importc: "g_mount_operation_get_password_save", libgio.}
proc setPasswordSave*(op: GMountOperation; save: GPasswordSave) {.
    importc: "g_mount_operation_set_password_save", libgio.}
proc `passwordSave=`*(op: GMountOperation; save: GPasswordSave) {.
    importc: "g_mount_operation_set_password_save", libgio.}
proc getChoice*(op: GMountOperation): cint {.
    importc: "g_mount_operation_get_choice", libgio.}
proc choice*(op: GMountOperation): cint {.
    importc: "g_mount_operation_get_choice", libgio.}
proc setChoice*(op: GMountOperation; choice: cint) {.
    importc: "g_mount_operation_set_choice", libgio.}
proc `choice=`*(op: GMountOperation; choice: cint) {.
    importc: "g_mount_operation_set_choice", libgio.}
proc reply*(op: GMountOperation; result: GMountOperationResult) {.
    importc: "g_mount_operation_reply", libgio.}

template gTypeVolumeMonitor*(): untyped =
  (volumeMonitorGetType())

template gVolumeMonitor*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeVolumeMonitor, GVolumeMonitorObj))

template gVolumeMonitorClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeVolumeMonitor, GVolumeMonitorClassObj))

template gVolumeMonitorGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeVolumeMonitor, GVolumeMonitorClassObj))

template gIsVolumeMonitor*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeVolumeMonitor))

template gIsVolumeMonitorClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeVolumeMonitor))

const
  G_VOLUME_MONITOR_EXTENSION_POINT_NAME* = "gio-volume-monitor"

type
  GVolumeMonitor* =  ptr GVolumeMonitorObj
  GVolumeMonitorPtr* = ptr GVolumeMonitorObj
  GVolumeMonitorObj* = object of GObjectObj
    priv36: Gpointer

  GVolumeMonitorClass* =  ptr GVolumeMonitorClassObj
  GVolumeMonitorClassPtr* = ptr GVolumeMonitorClassObj
  GVolumeMonitorClassObj* = object of GObjectClassObj
    volumeAdded*: proc (volumeMonitor: GVolumeMonitor; volume: GVolume) {.cdecl.}
    volumeRemoved*: proc (volumeMonitor: GVolumeMonitor; volume: GVolume) {.cdecl.}
    volumeChanged*: proc (volumeMonitor: GVolumeMonitor; volume: GVolume) {.cdecl.}
    mountAdded*: proc (volumeMonitor: GVolumeMonitor; mount: GMount) {.cdecl.}
    mountRemoved*: proc (volumeMonitor: GVolumeMonitor; mount: GMount) {.cdecl.}
    mountPreUnmount*: proc (volumeMonitor: GVolumeMonitor; mount: GMount) {.cdecl.}
    mountChanged*: proc (volumeMonitor: GVolumeMonitor; mount: GMount) {.cdecl.}
    driveConnected*: proc (volumeMonitor: GVolumeMonitor; drive: GDrive) {.cdecl.}
    driveDisconnected*: proc (volumeMonitor: GVolumeMonitor; drive: GDrive) {.cdecl.}
    driveChanged*: proc (volumeMonitor: GVolumeMonitor; drive: GDrive) {.cdecl.}
    isSupported*: proc (): Gboolean {.cdecl.}
    getConnectedDrives*: proc (volumeMonitor: GVolumeMonitor): GList {.cdecl.}
    getVolumes*: proc (volumeMonitor: GVolumeMonitor): GList {.cdecl.}
    getMounts*: proc (volumeMonitor: GVolumeMonitor): GList {.cdecl.}
    getVolumeForUuid*: proc (volumeMonitor: GVolumeMonitor; uuid: cstring): GVolume {.cdecl.}
    getMountForUuid*: proc (volumeMonitor: GVolumeMonitor; uuid: cstring): GMount {.cdecl.}
    adoptOrphanMount*: proc (mount: GMount; volumeMonitor: GVolumeMonitor): GVolume {.cdecl.}
    driveEjectButton*: proc (volumeMonitor: GVolumeMonitor; drive: GDrive) {.cdecl.}
    driveStopButton*: proc (volumeMonitor: GVolumeMonitor; drive: GDrive) {.cdecl.}
    gReserved251*: proc () {.cdecl.}
    gReserved252*: proc () {.cdecl.}
    gReserved253*: proc () {.cdecl.}
    gReserved254*: proc () {.cdecl.}
    gReserved255*: proc () {.cdecl.}
    gReserved256*: proc () {.cdecl.}

proc volumeMonitorGetType*(): GType {.importc: "g_volume_monitor_get_type",
                                    libgio.}
proc volumeMonitorGet*(): GVolumeMonitor {.importc: "g_volume_monitor_get",
    libgio.}
proc getConnectedDrives*(volumeMonitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_connected_drives", libgio.}
proc connectedDrives*(volumeMonitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_connected_drives", libgio.}
proc getVolumes*(volumeMonitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_volumes", libgio.}
proc volumes*(volumeMonitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_volumes", libgio.}
proc getMounts*(volumeMonitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_mounts", libgio.}
proc mounts*(volumeMonitor: GVolumeMonitor): GList {.
    importc: "g_volume_monitor_get_mounts", libgio.}
proc getVolumeForUuid*(volumeMonitor: GVolumeMonitor;
                                    uuid: cstring): GVolume {.
    importc: "g_volume_monitor_get_volume_for_uuid", libgio.}
proc volumeForUuid*(volumeMonitor: GVolumeMonitor;
                                    uuid: cstring): GVolume {.
    importc: "g_volume_monitor_get_volume_for_uuid", libgio.}
proc getMountForUuid*(volumeMonitor: GVolumeMonitor; uuid: cstring): GMount {.
    importc: "g_volume_monitor_get_mount_for_uuid", libgio.}
proc mountForUuid*(volumeMonitor: GVolumeMonitor; uuid: cstring): GMount {.
    importc: "g_volume_monitor_get_mount_for_uuid", libgio.}
proc volumeMonitorAdoptOrphanMount*(mount: GMount): GVolume {.
    importc: "g_volume_monitor_adopt_orphan_mount", libgio.}

template gTypeNativeVolumeMonitor*(): untyped =
  (nativeVolumeMonitorGetType())

template gNativeVolumeMonitor*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeNativeVolumeMonitor, GNativeVolumeMonitorObj))

template gNativeVolumeMonitorClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeNativeVolumeMonitor, GNativeVolumeMonitorClassObj))

template gIsNativeVolumeMonitor*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeNativeVolumeMonitor))

template gIsNativeVolumeMonitorClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeNativeVolumeMonitor))

const
  G_NATIVE_VOLUME_MONITOR_EXTENSION_POINT_NAME* = "gio-native-volume-monitor"

type
  GNativeVolumeMonitor* =  ptr GNativeVolumeMonitorObj
  GNativeVolumeMonitorPtr* = ptr GNativeVolumeMonitorObj
  GNativeVolumeMonitorObj*{.final.} = object of GVolumeMonitorObj

  GNativeVolumeMonitorClass* =  ptr GNativeVolumeMonitorClassObj
  GNativeVolumeMonitorClassPtr* = ptr GNativeVolumeMonitorClassObj
  GNativeVolumeMonitorClassObj*{.final.} = object of GVolumeMonitorClassObj
    getMountForMountPath*: proc (mountPath: cstring; cancellable: GCancellable): GMount {.cdecl.}

proc nativeVolumeMonitorGetType*(): GType {.
    importc: "g_native_volume_monitor_get_type", libgio.}

template gTypeNetworkAddress*(): untyped =
  (networkAddressGetType())

template gNetworkAddress*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeNetworkAddress, GNetworkAddressObj))

template gNetworkAddressClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeNetworkAddress, GNetworkAddressClassObj))

template gIsNetworkAddress*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeNetworkAddress))

template gIsNetworkAddressClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeNetworkAddress))

template gNetworkAddressGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeNetworkAddress, GNetworkAddressClassObj))

type
  GNetworkAddress* =  ptr GNetworkAddressObj
  GNetworkAddressPtr* = ptr GNetworkAddressObj
  GNetworkAddressObj*{.final.} = object of GObjectObj
    priv37: pointer

  GNetworkAddressClass* =  ptr GNetworkAddressClassObj
  GNetworkAddressClassPtr* = ptr GNetworkAddressClassObj
  GNetworkAddressClassObj*{.final.} = object of GObjectClassObj

proc networkAddressGetType*(): GType {.importc: "g_network_address_get_type",
                                     libgio.}
proc newNetworkAddress*(hostname: cstring; port: uint16): GSocketConnectable {.
    importc: "g_network_address_new", libgio.}
proc newNetworkAddress*(port: uint16): GSocketConnectable {.
    importc: "g_network_address_new_loopback", libgio.}
proc networkAddressParse*(hostAndPort: cstring; defaultPort: uint16;
                          error: var GError): GSocketConnectable {.
    importc: "g_network_address_parse", libgio.}
proc networkAddressParseUri*(uri: cstring; defaultPort: uint16;
                             error: var GError): GSocketConnectable {.
    importc: "g_network_address_parse_uri", libgio.}
proc getHostname*(`addr`: GNetworkAddress): cstring {.
    importc: "g_network_address_get_hostname", libgio.}
proc hostname*(`addr`: GNetworkAddress): cstring {.
    importc: "g_network_address_get_hostname", libgio.}
proc getPort*(`addr`: GNetworkAddress): uint16 {.
    importc: "g_network_address_get_port", libgio.}
proc port*(`addr`: GNetworkAddress): uint16 {.
    importc: "g_network_address_get_port", libgio.}
proc getScheme*(`addr`: GNetworkAddress): cstring {.
    importc: "g_network_address_get_scheme", libgio.}
proc scheme*(`addr`: GNetworkAddress): cstring {.
    importc: "g_network_address_get_scheme", libgio.}

const
  G_NETWORK_MONITOR_EXTENSION_POINT_NAME* = "gio-network-monitor"

template gTypeNetworkMonitor*(): untyped =
  (networkMonitorGetType())

template gNetworkMonitor*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeNetworkMonitor, GNetworkMonitorObj))

template gIsNetworkMonitor*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeNetworkMonitor))

template gNetworkMonitorGetInterface*(o: untyped): untyped =
  (gTypeInstanceGetInterface(o, gTypeNetworkMonitor, GNetworkMonitorInterfaceObj))

type
  GNetworkMonitorInterface* =  ptr GNetworkMonitorInterfaceObj
  GNetworkMonitorInterfacePtr* = ptr GNetworkMonitorInterfaceObj
  GNetworkMonitorInterfaceObj*{.final.} = object of GTypeInterfaceObj
    networkChanged*: proc (monitor: GNetworkMonitor; available: Gboolean) {.cdecl.}
    canReach*: proc (monitor: GNetworkMonitor;
                   connectable: GSocketConnectable;
                   cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    canReachAsync*: proc (monitor: GNetworkMonitor;
                        connectable: GSocketConnectable;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    canReachFinish*: proc (monitor: GNetworkMonitor; result: GAsyncResult;
                         error: var GError): Gboolean {.cdecl.}

proc networkMonitorGetType*(): GType {.importc: "g_network_monitor_get_type",
                                     libgio.}
proc networkMonitorGetDefault*(): GNetworkMonitor {.
    importc: "g_network_monitor_get_default", libgio.}
proc getNetworkAvailable*(monitor: GNetworkMonitor): Gboolean {.
    importc: "g_network_monitor_get_network_available", libgio.}
proc networkAvailable*(monitor: GNetworkMonitor): Gboolean {.
    importc: "g_network_monitor_get_network_available", libgio.}
proc getNetworkMetered*(monitor: GNetworkMonitor): Gboolean {.
    importc: "g_network_monitor_get_network_metered", libgio.}
proc networkMetered*(monitor: GNetworkMonitor): Gboolean {.
    importc: "g_network_monitor_get_network_metered", libgio.}
proc getConnectivity*(monitor: GNetworkMonitor): GNetworkConnectivity {.
    importc: "g_network_monitor_get_connectivity", libgio.}
proc connectivity*(monitor: GNetworkMonitor): GNetworkConnectivity {.
    importc: "g_network_monitor_get_connectivity", libgio.}
proc canReach*(monitor: GNetworkMonitor;
                             connectable: GSocketConnectable;
                             cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_network_monitor_can_reach", libgio.}
proc canReachAsync*(monitor: GNetworkMonitor;
                                  connectable: GSocketConnectable;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_network_monitor_can_reach_async", libgio.}
proc canReachFinish*(monitor: GNetworkMonitor;
                                   result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_network_monitor_can_reach_finish", libgio.}

template gTypeNetworkService*(): untyped =
  (networkServiceGetType())

template gNetworkService*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeNetworkService, GNetworkServiceObj))

template gNetworkServiceClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeNetworkService, GNetworkServiceClassObj))

template gIsNetworkService*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeNetworkService))

template gIsNetworkServiceClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeNetworkService))

template gNetworkServiceGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeNetworkService, GNetworkServiceClassObj))

type
  GNetworkService* =  ptr GNetworkServiceObj
  GNetworkServicePtr* = ptr GNetworkServiceObj
  GNetworkServiceObj*{.final.} = object of GObjectObj
    priv38: pointer

  GNetworkServiceClass* =  ptr GNetworkServiceClassObj
  GNetworkServiceClassPtr* = ptr GNetworkServiceClassObj
  GNetworkServiceClassObj*{.final.} = object of GObjectClassObj

proc networkServiceGetType*(): GType {.importc: "g_network_service_get_type",
                                     libgio.}
proc newNetworkService*(service: cstring; protocol: cstring; domain: cstring): GSocketConnectable {.
    importc: "g_network_service_new", libgio.}
proc getService*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_service", libgio.}
proc service*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_service", libgio.}
proc getProtocol*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_protocol", libgio.}
proc protocol*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_protocol", libgio.}
proc getDomain*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_domain", libgio.}
proc domain*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_domain", libgio.}
proc getScheme*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_scheme", libgio.}
proc scheme*(srv: GNetworkService): cstring {.
    importc: "g_network_service_get_scheme", libgio.}
proc setScheme*(srv: GNetworkService; scheme: cstring) {.
    importc: "g_network_service_set_scheme", libgio.}
proc `scheme=`*(srv: GNetworkService; scheme: cstring) {.
    importc: "g_network_service_set_scheme", libgio.}

template gTypePermission*(): untyped =
  (permissionGetType())

template gPermission*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypePermission, GPermissionObj))

template gPermissionClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypePermission, GPermissionClassObj))

template gIsPermission*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypePermission))

template gIsPermissionClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypePermission))

template gPermissionGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypePermission, GPermissionClassObj))

type
  GPermission* =  ptr GPermissionObj
  GPermissionPtr* = ptr GPermissionObj
  GPermissionObj*{.final.} = object of GObjectObj
    priv39: pointer

  GPermissionClass* =  ptr GPermissionClassObj
  GPermissionClassPtr* = ptr GPermissionClassObj
  GPermissionClassObj*{.final.} = object of GObjectClassObj
    acquire*: proc (permission: GPermission; cancellable: GCancellable;
                  error: var GError): Gboolean {.cdecl.}
    acquireAsync*: proc (permission: GPermission; cancellable: GCancellable;
                       callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    acquireFinish*: proc (permission: GPermission; result: GAsyncResult;
                        error: var GError): Gboolean {.cdecl.}
    release*: proc (permission: GPermission; cancellable: GCancellable;
                  error: var GError): Gboolean {.cdecl.}
    releaseAsync*: proc (permission: GPermission; cancellable: GCancellable;
                       callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    releaseFinish*: proc (permission: GPermission; result: GAsyncResult;
                        error: var GError): Gboolean {.cdecl.}
    reserved: array[16, Gpointer]

proc permissionGetType*(): GType {.importc: "g_permission_get_type", libgio.}
proc acquire*(permission: GPermission; cancellable: GCancellable;
                        error: var GError): Gboolean {.
    importc: "g_permission_acquire", libgio.}
proc acquireAsync*(permission: GPermission;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_permission_acquire_async", libgio.}
proc acquireFinish*(permission: GPermission;
                              result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_permission_acquire_finish", libgio.}
proc release*(permission: GPermission; cancellable: GCancellable;
                        error: var GError): Gboolean {.
    importc: "g_permission_release", libgio.}
proc releaseAsync*(permission: GPermission;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_permission_release_async", libgio.}
proc releaseFinish*(permission: GPermission;
                              result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_permission_release_finish", libgio.}
proc getAllowed*(permission: GPermission): Gboolean {.
    importc: "g_permission_get_allowed", libgio.}
proc allowed*(permission: GPermission): Gboolean {.
    importc: "g_permission_get_allowed", libgio.}
proc getCanAcquire*(permission: GPermission): Gboolean {.
    importc: "g_permission_get_can_acquire", libgio.}
proc canAcquire*(permission: GPermission): Gboolean {.
    importc: "g_permission_get_can_acquire", libgio.}
proc getCanRelease*(permission: GPermission): Gboolean {.
    importc: "g_permission_get_can_release", libgio.}
proc canRelease*(permission: GPermission): Gboolean {.
    importc: "g_permission_get_can_release", libgio.}
proc implUpdate*(permission: GPermission; allowed: Gboolean;
                           canAcquire: Gboolean; canRelease: Gboolean) {.
    importc: "g_permission_impl_update", libgio.}

template gTypePollableInputStream*(): untyped =
  (pollableInputStreamGetType())

template gPollableInputStream*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypePollableInputStream, GPollableInputStreamObj))

template gIsPollableInputStream*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypePollableInputStream))

template gPollableInputStreamGetInterface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypePollableInputStream, GPollableInputStreamInterfaceObj))

type
  GPollableInputStreamInterface* =  ptr GPollableInputStreamInterfaceObj
  GPollableInputStreamInterfacePtr* = ptr GPollableInputStreamInterfaceObj
  GPollableInputStreamInterfaceObj*{.final.} = object of GTypeInterfaceObj
    canPoll*: proc (stream: GPollableInputStream): Gboolean {.cdecl.}
    isReadable*: proc (stream: GPollableInputStream): Gboolean {.cdecl.}
    createSource*: proc (stream: GPollableInputStream;
                       cancellable: GCancellable): glib.GSource {.cdecl.}
    readNonblocking*: proc (stream: GPollableInputStream; buffer: pointer;
                          count: Gsize; error: var GError): Gssize {.cdecl.}

proc pollableInputStreamGetType*(): GType {.
    importc: "g_pollable_input_stream_get_type", libgio.}
proc canPoll*(stream: GPollableInputStream): Gboolean {.
    importc: "g_pollable_input_stream_can_poll", libgio.}
proc isReadable*(stream: GPollableInputStream): Gboolean {.
    importc: "g_pollable_input_stream_is_readable", libgio.}
proc createSource*(stream: GPollableInputStream;
                                      cancellable: GCancellable): glib.GSource {.
    importc: "g_pollable_input_stream_create_source", libgio.}
proc readNonblocking*(stream: GPollableInputStream;
    buffer: pointer; count: Gsize; cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_pollable_input_stream_read_nonblocking", libgio.}

template gTypePollableOutputStream*(): untyped =
  (pollableOutputStreamGetType())

template gPollableOutputStream*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypePollableOutputStream, GPollableOutputStreamObj))

template gIsPollableOutputStream*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypePollableOutputStream))

template gPollableOutputStreamGetInterface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypePollableOutputStream, GPollableOutputStreamInterfaceObj))

type
  GPollableOutputStreamInterface* =  ptr GPollableOutputStreamInterfaceObj
  GPollableOutputStreamInterfacePtr* = ptr GPollableOutputStreamInterfaceObj
  GPollableOutputStreamInterfaceObj*{.final.} = object of GTypeInterfaceObj
    canPoll*: proc (stream: GPollableOutputStream): Gboolean {.cdecl.}
    isWritable*: proc (stream: GPollableOutputStream): Gboolean {.cdecl.}
    createSource*: proc (stream: GPollableOutputStream;
                       cancellable: GCancellable): glib.GSource {.cdecl.}
    writeNonblocking*: proc (stream: GPollableOutputStream; buffer: pointer;
                           count: Gsize; error: var GError): Gssize {.cdecl.}

proc pollableOutputStreamGetType*(): GType {.
    importc: "g_pollable_output_stream_get_type", libgio.}
proc canPoll*(stream: GPollableOutputStream): Gboolean {.
    importc: "g_pollable_output_stream_can_poll", libgio.}
proc isWritable*(stream: GPollableOutputStream): Gboolean {.
    importc: "g_pollable_output_stream_is_writable", libgio.}
proc createSource*(stream: GPollableOutputStream;
                                       cancellable: GCancellable): glib.GSource {.
    importc: "g_pollable_output_stream_create_source", libgio.}
proc writeNonblocking*(stream: GPollableOutputStream;
    buffer: pointer; count: Gsize; cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_pollable_output_stream_write_nonblocking", libgio.}

proc newPollableSource*(pollableStream: GObject): glib.GSource {.
    importc: "g_pollable_source_new", libgio.}
proc newPollableSource*(pollableStream: Gpointer; childSource: glib.GSource;
                            cancellable: GCancellable): glib.GSource {.
    importc: "g_pollable_source_new_full", libgio.}
proc pollableStreamRead*(stream: GInputStream; buffer: pointer; count: Gsize;
                         blocking: Gboolean; cancellable: GCancellable;
                         error: var GError): Gssize {.
    importc: "g_pollable_stream_read", libgio.}
proc pollableStreamWrite*(stream: GOutputStream; buffer: pointer; count: Gsize;
                          blocking: Gboolean; cancellable: GCancellable;
                          error: var GError): Gssize {.
    importc: "g_pollable_stream_write", libgio.}
proc pollableStreamWriteAll*(stream: GOutputStream; buffer: pointer;
                             count: Gsize; blocking: Gboolean;
                             bytesWritten: var Gsize;
                             cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_pollable_stream_write_all", libgio.}

template gTypePropertyAction*(): untyped =
  (propertyActionGetType())

template gPropertyAction*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypePropertyAction, GPropertyActionObj))

template gIsPropertyAction*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypePropertyAction))

proc propertyActionGetType*(): GType {.importc: "g_property_action_get_type",
                                     libgio.}
proc newPropertyAction*(name: cstring; `object`: Gpointer; propertyName: cstring): GPropertyAction {.
    importc: "g_property_action_new", libgio.}

template gTypeProxy*(): untyped =
  (proxyGetType())

template gProxy*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeProxy, GProxyObj))

template gIsProxy*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeProxy))

template gProxyGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeProxy, GProxyInterfaceObj))

const
  G_PROXY_EXTENSION_POINT_NAME* = "gio-proxy"

type
  GProxyAddress* =  ptr GProxyAddressObj
  GProxyAddressPtr* = ptr GProxyAddressObj
  GProxyAddressObj*{.final.} = object of GInetSocketAddressObj
    priv40: pointer

  GProxyAddressClass* =  ptr GProxyAddressClassObj
  GProxyAddressClassPtr* = ptr GProxyAddressClassObj
  GProxyAddressClassObj*{.final.} = object of GInetSocketAddressClassObj
type
  GProxyInterface* =  ptr GProxyInterfaceObj
  GProxyInterfacePtr* = ptr GProxyInterfaceObj
  GProxyInterfaceObj*{.final.} = object of GTypeInterfaceObj
    connect*: proc (proxy: GProxy; connection: GIOStream;
                  proxyAddress: GProxyAddress; cancellable: GCancellable;
                  error: var GError): GIOStream {.cdecl.}
    connectAsync*: proc (proxy: GProxy; connection: GIOStream;
                       proxyAddress: GProxyAddress;
                       cancellable: GCancellable;
                       callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    connectFinish*: proc (proxy: GProxy; result: GAsyncResult;
                        error: var GError): GIOStream {.cdecl.}
    supportsHostname*: proc (proxy: GProxy): Gboolean {.cdecl.}

proc proxyGetType*(): GType {.importc: "g_proxy_get_type", libgio.}
proc proxyGetDefaultForProtocol*(protocol: cstring): GProxy {.
    importc: "g_proxy_get_default_for_protocol", libgio.}
proc connect*(proxy: GProxy; connection: GIOStream;
                   proxyAddress: GProxyAddress; cancellable: GCancellable;
                   error: var GError): GIOStream {.importc: "g_proxy_connect",
    libgio.}
proc connectAsync*(proxy: GProxy; connection: GIOStream;
                        proxyAddress: GProxyAddress;
                        cancellable: GCancellable;
                        callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_proxy_connect_async", libgio.}
proc connectFinish*(proxy: GProxy; result: GAsyncResult;
                         error: var GError): GIOStream {.
    importc: "g_proxy_connect_finish", libgio.}
proc supportsHostname*(proxy: GProxy): Gboolean {.
    importc: "g_proxy_supports_hostname", libgio.}

template gTypeProxyAddress*(): untyped =
  (proxyAddressGetType())

template gProxyAddress*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeProxyAddress, GProxyAddressObj))

template gProxyAddressClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeProxyAddress, GProxyAddressClassObj))

template gIsProxyAddress*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeProxyAddress))

template gIsProxyAddressClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeProxyAddress))

template gProxyAddressGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeProxyAddress, GProxyAddressClassObj))

proc proxyAddressGetType*(): GType {.importc: "g_proxy_address_get_type",
                                   libgio.}
proc newProxyAddress*(inetaddr: GInetAddress; port: uint16; protocol: cstring;
                      destHostname: cstring; destPort: uint16; username: cstring;
                      password: cstring): GSocketAddress {.
    importc: "g_proxy_address_new", libgio.}
proc getProtocol*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_protocol", libgio.}
proc protocol*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_protocol", libgio.}
proc getDestinationProtocol*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_destination_protocol", libgio.}
proc destinationProtocol*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_destination_protocol", libgio.}
proc getDestinationHostname*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_destination_hostname", libgio.}
proc destinationHostname*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_destination_hostname", libgio.}
proc getDestinationPort*(proxy: GProxyAddress): uint16 {.
    importc: "g_proxy_address_get_destination_port", libgio.}
proc destinationPort*(proxy: GProxyAddress): uint16 {.
    importc: "g_proxy_address_get_destination_port", libgio.}
proc getUsername*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_username", libgio.}
proc username*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_username", libgio.}
proc getPassword*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_password", libgio.}
proc password*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_password", libgio.}
proc getUri*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_uri", libgio.}
proc uri*(proxy: GProxyAddress): cstring {.
    importc: "g_proxy_address_get_uri", libgio.}

template gTypeSocketAddressEnumerator*(): untyped =
  (socketAddressEnumeratorGetType())

template gSocketAddressEnumerator*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeSocketAddressEnumerator, GSocketAddressEnumeratorObj))

template gSocketAddressEnumeratorClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeSocketAddressEnumerator, GSocketAddressEnumeratorClassObj))

template gIsSocketAddressEnumerator*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeSocketAddressEnumerator))

template gIsSocketAddressEnumeratorClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeSocketAddressEnumerator))

template gSocketAddressEnumeratorGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeSocketAddressEnumerator, GSocketAddressEnumeratorClassObj))

type
  GSocketAddressEnumerator* =  ptr GSocketAddressEnumeratorObj
  GSocketAddressEnumeratorPtr* = ptr GSocketAddressEnumeratorObj
  GSocketAddressEnumeratorObj* = object of GObjectObj

  GSocketAddressEnumeratorClass* =  ptr GSocketAddressEnumeratorClassObj
  GSocketAddressEnumeratorClassPtr* = ptr GSocketAddressEnumeratorClassObj
  GSocketAddressEnumeratorClassObj* = object of GObjectClassObj
    next*: proc (enumerator: GSocketAddressEnumerator;
               cancellable: GCancellable; error: var GError): GSocketAddress {.cdecl.}
    nextAsync*: proc (enumerator: GSocketAddressEnumerator;
                    cancellable: GCancellable; callback: GAsyncReadyCallback;
                    userData: Gpointer) {.cdecl.}
    nextFinish*: proc (enumerator: GSocketAddressEnumerator;
                     result: GAsyncResult; error: var GError): GSocketAddress {.cdecl.}

proc socketAddressEnumeratorGetType*(): GType {.
    importc: "g_socket_address_enumerator_get_type", libgio.}
proc next*(enumerator: GSocketAddressEnumerator;
                                  cancellable: GCancellable;
                                  error: var GError): GSocketAddress {.
    importc: "g_socket_address_enumerator_next", libgio.}
proc nextAsync*(enumerator: GSocketAddressEnumerator;
                                       cancellable: GCancellable;
                                       callback: GAsyncReadyCallback;
                                       userData: Gpointer) {.
    importc: "g_socket_address_enumerator_next_async", libgio.}
proc nextFinish*(enumerator: GSocketAddressEnumerator;
                                        result: GAsyncResult;
                                        error: var GError): GSocketAddress {.
    importc: "g_socket_address_enumerator_next_finish", libgio.}

template gTypeProxyAddressEnumerator*(): untyped =
  (proxyAddressEnumeratorGetType())

template gProxyAddressEnumerator*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeProxyAddressEnumerator, GProxyAddressEnumeratorObj))

template gProxyAddressEnumeratorClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeProxyAddressEnumerator, GProxyAddressEnumeratorClassObj))

template gIsProxyAddressEnumerator*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeProxyAddressEnumerator))

template gIsProxyAddressEnumeratorClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeProxyAddressEnumerator))

template gProxyAddressEnumeratorGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeProxyAddressEnumerator, GProxyAddressEnumeratorClassObj))

type
  GProxyAddressEnumerator* =  ptr GProxyAddressEnumeratorObj
  GProxyAddressEnumeratorPtr* = ptr GProxyAddressEnumeratorObj
  GProxyAddressEnumeratorObj*{.final.} = object of GSocketAddressEnumeratorObj
    priv41: pointer

  GProxyAddressEnumeratorClass* =  ptr GProxyAddressEnumeratorClassObj
  GProxyAddressEnumeratorClassPtr* = ptr GProxyAddressEnumeratorClassObj
  GProxyAddressEnumeratorClassObj*{.final.} = object of GSocketAddressEnumeratorClassObj
    gReserved261*: proc () {.cdecl.}
    gReserved262*: proc () {.cdecl.}
    gReserved263*: proc () {.cdecl.}
    gReserved264*: proc () {.cdecl.}
    gReserved265*: proc () {.cdecl.}
    gReserved266*: proc () {.cdecl.}
    gReserved267*: proc () {.cdecl.}

proc proxyAddressEnumeratorGetType*(): GType {.
    importc: "g_proxy_address_enumerator_get_type", libgio.}

template gTypeProxyResolver*(): untyped =
  (proxyResolverGetType())

template gProxyResolver*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeProxyResolver, GProxyResolverObj))

template gIsProxyResolver*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeProxyResolver))

template gProxyResolverGetIface*(o: untyped): untyped =
  (gTypeInstanceGetInterface(o, gTypeProxyResolver, GProxyResolverInterfaceObj))

const
  G_PROXY_RESOLVER_EXTENSION_POINT_NAME* = "gio-proxy-resolver"

type
  GProxyResolverInterface* =  ptr GProxyResolverInterfaceObj
  GProxyResolverInterfacePtr* = ptr GProxyResolverInterfaceObj
  GProxyResolverInterfaceObj*{.final.} = object of GTypeInterfaceObj
    isSupported*: proc (resolver: GProxyResolver): Gboolean {.cdecl.}
    lookup*: proc (resolver: GProxyResolver; uri: cstring;
                 cancellable: GCancellable; error: var GError): cstringArray {.cdecl.}
    lookupAsync*: proc (resolver: GProxyResolver; uri: cstring;
                      cancellable: GCancellable; callback: GAsyncReadyCallback;
                      userData: Gpointer) {.cdecl.}
    lookupFinish*: proc (resolver: GProxyResolver; result: GAsyncResult;
                       error: var GError): cstringArray {.cdecl.}

proc proxyResolverGetType*(): GType {.importc: "g_proxy_resolver_get_type",
                                    libgio.}
proc proxyResolverGetDefault*(): GProxyResolver {.
    importc: "g_proxy_resolver_get_default", libgio.}
proc isSupported*(resolver: GProxyResolver): Gboolean {.
    importc: "g_proxy_resolver_is_supported", libgio.}
proc lookup*(resolver: GProxyResolver; uri: cstring;
                          cancellable: GCancellable; error: var GError): cstringArray {.
    importc: "g_proxy_resolver_lookup", libgio.}
proc lookupAsync*(resolver: GProxyResolver; uri: cstring;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_proxy_resolver_lookup_async", libgio.}
proc lookupFinish*(resolver: GProxyResolver;
                                result: GAsyncResult; error: var GError): cstringArray {.
    importc: "g_proxy_resolver_lookup_finish", libgio.}

template gTypeResolver*(): untyped =
  (resolverGetType())

template gResolver*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeResolver, GResolverObj))

template gResolverClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeResolver, GResolverClassObj))

template gIsResolver*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeResolver))

template gIsResolverClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeResolver))

template gResolverGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeResolver, GResolverClassObj))

type
  GResolver* =  ptr GResolverObj
  GResolverPtr* = ptr GResolverObj
  GResolverObj*{.final.} = object of GObjectObj
    priv42: pointer

  GResolverClass* =  ptr GResolverClassObj
  GResolverClassPtr* = ptr GResolverClassObj
  GResolverClassObj*{.final.} = object of GObjectClassObj
    reload*: proc (resolver: GResolver) {.cdecl.}
    lookupByName*: proc (resolver: GResolver; hostname: cstring;
                       cancellable: GCancellable; error: var GError): GList {.cdecl.}
    lookupByNameAsync*: proc (resolver: GResolver; hostname: cstring;
                            cancellable: GCancellable;
                            callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    lookupByNameFinish*: proc (resolver: GResolver; result: GAsyncResult;
                             error: var GError): GList {.cdecl.}
    lookupByAddress*: proc (resolver: GResolver; address: GInetAddress;
                          cancellable: GCancellable; error: var GError): cstring {.cdecl.}
    lookupByAddressAsync*: proc (resolver: GResolver; address: GInetAddress;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    lookupByAddressFinish*: proc (resolver: GResolver; result: GAsyncResult;
                                error: var GError): cstring {.cdecl.}
    lookupService*: proc (resolver: GResolver; rrname: cstring;
                        cancellable: GCancellable; error: var GError): GList {.cdecl.}
    lookupServiceAsync*: proc (resolver: GResolver; rrname: cstring;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    lookupServiceFinish*: proc (resolver: GResolver; result: GAsyncResult;
                              error: var GError): GList {.cdecl.}
    lookupRecords*: proc (resolver: GResolver; rrname: cstring;
                        recordType: GResolverRecordType;
                        cancellable: GCancellable; error: var GError): GList {.cdecl.}
    lookupRecordsAsync*: proc (resolver: GResolver; rrname: cstring;
                             recordType: GResolverRecordType;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    lookupRecordsFinish*: proc (resolver: GResolver; result: GAsyncResult;
                              error: var GError): GList {.cdecl.}
    gReserved274*: proc () {.cdecl.}
    gReserved275*: proc () {.cdecl.}
    gReserved276*: proc () {.cdecl.}

proc resolverGetType*(): GType {.importc: "g_resolver_get_type", libgio.}
proc resolverGetDefault*(): GResolver {.importc: "g_resolver_get_default",
    libgio.}
proc setDefault*(resolver: GResolver) {.
    importc: "g_resolver_set_default", libgio.}
proc `default=`*(resolver: GResolver) {.
    importc: "g_resolver_set_default", libgio.}
proc lookupByName*(resolver: GResolver; hostname: cstring;
                           cancellable: GCancellable; error: var GError): GList {.
    importc: "g_resolver_lookup_by_name", libgio.}
proc lookupByNameAsync*(resolver: GResolver; hostname: cstring;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_resolver_lookup_by_name_async", libgio.}
proc lookupByNameFinish*(resolver: GResolver; result: GAsyncResult;
                                 error: var GError): GList {.
    importc: "g_resolver_lookup_by_name_finish", libgio.}
proc resolverFreeAddresses*(addresses: GList) {.
    importc: "g_resolver_free_addresses", libgio.}
proc lookupByAddress*(resolver: GResolver; address: GInetAddress;
                              cancellable: GCancellable; error: var GError): cstring {.
    importc: "g_resolver_lookup_by_address", libgio.}
proc lookupByAddressAsync*(resolver: GResolver;
                                   address: GInetAddress;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_resolver_lookup_by_address_async", libgio.}
proc lookupByAddressFinish*(resolver: GResolver;
                                    result: GAsyncResult; error: var GError): cstring {.
    importc: "g_resolver_lookup_by_address_finish", libgio.}
proc lookupService*(resolver: GResolver; service: cstring;
                            protocol: cstring; domain: cstring;
                            cancellable: GCancellable; error: var GError): GList {.
    importc: "g_resolver_lookup_service", libgio.}
proc lookupServiceAsync*(resolver: GResolver; service: cstring;
                                 protocol: cstring; domain: cstring;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_resolver_lookup_service_async", libgio.}
proc lookupServiceFinish*(resolver: GResolver;
                                  result: GAsyncResult; error: var GError): GList {.
    importc: "g_resolver_lookup_service_finish", libgio.}
proc lookupRecords*(resolver: GResolver; rrname: cstring;
                            recordType: GResolverRecordType;
                            cancellable: GCancellable; error: var GError): GList {.
    importc: "g_resolver_lookup_records", libgio.}
proc lookupRecordsAsync*(resolver: GResolver; rrname: cstring;
                                 recordType: GResolverRecordType;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_resolver_lookup_records_async", libgio.}
proc lookupRecordsFinish*(resolver: GResolver;
                                  result: GAsyncResult; error: var GError): GList {.
    importc: "g_resolver_lookup_records_finish", libgio.}
proc resolverFreeTargets*(targets: GList) {.importc: "g_resolver_free_targets",
    libgio.}

template gResolverError*(): untyped =
  (gResolverErrorQuark())

proc resolverErrorQuark*(): GQuark {.importc: "g_resolver_error_quark", libgio.}

template gTypeResource*(): untyped =
  (resourceGetType())

template gResourceError*(): untyped =
  (gResourceErrorQuark())

proc resourceErrorQuark*(): GQuark {.importc: "g_resource_error_quark", libgio.}
type
  GStaticResource* =  ptr GStaticResourceObj
  GStaticResourcePtr* = ptr GStaticResourceObj
  GStaticResourceObj* = object
    data*: ptr uint8
    dataLen*: Gsize
    resource*: GResource
    next*: GStaticResource
    padding*: Gpointer

proc resourceGetType*(): GType {.importc: "g_resource_get_type", libgio.}
proc newResource*(data: glib.GBytes; error: var GError): GResource {.
    importc: "g_resource_new_from_data", libgio.}
proc `ref`*(resource: GResource): GResource {.
    importc: "g_resource_ref", libgio.}
proc unref*(resource: GResource) {.importc: "g_resource_unref",
    libgio.}
proc resourceLoad*(filename: cstring; error: var GError): GResource {.
    importc: "g_resource_load", libgio.}
proc openStream*(resource: GResource; path: cstring;
                         lookupFlags: GResourceLookupFlags; error: var GError): GInputStream {.
    importc: "g_resource_open_stream", libgio.}
proc lookupData*(resource: GResource; path: cstring;
                         lookupFlags: GResourceLookupFlags; error: var GError): glib.GBytes {.
    importc: "g_resource_lookup_data", libgio.}
proc enumerateChildren*(resource: GResource; path: cstring;
                                lookupFlags: GResourceLookupFlags;
                                error: var GError): cstringArray {.
    importc: "g_resource_enumerate_children", libgio.}
proc getInfo*(resource: GResource; path: cstring;
                      lookupFlags: GResourceLookupFlags; size: var Gsize;
                      flags: var uint32; error: var GError): Gboolean {.
    importc: "g_resource_get_info", libgio.}
proc info*(resource: GResource; path: cstring;
                      lookupFlags: GResourceLookupFlags; size: var Gsize;
                      flags: var uint32; error: var GError): Gboolean {.
    importc: "g_resource_get_info", libgio.}
proc sRegister*(resource: GResource) {.importc: "g_resources_register",
    libgio.}
proc sUnregister*(resource: GResource) {.
    importc: "g_resources_unregister", libgio.}
proc resourcesOpenStream*(path: cstring; lookupFlags: GResourceLookupFlags;
                          error: var GError): GInputStream {.
    importc: "g_resources_open_stream", libgio.}
proc resourcesLookupData*(path: cstring; lookupFlags: GResourceLookupFlags;
                          error: var GError): glib.GBytes {.
    importc: "g_resources_lookup_data", libgio.}
proc resourcesEnumerateChildren*(path: cstring; lookupFlags: GResourceLookupFlags;
                                 error: var GError): cstringArray {.
    importc: "g_resources_enumerate_children", libgio.}
proc resourcesGetInfo*(path: cstring; lookupFlags: GResourceLookupFlags;
                       size: var Gsize; flags: var uint32; error: var GError): Gboolean {.
    importc: "g_resources_get_info", libgio.}
proc init*(staticResource: GStaticResource) {.
    importc: "g_static_resource_init", libgio.}
proc fini*(staticResource: GStaticResource) {.
    importc: "g_static_resource_fini", libgio.}
proc getResource*(staticResource: GStaticResource): GResource {.
    importc: "g_static_resource_get_resource", libgio.}
proc resource*(staticResource: GStaticResource): GResource {.
    importc: "g_static_resource_get_resource", libgio.}

template gTypeSeekable*(): untyped =
  (seekableGetType())

template gSeekable*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeSeekable, GSeekableObj))

template gIsSeekable*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeSeekable))

template gSeekableGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeSeekable, GSeekableIfaceObj))

type
  GSeekableIface* =  ptr GSeekableIfaceObj
  GSeekableIfacePtr* = ptr GSeekableIfaceObj
  GSeekableIfaceObj*{.final.} = object of GTypeInterfaceObj
    tell*: proc (seekable: GSeekable): Goffset {.cdecl.}
    canSeek*: proc (seekable: GSeekable): Gboolean {.cdecl.}
    seek*: proc (seekable: GSeekable; offset: Goffset; `type`: GSeekType;
               cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}
    canTruncate*: proc (seekable: GSeekable): Gboolean {.cdecl.}
    truncateFn*: proc (seekable: GSeekable; offset: Goffset;
                     cancellable: GCancellable; error: var GError): Gboolean {.cdecl.}

proc seekableGetType*(): GType {.importc: "g_seekable_get_type", libgio.}
proc tell*(seekable: GSeekable): Goffset {.importc: "g_seekable_tell",
    libgio.}
proc canSeek*(seekable: GSeekable): Gboolean {.
    importc: "g_seekable_can_seek", libgio.}
proc seek*(seekable: GSeekable; offset: Goffset; `type`: GSeekType;
                   cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_seekable_seek", libgio.}
proc canTruncate*(seekable: GSeekable): Gboolean {.
    importc: "g_seekable_can_truncate", libgio.}
proc truncate*(seekable: GSeekable; offset: Goffset;
                       cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_seekable_truncate", libgio.}

type
  GSettingsSchemaSource* =  ptr GSettingsSchemaSourceObj
  GSettingsSchemaSourcePtr* = ptr GSettingsSchemaSourceObj
  GSettingsSchemaSourceObj* = object

  GSettingsSchema* =  ptr GSettingsSchemaObj
  GSettingsSchemaPtr* = ptr GSettingsSchemaObj
  GSettingsSchemaObj* = object

  GSettingsSchemaKey* =  ptr GSettingsSchemaKeyObj
  GSettingsSchemaKeyPtr* = ptr GSettingsSchemaKeyObj
  GSettingsSchemaKeyObj* = object

template gTypeSettingsSchemaSource*(): untyped =
  (settingsSchemaSourceGetType())

proc settingsSchemaSourceGetType*(): GType {.
    importc: "g_settings_schema_source_get_type", libgio.}
proc settingsSchemaSourceGetDefault*(): GSettingsSchemaSource {.
    importc: "g_settings_schema_source_get_default", libgio.}
proc `ref`*(source: GSettingsSchemaSource): GSettingsSchemaSource {.
    importc: "g_settings_schema_source_ref", libgio.}
proc unref*(source: GSettingsSchemaSource) {.
    importc: "g_settings_schema_source_unref", libgio.}
proc newSettingsSchemaSource*(directory: cstring;
    parent: GSettingsSchemaSource; trusted: Gboolean; error: var GError): GSettingsSchemaSource {.
    importc: "g_settings_schema_source_new_from_directory", libgio.}
proc lookup*(source: GSettingsSchemaSource;
                                 schemaId: cstring; recursive: Gboolean): GSettingsSchema {.
    importc: "g_settings_schema_source_lookup", libgio.}
proc listSchemas*(source: GSettingsSchemaSource;
                                      recursive: Gboolean;
                                      nonRelocatable: ptr cstringArray;
                                      relocatable: ptr cstringArray) {.
    importc: "g_settings_schema_source_list_schemas", libgio.}
template gTypeSettingsSchema*(): untyped =
  (settingsSchemaGetType())

proc settingsSchemaGetType*(): GType {.importc: "g_settings_schema_get_type",
                                     libgio.}
proc `ref`*(schema: GSettingsSchema): GSettingsSchema {.
    importc: "g_settings_schema_ref", libgio.}
proc unref*(schema: GSettingsSchema) {.
    importc: "g_settings_schema_unref", libgio.}
proc getId*(schema: GSettingsSchema): cstring {.
    importc: "g_settings_schema_get_id", libgio.}
proc id*(schema: GSettingsSchema): cstring {.
    importc: "g_settings_schema_get_id", libgio.}
proc getPath*(schema: GSettingsSchema): cstring {.
    importc: "g_settings_schema_get_path", libgio.}
proc path*(schema: GSettingsSchema): cstring {.
    importc: "g_settings_schema_get_path", libgio.}
proc getKey*(schema: GSettingsSchema; name: cstring): GSettingsSchemaKey {.
    importc: "g_settings_schema_get_key", libgio.}
proc key*(schema: GSettingsSchema; name: cstring): GSettingsSchemaKey {.
    importc: "g_settings_schema_get_key", libgio.}
proc hasKey*(schema: GSettingsSchema; name: cstring): Gboolean {.
    importc: "g_settings_schema_has_key", libgio.}
proc listKeys*(schema: GSettingsSchema): cstringArray {.
    importc: "g_settings_schema_list_keys", libgio.}
proc listChildren*(schema: GSettingsSchema): cstringArray {.
    importc: "g_settings_schema_list_children", libgio.}
template gTypeSettingsSchemaKey*(): untyped =
  (settingsSchemaKeyGetType())

proc settingsSchemaKeyGetType*(): GType {.importc: "g_settings_schema_key_get_type",
                                        libgio.}
proc `ref`*(key: GSettingsSchemaKey): GSettingsSchemaKey {.
    importc: "g_settings_schema_key_ref", libgio.}
proc unref*(key: GSettingsSchemaKey) {.
    importc: "g_settings_schema_key_unref", libgio.}
proc getValueType*(key: GSettingsSchemaKey): GVariantType {.
    importc: "g_settings_schema_key_get_value_type", libgio.}
proc valueType*(key: GSettingsSchemaKey): GVariantType {.
    importc: "g_settings_schema_key_get_value_type", libgio.}
proc getDefaultValue*(key: GSettingsSchemaKey): GVariant {.
    importc: "g_settings_schema_key_get_default_value", libgio.}
proc defaultValue*(key: GSettingsSchemaKey): GVariant {.
    importc: "g_settings_schema_key_get_default_value", libgio.}
proc getRange*(key: GSettingsSchemaKey): GVariant {.
    importc: "g_settings_schema_key_get_range", libgio.}
proc range*(key: GSettingsSchemaKey): GVariant {.
    importc: "g_settings_schema_key_get_range", libgio.}
proc rangeCheck*(key: GSettingsSchemaKey; value: GVariant): Gboolean {.
    importc: "g_settings_schema_key_range_check", libgio.}
proc getName*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_name", libgio.}
proc name*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_name", libgio.}
proc getSummary*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_summary", libgio.}
proc summary*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_summary", libgio.}
proc getDescription*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_description", libgio.}
proc description*(key: GSettingsSchemaKey): cstring {.
    importc: "g_settings_schema_key_get_description", libgio.}

template gTypeSettings*(): untyped =
  (settingsGetType())

template gSettings*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSettings, GSettingsObj))

template gSettingsClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeSettings, GSettingsClassObj))

template gIsSettings*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSettings))

template gIsSettingsClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeSettings))

template gSettingsGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeSettings, GSettingsClassObj))

type
  GSettingsClass* =  ptr GSettingsClassObj
  GSettingsClassPtr* = ptr GSettingsClassObj
  GSettingsClassObj*{.final.} = object of GObjectClassObj
    writableChanged*: proc (settings: GSettings; key: cstring) {.cdecl.}
    changed*: proc (settings: GSettings; key: cstring) {.cdecl.}
    writableChangeEvent*: proc (settings: GSettings; key: GQuark): Gboolean {.cdecl.}
    changeEvent*: proc (settings: GSettings; keys: ptr GQuark; nKeys: cint): Gboolean {.cdecl.}
    padding*: array[20, Gpointer]

  GSettings* =  ptr GSettingsObj
  GSettingsPtr* = ptr GSettingsObj
  GSettingsObj*{.final.} = object of GObjectObj
    priv43: pointer

proc settingsGetType*(): GType {.importc: "g_settings_get_type", libgio.}
proc settingsListSchemas*(): cstringArray {.importc: "g_settings_list_schemas",
    libgio.}
proc settingsListRelocatableSchemas*(): cstringArray {.
    importc: "g_settings_list_relocatable_schemas", libgio.}
proc newSettings*(schemaId: cstring): GSettings {.importc: "g_settings_new",
    libgio.}
proc newSettings*(schemaId: cstring; path: cstring): GSettings {.
    importc: "g_settings_new_with_path", libgio.}
proc newSettings*(schemaId: cstring; backend: GSettingsBackend): GSettings {.
    importc: "g_settings_new_with_backend", libgio.}
proc newSettings*(schemaId: cstring;
                                    backend: GSettingsBackend; path: cstring): GSettings {.
    importc: "g_settings_new_with_backend_and_path", libgio.}
proc newSettings*(schema: GSettingsSchema; backend: GSettingsBackend;
                      path: cstring): GSettings {.
    importc: "g_settings_new_full", libgio.}
proc listChildren*(settings: GSettings): cstringArray {.
    importc: "g_settings_list_children", libgio.}
proc listKeys*(settings: GSettings): cstringArray {.
    importc: "g_settings_list_keys", libgio.}
proc getRange*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_range", libgio.}
proc range*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_range", libgio.}
proc rangeCheck*(settings: GSettings; key: cstring; value: GVariant): Gboolean {.
    importc: "g_settings_range_check", libgio.}
proc setValue*(settings: GSettings; key: cstring; value: GVariant): Gboolean {.
    importc: "g_settings_set_value", libgio.}
proc getValue*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_value", libgio.}
proc value*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_value", libgio.}
proc getUserValue*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_user_value", libgio.}
proc userValue*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_user_value", libgio.}
proc getDefaultValue*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_default_value", libgio.}
proc defaultValue*(settings: GSettings; key: cstring): GVariant {.
    importc: "g_settings_get_default_value", libgio.}
proc set*(settings: GSettings; key: cstring; format: cstring): Gboolean {.
    varargs, importc: "g_settings_set", libgio.}
proc get*(settings: GSettings; key: cstring; format: cstring) {.varargs,
    importc: "g_settings_get", libgio.}
proc reset*(settings: GSettings; key: cstring) {.
    importc: "g_settings_reset", libgio.}
proc getInt*(settings: GSettings; key: cstring): cint {.
    importc: "g_settings_get_int", libgio.}
proc setInt*(settings: GSettings; key: cstring; value: cint): Gboolean {.
    importc: "g_settings_set_int", libgio.}
proc getInt64*(settings: GSettings; key: cstring): int64 {.
    importc: "g_settings_get_int64", libgio.}
proc setInt64*(settings: GSettings; key: cstring; value: int64): Gboolean {.
    importc: "g_settings_set_int64", libgio.}
proc getUint*(settings: GSettings; key: cstring): cuint {.
    importc: "g_settings_get_uint", libgio.}
proc setUint*(settings: GSettings; key: cstring; value: cuint): Gboolean {.
    importc: "g_settings_set_uint", libgio.}
proc getUint64*(settings: GSettings; key: cstring): uint64 {.
    importc: "g_settings_get_uint64", libgio.}
proc setUint64*(settings: GSettings; key: cstring; value: uint64): Gboolean {.
    importc: "g_settings_set_uint64", libgio.}
proc getString*(settings: GSettings; key: cstring): cstring {.
    importc: "g_settings_get_string", libgio.}
proc setString*(settings: GSettings; key: cstring; value: cstring): Gboolean {.
    importc: "g_settings_set_string", libgio.}
proc getBoolean*(settings: GSettings; key: cstring): Gboolean {.
    importc: "g_settings_get_boolean", libgio.}
proc setBoolean*(settings: GSettings; key: cstring; value: Gboolean): Gboolean {.
    importc: "g_settings_set_boolean", libgio.}
proc getDouble*(settings: GSettings; key: cstring): cdouble {.
    importc: "g_settings_get_double", libgio.}
proc setDouble*(settings: GSettings; key: cstring; value: cdouble): Gboolean {.
    importc: "g_settings_set_double", libgio.}
proc getStrv*(settings: GSettings; key: cstring): cstringArray {.
    importc: "g_settings_get_strv", libgio.}
proc strv*(settings: GSettings; key: cstring): cstringArray {.
    importc: "g_settings_get_strv", libgio.}
proc setStrv*(settings: GSettings; key: cstring; value: cstringArray): Gboolean {.
    importc: "g_settings_set_strv", libgio.}
proc getEnum*(settings: GSettings; key: cstring): cint {.
    importc: "g_settings_get_enum", libgio.}
proc setEnum*(settings: GSettings; key: cstring; value: cint): Gboolean {.
    importc: "g_settings_set_enum", libgio.}
proc getFlags*(settings: GSettings; key: cstring): cuint {.
    importc: "g_settings_get_flags", libgio.}
proc setFlags*(settings: GSettings; key: cstring; value: cuint): Gboolean {.
    importc: "g_settings_set_flags", libgio.}
proc getChild*(settings: GSettings; name: cstring): GSettings {.
    importc: "g_settings_get_child", libgio.}
proc child*(settings: GSettings; name: cstring): GSettings {.
    importc: "g_settings_get_child", libgio.}
proc isWritable*(settings: GSettings; name: cstring): Gboolean {.
    importc: "g_settings_is_writable", libgio.}
proc delay*(settings: GSettings) {.importc: "g_settings_delay",
    libgio.}
proc apply*(settings: GSettings) {.importc: "g_settings_apply",
    libgio.}
proc revert*(settings: GSettings) {.importc: "g_settings_revert",
    libgio.}
proc getHasUnapplied*(settings: GSettings): Gboolean {.
    importc: "g_settings_get_has_unapplied", libgio.}
proc hasUnapplied*(settings: GSettings): Gboolean {.
    importc: "g_settings_get_has_unapplied", libgio.}
proc settingsSync*() {.importc: "g_settings_sync", libgio.}

type
  GSettingsBindSetMapping* = proc (value: GValue; expectedType: GVariantType;
                                userData: Gpointer): GVariant {.cdecl.}

type
  GSettingsBindGetMapping* = proc (value: var GValueObj; variant: GVariant;
                                userData: Gpointer): Gboolean {.cdecl.}

type
  GSettingsGetMapping* = proc (value: GVariant; result: var Gpointer;
                            userData: Gpointer): Gboolean {.cdecl.}

type
  GSettingsBindFlags* {.size: sizeof(cint), pure.} = enum
    DEFAULT, GET = 1 shl 0,
    SET = 1 shl 1, NO_SENSITIVITY = 1 shl 2,
    GET_NO_CHANGES = 1 shl 3,
    INVERT_BOOLEAN = 1 shl 4

proc `bind`*(settings: GSettings; key: cstring; `object`: Gpointer;
                   property: cstring; flags: GSettingsBindFlags) {.
    importc: "g_settings_bind", libgio.}
proc bindWithMapping*(settings: GSettings; key: cstring;
                              `object`: Gpointer; property: cstring;
                              flags: GSettingsBindFlags;
                              getMapping: GSettingsBindGetMapping;
                              setMapping: GSettingsBindSetMapping;
                              userData: Gpointer; destroy: GDestroyNotify) {.
    importc: "g_settings_bind_with_mapping", libgio.}
proc bindWritable*(settings: GSettings; key: cstring; `object`: Gpointer;
                           property: cstring; inverted: Gboolean) {.
    importc: "g_settings_bind_writable", libgio.}
proc settingsUnbind*(`object`: Gpointer; property: cstring) {.
    importc: "g_settings_unbind", libgio.}
proc createAction*(settings: GSettings; key: cstring): GAction {.
    importc: "g_settings_create_action", libgio.}
proc getMapped*(settings: GSettings; key: cstring;
                        mapping: GSettingsGetMapping; userData: Gpointer): Gpointer {.
    importc: "g_settings_get_mapped", libgio.}
proc mapped*(settings: GSettings; key: cstring;
                        mapping: GSettingsGetMapping; userData: Gpointer): Gpointer {.
    importc: "g_settings_get_mapped", libgio.}

template gTypeSimpleAction*(): untyped =
  (simpleActionGetType())

template gSimpleAction*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSimpleAction, GSimpleActionObj))

template gIsSimpleAction*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSimpleAction))

proc simpleActionGetType*(): GType {.importc: "g_simple_action_get_type",
                                   libgio.}
proc newSimpleAction*(name: cstring; parameterType: GVariantType): GSimpleAction {.
    importc: "g_simple_action_new", libgio.}
proc newSimpleAction*(name: cstring; parameterType: GVariantType;
                              state: GVariant): GSimpleAction {.
    importc: "g_simple_action_new_stateful", libgio.}
proc setEnabled*(simple: GSimpleAction; enabled: Gboolean) {.
    importc: "g_simple_action_set_enabled", libgio.}
proc `enabled=`*(simple: GSimpleAction; enabled: Gboolean) {.
    importc: "g_simple_action_set_enabled", libgio.}
proc setState*(simple: GSimpleAction; value: GVariant) {.
    importc: "g_simple_action_set_state", libgio.}
proc `state=`*(simple: GSimpleAction; value: GVariant) {.
    importc: "g_simple_action_set_state", libgio.}
proc setStateHint*(simple: GSimpleAction; stateHint: GVariant) {.
    importc: "g_simple_action_set_state_hint", libgio.}
proc `stateHint=`*(simple: GSimpleAction; stateHint: GVariant) {.
    importc: "g_simple_action_set_state_hint", libgio.}

template gTypeSimpleActionGroup*(): untyped =
  (simpleActionGroupGetType())

template gSimpleActionGroup*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSimpleActionGroup, GSimpleActionGroupObj))

template gSimpleActionGroupClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeSimpleActionGroup, GSimpleActionGroupClassObj))

template gIsSimpleActionGroup*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSimpleActionGroup))

template gIsSimpleActionGroupClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeSimpleActionGroup))

template gSimpleActionGroupGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeSimpleActionGroup, GSimpleActionGroupClassObj))

type
  GSimpleActionGroup* =  ptr GSimpleActionGroupObj
  GSimpleActionGroupPtr* = ptr GSimpleActionGroupObj
  GSimpleActionGroupObj*{.final.} = object of GObjectObj
    priv44: pointer

  GSimpleActionGroupClass* =  ptr GSimpleActionGroupClassObj
  GSimpleActionGroupClassPtr* = ptr GSimpleActionGroupClassObj
  GSimpleActionGroupClassObj*{.final.} = object of GObjectClassObj
    padding*: array[12, Gpointer]

proc simpleActionGroupGetType*(): GType {.importc: "g_simple_action_group_get_type",
                                        libgio.}
proc newSimpleActionGroup*(): GSimpleActionGroup {.
    importc: "g_simple_action_group_new", libgio.}
proc lookup*(simple: GSimpleActionGroup; actionName: cstring): GAction {.
    importc: "g_simple_action_group_lookup", libgio.}
proc insert*(simple: GSimpleActionGroup; action: GAction) {.
    importc: "g_simple_action_group_insert", libgio.}
proc remove*(simple: GSimpleActionGroup; actionName: cstring) {.
    importc: "g_simple_action_group_remove", libgio.}
proc addEntries*(simple: GSimpleActionGroup;
                                  entries: GActionEntry; nEntries: cint;
                                  userData: Gpointer) {.
    importc: "g_simple_action_group_add_entries", libgio.}

template gTypeSimpleAsyncResult*(): untyped =
  (simpleAsyncResultGetType())

template gSimpleAsyncResult*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeSimpleAsyncResult, GSimpleAsyncResultObj))

template gSimpleAsyncResultClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeSimpleAsyncResult, GSimpleAsyncResultClassObj))

template gIsSimpleAsyncResult*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeSimpleAsyncResult))

template gIsSimpleAsyncResultClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeSimpleAsyncResult))

template gSimpleAsyncResultGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeSimpleAsyncResult, GSimpleAsyncResultClassObj))

type
  GSimpleAsyncResultClass* =  ptr GSimpleAsyncResultClassObj
  GSimpleAsyncResultClassPtr* = ptr GSimpleAsyncResultClassObj
  GSimpleAsyncResultClassObj* = object

proc simpleAsyncResultGetType*(): GType {.importc: "g_simple_async_result_get_type",
                                        libgio.}
proc newSimpleAsyncResult*(sourceObject: GObject;
                           callback: GAsyncReadyCallback; userData: Gpointer;
                           sourceTag: Gpointer): GSimpleAsyncResult {.
    importc: "g_simple_async_result_new", libgio.}
proc newSimpleAsyncResultError*(sourceObject: GObject;
                                callback: GAsyncReadyCallback; userData: Gpointer;
                                domain: GQuark; code: cint; format: cstring): GSimpleAsyncResult {.
    varargs, importc: "g_simple_async_result_new_error", libgio.}
proc newSimpleAsyncResultFromError*(sourceObject: GObject;
                                    callback: GAsyncReadyCallback;
                                    userData: Gpointer; error: GError): GSimpleAsyncResult {.
    importc: "g_simple_async_result_new_from_error", libgio.}
proc newSimpleAsyncResultTakeError*(sourceObject: GObject;
                                    callback: GAsyncReadyCallback;
                                    userData: Gpointer; error: GError): GSimpleAsyncResult {.
    importc: "g_simple_async_result_new_take_error", libgio.}
proc setOpResGpointer*(simple: GSimpleAsyncResult;
                                        opRes: Gpointer;
                                        destroyOpRes: GDestroyNotify) {.
    importc: "g_simple_async_result_set_op_res_gpointer", libgio.}
proc `opResGpointer=`*(simple: GSimpleAsyncResult;
                                        opRes: Gpointer;
                                        destroyOpRes: GDestroyNotify) {.
    importc: "g_simple_async_result_set_op_res_gpointer", libgio.}
proc getOpResGpointer*(simple: GSimpleAsyncResult): Gpointer {.
    importc: "g_simple_async_result_get_op_res_gpointer", libgio.}
proc opResGpointer*(simple: GSimpleAsyncResult): Gpointer {.
    importc: "g_simple_async_result_get_op_res_gpointer", libgio.}
proc setOpResGssize*(simple: GSimpleAsyncResult; opRes: Gssize) {.
    importc: "g_simple_async_result_set_op_res_gssize", libgio.}
proc `opResGssize=`*(simple: GSimpleAsyncResult; opRes: Gssize) {.
    importc: "g_simple_async_result_set_op_res_gssize", libgio.}
proc getOpResGssize*(simple: GSimpleAsyncResult): Gssize {.
    importc: "g_simple_async_result_get_op_res_gssize", libgio.}
proc opResGssize*(simple: GSimpleAsyncResult): Gssize {.
    importc: "g_simple_async_result_get_op_res_gssize", libgio.}
proc setOpResGboolean*(simple: GSimpleAsyncResult;
                                        opRes: Gboolean) {.
    importc: "g_simple_async_result_set_op_res_gboolean", libgio.}
proc `opResGboolean=`*(simple: GSimpleAsyncResult;
                                        opRes: Gboolean) {.
    importc: "g_simple_async_result_set_op_res_gboolean", libgio.}
proc getOpResGboolean*(simple: GSimpleAsyncResult): Gboolean {.
    importc: "g_simple_async_result_get_op_res_gboolean", libgio.}
proc opResGboolean*(simple: GSimpleAsyncResult): Gboolean {.
    importc: "g_simple_async_result_get_op_res_gboolean", libgio.}

proc setCheckCancellable*(simple: GSimpleAsyncResult;
    checkCancellable: GCancellable) {.importc: "g_simple_async_result_set_check_cancellable",
                                       libgio.}

proc `checkCancellable=`*(simple: GSimpleAsyncResult;
    checkCancellable: GCancellable) {.importc: "g_simple_async_result_set_check_cancellable",
                                       libgio.}
proc getSourceTag*(simple: GSimpleAsyncResult): Gpointer {.
    importc: "g_simple_async_result_get_source_tag", libgio.}
proc sourceTag*(simple: GSimpleAsyncResult): Gpointer {.
    importc: "g_simple_async_result_get_source_tag", libgio.}
proc setHandleCancellation*(simple: GSimpleAsyncResult;
    handleCancellation: Gboolean) {.importc: "g_simple_async_result_set_handle_cancellation",
                                  libgio.}
proc `handleCancellation=`*(simple: GSimpleAsyncResult;
    handleCancellation: Gboolean) {.importc: "g_simple_async_result_set_handle_cancellation",
                                  libgio.}
proc complete*(simple: GSimpleAsyncResult) {.
    importc: "g_simple_async_result_complete", libgio.}
proc completeInIdle*(simple: GSimpleAsyncResult) {.
    importc: "g_simple_async_result_complete_in_idle", libgio.}
proc runInThread*(simple: GSimpleAsyncResult;
                                   `func`: GSimpleAsyncThreadFunc;
                                   ioPriority: cint; cancellable: GCancellable) {.
    importc: "g_simple_async_result_run_in_thread", libgio.}
proc setFromError*(simple: GSimpleAsyncResult;
                                    error: GError) {.
    importc: "g_simple_async_result_set_from_error", libgio.}
proc `fromError=`*(simple: GSimpleAsyncResult;
                                    error: GError) {.
    importc: "g_simple_async_result_set_from_error", libgio.}
proc takeError*(simple: GSimpleAsyncResult; error: GError) {.
    importc: "g_simple_async_result_take_error", libgio.}
proc propagateError*(simple: GSimpleAsyncResult;
                                      dest: var GError): Gboolean {.
    importc: "g_simple_async_result_propagate_error", libgio.}
proc setError*(simple: GSimpleAsyncResult; domain: GQuark;
                                code: cint; format: cstring) {.varargs,
    importc: "g_simple_async_result_set_error", libgio.}
proc `error=`*(simple: GSimpleAsyncResult; domain: GQuark;
                                code: cint; format: cstring) {.varargs,
    importc: "g_simple_async_result_set_error", libgio.}
discard """
proc setErrorVa*(simple: GSimpleAsyncResult; domain: GQuark;
                                  code: cint; format: cstring; args: VaList) {.
    importc: "g_simple_async_result_set_error_va", libgio.}
proc `errorVa=`*(simple: GSimpleAsyncResult; domain: GQuark;
                                  code: cint; format: cstring; args: VaList) {.
    importc: "g_simple_async_result_set_error_va", libgio.}
"""
proc simpleAsyncResultIsValid*(result: GAsyncResult; source: GObject;
                               sourceTag: Gpointer): Gboolean {.
    importc: "g_simple_async_result_is_valid", libgio.}
proc simpleAsyncReportErrorInIdle*(`object`: GObject;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer; domain: GQuark; code: cint;
                                   format: cstring) {.varargs,
    importc: "g_simple_async_report_error_in_idle", libgio.}
proc simpleAsyncReportGerrorInIdle*(`object`: GObject;
                                    callback: GAsyncReadyCallback;
                                    userData: Gpointer; error: GError) {.
    importc: "g_simple_async_report_gerror_in_idle", libgio.}
proc simpleAsyncReportTakeGerrorInIdle*(`object`: GObject;
                                        callback: GAsyncReadyCallback;
                                        userData: Gpointer; error: GError) {.
    importc: "g_simple_async_report_take_gerror_in_idle", libgio.}

template gTypeSimpleIoStream*(): untyped =
  (simpleIoStreamGetType())

template gSimpleIoStream*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeSimpleIoStream, GSimpleIOStreamObj))

template gIsSimpleIoStream*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeSimpleIoStream))

proc simpleIoStreamGetType*(): GType {.importc: "g_simple_io_stream_get_type",
                                     libgio.}
proc newSimpleIoStream*(inputStream: GInputStream;
                        outputStream: GOutputStream): GIOStream {.
    importc: "g_simple_io_stream_new", libgio.}

template gTypeSimplePermission*(): untyped =
  (simplePermissionGetType())

template gSimplePermission*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSimplePermission, GSimplePermissionObj))

template gIsSimplePermission*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSimplePermission))

proc simplePermissionGetType*(): GType {.importc: "g_simple_permission_get_type",
                                       libgio.}
proc newSimplePermission*(allowed: Gboolean): GPermission {.
    importc: "g_simple_permission_new", libgio.}

template gTypeSocketClient*(): untyped =
  (socketClientGetType())

template gSocketClient*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSocketClient, GSocketClientObj))

template gSocketClientClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeSocketClient, GSocketClientClassObj))

template gIsSocketClient*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSocketClient))

template gIsSocketClientClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeSocketClient))

template gSocketClientGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeSocketClient, GSocketClientClassObj))

type
  GSocketConnectionClass* =  ptr GSocketConnectionClassObj
  GSocketConnectionClassPtr* = ptr GSocketConnectionClassObj
  GSocketConnectionClassObj* = object of GIOStreamClassObj
    gReserved281*: proc () {.cdecl.}
    gReserved282*: proc () {.cdecl.}
    gReserved283*: proc () {.cdecl.}
    gReserved284*: proc () {.cdecl.}
    gReserved285*: proc () {.cdecl.}
    gReserved286*: proc () {.cdecl.}

  GSocketConnection* =  ptr GSocketConnectionObj
  GSocketConnectionPtr* = ptr GSocketConnectionObj
  GSocketConnectionObj* = object of GIOStreamObj
    priv45: pointer
type
  GSocketClientClass* =  ptr GSocketClientClassObj
  GSocketClientClassPtr* = ptr GSocketClientClassObj
  GSocketClientClassObj*{.final.} = object of GObjectClassObj
    event*: proc (client: GSocketClient; event: GSocketClientEvent;
                connectable: GSocketConnectable; connection: GIOStream) {.cdecl.}
    gReserved291*: proc () {.cdecl.}
    gReserved292*: proc () {.cdecl.}
    gReserved293*: proc () {.cdecl.}
    gReserved294*: proc () {.cdecl.}

  GSocketClient* =  ptr GSocketClientObj
  GSocketClientPtr* = ptr GSocketClientObj
  GSocketClientObj*{.final.} = object of GObjectObj
    priv46: pointer

proc socketClientGetType*(): GType {.importc: "g_socket_client_get_type",
                                   libgio.}
proc newSocketClient*(): GSocketClient {.importc: "g_socket_client_new",
    libgio.}
proc getFamily*(client: GSocketClient): GSocketFamily {.
    importc: "g_socket_client_get_family", libgio.}
proc family*(client: GSocketClient): GSocketFamily {.
    importc: "g_socket_client_get_family", libgio.}
proc setFamily*(client: GSocketClient; family: GSocketFamily) {.
    importc: "g_socket_client_set_family", libgio.}
proc `family=`*(client: GSocketClient; family: GSocketFamily) {.
    importc: "g_socket_client_set_family", libgio.}
proc getSocketType*(client: GSocketClient): GSocketType {.
    importc: "g_socket_client_get_socket_type", libgio.}
proc socketType*(client: GSocketClient): GSocketType {.
    importc: "g_socket_client_get_socket_type", libgio.}
proc setSocketType*(client: GSocketClient; `type`: GSocketType) {.
    importc: "g_socket_client_set_socket_type", libgio.}
proc `socketType=`*(client: GSocketClient; `type`: GSocketType) {.
    importc: "g_socket_client_set_socket_type", libgio.}
proc getProtocol*(client: GSocketClient): GSocketProtocol {.
    importc: "g_socket_client_get_protocol", libgio.}
proc protocol*(client: GSocketClient): GSocketProtocol {.
    importc: "g_socket_client_get_protocol", libgio.}
proc setProtocol*(client: GSocketClient; protocol: GSocketProtocol) {.
    importc: "g_socket_client_set_protocol", libgio.}
proc `protocol=`*(client: GSocketClient; protocol: GSocketProtocol) {.
    importc: "g_socket_client_set_protocol", libgio.}
proc getLocalAddress*(client: GSocketClient): GSocketAddress {.
    importc: "g_socket_client_get_local_address", libgio.}
proc localAddress*(client: GSocketClient): GSocketAddress {.
    importc: "g_socket_client_get_local_address", libgio.}
proc setLocalAddress*(client: GSocketClient;
                                  address: GSocketAddress) {.
    importc: "g_socket_client_set_local_address", libgio.}
proc `localAddress=`*(client: GSocketClient;
                                  address: GSocketAddress) {.
    importc: "g_socket_client_set_local_address", libgio.}
proc getTimeout*(client: GSocketClient): cuint {.
    importc: "g_socket_client_get_timeout", libgio.}
proc timeout*(client: GSocketClient): cuint {.
    importc: "g_socket_client_get_timeout", libgio.}
proc setTimeout*(client: GSocketClient; timeout: cuint) {.
    importc: "g_socket_client_set_timeout", libgio.}
proc `timeout=`*(client: GSocketClient; timeout: cuint) {.
    importc: "g_socket_client_set_timeout", libgio.}
proc getEnableProxy*(client: GSocketClient): Gboolean {.
    importc: "g_socket_client_get_enable_proxy", libgio.}
proc enableProxy*(client: GSocketClient): Gboolean {.
    importc: "g_socket_client_get_enable_proxy", libgio.}
proc setEnableProxy*(client: GSocketClient; enable: Gboolean) {.
    importc: "g_socket_client_set_enable_proxy", libgio.}
proc `enableProxy=`*(client: GSocketClient; enable: Gboolean) {.
    importc: "g_socket_client_set_enable_proxy", libgio.}
proc getTls*(client: GSocketClient): Gboolean {.
    importc: "g_socket_client_get_tls", libgio.}
proc tls*(client: GSocketClient): Gboolean {.
    importc: "g_socket_client_get_tls", libgio.}
proc setTls*(client: GSocketClient; tls: Gboolean) {.
    importc: "g_socket_client_set_tls", libgio.}
proc `tls=`*(client: GSocketClient; tls: Gboolean) {.
    importc: "g_socket_client_set_tls", libgio.}
proc getTlsValidationFlags*(client: GSocketClient): GTlsCertificateFlags {.
    importc: "g_socket_client_get_tls_validation_flags", libgio.}
proc tlsValidationFlags*(client: GSocketClient): GTlsCertificateFlags {.
    importc: "g_socket_client_get_tls_validation_flags", libgio.}
proc setTlsValidationFlags*(client: GSocketClient;
                                        flags: GTlsCertificateFlags) {.
    importc: "g_socket_client_set_tls_validation_flags", libgio.}
proc `tlsValidationFlags=`*(client: GSocketClient;
                                        flags: GTlsCertificateFlags) {.
    importc: "g_socket_client_set_tls_validation_flags", libgio.}
proc getProxyResolver*(client: GSocketClient): GProxyResolver {.
    importc: "g_socket_client_get_proxy_resolver", libgio.}
proc proxyResolver*(client: GSocketClient): GProxyResolver {.
    importc: "g_socket_client_get_proxy_resolver", libgio.}
proc setProxyResolver*(client: GSocketClient;
                                   proxyResolver: GProxyResolver) {.
    importc: "g_socket_client_set_proxy_resolver", libgio.}
proc `proxyResolver=`*(client: GSocketClient;
                                   proxyResolver: GProxyResolver) {.
    importc: "g_socket_client_set_proxy_resolver", libgio.}
proc connect*(client: GSocketClient;
                          connectable: GSocketConnectable;
                          cancellable: GCancellable; error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect", libgio.}
proc connectToHost*(client: GSocketClient; hostAndPort: cstring;
                                defaultPort: uint16;
                                cancellable: GCancellable;
                                error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_host", libgio.}
proc connectToService*(client: GSocketClient; domain: cstring;
                                   service: cstring;
                                   cancellable: GCancellable;
                                   error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_service", libgio.}
proc connectToUri*(client: GSocketClient; uri: cstring;
                               defaultPort: uint16;
                               cancellable: GCancellable; error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_uri", libgio.}
proc connectAsync*(client: GSocketClient;
                               connectable: GSocketConnectable;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_socket_client_connect_async", libgio.}
proc connectFinish*(client: GSocketClient;
                                result: GAsyncResult; error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_finish", libgio.}
proc connectToHostAsync*(client: GSocketClient;
                                     hostAndPort: cstring; defaultPort: uint16;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     userData: Gpointer) {.
    importc: "g_socket_client_connect_to_host_async", libgio.}
proc connectToHostFinish*(client: GSocketClient;
                                      result: GAsyncResult;
                                      error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_host_finish", libgio.}
proc connectToServiceAsync*(client: GSocketClient; domain: cstring;
                                        service: cstring;
                                        cancellable: GCancellable;
                                        callback: GAsyncReadyCallback;
                                        userData: Gpointer) {.
    importc: "g_socket_client_connect_to_service_async", libgio.}
proc connectToServiceFinish*(client: GSocketClient;
    result: GAsyncResult; error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_service_finish", libgio.}
proc connectToUriAsync*(client: GSocketClient; uri: cstring;
                                    defaultPort: uint16;
                                    cancellable: GCancellable;
                                    callback: GAsyncReadyCallback;
                                    userData: Gpointer) {.
    importc: "g_socket_client_connect_to_uri_async", libgio.}
proc connectToUriFinish*(client: GSocketClient;
                                     result: GAsyncResult;
                                     error: var GError): GSocketConnection {.
    importc: "g_socket_client_connect_to_uri_finish", libgio.}
proc addApplicationProxy*(client: GSocketClient; protocol: cstring) {.
    importc: "g_socket_client_add_application_proxy", libgio.}

template gTypeSocketConnectable*(): untyped =
  (socketConnectableGetType())

template gSocketConnectable*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeSocketConnectable, GSocketConnectableObj))

template gIsSocketConnectable*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeSocketConnectable))

template gSocketConnectableGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeSocketConnectable, GSocketConnectableIfaceObj))

type
  GSocketConnectableIface* =  ptr GSocketConnectableIfaceObj
  GSocketConnectableIfacePtr* = ptr GSocketConnectableIfaceObj
  GSocketConnectableIfaceObj*{.final.} = object of GTypeInterfaceObj
    enumerate*: proc (connectable: GSocketConnectable): GSocketAddressEnumerator {.cdecl.}
    proxyEnumerate*: proc (connectable: GSocketConnectable): GSocketAddressEnumerator {.cdecl.}
    toString*: proc (connectable: GSocketConnectable): cstring {.cdecl.}

proc socketConnectableGetType*(): GType {.importc: "g_socket_connectable_get_type",
                                        libgio.}
proc enumerate*(connectable: GSocketConnectable): GSocketAddressEnumerator {.
    importc: "g_socket_connectable_enumerate", libgio.}
proc proxyEnumerate*(connectable: GSocketConnectable): GSocketAddressEnumerator {.
    importc: "g_socket_connectable_proxy_enumerate", libgio.}
proc toString*(connectable: GSocketConnectable): cstring {.
    importc: "g_socket_connectable_to_string", libgio.}

template gTypeSocket*(): untyped =
  (socketGetType())

template gSocket*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSocket, GSocketObj))

template gSocketClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeSocket, GSocketClassObj))

template gIsSocket*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSocket))

template gIsSocketClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeSocket))

template gSocketGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeSocket, GSocketClassObj))

proc socketGetType*(): GType {.importc: "g_socket_get_type", libgio.}
proc newSocket*(family: GSocketFamily; `type`: GSocketType;
                protocol: GSocketProtocol; error: var GError): GSocket {.
    importc: "g_socket_new", libgio.}
proc newSocket*(fd: cint; error: var GError): GSocket {.
    importc: "g_socket_new_from_fd", libgio.}
proc getFd*(socket: GSocket): cint {.importc: "g_socket_get_fd", libgio.}
proc fd*(socket: GSocket): cint {.importc: "g_socket_get_fd", libgio.}
proc getFamily*(socket: GSocket): GSocketFamily {.
    importc: "g_socket_get_family", libgio.}
proc family*(socket: GSocket): GSocketFamily {.
    importc: "g_socket_get_family", libgio.}
proc getSocketType*(socket: GSocket): GSocketType {.
    importc: "g_socket_get_socket_type", libgio.}
proc socketType*(socket: GSocket): GSocketType {.
    importc: "g_socket_get_socket_type", libgio.}
proc getProtocol*(socket: GSocket): GSocketProtocol {.
    importc: "g_socket_get_protocol", libgio.}
proc protocol*(socket: GSocket): GSocketProtocol {.
    importc: "g_socket_get_protocol", libgio.}
proc getLocalAddress*(socket: GSocket; error: var GError): GSocketAddress {.
    importc: "g_socket_get_local_address", libgio.}
proc localAddress*(socket: GSocket; error: var GError): GSocketAddress {.
    importc: "g_socket_get_local_address", libgio.}
proc getRemoteAddress*(socket: GSocket; error: var GError): GSocketAddress {.
    importc: "g_socket_get_remote_address", libgio.}
proc remoteAddress*(socket: GSocket; error: var GError): GSocketAddress {.
    importc: "g_socket_get_remote_address", libgio.}
proc setBlocking*(socket: GSocket; blocking: Gboolean) {.
    importc: "g_socket_set_blocking", libgio.}
proc `blocking=`*(socket: GSocket; blocking: Gboolean) {.
    importc: "g_socket_set_blocking", libgio.}
proc getBlocking*(socket: GSocket): Gboolean {.
    importc: "g_socket_get_blocking", libgio.}
proc blocking*(socket: GSocket): Gboolean {.
    importc: "g_socket_get_blocking", libgio.}
proc setKeepalive*(socket: GSocket; keepalive: Gboolean) {.
    importc: "g_socket_set_keepalive", libgio.}
proc `keepalive=`*(socket: GSocket; keepalive: Gboolean) {.
    importc: "g_socket_set_keepalive", libgio.}
proc getKeepalive*(socket: GSocket): Gboolean {.
    importc: "g_socket_get_keepalive", libgio.}
proc keepalive*(socket: GSocket): Gboolean {.
    importc: "g_socket_get_keepalive", libgio.}
proc getListenBacklog*(socket: GSocket): cint {.
    importc: "g_socket_get_listen_backlog", libgio.}
proc listenBacklog*(socket: GSocket): cint {.
    importc: "g_socket_get_listen_backlog", libgio.}
proc setListenBacklog*(socket: GSocket; backlog: cint) {.
    importc: "g_socket_set_listen_backlog", libgio.}
proc `listenBacklog=`*(socket: GSocket; backlog: cint) {.
    importc: "g_socket_set_listen_backlog", libgio.}
proc getTimeout*(socket: GSocket): cuint {.
    importc: "g_socket_get_timeout", libgio.}
proc timeout*(socket: GSocket): cuint {.
    importc: "g_socket_get_timeout", libgio.}
proc setTimeout*(socket: GSocket; timeout: cuint) {.
    importc: "g_socket_set_timeout", libgio.}
proc `timeout=`*(socket: GSocket; timeout: cuint) {.
    importc: "g_socket_set_timeout", libgio.}
proc getTtl*(socket: GSocket): cuint {.importc: "g_socket_get_ttl",
    libgio.}
proc ttl*(socket: GSocket): cuint {.importc: "g_socket_get_ttl",
    libgio.}
proc setTtl*(socket: GSocket; ttl: cuint) {.importc: "g_socket_set_ttl",
    libgio.}
proc `ttl=`*(socket: GSocket; ttl: cuint) {.importc: "g_socket_set_ttl",
    libgio.}
proc getBroadcast*(socket: GSocket): Gboolean {.
    importc: "g_socket_get_broadcast", libgio.}
proc broadcast*(socket: GSocket): Gboolean {.
    importc: "g_socket_get_broadcast", libgio.}
proc setBroadcast*(socket: GSocket; broadcast: Gboolean) {.
    importc: "g_socket_set_broadcast", libgio.}
proc `broadcast=`*(socket: GSocket; broadcast: Gboolean) {.
    importc: "g_socket_set_broadcast", libgio.}
proc getMulticastLoopback*(socket: GSocket): Gboolean {.
    importc: "g_socket_get_multicast_loopback", libgio.}
proc multicastLoopback*(socket: GSocket): Gboolean {.
    importc: "g_socket_get_multicast_loopback", libgio.}
proc setMulticastLoopback*(socket: GSocket; loopback: Gboolean) {.
    importc: "g_socket_set_multicast_loopback", libgio.}
proc `multicastLoopback=`*(socket: GSocket; loopback: Gboolean) {.
    importc: "g_socket_set_multicast_loopback", libgio.}
proc getMulticastTtl*(socket: GSocket): cuint {.
    importc: "g_socket_get_multicast_ttl", libgio.}
proc multicastTtl*(socket: GSocket): cuint {.
    importc: "g_socket_get_multicast_ttl", libgio.}
proc setMulticastTtl*(socket: GSocket; ttl: cuint) {.
    importc: "g_socket_set_multicast_ttl", libgio.}
proc `multicastTtl=`*(socket: GSocket; ttl: cuint) {.
    importc: "g_socket_set_multicast_ttl", libgio.}
proc isConnected*(socket: GSocket): Gboolean {.
    importc: "g_socket_is_connected", libgio.}
proc `bind`*(socket: GSocket; address: GSocketAddress;
                 allowReuse: Gboolean; error: var GError): Gboolean {.
    importc: "g_socket_bind", libgio.}
proc joinMulticastGroup*(socket: GSocket; group: GInetAddress;
                               sourceSpecific: Gboolean; iface: cstring;
                               error: var GError): Gboolean {.
    importc: "g_socket_join_multicast_group", libgio.}
proc leaveMulticastGroup*(socket: GSocket; group: GInetAddress;
                                sourceSpecific: Gboolean; iface: cstring;
                                error: var GError): Gboolean {.
    importc: "g_socket_leave_multicast_group", libgio.}
proc connect*(socket: GSocket; address: GSocketAddress;
                    cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_socket_connect", libgio.}
proc checkConnectResult*(socket: GSocket; error: var GError): Gboolean {.
    importc: "g_socket_check_connect_result", libgio.}
proc getAvailableBytes*(socket: GSocket): Gssize {.
    importc: "g_socket_get_available_bytes", libgio.}
proc availableBytes*(socket: GSocket): Gssize {.
    importc: "g_socket_get_available_bytes", libgio.}
proc conditionCheck*(socket: GSocket; condition: GIOCondition): GIOCondition {.
    importc: "g_socket_condition_check", libgio.}
proc conditionWait*(socket: GSocket; condition: GIOCondition;
                          cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_socket_condition_wait", libgio.}
proc conditionTimedWait*(socket: GSocket; condition: GIOCondition;
                               timeout: int64; cancellable: GCancellable;
                               error: var GError): Gboolean {.
    importc: "g_socket_condition_timed_wait", libgio.}
proc accept*(socket: GSocket; cancellable: GCancellable;
                   error: var GError): GSocket {.importc: "g_socket_accept",
    libgio.}
proc listen*(socket: GSocket; error: var GError): Gboolean {.
    importc: "g_socket_listen", libgio.}
proc receive*(socket: GSocket; buffer: cstring; size: Gsize;
                    cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_socket_receive", libgio.}
proc receiveFrom*(socket: GSocket; address: var GSocketAddress;
                        buffer: cstring; size: Gsize; cancellable: GCancellable;
                        error: var GError): Gssize {.
    importc: "g_socket_receive_from", libgio.}
proc send*(socket: GSocket; buffer: cstring; size: Gsize;
                 cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_socket_send", libgio.}
proc sendTo*(socket: GSocket; address: GSocketAddress; buffer: cstring;
                   size: Gsize; cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_socket_send_to", libgio.}
proc receiveMessage*(socket: GSocket; address: var GSocketAddress;
                           vectors: GInputVector; numVectors: cint;
                           messages: var ptr GSocketControlMessage;
                           numMessages: var cint; flags: var cint;
                           cancellable: GCancellable; error: var GError): Gssize {.
    importc: "g_socket_receive_message", libgio.}
proc sendMessage*(socket: GSocket; address: GSocketAddress;
                        vectors: GOutputVector; numVectors: cint;
                        messages: var GSocketControlMessage; numMessages: cint;
                        flags: cint; cancellable: GCancellable;
                        error: var GError): Gssize {.
    importc: "g_socket_send_message", libgio.}
proc receiveMessages*(socket: GSocket; messages: GInputMessage;
                            numMessages: cuint; flags: cint;
                            cancellable: GCancellable; error: var GError): cint {.
    importc: "g_socket_receive_messages", libgio.}
proc sendMessages*(socket: GSocket; messages: GOutputMessage;
                         numMessages: cuint; flags: cint;
                         cancellable: GCancellable; error: var GError): cint {.
    importc: "g_socket_send_messages", libgio.}
proc close*(socket: GSocket; error: var GError): Gboolean {.
    importc: "g_socket_close", libgio.}
proc shutdown*(socket: GSocket; shutdownRead: Gboolean;
                     shutdownWrite: Gboolean; error: var GError): Gboolean {.
    importc: "g_socket_shutdown", libgio.}
proc isClosed*(socket: GSocket): Gboolean {.importc: "g_socket_is_closed",
    libgio.}
proc createSource*(socket: GSocket; condition: GIOCondition;
                         cancellable: GCancellable): glib.GSource {.
    importc: "g_socket_create_source", libgio.}
proc speaksIpv4*(socket: GSocket): Gboolean {.
    importc: "g_socket_speaks_ipv4", libgio.}
proc getCredentials*(socket: GSocket; error: var GError): GCredentials {.
    importc: "g_socket_get_credentials", libgio.}
proc credentials*(socket: GSocket; error: var GError): GCredentials {.
    importc: "g_socket_get_credentials", libgio.}
proc receiveWithBlocking*(socket: GSocket; buffer: cstring; size: Gsize;
                                blocking: Gboolean; cancellable: GCancellable;
                                error: var GError): Gssize {.
    importc: "g_socket_receive_with_blocking", libgio.}
proc sendWithBlocking*(socket: GSocket; buffer: cstring; size: Gsize;
                             blocking: Gboolean; cancellable: GCancellable;
                             error: var GError): Gssize {.
    importc: "g_socket_send_with_blocking", libgio.}
proc getOption*(socket: GSocket; level: cint; optname: cint; value: var cint;
                      error: var GError): Gboolean {.
    importc: "g_socket_get_option", libgio.}
proc option*(socket: GSocket; level: cint; optname: cint; value: var cint;
                      error: var GError): Gboolean {.
    importc: "g_socket_get_option", libgio.}
proc setOption*(socket: GSocket; level: cint; optname: cint; value: cint;
                      error: var GError): Gboolean {.
    importc: "g_socket_set_option", libgio.}

template gTypeSocketConnection*(): untyped =
  (socketConnectionGetType())

template gSocketConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSocketConnection, GSocketConnectionObj))

template gSocketConnectionClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeSocketConnection, GSocketConnectionClassObj))

template gIsSocketConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSocketConnection))

template gIsSocketConnectionClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeSocketConnection))

template gSocketConnectionGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeSocketConnection, GSocketConnectionClassObj))

proc socketConnectionGetType*(): GType {.importc: "g_socket_connection_get_type",
                                       libgio.}
proc isConnected*(connection: GSocketConnection): Gboolean {.
    importc: "g_socket_connection_is_connected", libgio.}
proc connect*(connection: GSocketConnection;
                              address: GSocketAddress;
                              cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_socket_connection_connect", libgio.}
proc connectAsync*(connection: GSocketConnection;
                                   address: GSocketAddress;
                                   cancellable: GCancellable;
                                   callback: GAsyncReadyCallback;
                                   userData: Gpointer) {.
    importc: "g_socket_connection_connect_async", libgio.}
proc connectFinish*(connection: GSocketConnection;
                                    result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_socket_connection_connect_finish", libgio.}
proc getSocket*(connection: GSocketConnection): GSocket {.
    importc: "g_socket_connection_get_socket", libgio.}
proc socket*(connection: GSocketConnection): GSocket {.
    importc: "g_socket_connection_get_socket", libgio.}
proc getLocalAddress*(connection: GSocketConnection;
                                      error: var GError): GSocketAddress {.
    importc: "g_socket_connection_get_local_address", libgio.}
proc localAddress*(connection: GSocketConnection;
                                      error: var GError): GSocketAddress {.
    importc: "g_socket_connection_get_local_address", libgio.}
proc getRemoteAddress*(connection: GSocketConnection;
                                       error: var GError): GSocketAddress {.
    importc: "g_socket_connection_get_remote_address", libgio.}
proc remoteAddress*(connection: GSocketConnection;
                                       error: var GError): GSocketAddress {.
    importc: "g_socket_connection_get_remote_address", libgio.}
proc socketConnectionFactoryRegisterType*(gType: GType; family: GSocketFamily;
    `type`: GSocketType; protocol: cint) {.importc: "g_socket_connection_factory_register_type",
                                       libgio.}
proc socketConnectionFactoryLookupType*(family: GSocketFamily;
                                        `type`: GSocketType; protocolId: cint): GType {.
    importc: "g_socket_connection_factory_lookup_type", libgio.}
proc connectionFactoryCreateConnection*(socket: GSocket): GSocketConnection {.
    importc: "g_socket_connection_factory_create_connection", libgio.}

template gTypeSocketControlMessage*(): untyped =
  (socketControlMessageGetType())

template gSocketControlMessage*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSocketControlMessage, GSocketControlMessageObj))

template gSocketControlMessageClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeSocketControlMessage, GSocketControlMessageClassObj))

template gIsSocketControlMessage*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSocketControlMessage))

template gIsSocketControlMessageClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeSocketControlMessage))

template gSocketControlMessageGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeSocketControlMessage, GSocketControlMessageClassObj))

proc socketControlMessageGetType*(): GType {.
    importc: "g_socket_control_message_get_type", libgio.}
proc getSize*(message: GSocketControlMessage): Gsize {.
    importc: "g_socket_control_message_get_size", libgio.}
proc size*(message: GSocketControlMessage): Gsize {.
    importc: "g_socket_control_message_get_size", libgio.}
proc getLevel*(message: GSocketControlMessage): cint {.
    importc: "g_socket_control_message_get_level", libgio.}
proc level*(message: GSocketControlMessage): cint {.
    importc: "g_socket_control_message_get_level", libgio.}
proc getMsgType*(message: GSocketControlMessage): cint {.
    importc: "g_socket_control_message_get_msg_type", libgio.}
proc msgType*(message: GSocketControlMessage): cint {.
    importc: "g_socket_control_message_get_msg_type", libgio.}
proc serialize*(message: GSocketControlMessage;
                                    data: Gpointer) {.
    importc: "g_socket_control_message_serialize", libgio.}
proc socketControlMessageDeserialize*(level: cint; `type`: cint; size: Gsize;
                                      data: Gpointer): GSocketControlMessage {.
    importc: "g_socket_control_message_deserialize", libgio.}

template gTypeSocketListener*(): untyped =
  (socketListenerGetType())

template gSocketListener*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSocketListener, GSocketListenerObj))

template gSocketListenerClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeSocketListener, GSocketListenerClassObj))

template gIsSocketListener*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSocketListener))

template gIsSocketListenerClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeSocketListener))

template gSocketListenerGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeSocketListener, GSocketListenerClassObj))

type
  GSocketListenerClass* =  ptr GSocketListenerClassObj
  GSocketListenerClassPtr* = ptr GSocketListenerClassObj
  GSocketListenerClassObj* = object of GObjectClassObj
    changed*: proc (listener: GSocketListener) {.cdecl.}
    event*: proc (listener: GSocketListener; event: ptr GSocketListenerEvent;
                socket: GSocket) {.cdecl.}
    gReserved302*: proc () {.cdecl.}
    gReserved303*: proc () {.cdecl.}
    gReserved304*: proc () {.cdecl.}
    gReserved305*: proc () {.cdecl.}
    gReserved306*: proc () {.cdecl.}

  GSocketListener* =  ptr GSocketListenerObj
  GSocketListenerPtr* = ptr GSocketListenerObj
  GSocketListenerObj* = object of GObjectObj
    priv47: pointer

proc socketListenerGetType*(): GType {.importc: "g_socket_listener_get_type",
                                     libgio.}
proc newSocketListener*(): GSocketListener {.importc: "g_socket_listener_new",
    libgio.}
proc setBacklog*(listener: GSocketListener; listenBacklog: cint) {.
    importc: "g_socket_listener_set_backlog", libgio.}
proc `backlog=`*(listener: GSocketListener; listenBacklog: cint) {.
    importc: "g_socket_listener_set_backlog", libgio.}
proc addSocket*(listener: GSocketListener; socket: GSocket;
                              sourceObject: GObject; error: var GError): Gboolean {.
    importc: "g_socket_listener_add_socket", libgio.}
proc addAddress*(listener: GSocketListener;
                               address: GSocketAddress; `type`: GSocketType;
                               protocol: GSocketProtocol;
                               sourceObject: GObject;
                               effectiveAddress: var GSocketAddress;
                               error: var GError): Gboolean {.
    importc: "g_socket_listener_add_address", libgio.}
proc addInetPort*(listener: GSocketListener; port: uint16;
                                sourceObject: GObject; error: var GError): Gboolean {.
    importc: "g_socket_listener_add_inet_port", libgio.}
proc addAnyInetPort*(listener: GSocketListener;
                                   sourceObject: GObject; error: var GError): uint16 {.
    importc: "g_socket_listener_add_any_inet_port", libgio.}
proc acceptSocket*(listener: GSocketListener;
                                 sourceObject: var GObject;
                                 cancellable: GCancellable;
                                 error: var GError): GSocket {.
    importc: "g_socket_listener_accept_socket", libgio.}
proc acceptSocketAsync*(listener: GSocketListener;
                                      cancellable: GCancellable;
                                      callback: GAsyncReadyCallback;
                                      userData: Gpointer) {.
    importc: "g_socket_listener_accept_socket_async", libgio.}
proc acceptSocketFinish*(listener: GSocketListener;
                                       result: GAsyncResult;
                                       sourceObject: var GObject;
                                       error: var GError): GSocket {.
    importc: "g_socket_listener_accept_socket_finish", libgio.}
proc accept*(listener: GSocketListener;
                           sourceObject: var GObject;
                           cancellable: GCancellable; error: var GError): GSocketConnection {.
    importc: "g_socket_listener_accept", libgio.}
proc acceptAsync*(listener: GSocketListener;
                                cancellable: GCancellable;
                                callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_socket_listener_accept_async", libgio.}
proc acceptFinish*(listener: GSocketListener;
                                 result: GAsyncResult;
                                 sourceObject: var GObject;
                                 error: var GError): GSocketConnection {.
    importc: "g_socket_listener_accept_finish", libgio.}
proc close*(listener: GSocketListener) {.
    importc: "g_socket_listener_close", libgio.}

template gTypeSocketService*(): untyped =
  (socketServiceGetType())

template gSocketService*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeSocketService, GSocketServiceObj))

template gSocketServiceClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeSocketService, GSocketServiceClassObj))

template gIsSocketService*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeSocketService))

template gIsSocketServiceClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeSocketService))

template gSocketServiceGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeSocketService, GSocketServiceClassObj))

type
  GSocketServiceClass* =  ptr GSocketServiceClassObj
  GSocketServiceClassPtr* = ptr GSocketServiceClassObj
  GSocketServiceClassObj* = object of GSocketListenerClassObj
    incoming*: proc (service: GSocketService; connection: GSocketConnection;
                   sourceObject: GObject): Gboolean {.cdecl.}
    gReserved311*: proc () {.cdecl.}
    gReserved312*: proc () {.cdecl.}
    gReserved313*: proc () {.cdecl.}
    gReserved314*: proc () {.cdecl.}
    gReserved315*: proc () {.cdecl.}
    gReserved316*: proc () {.cdecl.}

  GSocketService* =  ptr GSocketServiceObj
  GSocketServicePtr* = ptr GSocketServiceObj
  GSocketServiceObj* = object of GSocketListenerObj
    priv48: pointer

proc socketServiceGetType*(): GType {.importc: "g_socket_service_get_type",
                                    libgio.}
proc newSocketService*(): GSocketService {.importc: "g_socket_service_new",
    libgio.}
proc start*(service: GSocketService) {.
    importc: "g_socket_service_start", libgio.}
proc stop*(service: GSocketService) {.
    importc: "g_socket_service_stop", libgio.}
proc isActive*(service: GSocketService): Gboolean {.
    importc: "g_socket_service_is_active", libgio.}

proc srvTargetGetType*(): GType {.importc: "g_srv_target_get_type", libgio.}
template gTypeSrvTarget*(): untyped =
  (srvTargetGetType())

proc newSrvTarget*(hostname: cstring; port: uint16; priority: uint16;
                   weight: uint16): GSrvTarget {.importc: "g_srv_target_new",
    libgio.}
proc copy*(target: GSrvTarget): GSrvTarget {.
    importc: "g_srv_target_copy", libgio.}
proc free*(target: GSrvTarget) {.importc: "g_srv_target_free",
    libgio.}
proc getHostname*(target: GSrvTarget): cstring {.
    importc: "g_srv_target_get_hostname", libgio.}
proc hostname*(target: GSrvTarget): cstring {.
    importc: "g_srv_target_get_hostname", libgio.}
proc getPort*(target: GSrvTarget): uint16 {.
    importc: "g_srv_target_get_port", libgio.}
proc port*(target: GSrvTarget): uint16 {.
    importc: "g_srv_target_get_port", libgio.}
proc getPriority*(target: GSrvTarget): uint16 {.
    importc: "g_srv_target_get_priority", libgio.}
proc priority*(target: GSrvTarget): uint16 {.
    importc: "g_srv_target_get_priority", libgio.}
proc getWeight*(target: GSrvTarget): uint16 {.
    importc: "g_srv_target_get_weight", libgio.}
proc weight*(target: GSrvTarget): uint16 {.
    importc: "g_srv_target_get_weight", libgio.}
proc srvTargetListSort*(targets: GList): GList {.
    importc: "g_srv_target_list_sort", libgio.}

template gTypeSimpleProxyResolver*(): untyped =
  (simpleProxyResolverGetType())

template gSimpleProxyResolver*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeSimpleProxyResolver, GSimpleProxyResolverObj))

template gSimpleProxyResolverClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeSimpleProxyResolver, GSimpleProxyResolverClassObj))

template gIsSimpleProxyResolver*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeSimpleProxyResolver))

template gIsSimpleProxyResolverClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeSimpleProxyResolver))

template gSimpleProxyResolverGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeSimpleProxyResolver, GSimpleProxyResolverClassObj))

type
  GSimpleProxyResolver* =  ptr GSimpleProxyResolverObj
  GSimpleProxyResolverPtr* = ptr GSimpleProxyResolverObj
  GSimpleProxyResolverObj*{.final.} = object of GObjectObj
    priv49: pointer

  GSimpleProxyResolverClass* =  ptr GSimpleProxyResolverClassObj
  GSimpleProxyResolverClassPtr* = ptr GSimpleProxyResolverClassObj
  GSimpleProxyResolverClassObj*{.final.} = object of GObjectClassObj
    gReserved321*: proc () {.cdecl.}
    gReserved322*: proc () {.cdecl.}
    gReserved323*: proc () {.cdecl.}
    gReserved324*: proc () {.cdecl.}
    gReserved325*: proc () {.cdecl.}

proc simpleProxyResolverGetType*(): GType {.
    importc: "g_simple_proxy_resolver_get_type", libgio.}
proc newSimpleProxyResolver*(defaultProxy: cstring; ignoreHosts: cstringArray): GProxyResolver {.
    importc: "g_simple_proxy_resolver_new", libgio.}
proc setDefaultProxy*(resolver: GSimpleProxyResolver;
    defaultProxy: cstring) {.importc: "g_simple_proxy_resolver_set_default_proxy",
                           libgio.}
proc `defaultProxy=`*(resolver: GSimpleProxyResolver;
    defaultProxy: cstring) {.importc: "g_simple_proxy_resolver_set_default_proxy",
                           libgio.}
proc setIgnoreHosts*(resolver: GSimpleProxyResolver;
                                        ignoreHosts: cstringArray) {.
    importc: "g_simple_proxy_resolver_set_ignore_hosts", libgio.}
proc `ignoreHosts=`*(resolver: GSimpleProxyResolver;
                                        ignoreHosts: cstringArray) {.
    importc: "g_simple_proxy_resolver_set_ignore_hosts", libgio.}
proc setUriProxy*(resolver: GSimpleProxyResolver;
                                     uriScheme: cstring; proxy: cstring) {.
    importc: "g_simple_proxy_resolver_set_uri_proxy", libgio.}
proc `uriProxy=`*(resolver: GSimpleProxyResolver;
                                     uriScheme: cstring; proxy: cstring) {.
    importc: "g_simple_proxy_resolver_set_uri_proxy", libgio.}

template gTypeTask*(): untyped =
  (taskGetType())

template gTask*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeTask, GTaskObj))

template gTaskClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeTask, GTaskClassObj))

template gIsTask*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeTask))

template gIsTaskClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeTask))

template gTaskGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeTask, GTaskClassObj))

type
  GTaskClass* =  ptr GTaskClassObj
  GTaskClassPtr* = ptr GTaskClassObj
  GTaskClassObj* = object

proc taskGetType*(): GType {.importc: "g_task_get_type", libgio.}
proc newTask*(sourceObject: Gpointer; cancellable: GCancellable;
              callback: GAsyncReadyCallback; callbackData: Gpointer): GTask {.
    importc: "g_task_new", libgio.}
proc taskReportError*(sourceObject: Gpointer; callback: GAsyncReadyCallback;
                      callbackData: Gpointer; sourceTag: Gpointer; error: GError) {.
    importc: "g_task_report_error", libgio.}
proc newTaskReport*(sourceObject: Gpointer; callback: GAsyncReadyCallback;
                         callbackData: Gpointer; sourceTag: Gpointer;
                         domain: GQuark; code: cint; format: cstring) {.varargs,
    importc: "g_task_report_new_error", libgio.}
proc setTaskData*(task: GTask; taskData: Gpointer;
                      taskDataDestroy: GDestroyNotify) {.
    importc: "g_task_set_task_data", libgio.}
proc `taskData=`*(task: GTask; taskData: Gpointer;
                      taskDataDestroy: GDestroyNotify) {.
    importc: "g_task_set_task_data", libgio.}
proc setPriority*(task: GTask; priority: cint) {.
    importc: "g_task_set_priority", libgio.}
proc `priority=`*(task: GTask; priority: cint) {.
    importc: "g_task_set_priority", libgio.}
proc setCheckCancellable*(task: GTask; checkCancellable: Gboolean) {.
    importc: "g_task_set_check_cancellable", libgio.}
proc `checkCancellable=`*(task: GTask; checkCancellable: Gboolean) {.
    importc: "g_task_set_check_cancellable", libgio.}
proc setSourceTag*(task: GTask; sourceTag: Gpointer) {.
    importc: "g_task_set_source_tag", libgio.}
proc `sourceTag=`*(task: GTask; sourceTag: Gpointer) {.
    importc: "g_task_set_source_tag", libgio.}
proc getSourceObject*(task: GTask): Gpointer {.
    importc: "g_task_get_source_object", libgio.}
proc sourceObject*(task: GTask): Gpointer {.
    importc: "g_task_get_source_object", libgio.}
proc getTaskData*(task: GTask): Gpointer {.importc: "g_task_get_task_data",
    libgio.}
proc taskData*(task: GTask): Gpointer {.importc: "g_task_get_task_data",
    libgio.}
proc getPriority*(task: GTask): cint {.importc: "g_task_get_priority",
    libgio.}
proc priority*(task: GTask): cint {.importc: "g_task_get_priority",
    libgio.}
proc getContext*(task: GTask): glib.GMainContext {.
    importc: "g_task_get_context", libgio.}
proc context*(task: GTask): glib.GMainContext {.
    importc: "g_task_get_context", libgio.}
proc getCancellable*(task: GTask): GCancellable {.
    importc: "g_task_get_cancellable", libgio.}
proc cancellable*(task: GTask): GCancellable {.
    importc: "g_task_get_cancellable", libgio.}
proc getCheckCancellable*(task: GTask): Gboolean {.
    importc: "g_task_get_check_cancellable", libgio.}
proc checkCancellable*(task: GTask): Gboolean {.
    importc: "g_task_get_check_cancellable", libgio.}
proc getSourceTag*(task: GTask): Gpointer {.
    importc: "g_task_get_source_tag", libgio.}
proc sourceTag*(task: GTask): Gpointer {.
    importc: "g_task_get_source_tag", libgio.}
proc taskIsValid*(result: Gpointer; sourceObject: Gpointer): Gboolean {.
    importc: "g_task_is_valid", libgio.}
type
  GTaskThreadFunc* = proc (task: GTask; sourceObject: Gpointer; taskData: Gpointer;
                        cancellable: GCancellable) {.cdecl.}

proc runInThread*(task: GTask; taskFunc: GTaskThreadFunc) {.
    importc: "g_task_run_in_thread", libgio.}
proc runInThreadSync*(task: GTask; taskFunc: GTaskThreadFunc) {.
    importc: "g_task_run_in_thread_sync", libgio.}
proc setReturnOnCancel*(task: GTask; returnOnCancel: Gboolean): Gboolean {.
    importc: "g_task_set_return_on_cancel", libgio.}
proc getReturnOnCancel*(task: GTask): Gboolean {.
    importc: "g_task_get_return_on_cancel", libgio.}
proc returnOnCancel*(task: GTask): Gboolean {.
    importc: "g_task_get_return_on_cancel", libgio.}
proc attachSource*(task: GTask; source: glib.GSource; callback: GSourceFunc) {.
    importc: "g_task_attach_source", libgio.}
proc returnPointer*(task: GTask; result: Gpointer;
                        resultDestroy: GDestroyNotify) {.
    importc: "g_task_return_pointer", libgio.}
proc returnBoolean*(task: GTask; result: Gboolean) {.
    importc: "g_task_return_boolean", libgio.}
proc returnInt*(task: GTask; result: Gssize) {.importc: "g_task_return_int",
    libgio.}
proc returnError*(task: GTask; error: GError) {.
    importc: "g_task_return_error", libgio.}
proc newReturn*(task: GTask; domain: GQuark; code: cint; format: cstring) {.
    varargs, importc: "g_task_return_new_error", libgio.}
proc returnErrorIfCancelled*(task: GTask): Gboolean {.
    importc: "g_task_return_error_if_cancelled", libgio.}
proc propagatePointer*(task: GTask; error: var GError): Gpointer {.
    importc: "g_task_propagate_pointer", libgio.}
proc propagateBoolean*(task: GTask; error: var GError): Gboolean {.
    importc: "g_task_propagate_boolean", libgio.}
proc propagateInt*(task: GTask; error: var GError): Gssize {.
    importc: "g_task_propagate_int", libgio.}
proc hadError*(task: GTask): Gboolean {.importc: "g_task_had_error",
    libgio.}
proc getCompleted*(task: GTask): Gboolean {.importc: "g_task_get_completed",
    libgio.}
proc completed*(task: GTask): Gboolean {.importc: "g_task_get_completed",
    libgio.}

template gTypeSubprocess*(): untyped =
  (subprocessGetType())

template gSubprocess*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeSubprocess, GSubprocessObj))

template gIsSubprocess*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeSubprocess))

proc subprocessGetType*(): GType {.importc: "g_subprocess_get_type", libgio.}

proc newSubprocess*(flags: GSubprocessFlags; error: var GError; argv0: cstring): GSubprocess {.
    varargs, importc: "g_subprocess_new", libgio.}
proc subprocessNewv*(argv: cstringArray; flags: GSubprocessFlags;
                     error: var GError): GSubprocess {.
    importc: "g_subprocess_newv", libgio.}
proc getStdinPipe*(subprocess: GSubprocess): GOutputStream {.
    importc: "g_subprocess_get_stdin_pipe", libgio.}
proc stdinPipe*(subprocess: GSubprocess): GOutputStream {.
    importc: "g_subprocess_get_stdin_pipe", libgio.}
proc getStdoutPipe*(subprocess: GSubprocess): GInputStream {.
    importc: "g_subprocess_get_stdout_pipe", libgio.}
proc stdoutPipe*(subprocess: GSubprocess): GInputStream {.
    importc: "g_subprocess_get_stdout_pipe", libgio.}
proc getStderrPipe*(subprocess: GSubprocess): GInputStream {.
    importc: "g_subprocess_get_stderr_pipe", libgio.}
proc stderrPipe*(subprocess: GSubprocess): GInputStream {.
    importc: "g_subprocess_get_stderr_pipe", libgio.}
proc getIdentifier*(subprocess: GSubprocess): cstring {.
    importc: "g_subprocess_get_identifier", libgio.}
proc identifier*(subprocess: GSubprocess): cstring {.
    importc: "g_subprocess_get_identifier", libgio.}
when defined(unix):
  proc sendSignal*(subprocess: GSubprocess; signalNum: cint) {.
      importc: "g_subprocess_send_signal", libgio.}
proc forceExit*(subprocess: GSubprocess) {.
    importc: "g_subprocess_force_exit", libgio.}
proc wait*(subprocess: GSubprocess; cancellable: GCancellable;
                     error: var GError): Gboolean {.importc: "g_subprocess_wait",
    libgio.}
proc waitAsync*(subprocess: GSubprocess;
                          cancellable: GCancellable;
                          callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_subprocess_wait_async", libgio.}
proc waitFinish*(subprocess: GSubprocess; result: GAsyncResult;
                           error: var GError): Gboolean {.
    importc: "g_subprocess_wait_finish", libgio.}
proc waitCheck*(subprocess: GSubprocess;
                          cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_subprocess_wait_check", libgio.}
proc waitCheckAsync*(subprocess: GSubprocess;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_subprocess_wait_check_async", libgio.}
proc waitCheckFinish*(subprocess: GSubprocess;
                                result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_subprocess_wait_check_finish", libgio.}
proc getStatus*(subprocess: GSubprocess): cint {.
    importc: "g_subprocess_get_status", libgio.}
proc status*(subprocess: GSubprocess): cint {.
    importc: "g_subprocess_get_status", libgio.}
proc getSuccessful*(subprocess: GSubprocess): Gboolean {.
    importc: "g_subprocess_get_successful", libgio.}
proc successful*(subprocess: GSubprocess): Gboolean {.
    importc: "g_subprocess_get_successful", libgio.}
proc getIfExited*(subprocess: GSubprocess): Gboolean {.
    importc: "g_subprocess_get_if_exited", libgio.}
proc ifExited*(subprocess: GSubprocess): Gboolean {.
    importc: "g_subprocess_get_if_exited", libgio.}
proc getExitStatus*(subprocess: GSubprocess): cint {.
    importc: "g_subprocess_get_exit_status", libgio.}
proc exitStatus*(subprocess: GSubprocess): cint {.
    importc: "g_subprocess_get_exit_status", libgio.}
proc getIfSignaled*(subprocess: GSubprocess): Gboolean {.
    importc: "g_subprocess_get_if_signaled", libgio.}
proc ifSignaled*(subprocess: GSubprocess): Gboolean {.
    importc: "g_subprocess_get_if_signaled", libgio.}
proc getTermSig*(subprocess: GSubprocess): cint {.
    importc: "g_subprocess_get_term_sig", libgio.}
proc termSig*(subprocess: GSubprocess): cint {.
    importc: "g_subprocess_get_term_sig", libgio.}
proc communicate*(subprocess: GSubprocess; stdinBuf: glib.GBytes;
                            cancellable: GCancellable;
                            stdoutBuf: var glib.GBytes; stderrBuf: var glib.GBytes;
                            error: var GError): Gboolean {.
    importc: "g_subprocess_communicate", libgio.}
proc communicateAsync*(subprocess: GSubprocess; stdinBuf: glib.GBytes;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_subprocess_communicate_async", libgio.}
proc communicateFinish*(subprocess: GSubprocess;
                                  result: GAsyncResult;
                                  stdoutBuf: var glib.GBytes;
                                  stderrBuf: var glib.GBytes; error: var GError): Gboolean {.
    importc: "g_subprocess_communicate_finish", libgio.}
proc communicateUtf8*(subprocess: GSubprocess; stdinBuf: cstring;
                                cancellable: GCancellable;
                                stdoutBuf: cstringArray; stderrBuf: cstringArray;
                                error: var GError): Gboolean {.
    importc: "g_subprocess_communicate_utf8", libgio.}
proc communicateUtf8Async*(subprocess: GSubprocess;
                                     stdinBuf: cstring;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     userData: Gpointer) {.
    importc: "g_subprocess_communicate_utf8_async", libgio.}
proc communicateUtf8Finish*(subprocess: GSubprocess;
                                      result: GAsyncResult;
                                      stdoutBuf: cstringArray;
                                      stderrBuf: cstringArray;
                                      error: var GError): Gboolean {.
    importc: "g_subprocess_communicate_utf8_finish", libgio.}

template gTypeSubprocessLauncher*(): untyped =
  (subprocessLauncherGetType())

template gSubprocessLauncher*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeSubprocessLauncher, GSubprocessLauncherObj))

template gIsSubprocessLauncher*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeSubprocessLauncher))

proc subprocessLauncherGetType*(): GType {.
    importc: "g_subprocess_launcher_get_type", libgio.}
proc newSubprocessLauncher*(flags: GSubprocessFlags): GSubprocessLauncher {.
    importc: "g_subprocess_launcher_new", libgio.}
proc spawn*(self: GSubprocessLauncher; error: var GError;
                              argv0: cstring): GSubprocess {.varargs,
    importc: "g_subprocess_launcher_spawn", libgio.}
proc spawnv*(self: GSubprocessLauncher; argv: cstringArray;
                               error: var GError): GSubprocess {.
    importc: "g_subprocess_launcher_spawnv", libgio.}
proc setEnviron*(self: GSubprocessLauncher; env: cstringArray) {.
    importc: "g_subprocess_launcher_set_environ", libgio.}
proc `environ=`*(self: GSubprocessLauncher; env: cstringArray) {.
    importc: "g_subprocess_launcher_set_environ", libgio.}
proc setenv*(self: GSubprocessLauncher; variable: cstring;
                               value: cstring; overwrite: Gboolean) {.
    importc: "g_subprocess_launcher_setenv", libgio.}
proc unsetenv*(self: GSubprocessLauncher; variable: cstring) {.
    importc: "g_subprocess_launcher_unsetenv", libgio.}
proc getenv*(self: GSubprocessLauncher; variable: cstring): cstring {.
    importc: "g_subprocess_launcher_getenv", libgio.}
proc setCwd*(self: GSubprocessLauncher; cwd: cstring) {.
    importc: "g_subprocess_launcher_set_cwd", libgio.}
proc `cwd=`*(self: GSubprocessLauncher; cwd: cstring) {.
    importc: "g_subprocess_launcher_set_cwd", libgio.}
proc setFlags*(self: GSubprocessLauncher;
                                 flags: GSubprocessFlags) {.
    importc: "g_subprocess_launcher_set_flags", libgio.}

when defined(unix):
  proc setStdinFilePath*(self: GSubprocessLauncher;
      path: cstring) {.importc: "g_subprocess_launcher_set_stdin_file_path",
                     libgio.}
  proc `stdinFilePath=`*(self: GSubprocessLauncher;
      path: cstring) {.importc: "g_subprocess_launcher_set_stdin_file_path",
                     libgio.}
  proc takeStdinFd*(self: GSubprocessLauncher; fd: cint) {.
      importc: "g_subprocess_launcher_take_stdin_fd", libgio.}
  proc setStdoutFilePath*(self: GSubprocessLauncher;
      path: cstring) {.importc: "g_subprocess_launcher_set_stdout_file_path",
                     libgio.}
  proc `stdoutFilePath=`*(self: GSubprocessLauncher;
      path: cstring) {.importc: "g_subprocess_launcher_set_stdout_file_path",
                     libgio.}
  proc takeStdoutFd*(self: GSubprocessLauncher; fd: cint) {.
      importc: "g_subprocess_launcher_take_stdout_fd", libgio.}
  proc setStderrFilePath*(self: GSubprocessLauncher;
      path: cstring) {.importc: "g_subprocess_launcher_set_stderr_file_path",
                     libgio.}
  proc `stderrFilePath=`*(self: GSubprocessLauncher;
      path: cstring) {.importc: "g_subprocess_launcher_set_stderr_file_path",
                     libgio.}
  proc takeStderrFd*(self: GSubprocessLauncher; fd: cint) {.
      importc: "g_subprocess_launcher_take_stderr_fd", libgio.}
  proc takeFd*(self: GSubprocessLauncher; sourceFd: cint;
                                 targetFd: cint) {.
      importc: "g_subprocess_launcher_take_fd", libgio.}
  proc setChildSetup*(self: GSubprocessLauncher;
                                        childSetup: GSpawnChildSetupFunc;
                                        userData: Gpointer;
                                        destroyNotify: GDestroyNotify) {.
      importc: "g_subprocess_launcher_set_child_setup", libgio.}
  proc `childSetup=`*(self: GSubprocessLauncher;
                                        childSetup: GSpawnChildSetupFunc;
                                        userData: Gpointer;
                                        destroyNotify: GDestroyNotify) {.
      importc: "g_subprocess_launcher_set_child_setup", libgio.}

template gTypeTcpConnection*(): untyped =
  (tcpConnectionGetType())

template gTcpConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTcpConnection, GTcpConnectionObj))

template gTcpConnectionClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeTcpConnection, GTcpConnectionClassObj))

template gIsTcpConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTcpConnection))

template gIsTcpConnectionClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeTcpConnection))

template gTcpConnectionGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeTcpConnection, GTcpConnectionClassObj))

type
  GTcpConnectionClass* =  ptr GTcpConnectionClassObj
  GTcpConnectionClassPtr* = ptr GTcpConnectionClassObj
  GTcpConnectionClassObj* = object of GSocketConnectionClassObj

  GTcpConnection* =  ptr GTcpConnectionObj
  GTcpConnectionPtr* = ptr GTcpConnectionObj
  GTcpConnectionObj* = object of GSocketConnectionObj
    priv50: pointer

proc tcpConnectionGetType*(): GType {.importc: "g_tcp_connection_get_type",
                                    libgio.}
proc setGracefulDisconnect*(connection: GTcpConnection;
    gracefulDisconnect: Gboolean) {.importc: "g_tcp_connection_set_graceful_disconnect",
                                  libgio.}
proc `gracefulDisconnect=`*(connection: GTcpConnection;
    gracefulDisconnect: Gboolean) {.importc: "g_tcp_connection_set_graceful_disconnect",
                                  libgio.}
proc getGracefulDisconnect*(connection: GTcpConnection): Gboolean {.
    importc: "g_tcp_connection_get_graceful_disconnect", libgio.}
proc gracefulDisconnect*(connection: GTcpConnection): Gboolean {.
    importc: "g_tcp_connection_get_graceful_disconnect", libgio.}

template gTypeTcpWrapperConnection*(): untyped =
  (tcpWrapperConnectionGetType())

template gTcpWrapperConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTcpWrapperConnection, GTcpWrapperConnectionObj))

template gTcpWrapperConnectionClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeTcpWrapperConnection, GTcpWrapperConnectionClassObj))

template gIsTcpWrapperConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTcpWrapperConnection))

template gIsTcpWrapperConnectionClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeTcpWrapperConnection))

template gTcpWrapperConnectionGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeTcpWrapperConnection, GTcpWrapperConnectionClassObj))

type
  GTcpWrapperConnectionClass* =  ptr GTcpWrapperConnectionClassObj
  GTcpWrapperConnectionClassPtr* = ptr GTcpWrapperConnectionClassObj
  GTcpWrapperConnectionClassObj*{.final.} = object of GTcpConnectionClassObj

  GTcpWrapperConnection* =  ptr GTcpWrapperConnectionObj
  GTcpWrapperConnectionPtr* = ptr GTcpWrapperConnectionObj
  GTcpWrapperConnectionObj*{.final.} = object of GTcpConnectionObj
    priv51: pointer

proc tcpWrapperConnectionGetType*(): GType {.
    importc: "g_tcp_wrapper_connection_get_type", libgio.}
proc newTcpWrapperConnection*(baseIoStream: GIOStream; socket: GSocket): GSocketConnection {.
    importc: "g_tcp_wrapper_connection_new", libgio.}
proc getBaseIoStream*(conn: GTcpWrapperConnection): GIOStream {.
    importc: "g_tcp_wrapper_connection_get_base_io_stream", libgio.}
proc baseIoStream*(conn: GTcpWrapperConnection): GIOStream {.
    importc: "g_tcp_wrapper_connection_get_base_io_stream", libgio.}

template gTypeTestDbus*(): untyped =
  (testDbusGetType())

template gTestDbus*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeTestDbus, GTestDBusObj))

template gIsTestDbus*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeTestDbus))

proc testDbusGetType*(): GType {.importc: "g_test_dbus_get_type", libgio.}
proc newTestDbus*(flags: GTestDBusFlags): GTestDBus {.
    importc: "g_test_dbus_new", libgio.}
proc testDbusGetFlags*(self: GTestDBus): GTestDBusFlags {.
    importc: "g_test_dbus_get_flags", libgio.}
proc testDbusGetBusAddress*(self: GTestDBus): cstring {.
    importc: "g_test_dbus_get_bus_address", libgio.}
proc testDbusAddServiceDir*(self: GTestDBus; path: cstring) {.
    importc: "g_test_dbus_add_service_dir", libgio.}
proc testDbusUp*(self: GTestDBus) {.importc: "g_test_dbus_up", libgio.}
proc testDbusStop*(self: GTestDBus) {.importc: "g_test_dbus_stop", libgio.}
proc testDbusDown*(self: GTestDBus) {.importc: "g_test_dbus_down", libgio.}
proc testDbusUnset*() {.importc: "g_test_dbus_unset", libgio.}

template gTypeThemedIcon*(): untyped =
  (themedIconGetType())

template gThemedIcon*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeThemedIcon, GThemedIconObj))

template gThemedIconClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeThemedIcon, GThemedIconClassObj))

template gIsThemedIcon*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeThemedIcon))

template gIsThemedIconClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeThemedIcon))

template gThemedIconGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeThemedIcon, GThemedIconClassObj))

type
  GThemedIconClass* =  ptr GThemedIconClassObj
  GThemedIconClassPtr* = ptr GThemedIconClassObj
  GThemedIconClassObj* = object

proc themedIconGetType*(): GType {.importc: "g_themed_icon_get_type", libgio.}
proc newThemedIcon*(iconname: cstring): GIcon {.importc: "g_themed_icon_new",
    libgio.}
proc newThemedIconWithDefaultFallbacks*(iconname: cstring): GIcon {.
    importc: "g_themed_icon_new_with_default_fallbacks", libgio.}
proc newThemedIcon*(iconnames: cstringArray; len: cint): GIcon {.
    importc: "g_themed_icon_new_from_names", libgio.}
proc prependName*(icon: GThemedIcon; iconname: cstring) {.
    importc: "g_themed_icon_prepend_name", libgio.}
proc appendName*(icon: GThemedIcon; iconname: cstring) {.
    importc: "g_themed_icon_append_name", libgio.}
proc getNames*(icon: GThemedIcon): cstringArray {.
    importc: "g_themed_icon_get_names", libgio.}
proc names*(icon: GThemedIcon): cstringArray {.
    importc: "g_themed_icon_get_names", libgio.}

template gTypeThreadedSocketService*(): untyped =
  (threadedSocketServiceGetType())

template gThreadedSocketService*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeThreadedSocketService, GThreadedSocketServiceObj))

template gThreadedSocketServiceClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeThreadedSocketService, GThreadedSocketServiceClassObj))

template gIsThreadedSocketService*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeThreadedSocketService))

template gIsThreadedSocketServiceClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeThreadedSocketService))

template gThreadedSocketServiceGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeThreadedSocketService, GThreadedSocketServiceClassObj))

type
  GThreadedSocketServiceClass* =  ptr GThreadedSocketServiceClassObj
  GThreadedSocketServiceClassPtr* = ptr GThreadedSocketServiceClassObj
  GThreadedSocketServiceClassObj*{.final.} = object of GSocketServiceClassObj
    run*: proc (service: GThreadedSocketService;
              connection: GSocketConnection; sourceObject: GObject): Gboolean {.cdecl.}
    gReserved331*: proc () {.cdecl.}
    gReserved332*: proc () {.cdecl.}
    gReserved333*: proc () {.cdecl.}
    gReserved334*: proc () {.cdecl.}
    gReserved335*: proc () {.cdecl.}

  GThreadedSocketService* =  ptr GThreadedSocketServiceObj
  GThreadedSocketServicePtr* = ptr GThreadedSocketServiceObj
  GThreadedSocketServiceObj*{.final.} = object of GSocketServiceObj
    priv52: pointer

proc threadedSocketServiceGetType*(): GType {.
    importc: "g_threaded_socket_service_get_type", libgio.}
proc newThreadedSocketService*(maxThreads: cint): GSocketService {.
    importc: "g_threaded_socket_service_new", libgio.}

const
  G_TLS_BACKEND_EXTENSION_POINT_NAME* = "gio-tls-backend"

template gTypeTlsBackend*(): untyped =
  (tlsBackendGetType())

template gTlsBackend*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeTlsBackend, GTlsBackendObj))

template gIsTlsBackend*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeTlsBackend))

template gTlsBackendGetInterface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeTlsBackend, GTlsBackendInterfaceObj))

type
  GTlsBackend* =  ptr GTlsBackendObj
  GTlsBackendPtr* = ptr GTlsBackendObj
  GTlsBackendObj* = object

type
  GTlsBackendInterface* =  ptr GTlsBackendInterfaceObj
  GTlsBackendInterfacePtr* = ptr GTlsBackendInterfaceObj
  GTlsBackendInterfaceObj*{.final.} = object of GTypeInterfaceObj
    supportsTls*: proc (backend: GTlsBackend): Gboolean {.cdecl.}
    getCertificateType*: proc (): GType {.cdecl.}
    getClientConnectionType*: proc (): GType {.cdecl.}
    getServerConnectionType*: proc (): GType {.cdecl.}
    getFileDatabaseType*: proc (): GType {.cdecl.}
    getDefaultDatabase*: proc (backend: GTlsBackend): GTlsDatabase {.cdecl.}
    supportsDtls*: proc (backend: GTlsBackend): Gboolean {.cdecl.}
    getDtlsClientConnectionType*: proc (): GType {.cdecl.}
    getDtlsServerConnectionType*: proc (): GType {.cdecl.}

proc tlsBackendGetType*(): GType {.importc: "g_tls_backend_get_type", libgio.}
proc tlsBackendGetDefault*(): GTlsBackend {.
    importc: "g_tls_backend_get_default", libgio.}
proc getDefaultDatabase*(backend: GTlsBackend): GTlsDatabase {.
    importc: "g_tls_backend_get_default_database", libgio.}
proc defaultDatabase*(backend: GTlsBackend): GTlsDatabase {.
    importc: "g_tls_backend_get_default_database", libgio.}
proc supportsTls*(backend: GTlsBackend): Gboolean {.
    importc: "g_tls_backend_supports_tls", libgio.}
proc supportsDtls*(backend: GTlsBackend): Gboolean {.
    importc: "g_tls_backend_supports_dtls", libgio.}
proc getCertificateType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_certificate_type", libgio.}
proc certificateType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_certificate_type", libgio.}
proc getClientConnectionType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_client_connection_type", libgio.}
proc clientConnectionType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_client_connection_type", libgio.}
proc getServerConnectionType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_server_connection_type", libgio.}
proc serverConnectionType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_server_connection_type", libgio.}
proc getFileDatabaseType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_file_database_type", libgio.}
proc fileDatabaseType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_file_database_type", libgio.}
proc getDtlsClientConnectionType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_dtls_client_connection_type", libgio.}
proc dtlsClientConnectionType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_dtls_client_connection_type", libgio.}
proc getDtlsServerConnectionType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_dtls_server_connection_type", libgio.}
proc dtlsServerConnectionType*(backend: GTlsBackend): GType {.
    importc: "g_tls_backend_get_dtls_server_connection_type", libgio.}

template gTypeTlsCertificate*(): untyped =
  (tlsCertificateGetType())

template gTlsCertificate*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTlsCertificate, GTlsCertificateObj))

template gTlsCertificateClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeTlsCertificate, GTlsCertificateClassObj))

template gIsTlsCertificate*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTlsCertificate))

template gIsTlsCertificateClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeTlsCertificate))

template gTlsCertificateGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeTlsCertificate, GTlsCertificateClassObj))

proc tlsCertificateGetType*(): GType {.importc: "g_tls_certificate_get_type",
                                     libgio.}
proc newTlsCertificate*(data: cstring; length: Gssize; error: var GError): GTlsCertificate {.
    importc: "g_tls_certificate_new_from_pem", libgio.}
proc newTlsCertificate*(file: cstring; error: var GError): GTlsCertificate {.
    importc: "g_tls_certificate_new_from_file", libgio.}
proc newTlsCertificate*(certFile: cstring; keyFile: cstring;
                                 error: var GError): GTlsCertificate {.
    importc: "g_tls_certificate_new_from_files", libgio.}
proc newTlsCertificateList*(file: cstring; error: var GError): GList {.
    importc: "g_tls_certificate_list_new_from_file", libgio.}
proc getIssuer*(cert: GTlsCertificate): GTlsCertificate {.
    importc: "g_tls_certificate_get_issuer", libgio.}
proc issuer*(cert: GTlsCertificate): GTlsCertificate {.
    importc: "g_tls_certificate_get_issuer", libgio.}
proc verify*(cert: GTlsCertificate;
                           identity: GSocketConnectable;
                           trustedCa: GTlsCertificate): GTlsCertificateFlags {.
    importc: "g_tls_certificate_verify", libgio.}
proc isSame*(certOne: GTlsCertificate;
                           certTwo: GTlsCertificate): Gboolean {.
    importc: "g_tls_certificate_is_same", libgio.}

template gTypeTlsConnection*(): untyped =
  (tlsConnectionGetType())

template gTlsConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTlsConnection, GTlsConnectionObj))

template gTlsConnectionClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeTlsConnection, GTlsConnectionClassObj))

template gIsTlsConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTlsConnection))

template gIsTlsConnectionClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeTlsConnection))

template gTlsConnectionGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeTlsConnection, GTlsConnectionClassObj))

proc tlsConnectionGetType*(): GType {.importc: "g_tls_connection_get_type",
                                    libgio.}
proc setUseSystemCertdb*(conn: GTlsConnection;
                                      useSystemCertdb: Gboolean) {.
    importc: "g_tls_connection_set_use_system_certdb", libgio.}
proc `useSystemCertdb=`*(conn: GTlsConnection;
                                      useSystemCertdb: Gboolean) {.
    importc: "g_tls_connection_set_use_system_certdb", libgio.}
proc getUseSystemCertdb*(conn: GTlsConnection): Gboolean {.
    importc: "g_tls_connection_get_use_system_certdb", libgio.}
proc useSystemCertdb*(conn: GTlsConnection): Gboolean {.
    importc: "g_tls_connection_get_use_system_certdb", libgio.}
proc setDatabase*(conn: GTlsConnection; database: GTlsDatabase) {.
    importc: "g_tls_connection_set_database", libgio.}
proc `database=`*(conn: GTlsConnection; database: GTlsDatabase) {.
    importc: "g_tls_connection_set_database", libgio.}
proc getDatabase*(conn: GTlsConnection): GTlsDatabase {.
    importc: "g_tls_connection_get_database", libgio.}
proc database*(conn: GTlsConnection): GTlsDatabase {.
    importc: "g_tls_connection_get_database", libgio.}
proc setCertificate*(conn: GTlsConnection;
                                  certificate: GTlsCertificate) {.
    importc: "g_tls_connection_set_certificate", libgio.}
proc `certificate=`*(conn: GTlsConnection;
                                  certificate: GTlsCertificate) {.
    importc: "g_tls_connection_set_certificate", libgio.}
proc getCertificate*(conn: GTlsConnection): GTlsCertificate {.
    importc: "g_tls_connection_get_certificate", libgio.}
proc certificate*(conn: GTlsConnection): GTlsCertificate {.
    importc: "g_tls_connection_get_certificate", libgio.}
proc setInteraction*(conn: GTlsConnection;
                                  interaction: GTlsInteraction) {.
    importc: "g_tls_connection_set_interaction", libgio.}
proc `interaction=`*(conn: GTlsConnection;
                                  interaction: GTlsInteraction) {.
    importc: "g_tls_connection_set_interaction", libgio.}
proc getInteraction*(conn: GTlsConnection): GTlsInteraction {.
    importc: "g_tls_connection_get_interaction", libgio.}
proc interaction*(conn: GTlsConnection): GTlsInteraction {.
    importc: "g_tls_connection_get_interaction", libgio.}
proc getPeerCertificate*(conn: GTlsConnection): GTlsCertificate {.
    importc: "g_tls_connection_get_peer_certificate", libgio.}
proc peerCertificate*(conn: GTlsConnection): GTlsCertificate {.
    importc: "g_tls_connection_get_peer_certificate", libgio.}
proc getPeerCertificateErrors*(conn: GTlsConnection): GTlsCertificateFlags {.
    importc: "g_tls_connection_get_peer_certificate_errors", libgio.}
proc peerCertificateErrors*(conn: GTlsConnection): GTlsCertificateFlags {.
    importc: "g_tls_connection_get_peer_certificate_errors", libgio.}
proc setRequireCloseNotify*(conn: GTlsConnection;
    requireCloseNotify: Gboolean) {.importc: "g_tls_connection_set_require_close_notify",
                                  libgio.}
proc `requireCloseNotify=`*(conn: GTlsConnection;
    requireCloseNotify: Gboolean) {.importc: "g_tls_connection_set_require_close_notify",
                                  libgio.}
proc getRequireCloseNotify*(conn: GTlsConnection): Gboolean {.
    importc: "g_tls_connection_get_require_close_notify", libgio.}
proc requireCloseNotify*(conn: GTlsConnection): Gboolean {.
    importc: "g_tls_connection_get_require_close_notify", libgio.}
proc setRehandshakeMode*(conn: GTlsConnection;
                                      mode: GTlsRehandshakeMode) {.
    importc: "g_tls_connection_set_rehandshake_mode", libgio.}
proc `rehandshakeMode=`*(conn: GTlsConnection;
                                      mode: GTlsRehandshakeMode) {.
    importc: "g_tls_connection_set_rehandshake_mode", libgio.}
proc getRehandshakeMode*(conn: GTlsConnection): GTlsRehandshakeMode {.
    importc: "g_tls_connection_get_rehandshake_mode", libgio.}
proc rehandshakeMode*(conn: GTlsConnection): GTlsRehandshakeMode {.
    importc: "g_tls_connection_get_rehandshake_mode", libgio.}
proc handshake*(conn: GTlsConnection;
                             cancellable: GCancellable; error: var GError): Gboolean {.
    importc: "g_tls_connection_handshake", libgio.}
proc handshakeAsync*(conn: GTlsConnection; ioPriority: cint;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_tls_connection_handshake_async", libgio.}
proc handshakeFinish*(conn: GTlsConnection;
                                   result: GAsyncResult; error: var GError): Gboolean {.
    importc: "g_tls_connection_handshake_finish", libgio.}

template gTlsError*(): untyped =
  (gTlsErrorQuark())

proc tlsErrorQuark*(): GQuark {.importc: "g_tls_error_quark", libgio.}

proc emitAcceptCertificate*(conn: GTlsConnection;
    peerCert: GTlsCertificate; errors: GTlsCertificateFlags): Gboolean {.
    importc: "g_tls_connection_emit_accept_certificate", libgio.}

template gTypeTlsClientConnection*(): untyped =
  (tlsClientConnectionGetType())

template gTlsClientConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTlsClientConnection, GTlsClientConnectionObj))

template gIsTlsClientConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTlsClientConnection))

template gTlsClientConnectionGetInterface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeTlsClientConnection, GTlsClientConnectionInterfaceObj))

type
  GTlsClientConnectionInterface* =  ptr GTlsClientConnectionInterfaceObj
  GTlsClientConnectionInterfacePtr* = ptr GTlsClientConnectionInterfaceObj
  GTlsClientConnectionInterfaceObj*{.final.} = object of GTypeInterfaceObj
    copySessionState*: proc (conn: GTlsClientConnection;
                           source: GTlsClientConnection) {.cdecl.}

proc tlsClientConnectionGetType*(): GType {.
    importc: "g_tls_client_connection_get_type", libgio.}
proc newTlsClientConnection*(baseIoStream: GIOStream;
                             serverIdentity: GSocketConnectable;
                             error: var GError): GIOStream {.
    importc: "g_tls_client_connection_new", libgio.}
proc getValidationFlags*(conn: GTlsClientConnection): GTlsCertificateFlags {.
    importc: "g_tls_client_connection_get_validation_flags", libgio.}
proc validationFlags*(conn: GTlsClientConnection): GTlsCertificateFlags {.
    importc: "g_tls_client_connection_get_validation_flags", libgio.}
proc setValidationFlags*(conn: GTlsClientConnection;
    flags: GTlsCertificateFlags) {.importc: "g_tls_client_connection_set_validation_flags",
                                 libgio.}
proc `validationFlags=`*(conn: GTlsClientConnection;
    flags: GTlsCertificateFlags) {.importc: "g_tls_client_connection_set_validation_flags",
                                 libgio.}
proc getServerIdentity*(conn: GTlsClientConnection): GSocketConnectable {.
    importc: "g_tls_client_connection_get_server_identity", libgio.}
proc serverIdentity*(conn: GTlsClientConnection): GSocketConnectable {.
    importc: "g_tls_client_connection_get_server_identity", libgio.}
proc setServerIdentity*(conn: GTlsClientConnection;
    identity: GSocketConnectable) {.importc: "g_tls_client_connection_set_server_identity",
                                     libgio.}
proc `serverIdentity=`*(conn: GTlsClientConnection;
    identity: GSocketConnectable) {.importc: "g_tls_client_connection_set_server_identity",
                                     libgio.}
proc getUseSsl3*(conn: GTlsClientConnection): Gboolean {.
    importc: "g_tls_client_connection_get_use_ssl3", libgio.}
proc useSsl3*(conn: GTlsClientConnection): Gboolean {.
    importc: "g_tls_client_connection_get_use_ssl3", libgio.}
proc setUseSsl3*(conn: GTlsClientConnection;
                                    useSsl3: Gboolean) {.
    importc: "g_tls_client_connection_set_use_ssl3", libgio.}
proc `useSsl3=`*(conn: GTlsClientConnection;
                                    useSsl3: Gboolean) {.
    importc: "g_tls_client_connection_set_use_ssl3", libgio.}
proc getAcceptedCas*(conn: GTlsClientConnection): GList {.
    importc: "g_tls_client_connection_get_accepted_cas", libgio.}
proc acceptedCas*(conn: GTlsClientConnection): GList {.
    importc: "g_tls_client_connection_get_accepted_cas", libgio.}
proc copySessionState*(conn: GTlsClientConnection;
    source: GTlsClientConnection) {.importc: "g_tls_client_connection_copy_session_state",
                                     libgio.}

const
  G_TLS_DATABASE_PURPOSE_AUTHENTICATE_SERVER* = "1.3.6.1.5.5.7.3.1"
  G_TLS_DATABASE_PURPOSE_AUTHENTICATE_CLIENT* = "1.3.6.1.5.5.7.3.2"

template gTypeTlsDatabase*(): untyped =
  (tlsDatabaseGetType())

template gTlsDatabase*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTlsDatabase, GTlsDatabaseObj))

template gTlsDatabaseClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeTlsDatabase, GTlsDatabaseClassObj))

template gIsTlsDatabase*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTlsDatabase))

template gIsTlsDatabaseClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeTlsDatabase))

template gTlsDatabaseGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeTlsDatabase, GTlsDatabaseClassObj))

proc tlsDatabaseGetType*(): GType {.importc: "g_tls_database_get_type", libgio.}
proc verifyChain*(self: GTlsDatabase; chain: GTlsCertificate;
                             purpose: cstring; identity: GSocketConnectable;
                             interaction: GTlsInteraction;
                             flags: GTlsDatabaseVerifyFlags;
                             cancellable: GCancellable; error: var GError): GTlsCertificateFlags {.
    importc: "g_tls_database_verify_chain", libgio.}
proc verifyChainAsync*(self: GTlsDatabase;
                                  chain: GTlsCertificate; purpose: cstring;
                                  identity: GSocketConnectable;
                                  interaction: GTlsInteraction;
                                  flags: GTlsDatabaseVerifyFlags;
                                  cancellable: GCancellable;
                                  callback: GAsyncReadyCallback;
                                  userData: Gpointer) {.
    importc: "g_tls_database_verify_chain_async", libgio.}
proc verifyChainFinish*(self: GTlsDatabase;
                                   result: GAsyncResult; error: var GError): GTlsCertificateFlags {.
    importc: "g_tls_database_verify_chain_finish", libgio.}
proc createCertificateHandle*(self: GTlsDatabase;
    certificate: GTlsCertificate): cstring {.
    importc: "g_tls_database_create_certificate_handle", libgio.}
proc lookupCertificateForHandle*(self: GTlsDatabase;
    handle: cstring; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    error: var GError): GTlsCertificate {.
    importc: "g_tls_database_lookup_certificate_for_handle", libgio.}
proc lookupCertificateForHandleAsync*(self: GTlsDatabase;
    handle: cstring; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_tls_database_lookup_certificate_for_handle_async", libgio.}
proc lookupCertificateForHandleFinish*(self: GTlsDatabase;
    result: GAsyncResult; error: var GError): GTlsCertificate {.
    importc: "g_tls_database_lookup_certificate_for_handle_finish", libgio.}
proc lookupCertificateIssuer*(self: GTlsDatabase;
    certificate: GTlsCertificate; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    error: var GError): GTlsCertificate {.
    importc: "g_tls_database_lookup_certificate_issuer", libgio.}
proc lookupCertificateIssuerAsync*(self: GTlsDatabase;
    certificate: GTlsCertificate; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_tls_database_lookup_certificate_issuer_async", libgio.}
proc lookupCertificateIssuerFinish*(self: GTlsDatabase;
    result: GAsyncResult; error: var GError): GTlsCertificate {.
    importc: "g_tls_database_lookup_certificate_issuer_finish", libgio.}
proc lookupCertificatesIssuedBy*(self: GTlsDatabase;
    issuerRawDn: glib.GByteArray; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    error: var GError): GList {.importc: "g_tls_database_lookup_certificates_issued_by",
                                  libgio.}
proc lookupCertificatesIssuedByAsync*(self: GTlsDatabase;
    issuerRawDn: glib.GByteArray; interaction: GTlsInteraction;
    flags: GTlsDatabaseLookupFlags; cancellable: GCancellable;
    callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_tls_database_lookup_certificates_issued_by_async", libgio.}
proc lookupCertificatesIssuedByFinish*(self: GTlsDatabase;
    result: GAsyncResult; error: var GError): GList {.
    importc: "g_tls_database_lookup_certificates_issued_by_finish", libgio.}

template gTypeTlsFileDatabase*(): untyped =
  (tlsFileDatabaseGetType())

template gTlsFileDatabase*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTlsFileDatabase, GTlsFileDatabaseObj))

template gIsTlsFileDatabase*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTlsFileDatabase))

template gTlsFileDatabaseGetInterface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeTlsFileDatabase, GTlsFileDatabaseInterfaceObj))

type
  GTlsFileDatabaseInterface* =  ptr GTlsFileDatabaseInterfaceObj
  GTlsFileDatabaseInterfacePtr* = ptr GTlsFileDatabaseInterfaceObj
  GTlsFileDatabaseInterfaceObj*{.final.} = object of GTypeInterfaceObj
    padding*: array[8, Gpointer]

proc tlsFileDatabaseGetType*(): GType {.importc: "g_tls_file_database_get_type",
                                      libgio.}
proc newTlsFileDatabase*(anchors: cstring; error: var GError): GTlsDatabase {.
    importc: "g_tls_file_database_new", libgio.}

template gTypeTlsInteraction*(): untyped =
  (tlsInteractionGetType())

template gTlsInteraction*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeTlsInteraction, GTlsInteractionObj))

template gTlsInteractionClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeTlsInteraction, GTlsInteractionClassObj))

template gIsTlsInteraction*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeTlsInteraction))

template gIsTlsInteractionClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeTlsInteraction))

template gTlsInteractionGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeTlsInteraction, GTlsInteractionClassObj))

proc tlsInteractionGetType*(): GType {.importc: "g_tls_interaction_get_type",
                                     libgio.}
proc invokeAskPassword*(interaction: GTlsInteraction;
                                      password: GTlsPassword;
                                      cancellable: GCancellable;
                                      error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_invoke_ask_password", libgio.}
proc askPassword*(interaction: GTlsInteraction;
                                password: GTlsPassword;
                                cancellable: GCancellable;
                                error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_ask_password", libgio.}
proc askPasswordAsync*(interaction: GTlsInteraction;
                                     password: GTlsPassword;
                                     cancellable: GCancellable;
                                     callback: GAsyncReadyCallback;
                                     userData: Gpointer) {.
    importc: "g_tls_interaction_ask_password_async", libgio.}
proc askPasswordFinish*(interaction: GTlsInteraction;
                                      result: GAsyncResult;
                                      error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_ask_password_finish", libgio.}
proc invokeRequestCertificate*(interaction: GTlsInteraction;
    connection: GTlsConnection; flags: GTlsCertificateRequestFlags;
    cancellable: GCancellable; error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_invoke_request_certificate", libgio.}
proc requestCertificate*(interaction: GTlsInteraction;
                                       connection: GTlsConnection;
                                       flags: GTlsCertificateRequestFlags;
                                       cancellable: GCancellable;
                                       error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_request_certificate", libgio.}
proc requestCertificateAsync*(interaction: GTlsInteraction;
    connection: GTlsConnection; flags: GTlsCertificateRequestFlags;
    cancellable: GCancellable; callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_tls_interaction_request_certificate_async", libgio.}
proc requestCertificateFinish*(interaction: GTlsInteraction;
    result: GAsyncResult; error: var GError): GTlsInteractionResult {.
    importc: "g_tls_interaction_request_certificate_finish", libgio.}

template gTypeTlsServerConnection*(): untyped =
  (tlsServerConnectionGetType())

template gTlsServerConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeTlsServerConnection, GTlsServerConnectionObj))

template gIsTlsServerConnection*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeTlsServerConnection))

template gTlsServerConnectionGetInterface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeTlsServerConnection, GTlsServerConnectionInterfaceObj))

type
  GTlsServerConnectionInterface* =  ptr GTlsServerConnectionInterfaceObj
  GTlsServerConnectionInterfacePtr* = ptr GTlsServerConnectionInterfaceObj
  GTlsServerConnectionInterfaceObj*{.final.} = object of GTypeInterfaceObj

proc tlsServerConnectionGetType*(): GType {.
    importc: "g_tls_server_connection_get_type", libgio.}
proc newTlsServerConnection*(baseIoStream: GIOStream;
                             certificate: GTlsCertificate;
                             error: var GError): GIOStream {.
    importc: "g_tls_server_connection_new", libgio.}

template gTypeTlsPassword*(): untyped =
  (tlsPasswordGetType())

template gTlsPassword*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeTlsPassword, GTlsPasswordObj))

template gTlsPasswordClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeTlsPassword, GTlsPasswordClassObj))

template gIsTlsPassword*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeTlsPassword))

template gIsTlsPasswordClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeTlsPassword))

template gTlsPasswordGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeTlsPassword, GTlsPasswordClassObj))

proc tlsPasswordGetType*(): GType {.importc: "g_tls_password_get_type", libgio.}
proc newTlsPassword*(flags: GTlsPasswordFlags; description: cstring): GTlsPassword {.
    importc: "g_tls_password_new", libgio.}
proc getValue*(password: GTlsPassword; length: var Gsize): ptr cuchar {.
    importc: "g_tls_password_get_value", libgio.}
proc value*(password: GTlsPassword; length: var Gsize): ptr cuchar {.
    importc: "g_tls_password_get_value", libgio.}
proc setValue*(password: GTlsPassword; value: var cuchar;
                          length: Gssize) {.importc: "g_tls_password_set_value",
    libgio.}
proc `value=`*(password: GTlsPassword; value: var cuchar;
                          length: Gssize) {.importc: "g_tls_password_set_value",
    libgio.}
proc setValueFull*(password: GTlsPassword; value: var cuchar;
                              length: Gssize; destroy: GDestroyNotify) {.
    importc: "g_tls_password_set_value_full", libgio.}
proc `valueFull=`*(password: GTlsPassword; value: var cuchar;
                              length: Gssize; destroy: GDestroyNotify) {.
    importc: "g_tls_password_set_value_full", libgio.}
proc getFlags*(password: GTlsPassword): GTlsPasswordFlags {.
    importc: "g_tls_password_get_flags", libgio.}
proc setFlags*(password: GTlsPassword; flags: GTlsPasswordFlags) {.
    importc: "g_tls_password_set_flags", libgio.}
proc getDescription*(password: GTlsPassword): cstring {.
    importc: "g_tls_password_get_description", libgio.}
proc description*(password: GTlsPassword): cstring {.
    importc: "g_tls_password_get_description", libgio.}
proc setDescription*(password: GTlsPassword; description: cstring) {.
    importc: "g_tls_password_set_description", libgio.}
proc `description=`*(password: GTlsPassword; description: cstring) {.
    importc: "g_tls_password_set_description", libgio.}
proc getWarning*(password: GTlsPassword): cstring {.
    importc: "g_tls_password_get_warning", libgio.}
proc warning*(password: GTlsPassword): cstring {.
    importc: "g_tls_password_get_warning", libgio.}
proc setWarning*(password: GTlsPassword; warning: cstring) {.
    importc: "g_tls_password_set_warning", libgio.}
proc `warning=`*(password: GTlsPassword; warning: cstring) {.
    importc: "g_tls_password_set_warning", libgio.}

template gTypeVfs*(): untyped =
  (vfsGetType())

template gVfs*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeVfs, GVfsObj))

template gVfsClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeVfs, GVfsClassObj))

template gVfsGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeVfs, GVfsClassObj))

template gIsVfs*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeVfs))

template gIsVfsClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeVfs))

const
  G_VFS_EXTENSION_POINT_NAME* = "gio-vfs"

type
  GVfsFileLookupFunc* = proc (vfs: GVfs; identifier: cstring; userData: Gpointer): GFile {.cdecl.}

  GVfs* =  ptr GVfsObj
  GVfsPtr* = ptr GVfsObj
  GVfsObj*{.final.} = object of GObjectObj

  GVfsClass* =  ptr GVfsClassObj
  GVfsClassPtr* = ptr GVfsClassObj
  GVfsClassObj*{.final.} = object of GObjectClassObj
    isActive*: proc (vfs: GVfs): Gboolean {.cdecl.}
    getFileForPath*: proc (vfs: GVfs; path: cstring): GFile {.cdecl.}
    getFileForUri*: proc (vfs: GVfs; uri: cstring): GFile {.cdecl.}
    getSupportedUriSchemes*: proc (vfs: GVfs): cstringArray {.cdecl.}
    parseName*: proc (vfs: GVfs; parseName: cstring): GFile {.cdecl.}
    localFileAddInfo*: proc (vfs: GVfs; filename: cstring; device: uint64;
                           attributeMatcher: GFileAttributeMatcher;
                           info: GFileInfo; cancellable: GCancellable;
                           extraData: var Gpointer;
                           freeExtraData: ptr GDestroyNotify) {.cdecl.}
    addWritableNamespaces*: proc (vfs: GVfs; list: GFileAttributeInfoList) {.cdecl.}
    localFileSetAttributes*: proc (vfs: GVfs; filename: cstring;
                                 info: GFileInfo; flags: GFileQueryInfoFlags;
                                 cancellable: GCancellable;
                                 error: var GError): Gboolean {.cdecl.}
    localFileRemoved*: proc (vfs: GVfs; filename: cstring) {.cdecl.}
    localFileMoved*: proc (vfs: GVfs; source: cstring; dest: cstring) {.cdecl.}
    deserializeIcon*: proc (vfs: GVfs; value: GVariant): GIcon {.cdecl.}
    gReserved341*: proc () {.cdecl.}
    gReserved342*: proc () {.cdecl.}
    gReserved343*: proc () {.cdecl.}
    gReserved344*: proc () {.cdecl.}
    gReserved345*: proc () {.cdecl.}
    gReserved346*: proc () {.cdecl.}

proc vfsGetType*(): GType {.importc: "g_vfs_get_type", libgio.}
proc isActive*(vfs: GVfs): Gboolean {.importc: "g_vfs_is_active", libgio.}
proc getFileForPath*(vfs: GVfs; path: cstring): GFile {.
    importc: "g_vfs_get_file_for_path", libgio.}
proc fileForPath*(vfs: GVfs; path: cstring): GFile {.
    importc: "g_vfs_get_file_for_path", libgio.}
proc getFileForUri*(vfs: GVfs; uri: cstring): GFile {.
    importc: "g_vfs_get_file_for_uri", libgio.}
proc fileForUri*(vfs: GVfs; uri: cstring): GFile {.
    importc: "g_vfs_get_file_for_uri", libgio.}
proc getSupportedUriSchemes*(vfs: GVfs): cstringArray {.
    importc: "g_vfs_get_supported_uri_schemes", libgio.}
proc supportedUriSchemes*(vfs: GVfs): cstringArray {.
    importc: "g_vfs_get_supported_uri_schemes", libgio.}
proc parseName*(vfs: GVfs; parseName: cstring): GFile {.
    importc: "g_vfs_parse_name", libgio.}
proc vfsGetDefault*(): GVfs {.importc: "g_vfs_get_default", libgio.}
proc vfsGetLocal*(): GVfs {.importc: "g_vfs_get_local", libgio.}
proc registerUriScheme*(vfs: GVfs; scheme: cstring;
                           uriFunc: GVfsFileLookupFunc; uriData: Gpointer;
                           uriDestroy: GDestroyNotify;
                           parseNameFunc: GVfsFileLookupFunc;
                           parseNameData: Gpointer;
                           parseNameDestroy: GDestroyNotify): Gboolean {.
    importc: "g_vfs_register_uri_scheme", libgio.}
proc unregisterUriScheme*(vfs: GVfs; scheme: cstring): Gboolean {.
    importc: "g_vfs_unregister_uri_scheme", libgio.}

const
  G_VOLUME_IDENTIFIER_KIND_HAL_UDI* = "hal-udi"

const
  G_VOLUME_IDENTIFIER_KIND_UNIX_DEVICE* = "unix-device"

const
  G_VOLUME_IDENTIFIER_KIND_LABEL* = "label"

const
  G_VOLUME_IDENTIFIER_KIND_UUID* = "uuid"

const
  G_VOLUME_IDENTIFIER_KIND_NFS_MOUNT* = "nfs-mount"

const
  G_VOLUME_IDENTIFIER_KIND_CLASS* = "class"

template gTypeVolume*(): untyped =
  (volumeGetType())

template gVolume*(obj: untyped): untyped =
  (gTypeCheckInstanceCast(obj, gTypeVolume, GVolumeObj))

template gIsVolume*(obj: untyped): untyped =
  (gTypeCheckInstanceType(obj, gTypeVolume))

template gVolumeGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeVolume, GVolumeIfaceObj))

type
  GVolumeIface* =  ptr GVolumeIfaceObj
  GVolumeIfacePtr* = ptr GVolumeIfaceObj
  GVolumeIfaceObj*{.final.} = object of GTypeInterfaceObj
    changed*: proc (volume: GVolume) {.cdecl.}
    removed*: proc (volume: GVolume) {.cdecl.}
    getName*: proc (volume: GVolume): cstring {.cdecl.}
    getIcon*: proc (volume: GVolume): GIcon {.cdecl.}
    getUuid*: proc (volume: GVolume): cstring {.cdecl.}
    getDrive*: proc (volume: GVolume): GDrive {.cdecl.}
    getMount*: proc (volume: GVolume): GMount {.cdecl.}
    canMount*: proc (volume: GVolume): Gboolean {.cdecl.}
    canEject*: proc (volume: GVolume): Gboolean {.cdecl.}
    mountFn*: proc (volume: GVolume; flags: GMountMountFlags;
                  mountOperation: GMountOperation;
                  cancellable: GCancellable; callback: GAsyncReadyCallback;
                  userData: Gpointer) {.cdecl.}
    mountFinish*: proc (volume: GVolume; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    eject*: proc (volume: GVolume; flags: GMountUnmountFlags;
                cancellable: GCancellable; callback: GAsyncReadyCallback;
                userData: Gpointer) {.cdecl.}
    ejectFinish*: proc (volume: GVolume; result: GAsyncResult;
                      error: var GError): Gboolean {.cdecl.}
    getIdentifier*: proc (volume: GVolume; kind: cstring): cstring {.cdecl.}
    enumerateIdentifiers*: proc (volume: GVolume): cstringArray {.cdecl.}
    shouldAutomount*: proc (volume: GVolume): Gboolean {.cdecl.}
    getActivationRoot*: proc (volume: GVolume): GFile {.cdecl.}
    ejectWithOperation*: proc (volume: GVolume; flags: GMountUnmountFlags;
                             mountOperation: GMountOperation;
                             cancellable: GCancellable;
                             callback: GAsyncReadyCallback; userData: Gpointer) {.cdecl.}
    ejectWithOperationFinish*: proc (volume: GVolume; result: GAsyncResult;
                                   error: var GError): Gboolean {.cdecl.}
    getSortKey*: proc (volume: GVolume): cstring {.cdecl.}
    getSymbolicIcon*: proc (volume: GVolume): GIcon {.cdecl.}

proc volumeGetType*(): GType {.importc: "g_volume_get_type", libgio.}
proc getName*(volume: GVolume): cstring {.importc: "g_volume_get_name",
    libgio.}
proc name*(volume: GVolume): cstring {.importc: "g_volume_get_name",
    libgio.}
proc getIcon*(volume: GVolume): GIcon {.importc: "g_volume_get_icon",
    libgio.}
proc icon*(volume: GVolume): GIcon {.importc: "g_volume_get_icon",
    libgio.}
proc getSymbolicIcon*(volume: GVolume): GIcon {.
    importc: "g_volume_get_symbolic_icon", libgio.}
proc symbolicIcon*(volume: GVolume): GIcon {.
    importc: "g_volume_get_symbolic_icon", libgio.}
proc getUuid*(volume: GVolume): cstring {.importc: "g_volume_get_uuid",
    libgio.}
proc uuid*(volume: GVolume): cstring {.importc: "g_volume_get_uuid",
    libgio.}
proc getDrive*(volume: GVolume): GDrive {.
    importc: "g_volume_get_drive", libgio.}
proc drive*(volume: GVolume): GDrive {.
    importc: "g_volume_get_drive", libgio.}
proc getMount*(volume: GVolume): GMount {.
    importc: "g_volume_get_mount", libgio.}
proc mount*(volume: GVolume): GMount {.
    importc: "g_volume_get_mount", libgio.}
proc canMount*(volume: GVolume): Gboolean {.importc: "g_volume_can_mount",
    libgio.}
proc canEject*(volume: GVolume): Gboolean {.importc: "g_volume_can_eject",
    libgio.}
proc shouldAutomount*(volume: GVolume): Gboolean {.
    importc: "g_volume_should_automount", libgio.}
proc mount*(volume: GVolume; flags: GMountMountFlags;
                  mountOperation: GMountOperation;
                  cancellable: GCancellable; callback: GAsyncReadyCallback;
                  userData: Gpointer) {.importc: "g_volume_mount", libgio.}
proc mountFinish*(volume: GVolume; result: GAsyncResult;
                        error: var GError): Gboolean {.
    importc: "g_volume_mount_finish", libgio.}
proc eject*(volume: GVolume; flags: GMountUnmountFlags;
                  cancellable: GCancellable; callback: GAsyncReadyCallback;
                  userData: Gpointer) {.importc: "g_volume_eject", libgio.}
proc ejectFinish*(volume: GVolume; result: GAsyncResult;
                        error: var GError): Gboolean {.
    importc: "g_volume_eject_finish", libgio.}
proc getIdentifier*(volume: GVolume; kind: cstring): cstring {.
    importc: "g_volume_get_identifier", libgio.}
proc identifier*(volume: GVolume; kind: cstring): cstring {.
    importc: "g_volume_get_identifier", libgio.}
proc enumerateIdentifiers*(volume: GVolume): cstringArray {.
    importc: "g_volume_enumerate_identifiers", libgio.}
proc getActivationRoot*(volume: GVolume): GFile {.
    importc: "g_volume_get_activation_root", libgio.}
proc activationRoot*(volume: GVolume): GFile {.
    importc: "g_volume_get_activation_root", libgio.}
proc ejectWithOperation*(volume: GVolume; flags: GMountUnmountFlags;
                               mountOperation: GMountOperation;
                               cancellable: GCancellable;
                               callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_volume_eject_with_operation", libgio.}
proc ejectWithOperationFinish*(volume: GVolume; result: GAsyncResult;
                                     error: var GError): Gboolean {.
    importc: "g_volume_eject_with_operation_finish", libgio.}
proc getSortKey*(volume: GVolume): cstring {.
    importc: "g_volume_get_sort_key", libgio.}
proc sortKey*(volume: GVolume): cstring {.
    importc: "g_volume_get_sort_key", libgio.}

template gTypeZlibCompressor*(): untyped =
  (zlibCompressorGetType())

template gZlibCompressor*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeZlibCompressor, GZlibCompressorObj))

template gZlibCompressorClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeZlibCompressor, GZlibCompressorClassObj))

template gIsZlibCompressor*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeZlibCompressor))

template gIsZlibCompressorClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeZlibCompressor))

template gZlibCompressorGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeZlibCompressor, GZlibCompressorClassObj))

type
  GZlibCompressorClass* =  ptr GZlibCompressorClassObj
  GZlibCompressorClassPtr* = ptr GZlibCompressorClassObj
  GZlibCompressorClassObj*{.final.} = object of GObjectClassObj

proc zlibCompressorGetType*(): GType {.importc: "g_zlib_compressor_get_type",
                                     libgio.}
proc newZlibCompressor*(format: GZlibCompressorFormat; level: cint): GZlibCompressor {.
    importc: "g_zlib_compressor_new", libgio.}
proc getFileInfo*(compressor: GZlibCompressor): GFileInfo {.
    importc: "g_zlib_compressor_get_file_info", libgio.}
proc fileInfo*(compressor: GZlibCompressor): GFileInfo {.
    importc: "g_zlib_compressor_get_file_info", libgio.}
proc setFileInfo*(compressor: GZlibCompressor;
                                fileInfo: GFileInfo) {.
    importc: "g_zlib_compressor_set_file_info", libgio.}
proc `fileInfo=`*(compressor: GZlibCompressor;
                                fileInfo: GFileInfo) {.
    importc: "g_zlib_compressor_set_file_info", libgio.}

template gTypeZlibDecompressor*(): untyped =
  (zlibDecompressorGetType())

template gZlibDecompressor*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeZlibDecompressor, GZlibDecompressorObj))

template gZlibDecompressorClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeZlibDecompressor, GZlibDecompressorClassObj))

template gIsZlibDecompressor*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeZlibDecompressor))

template gIsZlibDecompressorClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeZlibDecompressor))

template gZlibDecompressorGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeZlibDecompressor, GZlibDecompressorClassObj))

type
  GZlibDecompressorClass* =  ptr GZlibDecompressorClassObj
  GZlibDecompressorClassPtr* = ptr GZlibDecompressorClassObj
  GZlibDecompressorClassObj*{.final.} = object of GObjectClassObj

proc zlibDecompressorGetType*(): GType {.importc: "g_zlib_decompressor_get_type",
                                       libgio.}
proc newZlibDecompressor*(format: GZlibCompressorFormat): GZlibDecompressor {.
    importc: "g_zlib_decompressor_new", libgio.}
proc getFileInfo*(decompressor: GZlibDecompressor): GFileInfo {.
    importc: "g_zlib_decompressor_get_file_info", libgio.}
proc fileInfo*(decompressor: GZlibDecompressor): GFileInfo {.
    importc: "g_zlib_decompressor_get_file_info", libgio.}

template gTypeDbusInterface*(): untyped =
  (dbusInterfaceGetType())

template gDbusInterface*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusInterface, GDBusInterfaceObj))

template gIsDbusInterface*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusInterface))

template gDbusInterfaceGetIface*(o: untyped): untyped =
  (gTypeInstanceGetInterface(o, gTypeDbusInterface, GDBusInterfaceIfaceObj))

type
  GDBusInterfaceIface* =  ptr GDBusInterfaceIfaceObj
  GDBusInterfaceIfacePtr* = ptr GDBusInterfaceIfaceObj
  GDBusInterfaceIfaceObj*{.final.} = object of GTypeInterfaceObj
    getInfo*: proc (`interface`: GDBusInterface): GDBusInterfaceInfo {.cdecl.}
    getObject*: proc (`interface`: GDBusInterface): GDBusObject {.cdecl.}
    setObject*: proc (`interface`: GDBusInterface; `object`: GDBusObject) {.cdecl.}
    dupObject*: proc (`interface`: GDBusInterface): GDBusObject {.cdecl.}

proc dbusInterfaceGetType*(): GType {.importc: "g_dbus_interface_get_type",
                                    libgio.}
proc dbusInterfaceGetInfo*(`interface`: GDBusInterface): GDBusInterfaceInfo {.
    importc: "g_dbus_interface_get_info", libgio.}
proc dbusInterfaceGetObject*(`interface`: GDBusInterface): GDBusObject {.
    importc: "g_dbus_interface_get_object", libgio.}
proc dbusInterfaceSetObject*(`interface`: GDBusInterface;
                             `object`: GDBusObject) {.
    importc: "g_dbus_interface_set_object", libgio.}
proc dbusInterfaceDupObject*(`interface`: GDBusInterface): GDBusObject {.
    importc: "g_dbus_interface_dup_object", libgio.}

template gTypeDbusInterfaceSkeleton*(): untyped =
  (dbusInterfaceSkeletonGetType())

template gDbusInterfaceSkeleton*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusInterfaceSkeleton, GDBusInterfaceSkeletonObj))

template gDbusInterfaceSkeletonClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeDbusInterfaceSkeleton, GDBusInterfaceSkeletonClassObj))

template gDbusInterfaceSkeletonGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeDbusInterfaceSkeleton, GDBusInterfaceSkeletonClassObj))

template gIsDbusInterfaceSkeleton*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusInterfaceSkeleton))

template gIsDbusInterfaceSkeletonClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeDbusInterfaceSkeleton))

type
  GDBusInterfaceSkeleton* =  ptr GDBusInterfaceSkeletonObj
  GDBusInterfaceSkeletonPtr* = ptr GDBusInterfaceSkeletonObj
  GDBusInterfaceSkeletonObj*{.final.} = object of GObjectObj
    priv53: pointer

type
  GDBusInterfaceSkeletonClass* =  ptr GDBusInterfaceSkeletonClassObj
  GDBusInterfaceSkeletonClassPtr* = ptr GDBusInterfaceSkeletonClassObj
  GDBusInterfaceSkeletonClassObj*{.final.} = object of GObjectClassObj
    getInfo*: proc (`interface`: GDBusInterfaceSkeleton): GDBusInterfaceInfo {.cdecl.}
    getVtable*: proc (`interface`: GDBusInterfaceSkeleton): GDBusInterfaceVTable {.cdecl.}
    getProperties*: proc (`interface`: GDBusInterfaceSkeleton): GVariant {.cdecl.}
    flush*: proc (`interface`: GDBusInterfaceSkeleton) {.cdecl.}
    vfuncPadding*: array[8, Gpointer]
    gAuthorizeMethod*: proc (`interface`: GDBusInterfaceSkeleton;
                           invocation: GDBusMethodInvocation): Gboolean {.cdecl.}
    signalPadding*: array[8, Gpointer]

proc dbusInterfaceSkeletonGetType*(): GType {.
    importc: "g_dbus_interface_skeleton_get_type", libgio.}
proc dbusInterfaceSkeletonGetFlags*(`interface`: GDBusInterfaceSkeleton): GDBusInterfaceSkeletonFlags {.
    importc: "g_dbus_interface_skeleton_get_flags", libgio.}
proc dbusInterfaceSkeletonSetFlags*(`interface`: GDBusInterfaceSkeleton;
                                    flags: GDBusInterfaceSkeletonFlags) {.
    importc: "g_dbus_interface_skeleton_set_flags", libgio.}
proc dbusInterfaceSkeletonGetInfo*(`interface`: GDBusInterfaceSkeleton): GDBusInterfaceInfo {.
    importc: "g_dbus_interface_skeleton_get_info", libgio.}
proc dbusInterfaceSkeletonGetVtable*(`interface`: GDBusInterfaceSkeleton): GDBusInterfaceVTable {.
    importc: "g_dbus_interface_skeleton_get_vtable", libgio.}
proc dbusInterfaceSkeletonGetProperties*(`interface`: GDBusInterfaceSkeleton): GVariant {.
    importc: "g_dbus_interface_skeleton_get_properties", libgio.}
proc dbusInterfaceSkeletonFlush*(`interface`: GDBusInterfaceSkeleton) {.
    importc: "g_dbus_interface_skeleton_flush", libgio.}
proc dbusInterfaceSkeletonExport*(`interface`: GDBusInterfaceSkeleton;
                                  connection: GDBusConnection;
                                  objectPath: cstring; error: var GError): Gboolean {.
    importc: "g_dbus_interface_skeleton_export", libgio.}
proc dbusInterfaceSkeletonUnexport*(`interface`: GDBusInterfaceSkeleton) {.
    importc: "g_dbus_interface_skeleton_unexport", libgio.}
proc dbusInterfaceSkeletonUnexportFromConnection*(
    `interface`: GDBusInterfaceSkeleton; connection: GDBusConnection) {.
    importc: "g_dbus_interface_skeleton_unexport_from_connection", libgio.}
proc dbusInterfaceSkeletonGetConnection*(`interface`: GDBusInterfaceSkeleton): GDBusConnection {.
    importc: "g_dbus_interface_skeleton_get_connection", libgio.}
proc dbusInterfaceSkeletonGetConnections*(
    `interface`: GDBusInterfaceSkeleton): GList {.
    importc: "g_dbus_interface_skeleton_get_connections", libgio.}
proc dbusInterfaceSkeletonHasConnection*(
    `interface`: GDBusInterfaceSkeleton; connection: GDBusConnection): Gboolean {.
    importc: "g_dbus_interface_skeleton_has_connection", libgio.}
proc dbusInterfaceSkeletonGetObjectPath*(`interface`: GDBusInterfaceSkeleton): cstring {.
    importc: "g_dbus_interface_skeleton_get_object_path", libgio.}

template gTypeDbusObject*(): untyped =
  (dbusObjectGetType())

template gDbusObject*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusObject, GDBusObjectObj))

template gIsDbusObject*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusObject))

template gDbusObjectGetIface*(o: untyped): untyped =
  (gTypeInstanceGetInterface(o, gTypeDbusObject, GDBusObjectIfaceObj))

type
  GDBusObjectIface* =  ptr GDBusObjectIfaceObj
  GDBusObjectIfacePtr* = ptr GDBusObjectIfaceObj
  GDBusObjectIfaceObj*{.final.} = object of GTypeInterfaceObj
    getObjectPath*: proc (`object`: GDBusObject): cstring {.cdecl.}
    getInterfaces*: proc (`object`: GDBusObject): GList {.cdecl.}
    getInterface*: proc (`object`: GDBusObject; interfaceName: cstring): GDBusInterface {.cdecl.}
    interfaceAdded*: proc (`object`: GDBusObject; `interface`: GDBusInterface) {.cdecl.}
    interfaceRemoved*: proc (`object`: GDBusObject;
                           `interface`: GDBusInterface) {.cdecl.}

proc dbusObjectGetType*(): GType {.importc: "g_dbus_object_get_type", libgio.}
proc dbusObjectGetObjectPath*(`object`: GDBusObject): cstring {.
    importc: "g_dbus_object_get_object_path", libgio.}
proc dbusObjectGetInterfaces*(`object`: GDBusObject): GList {.
    importc: "g_dbus_object_get_interfaces", libgio.}
proc dbusObjectGetInterface*(`object`: GDBusObject; interfaceName: cstring): GDBusInterface {.
    importc: "g_dbus_object_get_interface", libgio.}

template gTypeDbusObjectSkeleton*(): untyped =
  (dbusObjectSkeletonGetType())

template gDbusObjectSkeleton*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusObjectSkeleton, GDBusObjectSkeletonObj))

template gDbusObjectSkeletonClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeDbusObjectSkeleton, GDBusObjectSkeletonClassObj))

template gDbusObjectSkeletonGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeDbusObjectSkeleton, GDBusObjectSkeletonClassObj))

template gIsDbusObjectSkeleton*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusObjectSkeleton))

template gIsDbusObjectSkeletonClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeDbusObjectSkeleton))

type
  GDBusObjectSkeleton* =  ptr GDBusObjectSkeletonObj
  GDBusObjectSkeletonPtr* = ptr GDBusObjectSkeletonObj
  GDBusObjectSkeletonObj*{.final.} = object of GObjectObj
    priv54: pointer

type
  GDBusObjectSkeletonClass* =  ptr GDBusObjectSkeletonClassObj
  GDBusObjectSkeletonClassPtr* = ptr GDBusObjectSkeletonClassObj
  GDBusObjectSkeletonClassObj*{.final.} = object of GObjectClassObj
    authorizeMethod*: proc (`object`: GDBusObjectSkeleton;
                          `interface`: GDBusInterfaceSkeleton;
                          invocation: GDBusMethodInvocation): Gboolean {.cdecl.}
    padding*: array[8, Gpointer]

proc dbusObjectSkeletonGetType*(): GType {.
    importc: "g_dbus_object_skeleton_get_type", libgio.}
proc newDbusObjectSkeleton*(objectPath: cstring): GDBusObjectSkeleton {.
    importc: "g_dbus_object_skeleton_new", libgio.}
proc dbusObjectSkeletonFlush*(`object`: GDBusObjectSkeleton) {.
    importc: "g_dbus_object_skeleton_flush", libgio.}
proc dbusObjectSkeletonAddInterface*(`object`: GDBusObjectSkeleton;
                                     `interface`: GDBusInterfaceSkeleton) {.
    importc: "g_dbus_object_skeleton_add_interface", libgio.}
proc dbusObjectSkeletonRemoveInterface*(`object`: GDBusObjectSkeleton;
                                        `interface`: GDBusInterfaceSkeleton) {.
    importc: "g_dbus_object_skeleton_remove_interface", libgio.}
proc dbusObjectSkeletonRemoveInterfaceByName*(`object`: GDBusObjectSkeleton;
    interfaceName: cstring) {.importc: "g_dbus_object_skeleton_remove_interface_by_name",
                            libgio.}
proc dbusObjectSkeletonSetObjectPath*(`object`: GDBusObjectSkeleton;
                                      objectPath: cstring) {.
    importc: "g_dbus_object_skeleton_set_object_path", libgio.}

template gTypeDbusObjectProxy*(): untyped =
  (dbusObjectProxyGetType())

template gDbusObjectProxy*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusObjectProxy, GDBusObjectProxyObj))

template gDbusObjectProxyClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeDbusObjectProxy, GDBusObjectProxyClassObj))

template gDbusObjectProxyGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeDbusObjectProxy, GDBusObjectProxyClassObj))

template gIsDbusObjectProxy*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusObjectProxy))

template gIsDbusObjectProxyClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeDbusObjectProxy))

proc dbusObjectProxyGetType*(): GType {.importc: "g_dbus_object_proxy_get_type",
                                      libgio.}
proc newDbusObjectProxy*(connection: GDBusConnection; objectPath: cstring): GDBusObjectProxy {.
    importc: "g_dbus_object_proxy_new", libgio.}
proc dbusObjectProxyGetConnection*(proxy: GDBusObjectProxy): GDBusConnection {.
    importc: "g_dbus_object_proxy_get_connection", libgio.}

template gTypeDbusObjectManager*(): untyped =
  (dbusObjectManagerGetType())

template gDbusObjectManager*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusObjectManager, GDBusObjectManagerObj))

template gIsDbusObjectManager*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusObjectManager))

template gDbusObjectManagerGetIface*(o: untyped): untyped =
  (gTypeInstanceGetInterface(o, gTypeDbusObjectManager, GDBusObjectManagerIfaceObj))

type
  GDBusObjectManagerIface* =  ptr GDBusObjectManagerIfaceObj
  GDBusObjectManagerIfacePtr* = ptr GDBusObjectManagerIfaceObj
  GDBusObjectManagerIfaceObj*{.final.} = object of GTypeInterfaceObj
    getObjectPath*: proc (manager: GDBusObjectManager): cstring {.cdecl.}
    getObjects*: proc (manager: GDBusObjectManager): GList {.cdecl.}
    getObject*: proc (manager: GDBusObjectManager; objectPath: cstring): GDBusObject {.cdecl.}
    getInterface*: proc (manager: GDBusObjectManager; objectPath: cstring;
                       interfaceName: cstring): GDBusInterface {.cdecl.}
    objectAdded*: proc (manager: GDBusObjectManager; `object`: GDBusObject) {.cdecl.}
    objectRemoved*: proc (manager: GDBusObjectManager; `object`: GDBusObject) {.cdecl.}
    interfaceAdded*: proc (manager: GDBusObjectManager;
                         `object`: GDBusObject; `interface`: GDBusInterface) {.cdecl.}
    interfaceRemoved*: proc (manager: GDBusObjectManager;
                           `object`: GDBusObject;
                           `interface`: GDBusInterface) {.cdecl.}

proc dbusObjectManagerGetType*(): GType {.importc: "g_dbus_object_manager_get_type",
                                        libgio.}
proc dbusObjectManagerGetObjectPath*(manager: GDBusObjectManager): cstring {.
    importc: "g_dbus_object_manager_get_object_path", libgio.}
proc dbusObjectManagerGetObjects*(manager: GDBusObjectManager): GList {.
    importc: "g_dbus_object_manager_get_objects", libgio.}
proc dbusObjectManagerGetObject*(manager: GDBusObjectManager;
                                 objectPath: cstring): GDBusObject {.
    importc: "g_dbus_object_manager_get_object", libgio.}
proc dbusObjectManagerGetInterface*(manager: GDBusObjectManager;
                                    objectPath: cstring; interfaceName: cstring): GDBusInterface {.
    importc: "g_dbus_object_manager_get_interface", libgio.}

template gTypeDbusObjectManagerClient*(): untyped =
  (dbusObjectManagerClientGetType())

template gDbusObjectManagerClient*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusObjectManagerClient, GDBusObjectManagerClientObj))

template gDbusObjectManagerClientClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeDbusObjectManagerClient, GDBusObjectManagerClientClassObj))

template gDbusObjectManagerClientGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeDbusObjectManagerClient, GDBusObjectManagerClientClassObj))

template gIsDbusObjectManagerClient*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusObjectManagerClient))

template gIsDbusObjectManagerClientClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeDbusObjectManagerClient))

proc dbusObjectManagerClientGetType*(): GType {.
    importc: "g_dbus_object_manager_client_get_type", libgio.}
proc dbusObjectManagerClientNew*(connection: GDBusConnection;
                                 flags: GDBusObjectManagerClientFlags;
                                 name: cstring; objectPath: cstring;
                                 getProxyTypeFunc: GDBusProxyTypeFunc;
                                 getProxyTypeUserData: Gpointer;
                                 getProxyTypeDestroyNotify: GDestroyNotify;
                                 cancellable: GCancellable;
                                 callback: GAsyncReadyCallback; userData: Gpointer) {.
    importc: "g_dbus_object_manager_client_new", libgio.}
proc dbusObjectManagerClientNewFinish*(res: GAsyncResult; error: var GError): GDBusObjectManager {.
    importc: "g_dbus_object_manager_client_new_finish", libgio.}
proc dbusObjectManagerClientNewSync*(connection: GDBusConnection;
                                     flags: GDBusObjectManagerClientFlags;
                                     name: cstring; objectPath: cstring;
                                     getProxyTypeFunc: GDBusProxyTypeFunc;
                                     getProxyTypeUserData: Gpointer;
                                     getProxyTypeDestroyNotify: GDestroyNotify;
                                     cancellable: GCancellable;
                                     error: var GError): GDBusObjectManager {.
    importc: "g_dbus_object_manager_client_new_sync", libgio.}
proc dbusObjectManagerClientNewForBus*(busType: GBusType;
                                       flags: GDBusObjectManagerClientFlags;
                                       name: cstring; objectPath: cstring;
                                       getProxyTypeFunc: GDBusProxyTypeFunc;
                                       getProxyTypeUserData: Gpointer;
    getProxyTypeDestroyNotify: GDestroyNotify; cancellable: GCancellable;
                                       callback: GAsyncReadyCallback;
                                       userData: Gpointer) {.
    importc: "g_dbus_object_manager_client_new_for_bus", libgio.}
proc dbusObjectManagerClientNewForBusFinish*(res: GAsyncResult;
    error: var GError): GDBusObjectManager {.
    importc: "g_dbus_object_manager_client_new_for_bus_finish", libgio.}
proc dbusObjectManagerClientNewForBusSync*(busType: GBusType;
    flags: GDBusObjectManagerClientFlags; name: cstring; objectPath: cstring;
    getProxyTypeFunc: GDBusProxyTypeFunc; getProxyTypeUserData: Gpointer;
    getProxyTypeDestroyNotify: GDestroyNotify; cancellable: GCancellable;
    error: var GError): GDBusObjectManager {.
    importc: "g_dbus_object_manager_client_new_for_bus_sync", libgio.}
proc dbusObjectManagerClientGetConnection*(manager: GDBusObjectManagerClient): GDBusConnection {.
    importc: "g_dbus_object_manager_client_get_connection", libgio.}
proc dbusObjectManagerClientGetFlags*(manager: GDBusObjectManagerClient): GDBusObjectManagerClientFlags {.
    importc: "g_dbus_object_manager_client_get_flags", libgio.}
proc dbusObjectManagerClientGetName*(manager: GDBusObjectManagerClient): cstring {.
    importc: "g_dbus_object_manager_client_get_name", libgio.}
proc dbusObjectManagerClientGetNameOwner*(manager: GDBusObjectManagerClient): cstring {.
    importc: "g_dbus_object_manager_client_get_name_owner", libgio.}

template gTypeDbusObjectManagerServer*(): untyped =
  (dbusObjectManagerServerGetType())

template gDbusObjectManagerServer*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeDbusObjectManagerServer, GDBusObjectManagerServerObj))

template gDbusObjectManagerServerClass*(k: untyped): untyped =
  (gTypeCheckClassCast(k, gTypeDbusObjectManagerServer, GDBusObjectManagerServerClassObj))

template gDbusObjectManagerServerGetClass*(o: untyped): untyped =
  (gTypeInstanceGetClass(o, gTypeDbusObjectManagerServer, GDBusObjectManagerServerClassObj))

template gIsDbusObjectManagerServer*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeDbusObjectManagerServer))

template gIsDbusObjectManagerServerClass*(k: untyped): untyped =
  (gTypeCheckClassType(k, gTypeDbusObjectManagerServer))

type
  GDBusObjectManagerServer* =  ptr GDBusObjectManagerServerObj
  GDBusObjectManagerServerPtr* = ptr GDBusObjectManagerServerObj
  GDBusObjectManagerServerObj*{.final.} = object of GObjectObj
    priv55: pointer

type
  GDBusObjectManagerServerClass* =  ptr GDBusObjectManagerServerClassObj
  GDBusObjectManagerServerClassPtr* = ptr GDBusObjectManagerServerClassObj
  GDBusObjectManagerServerClassObj*{.final.} = object of GObjectClassObj
    padding*: array[8, Gpointer]

proc dbusObjectManagerServerGetType*(): GType {.
    importc: "g_dbus_object_manager_server_get_type", libgio.}
proc newDbusObjectManagerServer*(objectPath: cstring): GDBusObjectManagerServer {.
    importc: "g_dbus_object_manager_server_new", libgio.}
proc dbusObjectManagerServerGetConnection*(manager: GDBusObjectManagerServer): GDBusConnection {.
    importc: "g_dbus_object_manager_server_get_connection", libgio.}
proc dbusObjectManagerServerSetConnection*(
    manager: GDBusObjectManagerServer; connection: GDBusConnection) {.
    importc: "g_dbus_object_manager_server_set_connection", libgio.}
proc dbusObjectManagerServerExport*(manager: GDBusObjectManagerServer;
                                    `object`: GDBusObjectSkeleton) {.
    importc: "g_dbus_object_manager_server_export", libgio.}
proc dbusObjectManagerServerExportUniquely*(
    manager: GDBusObjectManagerServer; `object`: GDBusObjectSkeleton) {.
    importc: "g_dbus_object_manager_server_export_uniquely", libgio.}
proc dbusObjectManagerServerIsExported*(manager: GDBusObjectManagerServer;
                                        `object`: GDBusObjectSkeleton): Gboolean {.
    importc: "g_dbus_object_manager_server_is_exported", libgio.}
proc dbusObjectManagerServerUnexport*(manager: GDBusObjectManagerServer;
                                      objectPath: cstring): Gboolean {.
    importc: "g_dbus_object_manager_server_unexport", libgio.}

template gTypeDbusActionGroup*(): untyped =
  (dbusActionGroupGetType())

template gDbusActionGroup*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeDbusActionGroup, GDBusActionGroupObj))

template gDbusActionGroupClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeDbusActionGroup, GDBusActionGroupClass))

template gIsDbusActionGroup*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeDbusActionGroup))

template gIsDbusActionGroupClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeDbusActionGroup))

template gDbusActionGroupGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeDbusActionGroup, GDBusActionGroupClass))

proc dbusActionGroupGetType*(): GType {.importc: "g_dbus_action_group_get_type",
                                      libgio.}
proc dbusActionGroupGet*(connection: GDBusConnection; busName: cstring;
                         objectPath: cstring): GDBusActionGroup {.
    importc: "g_dbus_action_group_get", libgio.}

template gTypeRemoteActionGroup*(): untyped =
  (remoteActionGroupGetType())

template gRemoteActionGroup*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeRemoteActionGroup, GRemoteActionGroupObj))

template gIsRemoteActionGroup*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeRemoteActionGroup))

template gRemoteActionGroupGetIface*(inst: untyped): untyped =
  (gTypeInstanceGetInterface(inst, gTypeRemoteActionGroup, GRemoteActionGroupInterfaceObj))

type
  GRemoteActionGroupInterface* =  ptr GRemoteActionGroupInterfaceObj
  GRemoteActionGroupInterfacePtr* = ptr GRemoteActionGroupInterfaceObj
  GRemoteActionGroupInterfaceObj*{.final.} = object of GTypeInterfaceObj
    activateActionFull*: proc (remote: GRemoteActionGroup; actionName: cstring;
                             parameter: GVariant; platformData: GVariant) {.cdecl.}
    changeActionStateFull*: proc (remote: GRemoteActionGroup;
                                actionName: cstring; value: GVariant;
                                platformData: GVariant) {.cdecl.}

proc remoteActionGroupGetType*(): GType {.importc: "g_remote_action_group_get_type",
                                        libgio.}
proc activateActionFull*(remote: GRemoteActionGroup;
    actionName: cstring; parameter: GVariant; platformData: GVariant) {.
    importc: "g_remote_action_group_activate_action_full", libgio.}
proc changeActionStateFull*(remote: GRemoteActionGroup;
    actionName: cstring; value: GVariant; platformData: GVariant) {.
    importc: "g_remote_action_group_change_action_state_full", libgio.}

const
  G_MENU_ATTRIBUTE_ACTION* = "action"

const
  G_MENU_ATTRIBUTE_ACTION_NAMESPACE* = "action-namespace"

const
  G_MENU_ATTRIBUTE_TARGET* = "target"

const
  G_MENU_ATTRIBUTE_LABEL* = "label"

const
  G_MENU_ATTRIBUTE_ICON* = "icon"

const
  G_MENU_LINK_SUBMENU* = "submenu"

const
  G_MENU_LINK_SECTION* = "section"

template gTypeMenuModel*(): untyped =
  (menuModelGetType())

template gMenuModel*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeMenuModel, GMenuModelObj))

template gMenuModelClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeMenuModel, GMenuModelClassObj))

template gIsMenuModel*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeMenuModel))

template gIsMenuModelClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeMenuModel))

template gMenuModelGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeMenuModel, GMenuModelClassObj))

type
  GMenuAttributeIter* =  ptr GMenuAttributeIterObj
  GMenuAttributeIterPtr* = ptr GMenuAttributeIterObj
  GMenuAttributeIterObj*{.final.} = object of GObjectObj
    priv56: pointer

  GMenuAttributeIterClass* =  ptr GMenuAttributeIterClassObj
  GMenuAttributeIterClassPtr* = ptr GMenuAttributeIterClassObj
  GMenuAttributeIterClassObj*{.final.} = object of GObjectClassObj
    getNext*: proc (iter: GMenuAttributeIter; outName: cstringArray;
                  value: var GVariant): Gboolean {.cdecl.}

  GMenuModel* =  ptr GMenuModelObj
  GMenuModelPtr* = ptr GMenuModelObj
  GMenuModelObj*{.final.} = object of GObjectObj
    priv57: pointer
type
  GMenuLinkIter* =  ptr GMenuLinkIterObj
  GMenuLinkIterPtr* = ptr GMenuLinkIterObj
  GMenuLinkIterObj*{.final.} = object of GObjectObj
    priv58: pointer

  GMenuLinkIterClass* =  ptr GMenuLinkIterClassObj
  GMenuLinkIterClassPtr* = ptr GMenuLinkIterClassObj
  GMenuLinkIterClassObj*{.final.} = object of GObjectClassObj
    getNext*: proc (iter: GMenuLinkIter; outLink: cstringArray;
                  value: var GMenuModel): Gboolean {.cdecl.}

type
  GMenuModelClass* =  ptr GMenuModelClassObj
  GMenuModelClassPtr* = ptr GMenuModelClassObj
  GMenuModelClassObj*{.final.} = object of GObjectClassObj
    isMutable*: proc (model: GMenuModel): Gboolean {.cdecl.}
    getNItems*: proc (model: GMenuModel): cint {.cdecl.}
    getItemAttributes*: proc (model: GMenuModel; itemIndex: cint;
                            attributes: var glib.GHashTable) {.cdecl.}
    iterateItemAttributes*: proc (model: GMenuModel; itemIndex: cint): GMenuAttributeIter {.cdecl.}
    getItemAttributeValue*: proc (model: GMenuModel; itemIndex: cint;
                                attribute: cstring; expectedType: GVariantType): GVariant {.cdecl.}
    getItemLinks*: proc (model: GMenuModel; itemIndex: cint;
                       links: var glib.GHashTable) {.cdecl.}
    iterateItemLinks*: proc (model: GMenuModel; itemIndex: cint): GMenuLinkIter {.cdecl.}
    getItemLink*: proc (model: GMenuModel; itemIndex: cint; link: cstring): GMenuModel {.cdecl.}

proc menuModelGetType*(): GType {.importc: "g_menu_model_get_type", libgio.}
proc isMutable*(model: GMenuModel): Gboolean {.
    importc: "g_menu_model_is_mutable", libgio.}
proc getNItems*(model: GMenuModel): cint {.
    importc: "g_menu_model_get_n_items", libgio.}
proc nItems*(model: GMenuModel): cint {.
    importc: "g_menu_model_get_n_items", libgio.}
proc iterateItemAttributes*(model: GMenuModel; itemIndex: cint): GMenuAttributeIter {.
    importc: "g_menu_model_iterate_item_attributes", libgio.}
proc getItemAttributeValue*(model: GMenuModel; itemIndex: cint;
                                     attribute: cstring;
                                     expectedType: GVariantType): GVariant {.
    importc: "g_menu_model_get_item_attribute_value", libgio.}
proc itemAttributeValue*(model: GMenuModel; itemIndex: cint;
                                     attribute: cstring;
                                     expectedType: GVariantType): GVariant {.
    importc: "g_menu_model_get_item_attribute_value", libgio.}
proc getItemAttribute*(model: GMenuModel; itemIndex: cint;
                                attribute: cstring; formatString: cstring): Gboolean {.
    varargs, importc: "g_menu_model_get_item_attribute", libgio.}
proc itemAttribute*(model: GMenuModel; itemIndex: cint;
                                attribute: cstring; formatString: cstring): Gboolean {.
    varargs, importc: "g_menu_model_get_item_attribute", libgio.}
proc iterateItemLinks*(model: GMenuModel; itemIndex: cint): GMenuLinkIter {.
    importc: "g_menu_model_iterate_item_links", libgio.}
proc getItemLink*(model: GMenuModel; itemIndex: cint; link: cstring): GMenuModel {.
    importc: "g_menu_model_get_item_link", libgio.}
proc itemLink*(model: GMenuModel; itemIndex: cint; link: cstring): GMenuModel {.
    importc: "g_menu_model_get_item_link", libgio.}
proc itemsChanged*(model: GMenuModel; position: cint; removed: cint;
                            added: cint) {.importc: "g_menu_model_items_changed",
    libgio.}
template gTypeMenuAttributeIter*(): untyped =
  (menuAttributeIterGetType())

template gMenuAttributeIter*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeMenuAttributeIter, GMenuAttributeIterObj))

template gMenuAttributeIterClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeMenuAttributeIter, GMenuAttributeIterClassObj))

template gIsMenuAttributeIter*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeMenuAttributeIter))

template gIsMenuAttributeIterClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeMenuAttributeIter))

template gMenuAttributeIterGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeMenuAttributeIter, GMenuAttributeIterClassObj))

proc menuAttributeIterGetType*(): GType {.importc: "g_menu_attribute_iter_get_type",
                                        libgio.}
proc getNext*(iter: GMenuAttributeIter; outName: cstringArray;
                               value: var GVariant): Gboolean {.
    importc: "g_menu_attribute_iter_get_next", libgio.}
proc next*(iter: GMenuAttributeIter; outName: cstringArray;
                               value: var GVariant): Gboolean {.
    importc: "g_menu_attribute_iter_get_next", libgio.}
proc next*(iter: GMenuAttributeIter): Gboolean {.
    importc: "g_menu_attribute_iter_next", libgio.}
proc getName*(iter: GMenuAttributeIter): cstring {.
    importc: "g_menu_attribute_iter_get_name", libgio.}
proc name*(iter: GMenuAttributeIter): cstring {.
    importc: "g_menu_attribute_iter_get_name", libgio.}
proc getValue*(iter: GMenuAttributeIter): GVariant {.
    importc: "g_menu_attribute_iter_get_value", libgio.}
proc value*(iter: GMenuAttributeIter): GVariant {.
    importc: "g_menu_attribute_iter_get_value", libgio.}
template gTypeMenuLinkIter*(): untyped =
  (menuLinkIterGetType())

template gMenuLinkIter*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeMenuLinkIter, GMenuLinkIterObj))

template gMenuLinkIterClass*(class: untyped): untyped =
  (gTypeCheckClassCast(class, gTypeMenuLinkIter, GMenuLinkIterClassObj))

template gIsMenuLinkIter*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeMenuLinkIter))

template gIsMenuLinkIterClass*(class: untyped): untyped =
  (gTypeCheckClassType(class, gTypeMenuLinkIter))

template gMenuLinkIterGetClass*(inst: untyped): untyped =
  (gTypeInstanceGetClass(inst, gTypeMenuLinkIter, GMenuLinkIterClassObj))

proc menuLinkIterGetType*(): GType {.importc: "g_menu_link_iter_get_type",
                                   libgio.}
proc getNext*(iter: GMenuLinkIter; outLink: cstringArray;
                          value: var GMenuModel): Gboolean {.
    importc: "g_menu_link_iter_get_next", libgio.}
proc next*(iter: GMenuLinkIter; outLink: cstringArray;
                          value: var GMenuModel): Gboolean {.
    importc: "g_menu_link_iter_get_next", libgio.}
proc next*(iter: GMenuLinkIter): Gboolean {.
    importc: "g_menu_link_iter_next", libgio.}
proc getName*(iter: GMenuLinkIter): cstring {.
    importc: "g_menu_link_iter_get_name", libgio.}
proc name*(iter: GMenuLinkIter): cstring {.
    importc: "g_menu_link_iter_get_name", libgio.}
proc getValue*(iter: GMenuLinkIter): GMenuModel {.
    importc: "g_menu_link_iter_get_value", libgio.}
proc value*(iter: GMenuLinkIter): GMenuModel {.
    importc: "g_menu_link_iter_get_value", libgio.}

template gTypeMenu*(): untyped =
  (menuGetType())

template gMenu*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeMenu, GMenuObj))

template gIsMenu*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeMenu))

template gTypeMenuItem*(): untyped =
  (menuItemGetType())

template gMenuItem*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeMenuItem, GMenuItemObj))

template gIsMenuItem*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeMenuItem))

type
  GMenuItem* =  ptr GMenuItemObj
  GMenuItemPtr* = ptr GMenuItemObj
  GMenuItemObj* = object

  GMenu* =  ptr GMenuObj
  GMenuPtr* = ptr GMenuObj
  GMenuObj* = object

proc menuGetType*(): GType {.importc: "g_menu_get_type", libgio.}
proc newMenu*(): GMenu {.importc: "g_menu_new", libgio.}
proc freeze*(menu: GMenu) {.importc: "g_menu_freeze", libgio.}
proc insertItem*(menu: GMenu; position: cint; item: GMenuItem) {.
    importc: "g_menu_insert_item", libgio.}
proc prependItem*(menu: GMenu; item: GMenuItem) {.
    importc: "g_menu_prepend_item", libgio.}
proc appendItem*(menu: GMenu; item: GMenuItem) {.
    importc: "g_menu_append_item", libgio.}
proc remove*(menu: GMenu; position: cint) {.importc: "g_menu_remove",
    libgio.}
proc removeAll*(menu: GMenu) {.importc: "g_menu_remove_all", libgio.}
proc insert*(menu: GMenu; position: cint; label: cstring;
                 detailedAction: cstring) {.importc: "g_menu_insert", libgio.}
proc prepend*(menu: GMenu; label: cstring; detailedAction: cstring) {.
    importc: "g_menu_prepend", libgio.}
proc append*(menu: GMenu; label: cstring; detailedAction: cstring) {.
    importc: "g_menu_append", libgio.}
proc insertSection*(menu: GMenu; position: cint; label: cstring;
                        section: GMenuModel) {.
    importc: "g_menu_insert_section", libgio.}
proc prependSection*(menu: GMenu; label: cstring; section: GMenuModel) {.
    importc: "g_menu_prepend_section", libgio.}
proc appendSection*(menu: GMenu; label: cstring; section: GMenuModel) {.
    importc: "g_menu_append_section", libgio.}
proc insertSubmenu*(menu: GMenu; position: cint; label: cstring;
                        submenu: GMenuModel) {.
    importc: "g_menu_insert_submenu", libgio.}
proc prependSubmenu*(menu: GMenu; label: cstring; submenu: GMenuModel) {.
    importc: "g_menu_prepend_submenu", libgio.}
proc appendSubmenu*(menu: GMenu; label: cstring; submenu: GMenuModel) {.
    importc: "g_menu_append_submenu", libgio.}
proc menuItemGetType*(): GType {.importc: "g_menu_item_get_type", libgio.}
proc newMenuItem*(label: cstring; detailedAction: cstring): GMenuItem {.
    importc: "g_menu_item_new", libgio.}
proc newMenuItem*(model: GMenuModel; itemIndex: cint): GMenuItem {.
    importc: "g_menu_item_new_from_model", libgio.}
proc newMenuItem*(label: cstring; submenu: GMenuModel): GMenuItem {.
    importc: "g_menu_item_new_submenu", libgio.}
proc newMenuItem*(label: cstring; section: GMenuModel): GMenuItem {.
    importc: "g_menu_item_new_section", libgio.}
proc getAttributeValue*(menuItem: GMenuItem; attribute: cstring;
                                expectedType: GVariantType): GVariant {.
    importc: "g_menu_item_get_attribute_value", libgio.}
proc attributeValue*(menuItem: GMenuItem; attribute: cstring;
                                expectedType: GVariantType): GVariant {.
    importc: "g_menu_item_get_attribute_value", libgio.}
proc getAttribute*(menuItem: GMenuItem; attribute: cstring;
                           formatString: cstring): Gboolean {.varargs,
    importc: "g_menu_item_get_attribute", libgio.}
proc attribute*(menuItem: GMenuItem; attribute: cstring;
                           formatString: cstring): Gboolean {.varargs,
    importc: "g_menu_item_get_attribute", libgio.}
proc getLink*(menuItem: GMenuItem; link: cstring): GMenuModel {.
    importc: "g_menu_item_get_link", libgio.}
proc link*(menuItem: GMenuItem; link: cstring): GMenuModel {.
    importc: "g_menu_item_get_link", libgio.}
proc setAttributeValue*(menuItem: GMenuItem; attribute: cstring;
                                value: GVariant) {.
    importc: "g_menu_item_set_attribute_value", libgio.}
proc `attributeValue=`*(menuItem: GMenuItem; attribute: cstring;
                                value: GVariant) {.
    importc: "g_menu_item_set_attribute_value", libgio.}
proc setAttribute*(menuItem: GMenuItem; attribute: cstring;
                           formatString: cstring) {.varargs,
    importc: "g_menu_item_set_attribute", libgio.}
proc `attribute=`*(menuItem: GMenuItem; attribute: cstring;
                           formatString: cstring) {.varargs,
    importc: "g_menu_item_set_attribute", libgio.}
proc setLink*(menuItem: GMenuItem; link: cstring; model: GMenuModel) {.
    importc: "g_menu_item_set_link", libgio.}
proc `link=`*(menuItem: GMenuItem; link: cstring; model: GMenuModel) {.
    importc: "g_menu_item_set_link", libgio.}
proc setLabel*(menuItem: GMenuItem; label: cstring) {.
    importc: "g_menu_item_set_label", libgio.}
proc `label=`*(menuItem: GMenuItem; label: cstring) {.
    importc: "g_menu_item_set_label", libgio.}
proc setSubmenu*(menuItem: GMenuItem; submenu: GMenuModel) {.
    importc: "g_menu_item_set_submenu", libgio.}
proc `submenu=`*(menuItem: GMenuItem; submenu: GMenuModel) {.
    importc: "g_menu_item_set_submenu", libgio.}
proc setSection*(menuItem: GMenuItem; section: GMenuModel) {.
    importc: "g_menu_item_set_section", libgio.}
proc `section=`*(menuItem: GMenuItem; section: GMenuModel) {.
    importc: "g_menu_item_set_section", libgio.}
proc setActionAndTargetValue*(menuItem: GMenuItem; action: cstring;
                                      targetValue: GVariant) {.
    importc: "g_menu_item_set_action_and_target_value", libgio.}
proc `actionAndTargetValue=`*(menuItem: GMenuItem; action: cstring;
                                      targetValue: GVariant) {.
    importc: "g_menu_item_set_action_and_target_value", libgio.}
proc setActionAndTarget*(menuItem: GMenuItem; action: cstring;
                                 formatString: cstring) {.varargs,
    importc: "g_menu_item_set_action_and_target", libgio.}
proc `actionAndTarget=`*(menuItem: GMenuItem; action: cstring;
                                 formatString: cstring) {.varargs,
    importc: "g_menu_item_set_action_and_target", libgio.}
proc setDetailedAction*(menuItem: GMenuItem; detailedAction: cstring) {.
    importc: "g_menu_item_set_detailed_action", libgio.}
proc `detailedAction=`*(menuItem: GMenuItem; detailedAction: cstring) {.
    importc: "g_menu_item_set_detailed_action", libgio.}
proc setIcon*(menuItem: GMenuItem; icon: GIcon) {.
    importc: "g_menu_item_set_icon", libgio.}
proc `icon=`*(menuItem: GMenuItem; icon: GIcon) {.
    importc: "g_menu_item_set_icon", libgio.}

proc dbusConnectionExportMenuModel*(connection: GDBusConnection;
                                    objectPath: cstring; menu: GMenuModel;
                                    error: var GError): cuint {.
    importc: "g_dbus_connection_export_menu_model", libgio.}
proc dbusConnectionUnexportMenuModel*(connection: GDBusConnection;
                                      exportId: cuint) {.
    importc: "g_dbus_connection_unexport_menu_model", libgio.}

template gTypeDbusMenuModel*(): untyped =
  (dbusMenuModelGetType())

template gDbusMenuModel*(inst: untyped): untyped =
  (gTypeCheckInstanceCast(inst, gTypeDbusMenuModel, GDBusMenuModelObj))

template gIsDbusMenuModel*(inst: untyped): untyped =
  (gTypeCheckInstanceType(inst, gTypeDbusMenuModel))

type
  GDBusMenuModel* =  ptr GDBusMenuModelObj
  GDBusMenuModelPtr* = ptr GDBusMenuModelObj
  GDBusMenuModelObj* = object

proc dbusMenuModelGetType*(): GType {.importc: "g_dbus_menu_model_get_type",
                                    libgio.}
proc dbusMenuModelGet*(connection: GDBusConnection; busName: cstring;
                       objectPath: cstring): GDBusMenuModel {.
    importc: "g_dbus_menu_model_get", libgio.}

template gTypeNotification*(): untyped =
  (notificationGetType())

template gNotification*(o: untyped): untyped =
  (gTypeCheckInstanceCast(o, gTypeNotification, GNotificationObj))

template gIsNotification*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeNotification))

proc notificationGetType*(): GType {.importc: "g_notification_get_type", libgio.}
proc newNotification*(title: cstring): GNotification {.
    importc: "g_notification_new", libgio.}
proc setTitle*(notification: GNotification; title: cstring) {.
    importc: "g_notification_set_title", libgio.}
proc `title=`*(notification: GNotification; title: cstring) {.
    importc: "g_notification_set_title", libgio.}
proc setBody*(notification: GNotification; body: cstring) {.
    importc: "g_notification_set_body", libgio.}
proc `body=`*(notification: GNotification; body: cstring) {.
    importc: "g_notification_set_body", libgio.}
proc setIcon*(notification: GNotification; icon: GIcon) {.
    importc: "g_notification_set_icon", libgio.}
proc `icon=`*(notification: GNotification; icon: GIcon) {.
    importc: "g_notification_set_icon", libgio.}
proc setUrgent*(notification: GNotification; urgent: Gboolean) {.
    importc: "g_notification_set_urgent", libgio.}
proc `urgent=`*(notification: GNotification; urgent: Gboolean) {.
    importc: "g_notification_set_urgent", libgio.}
proc setPriority*(notification: GNotification;
                              priority: GNotificationPriority) {.
    importc: "g_notification_set_priority", libgio.}
proc `priority=`*(notification: GNotification;
                              priority: GNotificationPriority) {.
    importc: "g_notification_set_priority", libgio.}
proc addButton*(notification: GNotification; label: cstring;
                            detailedAction: cstring) {.
    importc: "g_notification_add_button", libgio.}
proc addButtonWithTarget*(notification: GNotification;
                                      label: cstring; action: cstring;
                                      targetFormat: cstring) {.varargs,
    importc: "g_notification_add_button_with_target", libgio.}
proc addButtonWithTargetValue*(notification: GNotification;
    label: cstring; action: cstring; target: GVariant) {.
    importc: "g_notification_add_button_with_target_value", libgio.}
proc setDefaultAction*(notification: GNotification;
                                   detailedAction: cstring) {.
    importc: "g_notification_set_default_action", libgio.}
proc `defaultAction=`*(notification: GNotification;
                                   detailedAction: cstring) {.
    importc: "g_notification_set_default_action", libgio.}
proc setDefaultActionAndTarget*(notification: GNotification;
    action: cstring; targetFormat: cstring) {.varargs,
    importc: "g_notification_set_default_action_and_target", libgio.}
proc `defaultActionAndTarget=`*(notification: GNotification;
    action: cstring; targetFormat: cstring) {.varargs,
    importc: "g_notification_set_default_action_and_target", libgio.}
proc setDefaultActionAndTargetValue*(
    notification: GNotification; action: cstring; target: GVariant) {.
    importc: "g_notification_set_default_action_and_target_value", libgio.}
proc `defaultActionAndTargetValue=`*(
    notification: GNotification; action: cstring; target: GVariant) {.
    importc: "g_notification_set_default_action_and_target_value", libgio.}

template gTypeListModel*(): untyped =
  (listModelGetType())

proc listModelGetType*(): GType {.importc: "g_list_model_get_type", libgio.}
type
  GListModel* =  ptr GListModelObj
  GListModelPtr* = ptr GListModelObj
  GListModelObj* = object

template gIsListModel*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeListModel))

template gListModelGetIface*(obj: untyped): untyped =
  (gTypeInstanceGetInterface(obj, gTypeListModel, GListModelIface))

type
  GListModelInterface* =  ptr GListModelInterfaceObj
  GListModelInterfacePtr* = ptr GListModelInterfaceObj
  GListModelInterfaceObj*{.final.} = object of GTypeInterfaceObj
    getItemType*: proc (list: GListModel): GType {.cdecl.}
    getNItems*: proc (list: GListModel): cuint {.cdecl.}
    getItem*: proc (list: GListModel; position: cuint): Gpointer {.cdecl.}

proc getItemType*(list: GListModel): GType {.
    importc: "g_list_model_get_item_type", libgio.}

proc itemType*(list: GListModel): GType {.
    importc: "g_list_model_get_item_type", libgio.}
proc getNItems*(list: GListModel): cuint {.
    importc: "g_list_model_get_n_items", libgio.}
proc nItems*(list: GListModel): cuint {.
    importc: "g_list_model_get_n_items", libgio.}
proc getItem*(list: GListModel; position: cuint): Gpointer {.
    importc: "g_list_model_get_item", libgio.}
proc item*(list: GListModel; position: cuint): Gpointer {.
    importc: "g_list_model_get_item", libgio.}
proc getObject*(list: GListModel; position: cuint): GObject {.
    importc: "g_list_model_get_object", libgio.}
proc `object`*(list: GListModel; position: cuint): GObject {.
    importc: "g_list_model_get_object", libgio.}
proc itemsChanged*(list: GListModel; position: cuint; removed: cuint;
                            added: cuint) {.importc: "g_list_model_items_changed",
    libgio.}

template gTypeListStore*(): untyped =
  (listStoreGetType())

type
  GListStore* =  ptr GListStoreObj
  GListStorePtr* = ptr GListStoreObj
  GListStoreObj* = object

  GListStoreClass* =  ptr GListStoreClassObj
  GListStoreClassPtr* = ptr GListStoreClassObj
  GListStoreClassObj*{.final.} = object of GObjectClassObj

proc listStoreGetType*(): GType {.importc: "g_list_store_get_type", libgio.}
template gIsListStore*(o: untyped): untyped =
  (gTypeCheckInstanceType(o, gTypeListStore))

proc newListStore*(itemType: GType): GListStore {.importc: "g_list_store_new",
    libgio.}
proc insert*(store: GListStore; position: cuint; item: Gpointer) {.
    importc: "g_list_store_insert", libgio.}
proc insertSorted*(store: GListStore; item: Gpointer;
                            compareFunc: GCompareDataFunc; userData: Gpointer): cuint {.
    importc: "g_list_store_insert_sorted", libgio.}
proc sort*(store: GListStore; compareFunc: GCompareDataFunc;
                    userData: Gpointer) {.importc: "g_list_store_sort", libgio.}
proc append*(store: GListStore; item: Gpointer) {.
    importc: "g_list_store_append", libgio.}
proc remove*(store: GListStore; position: cuint) {.
    importc: "g_list_store_remove", libgio.}
proc removeAll*(store: GListStore) {.
    importc: "g_list_store_remove_all", libgio.}
proc splice*(store: GListStore; position: cuint; nRemovals: cuint;
                      additions: var Gpointer; nAdditions: cuint) {.
    importc: "g_list_store_splice", libgio.}

