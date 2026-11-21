# Writing default and carried values with their slots

One experimental build for item 3 of [Buster #3196](https://github.com/buster14a/buster/issues/3196), based on [b3b6c3010](https://github.com/buster14a/buster/commit/b3b6c30102a68f47ab94247471ca4dd9924933a2). As the row writer compresses the kinds from eight records, it emits zero or one for each native entry and expands the direct record payloads into their first slots. A masked load reads the carried payloads. This removes the default-value initialization loop and the separate direct-payload list. Constant conversions, stores, strides, control labels, updates and numbering keep their existing fixups. Those fixups remain in the values interval.

The table reports the **combined row write and values passes, in TSC ticks per swept record**. Both executables used Release on locked Ryzen 7 9700X CPU 2. Seven rounds alternated ABBA and BAAB for each of the three corpora. Every one of the 84 invocations exited zero with the same coverage, no differing rows, and no difference between repeated executions. SQLite produced 315,461 admitted native entries, Lua 64,738 and musl 204,112.

| Corpus | First ordinary / changed | First paired change [range] | Repeat ordinary / changed | Repeat paired change [range] |
| --- | ---: | ---: | ---: | ---: |
| sqlite | 4.370 / 6.113 | +1.779 [+1.668, +1.909] | 2.789 / 3.747 | +0.944 [+0.894, +0.997] |
| lua | 6.862 / 8.252 | +1.366 [+1.282, +1.472] | 3.410 / 4.090 | +0.684 [+0.670, +0.728] |
| musl | 13.515 / 13.739 | +0.154 [-1.889, +1.995] | 4.058 / 5.055 | +1.010 [+0.954, +1.145] |

[paired.tsv](paired.tsv) includes the two intervals separately and together, all rows, the corresponding totals, and costs per admitted record. Each round averages its two readings for each binary before taking the difference. The columns give medians across rounds and the range of the seven paired differences.

[runs.tar.xz](runs.tar.xz) contains the original outputs, errors and exit statuses. To reproduce the tables, extract it and run `python3 scripts/pairs.py slots runs`. [environment.txt](environment.txt) records the source and binary revisions and host. The source difference is [experiment.patch](experiment.patch). The hardware runner and its corpus and lock scripts are in [scripts](scripts). The start script uses the already-built baseline executable in the directory of [the sweep-counter experiment](../../window-sweep-counters-3196-2026-11-21/). For the candidate, apply this patch to the same revision and build using `./build.sh --config Release`.
