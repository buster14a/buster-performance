| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.27 (0.27 to 0.28)** | **0.31 (0.31 to 0.32)** | **0.31 (0.31 to 1.19)** |
| the sweep, a record swept, a first run | 0.41 (0.39 to 0.43) | 0.80 (0.78 to 0.81) | 1.70 (1.57 to 2.28) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | -0.01 (-0.12 to +0.06) | -0.01 (-0.24 to +0.98) | -0.81 (-6.69 to +3.09) |
| the tests' loop, more (its one run) | +0.12 (-0.07 to +0.32) | +0.06 (+0.01 to +1.22) | +0.67 (-1.20 to +4.47) |
| **the three together, the sweep by its second run** | **+0.40 (+0.17 to +0.47)** | **+0.32 (+0.18 to +2.52)** | **+1.01 (-5.70 to +5.54)** |
| the three together, the sweep by its first run | +0.55 (+0.29 to +0.61) | +0.81 (+0.68 to +3.00) | +2.33 (-3.74 to +7.00) |
| **the sweep, a first run less a second, ticks a chunk** | **68 (63 to 80)** | **185 (178 to 186)** | **167 (86 to 249)** |
| the sweep, ticks a chunk: a first run; a second | 215 (207 to 226); 144 (143 to 147) | 304 (295 to 306); 119 (116 to 122) | 216 (199 to 290); 40 (39 to 151) |
| the tests' bytes and loop, ticks a chunk, more | +66 (-60 to +104) | +2 (-46 to +834) | +89 (-763 to +663) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.34 (+0.31 to +0.38)** | **+0.39 (-0.18 to +0.40)** | **+0.36 (-0.39 to +1.14)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+23 (-44 to +64)** | **+115 (-11 to +372)** | **+232 (-1 to +248)** |
| the rows' other sweeps, a second run, more | +0.06 (+0.03 to +0.10) | +0.07 (-0.49 to +0.07) | +0.03 (-0.70 to +0.26) |
| of them the turns' lists and loops, where the listing is | +0.01 (-0.01 to +0.02) | +0.00 (-0.02 to +0.02) | -0.01 (-0.03 to +0.00) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | -47 (-117 to +0) | -70 (-189 to +188) | +60 (-156 to +81) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | +0.01 (-0.03 to +0.06); +20 (-86 to +111) | +0.01 (-0.43 to +0.05); +7 (-37 to +61) | -0.06 (-1.40 to +0.28); +54 (-185 to +229) |
| the kernel in place, more | +0.01 (-0.05 to +0.14) | +0.01 (-0.41 to +0.40) | +0.01 (-0.78 to +0.10) |
| the tests' other parts, more | -0.02 (-0.27 to +0.20) | -0.43 (-2.81 to +0.71) | +2.14 (-1.49 to +2.94) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.82 (8.58 to 9.11); 6.27 (6.25 to 6.30) | 12.42 (12.20 to 13.06); 6.71 (6.65 to 7.23) | 24.27 (23.53 to 25.94); 8.14 (8.03 to 8.77) |
| the timed region with no sweep in it, ticks a chunk | 27.0 (26.6 to 30.1) | 26.9 (25.6 to 28.6) | 27.4 (27.1 to 27.8) |
