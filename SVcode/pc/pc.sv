module program_counter (
    input  logic        CLK,
    input  logic        reset,
    input  logic [31:0] PCNext,
    output logic [31:0] PC
);

always_ff @(posedge CLK) begin
    if (reset)
        PC <= 32'h00000000;
    else
        PC <= PCNext;
end

endmodule
