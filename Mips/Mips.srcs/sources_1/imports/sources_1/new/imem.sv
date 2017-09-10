`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2017 11:51:44 AM
// Design Name: 
// Module Name: imem
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


module imem #(
    parameter Nloc = 512,
    parameter Dbits = 32,
    parameter initfile = "instr_data.mem"
    ) (
    input wire [Dbits-1:0] addr,
    output wire [Dbits-1:0] dataout
    );
    
    logic [Dbits-1:0] mem [Nloc-1 : 0];
    
    initial $readmemh(initfile, mem, 0, Nloc - 1);

    wire [$clog2(Nloc)-1:0] addrAligned = addr >> 2;
    assign dataout = mem[addrAligned];

endmodule
