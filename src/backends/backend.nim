import system/platforms
import std/[strutils, os, dynlib]
when not defined(nimscript): import osproc


type
  NguiBackEnd* = enum
    # Fake Backends
    beNIL
    beDOC # Used to generate docs
    # Real Backends
    beGTK3
    beNUKLEAR
    

iterator backendItems*: NguiBackEnd =
  for be in beGTK3 .. high(NguiBackEnd): yield be

proc parseBackend*(str: string, optional: NguiBackEnd = beNil): NguiBackEnd =
  result = parseEnum[NguiBackEnd](str, beNil)
  if result == beNil: result = parseEnum[NguiBackEnd]("be" & str, beNil)
  if result == beNil: result = optional

proc getbackend*: NguiBackEnd =
  result = beNIL

  template set(be: NguiBackEnd) = (if result == beNIL: result = be)

  const nguibackend {.strdefine.} = ""

  set(parseBackend(nguibackend))
  set(parseBackend(getEnv("NGUI_BACKEND")))
  set(beGTK3)

proc testDependencies*(
    backend: NguiBackEnd,
    os:      OsPlatform = targetOS,
    ):       seq[tuple[dep: string, found: bool]] =

  proc get(cmd: string): string =
    when defined(nimscript): gorge(cmd) else: execProcess(cmd)

  proc linuxInstalledSOList: string =
    get("""sh -c '/sbin/ldconfig -N -v'""")
    
  var candidates: seq[string]

  case os:
  of linux:
    # https://unix.stackexchange.com/a/282207
    let installedSOList = linuxInstalledSOList()
    
    proc find(lib: string): bool =
      setLen(candidates, 0)
      libCandidates(lib, candidates)
      for c in candidates:
        if c in installedSOList:
          return true
        
    template test(lib: string) = add(result, (lib, find(lib)))

    case backend:
    of beGTK3:
      # See gtk3_min
      test("libgtk-3.so(|.0)")
      test("libgobject-2.0.so(|.0)")
      test("libglib-2.0.so(|.0)")
      test("libgdk_pixbuf-2.0.so")
      test("libgdk-3.so(|.0)")
      test("libcairo.so(|.2)")

    of beNUKLEAR:
      if not defined(glfwStaticLib):
        test("libglfw.so.3")
      
      discard
    else: discard
    
  else:
    discard