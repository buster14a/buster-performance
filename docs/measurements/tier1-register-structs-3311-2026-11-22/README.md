# #3311: Tier 1 register-class structs kept in registers

Kernels from buster14a/buster#3311 (`acc = addv(acc, d)` 100,000,000 times, `addv` noinline,
returning a struct in registers), on benchpress (Ryzen 7 9700X), each timing run under
`exclusive.sh`, pinned with `taskset -c 2`, 11 rounds of every build in turn (`time.sh`).

- base: buster `1f7ce98f` (main), Release; fix: `60a51c45` (PR #3319), Release.
- clang: benchpress's host clang 23.1.1, `-O0` and `-O2`.
- `perf stat`'s counters were unavailable to the session (empty columns); wall times only.
- `i4.c`, `i2.c`, `l2.c`: `{int x,y,z,w}`, `{int x,y}`, `{long x,y}`. All builds print the same value
  (`kernels-build.log`).
- `times-*.tsv`: binary, round, ms (and the load/process snapshots before and after);
  `times-*.err`: the lock's wait lines; `summary.tsv`: min and median per binary.
- The i4 run's driver (`measure.sh`) died after its run because benchpress's /home filled up
  (100%, other sessions' trees); i2 and l2 were rerun by `one.sh` with the same timer.

| struct | clang -O0 | clang -O2 | Tier 0 | `--tier1` base | `--tier1` fix | base ÷ fix |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `{ int x, y, z, w; }` | 420.9 | 109.5 | 448.4 | 504.1 | 134.7 | 3.74× |
| `{ int x, y; }` | 408.0 | 109.3 | 411.1 | 439.4 | 91.2 | 4.82× |
| `{ long x, y; }` | 133.6 | 73.1 | 154.3 | 233.6 | 120.5 | 1.94× |

Medians in ms.
