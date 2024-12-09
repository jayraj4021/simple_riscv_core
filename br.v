/* 
Module => br
Purpose => B register, it holds the second argument of the ALU
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock, it loads the input value
    2. [31:0] bIn => B register input.
Output description =>
    1. [31:0] bOut => B register output.
*/
module br( input clk, input [31:0] bIn, output reg [31:0] bOut);
always@(posedge clk) begin
    bOut <= bIn;
end
endmodule