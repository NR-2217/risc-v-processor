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
    input  logic [31:0] wb_data,        // data to write back (from the WB stage)
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

    // Register File implementation
    logic [31:0] registers [31:0];
    integer i;

    // Decode explicit instruction fields
    assign opcode_out_d = instruction[6:0];
    assign fn3_out_d    = instruction[14:12];
    assign fn7_5        = instruction[30];
    assign imm11_5      = instruction[31:25];
    
    logic [4:0] rs1 = instruction[19:15];
    logic [4:0] rs2 = instruction[24:20];
    logic [4:0] rd  = instruction[11:7];

    // Asynchronous Read
    assign rs1_data = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
    assign rs2_data = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

    // Main Control unit logic 
    logic reg_write;
    always_comb begin
        // Defaults to avoid latches
        aluop = 3'b000; memtoreg = 2'b00; branch = 1'b0; 
        mem_write = 1'b0; mem_read = 1'b0; alu_src = 1'b0; mux_inp = 1'b0; reg_write = 1'b0;

        case (opcode_out_d)
            7'b0110011: begin // R-Type
                aluop = 3'b010; reg_write = 1'b1;
            end
            7'b0010011: begin // I-Type ALU
                aluop = 3'b010; alu_src = 1'b1; reg_write = 1'b1;
            end
            7'b0000011: begin // Load
                aluop = 3'b000; alu_src = 1'b1; mem_read = 1'b1; memtoreg = 2'b01; reg_write = 1'b1;
            end
            7'b0100011: begin // Store
                aluop = 3'b000; alu_src = 1'b1; mem_write = 1'b1;
            end
            7'b1100011: begin // Branch
                aluop = 3'b001; branch = 1'b1;
            end
            7'b1101111: begin // JAL
                memtoreg = 2'b10; branch = 1'b1; reg_write = 1'b1;
            end
            7'b1100111: begin // JALR
                memtoreg = 2'b10; branch = 1'b1; alu_src = 1'b1; mux_inp = 1'b1; reg_write = 1'b1;
            end
            7'b0110111, 7'b0010111: begin // LUI, AUIPC
                aluop = 3'b011; alu_src = 1'b1; reg_write = 1'b1;
            end
        endcase
    end

    // Register File Write (Synchronous)
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear registers with a for loop to avoid Yosys synthesis limits
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (!stall && reg_write && (rd != 5'd0)) begin
            registers[rd] <= wb_data;
        end
    end

    // Immediate Generation logic
    always_comb begin
        case (opcode_out_d)
            7'b0010011, 7'b0000011, 7'b1100111: // I-Type
                imm_out = {{20{instruction[31]}}, instruction[31:20]};
            7'b0100011: // S-Type
                imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            7'b1100011: // B-Type
                imm_out = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            7'b1101111: // J-Type
                imm_out = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
            7'b0110111, 7'b0010111: // U-Type
                imm_out = {instruction[31:12], 12'b0};
            default:
                imm_out = 32'd0;
        endcase
    end

endmodule