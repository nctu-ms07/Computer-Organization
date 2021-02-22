module carrylookaheadunit(
                          input cin,    
                          input [3:0] g,
                          input [3:0] p,
                          output [3:0] cout
                          );

assign cout[0] = g[0] | (p[0] & cin);
assign cout[1] = g[1] | (g[0] & p[1]) | (cin & p[0] & p[1]);
assign cout[2] = g[2] | (g[1] & p[2]) | (g[0] & p[1] & p[2]) | (cin & p[0] & p[1] & p[2]);
assign cout[3] = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]) | (cin & p[0] & p[1] & p[2] & p[3]);

endmodule