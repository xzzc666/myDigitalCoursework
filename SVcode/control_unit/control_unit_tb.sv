`timescale 1ns/1ps
`include "./SVcode/control_unit/control_unit.sv"

module control_unit_tb;

    logic [31:0] instr;
    logic        Zero;

    logic        RegWrite;
    logic [2:0]  ImmSrc;
    logic        ALUSrc;
    logic [4:0]  ALUControl;
    logic        MemWrite;
    logic [1:0]  ResultSrc;
    logic [1:0]  PCSrc;

    control_unit dut (
        .instr(instr),
        .Zero(Zero),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .PCSrc(PCSrc)
    );

    initial begin
        $dumpfile("control_unit_tb.vcd");
        $dumpvars(0, control_unit_tb);
    end

    initial begin
        $display("Time\tinstr\t\t\tZero\tRegWrite ImmSrc ALUSrc ALUCtrl MemWrite ResultSrc PCSrc");
        $monitor("%0t\t%h\t%b\t%b\t %b\t   %b\t   %b\t   %b\t    %b\t    %b",
                 $time, instr, Zero, RegWrite, ImmSrc, ALUSrc, ALUControl,
                 MemWrite, ResultSrc, PCSrc);

        // =========================================================
        // R-type instruction tests
        // =========================================================

        // add  x1, x2, x3
        instr = 32'b0000000_00011_00010_000_00001_0110011; Zero = 0;
        #10;

        // sub  x1, x2, x3
        instr = 32'b0100000_00011_00010_000_00001_0110011; Zero = 0;
        #10;

        // or   x1, x2, x3
        instr = 32'b0000000_00011_00010_110_00001_0110011; Zero = 0;
        #10;

        // and  x1, x2, x3
        instr = 32'b0000000_00011_00010_111_00001_0110011; Zero = 0;
        #10;

        // sll  x1, x2, x3
        instr = 32'b0000000_00011_00010_001_00001_0110011; Zero = 0;
        #10;

        // srl  x1, x2, x3
        instr = 32'b0000000_00011_00010_101_00001_0110011; Zero = 0;
        #10;

        // slt  x1, x2, x3
        instr = 32'b0000000_00011_00010_010_00001_0110011; Zero = 0;
        #10;

        // =========================================================
        // I-type arithmetic instruction tests
        // =========================================================

        // addi x1, x2, 5
        instr = 32'b000000000101_00010_000_00001_0010011; Zero = 0;
        #10;

        // ori  x1, x2, 5
        instr = 32'b000000000101_00010_110_00001_0010011; Zero = 0;
        #10;

        // andi x1, x2, 5
        instr = 32'b000000000101_00010_111_00001_0010011; Zero = 0;
        #10;

        // slli x1, x2, 3
        instr = 32'b0000000_00011_00010_001_00001_0010011; Zero = 0;
        #10;

        // srli x1, x2, 3
        instr = 32'b0000000_00011_00010_101_00001_0010011; Zero = 0;
        #10;

        // slti x1, x2, 5
        instr = 32'b000000000101_00010_010_00001_0010011; Zero = 0;
        #10;

        // =========================================================
        // Memory access instruction tests
        // =========================================================

        // lw x1, 8(x2)
        instr = 32'b000000001000_00010_010_00001_0000011; Zero = 0;
        #10;

        // sw x3, 8(x2)
        instr = 32'b0000000_00011_00010_010_01000_0100011; Zero = 0;
        #10;

        // =========================================================
        // Branch instruction tests
        // =========================================================

        // beq taken
        instr = 32'b0000000_00011_00010_000_01000_1100011; Zero = 1;
        #10;

        // beq not taken
        instr = 32'b0000000_00011_00010_000_01000_1100011; Zero = 0;
        #10;

        // bne taken
        instr = 32'b0000000_00011_00010_001_01000_1100011; Zero = 0;
        #10;

        // bne not taken
        instr = 32'b0000000_00011_00010_001_01000_1100011; Zero = 1;
        #10;

        // blt taken (using slt + ~Zero)
        instr = 32'b0000000_00011_00010_100_01000_1100011; Zero = 0;
        #10;

        // blt not taken
        instr = 32'b0000000_00011_00010_100_01000_1100011; Zero = 1;
        #10;

        // bge taken (using slt + Zero)
        instr = 32'b0000000_00011_00010_101_01000_1100011; Zero = 1;
        #10;

        // bge not taken
        instr = 32'b0000000_00011_00010_101_01000_1100011; Zero = 0;
        #10;

        // =========================================================
        // Jump instruction tests
        // =========================================================

        // jal x1, offset
        instr = 32'b0_0000001010_1_00000000_00001_1101111; Zero = 0;
        #10;

        // jalr x1, x2, 4
        instr = 32'b000000000100_00010_000_00001_1100111; Zero = 0;
        #10;

        // =========================================================
        // U-type instruction test
        // =========================================================

        // lui x1, 0x12345
        instr = 32'b00010010001101000101_00001_0110111; Zero = 0;
        #10;

        $finish;
    end

endmodule