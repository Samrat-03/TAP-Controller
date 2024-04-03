`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.03.2024 19:44:23
// Design Name: 
// Module Name: tap_design
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


module tap_design(
    input TCK,TMS,TRST,TDI,
    output reg TDO,
    output reg t1,t2,t3,t4,t5,t6,sh//,t7,t8,t9,t10,t11,t12,sh
    );
    
    // Define the 16 states
    parameter Test_Logic_Reset=0, Idle=1, Select_DRScan=2, Select_IRScan=3, CaptureDR=4, CaptureIR=5, ShiftDR=6, ShiftIR=7, Exit1DR=8, Exit1IR=9, PauseDR=10, PauseIR=11, Exit2DR=12, Exit2IR=13, UpdateDR=14, UpdateIR=15;
    reg [3:0] state, next_state;
    initial state = Test_Logic_Reset;
    
    always@(*) begin
        if(state==Test_Logic_Reset) begin
            if (TMS)
                next_state <= Test_Logic_Reset;
            else
                next_state <= Idle;
        end
        
        else if (state==Idle) begin
            if (TMS)
                next_state <= Select_DRScan;
            else
                next_state <= Idle;
        end
        
        else if (state==Select_DRScan) begin
            if (TMS)
                next_state <= Select_IRScan;
            else
                next_state <= CaptureDR;
        end
        
        else if (state==Select_IRScan) begin
            if (TMS)
                next_state <= Test_Logic_Reset;
            else
                next_state <= CaptureIR;
        end
        
        else if (state==CaptureDR) begin
            if (TMS)
                next_state <= Exit1DR;
            else
                next_state <= ShiftDR;
        end
        
        else if (state==CaptureIR) begin
            if (TMS)
                next_state <= Exit1IR;
            else
                next_state <= ShiftIR;
        end
        
        else if (state==ShiftDR) begin
            if (TMS)
                next_state <= Exit1DR;
            else
                next_state <= ShiftDR;
        end
        
        else if (state==ShiftIR) begin
            if (TMS)
                next_state <= Exit1IR;
            else
                next_state <= ShiftIR;
        end
        
        else if (state==Exit1DR) begin
            if (TMS)
                next_state <= UpdateDR;
            else
                next_state <= PauseDR;
        end
        
        else if (state==Exit1IR) begin
            if (TMS)
                next_state <= UpdateIR;
            else
                next_state <= PauseIR;
        end
        
        else if (state==PauseDR) begin
            if (TMS)
                next_state <= Exit2DR;
            else
                next_state <= PauseDR;
        end
        
        else if (state==PauseIR) begin
            if (TMS)
                next_state <= Exit2IR;
            else
                next_state <= PauseIR;
        end
        
        else if (state==Exit2DR) begin
            if (TMS)
                next_state <= UpdateDR;
            else
                next_state <= ShiftDR;
        end
        
        else if (state==Exit2IR) begin
            if (TMS)
                next_state <= UpdateIR;
            else
                next_state <= ShiftIR;
        end
        
        else if (state==UpdateDR) begin
            if (TMS)
                next_state <= Select_DRScan;
            else
                next_state <= Idle;
        end
        
        else begin
            if (TMS)
                next_state <= Select_DRScan;
            else
                next_state <= Idle;
        end
    end
    
    reg [11:0] sys_in;
    wire [11:0] SO,PO;
    reg mode;
    reg extest=0,bypass=0,sampre=0,intest=0;
    
    bsc b1r1 (sys_in[0],TDI,(state==ShiftDR),(state==CaptureDR),(state==UpdateDR),TCK,mode,SO[0],PO[0]);
    bsc b1r2 (sys_in[1],SO[0],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR),TCK,mode,SO[1],PO[1]);
    bsc b1r3 (sys_in[2],SO[1],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR), TCK,mode,SO[2],PO[2]);
    bsc b1r4 (sys_in[3],SO[2],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR), TCK,mode,SO[3],PO[3]);
    bsc b1r5 (sys_in[4],SO[3],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR), TCK,mode,SO[4],PO[4]);
    bsc b1r6 (sys_in[5],SO[4],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR), TCK,mode,SO[5],PO[5]);
    
    bsc b2r1 (sys_in[6],SO[5],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR),TCK,mode,SO[6],PO[6]);
    bsc b2r2 (sys_in[7],SO[6],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR),TCK,mode,SO[7],PO[7]);
    bsc b2r3 (sys_in[8],SO[7],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR), TCK,mode,SO[8],PO[8]);
    bsc b2r4 (sys_in[9],SO[8],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR), TCK,mode,SO[9],PO[9]);
    bsc b2r5 (sys_in[10],SO[9],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR), TCK,mode,SO[10],PO[10]);
    bsc b2r6 (sys_in[11],SO[10],(state==ShiftDR),(state==CaptureDR),(state==UpdateDR), TCK,mode,SO[11],PO[11]);
    

    
    
    
    /* Instruction register opcodes
    111 = BYPASS
    000 = EXTEST
    001 = SAMPLE/PRELOAD
    010 = INTEST
    */
    // Instruction Register
    reg [2:0] hold,shift;
    reg a,b;
    wire c;
    
    and_gate a1(a,b,c);
    
    always@(posedge TCK) begin
        if (state==ShiftIR) begin
            shift[2] <= TDI;
            shift[0] <= shift[1];
            shift[1] <= shift[2];
        end
        else if (state==UpdateIR)
            hold <= shift;
    end
    
    // Instruction Decoder
    always@(negedge (state==UpdateIR)) begin
        if (hold==3'b000) begin
            $display("EXTEST");
            mode <= 1;
            extest <= 1;
        end
        
        else if (hold==3'b111) begin
            $display("BYPASS");
            bypass <= 1;
//            TDO <= TDI;
        end
        
        else if (hold==3'b001) begin
            $display("SAMPLE/PRELOAD");
            mode <= 0;
            sampre <= 1;
        end
        
        else if (hold==3'b010) begin
            $display("INTEST");
            mode <= 1;
            intest <= 1;
        end
    end
    
    always@(*) begin
        if (extest) begin
            if (state==Exit1DR) begin
                sys_in[6] <= PO[5];
                sys_in[7] <= PO[4];
                sys_in[8] <= PO[3];
            end
                
//            t1 <= SO[0];
//            t2 <= SO[1];
//            t3 <= SO[2];
//            t4 <= SO[3];
//            t5 <= SO[4];
//            t6 <= SO[5];
//            t7 <= SO[6];
//            t8 <= SO[7];
//            t9 <= SO[8];
//            t10 <= SO[9];
//            t11 <= SO[10];
//            t12 <= SO[11];
            TDO <= SO[11];
        end
        
        else if (bypass)
            TDO <= TDI;
            
        else if (sampre) begin
            sys_in[0] <= 1;
            sys_in[1] <= 0;
            sys_in[2] <= 0;
            TDO <= SO[5];
        end
        
        else if (intest) begin
            t1 <= SO[0];
            t2 <= SO[1];
            t3 <= SO[2];
            t4 <= SO[3];
            t5 <= SO[4];
            t6 <= SO[5];
            sh <= state==ShiftDR;
            TDO <= SO[4];
            if (state==Exit1DR) begin
                a <= PO[0];
                b <= PO[1];
                sys_in[4] <= c;
            end
        end
    end
    
    
    
    always@(posedge TCK or negedge TRST) begin
        if(~TRST) begin
            state <= Test_Logic_Reset;
            hold <= 3'b000;
            shift <= 3'b000;
            mode <= 0;
        end
        else begin
            state <= next_state;
//            $display("state = %d",state);
        end
    end
    
    /*
    input PI,SI,ShiftDR,CaptureDR,UpdateDR,mode,
    output reg SO,
    output PO
    */
    


    
endmodule
