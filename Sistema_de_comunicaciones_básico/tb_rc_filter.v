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

module tb_rc_filter;
    parameter OS    = 4;
    parameter TAPS  = 6;
    parameter S_COEF= 8;
    parameter S_IN  = 2;
    parameter N_sym = 20;
    parameter S_OUT = S_COEF+ S_IN;
    parameter path_dir = `PATH;
    
    integer tb_o_rc_filter;
    
    integer i;
    integer j;
    
    reg                     i_reset             ;
    reg                     i_enable             ;
    reg                     i_valid             ;
    reg                     clock                   ;
    wire        [S_OUT-1:0] o_filterx;
    reg         [1:0]       i_mappedx;    
    reg signed  [1:0]       read_i_mappedx [0:N_sym-1];
    
    initial
    begin
    $readmemb({path_dir,"v_o_mapperx.txt"}, read_i_mappedx);
    tb_o_rc_filter = $fopen({path_dir,"v_o_rc_filter.txt"});
    clock               = 1'b0       ;
    i_reset             = 1'b0       ;
    i_enable            = 1'b0       ;
    i_valid             = 1'b0       ;
    #10
    i_reset             = 1'b1       ;
    i_enable            = 1'b1       ;
    i_valid             = 1'b1       ;
    #10
    for (i=0; i<N_sym; i=i+1)
        begin
            i_mappedx <= read_i_mappedx[i]; 
            for(j=0;j<OS;j=j+1)begin
            clock = ~clock;
            #10;
            clock = ~clock;
            #10;
            $fdisplay(tb_o_rc_filter, "%b",o_filterx);
            end
         
        end
        $fclose(tb_o_rc_filter);
    end

rc_filter
    u_rc_filter(
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_valid(i_valid),
    .i_mappedx(i_mappedx),
    .clock(clock),
    .o_filterx(o_filterx)
    );
endmodule