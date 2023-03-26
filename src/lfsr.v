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

module galois_lfsr 
#(parameter N=48)
(
    input clk,
    input rst,
    input en, 
    input [N-1:0] taps,
    input ld,
    input [N-1:0] lfsr_i,
    output [N-1:0] lfsr_o,
    output k
);

wire [N-1:0] lfsr_next;
reg [N-1:0] lfsr_reg;

// rising edge detector 
//reg prev_signal; // register to store previous value of signal
//always @(posedge clk, posedge rst) begin
//    if (rst) begin
//        ld <= 1'b0;       // reset output to zero
//        prev_signal <= en; // reset previous signal value
//    end else begin
//        if (en == 1'b1 && prev_signal == 1'b0) begin
//            ld <= 1'b1;  // set output to 1 when rising edge detected
//        end else begin
//            ld <= 1'b0;  // set output to 0 otherwise
//        end
//        prev_signal <= en; // store current signal value as previous value
//    end
//end

always @(posedge clk) begin
    if (rst) begin        
        lfsr_reg <= lfsr_i;
    end else begin
        lfsr_reg <= lfsr_next;
     end
end

assign lfsr_next = (ld==1'b1) ? lfsr_i : (en==1'b1) ? (lfsr_reg[0] ? (lfsr_reg >> 1) ^ taps : (lfsr_reg >> 1)) : lfsr_reg;

assign k = lfsr_reg[0];

assign lfsr_o = lfsr_reg;

endmodule
