`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:09 08/14/2018 
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
    //I2C
    output scl,
    inout sda,
    //digital
    output [7:0]smg_data,
    output [5:0]scan_sig
    );
    
    
    wire [1:0]start_sig;
    wire [7:0]addr_sig;
    wire [7:0]wrdata;
    wire [7:0]rddata;
    wire done_sig;
    wire [23:0]number_sig;
    
    control_module u1(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .start_sig(start_sig),
        .addr_sig(addr_sig),
        .wrdata(wrdata),
        .rddata(rddata),
        .done_sig(done_sig),
        .number_sig(number_sig)
    );
    
    iic_com u2(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .start_sig(start_sig),  //input: output by u1
        .addr_sig(addr_sig),    //input: output by u1
        .wrdata(wrdata),        //input: output by u1
        .rddata(rddata),        //output: input to u1
        .done_sig(done_sig),    //output: input to u1
        .scl(scl),
        .sda(sda)
    );
    
    smg_interface u3(
        .CLK(sysclk),
        .RSTn(rst_n),
        .number_sig(number_sig),    //input: output by u1
        .smg_data(smg_data),
        .scan_sig(scan_sig)
    );


endmodule
