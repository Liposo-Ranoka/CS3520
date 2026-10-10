# Exercise 3: Count Even Numbers

## Purpose
Count and print the number of even integers in an array.

## Logic
- Initialize the array address, length, index and count.
- bge exits when the index reaches the array length.
- slli multiplies the index by 4 to calculate the byte offset.
- add forms the element address; lw loads its value.
- andi checks the last bit: 0 means even, 1 means odd.
- bne skips odd values; otherwise increment the count.
- Increment the index and repeat.

## Registers
- t0: Index.
- t1: Even count.
- t2: Current element.
- t3: Array base address.
- t4: Array length.
- t5: Byte offset, then element address.
- t6: Last-bit test result.
- a0: Print argument.
- a7: Ripes service number.

## Expected output
Even count = 2

## Key point
Only 12 and 6 are even. Each array word occupies 4 bytes.