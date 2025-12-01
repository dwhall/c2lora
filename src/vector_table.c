/*
Reference:
    https://developer.arm.com/documentation/ddi0403/latest
    DDI0403E_e_armv7m_arm.pdf
    B1.5 Armv7-M exception model
*/

#include <stdint.h>

typedef void (*ExceptionHandler)(void);
typedef void (*ExternalIrqHandler)(void);
typedef struct
{
    uint32_t *stackPointer;             /* 0      */
    ExceptionHandler exception[15];     /* 1..15  */
    ExternalIrqHandler externalIrq[48]; /* 16..63 */
} VectorTable;

extern void nim_default_handler(void) __attribute__((weak));

void default_Handler(void) {
    if (nim_default_handler) {
        nim_default_handler();
    }
    for(;;);
}

/* A reserved exception should never happened */
static void reserved_Handler(void) {
    /* Stay here so a debugger will reveal the problem */
    for(;;);
}

/* The weak attribute allows the function to be overridden by a
   user-defined function with the same name. The alias attribute causes
   the function to be an alias for default_Handler if not overridden.
*/
void Reset_Handler(void) __attribute__((weak, alias("default_Handler")));
void NMI_Handler(void) __attribute__((weak, alias("default_Handler")));
void HardFault_Handler(void) __attribute__((weak, alias("default_Handler")));
void MemoryManagement_Handler(void) __attribute__((weak, alias("default_Handler")));
void BusFault_Handler(void) __attribute__((weak, alias("default_Handler")));
void UsageFault_Handler(void) __attribute__((weak, alias("default_Handler")));
void SVC_Handler(void) __attribute__((weak, alias("default_Handler")));
void DebugMon_Handler(void) __attribute__((weak, alias("default_Handler")));
void PendSV_Handler(void) __attribute__((weak, alias("default_Handler")));
void SysTick_Handler(void) __attribute__((weak, alias("default_Handler")));

void POWER_CLOCK_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void RADIO_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void UARTE0_UART0_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void NFCT_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void GPIOTE_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SAADC_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void TIMER0_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void TIMER1_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void TIMER2_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void RTC0_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void TEMP_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void RNG_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void ECB_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void CCM_AAR_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void WDT_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void RTC1_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void QDEC_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void COMP_LPCOMP_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SWI0_EGU0_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SWI1_EGU1_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SWI2_EGU2_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SWI3_EGU3_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SWI4_EGU4_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SWI5_EGU5_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void TIMER3_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void TIMER4_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void PWM0_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void PDM_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void MWU_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void PWM1_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void PWM2_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SPIM2_SPIS2_SPI2_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void RTC2_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void I2S_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void FPU_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void USBD_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void UARTE1_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void QSPI_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void CRYPTOCELL_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void PWM3_IRQHandler(void) __attribute__((weak, alias("default_Handler")));
void SPIM3_IRQHandler(void) __attribute__((weak, alias("default_Handler")));

/* The linker script provides this symbol.  The stack is located at or
   near the greatest-valued address in RAM and grows toward lesser values.
*/
extern uint32_t __StackTop;

/* The section attribute locates the vector table at the linker symbol, .isr_vector
   The used attribute prevents the optimizer from removing this struct
   that is not referred to by any other variable.
*/
static VectorTable const vectorTable __attribute__((section(".isr_vector"), used)) = {
    .stackPointer = &__StackTop,
    .exception = {
        Reset_Handler,
        NMI_Handler,
        HardFault_Handler,
        MemoryManagement_Handler,
        BusFault_Handler,
        UsageFault_Handler,
        reserved_Handler,
        reserved_Handler,
        reserved_Handler,
        reserved_Handler,
        SVC_Handler,
        DebugMon_Handler,
        reserved_Handler,
        PendSV_Handler,
        SysTick_Handler,
    },
    .externalIrq = {
        POWER_CLOCK_IRQHandler, /* 16 */
        RADIO_IRQHandler,
        UARTE0_UART0_IRQHandler,
        SPIM0_SPIS0_TWIM0_TWIS0_SPI0_TWI0_IRQHandler,
        SPIM1_SPIS1_TWIM1_TWIS1_SPI1_TWI1_IRQHandler, /* 20 */
        NFCT_IRQHandler,
        GPIOTE_IRQHandler,
        SAADC_IRQHandler,
        TIMER0_IRQHandler,
        TIMER1_IRQHandler,
        TIMER2_IRQHandler,
        RTC0_IRQHandler,
        TEMP_IRQHandler,
        RNG_IRQHandler,
        ECB_IRQHandler,       /* 30 */
        CCM_AAR_IRQHandler,
        WDT_IRQHandler,
        RTC1_IRQHandler,
        QDEC_IRQHandler,
        COMP_LPCOMP_IRQHandler,
        SWI0_EGU0_IRQHandler,
        SWI1_EGU1_IRQHandler,
        SWI2_EGU2_IRQHandler,
        SWI3_EGU3_IRQHandler,
        SWI4_EGU4_IRQHandler, /* 40 */
        SWI5_EGU5_IRQHandler,
        TIMER3_IRQHandler,
        TIMER4_IRQHandler,
        PWM0_IRQHandler,
        PDM_IRQHandler,
        reserved_Handler,
        reserved_Handler,
        MWU_IRQHandler,
        PWM1_IRQHandler,
        PWM2_IRQHandler,      /* 50 */
        SPIM2_SPIS2_SPI2_IRQHandler,
        RTC2_IRQHandler,
        I2S_IRQHandler,
        FPU_IRQHandler,
        USBD_IRQHandler,
        UARTE1_IRQHandler,
        QSPI_IRQHandler,
        CRYPTOCELL_IRQHandler,
        reserved_Handler,
        reserved_Handler,     /* 60 */
        PWM3_IRQHandler,
        reserved_Handler,
        SPIM3_IRQHandler,     /* 63 */
    },
};
