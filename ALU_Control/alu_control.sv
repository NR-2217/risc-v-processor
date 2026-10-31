`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 15:23:28
// Design Name: 
// Module Name: alu_control
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
module alu_control (
    input  logic [2:0] alu_op,        
    input  logic [2:0] fn3,
    input  logic [6:0] imm11_5,       
    input  logic       fn7_5,         
    output logic [4:0] control_out
);
    always_comb begin
        case (alu_op)
            3'b000: control_out = 5'b00000; // ADD 
            3'b001: control_out = {2'b11, fn3}; // Encodes exact branch type to ALU
            3'b100: control_out = 5'b10000; // PASS B for U-Type
            3'b010: begin // R-type
                case (fn3)
                    3'b000: control_out = fn7_5 ? 5'b01000 : 5'b00000; // SUB : ADD
                    3'b001: control_out = 5'b00001; // SLL
                    3'b010: control_out = 5'b00010; // SLT
                    3'b011: control_out = 5'b00011; // SLTU
                    3'b100: control_out = 5'b00100; // XOR
                    3'b101: control_out = fn7_5 ? 5'b01101 : 5'b00101; // SRA : SRL
                    3'b110: control_out = 5'b00110; // OR
                    3'b111: control_out = 5'b00111; // AND
                endcase
            end
            3'b011: begin // I-type
                case (fn3)
                    3'b000: control_out = 5'b00000; // ADD
                    3'b001: control_out = 5'b00001; // SLL
                    3'b010: control_out = 5'b00010; // SLT
                    3'b011: control_out = 5'b00011; // SLTU
                    3'b100: control_out = 5'b00100; // XOR
                    3'b101: control_out = imm11_5[5] ? 5'b01101 : 5'b00101; // SRAI : SRLI
                    3'b110: control_out = 5'b00110; // OR
                    3'b111: control_out = 5'b00111; // AND
                endcase
            end
            default: control_out = 5'b00000;
        endcase
    end
endmodule