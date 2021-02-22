module ForwardUnit(
    input EX_MEM_RegWrite_i,
	input [5-1:0] EX_MEM_writeReg1_i,
	input MEM_WB_RegWrite_i,
	input [5-1:0] MEM_WB_writeReg1_i,
	input [5-1:0] ID_EX_RS_i,
	input [5-1:0] ID_EX_RT_i,
    output [2-1:0] Forward_A_o,
    output [2-1:0] Forward_B_o
	);

wire EX_MEM_RS;
wire EX_MEM_RT;
wire MEM_WB_RS;
wire MEM_WB_RT;

assign EX_MEM_RS = (EX_MEM_RegWrite_i && (EX_MEM_writeReg1_i != 0)) && (EX_MEM_writeReg1_i == ID_EX_RS_i);
assign EX_MEM_RT = (EX_MEM_RegWrite_i && (EX_MEM_writeReg1_i != 0)) && (EX_MEM_writeReg1_i == ID_EX_RT_i);

assign MEM_WB_RS = (MEM_WB_RegWrite_i && (MEM_WB_writeReg1_i != 0)) && (MEM_WB_writeReg1_i == ID_EX_RS_i);
assign MEM_WB_RT = (MEM_WB_RegWrite_i && (MEM_WB_writeReg1_i != 0)) && (MEM_WB_writeReg1_i == ID_EX_RT_i);

assign Forward_A_o = EX_MEM_RS ? 2'b00 : (MEM_WB_RS ? 2'b01 : 2'b10); //EX_MEM_RS 00, MEM_WB_RS 01, origin 10
assign Forward_B_o = EX_MEM_RT ? 2'b00 : (MEM_WB_RT ? 2'b01 : 2'b10); //EX_MEM_RT 00, MEM_WB_RT 01, origin 10

endmodule