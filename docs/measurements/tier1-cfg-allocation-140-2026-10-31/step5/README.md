# Tier 1 through the C driver: correctness and run time on programs (#140, step 5), 2026-10-31

Evidence for buster#140's last Done-when items, correctness by #142's programs and SQLite's own tests and run time
against Tier 0 and clang -O2, now that the driver's `--tier1` compiles each function Tier 1's pipeline takes by Tier 1
and the rest by Tier 0 (buster#970). By Claude, at David's request. The parent directory's README covers steps 1 to 3
(the CFG allocator itself, its validity on the corpora, its compile time and spills), `step4/` the native edge moves.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `693926a7` | main, with #964 and #965 merged |
| first head | `517b6ae9` | `--tier1`, frame objects, symbols, calls, narrow values, division and shifts |
| final head | `2fa64125` | the first head, values live across calls in callee-saved registers, the report's counts |

Both heads are `claude/140-tier1-driver` (buster#970). The 9700X trees were `git archive`s of the commits:
`9700x/receipts.txt` has each tree's file hash (equal to its commit's archive), its `build/compiler`'s and the inputs'.

## Commands

On the 9700X, every step one hold of the shared lock, timed runs on CPU 2 (`9700x/`):

- `queue-c.sh BASE HEAD`: both trees' builds (`BUSTER_DEBUG_INFO=0`); `ab` of `time-runs`, 5 rounds of 21 runs, base
  against head, of `-c` of the frozen `sqlite3.c` and of the direct path's link of speedtest1; head's `-c` with and
  without `--tier1`; speedtest1 (#136's harness: the frozen `sqlite3.c`, SQLite 3.53.2's `test/speedtest1.c`,
  `test/speedtest.tcl`'s flags and options, the database on tmpfs) built six ways, a `--verify` run of each, 11 rounds
  of the six in a rotating order; `perf record` of the Tier 0 and `--tier1` builds' runs. Its first run built
  speedtest1 with a relative compiler path after a `cd`, so only clang's builds ran: `queue-s.sh` is that part again,
  fixed, for the first head, and `queue-c.sh` as kept here has the fix.
- `queue-b2.sh BASE HEAD`: two more builds of each tree, alternating.
- `queue-f.sh BASE HEAD REVISION`: for the final head, `queue-c.sh`, then `perf stat` of four builds' runs, then
  `queue-d.sh`.
- `queue-d.sh HEAD REVISION`: #142's campaign, Csmith `0cdc710` and YARPGen `1adb290`, seeds 3000 to 3039, 2 programs
  per generator a hold, at both tiers (`--tier0-default`, `--tier1-arg --tier1 --tier1-arg
  -fno-asynchronous-unwind-tables`).
- `summary-c.sh LOGS ST` makes the tables below from the logs; `mix.awk` counts the instruction mix of the functions
  `head-2fa64125/tier-classes.txt` marks as Tier 1's, which are those whose instruction sequence differs between the
  Tier 0 and `--tier1` builds.

Locally (`local/`, Zen 4, counts and correctness only): c-testsuite's subset by `test-c-testsuite --tier1` at the final
head (`c-testsuite-tier1.log`); #142 campaigns of 40 programs per generator, seeds 2000 to 2039 at `517b6ae9`'s code
(`diff3-*`) and 5000 to 5039 at the final head's (`diff5-*`), and 30 per generator with `--tier1 --scalar`, seeds 4000
to 4029 at `517b6ae9` (`diff4-*`); `speedtest1-build.sh` and `speedtest1-run.sh` for local runs.

## Correctness

| Check | Result |
| --- | --- |
| c-testsuite's 220-program subset, `--tier1`, both paths | 220 pass; Tier 1 compiles 350 of their 430 functions |
| speedtest1 `--verify`, `--tier1` and `--tier1 --scalar`, both heads | `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`, Tier 0's, clang -O0's and clang -O2's hash |
| #142 on the 9700X, 80 programs, `517b6ae9` and `2fa64125` | 66 pass at both tiers in each; 14 fail in clang's own steps (9 links past the small code model, 2 output limits, 3 runs past 30 s under clang -O0), none in Buster's |
| #142 locally, 80 programs, vector path (`diff3`, `diff5`) | 66 and 66 pass; 14 and 14 fail in clang's steps |
| #142 locally, 60 programs, `--tier1 --scalar` (`diff4`) | 51 pass; 9 fail in clang's steps |

Tier 1 compiled 1,378 of the `diff3` Csmith programs' 1,524 functions and 133 of the YARPGen programs' 200, so the
campaigns exercise the allocator. The vector path is the CFG allocator's vector path with its scalar fallback (both);
`--scalar` is the scalar path alone.

## Coverage

`--tier1-report` on speedtest1 at the final head: Tier 1 compiles 2,207 of its 2,709 functions. Tier 0 compiles the
rest: 369 refused at a call (most for a narrow argument, whose extension the IR doesn't record), 79 as a whole (labels
and switches, `sqlite3VdbeExec` and the parser's among them; aggregates by value; variadic definitions), 22 at a
constant, 21 at a parameter, 7 at a load, 1 at a phi, 3 in allocation.

## Run time

speedtest1, medians of 11 rounds (wall, from fork to wait), ranges in brackets:

| Build | first head | final head |
| --- | ---: | ---: |
| Tier 0 (head's default) | 256.1 ms (255.5–256.9) | 256.1 ms (255.4–256.5) |
| Tier 0 (base's) | 257.2 ms (256.3–258.0) | 256.5 ms (256.0–257.4) |
| `--tier1` | 289.9 ms (289.6–290.8) | 285.0 ms (284.2–285.7) |
| `--tier1 --scalar` | 289.7 ms (288.4–292.6) | 285.7 ms (285.0–286.5) |
| clang -O0 | 295.4 ms (293.7–296.4) | 289.6 ms (288.1–290.7) |
| clang -O2 | 132.3 ms (132.0–132.7) | 131.5 ms (131.3–132.0) |

At the final head, `perf stat` of one run each: Tier 0 5,694 M instructions and 1,320 M cycles; `--tier1` 6,431 M and
1,477 M; `--tier1 --scalar` 6,460 M and 1,478 M; clang -O2 2,010 M and 634 M.

So the build of both tiers runs 11.3% slower than Tier 0's, about clang -O0's time, and 2.17 times clang -O2's. Where:
of the Tier 0 build's 1,341 M sampled cycles, the functions Tier 1 compiles take 667 M; in the `--tier1` build their
code takes 843 M (+26%), while the functions both builds leave to Tier 0 take 545 M and 534 M. Statically, Tier 1's
code of those functions has 272,353 instructions against Tier 0's 193,408 for them, 39,353 frame accesses against
13,219, 17,107 `setcc` against 8,190 and 22,469 `test` against 12,066 (`mix.awk`). Before callee-saved registers (the
first head), its frame accesses were 58,035 and it ran 13.2% slower than Tier 0.

The allocation's own traffic, from `--tier1-report` (records of Tier 1's code):

| Head | records | spill stores | reloads | call saves | restores | recomputed constants | edge moves |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| first | 289,081 | 6,496 | 8,532 | 20,732 | 20,732 | 335 | 13,820 |
| final | 272,439 | 3,439 | 4,111 | 10,355 | 10,355 | 213 | 10,508 |

What still costs, from the disassembly: comparisons stay `cmp; setcc; movzx; test; setne; movzx; test; jcc` chains,
C's comparison-as-int through the IR's `zext`, which selection doesn't fuse; constant offsets are materialized and
added (`mov $8, %edx; lea (%r8,%rdx), %rdx; mov (%rdx), %rdx`) rather than folded into addresses; an unsigned remainder
by 16 is a `div`; and the saves around calls that remain are mostly parameters', whose definition's interval keeps its
caller-saved incoming register across the entry block's calls.

## Compile time and build time

`time-runs` medians per round, ms (wall), 5 rounds of 21 runs:

| Command | base | final head |
| --- | --- | --- |
| `-c sqlite3.c` | 130.42, 130.41, 130.40, 130.44, 130.44 | 130.72, 130.51, 130.73, 130.78, 130.64 |
| speedtest1's direct-path link | 134.62, 134.48, 134.62, 134.55, 134.54 | 134.79, 134.69, 134.76, 134.70, 134.79 |
| `--tier1 -c sqlite3.c` | | 395.81, 395.88, 395.81, 395.93, 395.71 |

The default path's instructions: 1,350,286,090 at base, 1,350,409,207 at the final head (+0.009%); its time +0.2%,
within what a code placement moves a whole compile by on this host (docs/profiling.md, "Builds over their code's
placements and copies"). The build: the checker's unit, the longest, takes 40.0 s at both heads (three builds of the
first, one of the final) against 36.6 to 36.9 s at base (four builds), since it now compiles Tier 1's modules for the
driver: the build is 3.1 s longer.

## Limitations

- The `--tier1` build is both tiers' code: Tier 1's share of the run's cycles is 56% (843 of 1,496 M), and its hottest
  function, `sqlite3VdbeExec`, is Tier 0's. The run time measures Tier 1's code where it compiles, not a Tier 1 build.
- The per-tier attribution is by sampled cycles of one run each, with functions classed by their instruction
  sequences; the static mix counts instructions, not their execution.
- Unwind tables and `-g` are off in the `--tier1` builds (the driver refuses them with it); the Tier 0 and clang builds
  have them.
- The local machine is Zen 4: its results are counts and correctness only.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
