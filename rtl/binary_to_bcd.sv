//Binary to Binary-Coded Decimal
`timescale 1ns / 1ps
module binary_to_bcd (
    input  logic [6:0] bin,   // binary input (0 to 99)
    output logic [3:0] tens,  // decimal tens digit
    output logic [3:0] ones   // decimal ones digit
);

  always_comb begin
    tens = 4'(bin / 7'd10);  // tens digit
    ones = 4'(bin % 7'd10);  // ones digit
  end

endmodule

