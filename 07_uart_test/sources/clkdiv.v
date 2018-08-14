`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:59:24 08/12/2018 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(
    sysclk,
    clkout
    );
    
    input sysclk;
    output clkout; //采样时钟输出
    
    reg clkout = 1'b0; //必须赋值一个初始值 输出寄存器化
    
    //波特率为9600bits/s 每个bit 16个采样时钟 则采样时钟频率f = 9600 * 16 = 153600Hz
    //故分频系数clkdiv = 50MHz / (9600 * 16) = ≈ 325.5 = 326
    
    //若波特率为115200 则clkdiv = 50MHz / (115200 * 16) = 27
    
    reg [8:0]count = 9'd0; //必须赋值一个初始值
    
    always @(posedge sysclk) begin
        if (count == 9'd162) begin
            clkout <= 1'b1;
            count <= count + 1'b1; //并不可少 否则电路将维持在count == 9'd162状态
        end
        else if (count == 9'd325) begin
            clkout <= 1'b0;
            count <= 9'd0;
        end
        else
            count <= count + 1'b1;
    end


endmodule
