import ../ngui
import os


type
  NIcon* = enum
    niFOLDER
    #niFOLDER_LINK
    niFILE
    niFILE_LINK
    niFILE_OPEN
    niEXECUTABLE


proc iconBitmap*(icon: NIcon): Bitmap =
  const IMGS = (proc: auto = 
    var list: array[NIcon, string]

    const BASE_DIR =
      currentSourcePath() / ParDir / ParDir / ParDir / "assets" / "icons"

    template set(i, f) =
      list[i] = readFile(BASE_DIR / f)
    
    set(niFOLDER,     "tabler-icon-folder.png")
    set(niFILE,       "tabler-icon-file.png")
    set(niFILE_LINK,  "tabler-icon-file-symlink.png")
    set(niFILE_OPEN,  "tabler-icon-file-import.png")
    set(niEXECUTABLE, "tabler-icon-terminal-2.png")

    return list
  )()

  return newBitmap(IMGS[icon])
