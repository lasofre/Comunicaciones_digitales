/*
Fundacion Fulgor.
Asignatura: Diseï¿½o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module ber
#(
    parameter RX_DELAY = 4,
    parameter BUFFER = 16,
    parameter DELAY = $clog2(BUFFER),
    parameter SDELAY = $clog2(RX_DELAY)
)
(   
    input                     clock,
    input                     i_reset,
    input                     i_enable,
    input                     i_valid,
    input  [SDELAY-1:0]       i_delay_sis,
    input                     i_sync,
    input                     i_prbs,
    input                     i_slicer,
    output reg                o_slicer,
    output reg                o_prbs,
    output reg                o_delay,                     
    output reg                o_ber
);
reg [SDELAY-1:0]    r_sis_delay;
reg [DELAY-1:0]     r_delay;
reg [BUFFER-1:0]    r_buffer;
reg                 s_star_comp;
//------------- delay
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            r_delay<={DELAY{1'b0}};     
        end
        else if ((r_delay<{DELAY{1'b1}}) && (!s_star_comp) && i_valid ) begin  //---- en implementación
        //else if ((r_delay<{DELAY{1'b1}}) && (!i_sync)) begin
                r_delay<=r_delay+1'b1; 
            end
    end
//------------- Carga de buffer
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            r_buffer<={BUFFER{1'b0}};     
        end
        else begin
        if(i_valid && i_enable)begin
            r_buffer<={r_buffer[BUFFER-2:0],i_prbs};
        end
        end
end
//------------ delay de sistema de recepción
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            r_sis_delay<={SDELAY{1'b0}};     
        end
        else if(r_sis_delay<{SDELAY{1'b1}} && i_sync && i_valid ) begin
            r_sis_delay<=r_sis_delay+1'b1;
        end
end
//------------ start_reg reset
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            s_star_comp<=1'b0; 
             end
        //else if (r_sis_delay == {SDELAY{1'b1}}) begin
        else if (r_sis_delay == i_delay_sis  && i_sync && i_valid ) begin
             s_star_comp<=1'b1;
        end

end
//------------ comparación
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            o_slicer<=1'b0;
            o_prbs<=1'b0;
            o_delay<=1'b0;                     
            o_ber<=1'b0;    
        end
        else if(s_star_comp && i_valid && i_enable) begin
        //else if(i_sync) begin
            o_slicer<=i_slicer;
            o_prbs<=r_buffer[r_delay-2];
            o_delay<=r_delay;
            if(i_slicer == r_buffer[r_delay-2])begin                    
                o_ber<=1'b1;
            end
            else begin
                o_ber<=1'b0;
           end
        end
end
endmodule