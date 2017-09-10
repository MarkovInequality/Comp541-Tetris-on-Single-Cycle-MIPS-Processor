`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2017 11:34:34 PM
// Design Name: 
// Module Name: screenmem
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

module screenmem #(
    parameter xsize = 40,
    parameter ysize = 30,
    parameter Dbits = 32,
    parameter initfile = "screen_data.mem"
    ) (
    input wire clock,
    input wire wr,
    input wire [$clog2(ysize*xsize)+1:0] rwaddr,
    input wire [$clog2(ysize*xsize)-1:0] roaddr,
    input wire [Dbits-1:0] writedata,
    output wire [Dbits-1:0] screenread, controlread
    );
    
    wire [$clog2(ysize*xsize)-1:0] rwaddrAligned = rwaddr >> 2;
    
    logic [Dbits-1 : 0] mem [(ysize * xsize) - 1 : 0];
    
    initial $readmemh(initfile, mem, 0, (ysize * xsize) - 1);
 
    always_ff @(posedge clock)                // Memory write: only when wr==1, and only at posedge clock
       if(wr)
          mem[rwaddrAligned] <= writedata;
 
    assign controlread = mem[rwaddrAligned];
    assign screenread = mem[roaddr];
    
endmodule