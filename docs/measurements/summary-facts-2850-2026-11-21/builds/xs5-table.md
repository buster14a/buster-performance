| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.27 (0.27 to 0.28)** | **0.36 (0.35 to 0.36)** | **0.39 (0.38 to 0.40)** |
| the sweep, a record swept, a first run | 0.44 (0.42 to 0.49) | 0.84 (0.82 to 0.89) | 1.93 (1.46 to 2.73) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | +0.19 (-0.31 to +0.72) | -0.11 (-0.84 to +6.15) | -0.83 (-2.25 to +2.82) |
| the tests' loop, more (its one run) | +0.14 (-0.01 to +0.31) | +0.09 (-0.14 to +1.15) | +0.05 (-0.83 to +5.18) |
| **the three together, the sweep by its second run** | **+0.61 (+0.09 to +1.08)** | **+0.89 (-0.43 to +6.37)** | **-0.88 (-1.69 to +5.18)** |
| the three together, the sweep by its first run | +0.80 (+0.24 to +1.26) | +1.41 (+0.04 to +6.84) | +1.45 (-0.14 to +6.47) |
| **the sweep, a first run less a second, ticks a chunk** | **86 (78 to 115)** | **184 (175 to 200)** | **196 (137 to 295)** |
| the sweep, ticks a chunk: a first run; a second | 232 (221 to 259); 144 (141 to 149) | 318 (311 to 335); 136 (133 to 138) | 245 (185 to 346); 50 (49 to 51) |
| the tests' bytes and loop, ticks a chunk, more | +181 (-94 to +423) | +200 (-296 to +2275) | -162 (-263 to +607) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.31 (+0.25 to +0.37)** | **+0.43 (+0.41 to +0.64)** | **+0.48 (-0.78 to +1.19)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+19 (-135 to +123)** | **+102 (+97 to +252)** | **+165 (-125 to +407)** |
| the rows' other sweeps, a second run, more | +0.05 (-0.02 to +0.09) | +0.07 (+0.05 to +0.28) | +0.08 (-1.17 to +0.81) |
| of them the turns' lists and loops, where the listing is | +0.01 (-0.04 to +0.02) | +0.01 (+0.00 to +0.03) | -0.00 (-0.01 to +0.00) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | -83 (-221 to +31) | -74 (-91 to +64) | +2 (-303 to +190) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | -0.00 (-0.08 to +0.02); +12 (-77 to +62) | +0.01 (-0.01 to +0.11); +39 (-18 to +113) | +0.03 (-0.13 to +0.19); +10 (-209 to +101) |
| the kernel in place, more | -0.01 (-0.12 to +0.04) | -0.01 (-2.31 to +0.01) | +0.01 (-0.69 to +0.95) |
| the tests' other parts, more | +0.20 (-0.15 to +0.32) | -0.17 (-1.81 to +0.23) | +1.18 (-2.32 to +3.32) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.71 (8.50 to 9.45); 6.26 (6.22 to 6.34) | 12.40 (12.24 to 13.80); 6.68 (6.63 to 6.70) | 23.46 (21.01 to 24.32); 8.11 (8.02 to 9.32) |
| the timed region with no sweep in it, ticks a chunk | 28.3 (25.8 to 29.4) | 27.0 (26.4 to 28.3) | 27.3 (26.9 to 27.6) |
