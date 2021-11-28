//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2021 13:12:50
// Design Name: 
// Module Name: tb_shiftreg
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

module tb_shiftreg();
    
   wire [4 - 1 : 0] output_shift    ;
   reg                   i_reset    ;
   reg                   i_enable   ;
   reg                   i_selector ;
   reg                   clock      ;

   initial begin

      clock               = 1'b0       ;
      i_reset             = 1'b0       ;
      i_enable            = 1'b0       ;
      i_selector          = 1'b0       ;
      #100 i_reset        = 1'b1       ;
      #300 i_selector     = 1'b1       ;
      #1000000 $finish                 ;
   end

   always #5 clock = ~clock;
   always #10 i_enable = ~i_enable;
shiftreg
    u_shiftreg(
        .clock(clock),
        .i_reset(i_reset),
        .i_enable(i_enable),
        .i_selector(i_selector),
        .o_shift(output_shift)
    );

endmodule