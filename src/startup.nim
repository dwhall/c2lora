proc main

# Arm cortex m4 architecture uses Reset_Handler as an
# entry point.
proc Reset_Handler() {.exportc.} =
  main()
  while true: discard

{.emit: """
__attribute__((section(".isr_vector")))
void (* const vectors[])(void) = {
    (void (*)(void))(0x20040000),  // Stack pointer
    Reset_Handler,
};
""".}
