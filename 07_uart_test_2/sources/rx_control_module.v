`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:42 08/13/2018 
// Design Name: 
// Module Name:    rx_module 
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
module rx_control_module(
    sysclk,
    rst_n,
    rx,
    clk_bps,
    rx_en_sig,
    count_sig,
    rx_data,
    rx_done_sig,
    dataerror,
    frameerror
    );
    
    input sysclk;
    input rst_n;
    input rx;
    input clk_bps;
    input rx_en_sig;
    output count_sig;
    output [7:0]rx_data;
    output rx_done_sig;
    output dataerror;
    output frameerror;
    
    //检测开始信号
    reg rx_buf;
    reg rx_start;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            rx_buf <= 1'b1;
            rx_start <= 1'b0;
        end
        else begin
            rx_buf <= rx;
            rx_start <= rx_buf & (!rx);
        end
    end
    
    
    reg [3:0]i;
    reg isCount;
    reg [7:0]rData;
    reg isDone;
    reg rDataerror;
    reg rFrameerror;
    
    parameter paritymode = 1'b0; //偶校验
    reg presult;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 4'd0;
            isCount <= 1'b0;
            rData <= 8'd0;
            isDone <= 1'b0;
            rDataerror <= 1'b0;
            rFrameerror <= 1'b0;
        end
        else if (rx_en_sig) begin
            case (i)
            
                0: //检测开始位
                    if (rx_start) begin
                        isCount <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                1: //忽略起始位占用的时间 | 复位上次数据发送错误
                    if (clk_bps) begin
                        i <= i + 1'b1;
                        rDataerror <= 1'b0;
                        rFrameerror <= 1'b0;
                    end
                    
                2: //bit0
                    if (clk_bps) begin
                        rData[0] <= rx;
                        presult <= rx^paritymode;
                        i <= i + 1'b1;
                    end
                    
                3,4,5,6,7,8,9: //bit1~bit7
                    if (clk_bps) begin
                        rData[i-2] <= rx;
                        presult <= presult^rx;
                        i <= i + 1'b1;
                    end
                    
                10: //校验位
                    if (clk_bps) begin
                        if (presult == rx)
                            rDataerror <= 1'b0;
                        else
                            rDataerror <= 1'b1;
                            
                        i <= i + 1'b1;
                    end
                    
                11: //停止位
                    if (clk_bps) begin
                        if (rx == 1'b1)
                            rFrameerror <= 1'b0;
                        else
                            rFrameerror <= 1'b1;
                            
                        i <= i + 1'b1;
                    end
                    
                12: //一帧数据接收完成
                    begin
                        isDone <= 1'b1;
                        isCount <= 1'b0;
                        i <= i + 1'b1;
                    end
                    
                 13:
                    begin
                        isDone <= 1'b0;
                        i <= 4'd0;
                    end
            
            endcase
        end
    end

    assign count_sig = isCount;
    assign rx_data = rData;
    assign rx_done_sig = isDone;
    assign dataerror = rDataerror;
    assign frameerror = rFrameerror;
    
endmodule












