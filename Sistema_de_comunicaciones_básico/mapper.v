/*
Fundacion Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module mapper
(
    input            i_reset,
    input            i_enable,
    input            i_valid,
    input            i_symbolx,
    input            clock,
    output reg [1:0] o_mappedx
);
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            o_mappedx<=2'b11;        
        end
        else if(i_valid && i_enable) begin
             if (i_symbolx) begin
                o_mappedx<=2'b01; 
            end
            else begin
                o_mappedx<=2'b11; 
            end
        end
    end
    
 endmodule