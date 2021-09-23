include private/ngui_common_gtk


# WIDGET ----------------------------------------
proc internalGetBGColor(this: NElement): Pixel =
  # https://developer.gnome.org/gtk3/stable/chap-css-properties.html
  # "Table 10. Background properties"
  invokeSatanGet(this, "background-color", result)
  
proc internalSetBGColor(this: NElement, color: Pixel) =
  doAssert this.raw != nil

  let (r, g, b, a) = (color.r, color.g, color.b, color.a)
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
  let (r, g, b, a) = (color.r, color.g, color.b, color.a)
  discard invokeSatanSet(
    this, "*{border-color:rgba($1,$2,$3,$4);}", r, g, b, a)


# APP -------------------------------------------
proc internalRun(this: App) =
  for c in utilItems(this):
    showAll(c.data(gtkWidget))
  gtkMain() # Blocking

proc internalStop(this: App) =
  utilStopRepeat()
  gtkMainQuit()


# WINDOW ----------------------------------------
proc internalGetOpacity(this: Window): float =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-opacity
  float(getOpacity(this.data(gtkWidget)))
  
proc internalSetOpacity(this: Window, v: float) =
  let w = this.data(gtkWindow)
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-opacity
  setOpacity(gtkWidget(w), v.cdouble)

  # Transparent window
  # https://stackoverflow.com/a/3909283
  proc onScreenChanged(this: gtkWindow, _: (GPointer, GPointer)) {.cdecl.} =
    setVisual(gtkWidget(this), getRGBAVisual(getScreen(gtkWidget(this))))

  proc onDraw(t: gtkWindow, c: cairoContext, _: GPointer): GBoolean {.cdecl.} =
    setSourceRGBA(c, 0.0, 1.0, 0.0, 0.5)
    setOperator(c, SOURCE)
    paint(c)
    return GBoolean(false)
  
  discard signal(GPointer(w), "screen-changed", gCALLBACK(onScreenChanged), nil)
  discard signal(GPointer(w), "draw", gCALLBACK(onDraw), nil)
  setAppPaintable(gtkWidget(w), GBoolean(true))
  onScreenChanged(w, (nil, nil))
  # TODO: Test


# BUBBLE ----------------------------------------
proc internalAttach(this: Bubble, that: NElement) =
  let thisD = this.data(gtkPopover)
  setRelativeTo(thisD, that.data(gtkWidget))
  setConstrainTo(thisD, PopoverConstraint.NONE)
  show(gtkWidget(thisD))


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
    (if pointer(data) == nil: nil else: newBitmap(GdkPixBuf(data))))
