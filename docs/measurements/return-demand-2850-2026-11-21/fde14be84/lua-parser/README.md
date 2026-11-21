# lua-parser ordinary production compile

The source file was 56,339 bytes with SHA-256 `c5507307586c1a2336a7722229f7b350ae9c548b854933b370ad150e9e6e7f84`. Both stage runs reported 24,078 preprocessed tokens. All 28 recorded object outputs were 51,568 bytes with SHA-256 `66995b0d9a26977b07b3a83cb1cdd08ea9f9057a6f416b3493e7813599dabd8a`. Default diagnostic bytes agreed across every invocation within each timing series. The two `-Wall -Wextra` diagnostic streams agreed.

| Metric | Baseline median | Production median | Production minus baseline, median [min, max] |
| --- | ---: | ---: | ---: |
| cycles/token | 1,510.9174 | 1,522.0267 | +11.1094 [−37.8229, +22.3843] |
| user-instructions | 59,248,138.0 | 58,959,170.0 | −288,968.0 [−289,017.0, −288,461.0] |
| kernel-instructions | 7,334,906.5 | 7,363,454.0 | +32,355.0 [−96,706.0, +291,005.0] |
| wall-ms | 6.2045 | 6.1190 | −0.1530 [−0.2840, −0.0065] |

PMU process faults ranged from 1,169 to 1,174. Wall runs had 1,191–1,197 minor faults and zero major faults. All PMU events ran at 100% enabled time. Each wall observation followed a warm-up compile of the same source and mode.

The [sample order](order.tsv), [per-process counters](samples.tsv), [raw perf and wall reports](reports.tar.xz), [object digests](objects.tsv) and [warning-mode diagnostic digests](diagnostics.tsv) and [default diagnostic digests](default-diagnostics.tsv) retain all observations.
