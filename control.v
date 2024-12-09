/* 
Module => control
Purpose => main controller of the design
Input description =>
    1. clk => central ticker of the system, on each positive edge of the clock things happen
    2. 
Output description =>
    1. 
*/


module control(  input clk, input rst, input [6:0] instOpcode, 
                output reg IorDSelector, output reg ce, output reg oce, output reg wre, output reg pcWriteEnable, output reg memtoRegSelect, output reg irWriteEnable, 
                        output reg regWriteEnable, output reg aluSrcASelect, output reg [1:0] aluSrcBSelect, output reg [1:0] aluOp );
    
    // 10 States - one hot encoding
    reg [10:0] currentState;
    reg [10:0] nextState;
    // state definition
    localparam
        idle =                  11'b00000000001,
        instFetch =             11'b00000000010,
        instDecodeRegFetch =    11'b00000000100,
        memoryAddrCompute =     11'b00000001000,
        memoryReadAccess =      11'b00000010000,
        memoryReadComplete =    11'b00000100000,
        mdrToRegFile =          11'b00001000000,
        memoryWriteAccess =     11'b00010000000,
        rTypeExecute =          11'b00100000000,
        rTypeComplete =         11'b01000000000,
        branchComplete =        11'b10000000000;
    
    // Sequential logic for state transition
    // asynchronous rst
    always@(posedge clk or posedge rst) begin
        if(rst) begin
            // reset to initial state
            currentState <= idle;
        end else begin
            // state transition
            currentState <= nextState;
        end
    end

    always@(*) begin
        //Default assignments
        nextState = currentState;
        IorDSelector = 1'b0;
        // memory controls
        ce = 1'b0;  // clock enable input for memory, active high
        oce = 1'b0; // output clock enable for memory, signal used in pipeline, invalid in Bypass
        wre = 1'b0; // write enable input, 1: write, 0: read
        pcWriteEnable = 1'b0;
        memtoRegSelect = 1'b0;
        irWriteEnable = 1'b0;
        regWriteEnable = 1'b0;
        aluSrcASelect = 1'b0;
        aluSrcBSelect = 2'b00;
        aluOp = 2'b00;

        // state machine logic
        case(currentState)
            // idle state hex is 1
            idle: begin
                nextState = instFetch;
            end
            // instFetch state hex is 2
            instFetch: begin
                nextState = instDecodeRegFetch;
                // enables and selectors
                IorDSelector = 1'b0;
                ce = 1'b1;
                oce = 1'b1;
                wre = 1'b0;
                pcWriteEnable = 1'b1;
                memtoRegSelect = 1'b0;
                irWriteEnable = 1'b1;
                regWriteEnable = 1'b0;
                aluSrcASelect = 1'b0;
                aluSrcBSelect = 2'b01;
                aluOp = 2'b00;
            end
            // instDecodeRegFetch state hex is 4
            instDecodeRegFetch: begin
                if(instOpcode == 7'h03) begin
                    nextState = memoryAddrCompute;
                end else begin
                    nextState = rTypeExecute;
                end
                ce = 1'b0;
                oce = 1'b0;
                // changing ALU input to immediate generator output to calculate branch address
                aluSrcASelect = 1'b0;
                aluSrcBSelect = 2'b10;
                aluOp = 2'b00;
            end
            // memoryAddrCompute state hex is 8
            memoryAddrCompute: begin
                if(instOpcode == 7'h03) begin
                    nextState = memoryReadAccess;
                end else begin
                    nextState = memoryWriteAccess;
                end
                aluSrcASelect = 1'b1;
                aluSrcBSelect = 2'b10;
                aluOp = 2'b00;
            end
            // memoryReadAccess state hex is 10
            memoryReadAccess: begin
                nextState = memoryReadComplete;
                ce = 1'b1;
                oce = 1'b1;
                IorDSelector = 1'b1;
                aluSrcASelect = 1'b1;
                aluSrcBSelect = 2'b10;
                aluOp = 2'b00;
            end
            // memoryReadComplete state hex is 20
            memoryReadComplete: begin
                nextState = mdrToRegFile;
                ce = 1'b0;
                oce = 1'b0;
                IorDSelector = 1'b0;
                memtoRegSelect = 1'b1;
                regWriteEnable = 1'b1;
            end
            // mdrToRegFile state hex is 40
            mdrToRegFile: begin
                nextState = instFetch;
                ce = 1'b0;
                oce = 1'b0;
                IorDSelector = 1'b0;
                memtoRegSelect = 1'b1;
                regWriteEnable = 1'b1;
            end
            // memoryWriteAccess state hex is 80
            memoryWriteAccess: begin
                nextState = instFetch;
                ce = 1'b1;
                oce = 1'b1;
                wre = 1'b1;
                IorDSelector = 1'b1;
            end
            // rTypeExecute state hex is 100
            rTypeExecute: begin
                nextState = rTypeComplete;
                aluSrcASelect = 1'b1;
                aluSrcBSelect = 2'b00;
                // aluOp= 2'10 indicates that the operation will be decided by opcode of instruction
                aluOp = 2'b10;
            end
            // rTypeComplete state hex is 200
            rTypeComplete: begin
                nextState = instFetch;
                regWriteEnable = 1'b1;
                memtoRegSelect = 1'b0;
            end
            // branchComplete state hex is 400
            branchComplete: begin
                nextState = instFetch;

            end
            default: begin
                nextState = idle;
                IorDSelector = 1'b0;
                ce = 1'b0;  
                oce = 1'b0; 
                wre = 1'b0; 
                pcWriteEnable = 1'b0;
                memtoRegSelect = 1'b0;
                irWriteEnable = 1'b0;
                regWriteEnable = 1'b0;
                aluSrcASelect = 1'b0;
                aluSrcBSelect = 2'b00;
                aluOp = 2'b00;
            end
        endcase
    end



endmodule