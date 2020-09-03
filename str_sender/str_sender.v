`timescale 1ns / 1ps
`default_nettype none

module str_sender(clk, s_dtm, s_vld, s_rdy);
input clk;
output [7:0] s_dtm; output s_vld; input s_rdy;
wire [35*8 -1:0] str = {"22/11/1996: ",
                        "0xBED4BABE = 3201612478"};
reg [5:0] i = 0;
always @(posedge clk)
	if (s_vld && s_rdy)
		i <= (i == 6'd34) ? 0 : i + 1;
assign s_dtm = str[8*(35-i) -1 -: 8];
assign s_vld = 1;
endmodule
