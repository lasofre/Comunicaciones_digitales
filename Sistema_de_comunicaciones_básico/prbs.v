/*
Fundacion Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module prbs
#(
    parameter ORDER = 9,
    parameter SEEDX = {ORDER{1'b0}}
)
(
    input  i_reset,
    input  i_enable,
    input  i_valid,
    input  clock,
    output o_prbsx
);
reg [ORDER-1:0] r_prbsx;

always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            r_prbsx<=SEEDX;        
        end
        else 
            begin
            if (i_enable && i_valid) begin
            r_prbsx<={r_prbsx[ORDER-5]^r_prbsx[0],r_prbsx[ORDER-1:1]};
        end
        end
    end
assign o_prbsx=r_prbsx[0];
endmodule