# Assignment 1 Report
## Task 1 Report
### Description of Test Inputs
I used the value\_in `0xffffffff` because it made it very easy
to see which bits were being masked out. I chose the value of n
to be every possible value i.e. range [0...32). This combination
of inputs allowed me to quickly verify that my module was working
as expected.
### Summary of Outputs
- `waveform viewer`: The output is a pictorial representation of the signals
   in the testbench. This representation can be saved as a .wdb file.
- `$display`: Displays a string on the terminal / output screen. It can be used
   to print various values from your testbench.
- `$monitor`: Same as `$display` but used SystemVerilogs async message queue.
   This allows paralell simulation messages to be printed in FIFO order.

### Discussion of Simulation Methods
Each simulation methodology has it's pros and cons
`$display`/`$monitor` both use print statements which allows
engineers to quickly inspect large inputs or sequences.

The waveform viewer is good if you need a visual confirmion that something
is working. This is especially helpful with timing problems.

I acutally prefer using hard assertions in the testbenches I make
as apposed to relying on the waveform viewer or `$display`/`monitor`.
It allows engineers to automate the test bench and communicate what is expected
behaviour to a naive reader.

## Task 2 Report
