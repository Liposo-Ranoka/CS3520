# Exercise 1: Compare Two Integers

## Purpose
Print the larger of two integers, or " equal" if they match.

## Logic
- Load num1 into t0 and num2 into t1.
- beq branches to EQUAL if the values match.
- blt branches to NUM2 if num1 is smaller.
- Otherwise, print num1.
- j EXIT skips the remaining output blocks.

## Registers
- t0, t1: Input integers.
- a0: Integer value or string address to print.
- a7: Ripes service number: 1 prints an integer,
  4 prints a string, and 10 exits.

## Expected output
For num1 = 17 and num2 = 18:
18 is larger

## Key point
lw loads a value; la loads an address.
Equal inputs print " equal" without a newline.