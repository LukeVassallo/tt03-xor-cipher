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

module serial2parallel #( parameter N =8 ) (
    input clk,
    input rst,
    input start,
    input d,
    output [N-1:0] a,
    output conversion_start,
    output conversion_finish,
    output reg conversion_finish_dly,
    output module_busy );
    
    reg [1:0] state_reg, state_next;
    
    localparam [0:0]
        state_idle = 1'b0,
        state_shift = 1'b1;
    
    always @(posedge clk) 
    begin
        if (rst == 1'b1) begin
            state_reg <= state_idle;
        end else begin
            state_reg <= state_next;
        end 
    end
    
    reg [2:0] shift_cntr;
    wire [2:0] shift_cntr_next;
    
    always @(posedge clk) 
    begin
        if (rst == 1'b1) begin
            shift_cntr <= 2'b0;
            parallel_word <= 7'b0;
        end else begin
            shift_cntr <= shift_cntr_next;
            parallel_word <= parallel_word_next;
        end 
    end
 
always @(state_reg, shift_cntr, start)
begin
    state_next <= state_reg; 
    
    case (state_reg) 
        state_idle:
            if (start == 1'b1) begin
                state_next <= state_shift;
            end           
            
        state_shift:
            if (shift_cntr == N-1) begin 
                state_next <= state_idle;
            end             
    endcase
end    

always @(posedge clk)
begin 
    conversion_finish_dly <= conversion_finish;
end

wire shift_condition = (state_reg == state_idle & start) | (state_reg == state_shift);
reg [7:0] parallel_word;
wire [7:0] parallel_word_next = shift_condition ? {parallel_word[6:0], d} : parallel_word; 
assign shift_cntr_next = shift_condition ? shift_cntr +1 : shift_cntr;
   
assign a = parallel_word;
assign module_busy = shift_condition;
assign conversion_start = (state_reg == state_idle & start);
assign conversion_finish = (shift_cntr == N-1);   
    
endmodule    
    
