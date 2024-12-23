/* 
Module => alu
Purpose => Arithmetic Logic Unit i.e. the computation unit of the CPU
Input description =>
    1. ALUop - 2 bit operational code sent to ALU from control unit
    2. instOpcode - instruction opcode to decide ALU function 
    3. A - 32 bit operand
    4. B - 32 bit operand
Output description =>
    1. Z - ALU output
*/
module alu(input [1:0] ALUop, input [6:0] instOpcode, input [31:0] A , input [31:0] B, output reg [31:0] Z);

always@(*) begin
    case(ALUop)
        2'b00: Z = A + B ;
        2'b01: Z = A - B ;
        // following two are fake, need to update
        2'b10: begin
            if (instOpcode == 7'h33) begin
                // 7'h33 is opcode for add
                // TODO -- need to add funct3 and funct7 bits also as sub has same opcode but different funct bits
                Z = A + B; 
            end else begin
                Z = A - B;
            end
        end
        2'b11: Z = A + B ;
    endcase
end
endmodule