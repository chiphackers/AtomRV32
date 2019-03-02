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
