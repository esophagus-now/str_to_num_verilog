`timescale 1ns / 1ps
`default_nettype wire

`define WAIT_FIRST_DIGIT 2'd0
`define READ_DIGITS 2'd1
`define SEND_NUM 2'd2

module str_to_num(clk, s_dtm, s_vld, s_rdy,
					   n_dtm, n_vld, n_rdy);
input clk;
input [7:0]       s_dtm; input  s_vld; output s_rdy;
output reg [31:0] n_dtm; output n_vld; input  n_rdy;
reg [1:0] state = `WAIT_FIRST_DIGIT;
wire s_isdigit = (s_dtm >= "0" && s_dtm <= "9");
wire s_handshake = (s_vld && s_rdy);
always @(posedge clk)
	case (state)
	`WAIT_FIRST_DIGIT:
		if (s_handshake && s_isdigit) begin
			state <= `READ_DIGITS;
			n_dtm <= {28'b0, s_dtm[3:0]};
		end
	`READ_DIGITS:
		if (s_handshake && s_isdigit) 
			n_dtm <= {n_dtm[28:0],3'b0}
			        +{n_dtm[30:0],1'b0}
			        +{28'b0,s_dtm[3:0]};
		else if (s_handshake && !s_isdigit) 
			state <= `SEND_NUM;
	`SEND_NUM:
		state <= (n_vld && n_rdy) ? 
		         `WAIT_FIRST_DIGIT : `SEND_NUM;
	endcase
assign n_vld = (state == `SEND_NUM);
assign s_rdy = (state != `SEND_NUM);
endmodule
