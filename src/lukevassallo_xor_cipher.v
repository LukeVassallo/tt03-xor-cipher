module lukevassallo_xor_cipher (
input [7:0] io_in,
output [7:0] io_out );

//xor_cipher uut (
//    .clk(io_in[0]),
//    .rst(io_in[1]),
  
//    .data_stream(io_in[2]),
//    .external_k(io_in[3]),
    
//    .e(io_out[0]),
//    .d(io_out[1]),
    
//    .cfg_en(io_in[4]),
//    .cfg_i(io_in[5]),
//    .en(io_in[6]),
//    .cfg_o(io_out[2]),
//    .heartbeat(io_out[7:3])
//);
dual_xor_stream_cipher #( .M(32) ) uut  (
    .clk(io_in[0]),
    .rst(io_in[1]),
    .tx_p(io_in[2]),
    .rx_e(io_in[3]),
    .cfg_en(io_in[4]),
    .cfg_i(io_in[5]),
    .tx_en(io_in[6]),
    .rx_en(io_in[7]),
    
    .tx_e(io_out[0]),
    .rx_p(io_out[1]),
    .dbg_tx_p(io_out[2]),
    .dbg_rx_e(io_out[3]), 

    .cfg_o(io_out[4]),
    .heartbeat(io_out[7:5])
);
endmodule
