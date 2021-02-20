
# e14.nim: Simple table/toolbar example

import ngui, os


proc main =
  let (app, tools, table) = (app(), tools(), table())
  let (b1, b2) = (button("Toggle values"), button("Hide headers"))
  let box = hbox()
  
  table.head("Index", "Active", "Name")
  table.row(1, true, "Foo")
  table.row(2, true, "Bar")
  table.row(3, false, "Baz")

  b1.onClickDo:
    const (p1, p2) = ((1, 0), (2, 1)) # X,Y
    cell(table, p1): ofBool b: table[p1]= not b
    cell(table, p2): ofStr  s: table[p2]= s[2..^1] & s[0..1]
    # cell(table, 1, 0): ofBool b: table[1, 0]= not b <-- valid too

  b2.onClickDo:
    table.headers = not table.headers
    b2.text = ["Show", "Hide"][int(table.headers)] & " headers"
  
  let (bt1, bt2) = (button(niFile), button(niFolder))
  tools.orientation = noVertical
  tools.add(bt1, NSEPARATOR, bt2)
  
  bt1.onClickDo:
    let bubble = bubble(button(niExecutable))
    bubble.attach(bt1)
    bubble[0].onClickDo: 
      discard execShellCmd("examples" / ("e14" & ExeExt))
  
  bt2.onClickDo:
    bubble(
      box(
        label("I don't really\lhave a purpose"),
        image(currentSourcePath() / ParDir / "assets" / "icon1.png")))
      .attach(bt2, destroyAfterMs = 1500)

  box.add(tools, NSEPARATOR, table)

  app.add(box, NSEPARATOR, b1, b2)
  run(app)
  
main()
