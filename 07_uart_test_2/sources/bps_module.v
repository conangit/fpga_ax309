`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:32:36 08/13/2018 
// Design Name: 
// Module Name:    bps_module 
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
module bps_module(
    sysclk,
    rst_n,
    count_sig,
    clk_bps
    );
    
    input sysclk;
    input rst_n;
    input count_sig;
    output clk_bps;
    
    //115200波特率 => 每个bit占用时间为 1/115200s
    //50MHz sysclk计数为 50 * 10^6 * 1/115200 = 434
    //在每个bit的中间时间点采样数据 即[0 216] clk_bps为低; [217 433]为高
    
    reg [8:0]count;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n)
            count <= 9'd0;
        else if (count == 9'd433)
            count <= 9'd0;
        else if (count_sig)
            count <= count + 1'b1;
        else
            count <= 9'd0;
    end
    
    assign clk_bps = (count == 9'd216) ? 1'b1 : 1'b0;
    
endmodule
