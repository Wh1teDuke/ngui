
# e6.nim: Simple List Example

import ngui

proc main =
  # ALWAYS start with app()
  let app = app()
  let list = list()
  
  for i in 0 .. 9:
    list.add(label("I'm number " & $succ(i)))

  app.add(list)
  
  
  list.onClickDo:
    echo Label(list.selected[0]).text
  
  # NEVER add new elements to app after run()
  run(app)
  
main()
