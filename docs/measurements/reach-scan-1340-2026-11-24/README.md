# The warnings' reach scan behind an exact filter (buster14a/buster#1340, part 1), 2026-11-24

The default warnings' reach scan (`check_common_facts`: `check_common_own_reach` asked of every candidate the
operators' classes list) visits 78,304 nodes of the frozen `sqlite3.c` for 2,292 with a bit. The pull request puts a
filter ahead of the list that takes out the candidates whose bits can only be zero (`c_check_common_reach_filter.c`).
This is what it took on the 9700X to make that a saving at all, and how large the saving is: **about half a
millisecond of the 111.9 ms compile (−2.4 to −3.2 M user cycles of 548 M), not the 2 ms the plan hoped for.**

- Base: main `188cef8071a0b9be25249deb0811c29ecea372e4`. Head: `c2c31ec65bf7bcf8ce696451b449b41a32976614`
  (branch `claude/reach-scan-1340`, before its merge of main `5cd20eff`, `2bbb637e`, which no hold here timed).
- Host: the Ryzen 7 9700X (`benchpress`), every build and run under its lock, one hold each, owner
  `1340-reach-claude`. Builds as the 9700X job builds (`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config
  Release`).
- Protocol (`scripts/ab.sh`, after `compile-count-2850-2026-11-24/scripts/warn-facts.sh`): the frozen corpus's
  `sqlite3.c`, `--lanes 1 -c` with the four `SQLITE_*` defines, CPU 2, `perf stat -r 11`, three rounds (forward,
  reverse, forward) of every variant in one hold. Every run's exit status is 0, every object is byte-identical to
  base's and no compile prints a diagnostic (`9700x/ab-*/err-*.txt`, no `differs.txt`). `base-w` is base under `-w`,
  for scale: the default warnings are 11.4 to 11.9 ms.

## The result

`d ms` is each variant's task-clock less base's in the same round, the three rounds' mean; `d Mcyc` user cycles.
`scripts/reduce.py` makes each hold's `reduced.txt`.

| hold | variant | commit or patch | d ms | by round | d Mcyc | d Minst |
| --- | --- | --- | ---: | --- | ---: | ---: |
| `ab-first` | gathers, 16 nodes at a time | `6be0c21f` | +0.48 | +0.46 +0.50 +0.48 | +3.41 | −27.0 |
| `ab-first` | the same without the widths | `6be0c21f` + `stage1.diff` | +0.89 | +0.97 +0.85 +0.84 | +5.23 | −21.6 |
| `ab-third` | no gathers, 16 at a time | `38281e04` | +0.12 | +0.27 +0.16 −0.07 | +1.01 | −23.0 |
| `ab-third` | and rows prefetched a chunk at a time | `38281e04` + `chunk.patch` | −0.50 | −0.30 −0.47 −0.72 | −2.32 | −22.5 |
| `ab-fourth` | bytes, 64 at a time | `38281e04` + `bytes.patch` | −0.59 | −0.44 −0.70 −0.64 | −3.18 | −24.2 |
| `ab-sixth` | the same | | −0.55 | −0.51 −0.81 −0.34 | −3.09 | −24.2 |
| `ab-sixth` | and the constants' values, the rows a chunk behind | `38281e04` + `values.patch` | −0.42 | −0.51 −0.47 −0.29 | −2.16 | −25.2 |
| `ab-final-1` | bytes, as committed | `25733755` | −0.61 | −0.29 −0.92 −0.62 | −2.45 | −24.3 |
| `ab-final-2` | **head** | `c2c31ec6` | **−0.43** | −0.20 −0.48 −0.62 | **−2.93** | −24.4 |
| `ab-final-3` | **head** | `c2c31ec6` | **−0.58** | (−1.40) −0.09 −0.25 | **−2.39** | −24.4 |

