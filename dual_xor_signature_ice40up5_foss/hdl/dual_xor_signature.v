module dual_xor_signature (
    input rst,
    input stream_select,
    output encrypted,
    output decrypted,
    output uart_txd
    );
wire clk_48mhz, clk16;

wire stimuli_cfg_i, stimuli_cfg_o, cfg_en;
wire start_pulse;

wire encrypted; // loopback
wire decrypted;
wire [7:0] decrypted_byte;
wire [7:0] encrypted_byte;
wire busy;

wire [7:0] uart_byte;
wire uart_tx_en;

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


dual_xor_test_stimulus_2 #(.M(32)) dual_xor_test_stimulus_2_0 (
    .clk(clk16),
    .rst(rst),
    .cfg_i(stimuli_cfg_i),
    .tx_lfsr_taps(32'h48000000),
    .tx_lfsr_state(32'h55),
    .rx_lfsr_taps(32'h48000000),
    .rx_lfsr_state(32'h55),
    .cfg_en(cfg_en),
    .cfg_o(stimuli_cfg_o),
    .cfg_reg(),
    .start_pulse(start_pulse)
);

serial2parallel serial2parallel_0 (
    .clk(clk16),
    .rst(rst),
    .start(start_pulse),
    .d(decrypted),
    .a(decrypted_byte),
    .conversion_start(),
    .conversion_finish(),
    .conversion_finish_dly(uart_tx_en),
    .module_busy(busy)
);

serial2parallel serial2parallel_1 (
    .clk(clk16),
    .rst(rst),
    .start(start_pulse),
    .d(encrypted),
    .a(encrypted_byte),
    .conversion_start(),
    .conversion_finish(),
    .conversion_finish_dly(),
    .module_busy()
);

dual_xor_stream_cipher #(.M(32)) dualxor_stream_cipher_0 (
    .clk(clk16),
    .rst(rst),
    .tx_p(1'b1),
    .rx_e(encrypted),
    .cfg_en(cfg_en),
    .cfg_i(stimuli_cfg_o),
    .tx_en(busy),
    .rx_en(busy),
    .tx_e(encrypted),
    .rx_p(decrypted),
    .dbg_tx_p(),
    .dbg_rx_e(),
    .cfg_o(stimuli_cfg_i),
    .heartbeat(heartbeat)
);

mux mux_0(
    .a(decrypted_byte),
    .b(encrypted_byte),
    .c(uart_byte),
    .sel(stream_select)
);

uart_tx #( .BIT_RATE(115200), .CLK_HZ(16_000_000) ) uart_tx_0 (
    .clk(clk16),
    .resetn(!rst),
    .uart_tx_en(uart_tx_en),
    .uart_tx_data(uart_byte),
    .uart_txd(uart_txd),
    .uart_tx_busy()
);

endmodule
