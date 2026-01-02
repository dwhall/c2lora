import nrf52840/p
import cm4f/core

# The fault_Handler overrides the weak symbol in the vector table.
# Any hard fault will trigger this handler, despite no reference
# from the main module.  So we mark it as used to silence a compiler warning.
{.used.}

const
  standardDelay = 1000
  longDelay = 5000
  greenPinBit = 1'u32 shl 3 # P1.03/LED1/RAK19007 Green

func waitBlocking(ticks: int) =
  var outerTicks = ticks
  while outerTicks > 0:
    dec outerTicks
    var innerTicks {.volatile.} = standardDelay
    while innerTicks > 0:
      dec innerTicks

proc blinkLed(pinBit: static uint32, delay: int) =
  P1.OUTSET = pinBit
  waitBlocking(delay)
  P1.OUTCLR = pinBit
  waitBlocking(delay)

proc fault_Handler*(blinkCount: uint32 = 0) {.exportc, noconv, noreturn.} =
  ## Blinks the green LED blinkCount number of times.
  ## If blinkCount is zero, uses the ISR number as the count.
  ## Repeats the count after a noticeable pause.
  # Fault handler exceptions are higher priority than SysTick
  # which prevents SysTick from interrupting this handler;
  # so we must use blocking waits to flash the LED
  P1.DIRSET = greenPinBit
  let actualBlinkCount = if blinkCount == 0: IPSR.ISR_NUMBER else: blinkCount
  while true:
    for i in 0 ..< actualBlinkCount:
      blinkLed(greenPinBit, standardDelay)
    waitBlocking(longDelay)

