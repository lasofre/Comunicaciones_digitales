//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2021 13:27:11
// Design Name: 
// Module Name: tb_count
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
`timescale 1ns/100ps

module tb_count();
   reg  [2 - 1 : 0]      reg_sel  ;
   reg                   i_reset  ;
   reg                   i_enable ;
   reg                   clock    ;
   wire                  o_enable ;

   initial begin

      clock               = 1'b0       ;
      reg_sel             = 2'b00      ;
      i_reset             = 1'b0       ;
      i_enable            = 1'b0       ;
      #100 i_reset        = 1'b1       ;
      #100 i_enable       = 1'b1       ;
      #110 reg_sel        = 2'b01      ;
      #210 reg_sel        = 2'b10      ;
      #1000000 $finish                 ;
   end

   always #5 clock = ~clock;

count
    u_count(
        .clock(clock),
        .i_reset(i_reset),
        .i_enable(i_enable),
        .i_sel(reg_sel),
        .o_enable(o_enable)
    );

endmodule