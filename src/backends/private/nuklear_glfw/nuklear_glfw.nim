{.define: glfwStaticLib.}


# GLFW ========================================================================
import glfw/wrapper as glfw, glad


#proc onWindowCloseCallBack(w: glfw.Window) {.cdecl.} =
  #closeRequest = true

template wHint(a, b) = glfw.windowHint(a.cint, b.cint)

proc glfwStart: bool =
  result = bool(glfw.init())
  if not result: return

  wHint(hContextVersionMajor,    1)
  wHint(hContextVersionMinor,    0)
  wHint(hVisible,                false)
  #wHint(hTransparentFramebuffer, true)

proc glfwNewWindow(
    title:         string,
    width, height: int,
    shared:        glfw.Window = nil,
    ):             glfw.Window =

  result = glfw.createWindow(
    width   = cint(width),
    height  = cint(height),
    title   = cstring(title),
    monitor = nil, 
    share   = shared)

  #discard glfwSetWindowCloseCallback(result, onWindowCloseCallBack)

proc glfwVisible*(w: glfw.Window, state: bool) =
  (if state: glfw.showWindow else: glfw.hideWindow)(w)

proc glfwVisible*(w: glfw.Window): bool =
  bool(glfw.getWindowAttrib(w, hVisible.cint))

proc glfwTitle*(w: glfw.Window, title: string) =
  glfw.setWindowTitle(w, cstring(title))
  
proc glfwSize*(w: glfw.Window): tuple[w, h: int] =
  # https://www.glfw.org/docs/latest/group__window.html#gaeea7cbc03373a41fb51cfbf9f2a5d4c6
  var wW, wH: cint
  glfw.getWindowSize(w, wW.addr, wH.addr)
  return (wW.int, wH.int)
  
proc glfwSize*(w: glfw.Window, size: tuple[w, h: int]) =
  # https://www.glfw.org/docs/latest/group__window.html#ga371911f12c74c504dd8d47d832d095cb
  glfw.setWindowSize(w, cint(size.w), cint(size.h))

proc glfwClose*(w: glfw.Window) =
  # https://www.glfw.org/docs/latest/group__window.html#ga49401f82a1ba5f15db5590728314d47c
  # https://www.glfw.org/docs/latest/group__window.html#gacdf43e51376051d2c091662e9fe3d7b2
  glfw.hideWindow(w)
  glfw.destroyWindow(w)

proc glfwIcon*(w: glfw.Window, size: tuple[w, h: int], data: pointer) =
  # https://www.glfw.org/docs/latest/window_guide.html#window_icon
  # https://www.glfw.org/docs/latest/group__window.html#gadd7ccd39fe7a7d1f0904666ae5932dc5
  # https://www.glfw.org/docs/latest/structGLFWimage.html
  var img = glfw.IconImageObj(
    width:  size.w.int32,
    height: size.h.int32,
    pixels: cast[ptr[cuchar]](data))
  glfw.setWindowIcon(w, 1, img.addr)
  
proc glfwResizable*(w: glfw.Window, state: bool) =
  glfw.setWindowAttrib(w, hResizable.int32, state.int32)

proc glfwResizable*(w: glfw.Window): bool =
  glfw.getWindowAttrib(w, hResizable.int32).bool


# NUKLEAR =====================================================================
# https://github.com/Immediate-Mode-UI/Nuklear/blob/master/demo/glfw_opengl2/nuklear_glfw_gl2.h
# https://github.com/Immediate-Mode-UI/Nuklear/blob/master/demo/overview.c

import std/[tables, times, strutils]
import nuklear
export nuklear

const
  (DCL, DCH)       = (0.02, 0.2)
  DEF_WIN_SIZE*    = 300
  BUF_LEN          = 64 * 1024


