`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2017 09:00:38 PM
// Design Name: 
// Module Name: init_test
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


module init_test;

   localparam width = 8;	// if you change width, be sure to resize 
				// operands A and B near the bottom

   // Inputs
   logic [10:0] addr;
   logic clk = 0;
   logic [2:0] charcode = 0;
   logic [10:0] x = 0;
   logic [10:0] y = 0;
   // Outputs
   wire [11:0] out;
   wire screenadr;
   wire [3:0] red, green, blue;
   wire hsync, vsync;
   //wire [11:0] rgb = uut2.bmem_color;
   wire [3:0] xin = x[3:0];
   wire [3:0] yin = y[3:0];
   wire [31:0] asdf; 
   

   // Instantiate the Unit Under Test (UUT)
   bitmapmem uut(addr, out);
   //vgadisplaydriver uut2(clk, charcode, screenadr, red, green, blue, hsync, vsync, x, y);
   dmem uut3(clk, 0, addr, 0, asdf);
   
   initial begin
      // Initialize Inputs
   addr = 0;
   charcode = 1;
   x = 0;
   y = 0;

      // Wait 2 ns
      #5;

      #2 y = 1; x = 0; addr = 4;
      #2 y = 0; x = 1; 
      #2 y = 2; x = 1;        
                             
      // Wait another 5 ns, and then finish simulation
      #5 $finish;
   end
      
endmodule