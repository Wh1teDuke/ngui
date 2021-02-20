import cairo
# from opengl import
include "cairo_pragma.nim"
const
  CAIRO_HAS_GLX_FUNCTIONS = false
  CAIRO_HAS_WGL_FUNCTIONS = false
  CAIRO_HAS_EGL_FUNCTIONS = false
proc surfaceCreate*(device: Device; content: Content;
                          width: cint; height: cint): Surface {.
    importc: "cairo_gl_surface_create", libcairo.}
proc surfaceCreateForTexture*(abstractDevice: Device;
                                    content: Content; tex: cuint;
                                    width: cint; height: cint): Surface {.
    importc: "cairo_gl_surface_create_for_texture", libcairo.}
proc setSize*(surface: Surface; width: cint; height: cint) {.
    importc: "cairo_gl_surface_set_size", libcairo.}
proc getWidth*(abstractSurface: Surface): cint {.
    importc: "cairo_gl_surface_get_width", libcairo.}
proc getHeight*(abstractSurface: Surface): cint {.
    importc: "cairo_gl_surface_get_height", libcairo.}
proc swapbuffers*(surface: Surface) {.
    importc: "cairo_gl_surface_swapbuffers", libcairo.}
proc setThreadAware*(device: Device;
                                 threadAware: CairoBoolT) {.
    importc: "cairo_gl_device_set_thread_aware", libcairo.}
when CAIRO_HAS_GLX_FUNCTIONS:
  proc deviceCreate*(dpy: ptr Display; glCtx: GLXContext): Device {.
      importc: "cairo_glx_device_create", libcairo.}
  proc getDisplay*(device: Device): ptr Display {.
      importc: "cairo_glx_device_get_display", libcairo.}
  proc getContext*(device: Device): GLXContext {.
      importc: "cairo_glx_device_get_context", libcairo.}
  proc surfaceCreateForWindow*(device: Device; win: Window;
                                     width: cint; height: cint): Surface {.
      importc: "cairo_gl_surface_create_for_window", libcairo.}
when CAIRO_HAS_WGL_FUNCTIONS:
  proc deviceCreate*(rc: Hglrc): Device {.
      importc: "cairo_wgl_device_create", libcairo.}
  proc getContext*(device: Device): Hglrc {.
      importc: "cairo_wgl_device_get_context", libcairo.}
  proc surfaceCreateForDc*(device: Device; dc: Hdc; width: cint;
                                 height: cint): Surface {.
      importc: "cairo_gl_surface_create_for_dc", libcairo.}
when CAIRO_HAS_EGL_FUNCTIONS:
  proc deviceCreate*(dpy: EGLDisplay; egl: EGLContext): Device {.
      importc: "cairo_egl_device_create", libcairo.}
  proc surfaceCreateForEgl*(device: Device; egl: EGLSurface;
                                  width: cint; height: cint): Surface {.
      importc: "cairo_gl_surface_create_for_egl", libcairo.}
  proc getDisplay*(device: Device): EGLDisplay {.
      importc: "cairo_egl_device_get_display", libcairo.}
  proc getContext*(device: Device): EGLSurface {.
      importc: "cairo_egl_device_get_context", libcairo.}
