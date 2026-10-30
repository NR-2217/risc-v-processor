`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 15:28:20
// Design Name: 
// Module Name: alu
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

module alu #(parameter int DATA_WIDTH = 32)(
    input  logic [4:0]            alu_control,
    input  logic [DATA_WIDTH-1:0] rs1_data,
    input  logic [DATA_WIDTH-1:0] rs2_data,
    output logic [DATA_WIDTH-1:0] alu_out,
    output logic                  zero          
);
    always_comb begin
        zero = 1'b0; // Default zero flag
        
        case (alu_control)
            // Standard Arithmetic & Logic
            5'b00000: alu_out = rs1_data + rs2_data; // ADD
            5'b01000: alu_out = rs1_data - rs2_data; // SUB
            5'b00001: alu_out = rs1_data << rs2_data[4:0]; // SLL
            5'b00010: alu_out = ($signed(rs1_data) < $signed(rs2_data)) ? 32'd1 : 32'd0; // SLT
            5'b00011: alu_out = (rs1_data < rs2_data) ? 32'd1 : 32'd0; // SLTU
            5'b00100: alu_out = rs1_data ^ rs2_data; // XOR
            5'b00101: alu_out = rs1_data >> rs2_data[4:0]; // SRL
            5'b01101: alu_out = $signed(rs1_data) >>> rs2_data[4:0]; // SRA
            5'b00110: alu_out = rs1_data | rs2_data; // OR
            5'b00111: alu_out = rs1_data & rs2_data; // AND
            5'b10000: alu_out = rs2_data; // U-Type Pass-through

            // Branch Conditions (Encoded as 11xxx from ALU_Control)
            5'b11000: begin alu_out = rs1_data - rs2_data; zero = (rs1_data == rs2_data); end // BEQ
            5'b11001: begin alu_out = rs1_data - rs2_data; zero = (rs1_data != rs2_data); end // BNE
            5'b11100: begin alu_out = rs1_data - rs2_data; zero = ($signed(rs1_data) < $signed(rs2_data)); end // BLT
            5'b11101: begin alu_out = rs1_data - rs2_data; zero = ($signed(rs1_data) >= $signed(rs2_data)); end // BGE
            5'b11110: begin alu_out = rs1_data - rs2_data; zero = (rs1_data < rs2_data); end // BLTU
            5'b11111: begin alu_out = rs1_data - rs2_data; zero = (rs1_data >= rs2_data); end // BGEU

            default: alu_out = 32'd0;
        endcase
    end
endmodule