//Button Hold Detect
`timescale 1ns / 1ps
module button_hold_detect #(
    parameter int HOLD_CYCLES = 50_000_000
) (
    input  logic clk,
    input  logic button,
    output logic held
);

  localparam int CountMax = HOLD_CYCLES;
  localparam int CountWidth = $clog2(CountMax + 1);

  logic count_rst;
  logic count_enable;
  logic [CountWidth-1:0] count;

  mod_n_counter #(
      .N    (CountMax + 1),
      .WIDTH(CountWidth)
  ) u_counter (
      .clk   (clk),
      .rst   (count_rst),
      .enable(count_enable),
      .count (count)
  );
  // Reset the counter whenever the button is released
  assign count_rst = ~button;

  // Count only while button is pressed and the counter has not reached CountMax
  assign count_enable = button && (count < CountWidth'(CountMax));

  // held becomes 1 once the button has been held long enough
  assign held = button && (count == CountWidth'(CountMax));

endmodule
