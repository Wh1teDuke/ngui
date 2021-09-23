
# e13.nim: simple random widgets example

import ngui, os


proc main =
  let app = app()

  # Tabs ===
  let tab = tab()
  
  # P1
  let progress = progress()
  let textArea = textArea("\nWrite a book here")
  let list = list()
  
  let tabPage1 = vbox(
    progress, label("Time left before we move on"), textArea, list)

  for i in 1 .. 10: list.add(label("Item " & $i))
  list.onChangeDo:
    echo "Selected: ", list.selected

  textArea.onChangeDo: echo "Changed"
  textArea.size = (w: 300, h: 50)
  progress.size = (w: 300, h: 30)

  # P2
  let tabPage2 = vbox(
    slider(), label("0"), button("Choose File"), label(""))

  tabPage2[0].onChangeDo:
    Label(this.next).text = $Slider(this).value.int

  tabPage2[2].onClickDo:
    fileChoose() do:
      let files = currentEvent().files

      Label(tabPage2[3]).text =
        (if len(files) > 0: files[0] else: "")

      echo Label(tabPage2[3]).text

  tab.add(tabPage1, label("Main Content"))
  tab.add(named(tabPage2, "More Stuff"))
  tab.reorderable = on
  tab.side = nsLEFT

  doAssert tab.index(tabPage1) == 0
  doAssert tabPage1.index == 0
  
  # Status ===
  let status = label("Done")
  let statusBorder = box(status)
  
  statusBorder.border      = 2
  statusBorder.borderColor = pixel(50, 100, 150)
  statusBorder.bgColor     = pixel(0.8, 0.6, 0.6)

  var s = 0.0
  discard repeatDo 100:
    if progress.value >= 1: quit()
    progress.value = progress.value + s
    s += 0.00001
    status.text = "Progress " & $int(progress.value * 100) & "%"

  # App ===
  add(app, tab, statusBorder)
  app[0].icon = bitmap(currentSourcePath() / ParDir / "assets" / "icon1.png")

  app[0].onFocusOffDo: echo "FocusOff"
  app[0].onFocusOnDo: echo "FocusOn"
  app[0].onKeyPressDo:
    if event.key == nkV: eventHandled() # Won't propagate to textArea
    elif event.key == nkEsc: stop(app)
    else: echo "P: ", event.key # currentEvent()

  app[0].onKeyReleaseDo:
    echo "R: ", event.key

  textArea.focus
  run(app)

main()