type
  MouseState* = enum
    msUp msRelease msDown msPress
  
  nk_glfw_vertex {.bycopy.} = object
    position: array[2, cfloat]
    uv: array[2, cfloat]
    col: array[4, nk_byte]

  nk_glfw {.bycopy.} = object
    # Screen
    buf1:  pointer
    buf2:  pointer
    nkCtx*: nk_context
    width, height: cint
    display_width, display_height: cint
    fb_scale: nk_vec2
    cmds: nk_buffer
    null: nk_draw_null_texture
    # Text
    atlas: nk_font_atlas
    atlasText: GLuint
    text: seq[cuint]
    # Mouse
    scroll: nk_vec2
    lastButtonClick: cdouble
    isDoubleClickDown*: bool
    double_click_pos: nk_vec2
    mouseLast: tuple[x, y: cdouble]
    mouseMove*: bool
    mouseState*: array[MouseButton, MouseState]


var
  winToCtx =   initTable[glfw.Window, nk_glfw]()
  shared:      glfw.Window
  lastCtx:     tuple[w: glfw.Window, ctx: ptr[nk_glfw]]

proc getContext*(w: glfw.Window): ptr[nk_glfw] =
  if w == lastCtx.w: return lastCtx.ctx
  result = addr(winToCtx[w])
  lastCtx = (w, result)

proc getWindow(h: nk_handle): glfw.Window =
  for win, ctx in winToCtx:
    if ctx.nkCtx.clip.userdata == h: return win
  raiseAssert("Window not found")

proc getCurrentWindow*: glfw.Window =
  lastCtx.w

proc getCurrentNuklearGLFWContext*: ptr[nk_glfw] =
  lastCtx.ctx


# GLFW Callbacks ================================
proc onScrollCB(w: glfw.Window, oX, oY: cdouble) {.cdecl.} =
  let ctx = getContext(w)
  ctx.scroll.x += oX
  ctx.scroll.y += oY

proc onMouseCB(w: glfw.Window, button, action, mods: cint) {.cdecl.} =
  let
    ctx = getContext(w)
    action = KeyAction(action)
  
  # Click State
  template state: auto = ctx.mouseState[MouseButton(button)]
  
  state = 
    if action == kaDown: msPress else: msRelease

  # Double Click
  var x, y: cdouble

  glfw.getCursorPos(w, x.addr, y.addr)
  
  if action != kaDown:
    ctx.isDoubleClickDown = false
    return

  let
    t = glfw.getTime()
    d = t - ctx.lastButtonClick
  
  ctx.lastButtonClick = t

  if d in DCL .. DCH:
    ctx.isDoubleClickDown = true
    ctx.double_click_pos  = nk_vec2(x: x, y: y)

proc onCharCB(w: glfw.Window, chr: cuint) {.cdecl.} =
  let ctx = getContext(w)
  add(ctx.text, chr)


# NUKLEAR Callbacks =============================
proc onClipCopyCB(usr: nk_handle, str: cstring, len: cint) {.cdecl.} =  
  if len == 0: return
  var str2 = newString(len)
  for i, c in str: str2[i] = c
  glfw.setClipboardString(getWindow(usr), cstring(str2))

proc onClipPasteCB(usr: nk_handle, nkTextEdit: ptr[nk_text_edit]) {.cdecl.} =  
  let text = glfw.getClipboardString(getWindow(usr))
  if text != nil:
    discard nk_text_edit_paste(nkTextEdit, text, len(text).cint)


# MAIN ==========================================
proc nk_glfw_init* =
  doAssert glfwStart()
  
proc nk_glfw_key_cb*(w: glfw.Window, cb: glfw.Keyfun) =
  discard glfw.setKeyCallback(w, cb)
  
proc nk_glfw_mouse_cb*(w: glfw.Window, cb: glfw.Mousebuttonfun) =
  discard glfw.setMouseButtonCallback(w, cb)
  
