# T's records as columns: #2524's step 1, its cost gate's first lever (2026-11-12)

This is [buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1, the node machine in shadow, and the
first lever its cost follow-up named ([its record](../node-machine-shadow-cost-2524-2026-11-12/)): the design's records
in place of a whole 96-byte `CheckValue` a record. The machine's T sweep stores each record's value as the design's
columns. The rows and the direct rules read and write the columns. The action, `check_action_compute`, stays the exact
twin. `docs/node-machine.md`'s "T's records as columns" summarizes this record.

Everything ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the lock, pinned to CPU 2, with the scripts in
`scripts/`: the earlier records' `time.sh`, `repeat.sh` and `corpora.sh`, unchanged but for `lock.sh`'s owner. `build.sh`
builds `src` in one hold and keeps the compiler in `results/LABEL`. `measure2.sh` checks out a commit, applies a patch
(`-` for none), builds, times, times with `--repeat 2` and, with `annotate`, profiles. `annotate.sh` records the sweeps
by cycles and, from `s4` on, by retired instructions too.

## Sources and binaries

- **The measured commits**, each checked out by its id after `git checkout -- . && git clean -fd`, with no local change
  (`logs/build-LABEL.log` shows each one's `git log` and `git status`):
  - `main-0af27a30`: buster main
    [`0af27a309`](https://github.com/buster14a/buster/commit/0af27a309), timed twice (`main-0af27a30`, then
    `main-0af27a30-b` right after the final commit's runs, the same binary).
  - `split`: [buster#2571](https://github.com/buster14a/buster/pull/2571)'s head,
    [`27ee009a3`](https://github.com/buster14a/buster/commit/27ee009a3959de4d2c533021b289e969eecf91a2): the machine
    split into T, C and X files, with the record accessors. The commits below are on it.
  - `a7554651`: [`a75546513`](https://github.com/buster14a/buster/commit/a75546513), T's records as columns, a pointer
    a column, each column staggered.
  - `2044025c`: [`2044025cc`](https://github.com/buster14a/buster/commit/2044025cc), the columns in one block, one base
    for every field. **The final commit.**
- **The patches** (`patches/`), the working tree at each step, applied to a clean checkout:
  - `v4`: T's columns, a pointer a column, not staggered, on main `0af27a30`;
  - `stagger`: the split's own columns (a whole value a record) staggered, nothing else, on `27ee009a3`;
  - `s2`: `a7554651` before its last comments, a simplification of three conditions and a fix: replacing the integer of
    a record whose payload is a floating value with a zero significand (-0.0) now makes the value whole; on
    `27ee009a3`;
  - `s4`: `s2` with T's loop inputs held in locals and `restrict` on its machine pointer, on `27ee009a3`.
- **Binary hashes:** `results/compilers.txt`. Only `main-0af27a30`'s, `a7554651`'s, `2044025c`'s and `04abc91b`'s
  compilers were kept (`results/compilers-kept.txt`): the host's disk filled during these runs (below).
- **Host:** `results/env.txt` (Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, the performance governor).

## Results (`sqlite3.c`, a taken evaluated node)

The least of 11 passes of one process, each sweep set timed on its own. C's figure is T and C's less T's, X's all
three's less T and C's. "Warm" is the second of two runs in a row (`--repeat 2`): the run of two's figure less the one
run's, each from its own process.

| `sqlite3.c` | T: cycles, instructions | C | X | all three | all three, warm |
| --- | ---: | ---: | ---: | ---: | ---: |
| main (`main-0af27a30-b`) | 94.8, 368.1 | 42.4, 189.0 | 32.9, 112.8 | 170.1, 669.9 | 159.8, 666.9 |
| main (`main-0af27a30`) | 95.0, 368.1 | 43.0, 189.0 | 32.4, 112.8 | 170.4, 669.9 | 158.7, 666.9 |
| the split | 95.2, 368.1 | 42.4, 189.0 | 31.8, 102.8 | 169.4, 659.9 | 150.3, 657.0 |
| the split, staggered (`stagger`) | 92.5, 368.1 | 37.1, 189.0 | 23.3, 102.8 | 152.9, 659.9 | 130.5, 657.0 |
| T's columns, not staggered (`v4`) | 135.1, 347.1 | 108.9, 221.6 | 41.0, 111.9 | 285.0, 680.6 | 342.3, 677.6 |
| T's columns, staggered (`s2`) | 87.5, 347.3 | 40.7, 208.6 | 26.0, 103.3 | 154.2, 659.2 | 124.4, 656.1 |
| `s2`, locals and `restrict` (`s4`) | 91.3, 350.0 | 40.6, 208.6 | 25.7, 103.3 | 157.6, 661.9 | 128.3, 658.9 |
| `a7554651` | 88.1, 347.0 | 45.6, 208.7 | 23.0, 103.2 | 156.7, 658.9 | 124.9, 656.0 |
| **`2044025c`** | **87.3, 344.0** | **37.4, 185.3** | **25.5, 97.8** | **150.2, 627.1** | **123.4, 624.1** |

Warm, `2044025c`'s T costs 68.2 cycles a node, its C 35.1 and its X 20.1; main's 79.9, 49.5 and 30.4.

| Lua 5.4.8, all three sweeps, one run | cycles |
| --- | ---: |
| main (`main-0af27a30-b`) | 178.6 |
| the split | 179.4 |
| the split, staggered | 162.2 |
| `a7554651` | 168.7 |
| `2044025c` | 169.8 |

- **The stagger is most of the gain.** Arrays of 4,096 elements one after another each begin on a 4 KB boundary, so
  every column's first records, all a small expression touches, fall in one set of the first-level cache, more lines
  than its 12 ways, and each record's fields are 4 KB apart. Main's whole values had that layout too. Staggering the
  columns by two cache lines each takes 16.5 cycles off main's 169.4 in one run and 19.8 off 150.3 warm, with no
  instruction fewer. T's columns without it (`v4`) ran at an IPC of 2.4: 285.0 cycles.
- **A pointer a column cost C 19.7 instructions a node** (`a7554651`: 208.7 against 189.0). The build's
  `-fno-strict-aliasing` lets any store change a column's pointer in `NodeMachine`, so C loaded it again for each field:
  three instructions where a whole value's base took one. In one block (`2044025c`) every field is one load from one
  base, and C runs 185.3.
- **The columns are worth 24 of T's 368 instructions and 33 of all three sweeps' 660**, against the staggered whole
  values: 2.7 cycles in one run and 7.1 warm on `sqlite3.c`. On Lua they cost 7.6: a quarter of its typed operators go
  to the action (5,098 of 19,514, against 7,238 of 83,211 on `sqlite3.c`), and the action takes and gives whole values,
  which the columns make and take apart.
- **`s4`**, T's loop inputs in locals and `restrict`, ran no faster than `s2`: within the about 3% that placement
  moves these figures.
- **Against the gate's 120:** 150.2 cycles in one run and 123.4 warm. The warm figure is the reader's position in step
  2: 3% over.

## With the new codes: the split's head `f5b919f2` (calls, `&&`, `||`, `?:`)

[buster#2571](https://github.com/buster14a/buster/pull/2571)'s head moved to
[`f5b919f20`](https://github.com/buster14a/buster/commit/f5b919f20): main's `&&`, `||` and `?:` (buster#2569) and the
calls (buster#2575) in the split files. [buster#2580](https://github.com/buster14a/buster/pull/2580) merged it at
[`04abc91bb`](https://github.com/buster14a/buster/commit/04abc91bb): the split's new per-record columns join
`NodeMachineColumns`, the logical operator's rule reads and writes the columns, and a call's arguments still convert by
the action's functions on values made whole. The machine now takes 93.0% of `sqlite3.c`'s evaluated nodes (242,002),
against 50.2% before, so these figures don't compare with the tables above.

- `split-f5b919f2`: the split's head, clean.
- `stagger-f5b919f2`: the split's head with its columns staggered alone (`patches/stagger2.patch`, two cache lines a
  column, the whole values' column last).
- `04abc91b`: buster#2580's merge, clean.

| `sqlite3.c` | T: cycles, instructions | C | X | all three | all three, warm |
| --- | ---: | ---: | ---: | ---: | ---: |
| the split's head | 119.1, 446.7 | 55.6, 204.4 | 37.7, 113.0 | 212.4, 764.1 | 167.1, 761.8 |
| the split's head, staggered | 119.0, 446.7 | 54.3, 204.4 | 36.3, 113.0 | 209.6, 764.1 | 159.3, 761.8 |
| **`04abc91b`** | **116.2, 434.5** | **56.1, 191.6** | **39.0, 107.0** | **211.3, 733.1** | **160.5, 730.7** |

| Lua 5.4.8, all three sweeps, one run | cycles, instructions |
| --- | ---: |
| the split's head | 194.5, 909.2 |
| the split's head, staggered | 191.8, 909.2 |
| `04abc91b` | 195.8, 903.0 |

- **The stagger is worth 2.8 cycles in one run and 7.8 warm here,** against 16.5 and 19.8 before. With the new codes the
  sweeps cost 43 cycles a node more, the calls most (their record, buster-performance#460).
- **The columns cut 31 of the 764 instructions** (T 12, C 13, X 6), but cost 1.7 cycles in one run and 1.2 warm against
  the staggered whole values, and 4.0 on Lua. More of the typed nodes go to the action now (12,942 of 147,250 on
  `sqlite3.c`), and a call's arguments are made whole for its conversions.
- **Against the gate's 120:** 211.3 cycles in one run and 160.5 warm.
- **The comparison** at `04abc91b`: `--verify` on `sqlite3.c`, Lua and musl, without and with `-g`, 0 differences and
  every run exited 0 (`results/04abc91b/verify-*.txt`).

## Where T's cost is (`results/*/perf-*.txt`, `annotate-*.txt`)

- **By cycles** (`s2`'s `perf-symbols.txt`, of the whole run, which the sweeps are most of): `node_machine_type` 39.4%,
  `node_machine_contexts` 16.5%, `node_machine_action` 6.3% and its callees about 5% more, `node_machine_expand` 4.7%.
  The action types 7,238 of the 142,196 records and costs about a fifth of T: casts but discards (2,870), a global's
  member (2,110), constant folds (`-x` 1,316, `|` 755), pointer comparisons (1,056), `sizeof` (912).
- **By retired instructions** (`s4`'s and `2044025c`'s `annotate-instructions-node_machine_type.txt`, summed by source
  line), T's instructions spread over its loop and context test, the leaves' records, the operands' search, the type
  words and the rules' type-table queries, none of them a tenth of T. A value's copies weren't where they went.
- **Main's hottest lines in T by cycles** (`main-0af27a30`'s `annotate-node_machine_type.txt`) were the leaf's 96-byte
  store after its record's load (11.6% of T) and the discard's copy of its operand (8.6%), both cache misses and
  store-forwarding waits on the inputs. The columns removed the copies; the inputs' misses remain in one run.

## The comparison

`--verify` on `sqlite3.c`, Lua 5.4.8's 34 sources and musl's 1,336 units, without and with `-g`, by `a7554651`'s and
`2044025c`'s compilers (`results/*/verify-*.txt`, each hold's owner line in `verify-holds.txt`): 0 differences in values,
entries and the twin, every run exited 0, and main's counts (75,973 nodes by a row or a rule and 7,238 by the action on
`sqlite3.c`). `a7554651`'s first attempt (`results/a7554651/first-attempt/`) stopped when the host's disk filled:
sqlite3.c and Lua without `-g` had finished, the rest are empty or cut short; the second attempt ran all six.

The lock's messages naming other sessions' holds were removed from the build logs (the `exclusive.sh: waiting` lines).

## Limits

- **One process a figure.** Each is the least of 11 passes of one process, and placement moves it by about 3%. The
  final commit's figures and main's second run were taken one after the other.
- **The warm cost is a difference of two minima,** each of its own process.
- **The sweeps run in the shadow's position**, after the pipeline. `--repeat` approximates the reader's position; it
  doesn't measure it.
- **The host's disk filled** (`/home`, 100%) during `a7554651`'s comparison, by every session's files: this session
  deleted its own build trees, compilers and `perf.data` files to finish, and kept the annotations.
