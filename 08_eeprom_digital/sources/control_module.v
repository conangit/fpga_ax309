`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:26:36 08/14/2018 
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
    sysclk,
    rst_n,
    rddata,
    done_sig,
    start_sig,
    addr_sig,
    wrdata,
    number_sig
    );
    
    /****************************/
    input sysclk;
    input rst_n;
    
    //i2c-eeprom
    input [7:0]rddata;
    input done_sig;
    
    output [1:0]start_sig;
    output [7:0]addr_sig;
    output [7:0]wrdata;
    
    //digital
    output [23:0]number_sig;
    /****************************/
    
    //eeprom读写
    reg [1:0]isStart;
    reg [7:0]rAddr;
    reg [7:0]rData;
    //数码管显示
    reg [23:0]rNum;
    
    assign start_sig = isStart;
    assign addr_sig = rAddr;
    assign wrdata = rData;
    assign number_sig = rNum;
    
    /****************************/
    
    //1s延时
    parameter T1S = 26'd49_999_999;
    
    reg[25:0]count;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n)
            count <= 26'd0;
        else if (count == T1S)
            count <= 26'd0;
        else if (isCount)
            count <= count + 1'b1;
        else
            count <= 26'd0;
    end
    
    /****************************/
    
    reg [2:0]i;
    reg isCount;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 3'd0;
            isStart <= 2'b00;
            rAddr <= 8'h00;
            rData <= 8'h00;
            rNum <= 24'h0000_00;
            isCount <= 1'b0;
        end
        else
            case (i)
                0:
                    if (done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else begin
                        isStart <= 2'b01;
                        rAddr <= 8'h00;
                        rData <= 8'hf5;
                    end
                    
                1:
                    if (done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else begin
                        isStart <= 2'b10;
                        rAddr <= 8'h00;
                    end
                    
                2:
                    if (count == T1S) begin
                        isCount <= 1'b1;
                        i <= i + 1'b1;
                    end
                    else begin
                        isCount <= 1'b1;
                        rNum <= {16'h0000, rddata[7:4], rddata[3:0]};
                    end
                    
                3:
                    if (done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else begin
                        isStart <= 2'b01;
                        rAddr <= 8'h10;
                        rData <= 8'h47;
                    end
                    
                4:
                    if (done_sig) begin
                        isStart <= 2'b00;
                        i <= i + 1'b1;
                    end
                    else begin
                        isStart <= 2'b10;
                        rAddr <= 8'h10;
                    end
                    
                5:
                    if (count == T1S) begin
                        isCount <= 1'b1;
                        i <= 3'd0;
                    end
                    else begin
                        isCount <= 1'b1;
                        rNum <= {16'h0000, rddata[7:4], rddata[3:0]};
                    end
            
            endcase
    end

endmodule
