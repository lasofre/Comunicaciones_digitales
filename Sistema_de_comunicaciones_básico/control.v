/*
Fundacion Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module control
#(
    parameter S_NCON    = 4
)
(
    input                     i_reset,
    input                     i_enable,
    input                     clock,
    output reg                o_valid
);
localparam NCON = $clog2(S_NCON);
reg [NCON-1:0]          r_cont;
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            r_cont<={NCON{1'b0}};        
        end
        else if ((r_cont < {NCON{1'b1}}) && i_enable) begin
                r_cont<=r_cont+1'b1;    
              end
              else begin
                  r_cont<={NCON{1'b0}}; 
              end
 end
 always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            o_valid<=1'b0;        
        end
        else if ((r_cont == {NCON{1'b0}}) && i_enable) begin
                o_valid<=1'b1;     
              end
              else begin
                  o_valid<=1'b0;
              end
 end
 endmodule