# Exercise 2: Sum of the First N Integers

## Purpose
Calculate and print the sum from 1 to N.

## Logic
- Load N into t0; initialize counter t1 = 1 and sum t2 = 0.
- bgt branches to END when the counter exceeds N.
- add adds the counter to the sum.
- addi increments the counter; j LOOP repeats.
- At END, print the messages, N and the sum.

## Registers
- t0: N.
- t1: Loop counter.
- t2: Running sum.
- a0: Integer or string address to print.
- a7: Ripes service: 1 prints an integer,
  4 prints a string, and 10 exits.

## Expected output
The sum of the first 5 integer is 15

## Key point
bgt is a pseudo-instruction equivalent to blt t0, t1, END.
The loop includes N before stopping.