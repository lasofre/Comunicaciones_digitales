module count (
    input clock,
    input i_reset,
    input i_enable,
    input [1:0] i_sel,
    output reg o_enable);
    wire [32-1:0] count_limit;
    reg  [32-1:0] count;
    localparam R0 = 32'd10;
    localparam R1 = 32'd20;
    localparam R2 = 32'd30;
    localparam R3 = 32'd40;

    assign count_limit = i_sel[1:0]==2'b00 ? R0 :
                         i_sel[1:0]==2'b01 ? R1 :
                         i_sel[1:0]==2'b10 ? R2 : R3;
    always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            count <= {32{1'b0}};                        //repito 32 veces el 0 con el operador de repetición
            o_enable <= 1'b0;                         
        end
        else if (i_enable) begin
            if (count < count_limit) begin
                count <=count + 1'b1;
                o_enable <= 1'b0;
            end
            else
                begin
                    count <= {32{1'b0}};
                    o_enable <= 1'b1;
                end
        end
        else 
            begin
                count <= count;
            end  
    end
endmodule