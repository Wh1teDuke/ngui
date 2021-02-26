
include private/ngui_common_gtk



# BASE ------------------------------------------
template gtkYouAreKillingMe() {.dirty.} =
  val =
    when val is bool:   bool(addr(v).getBoolean())
    elif val is int:    int(addr(v).getInt())
    elif val is string: $(addr(v).getString())
    elif val is Pixel:
      var c: RGBA
      # https://stackoverflow.com/a/47373201
      context.get(thisD.getStateFlags(), prop, c.addr, nil)
      let p = pixel(c.red, c.green, c.blue, c.alpha)
      rgbaFree(c)
      p
      
    else: discard
  unset(v.addr)

proc invokeSatanSet(
    this: NElement, css: string, args: varargs[string, `$`]): bool =
  let
    # The evil that men do lives on and on
    # https://developer.gnome.org/gtk3/stable/chap-css-properties.html
    # https://developer.gnome.org/gtk3/stable/GtkStyleContext.html
    context  = this.data(gtk.Widget).getStyleContext()
    provider = newCssProvider()
    css      = css % args

  var error: GError
  result = provider.loadFromData(css, css.len, error)
  context.addProvider(
    cast[StyleProvider](provider), STYLE_PROVIDER_PRIORITY_USER)

proc invokeSatanGet[T](this: NElement, prop: string, val: var T) =
  let
    thisD    = this.data(gtk.Widget)
    context  = thisD.getStyleContext()

  when val is Pixel:
    var c: RGBA
    # https://stackoverflow.com/a/47373201
    context.get(thisD.getStateFlags(), prop, c.addr, nil)
    val = pixel(c.red, c.green, c.blue, c.alpha)
    rgbaFree(c)
    
  else:
    var v: GValueObj
    context.getProperty(prop, thisD.getStateFlags(), v.addr)
    gtkYouAreKillingMe()


# EVENTS ----------------------------------------
# included


# WIDGET ----------------------------------------
proc internalGetOpacity(this: NElement): float =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-opacity
  float(this.data(gtk.Widget).getOpacity())
  
proc internalSetOpacity(this: NElement, v: float) =
  let w = this.data(gtk.Widget)
  
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-opacity
  w.setOpacity(v.cdouble)
  if not (this of Window): return

  # Transparent window
  # https://stackoverflow.com/a/3909283
  proc onScreenChanged(this: gtk.Widget, _: (GPointer, GPointer)) {.cdecl.} =
    this.setVisual(this.getScreen().getRGBAVisual())

  proc onDraw(t: gtk.Widget, c: cairo.Context, _: GPointer): GBoolean {.cdecl.} =
    c.setSourceRGBA(0.0, 1.0, 0.0, 0.5)
    c.setOPerator(SOURCE)
    c.paint()
    return false
  
  discard gSignalConnect(w, "screen-changed", gCALLBACK(onScreenChanged), nil)
  discard gSignalConnect(w, "draw", gCALLBACK(onDraw), nil)
  w.setAppPaintable(true)
  w.onScreenChanged((nil, nil))
  # Doesn't work on my computer, why?

proc internalSetVisible(this: NElement, state: bool) =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-visible
  this.data(Widget).setVisible(state)
  
proc internalGetVisible(this: NElement): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-visible
  if this of App: return
  return bool(this.data(Widget).getVisible())

proc internalGetNext(this: NElement): NElement = utilNext(this)

proc internalGetPrev(this: NElement): NElement = utilPrev(this)

proc internalGetFocus(this: NElement): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-is-focus
  this.data(gtk.Widget).isFocus()

proc internalSetFocus(this: NElement) =
  let thisD = this.data(gtk.Widget)
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-grab-focus
  thisD.setCanFocus(true)
  thisD.grabFocus()

proc internalGetSize(this: NElement): tuple[w, h: int] =
  # uggh ...
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-preferred-size
  result = (-1, -1)
  var a, b: Requisition
  this.data(gtk.Widget).getPreferredSize(a, b)
  if b != nil: return (b.width.int, b.height.int)

proc adjustSize(this: NElement) =
  if this.internalGetParent() == nil: return
  
  # https://stackoverflow.com/a/9691465 Shrink Window
  let parent = this.internalGetParent()
  
  if parent of Window:
    var dw, dh, w, h: cint
    getPreferredWidth(this.data(gtk.Container), dw, w)
    getPreferredHeight(this.data(gtk.Container), dh, h)
    # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-resize
    resize(parent.data(gtk.Window), w, h)
    
  adjustSize(parent)

