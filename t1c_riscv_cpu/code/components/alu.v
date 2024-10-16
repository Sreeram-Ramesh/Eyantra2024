
// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       [WIDTH-1:0] a, b,       // operands
    input       [2:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      overflow, zero                   // zero flag
);

always @(a, b, alu_ctrl) begin
    case (alu_ctrl)
        3'b000:  alu_out <= a + b;       // ADD
        3'b001:  alu_out <= a + ~b + 1;  // SUB
        3'b010:  alu_out <= a & b;       // AND
        3'b011:  alu_out <= a | b;       // OR
        3'b100:  alu_out <= a << b;      // SLL operation
        3'b101: begin                     // SLT / SLTI / SLTIU
            if (alu_ctrl == 3'b101) begin // Handle both SLT and SLTIU
                // Unsigned comparison for SLTIU
                alu_out <= (a < b) ? 1 : 0; // SLTIU: treat a and b as unsigned
            end else begin // Handle signed comparison for SLT
                if (a[31] != b[31])
                    alu_out <= a[31] ? 0 : 1; // Different sign
                else
                    alu_out <= a < b ? 1 : 0;  // Signed comparison
            end
        end
        3'b110:  alu_out <= a ^ b; // XOR , XORI
        default: alu_out = 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;
assign overflow = (a<b) ? 1'b1 : 1'b0;

endmodule

