.text
main:
    li a0, 14
    li a1, 21

    jal ra, gcd

    li a7, 1
    ecall

    li a7, 10
    ecall

gcd:
gcd_loop:
    beq a1, zero, gcd_done

    rem t0, a0, a1
    mv a0, a1
    mv a1, t0

    j gcd_loop

gcd_done:
    jalr zero, ra, 0