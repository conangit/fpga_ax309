`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:46:52 08/17/2018 
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
// fifo_ip fifo_ip_inst(
//    .clk(sysclk),   // input clk
//    .rst(!rst_n),   // input rst
//    .din(din),      // input [7 : 0] din
//    .wr_en(wr_en),  // input wr_en
//    .rd_en(rd_en),  // input rd_en
//    .dout(dout),    // output [7 : 0] dout
//    .full(full),    // output full
//    .empty(empty)   // output empty
// );
module control_module(
    sysclk,
    rst_n,
    din,
    wr_en,
    rd_en,
    rd_ready
    );
    
    input sysclk;
    input rst_n;
    
    output [7:0]din;    //FIFO写入数据
    output wr_en;       //FIFO写使能信号
    output rd_en;       //FIFO读使能信号
    
    output rd_ready;    //FIFO读数据有效标志
    
    /******************************************************************/
    reg [7:0]rWdata;
    reg wEn;
    reg rEn;
    reg ready;
    
    assign din = rWdata;
    assign wr_en = wEn;
    assign rd_en = rEn;
    assign rd_ready = ready;
    
    /******************************************************************/
    reg [9:0]cnt;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 10'd0;
        else
            cnt <= cnt + 1'b1;
    end
    
    /******************************************************************/
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            wEn <= 1'b0;
            rEn <= 1'b0;
            rWdata <= 8'd0;
        end
        else if((10'd0 < cnt) && (cnt < 10'd33)) begin //连续32个FIFO数据写入
            wEn <= 1'b1;
            rEn <= 1'b0;
            rWdata <= cnt; //8'h01 ~ 8'h20
        end
        else if ((10'd100 < cnt) && (cnt < 10'd133)) begin //连续32个FIFO数据读出
            wEn <= 1'b0;
            rEn <= 1'b1;
            rWdata <= 8'd0;
        end
        else begin
            wEn <= 1'b0;
            rEn <= 1'b0;
            rWdata <= 8'd0;
        end
    end
    
    /******************************************************************/
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n)
            ready <= 1'b0;
        else
            ready <= rEn;
    end


endmodule
