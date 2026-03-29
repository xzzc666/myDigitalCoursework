`include "./SVcode/instruction_memory.sv"
`include "./SVcode/reg_file.sv"
`include "./SVcode/data_memory_and_io.sv"
`include "./SVcode/pc/pc.sv"
`include "./SVcode/extend/extend.sv"
`include "./SVcode/alu/alu.sv"
`include "./SVcode/control_unit/control_unit.sv"

module risc_v (
    input  logic        CLK,
    input  logic        reset,
    input  logic [31:0] CPUIn,
    output logic [31:0] CPUOut
);

    logic [31:0] PC;
    logic [31:0] PCNext;
    logic [31:0] PCPlus4;
    logic [31:0] PCTarget;
    logic [31:0] Instr;
    logic [31:0] RD1;
    logic [31:0] RD2;
    logic [31:0] ImmExt;
    logic [31:0] SrcB;
    logic [31:0] ALUResult;
    logic [31:0] ReadData;
    logic [31:0] Result;
    logic        Zero;

    logic        RegWrite;
    logic [2:0]  ImmSrc;
    logic        ALUSrc;
    logic [4:0]  ALUControl;
    logic        MemWrite;
    logic [1:0]  ResultSrc;
    logic [1:0]  PCSrc;

    assign PCPlus4  = PC + 32'd4;
    assign PCTarget = PC + ImmExt;
    assign SrcB     = ALUSrc ? ImmExt : RD2;

    always_comb begin
        case (ResultSrc)
            2'b00:   Result = ImmExt;
            2'b01:   Result = ALUResult;
            2'b10:   Result = ReadData;
            2'b11:   Result = PCPlus4;
            default: Result = 32'h00000000;
        endcase
    end

    always_comb begin
        case (PCSrc)
            2'b00:   PCNext = PCPlus4;
            2'b01:   PCNext = PCTarget;
            2'b10:   PCNext = ALUResult;
            default: PCNext = PCPlus4;
        endcase
    end

    program_counter u_pc (
        .CLK(CLK),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC)
    );

    instruction_memory u_instruction_memory (
        .Instr(Instr),
        .PC(PC)
    );

    control_unit u_control_unit (
        .instr(Instr),
        .Zero(Zero),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .ALUControl(ALUControl),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .PCSrc(PCSrc)
    );

    reg_file u_reg_file (
        .RD1(RD1),
        .RD2(RD2),
        .WD3(Result),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WE3(RegWrite),
        .CLK(CLK)
    );

    extend u_extend (
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)
    );

    alu u_alu (
        .A(RD1),
        .B(SrcB),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    data_memory_and_io u_data_memory_and_io (
        .RD(ReadData),
        .CPUOut(CPUOut),
        .A(ALUResult),
        .WD(RD2),
        .CPUIn(CPUIn),
        .WE(MemWrite),
        .CLK(CLK)
    );

endmodule
