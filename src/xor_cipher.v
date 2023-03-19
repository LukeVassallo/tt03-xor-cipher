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

parameter lfsr_taps_default = 32'h00000060;
parameter lfsr_state_default = 32'h00000055;
parameter k_mux_internal_lfsr = 1'b0;
parameter a_mux_internal_signature = 1'b0;
parameter d_en_disabled = 1'b0;

reg [66:0] cfg_reg;
wire [66:0] cfg_next;
wire [31:0] lfsr_o;

wire internal_lfsr_k;
wire internal_signature;

wire k;
wire a;

wire cfg_en_b;
assign cfg_en_b = !cfg_en;
wire ld;
wire k_mux, a_mux, d_en; 

assign k_mux = cfg_reg[66];
assign a_mux = cfg_reg[65];
assign d_en = cfg_reg[64]; 

always @(posedge clk) begin
    if (rst) begin
        cfg_reg <= {lfsr_taps_default, lfsr_state_default};
    end else begin
        cfg_reg <= cfg_next;
    end
end

assign cfg_next = (cfg_en) ? {cfg_i, cfg_reg[66:1]} : {k_mux_internal_lfsr, a_mux_internal_signature, d_en_disabled, cfg_reg[63:32], lfsr_o};

galois_lfsr uut_galois_lfsr (
    .clk(clk),
    .rst(rst),
    .en(cfg_en_b),
    .ld(ld),
    .taps(cfg_reg[63:32]),
    .lfsr_i(cfg_reg[31:0]),
    .lfsr_o(lfsr_o),
    .k(internal_lfsr_k)
);

signature uut_signature (
    .clk(clk),
    .reset(rst),
    .q(internal_signature)
);

counter uut_counter (
    .clk(clk),
    .rst(rst),
    .en(cfg_en),
    .trigger_count(67),
    .pulse(ld));

assign k = (k_mux == 1'b1) ? external_k : internal_lfsr_k;

assign a = (a_mux == 1'b1) ? data_stream : internal_signature;

assign e = a ^ k; 

assign d = (d_en == 1'b1) ? e ^ k : 1'b0;

assign cfg_o = cfg_reg[0];

endmodule
