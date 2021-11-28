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

module tb_ber;
    parameter OS    = 4;
    parameter TAPS  = 6;
    parameter S_COEF= 8;
    parameter S_IN  = 2;
    parameter N_sym = 20;
    parameter RX_DELAY = 4;
    parameter BUFFER = 16;
    
    parameter S_OUT = S_COEF+ S_IN;
    parameter path_dir = `PATH;
    parameter DELAY = $clog2(BUFFER);
    parameter SDELAY = $clog2(RX_DELAY);
    integer tb_o_ber_slicer;
    integer tb_o_ber_prbs;
    integer tb_o_ber;
    
    integer i;

    reg                           i_reset;
    reg                           i_enable;
    reg                           i_valid;
    reg                           clock;
    wire                          o_ber_slicer;
    wire                          o_ber_prbs;
    wire                          o_ber;
    reg                           i_sync;
    reg                           i_slicer;   
    reg                           i_prbsx; 
    reg         [SDELAY-1:0]      i_delay_sis;
    reg signed  [S_OUT-1:0]       read_i_slicer [0:N_sym-1];
    reg signed                    read_i_sync   [0:(N_sym*OS)-1];
    reg signed                    read_i_prbsx  [0:N_sym-1];
    
    initial
    begin
    $readmemb({path_dir,"v_o_slicer.txt"}, read_i_slicer);
    $readmemb({path_dir,"v_o_sync.txt"}, read_i_sync);
    $readmemb({path_dir,"v_o_prbsx.txt"}, read_i_prbsx);
    tb_o_ber_slicer = $fopen({path_dir,"v_o_ber_slicer.txt"});
    tb_o_ber_prbs = $fopen({path_dir,"v_o_ber_prbs.txt"});
    tb_o_ber = $fopen({path_dir,"v_o_ber.txt"});
    clock               = 1'b0       ;
    i_reset             = 1'b0       ;
    i_valid             = 1'b0       ;
    i_enable            = 1'b0       ;
    i_delay_sis         = 2'b00      ;
    #10
    i_enable            = 1'b1       ;
    i_reset             = 1'b1       ;
    i_valid             = 1'b1       ;
    i_prbsx             = 1'b0;
    i_delay_sis         = 2'b00      ;
    #10
    for (i=0; i<N_sym; i=i+1)
        begin
            i_prbsx  <= read_i_prbsx[i];
            i_slicer <= read_i_slicer[i];
            i_sync   <= read_i_sync[i*OS];
            clock = ~clock;
            #10;
            clock = ~clock;
            #10;
            $fdisplay(tb_o_ber_slicer, "%b",o_ber_slicer);
            $fdisplay(tb_o_ber_prbs, "%b",o_ber_prbs);
            $fdisplay(tb_o_ber, "%b",o_ber);
         end
        $fclose(tb_o_ber_slicer);
        $fclose(tb_o_ber_prbs);
        $fclose(tb_o_ber);
    end

ber
    u_ber(
    .clock(clock),
    .i_reset(i_reset),
    .i_enable(i_enable),
    .i_valid(i_valid),
    .i_delay_sis(i_delay_sis),
    .i_sync(i_sync),
    .i_prbs(i_prbsx),
    .i_slicer(i_slicer),
    .o_slicer(o_ber_slicer),
    .o_prbs(o_ber_prbs),
    .o_delay(o_delay),                     
    .o_ber(o_ber)
    );
endmodule