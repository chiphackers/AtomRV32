`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/15/2018 10:41:23 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
    bus_A,
    bus_B,
    alu_ctrl,
    bus_out
    );

parameter DATA_WIDTH = 32;
parameter FUNC_WIDTH = 4;

input  [DATA_WIDTH-1 : 0]   bus_A;
input  [DATA_WIDTH-1 : 0]   bus_B;
input  [FUNC_WIDTH-1 : 0] alu_ctrl;
output [DATA_WIDTH-1 : 0]   bus_out;

reg [DATA_WIDTH-1 : 0] op_reg;

wire signed [DATA_WIDTH-1 : 0]   bus_A_SIGNED;
wire signed [DATA_WIDTH-1 : 0]   bus_B_SIGNED;

assign bus_out = op_reg;

always @(*) begin
    case (alu_ctrl)
    4'b0000 : op_reg = bus_A + bus_B;
           
    4'b0001 : op_reg = bus_B +{~bus_A + 1'b1};  
                
    4'b0010 :                               
        begin
            if(bus_A<bus_B)
                op_reg = 32'd1;
            else
                op_reg = 32'd0;
        end
        
    4'b0011 : op_reg = bus_A&bus_B;
        
    4'b0100 : op_reg = bus_A|bus_B;
        
    4'b0101 : op_reg = bus_A^bus_B;
        
    4'b0110 : op_reg = bus_B<<bus_A;
        
    4'b0111 : op_reg = bus_B>>bus_A; 
     
    4'b1000 : op_reg = bus_A>>>bus_B;
        
    4'b1001 : op_reg = bus_A;
        
    4'b1010 : op_reg = bus_B;

    4'bxx00:  op_reg = bus_A == bus_B; 
    
    4'bxx01:  op_reg = bus_A != bus_B;
    
    4'bxx10:  op_reg = bus_A < bus_B;
    
    4'bxx11:  op_reg = bus_A >= bus_B;
    
    default : op_reg = 32'd0;    
     
    endcase
    
end
    
endmodule