proc internalSetSize(this: NElement, size: tuple[w, h: int]) =
  let w = this.data(gtk.Widget)
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-size-request
  w.setSizeRequest(size.w.cint, size.h.cint)
  #let adapter = utilGetAdapter(w)
  #if adapter != nil:
    #cast[gtk.Widget](adapter).setSizeRequest(size.w.cint, size.h.cint)

  if this of Progress:
    discard invokeSatanSet(this,
      "trough{min-width:$1px;min-height:$2px;}progress{min-height:$2px;}",
        size.w, size.h)
  
  adjustSize(this)

proc internalSetTooltip(this: NElement, text: string) =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-set-tooltip-text
  this.data(gtk.Widget).setToolTipText(text)
  
proc internalGetTooltip(this: NElement): string =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-get-tooltip-text
  $this.data(gtk.Widget).getToolTipText()

proc internalSetDestroy(this: NElement) =
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-destroy
  this.data(gtk.Widget).destroy()

proc internalGetDestroy(this: NElement): bool = not utilExists(this)
proc internalGetParent(this: NElement): Container = utilParent(this)

proc internalGetBGColor(this: NElement): Pixel =
  # https://developer.gnome.org/gtk3/stable/chap-css-properties.html
  # "Table 10. Background properties"
  invokeSatanGet(this, "background-color", result)
  
proc internalSetBGColor(this: NElement, color: Pixel) =
  let (r, g, b, a) = color
  discard invokeSatanSet(this,
    "*{background-color:rgba($1,$2,$3,$4);}", r, g, b, a)


# CONTAINER -------------------------------------
proc internalRemove(this: Container, that: NElement) =  
  let (thisD, thatD) =
    (cast[gtk.Container](this.raw), cast[gtk.Widget](that.raw))

  if not utilDelAdapter(thatD, adapters):
    # https://developer.gnome.org/gtk3/stable/GtkContainer.html#gtk-container-remove
    thisD.remove(thatD)

  adjustSize(this)
  utilRemove(this, that)

proc handleMenuBarAdd(this, that: NElement) # FD
proc handleToolsAdd(this: Tools, that: NElement) # FD

proc internalAdd(this: Container, that: NElement) =  
  if this of App:
    utilChild(this, that)
    return

  # MENU/BAR
  # (Complex stuff, we need to create MenuItems in the middle)
  if (this of Menu or this of Bar) or (that of Menu):
    handleMenuBarAdd(this, that)
    return
  
  # TOOLS
  # Again, create an adapter
  if this of Tools:
    handleToolsAdd(Tools(this), that)
    return
  
  utilChild(this, that)
  let (thisD, thatD) = (this.data(gtk.Container), that.data(gtk.Widget))
  
  if not utilTryAddChild(thisD, thatD, adapters):
    # https://developer.gnome.org/gtk3/stable/GtkContainer.html#gtk-container-add
    thisD.add(thatD)
  # https://developer.gnome.org/gtk3/stable/GtkWidget.html#gtk-widget-show
  thatD.show()

proc reinsert(this: NElement) = utilChildrenReinsert(this.internalGetParent())

proc internalReplace(container: Container, this, that: NElement) =
  # TODO
  raiseAssert("Not implemented YET")

proc internalIndex(this: Container, that: NElement): int =
  utilChildIndex(this, that)

proc internalGetChild(this: Container, index: int): NElement =
  utilNChild(this, index)

proc internalLen(this: Container): int = utilLen(this)

proc internalGetBorder(this: Container): NBorder =
  # https://developer.gnome.org/gtk3/stable/chap-css-properties.html
  # "Table 7. Box properties" Not sure this always works
  invokeSatanGet(this, "margin-top", result[nsTop])
  invokeSatanGet(this, "margin-bottom", result[nsBottom])
  invokeSatanGet(this, "margin-left", result[nsLeft])
  invokeSatanGet(this, "margin-right", result[nsRight])

proc internalSetBorder(this: Container, b: NBorder) =
  # TODO: Who is in the right here? border-width or margin?
  discard invokeSatanSet(
    this, "*{border-top-width:$1px;border-bottom-width:$2px;border-left-width:$3px;border-right-width:$4px;}",
    b[nsTop], b[nsBottom], b[nsLeft], b[nsRight])

proc internalGetBorderColor(this: Container): Pixel =
  invokeSatanGet(this, "border-color", result)

proc internalSetBorderColor(this: Container, color: Pixel) =
  let (r,g,b,a) = color
  discard invokeSatanSet(this, "*{border-color:rgba($1,$2,$3,$4);}", r, g, b, a)

