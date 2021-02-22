module Decoder(
               input [6-1:0] instr_op_i,
	           output reg RegWrite_o,
	           output reg [4-1:0] ALU_op_o,
	           output reg ALUSrc_o,
	           output reg RegDst_o,
	           output reg Branch_o
	           );

always @(*) begin
	ALU_op_o = instr_op_i[3:0];
	Branch_o = instr_op_i[2];
	ALUSrc_o = instr_op_i[3];
	RegWrite_o = ~instr_op_i[2];
	RegDst_o = (instr_op_i == 0);
end

endmodule