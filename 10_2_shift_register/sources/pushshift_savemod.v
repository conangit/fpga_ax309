`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:21:24 08/16/2018 
// Design Name: 
// Module Name:    pushshift_savemod 
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
module pushshift_savemod(
    sysclk,
    rst_n,
    iEn,
    iAddr,
    iData,
    oData
    );
    
    input sysclk;
    input rst_n;
    input iEn;
    input [3:0]iAddr;
    input [3:0]iData;
    output [23:0]oData;
    
    /********************************************************/
    reg [3:0]RAM [15:0]; //片上RAM的声明
    reg [23:0]D1; //寄存器D1声明
    
    // iEn每拉高一个时钟，D1的内容就向左移动一个深度(4bit)
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            D1 <= 24'd0;
            RAM[0] <= 4'd0; //解释:本实验有一个奇怪的现象，就是按下复位按键后 有时显示状态并没有回到000000
        end
        else if (iEn) begin
            RAM[iAddr] <= iData;
            D1[3:0] <= RAM[iAddr]; //复位之后 1s后iEn才有效 此时D1[3:0]存储得是复位前一刻得RAM[0]的值;
            D1[7:4] <= D1[3:0];
            D1[11:8] <= D1[7:4];
            D1[15:12] <= D1[11:8];
            D1[19:16] <= D1[15:12];
            D1[23:20] <= D1[19:16];
        end
    end

    assign oData = D1;

endmodule
