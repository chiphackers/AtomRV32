module immediate#(
	parameter XLEN = 32,
    parameter OP_LEN = 7
)(
	input        [XLEN-1:0]     instr,
    input        [OP_LEN-1:0]   opcode,
    input        [2:0]          funct3,
	output reg   [XLEN-1:0]     imm_out,
    output reg                  is_type_R
);
    
    wire is_type_I, is_type_L, is_type_S, is_type_B, is_type_U, is_type_J;
    wire [5:0] types = {is_type_I, is_type_L, is_type_S, is_type_B, is_type_U, is_type_J};

    always @(*) begin
        is_type_I  = (opcode == 7'b0010011);
        is_type_L  = (opcode == 7'b0000011);
        is_type_S  = (opcode == 7'b0100011);
        is_type_B  = (opcode == 7'b1100011);
        is_type_U  = (opcode == 7'b0110111) | (opcode == 7'b0010111);
        is_type_J  = (opcode == 7'b1101111);
    end

	always@(*)begin
		case(types)
            5'b100000 : begin
                        if(funct3[1:0] == 2'b01 )
                            imm_out = {27'b0,instr[24:20]};
                        else
                            imm_out = {{21{instr[31]}},instr[30:20]};
                       end
			5'b001000 : imm_out = {{21{instr[31]}},instr[30:25],instr[11:8],instr[7]};
			5'b000100 : imm_out = {{20{instr[31]}},instr[7],instr[30:25],instr[11:8],1'b0};
			5'b000010 : imm_out = {instr[31:12],{12{1'b0}}};
			5'b000001 : imm_out = {{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0};
			default: imm_out = 32'd0;
		endcase
	end

endmodule
