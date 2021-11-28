//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2021 13:47:13
// Design Name: 
// Module Name: tb_top
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

module tb_top();
   wire      [4 - 1 : 0] o_led    ;
   wire      [4 - 1 : 0] o_led_r  ;
   wire      [4 - 1 : 0] o_led_g  ;
   wire      [4 - 1 : 0] o_led_b  ;
   reg       [4 - 1 : 0] i_btn  ;
   reg       [4 - 1 : 0] i_sw  ;
   reg                   i_reset  ;
   reg                   clock    ;

   initial begin

      clock                = 1'b0       ;
      i_reset              = 1'b0       ;
      i_btn                = 4'b0000    ;
      i_sw                 = 4'b0001    ;
      #100 i_reset         = 1'b1       ;
      #225 i_btn[2]        = 1'b1       ;
      #5   i_btn[2]        = 1'b0       ;
      #225 i_btn[3]        = 1'b1       ;
      #5   i_btn[3]        = 1'b0       ;
      #225 i_btn[0]        = 1'b1       ;
      #5   i_btn[0]        = 1'b0       ;
      #30  i_sw[3]         = 1'b1       ;
      #10000000 $finish                 ;
   end

   always #5 clock = ~clock;

top
    u_top(
    .clock(clock),
    .i_reset(i_reset),
    .i_sw(i_sw),
    .i_btn(i_btn),
    .o_led(o_led),
    .o_led_r(o_led_r),
    .o_led_g(o_led_g),
    .o_led_b(o_led_b)
    );

endmodule