| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.28 (0.27 to 0.31)** | **0.32 (0.31 to 0.33)** | **0.31 (-1.83 to 0.32)** |
| the sweep, a record swept, a first run | 0.42 (0.37 to 0.44) | 0.82 (0.80 to 0.83) | 1.92 (1.54 to 2.16) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | +0.05 (-0.13 to +0.21) | -0.15 (-0.45 to +0.32) | -2.03 (-2.94 to +0.40) |
| the tests' loop, more (its one run) | +0.13 (+0.06 to +0.20) | +0.07 (-0.10 to +0.12) | -0.06 (-1.44 to +0.64) |
| **the three together, the sweep by its second run** | **+0.45 (+0.31 to +0.58)** | **+0.23 (-0.10 to +0.76)** | **-1.91 (-4.27 to +1.16)** |
| the three together, the sweep by its first run | +0.59 (+0.44 to +0.69) | +0.74 (+0.41 to +1.25) | -0.29 (-2.01 to +2.72) |
| **the sweep, a first run less a second, ticks a chunk** | **70 (53 to 81)** | **192 (183 to 194)** | **208 (157 to 473)** |
| the sweep, ticks a chunk: a first run; a second | 220 (196 to 229); 146 (142 to 161) | 310 (301 to 312); 120 (118 to 123) | 244 (196 to 274); 40 (-232 to 40) |
| the tests' bytes and loop, ticks a chunk, more | +87 (+21 to +142) | -33 (-157 to +165) | -274 (-506 to +107) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.34 (+0.23 to +0.55)** | **+0.39 (+0.36 to +0.40)** | **+0.34 (-1.76 to +0.42)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+46 (-48 to +101)** | **+144 (-673 to +248)** | **+259 (+44 to +553)** |
| the rows' other sweeps, a second run, more | +0.06 (-0.05 to +0.26) | +0.07 (+0.04 to +0.09) | +0.05 (-0.44 to +0.10) |
| of them the turns' lists and loops, where the listing is | +0.01 (-0.01 to +0.05) | +0.01 (-0.00 to +0.01) | -0.00 (-0.02 to +0.01) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | -28 (-118 to +27) | -48 (-858 to +63) | -6 (-196 to +321) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | +0.01 (-0.09 to +0.03); -10 (-95 to +68) | +0.00 (-0.01 to +0.67); +10 (-221 to +725) | -0.01 (-1.96 to +0.07); +51 (-842 to +366) |
| the kernel in place, more | -0.02 (-0.15 to +0.63) | +0.02 (-0.08 to +1.82) | +0.00 (-1.39 to +1.30) |
| the tests' other parts, more | +0.04 (-0.19 to +0.22) | -0.13 (-3.27 to +1.13) | -0.14 (-3.18 to +4.18) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.81 (8.39 to 8.94); 6.28 (6.24 to 6.32) | 12.84 (12.29 to 14.64); 6.70 (6.69 to 6.71) | 23.05 (21.97 to 26.75); 8.11 (7.96 to 8.58) |
| the timed region with no sweep in it, ticks a chunk | 28.5 (26.7 to 29.1) | 26.6 (25.6 to 28.2) | 27.5 (27.2 to 307.5) |
