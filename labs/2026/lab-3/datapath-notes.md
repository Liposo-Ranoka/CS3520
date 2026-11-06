# Datapath Notes

## Step 4: Questions

### 1. lui vs auipc
Both `lui` and `auipc` use the U-type format and encode a 20-bit immediate shifted left by 12 bits. The difference is the ALU first operand multiplexer (`alu_op1_src`):
- For `lui`, `alu_op1_src` selects constant 0, so the ALU computes `0 + imm = imm`.
- For `auipc`, `alu_op1_src` selects the current PC, so the ALU computes `PC + imm`.

### 2. sw control and write-back
`sw` writes a value to memory and must not overwrite any register in the register file. The single control signal that prevents this is `reg_do_write_ctrl` (RegWrite), which is set to 0.  
Meanwhile, the write-back multiplexer (`reg_wr_src`) still selects an input (the ALU output address), but the register file ignores the data on the write bus because write enable is turned off.

### 3. Path from branch unit to pc_src
Both `beq` and `bne` compare `t0` (12) and `t1` (5):
1. `r1_out` and `r2_out` go into the dedicated `branch` comparison block, which evaluates the condition using funct3.
   - For `beq`, 12 == 5 is false, so the comparator output is 0.
   - For `bne`, 12 != 5 is true, so the comparator output is 1.
2. The comparator output feeds into an AND gate (`br_and`) along with `branch_ctrl` from the control unit (which is 1 for branch instructions).
   - `beq`: 0 AND 1 = 0.
   - `bne`: 1 AND 1 = 1.
3. The AND gate output goes into an OR gate (`controlflow_or`) alongside the unconditional jump control signal (which is 0 here).
   - `beq`: 0 OR 0 = 0.
   - `bne`: 1 OR 0 = 1.
4. The OR gate output drives `pc_src.select`.
   - For `beq`: select is 0, so `pc_src` passes sequential `PC + 4`.
   - For `bne`: select is 1, so `pc_src` passes the branch target address computed by the ALU.

### 4. Return address in jal and jalr
Both `jal` and `jalr` need to save `PC + 4` into register `ra`.
The return address is supplied by the third input of the write-back multiplexer (`reg_wr_src`), which connects directly to `pc_4.out`.
- The ALU cannot supply `PC + 4` because it is already computing the jump target address (`PC + imm` for `jal`, and `rs1 + imm` for `jalr`). A single ALU cannot perform two additions at once in a single cycle.
- Data memory cannot supply it because the return address is not a data value stored in RAM. Accessing memory would waste a memory cycle and read unrelated memory content.

---

## Step 5: Performance and Clock Period Trade-off

The simulator reports CPI = 1.00 for the single-cycle processor.
From the CPU time formula:
`CPU time = Instruction Count * CPI * Clock Period (Tc)`

While CPI = 1.00 is the best possible value for CPI, this design sacrifices the clock period `Tc` (clock rate). In a single-cycle design, every instruction must complete in one clock cycle, so the clock period is limited by the worst-case path through the hardware. That is the `lw` instruction, which must do instruction fetch, register read, ALU address calculation, data memory read, and register write-back all in one cycle.

In a 5-stage pipelined processor, each stage takes only one sub-operation per cycle, so the clock period is about 4 to 5 times shorter. The single-cycle design sacrifices clock frequency by roughly a factor of 4 to 5.

---

## Step 6: Ripes Implementation vs Textbook Datapath

### Finding A: Branch Target Calculation
- **Textbook:** Uses a dedicated branch adder separate from the ALU to compute `PC + offset`.
- **Ripes implementation:** Has no second adder. It computes the branch target using the main ALU by setting `alu_op1_src` to PC and `alu_op2_src` to immediate.
- **Advantage:** Eliminating the second 32-bit adder saves a significant amount of hardware area and circuit complexity.

### Finding B: Branch Condition Evaluation
- **Textbook:** Uses the main ALU to subtract `rs1 - rs2` and checks the ALU Zero flag for equality (`beq`).
- **Ripes implementation:** Uses a separate dedicated comparison unit (`branch`).
- **Advantage:**
  1. Frees the main ALU to compute the branch target address during the same cycle.
  2. The Zero flag can only test equality/inequality. A dedicated comparator can also test signed and unsigned relational conditions needed by RISC-V (`blt`, `bge`, `bltu`, `bgeu`).

### Finding C: Write-Back Multiplexer
- **Textbook:** Uses a 2-input `MemtoReg` multiplexer selecting between ALU result and Memory data.
- **Ripes implementation:** Uses a 3-input write-back multiplexer (`reg_wr_src`). The third input is connected to `pc_4.out` (`PC + 4`).
- **Advantage:** Allows `jal` and `jalr` to write the return address (`PC + 4`) directly into the register file in a single cycle without having to pass it through the ALU.

### Step 6 Think: Dedicated Adder vs Shared ALU Trade-Off
- **Dedicated Branch Adder (Textbook):** Branch target calculation is completely independent of the ALU, but requires extra hardware area and power for a second adder. This is standard in pipelined processors where arithmetic and branch calculations must happen in different stages or concurrently.
- **Shared ALU (Ripes):** Reuses the main ALU for the target address to save chip area, but requires a separate comparison unit. This is a good trade-off in simple single-cycle processors where chip area and simplicity are top priorities.

---

## Part B: Pipelining and Hazard Notes

### Step 10: Using lui instead of la in hazard-loaduse.s
`la` is a pseudo-instruction that expands to two real instructions: `auipc` followed by `addi`. The `addi` depends immediately on `auipc` at distance 1, which creates a data hazard during address setup.
Using `lui a0, 0x10000` followed by two `nop` instructions sets up the base address without any data hazards. That way, the program tests only the load-use hazard between `lw` and `addi`.

### Step 11: Load-bearing NOPs before ecall
In a 5-stage pipeline without forwarding:
- `addi a7, zero, 10` writes its result to the register file in the WB stage (stage 5).
- `ecall` reads `a7` in the ID stage (stage 2).
The distance between ID and WB is 3 stages. Without forwarding or hazard stalling, if `ecall` comes right after `addi a7`, `ecall` will read `a7` before the write-back happens, reading an old or uninitialized value.
The three `nop` instructions provide the 3 delay slots needed for `addi a7` to reach the WB stage and commit before `ecall` reads `a7`.

### Summary of Part B Programs
1. **pipeline-basic.s:** 8 instructions with no dependencies or branches. Runs through the 5 stages with no stalls, measuring the pure cost of filling and draining the pipeline (11 instructions + 4 cycles = 15 cycles).
2. **hazard-raw.s:** Tests RAW dependencies on `t0` at distances 1, 2, and 3. Without forwarding, distance 1 and 2 read stale values (t1 = 3, t2 = 100), while distance 3 reads the updated value (t3 = 1007) due to split-phase register access. With forwarding enabled, all three get correct values (10, 107, 1007).
3. **hazard-loaduse.s:** `lw` produces its result at the end of the MEM stage, but `addi` needs it at the beginning of EX. Forwarding cannot send data backward in time, so the processor must stall by 1 cycle (inserting a bubble).
4. **hazard-control.s:** When the branch is taken in the EX stage, the two instructions fetched behind it (`addi t2` and `addi t3`) are flushed so they do not take effect. The two `nop`s before `beq` isolate the control hazard by ensuring `t0` and `t1` are already committed before the branch evaluates.
