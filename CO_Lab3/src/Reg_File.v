//Subject:     CO project 2 - Register File
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Reg_File(
    clk_i,
	rst_i,
    RSaddr_i,
    RTaddr_i,
    RDaddr_i,
    RDdata_i,
    RegWrite_i,
    RSdata_o,
    RTdata_o
    );
          
//I/O ports
input           clk_i;
input           rst_i;
input           RegWrite_i;
input  [5-1:0]  RSaddr_i;
input  [5-1:0]  RTaddr_i;
input  [5-1:0]  RDaddr_i;
input  [32-1:0] RDdata_i;

output [32-1:0] RSdata_o;
output [32-1:0] RTdata_o;   

//Internal signals/registers           
reg  signed [32-1:0] REGISTER_BANK [0:32-1];     //32 word registers
wire        [32-1:0] RSdata_o;
wire        [32-1:0] RTdata_o;

//Read the data
assign RSdata_o = REGISTER_BANK[RSaddr_i] ;
assign RTdata_o = REGISTER_BANK[RTaddr_i] ;   

//Writing data when postive edge clk_i and RegWrite_i was set.
always @( posedge rst_i or posedge clk_i  ) begin
    if(rst_i == 0) begin
	    REGISTER_BANK[0]  <= 0; REGISTER_BANK[1]  <= 0; REGISTER_BANK[2]  <= 0; REGISTER_BANK[3]  <= 0;
	    REGISTER_BANK[4]  <= 0; REGISTER_BANK[5]  <= 0; REGISTER_BANK[6]  <= 0; REGISTER_BANK[7]  <= 0;
        REGISTER_BANK[8]  <= 0; REGISTER_BANK[9]  <= 0; REGISTER_BANK[10] <= 0; REGISTER_BANK[11] <= 0;
	    REGISTER_BANK[12] <= 0; REGISTER_BANK[13] <= 0; REGISTER_BANK[14] <= 0; REGISTER_BANK[15] <= 0;
        REGISTER_BANK[16] <= 0; REGISTER_BANK[17] <= 0; REGISTER_BANK[18] <= 0; REGISTER_BANK[19] <= 0;      
        REGISTER_BANK[20] <= 0; REGISTER_BANK[21] <= 0; REGISTER_BANK[22] <= 0; REGISTER_BANK[23] <= 0;
        REGISTER_BANK[24] <= 0; REGISTER_BANK[25] <= 0; REGISTER_BANK[26] <= 0; REGISTER_BANK[27] <= 0;
        REGISTER_BANK[28] <= 0; REGISTER_BANK[29] <= 128; REGISTER_BANK[30] <= 0; REGISTER_BANK[31] <= 0;
	end
    else begin
        if(RegWrite_i) 
            REGISTER_BANK[RDaddr_i] <= RDdata_i;	
		else 
		    REGISTER_BANK[RDaddr_i] <= REGISTER_BANK[RDaddr_i];
	end
end

endmodule     





                    
                    