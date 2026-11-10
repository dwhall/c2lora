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

const ledPin: array[BspLed, uint32] = [Led1Green: 3'u32, Led2Blue: 4]

proc initLed*(led: BspLed) =
  ## Inits the port GPIO for led as an output
  ## with initial value of off/low
  P1.OUTCLR.write(1'u32 shl ledPin[led])
  P1.DIRSET.write(1'u32 shl ledPin[led])

proc setLed*(led: BspLed, ledState: bool) =
  ## Sets the port GPIO for led to the value of ledState
  if ledState:
    P1.OUTSET.write(1'u32 shl ledPin[led])
  else:
    P1.OUTCLR.write(1'u32 shl ledPin[led])
