module extend (
    input  logic [31:0] Instr,      // Full 32-bit instruction
    input  logic [2:0]  ImmSrc,     // Immediate type selector
    output logic [31:0] ImmExt      // Extended immediate
);

always_comb begin
    case (ImmSrc)
        3'b000: begin
            // I-type immediate
            ImmExt = {{20{Instr[31]}}, Instr[31:20]};
        end

        3'b001: begin
            // S-type immediate
            ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
        end

        3'b010: begin
            // B-type immediate
            ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};
        end

        3'b011: begin
            // U-type immediate
            ImmExt = {Instr[31:12], 12'b0};
        end

        3'b100: begin
            // J-type immediate
            ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};
        end

    endcase
end

endmodule