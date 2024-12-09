/* 
Module => ar
Purpose => A register, it holds the first argument of the ALU
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock, it loads the input value
    2. [31:0] aIn => A register input.
Output description =>
    1. [31:0] aOut => A register output.
*/
module ar( input clk, input [31:0] aIn, output reg [31:0] aOut);
always@(posedge clk) begin
    aOut <= aIn;
end
endmodule