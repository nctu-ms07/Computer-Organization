`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:06:58 11/17/2013
// Design Name: 
// Module Name:    testbench 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define CYCLE_TIME 50			

module testbench;
reg Clk, Start;
integer     end_count;
// reg [31:0] i;

  Simple_Single_CPU CPU(Clk,Start);
  
initial
begin
	Clk = 0;
    Start = 0;
    
    #(`CYCLE_TIME) Start = 1;
    #(`CYCLE_TIME*320)	$stop;
end
  
always@(posedge Clk) begin
  	$display("PC = %d", CPU.PC.pc_out_o);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.memory[0], CPU.Data_Memory.memory[1], CPU.Data_Memory.memory[2], CPU.Data_Memory.memory[3], CPU.Data_Memory.memory[4], CPU.Data_Memory.memory[5], CPU.Data_Memory.memory[6], CPU.Data_Memory.memory[7]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.memory[8], CPU.Data_Memory.memory[9], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[12], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[15]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.memory[16], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[20], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[23]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.memory[24], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[28], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[31]);
    $display("Registers");
    $display("R0 = %d, R1 = %d, R2 = %d, R3 = %d, R4 = %d, R5 = %d, R6 = %d, R7 = %d", CPU.Registers.REGISTER_BANK[ 0], CPU.Registers.REGISTER_BANK[ 1], CPU.Registers.REGISTER_BANK[ 2], CPU.Registers.REGISTER_BANK[ 3], CPU.Registers.REGISTER_BANK[ 4], CPU.Registers.REGISTER_BANK[ 5], CPU.Registers.REGISTER_BANK[ 6], CPU.Registers.REGISTER_BANK[ 7]);
    $display("R8 = %d, R9 = %d, R10 =%d, R11 =%d, R12 =%d, R13 =%d, R14 =%d, R15 =%d", CPU.Registers.REGISTER_BANK[ 8], CPU.Registers.REGISTER_BANK[ 9], CPU.Registers.REGISTER_BANK[10], CPU.Registers.REGISTER_BANK[11], CPU.Registers.REGISTER_BANK[12], CPU.Registers.REGISTER_BANK[13], CPU.Registers.REGISTER_BANK[14], CPU.Registers.REGISTER_BANK[15]);
    $display("R16 =%d, R17 =%d, R18 =%d, R19 =%d, R20 =%d, R21 =%d, R22 =%d, R23 =%d", CPU.Registers.REGISTER_BANK[16], CPU.Registers.REGISTER_BANK[17], CPU.Registers.REGISTER_BANK[18], CPU.Registers.REGISTER_BANK[19], CPU.Registers.REGISTER_BANK[20], CPU.Registers.REGISTER_BANK[21], CPU.Registers.REGISTER_BANK[22], CPU.Registers.REGISTER_BANK[23]);
    $display("R24 =%d, R25 =%d, R26 =%d, R27 =%d, R28 =%d, R29 =%d, R30 =%d, R31 =%d", CPU.Registers.REGISTER_BANK[24], CPU.Registers.REGISTER_BANK[25], CPU.Registers.REGISTER_BANK[26], CPU.Registers.REGISTER_BANK[27], CPU.Registers.REGISTER_BANK[28], CPU.Registers.REGISTER_BANK[29], CPU.Registers.REGISTER_BANK[30], CPU.Registers.REGISTER_BANK[31]);
	
end

always #(`CYCLE_TIME/2) Clk = ~Clk;	
  
endmodule

