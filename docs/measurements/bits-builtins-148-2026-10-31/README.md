# The bit builtins, Buster #148

Compiler branch: `claude/148-builtins-misc` of buster14a/buster, for
[the #148 claim](https://github.com/buster14a/buster/issues/148#issuecomment-6525264816)'s item 3: clang 23's typed
overflow builtins (`__builtin_sadd_overflow` to `__builtin_umulll_overflow`) and its other bit builtins (`bitreverse8`
to `64` and `bitreverseg`, `bswapg`, `clrsb`, `clzs`, `ctzs`, `popcountg`, `clzg`, `ctzg`, C23's `__builtin_stdc_`
ones and the carry chains `addcb` to `subcll`), checked, folded and lowered as clang does.

This record keeps the cost on the 9700X of what the branch adds to every unit: catalog rows that the checker's and the
preprocessor's lookups scan, and family tests that every call of a unit asks. `-c` of the frozen `sqlite3.c` and of
stb_image at `-march=native`, neither of which calls one of these builtins: main against the head, by instructions and
time with one executable per tree, three times: the first head (`first/`), whose lookups the next version guarded, the
final one (`final/`), and after main moved on (the library builtins, buster#966, among it) the branch's merge of main
against that main (`merged/`).

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **main:** `bc8606055dd8c8595a99a0c7333027144a86dfaa`, the branch's base;
- **first head:** `6c72482ac4c4a448bdd60c15b30ecf0ea6295d66`, the typed overflow builtins and the bit builtins;
- **final head:** `46c87874d0e8fc7ef4473fdebc0e8b136d3a1702`, the same with the lookups guarded:
  `check_graph_builtin_op` answers an ordinary call's id at once, `check_builtin_typed_overflow_info` scans its table
  only for its family's ids, and `cbuiltin_entry` skips the catalog's scan for clang's x86 builtins' names;
- **new main:** `693926a7a99a0df9f520b36b9d13a373bf34ad9e`, main with the library builtins (buster#966) and four other
  merges;
- **merge:** `b5d6f55c805fd5e70bba23afa39736f1f10b594b`, the final head with the new main merged into it.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path in the C
locale), and `manifests/compare.txt` the comparison with the trees on the 9700X. stb_image is the unit of the earlier
records' (`stb/stb_image.c`, SHA-256 `40bcca3e…`, including `stb_image.h`, `594c2fe3…`, stb_image 2.30, with
`STB_IMAGE_IMPLEMENTATION`); `first/measure.log` has both files' SHA-256.

## Method

`scripts/queue.sh` built main and the first head (`scripts/build-tree.sh`, `BUSTER_DEBUG_INFO=0 ./build.sh`, as the
9700X job builds) and ran `scripts/measure.sh`, each in a hold of the host's lock of its own; `scripts/queue-final.sh`
did the same for the final head against the same main executable, and `scripts/queue-merged.sh` built the new main and
the merge and measured one against the other. `measure.sh` takes two trees and, in one hold, logs
the receipts (the date, `uname -a`, the CPU, CPU 2's governor, clang's and perf's versions, the lock's owner line, the
trees' commits, and the SHA-256 of both executables and of the inputs), compiles each unit with each tree once (its
status, and the two objects compared), then runs 8 rounds in which each tree, in an order alternated by round, compiles
each unit 3 times under `perf stat -e instructions:u,cycles:u,task-clock`, pinned to CPU 2, each run's exit status
beside its counters. The units:

- `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`
  of the frozen SQLite amalgamation, the 9700X job's compile-time step's command;
- `-c -march=native -I stb stb/stb_image.c`.

`scripts/analyze.py` takes each round's mean of a tree's runs, then the median of the rounds' means and the median,
minimum and maximum of the per-round ratios; its output is `*/analysis-*.txt`.

The lock's waiting messages went to separate `.stderr` files, which this record leaves out, as they name other jobs.

## Results

Every build exits 0, every timed run exits 0, and the trees write the same objects, byte for byte, for both units
(`first/measure.log`, `final/measure.log`, `merged/measure.log`).

| `-c` of | head | instructions | cycles | task clock |
|---|---|---:|---:|---:|
| `sqlite3.c` | first | +510,238 (+0.038%) | +0.53% (+0.22% to +0.86%) | +0.31% (+0.11% to +0.58%) |
| | final | −1,362,771 (−0.101%) | −0.14% (−0.54% to +0.03%) | −0.22% (−0.37% to −0.06%) |
| | merge | −1,392,284 (−0.103%) | −0.80% (−0.91% to −0.33%) | −0.74% (−1.02% to −0.36%) |
| stb_image `-march=native` | first | +231,849 (+0.122%) | −0.39% (−0.67% to −0.03%) | −1.09% (−1.70% to −0.82%) |
| | final | −467,801 (−0.246%) | −1.09% (−2.53% to −0.40%) | −1.41% (−3.02% to −0.75%) |
| | merge | −486,627 (−0.255%) | −0.68% (−1.35% to +0.09%) | −0.98% (−1.24% to −0.14%) |

The first and final heads are against main `bc860605`, and the merge against the new main `693926a7`.

The instructions are the medians of the rounds' means' differences, and the times the per-round ratios' median and
range. Main's medians in the first run were 1,349,008,266 instructions, 607.0 M cycles and 129.43 ms for `sqlite3.c`,
and 190,196,422 instructions, 72.2 M cycles and 19.11 ms for stb_image; in the final run 1,349,007,614, 608.7 M and
129.56 ms, and 190,196,643, 72.2 M and 19.14 ms; and the new main's in the merged run 1,350,435,354, 610.7 M and
129.90 ms, and 190,501,407, 72.1 M and 19.03 ms. A tree's instructions vary by at most 87 (`sqlite3.c`) and 2,901
(stb_image) within a round.

## Reading

The first head's instructions were work the units don't need: neither calls one of these builtins. Two lookups that
every unit pays for grew. `check_graph_builtin_op`, which the reader asks for every call (about 85,000 in `sqlite3.c`),
tested each builtin family in turn even for an ordinary call's id 0, among them the typed overflow builtins' scan of
their 18-row table, which the first commit added, and the bit builtins' range. And the catalog's linear scan, which
the checker runs once per distinct called name that starts with `__`, grew by 57 rows: stb_image's intrinsic headers
call 120 x86 builtins' names, which the scan never finds. The final head answers id 0 at once, scans the typed
overflow table only for its family's ids, and skips the catalog's scan for `__builtin_ia32_` names, none of its own.

The final head runs 1,362,771 fewer instructions than main on `sqlite3.c` and 467,801 fewer on stb_image, into the
same objects: the early answer for id 0 saves main's own family tests too. Its task clock is 0.22% below main's on
`sqlite3.c` and 1.41% below on stb_image, every round's ratio below 1.

The merge keeps that difference against the new main, whose library builtins add their own tests to the same lookups:
1,392,284 fewer instructions on `sqlite3.c` and 486,627 fewer on stb_image, into the same objects, and a task clock
0.74% and 0.98% below the new main's, every round's ratio below 1.

## Limitations

- The time differences are of one layout of each tree; the instructions are the precise comparison. No placements were
  measured.
- `perf stat` counted user-mode events of the whole process. The first head's extra instructions were attributed by
  reading the code and confirmed by the guarded build's instruction counts on the 7940HS (Zen 4), not by `perf record`.
- The tests ran on the 7940HS, not the 9700X; the 9700X ran the builds and the timings.
