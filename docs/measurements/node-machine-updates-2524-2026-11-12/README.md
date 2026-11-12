# The node machine's increments and compound assignments: #2524, step 1's coverage (2026-11-12)

This is the record of [buster#2577](https://github.com/buster14a/buster/pull/2577), part of
[buster#2524](https://github.com/buster14a/buster/issues/2524).

The PR gives the node machine (`src/buster/compiler/c_check_node_machine.c`) its codes for `++x`, `--x`, `x++`, `x--`
and the ten compound assignments. Before it, the machine refused them by code. `docs/node-machine.md`'s "Increments and
compound assignments" summarizes the result.

The shadow (`measure-node-machine --shadow`, `c_check_node_census.c`) runs the machine after the pipeline on every
expression the census takes. For each expression the machine takes, it compares two things:
- every record with the stream's node;
- the tape with the lowering's entries.

It also times the three sweeps, T, C and X.

Everything here ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the 9700X's lock (`scripts/lock.sh`
wraps `~/buster-fast-bench/exclusive.sh`), pinned to CPU 2.

## Sources and binaries

- **The measured commits,** before the merge below, are on main [`0af27a30`](https://github.com/buster14a/buster/commit/0af27a3096f9bd96334f27943dfc50918f58bc17):
  - [`ec743d0d8dd7e2b3c52c15582360f7d1a6fe19d0`](https://github.com/buster14a/buster/commit/ec743d0d8dd7e2b3c52c15582360f7d1a6fe19d0),
    the codes;
  - [`6196395c738d55cd6baef7e6ea46cbe386f9eeb7`](https://github.com/buster14a/buster/commit/6196395c738d55cd6baef7e6ea46cbe386f9eeb7),
    which keeps them out of the sweeps' loops.

  `scripts/commit.sh` fetched the PR's branch and checked each commit out by its id on the host. It ran after
  `git checkout -- . && git clean -fd`, with no local change left (`results/SHA/checkout.txt`), and built it
  (`logs/build-SHA.log`).
- **Main** is `0af27a30` itself, built in a worktree of the same clone (`logs/build-main.log`).
- **The series `v1` to `v6`** is the PR's working tree as it was built up. They were not commits: each is
  `diffs/updates-LABEL.diff` applied to main `0af27a30`. In order:
  - `v1`: the codes, with T typing every update by the action;
  - `v2`: T's rule for an arithmetic destination;
  - `v3`: T's rule for a pointer;
  - `v4`: the updates' functions out of line;
  - `v5`: `node_machine_convert` inlined again. `ec743d0d` is `v5` and one comment.
  - `v6`: the update rule last in C, X's loop with main's one compare, and the tape sized for every row it can keep.
    `6196395c` is `v6`'s code, and its compiler is `v6`'s byte for byte.
- **`v5-off` and `v6-off`** are `v5` and `v6` with the update codes refused again (`node_machine_code`), so the machine
  takes main's expressions. Their timing against main's is what the new code costs the expressions main already takes.
- **The compilers' hashes** are in `results/compilers.txt`. The compilers of `v1` to `v4` were deleted from the host
  after their runs; their hashes were taken first.
- **The environment** (`results/env.txt`):
  - Linux 6.18.50-2-lts, AMD Ryzen 7 9700X, the performance governor on CPU 2;
  - clang 23.1.1, perf 7.2.9-1.
- **The inputs:**
  - the frozen corpus's `sqlite3.c` with the 9700X job's `compile_time` options;
  - Lua 5.4.8's 34 sources;
  - musl's 1,336 units, the first source of each base name, with the census record's options.

  Their hashes are in `results/LABEL/corpora-inputs.txt`. The Lua sources' path is another session's folder of inputs,
  as in the step's earlier records.

## Commands

The scripts are the step's earlier records' (`corpora.sh`, `time.sh`, `profile.sh`), with these around them:

- `scripts/build-tree.sh TREE LABEL` builds a tree in one hold and keeps its compiler.
- `scripts/apply.sh DIFF` resets `src` to main `0af27a30` by its id and applies a diff.
- `scripts/series.sh`, `scripts/timing-only.sh` and `scripts/run-all.sh` chain the steps. `scripts/commit.sh` does the
  same for a pushed commit.

What each step measures:

- **The comparison** (`scripts/corpora.sh LABEL`) runs `measure-node-machine --shadow --verify --passes 0` on the three
  corpora, each without and with `-g`, one hold a run (`results/LABEL/verify-*.txt`). Each hold's owner line is in
  `verify-holds.txt`. `--verify` types every node that a row or a direct rule types by the action too, and counts the
  nodes where the two differ (`twin`).
- **The timing** (`scripts/time.sh LABEL`) runs `measure-node-machine --shadow --passes 11` on `sqlite3.c` and on Lua's
  sources in one hold (`results/LABEL/sqlite3.txt` and `lua.txt`). A pass is each sweep set (T; T and C; T, C and X)
  over every taken expression of a file. For each set, the least cycles and instructions over the 11 passes are kept and
  divided by the taken evaluated nodes. The counters are this thread's user-mode ones. C's and X's own costs are the
  differences of the sets.
- **The profile** (`scripts/profile.sh LABEL`) is `perf record -c 200003 -e cycles:u` of 40 timing passes on
  `sqlite3.c`. `results/LABEL/perf-symbols.txt` holds the report by symbol; `perf.data` isn't kept.

The build logs keep only the lines the builds printed. The lock's messages, which name other sessions' holds, were
removed.

## What the machine takes, at `6196395c`

The same at `ec743d0d` and every label from `v1` on. Main's figures are `results/main/verify-*.txt`.

| | `sqlite3.c` | Lua 5.4.8 | musl, 1,336 units |
| --- | ---: | ---: | ---: |
| census-taken evaluated nodes | 260,139 | 61,207 | 120,332 |
| machine-taken evaluated nodes, main | 130,559 (50.19%) | 25,073 (40.96%) | 56,144 (46.66%) |
| machine-taken evaluated nodes, `6196395c` | **145,386 (55.89%)** | **27,971 (45.70%)** | **65,409 (54.36%)** |
| machine-taken expressions, main and `6196395c` | 63.51%, 70.17% | 51.77%, 58.57% | 58.55%, 68.45% |
| entries compared | 199,540 | 34,955 | 87,335 |
| differences: values, entries, twin; with `-g` | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 |

- **What still stops the machine by code** is calls, `&&`, `||` and `?:`. On `sqlite3.c` the first operator without a
  code is a call in 12,856 of the 15,214 expressions refused by code. At main, `x++` came second (1,683) and `+=` and
  `|=` among the next.
- **T's rules type almost every update.** Two of `sqlite3.c`'s update nodes go to the action, and none of Lua's. musl
  has 174 (`action-typed op=` in `verify-*.txt`): updates whose type or lvalue the rules don't take. The rows have no
  `long double`, and a volatile destination is the action's.
- **The template refusals grow a little:**
  - musl: 859 to 1,016 expressions. 100 of them stop at an update the plan refuses (the `refused-at` lines for `x++`,
    `x--`, `+=`, `-=`, `*=` and `/=`). The rest are the templates' existing refusals inside the newly reached
    expressions, unsigned divisions by powers of two among them.
  - `sqlite3.c`: 121 to 133.
- **The row refusals are main's,** musl's 19. No update is refused for its rows' width.

## The sweeps' cost

A taken evaluated node on `sqlite3.c`, in cycles and instructions (`results/LABEL/sqlite3.txt`), with Lua's total
(`lua.txt`):

| label | T | C | X | T, C and X | taken nodes | Lua, T, C and X |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main | 95.0, 368.1 | 42.2, 189.0 | 32.6, 112.8 | 169.8, 669.9 | 130,559 | 177.4, 838.6 |
| `v1` | 102.3, 399.2 | 47.5, 203.5 | 40.4, 130.4 | 190.2, 733.1 | 145,386 | 200.0, 904.0 |
| `v2` | 98.4, 379.4 | 48.1, 203.4 | 41.7, 130.4 | 188.2, 713.2 | 145,386 | 197.4, 890.6 |
| `v3` | 96.6, 378.2 | 46.5, 203.4 | 41.0, 130.5 | 184.1, 712.1 | 145,386 | 194.1, 883.7 |
| `v4` | 104.1, 378.2 | 47.4, 199.8 | 40.8, 130.8 | 192.3, 708.8 | 145,386 | 192.3, 880.4 |
| `v5` | 97.1, 378.2 | 45.9, 199.8 | 33.9, 119.9 | 176.9, 697.9 | 145,386 | 186.0, 869.9 |
| `ec743d0d`, three runs | 96.6 to 99.3, 378.2 | 45.8 to 49.3, 199.8 | 34.3 to 34.8, 119.9 | 177.0 to 183.4, 697.9 | 145,386 | 187.1 to 189.5, 869.9 |
| `v6` | 97.2, 378.2 | 45.4, 196.6 | 30.8, 115.6 | 173.4, 690.4 | 145,386 | 187.2, 861.0 |
| `6196395c` | 98.5, 378.2 | 50.6, 196.6 | 29.8, 115.6 | 178.9, 690.4 | 145,386 | 186.1, 861.0 |
| `v5-off`, main's expressions | 94.7, 368.3 | 43.5, 194.0 | 31.6, 117.4 | 169.8, 679.7 | 130,559 | 179.6, 849.6 |
| `v6-off`, main's expressions | 96.4, 368.3 | 45.2, 189.5 | 27.2, 111.4 | 168.8, 669.2 | 130,559 | 174.4, 837.6 |

- **T's rules.** With every update typed by the action (`v1`), T ran 399.2 instructions a node. The arithmetic rule cut
  that to 379.4 (`v2`), and the pointer rule to 378.2 (`v3`).
- **What the code costs main's expressions.** At `v5` it was 9.8 instructions a node (`v5-off`, 679.7 against 669.9):
  - C tested the update range before most of its rules;
  - X tested every record for the tape's room and for a split, and stored where it stopped.

  `v6` removes them, and `v6-off` runs 669.2. Separately, `v3` and `v4` had lost X's inlined conversion, a call of its
  own at every node (11 instructions a node, `v4` to `v5`).
- **What the new expressions cost.** At `6196395c` the sweeps run 690.4 instructions a node against main's 669.9, on
  11% more nodes.
  - X runs 87.4 instructions an entry against main's 88.4. Its rise a node is the new expressions' entries: 1.37 a node
    against 1.28.
  - C runs 196.6 against 189.0, and T 378.2 against 368.1.
- **Cycles move without the instructions.** The same binary measured 177.0 to 183.4 cycles a node in three processes
  (`ec743d0d` and its two repeats), and `v6` and `6196395c`, one binary, 173.4 and 178.9. `v3` and `v4`'s T ran the same
  instructions at 96.6 and 104.1 cycles. Compare the labels by their instructions.

The step's cost gate, 120 cycles a node, is where the earlier records left it. This PR adds coverage.

## After the merge with the logical operators

While the PR was open, main gained the machine's `&&`, `||` and `?:` (buster#2569), whose entries before and between
operands are segments after an operand's row, as an update's first row is. The PR merged main into its branch:
- [`e02cecd72d2843024ae203b39a7f0c1fc0bf098e`](https://github.com/buster14a/buster/commit/e02cecd72d2843024ae203b39a7f0c1fc0bf098e)
  is the merge;
- [`58ca4ea76cdccd950dd9cd40a27ae239d8620752`](https://github.com/buster14a/buster/commit/58ca4ea76cdccd950dd9cd40a27ae239d8620752)
  keeps `node_machine_put_truth` inlined, as main has it.

Their baseline is main [`f2faf255`](https://github.com/buster14a/buster/commit/f2faf255e64c2551d63b55bf08039da59e31336a),
built in the main worktree by `scripts/main-at.sh` (`results/main-f2faf255`). `scripts/off-at.sh` builds a commit with
the update codes refused (`diffs/updates-SHA-off.diff`).

| | `sqlite3.c` | Lua 5.4.8 | musl, 1,336 units |
| --- | ---: | ---: | ---: |
| machine-taken evaluated nodes, main `f2faf255` | 154,280 (59.31%) | 29,595 (48.35%) | 65,775 (54.66%) |
| machine-taken evaluated nodes, `58ca4ea7` | **169,496 (65.16%)** | **32,547 (53.18%)** | **75,541 (62.78%)** |
| machine-taken expressions, main and `58ca4ea7` | 67.62%, 74.34% | 54.59%, 61.45% | 62.60%, 72.68% |
| entries compared | 249,280 | 42,862 | 107,086 |
| differences: values, entries, twin; with `-g` | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 |

The machine now refuses by code only calls: they are every one of `sqlite3.c`'s 13,069 expressions refused by code,
Lua's 3,885 and musl's 5,141. `e02cecd7` measured the same counts and no difference (`results/e02cecd7/verify-*.txt`).

| label | T | C | X | T, C and X | taken nodes | Lua, T, C and X |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main `f2faf255` | 98.1, 371.5 | 53.5, 203.8 | 40.8, 120.0 | 192.4, 695.3 | 154,280 | 188.1, 873.3 |
| `e02cecd7` | 97.4, 380.1 | 53.8, 210.6 | 36.1, 124.0 | 187.3, 714.7 | 169,496 | 190.6, 894.9 |
| `58ca4ea7` | 99.3, 380.1 | 55.0, 210.6 | 36.8, 124.1 | 191.1, 714.8 | 169,496 | 189.1, 894.9 |
| `e02cecd7-off`, main's expressions | 94.9, 370.8 | 50.4, 204.4 | 33.9, 120.5 | 179.2, 695.7 | 154,280 | 183.5, 874.5 |
| `58ca4ea7-off`, main's expressions | 96.7, 370.8 | 50.3, 204.4 | 32.8, 120.5 | 179.8, 695.7 | 154,280 | 188.7, 874.5 |

- **What the code costs main's expressions:** 0.4 instructions a node (695.7 against 695.3).
- **What the new expressions cost:** 714.8 instructions a node against 695.3, on 9.9% more nodes.
- **The inlining of `node_machine_put_truth`** changed no instruction count (714.7 and 714.8). It restores main's set of
  out-of-line functions: `nm` of `58ca4ea7`'s compiler lists main's and the updates' own.

## After the second merge: the split files and calls

Main then gained the machine's split into one file a sweep with record accessors (buster#2571) and calls (buster#2575).
[`5200426ee7718ea5f470295ca151d857c1c42fdd`](https://github.com/buster14a/buster/commit/5200426ee7718ea5f470295ca151d857c1c42fdd)
merges it, with the updates moved onto the split files. Its baseline is main
[`5f75ea52`](https://github.com/buster14a/buster/commit/5f75ea52846e96d717ffcbf3d3e05c276d197783) (`results/main-5f75ea52`).

| | `sqlite3.c` | Lua 5.4.8 | musl, 1,336 units |
| --- | ---: | ---: | ---: |
| machine-taken evaluated nodes, main `5f75ea52` | 242,002 (93.03%) | 53,385 (87.22%) | 98,763 (82.08%) |
| machine-taken evaluated nodes, `5200426e` | **258,466 (99.36%)** | **57,954 (94.69%)** | **110,248 (91.62%)** |
| machine-taken expressions, main and `5200426e` | 92.69%, 99.69% | 88.88%, 96.57% | 83.17%, 93.86% |
| refused by code, main and `5200426e` | 3,616, 0 | 837, 0 | 2,630, 0 |
| entries compared | 353,246 | 70,723 | 149,651 |
| calls compared | 13,473 | 4,064 | 5,357 |
| differences: values, entries, twin; with `-g` | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 |

- **Nothing is refused by code any more.** What is left is templates: on `sqlite3.c` 159 expressions, among them the
  pointer differences and unsigned divisions by powers of two. Lua refuses one call as `callee`.
- **`main.c` and c-testsuite**, run locally (`measure-node-machine --shadow --verify`, not on the 9700X): 98.38% and
  99.79% of their census-taken nodes are taken, with no difference, `-g` included.

| label | T | C | X | T, C and X | taken nodes | Lua, T, C and X |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main `5f75ea52` | 120.0, 446.7 | 59.9, 204.4 | 39.5, 113.0 | 219.4, 764.1 | 242,002 | 201.7, 909.2 |
| `5200426e` | 121.1, 453.3 | 56.6, 208.9 | 40.1, 117.3 | 217.8, 779.5 | 258,466 | 201.2, 924.5 |
| `5200426e-off`, main's expressions | 120.2, 447.0 | 54.6, 204.9 | 37.2, 115.0 | 212.0, 766.9 | 242,002 | 196.1, 912.6 |

- **What the code costs main's expressions:** 2.8 instructions a node (766.9 against 764.1), most of it X's (2.0):
  - the test for an update's destination after each evaluated record's row;
  - the test for a destination read by name at each record that isn't evaluated.

  Folding both under the one test of whether a state has more than `EVALUATED` would leave main's count of tests.
- **What the new expressions cost:** 779.5 instructions a node against 764.1, on 6.8% more nodes.
- **Out-of-line functions:** `nm` of `5200426e`'s compiler lists main's and the updates' own.

## Mishaps, and what was kept of them

- **The host's `/home` filled up** at 18:22 UTC. `v5-off`'s first build failed ("No space left on device"), and
  `build-tree.sh` then copied the previous build's compiler, `v5`'s, under `v5-off`. That run's files are not here. This
  session deleted its own disposable files (four compilers, main's build tree), and `v5-off` was built and timed again.
  `build-tree.sh` now stops where a build fails.
- **`v6`'s first run** applied its diff to `src` while `commit.sh` had left `src` at `ec743d0d`, so the diff didn't
  apply and the build was `ec743d0d`'s (the same compiler hash). Those runs are kept as `ec743d0d-repeat1` and `-repeat2`
  (`NOTE.txt`). `apply.sh` now resets `src` to main first and stops where a diff doesn't apply, and `v6` and `v6-off`
  ran again.
- **`v2`'s build log** was overwritten by a second run of `v2` that was stopped while it waited for the lock
  (`results/v2/build-note.txt`). The compiler and the runs are the first's.

## Limits

- **One process a figure,** the least of 11 passes. Cycles move by up to about 4% between processes on the same
  instructions (above).
- **Main ran once.** Its 169.8 cycles is one process, so the cycles' differences to it are within that spread. The
  instructions are exact.
- **The sweeps run in the shadow's position,** after the pipeline, not in the reader's, as step 2 would run them.
