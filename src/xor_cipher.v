module xor_cipher (
    input clk,
    input rst, 
    
    input data_stream,
    input external_k,
    
    output e,
    output d,
    
    input cfg_en,
    input cfg_i,
    output cfg_o );

parameter taps = 32'h00000060;
//reg cfg[64:0] = {1'b0, lfsr, taps};

wire internal_lfsr_k;
wire internal_signature;

galois_lfsr uut_galois_lfsr (
    .clk(clk),
    .rst(rst),
    .taps(32'h60),
    .k(internal_lfsr_k)
);

signature uut_signature (
    .clk(clk),
    .reset(rst),
    .q(internal_signature)
);

assign k = internal_lfsr_k;

assign a = internal_signature;

assign e = a ^ k; 

assign d = e ^ k;

assign cfg_o = 1'b0;

endmodule