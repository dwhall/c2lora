# SVD

An SVD file, which is XML format, describes the peripherals and registers of
an Arm processor implementation by a silicon manufacturer.
A proper SVD file does NOT give access to the ARM core registers.
A tool parses the `.svd` file and renders source code that can manipulate the peripherals,
registers and fields by name.

The SVD file included in this directory comes from the Nordic Semi
[SDK (nRF5_SDK_17.1.0_ddde560.zip)](https://www.nordicsemi.com/Products/nRF52840/Compatible-downloads#infotabs)
at the path: `nrf5_sdk_17.1.0_ddde560\modules\nrfx\mdk\nrf52840.svd`

The [minisvd2nim](https://github.com/dwhall/minisvd2nim) tool converted the SVD file to the Nim package
in this directory, via this command:
    `minisvd2nim nrf52840.svd`