proc nk_glfw_window*: glfw.Window =
  var ctx: nk_glfw
  ctx.buf1 = alloc(BUF_LEN)
  ctx.buf2 = alloc(BUF_LEN)  
  
  doAssert nk_init_fixed(
    ctx.nkCtx.addr, ctx.buf1, BUF_LEN.nk_size, nil).bool
  
  ctx.nkCtx.clip.copy     = onClipCopyCB
  ctx.nkCtx.clip.paste    = onClipPasteCB
  ctx.nkCtx.clip.userdata = nk_handle_id(
    block:
      var ctxId {.global.}: cint = 1_000
      inc(ctxId)
      ctxId
  )
  nk_buffer_init_default(ctx.cmds.addr)

  result = glfwNewWindow("ngui", DEF_WIN_SIZE, DEF_WIN_SIZE, shared)
  if shared == nil: shared = result

  let oldContext = glfw.getCurrentContext()
  glfw.makeContextCurrent(result)
  doAssert gladLoadGL(glfw.getProcAddress)
  glClear(GL_COLOR_BUFFER_BIT)

  # Fonts
  nk_font_atlas_init_default(ctx.atlas.addr)
  nk_font_atlas_begin(ctx.atlas.addr)
  
  var
    image: pointer
    w, h:  cint

  image = nk_font_atlas_bake(
    ctx.atlas.addr, w.addr, h.addr, NK_FONT_ATLAS_RGBA32)
    
  glGenTextures(1, ctx.atlasText.addr)
  glBindTexture(GL_TEXTURE_2D, ctx.atlasText)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR.GLint)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR.GLint)
  glTexImage2D(
    GL_TEXTURE_2D, 0, GLint(GL_RGBA), GLsizei(w), GLsizei(h),
    0, GL_RGBA, GL_UNSIGNED_BYTE, image)

  nk_font_atlas_end(
    ctx.atlas.addr, nk_handle_id(ctx.atlasText.cint), ctx.null.addr)

  if ctx.atlas.default_font != nil:
    nk_style_set_font(ctx.nkCtx.addr, ctx.atlas.default_font.handle.addr)
    
  # Callbacks
  discard glfw.setCharCallback(result,        onCharCB)
  discard glfw.setMouseButtonCallback(result, onMouseCB)
  discard glfw.setScrollCallback(result,      onScrollCB)

  winToCtx[result] = ctx
  
  if oldContext != nil:
    glfw.makeContextCurrent(oldContext)

