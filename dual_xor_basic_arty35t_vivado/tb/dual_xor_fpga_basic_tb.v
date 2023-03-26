`timescale 1ns / 1ns

module dual_xor_signature_tb;

reg clk;
reg rst;

dual_xor_fpga_basic_wrapper #(.M(32), .tx_cntr_period(2000))uut (
    .clk(clk),
    .rst(rst)
);

initial begin
    clk = 0;
    rst = 1;
    #100 rst = 0;
end

always #5 clk = ~clk;


endmodule
