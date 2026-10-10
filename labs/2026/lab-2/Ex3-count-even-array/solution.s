.data
nums:.word 12, 3, 6, 13, 45, 23, 7, 9 
len:.word 8 
msg:.string "Even count = "

.text
.globl main
main:
    la t3, nums # t3 = base address of nums array
    lw t4, len # t4 = 8 = array length
    li t0, 0 # t0 = i = 0
    li t1, 0 # t1 = count = 0

LOOP:
    bge t0, t4, END # if i >= len goto END

    slli t5, t0, 2 # t5 = i * 4 because each int is 4 bytes
    add t5, t3, t5 # t5 = address of nums[i]
    lw t2, 0(t5) # t2 = nums[i]

    andi t6, t2, 1 # t6 = nums[i] % 2. If 0 then even
    bne t6, x0, SKIP # if remainder!= 0, skip
    addi t1, t1, 1 # count++

SKIP:
    addi t0, t0, 1 # i++
    j LOOP

END:
    # print "Even count = "
    la a0, msg
    li a7, 4
    ecall

    # print count
    mv a0, t1
    li a7, 1
    ecall

    # exit
    li a7, 10
    ecall