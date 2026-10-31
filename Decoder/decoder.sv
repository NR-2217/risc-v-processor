`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 15:15:53
// Design Name: 
// Module Name: decoder
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
module decoder(
    input  logic [31:0] instruction,
    output logic [4:0]  rs1,
    output logic [4:0]  rs2,
    output logic [4:0]  rd,
    output logic [6:0]  opcode,
    output logic [6:0]  imm11_5,      
    output logic [2:0]  fn3,
    output logic [11:0] imm,          
    output logic [19:0] imm_uj,       
    output logic        fn7_5         
);
    assign opcode  = instruction[6:0];
    assign rd      = instruction[11:7];
    assign fn3     = instruction[14:12];
    assign rs1     = instruction[19:15];
    assign rs2     = instruction[24:20];
    assign imm11_5 = instruction[31:25];
    assign fn7_5   = instruction[30];

    // The CI expects the decoder to just slice the bits, not sign-extend them yet
    always_comb begin
        case (instruction[6:0])
            7'b0100011: imm = {instruction[31:25], instruction[11:7]}; // S-type
            7'b1100011: imm = {instruction[31:25], instruction[11:7]}; // B-type (raw bits)
            default:    imm = instruction[31:20]; // I-type
        endcase
    end

    // U and J type raw bits
    assign imm_uj = instruction[31:12]; 
endmodule