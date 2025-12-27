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

proc fault_Handler() {.exportc, noconv, noreturn.} =
  ## Blinks the green LED ISR number of times.
  ## Repeats the count after a noticeable pause.
  # Fault handler exceptions are higher priority than SysTick
  # which prevents SysTick from interrupting this handler;
  # so we must use blocking waits to flash the LED
  let blinkCount = IPSR.ISR_NUMBER
  P1.DIRSET = greenPinBit
  while true:
    for i in 0 ..< blinkCount:
      blinkLed(greenPinBit, standardDelay)
    waitBlocking(longDelay)

