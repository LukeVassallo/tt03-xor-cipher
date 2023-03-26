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

module dual_xor_test_stimulus_1 #(parameter M=32) (
    input clk,
    input rst,
    
    input decrypted,
    output datastream, 
    
    output en,
    output cfg_en, 
    output cfg_o,
    
    input config_once,
    input cfg_i,
    output reg [4*M+1:0] cfg_reg,

    input [M-1:0] tx_lfsr_taps,
    input [M-1:0] tx_lfsr_state,
    input [M-1:0] rx_lfsr_taps,
    input [M-1:0] rx_lfsr_state,   
    
    // debug
    output reg [M-1:0] error_counter,
    output errors );
    
//parameter lfsr_taps_default = 64'h48000000;
//parameter lfsr_state_default = 64'h770000000;
parameter mux_ext_a = 1'b1;
parameter mux_en_d = 1'b0;

wire [4*M+1:0] cfg_next;
reg [10:0] cfg_cntr, run_cntr;  // run_cntr >> cfg_cntr

galois_lfsr uut_galois_lfsr_d (
    .clk(clk),
    .rst(rst),
    .en(en),
    .ld(1'b0),
    .taps(64'h60),    // PRBS-7
    .lfsr_i(64'h1),
    .lfsr_o(),
    .k(datastream)
);

always @(posedge clk) begin
    if (rst) begin
        cfg_reg <= {mux_ext_a, mux_en_d, tx_lfsr_taps, tx_lfsr_state, rx_lfsr_taps, rx_lfsr_state};
    end else begin
        cfg_reg <= cfg_next;
    end
end

always @(posedge clk) begin
    if (rst) begin
        cfg_cntr <= 11'b0;
    end else begin
        cfg_cntr <= cfg_en ? cfg_cntr + 1 : 16'b0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        run_cntr <= 11'b0;
    end else begin
        run_cntr <= run_cntr + 1;
    end
end

//assign cfg_next = (state_reg == state_init) ? {mux_ext_k,mux_ext_a,d_en_disabled,lfsr_taps_default, lfsr_state_default} : ((cfg_en) ? {cfg_i, cfg_reg[130:1]} : cfg_reg);
assign cfg_next = (state_reg == state_init) ? {mux_ext_a, mux_en_d, tx_lfsr_taps, tx_lfsr_state, rx_lfsr_taps, rx_lfsr_state} : ((cfg_en) ? {cfg_i, cfg_reg[4*M+1:1]} : cfg_reg);
assign cfg_o = cfg_reg[0];

// Test state machine 
reg [1:0] state_reg, state_next;

localparam [1:0]
    state_init = 2'b00, 
    state_cfg = 2'b01,
    state_en = 2'b10,
    state_finish = 2'b11;

always @(posedge clk) begin
    if (rst) begin
        state_reg <= state_init;
    end else begin
        state_reg <= state_next;
    end
end

always @(state_reg, cfg_cntr, run_cntr)
begin
    state_next <= state_reg; 
    
    case (state_reg) 
        state_init:
            if (run_cntr == 100) begin
                state_next <= state_cfg;
            end
            
        state_cfg:
            if (cfg_cntr == 4*M+1) begin // length of cfg reg - 1
                state_next <= state_en;
            end 
            
        state_en:
            if ((run_cntr == 1000)&& (!config_once)) begin
                state_next <= state_finish;
            end
            
        state_finish:
            if (run_cntr == 2047)  begin
                state_next <= state_init;
            end 
            
    endcase
end

assign en = (state_reg == state_en) ? 1'b1 : 1'b0;
assign cfg_en = (state_reg == state_cfg) ? 1'b1 : 1'b0;

always @(posedge clk) begin
    if (rst) begin
        error_counter <= 48'b0;
    end else begin
        if ((datastream != decrypted) && (en == 1'b1)) begin
            error_counter <= error_counter + 1;
        end
    end
end

assign errors = (error_counter != 48'b0) ? 1'b1 : 1'b0;

endmodule
