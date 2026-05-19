//Editable Counter
`timescale 1ns / 1ps

module editable_counter #(
    parameter int N = 60,
    parameter int WIDTH = 6
) (
    input logic clk,
    input logic tick,  //Count incremets on tick when edit_mode is low
    input logic edit_mode,
    input logic inc,  //Count incremets by one when edit_mode is high
    input logic dec,  //Count decrements by one when edit_mode is high
    output logic [WIDTH-1:0] count
);

  logic enable;
  logic up;

  up_down_counter #(
      .MAX  (N - 1),
      .WIDTH(WIDTH)
  ) u_counter (
      .clk(clk),
      .enable(enable),
      .up(up),
      .count(count)
  );


  //If both inc and dec are high simultaneously, count should not change.
  wire inc_event = edit_mode && inc && !dec;
  wire dec_event = edit_mode && dec && !inc;
  wire tick_event = tick && !edit_mode;

  assign up = inc_event || tick_event;
  assign enable = inc_event || dec_event || tick_event;

endmodule
