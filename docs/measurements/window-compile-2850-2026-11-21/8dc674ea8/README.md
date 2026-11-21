# Intermediate frozen SQLite compilation of the local-read candidate

An independent check subsequently found a missing object field on a bare return in the checked representation. The production successor 3c06b4abb corrects the field. This record describes only the measurements of the earlier source.

The opt-in path at 8dc674ea879be50331f88cab04f0961b90de3d90 admitted 2,214 expressions, 707 more than its opt-in parent at 55700f5a4ca30d139fd406bb36dc3ee38adf7ffd. It replaced 4,482 ordinary graph nodes with 2,214 summaries. The resulting graph had 321,355 nodes, 707 fewer than the parent's opt-in graph.

| Mode | User + kernel cycles/token | User instructions/compile | CPU task time (ms) | Elapsed time (ms) | MB/s |
| --- | ---: | ---: | ---: | ---: | ---: |
| Parent, flag on | 931.1154 | 1,338,659,439 | 120.45 | 121.2145 | 78.432 |
| Candidate, flag off | 933.8129 | 1,344,022,133 | 120.64 | 121.3835 | 78.322 |
| Candidate, flag on | 933.2677 | 1,338,691,862.5 | 120.56 | 120.7855 | 78.710 |

Paired flag-on minus flag-off differences were −0.7238 cycles/token (−3.6848 to +2.8678) and −5,330,271 user instructions. Compared with the preceding opt-in path, the new admission used +0.8802 cycles/token (−1.9130 to +5.4021) and +32,423 user instructions (+31,942 to +32,919.5). The first paired wall round gave −0.5980 ms against flag-off and −0.4290 ms against the preceding opt-in. The checkpoint stopped the series at the next round boundary once a corrected source was ready. The hardware evidence establishes increased graph avoidance. It leaves an end-to-end throughput gain unresolved.

The three modes produced exactly the same 2,061,192-byte object in all 42 PMU compiles, six timed wall compiles, three stage-reported compiles and three additional `-Wall -Wextra` compiles. The object SHA-256 was efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa. The ordinary timed runs wrote empty stdout and stderr. The three extra warning runs produced identical 3,701-byte stderr (SHA-256 a3137fb77b1b62c77da81db5afea4606c4e50940f8fe52656b9c71ce2a2bfc6c) and empty stdout.

The [preceding campaign](../84a7d3d76/README.md) identifies the frozen 9,507,037-byte SQLite release input, its 716,136 preprocessed tokens, defines, CPU 2 affinity, single-core Ryzen 7 9700X, and the paired six-position order used here. The opt-in parent occupied the control positions. The PMU series completed seven rounds. The wall figures are the mean of the two positions per mode in its single completed round. Each wall measurement followed one warm-up in the same position. All perf events were active for 100% of the measured time. The candidate executable SHA-256 is 5992053ac0b718bba7444c3f2ff033f92d95bb1866fa0d7471b16a4dbb416a3b, and the preceding opt-in executable SHA-256 is 5e4ef0125ce15882f78299b6dfb76a39f80bcb10f93255e01ea4d4d7a064e93f. The source patch applies to parent 55700f5a4.

[PMU samples](pmu.tsv) · [PMU and stage reports](process-counters.tar.xz) · [Wall samples](wall.tsv) · [Wall reports](wall-reports.tar.xz) · [Warning and object digests](warnings.tsv)
