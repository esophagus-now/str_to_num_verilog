`timescale 1ns / 1ps
`default_nettype none

`include "macros.vh"
`include "str_to_num.v"

module tb();

	reg [7:0] s_dtm;
	reg s_vld;
	wire s_rdy; reg s_rdy_expected;
	wire [31:0] n_dtm; reg [31:0] n_dtm_expected;
	wire n_vld; reg n_vld_expected;
	reg n_rdy;

	reg clk = 0;

	always #5 clk <= ~clk;

	`auto_tb_decls;

	initial begin
		`open_drivers_file("str_to_num_drivers.mem");
		$dumpfile("str_to_num.vcd");
		$dumpvars;
		$dumplimit(512000);
		
		//Prevent infinite time simulation
		#10000
		$display("Simulation timeout");
		$finish;
	end

	`auto_tb_read_loop(clk)
		`dummy = $fscanf(`fd, "%c%b%b%d%b%b",
			s_dtm, s_vld, s_rdy_expected,
			n_dtm_expected, n_vld_expected, n_rdy
		);
	`auto_tb_read_end

	
	`auto_tb_test_loop(clk)
		`test(s_rdy, s_rdy_expected);
		`test(n_vld, n_vld_expected);
		if (n_vld) `test(n_dtm, n_dtm_expected);
	`auto_tb_test_end
	
	str_to_num DUT (clk, s_dtm, s_vld, s_rdy, n_dtm, n_vld, n_rdy);

endmodule
