## Copyright 2026 Dean Hall See LICENSE for details
##
## Project-specific items needed by KRNL
##

import armv7m/core
import proj_timers

type EventValue* = uint32

proc default_Handler() {.exportc, noconv.} =
  while true:
    when defined(arm):
      WFI()
    else:
      discard

proc lowPowerRunForever*() {.noreturn.} =
  while true:
    WFI()

const
  projTimerDeclarations* = [(intervalMs: 1000'u32, sigOrd: ProjTimerHeartbeat.ord.uint32)]
  projTimerPrescaler* = 0'u32
