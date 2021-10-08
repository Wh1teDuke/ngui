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

  doAssert w1.resizable,          "Window Resizable default == true"

  w1.text      = title
  w1.resizable = false

  add(app, w1)

  doAssert parent(w1) == app,     "Window parent is app"
  doAssert not(visible(w1)),      "Window Visible default == false"
  doAssert w1.position != p,      "Window position not set"
  doAssert opacity(w1) == 1.0,    "Window default opacity is 1.0"
  w1.position = p

  laterDo 0:
    doAssert visible(w1),         "Window Visible on run default == true"
    doAssert not(resizable(w1)),  "Window resizable set false"
    doAssert w1.text == title,    "Window title set to " & title
    doAssert w1.position == p,    "Window position set"
    doAssert w1.x == p.x,         "X coord comparison"
    doAssert w1.y == p.y,         "Y coord comparison"
    stop(app)

  run(app)


when isMainModule:
  testWindow()