proc internalAddSeparator(this: Container, dir: NOrientation) =
  # https://developer.gnome.org/gtk3/stable/GtkSeparator.html
  # https://developer.gnome.org/gtk3/stable/GtkSeparatorMenuItem.html
  # https://developer.gnome.org/gtk3/stable/GtkSeparatorToolItem.html
  if this of Box:
    let box = this.data(gtk.Box)
    box.add(newSeparator(Orientation(dir)))
  elif this of Menu:
    let menu = this.data(gtk.Menu)
    menu.add(newSeparatorMenuItem())
  elif this of Tools:
    let tools = this.data(gtk.ToolBar)
    tools.add(newSeparatorToolItem())


# APP -------------------------------------------
proc internalRun(this: App) =
  for c in utilItems(this):
    c.data(gtk.Window).showAll()
  gtk.main() # Blocking

proc internalStop(this: App) =
  utilStopRepeat()
  gtk.mainQuit()


# WINDOW ----------------------------------------
proc internalSetText(this: Window, text: string) =
  this.data(gtk.Window).title = text

proc internalGetText(this: Window): string =
  $this.data(gtk.Window).getTitle()

proc internalSetResizable(this: Window, state: bool) =
  this.data(gtk.Window).setResizable(state)

proc internalGetResizable(this: Window): bool =
  this.data(gtk.Window).getResizable()

proc internalSetPosition(this: Window, position: tuple[x, y: int]) =
  this.data(gtk.Window).move(position.x.cint, position.y.cint)

proc internalGetPosition(this: Window): tuple[x, y: int] =
  var x, y: cint
  this.data(gtk.Window).getPosition(x, y)
  return (x.int, y.int)

proc internalGetFocused(this: Window): NElement =
  let widget = this.data(gtk.Window).getFocus()
  if widget == nil: return
  return utilElement(widget)

proc internalGetIcon(this: Window): Bitmap =
  newBitmap(this.data(gtk.Window).getIcon())

proc internalSetIcon(this: Window, that: Bitmap) =
  this.data(gtk.Window).setIcon(cast[GdkPixBuf](that.data))

proc internalGetDecorated(this: Window): bool =
  bool(this.data(gtk.Window).getDecorated())
  
proc internalSetDecorated(this: Window, v: bool) =
  this.data(gtk.Window).setDecorated(v)

proc internalSetMinimized(this: Window, v: bool) =
  if v: this.data(gtk.Window).iconify()
  else: this.data(gtk.Window).deiconify()
  
proc internalGetMinimized(this: Window): bool =
  discard # TODO

proc internalSetMaximized(this: Window, v: bool) =
  if v: this.data(gtk.Window).maximize()
  else: this.data(gtk.Window).unmaximize()
  
proc internalGetMaximized(this: Window): bool =
  this.data(gtk.Window).isMaximized()


# ALERT -----------------------------------------  
# SET/GET Text https://developer.gnome.org/gtk3/stable/GtkMessageDialog.html#GtkMessageDialog--text

proc internalRun(this: Alert) =
  discard run(this.data(gtk.Dialog))
  gtk.destroy(this.data(gtk.Widget))

# From Window ****
proc internalSetModal(this: Alert, v: bool) =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-set-modal
  this.data(gtk.Window).setModal(v)

proc internalGetModal(this: Alert): bool =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-modal
  this.data(gtk.Window).getModal()
  
proc internalSetTransient(this: Alert, that: Window) =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-set-transient-for
  this.data(gtk.Window).setTransientFor(that.data(gtk.Window))

proc internalGetTransient(this: Alert): Window =
  # https://developer.gnome.org/gtk3/stable/GtkWindow.html#gtk-window-get-transient-for
  let w = this.data(gtk.Window).getTransientFor()
  if w != nil: return Window(utilElement(w))
# ****************


# LABEL -----------------------------------------
proc internalSetText(this: Label, text: string) =
  this.data(gtk.Label).setText(text)

proc internalGetText(this: Label): string =
  $this.data(gtk.Label).getText()

proc internalSetWrap(this: Label, state: bool) =
  this.data(gtk.Label).setLineWrap(state)

proc internalGetWrap(this: Label): bool =
  this.data(gtk.Label).getLineWrap()
  
proc internalGetXAlign(this: Label): float =
  this.data(gtk.Label).getXAlign()

proc internalGetYAlign(this: Label): float =
  this.data(gtk.Label).getYAlign()
  
proc internalSetXAlign(this: Label, v: float) =
  this.data(gtk.Label).setXAlign(v)

