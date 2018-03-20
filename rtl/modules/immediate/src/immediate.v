`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashen Ekanayake
// 
// Create Date: 03/05/2018 10:12:31 PM
// Design Name: 
// Module Name: immediate
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
module immediate#(
	parameter XLEN = 32
	)
	(
	input        [XLEN-1:0] instruction,
    input        is_type_I, is_type_S, is_type_B, is_type_U, is_type_J,
	output reg  [XLEN-1:0] imm_out
    );
    
    wire [4:0] intr = {is_type_I, is_type_S, is_type_B, is_type_U, is_type_J};

	always@(*)begin
		case(intr)
			5'b10000 : imm_out = {{21{instruction[31]}},instruction[30:20]};
			5'b01000 : imm_out = {{21{instruction[31]}},instruction[30:25],instruction[11:8],instruction[7]};
			5'b00100 : imm_out = {{20{instruction[31]}},instruction[7],instruction[30:25],instruction[11:8],1'b0};
			5'b00010 : imm_out = {instruction[31:12],{12{1'b0}}};
			5'b00001 : imm_out = {{12{instruction[31]}},instruction[19:12],instruction[20],instruction[30:21],1'b0};
			default: imm_out = 32'd0;
		endcase
	end

endmodule
