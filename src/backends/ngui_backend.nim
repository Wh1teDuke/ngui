

type
  NguiBackEnd* = enum
    beNIL beGTK2 beGTK3


const backend* = static:
  var be = beGTK3

  const nguibackend {.strdefine.} = ""
    
  if nguibackend != "":
    be = parseEnum[NguiBackEnd](nguibackend, beNil)
    if be == beNil: be = parseEnum[NguiBackEnd]("be" & nguibackend, beNil)
    if be == beNil: raiseAssert("Backend not implemented: " & nguibackend)

  be

var DEP_TRUE {.compileTime.} = false

from os import `/`, ParDir, dirExists
template withBackend(
    kind: NguiBackEnd,
    dModule: untyped,
    testDir: string) =

  when backend == kind:
    const d: string = currentSourcePath() / ParDir / "private" / testDir
    when not dirExists(d):
      {.fatal: d & " backend folder doesn't exist.".}
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
  testDir = "oldgtk3")
# -----------------------------------------------------------------------------
# GTK2
withBackend(
  kind    = beGTK2,
  dModule = ngui_begtk2,
  testDir = "gtk2")
# -----------------------------------------------------------------------------

when not(DEP_TRUE): {.fatal: "Backend not implemented: " & $backend.}
