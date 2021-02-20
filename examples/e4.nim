
# e4.nim: Simple radio in group example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let radios = [radio("radio1"), radio("radio2"), radio("radio3")]
  group(radios)
  
  for r in radios:
    r.onClickDo:
      echo this.text

    #[ v--- Valids too
    closureScope:
      let this = r
      r.onClick((proc(){.closure.} = echo this.text))
    closureScope:
      let this = r
      r.onEvent(neClick, (proc(){.closure.} = echo this.text))
    ]#
  
  app.add(radios)
  # NEVER add new elements to app after run()
  run(app)
  
main()
