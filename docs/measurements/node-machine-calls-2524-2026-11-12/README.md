# Calls as a code of the node machine: #2524's step 1 (2026-11-12)

This record is for [buster#2575](https://github.com/buster14a/buster/pull/2575), on
[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1. #2575 adds calls to the node machine's three
sweeps (T, C and X) and has the shadow compare each call's row of the function's calls table. `docs/node-machine.md`'s
"Calls" section summarizes it.

Before this, a call was the first operator without a code in 12,836 of `sqlite3.c`'s 18,651 refused expressions
([the shadow's record](../node-machine-shadow-2524-2026-11-12/)).

Everything ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the lock, pinned to CPU 2, with the scripts in
`scripts/`. These are the earlier records' scripts, plus `extra.sh` (c-testsuite and `main.c`) and the run drivers.

## Sources and binaries

| label | buster commit | what |
| --- | --- | --- |
| `main` | [`0af27a3096f9bd96334f27943dfc50918f58bc17`](https://github.com/buster14a/buster/commit/0af27a3096f9bd96334f27943dfc50918f58bc17) | main, the baseline for the comparison's counts |
| `split` | [`27ee009a3959de4d2c533021b289e969eecf91a2`](https://github.com/buster14a/buster/commit/27ee009a3959de4d2c533021b289e969eecf91a2) | [buster#2571](https://github.com/buster14a/buster/pull/2571)'s head, the machine in one file a sweep; #2575's parent and the timing's baseline |
| `head` | [`4b0e3cb50e9a057795eca784a8b866672dc69a4d`](https://github.com/buster14a/buster/commit/4b0e3cb50e9a057795eca784a8b866672dc69a4d) | #2575: calls, on `split` |
| `calls-on-main` | [`04d5a76dd18e4100b74cc13e6440c5073c15b15f`](https://github.com/buster14a/buster/commit/04d5a76dd18e4100b74cc13e6440c5073c15b15f) | the same work on `main`, before #2575 was rebased onto the split; two of its runs, kept as they ran |

- **Builds:** each commit was checked out by its id in a worktree of a fresh clone and built by its `./build.sh`
  (Release), as `results/LABEL/build.log` shows.
- **Binary hashes:** `results/LABEL/compiler.sha256`. `head`'s executable is 42,936 bytes larger than `split`'s.
- **Host:** `results/env.txt` (Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, the performance governor).
- **Inputs' hashes:** `results/LABEL/corpora-inputs.txt`.

`main` has the same counts as `split`: #2571 changes no behavior, and its own record shows it.

## The comparison (`corpora.sh`, `extra.sh`)

`measure-node-machine --shadow --verify --passes 0` was run on four inputs:

- the frozen `sqlite3.c`;
- Lua 5.4.8's 34 sources;
- musl's 1,336 units, each without and with `-g`;
- c-testsuite's 220-program subset, at `5c727565`;
- `main.c` of `head`'s tree, with this host's `-march=native` predefines.

The figures are the machine-taken evaluated nodes, as shares of the census-taken ones:

| | `main` | `head` | calls compared | differences (values, entries, twin), `-g` too |
| --- | ---: | ---: | ---: | --- |
| `sqlite3.c` | 130,559 (50.19%) | 208,705 (80.23%) | 12,548 | 0, 0, 0 |
| Lua 5.4.8 | 25,073 (40.96%) | 44,848 (73.27%) | 3,708 | 0, 0, 0 |
| musl, 1,336 units | 56,144 (46.66%) | 82,535 (68.59%) | 4,596 | 0, 0, 0 |
| c-testsuite subset | 3,642 (63.67%) | 4,642 (81.15%) | 276 | 0, 0, 0 (no `-g` run) |
| `main.c` | 28,893 (24.55%) | 51,214 (43.52%) | 4,034 | 0, 0, 0 (no `-g` run) |

Every run exited 0. `verify-holds.txt` has each hold's owner line.

Each call is compared in three ways:

- its arguments' conversions, against the stream's;
- its `CALL`'s row, against the stream's by one base for the whole expression (the tape's rows are relative to the
  expression's first call);
- its row's contents, against Tier 0's calls table: the callee's symbol, the argument count, the argument classes and
  sizes, whether it is variadic, and no result object.

**The check of the check.** I made a local build with the rows numbered in postorder instead of the tasks' preorder.
On `sqlite3.c` it reported entry differences in 282 expressions, those with nested calls, and exited 1. That build isn't
kept, and the experiment didn't run on this host.

**What the machine still refuses** (`head`, `refused=` and `refused-at` lines):

- **`sqlite3.c`:** 19.19% of the census-taken nodes by code: `&&` 1,600, `||` 625, `?:` 588, the increments 2,173 and
  the compound assignments 1,422, by the expression's first such operator. A further 0.59% is refused by template, none
  of it a call.
- **Lua:** 21.67% by code and 5.05% by template. One expression is refused as `callee`: `ldo.c`'s `LUAI_TRY`, whose `setjmp` returns twice.
- **musl:** 25.22% by code and 5.90% by template. 59 of the template refusals are calls with a long double, struct or
  union argument or result, which the lowering doesn't pass as a plain call.
- **Calls T typed by the action:** 3 on `sqlite3.c`, 0 on Lua, 11 on musl. They are volatile arguments, which the rule
  leaves to the action.

`sqlite3.c`'s census on this host takes 51,448 expressions and 260,139 nodes. In the session's container it took 51,453
and 260,173, presumably by the host's predefines. Lua's and musl's counts are the same on both.

## The cost (`time.sh`, `profile.sh`)

Each figure is the least of 11 passes of one process, each sweep set timed on its own, in this thread's user-mode
counters, per taken evaluated node.

| `sqlite3.c` | nodes | T: cycles, instructions | T+C | T+C+X |
| --- | ---: | ---: | ---: | ---: |
| `split` | 130,559 | 95.9, 368.1 | 139.7, 557.1 | 171.0, 659.9 |
| `head` | 208,705 | 119.5, 455.3 | 167.6, 648.9 | 201.5, 749.9 |
| the 78,146 nodes calls add, at the margin | | 159.1, 601.0 | 214.1, 802.2 | 252.4, 900.1 |
| `split`, warm: the second of two runs (`--repeat 2`) | | 78.0, 365.1 | 117.9, 554.1 | 147.9, 656.9 |
| `head`, warm | | 99.7, 452.7 | 140.6, 646.3 | 161.8, 747.3 |

Lua: `split` 177.0 cycles and 828.5 instructions a node for all three sweeps; `head` 182.7 and 881.6, and 190.1 at the
margin.

- **The expressions calls bring in cost more a node than those taken before,** mostly in T: 159 cycles a node at the
  margin, against 96.
- **They have more records than evaluated nodes.** A direct call's callee is a record T types but no node the lowering
  evaluates: 1.23 records an evaluated node at the margin, against 1.09.
- **The profiles (`perf-symbols.txt`, 40 passes)** add two of T's costs for calls:
  - interning the callee's function-to-pointer type (`type_index_find` and `type_find_or_add`, 2.4% of the run where
    `split`'s don't show them);
  - the arguments' conversions (`check_action_convert_plain`, 3.6% against 1.9%).

  Each is a per-unit table's work: a function type's pointer, and a pair of types' conversion, as the design's memo
  has it.
- **Step 1's gate is 120 cycles a node.** This moves the sweeps further from it (201.5 against 171.0), and below the
  design's refutation threshold of 250. The levers already claimed on #2524 are the 28-byte records and the baked
  context and template tables. Those two caches are the calls' own.

## `-c` is unchanged (`ab.sh`)

`-c` of the frozen `sqlite3.c` with the 9700X job's options, by `split`'s and `head`'s compilers, in `time-runs`'
Williams order, 21 runs each after 2 warm-ups (`results/ab-split-head/time-runs.txt`):

| | wall, median (range) | user cycles, median | instructions |
| --- | ---: | ---: | ---: |
| `split` | 124.016 ms (123.558 to 124.801) | 601.950 M | 1,350,805,488 |
| `head` | 124.105 ms (123.630 to 124.855) | 602.671 M | 1,350,802,286 |

That is +0.07% wall time with the same instructions. The machine runs only under `measure-node-machine --shadow`.

## Incidents

- **The disk filled.** During `run2.sh`, benchpress's `/home` reached 100% (475 GB, mostly other sessions' trees). That
  emptied `head`'s timing files, the A/B's files and the c-testsuite clone, and made `main.c`'s predefines empty. They
  are in `results/failed-disk-full`. I then removed this record's own build trees (4.4 GB) and ran those steps again
  (`run3.sh`); the results above are the second runs.
- **Stopped runs.** `run.sh` measured `calls-on-main` until the split appeared. It was stopped after two comparisons
  (`results/calls-on-main`), and the work was rebased onto the split and measured as `head`. Its two runs have the
  same counts as `head`'s.
- **Waiting messages.** The lock's messages naming other sessions' holds were removed from the logs (the
  `exclusive.sh: waiting` lines and their title and link lines).

## Limits

- **One process a figure.** Placement moves the sweeps' cycles by about 3% (the earlier records). The instructions
  are exact.
- **The margin isn't a set of calls.** It is the nodes of the expressions calls let the machine take, whatever their
  operators.
- **The check of the check ran in the session's container,** not here. Its build was a temporary one and isn't kept.
