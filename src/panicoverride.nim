import debug_rtt, hard_fault

{.push stack_trace: off, profiler:off.}

proc panic*(s: string) =
  # In armv7, ISR #7-10 are reserved, so we use 8 blinks to indicate a panic
  const panicLedBlinkCount = 8
  debugPrint("PANIC: ")
  debugPrint(s)
  debugPrint(['\n'])
  fault_Handler(panicLedBlinkCount)

{.pop.}
