`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2024 19:44:43
// Design Name: 
// Module Name: tap_tb
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


module tap_tb();
    reg TCK,TMS,TRST,TDI;
    wire TDO;
    wire t1,t2,t3,t4,t5,t6,sh;//,t7,t8,t9,t10,t11,t12,sh;
    
    tap_design tap1(TCK,TMS,TRST,TDI,TDO,t1,t2,t3,t4,t5,t6,sh);//,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12,sh);
    
    always #5 TCK = ~TCK;
    
    initial begin
        TCK = 0;
        TRST = 0;
        @(posedge TCK);
        TRST = 1;
        TDI = 0;
        TMS = 0;              // Idle
        @(posedge TCK);
        TMS = 1;              // SelectDR-Scan
        @(posedge TCK);
        TMS = 1;              // SelectIR-Scan
        @(posedge TCK);
        TMS = 0;              // CaptureIR
        @(posedge TCK);
        TMS = 0;              // ShiftIR
        TDI = 0;
        @(posedge TCK);
        TMS = 0;              // ShiftIR
        TDI = 0;
        @(posedge TCK);
        TMS = 0;              // ShiftIR      TDI: 0->1->0 => INTEST
        TDI = 0;
        @(posedge TCK);
        TMS = 1;              // Exit1IR
        TDI = 1;
        @(posedge TCK);
        TMS = 1;              // UpdateIR
        TDI = 0;
        @(posedge TCK);
        
        TMS = 1;              // SelectDR-Scan
        @(posedge TCK);
        TMS = 0;              // CaptureDR
        @(posedge TCK);
        TMS = 0;              // ShiftDR
        @(posedge TCK);
        TMS = 0;     
        TDI = 1;              // ShiftDR
        @(posedge TCK);
        TMS = 0;              // ShiftDR
        TDI = 1;
        @(posedge TCK);
        TMS = 1;              // Exit1DR
        TDI = 0;
        @(posedge TCK);
        TMS = 1;              // UpdateDR
        @(posedge TCK);
        TMS = 1;              // SelectDRScan
        @(posedge TCK);
        TMS = 0;              // CaptureDR
        @(posedge TCK);
        TMS = 0;              // ShiftDR
        @(posedge TCK);
        TMS = 0;              // ShiftDR
        @(posedge TCK);
        TMS = 0;              // ShiftDR
        @(posedge TCK);
        TMS = 0;              // ShiftDR
        @(posedge TCK);
        TMS = 1;              // Exit1DR
        @(posedge TCK);
        TMS = 1;              // UpdateDR
    end
endmodule
