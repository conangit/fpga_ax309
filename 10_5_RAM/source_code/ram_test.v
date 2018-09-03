`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:13:45 09/03/2018 
// Design Name: 
// Module Name:    ram_test 
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
module ram_test(
    clk,
    rst_n,
    wea,
    addra,
    dina
    );
    
    input clk;
    input rst_n;
    output wea;
    output [4:0]addra;
    output [7:0]dina;
    
    /***********************************************/
    reg rEn;
    reg [4:0]rAddr;
    reg [7:0]rData;
    
    assign wea = rEn;
    assign addra = rAddr;
    assign dina = rData;
    
    /***********************************************/
    reg [9:0]cnt;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 10'd0;
        else
            cnt <= cnt+1'b1;
    end
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            rEn <= 1'b0;
            rAddr <= 5'd0;
            rData <= 8'd0;
        end
        else if((cnt > 10'd0) && (cnt < 10'd33)) begin
            rEn <= 1'b1;
            rAddr <= rAddr + 1'b1;
            rData <= rData + 1'b1;
        end
        else if((cnt > 10'd100) && (cnt < 10'd133)) begin
            rEn <= 1'b0;
            rAddr <= rAddr + 1'b1;
            rData <= 8'd0;
        end
        else begin
            rEn <= 1'b0;
            rAddr <= 5'd0;
            rData <= 8'd0;
        end
    end


endmodule
