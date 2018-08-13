`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:53:22 08/12/2018 
// Design Name: 
// Module Name:    pll_test 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module pll_test(
    input clk,
    input rst_n
    );
    
    wire clk_5MHz;
    wire locked1;
    wire locked2;
    
    
    pll_ip_1 P1(
        .CLK_IN1(clk),              // IN 50MHz
        .CLK_OUT1(clk_5MHz),        // OUT 5MHz
        .RESET(~rst_n),
        .LOCKED(locked1)
    );
    
    
    wire clk_1MHz;
    wire clk_0p5MHz;
    
    pll_ip_2 P2(
        .CLK_IN1(clk_5MHz),         // IN 5MHz
        .CLK_OUT1(clk_1MHz),        // OUT 1MHz
        .CLK_OUT2(clk_0p5MHz),      // OUT 0.5MHz
        .RESET(~rst_n),
        .LOCKED(locked2)
    );


endmodule
