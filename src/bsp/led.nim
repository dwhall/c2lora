## Copyright 2026 Dean Hall See LICENSE for details
##
## BSP: Board Support Package for the RAK19007
## LED: light emitting diodes on the board
##
## | LED# | Color | Port.pin |
## |------|-------|----------|
## | LED1 | Green | P1.03    |
## | LED2 | Blue  | P1.04    |
##

import nrf52840/p

type BspLed* = enum
  Led1Green
  Led2Blue

proc initLed*(n: BspLed) =
  ## Inits the port GPIO for led n as an output
  ## with initial value of off/low
  case n
  of Led1Green:
    P1.OUTCLR.PIN3(1)
    P1.DIRSET.PIN3(1)
  of Led2Blue:
    P1.OUTCLR.PIN4(1)
    P1.DIRSET.PIN4(1)

proc setLed*(n: BspLed, ledState: bool) =
  ## Sets the port GPIO for led n to the value of ledState
  case n
  of Led1Green:
    if ledState:
      P1.OUTSET.PIN3(1)
    else:
      P1.OUTCLR.PIN3(1)
  of Led2Blue:
    if ledState:
      P1.OUTSET.PIN4(1)
    else:
      P1.OUTCLR.PIN4(1)
