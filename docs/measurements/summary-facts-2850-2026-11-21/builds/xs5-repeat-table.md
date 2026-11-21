| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.28 (0.26 to 0.28)** | **0.35 (0.34 to 0.36)** | **0.38 (0.38 to 0.40)** |
| the sweep, a record swept, a first run | 0.46 (0.44 to 0.49) | 0.85 (0.84 to 0.87) | 2.16 (1.63 to 2.66) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | +0.16 (+0.05 to +0.38) | -0.05 (-1.24 to +0.19) | -0.43 (-5.67 to +0.26) |
| the tests' loop, more (its one run) | +0.09 (-0.04 to +0.22) | +0.05 (-0.04 to +0.12) | -0.29 (-1.73 to +1.32) |
| **the three together, the sweep by its second run** | **+0.55 (+0.38 to +0.88)** | **+0.38 (-0.77 to +0.60)** | **-0.09 (-6.06 to +1.31)** |
| the three together, the sweep by its first run | +0.73 (+0.56 to +1.06) | +0.88 (-0.28 to +1.09) | +1.66 (-4.16 to +3.07) |
| **the sweep, a first run less a second, ticks a chunk** | **94 (84 to 111)** | **189 (184 to 193)** | **226 (158 to 288)** |
| the sweep, ticks a chunk: a first run; a second | 243 (230 to 256); 146 (138 to 150) | 320 (319 to 328); 133 (130 to 136) | 274 (207 to 338); 49 (48 to 51) |
| the tests' bytes and loop, ticks a chunk, more | +140 (+61 to +316) | +14 (-427 to +93) | -61 (-817 to +117) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.35 (+0.29 to +0.43)** | **+0.43 (-0.14 to +0.45)** | **+0.42 (+0.32 to +0.60)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+116 (-93 to +443)** | **+113 (-40 to +207)** | **+176 (-94 to +430)** |
| the rows' other sweeps, a second run, more | +0.07 (+0.01 to +0.15) | +0.07 (-0.49 to +0.11) | +0.04 (-0.06 to +0.22) |
| of them the turns' lists and loops, where the listing is | +0.01 (+0.00 to +0.06) | +0.01 (-0.00 to +0.02) | -0.01 (-0.02 to +0.01) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | +23 (-185 to +346) | -77 (-228 to +19) | -47 (-334 to +204) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | +0.00 (-0.10 to +0.07); +17 (-117 to +164) | +0.00 (-2.28 to +0.43); +29 (-175 to +951) | +0.01 (-0.17 to +0.84); -33 (-232 to +344) |
| the kernel in place, more | +0.04 (-0.05 to +0.08) | +0.04 (-0.04 to +1.26) | +0.00 (-0.65 to +0.40) |
| the tests' other parts, more | -0.02 (-0.24 to +0.17) | -0.03 (-0.55 to +2.67) | -0.30 (-2.03 to +1.64) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.76 (8.63 to 9.46); 6.26 (6.19 to 6.29) | 12.51 (12.24 to 15.83); 6.69 (6.63 to 7.26) | 24.91 (20.65 to 33.86); 8.07 (8.00 to 8.23) |
| the timed region with no sweep in it, ticks a chunk | 28.3 (27.2 to 29.6) | 28.0 (26.8 to 28.7) | 27.4 (27.0 to 27.8) |
