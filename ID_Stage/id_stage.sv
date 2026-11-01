`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 14:13:31
// Design Name: 
// Module Name: id_stage
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
module id_stage(
    input  logic        clk,
    input  logic        reset,
    input  logic        stall,
    input  logic [31:0] instruction,
    input  logic [31:0] wb_data,
    output logic [31:0] rs1_data,
    output logic [31:0] rs2_data,
    output logic [31:0] imm_out,
    output logic [6:0]  opcode_out_d,
    output logic [6:0]  imm11_5,
    output logic [2:0]  fn3_out_d,
    output logic        fn7_5,
    output logic [2:0]  aluop,
    output logic [1:0]  memtoreg,
    output logic        branch,
    output logic        mem_write,
    output logic        mem_read,
    output logic        alu_src,
    output logic        mux_inp
);
    logic [4:0] rs1, rs2, rd;
    logic [11:0] imm;
    logic [19:0] imm_uj;
    logic reg_write_ctrl;
    
    decoder dec_inst (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode_out_d),
        .imm11_5(imm11_5),
        .fn3(fn3_out_d),
        .imm(imm),
        .imm_uj(imm_uj),
        .fn7_5(fn7_5)
    );

    imm_generator imm_gen_inst (
        .imm_input(imm),
        .fn3(fn3_out_d),
        .opcode(opcode_out_d),
        .imm_input_uj(imm_uj),
        .imm_output(imm_out)
    );

    main_control mc_inst (
        .opcode(opcode_out_d),
        .fn3(fn3_out_d),
        .memtoreg(memtoreg),
        .branch(branch),
        .mux_inp(mux_inp),
        .memread(mem_read),
        .memwrite(mem_write),
        .alusrc(alu_src),
        .reg_write(reg_write_ctrl),
        .aluop(aluop)
    );

    logic gated_reg_write;
    assign gated_reg_write = reg_write_ctrl && !stall;

    register_file rf_inst (
        .rs1_sel(rs1),
        .rs2_sel(rs2),
        .reg_write(gated_reg_write),
        .clk(clk),
        .reset(reset),
        .wb_data(wb_data),
        .rd_sel(rd),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );
endmodule