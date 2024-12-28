/* 
Module => immGen
Purpose => Immediate generation unit, it has to generate 32bit immediates from all types of instructions. 
Input description =>
    1. instr - 32 bit instruction
Output description =>
    1. imm - 32 bit immediate
*/
module immGen( input [31:0] instr, output reg [31:0] imm);
always@(*) begin
    if (instr[6:0] == 7'h03 && instr[14:12] == 3'b010) begin
        // immediate generation for 'lw'
        imm = {20'h00000,instr[31:20]};
    end else if (instr[6:0] == 7'h63 && instr[14:12] == 3'b000) begin
        // immediate generation for 'beq'
        if (instr[31] == 1'b1) begin
            imm = {20'hFFFFF,instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
        end else begin
            imm = {20'h00000,instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
        end
    end 
    else begin
        imm = 32'h0;
    end
end
endmodule