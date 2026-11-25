# Direct compiler timings on Benchpress, 25 November 2026

The direct-to-object compiler changes in Buster commit `6acedd0d8` reduced wall time for the full SQLite amalgamation by 1.81% on the Ryzen 7 9700X. The three generated workloads compiled 3.35× to 7.82× faster. Seven production musl iconv mapping tables, compiled together in isolation, improved by 2.64×.

| Single-input `-c` workload | Baseline, ms | Candidate, ms | Wall-time change |
|---|---:|---:|---:|
| SQLite amalgamation, 9,507,037 bytes | 17.192 | 16.881 | 1.81% less |
| Seven musl iconv mapping tables | 1.910 | 0.724 | 2.64× faster |
| Generated switch, 4,000 cases | 2.131 | 0.552 | 3.86× faster |
| Generated integer array, 112,000 elements | 2.712 | 0.809 | 3.35× faster |
| Generated static inline chain, 3,500 reachable functions | 6.475 | 0.828 | 7.82× faster |
| One addition function | 0.396 | 0.399 | 0.76% more |

Each value is the median elapsed time for a fresh compiler process, including startup, compilation, and output to tmpfs. We pinned the processes to CPU 2 and used the host's shared exclusive lock for every build, test and measurement. Each workload ran in two blocks with alternating execution order. Each block discarded four warm-up pairs and kept 41. SQLite and the addition function ran again under fresh lock acquisitions, giving 164 observations per executable for those workloads and 82 for each other workload. The original/repeat median reductions for SQLite were 1.87% and 1.79%. For the addition function the median increases were 0.75% and 1.31%. The lock reported no other busy processes.

## Hardware counters

Each row gives median user-mode events per compile from a separate run of 11 measured pairs, after two warm-up pairs. Every reading ran the same workloads as the wall-time measurements.

| Workload | Baseline cycles, M | Candidate cycles, M | Baseline instructions, M | Candidate instructions, M |
|---|---:|---:|---:|---:|
| SQLite | 85.277 | 83.758 | 229.529 | 220.027 |
| musl iconv tables | 8.719 | 2.161 | 45.054 | 8.804 |
| Generated switch | 10.156 | 1.404 | 61.151 | 5.012 |
| Generated integer array | 13.035 | 2.437 | 66.397 | 10.396 |
| Generated inline chain | 35.371 | 2.643 | 164.653 | 11.508 |
| One addition function | 0.629 | 0.650 | 0.713 | 0.701 |

SQLite retired 4.14% fewer instructions and used 1.78% fewer user cycles. Its branch misses rose from 0.960 million to 1.008 million per compile. The six benchmark objects matched the baseline byte for byte and all six carried the direct compiler marker. The SQLite object SHA-256 was `ff67ee922b96b0897448ffb920f78702540e65b0c681ec9d70fc14c2ab8ea69f`. The baseline passed all 10 original direct checks and the candidate passed all 13.

## Build and inputs

Both executables were built on `benchpress` with the repository's Clang 23.1.4 toolchain, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0` and `./build.sh --config Release`. The baseline was `56490ed95ac23b1634b0252d8ee1405e54947418`. The patch applied to that revision had SHA-256 `6df633275077d366f9a85b0b6da8695240c5e5d88d8537ca7e089344d14abed8`. The four modified source files on the host also matched the local worktree by SHA-256. CPU 2 used the performance governor and its SMT sibling was offline. The host used Linux 6.18.50-2-lts and transparent huge pages were set to `always`.

[Wall-time samples](wall-times.csv) · [Hardware counters and object hashes](hardware-counters.csv) · [Build and lock logs, measured patch and replay scripts](run-record.tar.gz)
