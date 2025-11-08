# c2lora

Codec 2 over LoRa, written in Nim.

## Dev Env

* git 2.51 or later
* [Nim 2.2.0](https://nim-lang.org/install.html) or later
* [ARM GNU Toolchain Version 14.3.Rel1](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
    - provides a GCC 14.3 cross-compiler for ARM AArch32 bare-metal target (arm-none-eabi)

## Hardware target

* Module: [RAK4630](https://store.rakwireless.com/products/rak4631-lpwan-node)
    - Nordic nRF52840 BLE Core Module with LoRa SX1262
    - Frequency: US915
    - purchased from: [Rokland](https://store.rokland.com/products/rak-wireless-rak4631-nordic-nrf52840-ble-core-module-for-lorawan-with-lora-sx1262)

* Processor: [Nordic nRF52840](https://www.nordicsemi.com/Products/nRF52840)
    - Datasheet: [nRF52840 Product Specification v1.11](https://docs.nordicsemi.com/bundle/ps_nrf52840/page/keyfeatures_html5.html)
    - SDK: [nRF5_SDK_17.1.0_ddde560.zip](https://www.nordicsemi.com/Products/nRF52840/Compatible-downloads#infotabs)
    - 64 MHz Cortex-M4 with FPU
    - Specs:
        - 1 MB Flash, 256 KB RAM
        - 2.4 GHz RF Transceiver
            - Bluetooth LE, mesh
            - ANT, 802.15.4
        - UART, SPI, TWI, PDM, I2S, QSPI, PWM
        - USB 2.0
        - 128-bit AES CCM, ARM CryptoCell

* LoRa Radio Transceiver: [Semtech SX1262](https://www.semtech.com/products/wireless-rf/lora-connect/sx1262)
    - LoRa and FSK Modem
    - 170dB maximum link budget (SX1262 / 68)
    - +22dBm or +15dBm high efficiency PA
    - Low RX current of 4.6mA
    - Integrated DC-DC converter and LDO
    - Programmable bit rate up to 62.5kbps LoRa and 300kbps FSK
    - High sensitivity: down to -148dBm
