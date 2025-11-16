# C cross-compile to Arm (32-bit), no-OS, EABI.

switch("cpu", "arm")
switch("os", "any")
switch("cc", "gcc")

# Compiler executables
switch("arm.any.gcc.exe", "arm-none-eabi-gcc")
switch("arm.any.gcc.linkerexe", "arm-none-eabi-gcc")

# Compiler options
switch("arm.any.gcc.options.always", "-w -fmax-errors=4 -march=armv7e-m -mtune=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16")
switch("arm.any.gcc.options.linker", "-w -march=armv7e-m -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 -T linkers/nrf52.ld -o build/c2lora.elf -specs=nano.specs -specs=nosys.specs -Wl,--gc-sections")

# Nim cache directory
switch("nimcache", "build/nimcache")

# Optimization
# switch("opt", "size")

switch("noMain")

# Nim-compiler options for deeply-embedded targets:
switch("mm", "arc")
switch("panics", "on")  # requires local panicoverride.nim
switch("threads", "off")
switch("stacktrace", "off")
switch("profiler", "off")
switch("checks", "off")
switch("assertions", "off")
switch("stackTrace", "off")
switch("lineTrace", "off")
switch("exceptions", "goto")

switch("define", "noSignalHandler")
switch("define", "nimAllocPagesViaMalloc")  # requires mm:arc or mm:orc
switch("define", "nimPage512")
switch("define", "nimMemAlignTiny")

# Experimental
# switch("define", "nimPreviewSlimSystem")  # https://nim-lang.org/blog/2022/12/21/version-20-rc.html

# Debugging
# switch("opt", "none")
# switch("debugger", "native")

# Preferences
switch("styleCheck", "usages")  # prohibit flexible capitalization of identifiers
switch("styleCheck", "error")