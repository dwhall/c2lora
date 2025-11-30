/*
Reference:
    https://developer.arm.com/documentation/ddi0403/latest
    DDI0403E_e_armv7m_arm.pdf
    B1.5 Armv7-M exception model
*/

#include <stdint.h>

typedef void (*ExceptionHandler)(void);

typedef struct {
  uint32_t* stackPointer;
  ExceptionHandler resetHandler;
  ExceptionHandler nonMaskableInterrupt;
  ExceptionHandler hardFault;
  ExceptionHandler memMgmtFault;
  ExceptionHandler busFault;
  ExceptionHandler usageFault;
  ExceptionHandler reserved7;
  ExceptionHandler reserved8;
  ExceptionHandler reserved9;
  ExceptionHandler reserved10;
  ExceptionHandler svCall;
  ExceptionHandler debugMonitor;
  ExceptionHandler reserved13;
  ExceptionHandler pendSV;
  ExceptionHandler sysTick;
  // TODO: External interrupts
} VectorTable;

/* The default handler for an exception.
   This notifies the programmer that the exception occurred.
   The programmer should provide a proper handler */
static void default_Handler(void) {
    // TODO: clear flag, debugAssert, return
    for (;;);
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
void nmi_Handler(void) __attribute__((weak, alias("default_Handler")));
void hard_Fault(void) __attribute__((weak, alias("default_Handler")));
void memMgmt_Fault(void) __attribute__((weak, alias("default_Handler")));
void bus_Fault(void) __attribute__((weak, alias("default_Handler")));
void usageFault_Handler(void) __attribute__((weak, alias("default_Handler")));
void svCall_Handler(void) __attribute__((weak, alias("default_Handler")));
void debugMonitor_Handler(void) __attribute__((weak, alias("default_Handler")));
void pendSv_Handler(void) __attribute__((weak, alias("default_Handler")));
void SysTick_Handler(void) __attribute__((weak, alias("default_Handler")));

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
    .resetHandler = Reset_Handler,
    .nonMaskableInterrupt = nmi_Handler,
    .hardFault = hard_Fault,
    .memMgmtFault = memMgmt_Fault,
    .busFault = bus_Fault,
    .usageFault = usageFault_Handler,
    .reserved7 = reserved_Handler,
    .reserved8 = reserved_Handler,
    .reserved9 = reserved_Handler,
    .reserved10 = reserved_Handler,
    .svCall = svCall_Handler,
    .debugMonitor = debugMonitor_Handler,
    .reserved13 = reserved_Handler,
    .pendSV = pendSv_Handler,
    .sysTick = SysTick_Handler,
};
