`timescale 1ns / 1ps
`default_nettype wire

module str_sender(clk, s_dtm, s_vld, s_rdy);
input clk;
output [7:0] s_dtm; output s_vld; input s_rdy;
wire [35*8 -1:0] str = {"19/08/2005: ",
                        "0x5F3759DF = 1597463007"};
reg [5:0] i = 6'd35;
always @(posedge clk)
	if (s_vld && s_rdy)
		i <= (i == 6'd1) ? 6'd35 : i - 1;
assign s_dtm = str[8*i -1 -: 8];
assign s_vld = 1;
endmodule
