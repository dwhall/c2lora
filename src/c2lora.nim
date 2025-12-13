import nrf52840/p
import reset

const
  standardDelay = 1000
  longDelay = 5000
  bluePinBit = 1'u32 shl 4 # P1.04/LED2/RAK19007 Blue
  greenPinBit = 1'u32 shl 3 # P1.03/LED1/RAK19007 Green

var blink {.volatile.}: bool = false

proc readIpsr(): uint32 {.inline.} =
  asm """
    mrs %0, ipsr
    : "=r"(`result`)
  """

proc waitForInterrupt() {.inline.} =
  asm """
    wfi
  """

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

proc default_Handler() {.exportc, noconv.} =
  ## Blinks green LED based on IPSR value
  let ipsr = readIpsr()
  waitForInterrupt()

proc SysTick_Handler() {.exportc, noconv.} =
  P1.DIRSET = bluePinBit
  blink = not blink;
  if blink:
    P1.OUTSET = bluePinBit
  else:
    P1.OUTCLR = bluePinBit

  waitForInterrupt()

proc main() =
  waitForInterrupt()

when isMainModule:
  main()
