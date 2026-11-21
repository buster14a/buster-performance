# Storing initializer declarations and finish heads in ordinary SQLite compilation

All three compilers ran ordinary SQLite artifact generation. The sparse variant stores initializer owners and finish heads in the native sparse directories. The visited variant uses one-based declaration owners in zero-backed base pages and reuses the existing visit bit for finish heads. Both share the same unmodified b86eadcbd parent.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 901.2244 | 1,307,142,351.5 | 116.9975 |
| sparse | 900.1545 | 1,307,241,872.0 | 117.3525 |
| visited | 904.9126 | 1,306,970,837.0 | 117.2640 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| sparse minus baseline | −1.3187 [−1.8414, −1.0700] | +99,520.5 | +0.3550 [−0.4345, +0.5455] |
| visited minus baseline | +0.6493 [−0.2571, +5.1146] | −171,511.0 | +0.2665 [−0.4195, +0.5305] |
| visited minus sparse | +2.4907 [+1.0616, +6.1846] | −271,035.0 | −0.0150 [−0.0885, +0.0150] |

PMU fault counts ranged from 5,649 to 6,220. The independent wall series recorded 5,756 to 6,328 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 42 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` | `06e22d737854b1308c2d2ac408b01574348e08ca07823114b993aaf271b563d3` |
| sparse | `81cb70f1ac54ed116cee5d6bd7906b4b1e20c827` | `d89ee0849804eb2396a48f832b7e95e42d4959e283141f7967b7ce71c9d25a16` |
| visited | `1e668bd7e3e5b238d4caa5f89f4bf52abcfcfd39` | `e1cf9099788e03684d7814d42ac421c3ad287099afce00f7755ca434e56115f5` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](initializers-config.sh), [command and object checks](initializers-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [sparse-directory](init81c.patch) and [one-based plus visit-bit](init1e6.patch) patches each apply independently to the pristine baseline.
