/*
Fundación Fulgor.
Asignatura: Diseño Digital.
Trabajo practico n°4
Alumno: Bucca Matias.
titulo: tb_multiplicador_fixed
descripción: Descripción para el multiplicador de punto fijo parametrizado.
notas:
*/
module multiplicador_fixed 
#(
    parameter NBA  =12, parameter  NBFA  =11, // Entrada A S(xx,xx)
    parameter NBB  =08, parameter  NBFB  =06,  // Entrada B S(xx,xx)
    parameter NBS1 =12, parameter  NBFS1 =11, // Salida  1 S(xx,xx)
    parameter NBS2 =10 , parameter NBFS2 =09   // Salida  2 S(xx,xx)
)
(
    input signed   [NBA-1:0]        i_saa_aa,              
    input signed   [NBB-1:0]        i_sbb_bb,              
    output signed  [NBA+NBB-1 :0]   o_sxx_xx_full,        
    output signed  [NBS1-1:0]       o_s11_11_over_trunc,   
    output signed  [NBS1-1:0]       o_s11_11_satu_trunc,   
    output signed  [NBS2-1:0]       o_s22_22_satu_round    
);
localparam NEA   =  NBA  - NBFA;
localparam NEB   =  NBB  - NBFB;
localparam NES1  =  NBS1 - NBFS1;
localparam NES2  =  NBS2 - NBFS2;
localparam NEM   =  NBA+NBB -1;
localparam DOT   =  NEM-NBFA-NBFB-1;

wire signed [NEM:0]    s_full;
wire signed [NBS1 :0]  s_trunc_sat;

wire signed [NBS2  :0] s_s22_22;
wire signed [NBS2+1:0] s_s22_22_round;
wire signed [NBS2-1:0] s_s22_22_round_satu;



assign s_full = i_saa_aa * i_sbb_bb;

assign s_trunc_sat = &s_full[NEM : NEM-DOT-NES1] || ~|s_full[NEM : NEM-DOT-NES1] ? s_full[NEM-DOT-NES1 -: NBS1]:
                     &s_full[NEM]                                                ? {1'b1,{10{1'b0}}} : 
                                                                                   {1'b0,{10{1'b1}}} ; 

assign s_s22_22 = s_full[NEM-DOT-NES2 -:NBS2+1];
assign s_s22_22_round = s_s22_22 + 1'b1;

assign s_s22_22_round_satu = &s_s22_22_round[NBS2+1:NBS2] || ~|s_s22_22_round[NBS2+1:NBS2] ? s_s22_22_round[NBS2:1] :
                             &s_s22_22_round[NBS2+1]                            ? {1'b1,{NBFS2{1'b0}}} : 
                                                                                  {1'b0,{NBFS2{1'b1}}} ; 

assign o_sxx_xx_full = s_full;
assign o_s11_11_over_trunc = s_full[NEM-DOT-NES1 -: NBS1];
assign o_s11_11_satu_trunc = s_trunc_sat;
assign o_s22_22_satu_round = s_s22_22_round_satu;

endmodule