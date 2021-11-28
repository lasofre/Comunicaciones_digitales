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
module tb_mapper;
    parameter N_sym = 20;
    parameter path_dir = `PATH;
    integer tb_o_mapper;
    integer i;

    reg                   i_reset  ;
    reg                   i_enable  ;
    reg                   i_valid;
    reg                   clock    ;
    wire     [1:0]         o_mappedx;
    reg                   i_symbolx;
    reg                   read_i_symbolx [0:N_sym];
    initial
    begin
    $readmemb({path_dir,"v_o_prbsx.txt"}, read_i_symbolx);
    tb_o_mapper = $fopen({path_dir,"v_o_mapperx.txt"});
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
            i_symbolx <= read_i_symbolx[i]; 
            clock = ~clock;
            #10;
            clock = ~clock;
            #10;
            $fdisplay(tb_o_mapper, "%b",o_mappedx);
        end
        $fclose(tb_o_mapper);
    end

mapper
    u_mapper(
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_valid(i_valid),
    .i_symbolx(i_symbolx),
    .clock(clock),
    .o_mappedx(o_mappedx)
    );
endmodule