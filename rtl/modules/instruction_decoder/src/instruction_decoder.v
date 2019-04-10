module instruction_decoder#(
    parameter XLEN = 32,
	 parameter REG_FILE_DEPTH = 32,
    parameter REG_FILE_ADDR_LEN = $clog2(REG_FILE_DEPTH)
)(
    input [XLEN-1:0] instr,
    
    output reg [REG_FILE_ADDR_LEN-1:0] rs1, //read address 1
    output reg [REG_FILE_ADDR_LEN-1:0] rs2, //read address 2
    output reg [REG_FILE_ADDR_LEN-1:0] rd  //write address
);

    always @(*) begin
        rd     = instr[11:7];
        rs1    = instr[19:15];
        rs2    = instr[24:20];
    end

endmodule
