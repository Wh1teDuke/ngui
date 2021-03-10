
include private/ngui_common_gtk


# WIDGET ----------------------------------------
proc internalGetBGColor(this: NElement): Pixel =
  # https://developer.gnome.org/gtk3/stable/chap-css-properties.html
  # "Table 10. Background properties"
  invokeSatanGet(this, "background-color", result)
  
proc internalSetBGColor(this: NElement, color: Pixel) =
  let (r, g, b, a) = color
  discard invokeSatanSet(this,
    "*{background-color:rgba($1,$2,$3,$4);}", r, g, b, a)


# CONTAINER -------------------------------------
proc internalGetBorder(this: Container): int =
  # https://developer.gnome.org/gtk3/stable/chap-css-properties.html
  invokeSatanGet(this, "border-top-width", result) # Doesn't work

proc internalSetBorder(this: Container, b: int) =
  discard invokeSatanSet(this, "*{border-width:$1px;}", b)

proc internalGetBorderColor(this: Container): Pixel =
  invokeSatanGet(this, "border-color", result)

proc internalSetBorderColor(this: Container, color: Pixel) =
  let (r, g, b, a) = color
  discard invokeSatanSet(
    this, "*{border-color:rgba($1,$2,$3,$4);}", r, g, b, a)


# APP -------------------------------------------
proc internalRun(this: App) =
  for c in utilItems(this):
    c.data(gtkWindow).showAll()
  gtk.main() # Blocking

proc internalStop(this: App) =
  utilStopRepeat()
  gtk.mainQuit()


# WINDOW ----------------------------------------
proc internalGetOpacity(this: Window): float =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-opacity
  float(this.data(gtkWindow).getOpacity())
  
proc internalSetOpacity(this: Window, v: float) =
  let w = this.data(gtkWindow)
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-opacity
  w.setOpacity(v.cdouble)

  # Transparent window
  # https://stackoverflow.com/a/3909283
  proc onScreenChanged(this: gtkWindow, _: (GPointer, GPointer)) {.cdecl.} =
    this.setVisual(this.getScreen().getRGBAVisual())

  proc onDraw(t: gtkWindow, c: cairo.Context, _: GPointer): GBoolean {.cdecl.} =
    c.setSourceRGBA(0.0, 1.0, 0.0, 0.5)
    c.setOPerator(SOURCE)
    c.paint()
    return false
  
  discard signal(w, "screen-changed", gCALLBACK(onScreenChanged), nil)
  discard signal(w, "draw", gCALLBACK(onDraw), nil)
  w.setAppPaintable(true)
  w.onScreenChanged((nil, nil))
  # Doesn't work on my computer, why?


# BUBBLE ----------------------------------------
proc internalAttach(this: Bubble, that: NElement) =
  let thisD = this.data(gtkPopover)
  thisD.setRelativeTo(that.data(gtkWidget))
  thisD.setConstrainTo(PopoverConstraint.NONE)
  thisD.show()


# GRID ------------------------------------------  
proc internalAdd(this: Grid, that: NElement, r, c, w, h: int) =
  doAssert that.internalGetParent == nil

  utilChild(this, that)
  this.data(gtkGrid).attach(
    that.data(gtkWidget), c.cint, r.cint, w.cint, h.cint)


# CLIPBOARD -------------------------------------  
template asyncCB(req, dType, cbType, get) {.dirty.} =
  var
    idPool {.global.}: int = 0
    callbacks {.global.}: STable[int, typeOf(action)]

  proc callback(
      _: Clipboard, data: dType, id: GPointer) {.cdecl.} =
    let
      id = cast[int](id)
      cb = callbacks[id]
    del(callbacks, id)
    cb(get)

  inc(idPool)
  callbacks[idPool] = action
  C.req(cbType(callback), cast[GPointer](idPool))

proc internalClipboardAsyncGet(action: NAsyncTextProc) =
  asyncCB(requestText, cstring, ClipboardTextReceivedFunc,
    (if data == nil: "" else: $data))

proc internalClipboardAsyncGet(action: NAsyncBitmapProc) =
  asyncCB(requestImage, GdkPixBuf, ClipboardImageReceivedFunc,
    (if data == nil: nil else: newBitmap(cast[GdkPixBuf](data))))



# I was a flower of the mountain yes when I put the rose in my hair like
# the Andalusian girls used or shall I wear a red yes and how he kissed me
# under the Moorish wall and I thought well as well him as another and then
# I asked him with my eyes to ask again yes and then he asked me would
# I yes to say yes my mountain flower and first I put my arms around him yes
# and drew him down to me so he could feel my breasts all perfume yes and his
# heart was going like mad and yes I said yes I will Yes.