proc nk_glfw_new_frame*(
    w:            glfw.Window,
    disableInput: bool) =
  glfw.makeContextCurrent(w)

  let
    ei    = not disableInput
    ctx   = getContext(w)
    nkCtx = ctx.nkCtx.addr

  glfw.getWindowSize(w, ctx.width.addr, ctx.height.addr)
  glfw.getFramebufferSize(w, ctx.display_width.addr, ctx.display_height.addr)
  ctx.fb_scale.x = ctx.display_width / ctx.width
  ctx.fb_scale.y = ctx.display_height / ctx.height
  
  nk_input_begin(nkCtx)

  # Chars
  if ei:
    for c in ctx.text: nk_input_unicode(nkCtx, c)
    
  # Grab
  if nkCtx.input.mouse.grab.bool:
    glfw.setInputMode(w, CursorModeConst, cmHidden.cint)
  elif nkCtx.input.mouse.ungrab.bool:
    glfw.setInputMode(w, CursorModeConst, cmNormal.cint)
    
  # Key press
  template isDown(key): bool =
    ei and glfw.getKey(w, key.cint) == kaDown.cint

  template setInput(keyA, keyB) =
    var p = false
    when keyB is array:
      for k in keyB: p = p or isDown(k)
    else:
      p = isDown(keyB)
    nk_input_key(nkCtx, keyA, nk_bool(p))

  setInput(NK_KEY_DEL, keyDelete)
  setInput(NK_KEY_ENTER, keyEnter)
  setInput(NK_KEY_TAB, keyTab)
  setInput(NK_KEY_BACKSPACE, keyBackspace)
  setInput(NK_KEY_UP, keyUp)
  setInput(NK_KEY_DOWN, keyDown)
  setInput(NK_KEY_TEXT_START, keyHome)
  setInput(NK_KEY_TEXT_END, keyEnd)
  setInput(NK_KEY_SCROLL_START, keyHome)
  setInput(NK_KEY_SCROLL_END, keyEnd)
  setInput(NK_KEY_SCROLL_DOWN, keyPageDown)
  setInput(NK_KEY_SCROLL_UP, keyPageUp)
  setInput(NK_KEY_SHIFT, [keyLeftShift, keyRightShift])

  if isDown(keyLeftControl) or isDown(keyRightControl):        
    setInput(NK_KEY_COPY,            keyC)
    setInput(NK_KEY_PASTE,           keyV)
    setInput(NK_KEY_CUT,             keyX)
    setInput(NK_KEY_TEXT_UNDO,       keyZ)
    setInput(NK_KEY_TEXT_REDO,       keyR)
    setInput(NK_KEY_TEXT_WORD_LEFT,  keyLeft)
    setInput(NK_KEY_TEXT_WORD_RIGHT, keyRight)
    setInput(NK_KEY_TEXT_LINE_START, keyB)
    setInput(NK_KEY_TEXT_LINE_END,   keyE)

  else:
    setInput(NK_KEY_LEFT,  keyLEFT)
    setInput(NK_KEY_RIGHT, keyRIGHT)
    nk_input_key(nkCtx, NK_KEY_COPY,  0)
    nk_input_key(nkCtx, NK_KEY_PASTE, 0)
    nk_input_key(nkCtx, NK_KEY_CUT,   0)
    nk_input_key(nkCtx, NK_KEY_SHIFT, 0)

  # Motion
  ctx.mouseMove = false
  var x, y: cdouble
  glfw.getCursorPos(w, x.addr, y.addr)
  if ei:
    nk_input_motion(nkCtx, x.cint, y.cint)
    if (x, y) != ctx.mouseLast:
      ctx.mouseLast = (x, y)
      ctx.mouseMove = true

  if nkCtx.input.mouse.grabbed.bool:
    glfw.setCursorPos(
      w,
      cdouble(nkCtx.input.mouse.prev.x),
      cdouble(nkCtx.input.mouse.prev.y))

    nkCtx.input.mouse.pos.x = nkCtx.input.mouse.prev.x
    nkCtx.input.mouse.pos.y = nkCtx.input.mouse.prev.y

  # Mouse
  template setInputButton(buttonA, buttonB) =
    let down = ei and glfw.getMouseButton(w, buttonB.cint) == kaDown.cint
    nk_input_button(nkCtx, buttonA, cint(x), cint(y), nk_bool(down))

  setInputButton(NK_BUTTON_LEFT, mbLeft)
  setInputButton(NK_BUTTON_MIDDLE, mbMiddle)
  setInputButton(NK_BUTTON_RIGHT, mbRight)

  nk_input_button(
    nkCtx,
    NK_BUTTON_DOUBLE,
    cint(ctx.doubleClickPos.x),
    cint(ctx.doubleClickPos.y),
    nk_bool(ctx.isDoubleClickDown))

  # Scroll
  nk_input_scroll(nkCtx, ctx.scroll)
  nk_input_end(nkCtx)

  setLen(ctx.text, 0)
  ctx.scroll = nk_vec2()

