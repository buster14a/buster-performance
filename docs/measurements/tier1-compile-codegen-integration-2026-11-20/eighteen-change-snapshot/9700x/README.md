# Ryzen 7 9700X compilation with 18 PRs

The exact main and integrated compilers each built three real translation units at one lane. Each cell contains one warm-up and three alternating-order measured pairs. Every invocation used a short free window on CPU 2. The [24 processes](processes.tsv) include timings, counters, UTC timestamps and output hashes. The [artifact comparison](local-remote-objects.tsv) records the local and target outputs.

| Workload | Instructions | User cycles | Cycle range, % |
|---|---:|---:|---:|
| lua-lvm | -32.113% | -22.267% | -22.56,-22.19 |
| sqlite-O2 | -20.519% | -12.252% | -12.28,-12.01 |
| sqlite-tier1 | -2.217% | -1.531% | -1.74,-1.51 |
