module Sign_Extend(
                   input [16-1:0] data_i,
                   output reg [32-1:0] data_o
                   );

always@(*)begin
	if(data_i[15])
		data_o = {16'b1111111111111111,data_i[15:0]};
	else
		data_o = {16'b0000000000000000,data_i[15:0]};
end

endmodule