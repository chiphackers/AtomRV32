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
wire [6:0]               funct7, types;
wire [XLEN-1: 0]         r_data1, r_data2, alu_out, im_data, mem_data, wb_wdata;
wire                     ex_type_J, ex_type_B, ex_type_U, wb_en, wb_type_L, wb_type_S, wb_type_J;
wire                     w_take_branch, w_op_auipc;

/*
* pipeline registers
*
* NOTE: Named after the pipeline stage the register send data
*/

reg [XLEN-1: 0]        r_de_pc, r_de_inst;

reg [REG_ADDR_LEN-1:0] r_ex_rs1, r_ex_rs2, r_ex_rd;
reg [XLEN-1:0]         r_ex_inst, r_ex_pc, r_ex_imm;
reg [2:0]              r_ex_funct3;
reg [6:0]              r_ex_opcode, r_ex_funct7, r_ex_types;

reg [REG_ADDR_LEN-1:0] r_mem_alu_out, r_mem_pc;

reg [REG_ADDR_LEN-1:0] r_wb_rd;
reg [6:0]              r_wb_types;


/*
* stage #1 pipeline begin (fetch)
*/
always@(posedge clk)begin
    if(~rst_n) begin
        PC <= PC_RESET;
    end else begin
        if(w_take_branch)
            PC <= alu_out;
        else
            PC <= PC + 32'h1;
        end
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
*
* types is a 7-bit wide bus which indicate the type of opcode
* types = {is_type_R, is_type_I, is_type_L, is_type_S, is_type_J, is_type_B, is_type_U};
*/

instruction_decoder unit_id(
    .instr(r_de_inst),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .types(types)
);

register_file unit_regfile(
    .clk(clk),
    .wr_en(wb_en),
    .rs1(rs1),
    .rs2(rs2),
    .wr_addr(wb_rd),
    .wr_data(wb_wdata),
    .rd_data_1(r_data1),
    .rd_data_2(r_data2)
);

immediate unit_imm(
    .instr(r_de_instr),
    .opcode(opcode),
    .funct3(funct3),
    .types(types),
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
        r_ex_rd     <= 32'h0;
        r_ex_imm    <= 32'h0;
        r_ex_opcode <= 7'h0;
        r_ex_funct3 <= 3'h0;
        r_ex_funct7 <= 7'h0;
        r_ex_types  <= 7'h0;
    end else begin
        r_ex_pc     <= PC;
        r_ex_rs1    <= r_data1;
        r_ex_rs2    <= r_data2;
        r_ex_rd     <= rd;
        r_ex_imm    <= im_data;
        r_ex_opcode <= opcode;
        r_ex_funct3 <= func3;
        r_ex_funct7 <= funct7;
        r_ex_types  <= types;
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
    .TYPES(r_ex_types),
    .ALU_OUT(alu_out)
);

/*
* take_branch logic
* - if taken PC will be changed
* - JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU
*/
assign ex_type_J = r_ex_types[2];
assign ex_type_B = r_ex_types[1];

always @ (*) begin
    if(ex_type_J)
        w_take_branch = 1'b1;   // JAL and JALR
    else if(ex_type_B) begin
        case(r_ex_funct3)
            3'b000 : w_take_branch = (r_ex_rs1 == r_ex_rs2)? 1'b1 : 1'b0;                       // BEQ
            3'b001 : w_take_branch = (r_ex_rs1 ~= r_ex_rs2)? 1'b1 : 1'b0;                       // BNE
            3'b100 : w_take_branch = ($signed(r_ex_rs1) <  $signed(r_ex_rs2))? 1'b1 : 1'b0;     // BLT
            3'b101 : w_take_branch = ($signed(r_ex_rs1) >= $signed(r_ex_rs2))? 1'b1 : 1'b0;     // BGE
            3'b110 : w_take_branch = (r_ex_rs1 <  r_ex_rs2)? 1'b1 : 1'b0;                       // BLTU
            3'b111 : w_take_branch = (r_ex_rs1 >= r_ex_rs2)? 1'b1 : 1'b0;                       // BGEU
            default: w_take_branch = 1'b0;
        endcase
    end else begin
        w_take_branch = 1'b0;
    end
end

/*
* stage #4 pipeline begin (memory)
*/
always@(posedge clk)begin
    if(~rst_n) begin
        r_mem_pc      <= PC_RESET;
        r_mem_alu_out <= 32'h0;
    end else begin
        r_mem_pc      <= r_ex_pc;
        r_mem_alu_out <= alu_out;
    end
end
/*
* stage #4 pipeline end
*/

/*
* Data Cache
* - This module takes one clock cycles
* - It bypass memory pipeline stage hence addr uses alu_out not r_mem_alu_out
* - LOAD/STORE data value is present in rs_2 which will be taken from r_ex_rs2 to bypass memory pipeline stage
* - types[3] == 1 for S-type instructions which means a store operation.
*/
data_cache unit_dcache (
    .clk(clk),
    .rst_n(rst_n),
    .addr(alu_out),
    .funct3(r_ex_funct3),
    .types(r_ex_types),
    .w_data(r_ex_rs2),
    .r_data(mem_data)
);

/*
* stage #5 pipeline begin   (write back)
*/
always@(posedge clk)begin
    if(~rst_n) begin
        r_wb_rd     <= 32'h0;
        r_wb_types  <= 7'h0;
    end else begin
        r_wb_rd     <= r_ex_rd;
        r_wb_types  <= r_ex_types;
    end
end
/*
* stage #5 pipeline end
*/

assign wb_type_L = r_wb_types[4];
assign wb_type_S = r_wb_types[3];
assign wb_type_J = r_wb_types[2];

always @(*) begin
    case ({wb_type_L, wb_type_J})
        2'b10   : wb_data = mem_data;
        2'b01   : wb_data = r_mem_pc + 32'h1;
        default : wb_data = r_mem_alu_out;
    endcase
end

assign wb_en     = (wb_type_S)?  1'b0 : 1'b1;               // Store commands do not write to register file
assign wb_rd     = r_wb_rd;

endmodule
