# -g's range and location lists computed once (buster#2540, buster#2542, 2026-11-23)

The third piece of buster#2540 (the lists' half of buster#2542) on the Ryzen 7 9700X (`benchpress`): Release builds by
`./build.sh --config Release` with the 9700X's staged clang 23.1.4, every step under its own hold of
`~/buster-fast-bench/exclusive.sh` (`raw/compare.txt` ends with the runner, `piece.sh`).

- **Before:** buster `9730190c30f4f26393b2a8d32cec62cd77d69387` (main, 23 November).
- **After:** the same with branch `claude/2540-lists`, commit `e2a0096c3101b38c4c5b074dddbd7730b85b93a7`: the
  measuring pass writes each `check_debug_value_range_clipped` list into a memo and the writing pass copies it.
- **Inputs and scripts:** as `debug-events-2540-2026-11-23` (`scripts/`).

The first `-c` series (`raw/lists-main-u`) was disturbed: its `-c -g sqlite3.c` totals are 230 ms and more, against
166 in every other series, with the same binary. Both trees' `-c` series were run again, one hold each, with
`/proc/loadavg` before and after (`raw/lists2-*`); the table takes those. The executable series (`raw/lists-*-s`) are
undisturbed.

## Results (medians of 7, ms)

| | before | after | |
| --- | ---: | ---: | --- |
| `-c -g sqlite3.c`, `debug` stage | 21.917 | 20.486 | −1.43 |
| `-c -g sqlite3.c`, total | 166.523 | 164.716 | (plain 136.492 / 136.142) |
| `-c -g shell.c`, `debug` stage | 4.703 | 4.390 | −0.31 |
| the shell, one lane, `-g` | 220.812 | 219.278 | |
| the shell, seven lanes, `-g` | 167.526 | 165.600 | |

**The bytes:** 1,483 outputs equal (both units' objects, the shell at one and seven lanes, every musl unit both
compile), and the shell prints `42|3.53.2|1.4142135623730952`. On the 9700X, `check-call-graph` (0 cycles),
`test-streaming --cross-check` (200) and `test-check-debug --cross-check` (4,082) pass with the new compiler.
