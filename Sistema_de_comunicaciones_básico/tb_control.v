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
module tb_control;
    parameter N_sym = 20;
    integer tb_o_prbsx;
    integer i;

    reg                   i_reset  ;
    reg                   i_enable ;
    wire                  o_valid  ;
    reg                   clock    ;

    initial
    begin 
    clock               = 1'b0       ;
    i_reset             = 1'b0       ;
    i_enable            = 1'b0       ;
    #10
    i_reset             = 1'b1       ;
    i_enable            = 1'b1       ;
    for (i=0; i<N_sym; i=i+1)
        begin
            clock = ~clock;
            #10;
            clock = ~clock;
            #10;
        end
    end

control
    u_control
    (
    .i_reset(i_reset),
    .i_enable(i_enable),
    .clock(clock),
    .o_valid(o_valid)
    );
endmodule