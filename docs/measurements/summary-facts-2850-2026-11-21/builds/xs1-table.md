| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 112 | 11,522; 99; 23 |
| **the sweep, a record swept, a chunk's second run** | **0.33 (0.32 to 0.34)** | **0.49 (0.47 to 0.49)** | **0.49 (0.48 to 0.51)** |
| the sweep, a record swept, a first run | 0.47 (0.46 to 0.50) | 1.05 (1.04 to 1.10) | 1.99 (1.94 to 3.08) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | +0.08 (+0.05 to +0.15) | +0.65 (+0.13 to +2.99) | +0.54 (-0.26 to +2.79) |
| the tests' loop, more (its one run) | +0.16 (+0.10 to +0.19) | +0.16 (+0.09 to +0.25) | +0.16 (-0.11 to +1.18) |
| **the three together, the sweep by its second run** | **+0.57 (+0.54 to +0.62)** | **+1.38 (+0.71 to +3.64)** | **+1.44 (+0.92 to +3.44)** |
| the three together, the sweep by its first run | +0.71 (+0.71 to +0.75) | +1.95 (+1.33 to +4.20) | +3.52 (+2.87 to +4.94) |
| **the sweep, a first run less a second, ticks a chunk** | **75 (69 to 87)** | **217 (210 to 232)** | **190 (181 to 329)** |
| the sweep, ticks a chunk: a first run; a second | 249 (244 to 261); 174 (169 to 180) | 396 (395 to 416); 184 (178 to 187) | 252 (246 to 391); 62 (61 to 65) |
| the tests' bytes and loop, ticks a chunk, more | +132 (+111 to +144) | +344 (+86 to +1192) | +118 (+55 to +374) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.33 (+0.31 to +0.39)** | **+0.54 (+0.47 to +0.57)** | **+0.60 (-0.25 to +0.66)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+107 (+87 to +112)** | **+197 (+154 to +1231)** | **+190 (+100 to +521)** |
| the rows' other sweeps, a second run, more | -0.00 (-0.01 to +0.05) | +0.05 (+0.00 to +0.09) | +0.11 (-0.74 to +0.15) |
| of them the turns' lists and loops, where the listing is | +0.00 (-0.01 to +0.02) | +0.01 (-0.00 to +0.03) | -0.01 (-0.77 to +0.02) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | +20 (+18 to +37) | -20 (-56 to +998) | -81 (-139 to +331) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | +0.03 (-0.08 to +0.03); +2 (-36 to +24) | +0.00 (-0.24 to +0.02); -34 (-190 to +85) | +0.03 (-0.55 to +0.05); +14 (-41 to +298) |
| the kernel in place, more | +0.02 (-0.06 to +0.02) | +0.14 (+0.01 to +1.09) | -0.02 (-0.58 to +0.00) |
| the tests' other parts, more | -0.12 (-0.25 to +0.01) | +0.14 (-1.47 to +0.19) | +0.91 (-2.21 to +1.74) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.78 (8.73 to 8.87); 6.32 (6.27 to 6.38) | 12.38 (12.38 to 12.60); 6.67 (6.67 to 6.84) | 23.01 (20.99 to 26.35); 8.73 (8.10 to 8.79) |
| the timed region with no sweep in it, ticks a chunk | 29.0 (27.4 to 30.4) | 27.8 (26.8 to 36.5) | 27.1 (27.0 to 48.3) |
