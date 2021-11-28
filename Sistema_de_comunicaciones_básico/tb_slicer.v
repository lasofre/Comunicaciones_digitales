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

module tb_slicer;
    parameter OS    = 4;
    parameter TAPS  = 6;
    parameter S_COEF= 8;
    parameter S_IN  = 2;
    parameter N_sym = 20;
    parameter S_OUT = S_COEF+ S_IN;
    parameter path_dir = `PATH;
    
    integer tb_o_slicer;
    
    integer i;
    integer j; 
    reg                           i_reset;
    reg                           i_enable;
    reg                           i_valid;
    reg                           clock;
    wire                          o_slicer;
    reg signed                    i_sync;
    reg         [S_OUT-1:0]       i_dwnsmp;    
    reg signed  [S_OUT-1:0]       read_i_dwnsmp [0:N_sym*OS-1];
    reg signed                    read_i_sync [0:N_sym*OS-1];
    
    initial
    begin
    $readmemb({path_dir,"v_o_dwnsmp.txt"}, read_i_dwnsmp);
    $readmemb({path_dir,"v_o_sync.txt"}, read_i_sync);
    tb_o_slicer = $fopen({path_dir,"v_o_slicer.txt"});
    clock               = 1'b0       ;
    i_reset             = 1'b0       ;
    i_valid             = 1'b0       ;
    i_enable            = 1'b0       ;
    #10
    i_enable            = 1'b1       ;
    i_reset             = 1'b1       ;
    #10
    for (i=0; i<N_sym; i=i+1)
        begin
        for(j=0;j<OS;j=j+1) begin
        if(j<2)begin
        i_valid <= 1'b1;
        end
        else begin
            i_valid<=1'b0;
        end
        if(j==3)begin
        $fdisplay(tb_o_slicer, "%b",o_slicer);
        end
            i_dwnsmp <= read_i_dwnsmp[i*OS+j];
            i_sync   <= read_i_sync[i*OS+j];
            clock = ~clock;
            #10;
            clock = ~clock;
            #10;
         end
        end
        $fclose(tb_o_slicer);
    end

slicer
    u_slicer(
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_valid(i_valid),
    .i_sync(i_sync),
    .i_dwnsmp(i_dwnsmp),
    .clock(clock),
    .o_slicer(o_slicer)
    );
endmodule