//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 3/29/2017 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="instr_data.mem",		// correct filename inherited from parent/tester
    parameter smem_init="screen_data.mem",
    parameter dmem_init="mem_data.mem",
    parameter bmem_init="bitmap_data.mem"   	// correct filename inherited from parent/tester
)(
    input wire clk, reset,
    
    output wire [3:0] red, green, blue,
    output wire hsync, vsync,
    
    input wire ps2_clk,
    input wire ps2_data,
    
    output wire aclSCK,
    output wire aclMOSI,
    input wire aclMISO,
    output wire aclSS,
    
    output wire [15:0] LED,
    
    output wire audPWM,
    output wire audEn,
    
    output logic [7:0] segments,
    output logic [7:0] digitselect
);
   
   wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
   wire mem_wr;
   wire clk100, clk50, clk25, clk12;
   
   wire [10:0] smem_addr;
   wire [3:0] charcode;
   
   wire [31:0] keyboardin;
   
   wire [8:0] accelX, accelY, accelZ;
   wire [11:0] accelTmp;
   
   wire [31:0] period;
   
   logic [63:0] counter = 0;
   logic slowclk = 0;
   
   always_ff @(posedge clk)
   begin
     counter <= counter + 1;
     if (counter == 20000000)
        begin
        counter <= 0;
        slowclk = ~slowclk;
        end
     end
   
   clockdivider_Nexys4 clkdv(clk, clk100, clk50, clk25, clk12);
   //assign clk100=clk; assign clk50=clk; assign clk25=clk; assign clk12=clk;
   
   assign audEn = 1;
   
   display8digit disp(keyboardin, clk, segments, digitselect);
   
   vgadisplaydriver #(40, 30, 16, 256, bmem_init) display(clk, charcode, smem_addr, red, green, blue, hsync, vsync);
   keyboard keyb(clk, ps2_clk, ps2_data, keyboardin);
   accelerometer accel(clk, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelZ, accelTmp);
   montek_sound_Nexys4 sound(clk, period, audPWM);

   mips mips(clk50, reset, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata);
   imem #(.Nloc(512), .Dbits(32), .initfile(imem_init)) imem(pc[31:0], instr);
   memIO #(dmem_init, smem_init, 1024, 40, 30) memIO(clk50, mem_wr, mem_addr, mem_writedata, mem_readdata, smem_addr, charcode, keyboardin, accelX, accelY, accelZ, accelTmp, LED, period);

endmodule