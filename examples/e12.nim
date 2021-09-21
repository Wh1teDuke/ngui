
# e12.nim: simple image example

import std/[os, math, strutils, random], ngui


proc main =
  echo "I've been waiting for you ..."
  randomize()

  let imgPath = currentSourcePath() / ParDir / "assets" / "img1.jpg"
  let app = app()
  let image = image(imgPath) # image(bitmap(imgPath))
  let copy = image.bitmap.copy

  var t: float = 200 # ms
  var r = [1u8,2,3]
  shuffle(r)

  image.onClickDo:
    echo("Click: ", (x: event.x, y: event.y, m: event.mouse))
  image.onMoveDo:
    echo("Move: ", (x: event.x, y: event.y, m: event.mouse))
  image.onClickReleaseDo:
    echo("Release: ", (x: event.x, y: event.y, m: event.mouse))
  app.add(image)
  
  var stopRep = false
  app[0].onKeyPressDo:
    if event.key == nkEsc: quit()
    if nkControl in event.mods and event.key == nkV:
      clipboardAsyncGet proc(this: Bitmap) =
        if this == nil: return
        image.bitmap = this
        image.size = this.size
    if nkControl in event.mods and event.key == nkS:
      doAssert image.bitmap.save("img_" & $rand(100 .. 200) & ".png")
    if nkControl in event.mods and event.key == nkD:
      stopRep = true

  discard repeatDo t.int:
    let bitmap = image.bitmap

    for p in mitems(bitmap):
      p = pixel(p.r + r[0], p.g + r[1], p.b + r[2], p.a)

    t = max(20, t * 0.99)
    image.update()

    if not bool(rand(212)): shuffle(r)

    if copy[0] == bitmap[0] or stopRep:
      image.bitmap = copy
      stop() # return off

    setTime(ceil(t).int)

  run(app)

main()
