## Copyright 2026 Dean Hall See LICENSE for details
##
## Project-specific timer enumeration
##

import krnlpkg/[signal, systimer]

type ProjTimers = enum
  ProjTimerHeartbeat

const
  projTimerPrescaler* = 0'u32
  projTimerDeclarationList* =
    [(intervalMs: 1000'u32, sigOrd: ProjTimerHeartbeat.ord.uint32)]

  SigSysHeartbeat* = SigSysTimer(ProjTimerHeartbeat.ord.uint32)
