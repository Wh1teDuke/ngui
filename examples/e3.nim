
# e3.nim: Simple button example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let b = button("Click me if you dare", onEventClickDo = (echo "Miserable!"))
  b.tooltip = "Don't you dare"
  # b.onClick((proc(){.closure.} = echo "Miserable!")) # <-- Valid too
  # b.onEvent(neClick, (proc(){.closure.} = echo "Miserable!")) # <-- Valid too
  app.add(b)
  # NEVER add new elements to app after run()
  run(app)
  
main()
