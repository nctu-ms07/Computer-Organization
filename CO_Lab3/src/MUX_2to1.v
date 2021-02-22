module MUX_2to1(
               input [size-1:0] data0_i,
               input [size-1:0] data1_i,
               input select_i,
               output [size-1:0] data_o
               );

parameter size = 0;

assign data_o = select_i == 0 ? data0_i : data1_i;

endmodule