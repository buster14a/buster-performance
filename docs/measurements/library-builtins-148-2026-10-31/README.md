# The C library's builtins, Buster #148

Compiler branch: `claude/148-library-builtins` of buster14a/buster, for
[the #148 claim](https://github.com/buster14a/buster/issues/148#issuecomment-6525264816)'s item 2: clang 23's library
builtins (`__builtin_sin`, `__builtin_strlen`, `__builtin_printf`, and the plain names where clang makes them builtins of
the unit) compiled as calls of their functions, with clang's constant folds, and their `__has_builtin` and
`__has_constexpr_builtin` answers.

This record keeps the cost on the 9700X: `-c` of the frozen `sqlite3.c`, a unit of plain library calls, which the reader
now marks where clang folds them, and of stb_image at `-march=native`, whose intrinsics' builtins the checker and the
lowering now look up among the library's. Main against the head, by instructions and time with one executable per tree,
twice: the first head (`first/`), whose cost the next commit cut, and the final one (`final/`).

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **main:** `1b04bd5c210e74b346cb775d1e5b4cad7853788c`, the branch's base after its merge of main;
- **first head:** `88b04f937394955f24aa4a787806521c4e147cda`, the library builtins and that merge;
- **final head:** `9b2620b36fe7a224b24f0edd53aec215bb732f38`, with the commit that keeps the library's lookups to the calls that may be its.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path in the C
locale), and `manifests/compare.txt` the comparison with the trees on the 9700X. stb_image is the unit of the earlier
records' (`stb/stb_image.c`, SHA-256 `40bcca3e…`, including `stb_image.h`, `594c2fe3…`, stb_image 2.30, with
`STB_IMAGE_IMPLEMENTATION`); `first/measure.log` has both files' SHA-256.

## Method

`scripts/queue.sh` built each tree (`scripts/build-tree.sh`, `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds)
and ran `scripts/measure.sh`, each in a hold of the host's lock of its own. `measure.sh` takes two trees and, in one hold,
logs the receipts (the date, `uname -a`, the CPU, CPU 2's governor, clang's and perf's versions, the lock's owner line,
the trees' commits, and the SHA-256 of both executables and of the inputs), compiles each unit with each tree once (its
status, and the two objects compared), then runs 8 rounds in which each tree, in an order alternated by round, compiles
each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`, pinned to CPU 2, each run's exit status
beside its counters. The units:

- `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`
  of the frozen SQLite amalgamation, the 9700X job's compile-time step's command;
- `-c -march=native -I stb stb/stb_image.c`.

`scripts/analyze.py` takes each round's mean of a tree's runs, then the median of the rounds' means and the median,
minimum and maximum of the per-round ratios; its output is `*/analysis-*.txt`. The final head's run used the same
scripts with its tree in `head` (`scripts/queue-final.sh`).

The lock's waiting messages went to separate `.stderr` files, which this record leaves out, as they name other jobs.

## Results

Every build exits 0, every timed run exits 0, and the trees write the same objects, byte for byte, for both units
(`first/measure.log`, `final/measure.log`).

| `-c` of | head | instructions | cycles | task clock |
|---|---|---:|---:|---:|
| `sqlite3.c` | first | +2,011,344 (+0.149%) | +0.55% (+0.22% to +0.80%) | +0.35% (+0.29% to +0.53%) |
| | final | +448,058 (+0.033%) | +0.08% (−0.63% to +0.48%) | +0.07% (−0.40% to +0.64%) |
| stb_image `-march=native` | first | +578,947 (+0.304%) | −0.08% (−0.45% to +0.55%) | −0.25% (−0.48% to +0.41%) |
| | final | +131,801 (+0.069%) | −0.16% (−2.30% to +2.65%) | −0.42% (−2.52% to +3.41%) |

The instructions are the medians of the rounds' means' differences, and the times the per-round ratios' median and
range. Main's medians in the first run were 1,348,996,879 instructions, 606.7 M cycles and 128.82 ms for `sqlite3.c`,
and 190,209,945 instructions, 71.6 M cycles and 18.89 ms for stb_image; in the final run 1,348,996,373, 608.2 M and
129.01 ms, and 190,209,923, 73.0 M and 19.12 ms. A tree's instructions vary by at most 48 (`sqlite3.c`) and 2,901
(stb_image) within a round.

## Reading

The first head's 2.0M instructions on `sqlite3.c` were work the unit doesn't need: it calls no library builtin, but every
call of a function asked whether it was a plain library builtin's that clang folds (about 85,000 calls, 20 instructions
each, by `perf record` of the instructions on the 7940HS), and the checker called the fold's test for each. stb_image's
0.58M were its x86 builtins' calls looked up among the library's names, by the checker and twice by the lowering. The
final head tests a mask of the folds' identifiers on a call's spelling first, inlined, and keeps the x86 builtins out of
the library's lookups (`cbuiltin_library_candidate`); and the declared runtimes' pass compares a declaration's name with
the unit's spelled runtime functions as a vectorized reduction first.

The final head runs 448,058 more instructions than main on `sqlite3.c` and 131,801 more on stb_image, into the same
objects, and its times are main's within the rounds' ranges; stb_image's run was noisier than the first's, its
per-round ratios spanning five percent. What is left on `sqlite3.c` is the inlined test at each call of a function
and the declared runtimes' pass over the spelled names, and on stb_image the prefix test of each x86 builtin's
call by the checker and the lowering.

## Limitations

- The time differences are of one layout of each tree; the instructions are the precise comparison. No placements were
  measured.
- `perf stat` counted user-mode events of the whole process; the attribution of the first head's cost comes from
  `perf record` of instructions on the 7940HS (Zen 4), at a period of 200,003 over 10 runs, and the cut from the
  instruction counts of the commits between.
- The tests ran on the 7940HS, not the 9700X; the 9700X ran the builds and the timings.
