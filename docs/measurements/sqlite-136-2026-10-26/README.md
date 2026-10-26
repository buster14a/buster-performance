# SQLite through Tier 0, against clang -O0 and tcc

2026-10-26, for [buster14a/buster#136](https://github.com/buster14a/buster/issues/136):
how SQLite 3.53.2's amalgamation (`sqlite3.c` and `shell.c` of the frozen
corpus `preprocessor-corpora-astra-01a158dd`) fares compiled by this compiler's
`-c` (Tier 0's code), by clang 23.1.1 at -O0 and by tcc 0.9.28rc.

## Source and inputs

- buster: `c96562c00eced8fc6581ded429a7a887d1d6fe95`, the libgcc.a branch of #483 at the time; `manifest-c96562c0.sha256`
  lists the measured tree's `build.sh`, `src` and `tests`, which match that
  commit's `git archive` byte for byte. Built with `BUSTER_DEBUG_INFO=0 ./build.sh`.
- `identities.txt`: the compilers' versions, the host, and the sha256 of
  `sqlite3.c`, `shell.c`, `sqlite3.h` and the measured `build/compiler`.
- `work.sql`: the shell's workload, of our own: 300,000 rows inserted in a
  recursive CTE, indexed, aggregated, self-joined, updated, deleted, sorted and
  grouped. SQLite's own speedtest1 isn't in the corpus.

## Commands

`sq-measure.sh`, on the 9700X under one hold of the shared lock (about a
minute), pinned to CPU 2: `sqlite3.c` compiled 11 rounds by each compiler in a
rotating order (`compile.times`, microseconds); the shell built from each one's
objects of `sqlite3.c` and `shell.c`, linked by `cc` with `-lm -lpthread
-ldl`, running `work.sql` on `:memory:` 7 rounds in a rotating order
(`run.times`), each output compared with clang's; and `size` of the objects.
`measure.log` is its report.

## Results

| | buster `-c` | clang -O0 | tcc |
|---|---|---|---|
| `sqlite3.c` compiled, median of 11 | 192.4 ms | 560.1 ms | 42.9 ms |
| the shell running `work.sql`, median of 7 | 768.2 ms | 882.5 ms | (didn't link) |
| `sqlite3.o`'s text, as `size` counts it | 1,309,287 bytes | 1,111,708 | 1,375,335 |

The two shells print the same bytes (md5 `d080c12b7025e25108257c688dbe71c3`).
tcc's objects didn't link: through `cc`, an earlier run found them needing
tcc's runtime's `__floatundidf` (`libtcc1.a`'s) and GNU ld refusing their
FDEs ("overlapping FDEs"), and tcc's own link, which `sq-measure.sh` uses,
stopped at `libc_nonshared.a`'s `.note.GNU-stack` and `atexit`, so tcc's
shell wasn't run.

## Limitations

- One hold of the lock for the whole script; each compiler's and shell's runs
  rotate, so a drift of the machine's state reaches all of them alike.
- The workload is ours, not SQLite's speedtest1, and the shell runs one
  process per round (the times include its start).
- The lock's messages ("exclusive.sh: waiting" and their title, link and pull
  request lines) were removed from `measure.log`; nothing else was changed.
