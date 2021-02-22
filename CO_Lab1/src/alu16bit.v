module alu16bit(
               input [15:0] src1,
               input [15:0] src2,
               input less,
               input A_invert,
               input B_invert,
               input cin,
               input [1:0] operation,
               output reg [15:0] result,
               output msbcin,
               output g,
               output p
               );
wire [3:0] clu_g;
wire [3:0] clu_p;
wire [3:0] carry;
wire [15:0] tmp;


carrylookaheadunit clu(
                       .cin(cin),
                       .g(clu_g),
                       .p(clu_p),
                       .cout(carry));

alu4bit alu0(
             .src1(src1[3:0]),
             .src2(src2[3:0]),
             .less(less),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(cin),
             .operation(operation),
             .result(tmp[3:0]),
             .g(clu_g[0]),
             .p(clu_p[0])
              );

alu4bit alu1(
             .src1(src1[7:4]),
             .src2(src2[7:4]),
             .less(1'b0),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(carry[0]),
             .operation(operation),
             .result(tmp[7:4]),
             .g(clu_g[1]),
             .p(clu_p[1])
              );

alu4bit alu2(
             .src1(src1[11:8]),
             .src2(src2[11:8]),
             .less(1'b0),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(carry[1]),
             .operation(operation),
             .result(tmp[11:8]),
             .g(clu_g[2]),
             .p(clu_p[2])
              );
              
alu4bit alu3(
             .src1(src1[15:12]),
             .src2(src2[15:12]),
             .less(1'b0),
             .A_invert(A_invert),
             .B_invert(B_invert),
             .cin(carry[2]),
             .operation(operation),
             .result(tmp[15:12]),
             .msbcin(msbcin),
             .g(clu_g[3]),
             .p(clu_p[3])
              );
              
assign g = clu_g[3] | (clu_g[2] & clu_p[3]) | (clu_g[1] & clu_p[2] & clu_p[3]) | (clu_g[0] & clu_p[1] & clu_p[2] & clu_p[3]);
assign p = clu_p[3] & clu_p[2] & clu_p[1] & clu_p[0];

always@(*)begin
    result = tmp;
end

endmodule