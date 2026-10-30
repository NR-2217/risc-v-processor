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

    // Pre-formatting immediate extractions based on instruction type
    always_comb begin
        case (instruction[6:0])
            7'b0100011: imm = {instruction[31:25], instruction[11:7]}; // S-type
            7'b1100011: imm = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]}; // B-type
            default:    imm = instruction[31:20]; // I-type
        endcase
    end

    always_comb begin
        case (instruction[6:0])
            7'b1101111: imm_uj = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]}; // J-type
            default:    imm_uj = instruction[31:12]; // U-type
        endcase
    end
endmodule