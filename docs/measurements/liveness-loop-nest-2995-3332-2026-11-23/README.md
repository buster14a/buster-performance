# Liveness over loop nests: alternating orders (#2995, PR #3332), 9700X

Two rounds. Round 1 (`9700x/`, below its own heading) measured the first version, which built the backward order for
every function and alternated from the first sweep; it cost ordinary code about 0.7%. Round 2 (`9700x-round2/`)
measured the version that runs the postorder alone for four sweeps and builds the backward order only for a solve
still changing then.

## Round 2: lazy backward order (`9700x-round2/`)

- **base**: main `1b9821afe448258d08f47f6110922478aa0e4121`; **lazy**: PR head `9a63d70c9e7ac07ff8197c040f2e0da816ad6f58`.
- Each built with `./build.sh shifts --config Release DIR main.c 0 1024 2048 3072` (`BUSTER_DEBUG_INFO=0`): four
  placements of the same objects. `time-runs --runs 7 --warmups 1` ran all eight executables in its Williams order
  in one hold, on CPU 2: list 1 is `-w --tier1 -c` of sqlite3.c, list 2 the same of Lua 5.4.8's 34 sources in one
  command.

| input | base median (placements) | lazy median (placements) | wall, lazy vs base | user cycles |
| --- | --- | --- | --- | --- |
| sqlite3.c | 602.742 ms (602.324, 602.928, 602.864, 602.742) | 603.068 ms (603.259, 604.195, 602.920, 602.847) | +0.05% (−0.01% to +0.31% over placements) | +0.06% (−0.08% to +0.38%) |
| Lua | 169.853 ms (169.734, 170.162, 169.831, 169.751) | 169.923 ms (169.901, 170.224, 169.858, 169.777) | +0.04% (−0.23% to +0.29%) | −0.00% (−0.23% to +0.29%) |

The `over placements` ranges are time-runs' range of comparisons, not a confidence interval.

Nests, lazy (`compiler-0`), `-w --tier1 -c`, three runs each (seconds): loop-1000 0.171 0.168 0.167; loop-4000 0.656
0.654 0.668; loop-8000 2.613 2.595 2.601; ptr-4000 0.531 0.532 0.533; brk-4000 1.036 1.041 1.041. Base's are round
1's (loop-4000 5.63, loop-8000 52.1, ptr-4000 1.28, brk-4000 11.3). At 4,000 and 8,000 levels, and for the ptr and brk
shapes, both builds exit 1 with main's `cfg-allocation` capacity failure after liveness, as round 1 describes.

`benchmark-dataflow`, `compiler-0` of each (one placement), three runs, ns/function; every count and digest is main's:

| workload | sweeps | base | lazy |
| --- | --- | --- | --- |
| small-diamond | 2 | 35.3 35.7 37.4 | 36.4 36.6 36.7 |
| mid-sparse-nested | 3 | 134.5 134.5 134.5 | 137.9 145.7 146.8 |
| mid-sparse-diamond | 2 | 277.4 277.7 277.7 | 282.1 282.1 282.4 |
| medium-nested | 3 | 3702.0 3717.2 3744.7 | 3686.8 3710.4 3821.0 |
| large-local | 5 | 442131.8 451144.4 451766.1 | 460450.6 464360.4 464415.5 |
| large-dispatch | 3 | 259375.3 259858.1 262034.0 | 256475.4 256685.9 261267.6 |

These micro-workloads are a single placement each, and the solver's loops now take the two orders, a sweep limit
and a resume flag as arguments; the small ones read 1% to 9% slower, the large ones −1% to +3%. The whole-compile
comparison above, over four placements, shows no difference beyond its spread.

## Round 1: backward order for every function (`9700x/`)

Ryzen 7 9700X (`benchpress`), Release builds (`BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, the 9700X job's
staged Clang 23.1.4), every run pinned to CPU 2 under `exclusive.sh`, one hold per run (the short nests: one hold
per repetition). `9700x/run.sh` and `9700x/one.sh` are the exact scripts; `9700x/results/` holds their raw output, including the load
and busiest processes before and after each run (`load.log`, and the head of each `benchmark-dataflow-*.txt`).

- **base**: main `1b9821afe448258d08f47f6110922478aa0e4121`.
- **new**: PR #3332 at `8b01bc94ccb12913ccb1f5c75a60f996f9d74283` (main merged into the PR). The PR's later head
  `2d48a0c` changes only the `scratch_bytes` statistic's bound and a test, not what runs here.

### Nested `for` loops, `-w --tier1 -c` (`results/nests.tsv`, seconds)

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

### `benchmark-dataflow` (ns/function, five runs each)

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

### Whole compiles, `time-runs --runs 11 --warmups 1`, `-w --tier1 -c` (one layout each)

| input | base median wall | new median wall | wall | user cycles | instructions |
| --- | ---: | ---: | ---: | ---: | ---: |
| sqlite3.c | 602.183 ms | 606.084 ms | +0.65% | +0.68% | +0.17% |
| Lua 5.4.8, 34 sources in one command | 169.463 ms | 170.675 ms | +0.72% | +0.75% | +0.19% |

Each build is one executable, so these are single-layout comparisons: the ranges do not overlap, but a code
layout effect of this size is not ruled out.
