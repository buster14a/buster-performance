# Tier 1: increments after their last reader (#2592), 2026-11-14

Evidence for [buster#2592](https://github.com/buster14a/buster/issues/2592), its pull request
[buster#2705](https://github.com/buster14a/buster/pull/2705), and the follow-up
[buster#2732](https://github.com/buster14a/buster/pull/2732), which takes the pass's use counts out. By Claude in David's
directed session ([the session](https://claude.ai/code/session_01NNmNQs1PG31ytAByVRoJEv)).

Lua's `vmfetch`, `i = *(pc++)`, lowers to `pc + 4` before the load that reads `pc`. While the increment was defined,
`pc` was still live, so the increment took another register. The load then took `pc`'s register, which it frees, and
every handler's tail swapped the two back into the dispatch join's registers through `r11`. The pull request's
operand sink (`tier1_schedule_ir_sink`) moves a phi's next value to right after the last reader of the value it comes
from. Then the load comes first and the increment adds in `pc`'s register, as clang -O2's code does. buster's
`docs/tier1-allocation.md`, "Increments after their last reader", has the rule.

## Revisions

| Role | What |
| --- | --- |
| main | buster's main at `ca1ede6a27c1b2e726f2b54e873fd013d03a1fad` |
| head | main with `scripts/head.patch` (`ff74a181…`): the pull request's code. Its commit `6c4d12c` adds the fixtures, docs and a column's initialization; its compiler builds the same objects as head.patch's, all 34 Lua sources and speedtest1's unit (35 of 35 byte-identical) |
| first | the change's first form, which moved any expression of one value, without the rule that `a` be of the phi's family (not kept as a patch; its counts are below) |
| head2 | head with #2732's `tier1_schedule_ir.c` before its permutation was limited to a range (`68934bca…`): no use counts, candidates from the phis |
| head3 | head with #2732's `tier1_schedule_ir.c` (`ef265254…`), #2732's code |

## 1. Dynamic instruction counts (callgrind)

**Host.** A cloud container, not the 9700X (`counts/identities.txt`): an Intel Xeon with AVX-512, valgrind 3.22.0, GNU
objdump 2.42, clang 23.1.6. The compilers were built there natively, by `build.sh`'s Develop configuration.

**Inputs.** #1189's and #1217's:
- Lua 5.4.8 (`4f18ddae…`) and the five scripts;
- the frozen `sqlite3.c` (`0a409f16…`) and `speedtest1.c` at SQLite `ccc132c5` (`b5eaf4bb…`), as one unit, with
  speedtest1's `--size 5` mix.

Each Lua build has a fixed string-hash seed (`-Dluai_makeseed(L)=0x2592u`), so that a script's count repeats.

**Tools.**
- `scripts/buildlua.sh` builds Lua by `--tier1 -fno-asynchronous-unwind-tables`.
- `scripts/luacount.sh` checks each script's output against clang -O0's, then runs it under callgrind
  (`--dump-instr=yes`) and joins the counts with the disassembly by #1189's
  [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (`81856ce1…`).
- `scripts/st.sh` does the same for speedtest1, with its `--verify` hash.
- `scripts/moves.sh` sums `luaV_execute`'s moves.

`counts/` keeps each build's checks, totals and per-function sums, `moves.txt`, `tails.txt` and the static report
counts (`reports.txt`).

| | main | first | head | clang -O2 (#2574's) |
| --- | ---: | ---: | ---: | ---: |
| `luaV_execute` | 2,365.8 M | 2,253.7 M | 2,250.8 M | |
| `luaV_execute`'s register moves | 438.8 M | 327.5 M | 324.6 M | 322.9 M |
| of them through `r11` | 81.2 M | 9.7 M | 9.7 M | |
| indirect jumps after a move from `r11` (static, of 78) | 59 | 16 | 16 | |
| Lua's five scripts, whole processes | 5,236.6 M | 5,124.1 M | 5,121.1 M | 4,207.3 M |
| speedtest1, whole process | 2,873.3 M | 2,871.3 M | 2,871.5 M | 2,028.9 M |

Every script printed clang -O0's output and every speedtest1 gave the hash `1248168 a7fa3957…` (`counts/*/check.txt`,
`verify.txt`).

**By function.** head runs fewer instructions than main in every function that changes by more than 0.01 M:
- Lua: `luaV_execute` −114.94 M, `str_gsub` −0.34 M, `str_format` −0.12 M;
- speedtest1: `sqlite3VdbeExec` −1.26 M, `findElementWithHash` −0.44 M.

first lost 2.82 M in speedtest1's `vdbeSorterMerge`: `pp = &p->next; p = p->next` makes two values from `p`, and
moving `pp`'s increment past the load gave `p`'s register to it, where the load, `p`'s own next value, wanted it, so
the loop's back edge swapped them. head's family rule refuses that move.

**What's left** (`counts/moves.txt`, head's 9.7 M through `r11`):
- 7.92 M: one edge of `OP_CALL`'s path into `startfunc`, which swaps `rbx` and `r15`;
- 0.80 M: `OP_NEWTABLE`'s shift by `cl` in `r11`, not an edge's move;
- 1.02 M: the 16 tails that still swap. Some handlers increment `pc` themselves (`OP_LOADKX`), others reload `trap`
  into another register after a call (`OP_POW`), and a loop's backward jump moves `pc` by a variable amount.

**Statically** (`counts/reports.txt`, `--tier1-report`):

| | main | head |
| --- | ---: | ---: |
| `lvm.c` records / edge moves | 8,171 / 1,016 | 8,012 / 857 (76 expressions moved) |
| speedtest1's unit records / edge moves / spill stores / spill loads | 294,061 / 25,122 / 8,515 / 9,152 | 293,959 / 25,043 / 8,504 / 9,142 (54 moved) |

## 2. Run time on the 9700X

The method is #2553's ([tier1-dominator-places-2553-2026-11-12](../tier1-dominator-places-2553-2026-11-12/README.md),
section 3), with base and head.

- **Machine.** Ryzen 7 9700X, CPU 2. Every build, link, check and timed round took the shared lock.
- **Compilers** (`scripts/compilers.sh`): clean clones of main at `ca1ede6a`; head is the same clone with
  `scripts/head.patch`. Each is built by its own `build.sh --config Release` with `BUSTER_HOST_ARCH=znver5`
  (`9700x/build.log` has their hashes).
- **Objects.** Each compiler builds Lua's 33 objects and speedtest1's unit once, by `--tier1
  -fno-asynchronous-unwind-tables --tier1-report` (`scripts/prepare.sh`; `9700x/objects-*.sha256`,
  `9700x/reports-*.txt`). Their `.text` equals the container's builds by main and head, for `lvm.o` and speedtest1's
  object.
- **Executables** (`scripts/link.sh`): Lua is linked by `cc` in 33 orders (`9700x/orders.txt`); speedtest1 is linked
  after a padding object of 0 to 3,696 bytes, at 8 shifts. All 82 executables passed their checks before any timing
  (`9700x/checks.txt`): each script's output against clang -O0's, and speedtest1's verification hash.
- **Runs** (`scripts/time2.sh`, `scripts/round.sh`). Every executable runs once untimed. Then come 5 rounds of Lua
  (each order, each script, both revisions) and 7 of speedtest1 (each shift), in #2553's order, pinned to CPU 2 and
  counted by `perf stat` (task-clock, user cycles and instructions).
- **Lock holds.** Each program's round is one hold of the lock: Lua's about 20 s, speedtest1's about 8 s. #2553 held
  it once per run. When this ran the lock's queue was ten deep with other sessions' builds, and `scripts/prepare.sh`'s
  hold per link would have waited hours, so it was stopped after the objects. `9700x/runs/busy.txt` has the busiest
  processes and the load at each hold's start and end.
- **Statistics.** `scripts/analyze.c` (#1216's) computes `9700x/analysis.txt`.

1,762 timed runs, all exiting 0 with every count (`9700x/runs/runs.txt`), from 10:40 to 11:30 UTC.

| 9700X, CPU 2 | base | head | 100 ln(head / base), 95% interval | head slower at |
| --- | ---: | ---: | ---: | ---: |
| Lua's five scripts, user cycles (median over 33 orders) | 1,090.8 M | 1,091.8 M | -0.10 (-0.64 to +0.44) | 15 of 33 |
| Lua's five scripts, user instructions | 5,280.7 M | 5,165.3 M | -2.20 (-2.22 to -2.19) | 0 of 33 |
| speedtest1, user cycles (median over 8 shifts) | 825.5 M | 822.2 M | -0.34 (-0.71 to +0.04) | 2 of 8 |
| speedtest1, user instructions | 2,820.8 M | 2,819.0 M | -0.06 | 0 of 8 |

By script, Lua's user cycles change by the following (95% interval, orders where head is slower):

| Script | Change | Head slower at |
| --- | ---: | ---: |
| `calls` | -0.59 (-1.29 to +0.11) | 12 of 33 |
| `tables` | +0.30 (-0.86 to +1.46) | 18 of 33 |
| `strings` | -1.60 (-2.39 to -0.81) | 9 of 33 |
| `arithmetic` | -0.45 (-1.35 to +0.46) | 10 of 33 |
| `closures` | +1.17 (+0.22 to +2.12) | 25 of 33 |

The run-to-run spread within a cell is a median 0.63% (Lua) and 0.27% (speedtest1) in cycles.

**The instructions fall, the time doesn't.** The removed moves are register-to-register, which Zen 5 eliminates at
rename. The dispatch's critical path, the load of `i`, its opcode and the table's load into the indirect jump, never
included them. By script, the cycles don't follow the instructions:

| Script | Instructions (callgrind, `counts/`) | Cycles |
| --- | ---: | ---: |
| `arithmetic` | -5.71% | -0.45 |
| `strings` | -0.17% | -1.60 |
| `closures` | -1.13% | +1.17 |

`scripts/mispredict.sh` counted branch mispredictions for `closures` and `strings` at every order, once each
(`9700x/mispredict.txt`). They are 1.3 M and 0.6 M a run, the same for both revisions. Their per-order changes don't
follow the cycles' changes: the correlations are 0.02 and -0.05. Every order shares `luaV_execute`'s internal layout,
which head changes (159 fewer instructions), so the per-script differences are most likely that layout's, not the
removed moves'. Nothing here separates the two.

Without use counts (#2732, head3), `lvm.c`'s object is the same as head's, and Lua's scripts run the same 5,121.1 M
instructions by callgrind. speedtest1 runs 2,869.0 M, with the same hash. Roots that also have readers after their
anchor or in other blocks now move. Nine functions run fewer instructions (`sqlite3VdbeExec` −0.91 M against head) and
two run more, `instrFunc` +0.17 M and `allocateBtreePage` +0.16 M, from different spill choices. `sqlite3.c`'s spill
stores fall from 8,418 to 8,327 (`counts/reports-head3.txt`). These counts (`counts/*-head3/`) ran head2's compiler,
whose objects equal head3's: all 34 Lua sources, speedtest1's unit and `sqlite3.c`, byte for byte, by both host paths.
The 9700X's runs timed head, whose `luaV_execute` head3 shares.

## 3. Compile time on the 9700X

`measure-compile` runs the compilers' processes in a Williams order, pinned to CPU 2, each input in one hold of the
lock: 21 runs of `--tier1 --lanes 1 -c` of `sqlite3.c` (#518's options) and 41 of Lua's `lvm.c`.
- `scripts/compile.sh` timed head against base (`9700x/compile/`);
- `scripts/compile2.sh` timed head2 against base and head (`9700x/compile2/`);
- `scripts/compile3.sh` timed head3 against base and head2 (`9700x/compile3/`).

head3's first build reused head2's CMake tree, whose paths are absolute, so it built head2's sources:
`9700x/compile3-stale/` timed head2 against itself. That gives the noise, within 0.1% in cycles.

| `--tier1 -c`, medians | base | head | head2 | head3 |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c`, user instructions | 5,448.9 M | 5,507.3 M (+1.07%) | 5,460.4 M (+0.21%) | 5,458.6 M (+0.18%) |
| `sqlite3.c`, user cycles | 2,423.3 M | 2,461.4 M (+1.57%) | 2,432.8 M (+0.34%) | 2,431.8 M (+0.29%) |
| `lvm.c`, user instructions | 333.6 M | 336.8 M (+0.96%) | 335.4 M (+0.54%) | 335.7 M (+0.63%) |
| `lvm.c`, user cycles | 113.8 M | 114.7 M (+0.79%) | 114.0 M (+0.35%) | 114.1 M (+0.35%) |

Each column's base is the base measured in that hold, and every row's base is within 0.1% across the holds.

**The first form's cost.** By callgrind on a baseline (`x86-64`) build, the sink took 90.3 M of 16.6 G instructions
compiling `sqlite3.c`, inclusive. 43.6 M were its own code, which on that host includes the classification's scalar
twin. Most of the rest went to `ir_operand_count` and `ir_operand`, called per operand to count every value's uses;
the permutation took 3.4 M. Without use counts, the same build's sink takes 28.1 M, mostly that scalar classification,
which the 9700X's build does 64 instructions at a time.

**What's left.** head3's pass, on `sqlite3.c`, looks at 11,135 candidates, makes 4,258 family tests and 2,020 window
scans. It renames the operands of 48,542 of the 561,542 instructions it sees, those of the functions it moves anything
in. These counts come from a throwaway counting build, not kept. How the remaining +9.7 M instructions split between the
pass and the later stages, whose input it changes, isn't measured. On `lvm.c` the moved expressions span almost all of
`luaV_execute`, so the range limit saves nothing there, and its check adds a little.
