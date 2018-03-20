module instruction_decoder#(
    parameter XLEN = 32,
    parameter OP_LEN = 7,
	parameter REG_FILE_DEPTH = 32,
    parameter REG_FILE_ADDR_LEN = $clog2(REG_FILE_DEPTH)
)(
    input [XLEN-1:0] instr,
    
    output reg [REG_FILE_ADDR_LEN-1:0] rs1, //read address 1
    output reg [REG_FILE_ADDR_LEN-1:0] rs2, //read address 2
    output reg [REG_FILE_ADDR_LEN-1:0] rd,  //write address

    // Following registers are holding different parts of the instruction
    // Validity of the data contain in them depends on the tpe of instruction
    output reg [2:0] funct3,
    output reg [6:0] funct7,

    // Following registers are indicating the instruction type
    output reg is_type_R, is_type_I, is_type_S, is_type_B, is_type_U, is_type_J,
    // special control signals
    output reg is_alu_op
);

    always @(*) begin
        is_type_R  = (instr[OP_LEN-1:0] == 7'b0110011);
        is_type_I  = (instr[OP_LEN-1:0] == 7'b1100111) | (instr[OP_LEN-1:0] == 7'b0000011) | (instr[OP_LEN-1:0] == 7'b0010011);
        is_type_S  = (instr[OP_LEN-1:0] == 7'b0100011);
        is_type_B  = (instr[OP_LEN-1:0] == 7'b1100011);
        is_type_U  = (instr[OP_LEN-1:0] == 7'b0110111) | (instr[OP_LEN-1:0] == 7'b0010111);
        is_type_J  = (instr[OP_LEN-1:0] == 7'b1101111);


        is_alu_op  = (instr[OP_LEN-1:0] == 7'b0110011) | (instr[OP_LEN-1:0] == 7'b0010011);

        funct3 = instr[14:12];
        funct7 = instr[31:25];
        rd     = instr[11:7];
        rs1    = instr[19:15];
        rs2    = instr[24:20];
    end

endmodule
