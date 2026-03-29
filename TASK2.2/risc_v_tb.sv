`timescale 1ns/1ps
`include "./SVcode/risc_v/risc_v.sv"
module risc_v_tb;

    logic        CLK;
    logic        reset;
    logic [31:0] CPUIn;
    logic [31:0] CPUOut;

    localparam logic [31:0] A_INIT = 32'd 14;
    localparam logic [31:0] B_INIT = 32'd 15;

    risc_v dut (
        .CLK(CLK),
        .reset(reset),
        .CPUIn(CPUIn),
        .CPUOut(CPUOut)
    );

    initial begin
        CLK = 1'b0;
        forever #5 CLK = ~CLK;
    end

    initial begin
        $dumpfile("risc_v_tb.vcd");
        $dumpvars(0, risc_v_tb);

        $dumpvars(0, risc_v_tb.dut.u_reg_file.RF[8]);
        $dumpvars(0, risc_v_tb.dut.u_reg_file.RF[9]);
        $dumpvars(0, risc_v_tb.dut.u_reg_file.RF[18]);

        reset = 1'b1;
        CPUIn = 32'h00000000;

        dut.u_reg_file.RF[5]  = 32'h00000000;
        dut.u_reg_file.RF[6]  = 32'h00000000;
        dut.u_reg_file.RF[7]  = 32'h00000000;
        dut.u_reg_file.RF[8]  = A_INIT;
        dut.u_reg_file.RF[9]  = B_INIT;
        dut.u_reg_file.RF[18] = 32'h00000000;
        dut.u_reg_file.RF[28] = 32'h00000000;

        #12;
        reset = 1'b0;
        
        #1500;
        $finish;
    end

    initial begin
        $monitor(
            "t=%0t reset=%b PC=%h Instr=%h CPUOut=%h A(s0)=%h B(s1)=%h P(s2)=%h i(t1)=%h bit(t2)=%h limit(t3)=%h Result=%h ALUResult=%h",
            $time,
            reset,
            dut.PC,
            dut.Instr,
            CPUOut,
            dut.u_reg_file.RF[8],
            dut.u_reg_file.RF[9],
            dut.u_reg_file.RF[18],
            dut.u_reg_file.RF[6],
            dut.u_reg_file.RF[7],
            dut.u_reg_file.RF[28],
            dut.Result,
            dut.ALUResult
        );
    end

endmodule