proc internalSetYAlign(this: Label, v: float) =
  this.data(gtk.Label).setYAlign(v)


# ENTRY -----------------------------------------
proc internalGetText(this: Entry): string =
  $this.data(gtk.Entry).getText()

proc internalSetText(this: Entry, text: string) =
  this.data(gtk.Entry).setText(text)


# BUTTON ----------------------------------------
proc internalSetText(this: Button, text: string) =
  this.data(gtkButton).setLabel(text)
  
proc internalGetText(this: Button): string =
  $this.data(gtkButton).getLabel()

proc internalSetImage(this: Button, img: Bitmap) =
  this.data(gtkButton).setImage(newImage(cast[GDKPixbuf](img.data)))

proc internalGetImage(this: Button): Bitmap =
  newBitmap(this.data(gtkButton).getImage().getPixbuf())


# RADIO -----------------------------------------


# BUBBLE ----------------------------------------
proc internalAttach(this: Bubble, that: NElement) =
  let thisD = this.data(gtk.Popover)
  thisD.setRelativeTo(that.data(gtk.Widget))
  thisD.setConstrainTo(PopoverConstraint.NONE)
  thisD.show()


# IMAGE -----------------------------------------
# INCLUDED


# TEXT_AREA -------------------------------------
proc internalSetText(this: TextArea, text: string) =
  let buffer = this.data(gtk.TextView).getBuffer()
  buffer.setText(text, text.len.cint)

proc internalGetText(this: TextArea): string =
  var s, e: TextIter
  let buffer = this.data(gtk.TextView).getBuffer()
  buffer.getBounds(s, e)
  return $buffer.getText(s, e, true)


# CALENDAR --------------------------------------
proc internalGetDate(this: Calendar): DateTime =
  var d, m, y: cuint
  this.data(gtk.Calendar).getDate(y, m, d)

  return initDateTime(
    monthday = MonthdayRange(d), month = Month(m + 1), year = int(y),
    0, 0, 0, 0)

proc internalSetDate(this: Calendar, date: DateTime) =
  let c = this.data(gtk.Calendar)
  c.selectMonth((date.month.int - 1).cuint, date.year.cuint)
  c.selectDay(date.monthday.cuint)

proc internalMark(this: Calendar, day: int) =
  this.data(gtk.Calendar).markDay(day.cuint)

proc internalUnmark(this: Calendar, day: int) =
  this.data(gtk.Calendar).unmarkDay(day.cuint)

proc internalMarked(this: Calendar, day: int): bool =
  this.data(gtk.Calendar).getDayIsMarked(day.cuint)

proc internalClear(this: Calendar) =
  this.data(gtk.Calendar).clearMarks()


# SLIDER ----------------------------------------
proc internalSetValue(this: Slider, value: float) =
  this.data(gtk.Scale).setValue(value.cdouble)

proc internalGetValue(this: Slider): float =
  this.data(gtk.Scale).getValue().float

proc internalGetDecimals(this: Slider): int =
  this.data(gtk.Scale).getDigits().int

proc internalSetDecimals(this: Slider, decimals: int) =
  this.data(gtk.Scale).setDigits(decimals.cint)

proc internalSetStep(this: Slider, step: float) =
  this.data(gtk.Scale).setIncrements(step.cdouble, step.cdouble)

proc internalSetRange(this: Slider, range: Slice[float]) =
  this.data(gtk.Scale).setRange(range.a.cdouble, range.b.cdouble)

proc internalGetOrientation(this: Slider): NOrientation =
  NOrientation(this.data(gtk.Orientable).getOrientation())

proc internalSetOrientation(this: Slider, value: NOrientation) =
  this.data(gtk.Orientable).setOrientation(Orientation(value))


# CHECKBOX --------------------------------------
proc internalSetText(this: Checkbox, that: string) =
  this.data(gtkCheckButton).setLabel(that)

proc internalGetText(this: Checkbox): string =
  $this.data(gtkCheckButton).getLabel()

proc internalGetChecked(this: Checkbox): bool =
  this.data(gtkCheckButton).getActive()

proc internalSetChecked(this: Checkbox, v: bool) =
  this.data(gtkCheckButton).setActive(v)


# FILECHOOSE ------------------------------------
proc internalSetMultiple(this: FileChoose, state: bool) =
  gtkSet(this, "select-multiple", state)

proc internalGetMultiple(this: FileChoose): bool =
  gtkGet(this, "select-multiple", result)

