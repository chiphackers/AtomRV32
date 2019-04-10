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
wire [XLEN-1: 0]         r_data1, r_data2, wdata, im_data, mem_data;

/*
* pipeline registers
*
* NOTE: Named after the pipeline stage the register send data
*/
reg [REG_ADDR_LEN-1:0] r_ex_rs1, r_ex_rs2, r_ex_rd;
reg [XLEN-1:0]         r_ex_inst, r_ex_pc;

reg [REG_ADDR_LEN-1:0] r_mem_rs2;
reg [XLEN-1:0]         r_mem_wdata, r_mem_inst, r_mem_pc;

reg [REG_ADDR_LEN-1:0] r_wb_rs2;
reg [XLEN-1:0]         r_wb_wdata, r_wb_inst, r_wb_pc;

/*
* Module instantiation
*/

instruction_decoder unit_id(
    .instr(instr),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
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

/*
* stage #2 pipeline begin (execution)
*/
always@(posedge clk) begin
    if(~rst_n) begin
        r_ex_pc     <= PC_RESET;
        r_ex_rs1    <= 32'h0;
        r_ex_rs2    <= 32'h0;
        r_ex_inst   <= 32'h0;
    end else begin
        r_ex_pc     <= PC;
        r_ex_rs1    <= rs1;
        r_ex_rs2    <= rs2;
        r_ex_instr  <= instr;
    end
end
/*
* stage #2 pipeline end
*/


immediate unit_imm(
    .instr(r_ex_instr),
    .imm_out(im_data)
);

ALU_TOP unit_alu(
    .PC_IN(r_ex_pc),
    .RS1_IN(r_ex_rs1),
    .RS2_IN(r_ex_rs2),
    .IMM_IN(im_data),
    .OPCODE(r_ex_instr[6:0]),
    .FUNCT3(r_ex_instr[14:12]),
    .FUNCT7(r_ex_instr[31:25]),
    .MUX1_CTRL(1'b0),
    .ALU_OUT(wdata)
);

/*
* stage #3 pipeline begin (memory)
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
* stage #3 pipeline end
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
* stage #4 pipeline begin   (write back)
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

assign wb_rd = r_wb_inst[11:7];

endmodule
