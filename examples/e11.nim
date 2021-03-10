
# e11.nim: simple bar/menu example

import ngui


proc main =
  # ALWAYS start with app()
  let app = app()
  let bar = bar()
  let menu, submenu = menu()

  menu.add(label("Menu1"), NSEPARATOR, label("Menu2"), label("Exit"))
  menu[1].onClickDo: echo "Menu2!" # Separator is not a real Element
  menu[2].onClickDo: quit()

  submenu.add(label("submenu1"), label("submenu2"))
  
  menu[0].add(submenu)

  menu.onOpenDo: echo "Menu open"

  submenu[0].onClickDo: echo "SubMenu1"
  submenu[1].onClickDo: echo "SubMenu2"

  bar.add(add(label("MyMenu"), menu))
  app.add(bar, calendar())
  
  # NEVER add new elements to app after run()
  run(app)

main()
