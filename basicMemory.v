/* creating basic memory to help simulation in vscode, as gowin IP won't work. */



module basicMemory(input clk, input rst, input ce, input wre, input [7:0] ad, input [31:0] din, output reg [31:0] dout);

    reg [31:0] memStoreArray [255:0];

    initial begin
        memStoreArray[0] = 32'h02802483;  // lw x9, 40(x0)
        memStoreArray[4] = 32'h02C02503;  // lw x10, 44(x0)
        memStoreArray[8] = 32'h00A485B3;  // add x11, x9, x10
        memStoreArray[40] = 32'h00000006;
        memStoreArray[44] = 32'h00000005;
    end


    always@(posedge clk) begin
        if(wre) begin
            memStoreArray[ad] <= din;
        end else begin
           dout <= memStoreArray[ad]; 
        end
    end

endmodule