# Direct control roots in the ordinary program writer

The two exact Release compilers ran ordinary `-c` on the frozen SQLite translation unit. The candidate resolves control roots through the new program-writer representation. Both source modes were measured with diagnostic environment overrides unset.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 912.2766 | 1,325,002,782.5 | 118.4220 |
| candidate | 906.9224 | 1,323,202,282.5 | 118.2440 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −4.5347 [−6.9118, +8.4893] | −1,800,512.0 | +0.0395 [−0.7165, +0.5165] |

PMU fault counts ranged from 5,652 to 5,656. The independent wall series recorded 5,760 to 5,764 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 28 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 5,846 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `5bb9eb2bce413e40695599bfa8d0980ba585f3e7` | `ad45e54af97e72eef7e89ec92bc20d0a8c6678a77b47865f7fde0bccb236d596` |
| candidate | `f23966e9490f1b8f8a2a4239e1aa36e7c84f2504` | `518706075092cca7c3e144d8342336bf4ae9d0919543daba256e3c186bdb938b` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](program-prod-config.sh), [command and object checks](program-prod-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The three-round directional screen retired fewer user instructions on every pair. Its wall and total-cycle intervals each included both increases and decreases. The [twelve separate native controls](native-preflight.tsv) measured default and assignment-window outputs at each of the two revisions. In assignment mode both compilers admitted 8,380 expressions, replacing 23,743 ordinary nodes, leaving 308,260. All 12 objects matched the timed ordinary output. Both `-Wall -Wextra` controls wrote identical 5,846-byte warnings, and literal default invocations were quiet. The [archived raw preflight outputs](native-preflight.tar.xz), [native control script](program-prod-preflight.sh), [per-round user and kernel counters](paired.tsv), [production patch](implementation.patch) and [correctness campaign](correctness/method.md) preserve the evidence.
