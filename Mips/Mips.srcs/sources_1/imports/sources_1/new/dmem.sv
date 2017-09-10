`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2017 12:01:57 PM
// Design Name: 
// Module Name: dmem
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


module dmem #(
    parameter Nloc = 64,
    parameter Dbits = 32,
    parameter initfile = "mem_data.mem"
    ) (
    input wire clk,
    input wire wr,
    input wire [Dbits-1:0] addr,
    input wire [Dbits-1:0] writedata,
    output wire [Dbits-1:0] readdata
    );
    
    wire [$clog2(Nloc)-1:0] addrAligned = addr >> 2;
    ram_module #(Nloc, Dbits, initfile) mem(clk, wr, addrAligned, writedata, readdata);
endmodule
