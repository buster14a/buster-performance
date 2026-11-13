# The warnings' reach and root scans, and item 6's ceiling, Buster #892 (round 2)

Compiler issue: [#892](https://github.com/buster14a/buster/issues/892). The first round is
[`branch-free-sites-892-2026-11-13`](../branch-free-sites-892-2026-11-13/README.md) (buster#2655); its scripts and
method are this round's.

## Sources

- **Base:** main `447192ef` (buster#2655's merge), the tree `m2`, a worktree of a fresh clone.
- **The change:** buster `ab256cd3` (tree `51168b6e1414cdef6a23958c072a260923db4b85`), main with `r2.patch`, the
  tree `h3`; `git add -A && git write-tree` there printed the same tree id.
- **Placements:** each tree also built with `BUSTER_BUILD_DEFINES=-DBUSTER_CHECKER_OFFSET=1040` and `=2080`, in
  worktrees of their own (`scripts/r2-chain.sh`).
- **Builds:** `./build.sh`, Release, `-march=native` (`znver5`), one locked build each (`results/builds.txt`).

## Method

On the 9700X, CPU 2, every run under `exclusive.sh` with the holder's line kept as a receipt:
- `holds.txt` in `m2`, `h3` and `abtr-r2`;
- `objects.holds`, which also has the first round's lines.

The workload is `-c --lanes 1` of the frozen corpus's `sqlite3.c`, with the CI's defines. The scripts are the first
round's:
- `lbr.sh`: `perf stat -r 11` and the LBR at `-c 200003` over 8 compiles;
- `objects.sh`: the five `-c` modes and the self-check;
- `abtr2.sh`: `ab --lock` of `time-runs --runs 3 --copies 3` over main, the change and main again at the three
  placements, three rounds.

The logs keep only the lines these scripts and tools print (`results/statuses.txt` has each run's status line). The
lock's messages about other sessions' runs are dropped by an allowlist of line shapes.

**Item 6's ceiling** (`scripts/leafcost.sh`, `leafcost2.sh`, `results/leafcost`) is read from the first round's
main run (main `26f0bb0e`, its `main` results), its `main-lbr.data` of `cycles:u` samples (period 200003, 8 compiles,
24,314 samples):
- `symbols.txt`: the samples by symbol;
- `run-addresses.*`: `check_graph_run`'s samples by address, each symbolized with its inline chain.

## Results

**Objects:** the change's are the same bytes as main's in every mode (`objects.sha256` in `m2` and `h3`).

**Counters**, `perf stat -r 11`:

| | main | the change | |
| --- | ---: | ---: | ---: |
| mispredicted branches | 3,412,780 | 3,362,019 | −1.5% |
| mispredicted taken | 1,787,223 | 1,754,799 | −1.8% |
| instructions | 1,355,672,050 | 1,356,534,785 | +0.06% |

**Sites** (the LBR's mispredicted entries, of 15,542 and 14,301):

| site | main | the change |
| --- | ---: | ---: |
| `check_common_next_reach_op`'s refill test | 108 | 0; 39 at its refill loop's end |
| `check_common_next_root`'s refill test | 79 | 0 |

**Time over placements** (`abtr-r2`), each round's medians against main's:

| round | the change: user cycles | its range over the placements | main again |
| --- | ---: | ---: | ---: |
| 1 | −0.07% | −0.37% to +0.10% | +0.17% |
| 2 | −0.18% | −0.52% to +0.04% | −0.03% |
| 3 | −0.31% | −0.61% to +0.01% | −0.05% |

Wall time: the change −0.07%, −0.15% and −0.28%; main again +0.09%, −0.07% and −0.00%. The change is no slower and is
lower in every round, but each range reaches just past 0: within the floor.

**Item 6's ceiling:**

| | samples | of all |
| --- | ---: | ---: |
| `check_graph_run` | 1,154 | 4.75% |
| its leaves (`check_graph_leaf`'s inline chain) | 73 | 0.30% |
| the leaf test (`check_graph_is_leaf`'s) | 28 | 0.12% |
| the other nodes' actions (`check_graph_scalar_node`'s) | 968 | 3.98% |

`check_common_own_reach` takes 325 samples (1.34%) by symbol, in `symbols.txt`.

## Limitations

- One host and one workload.
- The placements move the checker's section alone.
- Item 6's attribution is of samples by their innermost inlined frames, at one build's layout.
