`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:10:40 08/12/2018
// Design Name:   clkdiv
// Module Name:   D:/Program/FPGA/fpga_ax309/07_uart_test/testbench/vtf_clkdiv.v
// Project Name:  uart_test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clkdiv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vtf_clkdiv;

    // Inputs
    reg clk;

    // Outputs
    wire clkout;

    // Instantiate the Unit Under Test (UUT)
    clkdiv uut (
        .clk(clk),
        .clkout(clkout)
    );

    initial begin
        // Initialize Inputs
        clk = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        #65200;
        $stop;
        
    end
    
    always #10 clk = ~clk;
      
endmodule

