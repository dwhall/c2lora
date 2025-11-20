# To learn how to use the output of the declarations below, visit:
# https://github.com/dwhall/minisvd2nim/blob/main/README.md#how-to-access-the-device

import metagenerator

#!fmt: off
declarePeripheral(peripheralName = RNG, baseAddress = 0x4000D000'u32, peripheralDesc = "Random Number Generator")
declareInterrupt(peripheralName = RNG, interruptName = RNG, interruptValue = 13, interruptDesc = "")
declareRegister(peripheralName = RNG, registerName = TASKS_START, addressOffset = 0x000'u32, readAccess = false, writeAccess = true, registerDesc = "Task starting the random number generator")
declareField(peripheralName = RNG, registerName = TASKS_START, fieldName = TASKS_START, bitOffset = 0, bitWidth = 1, readAccess = false, writeAccess = true, fieldDesc = "Task starting the random number generator")
declareRegister(peripheralName = RNG, registerName = TASKS_STOP, addressOffset = 0x004'u32, readAccess = false, writeAccess = true, registerDesc = "Task stopping the random number generator")
declareField(peripheralName = RNG, registerName = TASKS_STOP, fieldName = TASKS_STOP, bitOffset = 0, bitWidth = 1, readAccess = false, writeAccess = true, fieldDesc = "Task stopping the random number generator")
declareRegister(peripheralName = RNG, registerName = EVENTS_VALRDY, addressOffset = 0x100'u32, readAccess = true, writeAccess = true, registerDesc = "Event being generated for every new random number written to the VALUE register")
declareField(peripheralName = RNG, registerName = EVENTS_VALRDY, fieldName = EVENTS_VALRDY, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Event being generated for every new random number written to the VALUE register")
declareRegister(peripheralName = RNG, registerName = SHORTS, addressOffset = 0x200'u32, readAccess = true, writeAccess = true, registerDesc = "Shortcuts between local events and tasks")
declareField(peripheralName = RNG, registerName = SHORTS, fieldName = VALRDY_STOP, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Shortcut between event VALRDY and task STOP")
declareRegister(peripheralName = RNG, registerName = INTENSET, addressOffset = 0x304'u32, readAccess = true, writeAccess = true, registerDesc = "Enable interrupt")
declareField(peripheralName = RNG, registerName = INTENSET, fieldName = VALRDY, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Write '1' to enable interrupt for event VALRDY")
declareRegister(peripheralName = RNG, registerName = INTENCLR, addressOffset = 0x308'u32, readAccess = true, writeAccess = true, registerDesc = "Disable interrupt")
declareField(peripheralName = RNG, registerName = INTENCLR, fieldName = VALRDY, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Write '1' to disable interrupt for event VALRDY")
declareRegister(peripheralName = RNG, registerName = CONFIG, addressOffset = 0x504'u32, readAccess = true, writeAccess = true, registerDesc = "Configuration register")
declareField(peripheralName = RNG, registerName = CONFIG, fieldName = DERCEN, bitOffset = 0, bitWidth = 1, readAccess = true, writeAccess = true, fieldDesc = "Bias correction")
declareRegister(peripheralName = RNG, registerName = VALUE, addressOffset = 0x508'u32, readAccess = true, writeAccess = false, registerDesc = "Output random number")
declareField(peripheralName = RNG, registerName = VALUE, fieldName = VALUE, bitOffset = 0, bitWidth = 8, readAccess = true, writeAccess = false, fieldDesc = "Generated random number")
