`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ashen Ekanayake
// 
// Create Date: 03/02/2018 03:03:24 PM
// Design Name: 
// Module Name: register_file
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

module register_file#(
	parameter XLEN = 32,
	parameter REG_FILE_DEPTH = 32,
	parameter REG_FILE_ADDR_LEN = $clog2(REG_FILE_DEPTH)
	)(
	input clk,
	//input reset,
	input wr_en,
	input [REG_FILE_ADDR_LEN-1:0] rs1,
	input [REG_FILE_ADDR_LEN-1:0] rs2,
	input [REG_FILE_ADDR_LEN-1:0] wr_addr,
	input [XLEN-1:0] wr_data,
	output wire [XLEN-1:0] rd_data_1,
	output wire [XLEN-1:0] rd_data_2
    );
	
	reg [XLEN-1:0] reg_file [0:REG_FILE_DEPTH-1];

	assign rd_data_1 = (rs1 == 0)? 0 : reg_file [rs1];
	assign rd_data_2 = (rs2 == 0)? 0 : reg_file [rs2];

	always@(posedge clk)begin
		if(wr_en)begin
			reg_file[wr_addr] <= wr_data;
		end
	end	
endmodule
