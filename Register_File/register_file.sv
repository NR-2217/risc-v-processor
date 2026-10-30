`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2026 15:21:00
// Design Name: 
// Module Name: register_file
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


module register_file(
    input  logic [4:0]  rs1_sel, rs2_sel,   
    input  logic        reg_write,          
    input  logic        clk,
    input  logic        reset,              
    input  logic [31:0] wb_data,            
    input  logic [4:0]  rd_sel,             
    output logic [31:0] rs1_data, rs2_data  
);
    logic [31:0] registers [31:0];
    integer i;

    // Asynchronous Read
    assign rs1_data = (rs1_sel == 5'd0) ? 32'd0 : registers[rs1_sel];
    assign rs2_data = (rs2_sel == 5'd0) ? 32'd0 : registers[rs2_sel];

    // Synchronous Write with Yosys-safe for-loop reset
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;
            end
        end else if (reg_write && (rd_sel != 5'd0)) begin
            registers[rd_sel] <= wb_data;
        end
    end
endmodule
