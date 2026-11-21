# sqlite ordinary production compile

The source file was 9,507,037 bytes with SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Both stage runs reported 716,136 preprocessed tokens. All 60 recorded object outputs were 2,061,192 bytes with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostic bytes agreed across every invocation within each timing series. The two `-Wall -Wextra` diagnostic streams agreed.

| Metric | Baseline median | Production median | Production minus baseline, median [min, max] |
| --- | ---: | ---: | ---: |
| cycles/token | 936.7660 | 920.2512 | −15.2178 [−39.5855, −10.1991] |
| user-instructions | 1,347,887,577.0 | 1,326,932,510.5 | −20,955,068.5 [−20,956,128.5, −20,952,731.5] |
| kernel-instructions | 34,527,387.0 | 34,166,240.5 | −187,300.0 [−617,288.5, +451,074.0] |
| wall-ms | 121.0090 | 119.0605 | −1.9950 [−2.5040, −1.4485] |

PMU process faults ranged from 5,658 to 5,672. Wall runs had 5,766–5,773 minor faults and zero major faults. All PMU events ran at 100% enabled time. Each wall observation followed a warm-up compile of the same source and mode.

The [sample order](order.tsv), [per-process counters](samples.tsv), [raw perf and wall reports](reports.tar.xz), [object digests](objects.tsv) and [warning-mode diagnostic digests](diagnostics.tsv) and [default diagnostic digests](default-diagnostics.tsv) retain all observations.
