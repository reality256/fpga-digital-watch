//Modulo N Counter
`timescale 1ns / 1ps

module mod_n_counter #(
    parameter int N = 4,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic rst,
    input logic enable,
    output logic [WIDTH-1:0] count = WIDTH'(0)
);

  //Parameters
  localparam logic [WIDTH-1:0] Max = WIDTH'(N - 1);
  localparam logic [WIDTH-1:0] One = WIDTH'(1);
  localparam logic [WIDTH-1:0] Zero = WIDTH'(0);
  logic [WIDTH-1:0] next_count;

  //reset
  always_ff @(posedge clk) begin
    if (rst) count <= Zero;
    else if (enable) count <= next_count;
  end

  //Next state logic
  always_comb begin
    if (enable) next_count = count == Max ? Zero : count + One;
    else next_count = count;
  end
endmodule
