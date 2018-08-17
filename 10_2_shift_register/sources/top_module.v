`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:06:44 08/16/2018 
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
//
// 本实验有一个奇怪的现象，就是按下复位按键后
// 有时显示状态并没有回到000000
//
module top_module(
    input sysclk,
    input rst_n,
    output [7:0]smg_data,
    output [5:0]scan_sig
    );

    wire iEn;
    wire [3:0]iAddr;
    wire [3:0]iData;
    wire [23:0]number_sig;
    
    comtrol_module u1(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .iEn(iEn),              //output to u2
        .iAddr(iAddr),          //output to u2
        .iData(iData)           //output to u2
    );
    
    pushshift_savemod u2(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .iEn(iEn),
        .iAddr(iAddr),
        .iData(iData),
        .oData(number_sig)          //output to u3
    );
    
    smg_interface u3(
        .CLK(sysclk),
        .RSTn(rst_n),
        .number_sig(number_sig),    //input from u2
        .smg_data(smg_data),
        .scan_sig(scan_sig)
    );


endmodule
