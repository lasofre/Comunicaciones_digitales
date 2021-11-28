module flash (
        input clock,
        input i_reset,
        input i_enable,
        output reg [3:0] o_flash);
        
    always @(posedge clock or negedge i_reset) begin
        if (!i_reset) begin
                o_flash <= 4'b0000;
        end
        else if (i_enable == 1'b1) begin
                o_flash = ~o_flash;
        end
        else begin
            o_flash = o_flash;
        end
    end
endmodule