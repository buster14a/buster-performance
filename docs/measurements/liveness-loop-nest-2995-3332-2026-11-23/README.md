# Liveness over loop nests: alternating orders (#2995, PR #3332), 9700X

Ryzen 7 9700X (`benchpress`), Release builds (`BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, the 9700X job's
staged Clang 23.1.4), every run pinned to CPU 2 under `exclusive.sh`, one hold per run (the short nests: one hold
per repetition). `run.sh` and `one.sh` are the exact scripts; `results/` holds their raw output, including the load
and busiest processes before and after each run (`load.log`, and the head of each `benchmark-dataflow-*.txt`).

- **base**: main `1b9821afe448258d08f47f6110922478aa0e4121`.
- **new**: PR #3332 at `8b01bc94ccb12913ccb1f5c75a60f996f9d74283` (main merged into the PR). The PR's later head
  `2d48a0c` changes only the `scratch_bytes` statistic's bound and a test, not what runs here.

## Nested `for` loops, `-w --tier1 -c` (`results/nests.tsv`, seconds)

Medians of three runs (one for base at 4,000 and 8,000 levels and for the `ptr`/`brk` shapes).

| shape | base | new |
| --- | ---: | ---: |
| 256 levels | 0.024 | 0.015 |
| 500 | 0.048 | 0.042 |
| 1,000 | 0.221 | 0.168 |
| 2,000 | 0.355 | 0.169 |
| 4,000 | 5.629 | 0.666 |
| 8,000 | 52.083 | 2.624 |
| 4,000, pointer used only innermost (`ptr`) | 1.279 | 0.542 |
| 4,000, `break` at every level (`brk`) | 11.345 | 1.031 |

At 2,000 levels and more, both builds end in `Tier 1 resource failure: emission, cause=cfg-allocation error=2`
(`TIER1_CFG_CAPACITY`, Tier 0 fallback forbidden), exit status 1, after liveness. That failure is main's: it is the
same in both builds and is outside #3332. The times still include the whole liveness solve.

## `benchmark-dataflow` (ns/function, five runs each)

| workload | sweeps base/new | base runs | new runs |
| --- | --- | --- | --- |
| small-diamond | 2/2 | 35.4 35.2 35.8 35.4 35.5 | 35.1 35.2 37.0 36.1 36.1 |
| mid-sparse-nested | 3/3 | 134.3 134.3 135.4 134.3 135.6 | 138.0 136.3 138.5 137.3 138.7 |
| mid-sparse-diamond | 2/2 | 277.1 278.2 278.3 276.9 277.5 | 279.1 277.6 278.8 278.2 279.1 |
| medium-nested | 3/3 | 3765.5 3811.1 3766.6 3680.6 3670.6 | 3786.0 3783.1 3778.8 3783.9 3889.1 |
| large-local | 5/6 | 437704.8 437575.8 436390.4 437677.9 436691.6 | 509456.9 509703.5 509688.5 510121.9 509156.4 |
| large-dispatch | 3/3 | 256174.9 255996.4 255488.0 256021.5 255525.6 | 254506.8 254426.6 254246.2 254869.3 254237.5 |

Every digest matches its frozen value in both builds. large-local's extra sweep costs it 16%; mid-sparse-nested is
about 2% slower at the same sweep count.

## Whole compiles, `time-runs --runs 11 --warmups 1`, `-w --tier1 -c` (one layout each)

| input | base median wall | new median wall | wall | user cycles | instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite3.c | 602.183 ms | 606.084 ms | +0.65% | +0.68% | +0.17% |
| Lua 5.4.8, 34 sources in one command | 169.463 ms | 170.675 ms | +0.72% | +0.75% | +0.19% |

Each build is one executable, so these are single-layout comparisons: the ranges do not overlap, but a code
layout effect of this size is not ruled out.
