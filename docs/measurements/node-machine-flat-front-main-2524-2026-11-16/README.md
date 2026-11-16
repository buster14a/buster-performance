# buster#2524's front by passes, on today's main (2026-11-16)

The fourth commit of [the hand-off series](../node-machine-own-tests-2524-2026-11-16/patches/handoff) (`0004`, the
node machine's front by passes, `--front-flat`), re-picked on the tree of the series' second pull request: main
`1c6cc8ab5` with pull request [buster#2887](https://github.com/buster14a/buster/pull/2887)'s commits and
[the tests in the machine's own form as sorted](../node-machine-own-tests-main-2524-2026-11-16). Under
[the claim on buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6919991971), whose third item
was a decision on this commit: [to take it, as a third pull
request](https://github.com/buster14a/buster/issues/2524#issuecomment-6926573730), unless the owner says otherwise.
[Its own record](../node-machine-flat-front-2524-2026-11-15) has how it was built and what its parts cost.

**State: measured ahead.** The pull request can't open before the two in front of it merge (the session has one
branch). The sanitizer rows (`scripts/sanitizers.sh`) were running when this was pushed.

**Result.** On today's main it is what its record says: exact against the lean front on `sqlite3.c`, Lua and musl, and
1.46, 1.14 and 1.14 times faster than the lean front before the walk, each with its compaction (the record read 1.46,
1.13 and 1.18). The census's reports and the shadow's sweeps are unchanged. A compile's time is unchanged; it retires
343,637 more instructions of 1,364.6 M, as its record found (the build's parts fall elsewhere with the new file).

## 1. The re-pick

`git am --3way` of `0004` on the second pull request's tree: one conflict, in `c_check_node_census.c`'s exit-status
expression (buster#2875's two terms and the own form's on one side, the flat front's on the other; both kept).
`patches/flat.patch` is the whole tree against main `1c6cc8ab5`'s `src`, `tools` and `tests`.

In the cloud container, on that tree: `test-checker --seed 133`, the eight parts, 842,496 checks, 0 failures (part 5:
210,314); `--front-flat` and `--front-flat-first` exact on `sqlite3.c` and Lua.

## 2. The 9700X

Release builds, CPU 2, under the lock, a hold a run (`scripts/job4.sh`; `results/tables.txt` by `scripts/tables.py`;
the other scripts are [the first pull request's record](../node-machine-handoff-main-2524-2026-11-16/scripts)'s).
`own` is the second pull request's tree, `flat` the same with `0004`.

The fronts before the walk, ms at the TSC's 3,792.9 MHz (medians of seven readings in turn, musl's of three), each
with the compaction it reads:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the lean front, and the walk's compaction | 4.443 + 0.466 | 1.454 + 0.304 | 13.482 + 1.834 |
| the flat front, and its own | 3.051 + 0.320 | 1.318 + 0.222 | 11.498 + 1.920 |
| the lean front against the flat one | 1.46 times | 1.14 | 1.14 |
| the flat front's stages: classes; leaves; places; records; empty records | 0.158; 0.552; 0.875; 1.429; 0.030 | 0.079; 0.173; 0.446; 0.590; 0.028 | 0.766; 3.069; 3.109; 3.652; 0.490 |
| the flat front after the walk | 2.481 | 1.235 | 10.513 |
| records both fronts make; differences | 315,962; 0 | 90,801; 0 | 618,853; 0 |
| records only the lean front makes; only the flat front | 4; 0 | 0; 0 | 0; 0 |

Each of the 34 runs with the flat front compared it with the lean one, and the 17 others the lean front with the
walk's nodes: no difference in any.

`own` against `flat`:

| | `own` | `flat` |
| --- | ---: | ---: |
| `-c sqlite3.c`, instructions | 1,364,580,484 | 1,364,924,121 |
| its wall time, 21 runs a build from three fresh copies, twice | 122.845 ms; 122.601 ms | -0.16%; -0.33% |
| `own` against itself in the same runs | | -0.44%; -0.26% |
| its user cycles; `own` against itself | | -0.08%; -0.16%; and -0.39%; -0.15% |
| the shadow's T, C and X after the pipeline, cycles an evaluated node: `sqlite3.c`; Lua; musl | 178.2; 152.2; 136.8 | 177.4; 150.8; 135.8 |
| their instructions | 594.3; 683.7; 645.6 | the same |

- **The census's own reports** are `own`'s line for line on the three corpora, with both sets of warnings.
- **The 343,637 instructions** are the 344,000 of the commit's own record: no hook is in the coded walk's loop (the
  one call at a unit's start has a new name), and that record's `symdiff.py` shows the Release build's parts falling
  elsewhere with the new file.

## Files

- `patches/flat.patch`: the 9700X's build's sources.
- `scripts`: `job4.sh`, `tables.py`, and the cloud container's `sanitizers.sh` (with its paths as they were).
- `results/flat`, `results/own`: the runs (`flatfirst`, `leanfirst`, `flat`: the fronts; `shadow`, `shadow4`: the
  shadow alone; `census`, `census-wall`; `compile`). `results/tables.txt` is their summary.
