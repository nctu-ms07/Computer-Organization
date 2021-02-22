module HazardDetectUnit(
                               input ID_EX_MemRead_i,
							   input [5-1:0] ID_EX_RT_i,
							   input [5-1:0] IF_ID_RS_i,
							   input [5-1:0] IF_ID_RT_i,
							   output pc_write_o,
							   output IF_ID_flush_o
							   );

assign pc_write_o = ~(ID_EX_MemRead_i && ((ID_EX_RT_i == IF_ID_RS_i) || (ID_EX_RT_i == IF_ID_RT_i)));
assign IF_ID_flush_o = (ID_EX_MemRead_i && ((ID_EX_RT_i == IF_ID_RS_i) || (ID_EX_RT_i == IF_ID_RT_i)));

/*
always @(*) begin
  if(ID_EX_MemRead_i && (ID_EX_RT_i == IF_ID_RS_i) || (ID_EX_RT_i == IF_ID_RT_i)) begin
      pc_write_o <= 1'b0;
      IF_ID_flush_o <= 1'b1;
  end
  else begin
      pc_write_o <= 1'b1;
      IF_ID_flush_o <= 1'b0;
  end
end
*/

endmodule