## Copyright 2026 Dean Hall See LICENSE for details
##
## Platform-specific definitions for the nrf52 processor
##

import nrf52840/device

const platInterruptCount* = 64
const platFpuAvail* = cpu.fpuAvail
const platNvicPriorityBits* = cpu.nvicPriorityBits.uint32
