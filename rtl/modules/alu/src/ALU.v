`timescale 1ns / 1ps

module ALU(
    bus_A,
    bus_B,
    alu_ctrl,
    bus_out
    );

parameter DATA_WIDTH = 32;

input  [DATA_WIDTH-1 : 0]   bus_A;
input  [DATA_WIDTH-1 : 0]   bus_B;
input  [3: 0]               alu_ctrl;
output [DATA_WIDTH-1 : 0]   bus_out;

reg [DATA_WIDTH-1 : 0] op_reg;

wire signed [DATA_WIDTH-1 : 0]   bus_A_SIGNED;
wire signed [DATA_WIDTH-1 : 0]   bus_B_SIGNED;

assign bus_out = op_reg;

assign bus_A_SIGNED = $signed(bus_A);
assign bus_B_SIGNED = $signed(bus_B);

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
    case (alu_ctrl)
        4'b0000 : op_reg = bus_A + bus_B;                     // ADDU

        4'b0001 : op_reg = bus_B +{~bus_A + 1'b1};            // SUBU

        4'b0010 : op_reg = bus_B<<bus_A;                     // SLL

        4'b0100 : begin                                      //  SLT      
            if(bus_A_SIGNED < bus_B_SIGNED)
                op_reg = 32'd1;
            else
                op_reg = 32'd0;
        end

        4'b0110 : begin                                      //  SLTU      
            if(bus_A < bus_B)
                op_reg = 32'd1;
            else
                op_reg = 32'd0;
        end

        4'b1000 : op_reg = bus_A^bus_B;                      // XOR

        4'b1010 : op_reg = bus_B>>bus_A;                      // SRL

        4'b1011 : op_reg = bus_B_SIGNED >>> bus_A_SIGNED;     // SRA
 
        
        4'b1100 : op_reg = bus_A&bus_B;                      // AND
        
        4'b1110 : op_reg = bus_A|bus_B;                      // OR
        
        default : op_reg = 32'd0;    
     
    endcase
    
end
    
endmodule
