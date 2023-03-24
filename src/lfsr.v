module galois_lfsr 
#(parameter N=48)
(
    input clk,
    input rst,
    input en, 
    input [N-1:0] taps,
    input ld,
    input [N-1:0] lfsr_i,
    output [N-1:0] lfsr_o,
    output k
);

wire [N-1:0] lfsr_next;
reg [N-1:0] lfsr_reg;

// rising edge detector 
//reg prev_signal; // register to store previous value of signal
//always @(posedge clk, posedge rst) begin
//    if (rst) begin
//        ld <= 1'b0;       // reset output to zero
//        prev_signal <= en; // reset previous signal value
//    end else begin
//        if (en == 1'b1 && prev_signal == 1'b0) begin
//            ld <= 1'b1;  // set output to 1 when rising edge detected
//        end else begin
//            ld <= 1'b0;  // set output to 0 otherwise
//        end
//        prev_signal <= en; // store current signal value as previous value
//    end
//end

always @(posedge clk) begin
    if (rst) begin        
        lfsr_reg <= lfsr_i;
    end else begin
        lfsr_reg <= lfsr_next;
     end
end

assign lfsr_next = (ld==1'b1) ? lfsr_i : (en==1'b1) ? (lfsr_reg[0] ? (lfsr_reg >> 1) ^ taps : (lfsr_reg >> 1)) : lfsr_reg;

assign k = lfsr_reg[0];

assign lfsr_o = lfsr_reg;

endmodule