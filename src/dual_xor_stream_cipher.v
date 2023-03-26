// Copyright 2023 Luke Vassallo
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module dual_xor_stream_cipher #(parameter M = 32)(
    input clk,
    input rst, 
    
    input tx_p,
    input rx_e,

    output tx_e,
    output rx_p,    
    output dbg_tx_p,
    output dbg_rx_e,
    
    input cfg_en,
    input cfg_i,
    input tx_en,
    input rx_en,
    output cfg_o,
    output [2:0] heartbeat );

parameter tx_lfsr_taps_default = {M{32'h48000000}};
parameter tx_lfsr_state_default = {M{32'h000000055}};
parameter rx_lfsr_taps_default = {M{32'h48000000}};
parameter rx_lfsr_state_default = {M{32'h000000055}};
parameter a_mux_internal_signature = 1'b0;
parameter d_en_disabled = 1'b0;

reg [4*M+1:0] cfg_reg;
wire [4*M+1:0] cfg_next;
wire [M-1:0] tx_lfsr_o,rx_lfsr_o;

wire internal_signature;

wire k;
wire a;

wire cfg_en_b;
assign cfg_en_b = !cfg_en;
wire ld;
wire k_mux, a_mux, d_en; 
wire [15:0] heartbeat_count;
wire combined_tx_en, combined_rx_en;
assign combined_tx_en = tx_en & cfg_en_b;
assign combined_rx_en = rx_en & cfg_en_b;

assign a_mux = cfg_reg[4*M+1];
assign d_en = cfg_reg[4*M]; 

wire tx_lfsr_k, rx_lfsr_k;

always @(posedge clk) begin
    if (rst) begin
        cfg_reg <= {a_mux_internal_signature, d_en_disabled, tx_lfsr_taps_default, tx_lfsr_state_default, rx_lfsr_taps_default, rx_lfsr_state_default};
    end else begin
        cfg_reg <= cfg_next;
    end
end

assign cfg_next = (cfg_en) ? {cfg_i, cfg_reg[4*M+1:1]} : {cfg_reg[4*M+1:4*M], cfg_reg[4*M-1:3*M], tx_lfsr_o, cfg_reg[2*M-1:M], rx_lfsr_o};

galois_lfsr #( .N(M) ) uut_tx_galois_lfsr
(
    .clk(clk),
    .rst(rst),
    .en(combined_tx_en),
    .ld(ld),
    .taps(cfg_reg[4*M-1:3*M]),
    .lfsr_i(cfg_reg[3*M-1:2*M]),
    .lfsr_o(tx_lfsr_o),
    .k(tx_lfsr_k)
);

galois_lfsr #( .N(M) ) uut_rx_galois_lfsr (
    .clk(clk),
    .rst(rst),
    .en(combined_rx_en),
    .ld(ld),
    .taps(cfg_reg[2*M-1:M]),
    .lfsr_i(cfg_reg[M-1:0]),
    .lfsr_o(rx_lfsr_o),
    .k(rx_lfsr_k)
);

signature uut_signature (
    .clk(clk),
    .reset(rst),
    .ld(ld),
    .en(combined_tx_en),
    .q(internal_signature)
);

counter uut_counter (
    .clk(clk),
    .rst(rst),
    .en(cfg_en),
    .trigger_count( 16'd4*M+2 ), // This is correct. 
    .count(),
    .pulse(ld));
    
counter uut_heartbeat_counter (
    .clk(clk),
    .rst(rst),
    .en(1'b1),
    .trigger_count(16'hFFFF),
    .count(heartbeat_count),
    .pulse());

//assign k = (k_mux == 1'b1) ? external_k : internal_lfsr_k;
wire txp;

assign txp = (a_mux == 1'b1) ? tx_p : internal_signature;

assign tx_e = (cfg_en == 1'b0) ? txp ^ tx_lfsr_k : 1'b0; 

assign rx_p = (cfg_en == 1'b0) ? rx_e ^ rx_lfsr_k : 1'b0; 

//assign d = (cfg_en == 1'b0) ? ((d_en == 1'b1) ? e ^ k : 1'b0) : 1'b0;
assign dbg_tx_p = (cfg_en == 1'b0) ? ((d_en == 1'b1) ? tx_e ^ tx_lfsr_k : 1'b0) : 1'b0;
assign dbg_rx_e = (cfg_en == 1'b0) ? ((d_en == 1'b1) ? rx_p ^ rx_lfsr_k : 1'b0) : 1'b0;

assign cfg_o = (cfg_en == 1'b1) ? cfg_reg[0] : 1'b0;

assign heartbeat = heartbeat_count[9:7];

endmodule
