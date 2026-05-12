//Button Auto Repeat

`timescale 1ns / 1ps

module button_auto_repeat #(
    parameter int HOLD_CYCLES   = 50_000_000,
    //REPEAT_CYCLES must be smaller than HOLD_CYCLES
    parameter int REPEAT_CYCLES = 5_000_000
) (
    input  logic clk,
    input  logic button,
    output logic pulse
);


  logic rise;
  logic held;
  logic pulse_train;

  // Compensate for the startup latency of restartable_rate_generator
  // so the first repeat pulse occurs after exactly HOLD_CYCLES cycles.
  localparam int HoldDetectCycles = HOLD_CYCLES - REPEAT_CYCLES + 1;

  assign pulse = rise | (button & pulse_train);

  rising_edge_detector u_rise (
      .clk(clk),
      .sig_in(button),
      .rise(rise)
  );

  button_hold_detect #(
      .HOLD_CYCLES(HoldDetectCycles)
  ) u_hold (
      .clk(clk),
      .button(button),
      .held(held)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(REPEAT_CYCLES)
  ) u_pulse_train (
      .clk (clk),
      .run (held),
      .tick(pulse_train)
  );

endmodule
