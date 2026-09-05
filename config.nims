#!fmt: off

import os, strformat

mode = ScriptMode.Verbose

const
  entryModule = "main"
  binDir = "build"
  srcDir = "src"
  platform = "nrf52" # must match a case in plat.nim

# Compiler options
switch("arm.any.gcc.options.always", "-w -fmax-errors=4 -march=armv7e-m -mtune=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -ffunction-sections -fdata-sections")
switch("arm.any.gcc.options.linker", fmt"-w -march=armv7e-m -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -T linkers/{platform}.ld -o build/{entryModule}.elf -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections")

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

# Debugging
when defined(debug):
  when defined(macosx):
    switch("passC", "-g")  # embed DWARF debug info directly in ELF
  else:
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

proc uglyFixGetHomeDir(): string =
  result = getHomeDir()
  if result.len < 2:
    result = getEnv("USERPROFILE")

proc buildPathFlags(): string =
  result = " --NimblePath:\"" & uglyFixGetHomeDir() & ".nimble" / "pkgs2\""
  for dep in buildDeps:
    result.add(" --path:" & dep.parentDir())
  result.add(" --path:src" / "plat ")
  result.add(" --path:src" / "proj ")

proc buildDefines(): string =
  let mode = if paramCount() > 1: paramStr(2) else: "debug"
  result = case mode
    of "debug":
      " -d:debug"
    of "release":
      " -d:release"
    else:
      quit("Unknown build mode: " & mode & " (use 'debug' or 'release')")
  # define the platform
  result.add(fmt" -d:platform={platform} ")

task build, "Build the project (debug by default)":
  # Build dependencies first
  for dep in buildDeps:
    exec "nim --skipParentCfg " & dep

  # Build main project
  let gccExe = findExe("arm-none-eabi-gcc")
  if gccExe == "":
    quit("arm-none-eabi-gcc not found in PATH")
  let gccPath = '"' & gccExe.parentDir() & "/\""
  exec "nim c" &
       buildPathFlags() &
       buildDefines() &
       " --arm.any.gcc.path:" & gccPath &
       " --arm.any.gcc.exe:arm-none-eabi-gcc" &
       " --arm.any.gcc.linkerexe:arm-none-eabi-gcc " &
       srcDir / entryModule & ".nim"

  # Post-build steps
  let buildPath = binDir / entryModule
  exec "arm-none-eabi-objcopy -O binary " & buildPath & ".elf " & buildPath &
       ".bin"

  let objdumpOutput = gorgeEx("arm-none-eabi-objdump -D " & buildPath & ".elf")
  writeFile(buildPath & "-objdump.txt", objdumpOutput.output)
  echo "Objdump output written to " & buildPath & "-objdump.txt"

  exec "python3 deps/uf2/utils/uf2conv.py --base 0x26000 --family NRF52840 " &
       buildPath & ".bin --output " & buildPath & ".uf2 --convert"

task clean, "Clean build artifacts":
  rmDir(binDir)

task load, "Load UF2 file to the device":
  let uf2Path = binDir / entryModule & ".uf2"
  if not fileExists(uf2Path):
    quit("UF2 file not found. Please build the project first.")
  exec "python3 deps/uf2/utils/uf2conv.py --deploy " & uf2Path

task gendot, "Generate DOT file from module dependencies":
  exec "nim genDepend " & buildPathFlags() & buildDefines() & srcDir / entryModule & ".nim"
  exec "nim --skipParentCfg r tools/dotCompactor.nim < src/c2lora.dot > src/c2lora_compact.dot"
  exec "dot -Tpng -y -oc2lora_deps.png src/c2lora_compact.dot"
# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config



