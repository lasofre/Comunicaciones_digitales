module top (
    input clock,
    input i_reset,
    input [3:0] i_sw,
    input [3:0] i_btn,
    output [3:0] o_led,
    output reg [3:0] o_led_r,
    output reg [3:0] o_led_g,
    output reg [3:0] o_led_b
);
wire enable;
wire [3:0] output_shift;
wire [3:0] output_flash;
wire [3:0] output_mode;
reg  [3:0] reg_btn;

count
    u_count(
        .clock(clock),
        .i_reset(i_reset),
        .i_enable(i_sw[0]),
        .i_sel(i_sw[2:1]),
        .o_enable(enable)
    );
shiftreg
    u_shiftreg(
        .clock(clock),
        .i_reset(i_reset),
        .i_enable(enable),
        .i_selector(i_sw[3]),
        .o_shift(output_shift)
    );
flash
    u_flash(
        .clock(clock),
        .i_reset(i_reset),
        .i_enable(enable),
        .o_flash(output_flash)
    );

always @(posedge clock or negedge i_reset) begin
      if (!i_reset) begin
          reg_btn[3:1] <= 4'b001;                   
      end
      else if (i_btn[1]) begin
          reg_btn[3:1] <= 4'b001;
      end 
      else if (i_btn[2]) begin
          reg_btn[3:1] <= 4'b010;
      end 
      else if (i_btn[3]) begin
          reg_btn[3:1] <= 4'b100;
      end
end

always @(posedge clock or negedge i_reset) begin
      if (!i_reset) begin
          reg_btn[0] <= 1'b0;                   
      end
      else if (i_btn[0]) begin
          reg_btn[0] <= ~reg_btn[0];
      end 
end

always @(*) begin
    case (reg_btn[3:1])
            4'b001:begin  
            o_led_r  = output_mode;
            o_led_g  = 4'b0000;
            o_led_b  = 4'b0000;
            end
            4'b010:begin  
            o_led_r  = 4'b0000;
            o_led_g  = output_mode;
            o_led_b  = 4'b0000;
            end
            4'b100:begin
            o_led_r  = 4'b0000;
            o_led_g  = 4'b0000;
            o_led_b  = output_mode;
             end
            default: begin
            o_led_r  = output_mode;
            o_led_g  = 4'b0000;
            o_led_b  = 4'b0000;
            end
    endcase
end

assign  o_led = reg_btn;
assign output_mode = reg_btn[0]? output_shift : output_flash;
endmodule