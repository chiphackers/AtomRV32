`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2018 10:37:05 PM
// Design Name: 
// Module Name: Mux_2_to_1
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


module Mux_2_to_1(
    in_1, 
    in_2, 
    out, 
    CTRL
    );
    
parameter BITWIDTH = 32;
    
    input [BITWIDTH-1 : 0]  in_1;
    input [BITWIDTH-1 : 0]  in_2;
    input                   CTRL;
    
    output [BITWIDTH-1 : 0] out;
    
    assign out = (CTRL == 1'b0) ? in_1 : in_2;
    
endmodule
