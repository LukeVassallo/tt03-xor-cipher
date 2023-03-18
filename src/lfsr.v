module galois_lfsr (
    input clk,
    input rst,
    input en, 
    input [31:0] taps,
    input [31:0] lfsr_i,
    output [31:0] lfsr_o,
    output k
);

wire [31:0] lfsr_next;
reg [31:0] lfsr_reg;
reg ld; 


// rising edge detector 
reg prev_signal; // register to store previous value of signal
always @(posedge clk, posedge rst) begin
    if (rst) begin
        ld <= 1'b0;       // reset output to zero
        prev_signal <= en; // reset previous signal value
    end else begin
        if (en == 1'b1 && prev_signal == 1'b0) begin
            ld <= 1'b1;  // set output to 1 when rising edge detected
        end else begin
            ld <= 1'b0;  // set output to 0 otherwise
        end
        prev_signal <= en; // store current signal value as previous value
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin        
        //lfsr_reg <= 32'h55; //32'b11111111111111111111111111111111;
        lfsr_reg <= lfsr_i;
    end else begin
        if (en == 1'b1) begin
            lfsr_reg <= lfsr_next;
        end
     end
end

assign lfsr_next = (ld==1'b1) ? lfsr_i : (lfsr_reg[0] ? (lfsr_reg >> 1) ^ taps : (lfsr_reg >> 1));

assign k = lfsr_reg[0];

assign lfsr_o = lfsr_next;

endmodule