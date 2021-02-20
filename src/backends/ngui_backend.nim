

type
  NguiBackEnd* = enum
    beNIL beGTK3


const backend* = beGTK3
var DEP_TRUE {.compileTime.} = false

from os import `/`, ParDir, dirExists
template withBackend(
    kind: NguiBackEnd,
    dModule: untyped,
    testDir, fixMsg: string) =

  when backend == kind:
    const d: string = currentSourcePath() / ParDir / "private" / testDir
    when not dirExists(d):
      {.fatal: d & " backend folder doesn't exist.\lFix: " & fixMsg.}
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


# -----------------------------------------------------------------------------
include ngui_backend_interface
# -----------------------------------------------------------------------------
# GTK3
withBackend(
  kind    = beGTK3,
  dModule = ngui_begtk3,
  testDir = "oldgtk3",
  fixMsg  = "git clone --depth 1 https://github.com/StefanSalewski/oldgtk3.git [NGUI_FOLDER]/src/backend/private/")
# -----------------------------------------------------------------------------

when not(DEP_TRUE): {.fatal: "Backend not implemented: " & $backend.}
