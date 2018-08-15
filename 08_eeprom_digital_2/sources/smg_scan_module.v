`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:44:50 08/09/2018 
// Design Name: 
// Module Name:    smg_scan_module 
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
module smg_scan_module(
    CLK,
    RSTn,
    scan_sig
    );
    
    input CLK;
    input RSTn;
    output [5:0]scan_sig;
    
    
    localparam T1MS = 16'd49_999;
    
    reg [15:0]count;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn)
            count <= 16'd0;
        else if (count == T1MS)
            count <= 16'd0;
        else
            count <= count + 1'b1;
    end
    
    
    
    reg [2:0]i;
    reg [5:0]rScan;
    
    
    // 对应AX309 从左往右扫描 先高位再低位
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            i <= 3'd0;
            rScan <= 6'b11_1111;
        end
        else
            case(i)
                
                0:
                    if(count == T1MS)
                        i <= i + 1'b1;
                    else
                        rScan <= 6'b01_1111;
                
                1:
                    if(count == T1MS)
                        i <= i + 1'b1;
                    else
                        rScan <= 6'b10_1111;
                
                2:
                    if(count == T1MS)
                        i <= i + 1'b1;
                    else
                        rScan <= 6'b11_0111;
                
                3:
                    if(count == T1MS)
                        i <= i + 1'b1;
                    else
                        rScan <= 6'b11_1011;
            
                4:
                    if(count == T1MS)
                        i <= i + 1'b1;
                    else
                        rScan <= 6'b11_1101;
            
                5:
                    if(count == T1MS)
                        i <= 3'd0;
                    else
                        rScan <= 6'b11_1110;
                        
            endcase
    end
    
    assign scan_sig = rScan;

endmodule
