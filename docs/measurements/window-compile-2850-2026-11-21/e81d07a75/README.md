# Ordinary parser actions and physically removed direct calls on frozen SQLite

Local and native Release sources were parent 6e9c51b9d and private experiment e81d07a75. The five modes run the complete one-lane SQLite compile in symmetric rounds. Parent and head default use no window option, both regular modes use `--node-window`, and the call mode uses `--node-window-calls`. The native stage checks run separately from the cycle and wall measurements.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| parent-default | 0 | 0 | 323,623 | 930.4931 | 1,346,013,563.5 | 120.7860 |
| head-default | 0 | 0 | 323,623 | 933.6130 | 1,346,686,198.0 | 121.2370 |
| parent-window | 2,214 | 4,482 | 321,355 | 930.5165 | 1,341,459,380.0 | 120.7360 |
| head-window | 2,214 | 4,482 | 321,355 | 934.7089 | 1,344,094,372.5 | 121.3635 |
| head-calls | 4,551 | 16,391 | 311,783 | 935.6046 | 1,332,654,022.0 | 121.3555 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| head-default minus parent-default | +3.1036 [+1.4031, +4.7161] | +672,634.5 | +0.3950 [−0.0735, +1.7810] |
| head-window minus parent-window | +3.9314 [+3.0577, +8.5962] | +2,634,992.5 | +0.7660 [−0.4050, +0.9280] |
| head-calls minus head-window | −0.9132 [−1.6408, +0.8956] | −11,440,351.0 | +0.5585 [−0.2490, +0.7405] |
| head-calls minus parent-window | +4.8270 [+1.4168, +7.6830] | −8,805,348.0 | +0.5170 [+0.3355, +1.4865] |
| head-calls minus parent-default | +6.4205 [−0.2765, +7.3395] | −13,359,561.0 | +0.5695 [+0.5085, +1.3805] |

PMU fault counts ranged from 5,659 to 5,670. The independent wall series recorded 5,766 to 5,780 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 70 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| parent-default, parent-window | `6e9c51b9d238734468dccc03ab1b6c715449804e` | `4e5c9d27a80a151bbf0d9cf4f9b6be43a56ac42a5a1b36811170c26d78b93f1c` |
| head-default, head-window, head-calls | `e81d07a75b996106d0916a0a44f5a567cb8b4622` | `2bd5172c2df6ec8e7caef03e209746b96cbe3df261fd5fb86d962ea5efe2d8e5` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](call-plain-config.sh), [command and object checks](call-plain-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The ordinary graph has 323,623 nodes, computed independently from final graph nodes plus replaced nodes minus summaries in each window admission receipt. The [user and kernel counter differences](paired-summary.tsv) and [per-round values](paired.tsv) retain the arithmetic behind the aggregate. The [experimental source](implementation.patch) reconstructs the measured candidate on the named parent.

The [complete source and ABI validation](correctness/README.md) includes 1,378 translation units, source rows, function references, source-located diagnostics, ELF objects, independent generated fixtures and executable mutation controls.
