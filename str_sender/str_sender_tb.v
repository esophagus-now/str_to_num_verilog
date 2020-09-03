`timescale 1ns / 1ps
`default_nettype none

`include "macros.vh"
`include "str_sender.v"

module tb();

	reg clk = 0;
	wire [7:0] s_dtm; reg [7:0] s_dtm_expected;
	wire s_vld; reg s_vld_expected;
	reg s_rdy;

	always #5 clk <= ~clk;
	
	`auto_tb_decls;
	initial begin
		`open_drivers_file("str_sender_drivers.mem");	
		$dumpfile("str_sender.vcd");
		$dumpvars;
		$dumplimit(512000);
		
		//Prevent infinite time simulation
		#10000
		$display("Simulation timeout");
		$finish;
	end

	`auto_tb_read_loop(clk)
		`dummy = $fscanf(`fd, "%h%b%b",
			s_dtm_expected, 
			s_vld_expected,
			s_rdy
		);
	`auto_tb_read_end

	`auto_tb_test_loop(clk)
		`test(s_vld, s_vld_expected);
		if (s_vld) `test(s_dtm, s_dtm_expected);
	`auto_tb_test_end

	str_sender DUT(clk, s_dtm, s_vld, s_rdy);

endmodule
