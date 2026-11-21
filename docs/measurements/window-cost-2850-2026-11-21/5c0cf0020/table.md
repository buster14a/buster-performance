| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; a chunk | 321,434; 526 | 91,252; 379 | 377,187; 127 |
| pointers' ordered comparisons the loop leaves out | 76 | 36 | 47 |
| the tests' loop, a record swept: before | 1.66 (1.58 to 1.76) | 2.35 (2.28 to 2.43) | 4.22 (3.75 to 5.26) |
| **the tests' loop, more** | **-0.10 (-0.27 to +0.10)** | **+0.12 (+0.04 to +0.80)** | **+0.42 (-0.64 to +2.56)** |
| the build before against itself, its second run less its first | +0.03 (-0.13 to +0.12) | +0.01 (-0.10 to +0.04) | -0.07 (-1.24 to +0.81) |
| the tests' loop, ticks a chunk, more | -55 (-142 to +53) | +46 (+13 to +303) | +54 (-81 to +325) |
| the records' bytes' sweep, a record swept, more | +0.27 (+0.21 to +0.39) | +0.43 (-0.01 to +3.38) | +1.11 (-1.42 to +4.44) |
| the tests' other parts, more | +0.04 (-0.19 to +0.11) | +0.19 (-0.40 to +2.27) | +1.03 (-6.60 to +4.70) |
| the names' pass less the lines it makes, a name: before | 13.67 (13.35 to 13.74) | 18.29 (18.06 to 18.62) | 20.77 (20.20 to 22.38) |
| **the names' pass, more** | **-0.25 (-0.46 to -0.01)** | **+0.51 (-0.08 to +0.68)** | **+0.50 (-1.75 to +3.84)** |
| the front's inputs made again, a record: before; more | 30.05 (29.96 to 30.38); -2.63 (-2.96 to -2.29) | 28.38 (28.32 to 28.76); -2.13 (-2.52 to +4.39) | 33.57 (33.45 to 33.78); -0.58 (-0.78 to +1.20) |
| the kernel in place, a record made: before; more | 20.20 (20.16 to 20.22); +0.02 (-0.04 to +0.16) | 27.10 (26.97 to 27.34); +0.05 (-0.12 to +0.30) | 23.96 (23.88 to 24.34); +0.05 (-0.33 to +0.20) |
| C's sweeps' second run, a record swept, more | +0.01 (-0.02 to +0.10) | -0.00 (-2.42 to +0.10) | -0.06 (-0.13 to +0.21) |
| the rows' sweeps' second run, a record swept, more | +0.02 (-0.06 to +0.14) | +0.09 (+0.06 to +0.15) | -0.04 (-0.22 to +0.26) |
