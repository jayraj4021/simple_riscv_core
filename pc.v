/* 
Module => pc
Purpose => program counter register, its job is to keep track of current instruction getting executed, 
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock, program counter gets updated with the address on the addrIn ports.
    2. rst => resets the program counter to 32'h0000
    3. [31:0] addrIn => input address for the PC, it comes from ALU, it can be pc+4 for next instruction or can be branched address.
Output description =>
    1. [31:0] addrOut => output address from the PC
*/
module pc( input clk, input rst, input enable, input [31:0] addrIn, output reg [31:0] addrOut);

always@(posedge clk) begin
    if(rst == 1'b1) begin
        addrOut <= 32'h0000;
    end
    else begin
        if(enable == 1'b1) begin
            addrOut <= addrIn;
        end
    end
end
endmodule