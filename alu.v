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
    2. isZero - 1 bit flag which indicates if z is equal to 0
*/
module alu(input [1:0] ALUop, input [6:0] instOpcode, input [31:0] A , input [31:0] B, output reg [31:0] Z, output reg isZero);

always@(*) begin
    case(ALUop)
        2'b00: begin 
            Z = A + B ;
        end
        2'b01: begin
            Z = A - B ;
        end
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

always @(*) begin
    if (Z == 32'b0) begin
        isZero <= 1'b1;
    end else begin
        isZero <= 1'b0;
    end
end

endmodule