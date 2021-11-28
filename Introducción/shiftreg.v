module shiftreg (
        input clock,
        input i_reset,
        input i_enable,
        input i_selector,
        output [3:0] o_shift);
    
    reg [4-1:0] shift_reg;
    reg reg_enable;
    
    
    always @(posedge clock or negedge i_reset) begin
      if (!i_reset) begin
          reg_enable <= 1'b0;                   
      end
      else if(i_enable) begin
          reg_enable <= ~reg_enable;
      end 
    end
    always @(posedge clock or negedge i_reset) begin
        if (!i_reset) begin
                shift_reg <= 4'b0001;
        end
        else if(i_enable == 1'b1)begin
                if(i_selector == 1'b1)begin
                    shift_reg <= {shift_reg[2:0],shift_reg[3]};
                end
                else begin
                    shift_reg <= {shift_reg[0],shift_reg[3:1]};
                end
        end
        else begin
                shift_reg <= shift_reg;
        end
    end
    
    assign o_shift = shift_reg;
endmodule