
`timescale 1ns/1ps

module tb_ALU_TOP (); /* this is automatically generated */

	logic clk;

	// clock
	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end

	// (*NOTE*) replace reset, clock, others

	parameter DATA_WIDTH = 32;
	parameter FUNC_WIDTH = 5;

	logic [DATA_WIDTH-1 : 0] PC_IN;
	logic [DATA_WIDTH-1 : 0] RS1_IN;
	logic [DATA_WIDTH-1 : 0] RS2_IN;
	logic [DATA_WIDTH-1 : 0] IMM_IN;
	logic [FUNC_WIDTH-1 : 0] ALU_CTRL;
	logic                    MUX1_CTRL;
	logic                    MUX2_CTRL;
	logic [DATA_WIDTH-1 : 0] ALU_OUT;

	ALU_TOP #(
			.DATA_WIDTH(DATA_WIDTH),
			.FUNC_WIDTH(FUNC_WIDTH)
		) inst_ALU_TOP (
			.PC_IN     (PC_IN),
			.RS1_IN    (RS1_IN),
			.RS2_IN    (RS2_IN),
			.IMM_IN    (IMM_IN),
			.ALU_CTRL  (ALU_CTRL),
			.MUX1_CTRL (MUX1_CTRL),
			.MUX2_CTRL (MUX2_CTRL),
			.ALU_OUT   (ALU_OUT)
		);

	initial begin
		#100;
		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd0;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd0;
		MUX1_CTRL <= 1;
		MUX2_CTRL <= 0;
		#10;
		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd0;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 1;
		#10;

 		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd1;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd2;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd3;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd4;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd5;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd6;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd7;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd8;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd0;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd9;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd10;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd11;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd12;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd13;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd14;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd15;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd16;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd17;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd18;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= -10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd15;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= -10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd16;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= -10;
		RS1_IN <= 20;
		RS2_IN <= 30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd17;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= -30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd15;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= -30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd16;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= 10;
		RS1_IN <= 20;
		RS2_IN <= -30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd17;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= -10;
		RS1_IN <= 20;
		RS2_IN <= -30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd15;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= -10;
		RS1_IN <= 20;
		RS2_IN <= -30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd16;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;

		PC_IN <= -10;
		RS1_IN <= 20;
		RS2_IN <= -30;
		IMM_IN <= 40;
		ALU_CTRL <= 5'd17;
		MUX1_CTRL <= 0;
		MUX2_CTRL <= 0;
		#10;
		$finish;
	end


endmodule
