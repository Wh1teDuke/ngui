
# e6.nim: Simple grid example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let grid = grid()
  
  for i in 0 .. 9:
    grid.add(label("I'm number " & $succ(i)))

  for i in 0 .. 9:
    let label = label("I'm letter " & char(i + int('A')))
    grid.add(label, row = i, column = 2)

  app.add(grid)
  # NEVER add new elements to app after run()
  run(app)
  
main()
