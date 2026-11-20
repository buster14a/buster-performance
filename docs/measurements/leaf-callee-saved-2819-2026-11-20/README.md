# A looping leaf's values in callee-saved registers (buster#2819), 2026-11-20

Tier 1's CFG consumer allocated a function with no call and no asm body in the caller-saved registers alone, so
a leaf loop with more live values than those hold spilled on every iteration while `rbx`, `rbp` and `r12` to
`r15` stayed free. buster#2819's change allocates such a leaf again, where it spills and has a loop, with the
callee-saved registers added and every range avoiding them, and takes that allocation where it spills fewer
values by at least as many as the callee-saved registers it uses.

Base: buster main `377238c`. Head: the pull request's commit `701ed5c` on that main. Both built with
`./build.sh` (Develop, CI's toolchain: clang 23.1.4) in a claude.ai cloud container (Intel Xeon with AVX-512, no
PMU, so nothing here is a timing).

## What was run

- `cloud/sum8.txt`: the issue's `sum8` (`scripts/sum8.c`) by `--tier1 -O2 -march=x86-64 --tier1-report`, its
  report's spill counts and its code by each compiler. Base: `spill_stores=6 spill_loads=10 spill_slots=6`, five
  stores and six reloads in the loop. Head: no spill, four pushes and pops (`rbx`, `rbp`, `r12`, `r13`).
- `cloud/corpus-totals.txt`: `scripts/corpus_report.sh COMPILER DIR`, every function of the frozen corpus's
  `sqlite3.c` and Lua 5.4.8's 34 sources by `--tier1 -c --tier1-report`, the reports' sums and the objects'
  `.text` bytes (`size -A`). 1,992 functions by each; spill stores 10,730 to 10,577, reloads 11,658 to 11,490,
  slots 3,006 to 2,941, red zones 30 to 21, records 443,967 to 443,837, `.text` 1,783,681 to 1,782,257 bytes.
- `cloud/changed-functions.tsv`: the functions whose symbol size differs (`nm -S`): 14, all in `sqlite3.c`, all
  smaller, 1,400 bytes in all. No function of Lua's changes.
- `cloud/speedtest1-callgrind.txt`: speedtest1 (SQLite 3.53.2's `test/speedtest1.c` and the frozen `sqlite3.c`
  as one unit, `measure-tier1-programs`' `speedtest1-unity.c` and #136's flags) by each compiler's `--tier1
  -fno-asynchronous-unwind-tables -march=x86-64-v3` (valgrind runs no AVX-512), then
  `valgrind --tool=callgrind` on `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64
  --testset mix1`, a fresh database each. Instructions: 2,529,544,497 to 2,521,324,632 (-0.33%). Both builds'
  `--verify` hash: `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`.

The pull request's own checks and the 9700X's program measurement time speedtest1 and Lua's scripts.
