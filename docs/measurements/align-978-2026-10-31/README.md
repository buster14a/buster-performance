# Arrays of 16 bytes or more aligned to 16, Buster #978

Compiler branch: `claude/978-array-alignment` of buster14a/buster, for
[#978](https://github.com/buster14a/buster/issues/978): a global, static, thread-local or local array of 16 bytes or
more, whose declaration has no alignment attribute, aligned to at least 16 bytes, as the x86-64 psABI and clang align it.
Before, static data and frames gave such an array its element's alignment, and clang -O2's aligned stores into it
faulted.

This record keeps what the change costs on the 9700X: `-c` of the frozen `sqlite3.c` and of stb_image at
`-march=native`, main against the head, by instructions and time with one executable per tree. Their objects differ by
design: arrays of 16 bytes or more move to 16-byte boundaries.

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **main:** `b651971a8a8cfbef778d3ced8c409809ef94f6fe`, the branch's base. Its tree and build are the floating
  classifications' record's (`classify-148-2026-10-31`, buster-performance#179, its `main2`), linked here as `main`;
- **head:** `86b87d77da55bb1cbe79ebc71932b8fcea0fd70d`, the fix.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path in the C
locale), and `manifests/compare.txt` the comparison with the trees on the 9700X. stb_image is the earlier records' unit
(`stb/stb_image.c`, SHA-256 `40bcca3e…`, including `stb_image.h`, `594c2fe3…`, stb_image 2.30, with
`STB_IMAGE_IMPLEMENTATION`); `run/measure.log` has both files' SHA-256.

## Method

`scripts/queue.sh` built the head (`scripts/build-tree.sh`, `BUSTER_DEBUG_INFO=0 ./build.sh`, as the 9700X job builds)
and ran `scripts/measure.sh` against main's build, each in a hold of the host's lock of its own. `measure.sh` takes two
trees and, in one hold, logs the receipts (the date, `uname -a`, the CPU, CPU 2's governor, clang's and perf's versions,
the lock's owner line, the trees' commits, and the SHA-256 of both executables and of the inputs), compiles each unit
with each tree once (its status, the two objects compared, and each object's text, data and read-only sections' sizes
and alignments), then runs 8 rounds in which each tree, in an order alternated by round, compiles each unit 3 times
under `perf stat -e instructions:u,cycles:u,task-clock`, pinned to CPU 2, each run's exit status beside its counters.
The units:

- `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<its directory>`
  of the frozen SQLite amalgamation, the 9700X job's compile-time step's command;
- `-c -march=native -I stb stb/stb_image.c`.

`scripts/analyze.py` takes each round's mean of a tree's runs, then the median of the rounds' means and the median,
minimum and maximum of the per-round ratios; its output is `run/analysis-*.txt`.

## Results

Every build exits 0 and every timed run exits 0 (`run/measure.log`, `run/analysis-*.txt`).

| `-c` of | instructions | cycles | task clock |
|---|---:|---:|---:|
| `sqlite3.c` | +110,826 (+0.0082%) | −0.29% (−0.47% to +0.10%) | −0.25% (−0.52% to +0.22%) |
| stb_image `-march=native` | +9,318 (+0.0049%) | +0.32% (−0.34% to +0.98%) | +0.29% (−0.16% to +0.77%) |

The instructions are the medians of the rounds' means' differences, and the times the per-round ratios' median and
range. Main's medians were 1,349,154,277 instructions, 610.7 M cycles and 129.80 ms for `sqlite3.c`, and 189,992,016
instructions, 72.0 M cycles and 18.96 ms for stb_image. A tree's instructions vary by at most 37 (`sqlite3.c`) and 2,644
(stb_image) within a round.

The objects differ where the units define arrays of 16 bytes or more (`run/measure.log`'s sections): `sqlite3.c`'s
`.rodata`, `.data.rel.ro` and `.data` now have 16-byte alignment and 335, 48 and 80 more bytes, and its `.text` 16 more
bytes; stb_image's `.rodata` and `.data` have 16-byte alignment and 37 and 20 more bytes, and the same `.text`.

## Reading

The rule runs once per static object and once per local declaration (`type_large_array`), and the larger sections take
more padding; the instructions were not attributed further. Every time difference is within the rounds' ranges.

## Limitations

- The time differences are of one layout of each tree; the instructions are the precise comparison. No placements were
  measured.
- `perf stat` counted user-mode events of the whole process.
- The tests ran on the 9700X too, from separate copies of the trees, each in a hold of its own.