proc nk_glfw_render*(w: glfw.Window, force: bool) =
  glfw.makeContextCurrent(w)

  let
    ctx   = getContext(w)
    nkCtx = ctx.nkCtx.addr
    cmds  = nk_buffer_memory(nkCtx.memory.addr)

  # https://immediate-mode-ui.github.io/Nuklear/doc/nuklear.html#nuklear/api/drawing
  # 'After each frame you compare the draw command memory ...'
  if not force and equalMem(cmds, ctx.buf2, nkCtx.memory.allocated):
    nk_clear(nkCtx)
    return

  copyMem(ctx.buf2, cmds, nkCtx.memory.allocated)
  
  glClear(GL_COLOR_BUFFER_BIT)
  glClearColor(1.0, 1.0, 1.0, 1.0)
  
  glPushAttrib(GL_ENABLE_BIT or GL_COLOR_BUFFER_BIT or GL_TRANSFORM_BIT)
  glDisable(GL_CULL_FACE)
  glDisable(GL_DEPTH_TEST)
  glEnable(GL_SCISSOR_TEST)
  glEnable(GL_BLEND)
  glEnable(GL_TEXTURE_2D)
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)

  glViewport(0, 0, GLsizei(ctx.display_width), GLsizei(ctx.display_height))
  glMatrixMode(GL_PROJECTION)
  glPushMatrix()
  glLoadIdentity()
  glOrtho(0.0, GLDouble(ctx.width), GLDouble(ctx.height), 0.0, -1.0, 1.0)
  glMatrixMode(GL_MODELVIEW)
  glPushMatrix()
  glLoadIdentity()

  glEnableClientState(GL_VERTEX_ARRAY)
  glEnableClientState(GL_TEXTURE_COORD_ARRAY)
  glEnableClientState(GL_COLOR_ARRAY)

  block:
    let
      vp = offsetOf(nk_glfw_vertex, position)
      vt = offsetOf(nk_glfw_vertex, uv)
      vc = offsetOf(nk_glfw_vertex, col)

    # /* fill convert configuration */    
    template drawVertexLayoutElement(a, f, o): nk_draw_vertex_layout_element =
      nk_draw_vertex_layout_element(attribute: a, format: f, offset: o.nk_size)
    
    let vertex_layout: array[4, nk_draw_vertex_layout_element] = [
      drawVertexLayoutElement(
        NK_VERTEX_POSITION, NK_FORMAT_FLOAT, offsetOf(nk_glfw_vertex, position)),
      drawVertexLayoutElement(
        NK_VERTEX_TEXCOORD, NK_FORMAT_FLOAT, offsetOf(nk_glfw_vertex, uv)),
      drawVertexLayoutElement(
        NK_VERTEX_COLOR, NK_FORMAT_R8G8B8A8, offsetOf(nk_glfw_vertex, col)),
      NK_VERTEX_LAYOUT_END
    ]

    var config: nk_convert_config
    zeroMem(config.addr, sizeof(config))

    config.vertex_layout        = vertex_layout[0].unsafeAddr
    config.vertex_size          = sizeOf(nk_glfw_vertex).nk_size
    config.vertex_alignment     = alignOf(nk_glfw_vertex).nk_size
    config.circle_segment_count = 22
    config.curve_segment_count  = 22
    config.arc_segment_count    = 22
    config.global_alpha         = 1.0
    config.null                 = ctx.null
    config.shape_AA             = NK_ANTI_ALIASING_ON
    config.line_AA              = NK_ANTI_ALIASING_ON

    # /* convert shapes into vertexes */
    var vbuf, ebuf: nk_buffer
    nk_buffer_init_default(vbuf.addr)
    nk_buffer_init_default(ebuf.addr)

    doAssert NK_CONVERT_SUCCESS == nk_convert_result(nk_convert(
      nkCtx, ctx.cmds.addr, vbuf.addr, ebuf.addr, config.addr
    ))

    # /* setup vertex buffer pointer */
    block:
      let
        vs       = sizeOf(nk_glfw_vertex)
        vertices = nk_buffer_memory_const(vbuf.addr)

      glVertexPointer(
        2, cGL_FLOAT, GLSizei(vs), cast[pointer](cast[ByteAddress](vertices) + vp))
      glTexCoordPointer(
        2, cGL_FLOAT, GLSizei(vs), cast[pointer](cast[ByteAddress](vertices) + vt))
      glColorPointer(
        4, GL_UNSIGNED_BYTE, GLSizei(vs),
        cast[pointer](cast[ByteAddress](vertices) + vc))

    # /* iterate over and execute each draw command */    
    let indexList = cast[ptr[UncheckedArray[nk_draw_index]]](
      nk_buffer_memory_const(ebuf.addr))
    var i = 0
    for cmd in nk_draw_foreach(nkCtx, ctx.cmds.addr):
      if cmd.elem_count == 0: continue

      glBindTexture(GL_TEXTURE_2D, GLuint(cmd.texture.id))
      glScissor(
        GLint(cmd.clip_rect.x * ctx.fb_scale.x),
        GLint((ctx.height - GLint(cmd.clip_rect.y + cmd.clip_rect.h)).cfloat *
          ctx.fb_scale.y),
        GLint(cmd.clip_rect.w * ctx.fb_scale.x),
        GLint(cmd.clip_rect.h * ctx.fb_scale.y))
      glDrawElements(GL_TRIANGLES, GLsizei(cmd.elem_count), GL_UNSIGNED_SHORT,
                     indexList[i].addr)
      inc(i, cmd.elem_count.int)

    nk_clear(nkCtx)
    nk_buffer_clear(ctx.cmds.addr)
    nk_buffer_free(vbuf.addr)
    nk_buffer_free(ebuf.addr)

  # /* default OpenGL state */
  glDisableClientState(GL_VERTEX_ARRAY)
  glDisableClientState(GL_TEXTURE_COORD_ARRAY)
  glDisableClientState(GL_COLOR_ARRAY)

  glDisable(GL_CULL_FACE)
  glDisable(GL_DEPTH_TEST)
  glDisable(GL_SCISSOR_TEST)
  glDisable(GL_BLEND)
  glDisable(GL_TEXTURE_2D)

  glBindTexture(GL_TEXTURE_2D, 0)
  glMatrixMode(GL_MODELVIEW)
  glPopMatrix()
  glMatrixMode(GL_PROJECTION)
  glPopMatrix()
  glPopAttrib()

