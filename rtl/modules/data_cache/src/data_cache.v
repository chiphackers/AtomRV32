module data_cache #(
    parameter XLEN = 32,
    parameter OPCODE_WIDTH = 7
) (

module data_cache #(parameter ADDR_WIDTH = 5, DATA_WIDTH = 32, DEPTH = 256) (
    input wire clk,
    input wire rst_n,
    input wire [ADDR_WIDTH-1:0] addr, 
    input wire [2:0] funct3,
    input wire [6:0] types,
    input wire [DATA_WIDTH-1:0] w_data,
    output reg [DATA_WIDTH-1:0] r_data 
);

    wire is_type_L, is_type_S;

    /*
    * Type
    */
    assign is_type_L = types[4];
    assign is_type_S = types[3];

    reg [DATA_WIDTH-1:0] memory_array [0:DEPTH-1]; 

    integer i;

    always @ (posedge clk)
    begin
        if(~rst_n) begin
            for(i=0; i<DEPTH; i = i+1) begin
                memory_array[i]    <= 32'h0;
            end
        end else begin
            if(is_type_S) begin
                case(func3)
                    3'b000: memory_array[addr][7 :0] <= w_data[7 :0];
                    3'b001: memory_array[addr][15:0] <= w_data[15:0];
                    3'b010: memory_array[addr]       <= w_data;
                    default:memory_array[addr]       <= w_data;
                endcase
                r_data  <= 32'h0;
            end
            else if(is_type_L) begin
                case(func3)
                    3'b000: r_data <= { 25{memory_array[addr][7]}, memory_array[addr][6 :0]};
                    3'b001: r_data <= { 17{memory_array[addr][15]}, memory_array[addr][14 :0]};
                    3'b010: r_data <= memory_array[addr];
                    3'b100: r_data <= { 26{1'b0}, memory_array[addr][7 :0]};
                    3'b101: r_data <= { 16{1'b0}, memory_array[addr][15 :0]};
                    default:r_data <= 32'h0;
                endcase
            end else begin
                r_data  <= 32'h0;
            end
        end     
    end
endmodule
