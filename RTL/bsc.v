`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.03.2024 10:31:21
// Design Name: 
// Module Name: bsc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


/* Doubts

1. If ShiftDR=0 and CaptureDR rises, then SO = PI. 

*/


module bsc(
    input PI,SI,ShiftDR,CaptureDR,UpdateDR,TCK,mode,
    output reg SO,
    output PO
    );
    
    reg update;
    wire mux1out, mux2in;
    
    assign mux1out = ((PI & ~(ShiftDR)) | (SI & ShiftDR));
    // ShiftDR = 1  mux1out = SI         ShiftDR = 0   mux1out = PI
    assign PO = ((PI & ~(mode)) | (update & mode));
    
    always@(posedge TCK) begin
        SO <= mux1out;
//        SO <= capture;
    end
    
    always@(negedge TCK) begin
//        if (UpdateDR)
            update <= SO;
    end
    
    
endmodule
