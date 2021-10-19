import ngui


proc testWindow* =
  # --> NElement creation without app init not allowed
  var crash = false
  try:    discard window()
  except: crash = true
  doAssert crash,                 "Cannot create window without an active App"

  # --> Show window on run, and some properties
  let
    app   = app()
    w1    = window()
    title = "tWindow"
    p     = (x: 50, y: 50)
    icon  = iconBitmap(niEXECUTABLE)

  doAssert w1.resizable,          "Window Resizable default == true"

  w1.text      = title
  w1.resizable = false

  add(app, w1)

  doAssert icon(w1) == nil,       "Window icon is nil"
  doAssert parent(w1) == app,     "Window parent is app"
  doAssert not(visible(w1)),      "Window Visible default == false"
  doAssert w1.position != p,      "Window position not set"
  doAssert opacity(w1) == 1.0,    "Window default opacity is 1.0"
  doAssert decorated(w1),         "Window decorated by default"
  doAssert not(w1.minimized),     "Window not minimized by default"
  doAssert not(w1.maximized),     "Window not maximized by default"
  doAssert not(w1.modal),         "Window not modal by default"

  w1.position  = p
  w1.icon      = icon
  w1.opacity   = 0.5
  w1.decorated = false

  laterDo 0: # TODO: 'replace this laterDo 0' with 'onStart' events
    doAssert visible(w1),         "Window Visible on run default == true"
    doAssert not(resizable(w1)),  "Window resizable set false"
    doAssert w1.text == title,    "Window title set to " & title
    doAssert w1.position == p,    "Window position set"
    doAssert w1.x == p.x,         "X coord comparison"
    doAssert w1.y == p.y,         "Y coord comparison"
    doAssert w1.icon == icon,     "Window icon set"
    doAssert not(w1.decorated),   "Window decorated off"
    doAssert w1.opacity - 0.5 in -0.005 .. +0.005,
                                  "Window opacity set"
    w1.maximized = true
    doAssert w1.maximized,        "Window maximized"
    
    w1.minimized = true
    doAssert w1.minimized,        "Window minimized"
    stop(app)

  run(app)


when isMainModule:
  testWindow()