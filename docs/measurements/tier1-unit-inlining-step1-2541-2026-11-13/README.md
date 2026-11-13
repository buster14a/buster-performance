# #2541 step 1: small internal callees from unit summaries, on the 9700X (2026-11-13)

The measurement of step 1 of
[#2541's design](https://github.com/buster14a/buster/blob/main/docs/tier1-unit-inlining.md): the unit stage between the
emission's halves (the candidates' call graph and its cycles), a summary per candidate built once for the unit (its
lowering, its calls' expansions and Tier 1's passes from promotion to the verified optimizer, which its own code goes on
from at selection), and the small class (internal functions without an inline attribute, a summary of at most 256
instructions, each call at an inliner cost of at most 64: the prototype's c64), in
[buster14a/buster#2641](https://github.com/buster14a/buster/pull/2641).

- **main:** `26f0bb0e1ab0ae8fc0a7c119064796dfd4b0d5fa` (`9700x/main.commit`).
- **head:** `7ed0bc942bb4468993b9f75bf9a3ffacb9705ab1` (`9700x/head.commit`), the PR's first commit; and **head2**,
  `1c48a17b10b5f9b321d3d81103590e8bc95a870d` (`9700x/head2.commit`), its second, which copies the caller's runs between
  expansions by vector and writes the same objects (checked locally on sqlite3.c by both paths). Every run but the last
  compile session is head's.
- **Host:** AMD Ryzen 7 9700X, Linux 6.18.50, CPU 2 (governor and EPP `performance`), clang 23.1.1, perf 7.2.9
  (`9700x/host.txt`, with the inputs' and the Release compilers' SHA-256). Every build and run held the machine's lock,
  one hold per command (`scripts/lock.sh`, `scripts/queue.sh`, `9700x/q*.txt` and their logs).

The scripts adapt the design record's (`tier1-quality-138-2026-11-12/9700x`'s `proto-programs.sh`, `proto-runs.sh`,
`proto-compile.sh`) and step 0's (`selfhost-*.sh`) to two trees; the inputs are #138's record's (speedtest1.c, Lua
5.4.8 and its five scripts, with clang -O2's Lua as the scripts' expected output) and the host's frozen `sqlite3.c`. The
Release compilers were built on the host from clean clones (`scripts/clone.sh`, `scripts/build.sh`,
`9700x/results/build-*.log`). `scripts/summarize.sh` turns the runs into the tables below (`9700x/summary.txt`).

## The gate

