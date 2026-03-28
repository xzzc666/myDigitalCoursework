module control_unit (
    input  logic [31:0] instr,
    input  logic        Zero,

    output logic        RegWrite,
    output logic [2:0]  ImmSrc,
    output logic        ALUSrc,
    output logic [4:0]  ALUControl,
    output logic        MemWrite,
    output logic [1:0]  ResultSrc,
    output logic [1:0]  PCSrc
);

    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    always_comb begin
        // default values
        RegWrite   = 1'b0;
        ImmSrc     = 3'b000;
        ALUSrc     = 1'b0;
        ALUControl = 5'b00000;
        MemWrite   = 1'b0;
        ResultSrc  = 2'b00;
        PCSrc      = 2'b00;

        case (opcode)

            // =========================
            // R-type: add, sub, or, and, sll, srl, slt
            // opcode = 0110011
            // =========================
            7'b0110011: begin
                RegWrite  = 1'b1;
                ALUSrc    = 1'b0;
                ResultSrc = 2'b01;
                PCSrc     = 2'b00;

                case (funct3)
                    3'b000: begin
                        if (funct7 == 7'b0100000)
                            ALUControl = 5'b01010; // sub
                        else
                            ALUControl = 5'b00010; // add
                    end
                    3'b110: ALUControl = 5'b00111; // or
                    3'b111: ALUControl = 5'b00011; // and
                    3'b001: ALUControl = 5'b00000; // sll
                    3'b101: ALUControl = 5'b10000; // srl
                    3'b010: ALUControl = 5'b01001; // slt
                    default: ALUControl = 5'b00000;
                endcase
            end

            // =========================
            // I-type arithmetic:
            // addi, ori, andi, slli, srli, slti
            // opcode = 0010011
            // =========================
            7'b0010011: begin
                RegWrite  = 1'b1;
                ImmSrc    = 3'b000;
                ALUSrc    = 1'b1;
                ResultSrc = 2'b01;
                PCSrc     = 2'b00;

                case (funct3)
                    3'b000: ALUControl = 5'b00010; // addi
                    3'b110: ALUControl = 5'b00111; // ori
                    3'b111: ALUControl = 5'b00011; // andi
                    3'b001: ALUControl = 5'b00000; // slli
                    3'b101: ALUControl = 5'b10000; // srli
                    3'b010: ALUControl = 5'b01001; // slti
                    default: ALUControl = 5'b00000;
                endcase
            end

            // =========================
            // lw
            // opcode = 0000011
            // =========================
            7'b0000011: begin
                RegWrite   = 1'b1;
                ImmSrc     = 3'b000;
                ALUSrc     = 1'b1;
                ALUControl = 5'b00010; // add for address
                MemWrite   = 1'b0;
                ResultSrc  = 2'b10;
                PCSrc      = 2'b00;
            end

            // =========================
            // sw
            // opcode = 0100011
            // =========================
            7'b0100011: begin
                RegWrite   = 1'b0;
                ImmSrc     = 3'b001;
                ALUSrc     = 1'b1;
                ALUControl = 5'b00010; // add for address
                MemWrite   = 1'b1;
                ResultSrc  = 2'b00;    // don't care
                PCSrc      = 2'b00;
            end

            // =========================
            // Branches: beq, bne, blt, bge
            // opcode = 1100011
            // =========================
            7'b1100011: begin
                RegWrite  = 1'b0;
                ImmSrc    = 3'b010;
                ALUSrc    = 1'b0;
                MemWrite  = 1'b0;
                ResultSrc = 2'b00; // don't care

                case (funct3)
                    3'b000: begin
                        ALUControl = 5'b01010;           // beq -> sub
                        PCSrc      = Zero ? 2'b01 : 2'b00;
                    end
                    3'b001: begin
                        ALUControl = 5'b01010;           // bne -> sub
                        PCSrc      = Zero ? 2'b00 : 2'b01;
                    end
                    3'b100: begin
                        ALUControl = 5'b01001;           // blt -> slt
                        PCSrc      = Zero ? 2'b00 : 2'b01;
                    end
                    3'b101: begin
                        ALUControl = 5'b01001;           // bge -> slt
                        PCSrc      = Zero ? 2'b01 : 2'b00;
                    end
                    default: begin
                        ALUControl = 5'b00010;
                        PCSrc      = 2'b00;
                    end
                endcase
            end

            // =========================
            // jal
            // opcode = 1101111
            // =========================
            7'b1101111: begin
                RegWrite   = 1'b1;
                ImmSrc     = 3'b100;
                ALUSrc     = 1'b0;      // don't care
                ALUControl = 5'b00000;  // don't care
                MemWrite   = 1'b0;
                ResultSrc  = 2'b11;     // write PC+4
                PCSrc      = 2'b01;
            end

            // =========================
            // jalr
            // opcode = 1100111
            // =========================
            7'b1100111: begin
                RegWrite   = 1'b1;
                ImmSrc     = 3'b000;
                ALUSrc     = 1'b1;
                ALUControl = 5'b00010;  // rs1 + imm
                MemWrite   = 1'b0;
                ResultSrc  = 2'b11;     // write PC+4
                PCSrc      = 2'b10;
            end

            // =========================
            // lui
            // opcode = 0110111
            // =========================
            7'b0110111: begin
                RegWrite   = 1'b1;
                ImmSrc     = 3'b011;
                ALUSrc     = 1'b0;      // don't care
                ALUControl = 5'b00000;  // don't care
                MemWrite   = 1'b0;
                ResultSrc  = 2'b00;     // immediate
                PCSrc      = 2'b00;
            end

            default: begin
                RegWrite   = 1'b0;
                ImmSrc     = 3'b000;
                ALUSrc     = 1'b0;
                ALUControl = 5'b00000;
                MemWrite   = 1'b0;
                ResultSrc  = 2'b00;
                PCSrc      = 2'b00;
            end
        endcase
    end

endmodule
