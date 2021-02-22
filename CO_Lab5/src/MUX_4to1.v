module MUX_4to1(
               input [size-1:0] data0_i,
               input [size-1:0] data1_i,
			   input [size-1:0] data2_i,
			   input [size-1:0] data3_i,
               input [1:0] select_i,
               output [size-1:0] data_o
               );

parameter size = 0;

assign data_o = (select_i == 0) ? data0_i : (select_i == 1) ? data1_i : (select_i == 2) ? data2_i : data3_i;

endmodule