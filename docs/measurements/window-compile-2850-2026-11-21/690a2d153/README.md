# Discarded postfix operations on frozen SQLite

The additional postfix operations saved 2.173 million retired user instructions per compile. In seven paired rounds, total cycles changed by +0.3312 per token at the median and independent wall time changed by −0.3015 ms. Both ranges crossed zero. The [full local check and exact output qualification](correctness/README.md) includes comparisons of all 4,401 checked roots and all 381,191 sourced native entries.

The parent is the explicit for-initializer source a62702e32. The candidate adds discarded postfix increments and decrements in statement and for-step positions. Both modes use `--node-window-assignments -c`. The candidate takes 814 additional expressions and eliminates 814 final graph nodes. Both builds retain 2,214 generic return-window admissions when the explicit assignment option is absent; the measured comparison uses the explicit mode.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| parent | 3,587 | 9,974 | 317,236 | 934.1192 | 1,336,830,595.5 | 121.2400 |
| postfix | 4,401 | 11,602 | 316,422 | 933.6020 | 1,334,657,725.5 | 120.9685 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| postfix minus parent | +0.3311 [−3.1964, +2.1821] | −2,172,808.0 | −0.3015 [−1.0270, +0.3520] |

PMU fault counts ranged from 5,666 to 5,671. The independent wall series recorded 5,775 to 5,779 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 60 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| parent | `a62702e323e37ec9777b7efbc94d70a05598e38f` | `c1c19ff78e47d204c728be75556e3fb7193e383bc977b96e4d46dc52ea56994f` |
| postfix | `690a2d153c74c0b3c5ad241bd60ff0e22019a558` | `fb6f95b9643ce2c71225f04dc16bfa3c546ee277b96a91e109b43f7ea9f1be82` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](postfix-screen-config.sh), [command and object checks](postfix-screen-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
