/*
Fundaci�n Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo: 
descripcion:
notas:
*/
`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps
`define PATH "C:/Users/matia/Documents/UTN/0_Extracurricular/0_Fundacion_Fulgor/Diseno_Digital/tp5/entregable/test_file/"
module tb_prbs;
    parameter ORDER = 9;
    parameter SEEDX = 9'b110101010;
    parameter N_sym = 20;
    parameter path_dir = `PATH;
    integer tb_o_prbsx;
    integer i;

    reg                   i_reset  ;
    reg                   i_enable ;
    reg                   i_valid  ;
    reg                   clock    ;
    wire                  o_prbsx;

    initial
    begin 
    tb_o_prbsx = $fopen({path_dir,"v_o_prbsx.txt"});
    clock               = 1'b0       ;
    i_reset             = 1'b0       ;
    i_enable            = 1'b0       ;
    i_valid             = 1'b0       ;
    #10
    i_reset             = 1'b1       ;
    i_enable            = 1'b1       ;
    i_valid             = 1'b1       ;
    for (i=0; i<N_sym; i=i+1)
        begin
            clock = ~clock;
            #10;
            clock = ~clock;
            #10;
            $fdisplay(tb_o_prbsx, "%b",o_prbsx);
        end
        $fclose(tb_o_prbsx);
    end

prbs
    #(
    .ORDER(ORDER),
    .SEEDX(SEEDX)
    )
    u_prbs
    (
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_valid(i_valid),
    .clock(clock),
    .o_prbsx(o_prbsx)   
    );
endmodule