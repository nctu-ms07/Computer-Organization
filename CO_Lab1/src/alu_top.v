module alu_top(
               input src1,
               input src2,
               input less,
               input A_invert,
               input B_invert,
               input cin,
               input [1:0] operation,
               output reg result,
               output g,
               output p
               );
wire A,B,op_00,op_01,op_10;
assign A = src1 ^ A_invert;
assign B = src2 ^ B_invert;
assign op_00 = A & B;
assign op_01 = A | B;
assign op_10 = (p ^ cin);
assign g = op_00;
assign p = (A ^ B);

always@(*)begin
    case (operation)
        2'b00 : result = op_00;
        2'b01 : result = op_01;
        2'b10 : result = op_10;
        2'b11 : result = less;
    endcase
end

endmodule