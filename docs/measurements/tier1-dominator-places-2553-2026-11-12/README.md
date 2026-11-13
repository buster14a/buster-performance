# Tier 1: values keep their places along dominators (#2553), 2026-11-12

Evidence for [buster#2553](https://github.com/buster14a/buster/issues/2553) and its pull request
[buster#2603](https://github.com/buster14a/buster/pull/2603): the branch `claude/hopeful-wright-mi08b9` at
`09c205599b4282f3651ce2aaaa5a5c873bed6fd0` (**h7**, the pull request's code; the branch's later commits add tests and
documentation only) against main at its merge base, `afcb185e01ab0259a77972d5daa3f2079de26ade` (**base**). **h11** is h7
with `scripts/h11.patch`, a variant the pull request doesn't take. The issue asks for the dynamic edge moves, spills
and reloads (#1189's tags, as #1216 measured them) to fall on speedtest1 and Lua at every code placement, with no
more spills elsewhere, measured on the 9700X as #1216's were.

**Edge traffic falls on both programs, and both run faster on the 9700X. Two parts of the issue's target don't hold:
speedtest1's `yy_reduce` now saves and restores a parameter around a call on every reduction, and the edge traffic of
`sqlite3VdbeExec`, speedtest1's hottest function, rises slightly, though the function runs fewer instructions
(section 3, "Spills elsewhere").**

| Tagged edge traffic (callgrind, the 9700X's executables) | base | h7 | change |
| --- | ---: | ---: | ---: |
| speedtest1: moves, stores, reloads | 225.1 M | 210.6 M | -6.4% |
| Lua 5.4.8, five scripts | 542.7 M | 355.5 M | -34.5% |

| 9700X, CPU 2 | base | h7 | 100 ln(h7 / base), 95% interval | h7 slower at |
| --- | ---: | ---: | ---: | ---: |
| speedtest1, user cycles (median over 8 shifts) | 936.0 M | 928.7 M | -0.73 (-1.17 to -0.29) | 1 of 8 |
| speedtest1, user instructions | 3,199.4 M | 3,182.8 M | -0.52 | 0 of 8 |
| Lua's five scripts, user cycles (median over 33 link orders) | 1,223.4 M | 1,210.5 M | -1.02 (-1.44 to -0.61) | 7 of 33 |
| Lua's five scripts, user instructions | 6,005.3 M | 5,778.6 M | -3.83 (-3.85 to -3.81) | 0 of 33 |

The compile costs 1.0% more on sqlite3.c's `--tier1 -c` (section 4), of which the dominator analysis is about 0.6%.

## 1. What changed

- **h7** (`ccc81539`, `09c20559`): an interval may be hinted to another's register at its end (an *exit hint*), and
  each block's live-in values take their places from an *anchor*'s exit: its immediate dominator where that is laid
  out before it, or a loop's latch laid out before it. A phi takes its operand's place at the exit of a *chosen*
  predecessor (the latch, else the immediate dominator, else the nearest earlier one), an operand of a phi chain takes
  the register of the chain's first phi, and slot sharing joins phi to phi before phi to operand. The anchors come
  from `dominators.c`'s SEMI-NCA tree. `docs/tier1-allocation.md` ("Places along dominators") has the design.
- **h11** (`scripts/h11.patch`): h7, and an interval an exit hint names whose value the scan last left in memory stays
  there when it has no use, rather than being reloaded on the edge. It cut Lua's edge stores less, and on the 9700X
  it was slower than h7 on both programs.

`local/` holds the tagged counts of the steps toward h7, measured on this container's executables (section 2's
method, but the programs built and run here): head1 walked up to the nearest earlier dominator for every block and
fought #1216's dispatch conventions; head3 added phi-first slot sharing; head4 phi-chain operand targets; head8 h7 with
`local/head8-preference.patch` (a web's members that cross no call may take caller-saved registers); head9 a
definition-only column, reverted; head10 kept every unused hinted range in memory (h11's rule without its
restriction to exit hints); head12 h7 with `local/head12-rest.patch` (section 3, "Spills elsewhere"). head2, head5
and head6 are intermediate steps of the same design.

## 2. Tagged edge traffic (callgrind)

These counts ran in a cloud container, **not on the 9700X**: Intel Xeon @ 2.10 GHz, Linux 6.18.44, valgrind 3.22.0,
GNU objdump 2.42, clang 23.1.6 (the tagged compilers' build). They count the **9700X's own timed executables**
(speedtest1's shift 0 and Lua's link order 0, section 3), run through the 9700X's loader and C library (glibc 2.44)
copied here. Instruction counts are not times.

- **Tags.** `scripts/kinds-2553.patch` carries
  [#1189's tags](../tier1-gap-1189-2026-11-03/README.md) to base, behind `BUSTER_TIER1_MEASURE_KINDS` (built with
  `BUSTER_BUILD_DEFINES=-DBUSTER_TIER1_MEASURE_KINDS=1`), as #1216's record did, and splits an edge's records: a
  phi's operand (`e` moves, `T` stores, `U` reloads) or a value live into the successor (`h`, `t`, `u`), and a move
  through the scratch register of a cycle, `x`. #1216's record's `e` is this record's `e+h+x`, its `T` and `U` are
  `T+t` and `U+u`. The other tags are #1189's: `S` and `L` spill stores and loads, `C` and `R` saves and restores
  around calls, `r` register copies, `j` jumps.
- **Same code.** Each revision's tagged compiler builds the same `.text` as the 9700X's compiler of that revision, for
  each of the 34 objects (`scripts/text.sh`, `callgrind/text.txt`: 102 of 102 the same), so the tags each tagged
  compiler writes describe the 9700X's executables.
- **Counts** (`scripts/cg9700.sh`): each executable under `valgrind --tool=callgrind --dump-instr=yes`, joined with
  the tags by #1189's `tools/gap.c` (byte for byte that record's; its unmatched check 0 for every run). speedtest1's
  `--verify` hash is `1248168 a7fa3957…` for each revision, and each Lua script prints clang -O0's output
  (`callgrind/*/st.verify`, `lua-outputs.txt`). `scripts/compare.sh DIR...` sums each `summary.txt`.

| Tagged instructions | base | h7 | h11 |
| --- | ---: | ---: | ---: |
| speedtest1 program | 3,077.2 M | 3,060.6 M (-0.54%) | 3,065.5 M |
| speedtest1 edge moves e+h+x | 86.6 M | 74.7 M | 75.8 M |
| speedtest1 edge stores T+t | 61.7 M | 59.8 M | 61.1 M |
| speedtest1 edge reloads U+u | 76.8 M | 76.1 M | 75.1 M |
| Lua program (five scripts) | 5,479.6 M | 5,261.4 M (-3.98%) | 5,271.3 M |
| Lua edge moves e+h+x | 453.2 M | 272.6 M | 272.6 M |
| Lua edge stores T+t | 35.0 M | 31.3 M | 35.0 M |
| Lua edge reloads U+u | 54.5 M | 51.5 M | 54.5 M |

By tag, speedtest1's e, h and x went from 30.6, 40.0 and 16.0 M to 29.8, 35.4 and 9.5 M; its t and u fell by 2.4 and
1.0 M while T and U rose by 0.5 and 0.4 M. Lua's x, the moves through r11 that swap registers, halved, from 191.1 M
to 96.1 M, and its e fell from 214.6 M to 131.8 M. `local/` has the same counts for every step (head1 to head12), from
this container's own builds of the programs.

The other tags (`callgrind/other-tags.txt`, millions):

| | S | L | C | R | r | j |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| speedtest1 base | 24.14 | 3.55 | 88.54 | 101.89 | 44.27 | 379.72 |
| speedtest1 h7 | 25.45 | 3.52 | 91.08 | 104.46 | 39.76 | 375.46 |
| Lua base | 33.22 | 7.44 | 127.78 | 157.64 | 74.73 | 676.22 |
| Lua h7 | 33.96 | 7.44 | 127.77 | 157.62 | 72.60 | 641.17 |

## 3. Runtime on the 9700X

The method is #1216's ([tier1-loop-carried-1216-2026-11-09](../tier1-loop-carried-1216-2026-11-09/README.md),
section 2), with three revisions in place of two.

- **Machine.** Ryzen 7 9700X, Linux 6.18.50-2-lts, CPU 2 (`performance` governor, its SMT sibling, CPU 10,
  offline), glibc 2.44, GCC 16.2.1 and GNU ld 2.47 (`cc`, the link), perf 7.2.9, clang 23.1.1 (the compilers' build).
- **Lock.** Every build, compile, link, check and timed run took its own hold of `exclusive.sh`; other sessions' and
  CI's work ran between them.
- **Compilers** (`scripts/clone.sh`, `scripts/compilers.sh`): clean clones of base and h7 (h11: h7's clone with
  `h11.patch`), each built by its own `build.sh` with `BUSTER_HOST_ARCH=znver5` (`9700x/build.log` has their hashes).
- **Executables** (`scripts/prepare.sh`): each compiler builds Lua's 33 objects and speedtest1's one object once, by
  `--tier1 -fno-asynchronous-unwind-tables --tier1-report` (`9700x/objects-*.sha256`, `9700x/reports-*.txt`). Lua is
  linked by `cc` in #1216's 33 orders (`9700x/orders.txt`); speedtest1 after a padding object of 0, 528, ..., 3,696
  bytes. **speedtest1's shifts move all of its code together; they don't change its relative layout.** The inputs are
  #1216's: SQLite 3.53.2's amalgamation and `speedtest1.c`, Lua 5.4.8 and the five scripts.
- **Checks.** Before any timing, all 123 executables passed: every Lua order printed clang -O0's output for all five
  scripts and every speedtest1 shift gave the hash `1248168 a7fa3957…` (`9700x/checks.txt`).
- **Runs** (`scripts/time.sh`): every executable once untimed, then 5 rounds of Lua (each order, each script, the
  three revisions) and 7 of speedtest1 (each shift), the programs' rounds interleaved, the revisions' order rotated
  by round, layout and script. Each run is pinned to CPU 2 and counted by `perf stat` (task-clock, user cycles and
  instructions). `scripts/chain.sh` ran the three steps and the analyses.
- **Statistics** (`scripts/analyze.c`, #1216's): each layout's `100 ln(head / base)` over the cells' medians, the
  layouts taken as independent samples. `9700x/analysis-h7.txt` and `analysis-h11.txt` compare each with base.

### Results

2,643 timed runs, all exiting 0 with every count (`9700x/runs/runs.txt`): 5 per Lua cell and 7 per speedtest1 cell.
The warm-ups started at 21:39:56 UTC and the last round ended at 21:51:55 (`9700x/runs/log.txt`).

| User cycles, 100 ln(rev / base) | mean, 95% t interval | median | rev slower at |
| --- | ---: | ---: | ---: |
| Lua, h7 | -1.02 (-1.44 to -0.61) | -1.07 | 7 of 33 |
| Lua, h11 | -0.79 (-1.32 to -0.27) | -0.46 | 9 of 33 |
| speedtest1, h7 | -0.73 (-1.17 to -0.29) | -0.89 | 1 of 8 |
| speedtest1, h11 | +0.15 (-0.38 to +0.69) | +0.31 | 5 of 8 |

By script, h7's Lua user cycles: arithmetic -2.19 (-2.82 to -1.56), closures -1.54 (-2.60 to -0.48), tables -1.28
(-1.85 to -0.71), strings -0.15 (-0.99 to +0.68), calls +1.08 (-0.61 to +2.76; slower at 14 of 33 orders, its spread
4.76 over orders against 1.16 for the total). Task-clock follows cycles: -1.01 (Lua) and -0.58 (speedtest1). The
run-to-run spread within a cell is a median 0.54% (Lua) and 0.27% (speedtest1) in cycles.

Statically, by the `--tier1-report` totals (`9700x/reports-*.txt`), speedtest1's edge moves went from 23,171 to
21,446, its spill stores from 7,670 to 7,177 and its spill loads from 8,420 to 7,937; Lua's edge moves from 1,650 to
1,457 (`lvm.c`'s from 995 to 797). Both build every function by Tier 1 (2,709 and 1,087), with Lua's one fallback
unchanged.

### Spills elsewhere

The issue also asks for no more spills elsewhere, and that doesn't fully hold. speedtest1's spill stores (`S`) rose by
1.31 M and its saves and restores around calls (`C`, `R`) by 2.54 M and 2.57 M; Lua's `S` rose by 0.74 M. By function
(`gap`'s TSVs in `callgrind/`):

| Function | base | h7 |
| --- | ---: | ---: |
| `yy_reduce` (speedtest1): all instructions | 80.53 M | 81.07 M |
| `yy_reduce`: edge traffic, e+h+x+T+t+U+u | 4.18 M | 0.13 M |
| `yy_reduce`: saves and restores around calls, C+R | 0.66 M | 5.56 M |
| `sqlite3VdbeExec` (speedtest1): all instructions | 549.23 M | 546.82 M |
| `sqlite3VdbeExec`: edge traffic | 114.83 M | 116.91 M |
| `sqlite3VdbeExec`: spill stores, S | 15.41 M | 16.63 M |
| `luaV_execute` (Lua): all instructions | 2,865.63 M | 2,642.68 M |
| `luaV_execute`: edge traffic | 482.91 M | 295.62 M |
| `luaV_execute`: spill stores, S | 30.05 M | 30.79 M |

- **`yy_reduce`** accounts for nearly all of speedtest1's added `C` and `R`. Its parameter `yypParser` arrives in
  `rdi`. In h7 it stays there from the entry into the join after the parser's switch: the join's anchor is the block
  before the switch, whose exit holds it in `rdi`. The join calls `yy_find_reduce_action` on every reduction (1.23 M
  times), saving and restoring `rdi` around the call. Base kept it in `rbx` there and moved or stored it on every edge
  into the join instead. The function runs 0.54 M more instructions. The preferred problem (#2538) lets a parameter
  keep its incoming register on all of its intervals, though the preference's comment asks for that only over its
  definition's interval. Restricting a call-crossing parameter to callee-saved registers past its definition's
  interval (head9, and again head12 with `local/head12-rest.patch`, a column of the preferred problem's own sets)
  cost speedtest1 28.5 M and Lua 269 M more instructions than h7, so the pull request doesn't take it.
- **`sqlite3VdbeExec`**, speedtest1's hottest function, runs 2.41 M fewer instructions, but its edge traffic rose by
  2.08 M and its spill stores by 1.22 M. Its `e` rose from 5.45 M to 8.13 M. speedtest1's fall in edge traffic comes
  from its other functions.
- **`luaV_execute`** traded 0.74 M more spill stores for 187.3 M less edge traffic.

### Limits

- speedtest1's shifts move its one object as a whole, so its interval covers placement against pages and lines, not
  the relative layout of its functions. Lua's 33 orders do vary that.
- The interval is over the layouts' paired ratios; a layout's runs only make its medians.
- Tagged counts are of one placement each: instruction counts don't depend on placement, but Lua's move by a few
  million between runs, since Lua seeds its string hashes from addresses.

## 4. Compile time

`scripts/compile.sh` timed `--tier1 --lanes 1 -c` on sqlite3.c (21 runs) and Lua's `lvm.c` (41 runs) by h7's
`measure-compile` with base and h11 as references, pinned to CPU 2 (`9700x/compile/sqlite3.txt`, `lvm.txt`).
`scripts/nodom.sh` built h7 with `scripts/nodom.patch` (anchors without the dominator analysis: none, and the nearest
earlier predecessor chosen; not the pull request's code) and timed it the same way with base and h7 as references
(`sqlite3-nodom.txt`). `scripts/perf.sh` sampled each compiler's cycles on sqlite3.c (`compile/*.perf.txt`).

| sqlite3.c, medians | wall | user cycles | user instructions |
| --- | ---: | ---: | ---: |
| base | 378.6 ms | 1,999.3 M | 4,623.6 M |
| h7 | 382.5 ms (+1.0%) | 2,020.3 M (+1.0%) | 4,651.1 M (+0.6%) |
| h7 without the dominator analysis (second measurement, base 1,999.9 M and h7 2,019.9 M cycles there) | 380.7 ms | 2,007.7 M | 4,633.1 M |

So the dominator analysis is about 12 M of h7's 20 M extra cycles on sqlite3.c, and the rest of the change about 8 M.
`dominators_analyze` takes 1.72% of base's sampled cycles (the IR's passes) and 1.97% of h7's. On `lvm.c` the two are
within noise: 27.19 against 27.20 ms, 332.0 M against 333.3 M instructions.

## Files

- `scripts/`: `kinds-2553.patch` (tags), `cg9700.sh`, `text.sh`, `measure.sh`, `compare.sh` (section 2);
  `clone.sh`, `compilers.sh`, `prepare.sh`, `time.sh`, `chain.sh`, `analyze.c` (section 3); `compile.sh`, `nodom.sh`,
  `nodom.patch`, `perf.sh` (section 4); `h11.patch`; `mutants.sh` (the pull request's mutation checks).
- `callgrind/`: section 2's summaries, `gap`'s TSVs and the tag files, per revision; `text.txt`, `other-tags.txt`.
- `local/`: the steps' tagged summaries and `--tier1-report` totals; `head8-preference.patch`, `head12-rest.patch`.
- `9700x/`: section 3's logs, orders, checks, hashes, addresses, reports, `runs/runs.txt` (a line per run: program,
  layout, round, revision, script, exit status and counts) and the analyses; `compile/`, section 4's.

The inputs are external and not included; they are #1216's record's. The instruction text in `gap`'s TSVs and the
function names in the tag files derive from public-domain SQLite and from Lua 5.4.8 (MIT, Copyright (C) 1994-2025
Lua.org, PUC-Rio).
