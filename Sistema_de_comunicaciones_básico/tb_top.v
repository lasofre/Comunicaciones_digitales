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
module tb_top;
    parameter ORDER = 9;
    parameter N_sym = 20;
    parameter OS = 4;
    parameter SW    = 4;
    parameter LED    = 5;
    parameter path_dir = `PATH;
    integer tb_o_prbsx;
    integer i;

    reg                     i_reset;
    reg     [SW-1:0]        i_sw;
    wire    [LED-1:0]       o_led;
    reg                     clock;

    initial
    begin 
    clock               = 1'b0       ;
    i_reset             = 1'b0       ;
    i_sw                = {SW{1'b0}} ;
    #10
    i_reset             = 1'b1       ;
    i_sw                = 4'b0011 ;
    for (i=0; i<N_sym*OS; i=i+1)
        begin
            clock = ~clock;
            #10;
            clock = ~clock;
            #10;
        end
    end

top
    u_top
    (
    .i_reset(i_reset),
    .i_sw(i_sw),
    .clock(clock),
    .o_led(o_led)
    );
endmodule