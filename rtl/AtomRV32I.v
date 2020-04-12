module AtomRV32I #(
    parameter XLEN = 32,
    parameter REG_ADDR_LEN = $clog2(XLEN),
    parameter PC_RESET = 32'h0000_0000
)(
    input  clk,
    input  rst_n,
    input  [XLEN-1:0] instr,
    output [XLEN-1:0] instr_address,

    input  [XLEN-1:0] mem_in,
    output [XLEN-1:0] mem_out,
    output [XLEN-1:0] mem_addr,
    output [1:0]      mem_ctrl
);

/*
* Program Counter
*/
reg [XLEN-1: 0] PC;
assign instr_address = PC;

/*
* Intermediate wires
*/
wire [REG_ADDR_LEN-1: 0] rs1, rs2, rd, wb_rd;
wire [6:0]               opcode;
wire [2:0]               funct3;
wire [6:0]               funct7;
wire [XLEN-1: 0]         r_data1, r_data2, wdata, im_data, mem_data;

/*
* pipeline registers
*
* NOTE: Named after the pipeline stage the register send data
*/

reg [XLEN-1: 0]        r_de_pc, r_de_inst;

reg [REG_ADDR_LEN-1:0] r_ex_rs1, r_ex_rs2, r_ex_rd;
reg [XLEN-1:0]         r_ex_inst, r_ex_pc, r_ex_imm;
reg [6:0]              r_ex_opcode;
reg [2:0]              r_ex_funct3;
reg [6:0]              r_ex_funct7;

reg [REG_ADDR_LEN-1:0] r_mem_rs2;
reg [XLEN-1:0]         r_mem_wdata, r_mem_inst, r_mem_pc;

reg [REG_ADDR_LEN-1:0] r_wb_rs2;
reg [XLEN-1:0]         r_wb_wdata, r_wb_inst, r_wb_pc;


/*
* stage #1 pipeline begin (fetch)
*/
always@(posedge clk)begin
    if(~rst_n) begin
        PC <= PC_RESET;
    end else begin
        PC <= PC + 32'd4;
    end
end
/*
* stage #1 pipeline end
*/

/*
* stage #2 pipeline begin (decode)
*/
always@(posedge clk) begin
    if(~rst_n) begin
        r_de_pc   <= PC_RESET;
        r_de_inst <= 32'h0; 
    end else begin
        r_de_pc   <= PC;
        r_de_inst <= instr;
    end
end
/*
* stage #2 pipeline end
*/

/*
* Module instantiation
*/

instruction_decoder unit_id(
    .instr(r_de_inst),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7)
);

register_file unit_regfile(
    .clk(clk),
    .wr_en(1'b0),
    .rs1(rs1),
    .rs2(rs2),
    .wr_addr(wb_rd),
    .wr_data(r_wb_wdata),
    .rd_data_1(r_data1),
    .rd_data_2(r_data2)
);

immediate unit_imm(
    .instr(r_de_instr),
    .opcode(opcode),
    .funct3(funct3),
    .imm_out(im_data)
);

/*
* stage #3 pipeline begin (execution)
*/
always@(posedge clk) begin
    if(~rst_n) begin
        r_ex_pc     <= PC_RESET;
        r_ex_rs1    <= 32'h0;
        r_ex_rs2    <= 32'h0;
        r_ex_inst   <= 32'h0;
        r_ex_imm    <= 32'h0;
    end else begin
        r_ex_pc     <= PC;
        r_ex_rs1    <= r_data1;
        r_ex_rs2    <= r_data2;
        r_ex_instr  <= instr;
        r_ex_imm    <- im_data;
    end
end
/*
* stage #3 pipeline end
*/


ALU_TOP unit_alu(
    .PC_IN(r_ex_pc),
    .RS1_IN(r_ex_rs1),
    .RS2_IN(r_ex_rs2),
    .IMM_IN(r_ex_imm),
    .OPCODE(r_ex_opcode),
    .FUNCT3(r_ex_funct3),
    .FUNCT7(r_ex_funct7),
    .ALU_OUT(wdata)
);

/*
* stage #4 pipeline begin (memory)
*/
always@(posedge clk)begin
    if(~rst_n) begin
        r_mem_pc    <= PC_RESET;
        r_mem_rs2   <= 32'h0;
        r_mem_inst  <= 32'h0;
        r_mem_wdata <= 32'h0;
    end else begin
        r_mem_pc    <= r_ex_pc;
        r_mem_rs2   <= r_ex_rs2;
        r_mem_inst  <= r_ex_inst;
        r_mem_wdata <= wdata;
    end
end
/*
* stage #4 pipeline end
*/

/*
* Data Cache
* - This module takes two clock cycles
* - It bypass memory pipeline stage and directly write back to register file
*/
data_cache unit_dcache (
    .clk(clk),
    .rst_n(rst_n),
    .data_addr(wdata),
    .data_i(r_mem_rs2),
    .data_o(mem_data),
    .OPCODE(r_mem_inst[6:0]),
    .FUNCT3(r_mem_inst[2:0]),
    .mem_in(mem_in),
    .mem_out(mem_out),
    .mem_addr(mem_addr),
    .mem_ctrl(mem_ctrl)
);

/*
* stage #5 pipeline begin   (write back)
*/
always@(posedge clk)begin
    if(~rst_n) begin
        r_wb_rs2    <= 32'h0;
        r_wb_wdata  <= 32'h0;
        r_wb_inst   <= 32'h0;
    end else begin
        r_wb_rs2    <= r_mem_rs2;
        r_wb_wdata  <= r_mem_wdata;
        r_wb_inst   <= r_mem_inst;
    end
end
/*
* stage #5 pipeline end
*/

assign wb_rd = r_wb_inst[11:7];

endmodule
