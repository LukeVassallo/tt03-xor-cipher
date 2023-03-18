module lukevassallo_xor_cipher (
input [7:0] io_in,
output [7:0] io_out );

xor_chiper uut (
    .clk(io_in[0]),
    .rst(io_in[1]),
  
    .data_stream(io_in[2]),
    .external_k(io_in[3]),
    
    .e(io_out[0]),
    .d(io_in[1]),
    
    .cfg_en(io_in[4]),
    .cfg_i(io_in[5]),
    .cfg_o(io_out[2])
);

endmodule