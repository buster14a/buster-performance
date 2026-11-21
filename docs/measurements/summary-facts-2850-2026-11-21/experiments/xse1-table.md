| | `sqlite3.c` | Lua |
| --- | ---: | ---: |
| records swept; records listed for a reference; calls asked | 321,434; 14,911; 255 | 91,252; 5,128; 127 |
| the sweep as it is, a record swept, a chunk's second run (a region's two timer reads in it) | 0.34 (0.33 to 0.61) | 0.44 (0.43 to 0.44) |
| the same executable and setting twice in a reading, the second less the first | -0.02 (-0.51 to -0.01) | -0.00 (-0.01 to +0.01) |
| **with no objects' loop, more** | **-0.09 (-0.35 to -0.09)** | **-0.11 (-0.12 to -0.11)** |
| **with the objects by a gather of eight, more** | **+0.01 (-0.25 to +0.02)** | **-0.04 (-0.05 to -0.02)** |
| with no call asked, more | -0.02 (-0.29 to -0.01) | -0.04 (-0.05 to -0.03) |
| a first run: with no objects' loop, more; with the gather, more; with no call asked, more | -0.12 (-0.35 to -0.12); -0.05 (-0.26 to -0.03); -0.06 (-0.30 to -0.02) | -0.15 (-0.17 to -0.14); -0.07 (-0.10 to -0.00); -0.13 (-0.22 to -0.08) |
