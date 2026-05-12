// Variable-Speed Time Display
`timescale 1ns / 1ps
module top_time_display_v1 #(
    parameter int CYCLES_PER_SECOND = 50_000_000
) (
    input logic CLOCK_50,
    input logic [1:0] SW,
    output logic [6:0] HEX5,
    output logic [6:0] HEX4,
    output logic [6:0] HEX3,
    output logic [6:0] HEX2,
    output logic [6:0] HEX1,
    output logic [6:0] HEX0
);


  logic [4:0] hours;
  logic [5:0] minutes;
  logic [5:0] seconds;

  logic one_hz_tick;
  logic twentyfive_hz_tick;
  logic one_khz_tick;

  logic [3:0] hrs_tens;
  logic [3:0] hrs_ones;
  logic [3:0] min_tens;
  logic [3:0] min_ones;
  logic [3:0] sec_tens;
  logic [3:0] sec_ones;

  logic time_tick;

  always_comb begin
    case (SW)
      2'b00:   time_tick = one_hz_tick;
      2'b01:   time_tick = twentyfive_hz_tick;
      2'b10:   time_tick = one_khz_tick;
      default: time_tick = 1'b1;
    endcase
  end

  hms_counter #(
      .N_HOURS  (24),
      .N_MINUTES(60),
      .N_SECONDS(60),
      .W_HOURS  (5),
      .W_MINUTES(6),
      .W_SECONDS(6)
  ) counter (
      .clk(CLOCK_50),
      .enable(time_tick),
      .hours(hours),
      .minutes(minutes),
      .seconds(seconds)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND)
  ) one_hz_gen (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(one_hz_tick)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 25)
  ) twentyfive_hz_gen (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(twentyfive_hz_tick)
  );

  restartable_rate_generator #(
      .CYCLE_COUNT(CYCLES_PER_SECOND / 1_000)
  ) one_khz_gen (
      .clk (CLOCK_50),
      .run (1'b1),
      .tick(one_khz_tick)
  );

  binary_to_bcd bcd_hours (
      .bin ({2'b0, hours}),
      .tens(hrs_tens),
      .ones(hrs_ones)
  );

  binary_to_bcd bcd_minutes (
      .bin ({1'b0, minutes}),
      .tens(min_tens),
      .ones(min_ones)
  );

  binary_to_bcd bcd_seconds (
      .bin ({1'b0, seconds}),
      .tens(sec_tens),
      .ones(sec_ones)
  );

  seven_segment hour_tens_display (
      .digit(hrs_tens),
      .blank(1'b0),
      .segments(HEX5)
  );

  seven_segment hour_ones_display (
      .digit(hrs_ones),
      .blank(1'b0),
      .segments(HEX4)
  );

  seven_segment minute_tens_display (
      .digit(min_tens),
      .blank(1'b0),
      .segments(HEX3)
  );

  seven_segment minute_ones_display (
      .digit(min_ones),
      .blank(1'b0),
      .segments(HEX2)
  );

  seven_segment second_tens_display (
      .digit(sec_tens),
      .blank(1'b0),
      .segments(HEX1)
  );

  seven_segment second_ones_display (
      .digit(sec_ones),
      .blank(1'b0),
      .segments(HEX0)
  );
endmodule
