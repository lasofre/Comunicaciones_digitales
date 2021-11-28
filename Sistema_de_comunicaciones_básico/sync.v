/*
Fundacion Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module sync
#(
    parameter S_IN    = 10,
    parameter signed Symb_pos=10'b0001001101,
    parameter signed Symb_neg=10'b1110110011
)
(
    input                     i_reset,
    input                     i_enable,
    input                     i_valid,
    input  signed  [S_IN-1:0] i_rc_filter,
    input                     clock,
    output reg                o_sync
);
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            o_sync<=1'b0;        
        end
        else if ((i_rc_filter> Symb_pos) || (i_rc_filter < Symb_neg) && i_enable && i_valid) begin
                o_sync<=1'b1;    
              end
 end
 endmodule