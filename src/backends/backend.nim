import std/[strutils, os]


type
  NguiBackEnd* = enum
    # Fake Backends
    beNIL
    beDOC # Used to generate docs
    # Real Backends
    beGTK3
    beNUKLEAR


proc parseBackend*(str: string): NguiBackEnd =
  result = parseEnum[NguiBackEnd](str, beNil)
  if result == beNil: result = parseEnum[NguiBackEnd]("be" & str, beNil)

proc getbackend*: NguiBackEnd =
  result = beNIL

  template set(be: NguiBackEnd) = (if result == beNIL: result = be)

  const nguibackend {.strdefine.} = ""

  set(parseBackend(nguibackend))
  set(parseBackend(getEnv("NGUI_BACKEND")))
  set(beGTK3)