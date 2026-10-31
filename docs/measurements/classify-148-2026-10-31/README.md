# The floating classifications, Buster #148

Compiler branch: `claude/148-float-classify` of buster14a/buster, for
[the #148 claim](https://github.com/buster14a/buster/issues/148#issuecomment-6525264816)'s item 3: clang 23's
`__builtin_isnormal`, `issubnormal`, `iszero`, `issignaling` and `isfpclass` (of vectors too), `signbitf` and
`signbitl`, and `canonicalize`, `canonicalizef` and `canonicalizel`, checked, folded and lowered as clang does.

This record keeps the cost on the 9700X of what the branch adds to every unit: ten catalog rows that the checker's and
the preprocessor's lookups scan, and the float family's tests, which every call of a unit may ask. `-c` of the frozen
`sqlite3.c` and of stb_image at `-march=native`, neither of which calls one of these builtins: main against the head,
by instructions and time with one executable per tree.

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **main:** `693926a7a99a0df9f520b36b9d13a373bf34ad9e`, the branch's base;
- **head:** `6c7f6c36108de547c2efecf51f73849073a7435c`, the classifications (`d7d9b903`) and `isfpclass` of a vector.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path in the C
locale), and `manifests/compare.txt` the comparison with the trees on the 9700X. stb_image is the unit of the earlier
records' (`stb/stb_image.c`, SHA-256 `40bcca3e…`, including `stb_image.h`, `594c2fe3…`, stb_image 2.30, with
`STB_IMAGE_IMPLEMENTATION`); `run/measure.log` has both files' SHA-256.

## Method

`scripts/queue.sh` built both trees (`scripts/build-tree.sh`, `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job
builds) and ran `scripts/measure.sh`, each in a hold of the host's lock of its own. `measure.sh` takes two trees and, in
one hold, logs the receipts (the date, `uname -a`, the CPU, CPU 2's governor, clang's and perf's versions, the lock's
owner line, the trees' commits, and the SHA-256 of both executables and of the inputs), compiles each unit with each
tree once (its status, and the two objects compared), then runs 8 rounds in which each tree, in an order alternated by
round, compiles each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`, pinned to CPU 2, each run's
exit status beside its counters. The units:

- `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`
  of the frozen SQLite amalgamation, the 9700X job's compile-time step's command;
- `-c -march=native -I stb stb/stb_image.c`.

`scripts/analyze.py` takes each round's mean of a tree's runs, then the median of the rounds' means and the median,
minimum and maximum of the per-round ratios; its output is `run/analysis-*.txt`.

The lock's waiting messages went to separate `.stderr` files, which this record leaves out, as they name other jobs.

## Results

Every build exits 0, every timed run exits 0, and the trees write the same objects, byte for byte, for both units
(`run/measure.log`).

| `-c` of | instructions | cycles | task clock |
|---|---:|---:|---:|
| `sqlite3.c` | −55,822 (−0.004%) | −0.35% (−1.19% to +0.22%) | −0.41% (−1.16% to −0.03%) |
| stb_image `-march=native` | +20,899 (+0.011%) | +1.05% (−1.51% to +4.59%) | +1.11% (−0.83% to +3.53%) |

The instructions are the medians of the rounds' means' differences, and the times the per-round ratios' median and
range. Main's medians were 1,350,435,705 instructions, 613.2 M cycles and 130.35 ms for `sqlite3.c`, and 190,468,669
instructions, 72.5 M cycles and 19.02 ms for stb_image. A tree's instructions vary by at most 38 (`sqlite3.c`) and
2,925 (stb_image) within a round.

## Reading

Neither unit calls these builtins. stb_image's 20,899 more instructions are about what ten more rows cost the catalog's
linear scan, which the checker runs once per distinct called name that starts with `__`: its intrinsic headers call
120 x86 builtins' names, none of them the catalog's (120 names × 10 rows at about 17 instructions a row). The bit
builtins' branch (buster#969) skips the scan for `__builtin_ia32_` names; once both merge, those rows cost stb_image
nothing. `sqlite3.c`, which calls few `__` names, runs 55,822 fewer instructions, from code and layout changes this
record doesn't attribute. The time differences are within the rounds' ranges: stb_image's per-round task-clock ratios
run from −0.83% to +3.53%, and its instructions differ by 0.011%.

## Limitations

- The time differences are of one layout of each tree; the instructions are the precise comparison. No placements were
  measured.
- `perf stat` counted user-mode events of the whole process. The instruction differences were attributed by reading the
  code, not by `perf record`.
- The tests ran on the 7940HS, not the 9700X; the 9700X ran the builds and the timings.
