.syntax unified
.cpu cortex-m4
.thumb
.equ a, 5
.equ b, 3
.equ c, 2

.global vtable_kernel
.global kernel_reset

.type vtable_kernel, %object
.type kernel_reset, %function

.section .interrupt_vector
vtable_kernel:
    .word stack_start
    .word __kernel_reset+1
    .size vtable_kernel, .-vtable_kernel

.section .rodata
    data: .asciz "kernel started!\n"
    final: .asciz "Value in register #3: "

.section .text
kernel_reset:
    ldr r0, =data
    bl dbgput_line
    
    // calculate
    MOV R1, a
    MOV R2, b
    MOV R3, c

    AND R0, R1, R2   // R0 = a & b
    LSRS R0, R0, R3  // R0 = (a & b) >> c
    ADD R0, R0, R3   // R0 = ((a & b) >> c) + c

    MOV R3, R0

    ldr r0, =final
    bl dbgput
    mov r0, r3
    bl dbgput_num

end:
    b end
