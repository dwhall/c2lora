{.compile: "vector_table.c".}
{.compile: "stubs.c".}
{.compile: "std.c".}
{.compile: "section_init.c".}

proc NimMain() {.importc: "NimMain".}
proc copyDataSection() {.importc, cdecl.}
proc zeroBssSection() {.importc, cdecl.}

proc configureSystick100ms*() =
  {.emit: """
    __asm__ volatile (
      "ldr    r0, =0xE000E010     \n\t"
      "movs   r1, #0              \n\t"
      "str    r1, [r0]            \n\t"

      "ldr    r0, =0xE000E01C     \n\t"
      "ldr    r1, [r0]            \n\t"

      "ldr    r2, =0x00FFFFFF     \n\t"
      "ands   r1, r1, r2          \n\t"
      "cmp    r1, #0              \n\t"
      "beq    no_calib%=          \n\t"

      "movs   r2, #10             \n\t"
      "muls   r1, r2, r1          \n\t"
      "subs   r1, r1, #1          \n\t"
      "b      config_timer%=      \n\t"

      "no_calib%=:                \n\t"
      "ldr    r1, =6399999        \n\t"

      "config_timer%=:            \n\t"
      "ldr    r0, =0xE000E014     \n\t"
      "str    r1, [r0]            \n\t"

      "ldr    r0, =0xE000E018     \n\t"
      "movs   r1, #0              \n\t"
      "str    r1, [r0]            \n\t"

      "ldr    r0, =0xE000E010     \n\t"
      "movs   r1, #0x07           \n\t"
      "str    r1, [r0]            \n\t"

      :
      :
      : "r0", "r1", "r2", "memory"
    );
  """.}

proc Reset_Handler() {.exportc, noconv.} =
  copyDataSection()
  zeroBssSection()
  configureSystick100ms()
  NimMain()
