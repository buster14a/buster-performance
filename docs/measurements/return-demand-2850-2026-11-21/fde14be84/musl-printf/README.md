# musl-printf ordinary production compile

The source file was 16,763 bytes with SHA-256 `5ae7748a197b3c334f2b6791f8613940f27d3bac6f27bcfa73706222fff4ffa8`. Both stage runs reported 16,184 preprocessed tokens. All 28 recorded object outputs were 24,072 bytes with SHA-256 `a19e50ed30f084a39ee48ef0be9a3f82e9be1f4524d1803c38f224eb61dda651`. Default diagnostic bytes agreed across every invocation within each timing series. The two `-Wall -Wextra` diagnostic streams agreed.

| Metric | Baseline median | Production median | Production minus baseline, median [min, max] |
| --- | ---: | ---: | ---: |
| cycles/token | 1,588.1538 | 1,570.0901 | −29.2457 [−34.3076, −0.5944] |
| user-instructions | 38,254,980.5 | 37,920,378.5 | −334,581.0 [−334,676.0, −334,552.0] |
| kernel-instructions | 6,984,513.0 | 6,943,795.5 | −38,984.5 [−67,444.0, −6,498.0] |
| wall-ms | 4.2065 | 4.0985 | −0.1080 [−0.1605, +0.1225] |

PMU process faults ranged from 979 to 983. Wall runs had 997–1,000 minor faults and zero major faults. All PMU events ran at 100% enabled time. Each wall observation followed a warm-up compile of the same source and mode.

The [sample order](order.tsv), [per-process counters](samples.tsv), [raw perf and wall reports](reports.tar.xz), [object digests](objects.tsv) and [warning-mode diagnostic digests](diagnostics.tsv) and [default diagnostic digests](default-diagnostics.tsv) retain all observations.
