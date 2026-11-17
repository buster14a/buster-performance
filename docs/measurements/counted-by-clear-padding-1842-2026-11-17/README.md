# #1842's last commits: `-c sqlite3.c` and `__builtin_clear_padding`'s code, on the 9700X

[buster14a/buster#2920](https://github.com/buster14a/buster/pull/2920), part of #1842. That PR's first commit,
`be07a77d`, has its own record: [counted-by-initializers-1842-2026-11-17](../counted-by-initializers-1842-2026-11-17).
This record measures the commits after it:
- `a14efd3d`: counted_by's "expected ')'" in an argument;
- `bb2e1d8c`: clear_padding's repeats, through a table's loop;
- `f8931a7a`: a repeat's stores in loops of their own, in place;
- `3dc7d106`: the attribute record kept at main's size.

- **Host:** benchpress, the Ryzen 7 9700X. Every run held its lock (`exclusive.sh`), on CPU 2.
- **Builds:** Release with `BUSTER_DEBUG_INFO=0`, each built under the lock in its own worktree. The executables' hashes
  are in `results/compilers*.sha256`.
- **Compile:** `-c sqlite3.c` with `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5
  -DSQLITE_ENABLE_RTREE`, the object to `/dev/shm`. Each comparison is `time-runs` under `ab`: 7 runs of each of 3 fresh
  copies of base, head and base again, in a Williams order. There are three comparisons.
- **Generated code:** `padding.c`, built by each compiler with `-c` and linked by `cc`. Its argument chooses one of two
  records:
  - `large`: a record holding a 64-element array of padded records, cleared 2 million times;
  - `small`: a record holding a 2-element array, cleared 50 million times.

  Timed the same way, with 3 runs of each of 3 copies.

## Runs

| script | base | head | results |
| --- | --- | --- | --- |
| `run3.sh` | `be07a77d` (`compiler-head`) | `bb2e1d8c` (`compiler-head2`) | `compile3-*`, `padding3-*` (the script writes them `padding-*`), `check3.txt` |
| `run4.sh` | `be07a77d` | `f8931a7a` (`compiler-head3`) | `compile4-*`, `padding4-*`, `check4.txt` |
| `run5.sh` | main `d876a5e0` (`compiler-base`) | `3dc7d106` (`compiler-head4`), the PR's head | `compile5-*`, `padding5-*`, `check5.txt` |

Every build writes the same sqlite3.c object, sha256 `efcbc038…` (`check*.txt`).

## Results

Medians, each build against its base. For the compile, the three comparisons in turn.

| run | `-c sqlite3.c` wall | base again | `large` | base again | `small` | base again |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| 3: `bb2e1d8c` | -0.20%, +0.09%, -0.20% | -0.25%, +0.04%, -0.26% | **+14.03%** | +5.69% | +3.23% | -0.56% |
| 4: `f8931a7a` | -0.04%, -0.28%, -0.06% | +0.07%, -0.10%, -0.08% | **-78.97%** | -0.56% | +0.33% | +0.07% |
| 5: main → `3dc7d106` | -0.61%, -0.11%, -0.17% | +0.02%, +0.10%, -0.01% | **-78.98%** | +0.37% | +0.21% | -0.66% |

- **`large`:** main 276.3 ms, the final head 58.1 ms.
  - Main's table holds 128 copied entries, which its loop reads one at a time.
  - `bb2e1d8c` read each of the repeat's instances from its table, 14% slower than main.
  - `f8931a7a` makes the repeat a loop of two constant stores, in place.
- **`small`:** within base's own repeat.
- **Instructions, `-c sqlite3.c`:** main 1,362.12 M, the final head 1,362.65 M (+0.039%). That is `be07a77d`'s
  initializer trace; the later commits retire 16 k fewer than it.
