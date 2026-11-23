# Tier 1: a call's arguments out of each other's registers (#2823)

buster14a/buster PR #3330 (`claude/tier1-call-arguments-2823`, head `2dfce0d9`) against main `a891cc05`.

- `local/`: this session's static and callgrind counts, from a cloud container. Tier 1 objects of speedtest1
  (SQLite 3.53.2's `speedtest1.c` with the frozen corpus's `sqlite3.c`, one unit) and Lua 5.4.8's 33 sources, made by
  `count.sh`. `swaps.awk` counts swaps through `r11` whose third move is followed by a call within six instructions with
  no jump between (`swaps.txt`). `cg.sh` runs callgrind on speedtest1 (`--size 5 --testset mix1`) and Lua's five scripts.
  `fn.py` names the functions and diffs them (`callgrind-functions.txt`, `callgrind-totals.txt`). `base` is main and
  `new2` is the PR's head.
- `9700x/`: benchpress, every run under `exclusive.sh` and pinned to CPU 2.
  - `measure.sh` built both trees' Release compilers, Lua in three link orders (`lua-orders.txt`), speedtest1 and
    clang -O0's Lua, then checked outputs (`check.txt`). Its own timing steps failed on a path bug.
  - `timing.sh` timed the checked builds with `time-runs`, one hold of the lock per program (`results/final2/`).
  - The first run (`final`) was killed mid-check by something outside it. `bp-build.sh` and `bp-next.sh` made the
    builds.

| | main | PR |
| --- | ---: | ---: |
| Lua's five scripts, sum of medians (3 layouts x 11 runs) | 179.811 ms | 179.513 ms (-0.17%) |
| speedtest1, median of 11 (one layout) | 148.889 ms | 149.132 ms (+0.16%) |
| speedtest1's instructions | 2,418.92 M | 2,409.12 M (-0.41%) |
| `--tier1 -c` of speedtest1's unit, median of 11 | 628.395 ms | 629.561 ms (+0.19%) |
| `--tier1 -c` of `lvm.c`, median of 21 | 24.872 ms | 24.868 ms (-0.02%) |
