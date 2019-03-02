module immediate#(
	parameter XLEN = 32,
    parameter OP_LEN = 7
)(
	input        [XLEN-1:0] instr,
	output reg   [XLEN-1:0] imm_out,
    output reg   is_type_R
);
    
    wire is_type_I, is_type_S, is_type_B, is_type_U, is_type_J;
    wire [4:0] types = {is_type_I, is_type_S, is_type_B, is_type_U, is_type_J};

    always @(*) begin
        is_type_I  = (instr[OP_LEN-1:0] == 7'b1100111) | (instr[OP_LEN-1:0] == 7'b0000011) | (instr[OP_LEN-1:0] == 7'b0010011);
        is_type_S  = (instr[OP_LEN-1:0] == 7'b0100011);
        is_type_B  = (instr[OP_LEN-1:0] == 7'b1100011);
        is_type_U  = (instr[OP_LEN-1:0] == 7'b0110111) | (instr[OP_LEN-1:0] == 7'b0010111);
        is_type_J  = (instr[OP_LEN-1:0] == 7'b1101111);
    end

	always@(*)begin
		case(types)
			5'b10000 : imm_out = {{21{instr[31]}},instr[30:20]};
			5'b01000 : imm_out = {{21{instr[31]}},instr[30:25],instr[11:8],instr[7]};
			5'b00100 : imm_out = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
			5'b00010 : imm_out = {instr[31:12],{12{1'b0}}};
			5'b00001 : imm_out = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
			default: imm_out = 32'd0;
		endcase
	end

endmodule
