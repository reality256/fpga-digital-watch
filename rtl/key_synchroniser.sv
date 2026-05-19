//Key Synchroniser
`timescale 1ns / 1ps

module key_synchroniser (
    input  logic       clk,
    input  logic [3:0] key_n,              //active-low, asynchonous
    output logic [3:0] key_sync = 4'b0000  //active-high, synchronised
);

  logic [3:0] key_stage1 = 4'b0000;

  always_ff @(posedge clk) begin
    key_stage1 <= ~key_n;
    key_sync   <= key_stage1;
  end

endmodule
