`timescale 1ns/1ps
`include "./SVcode/alu/alu.sv"

module alu_tb;

    logic [31:0] A;
    logic [31:0] B;
    logic [4:0]  ALUControl;
    logic [31:0] ALUResult;
    logic        Zero;

    alu dut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

    initial begin
        $display("Time\tALUControl\tA\t\tB\t\tALUResult\tZero");
        $monitor("%0t\t%b\t\t%h\t%h\t%h\t%b",
                 $time, ALUControl, A, B, ALUResult, Zero);

        // =========================================================
        // Shift operation tests
        // ALUControl[1:0] = 00
        // ALUControl[4]   = 0 for SLL, 1 for SRL
        // =========================================================

        // SLL: 1 << 2 = 4
        A = 32'h00000001; B = 32'h00000002; ALUControl = 5'b00000;
        #10;

        // SLL: 3 << 4 = 0x30
        A = 32'h00000003; B = 32'h00000004; ALUControl = 5'b00000;
        #10;

        // SLL: shift by 0
        A = 32'h12345678; B = 32'h00000000; ALUControl = 5'b00000;
        #10;

        // SRL: 0x10 >> 2 = 0x4
        A = 32'h00000010; B = 32'h00000002; ALUControl = 5'b10000;
        #10;

        // SRL: 0x80000000 >> 4 = 0x08000000
        A = 32'h80000000; B = 32'h00000004; ALUControl = 5'b10000;
        #10;

        // SRL: shift by 0
        A = 32'h87654321; B = 32'h00000000; ALUControl = 5'b10000;
        #10;

        // =========================================================
        // SLT operation tests
        // ALUControl[1:0] = 01
        // Arithmetic path uses subtraction when ALUControl[3] = 1
        // =========================================================

        // 3 < 5 -> result should be 1
        A = 32'h00000003; B = 32'h00000005; ALUControl = 5'b01001;
        #10;

        // 7 < 2 -> result should be 0
        A = 32'h00000007; B = 32'h00000002; ALUControl = 5'b01001;
        #10;

        // Equal values -> result should be 0
        A = 32'h00000009; B = 32'h00000009; ALUControl = 5'b01001;
        #10;

        // Negative less-than case based on subtraction sign bit
        A = 32'hFFFFFFFE; B = 32'h00000001; ALUControl = 5'b01001;
        #10;

        // =========================================================
        // Arithmetic operation tests
        // ALUControl[1:0] = 10
        // ALUControl[3]   = 0 for ADD, 1 for SUB
        // =========================================================

        // ADD: 5 + 7 = 12
        A = 32'h00000005; B = 32'h00000007; ALUControl = 5'b00010;
        #10;

        // ADD: 0 + 0 = 0
        A = 32'h00000000; B = 32'h00000000; ALUControl = 5'b00010;
        #10;

        // ADD: negative + positive
        A = 32'hFFFFFFFC; B = 32'h00000002; ALUControl = 5'b00010;
        #10;

        // SUB: 9 - 4 = 5
        A = 32'h00000009; B = 32'h00000004; ALUControl = 5'b01010;
        #10;

        // SUB: 4 - 9 = negative result
        A = 32'h00000004; B = 32'h00000009; ALUControl = 5'b01010;
        #10;

        // SUB: equal values -> 0
        A = 32'h0000000A; B = 32'h0000000A; ALUControl = 5'b01010;
        #10;

        // =========================================================
        // Logic operation tests
        // ALUControl[1:0] = 11
        // ALUControl[2]   = 0 for AND, 1 for OR
        // =========================================================

        // AND
        A = 32'hF0F0F0F0; B = 32'h0FF00FF0; ALUControl = 5'b00011;
        #10;

        // AND with zero
        A = 32'h12345678; B = 32'h00000000; ALUControl = 5'b00011;
        #10;

        // AND all ones
        A = 32'hFFFFFFFF; B = 32'hAAAAAAAA; ALUControl = 5'b00011;
        #10;

        // OR
        A = 32'hF0F0F0F0; B = 32'h0FF00FF0; ALUControl = 5'b00111;
        #10;

        // OR with zero
        A = 32'h12345678; B = 32'h00000000; ALUControl = 5'b00111;
        #10;

        // OR mixed pattern
        A = 32'h55555555; B = 32'hAAAAAAAA; ALUControl = 5'b00111;
        #10;

        $finish;
    end

endmodule