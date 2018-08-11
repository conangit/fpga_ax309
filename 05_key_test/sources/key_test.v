`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:24:05 08/11/2018 
// Design Name: 
// Module Name:    key_test 
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
module key_test(
    clk,
    rst_n,
    key_in,
    led_out
    );
    
    input clk;
    input rst_n;
    input [3:0]key_in;
    output [3:0]led_out;
    
    reg [19:0]count;
    reg [3:0]key_scan;
    
    /*********************************************************************************
     *采样按键值：20ms扫描一次，采样频率小于按键毛刺频率，相当于过滤掉了高频毛刺信号
     ********************************************************************************/
     
     always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 20'd0;
        else begin
            if (count == 20'd999_999) begin//20ms计数
                key_scan <= key_in;
                count <= 20'd0;
            end
            else
                count <= count + 1'b1;
        end
     end
     
     //按键信号锁存一个时钟节拍
     reg [3:0] key_scan_r;
     
     always @(posedge clk)
        key_scan_r <= key_scan;
        
    //当检测按键有下降沿变化时。代表该按键被按下，按键有效
    wire [3:0]key_flag = key_scan_r[3:0] & (~key_scan[3:0]);
    
    reg [3:0]rLED;
    
    //LED灯控制
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rLED <= 4'b0000; //LED全灭
        else begin
            if(key_flag[0]) rLED[0] <= ~rLED[0];
            if(key_flag[1]) rLED[1] <= ~rLED[1];
            if(key_flag[2]) rLED[2] <= ~rLED[2];
            if(key_flag[3]) rLED[3] <= ~rLED[3];
        end
    end
    
    assign led_out = rLED;

endmodule

