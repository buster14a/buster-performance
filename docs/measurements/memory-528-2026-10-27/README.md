# sqlite3.c's memory first touched, before and after #528, on the 9700X

Raw evidence for buster's [`docs/compile-time.md`](https://github.com/buster14a/buster/blob/main/docs/compile-time.md),
section "Memory first touched (#528)" (buster14a/buster#528): the C driver's
`-c` of SQLite 3.53.2's `sqlite3.c` before and after three changes to what it
allocates. They are:
- the type table in base pages;
- lane 0's writer's columns in base pages of their own;
- a parse's temporaries in the checker's scratch.

The measurements are whole processes, with `--time-stages`' report of each
stage's time and peak RSS added, and perf's counters and profile.

## Identity

- **Date:** 2026-10-27, from 12:18 to 12:41 UTC.
- **Host:** `benchpress`, an AMD Ryzen 7 9700X (kernel 6.18.50-2-lts), every
  step under the host's lock (`exclusive.sh`) and pinned to CPU 2.
- **Compilers:** each tree built on the host with `BUSTER_DEBUG_INFO=0 ./build.sh`
  (clang 23.1.1, `-O3 -march=native`). The trees:
  - `base`: buster's `ea673e4bd6a60f69b17e74c1ce3d9bd1edc1aa73`, the head of
    PR #520 (main `ad408cf2` with the stage clock and `measure-compile`), as
    `git archive` writes it (`manifest-base.sha256` is its every file's hash).
    Its executable's sha256 is
    `187db5557e65c8edec8d95b7d9136116f42a74081c609d84bae0aa489ac00169`.
  - `head`: round 1's tree, base with the three changes, lane 0's whole
    scratch in base pages (`manifest-head.sha256`). Its executable's sha256 is
    `d43acd242863517c2eb7f9822e988163cf25c14479c043050beb0aaddeef9638`.
  - `head2`: round 2's tree, base with the three changes, only lane 0's
    writer's columns in base pages (`manifest-head2.sha256`). Its executable's
    sha256 is `4b8d6f06d40fb9f2625b2650b882b4a2ae348538ee37197abe3c16f9c4753d6c`.
    It is the tree of buster's commit `a8d788a5` (#528's branch) but for three
    comments: `c_parser.c`'s two on the kernels' reservation, and the figure
    37 MB, which the branch's `c_check_program_emit.c` and
    `docs/function-lanes.md` give as round 2's 46 MB.
- **Source:** `sqlite/sqlite3.c` of the frozen corpus
  `preprocessor-391e729af658`, sha256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
- **Reference for the ratio:** `/usr/bin/tcc`, sha256
  `49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082`.
- **Objects:** base's and head2's objects are the same bytes, sha256
  `0c48ff92978c3125b1822a1552eb48d2742ea09d80176488d8dc5320c4afe91f`, and so
  are base's and head's (round 1's `cmp`).

## Commands

The options, for every compile, are #136's speedtest1 record's
(`speedtest1-136-2026-10-26`), as #518's record has them:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

`round1.sh` and `round2.sh` ran each step under the lock:
- the build of each tree;
- the objects of base and the head, compared with `cmp`;
- `measure-compile --runs 21`, the head with base as its `--reference`, then
  base with the head's. After a warm-up, it rotates the default compile,
  `--time-stages` and the reference for 21 rounds;
- `measure-compile --runs 11 --reference tcc` of the head, and in round 1 of
  base;
- `perf stat -r 11 -e task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u`
  of each, in round 2 twice, alternating;
- in round 2, `perf record -q -F 20000` of 5 compiles of each, reported by DSO
  and by symbol.

Round 2's first `measure-compile` steps failed: the host's `/tmp` was full
for a moment ("can't make a directory under /tmp"), and the run was stopped.
`round2-measurements.sh` ran its measurements again, appending to the same log,
with `--directory` in the run's own directory.

## Files

- `round1.sh`, `round2.sh` and `round2-measurements.sh`: the scripts, as run.
- `round1.log` and `round2.log`: their output. The lock's waiting messages,
  which name other sessions' commands, are removed: by `strip_lock.py`, a later
  version of
  [`window-tables-lines-451-2026-10-26/review/strip_lock.py`](../window-tables-lines-451-2026-10-26/review/strip_lock.py)
  that drops a holder's command over several lines, then the owner lines that
  `perf stat`'s `tail` left without their first line.
- `manifest-base.sha256`, `manifest-head.sha256` and `manifest-head2.sha256`:
  each tree's files' hashes, as measured.
- `strip_lock.py`: the filter.
- `SHA256SUMS`: the files' hashes.

## Results

Round 2, head2 against base (`measure-compile`, medians of 21):

| | base | head2 | change |
| --- | ---: | ---: | ---: |
| wall time | 190.076 ms (188.707 to 191.608) | 184.042 ms (183.183 to 185.727) | −6.0 ms (−3.2%) |
| peak RSS | 673,248 KB | 512,576 KB | −160,672 KB (−23.9%) |
| minor faults | 1,547 | 2,258 | +711 |

Base against head2 gave 190.470 ms against 184.329 ms.

`perf stat -r 11`, the first of each pair:

| | base | head2 | change |
| --- | ---: | ---: | ---: |
| task-clock | 189.78 ms | 184.17 ms | −3.0% |
| page faults | 1,356 | 2,082 | +726 |
| cycles, user | 896.2 M | 901.0 M | +0.5% |
| instructions, user | 2,227.30 M | 2,227.11 M | 0.0% |
| cycles, kernel | 156.3 M | 120.3 M | −23.0% |
| instructions, kernel | 37.80 M | 37.13 M | −1.8% |

The second pair agreed: 189.70 ms against 183.83 ms; kernel cycles 155.9 M
against 119.5 M.

In the profiles, the kernel fell from 17.6% of the samples to 13.7%, and
`clear_page_erms` from 14.8% to 10.9%. glibc rose from 3.9% to 5.2%, most of it
the AVX-512 loop of `memset` at `libc.so.6+0x18fc80` (four `vmovdqa64` stores
an iteration, read with `objdump -d`), from about 2.9% of the samples to 4.4%.
The checker's reader zeroes its columns over pages the parse touched rather
than fresh ones the kernel cleared just before.

Round 1's head, with all of lane 0's scratch in base pages, measured 185.849 ms
against base's 189.791 ms, with a peak RSS of 519,532 KB. Its Tier 0 stage took
5.732 ms against base's 5.148, as Tier 0's arrays faulted base pages, which
head2 keeps in the caller's scratch.

Every run's `-c` and `--time-stages` objects were the same bytes
(`measure-compile: 0 failures`).
