# #1383: floating record members and short rows on the literal-table path

Branch `claude/1383-float-records-short-rows` of buster14a/buster. Base: main
`75751468ccbf751156bf2f10e552964b80bcf9ba`. Candidate: `c4c0525f1519e1221770b273de8cdc3b4f0fb897`
(`first-run/` holds the same run against the branch's first commit `27ea6a6527b3`, plus an
interleaved sqlite3.c control).

Host: benchpress (Ryzen 7 9700X), Release builds of both trees in `/tmp/1383-claude`, each
`-c` run pinned to CPU 2 (`taskset -c 2`), 5 whole processes per input and binary, one
`exclusive.sh` hold per input and binary. `measure.c` reports wall ms and the child's
`ru_maxrss`. Inputs are `gen.c SHAPE 1000000` (fixed seed); sqlite3.c is
`~/buster-fast-bench/653-claude/inputs/sqlite3.c`. `run.sh`, `sqlite.sh` and `build.sh` are
the scripts; `load.log` the load before and after each hold; `lock.log` the lock waits.

`compare.txt`: every object of the candidate is byte-identical to base's (both runs).

| input (1M values or rows) | base median ms | candidate median ms | speedup | base RSS MB | candidate RSS MB |
| --- | ---: | ---: | ---: | ---: | ---: |
| flat `const int t[]` (control) | 96.8 | 93.4 | 1.04x | 347 | 347 |
| `int t[][4]`, full rows (control) | 104.7 | 104.9 | 1.00x | 404 | 404 |
| `int t[][4]`, rows of 1-4 values | 459.9 | 72.7 | 6.32x | 1046 | 292 |
| `double t[][4]`, rows of 1-4 values | 557.2 | 92.6 | 6.02x | 1102 | 298 |
| `struct {int a, b;}` (control) | 225.0 | 229.0 | 0.98x | 857 | 857 |
| `struct {int a; double b;}` | 1977.8 | 252.4 | 7.84x | 3094 | 869 |
| `struct {int; float; double; long double;}` | 3328.0 | 504.3 | 6.60x | 5341 | 1447 |
| the same, block-scope static | 3180.2 | 536.1 | 5.93x | 5347 | 1489 |
| sqlite3.c (control) | 115.4 | 114.7 | 1.01x | 237 | 237 |

The first run's sqlite3.c readings for the candidate varied from 141 to 226 ms while
base's held at 118 ms (other load; see `first-run/load.log`); an interleaved rerun in
one hold (`first-run/sqlite-interleaved.tsv`) read 115.1 ms base, 114.7 ms candidate.
The first commit's full rows read 2.5% slower (104.3 to 107.0 ms); the candidate's
closes-only row count restores 104.7/104.9 ms.
