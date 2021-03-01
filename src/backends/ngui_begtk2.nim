
include private/ngui_common_gtk


#     v-- Set 'LAX_ERROR' to false to see fireworks
const LAX_ERROR = true
  
template bInfo(str: string) =
  echo("[NGUI_INFO] " & str & " NOT IMPLEMENTED")
template bError(str: string) =
  raiseAssert("[NGUI_ERROR] " & str & " NOT IMPLEMENTED")



# WIDGET ----------------------------------------
proc internalGetOpacity(this: NElement): float = 1.0
proc internalSetOpacity(this: NElement, v: float) = discard

proc toColor(p: Pixel): TColor =
  result.pixel = p.a
  result.red   = p.r
  result.green = p.g
  result.blue  = p.b

proc internalGetBGColor(this: NElement): Pixel =
  let c = this.data(gtkWidget).style.bg[STATE_NORMAL]
  result.r = uint8(c.red)
  result.g = uint8(c.green)
  result.b = uint8(c.blue)
  result.a = 255

proc internalSetBGColor(this: NElement, color: Pixel) =
  let
    c = toColor(color)
    w = this.data(gtkWidget)
  modify_bg(w, w.get_state, c.unsafeAddr)


# CONTAINER -------------------------------------
proc internalGetBorder(this: Container): NBorder =
  ## Get the border size of this container
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetBorder(this: Container): NBorder")
  else: bError("proc internalGetBorder(this: Container): NBorder")

proc internalSetBorder(this: Container, b: NBorder) =
  ## Set the border size of this container
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetBorder(this: Container, b: NBorder)")
  else: bError("proc internalSetBorder(this: Container, b: NBorder)")

proc internalGetBorderColor(this: Container): Pixel =
  ## Get the color of this container's border
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalGetBorderColor(this: Container): Pixel")
  else: bError("proc internalGetBorderColor(this: Container): Pixel")

proc internalSetBorderColor(this: Container, color: Pixel) =
  ## Set the color of this container's border
  # REMOVE BODY AND ADD YOUR OWN IMPLEMENTATION
  when LAX_ERROR: bInfo("proc internalSetBorderColor")
  else: bError("proc internalSetBorderColor")


# APP -------------------------------------------
proc internalRun(this: App) =
  for c in utilItems(this):
    c.data(gtkWindow).showAll()
  gtk2.main() # Blocking

proc internalStop(this: App) =
  utilStopRepeat()
  gtk2.mainQuit()


# BUBBLE ----------------------------------------
proc internalAttach(this: Bubble, that: NElement) =
  raiseAssert("GTK2 does not support Bubbles")


# BOX ------------------------------------------- 
proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int)  =
  discard # REMOVE internalAdd Box


# GRID ------------------------------------------
proc internalAdd(this: Grid, that: NElement, r, c, w, h: int)  =
  let
    thisD         = this.data(gtkGrid)
    (r, c, w, h)  = (guint(r), guint(c), guint(w), guint(h))

  var tR, tC: guint
  # https://developer.gnome.org/gtk2/2.24/GtkTable.html#gtk-table-get-size
  thisD.getSize(tR, tC)
  # https://developer.gnome.org/gtk2/2.24/GtkTable.html#gtk-table-resize
  if r + h > tR or c + w > tC: thisD.resize(max(tR, r + h), max(tC, c + w))
  # https://developer.gnome.org/gtk2/2.24/GtkTable.html#gtk-table-attach

  thisD.attachDefaults(that.data(gtkWidget), c, c + w, r, r + h)
  utilChild(this, that)


# CLIPBOARD -------------------------------------
proc getCB: PClipboard = clipboard_get(SELECTION_CLIPBOARD())
template C: PClipboard = getCB()

proc internalClipboardClear() = C.clear()

proc internalClipboardSet(text: string) = C.setText(text, len(text).gint)

proc internalClipboardSet(img: Bitmap) =
  C.setImage(cast[PPixBuf](img.data))

proc internalClipboardGetText: string =
  let txt = C.waitForText()
  if txt == nil: return
  result = $txt
  free(txt)

proc internalClipboardGetImg: Bitmap =
  let img = C.waitForImage()
  if img == nil: return
  result = newBitmap(cast[PPixBuf](img))
  gObjectUnref(img)

var
  idPool {.global.}: int = 0
  txtCB {.global.}: STable[int, NAsyncTextProc]
  imgCB {.global.}: STable[int, NAsyncBitmapProc]
  
proc onCPTxt(_: PClipboard, text: cstring, data: gpointer) {.cdecl, gcsafe.} =
  let id = cast[int](data)

  {.gcsafe.}:
    let cb = txtCB[id]
    del(txtCB, id)
    cb(if text == nil: "" else: $text)

proc onCPImg(_: PClipboard, img: PPixBuf, data: gpointer) {.cdecl, gcsafe.} =
  let id = cast[int](data)
  
  {.gcsafe.}:
    let cb = imgCB[id]
    del(imgCB, id)
    cb(if img == nil: nil else: newBitmap(img))

proc internalClipboardAsyncGet(action: NAsyncTextProc) =
  inc(idPool)
  txtCB[idPool] = action
  C.requestText(
    TClipboardTextReceivedFunc(onCPTxt), cast[gpointer](idPool))

proc internalClipboardAsyncGet(action: NAsyncBitmapProc) =
  inc(idPool)
  imgCB[idPool] = action
  C.requestImage(
    TClipboardImageReceivedFunc(onCPImg), cast[gpointer](idPool))