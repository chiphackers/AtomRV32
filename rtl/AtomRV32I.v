module AtomRV32I #(
    parameter XLEN = 32,
    parameter REG_ADDR_LEN = $clog2(XLEN)
)(
    input clk,
    input [XLEN-1:0] instr
);

wire [REG_ADDR_LEN-1: 0] rs1, rs2, rd;
wire [XLEN-1: 0]         r_data1, r_data2, wr_data, im_data;
wire [2:0] funct3;
wire [6:0] funct7;
wire is_type_R, is_type_I, is_type_S, is_type_B, is_type_U, is_type_J;
wire is_alu_op;

instruction_decoder unit_id(
    .instr(instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .funct3(funct3),
    .funct7(funct7),
    .is_type_R(is_type_R),
    .is_type_I(is_type_I),
    .is_type_S(is_type_S),
    .is_type_B(is_type_B),
    .is_type_U(is_type_U),
    .is_type_J(is_type_J),
    .is_alu_op(is_alu_op)
);

immediate unit_imm(
    .instruction(instr),
    .is_type_I(is_type_I),
    .is_type_S(is_type_S),
    .is_type_B(is_type_B),
    .is_type_U(is_type_U),
    .is_type_J(is_type_J),
    .imm_out(im_data)
);

register_file unit_regfile(
    .clk(clk),
    .wr_en(1'b0),
    .rs1(rs1),
    .rs2(rs2),
    .wr_addr(rd),
    .wr_data(wr_data),
    .rd_data_1(r_data1),
    .rd_data_2(r_data2)
);

ALU_TOP unit_alu(
    .PC_IN(32'b0),
    .RS1_IN(r_data1),
    .RS2_IN(r_data2),
    .IMM_IN(im_data),
    .ALU_CTRL({funct3, funct7[5]}),
    .MUX1_CTRL(1'b0),
    .MUX2_CTRL(is_type_R),
    .ALU_OUT(wr_data)
);

endmodule
