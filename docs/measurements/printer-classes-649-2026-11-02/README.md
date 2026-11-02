# #649: the printer's classes by kind and leaner batch copies, 9700X, 2026-11-02

Evidence for [buster14a/buster#1184](https://github.com/buster14a/buster/pull/1184) (issue
[#649](https://github.com/buster14a/buster/issues/649)). Base: buster `3ce71ec3`. The change: buster
`8b0e8b63` (the PR's first commit; its printer, `src/buster/compiler/c_preprocessor.c`, sha256
`8aa69219ed1168173e7e227af5f21a03ac8f65c69906a844611a5032deb9a761`, is the measured `v6`'s byte for byte).

## Host and method

- AMD Ryzen 7 9700X, kernel 6.18.50-2-lts, clang 23.1.1, CPU 2 (governor `performance`, EPP `performance`; its
  SMT sibling offline), every run under the host's exclusive lock and `taskset -c 2`.
- Each tree built with `BUSTER_DEBUG_INFO=0 ./build.sh` (`-march=native`, znver5) on the host.
- Inputs: `main.c` from `3ce71ec3`'s `src` for every tree (`-target x86_64-pc-linux-gnu -march=native -I<base>/src
  -fwrapv -funsigned-char <base>/src/buster/compiler/main.c`), and the host's pinned corpus
  `/var/lib/buster-9700x/corpora/preprocessor-391e729af658` for `sqlite3.c` (the arguments of the 9700X workflow's
  printer step).
- `benchmark-preprocessor --only vectorized [--markers]`: each run is one process of a warm-up and 21 passes, each
  pass preprocessing from nothing and then printing once to `/dev/null`, timed apart (`printing`) and with the run
  (`-E -P with printing` / `-E with printing`, the "whole run"). The tables give the median over the runs of each
  run's median.
- `abr.sh` / `abk.sh`: rounds of every tree (or tree and environment) and configuration, the order reversed every
  other round, each round one lock hold (`round.sh`, which they write).
- The repeat harness (`scripts/repeat.patch.py`, `patches/base-r.patch`; not in buster): with
  `BUSTER_PP_PRINT_REPEAT=N`, each pass prints N more times after the timed print, reading user-space cycles and
  instructions around each print (`repeat ... cycles/token ... instructions/token`). Its code runs after the timed
  print and only with the variable set; `v2` to `v7` carry it, the measured `base` and `v1` don't.
- The knobs (`scripts/knobs.patch.py`; not in buster): `BUSTER_PP_PRINT_PREFETCH` (0 none, 1 every spelling, 3
  identifiers', 4 the other tokens', 5 each range's span a line at a time) and `BUSTER_PP_PRINT_BUFFER` (log2 of
  the output buffer), read once.
- Lock messages: the logs were reduced to the lines the benchmark, the harness and `perf record` print
  (`scripts/keep_own.py`), which drops the lock's waiting messages naming other holders; the rounds' lock logs
  are left out.

## Trees (`patches/`, each against `3ce71ec3`'s `src`)

| tree | what |
| --- | --- |
| `base` | `3ce71ec3` |
| `base-r` | `base` with the repeat harness |
| `v1` | classes by kind (step 1 no longer reads two bytes a token) |
| `v2` | `v1` with the knobs |
| `v3` | `v1`, the leaner copies (spaces by `_mm512_storeu_si512`, which clang made a `memset` call) and batches ending at a long spelling, with the knobs |
| `v4` | `v3` with the spaces' stores masked to the batch and the `vpermb` check |
| `v5` | `v4` with knob 5 (it computes each range's span whatever the knob) |
| `v6` | the PR's first commit (prefetch for `-P` alone), with the harness |
| `v7` | `v6` with the copy loop unrolled by two |

## Results

`ab6/` (seven rounds, `base`, `v6`, `v7`), printing and whole-run medians in ms:

| | `base` | `v6` | `v7` |
| --- | --- | --- | --- |
| `main.c`, `-E -P` printing | 18.363 | 17.941 | 17.767 |
| `main.c`, `-E -P` whole | 103.919 | 103.070 | 102.845 |
| `main.c`, `-E` printing | 27.698 | 24.807 | 24.790 |
| `main.c`, `-E` whole | 102.195 | 97.633 | 97.884 |
| `sqlite3.c`, `-E -P` printing | 1.776 | 1.685 | 1.680 |
| `sqlite3.c`, `-E -P` whole | 12.584 | 12.265 | 12.317 |
| `sqlite3.c`, `-E` printing | 3.509 | 3.294 | 3.293 |
| `sqlite3.c`, `-E` whole | 14.046 | 13.595 | 13.618 |

`rep6/` (the harness, `BUSTER_PP_PRINT_REPEAT=4`, one run each, means of 88 prints of `main.c`):

| | `base-r` | `v6` | `v7` |
| --- | --- | --- | --- |
| `-P` instructions / cycles a token | 53.15 / 14.43 | 44.16 / 13.94 | 41.77 / 14.12 |
| `-E` instructions / cycles a token | 80.44 / 21.92 | 60.62 / 19.29 | 58.21 / 19.33 |

The other directories:
- `ab2/`: `base` against `v1`, seven rounds. `v1`'s `-P` printing was 9.3% (`main.c`) and 12.7% (`sqlite3.c`)
  slower, and with line markers 3.2% and 5.0% faster. `rep1/` has its harness counters.
- `kn1/`, `kn3/`, `kn4/`: `v2`, `v3`, `v4` with knob settings on `main.c`, three rounds each (`settings.txt`).
- `ab5/`: `base` against `v5` with knobs 0, 4 and 5, five rounds (`entries.txt`).
- `base-P/`, `v1-P/`: `perf record -e cycles:u -c 200003` of a `-P` run, by symbol. `iprof-base/`: the same with
  `instructions:u` and the harness. `fills-base/`: `ls_dmnd_fills_from_sys.{local_l2,local_ccx,dram_io_all}:u`,
  period 2003, by symbol, with each event's total count.

## Limitations

- One host, one CPU; the trees were sent by `tar` from snapshots of the working tree, whose `src` the patches
  describe.
- The harness's prints are warm (the same run printed again), unlike the benchmark's one print after each run;
  its counters attribute work, and the tables' times come from the benchmark.
- `main.c` is buster's own source at `3ce71ec3`; `sqlite3.c` is one other input.
