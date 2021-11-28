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

module tb_sync;
    parameter OS    = 4;
    parameter TAPS  = 6;
    parameter S_COEF= 8;
    parameter S_IN  = 2;
    parameter N_sym = 20;
    parameter S_OUT = S_COEF+ S_IN;
    parameter path_dir = `PATH;
    
    integer tb_o_rc_filter;
    
    integer i; 
    reg                     i_reset             ;
    reg                     i_enable            ;
    reg                     i_valid             ;
    reg                     clock               ;
    wire                          o_sync;
    reg         [S_OUT-1:0]       i_rc_filter;    
    reg signed  [S_OUT-1:0]       read_i_rc_filter [0:N_sym*OS-1];
    
    initial
    begin
    $readmemb({path_dir,"v_o_rc_filter.txt"}, read_i_rc_filter);
    tb_o_rc_filter = $fopen({path_dir,"v_o_sync.txt"});
    clock               = 1'b0       ;
    i_reset             = 1'b0       ;
    i_enable            = 1'b0       ;
    i_valid             = 1'b0       ;
    #10
    i_reset             = 1'b1       ;
    i_enable            = 1'b1       ;
    i_valid             = 1'b1       ;
    #10
    for (i=0; i<N_sym*OS; i=i+1)
        begin
            i_rc_filter <= read_i_rc_filter[i]; 
            clock = ~clock;
            #10;
            clock = ~clock;
            #10;
            $fdisplay(tb_o_rc_filter, "%b",o_sync);
        end
        $fclose(tb_o_rc_filter);
    end

sync
    u_sync(
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_valid(i_valid),
    .i_rc_filter(i_rc_filter),
    .clock(clock),
    .o_sync(o_sync)
    );
endmodule