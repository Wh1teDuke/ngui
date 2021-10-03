import ngui


proc testApp* =
  let app = app()

  # --> Repeat (Run, Stop)
  for _ in 0 .. 10:
    laterDo(0, stop(app))
    run(app)

when isMainModule:
  testApp()