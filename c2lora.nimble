# Package

version       = "0.1.0"
author        = "!!Dean"
description   = "Codec 2 over LoRa"
license       = "MIT"
srcDir        = "src"
bin           = @["c2lora"]


# Dependencies

requires "nim >= 2.2.0"

# Custom Build Tasks

task firmware, "Build Firmware":
    exec "nim c --skipCfg --out:build/c2lora.elf src/c2lora.nim"

task hex, "Build Firmware and convert to hex":
    exec "nimble firmware"
    exec "arm-none-eabi-objcopy -O ihex build/c2lora.elf build/c2lora.hex"