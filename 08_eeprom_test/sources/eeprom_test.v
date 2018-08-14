`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:04 08/14/2018 
// Design Name: 
// Module Name:    eeprom_test 
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
module eeprom_test(
    input sysclk,
    input rst_n,
    output scl,
    inout sda,
    output [3:0]led //指示读出的数据的低4位
    );
    
    reg [3:0]rLED; 
    
    assign led = rLED;
    
    //eeprom读写
    reg [1:0]isStart;
    reg [7:0]rAddr;
    reg [7:0]rData;
    
    wire [7:0]RdData;
    wire done_sig;
    
    iic_com u1(
        .sysclk(sysclk),
        .rst_n(rst_n),
        .start_sig(isStart),
        .addr_sig(rAddr),
        .wrdata(rData),
        .rddata(RdData),
        .done_sig(done_sig),
        .scl(scl),
        .sda(sda)
    );
    
    reg [1:0]i;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 2'd0;
            isStart <= 2'b00;
            rAddr <= 8'h00;
            rData <= 8'h00;
            rLED <= 4'b0000;
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
                    rLED <= RdData[3:0];
            
            endcase
    end

    wire [35:0]CONTROL0;
    
    chipscope_icon icon_debug(
        .CONTROL0(CONTROL0)
    );
    
    wire [255:0]TRIG0;
    
    chipscope_ila ila_debug(
        .CONTROL(CONTROL0),
        .CLK(sysclk),
        .TRIG0(TRIG0)
    );
    
    assign TRIG0[7:0] = RdData;
    
endmodule
