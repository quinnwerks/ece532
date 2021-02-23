# Assignment 1 Report
## Part 1
### Utilization Table

|         |           | Slice LUTs | Slice Registers | Block RAMs |
|---------|-----------|------------|-----------------|------------|
| 256*32  | Registers | 4616       | 8256            | 0          |
|         | BRAM      | 0          | 0               | 1          |
|         | DRAM      | 420        | 64              | 0          |
| 1024*32 | Registers | 18911      | 32832           | 0          |
|         | BRAM      | 0          | 0               | 2          |
|         | DRAM      | 1680       | 64              | 0          |

### Discussion
BRAM in general is better for large memories because it is denser.
DRAM is good if you have small memories because it uses only the resources
it needs (a BRAM tile has a minimum size). If you attempted to use DRAM
to implement large memories you can end up taking a large amount of the boards
resources. I would never use the `registers` option over BRAM/DRAM unless they were
not offered by the synthesis tool. The resource requirements to implement memory
purely in registers is absurd. Also as a side note synthesis implements register memory
much more slowly than BRAM/DRAM.

## Part 2
### Utilization Table and Fmax
|    |           | Slice LUTs | Slice Registers | Block RAMs | DSPs   | Fmax   |
|----|-----------|------------|-----------------|------------|--------|--------|
| 16 | With DSPs | 0          | 0               | 0          | 1      | 157.70 |
|    | No DSPs   | 328        | 48              | 0          | 0      |  91.54 |
| 32 | With DSPs | 48         | 0               | 0          | 5      |  79.84 |
|    | No DSPs   | 1139       | 96              | 0          | 0      |  83.44 |

#### FMax Calculations

```
Calculated using the worst unconstrained path delay of each circuit.
16, No DSPs: Worst delay:   10.924 ns => Fmax = 1 / (10.924e-9) =  91.54 MHz
16, With DSPs: Worst delay:  6.341 ns => Fmax = 1 / ( 6.341e-9) = 157.70 MHz
32, No DSPs: Worst delay:   11.984 ns => Fmax = 1 / (11.984e-9) =  83.44 MHz
32, With DSPs: Worst delay: 12.524 ns => Fmax = 1 / (12.524e-9) =  79.84 MHz
```
### Implementation Discussion
I inferered a DSP using the Xillinx guides as a reference. When the width was set
to 32 bits 4 more DSPs were used and some LUTs were used as well.

### Discussion: LUTs vs. DSPs
The DSP implementations performed much better in terms of FMax than the no dsp version
at 16 bits. At 32 bits the no DSP version performed slighly better than the version with DSPs.
In terms of area, using no DSPs takes quite a large number of generic resources (LUTS, registers)
compared to its DSP counterparts.

I think DSPs are generally the better choice if you have a computation step that fits
roughly within the size of a single DSP. That way you can easily chain DSPs together
to form a pipeline. If you have very wide numbers then DSPs might not be as fesable simply
because there are not very many of them available on the board. The FMax above demonstrates this
behaviour. The 16 bit computations fit into a single DSP and therefore are more efficeint than it's
32 bit counterpart which spilled onto LUTs.

## Part 3
### Utilization Table
|                   | Slice LUTs | Slice Registers | Block RAMs | DSPs   |
|-------------------|------------|-----------------|------------|--------|
| BRAM Impl         | 0          | 0               | 1          | 0      |
| Multiplier Impl   | 55         | 0               | 0          | 1      |

### Discussion
In general I think the lookup table approach is better because of it's speed.
BRAM is very dense and therefore would be faster. This approach is not fesable
if the lookup table has to be very large. If you have to cube very large numbers then using
the multiplier impl is better.

Numbers to back this up:
```
delay for bram impl: 1.855 ns
delay for multiplier impl: 6.335 ns
```
It is possible to combine the two approaches where you can have a lookup table for commonly
searched values and then use a multiplier if you don't have the value in the lookup table.
You would need some sort of pipeline to get this to work but the added complexity might
be worth it depending on the performance requirements of the application.
