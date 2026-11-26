# Direct compiler benchmarks after merging main, November 26, 2026

The direct path compiled the hexadecimal initializer at 1.319 GB/s of C source, up from 0.447 GB/s on main. The paired speedup was 2.965×. The SQLite amalgamation reached 0.617 GB/s from 0.611 GB/s, a 1.009× paired speedup. [Buster PR #3596](https://github.com/buster14a/buster/pull/3596)

| Workload | Base (ms) | Comparison (ms) | Paired speedup | Paired IQR | Pairs |
|---|---:|---:|---:|---:|---:|
| One-function C file | 0.261 | 0.240 | 1.078× | 1.066–1.114× | 48 |
| Hex initializer, 131,072 elements | 1.807 | 0.613 | 2.965× | 2.896–2.988× | 32 |
| SQLite 3.53.2 amalgamation | 15.557 | 15.414 | 1.009× | 1.004–1.013× | 32 |
| Lua 5.4.8, 34 files | 59.261 | 58.827 | 1.009× | 0.971–1.129× | 12 |
| musl string, 72 files | 26.128 | 25.205 | 1.038× | 1.029–1.048× | 12 |
| SQLite A/A control | 15.453 | 15.453 | 1.000× | 0.999–1.002× | 32 |

Base is `8e4d32879e17b7d9548cad54257a2f8461328366`. The comparison is its merge into the PR, `4a6f9dab780ca61090d69a167a45b18d71e917ad`. The SQLite A/A control runs the base binary on both sides.

Both Release builds used Clang 23.1.4 with `-O3 -march=znver5`. Each workload held the shared Benchpress lock and ran on logical CPU 2 of the Ryzen 7 9700X. Each translation unit started a fresh compiler process. The first two paired observations were warmups. Subsequent pairs alternated base-first and comparison-first order. Tiny repeats 12 compiles and hex repeats four per observation. Lua and musl each time the complete batch. The time columns are individual medians. Speedup is the median of within-pair ratios, and the IQR is the middle half of those ratios.

The hexadecimal input contains 808,314 bytes of source and emits 131,072 initializer bytes. The A/A control centered on 1.000×. Lua's interquartile range spans both gains and losses, so this run leaves its change unresolved.

The base passed all 38 direct tests and the PR passed all 39. All 109 distinct benchmark inputs produced byte-identical objects and took the same driver path on both revisions. Tiny, hex, SQLite, 33 of 34 Lua sources and all 72 musl string sources compiled directly.

[Console log](benchpress.log) · [Reproduction script](benchpress-3596-fresh.sh) · [Raw timing pairs](samples)
