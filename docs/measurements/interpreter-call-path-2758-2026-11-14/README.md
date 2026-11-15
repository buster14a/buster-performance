# The interpreters' call path (buster#2758), 2026-11-14

Measurements for buster PR #2809 (branch `claude/zen-mayer-w0nz6l`, commits 57f5e50, ab3c977 and f978f5b, on main
2ebfe68). The issue: c-testsuite's `00040.c` (8 queens by brute force, 4.57 billion interpreter steps in its four
forms) set the wall time of "Compare c-testsuite's typed streams, SSA and strict Tier 1 programs", the costliest
command of the x86-64 MSan row.

## Contents

| Path | What |
|---|---|
| `msan/scripts/run-00040.sh` | `perf record -F 199 -e cpu-clock` of `test-ssa-source --typed --tier1 00040.c`, with its wall time |
| `msan/scripts/tests.sh` | The interpreter commands of `tools/ci/correctness.tests` run on one build, a line each |
| `msan/msan-base/` | main 2ebfe68: the command's report, and the profile by form (`by-form.txt`, samples per process), by form and symbol, and by symbol |
| `msan/msan-head1/` | An intermediate state: the per-step locals and scalar transfers changed, no lookup table yet |
| `msan/msan-head2/` | Commit 57f5e50 |
| `msan/msan-head3/` | Commit ab3c977 (the PR's code; f978f5b is documentation) |
| `msan/tests/` | `tests.sh`'s lines for ab3c977's MSan and native builds, the c-testsuite command's totals, and main's MSan run of it (`c-testsuite-base-totals.txt`; its time is the last line of `tests-msan-head3.txt`) |
| `9700x/scripts/bench.sh` | The 9700X A/B: builds, then three rounds of main and the PR alternating, each run under its own hold of the host lock |
| `9700x/stats/` | Each run's `perf stat` (`*.txt`) and output (`*.out`), and `status.txt` |
| `9700x/procs.log` | `/proc/loadavg` and the busiest processes before and after each run, inside its hold |

## MSan (the issue's measurement)

x86-64 MSan Release build (`BUSTER_HOST_ARCH=x86-64 BUSTER_SANITIZER=memory ./build.sh --config Release`, CI's
toolchain, clang 23.1.4, `-fsanitize-memory-track-origins=2`), a 4-CPU cloud container (Intel Xeon @ 2.10 GHz), one
run each. Every run gave the same steps (1,350,907,668 / 1,086,721,022 / 1,086,721,022 / 1,044,385,699 for 00040.c)
and its expected output in every form.

| Run | main | head1 | 57f5e50 | ab3c977 |
|---|---:|---:|---:|---:|
| 00040.c alone, wall | 265.5 s | 155.4 s | 135.4 s | 122.3 s |
| its memory form, CPU | 260.5 s | | 133.2 s | 120.5 s |
| its vector SSA form, CPU | 180.1 s | | 106.3 s | 88.1 s |
| its scalar SSA form, CPU | 184.8 s | | 110.4 s | 87.4 s |
| its typed form, CPU | 164.5 s | | 77.2 s | 72.2 s |
| CI's command on the subset's 220 programs, wall | 280.8 s | | | 149.7 s |

The forms' CPU is the profile's samples per process at 199 Hz. In main's profile MSan's runtime was about 30% of the
samples (`UnwindFast` 7.6%, `__msan_memset` 4.9%, `SetShadow` and `SetOrigin` 3.3% each, `CopyOrigin` 2.3%,
`__msan_set_alloca_origin_with_descr` 1.9%), almost all of it per step: each step's address-taken locals poisoned and
cleared, and each scalar load, store and local a variable-size `memcpy`, each of which unwinds the stack at
origins=2.

## The 9700X

benchpress (Ryzen 7 9700X, Linux 6.18.50-2-lts), plain Release builds by `./build.sh --config Release` (the 9700X's
clang 23.1.4), main 2ebfe68 against ab3c977, three rounds alternating, every run one hold of the host lock. The only
other busy process in the snapshots was a CI `Runner.Worker` 0 s old in `forms-head-2`'s after-snapshot.

| Run | main | the PR | change |
|---|---:|---:|---:|
| `interpret-c 00040.c` (the typed form alone), `taskset -c 2`, wall | 12.66 / 12.56 / 12.67 s | 11.21 / 11.12 / 11.22 s | −11.5% (medians) |
| its cycles | 69.98 / 69.44 / 69.93 G | 61.86 / 61.65 / 62.13 G | −11.5% |
| its instructions | 400.70 G | 334.36 G | −16.6% |
| `test-ssa-source --typed 00040.c` (four forms), `taskset -c 2-5`, wall | 13.80 / 13.88 / 13.97 s | 12.63 / 12.51 / 12.64 s | −9.0% |
| its task-clock | 46.04 / 46.21 / 46.60 s | 43.53 / 43.29 / 43.38 s | −6.1% |
| its instructions | 1,387.8 G | 1,271.0 G | −8.4% |
| CI's command on the 220 programs, `taskset -c 2-5`, wall | 14.43 / 14.38 / 14.47 s | 13.20 / 13.46 / 13.18 s | −8.6% |
| its task-clock | 48.16 / 47.91 / 47.95 s | 45.45 / 45.42 / 45.26 s | −5.3% |

Every run passed, with the same totals line (220 programs, 220 passed).
