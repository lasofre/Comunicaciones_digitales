/*
Fundacion Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module slicer
#(
    parameter S_IN    = 10
)
(
    input                     i_reset,
    input                     i_enable,
    input                     i_valid,
    input                     i_sync,
    input          [S_IN-1:0] i_dwnsmp,
    input                     clock,
    output reg                o_slicer
);
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            o_slicer<=1'b0;        
        end
        else if (i_enable && i_sync && i_valid) begin
                if (!i_dwnsmp[S_IN-1]) begin
                        o_slicer<=1'b1;    
              end
              else begin
                o_slicer<=1'b0; 
              end
              end
 end
 endmodule