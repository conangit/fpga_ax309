`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:54:22 08/10/2018 
// Design Name: 
// Module Name:    led_test 
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
module led_test(
    clk,
    rst_n,
    leds
    );
    
    input clk;
    input rst_n;
    output [3:0]leds;

    //寄存器定义
    reg [31:0]timer;
    reg [3:0]rLed;
    
    //计数器计数：循环0~4秒
    always @(posedge clk or negedge rst_n) begin //检测时钟的上升沿和复位的下降沿
        if (!rst_n)
            timer <= 32'd0;
        else if (timer == 32'd199_999_999) //4秒计数
            timer <= 32'd0;
        else
            timer <= timer + 1'b1;
            
    end
    
    
    //LED灯控制
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            rLed <= 4'b1111; //led全亮
        else if (timer == 32'd49_999_999) //计数器计到1秒
            rLed <= 4'b1110; //led1熄灭
        else if (timer == 32'd99_999_999) //计数器计到2秒
            rLed <= 4'b1101; // led2熄灭
        else if (timer == 32'd149_999_999) //计数器计到3秒
            rLed <= 4'b1011; // led3熄灭
        else if (timer == 32'd199_999_999) //计数器计到4秒
            rLed <= 4'b0111; // led4熄灭
    end
    
    assign leds = rLed;
    

endmodule


