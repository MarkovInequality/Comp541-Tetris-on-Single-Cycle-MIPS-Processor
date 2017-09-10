`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2017 12:35:57 PM
// Design Name: 
// Module Name: vgadisplaydriver
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

module vgadisplaydriver # (
    parameter xscreensize = 40,
    parameter yscreensize = 30,
    parameter numchars = 16,
    parameter mem_per_char = 256,
    parameter initfile = "bitmap_data.mem"
    )
    (
    input wire clock,
    input wire [$clog2(numchars)-1:0] charcode,
    output wire [$clog2(yscreensize*xscreensize)-1:0] screenaddr,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );

   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   wire activevideo;
   wire [11:0] bmem_color;
   wire [$clog2(numchars)+7:0] bmem_addr;
   
   vgatimer myvgatimer(clock, hsync, vsync, activevideo, x, y);
   
   assign screenaddr = (y[$clog2(yscreensize)+3:4] * 40) + x[$clog2(xscreensize)+3:4];
   
   assign bmem_addr = {charcode, y[3:0], x[3:0]};
   
   bitmapmem #(numchars, mem_per_char, initfile) bmmem(bmem_addr, bmem_color);
   
   assign red[3:0]   = (activevideo == 1) ? bmem_color[11:8] : 4'b0;
   assign green[3:0] = (activevideo == 1) ? bmem_color[7:4] : 4'b0;
   assign blue[3:0]  = (activevideo == 1) ? bmem_color[3:0] : 4'b0;

endmodule
