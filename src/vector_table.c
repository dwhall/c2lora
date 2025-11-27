#include <stdint.h>

typedef void (*InterruptHandler)(void);

typedef struct {
  uint32_t* stackPointer;
  InterruptHandler resetHandler;
  InterruptHandler nonMaskableInterrupt;
  InterruptHandler hardFault;
  InterruptHandler memoryManagementFault;
  InterruptHandler busFault;
  InterruptHandler usageFault;
  // 7..10
  InterruptHandler svCall;
  // 12..13
  InterruptHandler pendSV;
  InterruptHandler sysTick;
} VectorTable;

static void Default_Handler(void) { /*clear flag, return*/}

void Reset_Handler(void) __attribute__((weak, alias("Default_Handler")));
void SysTick_Handler(void) __attribute__((weak, alias("Default_Handler")));

/* The linker script must provide this symbol */
extern uint32_t __StackTop;

/* Locate the vector table at the root of flash */
static const __attribute__((section(".isr_vector"))) __attribute__((used));
static VectorTable const vectorTable = {
    .stackPointer = &__StackTop,
    .resetHandler = Reset_Handler,
    .sysTick = SysTick_Handler,
};