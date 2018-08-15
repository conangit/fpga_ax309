`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:56:13 08/09/2018 
// Design Name: 
// Module Name:    smg_control_module 
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
module smg_control_module(
    CLK,
    RSTn,
    number_sig,
    number_data
    );
    
    input CLK;
    input RSTn;
    input [23:0]number_sig;
    output [3:0]number_data;
    
    
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
    reg [3:0]rData;
    
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            i <= 3'd0;
            rData <= 4'd0;
        end
        else
            case(i)
                
                0:
                    if (count == T1MS)
                        i <= i + 1'b1;
                    else
                        rData <= number_sig[23:20];
                
                1:
                    if (count == T1MS)
                        i <= i + 1'b1;
                    else
                        rData <= number_sig[19:16];
                
                2:
                    if (count == T1MS)
                        i <= i + 1'b1;
                    else
                        rData <= number_sig[15:12];
                
                3:
                    if (count == T1MS)
                        i <= i + 1'b1;
                    else
                        rData <= number_sig[11:8];
                
                
                4:
                    if (count == T1MS)
                        i <= i + 1'b1;
                    else
                        rData <= number_sig[7:4];
                
                5:
                    if (count == T1MS)
                        i <= 3'd0;
                    else
                        rData <= number_sig[3:0];
                
            endcase
    end

    assign number_data = rData;

endmodule
