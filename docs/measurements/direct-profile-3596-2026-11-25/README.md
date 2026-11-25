# Direct compiler startup and hexadecimal initializers on Benchpress

On November 25, 2026, the Ryzen 7 9700X compiled the hexadecimal initializer in 0.621 ms and SQLite in 16.195 ms with Buster PR #3596. The comparison uses the PR head `cfc20db4503197e9a0bb1b6ed816462510cd907f` and its `main` parent `20f3573eebb641e30cfceed4089a4ac3430259f2`. [Buster PR #3596](https://github.com/buster14a/buster/pull/3596)

| Workload | Base (ms) | PR (ms) | Paired speedup | Paired IQR | Pairs |
|---|---:|---:|---:|---:|---:|
| One-function C file | 0.245 | 0.231 | 1.063× | 1.020–1.103× | 48 |
| Hexadecimal initializer, 128 KiB of data | 1.807 | 0.621 | 2.908× | 2.877–2.948× | 32 |
| SQLite 3.53.2 amalgamation | 16.715 | 16.195 | 1.033× | 1.028–1.039× | 32 |
| Lua 5.4.8, all 34 files | 77.065 | 74.856 | 1.079× | 0.976–1.086× | 12 |
| musl string, all 72 files | 31.618 | 29.664 | 1.062× | 1.043–1.084× | 12 |

The two time columns are median wall times. Speedup is the median of the base time divided by the PR time within each pair. The IQR gives the middle half of those ratios. Dividing the two time columns can give a different value, particularly for Lua.

The hexadecimal fixture contains 131,072 initializer bytes in 808,314 bytes of C source. Source throughput rose from 0.447 to 1.302 GB/s. For the 9,507,037-byte SQLite amalgamation, throughput rose from 0.569 to 0.587 GB/s. A separate 32-pair SQLite run compared the baseline executable with itself. Its median times were 16.660 and 16.652 ms, with a paired ratio of 1.001× and an IQR of 0.995–1.003×.

Both compilers were built in Release with Clang 23.1.4, `-O3 -march=znver5`. Each workload held the shared Benchpress lock and ran on CPU 2. Every source file used a fresh compiler process with one lane. The timing order alternated between base first and PR first after two warmup pairs. Lua and musl times cover their whole batches.

All 109 distinct benchmark inputs produced byte-identical objects and used the same compilation path on both revisions. The direct path handled the three individual inputs, 31 of 34 Lua files and 64 of 72 musl files. The direct test suite passed 19 tests on the base and 20 on the PR.

The console log contains the build identifiers, host load, correctness checks and per-workload results. The individual timing pairs were written on Benchpress under `~/buster-fast-bench/3596-codex.3kKzQbvd/*.tsv`. [Console log](benchpress.log) · [Launcher and measurement code](benchpress-3596.sh)
