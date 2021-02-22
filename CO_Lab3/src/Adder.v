module Adder(
             input  [32-1:0] src1_i,
	         input  [32-1:0] src2_i,
	         input [32-1:0] sum_o
	         );

assign sum_o = src1_i + src2_i;

endmodule