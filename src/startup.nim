{.compile: "vector_table.c".}

proc main()

proc NimMain() {.importc: "NimMain".}

proc Reset_Handler() {.exportc, noconv.} =
  #NimMain()  # has unmet dependencies
  main()
  while true: discard

proc SysTick_Handler() {.exportc, noconv.} =
  # Nim code here
  discard
