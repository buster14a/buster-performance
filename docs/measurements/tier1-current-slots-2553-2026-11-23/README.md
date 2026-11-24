# Tier 1: slots already current across blocks (#2553), 2026-11-23

Evidence for [buster#2553](https://github.com/buster14a/buster/issues/2553) and its pull requests
[buster#3460](https://github.com/buster14a/buster/pull/3460) and
[buster#3478](https://github.com/buster14a/buster/pull/3478), both merged. #3460's branch
`claude/tier1-current-slots-2553` (**head**) is measured against main at its merge base,
`b7d0b5edff73852852f0664c07fab61b00cad378` (**base**), and again, after it merged main, against main `747fbeff`.
#3478 (`claude/tier1-current-slots-cost-2553`) generates the same code and cuts the analysis's compile time; its compile
time is section 2's `compile4/`.

The change is `tier1_cfg_current_slots`, a forward must-analysis of the values whose slots hold them at each block's
start, after which an edge or an eviction leaves out a store of a value into a slot that already holds it. The pull
requests and `docs/tier1-allocation.md` ("Slots already current (#2553)") have the design.

The session that made these runs: `session_01NNmNQsojpJwQo48xnR16jg` (Claude Code, Anthropic / claude-opus-5-5).

## 1. Tagged instructions (callgrind)

These counts ran in a cloud container, **not on the 9700X**: Intel Xeon @ 2.10 GHz, Linux 6.18.44, valgrind 3.22.0,
GNU objdump 2.42, the compilers built by `build.sh --config Release` there (the hosted toolchain, LLVM 23.1.4). They
count programs built and run in that container. Instruction counts are not times.

- **Tags.** `scripts/kinds-main.patch` is #2553's `kinds-2553.patch` (#1189's tags, `BUSTER_TIER1_MEASURE_KINDS`,
  written by `BUSTER_TIER1_KINDS`) ported to main `b7d0b5ed`: its three conflicts resolved by keeping main's code and
  adding the tags, an x87 phi's load left untagged. It also has #2553's `BUSTER_TIER1_DUMP_BLOCKS` dump, which the
  diagnosis below used. The letters are #2553's record's: `e`, `T`, `U` a phi operand's edge move, store and reload,
  `h`, `t`, `u` a live-in value's, `x` a move through the scratch register, `S` and `L` spill stores and loads,
  `C` and `R` saves and restores around calls.
- **Programs** (`scripts/measure.sh`): #1217's inputs (SQLite 3.53.2's amalgamation and `speedtest1.c` as one unit,
  Lua 5.4.8 with its five scripts), each compiler's `--tier1 -fno-asynchronous-unwind-tables`, Lua with its string
  hash seed fixed (`-Dluai_makeseed(L)=0x2768u`, as #2784's record), so that its counts don't move between runs. Each
  program ran under `valgrind --tool=callgrind --dump-instr=yes`, joined with the tags by #1189's `gap.c` (that
  record's `tools/gap.c`, with `GAP_INSTRUCTIONS=1` for per-instruction rows). `scripts/fndiff.sh` gives the
  per-function differences (`callgrind/functions.txt`).
- **Same code.** The head measured is the pull request's code before its tests and comments: speedtest1's unit and 12 of
  Lua's units compile to byte-identical objects by it and by the pull request's own compiler (bca7a951... for
  speedtest1, 00f2686b... for `lvm.c`).
- **Checks.** speedtest1's `--verify` hash is `1248168 a7fa3957...` for both, and each Lua script prints the same output
  for both (`callgrind/*/st.verify`, `*.out`).

| Instructions | base | head | change |
| --- | ---: | ---: | ---: |
| speedtest1 | 2,279.18 M | 2,255.03 M | -1.06% |
| speedtest1 edge moves e+h+x | 36.97 M | 36.97 M | 0 |
| speedtest1 edge stores T+t | 44.14 M | 30.15 M | -13.99 M |
| speedtest1 edge reloads U+u | 53.39 M | 53.39 M | 0 |
| speedtest1 spill stores S | 30.95 M | 21.03 M | -9.92 M |
| Lua's five scripts | 4,000.99 M | 3,994.60 M | -0.16% |
| Lua edge moves e+h+x | 82.48 M | 82.48 M | 0 |
| Lua edge stores T+t | 6.24 M | 5.54 M | -0.70 M |
| Lua edge reloads U+u | 21.58 M | 21.58 M | 0 |
| Lua spill stores S | 34.95 M | 29.25 M | -5.70 M |

The other tags (`L`, `C`, `R`) don't change. No function runs 0.05 M more; `sqlite3VdbeExec` runs 15.75 M fewer (473.5 M
to 457.8 M), `balance_nonroot` 1.39 M, `sqlite3Insert` 1.18 M, Lua's `luaV_execute` 3.22 M and `rehash` 2.36 M
(`callgrind/functions.txt`). Statically (`--tier1-report`, `callgrind/*/reports.txt`), speedtest1's unit has 442,398
records instead of 446,585, 7,031 spill stores instead of 10,976 and 23,728 edge moves instead of 26,484; Lua's 102,445
records instead of 102,532, 388 spill stores instead of 460 and 1,911 edge moves instead of 1,962.

### What the diagnosis found

On base, `sqlite3VdbeExec` held 71.1 M of speedtest1's 134.5 M tagged edge instructions: `t` 20.7 M, `u` 23.2 M, `U`
10.4 M, `T` 6.5 M. The allocation dump of its opcode loop (`scripts/dumpparse.py` reads `BUSTER_TIER1_DUMP_BLOCKS`'s
output) showed, at the dispatch's exit, a loop-invariant 32-bit load and two of the header's phis in their slots and
the step counter (`nVmStep`) in `rbp`, while the handlers' entry convention (#1216's, from the first handler) has the
three in `r15`, `r13` and `rbp` and the counter in its slot. On most of the 155 dispatch edges the loop reloads three
values and stores one; each handler's edge back to the latch, which keeps them in their slots, stored the three back
(5.82 M stores of the 32-bit value at `0x31c(%rsp)` alone). This change removes those stores. The reloads and the
counter's store remain: at the latch, header and dispatch a frame address's recipe holds `r13`, which the handlers
give a phi, without a use there.

