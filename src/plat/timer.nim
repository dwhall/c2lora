## Copyright 2025 Dean Hall, see LICENSE for details
##
## KRNL platform timer
##
## Provides the hardware-specific timer implementation for KRNL's systimer.
## Provides a callback at a given absolute tick count.  The callback,
## systimer, returns the next absolute tick count to be called at.
##

import armv7m/nvic
import nrf52840/rtc
import krnlpkg/[effects, syscall_intf, systimer]

var
  rtc1Prescaler: uint32
  rtc1Callback: PrivilegedModeCallback

func toTicks(millisecs: uint32, prescaler: uint32): uint32 =
  ## Converts milliseconds to hardware ticks, given the current prescaler.
  # TODO: involve the prescaler
  millisecs * 32768 div 1000

proc getTicks(): uint32 =
  ## Returns the current tick count from the hardware timer
  RTC1.COUNTER.read().COUNTER().uint32

proc stopTimer() =
  ## Stops the hardware timer, clear pending interrupt
  RTC1.TASKS_STOP.TASKS_STOP(1)
  RTC1.TASKS_CLEAR.TASKS_CLEAR(1)
  NVIC.NVIC_ICPR(0).CLRPEND(irq_RTC1, 1)

proc RTC1IrqHandler() {.noconv, tags: [PrivilegedModeEffect].} =
  if RTC1.EVENTS_COMPARE(0).read().uint32 != 0:
    RTC1.EVENTS_COMPARE(0).write(0)
    # FOUR clock cycles must happen after the above write
    # and before the proc returns
    # per nRF52840_PS_v1.11.pdf p.175
    if rtc1Callback == nil:
      # disable the interrupt
      discard
    let nowTicks = getTicks()
    let nextCompare = rtc1Callback(nowTicks)
    RTC1.CC(0).COMPARE(nextCompare)
    NVIC.NVIC_ICPR(0).CLRPEND(irq_RTC1, 1)

proc startTimer(
    firstCallTicks: uint32, callback: PrivilegedModeCallback, prescaler: uint32 = 0'u32
) =
  ## Starts the hardware timer
  stopTimer()
  RTC1.PRESCALER.PRESCALER(prescaler)
  RTC1.CC(0).COMPARE(firstCallTicks)
  RTC1.INTENSET.COMPARE0(1)
  discard syscallRegisterIrqHandler(irq_RTC1, RTC1IrqHandler)
  RTC1.TASKS_START.TASKS_START(1)
  rtc1Callback = callback
  rtc1Prescaler = prescaler

const rtc1Timer* = PlatTimerIntf(
  toTicks: toTicks, stopTimer: stopTimer, startTimer: startTimer, getTicks: getTicks
)
