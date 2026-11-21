| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.28 (0.27 to 0.29)** | **0.35 (0.34 to 0.37)** | **0.35 (0.34 to 0.36)** |
| the sweep, a record swept, a first run | 0.46 (0.43 to 0.47) | 0.84 (0.82 to 0.90) | 1.88 (1.53 to 2.75) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | +0.09 (-0.06 to +0.15) | -0.01 (-0.39 to +0.13) | -1.07 (-1.71 to +1.63) |
| the tests' loop, more (its one run) | +0.05 (-0.01 to +0.09) | +0.00 (-0.34 to +0.15) | +0.07 (-1.19 to +1.17) |
| **the three together, the sweep by its second run** | **+0.37 (+0.25 to +0.45)** | **+0.35 (-0.38 to +0.50)** | **-0.47 (-1.90 to +1.53)** |
| the three together, the sweep by its first run | +0.56 (+0.45 to +0.65) | +0.86 (+0.11 to +0.97) | +1.06 (-0.47 to +3.17) |
| **the sweep, a first run less a second, ticks a chunk** | **99 (82 to 106)** | **184 (179 to 209)** | **193 (149 to 305)** |
| the sweep, ticks a chunk: a first run; a second | 243 (227 to 248); 145 (140 to 150) | 319 (312 to 340); 133 (129 to 140) | 239 (194 to 349); 44 (43 to 45) |
| the tests' bytes and loop, ticks a chunk, more | +55 (-6 to +94) | +4 (-277 to +50) | -105 (-286 to +151) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.30 (+0.28 to +0.36)** | **+0.44 (+0.28 to +3.30)** | **+0.44 (-0.71 to +1.78)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+119 (+25 to +144)** | **+116 (-1270 to +173)** | **+73 (-134 to +494)** |
| the rows' other sweeps, a second run, more | +0.03 (+0.01 to +0.07) | +0.09 (-0.06 to +2.93) | +0.10 (-1.05 to +1.43) |
| of them the turns' lists and loops, where the listing is | +0.00 (-0.01 to +0.02) | +0.00 (-0.02 to +0.02) | +0.01 (-0.01 to +0.01) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | +17 (-72 to +56) | -67 (-1448 to -15) | -146 (-285 to +301) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | +0.00 (-0.05 to +0.07); -36 (-87 to +50) | -0.01 (-0.04 to +0.05); +5 (-543 to +56) | +0.05 (-0.05 to +1.01); -31 (-142 to +79) |
| the kernel in place, more | +0.00 (-0.09 to +0.09) | -0.01 (-0.46 to +2.79) | +0.48 (-0.16 to +2.55) |
| the tests' other parts, more | +0.06 (-0.05 to +0.16) | -0.05 (-0.89 to +2.89) | -0.94 (-3.99 to +1.41) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.72 (8.61 to 8.83); 6.26 (6.21 to 6.31) | 12.60 (12.27 to 13.26); 6.61 (6.58 to 6.71) | 23.44 (22.18 to 25.84); 8.08 (7.91 to 9.12) |
| the timed region with no sweep in it, ticks a chunk | 27.9 (26.9 to 29.6) | 27.8 (26.1 to 30.5) | 27.2 (26.8 to 31.7) |
