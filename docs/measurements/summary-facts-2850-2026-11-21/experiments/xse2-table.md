| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records listed for a reference; a chunk | 14,911; 24.4 | 5,128; 21.3 | 11,522; 3.9 |
| the sweep with the loop, a record swept, a chunk's second run (a region's two timer reads in it) | 0.33 (0.32 to 0.34) | 0.44 (0.44 to 0.45) | 0.68 (0.68 to 0.73) |
| the same executable and setting twice in a reading, the second less the first | +0.01 (-0.01 to +0.02) | -0.00 (-0.01 to +0.02) | -0.01 (-0.09 to +0.01) |
| **with a gather of eight quadwords, more** | **+0.00 (-0.00 to +0.09)** | **-0.07 (-0.08 to -0.05)** | **-0.14 (-0.19 to -0.13)** |
| with a gather of sixteen doublewords, more | +0.06 (+0.04 to +0.08) | -0.06 (-0.07 to -0.05) | -0.15 (-0.20 to -0.14) |
| a first run: with the loop | 0.64 (0.59 to 0.65) | 1.29 (1.27 to 1.32) | 2.71 (2.35 to 3.60) |
| **a first run: with a gather of eight, more** | **-0.04 (-0.07 to +0.02)** | **-0.06 (-0.10 to +0.01)** | **-0.40 (-0.84 to -0.27)** |
| a first run: with a gather of sixteen, more | -0.01 (-0.07 to +0.02) | -0.11 (-0.14 to +0.86) | -0.60 (-1.13 to -0.49) |
