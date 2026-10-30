`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 14:11:53
// Design Name: 
// Module Name: if_stage
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


module if_stage (
    input  logic        clk,
    input  logic        reset,              // Asynchronous, active high
    input  logic        stall,              // Hold the PC
    input  logic        and_out,            // 1 = take branch/jump target
    input  logic [31:0] pc_signed_offset,   // Branch / jump target address
    output logic [31:0] address,            // Current PC
    output logic [31:0] pc_new              // PC + 4
);

    logic [31:0] pc_reg;

    assign address = pc_reg;
    assign pc_new  = pc_reg + 32'd4;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            
            pc_reg <= 32'h8000_0000;
        end else if (!stall) begin
            if (and_out) begin
                pc_reg <= pc_signed_offset;
            end else begin
                pc_reg <= pc_new;
            end
        end
    end

endmodule
