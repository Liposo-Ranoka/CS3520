# Lab 3: Trace Tables

## Step 3: Single Instruction Trace (add t2, t0, t1)

Instruction executing at `PC = 0x00000008`: `add t2, t0, t1`  
Initial register values: `t0 = 12`, `t1 = 5`  
Expected result: `t2 = 17`

| Element | Port | Value | Notes |
| :--- | :--- | :--- | :--- |
| pc_reg | out | 0x00000008 | Address of executing instruction |
| pc_4 | out | 0x0000000C | Next sequential PC (PC + 4) |
| instr_mem | data_out | 0x006283B3 | 32-bit machine code for add t2, t0, t1 |
| decode | r1_reg_idx / r2_reg_idx | 5 / 6 | Register indices for t0 (x5) and t1 (x6) |
| decode | wr_reg_idx | 7 | Destination register index for t2 (x7) |
| control | reg_do_write_ctrl | 1 | RegWrite enabled |
| control | alu_op2_ctrl | 0 | Selects register r2_out instead of immediate |
| registerFile | r1_out / r2_out | 12 / 5 | Values read from t0 and t1 |
| alu_op1_src | out | 12 | Selected r1_out |
| alu_op2_src | out | 5 | Selected r2_out |
| alu | res | 17 | Result of 12 + 5 |
| data_mem | wr_en | 0 | MemWrite disabled |
| reg_wr_src | select / out | 0 / 17 | Selects ALU result to write back |
| pc_src | select / out | 0 / 0x0000000C | Selects PC + 4 for sequential execution |

### Step 3 Think Question
- **Where did the value on data_mem.addr come from?**  
  It comes directly from `alu.res` (17). The ALU output is physically wired to the data memory address input on the datapath.
- **Why is it harmless?**  
  It is harmless because `data_mem.wr_en` is 0, so no memory write happens. Also, the write-back multiplexer selects the ALU output rather than data memory output, so whatever memory reads is completely ignored.
- **What is it costing the machine?**  
  It wastes dynamic power. The address bits toggling causes internal charging and discharging in the memory address decoders even though memory is not being used.

---

## Step 4: Instruction Class Trace Table

Traced from `trace-classes.s` on the single-cycle processor:

| Instruction | Format | imm | op1 mux | op2 mux | alu.res | wb mux / pc mux |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| addi t0, zero, 12 | I-type | 12 | Register (0) | Immediate (12) | 12 | wb mux = ALU (12) / pc mux = PC+4 |
| add t2, t0, t1 | R-type | - | Register (12) | Register (5) | 17 | wb mux = ALU (17) / pc mux = PC+4 |
| lui t4, 0x2B | U-type | 0x2B000 (176128) | Constant 0 | Immediate (0x2B000) | 176128 | wb mux = ALU (176128) / pc mux = PC+4 |
| auipc t5, 0x0 | U-type | 0 | PC (0x14) | Immediate (0) | 20 | wb mux = ALU (20) / pc mux = PC+4 |
| lw a1, 0(a0) | I-type | 0 | Register (0x10000000) | Immediate (0) | 0x10000000 | wb mux = Memory (42) / pc mux = PC+4 |
| sw t2, 4(a0) | S-type | 4 | Register (0x10000000) | Immediate (4) | 0x10000004 | wb mux = Discard (RegWrite=0) / pc mux = PC+4 |
| beq t0, t1, skip | B-type | 8 | PC (0x28) | Immediate (8) | 0x30 | wb mux = Discard (RegWrite=0) / pc mux = PC+4 |
| bne t0, t1, target | B-type | 8 | PC (0x2C) | Immediate (8) | 0x34 | wb mux = Discard (RegWrite=0) / pc mux = Target (0x34) |
| jal ra, report | J-type | 12 | PC (0x34) | Immediate (12) | 0x40 | wb mux = PC+4 (0x38 in ra) / pc mux = Target (0x40) |
| jalr zero, ra, 0 | I-type | 0 | Register (0x38) | Immediate (0) | 0x38 | wb mux = PC+4 (rd=x0) / pc mux = Target (0x38) |

---

## Step 5: Processor Statistics

From the Statistics and Instruction Memory panels after running `trace-classes.s`:

- Instructions listed in memory panel: 18 (17 lines in source, but `la` expands to two instructions: `auipc` and `addi`)
- Instructions retired: 17 (`addi a2, zero, 99` at `skip` is not executed because `bne` is taken)
- Cycles elapsed: 17
- CPI: 1.00
- IPC: 1.00
