module alu (
    input  logic [31:0] A,             // ALU input A
    input  logic [31:0] B,             // ALU input B
    input  logic [4:0]  ALUControl,    // ALU control signal
    output logic [31:0] ALUResult,     // ALU output result
    output logic        Zero          // Zero flag
);

    logic [31:0] shift_result;
    logic [31:0] arith_result;
    logic [31:0] logic_result;
    logic [31:0] slt_result;


    always_comb begin

        // Shift path
        // ALUControl[4] = 0 for SLL, 1 for SRL
        case (ALUControl[4])
            1'b0: shift_result = A << B[4:0];
            1'b1: shift_result = A >> B[4:0];
        endcase

        // Arithmetic path
        // ALUControl[3] = 0 for add, 1 for subtract
        case (ALUControl[3])
            1'b0: arith_result = A + B;
            1'b1: arith_result = A - B;
        endcase

        // Logic path
        // ALUControl[2] = 0 for AND, 1 for OR
        case (ALUControl[2])
            1'b0: logic_result = A & B;
            1'b1: logic_result = A | B;
        endcase

        // Signed comparison must not rely only on the subtraction sign bit,
        // because subtraction can overflow when operands have different signs.
        slt_result = {31'b0, $signed(A) < $signed(B)};

        // Main ALU output multiplexer
        case (ALUControl[1:0])
            2'b00: ALUResult = shift_result;
            2'b01: ALUResult = slt_result;
            2'b10: ALUResult = arith_result;
            2'b11: ALUResult = logic_result;
            default: ALUResult = 32'h0;
        endcase
    end

    // Status flags
    assign Zero     = (ALUResult == 32'h0);

endmodule
