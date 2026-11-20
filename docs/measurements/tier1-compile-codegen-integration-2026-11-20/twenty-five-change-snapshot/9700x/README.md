# Ryzen 7 9700X compilation with 25 PRs

The exact main and integrated compilers each built three real translation units at one lane. Each cell contains one warm-up and three alternating-order measured pairs. Every invocation used a short free window on CPU 2. The [24 processes](processes.tsv) include timings, counters, UTC timestamps and output hashes. The [artifact comparison](local-remote-objects.tsv) records the local and target outputs.

| Workload | Instructions | User cycles | Cycle range, % |
|---|---:|---:|---:|
| lua-lvm | -32.143% | -22.522% | -23.00,-22.44 |
| sqlite-O2 | -20.973% | -12.729% | -12.85,-12.70 |
| sqlite-tier1 | -2.350% | -1.960% | -2.02,-1.94 |
