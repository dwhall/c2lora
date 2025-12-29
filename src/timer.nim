# Copyright 2025 Dean Hall, see LICENSE for details

import cm4f/nvic
import nrf52840/[clock, rtc]
import debug_rtt

var
  timerInterval: uint32
  timerCallback: proc()

proc configureTimer*(interval: uint32, callback: proc()) =
  timerInterval = interval
  timerCallback = callback

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
  RTC1.CC0 = timerInterval      # 3277 ticks ≈ 100ms at 32.768 kHz

  RTC1.INTENSET.COMPARE0(1).write() # Enable interrupt upon COMPARE[0]
  NVIC.NVIC_ISER_0.SETENA_17(1).write() # Enable interrupt on irq17/RTC1

  RTC1.TASKS_START = 1

const isrAttr = "__attribute__((__interrupt__)) $# $#$#"
proc RTC1_IRQHandler*() {.exportc, noconv, codegenDecl:isrAttr.} =
  const rtc1Bit = 1'u32 shl 17  # RTC1 interrupt bit in NVIC_ISER_0
  discard debugRTTwrite(0, "Hello from RTC1 IRQ!\n", 25)
  if RTC1.EVENTS_COMPARE0.uint32 != 0:
    RTC1.EVENTS_COMPARE0 = 0
    RTC1.CC0 = RTC1.CC0.uint32 + timerInterval
    timerCallback()
    NVIC.NVIC_ICPR_0 = rtc1Bit # Clear pending irq17/RTC1
    while RTC1.EVENTS_COMPARE0.uint32 != 0:
      discard # wait for event to clear

