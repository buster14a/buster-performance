# Lane-by-lane entry room: `-c` of main.c, base vs head (buster#2357; buster#2216, #1834)

This is the raw 9700X evidence behind [buster#2357](https://github.com/buster14a/buster/pull/2357) and package D2's work on [buster#2216](https://github.com/buster14a/buster/issues/2216) and [buster#1834](https://github.com/buster14a/buster/issues/1834) (buster#1447, round D). Package D2 (session_01EgbxngeTGfLCuAeJbLzxh5) ran the measurements on `benchpress` in `~/buster-fast-bench/2216-claude-d2/`. Package D3 (session_01EgbxndQMcsMYmMXdjncrCg) copied the files here unchanged, because D2 had no write access to this repository. The build trees (`base/`, `head/`) and `time-runs`' file copies (`copies/`) are left out. So are the empty `ab.log` and `tr*.log`.

- **Host.** The Ryzen 7 9700X (`benchpress`). Each tree was built with `./build.sh` (Release, `native`) under the host lock. The logs are `build-*.log`.
- **Workload.** `-c -march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h src/buster/compiler/main.c`, the base tree's own source. `predefines.h` is clang's `-dM -E -march=native -fwrapv -funsigned-char` (`setup.sh`).
- **Command.** One `time-runs` per head (`tr.sh`, `tr2.sh` … `tr6.sh`) under `exclusive.sh`, pinned to CPU 2: 3 warm-ups, then 20 runs of each build per file copy, with 2 fresh copies (`--copies 2`). Each script's output is `time-runs*.txt`, whose second and third lines are the base and head commits.

## Results

Each run compares a head of the PR's branch `vector/2216-lanewise-room` with main. `tr5.sh` wrote `time-runs5.txt` and was superseded by `tr6.sh`, which rebuilt the base at a newer main and wrote the same file. `time-runs5.txt` is `tr6.sh`'s.

| file | base | head | median wall | median user cycles | median instructions |
|---|---|---|---|---|---|
| `time-runs.txt` | `e43dfc102` | `b93a3c404` | +0.00% (copies −0.46% to +0.15%) | +0.06% | +0.13% |
| `time-runs2.txt` | `e43dfc102` | `77cbce7f6` | +0.16% (−0.08% to +0.54%) | +0.38% | +0.15% |
| `time-runs3.txt` | `e43dfc102` | `b7f366f7b` | −0.14% (−0.39% to +0.01%) | −0.10% | +0.25% |
| `time-runs4.txt` | `e43dfc102` | `f81acb7f6` | −0.03% (−0.08% to +0.04%) | +0.08% | +0.26% |
| `time-runs5.txt` | `cefceaec1` (main then) | `79e88c0e5` | **+0.06%** (−0.27% to +0.30%) | +0.09% | +0.10% |

The last row is the figure buster#2357 cites: `-c` of main.c is +0.06% in wall time on the 9700X, within noise. The head's instruction counts are 0.10% to 0.26% higher than base. Wall time and cycles stay within the copies' spread in every run.

`ab.sh` and `ab.txt` are an earlier per-run-lock `ab --rounds 10` attempt, base `e43dfc102` against head `b93a3c404`. Its log holds the rounds' order and their completion ("0 failed runs") but no timings, so it is kept only as a record of what was run.

## Limitations

This covers one host and one workload, main.c's `-c`, at a single code placement; `--copies` varies only the files' placement. The heads are successive revisions of one branch, each measured once.
