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

### Implementing Init Write
In order to implement the axi slave logic I used the Vivado generated slave logic
and modified the 4th registed to only go high for one clock cycle when it is
written to. The logic for this looks roughly like:
```
case statement for registers which happens @ posedge clk
    case reg 0:
        set reg 0 to input
        set init_write to zero
    case reg 1:
        set reg 1 to input
        set init_write to zero
    ...
    case reg 3 (init_write):
        set init_write to high
    default:
        set init_write to zero
```
This way init\_write only goes high on the clock cycle it's written to in.

### Implementing AXI-lite Master
The AXI-lite master logic was implemented by using Vivado's generated AXI-lite
master logic. The read channel logic was removed and the WADDR was wired directly
to the output address from the AXI-lite slave. The WDATA was wired directly to the
value\_out from the mask532 module. The init\_write signal would initate the axi
transactions.

## Task 3 Report

### Testbench Functionality
The testbench simulates the intended usage of the mask532 module. I used the
AXI VIP tutorial helper functions to allow me to write to the VIP.
The testbench does the following:
1. Write to the register for n.
2. Write to the register for value\_in
3. Write to the register for addr\_out.
4. Write to the 4th register to start an AXI-lite master write.
5. Wait for all transactions to complete.
6. Read from BRAM to confirm that the correct value was written at the correct location.

The testbench does not

### Description of Input Selection
I chose those inputs for my testbench because it made the testbench easy to verify.
I did not attempt to try many different values of n or value\_in because that is covered
in my testbench for part 1.

### Summary of Simulation Output
The simulation uses the `$write` function to output the value written to BRAM
by the `mask532_axi` module. The output of my simulation looks roughly like this:
```
Value written to BRAM: 0x3fffffff
```
This is the value I expected because `value_in` was set to 0xffffffff and `n` was set to 3.
i.e. `value_out` should equal 0x3fffffff & 0xffffffff = 0x3fffffff.
