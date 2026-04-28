//An up_down counter
`timescale 1ns / 1ps

module up_down_counter #(
    parameter int MAX   = 2,
    parameter int WIDTH = 2
) (
    input logic clk,
    input logic enable,
    input logic up,
    output logic [WIDTH-1:0] count
);
  //Parameters
  localparam logic [WIDTH-1:0] Max = WIDTH'(MAX);
  localparam logic [WIDTH-1:0] One = WIDTH'(1);
  localparam logic [WIDTH-1:0] Zero = WIDTH'(0);
  logic [WIDTH-1:0] next_count;

  //State initialization
  initial count = WIDTH'(0);

  //State register
  always_ff @(posedge clk) if (enable) count <= next_count;

  //Next state logic
  always_comb begin
    if (enable) begin
      if (up) next_count = count == Max ? Zero : count + One;
      else next_count = count == Zero ? Max : count - One;
    end else next_count = count;
  end

endmodule
