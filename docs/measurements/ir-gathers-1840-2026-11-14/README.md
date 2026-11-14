# #1840's gathers, compressing stores and truncating stores (2026-11-14)

The 9700X record for buster14a/buster#2722 (#1840 item 4's last rows): `IR_GATHER`, `IR_COMPRESS_STORE`, and
truncating stores as `truncate` then `masked_store`. It holds:

- the Zen 5 rows of Tier 1's new records (`zen5-table.txt`);
- the compile-time A/Bs against main;
- the backend unit built by each compiler's own `--tier1`, and Tier 1's work timed by each such build.

## Builds

- **Base:** main `8023523`.
- **Head:** the PR's code at `2526105`. The PR's last commit before the merges, `ec8b405`, changes only `docs/`. The
  two merges of main after it (`b22339b`, `2efab45`) add a table entry each; they are not timed here.
- **`c70562f`:** the first commit of the PR, whose build measured the Zen 5 rows.

Each is a Release build without debug information (`BUSTER_DEBUG_INFO=0 ./build.sh --config Release`), built under
the lock on benchpress (Ryzen 7 9700X).

## Scripts

- `run1840.sh` builds base and `c70562f` and runs `measure-x86-zen5 --missing --table` (`zen5-table.txt`). Its later
  `ab` steps were stopped and are not recorded.
- `final2.sh` builds `2526105`. Its `ab -c` A/B ran, but `ab` only runs commands and times nothing, so that run left
  no numbers and is not kept.
- `final3.sh` made every timing here: `time-runs` under `ab` (docs/profiling.md, "Whole drivers"). Each `ab` round is
  one `time-runs` process under one lock hold, on CPU 2. Each round runs base, head and base again (the floor), 3 runs
  each from 3 fresh copies, in a Williams order. It also counts the backend unit's machine rows and self-builds the
  backend unit.
- `perf1840.sh` and `tiny1840.sh` look for `--tier1`'s added instructions (below), and `bisect.txt` holds their counts.
- `progress.txt` is the runs' log.

The `tr-*.txt`, `rows-*.txt` and `self-*-compile.txt` files keep only the lines `time-runs` and `--tier1-report`
print. The lock's waiting banners, which name other sessions' runs, are removed.

## Zen 5 rows

`zen5-table.txt` is one `measure-x86-zen5 --missing --table` process of `c70562f`, whose standard error held only
the lock's wait. The 45 rows it printed are in buster14a/buster#2722's `x86_zen5_rows.c`, in cycles per instruction:

| Forms | Latency (chain through the index) | Throughput | Retired macro-ops | FP macro-ops |
| --- | ---: | ---: | ---: | ---: |
| `vpgatherqq xmm` | 16 | 3 | 13 | 9 |
| `vpgatherdd xmm`, `vpgatherqd xmm` (ymm index) | 17.25, 18.5 | 4 | 19 | 13 |
| `vpgatherdq ymm`, `vpgatherqq ymm` | 17.38, 18.5 | 4 | 19 | 13 |
| `vpgatherdd ymm` | 22.5 | 5.95 | 32 | 22 |
| `vpgatherqd ymm` (zmm index) | 25 | 6.75 | 35 | 25 |
| `vpgatherdq zmm`, `vpgatherqq zmm` | 22.62, 24.75 | 7, 7.03 | 38, 40 | 28, 30 |
| `vpcompress{b,w,d,q} [m]{k}`, 16 and 32 bytes | — | 3 | 7 | 5 |
| `vpcompress{b,w,d,q} [m]{k}`, 64 bytes | — | 3 | 8 | 5 |
| `vpmov{,s,us}{wb,db,dw,qw,qd} [m]{k}` | — | 0.5 | 2 | 2 |

These are the rows' values (the `# row` lines). A gather's unit is two instructions: `kxnorw`, which refills the mask
that the gather clears, then the gather. The rows subtract the `kxnorw`; the table's per-experiment lines keep it.

**The memory compress.** The register form's row is one a cycle with 2 macro-ops. The memory form is one every
3 cycles with 7 or 8, but it has no slow path like Zen 4's. One instruction stays Tier 1's choice: a register
compress, a prefix mask from the population count and a masked store would take five or six.

**The harness's gather fixtures.** `measure-x86-zen5` now fills a quadword index with quadwords of 3, and its scale
is the element's bytes. Before, `vpgatherqd`'s and `vpgatherqq`'s fixtures read wild addresses.

## Compile time

Three rounds of 9 processes per build each: medians over all 27, against base, with each round's base-again floor.

