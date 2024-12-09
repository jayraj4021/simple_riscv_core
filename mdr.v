/* 
Module => mdr
Purpose => memory data register, it holds data value loaded from memory. 
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock, it loads the input value
    2. [31:0] mdrIn => memory data register input.
Output description =>
    1. [31:0] mdrOut => memory data register output.
*/
module mdr( input clk, input [31:0] mdrIn, output reg [31:0] mdrOut);
always@(posedge clk) begin
    mdrOut <= mdrIn;
end
endmodule