| Gate | Result |
| --- | --- |
| objects equal at 1 and 8 lanes, by both twins | **met**: 72 of 72 pairs the same bytes (`9700x/results/objects.txt`: sqlite3.c, speedtest1.c and Lua's 34 units, by the vector path and the scalar twin, `-O2`) |
| speedtest1 at least 6% fewer cycles at every placement | **not met**: 5.34% fewer (4.86 to 5.82), faster at 8 of 8 placements, 4.45% to 6.08% each |
| Lua not slower at any link order | **not met**: 1.51% fewer over the five scripts (-4.18 to +1.16), faster at 3 of 4 orders; the fourth +0.14 |
| the unit stage under 1% of `--tier1 -c sqlite3.c` | **met**: `check_tier1_inline_stage` 0.02% of the compile's user cycles (`9700x/results/stage-*.txt`) |
| the compile's growth at most its code's plus 3 points | **not met**: user cycles +17.3% (+17.4% by head2) for `.text` +12.8% (992,104 to 1,119,304 bytes), so 4.5 points past the code's growth where the gate allows 3 |

## Programs

speedtest1 (the frozen sqlite3.c and speedtest1.c as one unit) at eight placements of its code (a padding object of
0, 528, ..., 3,696 bytes of NOPs linked first), Lua as an object per unit linked in four orders of its 33 units; every
executable checked first (speedtest1's verification hash at every placement, each Lua script's output against clang
-O2's at every order: `9700x/results/runs/checks.txt`, 48 hashes and 120 outputs, all as expected), then one warm-up and
six measured rounds, the trees alternating by round and placement (`scripts/runs.sh`, three holds of two rounds).
As 100 ln(head / main) of user cycles, the mean over placements with its 95% interval (Student's t over the eight
placements, or four orders; a placement's rounds are not independent draws of a layout):

| Program | main, M | head, M | change | faster at | each placement |
| --- | ---: | ---: | ---: | --- | --- |
| speedtest1 | 882.4 | 836.5 | **-5.34** (-5.82 to -4.86) | 8 of 8 | -5.15 -6.08 -5.42 -5.97 -4.91 -5.77 -4.98 -4.45 |
| Lua, five scripts | 1,117.6 | 1,101.0 | **-1.51** (-4.18 to +1.16) | 3 of 4 | -3.81 -0.84 -1.54 +0.14 |
| calls.lua | 108.7 | 108.1 | -0.50 (-2.59 to +1.59) | 2 of 4 | |
| tables.lua | 230.1 | 226.5 | -1.55 (-2.42 to -0.68) | 4 of 4 | |
| strings.lua | 274.9 | 269.1 | -2.13 (-3.32 to -0.95) | 4 of 4 | |
| arithmetic.lua | 174.8 | 173.6 | -0.65 (-5.65 to +4.35) | 2 of 4 | |
| closures.lua | 329.3 | 323.7 | -1.75 (-8.23 to +4.74) | 2 of 4 | |

The objects (`9700x/results/programs/*-builds.sha256` and the `--tier1-report`s): speedtest1's `.text` 1,024,690 to
1,152,418 bytes (+12.5%), its expanded calls 2 to 4,664; Lua's units' `.text` 224,909 to 260,164 (+15.7%), 0 to 660.
The prototype's c64 grew them by 10.5% and 11.4%.

The calls each program makes (`scripts/calls.sh`, `9700x/results/calls.tsv`: retired near returns, three runs, the
first placement and order):

| Program | main's returns, M | head's, M | removed, M | cycles removed, M | cycles a removed call |
| --- | ---: | ---: | ---: | ---: | ---: |
| speedtest1 | 76.22 | 59.37 | 16.85 | 43.8 | 2.6 |
| Lua, five scripts | 110.70 | 106.09 | 4.61 | 37.0 | |

speedtest1's removed calls are worth 2.6 cycles each, as the design measured (2.8 to 3.0). Lua's hot functions are
external (`luaV_*`, `luaH_*`), which step 1's internal classes don't take: calls.lua and arithmetic.lua lose almost no
calls, and their changes are the placement's noise.

### Against the prototype

The gate's figures are the prototype's at c64, measured against main of 2026-11-12, whose speedtest1 took 936.3 M
cycles and Lua 1,236.3 M. Today's main takes 882.4 M and 1,117.6 M: 5.8% and 9.6% less, from the work between
(#2593's placement, #2524's node machine, step 0 and others). In cycles, head's speedtest1 (836.5 M) is below the
prototype's c64 (876.9 M) and its c128 (854.9 M); its Lua (1,101.0 M) below the prototype's c64 (1,207.3 M). Against
a faster main, the same reach is a smaller fraction; which of the work between overlaps with what inlining removes was
not measured.

## The compile

`--tier1 -c` of the frozen sqlite3.c, one lane, pinned to CPU 2, seven measured runs each in rotation after a warm-up
(`scripts/compile.sh`; `9700x/results/compile/perf.tsv`, `runs.tsv` with wall, user and system seconds and peak RSS):

| | user cycles, M | instructions, M | task-clock, ms | peak RSS, MB | `.text`, bytes |
| --- | ---: | ---: | ---: | ---: | ---: |
| main | 2,140.2 | 4,735.6 | 402.9 | 294.5 | 992,104 |
| head | 2,510.6 (+17.3%) | 5,669.3 (+19.7%) | 471.0 (+16.9%) | 307.3 (+4.4%) | 1,119,304 (+12.8%) |
| head2 (second session; main 2,134.5) | 2,505.9 (+17.4%) | 5,639.4 (+19.1%) | 470.4 (+16.8%) | 307.3 | 1,119,304 |

The profiles (`scripts/profile.sh`, `scripts/stage.sh`; `9700x/results/profile-*.txt`, `stage-*.txt`) put the growth
in every stage at about its own share: the backend's stages (promotion, the CFG, selection, the allocation, the
emission) each take about the same fraction of head's compile as of main's. What inlining itself adds is
`ir_optimize_inline` (1.6% of head's cycles; 2.1% by head2's sampling), the unit stage (0.02%) and the summaries'
bookkeeping (0.1%): the rest is the larger IR. In the IR the growth is about twice the code's (locally, on sqlite3.c
`-O2`: the optimized functions' instructions +23.4% and blocks +37% for `.text` +10.3%), since an expanded callee's IR
is all copied while the call it replaces was one instruction and its machine code a few.

## Where the compile's cost was found (local)

Before the 9700X, the levers were chosen by callgrind on this session's container (an Intel Xeon), on scalar-host
builds (`BUSTER_HOST_ARCH=x86-64`, valgrind can't run AVX-512; `ulimit -v 64 GiB` so that the arenas reserve), one lane,
`--tier1 -O2 -c sqlite3.c` (`local/callgrind-totals.txt`; `local/callgrind-main-vs-*.txt`: each function's inclusive
instructions, M, main against the variant, by `callgrind_annotate --inclusive=yes`; `0x...9950` is memset's PLT entry):

| Variant | the program, M | the Tier 1 stage (`check_tier1_compile`), M |
| --- | ---: | ---: |
| main | 15,875.8 | 5,439 |
| summaries promoted and optimized apart from the passes, SROA after every expansion (`first`) | 18,108.3 (+14.1%) | 7,635 (+40.4%) |
| summaries are the passes' result, which their own code goes on from (`passes`) | 17,781.0 (+12.0%) | 7,299 (+34.2%) |
| and SROA only where an expansion copied an aggregate (`sroa`, the PR's code) | 17,183.1 (+8.2%) | 6,701 (+23.2%) |

The first variant optimized every small summary for its callers and again in its own pipeline (442 M); making the
summary the passes' result removed that, and since the summaries were smaller, more callees fit the class. SROA ran
after every expansion of a function with any address-taken slot, 449 functions on sqlite3.c, for 662 M; without it
sqlite3.c's `.text` changed by 768 bytes (0.05%), since what it split was the caller's own aggregates, not the
expansions', so it now runs only where an expansion copied an aggregate argument or result (or on vectors, as before).
Container timings (`time` of the native build, alternating, twelve runs) moved by 20% between runs and decided nothing.

## The compiler built by `--tier1`

As step 0's record: the compiler's 43 units at the scalar host compiled by each tree's `--tier1` and by clang -O2
(head's), linked by clang (`scripts/selfhost-build.sh`); the self-built compilers then compile the frozen sqlite3.c, one
lane, pinned to CPU 2 (`scripts/selfhost-runs.sh`, `scripts/selfhost-perf.sh`).

**Objects** (`9700x/results/selfhost/runs-checks.txt`): the default tier's object is the same bytes by all three builds;
the `--tier1` workload's is the same by head's `--tier1` build and its clang -O2 build. Main's differs from head's by
design: head's `--tier1` expands what main's doesn't.

**Counters** (`perf-*-stat.csv`, three runs, the default tier's compile):

| The compiler built by | user cycles, M | instructions, M | returns, M | branches, M |
| --- | ---: | ---: | ---: | ---: |
| main's `--tier1` | 8,099.6 | 30,332.0 | 282.7 | 4,322.6 |
| head's `--tier1` | 7,705.4 (-4.9%) | 29,459.1 | **178.7** | 4,055.6 |

The compiler's own build removes 104 M of its 283 M calls for 4.9% of its cycles, 3.8 cycles a removed call (step 2's
gate there is at most 60 M returns and 8% fewer cycles).

## Reproducing

On the host, in a directory with these scripts: `./clone.sh COMMIT main`, the same for head; then `queue.sh` of
`9700x/q1.txt`, `q2.txt` and `q3.txt` (each line takes the lock for one command); then `./summarize.sh`.
