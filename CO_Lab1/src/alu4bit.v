module alu4bit(
               input [3:0] src1,
               input [3:0] src2,
               input less,
               input A_invert,
               input B_invert,
               input cin,
               input [1:0] operation,
               output reg [3:0] result,
               output msbcin,
               output g,
               output p
               );
wire [3:0] clu_g;
wire [3:0] clu_p;
wire [3:0] carry;
wire [3:0] tmp;

carrylookaheadunit clu(
                       .cin(cin),
                       .g(clu_g),
                       .p(clu_p),
                       .cout(carry));

alu_top alu0(
             .src1(src1[0]),
             .src2(src2[0]),
             .less(less),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(cin),
             .operation(operation),
             .result(tmp[0]),
             .g(clu_g[0]),
             .p(clu_p[0])
              );

alu_top alu1(
             .src1(src1[1]),
             .src2(src2[1]),
             .less(1'b0),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(carry[0]),
             .operation(operation),
             .result(tmp[1]),
             .g(clu_g[1]),
             .p(clu_p[1])
              );

alu_top alu2(
             .src1(src1[2]),
             .src2(src2[2]),
             .less(1'b0),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(carry[1]),
             .operation(operation),
             .result(tmp[2]),
             .g(clu_g[2]),
             .p(clu_p[2])
              );
              
alu_top alu3(
             .src1(src1[3]),
             .src2(src2[3]),
             .less(1'b0),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(carry[2]),
             .operation(operation),
             .result(tmp[3]),
             .g(clu_g[3]),
             .p(clu_p[3])
              );

assign msbcin = carry[2];              
assign g = clu_g[3] | (clu_g[2] & clu_p[3]) | (clu_g[1] & clu_p[2] & clu_p[3]) | (clu_g[0] & clu_p[1] & clu_p[2] & clu_p[3]);
assign p = clu_p[3] & clu_p[2] & clu_p[1] & clu_p[0];

always@(*)begin
    result = tmp;
end

endmodule