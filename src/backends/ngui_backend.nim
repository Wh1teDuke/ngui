

type
  NguiBackEnd* = enum
    beNIL beGTK2 beGTK3
    beDOC # Used to generate docs


const backend* = static:
  var be = beGTK3

  const nguibackend {.strdefine.} = ""
    
  if nguibackend != "":
    be = parseEnum[NguiBackEnd](nguibackend, beNil)
    if be == beNil: be = parseEnum[NguiBackEnd]("be" & nguibackend, beNil)
    if be == beNil: raiseAssert("Backend not implemented: " & nguibackend)

  be

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


# -----------------------------------------------------------------------------
include ngui_backend_interface
# -----------------------------------------------------------------------------
# GTK3
withBackend(kind = beGTK3, dModule = ngui_begtk3)
# -----------------------------------------------------------------------------
# GTK2
withBackend(kind = beGTK2, dModule = ngui_begtk2)
# -----------------------------------------------------------------------------
# DOCS
withBackend(kind = beDOC, dModule = ../../ngui_backend_interface)
# -----------------------------------------------------------------------------

when not(DEP_TRUE): {.fatal: "Backend not implemented: " & $backend.}
