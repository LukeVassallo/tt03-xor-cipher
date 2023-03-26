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

module signature (
input clk,
input reset,
input ld,
input en,
output q );

reg [319:0] signature = 320'b01001100011101010110101101100101001000000101011001100001011100110111001101100001011011000110110001101111001000000101010001101001011011100111100100100000010101000110000101110000011001010110111101110101011101000010000000110010001100000011001000110011001011110011000000110011001011110011001000110100001011100000110100001010;
reg [8:0] counter = 0;
wire [8:0] counter_next;

always @(posedge clk, posedge reset) begin
    if (reset) begin
        counter = 9'h13F;
    end else begin 
        counter <= counter_next;
    end
end

assign counter_next = (ld == 1'b1) ? 9'h13F : ( (en == 1'b1) ? ( (counter == 0) ? 9'h13F : counter - 1) : counter );

assign q = signature[counter];

endmodule
