# The node machine's T without its rules, and what a first run costs (#2524's step 1, 2026-11-14)

This record is for [buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1. It covers two things:

- **T's loop without its rules.** T's rules become one `switch` case per operator, out of T's loop, and T's loop reads the
  expression's range from its own arguments.
- **What a first run of an expression costs.** The sweeps were measured set by set, with and without `--repeat 2`.

`docs/node-machine.md`'s section "T's loop without its rules, and what a first run costs" summarizes it.

## Summary

- **The change cuts T's instructions.** T runs 14 fewer a node (350.9 to 336.8 on `sqlite3.c`), with the same machine
  results.
- **Its cycles move by less than a copy of the executable does.** The exploration's build and the commit's have
  byte-identical `.text`, yet the three sweeps ran at 169.4 and 172.9 cycles a node. Fresh copies of the commit's file
  ran 169.9 to 172.8.
- **Over four copies of each, at the median:**
  - on `sqlite3.c`, the three sweeps went from 173.3 to 172.1 cycles a node;
  - on Lua, from 148.4 to 146.2;
  - T on Lua was 1.2 cycles faster at every copy.
- **The larger finding: a first run of an expression costs about 45 cycles a node more than an immediate second run.**
  On `sqlite3.c`, the three sweeps cost 168.2 cycles a node on a first run and 123.5 on a second, on the same 570
  instructions. The second run misses the instruction cache 6.4 times against 14.2, and the op cache 9.1 times against
  22.6. The gate's 120 is about what a warm run costs now.

## How it was measured

Everything timed ran on the Ryzen 7 9700X (`benchpress`). Each run had its own hold of the lock and was pinned to CPU 2,
with the scripts in `scripts/`.

- **Shared scripts:** `time.sh`, `corpora.sh`, `ab.sh`, `medians.py`, `sweeps.py` and `lock.sh` are
  [the C and X record](../node-machine-dispatch-2524-2026-11-14/)'s. That includes its own Lua 5.4.8 sources.
- **Taken from the front-end record:** `explore-only.sh` and `patches/only.patch` come from
  [the front-end record](../node-machine-front-end-2524-2026-11-13/).
- **New in this record:**
  - `build-shifts.sh`;
  - `explore-repeat.sh`;
  - `annotate-t.sh`, T's functions' samples by source line;
  - `counts.py`, which turns `explore-only.sh`'s and `explore-repeat.sh`'s counts into per-node figures.
- **Build fix:** `build-inc.sh` here resets its worktree before checking out the base. The earlier record's version
  refused to switch bases with a patch still applied.

## Versions

| label | what | source |
| --- | --- | --- |
| `m2` | main | [`c471f32f`](https://github.com/buster14a/buster/commit/c471f32f0136bbb21cfe083c9947f86346de2a0a) |
| `t1` | `node_machine_rule` as a `switch`, plus the counters out of T's loop. Clang left it out of line with the rules inlined into it | `patches/t1.patch` on `m2` |
| `t2` | `t1` plus T's range (first node, root, count) from its arguments | `patches/t2.patch` on `m2` |
| `t2b` | T's range from its arguments alone, on main's shape | `patches/t2b.patch` on `m2` |
| **`pr2`** | the pull request's code: `t2`, with `node_machine_rule` marked `noinline` and its comment | [`dcdb045e`](https://github.com/buster14a/buster/commit/dcdb045e04d33a89c6a05ea1701191bec0ce0291) |
| `m2-sN`, `t2-sN` | `m2` and `t2` with N bytes of padding before the checker unit's code (`./build.sh shifts`), N = 0, 1,024, 2,112, 3,136 | `build-shifts.sh` |
| `m2-cN`, `pr2-cN` | fresh copies (`cp`) of `m2`'s and `pr2`'s executables, N = 1 to 3 | byte-identical to their originals |

How each version was built:
- `m2` and `pr2` were built in fresh worktrees (`build-label.sh`).
- `t1`, `t2` and `t2b` were built incrementally in one worktree (`build-inc.sh`).
- The shifted versions were built by `build-shifts.sh`.
- Every build used `--config Release`.

Each version's files:
- `results/LABEL/build.log`: the build's log, with the lock's waiting lines removed.
- `results/LABEL/compiler.sha256`: the executable's hash.
- `results/LABEL/revision.txt`: the source revision and the patch's hash.
- `results/LABEL/nm-node-machine.txt`: the node machine's functions and their sizes.

`t2`'s and `pr2`'s executables have the same `.text`, byte for byte, and every symbol at the same address (`objcopy` and
`nm -n`, compared on the host).

## The final comparison (`time.sh`, rounds `g1` to `g6`; `results/sweeps-g.txt`)

`m2` and `pr2` in turn, six rounds, in cycles and instructions a taken evaluated node, medians. C and X are differences of
the sets' medians.

| | T | C | X | three (range) |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c`, `m2` | 90.3, 350.9 | 47.2, 169.3 | 35.7, 78.7 | 173.2, 598.9 (172.8-173.5) |
| `sqlite3.c`, `pr2` | 90.0, 336.8 | 45.4, 169.3 | 37.4, 78.7 | 172.9, 584.8 (172.3-173.8) |
| Lua, `m2` | 84.3, 444.5 | 39.4, 171.3 | 25.0, 76.0 | 148.7, 691.8 |
| Lua, `pr2` | 83.0, 427.4 | 38.8, 171.3 | 27.2, 76.0 | 149.0, 674.7 |

With `--repeat 2`, the three sweeps ran 289.1 against 295.4 on `sqlite3.c`, and 271.1 against 278.1 on Lua.

## Copies of one executable (`results/LABEL-cN/`, rounds `f1`)

One run each of three fresh copies per side, beside the final comparison's medians (`results/sweeps-f.txt`). The three
sweeps, in cycles a taken node:

| | original (six runs) | copy 1 | copy 2 | copy 3 | median of the four |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c`, `m2` | 173.2 | 173.7 | 173.3 | 173.2 | 173.3 |
| `sqlite3.c`, `pr2` | 172.9 | 169.9 | 172.8 | 171.3 | 172.1 |
| Lua, `m2` | 148.7 | 148.7 | 147.6 | 148.1 | 148.4 |
| Lua, `pr2` | 149.0 | 145.3 | 146.7 | 145.6 | 146.2 |

T's medians over the four copies: 90.6 against 90.4 on `sqlite3.c`, and 83.9 against 82.7 on Lua. `pr2`'s spread is
mostly X's: 34.3 to 37.4 on `sqlite3.c`.

## The exploration and the placements (`results/sweeps-f.txt`)

**The variants**, on `sqlite3.c`. `m2`'s figures are medians of 7 runs; the variants' of 3, or 6 for `t2`.

| version | T | C | X | three |
| --- | ---: | ---: | ---: | ---: |
| `m2` | 90.1, 350.9 | 47.8, 169.3 | 35.5, 78.7 | 173.4, 598.9 |
| `t1` | 91.6, 350.7 | 46.0, 169.3 | 35.6, 78.7 | 173.2, 598.7 |
| `t2` | 90.2, 336.8 | 44.8, 169.3 | 34.5, 78.7 | 169.5, 584.8 |
| `t2b` | 103.6, 344.4 | 47.2, 169.4 | 33.6, 78.6 | 184.4, 592.4 |

`t2b` changes the size of `node_machine_type` alone, from 11,759 bytes to 12,579. No function's inlining changes.

**At four placements** (`build-shifts.sh`), two runs each, the three sweeps in cycles a node:

| | 0 bytes | 1,024 | 2,112 | 3,136 |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c`, `m2` | 174.2 | 173.1 | 175.6 | 174.0 |
| `sqlite3.c`, `t2` | 170.2 | 168.8 | 169.2 | 168.4 |
| Lua, `m2` | 148.1 | 147.7 | 149.6 | 147.1 |
| Lua, `t2` | 146.0 | 145.4 | 145.1 | 146.1 |

## What a first run costs (`scripts/counts.py results 257229`)

Each sweep set was timed alone with `only.patch`'s `BUSTER_NODE_SHADOW_ONLY` (0 for T, 1 for T and C, 2 for all three),
on `only2`, which is `m2` with `only.patch`. Counts are from `perf stat`, user mode. Each figure is 40 passes, less a run
of none, per taken node: 257,229 nodes on `sqlite3.c`.

- **The runs:** `explore-only.sh` (`results/only2/only/`) runs each expression's sweeps once. `explore-repeat.sh`
  (`results/only2/repeat/`) runs them twice in a row with `--repeat 2`. The difference between the two is the second
  run.
- **Event groups:** the events come in two groups of five, so each group's figures are a separate process's.
- **Unreliable figures:** `only/counts-p40-set2-e2.txt` counted 7% more cycles than `e1` for the same set, which is
  multiplexing. Its back-end stall counts are not used.

| | cycles | instructions | slots the front end left empty | L1i misses | mispredicts | op-cache misses | op-cache accesses |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| T | 88.5 | 323.9 | 216.1 | 5.2 | 0.8 | 8.8 | 79.2 |
| C | 47.6 | 164.9 | 179.0 | 5.1 | 0.4 | 7.3 | 41.4 |
| X | 32.1 | 81.2 | 175.0 | 4.0 | 0.4 | 6.5 | 30.3 |
| all three, first run | 168.2 | 570.0 | 570.1 | 14.2 | 1.6 | 22.6 | 150.9 |
| T alone, second run | 75.6 | 314.0 | 134.0 | 3.5 | 0.5 | 4.2 | 66.6 |
| all three, second run | 123.5 | 570.4 | 266.8 | 6.4 | 0.7 | 9.1 | 120.7 |

- **X is the most front-end bound:** 175 of its 257 dispatch slots a node (32.1 cycles, eight slots each) are left
  empty, which is 68%.
- **A second run is 45 cycles cheaper on the same instructions.** Its instruction-cache misses fall from 14.2 to 6.4 a
  node, its op-cache misses from 22.6 to 9.1, and its mispredictions from 1.6 to 0.7.
  - In the shadow's timing loop, nothing runs between one expression's sweeps and the next expression's.
  - So the difference is the expression's own paths through the sweeps' code, and its inputs, refilling the caches.
  - The sweeps' code together is larger than the 32 KB instruction cache: `node_machine_type` is 11.8 KB,
    `node_machine_call_rule` 6.7 KB, `node_machine_contexts` 5.9 KB and `node_machine_expand` 5.7 KB, beside the
    other rules.
- **Data fills are a guess.** `explore-repeat.sh` also counted `ls_dmnd_fills_from_sys.all`, demand fills from memory.
  It counted 28.4 M for T and 31.9 M for all three over a whole `--repeat 2` run, but the `--repeat 1` runs didn't
  count it, so the data's share of the 45 cycles isn't measured.

## T's profile at main (`annotate-t.sh`, `results/m2/annotate-*`)

`perf record` of 40 passes of the shadow on `sqlite3.c`, with `cycles:u` and `instructions:u`. Samples are attributed
to source lines by `addr2line`, for `node_machine_type`, `node_machine_call_rule`, `node_machine_store_rule` and
`node_machine_pointer_rule`.

- **The profile is flat.** No line takes above 4%.
- **About a tenth goes to the leaf's record and its type word.** The leaf's record lines are `c_check_node_machine_type.c`
  lines 2138 to 2144, and the type word is `c_check_node_machine.c` line 496.
- **The operators' rule chain** is about 2 to 3%: lines 1987, 2003 and 2021.

## The checks

- **`--verify` on the 9700X** (`corpora.sh`, `results/m2/verify-*.txt` and `results/pr2/verify-*.txt`):
  - on the frozen `sqlite3.c`, Lua 5.4.8 and musl's 1,336 units, with and without `-g`;
  - 0 differences in values, entries and the twin;
  - `pr2`'s reports are the same as `m2`'s apart from their times.
- **The same in the cloud container** by its Develop builds of each variant: 0 differences, and the same reports as main.
- **`-c sqlite3.c`** (`ab.sh`, `results/ab-m2-pr2/`): 122.677 ms against 122.660, and 1,361,561,414 instructions against
  1,361,561,181, the medians of 21 runs each.
- **In the cloud container:**
  - `test-checker`: 838,851 checks, 0 failures;
  - `./build.sh check-call-graph`: 0 cycles.
