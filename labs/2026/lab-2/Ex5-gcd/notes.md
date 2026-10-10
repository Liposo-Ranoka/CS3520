# Exercise 5: Greatest Common Divisor

## Purpose
Find the GCD of 14 and 21 using Euclid’s algorithm.

## Logic
- Load the inputs into a0 and a1, then call gcd.
- If a1 is zero, return a0.
- Otherwise, calculate the remainder using rem.
- Replace a0 with a1 and a1 with the remainder.
- Repeat until a1 becomes zero, then return and print.

## Registers
- a0: First number and final GCD.
- a1: Second number.
- t0: Remainder.
- ra: Return address.
- a7: Ripes service number.

## Trace
(14, 21) → (21, 14) → (14, 7) → (7, 0)

## Expected output
7

## Key point
rem requires the M extension. No stack frame is needed
because gcd calls no other procedure and changes no saved registers.