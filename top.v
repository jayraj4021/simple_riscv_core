/* 
Module => top
Purpose => top module of the design 
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock things happen
    2. rst => reset signal of the system
Output description =>
    1. fDataOut => 6 bit output data to visualize on 6 LEDs of tang nano 9k
*/

`include "pc.v"
`include "ir.v"
`include "mdr.v"
`include "ar.v"
`include "br.v"
`include "alur.v"
`include "alu.v"
`include "rf.v"
`include "immGen.v"
`include "control.v"
`include "basicMemory.v"
//`include "gowin_sp/gowin_sp.v"


module top( input clk, nrst, output [5:0] fDataOut);

    // on tang nano, buttons are pulled high so whenever the button is pressed, we get low so our rst will be active low. hence the name nrst.
    // converting acrive low reset of tang nano to active high
    wire rst = !nrst;

    wire [31:0] addrInPcNet, addrOutPcNet;
    wire [31:0] aluOutNet;
    wire [31:0] memoryDataOutNet;
    wire [31:0] irOutNet;
    wire [31:0] mdrOutNet;
    wire [31:0] rfWriteDataMuxOutNet;
    wire [31:0] readData1Net;
    wire [31:0] readData2Net;
    wire [31:0] arOutNet;
    wire [31:0] brOutNet;
    wire [31:0] aluAmuxOutNet;
    wire [31:0] aluBmuxOutNet;
    wire [31:0] immGenOutNet;
    wire [31:0] IorDmuxOutNet;
    wire IorDSelectorNet, ceNet, oceNet, wreNet, pcWriteEnableNet, memtoRegSelectNet, irWriteEnableNet, regWriteEnableNet, aluSrcASelectNet;
    wire [1:0] aluSrcBSelectNet;
    wire [1:0] aluOpNet;

   
    // instantiating all the modules
    pc u_pc(.clk(clk), .rst(rst), .enable(pcWriteEnableNet),.addrIn(addrInPcNet), .addrOut(addrOutPcNet));
    mux2 u_IorDmux(.in0(addrOutPcNet), .in1(aluOutNet), .select(IorDSelectorNet), .out(IorDmuxOutNet));
    //Gowin_SP u_spmem(.dout(memoryDataOutNet), .clk(clk), .oce(oceNet), .ce(ceNet), .reset(rst), .wre(wreNet), .ad(IorDmuxOutNet[7:0]), .din(brOutNet));
    basicMemory u_basicMemory(.clk(clk), .rst(rst), .ce(ceNet), .wre(wreNet), .ad(IorDmuxOutNet[7:0]), .din(brOutNet), .dout(memoryDataOutNet));
    ir u_ir(.clk(clk), .enable(irWriteEnableNet),.instIn(memoryDataOutNet), .instOut(irOutNet));
    mdr u_mdr(.clk(clk), .mdrIn(memoryDataOutNet), .mdrOut(mdrOutNet));
    mux2 u_rfWriteDataMux(.in0(aluOutNet),.in1(mdrOutNet),.select(memtoRegSelectNet),.out(rfWriteDataMuxOutNet));
    rf u_rf(.clk(clk), .regWriteEnable(regWriteEnableNet), .readReg1(irOutNet[19:15]), .readReg2(irOutNet[24:20]), .writeReg(irOutNet[11:7]), .readData1(readData1Net), .readData2(readData2Net),.writeData(rfWriteDataMuxOutNet));
    ar u_ar(.clk(clk), .aIn(readData1Net), .aOut(arOutNet));
    mux2 u_aluAmux(.in0(addrOutPcNet), .in1(arOutNet), .select(aluSrcASelectNet), .out(aluAmuxOutNet));
    br u_br(.clk(clk), .bIn(readData2Net), .bOut(brOutNet));
    mux3 u_aluBmux(.in0(brOutNet),.in1(32'h00000004),.in2(immGenOutNet),.select(aluSrcBSelectNet),.out(aluBmuxOutNet));
    immGen u_immGen(.instr(irOutNet),.imm(immGenOutNet));
    alu u_alu(.ALUop(aluOpNet), .instOpcode(irOutNet[6:0]), .A(aluAmuxOutNet), .B(aluBmuxOutNet), .Z(addrInPcNet));
    alur u_alur(.clk(clk), .aluIn(addrInPcNet), .aluOut(aluOutNet));
    control u_control(.clk(clk), .rst(rst), .instOpcode(irOutNet[6:0]), .IorDSelector(IorDSelectorNet), .ce(ceNet), .oce(oceNet), .wre(wreNet), .pcWriteEnable(pcWriteEnableNet), .memtoRegSelect(memtoRegSelectNet),
                .irWriteEnable(irWriteEnableNet), .regWriteEnable(regWriteEnableNet), .aluSrcASelect(aluSrcASelectNet), .aluSrcBSelect(aluSrcBSelectNet), .aluOp(aluOpNet));

    assign fDataOut = aluOutNet[5:0];
endmodule

module mux2 (input [31:0] in0, in1, input select, output reg [31:0] out);
    always @(*) begin
        case(select)
            1'b0: out = in0;
            1'b1: out = in1;
        endcase
    end
endmodule

module mux3 (input [31:0] in0, in1, in2, input [1:0] select, output reg [31:0] out);
    always @(*) begin
        case(select)
            2'b00: out = in0;
            2'b01: out = in1;
            2'b10: out = in2;
            default: out = in1;
        endcase
    end
endmodule
