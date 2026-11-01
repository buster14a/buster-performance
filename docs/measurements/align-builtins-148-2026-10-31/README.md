# The alignment builtins and `expect_with_probability`, Buster #148

Compiler branch: `claude/148-align-expect` of buster14a/buster, for item 3 of
[#148](https://github.com/buster14a/buster/issues/148): `__builtin_align_up`, `__builtin_align_down`,
`__builtin_is_aligned` and `__builtin_expect_with_probability`, which the checker refused before, and `__builtin_expect`
folded as clang folds it. The branch is on the large arrays' alignment ([#984](https://github.com/buster14a/buster/pull/984),
#978), whose head is the base here.

This record keeps what the change costs units that call none of them on the 9700X: `-c` of the frozen `sqlite3.c` and of
stb_image at `-march=native`, the base against the head, by instructions and time with one executable per tree.

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **base:** `08cd8a426227dfb6e9760bf87afab15614a7d8b7`, #984's head (#978's fix merged with main);
- **head:** `650a1b72102d262ec12ca752c421d2233bb75ed6`, the builtins on it.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path in the C
locale), and `manifests/compare.txt` the check of the trees on the 9700X against them: no file differs. stb_image is the
earlier records' unit (`stb/stb_image.c`, including `stb_image.h`, stb_image 2.30, with `STB_IMAGE_IMPLEMENTATION`);
`run/measure.log` has both files' SHA-256.

## Method

Both trees were built by the branch's test rounds (`BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds), each in a
hold of the host's lock of its own. `scripts/queue.sh` logs both builds' last lines and executables' SHA-256
(`run/builds.log`) and runs `scripts/measure.sh` in one hold. `measure.sh` takes two trees and logs the receipts (the
date, `uname -a`, the CPU, CPU 2's governor, clang's and perf's versions, the lock's owner line, the trees' commits, and
the SHA-256 of both executables and of the inputs), compiles each unit with each tree once (its status, the two objects
compared, and each object's text, data and read-only sections' sizes and alignments), then runs 8 rounds in which each
tree, in an order alternated by round, compiles each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`,
pinned to CPU 2, each run's exit status beside its counters. The units:

- `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`
  of the frozen SQLite amalgamation, the 9700X job's compile-time step's command;
- `-c -march=native -I stb stb/stb_image.c`.

`scripts/analyze.py` takes each round's mean of a tree's runs, then the median of the rounds' means and the median,
minimum and maximum of the per-round ratios; its output is `run/analysis-*.txt`.

## Results

Every timed run exits 0, and each unit's objects are identical between the trees (`run/measure.log`,
`run/analysis-*.txt`).

| `-c` of | instructions | cycles | task clock |
|---|---:|---:|---:|
| `sqlite3.c` | −59,231 (−0.0044%) | −0.44% (−0.55% to −0.16%) | −0.37% (−0.61% to −0.11%) |
| stb_image `-march=native` | +10,348 (+0.0054%) | +0.03% (−0.55% to +0.39%) | +0.22% (−0.35% to +0.74%) |

The instructions are the medians of the rounds' means' differences, and the times the per-round ratios' median and
range. The base's medians were 1,349,267,322 instructions, 609.2 M cycles and 129.64 ms for `sqlite3.c`, and
190,008,420 instructions, 71.5 M cycles and 18.81 ms for stb_image. A tree's instructions vary by at most 35
(`sqlite3.c`) and 2,642 (stb_image) within a round.

## The walk's sensitivity (`bisection/`)

The branch's first head with the const objects' reads (8ed70f2f) made the same units run more instructions: 1,111,578
(+0.0824%) for `sqlite3.c` and 136,442 (+0.0718%) for stb_image, in a measurement of this method whose logs were replaced
by the final head's. `bisection/` has what found the cause, each variant's `sqlite3.c` instructions (`perf stat
-e instructions:u`, pinned to CPU 2, 3 runs per tree, the base's beside it in the same hold) and the diffs that made the
variants (`bisection/variants/`):

| Variant | Tree | `-fsyntax-only` | `-c` |
|---|---|---:|---:|
| 8ed70f2f | `talign8` | | +1,111,581 (`ab9.log`) |
| the walk's ordinary calls test `op` first (`op-first.diff` on 8ed70f2f) | `talign9` | | +864,739 (`ab9.log`) |
| and the alignment's evidence out of line (`noinline.diff`) | `talign10` | +921,681 (`ab12.log`) | +920,462 (`ab11.log`) |
| the base with the catalog's four rows alone (`catalog-only.diff` on 08cd8a42) | `tcat` | +114 (`ab13.log`) | |
| the base with the rows and the miscellaneous actions (`misc-only.diff`) | `tmisc` | +11,129 (`ab14.log`) | |
| `talign10` with the base's `c_check_input.c` | `tnoadapt` | +13,621 (`ab15.log`) | |
| one out-of-line helper, the head (`helper.diff` on 8ed70f2f, 650a1b72's tree) | `talign11` | −58,983 (`ab16.log`) | −59,983 (`ab16.log`) |

`talign10`'s difference from the base was the same for `-c` as for `-fsyntax-only`, and none for `-E` (`ab12.log`), so
the instructions were the parser's or the checker's, and the parser didn't change. The code that the source adapter's
walk (`check_input_expressions`, the hottest function) gained for the two builtins (a block for
`expect_with_probability`'s probability, the alignment's evidence and their conditions) changed the walk's registers
throughout: in `talign9` it took the walk's frame from 376 to 904 bytes (`objdump` at the time, not logged). With the
alignment's evidence out of line, the frame was 392 bytes (`round11.log`) and the instructions stayed. With both
builtins' work in one out-of-line helper reached only from the walk's existing evidence block
(`check_input_misc_evidence`), the walk's frame is the base's 376 bytes (`round16.log`) and its code shorter. Per-symbol
samples of 20 `perf record` runs per tree couldn't attribute differences this small: their noise exceeded them.

## Reading

Units that call none of the four builtins pay nothing measurable: the catalog's rows cost 114 instructions on
`sqlite3.c`, the actions about 11,000, and the head's walk runs fewer than the base's. Every time difference is within
the rounds' ranges.

## Limitations

- The time differences are of one layout of each tree; the instructions are the precise comparison. No placements were
  measured.
- `perf stat` counted user-mode events of the whole process.
- The bisection's variants were measured in holds of their own, three runs per tree; only the final head was measured
  by `measure.sh`.
- The tests ran on the 9700X too, from separate copies of the trees, each in a hold of its own.

