# Guarded direct-return calls, three-round frozen SQLite screen

The guarded prototype admitted another 119 direct-return calls. The graph shrank by 355 nodes and all 14 successful compiles produced the same object. The paired instruction count fell in each round by about 0.026%. The cycle differences changed sign and the three-round screen provides no evidence of a consistent throughput gain.

| Paired prototype minus baseline | Round 1 | Round 2 | Round 3 | Median |
| --- | ---: | ---: | ---: | ---: |
| User + kernel cycles per preprocessed token | −3.1750 | +2.5946 | +8.3790 | +2.5946 |
| User instructions | −343,296 | −341,608.5 | −342,070 | −342,070 |

Both modes used the same Release executable from 566a5293e85c8463a4c60dfeacf8ccf5cd9c9e05, built over the #3224 assignment source 39cd1b6ce77f2289a56ec0d1de2f5044e1607979. Both used `--node-window --lanes 1 -c` and `BUSTER_CALL_GUARD=1`. The baseline left `BUSTER_CALL_PROTO` unset and the prototype set it to 1. Both left the logging and missing-reference controls unset. The [frozen SQLite input and arguments](../paired-driver/README.md) had 716,136 tokens. The host lock, CPU affinity and per-round pairing matched the other native comparisons. The order was A-B-B-A, B-A-A-B, A-B-B-A across the three rounds.

The candidate moved from 2,977 taken expressions / 7,534 ordinary nodes replaced / 319,066 final graph nodes to 3,096 / 8,008 / 318,711. The 12 timed compiles and two separate stage runs each produced a 2,061,192-byte ELF object with SHA-256 efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa. The PMU events ran at 100% enabled time, and all process page-fault counts were between 5,665 and 5,669.

The [local correctness qualification and source patch](correctness/README.md) include the guarded and unguarded differential matrices, Clang and Buster comparisons, ELF and diagnostic receipts by unit, a linked executable and a causal reference-removal control. The [exact run order](order.tsv), [per-invocation command](call-screen-one.sh) and [raw measurements, statuses and hashes](measured-runs.tar.xz) reproduce this experimental screen.
