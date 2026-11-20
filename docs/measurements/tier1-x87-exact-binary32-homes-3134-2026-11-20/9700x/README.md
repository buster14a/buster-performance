# Ryzen 7 9700X generated-program measurements

The control and #3134 binaries from the [four-placement build ledger](../loops/programs.tsv) ran on one pinned core in two free intervals on the shared Ryzen 7 9700X. Each executable ran 1,536 passes over 256 elements. The program checked the expected ten-byte results and flags. The [32 observations](hardware-processes.tsv) comprise both compilers, two independent loop families, two placements and four rounds. Round zero is a warm-up. Each reported percentage is the median of the three subsequent within-round changes. The [raw perf and host-load records](raw.tar.gz) and [paired summaries](paired.tsv) cover all of the measured cells.

| Loop and offset | Fewer cycles | Fewer instructions |
|---|---:|---:|
| Affine, 0 | 49.534% | 11.626% |
| Affine, 32 | 49.525% | 11.626% |
| Polynomial, 0 | 48.992% | 13.243% |
| Polynomial, 32 | 48.977% | 13.243% |

The absolute addresses match between compilers at each placement. The recurrence and full-precision control are outside this initial hardware comparison.
