# Tier 1's remaining refusals (buster#141), 2026-11-03

Evidence for [buster#1204](https://github.com/buster14a/buster/pull/1204), which removes the Tier 1 refusals claimed on
[buster#141](https://github.com/buster14a/buster/issues/141). It covers:
- 128-bit integers;
- long double on the x87;
- the calling convention's rarer aggregate shapes and the aggregates it ignores;
- the IR's vectors;
- two follow-up commits that cut what the long double and vector support costs code that uses neither.

Everything below ran on the Ryzen 7 9700X (benchpress). Each build and each measurement held
`~/buster-fast-bench/exclusive.sh` once (owner `claude-141-wide`), and every timed process was pinned to CPU 2.

The files are in `9700x/`:
- Lock-wait lines are removed from the logs.
- The trees, executables, objects, databases and perf data are left out.
- `9700x/patches/` holds every measured tree's source as patches (below).

The test-suite results in the cloud container are in buster#1204's description, not here.

## Revisions, trees and setup

The series was measured as committed on main `9f3610a9`, before the rebase onto main `703ae9f5`. The rebase changed no
file of the series. The follow-up commits were measured on the rebased trees.

| Tree | Revision | What it is |
| --- | --- | --- |
| `base-9f3610a9` | `9f3610a9` | main before the series (buster#1190's head) |
| `head-efb954e9` | `efb954e9` | 128-bit integers (rebased: `f8bff99e`) |
| `head-51e969b9` | `51e969b9` | long double (rebased: `93121b23`) |
| `head-0c76601d` | `0c76601d` | x87 aggregates (rebased: `a8d78db3`) |
| `head-f27c103c` | `f27c103c` | the rarer shapes' first version, before the whole-vector-part fix (`patches/f27c103c.patch`) |
| `head-6cea6c24`, `head-73ad6e13` | `6cea6c24`, `73ad6e13` | ignored aggregates' first versions, per-call reads of argument locations (patches) |
| `head-734aff5b` | `734aff5b` | ignored aggregates as committed, on `fb8e4d4a`, the rarer shapes as committed (rebased: `a934e808`, `6dad4b23`) |
| `head-9004e177` | `9004e177` | the IR's vectors (SSA promotion, SCCP, DCE, CFG cleanup; rebased: `1794ac13`) |
| `head-b4401c64` | `b4401c64` | the IR's vectors with SCCP gated by a per-prepare scan (iteration, patch) |
| `head-7571f289`, `head-a917e5e2`, `head-ba5bfd5c` | as named | Tier 1's vectors, iterations (patches; `7571f289` is on `ddf8977a`, an iteration of the IR commit) |
| `head-15929849` | `15929849` | Tier 1's vectors as committed (rebased: `c27be772`) |
| `head-1794ac13`, `head-c27be772` | `1794ac13`, `c27be772` | the rebased IR and Tier 1 vector commits, on main `703ae9f5` |
| `head-vpat` | `c27be772` + `patches/vpat.patch` | experiment: selection's vector candidates out of line (not taken) |
| `head-vscan` | `97806049` | commit 8: one scan for vectors per function |
| `head-ldscan` | `9862b563` | commit 9: one scan for long doubles per function |

- `patches/series-9f3610a9..15929849.patch` is the series as measured. `patches/series-703ae9f5..9862b563.patch` is the
  rebased series with commits 8 and 9. The trees `head-vscan` and `head-ldscan` were copied from the working tree before
  their commits; their changed files hash to `97806049`'s and `9862b563`'s.
- Each tree was built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`build.sh`; logs in `logs-build/`), the repository's
  build before the CMake cutover (buster#1191).
- Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9.
- `common.sh` has the paths, the options and the lock's metadata.
- Inputs:
  - the frozen `sqlite3.c` 3.53.2 (`~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`, SHA-256
    `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), with
    `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`. It has no
    long double, vector, x87 aggregate or rare aggregate shape, and two 128-bit products;
  - speedtest1 with that `sqlite3.c` (#136's unity harness, `speedtest1-unity.c`, SHA-256
    `eadb487f20f2bb4b383ad25078b0677a97d04f06204325cd9ab34665efbac1d5`), run as
    `--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1`.

## Each step against its parent (`measure.sh`)

`measure.sh BASE HEAD` (outputs in `measure-HEAD/`):
1. Each tree's `--tier1 --tier1-report --tier1-refusals -c` of `sqlite3.c`, and the head's with `--tier1-strict`
   (`reports/`).
2. `ab` of `--tier1 -c sqlite3.c`, 5 rounds of 21 runs (`compile-tier1-ab.log`). The table gives the median of the
   rounds' medians.
3. `perf stat -e instructions:u,cycles:u`, 11 runs a hold, 3 holds per tree (`compile-stat-*.csv`). The table gives
   the mean of the holds.
4. A `perf record` of the head (`perf-report-*.txt`, cycles at 20 kHz, one compile).
5. speedtest1 built by the base's and the head's `--tier1` (`st-t1base`, `st-t1`) and by the head's Tier 0 (`st-t0`).
   Each runs `--verify`, then 11 rounds of the three in a rotating order, each from a fresh database on tmpfs (`st/`).
6. The head's `test-tier1-wide` (and from `15929849`, `test-tier1-masks`), natively.

| Step | Tier 1 functions | Instructions | Cycles | Wall (ms) |
| --- | --- | --- | --- | --- |
| `9f3610a9` → `efb954e9` | 2,666 → 2,668 | 5,895.42 M → 5,895.09 M | 2,386.88 M → 2,393.68 M | 449.12 → 450.16 |
| `efb954e9` → `51e969b9` | 2,668 | 5,895.09 M → 5,910.34 M | 2,392.15 M → 2,390.65 M | 449.76 → 449.61 |
| `51e969b9` → `734aff5b` | 2,668 | 5,910.34 M → 5,912.10 M | 2,390.32 M → 2,393.84 M | 449.55 → 450.28 |
| `734aff5b` → `15929849` | 2,668 | 5,912.10 M → 5,923.77 M | 2,393.68 M → 2,404.20 M | 450.25 → 452.12 |

- At `9f3610a9` Tier 1 refuses `sqlite3Multiply128` and `sqlite3Multiply160`; from `efb954e9` on it compiles all 2,668
  functions, and `--tier1-strict` exits 0.
- From `efb954e9` on, each step's `--tier1` object is byte-identical to its parent's (`cmp` of
  `/tmp/claude-141-wide/report-*.o`). So the later rows measure only what the new support costs code without it.
- speedtest1's medians (µs, `st/times.txt`):

  | Step | Base's Tier 1 | Head's Tier 1 | Head's Tier 0 |
  | --- | ---: | ---: | ---: |
  | `efb954e9` | 207,068 | 208,370 | 256,178 |
  | `51e969b9` | 208,846 | 208,183 | 257,381 |
  | `734aff5b` | 208,133 | 208,156 | 264,201 |
  | `15929849` | 207,664 | 208,418 | 255,547 |

  - At the last two steps the base's and the head's Tier 1 executables are byte-identical (`cmp`), yet their medians
    differ by up to 0.36%. That is the noise floor of this comparison.
  - Every build's `--verify` prints `Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`.
- The iterations, measured the same way:

  | Head (base) | Instructions | Wall (ms) |
  | --- | --- | --- |
  | `6cea6c24` (`51e969b9`) | 5,910.34 M → 5,914.89 M | 449.74 → 451.50 |
  | `7571f289` (`73ad6e13`) | 5,912.04 M → 5,926.50 M | 451.10 → 451.47 |
  | `a917e5e2` (`734aff5b`) | 5,912.10 M → 5,930.55 M | 450.26 → 452.26 |
  | `ba5bfd5c` (`734aff5b`) | 5,912.10 M → 5,926.61 M | 450.19 → 451.62 |

  - `6cea6c24` read every call's argument locations. `734aff5b` replaced that with one vectorized scan per function.
    The three aggregate commits' cost against `51e969b9` went from +4.55 M (`6cea6c24`'s stack) to +1.76 M
    (`734aff5b`'s).
  - `a917e5e2` gated SCCP by a scan per prepare. `ba5bfd5c` and `15929849` restructured selection behind one
    `vector_node` test.

## `perf stat` alone (`bisect.sh`)

`bisect.sh TREE...`: `perf stat` of each tree's `--tier1 -c sqlite3.c`, 11 runs a hold, 3 rounds in an order that
rotates by round. Then a `perf record` (cycles at 20 kHz, 5 compiles) of the first and the last tree. Means of the holds:

| Directory | Tree | Instructions | Cycles |
| --- | --- | --- | --- |
| `bisect/` (first run) | `51e969b9` | 5,910.34 M | 2,390.84 M |
| | `0c76601d` | 5,911.52 M | 2,402.66 M |
| | `f27c103c` | 5,912.49 M | 2,418.19 M |
| | `6cea6c24` | 5,914.89 M | 2,399.95 M |
| `bisect2/` | `51e969b9`, `6cea6c24`, `73ad6e13` | 5,910.34 M, 5,914.89 M, 5,912.03 M | 2,390.13 M, 2,399.08 M, 2,397.20 M |
| `bisect3/` | `734aff5b`, `b4401c64`, `a917e5e2`, `ba5bfd5c` | 5,912.10 M, 5,917.21 M, 5,930.55 M, 5,926.61 M | 2,394.28 M, 2,394.47 M, 2,405.69 M, 2,402.18 M |
| `bisect4/` | `734aff5b`, `9004e177`, `b4401c64` | 5,912.10 M, 5,913.45 M, 5,917.21 M | 2,394.72 M, 2,391.74 M, 2,394.77 M |
| `bisect5/` | `734aff5b`, `9004e177`, `ba5bfd5c`, `15929849` | 5,912.10 M, 5,913.45 M, 5,926.61 M, 5,923.77 M | 2,394.35 M, 2,390.30 M, 2,402.24 M, 2,402.87 M |
| `bisect/` (sixth run) | `1794ac13`, `c27be772`, `vpat` | 5,841.01 M, 5,851.32 M, 5,850.95 M | 2,383.04 M, 2,385.17 M, 2,397.33 M |
| `bisect7/` | `c27be772`, `vscan` | 5,851.33 M, 5,847.94 M | 2,383.80 M, 2,392.40 M |
| `bisect8/` | `vscan`, `ldscan` | 5,847.94 M, 5,842.79 M | 2,391.26 M, 2,388.95 M |

- `bisect5/` splits the vectors' cost:
  - the IR commit `9004e177`: +1.35 M instructions, −0.17% cycles;
  - Tier 1's commit `15929849`: +10.32 M instructions, +0.53% cycles.
- The sixth run used `bisect6.sh`, a copy of `bisect.sh` whose rename of the output directory didn't apply. It wrote
  into `bisect/` beside the first run, under its own trees' names (`bisect-run6.log`).
- On the rebased trees (main `703ae9f5`), Tier 1's vector commit costs the same +10.32 M (`1794ac13` → `c27be772`).
- `vpat` moves selection's vector candidates out of the twice-inlined candidates body. It saved 0.37 M instructions and
  cost 0.5% to 0.6% more cycles, so it was not taken.
- Commit 8 (`vscan`) removes 3.38 M instructions with 0.36% more cycles. Commit 9 (`ldscan`) removes 5.15 M with 0.10%
  fewer cycles. With both, the head takes 5,842.79 M instructions: 8.54 M fewer than `c27be772` and 1.78 M more than
  `1794ac13`. Commit 9's part recovers the long double commit's cost, not the vector commit's.
- Cycles move with code placement as well as with work. `vpat` and `vscan` each removed instructions yet ran more
  cycles. Wall time decides (`ab9/`, below).

## Attribution by instruction samples

- `irec2.sh TREE...` (`irec2/`): `perf record -e instructions:u -c 2000003` over 20 compiles per tree. That sample
  period is below perf's throttling rate; `throttle-*.txt` counts 0 throttle events for each tree. Each report keeps
  the `compiler` command alone and gives samples per symbol. A sample is 2,000,003 instructions, so per compile one
  sample is about 0.1 M.
  - `1794ac13` → `c27be772`: the samples sum to +10.8 M per compile (`perf stat`: +10.32 M).
    `ir_function_has_vectors_path` became its own symbol at 16 samples, about 1.6 M per compile, because Tier 1's
    commit scanned for vectors three times per function. Commit 8 brings that back to one scan.
  - `efb954e9` → `51e969b9`: the samples sum to +19.5 M per compile (`perf stat`: +15.25 M).
    `tier1_select_x87_node`, a new out-of-line symbol at 18 samples (about 1.8 M per compile), ran on every node.
    Commit 9 gates it by a scan per function.
  - The rest of each delta can't be pinned on functions. Inlining in the unity build shifts between the trees and moves
    tens of millions of instructions between functions, in both directions, that the commits don't touch:
    - for the vectors: `ir_cfg_validated` −28.5 M, `ir_check_graph` +30.1 M, `tier1_emit_cfg_problem` +52.9 M;
    - for long double: `tier1_emit_cfg_problem` outlined at +131.0 M, `tier1_emit_cfg_function` −102.7 M.
- `irec.sh` (`irec/`) and `irecord.sh` (`irecord/`) are earlier profiles at a 200,000-instruction period. `irec/`'s
  totals don't match `perf stat`'s, which points to throttling, so `irec2/` replaces it. `irecord/` (one compile each of
  `734aff5b`, `b4401c64`, `a917e5e2` and `ba5bfd5c`) guided the iterations and was not checked for throttling.

## Commits 7, 8 and 9 by wall time (`ab9/`)

`queue9.sh` runs `ab` of `--tier1 -c sqlite3.c` by `c27be772`, `vscan` and `ldscan`: 5 rounds of 21 runs, in an order
that rotates by round (`ab9/compile-tier1-ab.log`). The rounds' medians (ms):

| Tree | Rounds' medians | Median |
| --- | --- | ---: |
| `c27be772` (commit 7) | 447.759, 448.036, 448.048, 448.209, 448.908 | 448.048 |
| `vscan` (commit 8) | 449.235, 449.391, 449.446, 449.963, 450.244 | 449.446 |
| `ldscan` (commit 9) | 448.663, 448.899, 449.048, 449.199, 449.639 | 449.048 |

- Commit 8 reads 0.31% slower than commit 7, and commit 9 reads 0.09% faster than commit 8. That leaves commit 9
  0.22% slower than commit 7 with 8.54 M (0.15%) fewer instructions, as the cycles above read.
- One executable per tree is one placement of its code. buster's profiling guide ("Comparing two versions", #509)
  puts a whole compile's difference below about 0.2% under what this comparison resolves. `place10.sh` compares
  commit 7 and commit 9 over six placements of the checker's unit and three fresh copies each, with commit 7 twice as
  the floor (`place10/`).

## Limitations

- Cycles and wall time swing by about 0.5% to 1% between builds that differ in code placement alone; instruction
  counts are deterministic to a few hundred.
- The speedtest1 rows compare executables built by different compilers. Where those executables are identical, the
  rows show the noise floor.
- The per-function attribution names only the work whose symbol appears or disappears. Inlining hides the rest.
