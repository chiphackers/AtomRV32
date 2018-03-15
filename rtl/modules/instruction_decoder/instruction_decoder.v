module instruction_decoder#(
    parameter XLEN = 32,
    parameter OPCODE_LEN = 7,
	parameter REG_FILE_DEPTH = 32,
    parameter REG_FILE_ADDR_LEN = $clog2(REG_FILE_DEPTH)
)(
    input clk,
    input rst_n,
    input en,

    input [XLEN-1:0] instruction,
    
    output [REG_FILE_ADDR_LEN-1:0] addr_0,
    output [REG_FILE_ADDR_LEN-1:0] addr_1,
    output [REG_FILE_ADDR_LEN-1:0] w_addr
);


    reg instr_beq, instr_bne, instr_blt, instr_bge, instr_bltu, instr_bgeu, instr_addi, instr_slti, instr_sltiu, instr_xori, instr_ori, instr_andi, instr_add, instr_sub, instr_sll, instr_slt, instr_sltu, instr_xor, instr_srl, instr_sra, instr_or, instr_and;

    // Following registers are indicating the instruction type
    reg is_type_R, is_type_I, is_type_S, is_type_U;

    // Following registers are holding different parts of the instruction
    // Validity of the data contain in them depends on the tpe of instruction
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [REG_FILE_ADDR_LEN-1:0] rs1, rs2, rd;


    // reset instruction registers
    always @(negedge clk) begin 
        if (!rst_n) begin
            instr_beq   <= 0;
            instr_bne   <= 0;
            instr_blt   <= 0;
            instr_bge   <= 0;
            instr_bltu  <= 0;
            instr_bgeu  <= 0;

            instr_addi  <= 0;
            instr_slti  <= 0;
            instr_sltiu <= 0;
            instr_xori  <= 0;
            instr_ori   <= 0;
            instr_andi  <= 0;

            instr_add   <= 0;
            instr_sub   <= 0;
            instr_sll   <= 0;
            instr_slt   <= 0;
            instr_sltu  <= 0;
            instr_xor   <= 0;
            instr_srl   <= 0;
            instr_sra   <= 0;
            instr_or    <= 0;
            instr_and   <= 0;
        end
    end

    always @(*) begin
        is_type_R  = (instruction[OPCODE_LEN-1:0] == 7'b0110011);
        is_type_I  = (instruction[OPCODE_LEN-1:0] == 7'b0010011);
        is_type_S  = (instruction[OPCODE_LEN-1:0] == 7'b0100011);
        is_type_U  = (instruction[OPCODE_LEN-1:0] == 7'b0000011);

        funct3 = instruction[14:12];
        funct7 = instruction[31:25];
        rd     = instruction[11:7];
        rs1    = instruction[19:15];
        rs2    = instruction[24:20];
    end

endmodule
