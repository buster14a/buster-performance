# lua-vm ordinary production compile

The source file was 59,115 bytes with SHA-256 `88b10a2f1f539cdfbefac818c64ceee59ac1b5f55038643637109a98834bb926`. Both stage runs reported 73,465 preprocessed tokens. All 60 recorded object outputs were 70,128 bytes with SHA-256 `818f116a71989e01ca4b6594d67d9694bfddc6ba89f8c8e4afdfae4bf231cad2`. Default diagnostic bytes agreed across every invocation within each timing series. The two `-Wall -Wextra` diagnostic streams agreed.

| Metric | Baseline median | Production median | Production minus baseline, median [min, max] |
| --- | ---: | ---: | ---: |
| cycles/token | 1,110.7329 | 855.1976 | −259.0895 [−276.8394, −178.8383] |
| user-instructions | 170,928,052.0 | 120,811,632.0 | −50,116,150.5 [−50,116,723.5, −50,114,054.0] |
| kernel-instructions | 11,534,527.0 | 9,449,754.0 | −1,954,943.5 [−2,298,758.0, +12,786,902.5] |
| wall-ms | 14.9870 | 11.1645 | −3.8380 [−3.8790, −3.7670] |

PMU process faults ranged from 1,592 to 6,498. Wall runs had 1,618–2,079 minor faults and zero major faults. All PMU events ran at 100% enabled time. Each wall observation followed a warm-up compile of the same source and mode.

lua-vm pmu contained process fault counts over 4,000 in round(s) 4. The paired cycles/token result after excluding those rounds was −264.9695 [−276.8394, −203.1201].

The [sample order](order.tsv), [per-process counters](samples.tsv), [raw perf and wall reports](reports.tar.xz), [object digests](objects.tsv) and [warning-mode diagnostic digests](diagnostics.tsv) and [default diagnostic digests](default-diagnostics.tsv) retain all observations.
