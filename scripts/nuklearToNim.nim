import std/[os, strutils, httpclient, times]


#[
Assumes:

#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_IO
#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_INCLUDE_VERTEX_BUFFER_OUTPUT
#define NK_INCLUDE_FONT_BAKING
#define NK_INCLUDE_DEFAULT_FONT
#define NK_KEYSTATE_BASED_INPUT
#define NK_IMPLEMENTATION
]#



proc main =
  # -----------------------------------
  let c2nim = findExe("c2nim")
  doAssert c2nim != "", "c2nim not found"
  
  # -----------------------------------
  echo "- Download nuklear.h"
  
  let
    client = newHttpClient()  
    nuklearH = getContent(
      client,
      "https://raw.githubusercontent.com/Immediate-Mode-UI/Nuklear/master/src/nuklear.h") 
    
  writeFile("nuklear.h", nuklearH)
    
  # -----------------------------------
  echo "- Preprocess nuklear.h"
  
  var headerStr = readFile("nuklear.h")
  
  proc del(a, b: string, bIncluded: bool = false) =
    let
      aLen = len(a)
      bLen = len(b)

    while true:
      let a = find(headerStr, a)
      if a == -1: break
      
      let b = find(headerStr, b, a + aLen)
      if b == -1: break

      delete(headerStr, a, (b - 1) + [0, bLen][int(bIncluded)])
    
  proc del(a: string) =
    headerStr = replace(headerStr, a)
    
  proc repl(a, b: string) =
    headerStr = replace(headerStr, a, b)
    
  proc remBlock(str: string) =
    let aLen = len(str)
    var a = 0
    while true:
      a = find(headerStr, str, a)
      if a == -1: break
      
      var
        b = -1
        feol = -1
        eol = false

      for i in find(headerStr, ":", a) .. high(headerStr):
        if eol and headerStr[i] notin {' ', '\l'}:
          b = i
          break
        
        eol = headerStr[i] == '\l'
        if eol and feol == -1: feol = i
      
      doAssert b != -1
      var str = headerStr[feol .. b]
      delete(headerStr, a, b)
      str = replace(str, "\l  ", "\l")
      insert(headerStr, str, a)

  del("#ifndef NK_API", "#ifdef NK_INCLUDE_FIXED_TYPES")
  del("#else\l  #ifndef NK_INT8", "\l#endif")
  del("#ifdef NK_INCLUDE_STANDARD_VARARGS", "\l#endif", true)
  del("#define NK_CONFIGURATION_STACK_TYPE(prefix, name, type)\\", "#define nk_float float")
  del("#ifndef NK_BOOL", "\l#endif", true)
  del("/*", "*/", true)
  del("#ifndef NK_STRTOD", "#endif", true)
  del("#ifdef NK_INCLUDE_COMMAND_USERDATA", "#endif", true)
  del("#ifdef NK_UINT_DRAW_INDEX", "#endif", true)
      
  del("NK_CONFIGURATION_STACK_TYPE", "\l")
  del("NK_CONFIG_STACK", "\l")

  del("NK_API")
  del("#define NK_VERTEX_LAYOUT_END NK_VERTEX_ATTRIBUTE_COUNT,NK_FORMAT_COUNT,0")
  del("#define nk_foreach(c, ctx) for((c) = nk__begin(ctx); (c) != 0; (c) = nk__next(ctx,c))")
  del("#define nk_draw_foreach(cmd,ctx, b) for((cmd)=nk__draw_begin(ctx, b); (cmd)!=0; (cmd)=nk__draw_next(cmd, b, ctx))")
  del("#define nk_draw_list_foreach(cmd, can, b) for((cmd)=nk__draw_list_begin(can, b); (cmd)!=0; (cmd)=nk__draw_list_next(cmd, b, can))")
  
  # Tiny edge case
  repl(
    "#ifdef NK_INCLUDE_VERTEX_BUFFER_OUTPUT\l    struct nk_draw_list draw_list;\l#endif",
     "    struct nk_draw_list draw_list;")

  var header = splitLines(headerStr)
  
  writeFile("n.h", join(header, "\l"))
  
  # -----------------------------------
  let cmd = "c2nim --skipcomments --debug --cdecl --importc n.h"
  echo "- ", cmd
  
  if execShellCmd(cmd) != 0: return

  # -----------------------------------
  echo "- Postprocess nuklear.nim"
  
  headerStr = readFile("n.nim")
  add(headerStr, "\ltype\l  nk_draw_index* = nk_ushort\l")
  
  del("when defined(NK_INCLUDE_FIXED_TYPES):", "type")
  repl("NK_INT8", "int8")
  repl("NK_UINT8", "uint8")
  repl("NK_INT16", "int16")
  repl("NK_UINT16", "uint16")
  repl("NK_INT32", "int32")
  repl("NK_UINT32", "uint32")
  repl("NK_SIZE_TYPE", "uint")
  repl("NK_POINTER_TYPE", "uint")
  repl("NK_BOOL", "cint")
  repl("NK_STATIC_ASSERT", "static: doAssert")
  repl("* = enum", "* {.size: sizeOf(cint).} = enum")
  repl("NK_MAX", "max")
  del("when defined(NK_INCLUDE_STANDARD_BOOL):", "else:\l  ", true)
  del("discard", "\l")
  del("var ")

  remBlock("when not defined")
  remBlock("when defined")
  
  # Gen nk_config_stack_*/_element
  add(headerStr, "\ltype\l")
  
  for i in [
      "style_item", "float", "vec2", "flags", "color",
      "user_font", "button_behavior"]:

    add(headerStr, """
  nk_config_stack_$1_element*  {.bycopy.} = object
    address*: ptr $2
    old_value*: $2
""" % [i, (if i != "float": "nk_" else: "c") & i])

    add(headerStr, """
  nk_config_stack_$1*  {.bycopy.} = object
    head*: cint
    elements*: array[16, nk_config_stack_$1_element]
""" % [i])
  
  # Parse nim
  header = splitLines(headerStr) 
  
  var
    typeList: seq[string]
    procList: seq[string]
    constList: seq[string]
    assertList: seq[string]
  
  type Scanning = enum sNone sType sConst sProc
  
  var scanning = sNone
    
  for i, line in header:
    if isEmptyOrWhitespace(line): continue

    if startsWith(line, "template"):
      scanning = sNone
      continue
    
    if startsWith(line, "static"):
      add(assertList, line)
      scanning = sNone
      continue

    if startsWith(line, "type"):
      scanning = sType
      continue
  
    if startsWith(line, "const"):
      scanning = sConst
      continue
    
    if startsWith(line, "proc"):
      scanning = sProc

    case scanning:
    of sType:
      if startsWith(line, "    "):
        add(typeList[^1], "\l" & line)
      elif startsWith(line, "  "):
        add(typeList, unindent(line))
      else:
        echo "DEBUG ", (i + 1, line)
        
    of sProc:
      if startsWith(line, "proc"):
        add(procList, line)
      else:
        add(procList[^1], unindent(line))
      
    of sConst:
      var discardConstList {.global.} = @[
        "NK_FORMAT_COLOR_END*", "NK_FORMAT_R8G8B8*", "NK_WINDOW_DYNAMIC*",
        "nk_float*", "NK_UTF_INVALID*",
      ]
      
      var skip = false
      for i, d in discardConstList:
        if d in line:
          skip = true
          del(discardConstList, i)
          break
        
      if skip: continue
      
      if "nk_window" in line and "NK_VALUE_PAGE_CAPACITY" in constList[^1]:
        add(constList[^1], unindent(line))
        # Added by hand
        delete(constList, high(constList))
      else:
        add(constList, unindent(line))
      
    of sNone:
      discard
  
  #writeFile("n.nim", join(header, "\l"))
  
  var nimWrapper = multiReplace("""
# Nim Nuklear wrapper autogenerated ($1)

from strutils import `%`
from os import parentDir
  
{.passL:"-lm".}
{.emit:???
#define NK_INCLUDE_FIXED_TYPES
#define NK_INCLUDE_STANDARD_IO
#define NK_INCLUDE_DEFAULT_ALLOCATOR
#define NK_INCLUDE_VERTEX_BUFFER_OUTPUT
#define NK_INCLUDE_FONT_BAKING
#define NK_INCLUDE_DEFAULT_FONT
#define NK_KEYSTATE_BASED_INPUT
#define NK_IMPLEMENTATION
#include "!/nuklear.h"
??? % [currentSourcePath.parentDir()] .}
""" % [getDateStr()], [("?", "\""), ("!", "$1")])
  
  # Consts
  add(nimWrapper, "\l\l\l# CONST ---------\l")
  add(nimWrapper, "const\l")
  template addNWLine(c: string) =
    add(nimWrapper, c)
    add(nimWrapper, "\l")
  
  for c in constList:
    add(nimWrapper, "  ")
    addNWLine(c)
  
  add(nimWrapper, """

template NK_FLAG(x: untyped): uint32 = 1 shl uint32(x)

template NK_VALUE_PAGE_CAPACITY*: uint32 = (
  ((max(sizeof(nk_window), sizeof(nk_panel)) div sizeof((nk_uint)))) div 2)

template `or`(a, b: enum): int = a.int or b.int
template `or`(a: int, b: enum): int = a or b.int

""")
    
  # Types
  add(nimWrapper, "\l\l\l# TYPES ---------\l")
  add(nimWrapper, "type\l")
  
  var addAsConst: seq[string]
  
  for t in mitems typeList:    
    if "enum" in t:
      t = replace(t, "\l")
      t = replace(t, "enum", "enum\l")
      t = replace(t, ", ", "\l    ")
      t = replace(t, ",")
      
      if " or " in t:
        let lines = splitLines(t)
        var res = ""
        
        let oLen = len(addAsConst)
        for li in lines:
          if "or" in li: add(addAsConst, li)
          else: add(res, li & "\l")

        if len(addAsConst) - oLen == len(lines) - 1:
          continue

        t = res
      
    add(nimWrapper, "  ")
    addNWLine(t)
    if "\l" in t: add(nimWrapper, "\l")
      
    
  # Procs
  add(nimWrapper, "\l\l\l# PROCS ---------\l")
  for p in mitems procList:
    if "__" in p:
      if "proc nk__draw_begin" in p:
        p = replace(p, "proc nk__draw_begin", "proc nk_draw_begin")

      elif "proc nk__draw_next" in p:
        p = replace(p, "proc nk__draw_next", "proc nk_draw_next")
      
      else:
        continue

    if "proc nk_color_f*" in p: continue
    if "proc nk_vec2*" in p: continue
    if "proc nk_vec2i*" in p: continue
    if "proc nk_rect*" in p: continue
    if "proc nk_recti*" in p: continue
    
    if "proc nk_image*" in p:
      p = replace(p, "nk_image*", "nk_image_show*")
    elif "proc nk_font_config*" in p:
      p = replace(p, "nk_font_config*", "nk_font_config_ph*")

    addNWLine(p)
  
  # More consts
  add(nimWrapper, "\l\l\l")
  add(nimWrapper, "const\l")
  for c in mitems addAsConst:
    c = replace(c, " =", "* =")
    add(nimWrapper, "  " & unindent(c) & "\l")
    
  # Asserts
  add(nimWrapper, "\l\l\l")
  for a in assertList:
    addNWLine(a)

  # Custom
  add(nimWrapper, """

const  
  NK_VERTEX_LAYOUT_END* = nk_draw_vertex_layout_element(
    attribute: NK_VERTEX_ATTRIBUTE_COUNT,
    format:    NK_FORMAT_COUNT,
    offset:    0)

iterator nk_draw_foreach*(
    ctx: ptr[nk_context], b: ptr[nk_buffer]): ptr[nk_draw_command] =
  var cmd = nk_draw_begin(ctx, b)
  while cmd != nil:
    yield cmd
    cmd = nk_draw_next(cmd, b, ctx)

""")
    
  writeFile("nuklear.nim", nimWrapper)

  # -----------------------------------
  echo "- Download nuklear.h (full)"

  let nuklear = getContent(
    client,
    "https://raw.githubusercontent.com/Immediate-Mode-UI/Nuklear/master/nuklear.h")
  
  writeFile("nuklear.h", nuklear)
  
  # Remove temp files
  removeFile("n.h")
  removeFile("n.nim")

when isMainModule:
  main()
