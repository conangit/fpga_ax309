`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:05:35 08/16/2018 
// Design Name: 
// Module Name:    comtrol_module 
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
module comtrol_module(
    sysclk,
    rst_n,
    iEn,
    iAddr,
    iData
    );
    
    input sysclk;
    input rst_n;
    output iEn;
    output [3:0]iAddr;
    output [3:0]iData;
    
    /*****************************************************/
    reg isEn;
    reg [3:0]rAddr;
    reg [3:0]rData;
    
    assign iEn = isEn;
    assign iAddr = rAddr;
    assign iData = rData;
    
    /*****************************************************/
    //控制每1s移位一次，便于观察
    parameter T1S = 26'd49_999_999;
    reg [25:0]count;
    
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
    
    /*****************************************************/
    reg [2:0]i;
    reg isCount;
     
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 3'd0;
            {rAddr, rData} <= 8'd0;
            isEn <= 1'b0;
            isCount <= 1'b0;
        end
        else begin
            case (i)
            
                0:
                    if (count == T1S) begin isCount <= 1'b0; isEn <= 1'b1; i <= i + 1'b1; end
                    else begin isCount <= 1'b1; isEn <= 1'b0; rAddr <= 4'd0; rData <= 4'h1; end

                1:
                    if (count == T1S) begin isCount <= 1'b0; isEn <= 1'b1; i <= i + 1'b1; end
                    else begin isCount <= 1'b1; isEn <= 1'b0; rAddr <= 4'd0; rData <= 4'h2; end

                2:
                    if (count == T1S) begin isCount <= 1'b0; isEn <= 1'b1; i <= i + 1'b1; end
                    else begin isCount <= 1'b1; isEn <= 1'b0; rAddr <= 4'd0; rData <= 4'h3; end
                    
                3:
                    if (count == T1S) begin isCount <= 1'b0; isEn <= 1'b1; i <= i + 1'b1; end
                    else begin isCount <= 1'b1; isEn <= 1'b0; rAddr <= 4'd0; rData <= 4'h4; end
                    
                4:
                    if (count == T1S) begin isCount <= 1'b0; isEn <= 1'b1; i <= i + 1'b1; end
                    else begin isCount <= 1'b1; isEn <= 1'b0; rAddr <= 4'd0; rData <= 4'h5; end
                    
                5:
                    if (count == T1S) begin isCount <= 1'b0; isEn <= 1'b1; i <= i + 1'b1; end
                    else begin isCount <= 1'b1; isEn <= 1'b0; rAddr <= 4'd0; rData <= 4'h6; end
                    
                6:
                    begin isEn <= 1'b0; i <= 3'd0; end
            
            endcase
        end
    end
    

endmodule
