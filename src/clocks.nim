# Copyright 2026 Dean Hall, see LICENSE for details

import nrf52840/clock

proc initClocks*() =
  # Start the low-frequency clock (LFCLK)
  # Source: Internal RC oscillator (0) or external 32.768 kHz crystal (1)
  CLOCK.TASKS_LFCLKSTOP.TASKS_LFCLKSTOP(1)
  CLOCK.LFCLKSRC.write(0)
  CLOCK.TASKS_LFCLKSTART.TASKS_LFCLKSTART(1)

  # Wait for LFCLK to start
  while CLOCK.EVENTS_LFCLKSTARTED.uint32 == 0:
    discard
  CLOCK.EVENTS_LFCLKSTARTED.EVENTS_LFCLKSTARTED(0)
