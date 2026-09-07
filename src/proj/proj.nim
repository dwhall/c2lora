## Copyright 2026 Dean Hall See LICENSE for details
##
## Project-specific items needed by KRNL
##

import armv7m/core

type EventValue* = uint32

proc default_Handler() {.exportc, noconv.} =
  while true:
    when defined(arm):
      WFI()
    else:
      discard
