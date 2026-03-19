`timescale 1ns/1ps
`include "./SVcode/pc/pc.sv"

module program_counter_tb;

    logic        CLK;
    logic        reset;
    logic [31:0] PCNext;
    logic [31:0] PC;

    program_counter dut (
        .CLK(CLK),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    initial begin
        $dumpfile("program_counter_tb.vcd");
        $dumpvars(0, program_counter_tb);
    end

    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    initial begin
        $display("Time\tCLK\treset\tPCNext\t\tPC");

        $monitor("%0t\t%b\t%b\t%h\t%h", $time, CLK, reset, PCNext, PC);
        
        reset  = 1;
        PCNext = 32'h00000004;
        #10;

        reset  = 0;
        PCNext = 32'h00000004;
        #10;

        PCNext = 32'h00000008;
        #10;

        PCNext = 32'h0000000C;
        #10;

        reset = 1;
        PCNext = 32'h00000010;
        #10;

        reset = 0;
        PCNext = 32'h00000014;
        #10;

        $finish;
    end

endmodule