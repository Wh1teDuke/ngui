
import private/gtk2/[gtk2, gdk2, glib2, gdk2, gdk2pixbuf, cairo]


# -----------------------------------------------
# GTK2
# -----------------------------------------------
type
  gtkWindow            = gtk2.PWindow
  gtkDialog            = gtk2.PDialog
  gtkWidget            = gtk2.PWidget
  gtkContainer         = gtk2.PContainer
  gtkComboBox          = gtk2.PComboBox
  gtkListStore         = gtk2.PListStore
  gtkTreeIterObj       = gtk2.TTreeIter
  gtkTreeModel         = gtk2.PTreeModel
  gtkNoteBook          = gtk2.PNoteBook
  gtkRadioButton       = gtk2.PRadioButton
  gtkButton            = gtk2.PButton
  gtkToolItem          = gtk2.PToolItem
  gtkGrid              = gtk2.PTable
  gtkLabel             = gtk2.PLabel
  gtkEntry             = gtk2.PEntry
  gtkTextIter          = gtk2.PTextIter
  gtkTreeView          = gtk2.PTreeView
  gtkListBox           = gtk2.PCList
  gtkListBoxRow        = gtk2.PCListRow
  gtkFrame             = gtk2.PFrame
  gtkImage             = gtk2.PImage
  gtkToolBar           = gtk2.PToolBar
  gtkTextView          = gtk2.PTextView
  gtkCalendar          = gtk2.PCalendar
  gtkScale             = gtk2.PScale
  gtkBox               = gtk2.PBox
  gtkMenuItem          = gtk2.PMenuItem
  gtkMenu              = gtk2.PMenu
  gtkProgressBar       = gtk2.PProgressBar
  gtkCheckButton       = gtk2.PCheckButton
  gtkFileChooserDialog = gtk2.PFileChooser
  gtkCellLayout        = gtk2.PPGtkCellLayout
  gtkOrientable        = gtk2.PWidget
  Orientation          = gtk2.TOrientation

  GPointer             = glib2.gpointer
  GValueObj            = glib2.TGValue  
  ClipBoard            = gtk2.PClipboard
  GDKPixbuf            = gdk2pixbuf.PPixbuf


const
  SCB          = gtk2.SIGNAL_FUNC
  signal       = gtk2.signalConnect
  gtkDestroy   = proc(w: gtkWidget) = gtk2.destroy(w)
  objectUnref  = gObjectUnref
  newPixbuf    = pixbuf_new


proc gtkRef(w: PWidget): auto = reference(w)
proc gtkRef(w: GPointer): auto = gObjectRef(w)
proc newMenuItem(): auto = gtk2.menu_item_new()
proc newEventBox(): auto = gtk2.event_box_new()
proc newToolItem(): auto = gtk2.tool_item_new()
proc newWindow(): auto = gtk2.window_new(gtk2.WINDOW_TOP_LEVEL)
proc newGrid(): auto = gtk2.table_new(1, 1, true)
proc newLabel(): auto = gtk2.label_new("")
proc newEntry(): auto = gtk2.entry_new()
proc newButton(): auto = gtk2.button_new()
proc newRadioButton(): auto = gtk2.radio_button_new(nil)
proc newImage(): auto = gtk2.image_new()
proc newTextView(): auto = gtk2.text_view_new()
proc newCalendar(): auto = gtk2.calendar_new()
proc newCheckButton(): auto = gtk2.check_button_new()
proc newPopover(): gtkWidget = raiseAssert("TODO") # cast[gtkWidget](gtk2.pop_over_new())
proc newFileChooser(): auto = gtk2.file_chooser_dialog_new(
  nil, nil, FILE_CHOOSER_ACTION_OPEN, nil)
proc newNoteBook(): auto = gtk2.notebook_new()
proc newMenuBar(): auto = gtk2.menu_bar_new()
proc newMenu(): auto = gtk2.menu_new()
proc newComboBox(): auto = gtk2.comboBox_new_with_model(
  cast[gtkTreeModel](gtk2.list_store_new(1, G_TYPE_STRING)))
