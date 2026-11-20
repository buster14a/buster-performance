# Internal compiler lanes

Each run compiles one translation unit with one, two or four internal compiler lanes, using that many physical cores. Seven post-warm-up pairs are summarized from 192 checked compilations. The [raw counters](counters.tsv.gz) and [dispersion](summary.tsv) include elapsed time, cycles, retired instructions, task-clock, minor faults and peak resident size.

| Workload | 1 lane | 2 lanes | 4 lanes |
|---|---:|---:|---:|
| sqlite-release | -1.09% | -1.25% | -0.59% |
| sqlite-debug | -13.64% | -15.41% | -19.06% |
| lua-vm-debug | -16.97% | -17.40% | -20.14% |
| lua-parser-release | -2.51% | +2.50% | -1.26% |
