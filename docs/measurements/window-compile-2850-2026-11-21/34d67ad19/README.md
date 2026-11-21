# Frozen SQLite with discarded literal expressions

The real wall series measured −0.68 ms for generic discards against their direct parent and −0.86 ms for explicit stores plus discards against theirs. The first wall round included large page-fault counts on the generic, ordinary and earlier local-reads executables. In the remaining six low-fault rounds, all six generic and explicit comparisons favored the candidate, with median savings of 0.76 ms and 0.85 ms respectively. The [candidate source change](discarded-literals.patch) applies to 0d84c3cdb.

The parent is the split assignment experiment 0d84c3cdb. Its regular option admits return expressions, while its explicit assignment option adds local stores. The candidate 34d67ad19 adds 5,403 discarded integer literals to both options and eliminates 10,806 graph nodes in each comparison. On frozen SQLite, each option reduced total cycles in all seven comparisons against its corresponding parent option. Both also reduced retired user instructions by over 12.8 million per compile.

The `reads` mode is the earlier #3218 binary with `--node-window`. The two parent modes use 0d84c3cdb. On the candidate, `ordinary` means plain `-c`, `regular` means `--node-window`, and `stores` means `--node-window-assignments`. All measurements share one six-mode experiment. Page policy used the host default. Per-process huge-page mappings were not measured.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| reads | 2,214 | 4,482 | 321,355 | 930.6219 | 1,340,753,030.5 | 120.8585 |
| parent-regular | 2,214 | 4,482 | 321,355 | 932.9886 | 1,341,293,291.5 | 121.3030 |
| parent-stores | 2,977 | 7,534 | 319,066 | 934.9968 | 1,339,365,070.0 | 121.4485 |
| ordinary | 0 | 0 | 323,623¹ | 930.7941 | 1,346,114,821.0 | 121.1255 |
| regular | 7,617 | 20,691 | 310,549 | 927.9180 | 1,328,409,083.5 | 120.5060 |
| stores | 8,380 | 23,743 | 308,260 | 929.3812 | 1,326,538,229.0 | 120.5380 |

¹ The ordinary graph size follows from final nodes plus ordinary nodes replaced minus summaries inserted in every opt-in mode.

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| regular minus parent-regular | −6.8385 [−15.3550, −0.3584] | −12,884,208.0 | −0.6845 [−1.0300, +7.4325] |
| stores minus parent-stores | −5.7347 [−8.7272, −3.5551] | −12,826,848.0 | −0.8615 [−5.8295, −0.3435] |
| regular minus reads | −4.9883 [−7.8091, +1.6896] | −12,344,025.5 | −0.4185 [−3.8140, −0.0510] |
| stores minus reads | −4.8844 [−7.2682, +0.7400] | −14,214,785.0 | −0.4800 [−17.7145, +0.0840] |
| regular minus ordinary | −4.3189 [−8.0579, +0.8398] | −17,705,780.5 | −0.6215 [−3.8380, +0.0480] |
| stores minus ordinary | −2.9786 [−7.0221, +0.2585] | −19,576,583.0 | −0.4415 [−17.7385, −0.1575] |
| stores minus regular | +0.8513 [−3.9955, +5.6890] | −1,870,812.0 | −0.0265 [−13.9005, +0.1930] |

PMU fault counts ranged from 5,660 to 5,743. The independent wall series recorded 5,768 to 60,047 minor faults and zero major faults.

Excluding rounds with a process above 20,000 faults in the wall series removes rounds 1. The retained paired differences are

| Paired difference | wall-ms, median [min, max] |
| --- | ---: |
| regular minus parent-regular | −0.7632 [−1.0300, −0.0590] |
| stores minus parent-stores | −0.8548 [−1.3775, −0.3435] |
| regular minus reads | −0.4130 [−0.7760, −0.0510] |
| stores minus reads | −0.4625 [−0.6005, +0.0840] |
| regular minus ordinary | −0.5482 [−0.9180, +0.0480] |
| stores minus ordinary | −0.3617 [−0.8675, −0.1575] |
| stores minus regular | +0.0120 [−0.2790, +0.1930] |

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 180 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| reads | `227853575f341342bb02e6b4c38c79044ce691bc` | `40eb5cb1f9015f76232e62ea06efc931c659fee590481f3679bfdb33820bc6ba` |
| parent-regular, parent-stores | `0d84c3cdb8b3146c03c874ac2c553279c4d1eed2` | `65cba6c5358c9a4c8f393eeddb0867e51a17f939f8450d6d94dabd4d5dde7ca5` |
| ordinary, regular, stores | `34d67ad19714a14333a9c850ab32b428e23ce7d3` | `16c226a48eec53c429e4cc8147f15584d83cd804d0c428503e2f711acafd989d` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](native-matrix-config.sh), [command and object checks](native-matrix-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
