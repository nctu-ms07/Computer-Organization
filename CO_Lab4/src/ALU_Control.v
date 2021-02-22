module ALU_Control(
                   input [6-1:0] funct_i,
                   input [6-1:0] ALUOp_i,
                   output reg [4-1:0] ALUCtrl_o
                   );

always@(*)begin
	ALUCtrl_o[0] = (ALUOp_i[1] | (~(ALUOp_i[3] | ALUOp_i[2] | ALUOp_i[1]) & (funct_i[0] | (funct_i[3] & funct_i[1])))) & ~ALUOp_i[5];
	ALUCtrl_o[1] = ~(~(ALUOp_i[3] | ALUOp_i[2] | ALUOp_i[1]) & (funct_i[2] | funct_i[4]));
	ALUCtrl_o[2] = (ALUOp_i[1] | ALUOp_i[2] | (~(ALUOp_i[3] | ALUOp_i[2] | ALUOp_i[1]) & (funct_i[1] | funct_i[4]))) & ~ALUOp_i[5];
	ALUCtrl_o[3] = ~(ALUOp_i[3] | ALUOp_i[2] | ALUOp_i[1]) & funct_i[4];
end

endmodule