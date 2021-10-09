import ngui
import tApp
import tWindow


proc main =
  doAssert requiredLibsInstalled(), "Libraries not installed for this backend"
  testApp()
  testWindow()

when isMainModule:
  main()