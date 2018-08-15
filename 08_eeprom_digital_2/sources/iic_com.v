`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:22:54 08/14/2018 
// Design Name: 
// Module Name:    iic_com 
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
module iic_com(
    sysclk,
    rst_n,
    start_sig,
    addr_sig,
    wrdata,
    rddata,
    done_sig,
    scl,
    sda
    );
    
    input sysclk;
    input rst_n;
    
    input [1:0]start_sig;   //read or write command
    input [7:0]addr_sig;    //eeprom words addr
    input [7:0]wrdata;      //eeprom write data
    output [7:0]rddata;     //eeprom read data
    output done_sig;
    
    output scl;
    inout sda;
    
    /*******************************************************************/
    /*
     * 100kbits/s => 1 / 100_000 s/bit = 10 us/bit
     * 50MHz计时10us => n = 500
     */
    parameter T5US = 8'd249;
    
    reg [7:0]count;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n)
            count <= 8'd0;
        else if (count == T5US)
            count <= 8'd0;
        else if (start_sig[0] || start_sig[1])
            count <= count + 1'b1;
        else
            count <= 8'd0;
    end
    
    /*******************************************************************/
    
    reg [5:0]i;
    reg [5:0]go;
    reg [7:0]rData;
    reg rSCL;
    reg rSDA;
    reg isAck;
    reg isDone;
    reg isOut;
    
    assign done_sig = isDone;
    assign rddata = rData;
    assign scl = rSCL;
    assign sda = isOut ? rSDA : 1'bz;
    
    //i2c读写处理程序
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 6'd0;
            go <= 6'd0;
            rData <= 8'd0;
            rSCL <= 1'b1;
            rSDA <= 1'b1;
            isAck <= 1'b1; //默认NACK
            isDone <= 1'b0;
            isOut <= 1'b1;
        end
        else if (start_sig[0]) //i2c数据写
            case (i)
            
                0: //S信号 上半时钟周期
                    begin
                        isOut <= 1'b1;
                    
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL<= 1'b1; rSDA<= 1'b1; end
                    end
                    
                1: //S信号 下半时钟周期
                    begin
                        isOut <= 1'b1;
                    
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end // rSCL <= 1'b0; 才是一个时钟周期的完整描述
                        else begin rSCL <= 1'b1; rSDA <= 1'b0; end //SCL整个周期为高电平 SDA产生一个下降沿
                    end
                        
                2: //send device addr(Write)
                    begin
                        rData <= {4'b1010, 3'b000, 1'b0};
                        i <= 6'd9;
                        go <= i + 1'b1; //go=3
                    end
                    
                3: //send eeprom word addr
                    begin
                        rData <= addr_sig;
                        i <= 6'd9;
                        go <= i + 1'b1; //go=4
                    end
                
                4: //send eeprom write data
                    begin
                        rData <= wrdata;
                        i <= 6'd9;
                        go <= i + 1'b1; //go=5
                    end
                
                5: //P信号 上半时钟周期
                    begin
                        isOut <= 1'b1;
                        
                        //为什么不行
                        // if (count == T5US) i <= i + 1'b1;
                        // else begin rSCL<= 1'b1; rSDA<= 1'b0; end
                        
                        //OK
                        if (count == 0) rSCL<= 1'b0;
                        else if (count == 124) rSCL<= 1'b1;
                        else if (count == T5US) i <= i + 1'b1;
                        
                        rSDA<= 1'b0;
                        
                    end
                
                6: //P信号 下半时钟周期
                    begin
                        isOut <= 1'b1;
                    
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL<= 1'b1; rSDA<= 1'b1; end //整个周期内SCL=1 SDA产生一个上升沿 --> 出错！！！！ SCL为什么必须有一个上升沿的跳变？
                    end
                
                7: //done_sig脉冲
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                
                8: //收尾
                    begin
                        isDone <= 1'b0;
                        i <= 6'd0;
                    end
                
                9,11,13,15,17,19,21,23: //写数据的上半周期 -- 设置数据
                    begin
                        isOut <= 1'b1;
                        
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL <= 1'b0; rSDA <= rData[7 - ((i-9)>>1)]; end //MSB 9--7 11--6 13--5 15--4 17--3 19--2 21--1 23--0 
                    end
                
                10,12,14,16,18,20,22,24: //写数据的下半周期 -- 锁存数据
                    begin
                        isOut <= 1'b1;
                        
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL <= 1'b1; end
                    end
                        
                25: //wait for ack 上半周期
                    begin
                        isOut <= 1'b0;
                        
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL <= 1'b0; end
                    end
                
                26: //wait for ack 下半周期
                    begin
                        isOut <= 1'b0;
                        
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL <= 1'b1; end
                        
                        if (count == 8'd124) isAck <= sda;
                    end
                
                27: //ack判断
                    if (isAck == 1'b0) i <= go;
                    else i <= 6'd0;
            
            endcase
        else if (start_sig[1]) //i2c数据读
            case (i)
            
                0: //S信号 上半时钟周期
                    begin
                        isOut <= 1'b1;
                    
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL<= 1'b1; rSDA<= 1'b1; end
                    end
                    
                1: //S信号 下半时钟周期
                    begin
                        isOut <= 1'b1;
                    
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL <= 1'b1; rSDA <= 1'b0; end //SCL整个周期为高电平 SDA产生一个下降沿
                    end
                    
                2: //send device addr(Write)
                    begin
                        rData <= {4'b1010, 3'b000, 1'b0};
                        i <= 6'd12;
                        go <= i + 1'b1; //go=3
                    end
                    
                3: //send eeprom word addr
                    begin
                        rData <= addr_sig;
                        i <= 6'd12;
                        go <= i + 1'b1; //go=4
                    end
                    
                4: //R-S信号 上半时钟周期
                    begin
                        isOut <= 1'b1;
                    
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL<= 1'b1; rSDA<= 1'b1; end
                    end
                    
                5: //R-S信号 下半时钟周期
                    begin
                        isOut <= 1'b1;
                    
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL <= 1'b1; rSDA <= 1'b0; end //SCL整个周期为高电平 SDA产生一个下降沿
                    end
                    
                6: //send device addr(Read)
                    begin
                        rData <= {4'b1010, 3'b000, 1'b1};
                        i <= 6'd12;
                        go <= i + 1'b1; //go=7
                    end
                    
                7: //read eeprom data
                    begin
                        rData <= 8'd0;
                        i <= 6'd31;
                        go <= i + 1'b1; //go=8
                    end
                
                8: //P信号 上半时钟周期
                    begin
                        isOut <= 1'b1;
                        
                        //为什么这里又可以了？
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL<= 1'b1; rSDA<= 1'b0; end
                    end
                
                9: //P信号 下半时钟周期
                    begin
                        isOut <= 1'b1;
                    
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL<= 1'b1; rSDA<= 1'b1; end //整个周期内SCL=1 SDA产生一个上升沿
                    end
                    
                10: //done_sig脉冲
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                
                11: //收尾
                    begin
                        isDone <= 1'b0;
                        i <= 6'd0;
                    end
                    
                12,14,16,18,20,22,24,26: //写数据的上半周期 -- 设置数据
                    begin
                        isOut <= 1'b1;
                        
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL <= 1'b0; rSDA <= rData[7 - ((i-12)>>1)]; end //MSB 12--7 14--6 16--5 18--4 20--3 22--2 24--1 26--0 
                    end
                    
                13,15,17,19,21,23,25,27: //写数据的下半周期 -- 锁存数据
                    begin
                        isOut <= 1'b1;
                        
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL <= 1'b1; end
                    end
                    
                
                28: //wait for ack 上半周期
                    begin
                        isOut <= 1'b0;
                        
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL <= 1'b0; end
                    end
                
                29: //wait for ack 下半周期
                    begin
                        isOut <= 1'b0;
                        
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL <= 1'b1; end
                        
                        if (count == 8'd124) isAck <= sda;
                    end
                    
                30: //ack判断
                    if (isAck == 1'b0) i <= go;
                    else i <= 5'd0;
                    
                31,33,35,37,39,41,43,45: //读数据的上半周期
                    begin
                        isOut <= 1'b0;
                        
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL <= 1'b0; end
                    end
                    
                32,34,36,38,40,42,44,46:
                    begin
                        isOut <= 1'b0;
                        
                        if (count == T5US) begin i <= i + 1'b1; rSCL <= 1'b0; end
                        else begin rSCL <= 1'b1; end
                        
                        if (count == 8'd124) rData[7 - ((i-32)>>1)] <= sda; //32--7 34--6 ... 46--0
                    end
                    
                47: //master send nack上半周期
                    begin
                        isOut <= 1'b0;
                        
                        if (count == T5US) i <= i + 1'b1;
                        else begin rSCL <= 1'b1; rSDA <= 1'b1; end
                    end
                    
                48: //master send nack上半周期
                    begin
                        isOut <= 1'b0;
                        
                        if (count == T5US) begin i <= go; rSCL <= 1'b0; end
                        else begin rSCL <= 1'b1; rSDA <= 1'b1; end
                    end
                
            endcase
    end


endmodule

