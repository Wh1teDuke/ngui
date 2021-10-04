import ngui


proc testApp* =
  # --> Init
  doAssert not(ngui.initialized()),          "App is not initialized"
  doAssert not(ngui.running()),              "App is not running"
  let app = app()
  doAssert ngui.initialized(),               "App is initialized"
  doAssert not(ngui.running()),              "App is running"
  
  # --> 'laterDo' works
  var laterDoWorks = false
  laterDo 0:
    doAssert not(laterDoWorks),              "laterDo payload first time"
    laterDoWorks = true
    stop(app)

  doAssert not(laterDoWorks),                "laterDo payload not executed yet"
  run(app)
  doAssert laterDoWorks,                     "laterDo payload executed"

  # --> Repeat (Run, Stop)
  for _ in 1 .. 10:
    doAssert ngui.initialized(),             "App is initialized"
    laterDo 0:
      doAssert ngui.running(),               "App is running"
      stop(app)
    doAssert not(ngui.running()),            "App is not running"
    run(app)
    doAssert not(ngui.running()),            "App is stopped"

  # --> Retrieve window
  let w1, w2, w3 = window()
  add(app, w1, w2, w3)

  doAssert app[+0] == w1,                    "Test app first child"
  doAssert app[+1] == w2,                    "Test app second child"
  doAssert app[+2] == w3,                    "Test app this child"

  doAssert app[^3] == w1,                    "Test app first child  (Backwards)"
  doAssert app[^2] == w2,                    "Test app second child (Backwards)"
  doAssert app[^1] == w3,                    "Test app third child  (Backwards)"
  
  # --> Kill App
  shutdown(app)
  doAssert not(ngui.initialized()),          "App is shutdown"
  doAssert not(ngui.running()),              "App is stopped"

when isMainModule:
  testApp()