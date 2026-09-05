import plat/debug_rtt

{.push stack_trace: off, profiler: off.}

proc panic*(s: string) =
  debugPrint(s)
  debugPrint("\n")

{.pop.}
