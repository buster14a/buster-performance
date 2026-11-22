# Source-owned native compilation and typed-row retirement

SQLite emitted its complete 2,061,192-byte reference ELF with zero persistent expression nodes and one reserved graph slot. All 2,674 function bodies entered the source path. It emitted 2,665 native fragments (1,063,662 bytes and 15,777 relocations). It released 380,405 of 381,191 typed slots in 2,671 bodies after early native lowering. Both compiler modes and the independent ordinary compiler produced the same object on SQLite and Buster. All 6,860 independent local source/policy observations matched status, stdout, stderr and object bytes or absence. This includes 863 ordinary failures. [Source](source.patch), [build identity](revision.txt), [local policy counts](source-policy.tsv), [local records](local-records.tar.gz).

| Fresh one-core Release compilation on 9700X CPU 2 | Ordinary | Source | Median paired difference | Candidate wins |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 114.0803 ms | 128.5955 ms | +14.4717 ms | 0/5 |
| Buster | 612.5143 ms | 664.7129 ms | +52.1986 ms | 0/5 |

SQLite's five paired wall differences ranged from +13.4747 to +14.9044 ms. Peak RSS increased by 33,716 KiB. Three separate PMU rounds added 296.633 million user instructions and 80.318 million total cycles. One ordinary PMU invocation had 56,663 minor faults against roughly 5,500 typically. It is included in the unfiltered observations and in its pair. Buster added 865.634 million user instructions, 280.489 million total cycles and 5,096 KiB peak RSS. Every invocation acquired the shared lock individually. [Individual observations](samples.tsv), [paired wall and counter results](paired.tsv), [raw receipts and harnesses](native-records.tar.gz).

The four separate perf profiles retained every recorded sample. The recorded instruction event totals cover a fraction of the full process counters. The sample rankings describe where the profiles observed work. The separate perf stat measurements above give the full invocation totals. [Instruction sample rankings](rank-instructions.tsv), [cycle sample rankings](rank-cycles.tsv), [four raw perf.data recordings, symbol and IP reports, stage logs and commands](profiles.tar.gz).
