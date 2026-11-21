# Hardware counters by window sweep

[Buster #3215](https://github.com/buster14a/buster/pull/3215) implements the first experiment in [#3196](https://github.com/buster14a/buster/issues/3196) for [#2850](https://github.com/buster14a/buster/issues/2850). These are measurements of the shadow on Buster commit [b3b6c3010](https://github.com/buster14a/buster/commit/b3b6c30102a68f47ab94247471ca4dd9924933a2). The measured source includes the pointer-ordering checks from #3213. Release, Ryzen 7 9700X CPU 2, one user-mode event per invocation. All 378 invocations exited zero.

Each cell gives **paired excess cycles per chunk on its first execution / cycles per record on its repeated execution**. The first number is the median of seven within-run differences. The second is the median repeated cost per record. SQLite, Lua and musl contributed 611, 241, 2,975 chunks per invocation and 321,434, 91,252, 377,187 records respectively.

| Sweep | SQLite | Lua | musl |
| --- | ---: | ---: | ---: |
| tests bytes | +8,210 / 4.76 | +11,818 / 4.86 | +4,997 / 5.59 |
| tests loop | +413 / 1.54 | +759 / 1.64 | +615 / 2.10 |
| contexts loop | +970 / 4.19 | +1,996 / 4.64 | +1,781 / 5.37 |
| contexts targets | +99 / 1.72 | +205 / 1.69 | +208 / 1.85 |
| contexts expressions | +195 / 2.55 | +274 / 2.14 | +184 / 2.37 |
| rows reads | +137 / 2.21 | +355 / 2.05 | +542 / 2.15 |
| rows shapes | +50 / 0.63 | +247 / 0.64 | +355 / 0.80 |
| rows lists | +294 / 0.95 | +482 / 0.89 | +384 / 0.89 |
| rows write | +97 / 1.06 | +304 / 1.20 | +634 / 1.62 |
| rows values | +884 / 2.83 | +1,395 / 3.61 | +1,195 / 3.83 |
| rows expressions | +55 / 1.16 | +76 / 1.03 | +58 / 1.27 |
| rows summaries | +92 / 0.36 | +239 / 0.49 | +215 / 0.63 |

Under #3196’s criterion of a first execution within 10% of the second on all three corpora, the qualifying sweeps were none. The tests’ bytes include declaration-line construction on first use. Repetition can both reuse those lines and warm the instruction and data caches. The lists interval includes checking whether a chunk has any updates or branches. Treat the paired excess as the observed cost of the first pass on this workload. The experiment does not isolate a fixed microarchitectural latency.

## Data and reproduction

[sweeps.tsv](sweeps.tsv) contains the first and second medians per chunk and per swept record, together with the paired difference and its seven-round range. It includes cycles, instructions, branch misses, L1 instruction and data read misses, and front-end stalls for all 12 sweeps on all three corpora. [runs.tar.xz](runs.tar.xz) contains the original stdout, stderr and exit status for every invocation. The collector reports raw counts and the median empty-interval cost. The reducer subtracts that cost once per chunk. Negative adjusted or paired values are retained.

Build the source revision with `./build.sh --config Release`. In a scratch job directory, place the three scripts `rounds.sh`, `corpora.sh` and `lock.sh` together, copy the compiler to `result/compiler`, and place the Lua 5.4.8 source in `inputs/lua-5.4.8/src`. The frozen SQLite and musl roots and options are in [corpora.sh](scripts/corpora.sh). On Benchpress `lock.sh` invokes the shared exclusive host wrapper. From the job directory, `bash rounds.sh 7` reproduces the seven rounds. [rounds.sh](scripts/rounds.sh) invokes `measure-node-machine --shadow --window-rows --passes 0 --window-counter FAMILY EVENT` once per corpus, with the usual exclusive host lock around each invocation. Each round additionally took the #2850 campaign lock to keep this session’s other timings out of it. [environment.txt](environment.txt) records the source revision, input and executable hashes, build environment and CPU.

To regenerate the summary from the archive, using the C reducer in this directory:

```sh
tar -xf runs.tar.xz
cc -std=c17 -O2 -Wall -Wextra -Werror scripts/summary.c -o summary
./summary raw/*.out > reproduced.tsv
```

The order of rows follows the input order. Sort both TSV files before comparing them.
