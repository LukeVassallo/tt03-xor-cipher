module xor_cipher (
    input clk,
    input rst, 
    
    input data_stream,
    input external_k,
    
    output e,
    output d,
    
    input cfg_en,
    input cfg_i,
    input en,
    output cfg_o,
    output [4:0] heartbeat );

parameter lfsr_taps_default = 64'h0000000048000000;
parameter lfsr_state_default = 64'h00000000000000055;
parameter k_mux_internal_lfsr = 1'b0;
parameter a_mux_internal_signature = 1'b0;
parameter d_en_disabled = 1'b0;

reg [130:0] cfg_reg;
wire [130:0] cfg_next;
wire [63:0] lfsr_o;

wire internal_lfsr_k;
wire internal_signature;

wire k;
wire a;

wire cfg_en_b;
assign cfg_en_b = !cfg_en;
wire ld;
wire k_mux, a_mux, d_en; 
wire [15:0] heartbeat_count;
wire combined_en;
assign combined_en = en & cfg_en_b;

assign k_mux = cfg_reg[130];
assign a_mux = cfg_reg[129];
assign d_en = cfg_reg[128]; 

always @(posedge clk) begin
    if (rst) begin
        cfg_reg <= {k_mux_internal_lfsr, a_mux_internal_signature, d_en_disabled, lfsr_taps_default, lfsr_state_default};
    end else begin
        cfg_reg <= cfg_next;
    end
end

assign cfg_next = (cfg_en) ? {cfg_i, cfg_reg[130:1]} : {cfg_reg[130:64], lfsr_o};

galois_lfsr uut_galois_lfsr (
    .clk(clk),
    .rst(rst),
    .en(combined_en),
    .ld(ld),
    .taps(cfg_reg[127:64]),
    .lfsr_i(cfg_reg[63:0]),
    .lfsr_o(lfsr_o),
    .k(internal_lfsr_k)
);

signature uut_signature (
    .clk(clk),
    .reset(rst),
    .en(combined_en),
    .q(internal_signature)
);

counter uut_counter (
    .clk(clk),
    .rst(rst),
    .en(cfg_en),
    .trigger_count(16'd130),
    .count(),
    .pulse(ld));
    
counter uut_heartbeat_counter (
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .trigger_count(16'hFFFF),
    .count(heartbeat_count),
    .pulse());

assign k = (k_mux == 1'b1) ? external_k : internal_lfsr_k;

assign a = (a_mux == 1'b1) ? data_stream : internal_signature;

assign e = (cfg_en == 1'b0) ? a ^ k : 1'b0; 

assign d = (cfg_en == 1'b0) ? ((d_en == 1'b1) ? e ^ k : 1'b0) : 1'b0;

assign cfg_o = (cfg_en == 1'b1) ? cfg_reg[0] : 1'b0;

assign heartbeat = heartbeat_count[9:5];

endmodule
