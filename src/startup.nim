proc main

template sectionVar*(section: string, name: untyped, typ: typedesc, init: string): untyped =
  var name {.exportc: astToStr(name), codegenDecl:
    "__attribute__((section(\"" & section & "\")))\n" &
    "__attribute__((used))\n" &
    "$# $# = " & init
  .}: typ

type
  VectorTable = object
    stackPointer: uint32
    resetHandler: proc() {.noconv.}

# Arm cortex m4 architecture uses Reset_Handler as an
# entry point.
proc Reset_Handler() {.exportc, noconv.} =
  main()
  while true: discard

sectionVar(".isr_vector", vectorTable, VectorTable, """{
  .stackPointer = 0x20040000,
  .resetHandler = Reset_Handler
}""")