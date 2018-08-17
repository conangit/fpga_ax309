`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:06:39 08/15/2018 
// Design Name: 
// Module Name:    rom_test 
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
module rom_test(
    input sysclk,
    input rst_n,
    output [7:0]rom_data
    );
    
    reg [4:0]rom_addr;
    
    always @(posedge sysclk or negedge rst_n) begin
        if (!rst_n)
            rom_addr <= 5'h00;
        else
            rom_addr <= rom_addr + 1'b1;
    end
    
    /*
    //在ip配置页面 选择了Single Port RAM 导致实验失败
    rom_ip your_instance_name (
        .clka(clka), // input clka
        .wea(wea), // input [0 : 0] wea
        .addra(addra), // input [4 : 0] addra
        .dina(dina), // input [7 : 0] dina
        .douta(douta) // output [7 : 0] douta
    );
    */
    
    rom_ip rom_ip_inst(
        .clka(sysclk),      // input clka
        .addra(rom_addr),   // input [4 : 0] addra
        .douta(rom_data)        // output [7 : 0] douta
    );
    
    wire [35:0]CONTROL0;
    wire [255:0]TRIG0;
    
    chipscope_icon icon_debug(
        .CONTROL0(CONTROL0)
    );
    
    chipscope_ila ila_debug(
        .CONTROL(CONTROL0),
        .CLK(sysclk),
        .TRIG0(TRIG0)
    );
    
    assign TRIG0[4:0] = rom_addr;
    assign TRIG0[12:5] = rom_data;

endmodule
