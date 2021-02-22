`timescale 1ns / 1ps
//Subject:     CO project 4 - Test Bench
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

`define CYCLE_TIME 10			

module TestBench;

//Internal Signals
reg         CLK;
reg         RST;
integer     count;
integer     i;
integer     handle;

//Greate tested modle  
Pipe_CPU_1 cpu(
    .clk_i(CLK),
    .rst_i(RST)
    );
 
//Main function

always #(`CYCLE_TIME/2) CLK = ~CLK;	

initial begin
    //handle = $fopen("P4_Result.dat");
    CLK = 0;
    RST = 0;
    count = 0;
   
    // instruction memory
    for(i=0; i<32; i=i+1)
    begin
        cpu.IM.instruction_file[i] = 32'b0;
    end

    $readmemb("testcase/CO_P5_test_1.txt", cpu.IM.instruction_file);  //Read instruction from "CO_P5_test_1.txt"   
    
    // data memory
    for(i=0; i<128; i=i+1)
    begin
        cpu.DM.Mem[i] = 8'b0;
    end
    
    #(`CYCLE_TIME)      RST = 1;
    #(`CYCLE_TIME*50)   $stop;
    //#(`CYCLE_TIME*20)	$fclose(handle); $stop;
end

always@(posedge CLK) begin
    count = count + 1;

    //print result to transcript 
    $display("Register===========================================================\n");
	$display("PC add = %d", cpu.pc_curaddr);
    $display("r0=%5d, r1=%5d, r2=%5d, r3=%5d, r4=%5d, r5=%5d, r6=%5d, r7=%5d\n",
    cpu.RF.Reg_File[0], cpu.RF.Reg_File[1], cpu.RF.Reg_File[2], cpu.RF.Reg_File[3], cpu.RF.Reg_File[4], 
    cpu.RF.Reg_File[5], cpu.RF.Reg_File[6], cpu.RF.Reg_File[7],
    );
    $display("r8=%5d, r9=%5d, r10=%5d, r11=%5d, r12=%5d, r13=%5d, r14=%5d, r15=%5d\n",
    cpu.RF.Reg_File[8], cpu.RF.Reg_File[9], cpu.RF.Reg_File[10], cpu.RF.Reg_File[11], cpu.RF.Reg_File[12], 
    cpu.RF.Reg_File[13], cpu.RF.Reg_File[14], cpu.RF.Reg_File[15],
    );
    $display("r16=%5d, r17=%5d, r18=%5d, r19=%5d, r20=%5d, r21=%5d, r22=%5d, r23=%5d\n",
    cpu.RF.Reg_File[16], cpu.RF.Reg_File[17], cpu.RF.Reg_File[18], cpu.RF.Reg_File[19], cpu.RF.Reg_File[20], 
    cpu.RF.Reg_File[21], cpu.RF.Reg_File[22], cpu.RF.Reg_File[23],
    );
    $display("r24=%5d, r25=%5d, r26=%5d, r27=%5d, r28=%5d, r29=%5d, r30=%5d, r31=%5d\n",
    cpu.RF.Reg_File[24], cpu.RF.Reg_File[25], cpu.RF.Reg_File[26], cpu.RF.Reg_File[27], cpu.RF.Reg_File[28], 
    cpu.RF.Reg_File[29], cpu.RF.Reg_File[30], cpu.RF.Reg_File[31],
    );

    $display("\nMemory\n");
    $display("m0=%5d, m1=%5d, m2=%5d, m3=%5d, m4=%5d, m5=%5d, m6=%5d, m7=%5d\n\nm8=%5d, m9=%5d, m10=%5d, m11=%5d, m12=%5d, m13=%5d, m14=%5d, m15=%5d\n\nr16=%5d, m17=%5d, m18=%5d, m19=%5d, m20=%5d, m21=%5d, m22=%5d, m23=%5d\n\nm24=%5d, m25=%5d, m26=%5d, m27=%5d, m28=%5d, m29=%5d, m30=%5d, m31=%5d",							 
            cpu.DM.memory[0], cpu.DM.memory[1], cpu.DM.memory[2], cpu.DM.memory[3],
            cpu.DM.memory[4], cpu.DM.memory[5], cpu.DM.memory[6], cpu.DM.memory[7],
            cpu.DM.memory[8], cpu.DM.memory[9], cpu.DM.memory[10], cpu.DM.memory[11],
            cpu.DM.memory[12], cpu.DM.memory[13], cpu.DM.memory[14], cpu.DM.memory[15],
            cpu.DM.memory[16], cpu.DM.memory[17], cpu.DM.memory[18], cpu.DM.memory[19],
            cpu.DM.memory[20], cpu.DM.memory[21], cpu.DM.memory[22], cpu.DM.memory[23],
            cpu.DM.memory[24], cpu.DM.memory[25], cpu.DM.memory[26], cpu.DM.memory[27],
            cpu.DM.memory[28], cpu.DM.memory[29], cpu.DM.memory[30], cpu.DM.memory[31]
            );
	
end
  
endmodule

