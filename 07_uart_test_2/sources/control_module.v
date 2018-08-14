`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:18:53 08/13/2018 
// Design Name: 
// Module Name:    control_module 
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
module control_module(
    sysclk,
    rst_n,
    rx_done_sig,
    tx_done_sig,
    rx_en_sig,
    tx_en_sig,
    rx_data,
    tx_data
    );
    
    input sysclk;
    input rst_n;
    
    input rx_done_sig;
    input tx_done_sig;
    
    output rx_en_sig;
    output tx_en_sig;
    
    input [7:0]rx_data;
    output [7:0]tx_data;
    
    reg rEn;
    reg tEn;
    reg [7:0]rData;
    
    reg [1:0]i;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 2'd0;
            rEn <= 1'b0;
            tEn <= 1'b0;
            rData <= 8'd0;
        end
        else
            case (i)
                0: //等待PC发送数据
                    if (rx_done_sig) begin
                        rEn <= 1'b0;
                        i <= 2'd1;
                    end
                    else
                        rEn <= 1'b1;
                        
                1: //锁存接收的数据到发送的数据上
                    begin
                        rData <= rx_data;
                        i <= 2'd2;
                    end
                        
                2: //将接收的数据发送到PC 实现loopback
                    if (tx_done_sig) begin
                        tEn <= 1'b0;
                        i <= 2'd0;
                    end
                    else
                        tEn <= 1'b1;
                        
            endcase
    end

    assign rx_en_sig = rEn;
    assign tx_en_sig = tEn;
    assign tx_data = rData;
    
endmodule
