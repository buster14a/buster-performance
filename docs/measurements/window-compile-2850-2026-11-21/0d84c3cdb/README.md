# Assignment discovery behind its own opt-in at 0d84c3cdb

The regular `--node-window` option retained 2,214 admissions, matching the preceding local-reads compiler. The separate `--node-window-assignments` option increased this to 2,977. Enabling stores saved 1,928,154.5 user instructions per compile at the paired median. Its wall and cycle ranges crossed zero. The feature-specific path therefore has measured instruction savings and unresolved throughput impact.

| Exact binary and mode | Expressions taken | Graph nodes | Cycles/token | User instructions | Wall ms |
| --- | ---: | ---: | ---: | ---: | ---: |
| 227853575 with `--node-window` | 2,214 | 321,355 | 934.12123 | 1,340,753,030 | 120.8885 |
| 0d84c3cdb ordinary `-c` | 0 | 323,623 (ordinary graph) | 934.55699 | 1,346,114,853.5 | 120.9810 |
| 0d84c3cdb with `--node-window` | 2,214 | 321,355 | 932.18854 | 1,341,293,208.5 | 121.2190 |
| 0d84c3cdb with `--node-window-assignments` | 2,977 | 319,066 | 933.99419 | 1,339,365,043 | 121.1275 |

The ordinary graph size is inferred from either opt-in graph and its counters for ordinary nodes replaced and summaries inserted. Both routes yield 323,623.

| Paired option difference | Cycles/token, median [min,max] | User instructions, median | Wall ms, median [min,max] |
| --- | ---: | ---: | ---: |
| Regular option minus 227853575's opt-in | −2.96635 [−3.60543, +97.06013] | +540,214.5 | +0.1290 [−0.7520, +3.8060] |
| Regular option minus same executable ordinary | −2.06750 [−7.67209, +98.64680] | −4,821,609 | +0.2780 [−0.4660, +3.5590] |
| Assignment option minus same executable regular | +0.02046 [−97.18716, +10.37740] | −1,928,154.5 | +0.1080 [−3.7780, +0.6860] |
| Assignment option minus 227853575's opt-in | −2.36893 [−3.00906, +7.17785] | −1,387,999 | +0.0280 [−0.6150, +1.2650] |
| Assignment option minus same executable ordinary | −0.25055 [−2.95680, +2.70531] | −6,749,811.5 | +0.0300 [−0.2190, +0.7265] |

One regular-option PMU process (round 6, position 5) incurred 59,900 page faults and 1,128.21 cycles/token. All other PMU processes had fewer than 5,700 page faults, and every elapsed-time sample had fewer than 5,800 minor faults. Retaining only the six complete low-fault PMU rounds, regular opt-in changed cycles/token by −2.97510 [−3.60543, −1.92757] versus 227853575's opt-in and −2.39043 [−7.67209, −0.27101] versus its own ordinary compile. The assignment switch versus regular opt-in changed cycles/token by +0.44414 [−0.51010, +10.37740]. The original seven-round results preserve all observations. Per-process huge-page mappings were not collected.

The locked Ryzen 7 9700X ran 56 PMU processes and a separate 56 timed wall processes on CPU 2, using seven rotated palindrome rounds of eight positions each. The four stage and four `-Wall -Wextra` checks used the same input and mode selections. All 120 output objects were byte-identical by SHA-256 (efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa, 2,061,192 bytes). All warning-mode stderr outputs were identical (3,701 bytes) with empty stdout.

The qualified candidate is 0d84c3cdb8b3146c03c874ac2c553279c4d1eed2, Release binary SHA-256 65cba6c5358c9a4c8f393eeddb0867e51a17f939f8450d6d94dabd4d5dde7ca5. The reference is 227853575f341342bb02e6b4c38c79044ce691bc. The source patch applies to 39cd1b6ce77f2289a56ec0d1de2f5044e1607979. The [single-image diagnostic comparison](../39cd1b6ce/assignment-controls/README.md) isolates the underlying candidate-discovery and store paths. The [frozen SQLite method](../paired-driver/README.md) records input size and token denominator.

[Raw PMU and wall samples](samples.tsv) · [Full order](order.tsv) · [Original timing reports](measurements.tar.xz) · [Object digests](objects.tsv) · [Diagnostic digests](warnings.tsv) · [Stage reports](stages.tar.xz)
