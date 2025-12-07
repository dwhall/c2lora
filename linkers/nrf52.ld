/* Device Specific Linker script to configure memory regions. */
SEARCH_DIR(linkers)

MEMORY
{
  FLASH (rx)  : ORIGIN = 0x00026000, LENGTH = 824K
  RAM (rwx) : ORIGIN = 0x20000000, LENGTH = 256K
}

INCLUDE "/common.ld"

PROVIDE(Reset_Handler = default_Handler);
PROVIDE(NMI_Handler = default_Handler);
PROVIDE(HardFault_Handler = default_Handler);
PROVIDE(MemoryManagement_Handler = default_Handler);
PROVIDE(BusFault_Handler = default_Handler);
PROVIDE(UsageFault_Handler = default_Handler);
PROVIDE(SVC_Handler = default_Handler);
PROVIDE(DebugMon_Handler = default_Handler);
PROVIDE(PendSV_Handler = default_Handler);
PROVIDE(SysTick_Handler = default_Handler);

PROVIDE(POWER_CLOCK_IRQHandler = default_Handler);
PROVIDE(RADIO_IRQHandler = default_Handler);
PROVIDE(UARTE0_UART0_IRQHandler = default_Handler);
PROVIDE(SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler = default_Handler);
PROVIDE(SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler = default_Handler);
PROVIDE(NFCT_IRQHandler = default_Handler);
PROVIDE(GPIOTE_IRQHandler = default_Handler);
PROVIDE(SAADC_IRQHandler = default_Handler);
PROVIDE(TIMER0_IRQHandler = default_Handler);
PROVIDE(TIMER1_IRQHandler = default_Handler);
PROVIDE(TIMER2_IRQHandler = default_Handler);
PROVIDE(RTC0_IRQHandler = default_Handler);
PROVIDE(TEMP_IRQHandler = default_Handler);
PROVIDE(RNG_IRQHandler = default_Handler);
PROVIDE(ECB_IRQHandler = default_Handler);
PROVIDE(CCM_AAR_IRQHandler = default_Handler);
PROVIDE(WDT_IRQHandler = default_Handler);
PROVIDE(RTC1_IRQHandler = default_Handler);
PROVIDE(QDEC_IRQHandler = default_Handler);
PROVIDE(COMP_LPCOMP_IRQHandler = default_Handler);
PROVIDE(SWI0_EGU0_IRQHandler = default_Handler);
PROVIDE(SWI1_EGU1_IRQHandler = default_Handler);
PROVIDE(SWI2_EGU2_IRQHandler = default_Handler);
PROVIDE(SWI3_EGU3_IRQHandler = default_Handler);
PROVIDE(SWI4_EGU4_IRQHandler = default_Handler);
PROVIDE(SWI5_EGU5_IRQHandler = default_Handler);
PROVIDE(TIMER3_IRQHandler = default_Handler);
PROVIDE(TIMER4_IRQHandler = default_Handler);
PROVIDE(PWM0_IRQHandler = default_Handler);
PROVIDE(PDM_IRQHandler = default_Handler);
PROVIDE(MWU_IRQHandler = default_Handler);
PROVIDE(PWM1_IRQHandler = default_Handler);
PROVIDE(PWM2_IRQHandler = default_Handler);
PROVIDE(SPIM2_SPIS2_SPI2_IRQHandler = default_Handler);
PROVIDE(RTC2_IRQHandler = default_Handler);
PROVIDE(I2S_IRQHandler = default_Handler);
PROVIDE(FPU_IRQHandler = default_Handler);
PROVIDE(USBD_IRQHandler = default_Handler);
PROVIDE(UARTE1_IRQHandler = default_Handler);
PROVIDE(QSPI_IRQHandler = default_Handler);
PROVIDE(CRYPTOCELL_IRQHandler = default_Handler);
PROVIDE(PWM3_IRQHandler = default_Handler);
PROVIDE(SPIM3_IRQHandler = default_Handler);