/*
Fundacion Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module top
#(
    parameter ORDER = 9,
    parameter SW    = 4,
    parameter LED    = 5,
    parameter SEEDI = 9'b110101010,
    parameter SEEDQ = 9'b111111110
)
(
    input               i_reset,
    input  [SW-1:0]     i_sw,
    input               clock,
    output [LED-1:0]    o_led
);
wire            s_valid;
wire            s_prbsI;
wire            s_prbsQ;
wire            s_enable_tx;
wire            s_enable_rx;
wire    [1:0]   s_mappedI;
wire    [1:0]   s_mappedQ;
wire    [9:0]   s_filterI;
wire    [9:0]   s_filterQ;
wire            s_syncI;
wire            s_syncQ;
wire    [1:0]   s_fase;
wire    [9:0]   s_dwnsmpI;
wire    [9:0]   s_dwnsmpQ;
wire            s_slicerI;
wire            s_slicerQ;

wire    [1:0]   s_delay_sis;
wire            s_ber_refI;
wire            s_ber_inI;
wire            s_berI;
wire            s_ber_refQ;
wire            s_ber_inQ;
wire            s_berQ;
assign s_enable_tx=i_sw[0];
assign s_enable_rx=i_sw[1];
assign s_fase = i_sw[3:0];
assign s_delay_sis = 2'b01;

control
    u_control
    (
    .i_reset(i_reset),
    .i_enable(s_enable_tx),
    .clock(clock),
    .o_valid(s_valid)
    );

prbs
    #(
    .ORDER(ORDER),
    .SEEDX(SEEDI)
    )
    u_prbsI
    (
    .i_reset(i_reset),
    .i_enable(s_enable_tx),
    .i_valid(s_valid),
    .clock(clock),
    .o_prbsx(s_prbsI)   
    );
prbs
    #(
    .ORDER(ORDER),
    .SEEDX(SEEDQ)
    )
    u_prbsQ
    (
    .i_reset(i_reset),
    .i_enable(s_enable_tx),
    .i_valid(s_valid),
    .clock(clock),
    .o_prbsx(s_prbsQ)   
    );
    
mapper
    u_mapperI(
    .i_reset(i_reset),
    .i_enable(s_enable_tx),
    .i_valid(s_valid),
    .i_symbolx(s_prbsI),
    .clock(clock),
    .o_mappedx(s_mappedI)
    );
    
mapper
    u_mapperQ(
    .i_reset(i_reset),
    .i_enable(s_enable_tx),
    .i_valid(s_valid),
    .i_symbolx(s_prbsQ),
    .clock(clock),
    .o_mappedx(s_mappedQ)
    );

rc_filter
    u_rc_filterI(
    .i_reset(i_reset),
    .i_enable(s_enable_tx),
    .i_valid(s_enable_tx),
    .i_mappedx(s_mappedI),
    .clock(clock),
    .o_filterx(s_filterI)
    );
rc_filter
    u_rc_filterQ(
    .i_reset(i_reset),
    .i_enable(s_enable_tx),
    .i_valid(s_enable_tx),
    .i_mappedx(s_mappedQ),
    .clock(clock),
    .o_filterx(s_filterQ)
    );
sync
    u_syncI(
    .i_reset(i_reset),
    .i_enable(s_enable_rx),
    .i_valid(s_valid),
    .i_rc_filter(s_filterI),
    .clock(clock),
    .o_sync(s_syncI)
    );
sync
    u_syncQ(
    .i_reset(i_reset),
    .i_enable(s_enable_rx),
    .i_valid(s_valid),
    .i_rc_filter(s_filterQ),
    .clock(clock),
    .o_sync(s_syncQ)
    );
    
 dwnsmp
    u_dwnsmpI(
    .i_reset(i_reset),
    .i_enable(s_enable_rx),
    .i_valid(s_enable_rx),
    .i_fase(s_fase),
    .i_rc_filter(s_filterI),
    .i_sync(s_syncI),
    .clock(clock),
    .o_dwnsmp(s_dwnsmpI)
    );
 dwnsmp
    u_dwnsmpQ(
    .i_reset(i_reset),
    .i_enable(s_enable_rx),
    .i_valid(s_enable_rx),
    .i_fase(s_fase),
    .i_rc_filter(s_filterQ),
    .i_sync(s_syncQ),
    .clock(clock),
    .o_dwnsmp(s_dwnsmpQ)
    );
slicer
    u_slicerI(
    .i_reset(i_reset),
    .i_enable(s_enable_rx),
    .i_valid(s_valid),
    .i_sync(s_syncQ),
    .i_dwnsmp(s_dwnsmpI),
    .clock(clock),
    .o_slicer(s_slicerI)
    );
slicer
    u_slicerQ(
    .i_reset(i_reset),
    .i_enable(s_enable_rx),
    .i_valid(s_valid),
    .i_sync(s_syncQ),
    .i_dwnsmp(s_dwnsmpQ),
    .clock(clock),
    .o_slicer(s_slicerQ)
    );
ber
    u_berI(
    .clock(clock),
    .i_reset(i_reset),
    .i_enable(s_enable_rx),
    .i_valid(s_valid),
    .i_delay_sis(s_delay_sis),
    .i_sync(s_syncI),
    .i_prbs(s_prbsI),
    .i_slicer(s_slicerI),
    .o_slicer(s_ber_inI),
    .o_prbs(s_ber_refI),
    .o_delay(),                     
    .o_ber(s_berI)
    );
ber
    u_berQ(
    .clock(clock),
    .i_reset(i_reset),
    .i_enable(s_enable_rx),
    .i_valid(s_valid),
    .i_delay_sis(s_delay_sis),
    .i_sync(s_syncQ),
    .i_prbs(s_prbsQ),
    .i_slicer(s_slicerQ),
    .o_slicer(s_ber_inQ),
    .o_prbs(s_ber_refQ),
    .o_delay(),                     
    .o_ber(s_berQ)
    );  
assign o_led[0]= i_reset;
assign o_led[1]= s_enable_tx;
assign o_led[2]= s_enable_rx;
assign o_led[3]= s_berI;
assign o_led[4]= s_berQ;

endmodule