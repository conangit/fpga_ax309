`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:07:01 08/13/2018
// Design Name:   bps_module
// Module Name:   D:/Program/FPGA/fpga_ax309/07_uart_test_2/testbench/vtf_bps_mod.v
// Project Name:  uart_test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bps_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vtf_bps_mod;

    // Inputs
    reg sysclk;
    reg rst_n;
    reg count_sig;

    // Outputs
    wire clk_bps;

    // Instantiate the Unit Under Test (UUT)
    bps_module uut (
        .sysclk(sysclk), 
        .rst_n(rst_n), 
        .count_sig(count_sig), 
        .clk_bps(clk_bps)
    );

    initial begin
        // Initialize Inputs
        sysclk = 0;
        rst_n = 0;
        count_sig = 0;

        // Wait 100 ns for global reset to finish
        #100;
        rst_n = 1;
        count_sig = 1;
        // Add stimulus here
        #1000000;
        $stop;
    end
      
      always #10 sysclk = ~sysclk;
      
endmodule

