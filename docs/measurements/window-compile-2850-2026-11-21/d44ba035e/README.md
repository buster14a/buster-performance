# Frozen SQLite with conditional comparisons enabled at d44ba035e

The option admitted 1,367 additional expressions and avoided a net 2,734 additional graph nodes, but slowed the compilation against both baselines on the locked Ryzen 7 9700X. The same candidate executable spent 6.9352 additional user-plus-kernel cycles per preprocessed token when the option was enabled, and retired 890,113 more user instructions. The cycles and instruction counts increased in every paired round.

| Exact mode | Cycles/token | User instructions | Wall ms | MB/s |
| --- | ---: | ---: | ---: | ---: |
| #3224 parent with `--node-window` | 935.2391 | 1,340,045,298.5 | 121.8125 | 78.046 |
| Candidate with `--node-window` | 935.4847 | 1,339,536,517 | 121.6990 | 78.119 |
| Same candidate with `--node-window-conditions` | 941.9539 | 1,340,426,618.5 | 122.5550 | 77.574 |

| Conditions minus comparator | Paired cycles/token [min, max] | User instructions [min, max] | Wall ms [min, max] |
| --- | ---: | ---: | ---: |
| Parent opt-in | +7.18947 [+4.44269, +8.52166] | +381,859 [+379,566, +382,235] | +0.4370 [+0.1155, +1.2775] |
| Same-binary regular opt-in | +6.93520 [+5.10517, +9.40532] | +890,113 [+889,270, +892,307.5] | +0.6620 [−11.4730, +1.6790] |

One same-binary regular opt-in wall sample in round 5 took 146.648 ms and had 59,950 minor faults. The comparison includes that sample. Excluding its entire round, the condition option was slower than either comparator in every remaining round, with a median increase of +0.7213 ms (+0.1150 to +1.6790) against regular opt-in and +0.5885 ms (+0.3080 to +1.2775) against parent opt-in. The cost result applies to this source, compiler mode and frozen input.

The ordinary and two regular opt-in controls used the [parent assignment source and flags](../39cd1b6ce/README.md). The extra condition option on d44ba035e84172eaac4ddd4b4b3339bb4fd34b9b admitted 4,344 expressions, replacing 11,635 ordinary nodes with 4,344 summaries. This left a 316,332-node graph. Both regular opt-ins admitted 2,977 expressions and produced a 319,066-node graph. The condition candidate Release executable has SHA-256 ef53aa8b953af9e554714c3d1abb240a684fd0117d2fa111db60cef366fd22ae. The source patch applies to 39cd1b6ce77f2289a56ec0d1de2f5044e1607979.

All 92 observed compiles produced the same 2,061,192-byte object (SHA-256 efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa). This includes 42 timed PMU, 42 timed wall, four stage and four additional `-Wall -Wextra` compiles. The ordinary candidate `-c` was the fourth stage and warning control. All four warning runs wrote the same 3,701 stderr bytes and empty stdout.

Seven rounds followed the [paired driver method](../paired-driver/README.md). The sample tables use `prioron` for the parent, `off` for the candidate's **regular opt-in**, and `on` for the additional condition option. [Raw PMU samples](pmu.tsv) · [Raw wall samples](wall.tsv) · [Faults](wall-faults.tsv) · [Stage and perf output](process-counters.tar.xz) · [Wall reports](wall-reports.tar.xz) · [Warnings](warnings.tsv)

The [exact-head correctness and fidelity archive](correctness/README.md) includes the target-feature and chunk-boundary matrices, per-translation-unit receipts, seeded generator, historical probes, corpus sweeps, sanitizer check, reproducible scripts and SHA-256 manifest. These checks qualify the semantics of the experimental option alongside its measured throughput regression.