proc internalGetFiles(this: FileChoose): seq[string] =
  var list = this.data(FileChooser).getFilenames()
  while list != nil:
    let name = cast[cstring](list.data)
    result.add($name)
    free(list.data)
    list = list.next
  free(list)

proc internalSetText(this: FileChoose, text: string) =
  this.data(gtk.FileChooserDialog).setTitle(text)

proc internalGetText(this: FileChoose): string =
  $this.data(gtk.FileChooserDialog).getTitle()

proc internalSetButton(this: FileChoose, button: string, index: int) =
  discard this.data(gtk.FileChooserDialog).addButton(button, index.cint)

proc internalRun(this: FileChoose): int =
  let rc = this.data(gtk.FileChooserDialog).run().int
  return if rc < 0: -1 else: rc  


# BAR -------------------------------------------
# ---


# MENU ------------------------------------------
# ---


proc handleMenuBarAdd(this, that: NElement) =
  # BAR / MENU ----------------------
  # GTKMenuBar/GTKMenu hierarchy:
  # MenuBar -> [MenuItem] -> Menu -> [MenuItem] -> Widgets
  # https://developer.gnome.org/gtk3/stable/GtkMenuItem.html
  # ---------------------------------

  let (thisD, thatD) = (this.data(gtk.Container), that.data(gtk.Widget))

  if this of Bar:
    # MenuBar -> CREATE(MenuItem) -> Menu
    if that of Menu:
      
      # Maybe 'this' has a MenuItem attached already somewhere ...
      let
        last  = utilNChild(Bar(this), utilLen(Bar(this)) - 1)
        lastD = cast[gtk.Widget](last.raw)
        
      if last != nil:
        # TODO: What if returns EventBox?
        let mItem = cast[gtk.MenuItem](
          utilGetOrAddAdapter(lastD, adaptersMenuItem))
        gtk.MenuItem(mItem).setSubmenu(that.data(gtk.Menu))
        return

      # Sorry, but in between Bar and Menu, we need
      # a label or something, now you will die
      raiseAssert(
        "Cannot add Menu directly to Bar. Add Menu to label and " &
        "that label to Bar instead")

    # MenuBar -> CREATE(MenuItem->Menu) -> That
    else:      
      # Maybe 'that' already has a MenuItem attached
      discard utilInsertAdapter(thisD, thatD, adaptersMenuItem)

  # Menu -> CREATE(MenuItem) -> That  
  elif this of Menu:
    discard utilInsertAdapter(thisD, thatD, adaptersMenuItem)
  
  # CREATE(MenuItem) -> This -> That
  elif that of Menu:
    let mItem = cast[gtk.MenuItem](
      utilGetOrAddAdapter(thisD, adaptersMenuItem))
    mItem.setSubmenu(gtk.Menu(thatD))

    if utilExists(neClick, thisD) and not utilExists(neClick, mItem):
      utilSet(neClick, mItem, utilGet(neClick, thisD))
      discard gSignalConnect(
        mItem, "activate", gCALLBACK(triggerEvent), cast[pointer](neClick))

    return

  else:
    # Should never by triggered by client code
    raiseAssert("NOOOOOOOOOOOOOOOOOOOOOO!")

  utilChild(Container(this), that)

proc internalAdd(this: NElement, that: Menu) =
  handleMenuBarAdd(this, that)


# COMBOBOX --------------------------------------
proc internalAdd(this: ComboBox, text: string) =
  let ls = cast[ListStore](this.data(gtkComboBox).getModel())

  var ti: TreeIterObj
  ls.append(ti.addr)
  ls.set(ti.addr, 0, cstring(text), -1)

template comboBoxWithIndex(
    this: ComboBox, idx: int, body: untyped) {.dirty.} =
  let ls =
    cast[ListStore](this.data(gtkComboBox).getModel())

  var i = idx.cint
  var ti: TreeIterObj

  if cast[TreeModel](ls).getIter(ti.addr, newTreePath(i, 1)):
    body

proc internalSet(this: ComboBox, text: string, i: int) =
  comboBoxWithIndex(this, i):
    ls.set(ti.addr, 0, cstring(text), -1)

proc internalGet(this: ComboBox, i: int): string =
  comboBoxWithIndex(this, i):
    var v: GValueObj
    cast[TreeModel](ls).getValue(ti.addr, 0, v.addr)
    result = $getString(v.addr)
    unset(v.addr)

proc internalGetSelectedIndex(this: ComboBox): int = # TODO 
  int(this.data(gtkComboBox).getActive())

proc internalSetSelectedIndex(this: ComboBox, i: int) =
  this.data(gtkComboBox).setActive(i.cint)

