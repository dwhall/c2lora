extern void Reset_Handler(void);

__attribute__((section(".text.start"), used))
void start(void) {
    Reset_Handler();
}
