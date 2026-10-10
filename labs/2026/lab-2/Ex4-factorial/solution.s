.text
main:
    li a0, 3                 # Argument: n = 3
    jal ra, factorial        # Call factorial(3)

    # Returned answer is in a0
    li a7, 1                 # Print integer
    ecall

    li a7, 10                # Exit program
    ecall


factorial:
    # Create a separate stack frame for this call
    addi sp, sp, -16
    sw ra, 12(sp)            # Save this call's return address
    sw a0, 8(sp)             # Save this call's original n

    # Base case: if n <= 1, return 1
    li t0, 1
    bge t0, a0, base_case

    # Recursive case: factorial(n - 1)
    addi a0, a0, -1
    jal ra, factorial

    # a0 now contains factorial(n - 1)
    lw t0, 8(sp)             # Recover original n
    mul a0, t0, a0           # Result = n * factorial(n - 1)
    j factorial_return

base_case:
    li a0, 1

factorial_return:
    lw ra, 12(sp)            # Recover this call's return address
    addi sp, sp, 16          # Release this call's stack frame
    jalr zero, ra, 0         # Return to caller
    