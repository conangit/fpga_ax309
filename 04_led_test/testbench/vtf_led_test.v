`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:36:43 08/11/2018
// Design Name:   led_test
// Module Name:   D:/Program/FPGA/fpga_ax309/04_led_test/testbench/vtf_led_test.v
// Project Name:  lest_test
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: led_test
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vtf_led_test;

    // Inputs
    reg clk;
    reg rst_n;

    // Outputs
    wire [3:0] leds;

    // Instantiate the Unit Under Test (UUT)
    led_test uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .leds(leds)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;

        // Wait 100 ns for global reset to finish
        #100;
        rst_n = 1;
        
        
        // Add stimulus here
        #2000; //仿真时间2000ns = 2us
        // $stop; //modelsim运行到此处停止
    end
    
    always begin
        #10 clk = ~clk; //产生50MHz的时钟源
    end
    
      
endmodule

