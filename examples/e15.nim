
# e15: Tree example

import ngui


proc main =
  let app = app()
  let tree = tree([(ckInt, "Field1"), (ckInt, "Field2"), (ckInt, "Field3")])

  # --------------------
  tree.row(1, 2, 3)            # 0
  # |
  tree.row(4, 5, 6)            # 1
  # |__
  tree.row([1], 7, 8, 9)       # 1,0
  #    |
  tree.row([1], 10, 11, 12)    # 1,1
  # |
  tree.row(123, 456, 575)      # 2
  # |__
  tree.row([2], 678, 999, 777) # 2,0
  # |  |__
  tree.row([2,0], 404, 505, 666)

  doAssert tree.headers

  let
    button1 = button("Get Last Value")
    button2 = button("Set Last Value")

  button1.onClickDo:
    echo tree[[2, 0, 0], 2]
  button2.onClickDo:
    tree[[2, 0, 0], 2]= 999

  add(app, tree, button1, button2)
  run(app)

main()