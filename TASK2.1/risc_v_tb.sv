`timescale 1ns/1ps
`include "./SVcode/risc_v/risc_v.sv"

module risc_v_tb;

    logic        CLK;
    logic        reset;
    logic [31:0] CPUIn;
    logic [31:0] CPUOut;

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

        $dumpvars(0, risc_v_tb.dut.u_reg_file.RF[1]);
        $dumpvars(0, risc_v_tb.dut.u_reg_file.RF[2]);
        $dumpvars(0, risc_v_tb.dut.u_reg_file.RF[3]);

        reset = 1'b1;
        CPUIn = 32'b0;

        #12;
        reset = 1'b0;
        
        #1000;
        $finish;
    end

    initial begin
        $monitor(
            "t=%0t reset=%b PC=%h Instr=%h CPUIn=%h CPUOut=%h Result=%h ALUResult=%h x1=%h x2=%h x3=%h",
            $time,
            reset,
            dut.PC,
            dut.Instr,
            CPUIn,
            CPUOut,
            dut.Result,
            dut.ALUResult,
            dut.u_reg_file.RF[1],
            dut.u_reg_file.RF[2],
            dut.u_reg_file.RF[3]
        );
    end

endmodule
