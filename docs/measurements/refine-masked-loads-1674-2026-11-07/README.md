# Refine pass, stage 1: masked loads for every batch (buster#1674)

This is the evidence for [buster#1674](https://github.com/buster14a/buster/issues/1674).

**The change.** `refine_hash_batch` reads every batch's identifiers with a masked load each, bounded by its length. It
used to do that only where the batch's last identifier's 32 bytes would pass the source's end. Everywhere else it read
plain 32-byte loads, and cleared each pair's bytes past their lengths with a masked move, from a 64-bit mask built of
two `bzhi`, a shift and an or. Both paths load the same bytes, so the hashes and ids are the same.

The change came from an observation in [#1555's repeat](../line-crossing-loads-1555-repeat-2026-11-07/README.md):
fewer instructions per token, with a phase comparison that wasn't placement-controlled. This record makes that
comparison over placements.

## How it was run

As in #1555's repeat:

- **The lock:**
  - Every build, test, compile, benchmark and `perf stat` is one run of `scripts/one.sh`, which takes the 9700X's lock (`exclusive.sh`) for that run alone.
  - `ab` takes the lock for each `time-runs` process.
- **The receipts:** each run's are in `runs/NAME/`:
  - the command and directory;
  - when the lock was requested, taken and given back, and whether it waited;
  - the exit status, standard output and standard error;
  - for `perf stat`, its CSV with the running percentages.
- **Holder details:** `exclusive.sh`'s messages naming the holder are not kept. In `runs/placements/ab.log` its waiting blocks are replaced by a marker.
- **Totals:**
  - 113 runs and the `ab` campaign, all exiting 0;
  - every counted event ran 100% of the time;
  - `scripts/analyze.py` checks the receipts and writes `summary.txt`.

## Sources and identities (`runs/identities`, `runs/executables`, `runs/shifted-executables`)

- **The trees:** two clean clones, with `git status --porcelain` empty before and after each build.

  | Tree | Commit |
  | --- | --- |
  | main | buster `cb78f07bee90c007fe6f6b0202e75d81e6e9c356` |
  | head | `af6e7e5212d5e31cd80066da4e1335d2c64fb1cb`, main with the change (`scripts/m1674-head.patch`) |

  The head commit reached the host as a git bundle, sha256 `e917429c…`.
- **The executables** (`BUSTER_HOST_ARCH=znver5 ./build.sh`, sha256):
  - main `11514792…`;
  - head `cfdc732b…`.
- **The placement builds:** `BUSTER_DEBUG_INFO=0 ./build.sh shifts DIR main_unit_frontend.c 0 704 1408 2048 2752 3456`. The frontend unit holds the refine pass. They are listed with their hashes.
- **Host and input:** AMD Ryzen 7 9700X, kernel 6.18.50-2-lts, perf 7.2.9, clang 23.1.1, every timed process on CPU 2. The input is the frozen `sqlite3.c` (sha256 `0a409f16…`) with `tools/microarch/workloads.sh`'s command lines and the pinned predefines, under `SOURCE_DATE_EPOCH=1792454400`. The C library corpus and main's `src` were used for the phase.

## Results (`summary.txt`)

**Correctness:**

- `test-refinement` on the head passes:
  - 0 of 20,000 random inputs differ;
  - 0 of 9,600 page-edge inputs differ, where inputs end just before a `PROT_NONE` page or start at a page's start;
  - all 886 files of `src` give the same ids.
- **Outputs:** main's and the head's are the same bytes:
  - the `-c` object, `f5d1e6f4…`;
  - the `-E` output, `a984f9ca…`;
  - standard output, diagnostics and exit status of `-c`, `-fsyntax-only` and `-E`.

**Counters** (`perf stat`, `-c` of `sqlite3.c`, six rounds alternating, one placement each):

| Counter | main | head | change |
| --- | ---: | ---: | --- |
| user instructions | 1,321.16M | 1,320.26M | −0.90M, ranges apart |
| user cycles | 596.57M (595.26–607.13) | 599.22M (598.50–601.76) | ranges overlap |

**The refine phase** (`benchmark-refinement --only refine_tokens_64`):

- **Setup:**
  - main, the head and main again ran at each of six placements of the frontend unit, in an order that rotated by placement and round;
  - three rounds on `sqlite3.c`, one each on the C library corpus and `src`;
  - each benchmark is 21 passes, and its median is used.
- **The ratio:** each build's cycles per token divided by main's at the same placement and round.

| Corpus | head / main | below 1 | main again / main | instructions per token, main → head |
| --- | --- | --- | --- | --- |
| `sqlite3.c` (18 pairs) | 0.9874 (0.9819–0.9946) | 18 of 18 | 1.0000 (0.9892–1.0651) | 19.80 → 18.80 |
| `src` (6 pairs) | 0.9904 (0.9850–0.9932) | 6 of 6 | 0.9993 (0.9973–1.0014) | 19.63 → 18.66 |
| C library (6 pairs) | 0.9972 (0.9913–1.0024) | 4 of 6 | 0.9992 (0.9929–1.0726) | 28.64 → 27.60 |

**The time medians:**

| Corpus | main | head |
| --- | --- | --- |
| `sqlite3.c` | 1.164 ms | 1.149 ms |
| `src` | 8.412 ms | 8.323 ms |
| C library | 30.096 ms | 29.968 ms |

**Whole drivers over placements** (`runs/placements/ab.log`, buster#509's method):

- **Setup:** six placements of the frontend unit, two copies each, one run per `time-runs` process, four `ab` rounds, with main's executables again as the floor.
- **The figures:** user cycles against main, each round's median over placements and copies.

| | `-c`, rounds 1–4 | `-fsyntax-only`, rounds 1–4 |
| --- | --- | --- |
| head | +0.32%, −0.17%, +0.27%, −0.01% | +0.07%, +0.07%, +0.39%, −0.05% |
| main again | −0.09%, +0.01%, +0.16%, −0.07% | −0.11%, +0.37%, +0.10%, −0.22% |

## What this supports

- **The change gives the same output.** It removes about one instruction per token in the refine phase on all three corpora, and 0.90M per `-c` of `sqlite3.c`.
- **The phase:**
  - **`sqlite3.c` and `src`:** the head took fewer cycles per token than main at every placement and round. The medians are 1.3% and 1.0%, and every head ratio is below main-again's median.
  - **The C library corpus:** the difference, 0.3%, is within main-again's spread.
- **The whole drivers:**
  - **What was expected:** the refine phase is about 1.2 ms of a 110–130 ms compile of `sqlite3.c`, so a 1% gain in it is about 0.01% of the whole driver.
  - **What was measured:** both `-c` and `-fsyntax-only` stayed within main's own floor.
  - **What that means:** neither a gain nor a loss there is established.
- **Not established:**
  - **The single-placement cycles counters:** they don't separate the builds.
  - **Other hosts and the C++ corpus:** neither was run.
