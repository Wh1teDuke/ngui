import ../backend as be


const backend* = getBackend()

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
include ngui_api
include ngui_backend_interface
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