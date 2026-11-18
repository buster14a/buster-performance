# Diagnostics' deletion (#2924, C6, with #2959's fix)

buster's `c6-diagnostics` against main `caa8f6a3e` (after #2956) on the 9700X: Release builds, every run under the
lock on CPU 2 ([`run.sh`](run.sh), [`disassembly/`](disassembly/), [`logs/`](logs/)).
- The gate is [`../c-diagnostics-gate/`](../c-diagnostics-gate/).
- #2959's fix and its experiments are [`../c-diagnostics-fix-2959/`](../c-diagnostics-fix-2959/).

## What the head is

1. **#2959's fix:**
   - the radix sort's `digits` and `ranks` aligned to 64 bytes;
   - a vector count sort through 512 records;
   - `diagnostic_merge` always gives the sort scratch.
2. **The test checks the sort against its definition:** every record once, with its keys, ordered by (source,
   sequence), and equal keys in input order.
3. **The deletion:** the insertion twin goes entirely (`diagnostic_sort_scalar` and its comparison), along with
   `diagnostic_merge`'s `scalar` parameter, the lane test's scalar modes and the benchmark's twin and `--only`.
   `--after-scalar` now conditions with scalar integer work.
4. **The test's counts** gain 504 to 519, around the cutoff.
5. **The docs.**
6. **The benchmark warms each count for 10 ms rather than one pass** (below).

## Results

- **`test-diagnostics`** passes on head.
- **`benchmark-diagnostics`**, three processes each, ns/key. Main runs the twin interleaved with its selected path;
  head runs its one path.

  | Records | Main's twin | Main's selected | Head | Twin / head (medians) | Head after 100 ms |
  | ---: | ---: | ---: | ---: | ---: | ---: |
  | 32 | 4.48–4.52 | 5.78–5.85 | 4.53–11.32 | 0.98 | 4.53–4.62 |
  | 64 | 7.51–7.60 | 10.95–11.00 | 7.22–8.47 | 1.04 | 7.22–7.23 |
  | 256 | 35.06–35.08 | 53.39–54.71 | 21.30–23.70 | 1.62 | 21.18 |
  | 4,096 | 481.45–482.22 | 43.00–61.97 | 43.07–43.27 | 11.19 | 42.91–43.14 |

- **Disassembly** ([`logs/compare.txt`](logs/compare.txt)): 9,926 functions are identical. Of the three that differ,
  `diagnostic_sort` and `diagnostic_merge` change with this work; the third, `dataflow_test_solve`, is test code.
  Head adds `diagnostic_benchmark_scalar_work` and no others. The functions in `.text.buster_start` are the same set in
  both.

## The 32-record row's outlier, and the warm-up

One head process read 11.32 ns/key at 32 records, against 4.53–4.60 in the other two and in every conditioned
process.

**The stack doesn't decide it.** A sweep with ASLR off over stack pads from 0 to 1,008 bytes in 16-byte steps
([`stack.sh`](stack.sh), [`logs/stack/`](logs/stack/)) found 16 of 64 pads at 6.2–6.9 and the rest at 4.5, with no
period. Repeating pad 0 gave 6.55 once and 4.66 once ([`stack-counters.sh`](stack-counters.sh),
[`logs/stack-counters/`](logs/stack-counters/)). Both runs counted about 720 M cycles and the same
store-to-load-interlock counts over the whole process.

**It is a transient at the process's start.** The 32-record row is each process's first measurement and its shortest:
21 samples of about 37 µs after a single warm-up pass.

**The fix is in the benchmark:** each count now warms for 10 ms before its samples
([`warm.patch`](warm.patch), [`warm.sh`](warm.sh), [`logs/warm/`](logs/warm/)). Six processes then read 4.45–4.61
ns/key at 32 records and 7.18–7.22 at 64.

## Mutation check ([`mutation/`](mutation/))

- **Round 1** ([`pr.results`](mutation/pr.results)): the deletion's tree before #2959. All 5 mutants fail:
  - d1 breaks the insertion path, which the twin test had compared with itself;
  - d2 to d5 break the radix sort.
- **Round 2** ([`pr2.results`](mutation/pr2.results)): the final tree, which has the count sort. All 9 mutants fail:
  - d2 to d5 again;
  - k1, ties in earlier blocks not counted;
  - k2, every tie in the record's own block counted;
  - k3, the source column's lane 7 taken from the wrong qword;
  - k4, lanes past the end given the smallest keys;
  - k5, the second register's load cut short.

  Four of the round-2 mutants fail by a crash rather than a failed check: d5, k2, k4 and k5. A wrong place lands
  outside the scratch, against the test's guard pages.

## Sanitizers

Built locally (`BUSTER_HOST_ARCH=vector`, Release) on the head, for AddressSanitizer with UBSan, MemorySanitizer and
ThreadSanitizer: `test-diagnostics` and `benchmark-diagnostics --after-scalar 2`.
