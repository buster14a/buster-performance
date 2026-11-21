# sqlite ordinary production compile

The source file was 9,507,037 bytes with SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Both stage runs reported 716,136 preprocessed tokens. All 28 recorded object outputs were 2,061,192 bytes with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostic bytes agreed across every invocation within each timing series. The two `-Wall -Wextra` diagnostic streams agreed.

| Metric | Baseline median | Production median | Production minus baseline, median [min, max] |
| --- | ---: | ---: | ---: |
| cycles/token | 930.5777 | 934.3892 | +3.4020 [+2.3927, +99.2058] |
| user-instructions | 1,346,011,650.5 | 1,346,011,894.5 | +719.5 [+244.0, +26,993.5] |
| kernel-instructions | 33,448,485.0 | 33,357,848.0 | −112,229.5 [−526,031.5, +93,316,829.5] |
| wall-ms | 120.5260 | 120.6160 | +0.0590 [−0.0120, +0.2735] |

PMU process faults ranged from 5,658 to 59,016. Wall runs had 5,766–5,770 minor faults and zero major faults. All PMU events ran at 100% enabled time. Each wall observation followed a warm-up compile of the same source and mode.

sqlite pmu contained process fault counts over 20,000 in round(s) 2. The paired cycles/token result after excluding those rounds was +2.8973 [+2.3927, +3.4020].

The [sample order](order.tsv), [per-process counters](samples.tsv), [raw perf and wall reports](reports.tar.xz), [object digests](objects.tsv) and [warning-mode diagnostic digests](diagnostics.tsv) and [default diagnostic digests](default-diagnostics.tsv) retain all observations.
