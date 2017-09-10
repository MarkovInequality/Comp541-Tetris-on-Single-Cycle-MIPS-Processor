`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2017 11:34:34 PM
// Design Name: 
// Module Name: bitmapmem
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

module bitmapmem #( //please keep these parameters powers of 2
    parameter chars = 16,
    parameter mem_per_char = 256,
    parameter initfile = "bitmap_data.mem"
    ) (
    input wire [$clog2(chars)+$clog2(mem_per_char)-1:0] addr,
    output wire [11:0] dataout
    );
    
    logic [11 : 0] mem [(chars * mem_per_char) - 1 : 0];
    
    initial $readmemh(initfile, mem, 0, (chars * mem_per_char) - 1);

    assign dataout = mem[addr];
    
endmodule
