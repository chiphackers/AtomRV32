module instruction_decoder#(
    parameter XLEN = 32,
	 parameter REG_FILE_DEPTH = 32,
    parameter REG_FILE_ADDR_LEN = $clog2(REG_FILE_DEPTH)
)(
    input [XLEN-1:0] instr,
    
    output reg [REG_FILE_ADDR_LEN-1:0] rs1, //read address 1
    output reg [REG_FILE_ADDR_LEN-1:0] rs2, //read address 2
    output reg [REG_FILE_ADDR_LEN-1:0] rd,  //write address
    output reg [6:0]                   opcode,
    output reg [2:0]                   funct3,
    output reg [6:0]                   funct7,
    output reg [6:0]                   types
);

    // OPCODE code names from Risc-V ISA manual
    localparam OP     = 7'b0110011;
    localparam OP_IMM = 7'b0010011;
    localparam LOAD   = 7'b0000011;
    localparam STORE  = 7'b0100011;
    localparam BRANCH = 7'b1100011;
    localparam JAL    = 7'b1101111;
    localparam JALR   = 7'b1100111;
    localparam LUI    = 7'b0110111;
    localparam AUIPC  = 7'b0010111;

    wire is_type_R, is_type_I, is_type_L, is_type_S, is_type_J, is_type_B, is_type_U;
    wire [6:0] types = {is_type_R, is_type_I, is_type_L, is_type_S, is_type_J, is_type_B, is_type_U};

    /*
    * Type
    * - Special notes
    *   - JALR is actually encoded as an I-type instruction. However we also set is_type_J=1 for JALR since we use this signal to jump
    */
    assign is_type_R = (opcode == OP    )? 1'b1 : 1'b0;
    assign is_type_I = (opcode == OP_IMM || opcode == JALR )? 1'b1 : 1'b0;
    assign is_type_L = (opcode == LOAD  )? 1'b1 : 1'b0;
    assign is_type_S = (opcode == STORE )? 1'b1 : 1'b0;
    assign is_type_J = (opcode == JAL  || opcode == JALR )? 1'b1 : 1'b0;
    assign is_type_B = (opcode == BRANCH)? 1'b1 : 1'b0;
    assign is_type_U = (opcode == LUI  || opcode == AUIPC )? 1'b1 : 1'b0;


    always @(*) begin
        rd     = instr[11:7];
        rs1    = instr[19:15];
        rs2    = instr[24:20];
        opcode = instr[6:0];
        funct3 = instr[14:12];
        funct7 = instr[31:25];
    end

endmodule
