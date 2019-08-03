module ALU_TOP #(
    parameter DATA_WIDTH   = 32,
    parameter FUNC_WIDTH   = 5,
    parameter OPCODE_WIDTH = 7
) (
    input [DATA_WIDTH-1   : 0] 	PC_IN,
    input [DATA_WIDTH-1   : 0] 	RS1_IN,
    input [DATA_WIDTH-1   : 0] 	RS2_IN, 
    input [DATA_WIDTH-1   : 0] 	IMM_IN, 
    input [OPCODE_WIDTH-1 : 0]  OPCODE,
    input [2 : 0]               FUNCT3,
    input [6 : 0]               FUNCT7,
    input 						MUX1_CTRL,

    output [DATA_WIDTH-1 : 0] 	ALU_OUT
);


// OPCODE code names from Risc-V ISA manual
localparam BRANCH = 7'b1100011;
localparam OP     = 7'b0110011;
localparam OP_IMM = 7'b0010011;
localparam JAL    = 7'b1101111;
localparam JALR   = 7'b1100111;



wire [DATA_WIDTH-1 : 0] bus_A;
wire [DATA_WIDTH-1 : 0] bus_B;

wire is_type_R, is_type_B, is_type_J;
wire is_alu_op, is_mem_op;
wire [FUNC_WIDTH-1:0] ALU_CTRL;

assign is_type_R = (OPCODE == OP    )? 1'b1 : 1'b0;
assign is_type_B = (OPCODE == BRANCH)? 1'b1 : 1'b0;
assign is_type_J = (OPCODE == JAL  || OPCODE == JALR  )? 1'b1 : 1'b0;
assign is_alu_op = (OPCODE == OP   || OPCODE == OP_IMM)? 1'b1 : 1'b0;

assign ALU_CTRL = (is_alu_op)? {1'b0, FUNCT3, FUNCT7[5]} : 5'b00000;

Mux_2_to_1 MUX_UP(
    .in_1(PC_IN), 
    .in_2(RS1_IN), 
    .out(bus_A), 
    .CTRL(is_type_B | is_type_J)
    );

Mux_2_to_1 MUX_DOWN(
    .in_1(RS2_IN), 
    .in_2(IMM_IN), 
    .out(bus_B), 
    .CTRL(is_type_R)
    );

ALU alu_a(
    .bus_A(bus_A),
    .bus_B(bus_B),
    .func3(FUNCT3),
    .func7(FUNCT7),
    .bus_out(ALU_OUT)
    );


endmodule
