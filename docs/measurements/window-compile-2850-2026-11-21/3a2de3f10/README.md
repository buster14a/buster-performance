# Packing singleton expression chains on frozen SQLite

The packed representation cut total cycles in all seven paired rounds by a median 3.77 cycles per preprocessed token. It saved 972,129 retired user instructions per complete SQLite compile. The independent wall-time differences ranged from −0.7765 to +9.4505 ms with a median of −0.059 ms. Round 2 included a packed process taking 141.155 ms with 5,772 minor faults. All observations remain in the table.

The 9700X measured a median drop of two process faults in the PMU series (range −3.5 to 0). This host’s small fault difference limits transfer of the larger measured fault savings in the [independent local run and correctness campaign](local-qualification/README.md). The [user and kernel paired counters](paired-summary.tsv) distinguish retired work, cycles and faults.

This comparison used the same private 3a2de3f10 Release executable and identical `--lanes 1 -c` arguments in both arms. The candidate arm set `BUSTER_CHAIN_PACKED=1`. The reference left it unset. The graph storage reporter, capacity override, alternate lazy-chain mode and poison control were unset in both arms. Each process compiled the complete frozen SQLite translation unit.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 937.7817 | 1,351,315,171.5 | 121.4575 |
| packed | 935.4106 | 1,350,343,049.0 | 121.2640 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| packed minus baseline | −3.7717 [−8.1791, −0.2808] | −972,128.5 | −0.0590 [−0.7765, +9.4505] |

PMU fault counts ranged from 5,658 to 5,663. The independent wall series recorded 5,766 to 5,772 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 60 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline, packed | `3a2de3f1000b796d36d34157049b30ebd7ef3357` | `e54e53919c4cc234ae5de71ea9e4cc7abc760032aaced59b66f515bb52e10d0f` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](chain-packed-config.sh), [command and object checks](chain-packed-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
