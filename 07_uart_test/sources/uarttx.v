`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:18:48 08/12/2018 
// Design Name: 
// Module Name:    uarttx 
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
module uarttx(
    clk,
    datain,
    wrsig,
    idle,
    tx
    );

    input clk;
    input [7:0]datain;
    input wrsig; //发送命令，上升沿有效
    output idle; //线路状态指示，高为线路忙，低为线路空闲
    output tx;
    
    //输出寄存器化
    reg idle;
    reg tx;
    
    reg send;
    reg wrsigbuf;
    reg wrsigrise;
    reg presult;
    
    reg [7:0]cnt;
    
    parameter paritymode = 1'b0;
    
    // 检测一个上升沿
    always @(posedge clk) begin
        wrsigbuf <= wrsig;
        wrsigrise <= (!wrsigbuf) & wrsig;
    end
    
    
    always @(posedge clk) begin
        if (wrsigrise && (!idle)) //当发送命令有效且线路为空闲状态
            send <= 1'b1;
        else if (cnt == 8'd168) //一帧数据发送结束
            send <= 1'b0;
    end
    
    
    //               start  bit1                bit7    stop
    //为什么不采用cnt为8-24-40-56-72-88-104-120-136-152-168
    //因为这里是数据发送过程，而不是数据接收过程(接收-->数据采集)
    always @(posedge clk) begin
        if (send == 1'b1) begin
            case(cnt)
        
                0:
                    begin
                        tx <= 1'b0;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                    
                16:
                    begin
                        tx <= datain[0];
                        presult <= datain[0]^paritymode;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                32:
                    begin
                        tx <= datain[1];
                        presult <= datain[1]^presult;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                48:
                    begin
                        tx <= datain[2];
                        presult <= datain[2]^presult;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                64:
                    begin
                        tx <= datain[3];
                        presult <= datain[3]^presult;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                80:
                    begin
                        tx <= datain[4];
                        presult <= datain[4]^presult;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                96:
                    begin
                        tx <= datain[5];
                        presult <= datain[5]^presult;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                112:
                    begin
                        tx <= datain[6];
                        presult <= datain[6]^presult;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                128:
                    begin
                        tx <= datain[7];
                        presult <= datain[7]^presult;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                144:
                    begin
                        tx <= presult; //发送奇偶校验位
                        presult <= datain[0]^paritymode;
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                160:
                    begin
                        tx <= 1'b1; //发送停止位
                        idle <= 1'b1;
                        cnt <= cnt + 1'b1;
                    end
                
                168:
                    begin
                        tx <= 1'b1;
                        idle <= 1'b0; //一帧数据发送结束
                        cnt <= cnt + 1'b1;
                    end
                    
                default:
                    cnt <= cnt + 1'b1;
                    
            endcase
        end
        else begin //空闲态
            tx <= 1'b1;
            cnt <= 8'd0;
            idle <= 1'b0;
        end
    end
    
    

endmodule
