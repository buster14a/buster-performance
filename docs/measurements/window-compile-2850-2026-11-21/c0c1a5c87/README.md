# Cumulative ordinary SQLite compilation against main

The paired median change in wall time was −2.5260 ms per SQLite compile, with all seven independent wall rounds favoring the integration. The paired change in total cycles per preprocessed token was −19.9804, with all seven PMU rounds favoring it. Source throughput from the median wall times was 78.492 MB/s for main and 80.107 MB/s for the combined source. The [13-file integration patch](combined.patch) applies to the baseline with SHA-256 `4db18b34f938b6e76c7ec187124d786ea22ad0095a63cdedbf7498abe4979061`. The [round-level differences](paired.tsv) preserve user and kernel contributions.

The unmodified baseline is main d009ca61c after the merges of #3218 and #3227. The private integration c0c1a5c87 combines the #3230 token-column change aef585e82 and default demand-driven return facts fde14be84 on that baseline. Its whole source tree is `501493625bce6bc7db4fe96bc9b10c312dd1f58e`. Both compilers ran the same ordinary `-c` command. Each source compiled through its default pipeline, with no window flag and no return-demand diagnostic selector.

| Metric | Baseline median | Combined median | Paired change, median [min, max] |
| --- | ---: | ---: | ---: |
| cycles/token | 934.0068 | 913.4977 | −19.9804 [−24.0547, −16.8350] |
| user cycles/token | 824.1535 | 806.3047 | −17.1594 [−21.5840, −14.8634] |
| kernel cycles/token | 110.1605 | 108.1380 | −2.4707 [−4.7465, −0.7967] |
| total instructions | 1,381,809,714.0 | 1,360,561,829.5 | −21,143,511.0 [−22,025,743.0, −20,675,129.0] |
| user instructions | 1,348,239,707.0 | 1,327,233,262.0 | −21,006,443.0 [−21,006,458.0, −21,006,426.0] |
| kernel instructions | 33,570,007.0 | 33,328,555.5 | −137,063.5 [−1,019,285.0, +331,313.5] |
| wall ms | 121.1205 | 118.6795 | −2.5260 [−2.9650, −1.1950] |

PMU fault counts ranged from 5,654 to 5,665. The independent wall series recorded 5,765 to 5,773 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 60 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `d009ca61c6e1e02d240267acfd62afc005746983` | `2480b0311d63714eb0828720966ba324a8fd6fca7922429478bd0eee31a3331d` |
| combined | `c0c1a5c87e91359a961b83f1249cfae9dd4d9ebe` | `540cd805de13600d72523290068c3e65026b2a1095c659e707d2e1197cf25210` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](combined-ordinary-config.sh), [command and object checks](combined-ordinary-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
