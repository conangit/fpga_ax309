`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:16:03 08/13/2018 
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
    input rx,
    output tx
    );
    
    wire clk;
    
    clkdiv u0(
        .sysclk(sysclk),
        .clkout(clk)
    );
    
    wire [7:0]rxdata;
    wire rdsig;
    wire dataerror;
    wire framerror;
    
    uartrx u1(
        .clk(clk),
        .rx(rx),
        .dataout(rxdata),
        .rdsig(rdsig),
        .dataerror(dataerror),
        .framerror(framerror)
    );
    
    wire [7:0]txdata;
    wire wrsig;
    wire idle;
    
    uarttx u2(
        .clk(clk),
        .datain(txdata),
        .wrsig(wrsig),
        .idle(idle),
        .tx(tx)
    );
    
    control_module u3(
        .clk(clk),
        .rdsig(rdsig),
        .rxdata(rxdata),
        .wrsig(wrsig),
        .txdata(txdata)
    );

endmodule
