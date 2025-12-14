# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device

import metagenerator

#!fmt: off
declareDevice(deviceName = nrf52840, svdFileVersion = "1", description = "nRF52840 reference description for radio MCU with ARM 32-bit Cortex-M4 Microcontroller ")
declareCpu(cpuName = CM4, revision = "r0p1", endian = "little", mpuPresent = true, fpuPresent = true, nvicPrioBits = 3, vendorSysTick = 0)
