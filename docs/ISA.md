# ALU operations

## Register(R-type) instructions

| No | func 7  | rs2 | rs1 | func 3 | rd | opcode  | Assem | Sym                     |
| -- | ------- | --- | --- | ------ | -- | ------- | ----- | ----------------------- |
|  1 | 0000000 |     |     |   000  |    | 0110011 | ADD   | rd = rs1 + rs2          |
|  2 | 0100000 |     |     |   000  |    | 0110011 | SUB   | rd = rs1 - rs2          |       
|  3 | 0000000 |     |     |   001  |    | 0110011 | SLL   | rd = rs1 << rs2[4:0]    |
|  4 | 0000000 |     |     |   010  |    | 0110011 | SLT   | rd =(S(rs1)<S(rs2))? 1:0|
|  5 | 0000000 |     |     |   011  |    | 0110011 | SLTU  | rd = (rs1 < rs2)? 1 : 0 |
|  6 | 0000000 |     |     |   100  |    | 0110011 | XOR   | rd = rs1 ^ rs2          |
|  7 | 0000000 |     |     |   101  |    | 0110011 | SRL   | rd = rs1 >> rs2[4:0]    |
|  8 | 0100000 |     |     |   101  |    | 0110011 | SRA   | rd = S(rs1 >> rs2[4:0]) |
|  9 | 0000000 |     |     |   110  |    | 0110011 | OR    | rd = rs1 or rs2         |
| 10 | 0000000 |     |     |   111  |    | 0110011 | AND   | rd = rs1 & rs2          |

## Immediate(I-type) instructions 

| No | imm 12          | rs1 | func 3 | rd | opcode  | Assem | Sym                     |
| -- | --------------  | --- | ------ | -- | ------- | ----- | ------------------------|
|  1 |                 |     |   000  |    | 0010011 | ADDI  | rd = rs1 + S(imm)       |
|  2 |                 |     |   010  |    | 0010011 | SLTI  | rd = (rs1< S(imm))? 1:0 |
|  3 |                 |     |   011  |    | 0010011 | SLTIU | rd = (rs1<  imm)? 1 : 0 |
|  4 |                 |     |   100  |    | 0010011 | XORI  | rd = rs1 ^ S(imm)       |
|  5 |                 |     |   110  |    | 0010011 | ORI   | rd = rs1 or S(imm)      |
|  6 |                 |     |   111  |    | 0010011 | ANDI  | rd = rs1 & S(imm)       |
|  7 | 0000000 - shamt |     |   001  |    | 0010011 | SLLI  | rd = rs1 << shamt       |
|  8 | 0000000 - shamt |     |   101  |    | 0010011 | SRLI  | rd = rs1 >> shamt       |
|  9 | 0100000 - shamt |     |   101  |    | 0010011 | SRAI  | rd = S(rs1 >> shamt)    |

## Immediate(U-type) instruction

| No | imm 20                         | rd | opcode  | Assem | Sym                     |
| -- | ------------------------------ | -- | ------- | ----- | ------------------------|
|  1 |                                |    | 0110111 | LUI   | rd = {imm,12{1'b0}}     |
|  2 |                                |    | 0010111 | AUIPC | rd = PC + {imm,12{1'b0}}|

# Control operations

## J-type encoded (Unconditional Jumps)

| No | imm 19                    | rd | opcode  | Assem | Sym                          |
| -- | ------------------------- | -- | ------- | ----- | -----------------------------|
|  1 |                           |    | 1101111 | JAL   | rd = PC+4; PC = PC + S(imm19)|

| No | imm 12     | rs1 | func 3 | rd | opcode  | Assem | Sym                          |
| -- | ---------- | --- | ------ | -- | ------- | ----- | -----------------------------|
|  1 |            |     |   000  |    | 1100111 | JALR  | rd = PC+4; PC = rs1+S(imm12) |

## B-type encoded (Conditional Jumps)

| No | imm 12:10-5 | rs2 | rs1 | func 3 | imm 4-1:11 | opcode  | Assem | Sym                             | 
| -- | ------------| --- | --- | ------ | ---------- | ------- | ----- |---------------------------------|
|  1 |             |     |     |   000  |            | 1100011 | BEQ   | if(rs1 == rs2) PC += imm        |
|  2 |             |     |     |   001  |            | 1100011 | BNE   | if(rs1 != rs2) PC += imm        |
|  3 |             |     |     |   100  |            | 1100011 | BLT   | if(S(rs1) <  S(rs2)) PC += imm  |
|  4 |             |     |     |   101  |            | 1100011 | BGE   | if(S(rs1) >= S(rs2)) PC += imm  |
|  5 |             |     |     |   110  |            | 1100011 | BLTU  | if(rs1 <  rs2) PC += imm        |
|  6 |             |     |     |   111  |            | 1100011 | BGEU  | if(rs1 >= rs2) PC += imm        |

# Memory operations

## L-type encoded (LOAD)

| No | imm 12          | rs1 | func 3 | rd | opcode  | Assem | Sym                           | 
| -- | --------------- | --- | ------ | -- | ------- | ----- | ----------------------------- |
|  1 |                 |     |   000  |    | 0000011 | LB    | rd = S(mem(rs1+offset)[7:0])  |
|  2 |                 |     |   001  |    | 0000011 | LH    | rd = S(mem(rs1+offset)[15:0]) |
|  3 |                 |     |   010  |    | 0000011 | LW    | rd = S(mem(rs1+offset)[31:0]) |
|  4 |                 |     |   100  |    | 0000011 | LBU   | rd = mem(rs1+S(offset))[7:0]  |
|  5 |                 |     |   101  |    | 0000011 | LHU   | rd = mem(rs1+S(offset))[15:0] |

## S-type encoded (STORE)

| No | imm 12[11:5] | rs2 | rs1 | func 3 | imm12[4:0] | opcode  | Assem | Sym                           | 
| -- | ------------ | --- | --- | ------ | ---------- | ------- | ----- | ----------------------------- |
|  1 |              |     |     |   000  |            | 0100011 | SB    | mem(rs1+S(offset)) = rs2[7:0] |
|  2 |              |     |     |   001  |            | 0100011 | SH    | mem(rs1+S(offset)) = rs2[15:0]|  
|  3 |              |     |     |   010  |            | 0100011 | SW    | mem(rs1+S(offset)) = rs2      |  
