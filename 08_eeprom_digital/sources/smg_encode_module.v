`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:24:24 08/09/2018 
// Design Name: 
// Module Name:    smg_encode_module 
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
module smg_encode_module(
    CLK,
    RSTn,
    number_data,
    smg_data
    );
    
    input CLK;
    input RSTn;
    input [3:0]number_data;
    output [7:0]smg_data;
    
    /*
     * 6位共阳数码管: 阴显示
     * 低电平选通
     * 共阳：char code table[]={0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90,0x88,0x83,0xc6,0xa1,0x86,0x8e};
     * 共阴：char code table[]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f,0x77,0x7c,0x39,0x5e,0x79,0x71};
     */
    parameter _0 = 8'b1100_0000;
    parameter _1 = 8'b1111_1001;
    parameter _2 = 8'b1010_0100;
    parameter _3 = 8'b1011_0000;
    parameter _4 = 8'b1001_1001;
    parameter _5 = 8'b1001_0010;
    parameter _6 = 8'b1000_0010;
    parameter _7 = 8'b1111_1000;
    parameter _8 = 8'b1000_0000;
    parameter _9 = 8'b1001_0000;
    parameter _a = 8'b1000_1000;
    parameter _b = 8'b1000_0011;
    parameter _c = 8'b1100_0110;
    parameter _d = 8'b1010_0001;
    parameter _e = 8'b1000_0110;
    parameter _f = 8'b1000_1110;

    parameter _z = 8'b1111_1111;

    reg [7:0]rSmg;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            rSmg <= _z;
        else
            case(number_data)
            
                4'd0:  rSmg<= _0;
                4'd1:  rSmg<= _1;
                4'd2:  rSmg<= _2;
                4'd3:  rSmg<= _3;
                4'd4:  rSmg<= _4;
                4'd5:  rSmg<= _5;
                4'd6:  rSmg<= _6;
                4'd7:  rSmg<= _7;
                4'd8:  rSmg<= _8;
                4'd9:  rSmg<= _9;
                4'd10: rSmg<= _a;
                4'd11: rSmg<= _b;
                4'd12: rSmg<= _c;
                4'd13: rSmg<= _d;
                4'd14: rSmg<= _e;
                4'd15: rSmg<= _f;
            
            endcase
    end
    
    assign smg_data = rSmg;

endmodule


