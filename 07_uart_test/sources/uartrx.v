`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:22:43 08/12/2018 
// Design Name: 
// Module Name:    uartrx 
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
module uartrx(
    clk,
    rx,
    dataout,
    rdsig,
    dataerror,
    framerror
    );
    
    input clk; //采样时钟
    input rx;
    output dataout; //接收数据输出
    output rdsig; //接收完成高电平脉冲 //receive_done
    output dataerror; //数据出错指示
    output framerror; //帧出错指示
    
    reg[7:0]dataout;
    reg rdsig;
    reg dataerror;
    reg framerror;
    
    
    reg [7:0]cnt;
    reg rxbuf, rxfall, receive;
    reg presult;
    reg idle;
    
    parameter paritymode = 1'b0;

    //检测tx线路下降沿
    always @(posedge clk) begin
        rxbuf <= rx;
        rxfall <= rxbuf & (!rx);
    end
    
    
    always @(posedge clk) begin
        if (rxfall && (!idle)) //检测到线路的下降沿，并且电路状态为空闲
            receive <= 1'b1;
        else if (cnt == 8'd168) //接收数据完成
            receive <= 1'b0;
    end
    
    always @(posedge clk) begin
        if (receive == 1'b1) begin
            case(cnt)
            
                8: //忽略停止位
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                    end
                    
                24: //bit-0
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        dataout[0] <= rx;
                        presult <= rx^paritymode;
                    end
                    
                40:
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        dataout[1] <= rx;
                        presult <= presult^rx;
                    end
                    
                56:
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        dataout[2] <= rx;
                        presult <= presult^rx;
                    end
                
                72:
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        dataout[3] <= rx;
                        presult <= presult^rx;
                    end
                    
                88:
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        dataout[4] <= rx;
                        presult <= presult^rx;
                    end
                    
                104:
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        dataout[5] <= rx;
                        presult <= presult^rx;
                    end
                    
                120:
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        dataout[6] <= rx;
                        presult <= presult^rx;
                    end
                    
                136:
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        dataout[7] <= rx;
                        presult <= presult^rx;
                    end
                    
                152: //接收奇偶校验位
                    begin
                        idle <= 1'b1;
                        rdsig <= 1'b0;
                        cnt <= cnt + 1'b1;
                        if (presult == rx)
                            dataerror <= 1'b0;
                        else
                            dataerror <= 1'b1;
                    end
                    
                168:
                    begin
                        idle <= 1'b1;
                        if (rx == 1'b1)
                            framerror <= 1'b0;
                        else
                            framerror <= 1'b1;
                        cnt <= cnt + 1'b1;
                        rdsig <= 1'b1;
                    end
                    
                default:
                    cnt <= cnt + 1'b1;
            
            endcase
        end
        else begin
            cnt <= 8'd0;
            idle <= 1'b0;
            rdsig <= 1'b0;
        end
    end
    
    
endmodule
