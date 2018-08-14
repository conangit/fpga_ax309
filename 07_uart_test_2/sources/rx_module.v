`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:09:35 08/13/2018 
// Design Name: 
// Module Name:    rx_module 
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
module rx_module(
    sysclk,
    rst_n,
    rx,
    rx_en_sig,
    rx_data,
    rx_done_sig
    );
    
    input sysclk;
    input rst_n;
    input rx;
    input rx_en_sig;
    
    output [7:0]rx_data;
    output rx_done_sig;
    
    wire count_sig;
    wire clk_bps;
    
    bps_module u1(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .count_sig(count_sig),
        .clk_bps(clk_bps)
    );
    
    wire dataerror;
    wire frameerror;
    
    rx_control_module u2(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .rx(rx),
        .clk_bps(clk_bps),
        .rx_en_sig(rx_en_sig),
        .count_sig(count_sig),
        .rx_data(rx_data),
        .rx_done_sig(rx_done_sig),
        .dataerror(dataerror),
        .frameerror(frameerror)
    );
    

endmodule
