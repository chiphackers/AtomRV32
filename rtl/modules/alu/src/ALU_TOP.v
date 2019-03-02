module ALU_TOP(
	PC_IN, 
	RS1_IN, 
	RS2_IN, 
	IMM_IN, 
	ALU_CTRL, 
	MUX1_CTRL, 
	MUX2_CTRL, 
	ALU_OUT
);


parameter DATA_WIDTH = 32;
parameter FUNC_WIDTH = 5;

input [DATA_WIDTH-1 : 0] 	PC_IN; 
input [DATA_WIDTH-1 : 0] 	RS1_IN;
input [DATA_WIDTH-1 : 0] 	RS2_IN; 
input [DATA_WIDTH-1 : 0] 	IMM_IN; 
input [FUNC_WIDTH-1 : 0] 	ALU_CTRL; 
input 						MUX1_CTRL;
input 						MUX2_CTRL;

output [DATA_WIDTH-1 : 0] 	ALU_OUT; 


wire [DATA_WIDTH-1 : 0] bus_A;
wire [DATA_WIDTH-1 : 0] bus_B;

Mux_2_to_1 MUX_UP(
    .in_1(PC_IN), 
    .in_2(RS1_IN), 
    .out(bus_A), 
    .CTRL(MUX1_CTRL)
    );

Mux_2_to_1 MUX_DOWN(
    .in_1(RS2_IN), 
    .in_2(IMM_IN), 
    .out(bus_B), 
    .CTRL(MUX2_CTRL)
    );



ALU alu_a(
    .bus_A(bus_A),
    .bus_B(bus_B),
    .alu_ctrl(ALU_CTRL),
    .bus_out(ALU_OUT)
    );


endmodule
