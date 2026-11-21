# Sparse opening and initializer preparation with ordinary direct control roots

The unmodified 232da75f9 compiler and the cumulative source a4e5b1935 run the same ordinary SQLite command without environment overrides. The candidate combines the program-writer control-root change, sparse source openings and lazy initializer indexing. This direct comparison measures their combined effect.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 902.5075 | 1,307,159,712.5 | 117.5110 |
| candidate | 903.5450 | 1,304,304,723.5 | 117.1460 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −0.0448 [−4.0045, +7.3132] | −2,854,645.0 | −0.3650 [−0.6975, −0.0925] |

PMU fault counts ranged from 5,652 to 5,655. The independent wall series recorded 5,760 to 5,764 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| candidate | `a4e5b1935526e0af6ca66daafb12b775f1427055` | `3c73edc66c2f4e54b749e591e428153f1966f42d518a0b9b1b41d00aac6c2e0f` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](prep-combined-config.sh), [command and object checks](prep-combined-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [twelve independent native controls](native-preflight.tsv) compare actual artifact, status and stream bytes under ordinary and explicit assignment options. Both builds admitted 8,990 expressions under the assignment option, replacing 26,183 ordinary nodes with 8,990 summaries and retaining 306,430 graph nodes. All twelve objects matched. The disabled-warning streams were empty and each enabled-warning stream contained 5,846 identical bytes. [Preflight reports](native-preflight.tar.xz), [preflight script](prep-combined-preflight.sh), [per-round metrics](paired.tsv) and the [complete compiled patch](implementation.patch) are included.

All 212 independently compiled [focused](correctness/direct.json) and [Lua/musl](correctness/broad.json) parent/candidate status, ELF and diagnostic pairs matched. The separate Develop build passed 848,407 [checker](correctness/checker.txt) and 211,028 [driver](correctness/driver.txt) assertions in all sixteen shards. The [self-host control](correctness/self-host.txt) passed the selected and scalar/vector full-lowering verification commands with identical full-lowering output.
