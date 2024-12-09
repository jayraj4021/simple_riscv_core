/* 
Module => ir
Purpose => instruction register, it holds the executing instruction. 
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock, it loads the input value
    2. [31:0] instIn => instruction register input.
Output description =>
    1. [31:0] instOut => instruction register output.
*/
module ir( input clk, input enable, input [31:0] instIn, output reg [31:0] instOut);
always@(posedge clk) begin
    if(enable == 1'b1) begin
        instOut <= instIn;
    end
end
endmodule