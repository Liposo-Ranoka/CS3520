.data
num1: .word 17
num2: .word 17
msgEqual: .string " equal"
msgLarge: .string " is larger\n"

.text
.global main
main:
    lw t0, num1
    lw t1, num2
    
    beq t0, t1, EQUAL
    blt t0, t1, NUM2
     
    mv a0, t0
    li a7, 1
    ecall
    la a0, msgLarge
    li a7, 4
    ecall
    j EXIT
    

NUM2:
     mv a0, t1
     li a7, 1
     ecall
     la a0, msgLarge
     li a7, 4
     ecall
     j EXIT
     
EQUAL:
    la a0, msgEqual
    li a7, 4
    ecall
     
EXIT:
    li a7, 10
    ecall
    
    