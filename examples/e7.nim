
# e7.nim: Simple entry example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let entry = entry("Press Enter")

  entry.onChangeDo(echo("Change: ", entry.text))
  entry.onEnterDo(echo("Enter: ", entry.text))

  app.add(entry)
  # NEVER add new elements to app after run()
  run(app)

main()
