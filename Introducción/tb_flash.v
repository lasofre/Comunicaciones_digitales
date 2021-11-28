//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.06.2021 12:54:39
// Design Name: 
// Module Name: tb_flash
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

module tb_flash();


   wire [4 - 1 : 0] output_flash  ;
   reg                   i_reset  ;
   reg                   i_enable ;
   reg                   clock    ;
   reg [2:0]             count;

   initial begin

      clock               = 1'b0       ;
      count               = 3'b000     ;
      i_reset             = 1'b0       ;
      i_enable            = 1'b0       ;
      #100 i_reset        = 1'b1       ;
      #1000000 $finish                 ;
   end

   always #5 clock = ~clock;

   always @(posedge clock or negedge i_reset) begin
        if (!i_reset) begin
                count <= 3'b000;
        end
        else if (count == 3'b111) begin
                     i_enable =1'b1;
                     count=0;
             end
             else begin
                    count=count+1;
                    i_enable = 1'b0;
            end
       end

flash
    u_flash(
        .clock(clock),
        .i_reset(i_reset),
        .i_enable(i_enable),
        .o_flash(output_flash)
    );

endmodule 

