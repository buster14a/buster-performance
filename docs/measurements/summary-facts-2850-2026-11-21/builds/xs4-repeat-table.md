| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.28 (0.27 to 0.31)** | **0.36 (0.35 to 0.38)** | **0.37 (0.36 to 0.42)** |
| the sweep, a record swept, a first run | 0.47 (0.44 to 0.49) | 0.83 (0.80 to 0.87) | 1.97 (1.62 to 2.65) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | -0.01 (-0.36 to +0.19) | -0.32 (-2.26 to +0.11) | -0.37 (-2.47 to +3.74) |
| the tests' loop, more (its one run) | +0.13 (+0.00 to +0.20) | +0.05 (-0.03 to +0.18) | -0.14 (-1.58 to +1.85) |
| **the three together, the sweep by its second run** | **+0.36 (+0.11 to +0.53)** | **+0.17 (-1.93 to +0.57)** | **-0.47 (-3.38 to +3.59)** |
| the three together, the sweep by its first run | +0.53 (+0.32 to +0.71) | +0.63 (-1.42 to +1.02) | +1.19 (-1.85 to +5.40) |
| **the sweep, a first run less a second, ticks a chunk** | **95 (85 to 112)** | **178 (170 to 195)** | **202 (158 to 289)** |
| the sweep, ticks a chunk: a first run; a second | 248 (229 to 257); 149 (140 to 163) | 316 (305 to 330); 137 (133 to 143) | 249 (205 to 336); 47 (45 to 53) |
| the tests' bytes and loop, ticks a chunk, more | +38 (-85 to +128) | -76 (-867 to +82) | -106 (-475 to +409) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.35 (+0.28 to +0.49)** | **+0.41 (-1.41 to +0.48)** | **+0.43 (-0.95 to +2.21)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+70 (-24 to +186)** | **+138 (-8 to +842)** | **+175 (-210 to +528)** |
| the rows' other sweeps, a second run, more | +0.05 (+0.01 to +0.20) | +0.05 (-1.79 to +0.11) | +0.06 (-1.37 to +1.84) |
| of them the turns' lists and loops, where the listing is | +0.01 (-0.01 to +0.04) | +0.01 (-0.01 to +0.02) | -0.00 (-0.08 to +0.05) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | -42 (-119 to +101) | -36 (-203 to +667) | -7 (-404 to +282) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | +0.00 (-0.16 to +0.16); -7 (-95 to +87) | +0.00 (-0.12 to +0.13); -0 (-227 to +81) | +0.01 (-1.64 to +1.80); +150 (-452 to +478) |
| the kernel in place, more | -0.02 (-0.11 to +0.04) | -0.03 (-3.08 to +0.22) | -0.01 (-0.66 to +2.07) |
| the tests' other parts, more | -0.01 (-0.28 to +0.23) | -0.14 (-2.57 to +2.32) | -0.52 (-2.12 to +1.79) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.83 (8.59 to 9.23); 6.26 (6.21 to 6.31) | 12.51 (12.23 to 13.77); 6.66 (6.63 to 8.99) | 24.85 (21.98 to 27.74); 8.07 (7.94 to 9.46) |
| the timed region with no sweep in it, ticks a chunk | 29.1 (27.0 to 32.7) | 28.3 (25.5 to 29.9) | 27.8 (27.3 to 28.6) |
