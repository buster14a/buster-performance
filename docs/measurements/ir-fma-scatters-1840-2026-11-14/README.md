# #1840's last rows: fused multiply-adds, the verifier's metadata table and scatters (2026-11-14)

The record of [buster14a/buster#1840](https://github.com/buster14a/buster/issues/1840)'s remaining items. The PR has
three commits on main `2909b2c`:

1. **FMA.** `IR_FMA`, and Tier 1's FMA3 forms for the 20 scalar fused multiply-add rows of #2644's contractions.
2. **Verifier table.** The IR verifier's metadata check by a table of kinds, which fixes the +0.30% `--tier1`
   instructions of #2722's gathers commit.
3. **Scatter.** `IR_SCATTER`, a store of four values, for the last machine row, and `ir_operand_more`, which keeps
   the operand count's common path short.

All runs are on the Ryzen 7 9700X (`benchpress`), each build, test, count and timing under its own
`exclusive.sh` hold, on CPU 2. The builds are `./build.sh --config Release` with `BUSTER_DEBUG_INFO=0`, except the
gathers' attribution builds, which keep `-g` for source lines.

## Contents

- `1840-fma/`: `fma1840.sh` and its outputs, for main `749be1a` against the FMA commit:
  - the Zen 5 rows measured by `measure-x86-zen5 --missing --table` (`rows.txt`, `zen5-table.txt`), and `test-x86-zen5` with them;
  - `time-runs` of `-c` and `--tier1 -c main.c` (`tr-c.txt`, `tr-t1.txt`);
  - the backend unit's machine rows at `--tier1 -march=znver5` (`rows-*.txt`);
  - the backend unit self-built by each `--tier1`, linked into a compiler: its output, the head's suites (`self-head/`) and its timing (`tr-self.txt`).
- `1840-meta/`: `meta1840.sh`, for main `2909b2c`, the FMA commit and the verifier table's commit:
  - `perf stat` instructions and cycles of `-c` and `--tier1 -c main.c` (`stat-*.txt`);
  - `time-runs` of main against the table's commit.
- `1840-scatter/`: `scatter1840.sh`, for main `2909b2c` against the three commits:
  - the scatters' Zen 5 rows, then the head's tests natively (`test-*.txt`);
  - the backend unit's rows, a self-built backend unit and its suites (`self/`);
  - `perf stat`, and `time-runs` of `-c` and `--tier1`.
- `ibs-gathers/`: `ibs1840.sh`, the IBS op samples by symbol of `--tier1 -c main.c` at #2722's base `8023523` and its
  gathers commit `c70562f` (Release with `-g`), and `summary.txt`.
- `ibs-scatters/`: `ibs2.sh`, the same for the FMA and table build against the scatter build, and `summary.txt`.
- `1840-cand/`, `1840-cand2/`: `perf stat` of `--tier1 -c main.c` on main `56b5864`'s `main.c`, for the FMA and
  table build, the scatter build and a candidate fix:
  - `1840-cand/`: the extra count by an opcode table, which took back 2.3 M;
  - `1840-cand2/`: `ir_operand_more`, the PR's final head.

## Results

### Machine rows of `main_unit_backend.c` at `--tier1 -march=znver5`

| Build | Rows |
| --- | ---: |
| main `749be1a` | 21 |
| FMA (`b62a08b`) | 1 |
| main `2909b2c` | 19 |
| FMA, table, scatters | 0 |

The self-built backend unit (each build's `--tier1` of its own sources, linked with its Release objects) passes
`test-ir`, `test-ir-simd`, `test-tier1-masks`, `test-tier1-select`, `test-x86-semantics` and `test-ir-lowering`. Its
`--tier1 -march=znver5` output of the backend unit is byte-identical to the Release compiler's.

### Zen 5 rows

- **FMA (6 rows).** `vfmadd132`, `vfmadd213` and `vfmadd231` of `ss` and `sd`, on registers: 4 cycles' latency, 2 per
  cycle, one macro-op.
- **Scatters (10 rows).** `vpscatterdd` to `vpscatterqq` at every width x86 has:
  - throughput: one every 3 cycles (`vpscatterqq` of 16 bytes) to one every 17 (`vpscatterdd` of 64);
  - macro-ops: 16 to 88;
  - latency: none, as a scatter has no result.

### `--tier1 -c main.c` instructions (`perf stat`, `instructions:u`)

| Build | Instructions | Against main |
| --- | ---: | ---: |
| main `2909b2c` | 19,301,272,436 | |
| + FMA | 19,315,952,258 | +0.076% |
| + table | 19,204,758,668 | −0.50% |
| + scatters (the scatter job's) | 19,250,965,072 | −0.28% (its own main: 19,305,162,744) |

The FMA build's output of `main.c` is byte-identical to main's, and its Tier 1 report is identical too. Its +0.076%
is the compiler's code, not more work. `-c` (Tier 0) instructions differ by less than 0.01% between all the builds.

### Timing (`time-runs --runs 3 --copies 3`, `ab --rounds 3`)

`--tier1 -c main.c`, user cycles against main, with main against itself for comparison:

| Builds | Rounds | Main against itself |
| --- | --- | --- |
| FMA and table | −0.26%, −0.29%, −0.28% | −0.03%, −0.20%, −0.21% |
| all three | −0.02%, −0.11%, −0.27% | −0.01%, +0.21%, −0.19% |

`-c main.c` is flat in every round. The self-built backend unit's own compile of the backend unit (`tr-self.txt`) is
+0.03% (base against itself +0.11%).

### The gathers' +0.30% (`ibs-gathers/`)

`--tier1` instructions were +56.4 M at `c70562f`. IBS put +101 of the +145 samples per run in `ir_check_rows`:

- its metadata condition grew by the masked accesses' compare chain (`ir_masked_access` and the gather's scale);
- the scalar check runs for every instruction that the vector batch defers.

The table of kinds (commit 2) makes that check one load.

### The scatters' instructions (`ibs-scatters/`)

IBS op samples per run, 4 runs each: `ir_operand_count` gained +84.5 (+35%), and every other symbol's delta is within
noise. The scatter commit's `ir_operand_count` added `ir_extra_value_count` for every instruction: after the compare
with `IR_INTRINSIC`, it ran `cmp $IR_SCATTER; sete; add; add`. Guarding it with the compares made a jump table. The
final head tests a byte table of the operations with more operands first (`ir_operand_more`), so the common path is a
load, a test and a return. On main `56b5864`'s `main.c` (`1840-cand2/`):

| Build | `--tier1` instructions | Against FMA + table |
| --- | ---: | ---: |
| FMA + table | 19,268,506,050 | |
| + scatters, first version | 19,311,088,845 | +42.6 M |
| + scatters, final | 19,280,931,398 | +12.4 M (+0.065%) |
