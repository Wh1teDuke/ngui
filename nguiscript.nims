import std/[strutils, sequtils, os]



cd(thisDir())

template info(str: varargs[untyped]) = echo "[INFO] ", str
template error(str: varargs[untyped]) = echo "[ERROR] ", str

proc replace(str: string, args: openArray[(string, string)]): string =
  result = str
  for a, b in items(args): result = replace(result, a, b)

let
  # https://nim-lang.github.io/Nim/nimc.html#compiler-usage-configuration-files
  cfgDir  = getConfigDir() / "nim"
  cfgFile = cfgDir / "nim.cfg"
  beTempl = "ngui_backend_template.nim"

task newBackend, "Gen Backend Interface Template":
  var str = """
#import private/backendfolder/[a,b,c]
#includeUtils ELEMENT, CONTAINER, EVENT, TIMER, ADAPTER
#     v-- Set 'LAX_ERROR' to false to see fireworks
const LAX_ERROR = true
  
template bInfo(str: string) =
  echo("[NGUI_INFO] " & str & " NOT IMPLEMENTED")
template bError(str: string) =
  raiseAssert("[NGUI_ERROR] " & str & " NOT IMPLEMENTED")
"""

  var procDef = ""
  
  proc addBody() =
    if procDef == "": return
    add(str, "  when LAX_ERROR: bInfo(\"" & procDef & "\")\l")
    add(str, "  else: bError(\"" & procDef & "\")\l\l")
    procDef = ""
  
  for line in splitLines(
      readFile($CurDir / "src" / "backends" / "ngui_backend_interface.nim")):
    if startsWith(line, "#"):
      addBody()
      add(str, "\l" & line & "\l")
      continue

    if startsWith(line, "  ##"):
      add(str, line & "\l")
      addBody()
      continue

    if startsWith(line, "proc") or startsWith(line, "#"):
      addBody()
      add(str, line & " =\l")
      procDef = line
      continue
    
  addBody()  
  writeFile(beTempl, str)
  
proc addToUserCfg(line: string): bool =
  if not fileExists(cfgFile):
    info cfgFile, " doesn't exist, creating a new one"
    mkDir(cfgDir)
    writeFile(cfgFile, "## USER CONFIG FILE GENERATED BY NGUISCRIPT\l\l")

  var lines = splitLines(readFile(cfgFile))

  if any(lines, proc(x: string): bool = line in x):
    return false

  while lines.len > 0 and lines[^1] == "": discard lines.pop
  lines.add(line & " # <-- Added by nguiscript")

  writeFile(cfgFile, join(lines, "\l") & "\l")
  return true

type RFUCResult = enum rFileNotFound rLineNotFound rLineRemoved

proc remFromUserCfg(line: string): RFUCResult =
  if not fileExists(cfgFile):
    return rFileNotFound
  
  var lines = splitLines(readFile(cfgFile))

  if not any(lines, proc(x: string): bool = line in x):
    return rLineNotFound

  lines = filter(lines, proc(x: string): bool = line notin x)
  while lines.len > 0 and lines[^1] == "": discard lines.pop

  writeFile(cfgFile, join(lines, "\l") & "\l")
  return rLineRemoved

task addPath, "Add ngui to your user config file":
  info "Installing in ", cfgFile
  
  info(
    if not addToUserCfg("path: \"" & thisDir() & "\""):
      "ngui seems to be already installed"
    else:
      "ngui installed"
  )

task remPath, "Remove ngui from your user config file":
  info "Uninstalling ngui from ", cfgFile
  
  info(
    case remFromUserCfg("ngui"):
    of rLineRemoved:  "ngui uninstalled"
    of rLineNotFound: "ngui wasn't installed"
    of rFileNotFound: "File doesn't exist"
  )


task defaultBackend, "Set default backend":
  var be = paramStr(paramCount()) # paramCount() - 1 is this a bug?
  # TODO: Get backend enum from a separate module
  info "Setting default backend: ", be
  discard remFromUserCfg("define:nguibackend=")
  if startsWith(be, "be"): discard addToUserCfg("define:nguibackend=" & be)

task examples, "Compile and execute all the examples in order":
  try:
    for i in 1 .. 30:
      let file = $CurDir / "examples" / ("e" & $i & ".nim")
      if not fileExists(file): continue
      
      for _ in 0 .. 30: echo("") # Clear screen
      echo readFile(file)
      info("Compiling ", file)
      info("Interrupt with ctrl + c")

      try:
        exec("nim r -d:release --hints:off --warnings:off " & file)
      except:
        if i != 1: raiseAssert("")

  except:
    discard # C'est fini

task docs, "Gen documentation":
  const
    DF = $CurDir / "docs" / "html"
    arg = "--warnings:off --hints:off --outdir:"

  proc nDoc(a: string) = exec("nim doc $1 $2 $3" % [arg, DF, a])
  proc nRSTDoc(a: string) = exec("nim rst2html $1 $2 $3" % [arg, DF, a])
  

  # Code Documentation ----------------
  rmDir(DF)
  mkDir(DF)

  # > Project
  
  # Hack to document backend
  let
    intSrcFile   = $CurDir / "src" / "backends" / "ngui_backend_interface.nim"
    intFile      = $CurDir / "ngui_backend_interface.nim"
    intHead      = $CurDir / "fakeimpl.nim"
    intFileHTML  = replace(intFile, "nim", "html")

  cpFile(intSrcFile, intFile)
  var html = splitLines(readFile(intFile))
  for line in mitems html:
    if not startsWith(line, "proc"): continue
    let (a, b) = (if '(' in line: ("(", "*(") else: (":", "*:"))
    line = replace(line, a, b) & " = discard"
    
  var head = readFile("src" / "ngui.nim")
  setLen(head, find(head, "include"))

  writeFile(intHead, head)
  writeFile(intFile, "import fakeimpl,times\l" & html.join("\l"))

  nDoc(intFile)

  rmFile(intFile)
  rmFile(intHead)

  writeFile(DF / intFileHTML, replace(readFile(DF / intFileHTML),
    [("fakeimpl", "ngui"), ("Imports", "Included by")]))
  
  # Main module
  nDoc($CurDir / "src" / "ngui.nim")

  # Tutorial --------------------------
  nRSTDoc(DF / ParDir / "learn.rst")
  
  # Architecture ----------------------
  nRSTDoc(DF / ParDir / "architecture.rst")
  writeFile($CurDir / "docs" / "html" / "architecture.html",
    replace(readFile($CurDir / "docs" / "html" / "architecture.html"),
      "./assets", "../assets")
  )
  
  # Fix man's mistakes ----------------
  let nlogo = "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"
  var css = splitLines(replace(readFile(DF / "nimdoc.out.css"),
    [("51px", "100px"), ("14px", "100px"),]))

  for line in mitems css:
    const S = """  --nim-sprite-base64: url("data:image/png;base64,"""
    if not startsWith(line, S): continue
    line = line[0 ..< S.len] & nlogo & "\");"

  writeFile(DF / "nimdoc.out.css", css.join("\l"))
