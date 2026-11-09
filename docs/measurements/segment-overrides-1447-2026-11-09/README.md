# Segment overrides in Tier 0's typed stream, Buster #1447 (PR #1870)

PR [#1870](https://github.com/buster14a/buster/pull/1870) adds a segment override to the typed stream's LOAD, STORE and
SET (`Tier0Function.segments`); a function without one pays a flag test on Tier 0's compile and validation. This record
checks that segment-free code is unchanged, base against head, on the 9700X.

## Sources and host

- **main:** `cb608c1f616f8fe26234bcaaa869caccc571de63`, the branch's base.
- **head:** `4a2dd72cb5a58f688fd51c1462b9172708c14b68`, #1870's first commit. Its later commits
  (`b8bf5c6`, `14a68db`, and the test's host-feature guard) touch only the segment route and `test-tier0`.

Each tree was a fresh clone at its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh` under the host's lock
(`logs/build-*.log`); executables' SHA-256 are in `logs/receipt.txt` with the CPU (AMD Ryzen 7 9700X), kernel, clang
23.1.1 and CPU 2's governor (performance). Inputs: the 9700X job's frozen `sqlite3.c`
(`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, with the job's `-D` options) and the head
tree's `src/buster/compiler/main.c` (`-c -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing`), the same
source for both compilers.

## Method

- `scripts/all.sh` (with `scripts/env.sh`): both builds, then `-c` of each input by both trees pinned to CPU 2
  (`logs/compile.log`), and the objects' SHA-256 (`logs/objects.sha256`).
- `scripts/ab1.sh`, in one hold of the lock: three rounds, each tree and input in turn, `perf stat -e
  instructions:u,cycles:u,task-clock` of the same `-c` pinned to CPU 2 (`logs/perf1.tsv`). An earlier per-run-lock
  attempt (`scripts/measure.sh`, `logs/perf.tsv`) was stopped after its first runs at the coordinator's request to
  hold the shared lock once; its rows agree.

## Results

- **Objects:** byte-identical base vs head: sqlite3.c `5c6e1e7b…a628ca`, main.c `7ab5b4f8…e21257`.
- **Instructions** (user): sqlite3.c 1,259,180,763–816 (main) vs 1,259,460,870–875 (head), +280,100 (+0.022%); main.c
  29,328,427,678–453,922 vs 29,328,703,837–728,035, +280,000 (+0.001%). The same ~280,000 on both inputs, whose
  function counts differ by an order of magnitude, so a fixed per-process cost, not one per function.
- **Time** (task-clock, ms, three rounds): sqlite3.c 116.66/116.66/116.18 (main) vs 117.02/116.65/116.17 (head);
  main.c 2204.2/2185.6/2186.8 vs 2181.9/2186.5/2189.3. No difference past the rounds' spread.

## Limitations

Three rounds on a lock shared with CI; the timing claim is only that no difference shows at this spread. The
fixed instruction delta is not attributed to a function.
