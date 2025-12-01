{.compile: "vector_table.c".}

import nrf52840 / p

const
  STANDARD_DELAY  = 1000
  LONG_DELAY      = 5000

proc read_ipsr(): uint32 {.inline.} =
  var registerValue: uint32
  asm """
    mrs %0, ipsr
    : "=r"(`registerValue`)
  """
  return registerValue

proc startDelay(ticks: int) {.inline, noSideEffect.} =
  var outerTicks = ticks

  while outerTicks > 0:
    dec outerTicks
    var innerTicks {.volatile.} = STANDARD_DELAY
    while innerTicks > 0:
      dec innerTicks

proc blink_LED(pinBit: uint32, delay: int) =
  P1.OUTSET = pinBit
  startDelay(delay)
  P1.OUTCLR = pinBit
  startDelay(delay)

proc nim_default_handler() {.exportc: "nim_default_handler", noconv.} =
  var ipsr: uint32 = read_ipsr()

  # Blink Green LED based on IPSR value
  const greenPinBit = 1'u32 shl 3 # P1.03/LED1/RAK19007 Green
  P1.DIRSET = greenPinBit
  while true:
    for i in 0 ..< ipsr:
      blink_LED(greenPinBit, STANDARD_DELAY)
    startDelay(LONG_DELAY)

proc main() =
  const bluePinBit = 1'u32 shl 4  # P1.04/LED2/RAK19007 Blue
  P1.DIRSET = bluePinBit
  while true:
    blink_LED(bluePinBit, STANDARD_DELAY)

proc Reset_Handler() {.exportc, noconv.} =
  #NimMain()  # FIXME: unmet dependencies
  main()
  while true: discard
