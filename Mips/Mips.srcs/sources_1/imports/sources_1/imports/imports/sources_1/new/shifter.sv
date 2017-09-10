`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2017 12:36:11 PM
// Design Name: 
// Module Name: shifter
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


module shifter #(parameter N = 32) (
    input wire signed [N-1:0] In,
    input wire [$clog2(N)-1:0] shamt,
    input wire left, logical,
    output wire [N-1:0] Out
    );
    
    assign Out = left ? (In << shamt) :
                    (logical ? In >> shamt : In >>> shamt);
endmodule
