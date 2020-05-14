module ALU_TOP #(
    parameter DATA_WIDTH   = 32,
) (
    input [DATA_WIDTH-1   : 0] 	PC_IN,
    input [DATA_WIDTH-1   : 0] 	RS1_IN,
    input [DATA_WIDTH-1   : 0] 	RS2_IN, 
    input [DATA_WIDTH-1   : 0] 	IMM_IN, 
    input [6 : 0]               OPCODE,
    input [2 : 0]               FUNCT3,
    input [6 : 0]               FUNCT7,
    input [6 : 0]               TYPES,

    output [DATA_WIDTH-1 : 0] 	ALU_OUT
);

// types = { R-type, I-type, L-type, S-type, J-type, B-type, U-type }

wire [DATA_WIDTH-1 : 0] bus_A1, bus_A;
wire [DATA_WIDTH-1 : 0] bus_B;
wire [3: 0]             alu_ctrl;

wire is_type_R, is_type_I, is_type_L, is_type_S, is_type_J, is_type_B, is_type_U;
wire op_add, op_jal, op_reg, op_lui;

/*
* Type
*/
assign is_type_R = types[6];
assign is_type_I = types[5];
assign is_type_L = types[4];
assign is_type_S = types[3];
assign is_type_J = types[2];
assign is_type_B = types[1];
assign is_type_U = types[0];

assign op_add = is_type_L | is_type_S | is_type_J | is_type_U;
assign op_jal = (is_type_J & ~is_type_I) | is_type_B | is_type_U;   // (J & ~I) captures the JALR which should use RS1 
assign op_reg = is_type_R;

Mux_2_to_1 MUX_UP(
    .in_1(PC_IN), 
    .in_2(RS1_IN), 
    .out(bus_A1), 
    .CTRL(op_jal)
    );

assign op_lui = is_type_U && OPCODE[5];
assign bus_A  = (op_lui)? DATA_WIDTH{1'b0} : bus_A1;  // Adding support for LUI and AUIPC

Mux_2_to_1 MUX_DOWN(
    .in_1(RS2_IN), 
    .in_2(IMM_IN), 
    .out(bus_B), 
    .CTRL(op_reg)
    );

//************************************************
//  ALU_CTRL => { FUNC3 , FUNC7[5] }
//************************************************
//  000-0 : ADD
//  000-1 : SUB
//  001-0 : SLL
//  010-0 : SLT
//  011-0 : SLTU
//  100-0 : XOR
//  101-0 : SRL
//  101-1 : SRA
//  110-0 : OR
//  111-0 : AND
//*************************************************
assign alu_ctrl = (op_add)? 4'b0000 : { FUNCT3, FUNCT7[5] };

ALU alu_a(
    .bus_A(bus_A),
    .bus_B(bus_B),
    .alu_ctrl(alu_ctrl),
    .bus_out(ALU_OUT)
    );


endmodule
