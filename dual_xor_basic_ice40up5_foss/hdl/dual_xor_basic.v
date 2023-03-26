module dual_xor_basic (
    input rst,
    input config_once,
    output plaintext,
    output encrypted,
    output decrypted,
    output led_r
    );
    
wire clk_48mhz, clk16;
wire stimuli_cfg_i, stimuli_cfg_o, cfg_en;
wire plaintext, en;
wire errors;

wire encrypted; // loopback
wire decrypted;
wire [7:0] decrypted_byte;
wire [7:0] encrypted_byte;


SB_HFOSC SB_HFOSC_inst(
    .CLKHFEN(1),
    .CLKHFPU(1),
    .CLKHF(clk_48mhz)
);

SB_PLL40_CORE #(
.FEEDBACK_PATH("SIMPLE"),
.PLLOUT_SELECT("GENCLK"),
.DIVR(4'b0010),
.DIVF(7'b0111111),
.DIVQ(3'b110),
.FILTER_RANGE(3'b001),
) SB_PLL40_CORE_inst (
.RESETB(1'b1),
.BYPASS(1'b0),
.PLLOUTCORE(clk16),
.REFERENCECLK(clk_48mhz)
);

dual_xor_test_stimulus_1 #(.M(32)) dual_xor_test_stimulus_1_0 (
    .clk(clk16),
    .rst(rst),
    .decrypted(decrypted),
    .datastream(plaintext),
    .en(en),
    .cfg_en(cfg_en),
    .cfg_o(stimuli_cfg_o),
    .config_once(config_once),
    .cfg_i(stimuli_cfg_i),
    .cfg_reg(),
    .tx_lfsr_taps(32'h48000000),
    .tx_lfsr_state(32'h55),
    .rx_lfsr_taps(32'h48000000),
    .rx_lfsr_state(32'h55),
    .error_counter(),
    .errors(errors)
);

assign led_r = !errors;

dual_xor_stream_cipher #(.M(32)) dualxor_stream_cipher_0 (
    .clk(clk16),
    .rst(rst),
    .tx_p(plaintext),
    .rx_e(encrypted),
    .cfg_en(cfg_en),
    .cfg_i(stimuli_cfg_o),
    .tx_en(en),
    .rx_en(en),
    .tx_e(encrypted),
    .rx_p(decrypted),
    .dbg_tx_p(),
    .dbg_rx_e(),
    .cfg_o(stimuli_cfg_i),
    .heartbeat(heartbeat)
);

endmodule
