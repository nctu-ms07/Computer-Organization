//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
                         input clk_i,
		                 input rst_i
		                 );

wire [31:0] pc_nextaddr;
wire [31:0] pc_curaddr;
wire [31:0] pc_nextaddr1;
wire [32-1:0] immediateshift;
wire [31:0] pc_nextaddr2;
wire [31:0] instr;

//Decoder related
wire          RegWrite;
wire [4-1:0]  ALUOp;
wire          ALUSrc;
wire          RegDst;
wire          Branch;
wire [4-1:0]  ALUCtrl;

//Register related
wire [32-1:0] readData1;
wire [32-1:0] readData2;
wire [5-1:0]  writeReg1;
wire [32-1:0] writeData;

//ALU related
wire [32-1:0] immediate;
wire [32-1:0] ALUSrc2;
wire          Zero;




//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_nextaddr) ,   
	    .pc_out_o(pc_curaddr) 
	    );

Adder Adder1(
        .src1_i(pc_curaddr),     
	    .src2_i(4),     
	    .sum_o(pc_nextaddr1)    
	    );

Instr_Memory IM(
        .pc_addr_i(pc_curaddr),  
	    .instr_o(instr)
	    );

Decoder decoder(
                .instr_op_i(instr[31:26]),
                .RegWrite_o(RegWrite),
                .ALU_op_o(ALUOp),
                .ALUSrc_o(ALUSrc),
                .RegDst_o(RegDst),
                .Branch_o(Branch)
                );

ALU_Ctrl ac(
            .funct_i(instr[5:0]),
            .ALUOp_i(ALUOp),
            .ALUCtrl_o(ALUCtrl)
            );

MUX_2to1 #(.size(5)) mux_write_reg(
                                   .data0_i(instr[20:16]),
                                   .data1_i(instr[15:11]),
                                   .select_i(RegDst),
                                   .data_o(writeReg1)
                                   );

Reg_File RF(
        .clk_i(clk_i),
		.rst_i (rst_i),
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(writeReg1) ,  
        .RDdata_i(writeData)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(readData1) ,  
        .RTdata_o(readData2)   
        );

Sign_Extend se(
               .data_i(instr[15:0]),
               .data_o(immediate)
               );

MUX_2to1 #(.size(32)) mux_alusrc(
                                 .data0_i(readData2),
                                 .data1_i(immediate),
                                 .select_i(ALUSrc),
                                 .data_o(ALUSrc2)
                                 );

ALU alu(
        .src1_i(readData1),
        .src2_i(ALUSrc2),
        .ctrl_i(ALUCtrl),
        .result_o(writeData),
        .zero_o(Zero)
        );

Shift_Left_Two_32 shifter(
                          .data_i(immediate),
                          .data_o(immediateshift)
                          );

Adder adder2(
             .src1_i(pc_nextaddr1),
             .src2_i(immediateshift),
             .sum_o(pc_nextaddr2)
             );

MUX_2to1 #(.size(32)) mux_pc_source(
                                    .data0_i(pc_nextaddr1),
                                    .data1_i(pc_nextaddr2),
                                    .select_i(Branch && Zero),
                                    .data_o(pc_nextaddr)
                                    );

endmodule