proc endFrame*(w: glfw.Window) =
  let ctx = getContext(w)
  
  # Mouse stuff
  template state(b): auto = ctx.mouseState[b]
  for mb in MouseButton:
    if state(mb) == msPress: state(mb) = msDown
    elif state(mb) == msRelease: state(mb) = msUp
    
proc nkContext*(w: glfw.Window): ptr[nk_context] =
  getContext(w).nkCtx.addr
  
template toBuffer*(
    maxLen: static[int],
    sep:    char,
    args:   varargs[string]): auto =

  block:
    var
      buffer: array[maxLen, char]
      total:  int
      b:      int

    for arg in args: 
      inc(total, len(arg))
      inc(total)
    doAssert total < maxLen
    
    for arg in args:
      for c in arg:
        buffer[b] = c
        inc(b)
      buffer[b] = sep
      inc(b)

    buffer[b] = '\0'

    buffer # 'return'
    
template withWindow*(
    w:       glfw.Window,
    size:    tuple[x, y, w, h: int],
    noInput: bool,
    action:  untyped) = 

  block:
    let ctx = getContext(w).nkCtx.addr
    
    var flags: cint
    template addFlag(f) =
      flags = flags or f.cint

    addFlag(NK_WINDOW_BORDER)
    addFlag(NK_WINDOW_NO_SCROLLBAR)
    if noInput: addFlag(NK_WINDOW_NO_INPUT)
    
    let rect = nk_rect(
      x: size[0].cfloat,
      y: size[1].cfloat,
      w: size[2].cfloat,
      h: size[3].cfloat)

    if nk_begin(ctx, "", rect, nk_flags(flags)).bool:
      action
    nk_end(ctx)

proc rowLayoutDynamic*(w: glfw.Window, len: int) =
  let ctx = getContext(w).nkCtx.addr
  nk_layout_row_dynamic(ctx, 0, len.cint)

proc rowLayoutSpaceBegin*(w: glfw.Window): tuple[x, y, w, h: int] =
  let ctx = getContext(w).nkCtx.addr
  nk_layout_space_begin(
    ctx, NK_STATIC, glfwSize(w).h.cfloat, 10_000)
  let r = nk_window_get_content_region(ctx)
  result = (r.x.int, r.y.int, r.w.int, r.h.int)

proc rowLayoutSpaceEnd*(w: glfw.Window) =
  let ctx = getContext(w).nkCtx.addr
  nk_layout_space_end(ctx)

var br: tuple[x, y: int]

proc rowLayoutSpace*(win: glfw.Window, x, y, w, h: int) =
  let ctx = getContext(win).nkCtx.addr
  nk_layout_space_push(
    ctx,
    nk_rect(
      x: (x - br.x).cfloat,
      y: (y - br.y).cfloat,
      w: w.cfloat,
      h: h.cfloat))

