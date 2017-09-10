`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2017 01:33:34 AM
// Design Name: 
// Module Name: memIO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memIO #(
    parameter initmem = "mem_data.mem",
    parameter initscreen = "screen_data.mem",
    parameter dmem_size = 1024,
    parameter screenxsize = 40,
    parameter screenysize = 30
    )
    (
    input wire clock,
    input wire wr,
    input wire [31:0] addr,
    input wire [31:0] datain,
    output wire [31:0] dataout,
    
    input wire [10:0] screenaddr,
    output wire [3:0] screenout,
    
    input wire [31:0] keyboardin,
    input wire [8:0] accelX, accelY, accelZ,
    input wire [11:0] accelTmp,
    
    output logic [15:0] leds = 0,
    output logic [31:0] period = 0
    );
    
    wire dmem_wr, smem_wr, wrout;
    wire[31:0] datamemout, screenmemout, accel;
    
    assign dmem_wr = (addr[17:16] == 'b01) ? wr : 0;
    assign smem_wr = (addr[17:16] == 'b10) ? wr : 0;
    assign wrout = (addr[17:16] == 'b11) ? wr : 0;
    
    always_ff @(posedge clock) begin
        if (wrout == 1) begin
            if (addr[4:2] == 'b101) period <= datain;
            if (addr[4:2] == 'b110) leds <= datain;
        end
    end

    dmem #(dmem_size, 32, initmem) data(clock, dmem_wr, addr, datain, datamemout);
    screenmem #(screenxsize, screenysize, 32, initscreen) screen(clock, smem_wr, addr, screenaddr, datain, screenout, screenmemout);
    
    assign accel = (addr[3:2] == 'b00) ? {23'b0, accelX} :
                   (addr[3:2] == 'b01) ? {23'b0, accelY} :
                   (addr[3:2] == 'b10) ? {23'b0, accelZ} :
                   (addr[3:2] == 'b11) ? {20'b0, accelTmp} : 32'bx;
    
    assign dataout = (addr[17:16] == 'b01) ? datamemout :
                     (addr[17:16] == 'b10) ? screenmemout :
                     (addr[17:16] == 'b11) ? ((addr[4] == 'b0) ? accel : ((addr[4:2] == 3'b100) ? keyboardin : 32'bx)) : 32'bx;
endmodule
