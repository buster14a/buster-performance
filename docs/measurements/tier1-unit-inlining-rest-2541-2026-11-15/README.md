# #2541's rest: dead functions and an expanded callee's parameters under `-g`, rows in other files, the compiler's own calls (2026-11-15)

The measurements of what [#2541](https://github.com/buster14a/buster/issues/2541)'s step 3 left and of step 2's returns
gate at its edge, for the PR on branch `claude/magical-bell-ejkrq2` of buster14a/buster
(`docs/tier1-unit-inlining.md`'s "The rest, measured"). Step 3's record is `tier1-unit-inlining-step3-2541-2026-11-14`,
step 2's `tier1-unit-inlining-step2-2541-2026-11-14`, whose scripts these 9700X runs used (`scripts` there:
`clone.sh`, `build.sh`, `selfhost-build.sh`, `selfhost-perf.sh`, `selfhost-runs.sh`, `compile.sh`, `compile-summary.sh`,
`queue.sh`, `lock.sh`).

- **Host:** AMD Ryzen 7 9700X (step 2's record's `host.txt`), every build and run one hold of the lock per command
  (`9700x/q13.txt`, `q14.txt` and their logs).
- **main5:** `64da385ebda7de50d656c42d0f207f95672176e0` (`9700x/main5.commit`); **head5:**
  `b13e32517ab29e028d49d18b4e5c1f97634b8ef4`, the branch's code without the `-g`-only parameter work; **head6:**
  `32be170e28d9004c2f41be04a7682e6861cf75ef`, with it (the docs' commit after it changes no code).

## The returns gate: the compiler built by `--tier1`

The compiler's units at the scalar host (`-march=x86-64`, the build's flags with `-gline-tables-only`) compiled by each
tree's `--tier1`, one lane a unit, linked by clang; then compiling the frozen sqlite3.c, one lane, CPU 2
(`9700x/results/selfhost`: `perf-*-stat.csv` three runs each, `selfhost-runs.tsv` three rounds of both workloads,
`*-units.tsv` the build's units):

| The compiler built by `--tier1` of | returns, M | cycles, M | instructions, M | its `.text`, bytes | its build, user s |
| --- | ---: | ---: | ---: | ---: | ---: |
| main5 | 59.41 | 5,023 | 21,126 | 49,934,835 | 45.5 |
| head5 | **52.53** (-11.6%) | 4,852 (-3.4%) | 21,067 | 45,537,123 (-8.8%) | 48.8 (+7.3%) |

Step 2's gate, at most 60 M returns, is met with 7.5 M to spare; main's build sits at 59.4 M, the edge step 2's record
found. The runs' rounds agree: the default-tier compile 5,013 M cycles against 4,840 M (-3.5%), the `--tier1` compile
11,192 M against 10,997 M (-1.7%).

Two causes kept the calls, found by a temporary trace of the inliner's decisions per call (`local/inline-trace.diff`,
never committed; `local/decisions-*.txt`, a line per callee and decision):

- **A summary was lowered without the wide-vector pieces** the function's own pipeline takes (#1624), so a function
  with a vector wider than its target had no summary: in the checker unit at the scalar host, whose AVX-512 types are
  wider than x86-64's, 210 summaries refused at lowering (`IR_ERROR_UNSUPPORTED`), `check_common_next_token`,
  `check_sparse_next` and the per-token `check_input_*` helpers among them (decision 3, no summary, in
  `decisions-checker-before.txt`).
- **A section rooted an internal candidate**, which clang's inliner doesn't: the compiler's checker is all under
  `#pragma clang section`, so none of it had the single-site class or dead functions (`rooted=1` in
  `decisions-checker-pieces.txt`, `0` in `decisions-checker-pieces-nosection.txt`).

On the session's container (an Intel Xeon), callgrind's calls of the compiler built by `--tier1` compiling speedtest1.c
(sqlite3.c's parser doesn't fit the 64 MiB arenas valgrind leaves): 2,962,978 before, 2,934,521 with the summaries'
pieces, 2,706,170 with sections rooting nothing (`local/callgrind-calls-*.txt`, `scripts/cgcalls.py`,
`scripts/selfhost-local.sh`). The `host_mm512_*` emulations stay calls: `noinline` by their definition.

## The gate programs and the compile

sqlite3.c's, speedtest1.c's and Lua 5.4.8's 34 units' `--tier1 -O2 -c` objects are the same bytes by main and head
(`local/objects-main-head.txt`, 36 of 36). `--tier1 -c` of the frozen sqlite3.c, one lane, CPU 2, seven runs
(`9700x/results/compile-q14`, `compile-summary.sh perf.tsv`):

| | cycles, M | instructions, M | task-clock, ms | `.text`, bytes |
| --- | ---: | ---: | ---: | ---: |
| main5 | 3,424.8 | 8,369.0 | 635.4 | 1,557,640 |
| head6 | 3,419.0 | 8,372.6 | 634.4 | 1,557,640 |
| main5, `-g` | 7,347.4 | 19,671.4 | 1,346.5 | 1,873,912 |
| head6, `-g` | 7,556.2 (+2.8%) | 19,827.4 (+0.8%) | 1,384.5 | 1,557,640 |

Under `-g` main kept the code of the functions every call expanded; head's `-g` object has the plain compile's code.

## `-g`

The debugger's views, by gdb 15.1 on the session's container (`local/gdb15-values.txt`) and gdb 18.1 on the 9700X
(`9700x/gdb18-values.txt`, by `scripts/gdb-checks.sh` on the `fixtures`):

- the inline fixture (`fixtures/dbg_tier1_inline.c`, `test-check-debug`'s) stopped at each of its six calls of
  `t1i_mark`: the expanded `t1i_square`'s `x` is 0, 1, 2 at its first calls and `<optimized out>` at the second (dead
  past `y`), the expanded `t1i_twice`'s `x` 0, 0, 1, 1, 2, 2: every value shown the program's, by both gdbs, in the
  executable and in a linked `-c -g` object (whose two callees are dead);
- `break t1i_square`: 5 locations in the executable, 2 in the linked object, by both;
- a three-parameter callee (`fixtures/two.c`): `a` and `c` the program's at each stop, `b` (dead past its use)
  `<optimized out>`;
- a header's callees (`fixtures/t1h.c`, `t1h.h`): each frame at its line in its own file.

sqlite3.c by `--tier1 -g -O2 -c`: `llvm-dwarfdump --verify` clean, 14,104 instances of 1,349 callees, 21,441 instances'
parameters with locations (on the session's container; `local/g-compile-local.txt` for its sizes there).
