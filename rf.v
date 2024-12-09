/* 
Module => rf
Purpose => register file, it containts all the 32 registers of RISC-V CPU
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock, it loads the input value
    2. regWriteEnable => active high signal to enable writing to the register file
    3. readReg1 and readReg2 => 5 bit address of the registers whose data needs to be presented on readData1 and readData2 respectively
    4. writeReg => 5 bit address of regiser to be written
    5. writeData => data to write in register selected by writeReg
Output description =>
    1. readData1 and readData2 => output data from registers specified by readReg1 and readReg2 respectively
*/
module rf(input clk, input regWriteEnable,
                     input [4:0] readReg1,
                     input [4:0] readReg2, 
                     input [4:0] writeReg, input [31:0] writeData, 
                    output reg [31:0] readData1, output reg [31:0] readData2);

// 32 registers each 32 bit wide
reg [31:0] registersOfRegFile [31:0];
// setting 0 register to always be 0
initial begin
    registersOfRegFile[0] <= 32'b0; 
end


// write logic
genvar i;
generate 
    for (i=0; i<32; i=i+1) begin: reg_write
        always@(posedge clk) begin
            if (regWriteEnable == 1'b1 && (writeReg == i) && (writeReg != 5'b0)) begin
                registersOfRegFile[i] <= writeData ;
            end 
        end
    end
endgenerate


//read logic
always @(posedge clk) begin
    readData1 = registersOfRegFile[readReg1];
    readData2 = registersOfRegFile[readReg2];
end
endmodule