
# e5.nim: Simple box example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let box = box() # vbox, hbox, box(bdHORIZONTAL/bdVERTICAL)
  
  let button1 = button("Hello")
  let button2 = button("Now")

  button1.onClickDo(echo(this.text, " World"))
  button2.onClickDo(echo(this.text, " Die"))
  
  box.add(button1, button2) # box.add([button1, button2]) # Valid too
  app.add(box)
  # NEVER add new elements to app after run()
  run(app)
  
main()
