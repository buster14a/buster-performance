# The node machine's `&&`, `||` and `?:`: #2524's step 1 (2026-11-12)

This is the record for [buster#2569](https://github.com/buster14a/buster/pull/2569), part of
[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1, the shadow. Before it, the node machine refused
`&&`, `||` and `?:` by code. Their entries come before and between their operands' (branches and labels), and X wrote
each record's row after its operands. Now:

- **C** classifies them by the lowering's `check_lower_logical` rules.
- **X** writes their tests, branches and jumps as a segment after an operand's row.
- **Labels** are numbered from the expression's first, in the order the tasks number them.
- **The shadow** compares each label with the lowering's, by its number counted from the expression's first and by its
  entry. The inventory's log keeps each pop's next label and each body's labels' entries for this.

`docs/node-machine.md`'s "The logical operators and the conditional" section summarizes the results.

Everything ran on the Ryzen 7 9700X (`benchpress`) with the scripts in `scripts/`. Each run was in a hold of the lock of
its own, pinned to CPU 2. The scripts are the step 1 records' (`node-machine-shadow-2524-2026-11-12`,
`node-machine-shadow-cost-2524-2026-11-12`) with this task's lock identity, plus `run.sh` and `run2.sh`, which ran them in
order.

## Sources and binaries

- **Main, the base:** buster
  [`0af27a3096f9bd96334f27943dfc50918f58bc17`](https://github.com/buster14a/buster/commit/0af27a3096f9bd96334f27943dfc50918f58bc17),
  a worktree of the host's checkout (`results/main`).
- **[`48abdd08`](https://github.com/buster14a/buster/commit/48abdd085e11b60fa27aafe3e2dc7ec7840d515e)** (`results/48abdd08`):
  the three operators as codes, T typing them by the action, the labels numbered by a preorder walk of the records.
- **[`cadbbe12`](https://github.com/buster14a/buster/commit/cadbbe127eadcb98c816ea6aac53bc7517b21fcd)** (`results/cadbbe12`):
  `&&` and `||` typed by a rule of `check_action_logic`'s steps, and the labels numbered from the labeled records alone.
  This is the PR's machine: its later commits change only the documents, and one change measured as `v4` and reverted.
- **`53f52dcb`**, the rule alone, was built but its runs were stopped for `cadbbe12`: it has no results here.
- **`v4`** (`results/v4`): `cadbbe12` with `v4.patch` applied in a separate worktree. The patch always inlines
  `node_machine_evaluate` and keeps the logical operators' rule, classification and numbering out of line. Its
  `commit.txt` names `cadbbe12`, the worktree's commit under the patch.
- **Builds and hashes:** each was built with the tree's `./build.sh` (Release, as `logs/build-*.log` show). Each
  `results/*/commit.txt` holds the commit and its compiler's SHA-256.
- **Host:** `results/env.txt` (Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, the performance governor).
- **Inputs:** the frozen corpora under `/var/lib/buster-9700x/corpora/preprocessor-391e729af658` and Lua 5.4.8's 34
  sources. Their hashes are in each `corpora-inputs.txt`; musl's options and 1,336 files are in `musl-options.txt` and
  `musl-files.txt`.

## The comparison (`corpora.sh`)

`measure-node-machine --shadow --verify --passes 0` checks every taken expression:
- each record's value, conversions and member offset against the stream's;
- its tape against the lowering's entries;
- each branch's label and each label's entry against the lowering's.

It runs without and with `-g`.

| `--verify` | `sqlite3.c` | Lua 5.4.8, 34 files | musl, 1,336 units |
| --- | ---: | ---: | ---: |
| census-taken evaluated nodes | 260,139 | 61,207 | 120,332 |
| machine-taken: main | 130,559 (50.19%) | 25,073 (40.96%) | 56,144 (46.66%) |
| machine-taken: `48abdd08` and `cadbbe12` | 154,280 (59.31%) | 29,595 (48.35%) | 65,775 (54.66%) |
| refused by code: main, `cadbbe12` | 49.34%, 40.21% | 55.90%, 48.36% | 48.45%, 39.65% |
| labels compared, in taken expressions | 5,438 in 2,100 | 806 in 302 | 2,300 in 924 |
| differences: values, entries, twin; with `-g` | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 |

Every run exited 0 (`status 0` at the end of each `verify-*.txt`). Each hold's owner line is in `verify-holds.txt`.

- **Refusals:** no `&&` or `||` is refused by its template on any corpus, and no `?:` on `sqlite3.c` or Lua. musl has 17
  expressions refused at a `?:` by its template (`refused-at op=?:`). The machine leaves two kinds of conditional to the
  tasks, `a ?: b` and one of a class past F64 (long double's); this record doesn't say which those 17 are.
- **What code refusal leaves:** in 13,048 of `sqlite3.c`'s 16,538 code-refused expressions, the first operator without a
  code is a call. The increments and compound assignments are the rest (`refused-at` lines).
- **The label check isn't vacuous.** Numbering the labels from 1 instead of 0 made every labeled expression of a local
  test file differ. That check ran on the session's own machine, not here.

## The sweeps' cost (`time.sh`, `profile.sh`)

`--passes 11`: each sweep set is timed on its own, and its least of 11 passes is taken. The table gives cycles a taken
evaluated node.

| `sqlite3.c` | T | C | X | all three | instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| main | 95.5 | 42.7 | 32.9 | 171.1 | 669.9 |
| `48abdd08` | 96.2 | 55.3 | 38.0 | 189.5 | 702.9 |
| `cadbbe12` | 97.2 | 52.1 | 38.9 | 188.2 | 695.3 |
| `v4` | 96.4 | 53.3 | 36.9 | 186.6 | 692.5 |

Lua's, all three: main 180.6, `48abdd08` 195.7, `cadbbe12` 190.4, `v4` 187.9.

- **The average rises because of the expressions newly taken.** From the totals of main and `cadbbe12`, the 23,721 newly
  taken nodes of `sqlite3.c` cost 282 cycles each (T 107, C 103, X 72), against 171 for those taken before. They also
  write 2.06 entries a node against 1.28: their tests, branches and jumps.
- **Two attempts moved it by no more than placement's 3%:**
  - `cadbbe12`'s numbering from the labeled records, against `48abdd08`'s walk of every record: C went from 55.3 to 52.1.
  - `v4`'s inlining: 186.6 in all, C 53.3. It was reverted in buster#2569.
- **The profiles** (`perf-symbols.txt`, `perf-contexts.txt` for the C sweep, 40 passes) show:
  - `cadbbe12`'s build left `node_machine_evaluate` out of line: 227 of C's 3,024 samples, against main's 32. `v4` brings
    it back inline, with no change in the timed figures.
  - C's most sampled instruction is still its branch on whether a record is evaluated, as in the step 1 records.

## `-c` (`ab.sh`)

`time-runs` ran `-c` of the frozen `sqlite3.c` (the 9700X job's `compile_time` options): main against `cadbbe12`, 21 runs
each after 2 warm-ups, in Williams order, in one hold.

| | wall, median (range) | user cycles | instructions |
| --- | ---: | ---: | ---: |
| main | 123.923 ms (123.125 to 124.650) | 600.790 M | 1,350,805,484 |
| `cadbbe12` | 123.978 ms (122.829 to 124.532) | 600.932 M | 1,350,810,807 |

They are the same: +0.04% wall, +0.02% user cycles. The 5,323 more instructions are the inventory's log's test, once a
body; the machine runs only under `measure-node-machine --shadow`.

The lock's messages naming other sessions' holds were removed from the build logs (the `exclusive.sh: waiting` lines).

## Limits

- **One process a figure.** Each sweep figure is the least of 11 passes of one process, and placement moves it by about
  3%.
- **The newly taken nodes' cost is a difference of two builds' totals.** Each build has its own placement.
- **The sweeps run in the shadow's position,** after the pipeline, as in the step 1 records.
