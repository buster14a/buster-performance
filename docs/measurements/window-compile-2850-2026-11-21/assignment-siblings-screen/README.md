# Frozen SQLite with field stores and for-initializer stores

For-initializer stores reduced total cycles in all seven paired rounds, by 4.83 cycles/token at the median. Field stores saved 3.38 cycles/token at the median and one round favored the parent. The for-initializer route saved 2.53 million retired user instructions per compile, compared with 1.43 million for field stores.

These two sibling implementations extend the explicit `--node-window-assignments` path of 0d84c3cdb. The field-store implementation admits 881 more assignments and eliminates 3,524 graph nodes. The for-initializer implementation admits 610 and eliminates 1,830 graph nodes. Both reduced the retired user instruction count in the three-round screen. The same three modes continued for four more rounds with the original executables and selectors. The seven-round table contains all original and extension observations. The [source, complete checked-value comparisons, native source tokens and fixture qualification](../assignment-shapes/README.md) document the two implementations and the shapes they can admit.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| parent | 2,977 | 7,534 | 319,066 | 937.5481 | 1,339,364,982.0 |
| arrow | 3,858 | 11,939 | 315,542 | 932.8063 | 1,337,930,271.0 |
| for-init | 3,587 | 9,974 | 317,236 | 931.2533 | 1,336,830,600.5 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median |
| --- | ---: | ---: |
| arrow minus parent | −3.3751 [−5.7823, +0.5540] | −1,434,701.0 |
| for-init minus parent | −4.8303 [−7.2950, −0.9787] | −2,534,401.0 |
| arrow minus for-init | +1.4552 [−3.6369, +2.5850] | +1,099,683.0 |

PMU fault counts ranged from 5,661 to 5,743.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 48 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| parent | `0d84c3cdb8b3146c03c874ac2c553279c4d1eed2` | `65cba6c5358c9a4c8f393eeddb0867e51a17f939f8450d6d94dabd4d5dde7ca5` |
| arrow | `0a01ce366930ea012600673ce1e98c847f3300c1` | `89a9eaf6b0d8ae76091d35c0e10ca781b1d815bae73b09067dbb8c1dc85134da` |
| for-init | `a62702e323e37ec9777b7efbc94d70a05598e38f` | `c1c19ff78e47d204c728be75556e3fb7193e383bc977b96e4d46dc52ea56994f` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](native-store-screen-config.sh), [command and object checks](native-store-screen-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
