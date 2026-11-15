# Tier 1 inlining: callees' locals under -g (buster#2541) and a call's signature as its decision (buster#2721)

For [buster14a/buster#2839](https://github.com/buster14a/buster/pull/2839), merged 2026-11-15 as `8a5d2b4b`:
`872e9749` (buster#2721) and `56391f0e` (buster#2541's callee locals), on main `377e5a85`.

## On the 9700X

Queue `9700x/q15.txt` (log `q15.txt.log`), in `~/buster-fast-bench/2541-step2-claude`, under the lock one run a hold.
The trees are `main7` (`377e5a85`, main at the branch's base) and `head7` (`56391f0e`), Release builds. The scripts
are in `9700x/scripts`; they are the ones #2541's earlier records describe.

### The programs (`programs.sh`, `runs.sh` three times, `summarize.sh`: `9700x/summary.txt`, `runs.tsv`)

| | main | head | 100 ln(head / main), 95% interval | head faster at |
| --- | ---: | ---: | ---: | ---: |
| speedtest1 (8 placements), user cycles | 735.4 M | 734.9 M | -0.07 (-0.37 to +0.23) | 5 of 8 |
| Lua's five scripts (4 link orders) | 991.5 M | 993.8 M | +0.24 (-0.05 to +0.53) | 0 of 4 |

- speedtest1's object is `--tier1` of the frozen sqlite3.c and speedtest1.c as one unit: its `.text` grows from
  1,566,955 to 1,572,992 bytes (+0.39%), the calls buster#2721 now expands (a unit with a variadic or unprototyped call
  was refused whole before). Its time doesn't change.
- Lua's executables are the same bytes on both trees (`main7-builds.sha256`, `head7-builds.sha256`): its difference
  is the measurement's own.

### The compile (`compile.sh`: `compile-perf.tsv`, `compile-sizes.txt`; one lane, CPU 2, seven runs)

| `--tier1 -c sqlite3.c` | user cycles | instructions | task-clock | the object's `.text` |
| --- | ---: | ---: | ---: | ---: |
| main | 3,407.1 M | 8,348.1 M | 632.6 ms | 1,521,704 |
| head | 3,394.2 M | 8,362.8 M (+0.18%) | 630.1 ms | 1,523,896 |
| main, `-g` | 7,518.6 M | 19,734.3 M | 1,377.9 ms | 1,521,704 |
| head, `-g` | 7,687.5 M (+2.2%) | 20,154.1 M (+2.1%) | 1,408.5 ms | 1,523,896 |

Under `-g` the object's code is the plain compile's on both trees; head's `-g` costs 2.2% more for the callees' locals
(their bindings and regions, the proof at the instances' origins, the variables' location lists).

### The compiler built by `--tier1` (`selfhost-runs.sh 3`, `selfhost-perf.sh`)

| Workload, user cycles (three rounds) | main | head |
| --- | --- | --- |
| default (`-c sqlite3.c`) | 5,164.7 / 5,170.9 / 5,164.7 M | 5,018.8 / 4,916.3 / 4,911.3 M |
| `--tier1` | 11,242.4 / 11,125.4 / 11,196.6 M | 11,030.0 / 11,033.0 / 11,023.6 M |

The default workload executes as many instructions on both (20,616 M against 20,615 M), so its -4.8% is the build's
layout more than its code; returns are 53.45 M against 53.08 M (`perf-*-stat.csv`). All 44 units of each build
compile (`*-tier1-units.tsv`).

### Determinism and the debugger

- `objects-head7.txt`: sqlite3.c's, speedtest1.c's and Lua's units by one lane, eight, and eight without holding, by
  both paths: 72 of 72 pairs the same bytes.
- `check-debug-head7.txt`: `test-check-debug --cross-check` on the 9700X's gdb 18.1, 4,065 checks, 0 failures (the
  inline fixture's callee local at six stops, the expanded loop's counter at five).
- `ir-source-sqlite.txt`: `test-ir-source --passes` on the frozen sqlite3.c. The inliner's units: main refuses 234
  (`IR_ERROR_TYPE`, buster#2721), head none; head changes 808 callers against 678.

## In the session's container (`local/`)

- `sqlite3-g-dies.txt`: sqlite3.c by `--tier1 -g -O2 -c`: 14,198 inlined subroutines on both; inlined variables with
  locations 4,734 against none (base: buster#2721 alone), parameters with locations 21,949 against 21,559 (an assigned
  parameter's assignments now carried); `llvm-dwarfdump --verify` reports no errors; `.text` the same as without `-g`.
- gdb 15.1 transcripts: `gdb15-inline-fixture.txt` (`dbg_tier1_inline.c`, `s.gdb`: the inner callee's `y` at four
  stops: 0, 1, 1, 4, each its `x * x`), `gdb15-loop-fixture.txt` (`loop.c`, `l.gdb`: the expanded loop's `i` at five
  stops, 0, 1, 2, 0, 1) and `gdb15-loop-out-of-line.txt` (`loop2.c`: the same loop not expanded, the same values;
  `total` is `<optimized out>` at the call in both, the proof's own limit there).
