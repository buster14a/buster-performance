| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.29 (0.27 to 0.32)** | **0.36 (0.36 to 0.37)** | **0.37 (0.36 to 0.44)** |
| the sweep, a record swept, a first run | 0.46 (0.43 to 0.49) | 0.83 (0.80 to 1.10) | 2.05 (1.74 to 2.30) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | -0.01 (-0.23 to +0.18) | -0.19 (-0.37 to -0.02) | -0.20 (-3.86 to +1.89) |
| the tests' loop, more (its one run) | +0.05 (-0.01 to +0.19) | +0.08 (-0.01 to +0.11) | -0.15 (-2.71 to +0.98) |
| **the three together, the sweep by its second run** | **+0.38 (+0.11 to +0.51)** | **+0.19 (+0.07 to +0.42)** | **-0.38 (-3.08 to +2.15)** |
| the three together, the sweep by its first run | +0.52 (+0.27 to +0.70) | +0.79 (+0.51 to +0.92) | +1.20 (-1.23 to +3.78) |
| **the sweep, a first run less a second, ticks a chunk** | **94 (60 to 104)** | **179 (167 to 281)** | **212 (175 to 245)** |
| the sweep, ticks a chunk: a first run; a second | 242 (228 to 256); 152 (144 to 171) | 316 (304 to 416); 138 (135 to 140) | 260 (221 to 292); 47 (46 to 56) |
| the tests' bytes and loop, ticks a chunk, more | +41 (-84 to +122) | -64 (-110 to +22) | -94 (-446 to +220) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.34 (+0.28 to +0.40)** | **+0.46 (+0.41 to +0.76)** | **+0.41 (+0.24 to +0.47)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+62 (-90 to +156)** | **+109 (+32 to +227)** | **+157 (-7 to +351)** |
| the rows' other sweeps, a second run, more | +0.05 (+0.01 to +0.07) | +0.09 (+0.05 to +0.40) | +0.03 (-0.20 to +0.10) |
| of them the turns' lists and loops, where the listing is | +0.01 (-0.00 to +0.03) | +0.01 (-0.02 to +0.03) | -0.00 (-0.02 to +0.01) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | -12 (-173 to +59) | -82 (-145 to -43) | -63 (-241 to +107) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | -0.01 (-0.05 to +0.03); +69 (-53 to +97) | +0.01 (-0.04 to +0.02); +2 (-56 to +85) | +0.02 (-0.02 to +0.19); +93 (-314 to +261) |
| the kernel in place, more | -0.03 (-0.08 to +0.09) | -0.05 (-0.14 to +0.21) | +0.08 (-0.39 to +0.13) |
| the tests' other parts, more | +0.05 (-0.18 to +0.16) | -0.25 (-2.96 to +0.20) | +0.62 (-0.28 to +2.85) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.83 (8.67 to 9.08); 6.25 (6.24 to 6.36) | 12.44 (12.32 to 13.56); 6.64 (6.60 to 6.90) | 24.87 (22.07 to 27.83); 8.15 (8.00 to 8.28) |
| the timed region with no sweep in it, ticks a chunk | 29.0 (26.7 to 31.7) | 28.9 (25.8 to 29.3) | 27.9 (27.3 to 28.2) |
