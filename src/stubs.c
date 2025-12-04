#include <sys/stat.h>
#include <stdint.h>

/* Stubs for unimplemented syscalls */
int _close(int fd) { return 0; }
int _fstat(int fd, struct stat *st) { return 0; }
int _isatty(int fd) { return 0;}
int _lseek(int fd, int ptr, int dir) { return 0;}
int _read(int fd, void *buf, size_t len) { return 0;}
int _write(int fd, const void *buf, size_t len) { return 0; }

/* Provided by the linker script */
extern char __end__;
extern char __HeapLimit;

/* Current program break, initialized to NULL */
static char *heap_end = 0;

void *_sbrk(int incr) {
    char *prev_heap_end;

    /* Initialize heap_end if this is the first call to _sbrk */
    if (heap_end == 0) {
        heap_end = &__end__;
    }

    prev_heap_end = heap_end;

    /* Check for heap overflow (heap_end exceeding __HeapLimit) */
    if ((heap_end + incr) > &__HeapLimit) {
        return (void *) -1; /* Indicate failure */
    }

    /* Inc Program Break and return previous Program Break */
    heap_end += incr;
    return (void *) prev_heap_end;
}