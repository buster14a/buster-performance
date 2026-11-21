# Skipping inactive binding-usage diagnostics after rebasing onto main

Under the default option set, none of the binding-usage diagnostics can be emitted. The candidate skips the corresponding per-translation-unit analysis when artifacts are requested and the diagnostics are inactive. Both modes compile the complete frozen SQLite source through ordinary `-c`. The baseline is 6e9c51b9d and the candidate is 48d490785.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 930.3752 | 1,346,011,633.0 | 120.8775 |
| candidate | 918.6534 | 1,328,168,719.5 | 118.9875 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −12.2542 [−16.6061, −6.6856] | −17,842,898.5 | −1.9130 [−2.2685, −1.1960] |

PMU fault counts ranged from 5,658 to 5,662. The independent wall series recorded 5,766 to 5,771 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 60 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `6e9c51b9d238734468dccc03ab1b6c715449804e` | `4e5c9d27a80a151bbf0d9cf4f9b6be43a56ac42a5a1b36811170c26d78b93f1c` |
| candidate | `48d490785424237f088dab9eaa925f7afdbe0117` | `206ea50ed8347d3381a4f35e6352e93ed7d0cd52c0e36836994ac43590ca7641` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](unused-port-config.sh), [command and object checks](unused-port-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

For the five distinct warning policies, both executables produced identical exit status, stdout, stderr and object bytes where successful. The [outcome ledger](warning-controls.tsv), [exact diagnostic bytes](warning-reports.tar.xz), [per-round user and kernel counters](paired.tsv), [applied source patch](implementation.patch) and [independent checker and driver qualification](correctness/README.md) preserve the individual checks.
