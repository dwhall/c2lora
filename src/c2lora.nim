import cm4f/systick
import nrf52840/p
import reset

const
  standardDelay = 1000
  longDelay = 5000
  bluePinBit = 1'u32 shl 4 # P1.04/LED2/RAK19007 Blue
  greenPinBit = 1'u32 shl 3 # P1.03/LED1/RAK19007 Green

proc readIpsr(): uint32 {.inline.} =
  asm """
    mrs %0, ipsr
    : "=r"(`result`)
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

proc fault_Handler() {.exportc, noconv.} =
  ## Blinks green LED based on IPSR value
  # Fault handlers are higher priority than SysTick
  # which prevents SysTick from interrupting this handler;
  # so we must use blocking waits to flash the LED
  let ipsr = readIpsr()
  P1.DIRSET = greenPinBit
  while true:
    for i in 0 ..< ipsr:
      blinkLed(greenPinBit, standardDelay)
    waitBlocking(longDelay)

proc default_Handler() {.exportc, noconv.} =
  # TODO: clear interrupt
  discard

proc waitForInterrupt() {.inline.} =
  asm """
    wfi
  """

proc configureSystick100ms() =
  SYSTICK.SYST_CSR = 0'u32
  var cal = SYSTICK.SYST_CALIB.TENMS.uint32
  if cal == 0'u32:
    cal = 6_400_000'u32 - 1'u32
  SYSTICK.SYST_RVR = cal
  SYSTICK.SYST_CVR = 0'u32
  SYSTICK.SYST_CSR
         .CLKSOURCE(1)
         .TICKINT(1)
         .ENABLE(1)
         .write()

proc SysTick_Handler() {.exportc, noconv.} =
  var ledState {.global, volatile.} = false
  ledState = not ledState
  if ledState:
    P1.OUTSET = bluePinBit
  else:
    P1.OUTCLR = bluePinBit

proc main() =
  P1.DIRSET = bluePinBit
  configureSystick100ms()
  while true:
    waitForInterrupt()

when isMainModule:
  main()
