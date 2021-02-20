
# e8.nim: Simple Combobox/Checkbox example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let b1 = comboBox("Foo", "Bar", "FileNotFound", selected = 1)
  let b2 = checkbox("Debug Combobox", true)

  b1.onChangeDo:
    if b2.checked:
      echo "Selected ", b1.index, ": ", b1.selected
  
  b2.onChangeDo:
    echo "Debug is ", ["off", "on"][int(b2.checked)]

  app.add(b1, b2)
  # NEVER add new elements to app after run()
  run(app)

main()
