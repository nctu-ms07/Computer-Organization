module alu(
           input clk,
           input rst_n,
           input [31:0] src1,
           input [31:0] src2,
           input [3:0] ALU_control,
           output reg [31:0] result,
           output reg zero,
           output reg cout,
           output reg overflow
           );
wire less,msbcin,g,p;
wire [31:0] tmp;

alu32bit unit(.src1(src1),
              .src2(src2),
              .less(less),
              .A_invert(ALU_control[3]),
              .B_invert(ALU_control[2]),
              .cin(ALU_control[2]),
              .operation(ALU_control[1:0]),
              .result(tmp),
              .msbcin(msbcin),
              .g(g),
              .p(p)
              );
              
assign less = (src1[31] ^ ~src2[31]) ?  (src1[31] ^ ~src2[31]) ^ msbcin : src1[31];

always@( posedge clk or negedge rst_n ) 
begin
	if(rst_n) begin
	result = tmp;
	zero = ~|tmp;
	cout = (g | (p & ALU_control[2])) & (ALU_control[1] & ~ALU_control[0]);
	overflow = msbcin ^ (g | (p & ALU_control[2]));
	end
	else begin

	end
end

endmodule