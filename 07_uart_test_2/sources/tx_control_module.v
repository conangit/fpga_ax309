`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:51:15 08/13/2018 
// Design Name: 
// Module Name:    tx_module 
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
module tx_control_module(
    sysclk,
    rst_n,
    clk_bps,
    tx_en_sig,
    tx_data,
    tx_done_sig,
    tx_idle,
    tx
    );
    
    input sysclk;
    input rst_n;
    input clk_bps;
    input tx_en_sig;        //发送使能信号
    input [7:0]tx_data;     //要发送的数据
    output tx_done_sig;     //一帧数据发送完成
    output tx_idle;         //tx线路状态
    output tx;
    
    reg isDone;
    reg idle;
    reg rTx;
    reg [3:0]i;
    
    parameter paritymode = 1'b0; //偶校验
    reg presult;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            isDone <= 1'b0;
            idle <= 1'b0;
            rTx <= 1'b1; //rx线默认高电平
        end
        else if (tx_en_sig) begin
            case (i)
                
                0: //发送开始位
                    if (clk_bps) begin
                        idle <= 1'b1;
                        rTx <= 1'b0;
                        i <= i + 1'b1;
                    end
                
                1: //bit0
                    if (clk_bps) begin
                        rTx <= tx_data[0];
                        presult <= tx_data[0]^paritymode;
                        i <= i + 1'b1;
                    end
                    
                2,3,4,5,6,7,8: //bit1~bit7
                    if (clk_bps) begin
                        rTx <= tx_data[i-1];
                        presult <= presult^tx_data[i-1];
                        i <= i + 1'b1;
                    end
                
                9: //发送校验位
                    if (clk_bps) begin
                        rTx <= presult;
                        i <= i + 1'b1;
                    end
                    
                10: //发送停止位
                    if (clk_bps) begin
                        rTx <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                11: //一帧数据发送完成
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                12:
                    begin
                        isDone <= 1'b0;
                        idle <= 1'b0;
                        i <= 4'd0;
                    end
            
            endcase
        end
    end
    
    
    assign tx_done_sig = isDone;
    assign tx_idle = idle;
    assign tx = rTx;


endmodule

