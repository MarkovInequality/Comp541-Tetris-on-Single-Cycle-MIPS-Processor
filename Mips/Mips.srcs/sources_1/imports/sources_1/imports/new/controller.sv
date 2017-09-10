//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2017 09:19:41 PM
// Design Name: 
// Module Name: controller
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

`timescale 1ns / 1ps
`default_nettype none

// These are non-R-type.  OPCODES defined here:

`define LW     6'b 100011
`define SW     6'b 101011

`define ADDI   6'b 001000
`define ADDIU  6'b 001001			// NOTE:  addiu *does* sign-extend the imm
`define SLTI   6'b 001010
`define SLTIU  6'b 001011
`define ANDI   6'b 001100
`define XORI   6'b 001110
`define ORI    6'b 001101
`define LUI    6'b 001111

`define BEQ    6'b 000100
`define BNE    6'b 000101
`define J      6'b 000010
`define JAL    6'b 000011


// These are all R-type, i.e., OPCODE=0.  FUNC field defined here:

`define ADD    6'b 100000
`define ADDU   6'b 100001
`define SUB    6'b 100010
`define AND    6'b 100100
`define OR     6'b 100101
`define XOR    6'b 100110
`define NOR    6'b 100111
`define SLT    6'b 101010
`define SLTU   6'b 101011
`define SLL    6'b 000000
`define SLLV   6'b 000100
`define SRL    6'b 000010
`define SRA    6'b 000011
`define JR     6'b 001000  


module controller(
   input  wire [5:0] op, 
   input  wire [5:0] func,
   input  wire Z,
   output wire [1:0] pcsel,
   output wire [1:0] wasel, 
   output wire sext,
   output wire bsel,
   output wire [1:0] wdsel, 
   output logic [4:0] alufn, 			// will become wire because updated in always_comb
   output wire wr,
   output wire werf, 
   output wire [1:0] asel
   ); 

  assign pcsel = ((op == 6'b0) & (func == `JR)) ? 2'b11   // controls 4-way multiplexer
               : ((op == `J) | (op == `JAL)) ? 2'b10
               : (((op == `BEQ) & (Z == 1)) | ((op == `BNE) & (Z == 0))) ? 2'b01
               : 2'b00;

  logic [9:0] controls;
  assign {werf, wdsel[1:0], wasel[1:0], asel[1:0], bsel, sext, wr} = controls[9:0];

  always_comb
     case(op)                                     // non-R-type instructions
        `LW: controls <= 10'b1_10_01_00_1_1_0;
        `SW: controls <= 10'b0_XX_XX_00_1_1_1;
      `ADDI,
     `ADDIU,
      `SLTI,
     `SLTIU: controls <= 10'b1_01_01_00_1_1_0;
      `ANDI,
      `XORI,
       `ORI: controls <= 10'b1_01_01_00_1_0_0;
       `LUI: controls <= 10'b1_01_01_10_1_X_0;
       `BEQ, 
       `BNE: controls <= 10'b0_XX_XX_00_0_1_0; //X for sext is also ok
         `J: controls <= 10'b0_XX_XX_XX_X_X_0;
       `JAL: controls <= 10'b1_00_10_XX_X_X_0;
      6'b000000:                                    
         case(func)                              // R-type
             `ADD,
            `ADDU,
             `SUB,
             `AND,
              `OR,
             `XOR,
             `NOR,
             `SLT,
            `SLTU,
            `SLLV: controls <= 10'b1_01_00_00_0_x_0;
             `SLL,
             `SRL,
             `SRA: controls <= 10'b1_01_00_01_0_x_0;
              `JR: controls <= 10'b0_XX_XX_XX_X_X_0;
            default:   controls <= 10'b0_XX_XX_XX_X_X_0; // unknown instruction, turn off register and memory writes
         endcase
      default: controls <= 10'b0_XX_XX_XX_X_X_0; // unknown instruction, turn off register and memory writes
    endcase
    

  always_comb
    case(op)                        // non-R-type instructions
        `LW,
        `SW,
      `ADDI,
     `ADDIU: alufn <= 5'b0xx01;
      `SLTI: alufn <= 5'b1x011;
     `SLTIU: alufn <= 5'b1x111;
      `ANDI: alufn <= 5'bx0000;
      `XORI: alufn <= 5'bx1000;
       `ORI: alufn <= 5'bx0100;
       `LUI: alufn <= 5'bx0010;
       `BEQ,
       `BNE: alufn <= 5'b1XX01;
      6'b000000:                      
         case(func)                 // R-type
             `ADD,
            `ADDU: alufn <= 5'b0xx01;
             `SUB: alufn <= 5'b1xx01;
             `AND: alufn <= 5'bx0000;
              `OR: alufn <= 5'bx0100;
             `XOR: alufn <= 5'bx1000;
             `NOR: alufn <= 5'bx1100;
             `SLT: alufn <= 5'b1x011;
            `SLTU: alufn <= 5'b1x111;
            `SLLV,
             `SLL: alufn <= 5'bx0010;
             `SRL: alufn <= 5'bx1010;
             `SRA: alufn <= 5'bx1110;
            default:   alufn <= 5'bXXXXX; // ???
         endcase
      default: alufn <= 5'bXXXXX;          // J, JAL
    endcase
    
endmodule
