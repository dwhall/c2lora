# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device

import metagenerator

#!fmt: off
declarePeripheral(peripheralName = NVMC, baseAddress = 0x4001E000'u32, peripheralDesc = "Non Volatile Memory Controller")
declareRegister(peripheralName = NVMC, registerName = READY, addressOffset = 0x400'u32, readAccess = true, writeAccess = false, registerDesc = "Ready flag")
declareField(peripheralName = NVMC, registerName = READY, fieldName = READY, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = false, fieldDesc = "NVMC is ready or busy")
declareRegister(peripheralName = NVMC, registerName = READYNEXT, addressOffset = 0x408'u32, readAccess = true, writeAccess = false, registerDesc = "Ready flag")
declareField(peripheralName = NVMC, registerName = READYNEXT, fieldName = READYNEXT, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = false, fieldDesc = "NVMC can accept a new write operation")
declareRegister(peripheralName = NVMC, registerName = CONFIG, addressOffset = 0x504'u32, readAccess = true, writeAccess = true, registerDesc = "Configuration register")
declareField(peripheralName = NVMC, registerName = CONFIG, fieldName = WEN, bitOffset = 0, bitWidth = 2, readAccess = true, writeAccess = true, fieldDesc = "Program memory access mode. It is strongly recommended to only activate erase and write modes when they are actively used. Enabling write or erase will invalidate the cache and keep it invalidated.")
declareRegister(peripheralName = NVMC, registerName = ERASEPAGE, addressOffset = 0x508'u32, readAccess = false, writeAccess = true, registerDesc = "Register for erasing a page in code area")
declareField(peripheralName = NVMC, registerName = ERASEPAGE, fieldName = ERASEPAGE, bitOffset = 0, bitWidth = 32, readAccess = false, writeAccess = true, fieldDesc = "Register for starting erase of a page in code area")
declareRegister(peripheralName = NVMC, registerName = ERASEPCR1, addressOffset = 0x508'u32, readAccess = false, writeAccess = true, registerDesc = "Deprecated register - Register for erasing a page in code area, equivalent to ERASEPAGE")
declareField(peripheralName = NVMC, registerName = ERASEPCR1, fieldName = ERASEPCR1, bitOffset = 0, bitWidth = 32, readAccess = false, writeAccess = true, fieldDesc = "Register for erasing a page in code area, equivalent to ERASEPAGE")
declareRegister(peripheralName = NVMC, registerName = ERASEALL, addressOffset = 0x50C'u32, readAccess = false, writeAccess = true, registerDesc = "Register for erasing all non-volatile user memory")
declareField(peripheralName = NVMC, registerName = ERASEALL, fieldName = ERASEALL, bitOffset = 0, bitWidth = 1, readAccess = false, writeAccess = true, fieldDesc = "Erase all non-volatile memory including UICR registers. The erase must be enabled using CONFIG.WEN before the non-volatile memory can be erased.")
declareRegister(peripheralName = NVMC, registerName = ERASEPCR0, addressOffset = 0x510'u32, readAccess = false, writeAccess = true, registerDesc = "Deprecated register - Register for erasing a page in code area, equivalent to ERASEPAGE")
declareField(peripheralName = NVMC, registerName = ERASEPCR0, fieldName = ERASEPCR0, bitOffset = 0, bitWidth = 32, readAccess = false, writeAccess = true, fieldDesc = "Register for starting erase of a page in code area, equivalent to ERASEPAGE")
declareRegister(peripheralName = NVMC, registerName = ERASEUICR, addressOffset = 0x514'u32, readAccess = false, writeAccess = true, registerDesc = "Register for erasing user information configuration registers")
declareField(peripheralName = NVMC, registerName = ERASEUICR, fieldName = ERASEUICR, bitOffset = 0, bitWidth = 1, readAccess = false, writeAccess = true, fieldDesc = "Register starting erase of all user information configuration registers. The erase must be enabled using CONFIG.WEN before the UICR can be erased.")
declareRegister(peripheralName = NVMC, registerName = ERASEPAGEPARTIAL, addressOffset = 0x518'u32, readAccess = false, writeAccess = true, registerDesc = "Register for partial erase of a page in code area")
declareField(peripheralName = NVMC, registerName = ERASEPAGEPARTIAL, fieldName = ERASEPAGEPARTIAL, bitOffset = 0, bitWidth = 32, readAccess = false, writeAccess = true, fieldDesc = "Register for starting partial erase of a page in code area")
declareRegister(peripheralName = NVMC, registerName = ERASEPAGEPARTIALCFG, addressOffset = 0x51C'u32, readAccess = true, writeAccess = true, registerDesc = "Register for partial erase configuration")
declareField(peripheralName = NVMC, registerName = ERASEPAGEPARTIALCFG, fieldName = DURATION, bitOffset = 0, bitWidth = 7, readAccess = true, writeAccess = true, fieldDesc = "Duration of the partial erase in milliseconds")
declareRegister(peripheralName = NVMC, registerName = ICACHECNF, addressOffset = 0x540'u32, readAccess = true, writeAccess = true, registerDesc = "I-code cache configuration register")
declareField(peripheralName = NVMC, registerName = ICACHECNF, fieldName = CACHEEN, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Cache enable")
declareField(peripheralName = NVMC, registerName = ICACHECNF, fieldName = CACHEPROFEN, bitOffset = 8, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Cache profiling enable")
declareRegister(peripheralName = NVMC, registerName = IHIT, addressOffset = 0x548'u32, readAccess = true, writeAccess = true, registerDesc = "I-code cache hit counter")
declareField(peripheralName = NVMC, registerName = IHIT, fieldName = HITS, bitOffset = 0, bitWidth = 32, readAccess = true, writeAccess = true, fieldDesc = "Number of cache hits. Register is writable, but only to '0'.")
declareRegister(peripheralName = NVMC, registerName = IMISS, addressOffset = 0x54C'u32, readAccess = true, writeAccess = true, registerDesc = "I-code cache miss counter")
declareField(peripheralName = NVMC, registerName = IMISS, fieldName = MISSES, bitOffset = 0, bitWidth = 32, readAccess = true, writeAccess = true, fieldDesc = "Number of cache misses. Register is writable, but only to '0'.")
