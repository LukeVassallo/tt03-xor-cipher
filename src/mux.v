module mux #(N=8) ( 
    input [N-1:0] a,
    input [N-1:0] b,
    input sel,
    output [N-1:0] c);
    
    assign c = (sel == 1'b1) ? a : b;
    
    endmodule
    
