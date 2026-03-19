`timescale 1ns/1ps // Define time units and resolution
`include "and.sv" // Include all modules being used in this module
module and2_tb;
logic a, b, y; // Declare the variables being used by the testbench
and2 dut (a, b, y); // Instantiate the module under test. dut (device
// under test) is the name we have chosen
initial begin // Single pass behaviour which starts at time 0 ns
 $dumpfile("and2_tb.vcd"); // Dump variable changes in the vcd file
 $dumpvars(0, and2_tb); // Specifies which variables to dump in the vcd file
 a = 0; b = 0; #20; // Set variable values and set time delays
 b = 1; #20;
 a = 1; #20;
 b = 0; #20;
end
initial begin // Single pass behaviour which starts at time 0 ns
 $monitor("t = %3d, a = %b, b = %b, y = %b \n", $time, a, b, y);
end // Print variable
// values on screen
endmodule