proc internalGetSelected(this: ComboBox): string =
  internalGet(this, internalGetSelectedIndex(this))
  

# PROGRESS --------------------------------------
proc internalValue(this: Progress): float =
  float(this.data(gtk.ProgressBar).getFraction())

proc internalValue(this: Progress, v: float) =
  this.data(gtk.ProgressBar).setFraction(v)


# BOX -------------------------------------------
proc internalSetSpacing(this: Box, spacing: int) =
  this.data(gtk.Box).setSpacing(spacing.cint)

proc internalGetOrientation(this: Box): NOrientation =
  NOrientation(this.data(gtk.Orientable).getOrientation())

proc internalSetOrientation(this: Box, value: NOrientation) =
  this.data(gtk.Orientable).setOrientation(Orientation(value))

proc internalAdd(this: Box, that: NElement, expand, fill: bool, padding: int) =
  doAssert that.internalGetParent == nil
  this.data(gtk.Box).packStart(
    that.data(gtk.Widget), expand, fill, padding.cuint)
  utilChild(this, that)


# TABLE -----------------------------------------
proc hackGetPixbufType: GType =
  var t {.global.}: GType
  once:
    let pb = newPixbuf(GdkColorspace.RGB, false, 8, 1, 1)
    t = gObjectType(pb)
    objectUnref(pb)
    
  return t

proc setHeaders(this: NTable, headers: openArray[(string, NCellKind)]) =
  var list: seq[GType]
  var visible = false

  for _, k in items headers:
    case k:
    of ckStr:  list.add(G_TYPE_STRING)
    of ckBool: list.add(G_TYPE_BOOLEAN)
    of ckImg:  list.add(hackGetPixbufType())

  let
    tv = this.data(gtk.TreeView)
    ls = listStoreNewv(list.len.cint, addr(list[0]))

  for i, (n, k) in headers:
    visible = visible or n != ""
    template add(r, t) =
      discard tv.appendColumn(
        newTreeViewColumn(n, r(), t, i.cint, nil))

    case k:
    of ckStr:  add(newCellRendererText, "text")
    of ckBool: add(newCellRendererToggle, "active")      
    of ckImg:  add(newCellRendererPixbuf, "pixbuf")
  
  tv.setModel(cast[TreeModel](ls))
  tv.setHeadersVisible(visible)

template tableSet(that: NTableCell, x: int) {.dirty.} =
  var old: NTableCell
  tableGet(old, x)
  if old.kind == that.kind:
    template set(v) = ls.set(ti.addr, x.cint, v, -1)
    case that.kind:
    of ckStr:  set(cstring(that.vStr))
    of ckBool: set(that.vBool)
    of ckImg:  set(cast[GdkPixBuf](that.vImg.data))

template tableGet(that: var NTableCell, x: int) {.dirty.} =
  var v: GValueObj
  cast[TreeModel](ls).getValue(ti.addr, x.cint, v.addr)
  let gvt = gValueType(v.addr)

  if gvt == G_TYPE_STRING:
    that = toCell($getString(v.addr))
  elif gvt == hackGetPixbufType():
    # TODO: Not tested
    that = toCell(newBitmap(cast[GdkPixBuf](getPointer(v.addr))))
  elif gvt == G_TYPE_BOOLEAN:
   that = toCell(getBoolean(v.addr))
  else:
    raiseAssert("Cell Type not implemented in gtk3")

  unset(v.addr)

template tableSet(that: NTableCell, x, y: int) {.dirty.} =
  var ti: TreeIterObj
  if cast[TreeModel](ls).getIter(ti.addr, newTreePath(y.cint, -1)):
    tableSet(that, x)

template tableGet(that: var NTableCell, x, y: int) {.dirty.} =
  var ti: TreeIterObj
  if cast[TreeModel](ls).getIter(ti.addr, newTreePath(y.cint, -1)):
    tableGet(that, x)

proc internalAdd(this: NTable, that: NTableRow) =
  let tv = this.data(gtk.TreeView)

  if tv.getModel() == nil:
    var list: seq[(string, NCellKind)]
    for i in 0 ..< that.len:
      let t = tv.getData("cn" & $i)
      let title = if t != nil: $cast[cstring](t) else: ""
      list.add((title, that.list[i].kind))

    setHeaders(this, list)

  let ls = cast[gtk.ListStore](tv.getModel())
  var ti: TreeIterObj
  ls.append(ti.addr)
  for i in 0 ..< that.len: tableSet(that.list[i], i)

