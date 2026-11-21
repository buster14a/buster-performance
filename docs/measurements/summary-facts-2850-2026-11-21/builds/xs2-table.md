| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.26 (0.26 to 0.27)** | **0.35 (0.34 to 0.35)** | **0.34 (0.34 to 0.36)** |
| the sweep, a record swept, a first run | 0.47 (0.46 to 0.48) | 0.86 (0.83 to 0.88) | 2.07 (1.76 to 2.21) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | +0.16 (-0.10 to +0.20) | -0.29 (-2.79 to +2.02) | +0.61 (-1.52 to +2.38) |
| the tests' loop, more (its one run) | +0.09 (+0.01 to +0.21) | +0.14 (-0.09 to +0.18) | +0.47 (+0.19 to +0.69) |
| **the three together, the sweep by its second run** | **+0.52 (+0.20 to +0.61)** | **-0.02 (-2.30 to +2.55)** | **+1.43 (-0.50 to +3.12)** |
| the three together, the sweep by its first run | +0.73 (+0.41 to +0.79) | +0.48 (-1.79 to +3.05) | +3.17 (+0.92 to +4.83) |
| **the sweep, a first run less a second, ticks a chunk** | **109 (98 to 114)** | **192 (181 to 197)** | **219 (180 to 234)** |
| the sweep, ticks a chunk: a first run; a second | 247 (242 to 253); 139 (137 to 144) | 325 (312 to 331); 131 (130 to 134) | 262 (223 to 280); 43 (43 to 46) |
| the tests' bytes and loop, ticks a chunk, more | +133 (-32 to +175) | -142 (-1003 to +834) | +137 (-106 to +353) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.29 (+0.20 to +0.38)** | **+0.40 (+0.35 to +0.41)** | **+0.43 (+0.37 to +0.48)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+91 (-68 to +328)** | **+132 (+64 to +156)** | **+295 (-63 to +581)** |
| the rows' other sweeps, a second run, more | +0.03 (-0.07 to +0.12) | +0.05 (+0.00 to +0.06) | +0.07 (+0.03 to +0.14) |
| of them the turns' lists and loops, where the listing is | +0.02 (-0.01 to +0.03) | +0.00 (+0.00 to +0.01) | +0.01 (+0.00 to +0.02) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | -18 (-176 to +217) | -65 (-131 to -36) | +74 (-284 to +362) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | -0.01 (-0.09 to +0.02); +26 (-42 to +48) | -0.00 (-0.01 to +0.10); -9 (-46 to +45) | -0.09 (-0.12 to +0.31); +104 (+86 to +275) |
| the kernel in place, more | +0.04 (-0.02 to +0.19) | -0.02 (-1.41 to +0.09) | +0.04 (-0.12 to +1.91) |
| the tests' other parts, more | -0.11 (-0.42 to +0.27) | -0.04 (-0.75 to +0.66) | -0.36 (-2.97 to +0.72) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.89 (8.61 to 8.90); 6.29 (6.24 to 6.43) | 12.58 (12.34 to 12.81); 6.69 (6.68 to 6.74) | 23.71 (21.12 to 25.11); 8.05 (8.00 to 8.13) |
| the timed region with no sweep in it, ticks a chunk | 26.8 (25.9 to 27.3) | 26.6 (26.2 to 28.1) | 26.9 (26.6 to 26.9) |
