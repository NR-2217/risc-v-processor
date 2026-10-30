`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 15:19:19
// Design Name: 
// Module Name: imm_generator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module imm_generator(
    input  logic [11:0] imm_input,       
    input  logic [2:0]  fn3,
    input  logic [6:0]  opcode,
    input  logic [19:0] imm_input_uj,    
    output logic [31:0] imm_output
);
    always_comb begin
        case (opcode)
            7'b0110111, 7'b0010111: // U-Type (LUI, AUIPC)
                imm_output = {imm_input_uj, 12'd0};
            7'b1101111: // J-Type (JAL)
                imm_output = {{11{imm_input_uj[19]}}, imm_input_uj, 1'b0};
            7'b1100011: // B-Type (Branch)
                imm_output = {{19{imm_input[11]}}, imm_input, 1'b0};
            default: // I-Type, S-Type, JALR
                imm_output = {{20{imm_input[11]}}, imm_input};
        endcase
    end
endmodule
