# buster#2524's front by passes, as its pull request (2026-11-16)

The fourth commit of [the hand-off series](../node-machine-own-tests-2524-2026-11-16/patches/handoff) (`0004`, the node
machine's front by passes, `measure-node-machine --shadow --front-flat`) with the comparison's fix that
[the compiler's own source asked for](../node-machine-flat-front-main-2524-2026-11-16), on main `178c9e2` (buster#2893's
merge, with buster#2887 and buster#2892 in). It is the series' third pull request. The session that prepared it stopped
before it could open; this session took the claim over
([buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6931982458)) and made the tree again from the
records, since the prepared worktree was in that session's container.

**Result.** On today's main it is what the earlier records say. The flat front is exact against the lean front on
`sqlite3.c`, Lua, musl and the compiler's own source, and 1.44, 1.14 and 1.15 times faster than the lean front before
the walk, each with its compaction (the earlier records read 1.46, 1.14 and 1.14 on main `1c6cc8ab5`). The census's
reports and the shadow's sweeps are unchanged. A compile's time is unchanged; it retires 343,735 more instructions of
1,361.8 M, as before (the build's parts fall elsewhere with the new file; no hook is in the coded walk's loop).

## 1. The tree

- `git checkout -b handoff-series 3d0d56ed7` and `git am` of the series' four patches gives the tree the series' README
  names (`522fa6b9`), and with it the blobs `0004` was made on, which are in no branch.
- `git cherry-pick` of the fourth commit onto main `178c9e2`: one conflict, in `c_check_node_census.c`'s exit-status
  expression (buster#2875's and the own form's terms on one side, the flat front's on the other; both kept). The commit
  keeps its author, message and trailers.
- `git apply` of the earlier record's `patches/flat-compare.patch`: clean. It is the second commit, this session's.

`patches/flat.patch` is the two commits' sources against main `178c9e2`'s (`src`, `tools`, `tests`), which is what the
9700X built.

## 2. In the cloud container

A Release build with CI's toolchain (4 CPUs, an Intel Xeon with AVX-512).

| what | result |
| --- | --- |
| `test-checker --seed 133`, the eight parts | 842,761 checks, 0 failures |
| `--front-flat` and `--front-flat-first` on `sqlite3.c`, Lua, musl and `main.c` | 0 differences, exit 0, in the eight runs |
| … `main.c`: records both fronts make; only the lean front's; only the flat front's | 884,309; 18; 35,341 |
| the six sanitizer rows (memory, address and thread, on the `x86-64` host and the native one): part 5 of `test-checker`, and for memory and address `--front-flat` and `--front-flat-first` on `sqlite3.c`, Lua and `main.c` | no report in any: part 5 passes in the six (210,278 checks on the `x86-64` host, 210,314 on the native one), and the 24 shadow runs exit 0 |

`results/cloud` has the runs' outputs (`flat`: the eight shadow runs; `test-checker.txt`; `sanitizers`: the rows'
progress and each row's part 5), and `scripts/sanitizers.sh` the rows' script (with this container's paths;
`corpora-cloud.sh` is its inputs' file).

## 3. The 9700X

Release builds, CPU 2, under the lock, a hold a run (`scripts/job.sh`; `results/tables.txt` by `scripts/tables.py`).
`base` is main `178c9e2`, `flat` the same with `patches/flat.patch`.

The fronts before the walk, ms at the TSC's 3,792.9 MHz (medians of seven readings in turn, musl's of three), each with
the compaction it reads:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the lean front, and the walk's compaction | 4.429 + 0.459 | 1.441 + 0.298 | 13.180 + 1.815 |
| the flat front, and its own | 3.080 + 0.321 | 1.309 + 0.222 | 11.086 + 1.940 |
| the lean front against the flat one | 1.44 times | 1.14 | 1.15 |
| the flat front's stages: classes; leaves; places; records; empty records | 0.158; 0.548; 0.878; 1.466; 0.031 | 0.078; 0.172; 0.450; 0.576; 0.028 | 0.790; 3.092; 3.164; 3.538; 0.494 |
| the flat front after the walk | 2.510 | 1.225 | 10.341 |
| records both fronts make; differences | 315,962; 0 | 90,801; 0 | 618,853; 0 |
| records only the lean front makes; only the flat front | 4; 0 | 0; 0 | 0; 0 |

Each of the 34 runs with the flat front compared it with the lean one, and the 17 others the lean front with the walk's
nodes: no difference in any.

`base` against `flat`:

| | `base` | `flat` |
| --- | ---: | ---: |
| `-c sqlite3.c`, instructions | 1,361,763,913 | 1,362,107,648 |
| its wall time, 21 runs a build from three fresh copies, twice | 121.806 ms; 121.641 ms | -0.13%; -0.22% |
| `base` against itself in the same runs | | -0.08%; +0.01% |
| its user cycles; `base` against itself | | -0.03%; -0.10%; and +0.17%; +0.07% |
| the shadow's T, C and X after the pipeline, cycles an evaluated node: `sqlite3.c`; Lua; musl | 173.4; 146.8; 134.1 | 173.2; 147.2; 134.0 |
| their instructions | 603.6; 688.1; 655.8 | the same |

- **The census's own reports** are `base`'s line for line on the three corpora, with both sets of warnings.
- **What else ran:** each run's file starts and ends with the host's busiest processes and its load, inside its hold.

## Files

- `patches/flat.patch`: the 9700X's build's sources against main `178c9e2`.
- `scripts`: `job.sh` and what it calls (`setup.sh`, `corpora.sh`, `lock.sh`, `build-label.sh`, `turns.sh`,
  `compile.sh`, `tables.py`), and the cloud container's `sanitizers.sh`, `shadow.sh` and `checker.sh`.
- `results/base`, `results/flat`: the 9700X's runs (`flatfirst`, `leanfirst`, `flat`: the fronts; `shadow`: the shadow
  alone; `census`, `census-wall`; `compile`). `results/tables.txt` is their summary, `results/job.log` the job's.
- `results/cloud`: section 2's runs.
