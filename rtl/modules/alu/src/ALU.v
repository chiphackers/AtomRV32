`timescale 1ns / 1ps

module ALU(
    bus_A,
    bus_B,
    func3,
    func7,
    bus_out
    );

parameter DATA_WIDTH = 32;
parameter FUNC3_WIDTH = 3;
parameter FUNC7_WIDTH = 7;

input  [DATA_WIDTH-1 : 0]   bus_A;
input  [DATA_WIDTH-1 : 0]   bus_B;
input  [FUNC3_WIDTH-1: 0]   func3;
input  [FUNC7_WIDTH-1: 0]   func7;
output [DATA_WIDTH-1 : 0]   bus_out;

reg [DATA_WIDTH-1 : 0] op_reg;

wire signed [DATA_WIDTH-1 : 0]   bus_A_SIGNED;
wire signed [DATA_WIDTH-1 : 0]   bus_B_SIGNED;

assign bus_out = op_reg;

assign bus_A_SIGNED = bus_A;
assign bus_B_SIGNED = bus_B;

//************************************************
//  ALU_CTRL => { FUNC3 , FUNC7[5] }
//************************************************
//  000-0 : ADD
//  000-1 : SUB
//  001-0 : SLL
//  010-0 : SLT
//  011-0 : SLTU
//  100-0 : XOR
//  101-0 : SRL
//  101-1 : SRA
//  110-0 : OR
//  111-0 : AND
//*************************************************
always @(*) begin
    case (func3)
        3'b000 : begin
            if(func7[5] == 1'b0)
                op_reg = bus_A + bus_B;                     // ADDU
            else
                op_reg = bus_B +{~bus_A + 1'b1};            // SUBU
        end
        3'b001 : op_reg = bus_B<<bus_A;                     // SLL

        3'b010 : begin                                      //  SLT      
            if(bus_A_SIGNED < bus_B_SIGNED)
                op_reg = 32'd1;
            else
                op_reg = 32'd0;
        end

        3'b011 : begin                                      //  SLTU      
            if(bus_A < bus_B)
                op_reg = 32'd1;
            else
                op_reg = 32'd0;
        end

        3'b100 : op_reg = bus_A^bus_B;                      // XOR

        3'b101 : begin
            if(func7[5] == 1'b0)
                op_reg = bus_B>>bus_A;                      // SRL
            else
                op_reg = bus_B_SIGNED >>> bus_A_SIGNED;     // SRA
        end
        
        3'b110 : op_reg = bus_A&bus_B;                      // AND
        
        3'b111 : op_reg = bus_A|bus_B;                      // OR
        
        default : op_reg = 32'd0;    
     
    endcase
    
end
    
endmodule