proc newCellRendererText(): auto = gtk2.cell_renderer_text_new()
proc newProgressBar(): auto = gtk2.progress_bar_new()
proc newScale(): auto = gtk2.hscale_new(nil) # TODO change orientation
proc newBox(): auto = gtk2.vbox_new(true, 0) # TODO change Orientation
proc newTreeView(): auto = gtk2.tree_view_new()
proc newToolBar(): auto = gtk2.tool_bar_new()
proc newFrame(): auto = gtk2.frame_new("")
proc newListBox(): auto = gtk2.clist_new(1) # https://developer.gnome.org/gtk2/2.24/GtkCList.html
proc newTreePath(a, b: int): auto = gtk2.tree_path_new_from_string($a & ":" & $b)
proc newSeparator(o: Orientation): gtkWidget =
  if int(o) == 1: vseparator_new() else: hseparator_new()
proc newSeparatorMenuItem(): gtkWidget = separator_menu_item_new()
proc newMessageDialog(): auto = gtk2.message_dialog_new(
  nil,
  0, # https://developer.gnome.org/gtk2/2.24/GtkDialog.html#GtkDialogFlags # TODO: TODO
  MESSAGE_OTHER, # https://developer.gnome.org/gtk2/2.24/GtkMessageDialog.html#GtkMessageType
  BUTTONS_CLOSE, # https://developer.gnome.org/gtk2/2.24/GtkMessageDialog.html#GtkButtonsType
  nil)
proc loadPixbuf(file: string): GDKPixbuf =
  var error: pointer
  return pixbuf_new_from_file(file, error)
proc joinGroup(a, b: gtkRadioButton) =
  a.setGroup(b.getGroup())
# -----------------------------------------------

include private/ngui_common_gtk


# NELEMENT --------------------------------------
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
proc internalGetBorder(this: Container): int {.notSupported.}
proc internalSetBorder(this: Container, b: int) {.notSupported.}
proc internalGetBorderColor(this: Container): Pixel {.notSupported.}
proc internalSetBorderColor(this: Container, color: Pixel) {.notSupported.}


# APP -------------------------------------------
proc internalRun(this: App) =
  for c in utilItems(this):
    c.data(gtkWindow).showAll()
  gtk2.main() # Blocking

proc internalStop(this: App) =
  utilStopRepeat()
  gtk2.mainQuit()


# WINDOW ----------------------------------------
proc internalGetOpacity(this: Window): float = 1.0
proc internalSetOpacity(this: Window, v: float) {.notSupported.}


# BUBBLE ----------------------------------------
proc internalAttach(this: Bubble, that: NElement) {.notSupported.}


# GRID ------------------------------------------
proc internalAdd(this: Grid, that: NElement, r, c, w, h: int)  =
  # https://developer.gnome.org/gtk2/2.24/GtkTable.html

  let
    thisD         = this.data(gtkGrid)
    (r, c, w, h)  = (guint(r), guint(c), guint(w), guint(h))

  var tR, tC: guint
  
  thisD.getSize(tR, tC)
  if r + h > tR or c + w > tC: thisD.resize(max(tR, r + h), max(tC, c + w))

  thisD.attachDefaults(that.data(gtkWidget), c, c + w, r, r + h)
  utilChild(this, that)


# CLIPBOARD -------------------------------------
var
  idPool {.global.}: int = 0
  txtCB {.global.}: STable[int, NAsyncTextProc]
  imgCB {.global.}: STable[int, NAsyncBitmapProc]
  
proc onCPTxt(_: Clipboard, text: cstring, data: gpointer) {.cdecl, gcsafe.} =
  let id = cast[int](data)

  {.gcsafe.}:
    let cb = txtCB[id]
    del(txtCB, id)
    cb(if text == nil: "" else: $text)

proc onCPImg(_: Clipboard, img: GdkPixBuf, data: gpointer) {.cdecl, gcsafe.} =
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