**Against the merged base** (the delegating session's request: main `85a032f8` against the branch's head on it,
`011a75d2`, both rebuilt; main's default warnings cost about 14 ms now):

| hold | d ms | by round | d Mcyc | d Minst |
| --- | ---: | --- | ---: | ---: |
| `ab-merged-3` | **−0.81** | −0.86 −0.38 −1.18 | −4.86 | −24.4 |
| `ab-merged-4` | **−0.54** | −0.46 −0.62 −0.54 | −3.39 | −24.4 |
| `ab-merged-1` | −0.24 | −0.83 (+0.93) −0.81 | −3.16 | −24.4 |
| `ab-merged-2` | −0.92 | −0.70 (−2.45) (+0.40) | −4.13 | −24.4 |

(In `ab-merged-1` and `-2` three rounds have a disturbed side, 0.7 to 1.6% deviation, in brackets.) The compile's
count (`tools/ci/compile-count.sh check`) moves by −2.244%: 312,423,048 to 305,411,280.

(`ab-second`, `ab-fifth` and the first round of `ab-final-3` each have a base round that something disturbed, 0.6 to
1.7% deviation over its 11 runs against the usual 0.1%; they are kept, and not used above but for `ab-final-3`, whose
disturbed round is in brackets. A hold's `head` is the branch's head when it ran: the gather form in `ab-first`, the
no-gathers form in `ab-second`; `binaries.txt` has each binary's commit and hash. `ab-final-1` to `-3`
time the gather and no-gather forms again beside the head: +0.54 to +0.67 and −0.02 to +0.25.)

The head's undisturbed rounds are −0.20, −0.48, −0.62, −0.09 and −0.25 ms, and the same code's before its last
cleanup (`ab-fourth`, `ab-sixth`, `ab-final-1`) −0.29 to −0.92. Instructions fall by 24 M (1.9%) in every hold; cycles
by 2.4 to 3.2 M (0.5%).

## Why it is small

**The scan was about 2 ms, not 2.9.** By function (`scripts/prof.sh`: eight `perf record -c 20011` runs of each
binary, alternating; `9700x/prof-*/by-function-*.txt`, percent of the compile's user cycles), base's reach functions
(`check_common_own_reach`, `check_common_edges_reach`, `check_common_facts`, `check_common_truth_candidate`,
`check_common_next_reach_op`, `check_common_constant_changes`, `check_common_edge_wanted`) are 2.0 to 2.5% in four
profiles, 11 to 13.7 M cycles. The 2.92 ms of `compile-count-2850-2026-11-24`'s switch left the reach bits out too, and
with them what the root walk does where a root has reach.

**Its cost is cold cache lines, and a filter that reads the same lines pays for them.**

| form | the scan's list with the filter (`check_common_next_reach_op`) | the filter's tables | the visits and climbs left |
| --- | ---: | ---: | ---: |
| base (no filter; `prof-fourth`) | 0.15 | | 2.02 |
| gathers (`prof-first`) | 1.82 | 0.06 | 0.75 |
| no gathers, 16 at a time (`prof-second`) | 1.04 | 0.21 | 0.72 |
| rows prefetched a chunk at a time (`prof-third`) | 1.07 | 0.27 | 0.78 |
| bytes, 64 at a time (`prof-fourth`) | 0.95 | 0.32 | 0.96 |

(percent of the compile's user cycles; the columns' functions are in the files.)

- **Gathers.** The first form gathered each candidate's operands' traits, types and rows of conversions, 16 nodes at a
  time: of the order of 150,000 `vpgatherdd` a compile, 64 uops each on Zen 5 (`docs/coding-style.md`). 10 M cycles, as much as
  the scan it replaced.
- **Rows.** Without them the list still cost 5.7 M cycles: about 20,000 nodes with a constant, conditional, comma or
  selection operand each read their row of conversions (32 bytes a node, 10.8 MB, cold), which is the conversion
  edges' only necessary condition that the exact test's code gives. One or two were in flight at a time; asking for a
  chunk's rows before reading any took about 3 M cycles off.
- **Flat.** By line (`scripts/lines.sh`, a build with debug info; `9700x/lines-*/by-line.txt`) what is left of the
  filter, 1.1% of the compile, has no hot line: three sequential byte columns and a pass that makes them, the scan's
  own listing, and a few scalar loads for about one node in ten.
- **Visits.** The 7,700 visits left cost about 650 cycles each where base's 78,000 cost about 150: what they read is
  cold now.
- **Values.** Deciding the integer constants by their values (a zero index, a nonzero divisor, a constant below both
  types' sign bits) takes the visits from 7,704 to 5,393 and saves nothing (`values.patch`, −2.2 against −3.1 M
  cycles): the payload row a value is in is as cold for the filter as for the visit. Not in the pull request.
- **Layout.** Functions the change doesn't touch move by 0.1 to 0.7% of the compile between the binaries
  (`check_program_select_shared`, `check_input_asm_labels`, `parse_tree_columns` in the `prof-*` diffs), more than the
  saving. The by-function accounting above is the steadier reading; the wall is the verdict.

What would take the rest: the conversion edges' bit a node made where the checker writes the row (the issue's own
remark), so that neither the scan nor a filter reads 10.8 MB of rows to learn that no target is a floating type.

## Counts (`9700x/ab-*/audit-*.txt`, the audit's)

| | candidates | visited | with a bit | lost |
| --- | ---: | ---: | ---: | ---: |
| base | 78,304 | 78,304 | 2,292 | |
| first form without the widths | 78,304 | 15,931 | 2,292 | 0 |
| head | 78,304 | 7,704 | 2,292 | 0 |
| with the values (`values.patch`) | 78,304 | 5,393 | 2,292 | 0 |

(The record's counters patch, `experiment-facts-counts.patch`, is for `e347ec526`; the audit counts the same visits on
any build: `BUSTER_TEST_COMMON_REACH_AUDIT=/path` appends them a unit.)

## Soundness (`container/`, a cloud container: 4 CPUs of a Xeon, no timing)

- **Corpora** (`scripts/compare.sh`, `corpora-results.txt`, `corpora-audit.txt`): `sqlite3.c` and `shell.c`, Lua
  5.4.8's 34 units, c-testsuite's 220 programs and musl's 1,355 units with its build's options, 1,611 units, under
  seven option sets (default; `-Wall -Wextra`; those with `-Wsign-compare -Wdouble-promotion
  -Wimplicit-int-float-conversion -Wfloat-conversion`; `-Wfloat-conversion`; `-Wimplicit-float-conversion`;
  `-Wself-assign -Wsign-compare`; `-Wimplicit-float-conversion -Wno-implicit-int-float-conversion`). Base and head
  from the same directory: 11,277 pairs, every object byte-identical, every stderr, stdout and exit status the same.
  `-Wconversion` isn't in the sets: the compiler refuses it as not fully implemented.
- **The audit over them** (the head again with `BUSTER_TEST_COMMON_REACH_AUDIT`, which lists every candidate and fails
  the unit where one the filter took out has a bit): default, 353,480 candidates, 82,426 kept, 68,130 with a bit, 0
  lost; `-Wall -Wextra`, 165,147 kept, 151,377 with a bit, 0 lost; float precision alone, 269,115 candidates, 209,766
  kept, 51,289 with a bit, 0 lost; under `-Wdouble-promotion` or `-Wimplicit-int-float-conversion` the filter doesn't
  apply.
- **Generated trees** (`test-checker-driver --reach-filter-only`): 408 trees under each of 256 option sets, 2,207,120
  candidates in the 24,576 runs where the filter applies, 1,574,768 kept, 0 lost.
- **Fault round** (`patches/fault-round.patch`, made by `scripts/make-faults.py`: a switch that breaks one necessary
  condition at run time, not for merge; `scripts/run-faults.sh`): 77 faults. The generated test fails under 75
  (`fault-round-generated-test.tsv`). The other two, a const object's zero divisor (the address constant's trait and
  the divisor's), need the initializers' receipts, which a generated stream hasn't: under each the audit fails
  `tests/driver/warnings/default-warning/division-by-a-const-object-s-zero.c`, which the warning sweep compiles under
  the audit, and `tests/checker/division-by-zero/compound.c`. A first round on trees whose nodes drew their operands
  independently left 24 of 80 alive (`fault-round-first-audit-on-sources.tsv` has which of those the audit caught on
  the repository's test sources); the trees were given leaves and their families' shapes, and three conditions the
  round showed redundant were removed.

## Files

- `scripts/`: `setup.sh`, `build-one.sh`, `build-queue.sh`, `try.sh` (the 9700X trees and builds), `ab.sh`,
  `reduce.py`, `prof.sh`, `lines.sh` (the runs), `compare.sh`, `compare-unit.sh` (the corpora), `make-faults.py`,
  `run-faults.sh`, `audit-files.sh` (the fault round).
- `patches/`: `stage1.diff`, `chunk.patch`, `bytes.patch`, `values.patch` (the forms that were timed as patches on a
  commit), `fault-round.patch`.
- `9700x/ab-*`: each hold's `stat-*.csv`, `err-*.txt`, `audit-*.txt`, `binaries.txt`, `before.txt`, `after.txt`,
  `reduced.txt`. `9700x/prof-*`: `by-function-*.txt`. `9700x/lines-*`: `by-line.txt`.
- `container/`: the corpora's comparison and audit, the fault round's results.
