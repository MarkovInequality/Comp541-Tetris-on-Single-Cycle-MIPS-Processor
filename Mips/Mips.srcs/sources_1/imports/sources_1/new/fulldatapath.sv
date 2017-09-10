`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/29/2017 01:19:13 PM
// Design Name: 
// Module Name: fulldatapath
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


module fulldatapath #(
        parameter initfile = "reg_data.mem",
        parameter pcinit = 'h40_0000
    )
    (
        input wire clk,
        input wire reset,
        output wire [31:0] pc,
        input wire [31:0] instr,
        input wire [1:0] pcsel,
        input wire [1:0] wasel,
        input wire sext,
        input wire bsel,
        input wire [1:0] wdsel,
        input wire [4:0] alufn,
        input wire werf,
        input wire [1:0] asel,
        output wire Z,
        output wire [31:0] mem_addr,
        output wire [31:0] mem_writedata,
        input wire [31:0] mem_readdata
    );
    
    wire [31:0] bt;
    logic [31:0] pcReg = pcinit;
    wire [31:0] signImm;
    wire [31:0] ReadData1, ReadData2;
    wire [31:0] aluA, aluB;
    wire [31:0] alu_result;
    wire [4:0] reg_writeaddr;
    wire [31:0] reg_writedata;
    
    assign pc = pcReg;
    
    assign bt = pcReg + 4 + (signImm[31:0] << 2);
    
    always_ff @(posedge clk) begin
        pcReg <= (reset == 1) ? pcinit :
                 (pcsel == 0) ? pcReg + 4 :
                 (pcsel == 1) ? bt :
                 (pcsel == 2) ? {pc[31:28], instr[25:0], 2'b00} :
                 (pcsel == 3) ? ReadData1 : pcinit;
    end;
    
    assign signImm = (sext == 0) ? {16'h0000, instr[15:0]} :
                                   {{16{instr[15]}}, instr[15:0]};
    
    assign reg_writeaddr = (wasel == 0) ? instr[15:11] :
                           (wasel == 1) ? instr[20:16] :
                           (wasel == 2) ? 31 : 0;
    
    assign reg_writedata = (wdsel == 0) ? pc + 4 :
                           (wdsel == 1) ? alu_result :
                           (wdsel == 2) ? mem_readdata : 0;
                     
    assign aluA = (asel == 0) ? ReadData1 :
               (asel == 1) ? instr[10:6] :
               (asel == 2) ? 16 : 0;
               
    assign aluB = (bsel == 0) ? ReadData2 :
               (bsel == 1) ? signImm : 0;
               
    assign mem_writedata = ReadData2;
    assign mem_addr = alu_result;
               
    ALU #(32) mainALU(aluA, aluB, alu_result, alufn, Z);
    register_file #(32, 32, initfile) rf(clk, werf, instr[25:21], instr[20:16], reg_writeaddr, reg_writedata, ReadData1, ReadData2);
       
endmodule
