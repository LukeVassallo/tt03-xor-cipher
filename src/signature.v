module signature (
input clk,
input reset,
input ld,
input en,
output q );

reg [255:0] signature = 256'b0100110001110101011010110110010100100000010101100110000101110011011100110110000101101100011011000110111100100000010101000110100101101110011110010010000001010100011000010111000001100101011011110111010101110100001000000011001000110000001100100011001100101110;
reg [7:0] counter = 0;
wire counter_next;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        counter = 8'hFF;
    end else begin 
        counter <= counter_next;
    end
end

assign counter_next = (ld == 1'b1) ? 8'hFF : ( (en == 1'b1) ? counter - 1 : counter );

assign q = signature[counter];

endmodule