| Command | Build | Wall (ms) | User cycles (M) | Instructions (M) |
| --- | --- | ---: | ---: | ---: |
| `-c main.c` (Tier 0) | base | 693.6 | 3,501.5 | 10,680.23 |
| | head | 692.7 (−0.14%) | 3,494.2 (−0.21%) | 10,680.24 (+0.000%) |
| | base again | 692.3 (−0.20%) | 3,496.6 (−0.14%) | 10,680.24 |
| `--tier1 -c main.c` | base | 1,173.0 | 6,135.2 | 19,024.22 |
| | head | 1,174.5 (+0.13%) | 6,141.1 (+0.10%) | 19,080.72 (**+0.297%**) |
| | base again | 1,173.5 (+0.04%) | 6,135.7 (+0.01%) | 19,024.22 |
| self-built backend, `--tier1 -c main_unit_backend.c` | base's | 3,158.4 | 16,847.1 | 47,591.01 |
| | head's | 3,155.5 (−0.09%) | 16,831.9 (−0.09%) | 47,591.02 (+0.000%) |
| | base's again | 3,158.2 (−0.01%) | 16,839.2 (−0.05%) | 47,591.02 |

The rounds' user cycles, head against base, and the base-again floor's:

| Command | Head | Floor |
| --- | --- | --- |
| `-c main.c` | −0.25%, +0.21%, −0.32% | −0.13%, −0.05%, −0.33% |
| `--tier1 -c main.c` | +0.15%, +0.16%, −0.18% | +0.08%, +0.14%, −0.39% |
| self-built backend | −0.00%, −0.12%, −0.01% | −0.13%, +0.10%, +0.06% |

- **Tier 0 (`-c`)** decodes no row into the IR. Its instructions are the same within 21 thousand, and its time is
  within the floor.
- **`--tier1 -c main.c`** retires 56.5 M more instructions (+0.30%), the same in every process. Its cycles stay within
  the floor's spread. Where they come from (`bisect.txt`, `perf stat -e instructions:u` of
  one process each, under the lock):
  - **`main.c`'s Tier 1 output barely changes.** Tier 1's report of `main.c` gives 1,394 functions by both builds,
    415,198 records against 415,208, and 35 machine rows against 32.
  - **The PR's first commit has all of it.** `c70562f` retires 19,080.92 M instructions, the head 19,080.71 M and base
    19,024.20 M.
  - **It is no fixed cost.** On a one-function file, `--tier1` retires 729,256 instructions by base and 729,548 by the
    head.
  - So it scales with Tier 1's work, not with the new operations, which `main.c` has only a few of. The likely cause,
    unconfirmed because sampling can't place it (below), is the backend unit's own code after the change: the new
    branches sit in Tier 1's `always_inline` candidate function, and LTO inlines the unit's functions differently.
- **The self-built backend.** In `self-*-compile.txt`, base's `--tier1` leaves 93 machine rows in the backend unit and
  the head's leaves 1. Linked with the head's clang-built Release objects, the two builds run Tier 1's own work
  (`--tier1 -c main_unit_backend.c`) at the same speed. Both give the Release head's object byte for byte
  (`progress.txt`: "outputs: base same, final same"). The head drops the 92 rows' moves into
  and out of place (154 to 1), too few to show in a 16.8 G-cycle compile.

**The attribution that failed** (`perf1840.sh`). `perf record -e instructions:u -c 100003` of one `--tier1 -c main.c`
process per build sampled only 7.8 G of the 19 G instructions, because perf throttled the sampling. Its per-symbol
differences swung by ±100 M in both directions. Grouped by subsystem, the shares moved by up to 1.7 points each way
(`ir_optimize` −1.65, `tier1_alloc` −1.38, `tier1_emit` +1.30, `tier1_cfg` +1.24), as functions that LTO inlines
differently in the two builds would. That hides a 0.3% total, so the samples are not kept. `tiny1840.sh` made the
one-function counts.

## Machine rows

`--tier1 --tier1-report -march=znver5` of the head's `main_unit_backend.c` (`rows-*.txt`):

| Build | Compiled functions | Records | Machine rows | Moves around rows |
| --- | ---: | ---: | ---: | ---: |
| base | 5,223 | 1,779,449 | 93 | 154 |
| head | 5,223 | 1,779,550 | 1 | 1 |

The row left is `tier1_select_burs.c`'s scatter (`_mm512_mask_i32scatter_epi32`). It needs a fourth value, so it stays
a machine row; its cost is on buster14a/buster#1840. After main's merge (`b22339b`) the unit also has 20 scalar
`vfmadd213sd`/`ss` rows. #2644 (#1239) contracts scalar `a * b + c` into those, outside #1840's list.
