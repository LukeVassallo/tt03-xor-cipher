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

`timescale 1ns / 1ns

module dual_xor_signature_tb;

reg clk;
reg rst;

dual_xor_fpga_signature_wrapper #(.M(32), .tx_cntr_period(2000))uut (
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
