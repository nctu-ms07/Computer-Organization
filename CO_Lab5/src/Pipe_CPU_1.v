`timescale 1ns / 1ps
module Pipe_CPU_1(
    input clk_i,
    input rst_i
    );

wire [31:0] pc_nextaddr;
wire pc_write; //1 write 0 no write
wire [31:0] pc_curaddr;
wire [31:0] pc_nextaddr1; //add4
wire [32-1:0] immediateshift;
wire [31:0] pc_nextaddr2; //branch
wire [31:0] EX_MEM_pc_nextaddr2; 
wire [31:0] pc_nextaddr3; //jump related
wire [31:0] pc_nextaddr4; //jump related
wire [31:0] instr;

wire IF_ID_flush;
wire [31:0] IF_ID_pc_nextaddr1;
wire [31:0] IF_ID_instr;

//Decoder related
wire          RegWrite;
wire [6-1:0]  ALUOp;
wire          ALUSrc;
wire [2-1:0]  RegWriteSrc;
wire [2-1:0]  RegDst;
wire          Branch;
wire [2-1:0]  BranchType;
wire [4-1:0]  ALUCtrl;
wire          MemRead;
wire          MemWrite;
wire          JumpSrc;

//Register related
wire [32-1:0] readData1;
wire [32-1:0] readData2;
wire [5-1:0]  writeReg1;
wire [32-1:0] writeData;

wire [31:0] ID_EX_pc_nextaddr1;
wire [31:0] ID_EX_instr;
wire          ID_EX_RegWrite;
wire [6-1:0]  ID_EX_ALUOp;
wire          ID_EX_ALUSrc;
wire [2-1:0]  ID_EX_RegWriteSrc;
wire [2-1:0]  ID_EX_RegDst;
wire          ID_EX_Branch;
wire [2-1:0]  ID_EX_BranchType;
wire [4-1:0]  ID_EX_ALUCtrl;
wire          ID_EX_MemRead;
wire          ID_EX_MemWrite;
//wire          ID_EX_JumpSrc;
wire [32-1:0] ID_EX_readData1;
wire [32-1:0] ID_EX_readData2;

wire [32-1:0] immediate;
wire [32-1:0] ID_EX_immediate;

//ALU related
wire [32-1:0] ALUSrc2;
wire [2-1:0] Forward_A;
wire [2-1:0] Forward_B;
wire [32-1:0] ALUSrc1_Forwarded;
wire [32-1:0] ALUSrc2_Forwarded;
wire [32-1:0] ALUResult;
wire          Zero;
wire          BranchCond;

wire [31:0] EX_MEM_pc_nextaddr1;
wire [31:0] EX_MEM_instr;
wire          EX_MEM_RegWrite;
wire [2-1:0]  EX_MEM_RegWriteSrc;
wire [2-1:0]  EX_MEM_RegDst;
wire          EX_MEM_Branch;
wire          EX_MEM_BranchCond;
wire          EX_MEM_MemRead;
wire          EX_MEM_MemWrite;
wire [32-1:0] EX_MEM_readData2;
wire [5-1:0]  EX_MEM_writeReg1;
wire [32-1:0] EX_MEM_ALUResult;
wire          EX_MEM_Zero;

//Data Memory related
wire [32-1:0] MemReadData;

wire [31:0] MEM_WB_pc_nextaddr1;
wire          MEM_WB_RegWrite;
wire [2-1:0]  MEM_WB_RegWriteSrc;
wire [5-1:0]  MEM_WB_writeReg1;
wire [32-1:0] MEM_WB_ALUResult;
wire [32-1:0] MEM_WB_MemReadData;
wire [32-1:0] MEM_WB_writeData;





/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i(rst_i),  
        .pc_write_i(pc_write),	
	    .pc_in_i(pc_nextaddr),   
	    .pc_out_o(pc_curaddr) 
	    );

Adder Adder1(
        .src1_i(pc_curaddr),     
	    .src2_i(4),     
	    .sum_o(pc_nextaddr1) 
	    );

Instruction_Memory IM(
        .addr_i(pc_curaddr),  
	    .instr_o(instr)
	    );
			

Pipe_Reg #(.size(64)) IF_ID(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.flush_i(IF_ID_flush || (EX_MEM_Branch && EX_MEM_BranchCond)),
		.data_i({pc_nextaddr1,instr}),
		.data_o({IF_ID_pc_nextaddr1,IF_ID_instr})
		);

//Instantiate the components in ID stage
Decoder Control(
                .instr_op_i(IF_ID_instr[31:26]),
                .RegWrite_o(RegWrite),
                .ALU_op_o(ALUOp),
                .ALUSrc_o(ALUSrc),
				.RegWriteSrc_o(RegWriteSrc),
                .RegDst_o(RegDst),
                .Branch_o(Branch),
				.BranchType_o(BranchType),
				.MemRead_o(MemRead),
				.MemWrite_o(MemWrite),
				.JumpSrc_o(JumpSrc)
                );


Reg_File RF(
        .clk_i(clk_i),
		.rst_i (rst_i),
        .RSaddr_i(IF_ID_instr[25:21]) ,  
        .RTaddr_i(IF_ID_instr[20:16]) ,  
        .RDaddr_i(MEM_WB_writeReg1) ,  
        .RDdata_i(MEM_WB_writeData)  , 
        .RegWrite_i (MEM_WB_RegWrite),
        .RSdata_o(readData1) ,  
        .RTdata_o(readData2)   
        );

Sign_Extend Sign_Extend(
               .data_i(IF_ID_instr[15:0]),
               .data_o(immediate)
               );

Pipe_Reg #(.size(177)) ID_EX(
        .clk_i(clk_i),
		.rst_i(rst_i),
		.flush_i(IF_ID_flush || (EX_MEM_Branch && EX_MEM_BranchCond)),
		.data_i({IF_ID_pc_nextaddr1,IF_ID_instr,RegWrite,ALUOp,ALUSrc,RegWriteSrc,RegDst,Branch,BranchType,MemRead,MemWrite,readData1,readData2,immediate}),
		.data_o({ID_EX_pc_nextaddr1,ID_EX_instr,ID_EX_RegWrite,ID_EX_ALUOp,ID_EX_ALUSrc,ID_EX_RegWriteSrc,ID_EX_RegDst,ID_EX_Branch,ID_EX_BranchType,ID_EX_MemRead,ID_EX_MemWrite,ID_EX_readData1,ID_EX_readData2,ID_EX_immediate})
		);


//Instantiate the components in EX stage
HazardDetectUnit Hazard(
                        .ID_EX_MemRead_i(ID_EX_MemRead),
						.ID_EX_RT_i(ID_EX_instr[20:16]),
						.IF_ID_RS_i(IF_ID_instr[25:21]),
						.IF_ID_RT_i(IF_ID_instr[20:16]),
						.pc_write_o(pc_write),
						.IF_ID_flush_o(IF_ID_flush)
						);
	
MUX_2to1 #(.size(32)) Mux1(
						   .data0_i(ID_EX_readData2),
                           .data1_i(ID_EX_immediate),
                           .select_i(ID_EX_ALUSrc),
                           .data_o(ALUSrc2)
                           );
						   

ALU_Control ALU_Control(
						.funct_i(ID_EX_instr[5:0]),
						.ALUOp_i(ID_EX_ALUOp),
						.ALUCtrl_o(ALUCtrl)
						);

ForwardUnit Forwarding(
                       .EX_MEM_RegWrite_i(EX_MEM_RegWrite),
					   .EX_MEM_writeReg1_i(EX_MEM_writeReg1),
					   .MEM_WB_RegWrite_i(MEM_WB_RegWrite),
					   .MEM_WB_writeReg1_i(MEM_WB_writeReg1),
					   .ID_EX_RS_i(ID_EX_instr[25:21]),
					   .ID_EX_RT_i(ID_EX_instr[20:16]),
					   .Forward_A_o(Forward_A),
					   .Forward_B_o(Forward_B)
					   );
					   
MUX_3to1 #(.size(32)) MuxALUSrc1(
                           .data0_i(EX_MEM_ALUResult),
						   .data1_i(MEM_WB_writeData),
						   .data2_i(ID_EX_readData1),
						   .select_i(Forward_A),
						   .data_o(ALUSrc1_Forwarded)
                           );

MUX_3to1 #(.size(32)) MuxALUSrc2(
                           .data0_i(EX_MEM_ALUResult),
						   .data1_i(MEM_WB_writeData),
						   .data2_i(ALUSrc2),
						   .select_i(Forward_B),
						   .data_o(ALUSrc2_Forwarded)
                           );

ALU ALU(
		.src1_i(ALUSrc1_Forwarded),
        .src2_i(ALUSrc2_Forwarded),
        .ctrl_i(ALUCtrl),
        .result_o(ALUResult),
        .zero_o(Zero)
        );

//add control
MUX_4to1 #(.size(1)) BranchSignal(
                                  .data0_i((ALUSrc1_Forwarded == ALUSrc2_Forwarded)),
								  .data1_i((ALUSrc1_Forwarded != ALUSrc2_Forwarded)),
								  .data2_i((ALUSrc1_Forwarded >= ALUSrc2_Forwarded)),
								  .data3_i((ALUSrc1_Forwarded > ALUSrc2_Forwarded)),
								  .select_i(ID_EX_BranchType),
								  .data_o(BranchCond)
								  );


MUX_3to1 #(.size(5)) Mux2(
						  .data0_i(ID_EX_instr[20:16]),
                          .data1_i(ID_EX_instr[15:11]),
						  .data2_i(5'd31),
                          .select_i(ID_EX_RegDst),
                          .data_o(writeReg1)
                          );



Shift_Left_Two_32 Shifter(
                          .data_i(ID_EX_immediate),
                          .data_o(immediateshift)
                          );

Adder Add_pc_branch(
					.src1_i(ID_EX_pc_nextaddr1),
					.src2_i(immediateshift),
					.sum_o(pc_nextaddr2)
					);

Pipe_Reg #(.size(175)) EX_MEM(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.flush_i((EX_MEM_Branch && EX_MEM_BranchCond)),
		.data_i({ID_EX_pc_nextaddr1,ID_EX_instr,ID_EX_RegWrite,ID_EX_RegWriteSrc,ID_EX_RegDst,ID_EX_Branch,BranchCond,ID_EX_MemRead,ID_EX_MemWrite,ID_EX_readData2,writeReg1,ALUResult,Zero,pc_nextaddr2}),
		.data_o({EX_MEM_pc_nextaddr1,EX_MEM_instr,EX_MEM_RegWrite,EX_MEM_RegWriteSrc,EX_MEM_RegDst,EX_MEM_Branch,EX_MEM_BranchCond,EX_MEM_MemRead,EX_MEM_MemWrite,EX_MEM_readData2,EX_MEM_writeReg1,EX_MEM_ALUResult,EX_MEM_Zero,EX_MEM_pc_nextaddr2})
		);


//Instantiate the components in MEM stage
Data_Memory DM(
			   .clk_i(clk_i),
		       .addr_i(EX_MEM_ALUResult),
		       .data_i(EX_MEM_readData2),
		       .MemRead_i(EX_MEM_MemRead),
		       .MemWrite_i(EX_MEM_MemWrite),
		       .data_o(MemReadData)
		       );
			   
MUX_2to1 #(.size(32)) Mux0(
						 .data0_i(pc_nextaddr1),
                         .data1_i(EX_MEM_pc_nextaddr2),
                         .select_i(EX_MEM_Branch && EX_MEM_BranchCond),
                         .data_o(pc_nextaddr)
                         );

Pipe_Reg #(.size(104)) MEM_WB(
		.clk_i(clk_i),
		.rst_i(rst_i),
		.flush_i(1'b0),
		.data_i({EX_MEM_pc_nextaddr1,EX_MEM_RegWrite,EX_MEM_RegWriteSrc,EX_MEM_writeReg1,EX_MEM_ALUResult,MemReadData}),
		.data_o({MEM_WB_pc_nextaddr1,MEM_WB_RegWrite,MEM_WB_RegWriteSrc,MEM_WB_writeReg1,MEM_WB_ALUResult,MEM_WB_MemReadData})
		);


//Instantiate the components in WB stage
MUX_3to1 #(.size(32)) Mux3(
                           .data0_i(MEM_WB_ALUResult),
                           .data1_i(MEM_WB_MemReadData),
						   .data2_i(MEM_WB_pc_nextaddr1),
                           .select_i(MEM_WB_RegWriteSrc),
                           .data_o(MEM_WB_writeData)
                           );

/****************************************
signal assignment
****************************************/

endmodule

