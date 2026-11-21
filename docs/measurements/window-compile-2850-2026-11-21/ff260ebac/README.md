# Direct-call compilation without diagnostic instrumentation on frozen SQLite

Local and native Release sources were parent 6e9c51b9d and private experiment ff260ebac. The five modes run the complete one-lane SQLite compile in symmetric rounds. Parent and head default use no window option, both regular modes use `--node-window`, and the call mode uses `--node-window-calls`. The native stage checks run separately from the cycle and wall measurements.
The source removes the experimental per-body checks and diagnostic environment lookups.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| parent-default | 0 | 0 | 323,623 | 930.8297 | 1,346,013,580.0 | 121.0620 |
| head-default | 0 | 0 | 323,623 | 933.0217 | 1,346,667,571.5 | 121.2570 |
| parent-window | 2,214 | 4,482 | 321,355 | 931.4942 | 1,341,459,476.5 | 121.4990 |
| head-window | 2,214 | 4,482 | 321,355 | 935.0781 | 1,344,075,686.0 | 121.4440 |
| head-calls | 4,551 | 16,391 | 311,783 | 935.0117 | 1,332,620,610.0 | 121.5525 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| head-default minus parent-default | +2.2237 [−3.0329, +3.6010] | +653,958.0 | +0.0980 [−0.0440, +0.1950] |
| head-window minus parent-window | +3.0903 [+0.9793, +6.2391] | +2,616,203.5 | −0.1880 [−0.2020, −0.0060] |
| head-calls minus head-window | −0.0664 [−1.6296, +0.7248] | −11,455,076.0 | +0.2445 [+0.0595, +1.0240] |
| head-calls minus parent-window | +1.7041 [+1.4607, +6.1727] | −8,838,867.5 | +0.0565 [+0.0535, +0.8220] |
| head-calls minus parent-default | +3.6114 [+2.1253, +4.2137] | −13,392,971.0 | +0.5900 [+0.3735, +1.4060] |

PMU fault counts ranged from 5,657 to 5,670. The independent wall series recorded 5,766 to 5,778 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 70 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| parent-default, parent-window | `6e9c51b9d238734468dccc03ab1b6c715449804e` | `4e5c9d27a80a151bbf0d9cf4f9b6be43a56ac42a5a1b36811170c26d78b93f1c` |
| head-default, head-window, head-calls | `ff260ebac510ef8584cbf58170d10dede17d4f00` | `53fc5ac788b61e151cf49c092a04927e3bdfe5a59dc101a1f5486c7f316771fc` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](call-clean-config.sh), [command and object checks](call-clean-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The ordinary graph has 323,623 nodes, computed independently from final graph nodes plus replaced nodes minus summaries in each window admission receipt. The [user and kernel counter differences](paired-summary.tsv) and [per-round values](paired.tsv) retain the arithmetic behind the aggregate. The [experimental source](implementation.patch) reconstructs the measured candidate on the named parent.

The [instrumented predecessor](../e81d07a75/README.md) and its [source qualification](../e81d07a75/correctness/README.md) preserve the separate experiment with verifier paths.
