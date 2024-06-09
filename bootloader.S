.syntax unified
.cpu cortex-m4
.thumb

.global bootload

.section .rodata
    image: .incbin "kernel.bin"
    end_of_image:
    str_boot_start: .asciz "bootloader started\n"
    str_boot_end: .asciz "bootloader end\n"
    str_boot_indicate: .asciz "#\n"
    final: .asciz "Value in register #3: \n"

.section .text
bootload:
    ldr r0, =str_boot_start
    bl dbgput_line
    ldr r0, =end_of_image
    ldr r1, =image
    ldr r2, =_ram_start

    sub r3, r0, r1
    add r3, r3, #1
loop_start:
    ldrb r4, [r1], #1
    strb r4, [r2], #1
    subs r3, r3, #1
    bne loop_start

    bl newline

    MOV R1, #a
    MOV R2, #b
    MOV R3, #c

    AND R0, R1, R2   // R0 = a & b
    LSRS R0, R0, R3  // R0 = (a & b) >> c
    ADD R0, R0, R3   // R0 = ((a & b) >> c) + c

    MOV R3, R0

    ldr r0, =final
    bl dbgput
    mov r0, r3
    bl dbgput_num

    ldr r0, =str_boot_end
    bl dbgput_line

    ldr lr, =bootload_end
    adds lr, lr, #1
    ldr r2, =_ram_start

    adds r2, r2, #4
    ldr r0, [r2]
    bx r0

bootload_end:
    b bootload_end
