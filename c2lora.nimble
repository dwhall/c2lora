# Package

version       = "0.1.0"
author        = "!!Dean"
description   = "Codec 2 over LoRa"
license       = "MIT"
srcDir        = "src"
binDir        = "build"
bin           = @["c2lora"]


# Dependencies

requires "nim >= 2.2.0"

# Custom Build Tasks
import os

proc joinPath(parts: varargs[string]): string =
  let dirSep = when defined(windows): "\\" else: "/"
  result = parts.join(dirSep)

let buildDeps = [
  joinPath("deps", "svd", "build.nims")
]

before build:
  for dep in buildDeps:
    exec "nim --skipParentCfg " & dep

after build:
  let buildPath = binDir / bin[0]
  exec("arm-none-eabi-objcopy -O binary " & buildPath & ".elf " & buildPath & ".bin")
  exec("python3 deps/uf2/utils/uf2conv.py " & buildPath & ".elf --output " & buildPath & ".uf2")

before clean:
  rmDir(binDir)
  quit(0)