proc internalSet(this: NTable, that: NTableCell, x, y: int) =
  let ls = cast[ListStore](this.data(gtk.TreeView).getModel())
  tableSet(that, x, y)

proc internalGet(this: Table, x, y: int): NTableCell =
  let ls = cast[ListStore](this.data(gtk.TreeView).getModel())
  tableGet(result, x, y)

proc internalHeader(this: NTable, headers: openArray[string]) =
  let tv = this.data(gtk.TreeView)

  if tv.getColumn(0) == nil:
    for i, h in headers:
      tv.setData("cn" & $i, GPointer(cstring(h)))
    
  else:
    for i, h in headers:
      tv.getColumn(i.cint).setTitle(h)

proc internalHeaders(this: NTable): bool =
  this.data(gtk.TreeView).getHeadersVisible()

proc internalHeaders(this: NTable, v: bool) =
  this.data(gtk.TreeView).setHeadersVisible(v)


# GRID ------------------------------------------  
proc internalAdd(this: Grid, that: NElement, r, c, w, h: int) =
  doAssert that.internalGetParent == nil

  utilChild(this, that)
  this.data(gtk.Grid).attach(
    that.data(gtk.Widget), c.cint, r.cint, w.cint, h.cint)


# TAB -------------------------------------------
proc internalAdd(this: Tab, that: Container, label: Label) =
  discard this.data(gtk.NoteBook).appendPage(
    that.data(gtk.Container), label.data(gtk.Label))
  utilChild(this, that)
  utilChild(that, label)

proc internalSetReorderable(this: Tab, v: bool) =
  let thisD = this.data(gtk.NoteBook)
  for i in 0 ..< internalLen(this): # :-/
    let c = internalGetChild(this, i)
    thisD.setTabReorderable(c.data(gtk.Widget), v)

proc internalGetReorderable(this: Tab): bool =
  if internalLen(this) == 0: return
  return this.data(gtk.NoteBook)
    .getTabReorderable(internalGetChild(this, 0).data(gtk.Widget))

proc internalGetSide(this: Tab): NSide =
  [nsLeft, nsRight, nsTop, nsBottom][
    int(this.data(gtk.NoteBook).getTabPos())]
  
proc internalSetSide(this: Tab, side: NSide) =
  this.data(gtk.NoteBook).setTabPos(
    [PositionType.TOP, PositionType.BOTTOM,
     PositionType.LEFT, PositionType.RIGHT][int(side)])


# LIST ------------------------------------------
proc internalGetMode(this: List): NAmount =
  NAmount(this.data(gtk.ListBox).getSelectionMode)

proc internalSetMode(this: List, mode: NAmount) =
  this.data(gtk.ListBox).setSelectionMode(SelectionMode(mode))

proc internalCmp(this: List, that: NCMPProc) =
  var cmps {.global.}: STable[int, NCMPProc]
  
  this.data(gtk.ListBox).setSortFunc(
    proc(a, b: gtk.ListBoxRow, data: GPointer): cint {.cdecl.} =
      let (a, b) = (a.getChild(), b.getChild())
      return cmps[cast[int](data)](a.utilElement(), b.utilElement()).cint
  , cast[GPointer](int(this.id)), nil)

  cmps[int(this.id)] = that
  
proc internalSelected(this: List, that: var seq[NElement]) =
  var r = this.data(gtk.ListBox).getSelectedRows()
  while r != nil:
    let d = cast[gtk.ListBoxRow](r.data).getChild()
    that.add(d.utilElement())
    r = r.next
  free(r)


# FRAME -----------------------------------------
proc internalSetText(this: Frame, text: string) =
  this.data(gtk.Frame).setLabel(text)

proc internalGetText(this: Frame): string =
  $this.data(gtk.Frame).getLabel()


# TOOLS -----------------------------------------  
proc internalGetOrientation(this: Tools): NOrientation =
  NOrientation(this.data(gtk.Orientable).getOrientation())

proc internalSetOrientation(this: Tools, value: NOrientation) =
  this.data(gtk.Orientable).setOrientation(Orientation(value))

proc handleToolsAdd(this: Tools, that: NElement) =
  # TOOLS ---------------------------
  # GTKToolBar hierarchy:
  # ToolBar -> [ToolItem] -> Widget
  # https://developer.gnome.org/gtk3/stable/GtkToolItem.html
  # ---------------------------------
  
  let (thisD, thatD) = (this.data(gtk.ToolBar), that.data(gtk.Widget))
  discard utilInsertAdapter(thisD, thatD, adaptersToolItem)
  utilChild(this, that)


