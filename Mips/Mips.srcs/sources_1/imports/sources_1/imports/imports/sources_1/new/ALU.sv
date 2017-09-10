`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/25/2017 12:43:01 PM
// Design Name: 
// Module Name: ALU
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


module ALU #(parameter N = 32) (
    input wire [N-1:0] A, B,
    output wire [N-1:0] R,
    input wire [4:0] ALUfn,
    output wire FlagZ
    );
    
    wire FlagN, FlagC, FlagV;
    
    wire subtract, shift, math;
    wire [1:0] bool;
    assign {subtract, bool, shift, math} = ALUfn[4:0];
    
    wire [N-1:0] addsubResult, shiftResult, logicResult;
    wire compResult;
    
    addsub #(N) AS(A, B, subtract, addsubResult, FlagN, FlagC, FlagV);
    shifter #(N) S(B, A[$clog2(N)-1:0], ~bool[1], ~bool[0], shiftResult);
    logical #(N) L(A, B, bool, logicResult);
    comparator Comp(FlagN, FlagV, FlagC, bool[0], compResult);
    
    assign R =  (~shift & math) ? addsubResult :
                (shift & ~math) ? shiftResult :
                (~shift & ~math) ? logicResult :
                (shift & math) ? {{(N-1){1'b0}}, compResult} : {N{1'bx}};
    
    assign FlagZ = ~(|R);
endmodule
