# sqlite3.c's memory first touched in the checker, before and after #572, on the 9700X

Raw evidence for buster's [`docs/compile-time.md`](https://github.com/buster14a/buster/blob/main/docs/compile-time.md),
section "The checker's columns (#572)" (buster14a/buster#572): the C driver's `-c` of SQLite 3.53.2's `sqlite3.c`
before and after #572's changes to what the checker allocates:
- the reader's columns that few tokens have an entry in, its scope stacks and its binding table, in an arena of the
  reader's own that it unmaps when it returns, without clearing; and the driver no longer publishing #113's
  environment (commit `47ac4e05`);
- the expression graph's values for `VALUE` nodes alone, and `check_program`'s labels, worklist and controls in an
  arena of its own (commit `f74414b9`).

The measurements are whole processes, with `--time-stages`' report of each stage's time and peak RSS added, perf's
counters and profile, and the checker's source benchmark.

## Identity

- **Date:** 2026-10-27, from 17:53 to 18:05 UTC (round 1) and from 18:29 to 19:10 UTC (round 2).
- **Host:** `benchpress`, an AMD Ryzen 7 9700X (kernel 6.18.50-2-lts), every step under the host's lock
  (`exclusive.sh`) and pinned to CPU 2.
- **Compilers:** each tree built on the host with `BUSTER_DEBUG_INFO=0 ./build.sh` (clang 23.1.1, `-O3
  -march=native`). The trees, each as `git archive` writes it (`manifest-*.sha256` is its every file's hash):
  - `base`: buster's `d8805cb7436542f16e1015c29f66feb15dac7c81`, main with #573 merged. Its executable's sha256 is
    `f4d5fe07f98eb09716292679b4dbd4a588d2fb24ac05e8d0fc4000252045a63f`.
  - `head1`: round 1's tree, buster's `5adadbe5fbe4330924fa8406aa78345bc5c01e16`, #572's first commit (`47ac4e05`)
    merged with `base`. Its executable's sha256 is
    `4e64ae01660559dfaecf3f9651b488b07e0926aec892518d710698e3f12b7644`.
  - `head2`: round 2's tree, buster's `f74414b95a91a6b937dd8e2a89b864685b017188`, #572's second commit on `head1`.
    Its executable's sha256 is `5b99154347ecec779180511825b32131e8e51a2fa8c3168ae7c5a23031e029bb`.
- **Source:** `sqlite/sqlite3.c` of the frozen corpus `preprocessor-391e729af658`, sha256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
- **Reference for the ratio:** `/usr/bin/tcc` (0.9.28rc), sha256
  `49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082`.
- **Objects:** every tree's object is the same bytes, sha256
  `0c48ff92978c3125b1822a1552eb48d2742ea09d80176488d8dc5320c4afe91f`.

## Commands

The options, for every compile, are #136's speedtest1 record's, as #518's record has them:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

`round1.sh` and `round2.sh` ran each step under the lock:
- the build of each tree;
- the objects of base and the head, compared with `cmp`;
- `measure-compile --runs 21`, the head with base as its `--reference`, then base with the head's. After a warm-up,
  it rotates the default compile, `--time-stages` and the reference for 21 rounds;
- `measure-compile --runs 11 --reference tcc` of the head;
- `perf stat -r 11 -e task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k,branch-misses:u` of
  each, twice, alternating;
- `perf record -q -F 20000` of 5 compiles, reported by DSO and by symbol: in round 1 of both trees, in round 2 of
  the head;
- in round 2, `benchmark-checker-source` of each tree, with the options of the 9700X job's step.

## Results

Round 2, base against `head2`:

| | base | head2 | change |
| --- | ---: | ---: | ---: |
| wall time (`measure-compile`) | 147.06 ms (145.98 to 147.92) | 140.26 ms (139.74 to 141.33) | −6.80 ms (−4.6%) |
| peak RSS | 514,000 KB | 393,140 KB | −120,860 KB (−23.5%) |
| minor faults | 2,251 | 2,265 | +14 |
| task-clock (perf, round 1) | 147.24 ms | 139.93 ms | −5.0% |
| cycles, kernel | 120.3 M | 108.5 M | −9.8% |
| cycles, user | 695.9 M | 667.3 M | −4.1% |
| instructions, user | 1,556.3 M | 1,558.0 M | +0.1% |

- **Reverse order:** base against `head2` measured 146.83 ms against 140.33 ms.
- **Second `perf stat` pair:** 146.66 ms against 139.49 ms, kernel cycles 119.8 M against 107.9 M.
- **Round 1** (`head1`, the reader's change alone): 142.08 ms against 147.34 ms, a peak RSS of 420,904 KB against
  513,052 KB; `perf stat`, twice: task-clock 146.83 and 146.55 ms against 142.41 and 141.80 ms, kernel cycles −6.2%,
  user cycles −2.6%, user instructions 1,556.3 M against 1,549.5 M.
- **Profile.** `clear_page_erms` took 13.00% of `head2`'s samples (round 2) and 14.13% of base's (round 1); the
  kernel 16.66% against 17.65%, and libc, its `memset` mostly, 3.63% against 4.63%.
- **The checker's source benchmark** (round 2): the graph run's vector path took 36.42 ns a body node against
  39.98 ns (201.8 against 221.4 cycles), its scalar twin 46.96 ns against 47.18 ns.

## Integrated base, round 3

The previously queued campaign completed on October 27 at 21:52 UTC. `round3.sh`, `round3.log` and the two
`manifest-*-3.sha256` files (named `manifest-base3.sha256` and `manifest-head3.sha256`) retain the comparison of
main `92c025e71856d13eb34247477c5294d2cead139e` against integration head
`da352e29a9f1206d935b50cc3372cbb839bc2631`. Later `fc103cfe` changes documentation only.
The same host, build flags, locked CPU 2, SQLite source and compile options apply. The objects are identical, with
the same `0c48ff92978c3125...` hash as rounds 1 and 2. Binary hashes are printed at the log's object-comparison step.

| Measure | main `92c025e7` | integrated `da352e29` |
| --- | ---: | ---: |
| 21-run wall median, head-first comparison | 147.074 ms | 140.812 ms |
| 21-run wall median, reverse comparison | 146.980 ms | 141.056 ms |
| peak RSS, first comparison | 512,868 KB | 392,000 KB |
| peak RSS, reverse comparison | 512,864 KB | 392,024 KB |
| user cycles, first perf pair | 692,359,477 | 671,525,183 |
| kernel cycles, first perf pair | 120,166,982 | 108,780,991 |
| user instructions, first perf pair | 1,552,457,457 | 1,554,177,472 |
| user cycles, second perf pair | 692,577,153 | 669,351,747 |
| kernel cycles, second perf pair | 120,004,554 | 108,578,811 |
| vector graph benchmark | 39.748 ns/body node | 36.509 ns/body node |

This integrated comparison lowers wall time by 4.26% and peak RSS by 23.57% in the first comparison; reverse order
confirms the direction. Instructions increase 0.11%, while user and kernel cycles fall. These are measurements of
the named snapshots and workload; they are not additive speedups for other concurrently developed checker PRs.
The original rounds above remain unchanged.

## Probes, on the laptop

`probes/` holds what throwaway builds on the laptop (an AMD Ryzen 9 7940HS, Zen 4) printed while finding where the
memory went, each a patch of the tree named below that printed counts to standard error; the patches aren't buster's
code:
- `columns-main.txt`, main `8fcf19ce`: for each of the reader's token columns, after the reader, the entries that
  differ from what its initialization wrote (a fill of 0xa5 for those it doesn't initialize), and the 4 KB pages
  and 2 MB pages those entries fall in; and the scratch's pushes and high-water at each stage (`probe-stage`).
- `pages-read-or-written.txt`, main `8fcf19ce`: each candidate column in a mapping of its own, in base pages
  without clearing; `touched` is `mincore`'s count of its pages read or written by the reader. Most are read at
  every token, which is why the reader's arena is in huge pages.
- `reader-arena-head.txt`, main `8fcf19ce` with a first version of #572's first commit: the reader's arena's resident
  and huge pages when the reader returns, and the 2 MB pages of each of its columns that hold a nonzero byte.
- `scratch-by-stage-main.txt` (main `8fcf19ce`) and `scratch-by-stage-head.txt` (`head1`'s tree): the scratch's
  pages each stage touches, read with `mincore` at the stage's end and released with `MADV_DONTNEED` before the
  next, by 16 MB (main) or 4 MB (head) of the arena.

## Files

- `round1.sh`, `round2.sh`: the runs; `round1.log`, `round2.log`: their output, without `exclusive.sh`'s waiting
  messages, which name other sessions' commands (`strip_lock.py`, #528's record's filter with step headings added).
- `manifest-base.sha256`, `manifest-head1.sha256`, `manifest-head2.sha256`: the trees' files.
- `probes/`: above.
- `SHA256SUMS`: this directory's files.
