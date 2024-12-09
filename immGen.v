/* 
Module => immGen
Purpose => Immediate generation unit, it has to generate 32bit immediates from all types of instructions. 
Input description =>
    1. 
    2. 
Output description =>
    1. 
*/
module immGen( input [31:0] instr, output reg [31:0] imm);
always@(*) begin
    // immediate generation for 'lw'
    if (instr[6:0] == 7'h03 && instr[14:12] == 3'b010) begin
        imm = {20'h00000,instr[31:20]};
    end else begin
        imm = 32'h0;
    end
end
endmodule