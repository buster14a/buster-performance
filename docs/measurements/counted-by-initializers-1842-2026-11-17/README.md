# #1842's counted_by initializers and sugar: `-c sqlite3.c`, main against head

[buster14a/buster#2920](https://github.com/buster14a/buster/pull/2920), part of #1842: the initializer walk's
trace of counted_by lists (`CheckInitCounted`) and the `__counted_by(n)` sugar in printed types.

- **Host:** benchpress, the Ryzen 7 9700X, every run under its lock (`exclusive.sh`), on CPU 2.
- **Builds:** Release, `BUSTER_DEBUG_INFO=0`, each built under the lock in its own worktree:
  - base: main `d876a5e0`;
  - head: `be07a77d`, the PR's commit.

  `results/compilers.sha256` has the executables' hashes.
- **Command:** `compare.sh`, as the 9700X records before it. It runs `time-runs` under `ab`: 7 runs of each of 3 fresh
  copies of base, head and base again, in a Williams order. The object goes to `/dev/shm`. There are three comparisons,
  `results/compile-1.txt` to `-3.txt`.
- **Input:** `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, with
  `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.
- **Same output:** both compilers write the same object, sha256 `efcbc038…` (`results/check.txt`).

## Results

Medians of 21 runs each. In brackets: each build against base.

| comparison | base wall | head wall | base-again wall | base cycles (M) | head cycles (M) | base-again cycles (M) |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 122.132 ms | 122.022 ms (-0.09%) | 122.063 ms (-0.06%) | 590.338 | 590.928 (+0.10%) | 591.751 (+0.24%) |
| 2 | 122.394 ms | 122.223 ms (-0.14%) | 122.179 ms (-0.18%) | 592.155 | 591.855 (-0.05%) | 592.400 (+0.04%) |
| 3 | 122.242 ms | 122.433 ms (+0.16%) | 122.436 ms (+0.16%) | 591.444 | 592.367 (+0.16%) | 591.418 (-0.00%) |

Instructions, the mode of each build's runs: base 1,362,119,5xx, head 1,362,663,2xx. That is +544k, or +0.040%: the
null tests the trace adds to the initializer walk's pushes and values, and the frame's three new fields. Wall time and
cycles are within base's own repeat.
