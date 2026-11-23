# -g's rows' lines from block indexes (buster#2540, 2026-11-23)

The second piece of buster#2540 on the Ryzen 7 9700X (`benchpress`): Release builds by `./build.sh --config Release`
with the 9700X's staged clang 23.1.4, every step under its own hold of `~/buster-fast-bench/exclusive.sh`
(`raw/compare.txt` ends with the runner, `piece.sh`).

- **Before:** buster `9730190c30f4f26393b2a8d32cec62cd77d69387` (main, 23 November, with buster#3342).
- **After:** the same with the change of branch `claude/2540-lines`, commit
  `d55222010356f30aabe7cd323d021841aa137f8c`: a file's line index (a bit per line end, a count per 64 bytes, in one
  pass) and the history runs' index (a bit per run's first token, a count per 64 tokens) in place of
  `check_debug_lines`' gathered binary searches and `pp_diagnostic_lines`' two scans.
- **Inputs and scripts:** as `debug-events-2540-2026-11-23` (`scripts/`): the frozen corpus's SQLite 3.53.2 with
  `test-sqlite`'s shell options, `-c` of each unit on CPU 2 (`raw/lines-*-u`), the shell to an executable on one lane
  (CPU 2) and seven (CPUs 1-7) (`raw/lines-*-s`), 7 runs each, `--time-stages`.

## Results (medians of 7, ms)

| | before | after | |
| --- | ---: | ---: | --- |
| `-c -g sqlite3.c`, `debug` stage | 21.862 | 18.403 | −3.46 |
| `-c -g sqlite3.c`, total | 166.015 | 162.502 | (plain 135.866 / 136.156) |
| `-c -g shell.c`, `debug` stage | 4.717 | 4.031 | −0.69 |
| the shell, one lane, `-g` | 221.090 | 216.472 | (plain 186.876 / 186.889) |
| the shell, seven lanes, `-g` | 167.412 | 163.725 | (plain 143.752 / 144.002) |

What `-g` adds to the shell's build: one lane 34.2 → 29.6 ms; seven lanes 23.7 → 19.7 ms.

**The bytes:** 1,483 outputs equal (both units' objects, the shell at one and seven lanes, every musl unit both
compile; 45 musl units neither compiles), and the shell prints `42|3.53.2|1.4142135623730952`. On the 9700X,
`./build.sh check-call-graph --config Release` (0 cycles) and `test-streaming --cross-check` (200 checks) pass with the
new compiler.