## 2. Runtime and compile time on the 9700X

The method is #2784's record's (`scripts/9700x/`, #2553's method with the lock held per program's round), with base
and head as two clean clones of base, head with `head.patch` (the pull request's source change, before its tests and
comments).

- **Machine.** benchpress, the Ryzen 7 9700X, CPU 2. Compilers built by each clone's `build.sh --config Release` with
  `BUSTER_HOST_ARCH=znver5` (the 9700X job's Clang 23.1.4), a hold of `exclusive.sh` each.
- **Programs.** #2592's inputs (`9700x/inputs.sha256`): Lua 5.4.8's 33 objects and speedtest1's unit, each compiled
  once by each compiler (`--tier1 -fno-asynchronous-unwind-tables --tier1-report`), Lua linked by `cc` in 33 orders
  (`9700x/orders.txt`), speedtest1 after 8 paddings (0 to 3,696 bytes). Their `.text` is the code counted in
  section 1: `lvm.o`'s, `ltable.o`'s and speedtest1's, base's and head's, are the container's bytes.
- **Checks.** All 82 executables print clang -O0's output for each Lua script, or speedtest1's hash
  (`9700x/checks.txt`).
- **Runs** (`scripts/9700x/time2.sh`, `round.sh`): a warm-up, then 5 rounds of Lua and 7 of speedtest1, a hold per
  program's round, the revisions' order rotated; 1,762 runs, none failed (`9700x/runs/`).
- **Statistics** (`scripts/9700x/analyze.c`, #2784's): 100 ln(head / base) of each layout's medians, the layouts as
  samples (`9700x/analysis.txt`).

| | user cycles, mean (95% t interval) | head slower at | instructions |
| --- | ---: | ---: | ---: |
| speedtest1 (8 shifts) | -0.94 (-1.80 to -0.08) | 1 of 8 | -1.02% |
| Lua's five scripts (33 orders) | -0.36 (-0.71 to -0.00) | 9 of 33 | -0.15% |
| calls.lua | -1.73 (-2.42 to -1.04) | 2 of 33 | |
| tables.lua | -0.52 (-0.97 to -0.07) | 9 of 33 | |
| strings.lua | -0.30 (-1.07 to +0.46) | 17 of 33 | |
| arithmetic.lua | +0.16 (-0.31 to +0.64) | 24 of 33 | |
| closures.lua | -0.05 (-0.95 to +0.84) | 13 of 33 | |

Task-clock follows cycles: speedtest1 -0.91 (-1.56 to -0.25), Lua -0.32 (-0.68 to +0.04). Lua's instructions here use
its address-seeded string hash, so they differ from section 1's fixed seed.

### Compile time

`measure-compile` (CPU 2, `--tier1 --lanes 1 -c`, a hold per input; 21 runs of `sqlite3.c`, 41 of `lvm.c`) and `perf
record -e cycles:u` of each compiler on `sqlite3.c` (#2553's `perf.sh`):

| sqlite3.c | instructions | cycles | `tier1_cfg_finish`'s share |
| --- | ---: | ---: | ---: |
| `compile/`: base `b7d0b5ed` / head `b651164d` (layout-order sweeps over the liveness's matrices) | 8,092.2 / 8,158.0 M (+0.81%) | 3,261.8 / 3,287.0 M (+0.77%) | |
| `compile2/`: base / `1083bacb` (reverse postorder, OUT kept, AVX-512 rows) | 8,092.2 / 8,124.9 M (+0.40%) | 3,262.4 / 3,279.0 M (+0.51%) | |
| `compile3/`: main `747fbeff` / #3460 as merged `63e53733` (#1384's groups, live lists) | 8,088.9 / 8,145.6 M (+0.70%) | 3,294.7 / 3,321.0 M (+0.80%) | 3.10% / 3.70% |
| `compile4/`: `747fbeff` / main `93ac0f5d` (with #3460) / #3478 `8084fcfa` | 8,088.9 / 8,149.0 / 8,136.8 M | 3,297.5 / 3,325.0 / 3,321.3 M | 3.01% / 3.52% / 3.42% |

`lvm.c`: 320.1 M to 321.8 M instructions (first head), 320.9 M (`1083bacb`); 319.5 M (`747fbeff`), 321.1 M (main
`93ac0f5d`), 320.8 M (#3478). Timed by phase in the container (TSC ticks over a `sqlite3.c` compile, `local` notes in
the pull request), #3460's analysis took about 20 M ticks: 8 M in the group solve, 3.3 M reading every block's
live-in list for the candidates and LIVE_IN, 3.0 M stamping each block's list before its edges, the rest in setup,
postorder, count and fill; #3478 removes the second and third.
