/*
Fundaci�n Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico n�4
Alumno: Bucca Matias.
titulo: tb_sumador_fixed
descripci�n: Testbench para el sumador de punto fijo parametrizado.
notas:
*/
`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps
`define PATH "C:/Users/matia/Documents/UTN/0_Extracurricular/0_Fundacion_Fulgor/Diseno_Digital/tp4/entregable/test_files/"
module tb_sumador_fixed;
    parameter NBA  =16; parameter  NBFA  =14; // Entrada A S(xx,xx)
    parameter NBB  =12; parameter  NBFB  =11; // Entrada B S(xx,xx)
    parameter NBS1 =11;  parameter NBFS1 =10; // Salida  1 S(xx,xx)
    parameter NBS2 =09;  parameter NBFS2 =08;  // Salida  2 S(xx,xx)
    parameter path_dir = `PATH;
    reg signed   [NBA-1:0]  i_saa_aa; 
    reg signed   [NBB-1:0]  i_sbb_bb; 
    reg          [NBA :0]          o_sxx_xx_full_w; 
    reg          [NBS1-1:0]        o_s11_11_over_trunc_w;          
    reg          [NBS1-1:0]        o_s11_11_satu_trunc_w;          
    reg          [NBS2-1:0]        o_s22_22_satu_round_w;          
    wire         [NBA   :0]        o_sxx_xx_full;          
    wire         [NBS1-1:0]        o_s11_11_over_trunc;    
    wire         [NBS1-1:0]        o_s11_11_satu_trunc;    
    wire         [NBS2-1:0]        o_s22_22_satu_round;    
    reg signed   [NBA-1:0]         read_data_i_saa_aa [0:5];
    reg signed   [NBB-1:0]         read_data_i_sbb_bb [0:5];
    integer tb_o_sxx_xx_full_dir;
    integer tb_o_s11_11_over_trunc_dir;
    integer tb_o_s11_11_satu_trunc_dir;
    integer tb_s22_22_satu_round_dir;
    integer i;
    initial
    begin 
        $readmemb({path_dir,"py_i_saa_aa.txt"}, read_data_i_saa_aa);
        $readmemb({path_dir,"py_i_sbb_bb.txt"}, read_data_i_sbb_bb);
        tb_o_sxx_xx_full_dir       = $fopen({path_dir,"v_o_sxx_xx_full.txt"});
        tb_o_s11_11_over_trunc_dir = $fopen({path_dir,"v_o_s11_11_over_trunc.txt"});
        tb_o_s11_11_satu_trunc_dir = $fopen({path_dir,"v_o_s11_11_satu_trunc.txt"});
        tb_s22_22_satu_round_dir   = $fopen({path_dir,"v_o_s22_22_satu_round.txt"});

        for (i=0; i<5; i=i+1)
        begin
            i_saa_aa = read_data_i_saa_aa[i]; 
            i_sbb_bb = read_data_i_sbb_bb[i]; 
            o_sxx_xx_full_w <= o_sxx_xx_full;
            o_s11_11_over_trunc_w<=  o_s11_11_over_trunc;      
            o_s11_11_satu_trunc_w<=  o_s11_11_satu_trunc;    
            o_s22_22_satu_round_w<=  o_s22_22_satu_round;       
            #2;  
            o_sxx_xx_full_w <= o_sxx_xx_full;
            o_s11_11_over_trunc_w<=  o_s11_11_over_trunc;      
            o_s11_11_satu_trunc_w<=  o_s11_11_satu_trunc;    
            o_s22_22_satu_round_w<=  o_s22_22_satu_round;  
            #2;  
            $fdisplay(tb_o_sxx_xx_full_dir, "%b",o_sxx_xx_full_w);
            $fdisplay(tb_o_s11_11_over_trunc_dir, "%b",o_s11_11_over_trunc_w);
            $fdisplay(tb_o_s11_11_satu_trunc_dir, "%b",o_s11_11_satu_trunc_w);
            $fdisplay(tb_s22_22_satu_round_dir, "%b",o_s22_22_satu_round_w);
            #100;  
        end
        $fclose(tb_o_sxx_xx_full_dir);
        $fclose(tb_o_s11_11_over_trunc_dir);
        $fclose(tb_o_s11_11_satu_trunc_dir);
        $fclose(tb_s22_22_satu_round_dir);
    end

sumador_fixed
    u_sumador_fixed(
        .i_saa_aa(i_saa_aa), 
        .i_sbb_bb(i_sbb_bb),  
        .o_sxx_xx_full(o_sxx_xx_full),         
        .o_s11_11_over_trunc(o_s11_11_over_trunc),    
        .o_s11_11_satu_trunc(o_s11_11_satu_trunc),    
        .o_s22_22_satu_round(o_s22_22_satu_round)    
    );
endmodule