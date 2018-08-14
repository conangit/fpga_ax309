`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:29:55 08/13/2018 
// Design Name: 
// Module Name:    uart_test 
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
module uart_test(
    sysclk,
    rst_n,
    rx,
    tx
    );
    
    input sysclk;
    input rst_n;
    input rx;
    output tx;
    
    wire rx_en_sig;
    wire rx_done_sig;
    wire tx_en_sig;
    wire tx_done_sig;
    
    wire [7:0]rx_data;
    wire [7:0]tx_data;
    
    
    rx_module u1(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .rx(rx),
        .rx_en_sig(rx_en_sig),
        .rx_data(rx_data),
        .rx_done_sig(rx_done_sig)
    );
    
    tx_module u2(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .tx(tx),
        .tx_en_sig(tx_en_sig),
        .tx_data(tx_data),
        .tx_done_sig(tx_done_sig)
    );
    
    control_module u3(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .rx_done_sig(rx_done_sig),
        .tx_done_sig(tx_done_sig),
        .rx_en_sig(rx_en_sig),
        .tx_en_sig(tx_en_sig),
        .rx_data(rx_data),
        .tx_data(tx_data)
    );


endmodule
