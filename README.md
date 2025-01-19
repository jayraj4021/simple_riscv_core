The repository contains verilog code for a RISC-V CPU that implements following instructions.

1. load word (lw)
2. add
3. branch if equal (beq)

top.v contains the top module (named top) of the design and test bench top_tb.v instantiates the module for a very basic test. Along with defining top module, the file also contains definition for 2 input mux, 3 input mux, register with enable and register without enable. I tried to implement the code on a small FPGA called tang nano, so you may see some code related to that but most of it is commented to make the code work on free verilog compiler 'icarus verilog'. 

Following are details of other files included in top.v.
1. alu.v 🧮- defines arithmetic logic unit of the processor.
2. rf.v 📁- defines register file, it contains all the 32-bit registers of the processor.
3. immGen.v - defines immediate generation unit.
4. control.v 👮‍♂️- defines the controller unit.
5. basicMemory.v - defines a basic memory array.

