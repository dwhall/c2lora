import nrf52840/[p, clock, rtc]
import cm4f/nvic
import reset, hard_fault
import debug_rtt

const
  bluePinBit = 1'u32 shl 4 # P1.04/LED2/RAK19007 Blue
  rtc1Bit = 1'u32 shl 17  # RTC1 interrupt bit in NVIC_ISER_0
  rtc_interval = 3277'u32 # ~100 ms
  isrAttr = "__attribute__((__interrupt__)) $# $#$#"

proc default_Handler() {.exportc, noconv.} =
  # TODO: clear interrupt
  discard

proc waitForInterrupt() {.inline.} =
  asm """
    wfi
  """

proc configureRTC1() =
  # Start the low-frequency clock (LFCLK)
  # Source: Internal RC oscillator (0) or external 32.768 kHz crystal (1)
  CLOCK.TASKS_LFCLKSTOP = 1
  CLOCK.LFCLKSRC = 0
  CLOCK.TASKS_LFCLKSTART = 1

  # Wait for LFCLK to start
  while CLOCK.EVENTS_LFCLKSTARTED.uint32 == 0:
    discard
  CLOCK.EVENTS_LFCLKSTARTED = 0

  RTC1.TASKS_STOP = 1           # Stop RTC
  RTC1.TASKS_CLEAR = 1          # Clear counter
  RTC1.PRESCALER = 0            # No prescaling: 32.768 kHz / (PRESCALER + 1)
  RTC1.CC0 = rtc_interval       # 3277 ticks ≈ 100ms at 32.768 kHz

  RTC1.INTENSET.COMPARE0(1).write() # Enable interrupt upon COMPARE[0]
  NVIC.NVIC_ISER_0.SETENA_17(1).write() # Enable interrupt on irq17/RTC1

  RTC1.TASKS_START = 1

proc toggleBlueLed =
    var ledState {.global, volatile.} = false
    ledState = not ledState
    if ledState:
      P1.OUTSET = bluePinBit
    else:
      P1.OUTCLR = bluePinBit

proc RTC1_IRQHandler() {.exportc, noconv, codegenDecl:isrAttr.} =
  discard debugRTTwrite(0, "Hello from RTC1 IRQ!\n", 25)
  if RTC1.EVENTS_COMPARE0.uint32 != 0:
    RTC1.EVENTS_COMPARE0 = 0
    RTC1.CC0 = RTC1.CC0.uint32 + rtc_interval
    toggleBlueLed()
    NVIC.NVIC_ICPR_0 = rtc1Bit # Clear pending irq17/RTC1
    while RTC1.EVENTS_COMPARE0.uint32 != 0:
      discard # wait for event to clear

proc main() =
  discard debugRTTwriteStr(0, "Hello from Nim!\n")
  debugRTTprintf(0, "Counter: %d\n", 42)
  P1.DIRSET = bluePinBit
  configureRTC1()
  while true:
    waitForInterrupt()

when isMainModule:
  main()
