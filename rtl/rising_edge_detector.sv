//Rising-edge Detector
`timescale 1ns / 1ps
module rising_edge_detector (
    input  logic clk,
    input  logic sig_in,
    output logic rise
);

  logic sig_prev;

  always_ff @(posedge clk) begin
    sig_prev <= sig_in;
  end

  assign rise = sig_in & ~sig_prev;
endmodule
