/*
Fundacion Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module dwnsmp
#(
    parameter S_IN    = 10,
    parameter OS      = 4,
    parameter FASE    =$clog2(OS)
)
(
    input                           i_reset,
    input                           i_enable,
    input                           i_valid,
    input              [FASE-1:0]   i_fase,         
    input      signed  [S_IN-1:0]   i_rc_filter,
    input                           i_sync,
    input                           clock,
    output reg signed  [S_IN-1:0]   o_dwnsmp
);
localparam  CONT = $clog2(OS)-1 ;
reg [CONT:0]         r_cont;

always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            r_cont<={CONT{1'b0}};     
        end
        else begin
            if (r_cont<(OS) && i_enable && i_valid) begin
                r_cont<=r_cont+1'b1; 
            end
            else begin
                r_cont<={CONT{1'b0}};  
            end
        end
    end

always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            o_dwnsmp<={S_IN{1'b0}};        
        end
        else if(i_sync && (r_cont==i_fase) && i_enable && i_valid) begin
                o_dwnsmp<=i_rc_filter;    
              end
 end
 endmodule
