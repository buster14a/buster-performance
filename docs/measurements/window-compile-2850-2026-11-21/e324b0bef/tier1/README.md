# SQLite tier1 compilation after the block lifetime reference correction

The pristine 232da75f9 parent and [#3241 candidate](https://github.com/buster14a/buster/pull/3241) compile the same frozen SQLite source. Both builds use the explicit `--tier1` artifact-producing driver. This three-round screen reports the direct effect of the changed block lifetime reference guard on this workload.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 4,781.4826 | 8,204,981,228.0 | 617.7760 |
| candidate | 4,778.8812 | 8,204,627,600.5 | 617.6005 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −6.3697 [−9.7894, +3.2513] | −353,627.5 | +0.0375 [−0.7495, +1.7115] |

PMU fault counts ranged from 5,909 to 5,934. The independent wall series recorded 6,017 to 6,042 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

The parent repeatedly produced the 2,400,992-byte object `a45469b6eb37600ce81ab9832889189139c8558156d8fc4ee44dfd2abc942793`. The candidate repeatedly produced the 2,400,936-byte object `fb8e1650fc34c318b6a43fd7219c00b0b7adfef0a713e8018eed53bcf894f2c6`. Each timed and qualification artifact matched the SHA for its source. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `232da75f980c7ff9f01ffa3d849d655970bbed78` | `60d2bb6f131538a8845d1bfe56dc37aac0332c2caf70d53cdae9a935741ce1ec` |
| candidate | `e324b0beff784218d0679c5afc6e5d61475cd96d` | `693dee094e914476005072b5a54fa07b66b63ffb2d4c0c39bcc002e1156c77d0` |

The [frozen driver method](../../paired-driver/README.md), [mode selectors](lifetime-config.sh), [command and object checks](lifetime-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The changed output removed `.Lbuster_string_15`. The other 3513 entries retained their name, symbol type and size.

The [symbol difference](symbol-difference.tsv), [raw symbol listings](symbols.tar.xz) and [symbol comparison](lifetime-symbols.py) compare object identities. [Per-round metrics](paired.tsv) retain user and kernel counters.
