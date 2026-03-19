`timescale 1ns/1ps
`include "./SVcode/extend/extend.sv"

module extend_tb;

    logic [31:0] Instr;
    logic [2:0]  ImmSrc;
    logic [31:0] ImmExt;

    extend dut (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    initial begin
        $dumpfile("extend_tb.vcd");
        $dumpvars(0, extend_tb);
    end

    initial begin
        $display("Time\tImmSrc\tInstr\t\t\tImmExt");
        $monitor("%0t\t%b\t%h\t%h", $time, ImmSrc, Instr, ImmExt);

        // I-type immediate tests
        Instr  = 32'h00500093;   // imm = 5
        ImmSrc = 3'b000;
        #10;

        Instr  = 32'h00C00113;   // imm = 12
        ImmSrc = 3'b000;
        #10;

        Instr  = 32'hFFF00093;   // imm = -1
        ImmSrc = 3'b000;
        #10;

        Instr  = 32'h80000093;   // imm = -2048
        ImmSrc = 3'b000;
        #10;

        // S-type immediate tests
        Instr  = 32'h0020A423;   // imm = 8
        ImmSrc = 3'b001;
        #10;

        Instr  = 32'hFE20AE23;   // imm = -4
        ImmSrc = 3'b001;
        #10;

        Instr  = 32'h7E20AF23;   // positive S-type immediate
        ImmSrc = 3'b001;
        #10;

        // B-type immediate tests
        Instr  = 32'h00208863;   // imm = 16
        ImmSrc = 3'b010;
        #10;

        Instr  = 32'hFE208EE3;   // negative branch immediate
        ImmSrc = 3'b010;
        #10;

        Instr  = 32'h00000063;   // imm = 0
        ImmSrc = 3'b010;
        #10;

        Instr  = 32'h7E208FE3;   // positive branch immediate
        ImmSrc = 3'b010;
        #10;

        // U-type immediate tests
        Instr  = 32'h123450B7;   // imm = 0x12345000
        ImmSrc = 3'b011;
        #10;

        Instr  = 32'hABCDE137;   // imm = 0xABCDE000
        ImmSrc = 3'b011;
        #10;

        Instr  = 32'hFFF00037;   // imm = 0xFFF00000
        ImmSrc = 3'b011;
        #10;

        // J-type immediate tests
        Instr  = 32'h001000EF;   // small positive jump immediate
        ImmSrc = 3'b100;
        #10;

        Instr  = 32'h7FF000EF;   // large positive jump immediate
        ImmSrc = 3'b100;
        #10;

        Instr  = 32'h800000EF;   // negative jump immediate
        ImmSrc = 3'b100;
        #10;

        Instr  = 32'h000000EF;   // imm = 0
        ImmSrc = 3'b100;
        #10;

        $finish;
    end

endmodule