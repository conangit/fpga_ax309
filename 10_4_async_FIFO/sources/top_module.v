`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:38:23 09/02/2018 
// Design Name: 
// Module Name:    top_module 
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
module top_module(
    input sysclk,
    input rst_n
    );
    
    
    wire clk_12m5;
    wire clk_50m;
    
    pll_ip u1(
        .CLK_IN1(sysclk),
        .CLK_OUT1(clk_12m5),
        .CLK_OUT2(clk_50m),
        .RESET(!rst_n)
    );
    
    wire wr_en;
    wire rd_en;
    wire [7:0]din;
    wire rd_ready;
    wire [15:0]dout;
    wire full;
    wire empty;
    
    fifo_control_mod u2(
        .rst_n(rst_n),
        .wr_clk(clk_12m5),
        .rd_clk(clk_50m),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wrdata(din),
        .rd_ready(rd_ready)
    );
    
    async_fifo_ip u3(
        .rst(!rst_n),       // input rst
        // .wr_clk(clk_12m5),  // input wr_clk 12.5MHz
        .wr_clk(clk_50m),
        .rd_clk(clk_50m),   // input rd_clk 50MHz
        .din(din),          // input [7 : 0] din
        .wr_en(wr_en),      // input wr_en
        .rd_en(rd_en),      // input rd_en
        .dout(dout),        // output [15 : 0] dout
        .full(full),        // output full
        .empty(empty)       // output empty
    );

    
    
    //Chipscope
    wire [35:0]CONTROL0;
    wire [63:0]TRIG0;
    
    chipscope_icon icon_debug(
        .CONTROL0(CONTROL0)
    );
    
    chipscope_ila ila_debug(
        .CONTROL(CONTROL0),
        .CLK(clk_50m),
        .TRIG0(TRIG0)
    );
    
    assign TRIG0[0] = wr_en;
    assign TRIG0[8:1] = din;
    
    assign TRIG0[9] = rd_en;
    assign TRIG0[10] = rd_ready;
    assign TRIG0[26:11] = dout;
    
    assign TRIG0[27] = full;
    assign TRIG0[28] = empty;
    

endmodule
