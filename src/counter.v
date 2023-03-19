module counter (
    input clk,
    input rst,
    input en,
    input [15:0] trigger_count,
    output reg [15:0] count,
    output pulse
);

wire [15:0] count_next;

always @(posedge clk) begin
    if (rst) begin
        count <= 16'b0;
    end else begin
        count <= count_next;
    end
end

assign pulse = (count == trigger_count) ? 1'b1 : 1'b0; 
assign count_next = (en) ? count + 1 : 0;


endmodule
