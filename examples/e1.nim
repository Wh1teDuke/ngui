
# e1.nim: Simple App example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  
  doAssert app[0] == nil
  doAssert app[0] == app[^1]
  doAssert app == getApp()
  doAssert app of App
  doAssert app of neApp

  echo "Won't display anything, cancel with control + c"
  # NEVER add new elements to app after run()
  run(app)
  
main()
