`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 14:14:38
// Design Name: 
// Module Name: ex_stage
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

module ex_stage (
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data,
    input  logic [31:0] imm_out,
    input  logic [31:0] address,       // current PC
    input  logic        branch,
    input  logic        alu_src,       // 0 = rs2_data, 1 = imm_out
    input  logic        fn7_5,
    input  logic        mux_inp,       // 1 = JALR
    input  logic [2:0]  fn3,
    input  logic [6:0]  imm11_5,
    input  logic [2:0]  aluop,
    input  logic [6:0]  opcode,
    output logic        and_out_ex,    // branch / jump taken
    output logic [31:0] alu_out,
    output logic [31:0] pc_ex_out      // branch / jump target
);

    logic [31:0] alu_in_2;
    logic        zero;
    logic        less_than;
    logic        branch_condition_met;

    assign alu_in_2 = (alu_src) ? imm_out : rs2_data;

    // Target Address Adder (mux_inp separates JALR base address from Branch/JAL base address)
    assign pc_ex_out = (mux_inp) ? (rs1_data + imm_out) : (address + imm_out);

    // ALU Execution Unit
    always_comb begin
        alu_out = 32'd0; 
        
        if (aluop == 3'b010) begin // R-Type or I-Type computation
            case (fn3)
                3'b000: begin
                    if (opcode == 7'b0110011 && fn7_5) 
                        alu_out = rs1_data - alu_in_2; // SUB
                    else 
                        alu_out = rs1_data + alu_in_2; // ADD
                end
                3'b001: alu_out = rs1_data << alu_in_2[4:0];           // SLL
                3'b100: alu_out = rs1_data ^ alu_in_2;                 // XOR
                3'b101: begin
                    if (fn7_5) alu_out = $signed(rs1_data) >>> alu_in_2[4:0]; // SRA
                    else       alu_out = rs1_data >> alu_in_2[4:0];           // SRL
                end
                3'b110: alu_out = rs1_data | alu_in_2;                 // OR
                3'b111: alu_out = rs1_data & alu_in_2;                 // AND
                default: alu_out = rs1_data + alu_in_2;
            endcase
        end else if (aluop == 3'b000) begin // Load / Store Address Calculation
            alu_out = rs1_data + alu_in_2;
        end else if (aluop == 3'b001) begin // Branch Subtraction
            alu_out = rs1_data - alu_in_2;
        end else if (aluop == 3'b011) begin // U-Type Pass-Through (LUI / AUIPC logic can be resolved here or upstream)
            alu_out = (opcode == 7'b0010111) ? (address + imm_out) : imm_out; 
        end
    end

    // Branch condition evaluations
    assign zero = (alu_out == 32'd0);
    assign less_than = ($signed(rs1_data) < $signed(rs2_data));
    logic less_than_u;
    assign less_than_u = (rs1_data < rs2_data);

    always_comb begin
        case (fn3)
            3'b000: branch_condition_met = zero;          // BEQ
            3'b001: branch_condition_met = !zero;         // BNE
            3'b100: branch_condition_met = less_than;     // BLT
            3'b101: branch_condition_met = !less_than;    // BGE
            3'b110: branch_condition_met = less_than_u;   // BLTU
            3'b111: branch_condition_met = !less_than_u;  // BGEU
            default: branch_condition_met = 1'b0;
        endcase
    end

    // Final Next-PC Selection Gate
    assign and_out_ex = (branch && branch_condition_met) || (opcode == 7'b1101111) || (opcode == 7'b1100111);

endmodule
