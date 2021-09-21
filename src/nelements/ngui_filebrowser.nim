when not declaredInScope(ngui_include_filebrowser):
  # Ugly hack to let the module be included in ngui_benuklear
  # Please understand ...
  import ../ngui

import ../utils/icons
import std/[os, strutils, algorithm]


type
  PathButton    = tuple
    path:       string
    button:     Button
    color:      Pixel
    
  BrowserAccept* = enum
    baFile baFolder

  # Pseudo NElement
  NFileBrowser* = ref object
    window:     ngui.Window
    path:       tuple[current, new: string]
    selected:   seq[string]
    buttons:    seq[PathButton]
    index:      int
    done:       bool
    mode:       NAmount
    accept:     set[BrowserAccept]


const selColor = Pixel(r: 120, g: 120, b: 120, a: 255)


proc nFileBrowser*(
    path:   string = getCurrentDir(),
    accept: set[BrowserAccept] = {baFile},
    mode:   NAmount = naMinOne,
    ): NFileBrowser =

  result = NFileBrowser(
    window:  window(),
    path:    (path, path),
    mode:    mode,
  )

proc update(this: NFileBrowser) # FD
proc listFiles(this: NFileBrowser) # FD

proc selected*(this: NFileBrowser): seq[string] =
  this.selected

proc done*(this: NFileBrowser): bool = this.done
  
proc path*(this: NFileBrowser): string = this.path.current

proc `text=`*(this: NFileBrowser, value: string) =
  this.window.text = value
  
proc text*(this: NFileBrowser): string =
  this.window.text

proc mode*(this: NFileBrowser): NAmount = this.mode
proc `mode=`*(this: NFileBrowser, mode: NAmount) = this.mode = mode
  
proc init(this: NFileBrowser) # FD
  
proc show*(this: NFileBrowser) =
  let w = this.window
  w.size = (500, 500)
  init(this)
  update(this)
  add(getApp(), w)

proc findEntry(this: NFileBrowser, path: string): ptr[PathButton] =
  for entry in mitems(this.buttons):
    if entry.path == path: return entry.addr
  
proc selectedList(this: NFileBrowser): seq[string] =
  let tableContent = this.window[NTable, 0, 1, 0]

  for row in tableContent.selectedRows:
    let txt = row.cells[1].vStr
    add(result,
      if txt == ParDir: txt else: this.path.current / txt)

proc index(this: NFileBrowser, button: Button): int =
  result = -1
  for i, (_, b, _) in this.buttons:
    if b == button: return i

proc setIndex(this: NFileBrowser, button: Button) =
  this.index = index(this, button)
  doAssert this.index != -1, "Button not found in stack"

proc update(this: NFileBrowser, entry: PathButton) =
  this.path.new = entry.path
  this.path.current = this.path.new
  this.buttons[this.index].button.bgColor = this.buttons[this.index].color
  setIndex(this, entry.button)
  entry.button.bgColor = selColor
  listFiles(this)

proc init(this: NFileBrowser) =
  let fb = this

  # Current Location Bar --------------
  let bLocation = hbox()

  # Current Location Content ----------
  let
    bContent     = vbox()
    tableContent = table([
      (ckImg, "Name"), (ckStr, ""), (ckStr, "Size")])
  
  bContent.scrolled = on
  tableContent.mode = this.mode

  onEvent(tableContent, neClick) do:
    let event = currentEvent()
    if event.double:
      let selected = selectedList(fb)
      if len(selected) > 0:
        let path = selected[0]

        if not dirExists(path):
          return # TODO: same effect as 'Accept'?
        
        if path == ParDir:
          update(fb, fb.buttons[fb.index - 1])
          return
        
        let entry = findEntry(fb, path)
        if entry != nil:
          update(fb, entry[])
          return
        
        fb.path.new = path
        update(fb)
  
  add(bContent, tableContent)
  
  # Buttons ---------------------------
  let
    bButtons = hbox()
    bCancel  = button("Cancel")
    bAccept  = button("Accept")
  
  template disposeThisWindow =
    fb.done = true
    destroy(fb.window)
  
  onEvent(bCancel, neClick) do:
    fb.selected = @[]
    disposeThisWindow()
  
  onEvent(bAccept, neClick) do:
    let list = selectedList(fb)
    if ParDir in list: return
    
    fb.selected = list

    disposeThisWindow()
    trigger(
      NEventArgs(element: fb.window, kind: neFILE_CHOOSE_ACCEPT, files: list))
    
  add(bButtons, bCancel, bAccept)
  
  # -----------------------------------
  let w = this.window
  add(w, bLocation, bContent, bButtons)
  
proc contentList(path: string): seq[(PathComponent, string)] =
  for kind, path in walkDir(path):
    add(result, (kind, path))

  sort(result, proc(a, b: (PathComponent, string)): int =
    result = -cmp(a[0].int, b[0].int)
    if result == 0: result = cmp(a[1], b[1])
  )

proc listFiles(this: NFileBrowser) =
  let
    bContent = this.window[Box, 0, 1]
    table    = NTable(bContent[0])

  removeAll(table)
  
  var contentList = contentList(this.path.current)  
  if not isRootDir(this.path.current):
    insert(contentList, (pcDir, ParDir))

  for (kind, path) in contentList:
    let icon =
      case kind:
      of pcFile: niFILE
      of pcLinkToFile: niFILE_LINK
      of pcDir: niFOLDER
      of pcLinkToDir: niFOLDER
      
    let
      info = getFileInfo(path)

      bmp  = iconBitmap(icon)
      name = lastPathPart(path)
      size =
        if path == ParDir: ""
        else: formatSize(info.size, includeSpace = true)

    #table.row(bmp, name, size)
    add(table, [toCell(bmp), toCell(name), toCell(size)])

proc update(this: NFileBrowser) =
  if this.buttons.len > 0 and this.path.current == this.path.new:
    return

  let
    fb        = this
    bLocation = this.window[Box, 0, 0]

  removeAll(bLocation)
  setLen(this.buttons,  0)
  setLen(this.selected, 0)
  
  this.path.current = this.path.new
  var path = ""

  for folder in split(this.path.new, DirSep):
    let button = button(if folder == "": $DirSep else: folder)

    if path == "" or path[^1] != DirSep:
      path &= $DirSep
    path &= folder

    onEvent(button, neClick) do:
      update(fb, fb.buttons[index(fb, Button(currentEvent().element))])

    add(bLocation, button)
    add(this.buttons, (path, button, button.bgColor))
  
  this.index = high(this.buttons)
  this.buttons[^1].button.bgColor = selColor
  listFiles(this)
