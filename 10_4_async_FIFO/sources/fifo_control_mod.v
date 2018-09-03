`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:30:11 09/02/2018 
// Design Name: 
// Module Name:    fifo_test 
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
module fifo_control_mod(
    rst_n,
    wr_clk,
    rd_clk,
    wr_en,
    rd_en,
    wrdata,
    rd_ready
    );
    
    input rst_n;
    input wr_clk;
    input rd_clk;
    
    output wr_en;
    output [7:0]wrdata;
    output rd_en;
    output rd_ready;
    
    /****************************************/
    reg rWrEn;
    reg [7:0]rWrData;
    reg rRdEn;
    reg rReady;
    
    assign wr_en = rWrEn;
    assign wrdata = rWrData;
    assign rd_en = rRdEn;
    assign rd_ready = rReady;
    
    /****************************************/
    
    /*
    // 读写由不同时钟控制，且是异步发生的
    //FIFO写计数
    reg [9:0]wrcnt;
    
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n)
            wrcnt <= 10'd0;
        else
            wrcnt <= wrcnt + 1'b1;
    end
    
    //FIFO读计数
    reg [11:0]rdcnt;
    
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n)
            rdcnt <= 12'd0;
        else
            rdcnt <= rdcnt + 1'b1;
    end
    
    //FIFO写操作
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            rWrEn <= 1'b0;
            rWrData <= 8'd0;
        end
        else if ((10'd100 < wrcnt) && (wrcnt < 10'd133)) begin
            rWrEn <= 1'b1;
            rWrData <= rWrData + 1'b1;
        end
        else begin
            rWrEn <= 1'b0;
            rWrData <= 8'd0;
        end
    end

    //FIFO读操作
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rRdEn <= 1'b0;
        end
        else if ((12'd2200 < rdcnt) && (rdcnt < 12'd2218))
            rRdEn <= 1'b1;
        else
            rRdEn <= 1'b0;
    end
    */

    //改成同步操作
    reg [11:0]cnt;
    
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 12'd0;
        else
            cnt <= cnt + 1'b1;
    end
    
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rWrEn <= 1'b0;
            rRdEn <= 1'b0;
            rWrData <= 8'd0;
        end
        else if ((12'd200 < cnt) && (cnt < 12'd232)) begin //actually 31 write deep
            rWrEn <= 1'b1;
            rRdEn <= 1'b0;
            rWrData <= rWrData + 1'b1;
        end
        else if ((12'd1200 < cnt) && (cnt < 12'd1216)) begin //actually 15 read deep
            rWrEn <= 1'b0;
            rRdEn <= 1'b1;
            rWrData <= 8'd0;
        end
        else begin
            rWrEn <= 1'b0;
            rRdEn <= 1'b0;
            rWrData <= 8'd0;
        end
    end
    
    
    
    /****************************************/
    //FIFO读数据有效标志
    always @(posedge rd_clk or negedge rst_n) begin
        if(!rst_n)
            rReady <= 1'b0;
        else
            rReady <= rRdEn;
    end

endmodule



 

