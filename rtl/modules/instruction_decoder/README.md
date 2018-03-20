# Instruction Decoder

This module will be decoding RISC-V 32I instructions
The following control signals are subjected to change.

## ALU Control Signals ##

is\_alu\_op signal works as the enable signal of ALU.
is\_type\_R select whether the instruction is R or I type.
In addtion instruction decoder will output following control signals to the ALU

index|  name       | Length | Description
-----|-------------|--------|-----------------------------
0    | funct7\_5   | 1      | Describe the specialize functionality
3:1  | funct3      | 3      | Describe the type of alu operation


### Based on the above signals decoded ALU opeartion is follows ###

 Encoding | Operation | Description
    3:1 0 |           |
----------|-----------|--------------
    000 0 | ADD       | Addition
    000 1 | SUB       | Substration
    001 0 | SLL       | Logical left shift
    010 0 | SLT       | Less than rd = rs1 < rs2
    011 0 | SLTU      | Unsigned SLT
    100 0 | XOR       | XOR
    101 0 | SRL       | Logical right shift
    101 1 | SRA       | Arithmatic right shift
    110 0 | OR        | OR
    111 0 | AND       | AND
