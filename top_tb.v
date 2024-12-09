`timescale 1ns / 1ns
`include "top.v"

module top_tb;

reg clk = 0;
reg nrst;
wire [5:0] fDataOut;

top u_top(.clk(clk), .nrst(nrst),.fDataOut(fDataOut));

always begin
    clk = ~clk;
    #10;
end

initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);

    #10
    nrst = 1'b0;
    #40
    nrst = 1'b1;

    #1000

    #10
    nrst = 1'b0;
    #40
    nrst = 1'b1;

    #1000

    $finish;
end

endmodule