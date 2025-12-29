#include <stdint.h>

extern uint32_t __etext;
extern uint32_t __data_start__;
extern uint32_t __data_end__;
extern uint32_t __bss_start__;
extern uint32_t __bss_end__;

intptr_t const etext = (intptr_t)&__etext;
intptr_t const data_start = (intptr_t)&__data_start__;
intptr_t const data_end = (intptr_t)&__data_end__;
intptr_t const bss_start = (intptr_t)&__bss_start__;
intptr_t const bss_end = (intptr_t)&__bss_end__;
