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
    input  logic [31:0] address,       
    input  logic        branch,
    input  logic        alu_src,       
    input  logic        fn7_5,
    input  logic        mux_inp,       
    input  logic [2:0]  fn3,
    input  logic [6:0]  imm11_5,
    input  logic [2:0]  aluop,
    input  logic [6:0]  opcode,
    output logic        and_out_ex,    
    output logic [31:0] alu_out,
    output logic [31:0] pc_ex_out      
);
    logic [4:0] alu_control_wire;
    logic       zero;
    logic [31:0] alu_in_2;

    assign alu_in_2 = (alu_src) ? imm_out : rs2_data;
    assign pc_ex_out = (mux_inp) ? (rs1_data + imm_out) : (address + imm_out);

    // ALU branch condition ('zero') determines if standard branches are taken
    assign and_out_ex = (branch && zero) || (opcode == 7'b1101111) || (opcode == 7'b1100111);

    alu_control ac (
        .alu_op(aluop),
        .fn3(fn3),
        .imm11_5(imm11_5),
        .fn7_5(fn7_5),
        .control_out(alu_control_wire)
    );

    alu alu_inst (
        .alu_control(alu_control_wire),
        .rs1_data(rs1_data),
        .rs2_data(alu_in_2),
        .alu_out(alu_out),
        .zero(zero)
    );
endmodule