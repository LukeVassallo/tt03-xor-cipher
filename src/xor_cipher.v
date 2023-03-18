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

reg [63:0] cfg_reg;
wire [63:0] cfg_next;
wire [31:0] lfsr_o;

wire internal_lfsr_k;
wire internal_signature;

wire k;
wire a;

wire cfg_en_b;
assign cfg_en_b = !cfg_en;


always @(posedge clk, posedge rst) begin
    if (rst) begin
        cfg_reg <= {lfsr_taps_default, lfsr_state_default};
    end else begin
        cfg_reg <= cfg_next;
    end
end

assign cfg_next = (cfg_en) ? {cfg_i, cfg_reg[63:1]} : {cfg_reg[63:32], lfsr_o};


galois_lfsr uut_galois_lfsr (
    .clk(clk),
    .rst(rst),
    .en(cfg_en_b),
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

assign k = internal_lfsr_k;

assign a = internal_signature;

assign e = a ^ k; 

assign d = e ^ k;

assign cfg_o = cfg_reg[0];

endmodule
