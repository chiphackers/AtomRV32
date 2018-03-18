`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashen Ekanayake
// 
// Create Date: 03/05/2018 10:12:31 PM
// Design Name: 
// Module Name: imm_extender
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
typedef enum {I_type=0, S_type=1, B_type=2, U_type=3, J_type=4 } instruction_type;

module imm_extender#(
	parameter XLEN = 32
	)
	(
	input        [XLEN-1:0] instruction,
	output wire  [XLEN-1:0] imm_out
    );
    
    instruction_type intr;
	always@(*)begin
		case(instruction[6:0])
			7'b0110111: intr = U_type;
			7'b0010111: intr = U_type;
			7'b1101111: intr = J_type;
			7'b1100111: intr = I_type;
			7'b1100011: intr = B_type;
			7'b0000011: intr = I_type;
			7'b0100011: intr = S_type;
			7'b0010011: intr = I_type;
			default   : intr = I_type;
		endcase
	end

	always@(*)begin
		case(intr)
			I_type : imm_out = {{21{instruction[31]}},instruction[30:20]};
			S_type : imm_out = {{21{instruction[31]}},instruction[30:25],instruction[11:8],instruction[7]};
			B_type : imm_out = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};
			U_type : imm_out = {instruction[31:12],{12{1'b0}}};
			J_type : imm_out = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0};
			default: imm_out = 32'd0;
		endcase
	end
endmodule
