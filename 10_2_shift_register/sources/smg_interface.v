`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:56:12 08/09/2018 
// Design Name: 
// Module Name:    smg_interface 
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
/*
 * number_sig 16进制 范围为24'd000_000~24'dfff_fff
 */

module smg_interface(
    CLK,
    RSTn,
    number_sig,
    smg_data,
    scan_sig
    );
    
    input CLK;
    input RSTn;
    input [23:0]number_sig;
    output [7:0]smg_data;
    output [5:0]scan_sig;
    
    /********************************************************/
    localparam T1MS = 16'd49_999;
    reg [15:0]count;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count <= 16'd0;
        else if (count == T1MS)
            count <= 16'd0;
        else if (isCount)
            count <= count + 1'b1;
        else
            count <= 16'd0;
    end
    
    /********************************************************/
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
    
    /********************************************************/
    reg [2:0]i, go;
    reg isCount;
    reg [3:0]rData;
    reg [7:0]rSmg;
    reg [5:0]rScan;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            i <= 3'd0;
            go <= 3'd0;
            isCount <= 1'b0;
            rData <= 4'd0;
            rSmg <= _z;
            rScan <= 6'b11_1111;
        end
        else
            case(i)
            
                0: //加载number_sig[3:0]
                    begin
                        rData <= number_sig[3:0];
                        i <= 3'd6;
                        go <= i + 1'b1;
                    end
                
                1: //加载number_sig[7:4]
                    begin
                        rData <= number_sig[7:4];
                        i <= 3'd6;
                        go <= i + 1'b1;
                    end
                    
                2: //加载number_sig[11:8]
                    begin
                        rData <= number_sig[11:8];
                        i <= 3'd6;
                        go <= i + 1'b1;
                    end
                    
                3: //加载number_sig[15:12]
                    begin
                        rData <= number_sig[15:12];
                        i <= 3'd6;
                        go <= i + 1'b1;
                    end
                    
                4: //加载number_sig[19:16]
                    begin
                        rData <= number_sig[19:16];
                        i <= 3'd6;
                        go <= i + 1'b1;
                    end
                    
                5: //加载number_sig[23:20]
                    begin
                        rData <= number_sig[23:20];
                        i <= 3'd6;
                        go <= 3'd0;
                    end
                    
                6: //smg编码
                    begin
                        case(rData)
                
                            4'd0:  rSmg <= _0;
                            4'd1:  rSmg <= _1;
                            4'd2:  rSmg <= _2;
                            4'd3:  rSmg <= _3;
                            4'd4:  rSmg <= _4;
                            4'd5:  rSmg <= _5;
                            4'd6:  rSmg <= _6;
                            4'd7:  rSmg <= _7;
                            4'd8:  rSmg <= _8;
                            4'd9:  rSmg <= _9;
                            4'd10: rSmg <= _a;
                            4'd11: rSmg <= _b;
                            4'd12: rSmg <= _c;
                            4'd13: rSmg <= _d;
                            4'd14: rSmg <= _e;
                            4'd15: rSmg <= _f;
                
                        endcase
                    
                        i <= i + 1'b1;
                    end
                
                7: //1ms smg显示
                    if (count == T1MS) begin
                        isCount <= 1'b0;
                        // rScan <= 6'b11_1111;
                        // rSmg <= _z;
                        i <= go;
                    end
                    else begin //每只数码管的点亮必需维持一段时间(亦即每只数码管必须维持一段熄灭时间)
                        isCount <= 1'b1;
                        //rScan[i] <= 1'b0;
                        //rScan <= 6'b00_0000;
                        //rScan <= 6'b11_1100;
                        // i在此态恒为6
                        // case (i)
                            // 0: rScan <= 6'b11_1110;
                            // 1: rScan <= 6'b11_1101;
                            // 2: rScan <= 6'b11_1011;
                            // 3: rScan <= 6'b11_0111;
                            // 4: rScan <= 6'b10_1111;
                            // 5: rScan <= 6'b01_1111;
                        // endcase
                        
                        case (go) //go由1~5~0 ”6ms周期内“ 每只数码管只有1ms点亮时间 其余5ms为熄灭态
                            1: rScan <= 6'b11_1110;
                            2: rScan <= 6'b11_1101;
                            3: rScan <= 6'b11_1011;
                            4: rScan <= 6'b11_0111;
                            5: rScan <= 6'b10_1111;
                            0: rScan <= 6'b01_1111;
                        endcase
                    end
                    
            endcase
    end

    assign smg_data = rSmg;
    assign scan_sig = rScan;

endmodule
