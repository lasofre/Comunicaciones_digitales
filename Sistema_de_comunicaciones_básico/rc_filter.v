/*
Fundacion Fulgor.
Asignatura: Dise�o Digital.
Trabajo practico: 5
Alumno: Bucca Matias.
titulo:
descripcion: 
notas:
*/
module rc_filter
#(
    parameter OS    = 4,
    parameter TAPS  = 6,
    parameter S_COEF= 8,
    parameter S_IN  = 2,
    parameter S_OUT = S_COEF+ S_IN
)
(
    input                    i_reset,
    input                    i_enable,
    input                    i_valid,
    input signed  [S_IN-1:0] i_mappedx,
    input                    clock,
    output signed [S_OUT-1:0]o_filterx
);
integer i;
genvar k;
genvar j;
localparam  CONT = $clog2(OS)-1 ;
localparam  SUM_OUT = $clog2(TAPS);
reg [CONT:0]         r_cont;
reg          [(TAPS*S_IN)-1:0]   r_shift;
wire signed  [S_COEF-1:0]        r_coef        [0:(TAPS*OS)-1];
wire signed  [S_COEF-1:0]        s_mux         [0:TAPS-1][0:OS-1];
wire signed  [S_OUT-1:0]         s_prod        [0:TAPS-1]; 
wire signed  [S_OUT+SUM_OUT:0]   s_sum_out     [0:TAPS];    



//--------------- Contador
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            r_cont<={CONT{1'b0}};     
        end
        else begin
            if (r_cont<(OS) && i_enable && i_valid) begin
                r_cont<=r_cont+1'b1; 
            end
            else begin
                r_cont<={CONT{1'b0}};  
            end
        end
    end
//--------------- Shift register
always @(posedge clock or negedge i_reset) 
    begin
        if (!i_reset) begin
            r_shift<={(TAPS*S_IN)-1{1'b0}};      
        end
        else begin
            if (r_cont == (OS-1) && i_enable && i_valid)begin
                r_shift<={r_shift[(TAPS*S_IN)-1-S_IN:0],i_mappedx};
            end
         end
 end
//------------ Registro de coeficientes

assign r_coef[0]= 8'b00000000;
assign r_coef[1]= 8'b00000001;
assign r_coef[2]= 8'b00000010;
assign r_coef[3]= 8'b00000011;
assign r_coef[4]= 8'b00000000;
assign r_coef[5]= 8'b11111001;
assign r_coef[6]= 8'b11110001;
assign r_coef[7]= 8'b11110000;
assign r_coef[8]= 8'b00000000;
assign r_coef[9]= 8'b00100010;
assign r_coef[10]=8'b01001101;
assign r_coef[11]=8'b01110010;
assign r_coef[12]=8'b01111111;
assign r_coef[13]=8'b01110010;
assign r_coef[14]=8'b01001101;
assign r_coef[15]=8'b00100010;
assign r_coef[16]=8'b00000000;
assign r_coef[17]=8'b11110000;
assign r_coef[18]=8'b11110001;
assign r_coef[19]=8'b11111001;
assign r_coef[20]=8'b00000000;
assign r_coef[21]=8'b00000011;
assign r_coef[22]=8'b00000010;
assign r_coef[23]=8'b00000001;


//------------ multiplexores
generate
for ( k=0 ; k< TAPS ; k=k+1) begin
    for ( j=0 ; j< OS ; j=j+1) begin
         assign s_mux[k][j] = r_coef[(TAPS*OS-1)-((OS)*k+j)];
    end
end
endgenerate


generate
for ( k=0 ; k < TAPS ; k=k+1) begin
           assign s_prod[k] = s_mux[k][r_cont] *$signed(r_shift[(k*S_IN)+1:(k*S_IN)]);
        end
endgenerate

assign s_sum_out[0] = s_prod[0];

generate 
for ( k=0 ; k< (TAPS) ; k=k+1) begin
           assign s_sum_out[k+1] = s_prod[k+1] + s_sum_out[k];
        end
endgenerate



assign o_filterx =s_sum_out[TAPS-1]; 

endmodule