# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device

import metagenerator

#!fmt: off
declareDevice(deviceName = nrf52840, mpuPresent = true, fpuPresent = true, nvicPrioBits = 3)
