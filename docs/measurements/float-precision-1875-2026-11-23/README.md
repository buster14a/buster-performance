# sqlite3.c cost of buster#3361 (#1875) on the 9700X

The 9700X's sqlite3.c cost of the checker's new `-Wimplicit-float-conversion` and `-Wliteral-range` floating-comparison
checks on the default path, for [buster#3361](https://github.com/buster14a/buster/pull/3361).

- main `1b9821afe448258d08f47f6110922478aa0e4121` vs head `8da1446c295c1ba6e3fea9b756dbf20aa7441919` (a merge of that main). Both are Release builds from the 9700X's toolchain, and `env-and-lock.txt` gives the binaries' sha256.
- Input: the frozen corpus `/var/lib/buster-9700x/corpora/preprocessor-391e729af658` (sqlite3.c, gnu17 pinned predefines, its frozen headers), at default warning flags.
- `ab.sh 15` ran under the lock (`exclusive.sh`): main and head alternate, 15 runs each, at `-fsyntax-only` and then `-c`, pinned to CPU 2, under `perf stat -e cycles:u,instructions:u`.
- `ab.txt` columns: mode, variant, run, cycles:u, instructions:u, wall, status. Every run exited 0. The wall column is empty because `bc` isn't installed on the host, so user-mode cycles are the timing.

| mode | metric | main median | head median | delta |
|---|---|---:|---:|---:|
| -fsyntax-only | cycles:u | 471,159,289 | 473,321,770 | +0.46% |
| -fsyntax-only | instructions:u | 1,071,563,552 | 1,072,353,516 | +0.07% |
| -c | cycles:u | 562,439,829 | 564,466,396 | +0.36% |
| -c | instructions:u | 1,279,437,714 | 1,280,164,146 | +0.06% |

The head runs about 0.79 M (0.07%) more instructions on both paths. That is the `==`/`!=` floating-literal scan, the
constant reader's floating-equality test and the larger warning tables. The cycle deltas (0.4–0.5%) are within the
spread of these 15-run samples (the minima are +0.39% and +0.49%).

An earlier attempt by the PR's previous owner (`~/buster-fast-bench/1875-claude/`) is not valid: its script passed
`--no-default-config`, which the driver rejects, so every run exited 1 after parsing the arguments.
