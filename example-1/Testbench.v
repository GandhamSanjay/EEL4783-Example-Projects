`timescale 1ns / 1ns

module Processor_tb();

reg clk = 0;
Processor proc_inst(.clk(clk));
always #5 clk = !clk;
endmodule


 