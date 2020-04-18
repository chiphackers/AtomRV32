module immediate#(
	parameter XLEN = 32,
    parameter OP_LEN = 7
)(
	input        [XLEN-1:0]     instr,
    input        [OP_LEN-1:0]   opcode,
    input        [2:0]          funct3,
    input        [6:0]          types,
	output reg   [XLEN-1:0]     imm_out
);
    
    // types = { R-type, I-type, L-type, S-type, J-type, B-type, U-type }

	always@(*)begin
		case(types[5:0])
            // I-type
            6'b100000 : begin
                        if(funct3[1:0] == 2'b01 )
                            imm_out = {27'b0,instr[24:20]};
                        else
                            imm_out = {{21{instr[31]}},instr[30:20]};
                       end
            // JALR instruction
            6'b100100 : imm_out = {{21{instr[31]}},instr[30:20]};
            // L-type
            6'b010000 : imm_out = {{21{instr[31]}},instr[30:20]};
            // S-type
			6'b001000 : imm_out = {{21{instr[31]}},instr[30:25],instr[11:8],instr[7]};
            // J-type
			6'b000100 : imm_out = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
            // B-type
			6'b000010 : imm_out = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
            // U-type
			6'b000001 : imm_out = {instr[31:12],{12{1'b0}}};
			default: imm_out = 32'd0;
		endcase
	end

endmodule
