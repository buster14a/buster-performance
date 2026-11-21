# SQLite ordinary compilation after the block lifetime reference correction

The pristine 232da75f9 parent and [#3241 candidate](https://github.com/buster14a/buster/pull/3241) compile the same frozen SQLite source. Both builds use the normal artifact-producing driver. This three-round screen reports the direct effect of the changed block lifetime reference guard on this workload.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 905.5000 | 1,307,159,725.0 | 117.3030 |
| candidate | 901.6716 | 1,307,414,534.0 | 117.0635 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −3.8285 [−5.8567, +4.6243] | +254,782.5 | −0.0175 [−0.2395, +0.2535] |

PMU fault counts ranged from 5,653 to 5,656. The independent wall series recorded 5,761 to 5,764 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| candidate | `e324b0beff784218d0679c5afc6e5d61475cd96d` | `693dee094e914476005072b5a54fa07b66b63ffb2d4c0c39bcc002e1156c77d0` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](lifetime-config.sh), [command and object checks](lifetime-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [symbol difference](symbol-difference.tsv), [raw symbol listings](symbols.tar.xz) and [symbol comparison](lifetime-symbols.py) compare object identities. [Per-round metrics](paired.tsv) retain user and kernel counters.