# TIMERS ----------------------------------------
proc internalRepeat(event: NRepeatProc, ms: int): NRepeatHandle =  
  # https://developer.gnome.org/gtk-tutorial/stable/c1759.html
  proc cb(a: GPointer): GBoolean {.cdecl.} = utilTrigger(cast[int](a))
  
  let rid = utilNextRepeatID()
  result = timeoutAdd(
    interval = cuint(ms),
    function = GSourceFunc(cb),
    data     = cast[GPointer](rid),
  ).NRepeatHandle

  utilRepeatAdd(event, result, rid)

proc internalStop(this: NRepeatHandle) =
  discard sourceRemove(this.cuint)
  utilDel(this)

proc internalSetTime(this: var NRepeatHandle, ms: int) =
  let event = utilGet(this)
  internalStop(this)
  this = internalRepeat(event, ms)


# CLIPBOARD -------------------------------------
proc getCB: Clipboard =
  # https://developer.gnome.org/gtk3/stable/gtk3-Clipboards.html
  var acb {.global.}: gdk.Atom
  once: acb = atomIntern("CLIPBOARD", true)
  return clipboardGet(acb)

template C: Clipboard = getCB()

proc internalClipboardClear = C.clear()

proc internalClipboardSet(text: string) = C.setText(text, text.len.cint)

proc internalClipboardSet(img: Bitmap) = C.setImage(cast[GdkPixBuf](img.data))

proc internalClipboardGetText: string =
  let txt = C.waitForText()
  if txt == nil: return
  result = $txt
  free(txt)

proc internalClipboardGetImg: Bitmap =
  let img = C.waitForImage()
  if img == nil: return
  result = newBitmap(cast[GdkPixBuf](img))
  objectUnref(img)
  
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


# EVENTS: THE SECOND COMING ---------------------
proc internalGetCurrentEvent: NEventArgs =
  # https://developer.gnome.org/gtk3/stable/gtk3-General.html
  # https://developer.gnome.org/gdk3/stable/gdk3-Event-Structures.html
  let e = getCurrentEvent()
  if e == nil: return
  
  case e.`type`:
  of BUTTON_PRESS, BUTTON_RELEASE, MOTION_NOTIFY:
    template setkind(a, b) =
      if e.`type` == a: result = NEventArgs(kind: b)
      
    setKind(BUTTON_PRESS,   neClick)
    setKind(BUTTON_RELEASE, neClickRelease)
    setKind(MOTION_NOTIFY,  neMove)
    
    if e.`type` in {BUTTON_PRESS, BUTTON_RELEASE}:
      let e = cast[EventButton](e)
      
      if e.button == 1: result.mouse.incl(nm1)
      if e.button == 2: result.mouse.incl(nm2)
      if e.button == 3: result.mouse.incl(nm3)
      
    else:
      var st: ModifierType
      if e.getState(st):      
        template setMouse(a, b) =
          if (int(st) and int(a)) != 0: result.mouse.incl(b)

        setMouse(BUTTON1_MASK, nm1)
        setMouse(BUTTON2_MASK, nm2)
        setMouse(BUTTON3_MASK, nm3)

    result.x = e.button.x.int
    result.y = e.button.y.int

  of KEY_PRESS, KEY_RELEASE:
    let key =
      case e.key.keyval:
      of KEY_ESCAPE: nkEsc
      of KEY_a .. KEY_z:
        NKey((int(e.key.keyval) - int(Key_a)) + int(nkA))
      of KEY_0 .. KEY_9:
        NKey((int(e.key.keyval) - int(Key_0)) + int(nk0))
      else: nkNone

    result =
      if e.`type` == KEY_PRESS: NEventArgs(kind: neKeyPress, key: key)
      else: NEventArgs(kind: neKeyRelease, key: key)

    var st: ModifierType
    if e.getState(st):
      template mapMod(mt: ModifierType, k: NKey) =
        if (int(st) and int(mt)) != 0: result.mods.incl(k)

      mapMod(CONTROL_MASK, nkControl)
      mapMod(SHIFT_MASK, nkShift)

  else: discard

  result.element = utilElement(e.getEventWidget())
  gdk.free(e)


# I was a flower of the mountain yes when I put the rose in my hair like
# the Andalusian girls used or shall I wear a red yes and how he kissed me
# under the Moorish wall and I thought well as well him as another and then
# I asked him with my eyes to ask again yes and then he asked me would
# I yes to say yes my mountain flower and first I put my arms around him yes
# and drew him down to me so he could feel my breasts all perfume yes and his
# heart was going like mad and yes I said yes I will Yes.
