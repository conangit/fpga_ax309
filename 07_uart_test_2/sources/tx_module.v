`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:20:02 08/13/2018 
// Design Name: 
// Module Name:    tx_module 
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
module tx_module(
    sysclk,
    rst_n,
    tx,
    tx_en_sig,
    tx_data,
    tx_done_sig
    );
    
    input sysclk;
    input rst_n;
    input tx_en_sig;
    input [7:0]tx_data;
    output tx_done_sig;
    output tx;
    
    wire clk_bps;
    
    bps_module u1(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .count_sig(tx_en_sig),
        .clk_bps(clk_bps)
    );
    
    wire tx_idle;
    
    tx_control_module u2(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .clk_bps(clk_bps),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_done_sig(tx_done_sig),
        .tx_idle(tx_idle),
        .tx(tx)
    );


endmodule
