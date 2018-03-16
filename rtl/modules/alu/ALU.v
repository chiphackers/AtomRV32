`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Sasindu Geemal (DoomsDay)
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
parameter FUNC_WIDTH = 5;

input  [DATA_WIDTH-1 : 0]   bus_A;
input  [DATA_WIDTH-1 : 0]   bus_B;
input  [FUNC_WIDTH-1 : 0] alu_ctrl;
output [DATA_WIDTH-1 : 0]   bus_out;

reg [DATA_WIDTH-1 : 0] op_reg;

wire signed [DATA_WIDTH-1 : 0]   bus_A_SIGNED;
wire signed [DATA_WIDTH-1 : 0]   bus_B_SIGNED;

assign bus_out = op_reg;

assign bus_A_SIGNED = bus_A;
assign bus_B_SIGNED = bus_B;

always @(*) begin
    case (alu_ctrl)
    5'b00000 : op_reg = bus_A + bus_B;                      // ADD
           
    5'b00001 : op_reg = bus_B +{~bus_A + 1'b1};            // SUB
                
    5'b00010 :                                            //  SLTU                 
        begin
            if(bus_A<bus_B)
                op_reg = 32'd1;
            else
                op_reg = 32'd0;
        end
        
    5'b000011 : op_reg = bus_A&bus_B;                  // AND
        
    5'b00100 : op_reg = bus_A|bus_B;                   // OR
        
    5'b00101 : op_reg = bus_A^bus_B;                   // XOR
        
    5'b00110 : op_reg = bus_B<<bus_A;                 // SLL
        
    5'b00111 : op_reg = bus_B>>bus_A;                 // SRL
     
    5'b01000 : op_reg = bus_A>>>bus_B;              // SRA
        
    5'b01001 : op_reg = bus_A;                      // PASS A
        
    5'b01010 : op_reg = bus_B;                      // PASS B

    5'b01011:  op_reg = {31'd0, (bus_A == bus_B)}; 
    
    5'b01100:  op_reg = {31'd0, (bus_A != bus_B)};
    
    5'b01101:  op_reg = {31'd0, (bus_A < bus_B)};
    
    5'b01110:  op_reg = {31'd0, (bus_A >= bus_B)};

    5'b01111 :                                            //  SLTU                 
        begin
            if(bus_A_SIGNED<bus_B_SIGNED)
                op_reg = 32'd1;
            else
                op_reg = 32'd0;
        end
    
    default : op_reg = 32'd0;    
     
    endcase
    
end
    
endmodule
