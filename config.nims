mode = ScriptMode.Verbose

const
  target = "c2lora"
  binDir = "build"
  srcDir = "src"

# Compiler options
switch("arm.any.gcc.options.always", "-w -fmax-errors=4 -march=armv7e-m -mtune=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffunction-sections -fdata-sections")
switch("arm.any.gcc.options.linker", "-w -march=armv7e-m -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -T linkers/nrf52.ld -o build/c2lora.elf -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections")

# Embedded Artistry Libc
# switch("passL","deps/libc/libc.a")

# Nim cache directory
switch("nimcache", "build/nimcache")

# Optimization
when defined(release):
  switch("opt", "size")

# Nim-compiler options:
switch("os", "any")
switch("cpu", "arm")
switch("cc", "gcc")
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
when defined(debug):
  switch("debugger", "native")
  switch("debuginfo", "on")
  switch("lineDir", "on")
else:
  switch("debugger", "off")
  switch("debuginfo", "off")
  switch("lineDir", "off")
  switch("passL", "-Wl,--strip-debug")
# switch("passL", "-Wl,-Map=build/c2lora.map")

# Preferences
switch("styleCheck", "usages")  # prohibit flexible capitalization of identifiers
switch("styleCheck", "error")

import std/os

let buildDeps = [
  "deps" / "svd" / "build.nims"
]

task build, "Build the project (debug by default)":
  let mode = if paramCount() > 1: paramStr(2) else: "debug"

  var pathFlags = ""
  var modeFlags = ""

  case mode
  of "debug":
    modeFlags = " -d:debug"
  of "release":
    modeFlags = " -d:release"
  else:
    quit("Unknown build mode: " & mode & " (use 'debug' or 'release')")

  # Build dependencies first
  for dep in buildDeps:
    exec "nim --skipParentCfg " & dep
    pathFlags.add(" --path:" & dep.parentDir())

  # Build main project
  exec "nim c" & pathFlags & modeFlags &
       " --arm.any.gcc.exe:arm-none-eabi-gcc" &
       " --arm.any.gcc.linkerexe:arm-none-eabi-gcc " &
       srcDir / target & ".nim"

  # Post-build steps
  let buildPath = binDir / target
  exec "arm-none-eabi-objcopy -O binary " & buildPath & ".elf " & buildPath &
       ".bin"

  let objdumpOutput = gorgeEx("arm-none-eabi-objdump -D " & buildPath & ".elf")
  writeFile(buildPath & "-objdump.txt", objdumpOutput.output)

  exec "python3 deps/uf2/utils/uf2conv.py --base 0x26000 --family NRF52840 " &
       buildPath & ".bin --output " & buildPath & ".uf2 --convert"

task clean, "Clean build artifacts":
  rmDir(binDir)

task load, "Load UF2 file to the device":
  let uf2Path = binDir / target & ".uf2"
  if not fileExists(uf2Path):
    quit("UF2 file not found. Please build the project first.")
  exec "python3 deps/uf2/utils/uf2conv.py --deploy " & uf2Path