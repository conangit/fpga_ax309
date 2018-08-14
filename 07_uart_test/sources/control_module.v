`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:37:19 08/13/2018 
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
module control_module(
    clk,
    rdsig,
    rxdata,
    wrsig,
    txdata
    );
    
    input clk;              //uart采样时钟
    input rdsig;            //接收完成标志
    input [7:0]rxdata;      //接收的数据
    output wrsig;           //发送请求
    output [7:0]txdata;     //要发送的数据
    
    
    reg [17:0]uart_wait;
    reg [15:0]uart_cnt;
    reg rx_data_valid;
    reg [7:0] store[19:0];
    reg [2:0]uart_stat;
    reg [8:0]k;
    reg [7:0]dataout_reg;
    reg data_sel;
    reg wrsig_reg;
    
    assign txdata = data_sel ? dataout_reg : rxdata;
    assign wrsig = data_sel ? wrsig_reg : rdsig;
    
    //存储要发送的数据
    always @(*) begin
        store[0] <= 72;  //H
        store[1] <= 101; //e
        store[2] <= 108; //l
        store[3] <= 108; //l
        store[4] <= 111; //o
        store[5] <= 32;  // 
        store[6] <= 65;  //A
        store[7] <= 76;  //L
        store[8] <= 73;  //I
        store[9] <= 78;  //N
        store[10] <= 88; //X
        store[11] <= 32; // 
        store[12] <= 65; //A
        store[13] <= 88; //X
        store[14] <= 51; //3
        store[15] <= 48; //0
        store[16] <= 57; //9
        store[17] <= 32; // 
        store[18] <= 10; //\r
        store[19] <= 13; //\n
    end
    
    //发送字符串
    always @(posedge clk) begin
        if (rdsig == 1'b1) begin
            uart_cnt <= 16'd0;
            uart_stat <= 3'b000;
            data_sel <= 1'b0;
            k <= 9'd0;
        end
        else begin
            case(uart_stat)
            
                3'b000:
                    if (rx_data_valid == 1'b1) begin
                        uart_stat <= 3'b001;
                        data_sel <= 1'b1;
                    end
                        
                3'b001:
                    if (k == 18) begin
                        if (uart_cnt == 0) begin
                            dataout_reg <= store[18];
                            uart_cnt <= uart_cnt + 1'b1;
                            wrsig_reg <= 1'b1;
                        end
                        else if (uart_cnt == 254) begin
                            uart_cnt <= 16'd0;
                            wrsig_reg <= 1'b0;
                            k <= 9'd0;
                            uart_stat <= 3'b010;
                        end
                        else begin
                            uart_cnt <= uart_cnt + 1'b1;
                            wrsig_reg <= 1'b0;
                        end
                    end
                    else begin
                        if (uart_cnt == 0) begin
                            dataout_reg <= store[k];
                            uart_cnt <= uart_cnt + 1'b1;
                            wrsig_reg <= 1'b1;
                        end
                        else if (uart_cnt == 254)begin
                            uart_cnt <= 16'd0;
                            wrsig_reg <= 1'b0;
                            k <= k + 1'b1;
                        end
                        else begin
                            uart_cnt <= uart_cnt + 1'b1;
                            wrsig_reg <= 1'b0;
                        end
                    end
                    
                3'b010: //发送完成
                    begin
                        uart_stat <= 3'b000;
                        data_sel <= 1'b0;
                    end
                
                default:
                    uart_stat <= 3'b000;
            
            endcase
        end
    end
    
    //串口发送控制
    always @(negedge clk) begin
        if (rdsig == 1'b1) begin
            uart_wait <= 0;
            rx_data_valid <= 1'b0;
        end
        else if (uart_wait == 18'h3f_ff) begin
            uart_wait <= 0;
            rx_data_valid <= 1'b1;
        end
        else begin
            uart_wait <= uart_wait + 1'b1;
            rx_data_valid <= 1'b0;
        end
    end


endmodule
