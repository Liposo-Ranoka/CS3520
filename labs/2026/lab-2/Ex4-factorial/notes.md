# Exercise 4: Recursive Factorial

## Purpose
Calculate factorial recursively. For n = 3, the result is 6.

## Logic
- main places 3 in a0 and calls factorial.
- Each call saves ra and the original n on the stack.
- If n <= 1, return 1.
- Otherwise, call factorial(n - 1) and multiply its result by n.
- Restore ra, release the stack frame and return.

## Registers
- a0: Input n and returned result.
- ra: Return address.
- sp: Stack pointer.
- t0: Base-case constant, then the saved n.
- a7: Ripes service number.

## Stack
Each call reserves 16 bytes:
- 12(sp): Saved return address.
- 8(sp): Saved n.

## Expected output
6

## Key point
Recursion overwrites ra and a0, so both must be saved.
