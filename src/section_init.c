#include <stdint.h>

extern uint32_t __etext;
extern uint32_t __data_start__;
extern uint32_t __data_end__;
extern uint32_t __bss_start__;
extern uint32_t __bss_end__;

void copyDataSection(void) {
    uint32_t *src = &__etext;
    uint32_t *dst = &__data_start__;
    uint32_t *end = &__data_end__;

    while (dst < end) {
        *dst++ = *src++;
    }
}

void zeroBssSection(void) {
    uint32_t *dst = &__bss_start__;
    uint32_t *end = &__bss_end__;

    while (dst < end) {
        *dst++ = 0;
    }
}