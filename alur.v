/* 
Module => alur
Purpose => ALU register, it holds the output of the ALU
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock, it loads the input value
    2. [31:0] aluIn => A register input.
Output description =>
    1. [31:0] aluOut => A register output.
*/
module alur( input clk, input [31:0] aluIn, output reg [31:0] aluOut);
always@(posedge clk) begin
    aluOut <= aluIn;
end
endmodule