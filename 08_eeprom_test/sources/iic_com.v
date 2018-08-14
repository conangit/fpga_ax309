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
    input [7:0]wrdata;
    output [7:0]rddata;
    output done_sig;
    
    output scl;
    inout sda;
    
    /*
     * 100kbits/s => 1 / 100_000 s/bit = 10 us/bit
     * 50MHz计时10us => n = 500
     */
    parameter F100K = 9'd200; //???? 200不是25oKbit的速率么?
    
    reg [4:0]i;
    reg [4:0]Go;
    reg [8:0]C1;
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
            i <= 5'd0;
            Go <= 5'd0;
            C1 <= 9'd0;
            rData <= 8'd0;
            rSCL <= 1'b1;
            rSDA <= 1'b1;
            isAck <= 1'b1; //默认NACK
            isDone <= 1'b0;
            isOut <= 1'b1;
        end
        else if (start_sig[0]) //i2c读数据
            case (i)
            
                0: //start
                    begin
                        isOut <= 1'b1; //SDA端口输出
                        
                        if (C1 == 0) rSCL <= 1'b1;
                        else if (C1 == 200) rSCL <= 1'b0; //SCL由高变低
                        
                        if (C1 == 0) rSDA <= 1'b1;
                        else if (C1 == 100) rSDA <= 1'b0; //SDA由高变低
                        
                        if (C1 == 250-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                1: //write device addr
                    begin
                        rData <= {4'b1010, 3'b000, 1'b0};
                        i <= 5'd7;
                        Go <= i + 1'b1; //Go = 1+1 = 2
                    end
                    
                2: //write word addr
                    begin
                        rData <= addr_sig;
                        i <= 5'd7;
                        Go <= i + 1'b1; //Go = 2+1 = 3
                    end
                    
                3: //write data
                    begin
                        rData <= wrdata;
                        i <= 5'd7;
                        Go <= i + 1'b1; //Go = 3+1 = 4
                    end
                    
                4: //stop
                    begin
                        isOut <= 1'b1;
                        
                        if (C1 == 0) rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1; //SCL由低变高
                        
                        if (C1 == 0) rSDA <= 1'b0;
                        else if (C1 == 150) rSDA <= 1'b1; //SDA由低变高
                        
                        if (C1 == 250-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                5: //i2c写结束
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                6:
                    begin
                        isDone <= 1'b0;
                        i <= 5'd0;
                    end
                
                7,8,9,10,11,12,13,14: //写device addr | word addr | write data
                    begin
                        isOut <= 1'b1;
                        rSDA <= rData[14-i]; //高位先发送 MSB
                        
                        if (C1 == 0) rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1;
                        else if (C1 == 150) rSCL <= 1'b0; // ____````````____
                        
                        if (C1 == F100K-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                15: // wait for ack
                    begin
                        isOut <= 1'b0; //SDA端改为输入
                        
                        if (C1 == 100) isAck <= sda;
                        
                        if (C1 == 0)  rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1;
                        else if (C1 == 150) rSCL <= 1'b0;
                        
                        if (C1 == F100K-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                16: //判断数据是否写入
                    if (isAck == 1'b0) //ack
                        i <= Go;
                    else //nack
                        i <= 5'd0;
            
            endcase
        //me
        
        else if (start_sig[1]) //i2c读数据
            case (i)
            
                0: //start
                    begin
                        isOut <= 1'b1;
                        
                        /*
                        错误写法：
                        
                        if (C1 == 200) rSCL <= 1'b0; //````````````_````
                        else rSCL <= 1'b1;
                        
                        if (C1 == 100) rSDA <= 1'b0; //````_````````````
                        else rSDA <= 1'b1;
                        
                        上面结果将是 SCL SDA分别在200,100时刻，产生一个单位的低电平脉冲信号
                             */
                        
                        if (C1 == 0) rSCL <= 1'b1;
                        else if (C1 == 200) rSCL <= 1'b0; //```````````````____
                        
                        if (C1 == 0) rSDA <= 1'b1;
                        else if (C1 == 100) rSDA <= 1'b0; //````````___________
                        
                        if (C1 == 250-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                1: //send device addr && direction: write
                    begin
                        rData <= {4'b1010, 3'b000, 1'b0};
                        i <= 5'd9;
                        Go <= i + 1'b1; //Go = 2;
                    end
                
                2: //write word addr
                    begin
                        rData <= addr_sig;
                        i <= 5'd9;
                        Go <= i + 1'b1; //Go = 3;
                    end
                
                3: //R-S
                //me error
                /*
                    begin
                        isOut <= 1'b1;
                        
                        if (C1 == 200) rSCL <= 1'b0;
                        else rSCL <= 1'b1;
                        
                        if (C1 == 100) rSDA <= 1'b0;
                        else rSDA <= 1'b1;
                        
                        if (C1 == 250-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    */
                    
                //alinx
                    /*
                    begin
                        isOut <= 1'b1;
                        
                        if (C1 == 0) rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1;
                        else if (C1 == 250) rSCL <= 1'b0;
                        
                        if (C1 == 0) rSDA <= 1'b0;
                        else if (C1 == 50) rSDA <= 1'b1;
                        else if (C1 == 150) rSDA <= 1'b0;
                        
                        if (C1 == 300-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                       */
                       
                // same time with S
                    begin
                        isOut <= 1'b1;
                        
                        if (C1 == 0) rSCL <= 1'b1;
                        else if (C1 == 200) rSCL <= 1'b0;
                        
                        if (C1 == 0) rSDA <= 1'b1;
                        else if (C1 == 100) rSDA <= 1'b0;
                        
                        if (C1 == 250-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                4: //send device addr && direction: read
                    begin
                        rData <= {4'b1010, 3'b000, 1'b1};
                        i <= 5'd9;
                        Go <= i + 1'b1; //Go = 5;
                    end
                
                5: //read dara
                    begin
                        rData <= 8'd0;
                        i <= 5'd19;
                        Go <= i + 1'b1; //Go = 6;
                    end
                    
                6: //stop
                    begin
                        isOut <= 1'b1;
                        
                        /* error
                        if (C1 == 50) rSCL <= 1'b1;
                        else rSCL <= 1'b0;
                        
                        if (C1 == 150) rSDA <= 1'b1;
                        else rSDA <= 1'b0;
                            */
                        
                        if (C1 == 0) rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1;
                        
                        if (C1 == 0) rSDA <= 1'b0;
                        else if (C1 == 150) rSDA <= 1'b1;
                        
                        if (C1 == 250-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                
                7: //done_sig
                    begin
                        isDone <= 1'b1;
                        i <= i + 1'b1;
                    end
                    
                8:
                    begin
                        isDone <= 1'b0;
                        i <= 5'd0;
                    end
                    
                9,10,11,12,13,14,15,16: //send device addr | word addr
                    begin
                        isOut <= 1'b1;
                        rSDA <= rData[16-i];
                        
                        if (C1 == 0) rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1;
                        else if (C1 == 150) rSCL <= 1'b0;
                        
                        if (C1 == F100K-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                17: //wait for ack
                    begin
                        isOut <= 1'b0;
                        
                        if (C1 == 100) isAck <= sda;
                        
                        if (C1 == 0) rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1; //____````(采样ack信号)````____
                        else if (C1 == 150) rSCL <= 1'b0;
                        
                        if (C1 == F100K-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                18: //判断ack
                    /*
                    if (Go == 5) //读的时候,发送完device addr(read),不用ack判断? 答案是需要。
                        i <= Go;
                    else if (isAck == 1'b0)
                        i <= Go;
                    else
                        i <= 5'd0;
                        */
                    
                    if (isAck == 1'b0)
                        i <= Go;
                    else
                        i <= 5'd0;
                        
                19,20,21,22,23,24,25,26: //read data
                    begin
                        isOut <= 1'b0; //SDA端口输入
                        
                        if (C1 == 100) rData[26-i] <= sda;
                        
                        if (C1 == 0) rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1;
                        else if (C1 == 150) rSCL <= 1'b0;
                        
                        if (C1 == F100K-1) begin C1 <= 9'd0; i <= i + 1'b1; end
                        else C1 <= C1 + 1'b1;
                    end
                    
                27: //Master send nack
                    begin
                        isOut <= 1'b1;
                        
                        rSDA <= 1'b1; //nack 是否需要？
                        
                        if (C1 == 0) rSCL <= 1'b0;
                        else if (C1 == 50) rSCL <= 1'b1;
                        else if (C1 == 150) rSCL <= 1'b0; //____````````____
                        
                        if (C1 == F100K-1) begin C1 <= 9'd0; i <= Go; end
                        else C1 <= C1 + 1'b1;
                    end
                
            endcase
        
        //ALINX
        /*
        else if (start_sig[1]) //i2c读数据
            case (i)
            
            endcase
          */
    end


endmodule

