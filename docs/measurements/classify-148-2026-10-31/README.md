# The floating classifications, Buster #148

Compiler branch: `claude/148-float-classify` of buster14a/buster, for
[the #148 claim](https://github.com/buster14a/buster/issues/148#issuecomment-6525264816)'s item 3: clang 23's
`__builtin_isnormal`, `issubnormal`, `iszero`, `issignaling` and `isfpclass` (of vectors too), `signbitf` and
`signbitl`, and `canonicalize`, `canonicalizef` and `canonicalizel`, checked, folded and lowered as clang does.

This record keeps the cost on the 9700X of what the branch adds to every unit: ten catalog rows that the checker's and
the preprocessor's lookups scan, and the float family's tests, which every call of a unit may ask. `-c` of the frozen
`sqlite3.c` and of stb_image at `-march=native`, neither of which calls one of these builtins: main against the head,
by instructions and time with one executable per tree, three times: the first head against its base (`run/`), the
branch's merge of a newer main against that main (`merged/`), and the final head, whose catalog rows moved last in the
table, against the same main (`final/`).

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **main:** `693926a7a99a0df9f520b36b9d13a373bf34ad9e`, the branch's base;
- **head:** `6c7f6c36108de547c2efecf51f73849073a7435c`, the classifications (`d7d9b903`) and `isfpclass` of a vector;
- **new main:** `b651971a8a8cfbef778d3ced8c409809ef94f6fe`, main with the bit builtins (buster#969) and three other merges;
- **merge:** `87763bfead26d51c88cbb912d09f6a9f33563ac2`, the head with the new main merged into it;
- **final head:** `14be3b647c22a8c637b32f37ef73ae6ce3db0acb`, the merge with the classifications' ten rows moved to the
  catalog's end.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path in the C
locale), and `manifests/compare.txt` the comparison with the trees on the 9700X. stb_image is the unit of the earlier
records' (`stb/stb_image.c`, SHA-256 `40bcca3e…`, including `stb_image.h`, `594c2fe3…`, stb_image 2.30, with
`STB_IMAGE_IMPLEMENTATION`); `run/measure.log` has both files' SHA-256.

## Method

`scripts/queue.sh` built both trees (`scripts/build-tree.sh`, `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job
builds) and ran `scripts/measure.sh`, each in a hold of the host's lock of its own; `scripts/queue-merged.sh` did the
same for the new main and the merge, and `scripts/queue-final.sh` built the final head and measured it against the
same new main executable. `measure.sh` takes two trees and, in
one hold, logs the receipts (the date, `uname -a`, the CPU, CPU 2's governor, clang's and perf's versions, the lock's
owner line, the trees' commits, and the SHA-256 of both executables and of the inputs), compiles each unit with each
tree once (its status, and the two objects compared), then runs 8 rounds in which each tree, in an order alternated by
round, compiles each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`, pinned to CPU 2, each run's
exit status beside its counters. The units:

- `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`
  of the frozen SQLite amalgamation, the 9700X job's compile-time step's command;
- `-c -march=native -I stb stb/stb_image.c`.

`scripts/analyze.py` takes each round's mean of a tree's runs, then the median of the rounds' means and the median,
minimum and maximum of the per-round ratios; its output is `*/analysis-*.txt`.

The lock's waiting messages went to separate `.stderr` files, which this record leaves out, as they name other jobs.

## Results

Every build exits 0, every timed run exits 0, and the trees write the same objects, byte for byte, for both units
(`run/measure.log`, `merged/measure.log`, `final/measure.log`).

| `-c` of | head | instructions | cycles | task clock |
|---|---|---:|---:|---:|
| `sqlite3.c` | first | −55,822 (−0.004%) | −0.35% (−1.19% to +0.22%) | −0.41% (−1.16% to −0.03%) |
| | merge | +5,454 (+0.0004%) | −1.02% (−1.42% to −0.39%) | −0.77% (−1.07% to −0.33%) |
| | final | +5,242 (+0.0004%) | −0.11% (−0.41% to +0.07%) | −0.17% (−0.36% to +0.13%) |
| stb_image `-march=native` | first | +20,899 (+0.011%) | +1.05% (−1.51% to +4.59%) | +1.11% (−0.83% to +3.53%) |
| | merge | +18,399 (+0.0097%) | −1.08% (−1.66% to +0.24%) | −0.32% (−0.94% to +0.46%) |
| | final | +11,557 (+0.0061%) | −0.18% (−1.90% to +0.09%) | −0.11% (−1.51% to +0.09%) |

The first head is against main `693926a7`, the merge and the final head against the new main `b651971a`. The
instructions are the medians of the rounds' means' differences, and the times the per-round ratios' median and range.
Main's medians in the first run were 1,350,435,705 instructions, 613.2 M cycles and 130.35 ms for `sqlite3.c`, and
190,468,669 instructions, 72.5 M cycles and 19.02 ms for stb_image; the new main's in the final run 1,349,154,379,
608.8 M and 129.43 ms, and 190,013,257, 71.8 M and 18.92 ms. A tree's instructions vary by at most 62 (`sqlite3.c`) and
2,925 (stb_image) within a round.

## Reading

Neither unit calls these builtins. The first run's reading of stb_image's 20,899 more instructions was the catalog's
scan of its 120 x86 builtins' names, ten rows longer, which the bit builtins (buster#969) skip; the merged run, against
a main with that skip, still shows 18,399, so that reading was wrong. The catalog is a linear table that the checker
scans once per distinct called name starting with `__` and the preprocessor for each name `__has_builtin` asks about,
and the ten rows sat before the vector builtins' and the atomics': every lookup of a name after them read ten more rows.
The final head puts them last, where only lookups of names that no row has read them: 6,842 instructions fewer than the
merge on stb_image, about what the same move saved on the 7940HS (6,900). The 11,557 left are unattributed: lookups of
names that no row has, and code the family's calls run. Every time difference is within the rounds' ranges.

## Limitations

- The time differences are of one layout of each tree; the instructions are the precise comparison. No placements were
  measured.
- `perf stat` counted user-mode events of the whole process. The instruction differences were attributed by reading the
  code, not by `perf record`.
- The tests ran on the 7940HS, not the 9700X; the 9700X ran the builds and the timings.
