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
        zero = 1'b0; 
        case (alu_control)
            5'b00000: alu_out = rs1_data + rs2_data; // ADD
            5'b00001: alu_out = rs1_data - rs2_data; // SUB
            5'b00010: alu_out = rs1_data ^ rs2_data; // XOR
            5'b00011: alu_out = rs1_data | rs2_data; // OR
            5'b00100: alu_out = rs1_data & rs2_data; // AND
            5'b00101: alu_out = rs1_data << rs2_data[4:0]; // SLL
            5'b00110: alu_out = rs1_data >> rs2_data[4:0]; // SRL
            5'b00111: alu_out = $signed(rs1_data) >>> rs2_data[4:0]; // SRA
            5'b01000: alu_out = ($signed(rs1_data) < $signed(rs2_data)) ? 32'd1 : 32'd0; // SLT
            5'b01001: alu_out = (rs1_data < rs2_data) ? 32'd1 : 32'd0; // SLTU

            // Branch Conditions
            5'b01010: begin alu_out = 32'd0; zero = (rs1_data == rs2_data); end // BEQ
            5'b01011: begin alu_out = 32'd0; zero = (rs1_data != rs2_data); end // BNE
            5'b01100: begin alu_out = 32'd0; zero = ($signed(rs1_data) < $signed(rs2_data)); end // BLT
            5'b01101: begin alu_out = 32'd0; zero = ($signed(rs1_data) >= $signed(rs2_data)); end // BGE
            5'b01110: begin alu_out = 32'd0; zero = (rs1_data < rs2_data); end // BLTU
            5'b01111: begin alu_out = 32'd0; zero = (rs1_data >= rs2_data); end // BGEU
            
            default: alu_out = 32'd0;
        endcase
    end
endmodule