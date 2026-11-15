# The candidates' pass at half the references pass (buster#2536, step 2.2c, 2026-11-15)

Step 2.2c moves `check_program`'s per-body loop into the windows. Its gate wants the candidates' pass, the one that
runs before the bodies' controls (step 2.2a's, [`all-core-step2a-pass-2536-2026-11-14`](../all-core-step2a-pass-2536-2026-11-14/)),
to cost at most half the references pass. Step 2.2a measured it at 0.57 on `sqlite3.c` and 0.61 on `main.c`. buster's
PR [#2816](https://github.com/buster14a/buster/pull/2816) cuts it. This record measures that PR against main.

The executables are buster `080c44ab7d8dada755bbd45a50ab698dfc7a29b8` (the PR's head) and its base on main,
`891c4c631fbd76d4981bf833c8bb985177cfb3c2` (`raw/commit.txt`). Both are Release builds made under the 9700X's lock
(`raw/9700x/build.*.log`, each with its SHA-256).

**In short.** The pass's census is main's on every unit of every corpus, and `--provisional-selection`'s objects are
the same bytes as without it. On the 9700X the pass now costs 0.396 times the references pass on `sqlite3.c` (1.35 ms,
against main's 1.90 ms, 0.565) and 0.429 on `main.c` (3.19 ms, against 4.62 ms, 0.618). The gate holds on both.

## What changed

The scans keep their scalar twin, which scans every node and is the oracle for the vector path.

- **Chunks outside the bodies are skipped.** `check_program_census_touched` marks the 64-node chunks whose tokens
  meet a body, and each scan jumps to the next marked chunk (`check_program_census_next`). No other node names a body's
  object, takes a body's operand or holds a body's condition, so the skip is exact.
  - On `main.c`, whose unit holds the compiler's tables, 59% of the nodes lie in no body: 576,715 of 1,396,513 are in
    bodies, against 98.6% on `sqlite3.c`.
  - A unit whose bodies hold more than three quarters of its tokens isn't marked at all.
- **The leaf scan:**
  - each leaf's flags and object come as one qword gather, 8 lanes at a time;
  - the static bit is gathered only for objects the flags don't mark;
  - a block whose static leaves all lie in one body, with no left-out range among them, stores its pairs compressed.
- **The dead marks** are a bit per node.
- **Each body's list** is sorted and kept once by its sort, with an insertion sort for a short list. It no longer marks
  an object-sized column.
- **The prune** asks only the calls the reader marked as library calls, and the `&&`, `||` and `?:` whose condition is a
  constant or a builtin's query. Their conditions are gathered 16 at a time.
- **The constant-`if` finder** tests the conditions 16 at a time. Its scalar test reads the value's columns, not the
  whole value.

## What was run

`scripts/run.sh` ran as a user unit on the host:

1. both builds;
2. one hold of the lock a corpus for `scripts/census.sh`: each unit by both builds' `--selection-census -c`, then by the
   head's `-c` and `--provisional-selection -c`, with the objects compared;
3. one hold a file for `scripts/repeat.sh`: `sqlite3.c` and `main.c`, 7 rounds, each build's census, `-c` and
   `--provisional-selection -c`, the builds' order swapped every round, `-c`'s counted by `perf stat`.

Every compile ran on CPU 2 with `--lanes 1`. The corpora are step 1's: `sqlite3.c`, Lua's 34 sources, c-testsuite's 220
programs, `main.c` (the head's) and musl's 1,336 units. `scripts/tally.sh` sums them.

## The census

| corpus | units | census the same as main's | pass: units off, extra bodies, symbols, missing | provisional: serves, extra symbols, objects the same |
| --- | ---: | ---: | --- | --- |
| `sqlite3.c` | 1 | 1 | 1, 0, 10, 0 | 1, 5, 1 |
| `main.c` | 1 | 1 | 1, 0, 156, 0 | 1, 78, 1 |
| Lua | 34 | 34 | 0, 0, 0, 0 | 34, 0, 34 |
| c-testsuite | 220 | 220 | 4, 0, 34, 0 | 220, 17, 220 |
| musl | 1,336 | 1,336 | 12, 0, 54, 0 | 1,336, 27, 1,336 |

Each unit's line is in `raw/9700x/NAME.txt`, and its ticks by both builds are in `NAME.ticks`. A cloud container gave
the same census by the vector path and by `--scalar` on every unit (`raw/local/vector`, `raw/local/scalar`,
`scripts/local-census-twin.sh`). It also gave the same bytes by `--provisional-selection` (`raw/local/provisional`).

## The cost

| file | build | references pass | candidates' pass | ratio |
| --- | --- | ---: | ---: | ---: |
| `sqlite3.c` | main | 3.355 ms | 1.896 ms | 0.565 |
| `sqlite3.c` | #2816 | 3.435 ms | 1.354 ms | **0.396** |
| `main.c` | main | 7.447 ms | 4.616 ms | 0.618 |
| `main.c` | #2816 | 7.501 ms | 3.192 ms | **0.429** |

These are medians of 7 rounds (`raw/9700x/NAME.repeat.txt`), in TSC ticks at 3.7925 GHz. The ratio is the median of
each run's.

- **`--provisional-selection`'s cost on `sqlite3.c`:** 1.36 ms now (122.82 to 124.18 ms of task clock), against 2.66 ms
  by main's build (122.78 to 125.44 ms).
- **On `main.c`** the option's cost is within the runs' spread: the two builds' plain runs differ by 4 ms (692.4 and
  696.5 ms). Its user instructions drop by 33.5 M (227.1 M more than plain by main's build, 193.6 M by #2816's). These
  are medians of `raw/9700x/NAME.SIDE.MODE.N.csv`.
- **Small units** pay a fixed cost of a few microseconds. Summed over each corpus's single census runs, the ratios are
  0.603 for Lua (main's build: 0.734), 2.36 for c-testsuite (2.51) and 1.61 for musl (1.61). A c-testsuite program's
  pass costs 2.3 µs, a musl unit's 5.3 µs: the scan's columns are allocated and cleared whatever the unit's size.
- **The objects** of the last rounds are the same bytes by `-c` and by `--provisional-selection -c`, and by both builds
  (`raw/9700x/NAME.*.same.txt`).

## How it got there

Three earlier runs of the same scripts are kept.

- **The first commit** (`783bc42f`, `raw/9700x-first/`) had the leaves' gathers, the insertion sort, the marked calls and
  the conditions by 16. In one census run it gave `sqlite3.c` 0.394 against main's 0.579. Its holds' timeouts counted
  the wait for the lock, which ended Lua's census before it started (status 124 in its `holds.log`). Its holds again,
  timing the run alone, gave Lua's census (status 0), then stopped for the next commit.
- **`d610c082`** (`raw/9700x-d610c082/`) added the chunk marks, the leaf fast path, the bit marks and the prune's filter.
  Its 7 rounds gave `sqlite3.c` 0.413 and `main.c` 0.540, short of the gate.
- **An ablation** (`raw/9700x-ablation/`, `scripts/ablation*.sh`) switched each of those parts off by an environment
  variable. Its build is `scripts/ablation-switches.patch` on the PR's docs commit, never pushed. The switches' calls
  slowed every variant of `main.c` by about 3 M ticks, so only the variants of that one build compare.
  - Without the chunk marks, `main.c` went from 0.645 to 0.613: a block outside the bodies still ran its loop with
    empty masks, and the marking read every node's token.
  - Without the fast path, 0.653; without the prune's filter, 0.630.
  - On `sqlite3.c` (0.415 with every part on), without the chunk marks 0.398, without the fast path 0.425, without the
    filter 0.442.
- **The final commit** jumps over unmarked chunks by the marks' words and doesn't mark a unit of bodies. A body's list is
  now kept once by its sort.

## Files

- `raw/9700x/`: the final run's census lines, ticks, repeats, plain and provisional counts, object comparisons, the
  holds' log and the builds'.
- `raw/9700x-d610c082/`, `raw/9700x-first/`, `raw/9700x-ablation/`: the earlier runs, as run.
- `raw/local/`: the cloud container's twin and byte checks.
- `scripts/`: every script as the final run ran it.
  - The first run's `run.sh` took the head's parent as main and bounded each hold's wait by its timeout.
  - The `d610c082` run's bounded the run alone, as the final one does.
- `SHA256SUMS`: every file's hash.
