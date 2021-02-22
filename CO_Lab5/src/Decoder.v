module Decoder(
               input [6-1:0] instr_op_i,
	           output RegWrite_o,
	           output [6-1:0] ALU_op_o,
	           output ALUSrc_o,
			   output [2-1:0] RegWriteSrc_o,
	           output [2-1:0] RegDst_o,
	           output Branch_o,
			   output [2-1:0] BranchType_o,
			   output MemRead_o,
			   output MemWrite_o,
			   output JumpSrc_o
	           );

assign RegWrite_o = (instr_op_i == 6'b000100 || instr_op_i == 6'b101011 || instr_op_i == 6'b000010 || instr_op_i == 6'b000101 || instr_op_i == 6'b000001 || instr_op_i == 6'b000111) ? 1'b0 : 1'b1;  // no beq sw j jr
assign ALU_op_o = instr_op_i[5:0];
assign ALUSrc_o = (instr_op_i[3] == 1 || instr_op_i == 6'b100011); // addi slti lw sw
assign RegWriteSrc_o = (instr_op_i == 6'b100011) ? 2'd1 : (instr_op_i == 6'b000011) ? 2'd2 : 2'd0; // lw 1 jal 2 aluresult 0
assign RegDst_o = (instr_op_i == 0) ? 2'd1 : (instr_op_i == 6'b000011) ? 2'd2 : 2'd0; //addi slti lw (regWriteDest  = 0) jal (regWriteDest = 2)
assign Branch_o = instr_op_i[2] | (instr_op_i == 6'b000001);
assign BranchType_o = (instr_op_i == 6'b000100) ? 2'b00 : (instr_op_i == 6'b000101) ? 2'b01 : (instr_op_i == 6'b000001) ? 2'b10 : 2'b11; //beq 0 bne 1 bge 2 bgt 3
assign MemRead_o = (instr_op_i == 6'b100011); // lw
assign MemWrite_o = (instr_op_i == 6'b101011); // sw
assign JumpSrc_o = (instr_op_i[5:1] == 5'b00001); // j jal 1 jr 0

endmodule