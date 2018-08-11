`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:07:22 08/11/2018
// Design Name:   pll_test
// Module Name:   D:/Program/FPGA/fpga_ax309/06_pll_test/testbench/vtf_pll_test.v
// Project Name:  pll_test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: pll_test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vtf_pll_test;

    // Inputs
    reg clk;
    reg rst_n;

    // Outputs
    wire clk_out;

    // Instantiate the Unit Under Test (UUT)
    pll_test uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .clk_out(clk_out)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;

        // Wait 100 ns for global reset to finish
        #100;
        rst_n = 1;
        
        // Add stimulus here
        #2000;
        $stop;

    end
    
    always #10 clk = ~clk; //产生50MHz时钟源
      
endmodule

