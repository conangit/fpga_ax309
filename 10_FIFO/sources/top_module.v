`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:43:57 08/17/2018 
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
    input rst_n,
    output full,
    output rd_ready,
    output [7:0]dout,
    output empty
    );

    wire [7:0]din;
    wire wr_en;
    wire rd_en;
    
    
    control_module u1(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .din(din),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .rd_ready(rd_ready)
    );
    
    fifo_ip fifo_ip_inst(
        .clk(sysclk),   // input clk
        .rst(!rst_n),   // input rst
        .din(din),      // input [7 : 0] din
        .wr_en(wr_en),  // input wr_en
        .rd_en(rd_en),  // input rd_en
        .dout(dout),    // output [7 : 0] dout
        .full(full),    // output full
        .empty(empty)   // output empty
    );
    
    
    //Chipscope
    wire [35:0]CONTROL0;
    wire [255:0]TRIG0;
    
    chipscope_icon icon_debug(
        .CONTROL0(CONTROL0)
    );
    
    chipscope_ila ila_debug(
        .CONTROL(CONTROL0),
        .CLK(sysclk),
        .TRIG0(TRIG0)
    );
    
    assign TRIG0[7:0] = din;
    assign TRIG0[8] = wr_en;
    assign TRIG0[9] = rd_en;
    
    assign TRIG0[10] = full;
    assign TRIG0[11] = rd_ready;
    assign TRIG0[19:12] = dout;
    assign TRIG0[20] = empty;

endmodule
