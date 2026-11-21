# Frozen SQLite with both explicit store extensions

Adding field stores to the for-initializer candidate saved another 2.018 million retired user instructions per compile. The median change in cycles per token was +0.0050, with a range of −4.1473 to +31.2789. The largest positive difference was in round 3, which included a combined-mode process at 129.46 ms task-clock. Every sample remained in the low-fault range. Seven paired rounds establish the reduction in retired work and leave the incremental throughput effect unresolved. All 48 native outputs agreed. The [combined correctness qualification](correctness/README.md) includes all 4,468 checked roots and all 381,191 sourced native entries.

The combined candidate extends the explicit assignment option with field stores through a local pointer and first assignments in for-loop initializers. The shared parent admits 2,977 expressions. For-initializer stores alone add 610, and the combined candidate adds another 881 field stores. This experiment pairs these three sources in the same sessions. All three use the same `--node-window-assignments -c` arguments. The [independent sibling experiments](../assignment-siblings-screen/README.md) and [portable qualification of the two shapes](../assignment-shapes/README.md) supplement these measurements.

The measured source `fa88df117cb04f1dc8b296101ce5613c5ce1558b` and the feature-stack revision `84adabc089262fbf3a2ffd92248d706a9251c388` both have Git tree `86a0d00be20427e5388087458c4a8ca5214f16ab`. Each reader can reproduce this with `git show -s --format=%T REVISION`. The [patch against the for-initializer source](field-on-for.patch) reproduces the combined tree.

| Mode | Expressions taken | Ordinary nodes replaced | Final graph nodes | Median cycles/token | Median user instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| parent | 2,977 | 7,534 | 319,066 | 937.4611 | 1,339,364,992.5 |
| for-init | 3,587 | 9,974 | 317,236 | 934.9759 | 1,336,830,616.5 |
| combined | 4,468 | 14,379 | 313,712 | 933.4421 | 1,334,812,345.5 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median |
| --- | ---: | ---: |
| combined minus for-init | +0.0050 [−4.1473, +31.2789] | −2,018,304.5 |
| combined minus parent | −3.7355 [−6.3627, +22.4749] | −4,552,630.0 |
| for-init minus parent | −2.3760 [−8.8040, +0.3281] | −2,534,376.0 |

PMU fault counts ranged from 5,662 to 5,672.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 48 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| parent | `0d84c3cdb8b3146c03c874ac2c553279c4d1eed2` | `65cba6c5358c9a4c8f393eeddb0867e51a17f939f8450d6d94dabd4d5dde7ca5` |
| for-init | `a62702e323e37ec9777b7efbc94d70a05598e38f` | `c1c19ff78e47d204c728be75556e3fb7193e383bc977b96e4d46dc52ea56994f` |
| combined | `fa88df117cb04f1dc8b296101ce5613c5ce1558b` | `93923db5acf3d637e3c2fe8c437c3a22d682919edcebfceba4d697d9293bd727` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](combined-store-config.sh), [command and object checks](combined-store-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.
