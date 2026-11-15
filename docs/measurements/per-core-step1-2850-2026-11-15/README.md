# The one-core path's step 1: the fact words (buster#2850), 2026-11-15

Step 1 of [buster#2850](https://github.com/buster14a/buster/issues/2850):
T's identifier leaves and lookups made from fact words, in the node
machine's shadow, with T's records as the oracle. Its gate was "every record
the oracle's; 10 cycles a leaf or lookup or less, a body's expressions a run".

**Result.** Every record is T's on `sqlite3.c`, Lua and musl. A taken leaf or
lookup costs 26.5, 17.2 and 15.8 cycles with a body a window, and 22.5, 15.0
and 14.9 with the windows packed to 384 records. A leaf is about 5 cycles and
meets the gate. A lookup is 18 to 63 cycles by its operator and doesn't: it
is past the design's own line of 20 cycles a lookup. The code is buster's
`c_check_node_machine_facts.c` (`measure-node-machine --shadow --facts`), in
[buster#2863](https://github.com/buster14a/buster/pull/2863); the design's
page is buster's `docs/one-core-path.md`; the result against the gate is
[on the issue](https://github.com/buster14a/buster/issues/2850#issuecomment-6900508040).

## How it was measured

- The 9700X (`benchpress`), CPU 2, every build and run under the host's lock,
  one hold a run (`scripts/lock.sh`).
- `base` is buster main `1b8231ea`; `head` is it with
  `scripts/patches/facts-8.patch`, the pull request's sources but for a
  comment and the docs. Both are `./build.sh --config Release`
  (`scripts/build-label.sh`).
- The inputs are the 9700X job's corpora: the frozen `sqlite3.c` with its
  `compile_time` options, Lua 5.4.8's `src/*.c`, and musl's sources by their
  own options (`scripts/facts.sh`).
- A run is `measure-node-machine --shadow --facts --passes 5`. After its
  checked pass it runs the kernel over every window of the unit five times and
  keeps the least: cycles, instructions and mispredicted branches by the
  thread's counters, less the same windows' given records put in place alone
  (the harness's part). A leaf's and a lookup's cycles are the two parts' TSC
  ticks from separate passes, by the cycles a tick of the label's `sqlite3.c`
  runs (`scripts/tables.py` says why).
- Each setting ran three times; the tables have the medians
  (`scripts/final.sh`, `scripts/tables.py`).
- The passes follow the shadow's own scalar sweeps over the unit and the
  checked pass; nothing here runs after a pause. The kernel's vector work is
  the listing (sixteen records a step) and the leaves' one load and store.

## The result

`python3 scripts/tables.py results head`:

| corpus | windows | records | leaves taken | lookups taken | differences | cycles | instructions | mispredicted | a leaf | a lookup | a leaf again | a lookup again |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | a body | 291,021 | 93,682 (100%) | 88,497 (99.73%) | 0 | 26.54 | 73.27 | 0.371 | 7.92 | 46.14 | 6.78 | 28.04 |
| `sqlite3.c` | packed, 384 | | | | 0 | 22.47 | 68.91 | 0.243 | 5.26 | 39.90 | 4.84 | 24.82 |
| `sqlite3.c` | packed, 4,096 | | | | 0 | 21.78 | 70.29 | 0.148 | 5.44 | 38.61 | 5.22 | 30.19 |
| Lua | a body | 73,998 | 21,795 (100%) | 19,736 (99.72%) | 0 | 17.22 | 75.76 | 0.000 | 7.89 | 28.11 | 6.75 | 27.13 |
| Lua | packed, 384 | | | | 0 | 15.00 | 67.63 | 0.008 | 5.16 | 25.26 | 4.84 | 23.71 |
| Lua | packed, 4,096 | | | | 0 | 15.74 | 67.58 | 0.005 | 5.00 | 27.22 | 4.87 | 27.13 |
| musl | a body | 130,291 | 42,850 (100%) | 27,383 (99.34%) | 0 | 15.82 | 71.32 | 0.003 | 6.55 | 29.99 | 5.38 | 29.04 |
| musl | packed, 384 | | | | 0 | 14.86 | 67.38 | 0.005 | 5.31 | 28.42 | 4.69 | 27.44 |
| musl | packed, 4,096 | | | | 0 | 14.99 | 66.95 | 0.005 | 5.23 | 28.93 | 4.65 | 28.39 |

"Cycles", "instructions" and "mispredicted" are a taken leaf or lookup's.
"Again" is each window run a second time at once. "A body" is a body's
expressions a window, cut every 384 records.

- **Lua's and musl's mispredicted branches read as none** because their passes
  repeat a sequence the predictor learns. `sqlite3.c`'s are the ones a compile
  would see, and its lookups' second runs (28 cycles against 46) show what
  they cost.
- **Left to T:** 200 discards, 35 calls and 5 subscripts on `sqlite3.c`; 50
  discards, 5 subscripts and a dereference on Lua; 151 subscripts, 17 arrows,
  12 discards and 3 calls on musl.
- **The words:** `sqlite3.c` has 4,740 rows, 18,260 lines and 2,229 member
  slots; no declaration needed its line made again on the three.

By part on `sqlite3.c`, windows packed to 384 records
(`python3 scripts/parts.py results head 40`, from `scripts/profile.sh`'s
profiles of the kernel's functions):

| part | of them | cycles each | instructions | mispredicted branches |
| --- | ---: | ---: | ---: | ---: |
| the lists, the classes' mask and the batches, a record of the window | 291,021 | 2.48 | 8.92 | 0.02 |
| a leaf | 93,682 | 2.96 | 15.21 | 0.00 |
| a discard | 36,724 | 17.82 | 54.19 | 0.20 |
| `->` | 23,433 | 25.25 | 92.12 | 0.15 |
| `.` | 7,257 | 31.89 | 123.45 | 0.24 |
| a call | 13,323 | 50.62 | 138.21 | 0.58 |
| a subscript | 6,812 | 62.60 | 226.63 | 0.56 |

## A compile is unchanged

`-c sqlite3.c` as whole processes, main against the branch
(`scripts/compile.sh`: `time-runs` under `ab`, 21 runs a build from three fresh
copies of each executable, the base twice; `results/head/compile-N.txt`):

| comparison | wall ms, main | the branch | difference (over copies) | main again against main |
| --- | ---: | ---: | --- | --- |
| 1 | 123.520 | 123.361 | -0.13% (-0.47% to +0.60%) | -0.22% |
| 2 | 123.392 | 123.592 | +0.16% (-0.29% to +0.27%) | -0.26% |
| 3 | 123.259 | 123.089 | -0.14% (-0.87% to +0.11%) | -0.20% |
| 4 | 123.415 | 123.111 | -0.25% (-0.66% to +0.18%) | -0.26% |

User cycles differ by +0.01%, -0.20%, -0.16% and +0.09%. No compile runs any
of the change.

## A record's stores

`scripts/tools/stores.c` (`scripts/stores.sh`, `results/stores-1024.txt`)
stores a record's nine values (4, 4, 1, 4, 4, 8, 8, 8 and 8 bytes) from a
16-byte source, 1,024 records a pass:

| cycles a record | records one after another | one record in three |
| --- | ---: | ---: |
| nine columns, staggered as T's are | 6.03 | 7.98 |
| eight, seven, six, five columns | 4.82, 4.32, 3.65, 2.86 | 6.35, 5.63, 4.12, 3.58 |
| four, three, two, one column | 2.13, 1.69, 1.15, 0.84 | 2.13, 1.69, 1.15, 0.85 |
| one 64-byte line, nine stores | 4.06 | 3.93 |
| one 64-byte line, one vector's store | 4.09 | 1.53 |

One record in three is the leaves' spacing: a store a column lands about one
a cycle, a line's stores two a cycle, and one vector's store costs 1.5. With
records one after another the lines are 64 KB, past the first-level cache,
likely what the last two rows' 4 cycles are. This is why the kernel's record
became one line (version 5 below): a leaf fell from 10.4 cycles to 6.7 at a
body a window, and to about 5 with the windows packed.

## The versions

Each is a patch on main `8f223aee` (`scripts/patches/facts-N.patch`, built
and run by `scripts/run-label.sh`; `results/fN`), one run each, a body a
window. Cycles a taken leaf or lookup, with its instructions:

| | the kernel | `sqlite3.c` | Lua | musl |
| ---: | --- | ---: | ---: | ---: |
| 1 | T's rules' steps on rows and slots; T's columns, each by a pointer of the kernel's state | 45.9 (140) | 31.7 (145) | 31.9 (140) |
| 2 | the columns in one block, the window's inputs in locals; a declaration's line as the reader had it at the use | 43.0 (122) | 29.5 (127) | 29.9 (123) |
| 3 | the lists by compress, a record's pairs stored together | 33.0 (94) | 20.8 (94) | 18.1 (86) |
| 4 | a short path a lookup, its rule behind it | 29.1 (75) | 17.8 (77) | 15.4 (76) |
| 5 | a record a line, a leaf a copy; lookups by class, their levels made by the kernel | 34.3 (91) | 21.4 (94) | 19.1 (86) |
| 6 | a path's tests as one word; a loop an operator | 34.5 (91) | 22.1 (96) | 19.7 (88) |
| 7 | the class with the record; a call's first arguments with no branch | 27.0 (73) | 17.2 (76) | 15.9 (71) |
| 8 | version 7 on main `1b8231ea` (`head`, medians of three) | 26.5 (73) | 17.2 (76) | 15.8 (71) |

- Versions 1 and 2 are whole passes, with the given records' copy (about 5.5
  cycles a taken leaf or lookup on `sqlite3.c`). Version 1 differed on 80 of
  musl's leaves: a weak declaration's address may be null.
- Version 4's mispredicted branches were 0.43 a record on `sqlite3.c` with a
  dispatch a lookup. The classes trade them for the loops' ends: 0.37 at a
  body a window, 0.24 at 384 records, 0.15 at 4,096.
- Version 5's and 6's level pass cost about 30 instructions a lookup, and gave
  back what the line and the classes gained. Version 7 takes each lookup's
  class with its record, as it takes the operator.
- Packed windows, `sqlite3.c`: version 4 at 4,096 records 27.8; version 7 at
  384 records 23.2 and at 4,096 records 21.7.

## Exact instruction counts

`scripts/tools/stephist.c` (from the vector lexer's record) single-steps a
function's calls and counts each instruction. It ran in the session's cloud
container on a Develop build (the same toolchain), over the checked pass of
the compiler's own source (`src/buster/compiler/main.c`'s unit: 36,660
leaves and 22,195 lookups taken): `results/stephist/hist-*.txt`, to be read
with the build they came from (`scripts/tools/join.py` and `path.py`, by the
inlining's records).

| instructions each | version 3 | version 4 |
| --- | ---: | ---: |
| a leaf | 32 | 32 |
| a member access (`->` and `.`) | 158 | 96 and 107 |
| a subscript | 278 | 163 |
| a call | 120 | 113 |
| a discard | 45 | 44 |

From version 5 a leaf is 9 instructions (15 with its loop).

## Traps met

- **A kernel's columns behind pointers of a struct** are loaded again after
  every store (`-fno-strict-aliasing`): version 1's 140 instructions a record.
  One block addressed from one base, and the read-only inputs in locals.
- **A loop of two or three iterations vectorized.** Clang 23 made the calls'
  argument loops vectors of loaded and inserted lanes and spilled the loops
  around them (the level pass was 47 instructions a lookup with it, 30
  without). `#pragma clang loop vectorize(disable) interleave(disable)`.
- **One function for the whole kernel** leaves its loops without registers;
  a function a part gave each loop its own.
- **Lua and musl hide mispredicted branches** (above).
- **A unit as short as musl's files** has its pass's counter reads in its
  cycles and not in its ticks: its cycles a tick read 1.65 where the clock's
  is 1.46.

## Files

- `scripts/`: `lock.sh` (the lock, one hold a command), `build-label.sh`,
  `facts.sh`, `run-label.sh`, `final.sh` (what `head` and `base` ran),
  `profile.sh`, `compile.sh`, `stores.sh`, `tables.py`, `parts.py`;
  `tools/stores.c`, `tools/stephist.c`, `tools/join.py`, `tools/path.py`;
  `patches/facts-1.patch` to `facts-8.patch`.
- `results/`: `f1` to `f7`, `head`, `base` (each label's build log, its
  executable's hash and its runs), `stores-1024.txt`, `stephist/`.
