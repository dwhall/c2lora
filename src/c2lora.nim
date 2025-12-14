import nrf52840/[p, clock, rtc]
import cm4f/nvic
import reset, hard_fault

const
  bluePinBit = 1'u32 shl 4 # P1.04/LED2/RAK19007 Blue
  rtc1Bit = 1'u32 shl 17  # RTC1 interrupt bit in NVIC_ISER_0
  rtc_interval = 3277'u32 # ~100 ms

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
  RTC1.INTENSET = 1 shl 16      # Bit 16 = COMPARE[0] interrupt

  # Enable RTC1 interrupt in NVIC (IRQ #17)
  NVIC.NVIC_ISER_0 = NVIC.NVIC_ISER_0.uint32 or rtc1Bit

  # Start RTC
  RTC1.TASKS_START = 1

proc RTC1_IRQHandler() {.exportc, noconv.} =
  if RTC1.EVENTS_COMPARE0.uint32 != 0:
    RTC1.EVENTS_COMPARE0 = 0
    RTC1.CC0 = RTC1.CC0.uint32 + rtc_interval

    var ledState {.global, volatile.} = false
    ledState = not ledState
    if ledState:
      P1.OUTSET = bluePinBit
    else:
      P1.OUTCLR = bluePinBit

proc main() =
  P1.DIRSET = bluePinBit
  configureRTC1()
  while true:
    waitForInterrupt()

when isMainModule:
  main()
