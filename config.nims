mode = ScriptMode.Verbose

version       = "0.1.0"
author        = "Dean"
description   = "Codec 2 over LoRa"
license       = "MIT"
srcDir        = "src"
binDir        = "build"
bin           = @["c2lora"]

# Dependencies
requires "nim >= 2.2.0"

# Compiler options
switch("arm.any.gcc.options.always", "-w -fmax-errors=4 -march=armv7e-m -mtune=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffunction-sections -fdata-sections")
switch("arm.any.gcc.options.linker", "-w -march=armv7e-m -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -T linkers/nrf52.ld -o build/c2lora.elf -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections")

# Embedded Artistry Libc
# switch("passL","deps/libc/libc.a")

# Nim cache directory
switch("nimcache", "build/nimcache")

# Optimization
switch("opt", "size")

# Nim-compiler options:
switch("os", "any")
switch("cpu", "arm")
switch("mm", "arc")
switch("panics", "on")  # requires local panicoverride.nim
switch("threads", "off")
switch("profiler", "off")
switch("checks", "off")
switch("assertions", "off")
switch("stackTrace", "off")
switch("lineTrace", "off")
switch("exceptions", "goto")

switch("define", "useMalloc")
switch("define", "noSignalHandler")
switch("define", "nimAllocPagesViaMalloc")  # requires mm:arc or mm:orc
switch("define", "nimPage512")
switch("define", "nimMemAlignTiny")

# Experimental
# switch("define", "nimPreviewSlimSystem")  # https://nim-lang.org/blog/2022/12/21/version-20-rc.html

# Debugging
# switch("debugger", "native")
# switch("passL", "-Wl,-Map=build/c2lora.map")

# Preferences
switch("styleCheck", "usages")  # prohibit flexible capitalization of identifiers
switch("styleCheck", "error")

import std/os

# Build dependencies
let buildDeps = [
  "deps" / "svd" / "build.nims"
]

# Build task
task build, "Build the project":
  var pathFlags = ""

  # Build dependencies first
  for dep in buildDeps:
    exec "nim --skipParentCfg " & dep
    pathFlags.add(" --path:" & dep.parentDir())

  # Build main project
  exec "nim c" & pathFlags & " --arm.any.gcc.exe:arm-none-eabi-gcc" &
       " --arm.any.gcc.linkerexe:arm-none-eabi-gcc " & srcDir / bin[0] & ".nim"

  # Post-build steps
  let buildPath = binDir / bin[0]
  exec "arm-none-eabi-objcopy -O binary " & buildPath & ".elf " & buildPath &
       ".bin"

  let objdumpOutput = gorgeEx("arm-none-eabi-objdump -D " & buildPath & ".elf")
  writeFile(buildPath & "-objdump.txt", objdumpOutput.output)

  exec "python3 deps/uf2/utils/uf2conv.py --base 0x26000 --family NRF52840 " &
       buildPath & ".bin --output " & buildPath & ".uf2 --convert"

# Clean task
task clean, "Clean build artifacts":
  rmDir(binDir)