template withNestedRowLayout*(w: glfw.Window, c: int, body: untyped) =
  block:
    let ctx = getContext(w).nkCtx.addr
    nk_layout_row_begin(ctx, NK_DYNAMIC, 0, c) # height, widgets
    template push(p: float) = nk_layout_row_push(ctx, p) # % width
    body
    nk_layout_row_end(ctx)    

template withTree*(
    w:      glfw.Window,
    open:   var bool,
    text:   string,
    action: untyped) =
      
  block:
    let ctx = getContext(w).nkCtx.addr
    var collapse = (if open: NK_MAXIMIZED else: NK_MINIMIZED)
    
    if nk_tree_state_push(ctx, NK_TREE_NODE, text, collapse.addr).bool:
      action
      nk_tree_pop(ctx)

    open = collapse == NK_MAXIMIZED

template withGroup*(
    w:      glfw.Window,
    id:     string,
    action: untyped) =
  
  let ctx = getContext(w).nkCtx.addr

  var flags:  cint
  template addFlag(f) = flags = flags or f.cint
  addFlag(NK_WINDOW_BORDER)
  if nk_group_begin_titled(ctx, id, "", nk_flags(flags)).bool:
    action
    nk_group_end(ctx)
    
template withTab*(
    w:      glfw.Window,
    id:     string,
    region: tuple[x, y, w, h: int],
    a, b:   untyped) =
  block:
    let ctx = getContext(w).nkCtx.addr
    var flags: cint
    template addFlag(f) = flags = flags or f.cint
    addFlag(NK_WINDOW_BORDER)
    addFlag(NK_WINDOW_NO_SCROLLBAR)
    let oBr = br
    if nk_group_begin_titled(ctx, id, "", nk_flags(flags)).bool:
      nk_layout_space_begin(ctx, NK_STATIC, region.h.cfloat, 10_000)
      # Tabs
      discard nk_style_push_vec2(ctx, ctx.style.window.spacing.addr, nk_vec2())
      discard nk_style_push_float(ctx, ctx.style.button.rounding.addr, 0)
      br = (region.x, region.y)
      a
      discard nk_style_pop_float(ctx)
      discard nk_style_pop_vec2(ctx)
      # Content
      b
      reset(br)
      nk_layout_space_end(ctx)
      nk_group_end(ctx)
    br = oBr
    
proc showProgress*(
    w:              glfw.Window,
    v:              var float,
    modifiable:     bool,
    ):              bool =
  
  let ctx = getContext(w).nkCtx.addr
  var s = (v * 100).nk_size
  result = nk_progress(
    ctx, s.addr, 100, if modifiable: nk_true else: nk_false).bool

proc showSlider*(
    w:    glfw.Window,
    v:    var float,
    r:    Slice[float],
    step: float,
    ):    bool =

  let ctx = getContext(w).nkCtx.addr
  var s = v.cfloat
  result = nk_slider_float(
    ctx, r.a.cfloat, s.addr, r.b.cfloat, step.cfloat).bool
  if result: v = s.float

proc showRadio*(w: glfw.Window, label: string, active: bool): bool =
  let ctx = getContext(w).nkCtx.addr
  return nk_option_text(
    ctx, cstring(label), len(label).cint, active.nk_bool).bool

