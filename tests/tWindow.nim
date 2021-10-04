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

  doAssert w1.resizable,          "Window Resizable default == true"

  w1.text      = title
  w1.resizable = false

  add(app, w1)

  doAssert parent(w1) == app,     "Window parent is app"
  doAssert not(visible(w1)),      "Window Visible default == false"

  laterDo 0:
    doAssert visible(w1),        "Window Visible on run default == true"
    doAssert not(resizable(w1)), "Window resizable set false"
    doAssert w1.text == title,   "Window title set to " & title
    stop(app)

  run(app)


when isMainModule:
  testWindow()