# Writing every native payload in its final slot

One experimental build for item 3 of [Buster #3196](https://github.com/buster14a/buster/issues/3196), based on [b3b6c3010](https://github.com/buster14a/buster/commit/b3b6c30102a68f47ab94247471ca4dd9924933a2). The candidate computes the rare numbering decisions first, including labels for earlier arms, nested call rows and temporary locals. It then emits a final value for every slot during row compression. The values interval measures the preparation, and the write interval measures emission. Both intervals and their sum are included in the comparison. [Local differential checks](local/summary.txt) exercised the seven value sources, a control-flow fixture, the three frozen corpora and the compiler translation unit under both warning policies.

The table reports the **combined row write and values passes, in TSC ticks per swept record**. Both executables used Release on locked Ryzen 7 9700X CPU 2. Seven rounds alternated ABBA and BAAB for each of the three corpora. Every one of the 84 invocations exited zero with the same coverage, no differing rows, and no difference between repeated executions. SQLite produced 315,461 admitted native entries, Lua 64,738 and musl 204,112.

| Corpus | First ordinary / changed | First paired change [range] | Repeat ordinary / changed | Repeat paired change [range] |
| --- | ---: | ---: | ---: | ---: |
| sqlite | 4.357 / 18.619 | +14.261 [+14.073, +14.347] | 2.788 / 7.960 | +5.192 [+5.126, +5.211] |
| lua | 6.836 / 19.867 | +13.041 [+12.951, +13.292] | 3.408 / 8.017 | +4.606 [+4.601, +4.637] |
| musl | 14.188 / 25.001 | +10.812 [+9.462, +12.197] | 4.018 / 8.948 | +4.953 [+4.868, +7.585] |

[paired.tsv](paired.tsv) includes the two intervals separately and together, all rows, the corresponding totals, and costs per admitted record. Each round averages its two readings for each binary before taking the difference. The columns give medians across rounds and the range of the seven paired differences.

[runs.tar.xz](runs.tar.xz) contains the original outputs, errors and exit statuses. To reproduce the tables, extract it and run `python3 scripts/pairs.py slots runs`. [environment.txt](environment.txt) records the source and binary revisions and host. The source difference is [experiment.patch](experiment.patch). The hardware runner and its corpus and lock scripts are in [scripts](scripts). The start script uses the already-built baseline executable in the directory of [the sweep-counter experiment](../../window-sweep-counters-3196-2026-11-21/). For the candidate, apply this patch to the same revision and build using `./build.sh --config Release`.
