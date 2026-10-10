.data
num1: .word 5
msg1: .string "The sum of the first "
msg2: .string " integer is "
newline: .string "\n"

.text
.globl main

main:
    lw t0, num1
    li t1, 1
    li t2, 0
    
LOOP:
    bgt t1, t0, END
    add t2, t2, t1
    addi t1, t1, 1
    j LOOP

END:
    la a0, msg1
    li a7, 4
    ecall
    
    mv a0, t0
    li a7, 1
    ecall
    
    la a0, msg2
    li a7, 4
    ecall
    
    mv a0, t2
    li a7, 1
    ecall
    
    la a0, newline
    li a7, 4
    ecall
    
    li a7, 10
    ecall
    
     
    