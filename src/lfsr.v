module galois_lfsr (
    input clk,
    input rst,
    input [31:0] taps,
    output k
);

wire [31:0] lfsr_next;
reg [31:0] lfsr_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin        
        lfsr_reg <= 32'h55; //32'b11111111111111111111111111111111;
    end else begin
        lfsr_reg <= lfsr_next;
     end
end

assign lfsr_next = lfsr_reg[0] ? (lfsr_reg >> 1) ^ taps : (lfsr_reg >> 1);

assign k = lfsr_reg[0];

endmodule