`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:21:07 08/11/2018 
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
    input rst_n,
    output [2:0]clk_out // 5 10 25 MHz
    );
    
    wire pll_clk_out1;
    wire pll_clk_out2;
    wire pll_clk_out3;
    wire locked;
    
    
    pll_ip u1(
        // Clock in ports
        .CLK_IN1(clk),                  // IN 50MHz
        // Clock out ports
        .CLK_OUT1(pll_clk_out1),        // OUT 25Mhz
        .CLK_OUT2(pll_clk_out2),        // OUT 10Mhz
        .CLK_OUT3(pll_clk_out3),        // OUT 5MHz
        // Status and control signals
        .RESET(~rst_n),                 // IN
        .LOCKED(locked)                 // OUT
    );
    
    //调用ODDR2使时钟信号通过普通IO输出
    ODDR2
    #(.DDR_ALIGNMENT("NONE"),   //sets output alignment to "NONE", "C0" or "C1"
    .INIT(1'b0),                //sets initial state of Q output to "1'b0" or "1'b1"
    .SRTYPE("SYNC"))            //specifies "SYNC" or "ASYNC" set/reset
    ODDR2_inst_u1 (
        .Q(clk_out[0]),         //1-bit DDR output data
        .C0(pll_clk_out1),      //1-bit clock input
        .C1(~pll_clk_out1),     //1-bit clock input
        .CE(1'b1),              //1-bit clock enable input
        .D0(1'b1),              //1-bit data input (associated with C0)
        .D1(1'b0),              //1-bit data input (associated with C1)
        .R(1'b0),               //1-bit reset input
        .S(1'b0)                //1-bit set input
    );
    
    ODDR2
    #(.DDR_ALIGNMENT("NONE"),   //sets output alignment to "NONE", "C0" or "C1"
    .INIT(1'b0),                //sets initial state of Q output to "1'b0" or "1'b1"
    .SRTYPE("SYNC"))            //specifies "SYNC" or "ASYNC" set/reset
    ODDR2_inst_u2 (
        .Q(clk_out[1]),         //1-bit DDR output data
        .C0(pll_clk_out2),      //1-bit clock input
        .C1(~pll_clk_out2),     //1-bit clock input
        .CE(1'b1),              //1-bit clock enable input
        .D0(1'b1),              //1-bit data input (associated with C0)
        .D1(1'b0),              //1-bit data input (associated with C1)
        .R(1'b0),               //1-bit reset input
        .S(1'b0)                //1-bit set input
    );
    
    ODDR2
    #(.DDR_ALIGNMENT("NONE"),   //sets output alignment to "NONE", "C0" or "C1"
    .INIT(1'b0),                //sets initial state of Q output to "1'b0" or "1'b1"
    .SRTYPE("SYNC"))            //specifies "SYNC" or "ASYNC" set/reset
    ODDR2_inst_u3 (
        .Q(clk_out[2]),         //1-bit DDR output data
        .C0(pll_clk_out3),      //1-bit clock input
        .C1(~pll_clk_out3),     //1-bit clock input
        .CE(1'b1),              //1-bit clock enable input
        .D0(1'b1),              //1-bit data input (associated with C0)
        .D1(1'b0),              //1-bit data input (associated with C1)
        .R(1'b0),               //1-bit reset input
        .S(1'b0)                //1-bit set input
    );
    


endmodule
