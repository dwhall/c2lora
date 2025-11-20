# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device

import metagenerator

#!fmt: off
declarePeripheral(peripheralName = ACL, baseAddress = 0x4001E000'u32, peripheralDesc = "Access control lists")
declareRegister(peripheralName = ACL, registerName = ADDR, addressOffset = 0x000'u32, readAccess = true, writeAccess = true, registerDesc = "Description cluster: Start address of region to protect. The start address must be word-aligned.")
declareField(peripheralName = ACL, registerName = ADDR, fieldName = ADDR, bitOffset = 0, bitWidth = 32, readAccess = true, writeAccess = true, fieldDesc = "Start address of flash region n. The start address must point to a flash page boundary.")
declareRegister(peripheralName = ACL, registerName = SIZE, addressOffset = 0x004'u32, readAccess = true, writeAccess = true, registerDesc = "Description cluster: Size of region to protect counting from address ACL[n].ADDR. Write '0' as no effect.")
declareField(peripheralName = ACL, registerName = SIZE, fieldName = SIZE, bitOffset = 0, bitWidth = 32, readAccess = true, writeAccess = true, fieldDesc = "Size of flash region n in bytes. Must be a multiple of the flash page size.")
declareRegister(peripheralName = ACL, registerName = PERM, addressOffset = 0x008'u32, readAccess = true, writeAccess = true, registerDesc = "Description cluster: Access permissions for region n as defined by start address ACL[n].ADDR and size ACL[n].SIZE")
declareField(peripheralName = ACL, registerName = PERM, fieldName = WRITE, bitOffset = 1, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Configure write and erase permissions for region n. Write '0' has no effect.")
declareField(peripheralName = ACL, registerName = PERM, fieldName = READ, bitOffset = 2, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Configure read permissions for region n. Write '0' has no effect.")