proc showCalendar*(
    w:        glfw.Window,
    id:       string,
    marked:   set[1..31],
    date:     var DateTime,
    ): bool =
  # TODO: NCalendar
  # https://github.com/Immediate-Mode-UI/Nuklear/blob/master/demo/overview.c#L482-L539
  let ctx = getContext(w).nkCtx.addr
  if not bool(nk_group_begin_titled(ctx, id, "", nk_flags(
        NK_WINDOW_NO_SCROLLBAR.nk_uint or
        NK_WINDOW_BORDER.nk_uint))):
    return

  var buffer = toBuffer(16, ' ', $month(date), $year(date))

  # Header (Left button, Month/Year, Right Button)
  nk_layout_row_begin(ctx, NK_DYNAMIC, 0, 3) # height, widgets

  block:
    template button(sym, op) =
      nk_layout_row_push(ctx, 0.1) # % width
      if nk_button_symbol(ctx, sym).bool:
        date = op(date, months(1))
        result = true
    
    # Prev Month
    button(NK_SYMBOL_TRIANGLE_LEFT, `-`)

    # Current Month
    nk_layout_row_push(ctx, 0.799999) # For some weird bug I cannot put 0.8
    nk_label(ctx, buffer[0].addr, NK_TEXT_CENTERED.nk_flags)
    
    # Next Month
    button(NK_SYMBOL_TRIANGLE_RIGHT, `+`)

  nk_layout_row_end(ctx)
  # -----------------------------------
  
  # Weekdays
  nk_layout_row_dynamic(ctx, 0, 7)
  for d in WeekDay:
    var buff = toBuffer(16, ' ', $d)
    for i in 0 .. 2: buff[i] = toUpperAscii(buff[i])
    for i in 3 .. high(buff): buff[i] = '\0'
    nk_label(ctx, buff[0].addr, NK_TEXT_CENTERED.nk_flags)
  # -----------------------------------
  
  # Monthdays
  nk_layout_row_dynamic(ctx, 20, 7)
  let md = date.monthday
  let s = getDayOfWeek(1, date.month, date.year).cint
  if s > 0: nk_spacing(ctx, s)
  for i in 1 .. getDaysInMonth(date.month, date.year):
    var
      buff  = toBuffer(4, ' ', $i)
      click = false
    
    if i in marked or i == md:
      var style = ctx.style.button

      if i in marked:
        style.border = 5.0
      if i == md:
        style.border_color.r += 60
        style.border_color.g += 60
        style.border_color.b += 60

      click = nk_button_label_styled(ctx, style.addr, buff[0].addr).bool

    else:
      click = nk_button_label(ctx, buff[0].addr).bool
        
    if click:
      date = initDateTime(i, date.month, date.year, 0, 0, 0)
      result = true
  
  # -----------------------------------
  
  nk_group_end(ctx)

template withBar*(
    win:      glfw.Window,
    entryLen: int,
    body1:    untyped) =

  block:
    let ctx = getContext(win).nkCtx.addr
    var closeThis = false

    nk_layout_row_begin(ctx, NK_STATIC, 25, entryLen.cint)
    
    template menuClose {.inject, used.} = nk_menu_close(ctx)

    template withBarEntry(
        label: string,
        size:  tuple[w, h: int],
        body2: untyped,
        )      {.inject.} =

      block:        
        nk_layout_row_push(ctx, cfloat(len(label) * 11))
        if nk_menu_begin_text(
            ctx,
            label,
            len(label).cint,
            nk_flags(NK_TEXT_LEFT),
            nk_vec2(x: size.w.cfloat, y: size.h.cfloat)).bool:

          nk_layout_row_dynamic(ctx, 25, 1)
          body2
          nk_menu_end(ctx)

    body1
    nk_layout_row_end(ctx)
    nk_menubar_end(ctx)

proc showMenuItemLabel*(w: glfw.Window, label: string): bool =
  let ctx = getContext(w).nkCtx.addr
  result = nk_menu_item_text(
    ctx, label, len(label).cint, nk_flags(NK_TEXT_LEFT)).bool

proc initImage*(data: pointer, w, h: int): uint32 =
  glGenTextures(GLsizei(1), addr(result))
  glBindTexture(GL_TEXTURE_2D, result)
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1)

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST.GLint)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST.GLint)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE.GLint)
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE.GLint)

  glTexImage2D(GL_TEXTURE_2D, GLint(0), GLint(GL_RGBA8),
  GLsizei(w), GLsizei(h), GLint(0), GL_RGBA, GL_UNSIGNED_BYTE, data)

proc updateImage*(oldId: uint32, data: pointer, w, h: int): uint32 =
  glBindTexture(GL_TEXTURE_2D, oldId)
  glTexSubImage2D(GL_TEXTURE_2D, GLint(0),
    GLint(0), GLint(0), GLSizei(w), GLSizei(h),
    GL_RGBA, GL_UNSIGNED_BYTE, data)
  
  return oldId
