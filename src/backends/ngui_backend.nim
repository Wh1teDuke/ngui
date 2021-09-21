

type
  NguiBackEnd* = enum
    beNIL beDOC # Used to generate docs
    beGTK3
    beNUKLEAR


const backend* = static:
  proc parseBackend(str: string): NguiBackEnd =
    result = parseEnum[NguiBackEnd](str, beNil)
    if result == beNil: result = parseEnum[NguiBackEnd]("be" & str, beNil)
    if result == beNil: raiseAssert("Backend not implemented: " & str)
  
  var be = beGTK3

  const nguibackend {.strdefine.} = ""
  let envBackend = getEnv("NGUI_BACKEND")
    
  if envBackend != "":
    be = parseBackend(envBackend)

  if nguibackend != "":
    be = parseBackend(nguibackend)  

  be

{.hint: "Using backend " & $backend.}
var DEP_TRUE {.compileTime.} = false

template withBackend(kind: NguiBackEnd, dModule: untyped) =
  when backend == kind:
    include dModule
    static: DEP_TRUE = on
    
import macros
macro includeUtils(args: varargs[untyped]): untyped =
  result = newStmtList()
  
  for arg in args:
    let i = ident("NGUI_DEF_UTIL_" & $arg)
    result.add quote do: {.define: `i`.}
  
  result.add quote do:
    include ngui_backend_util
    
macro notSupported(this: untyped): untyped =
  let sign = repr(this)
  this[^1] = quote do:
    raiseAssert("Not Supported: (" & $backend & ", " & `sign` & ")")
  return this

template ifElement(this: NElement, that: typedesc[NElement], op: untyped) =
  if this of that:
    let `this` {.inject.} = that(this)
    op


# -----------------------------------------------------------------------------
include ngui_backend_interface
include ngui_api
# -----------------------------------------------------------------------------
# GTK3
withBackend(kind = beGTK3, dModule = ngui_begtk3)
# -----------------------------------------------------------------------------
# NUKLEAR
withBackend(kind = beNUKLEAR, dModule = ngui_benuklear)
# -----------------------------------------------------------------------------
# DOCS
withBackend(kind = beDOC, dModule = ../../ngui_backend_interface)
# -----------------------------------------------------------------------------

when not(DEP_TRUE): {.fatal: "Backend not implemented: " & $backend.}