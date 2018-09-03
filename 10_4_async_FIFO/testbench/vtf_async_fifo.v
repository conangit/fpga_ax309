`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:44:27 09/02/2018
// Design Name:   top_module
// Module Name:   D:/Program/FPGA/fpga_ax309/10_4_async_FIFO/testbench/vtf_async_fifo.v
// Project Name:  aFIFO
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top_module
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vtf_async_fifo;

    // Inputs
    reg sysclk;
    reg rst_n;

    // Instantiate the Unit Under Test (UUT)
    top_module uut (
        .sysclk(sysclk), 
        .rst_n(rst_n)
    );

    initial begin
        // Initialize Inputs
        sysclk = 0;
        rst_n = 0;

        // Wait 100 ns for global reset to finish
        #100;
        rst_n = 1;
        
        // Add stimulus here
        #1_000_000;
        $stop;
    end

    always #10 sysclk = ~sysclk; //产生50MHz时钟源
      
endmodule

