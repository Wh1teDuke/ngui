
# e10.nim: Simple alert example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let window = window("e10: Alert")
  let button = button("Show Alert")
  
  button.onClickDo:
    alert(parent = window, "Hello stranger")

  window.add(button)
  app.add(window)
  # NEVER add new elements to app after run()
  run(app)

main()
