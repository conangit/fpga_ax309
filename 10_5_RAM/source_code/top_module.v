`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:11:06 09/03/2018 
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
    output [7:0]douta
    );
    
    wire wea;
    wire [4:0]addra;
    wire [7:0]dina;
    
    ram_test u1(
        .clk(sysclk),
        .rst_n(rst_n),
        .wea(wea),
        .addra(addra),
        .dina(dina)
    );
    
    //32*8bit的FPGA片内RAM例化
    ram_controller u2(
        .clka(sysclk),  // input clka
        .wea(wea),      // input [0 : 0] wea
        .addra(addra),  // input [4 : 0] addra
        .dina(dina),    // input [7 : 0] dina
        .douta(douta)   // output [7 : 0] douta
    );
    
    
    //Chipscope
    wire [35:0]CONTROL0;
    wire [63:0]TRIG0;
    
    chipscope_icon debug_icon(
        .CONTROL0(CONTROL0)
    );
    
    chipscope_ila debug_ila(
        .CONTROL(CONTROL0),
        .CLK(sysclk),
        .TRIG0(TRIG0)
    );
    
    assign TRIG0[0] = wea;
    assign TRIG0[5:1] = addra;
    assign TRIG0[13:6] = dina;
    assign TRIG0[21:14] = douta;

endmodule
