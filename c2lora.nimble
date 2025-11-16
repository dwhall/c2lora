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

after build:
  let buildPath = binDir / bin[0]
  when defined(windows):
    mvFile(buildPath & ".exe", buildPath & ".elf")
  else:
    mvFile(buildPath, buildPath & ".elf")
  exec("arm-none-eabi-objcopy -O ihex " & buildPath & ".elf " & buildPath & ".hex")
  exec("arm-none-eabi-objcopy -O binary " & buildPath & ".elf " & buildPath & ".bin")

before clean:
  rmDir(binDir)
  quit(0)