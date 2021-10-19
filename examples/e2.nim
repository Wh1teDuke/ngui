
# e2.nim: Simple Window example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  app.add(window("e2")) # getApp().add(window("e2"))

  app[0].onKeyPressDo:
    if event.key == nkEsc: stop(app)

  doAssert app[0].text == "e2"
  doAssert app[0] == app[^1]
  doAssert app[0] of Window
  doAssert NElement(app) != NElement(app[0])

  # NEVER add new elements to app after run()
  run(app)
  
main()
