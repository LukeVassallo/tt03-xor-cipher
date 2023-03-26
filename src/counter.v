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

// Author : Luke Vassallo
// Notes  : A general purpose up counter with a configurable single-cycle 
//          output pulse.

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
