/*
Fundación Fulgor.
Asignatura: Diseño Digital.
Trabajo practico n°4
Alumno: Bucca Matias.
titulo: tb_multiplicador_fixed
descripción: Descripcón para el sumador de punto fijo parametrizado.
notas:
*/
module sumador_fixed 
#(
    parameter NBA  =16, parameter  NBFA  =14, // Entrada A S(xx,xx)
    parameter NBB  =12, parameter  NBFB  =11, // Entrada B S(xx,xx)
    parameter NBS1 =11,  parameter NBFS1 =10, // Salida  1 S(xx,xx)
    parameter NBS2 =9 ,  parameter NBFS2 =8   // Salida  2 S(xx,xx)
)
(
    input signed   [NBA-1:0]  i_saa_aa,              //S(16,14) S,E,14D
    input signed   [NBB-1:0]  i_sbb_bb,              //S(12,11) S,11D
    output signed  [NBA:0]    o_sxx_xx_full,         //S(17,14)C,S,E,14D
    output signed  [NBS1-1:0] o_s11_11_over_trunc,   //S(11,10)
    output signed  [NBS1-1:0] o_s11_11_satu_trunc,   //S(11,10)
    output signed  [NBS2-1:0] o_s22_22_satu_round    //S(9,8)
);
localparam NEA   =  NBA  - NBFA;
localparam NEB   =  NBB  - NBFB;
localparam NES1  =  NBS1 - NBFS1;
localparam NES2  =  NBS2 - NBFS2;

localparam DOT   =  NEA-NBFA-1;

localparam DEAB  =  NEA  - NEB;
localparam DFAB  =  NBFA - NBFB;


wire signed [NBA  :0] s_full;
wire signed [NBA-1:0] s_aj_sbb_bb;
wire signed [NBS1 :0] s_trunc_sat;

wire signed [NBS2  :0] s_s22_22;
wire signed [NBS2+1:0] s_s22_22_round;
wire signed [NBS2-1:0]  s_s22_22_round_satu;

assign s_aj_sbb_bb = {{DEAB{i_sbb_bb[NBB-1]}},i_sbb_bb,{DFAB{1'b0}}}; 

assign s_full = i_saa_aa + s_aj_sbb_bb; // Se puede usar $signed()

assign s_trunc_sat = &s_full[NBA : NEA-DOT-NES1] || ~|s_full[NBA : NEA-DOT-NES1] ? s_full[NEA-DOT-NES1 -: NBS1]:
                     &s_full[NBA]                                                ? {1'b1,{10{1'b0}}} : 
                                                                                   {1'b0,{10{1'b1}}} ; 

assign s_s22_22 = s_full[NEA-DOT-NES2 -:NBS2+1];
assign s_s22_22_round = s_s22_22 + 1'b1;

assign s_s22_22_round_satu = &s_s22_22_round[NBS2+1:NBS2] || ~|s_s22_22_round[NBS2+1:NBS2] ? s_s22_22_round[NBS2:1] :
                             &s_s22_22_round[NBS2+1]                            ? {1'b1,{NBFS2{1'b0}}} : 
                                                                              {1'b0,{NBFS2{1'b1}}} ; 

assign o_sxx_xx_full = s_full;
assign o_s11_11_over_trunc = s_full[NEA-DOT-NES1 -: NBS1];
assign o_s11_11_satu_trunc = s_trunc_sat;
assign o_s22_22_satu_round = s_s22_22_round_satu;

endmodule