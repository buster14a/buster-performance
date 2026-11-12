# What Tier 1's pipeline costs a compile, by stage: the measurements behind buster#2538's design (2026-11-12)

These are the measurements that [buster#2538](https://github.com/buster14a/buster/issues/2538)'s design
(`docs/tier1-one-allocation.md` in buster) rests on, taken for the compile-cost side of
[buster#138](https://github.com/buster14a/buster/issues/138). They compare `--tier1` with the default compile on three
corpora, attribute Tier 1's pipeline to 66 stages and to each function by a lap log and by hardware counters, and
measure prototypes of three levers: stages over batches of functions, a profile-guided build, and one allocator call
for a function's two allocation problems, which is the design. The patches here are measurement code: nothing in this
record is the design's implementation.

- **Source:** buster `c5f0efb20199618a542f0d8de61951916c15d76c` (main on 12 November), a clean clone built on the host
  by `./build.sh` (Release, `-O3 -march=native`, debug information). The unpatched executable (`src`) has SHA-256
  `bc81ec29…`; the patched trees' are in `env.txt`, with every patch's hash.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50, clang 23.1.1, perf 7.2.9, `/home` on btrfs with zstd
  (`env.txt`).
- **Every build and run** was one hold of the machine's lock (`scripts/lock.sh`, owner `claude-tier1-cost`), queued a
  line a hold (`scripts/queue.sh`, `raw/logs/q-*.log`). The workload is pinned to CPU 2, whose SMT sibling is offline
  and whose governor is `performance`; the eight-lane rows take CPUs 0 to 7. Each script writes the lock's own line for
  its hold first (`raw/*/*/holder.txt`).
- **Workloads** (`scripts/corpora.sh`): `sqlite3.c` of the frozen corpus (SHA-256 `0a409f16…`, 9,507,037 bytes) with
  the 9700X job's `compile_time` options, one unit; Lua 5.4.8's 33 units (`lua.c` and the library, the release by its
  hash, `scripts/inputs.sh`); the corpus's musl, the first source of each base name, 1,336 units as one command.
  Always `-c`, and `--lanes 1` unless a row says eight.
- **Whole-process timings** are `scripts/runs.py`'s: the configurations in a Williams design's order after a warm-up
  round, each in a directory of its own, each process under `perf stat` for its wall time and its user and kernel
  cycles and instructions; peaks come from a second pass without `perf`. The tables give medians, with the wall
  times' range.
- **What `raw/` keeps:** every experiment's small files whole and a part of the large ones, recompressed as xz
  (`scripts/collect.sh` lists them). The tables were made from all of the host's results by `scripts/tables.sh`; the
  rest stays in the session's directory on the host, `~/buster-fast-bench/138-tier1-cost-claude/results`.

## 1. The baseline

`scripts/baseline3.sh CORPUS LANES`: the unpatched executable, default against `--tier1`, 7 runs (musl: 5), then 3
without `perf` for the peaks, one `--tier1-report` compile and, on one lane, three `--time-stages` reports of each.
`raw/baseline3/`, `tables/baseline.md`:

| corpus | lanes | compile | wall ms (range) | user cycles, M | kernel cycles, M | user instructions, M | peak MB | functions by Tier 1 |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| sqlite | 1 | default | 124.0 (123.4 to 149.3) | 599.3 | 82.1 | 1,347.5 | 235.1 |  |
| sqlite | 1 | `--tier1` | 426.1 (425.5 to 426.9) | 2,257.1 | 96.1 | 5,278.7 | 295.8 | 2668 of 2668 |
| sqlite | 8 | default | 115.8 (114.5 to 116.9) | 631.1 | 124.0 | 1,348.4 | 275.6 |  |
| sqlite | 8 | `--tier1` | 176.4 (174.3 to 177.2) | 2,324.4 | 204.4 | 5,280.8 | 455.4 | 2668 of 2668 |
| lua | 1 | default | 91.7 (91.5 to 104.7) | 439.9 | 64.5 | 1,165.0 | 64.5 |  |
| lua | 1 | `--tier1` | 167.5 (167.4 to 180.8) | 827.7 | 95.6 | 2,014.2 | 103.1 | 1087 of 1088 |
| lua | 8 | default | 34.6 (28.5 to 39.6) | 605.8 | 246.1 | 1,200.7 | 221.4 |  |
| lua | 8 | `--tier1` | 54.6 (46.2 to 71.4) | 966.8 | 259.4 | 2,049.4 | 241.8 | 1087 of 1088 |
| musl | 1 | default | 1052.9 (1052.3 to 1080.4) | 4,747.0 | 1,074.6 | 12,756.1 | 142.8 |  |
| musl | 1 | `--tier1` | 1352.4 (1350.9 to 1354.1) | 6,208.1 | 1,268.9 | 15,145.0 | 148.7 | 2755 of 2756 |
| musl | 8 | default | 242.0 (241.2 to 251.3) | 5,511.5 | 2,052.9 | 12,777.8 | 286.4 |  |
| musl | 8 | `--tier1` | 296.1 (295.0 to 313.1) | 6,988.8 | 2,484.8 | 15,168.0 | 293.7 | 2755 of 2756 |

Tier 1 compiles every function of `sqlite3.c` and all but one of Lua's and of musl's. On one lane `--tier1` is 3.44
times the default compile on `sqlite3.c`, 1.83 on Lua and 1.28 on musl.

Two earlier baselines are kept because their faults are traps:

- `raw/baseline/` (`scripts/baseline.sh`, `time-runs` with both configurations' lists) read `--tier1` on `sqlite3.c`
  as 447 ms after a default compile and 427 ms after itself, with the same cycles. Both lists wrote `sqlite3.o` in one
  directory, and the `--tier1` object (2,119,744 bytes) is shorter than the default's (2,332,024): the object writer
  truncates a file that was longer, and on this btrfs the truncation waits 20 ms (`object-write` 20.2 ms against
  0.37 ms in `--time-stages`). Hence a directory per configuration everywhere after.
- `raw/baseline2/` (`scripts/baseline2.sh`) has no wall times: `perf stat -x,` prints `duration_time` as 0 on this
  perf, so `runs.py` reads perf's plain output. Its peaks were taken under `perf`, where a process's peak is never
  below perf's own at its fork (66 MB) and reads about 3 MB high; hence the pass without it.

## 2. The measurement patch and what it costs

`scripts/laps.patch` (and its later versions, each the one before plus a prototype: `laps3.patch`, `laps4.patch`,
`laps5.patch`, `laps6.patch`, `laps7.patch`, `laps8.patch`) adds `tier1_laps.h`: a TSC stamp at the end of each of 66 stages inside
`check_tier1_compile` and at each of the driver's stages (`check_clock_lap`), each with the function being compiled;
a row per function with its sizes; and the TSC's two anchors on `CLOCK_MONOTONIC_RAW`. With `BUSTER_T1_LAPS=PATH` the
log is written after the last stage; without it the stamps go nowhere.

`scripts/overhead.sh`, `raw/overhead/`, `tables/overhead.md`: `--tier1 -c sqlite3.c` takes 2,258.9 M user cycles by
the unpatched executable, 2,261.0 M by the patched one with the log off and 2,314.5 M with it on (the log's own
writing, after the last lap); the three objects are one (`573889642b44…`).

## 3. The pipeline by stage

`scripts/laps.sh CORPUS`: 5 logged compiles of each configuration (musl: 3), no `perf`. `raw/laps/`,
`scripts/tools/stage_table.py`: `tables/CORPUS-stages.tsv` (every stage, the median of the logs with their range),
`CORPUS-groups.tsv`, `CORPUS-default-stages.tsv`. A lap's time is its stamp less the one before, so a stage's time is
exact to the stamps' own cost.

`sqlite3.c`: the pipeline is 298.6 ms of the 426.8 ms between the first lap and the last, for 2,668 functions. Lua:
70.0 of 168.2 ms. musl: 226.0 of 1,361.3 ms. By what a lever would remove (`scripts/tools/ranking.py`,
`tables/sqlite-ranking.md`; the cycles, IPC and frontend share are section 5's):

| stages | ms | of the compile | the compile without it, ms | M cycles | IPC | slots waiting for the frontend |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| register allocation: the first call | 48.4 | 11.3% | 378 | 272.7 | 2.24 | 45% |
| register allocation: the second call | 32.7 | 7.7% | 393 | 184.3 | 2.74 | 39% |
| register allocation: the callee-saved step | 3.5 | 0.8% | 423 | 20.0 | 2.38 | 45% |
| emission: the allocation problem | 18.2 | 4.3% | 408 | 104.0 | 2.29 | 47% |
| emission: saves and frame | 7.1 | 1.7% | 419 | 40.2 | 2.60 | 45% |
| emission: records | 35.0 | 8.2% | 391 | 198.9 | 2.46 | 43% |
| SSA construction | 37.6 | 8.8% | 389 | 208.4 | 2.25 | 48% |
| instruction selection | 33.8 | 7.9% | 392 | 190.8 | 2.18 | 45% |
| IR verification, six checks | 30.6 | 7.2% | 395 | 173.5 | 2.28 | 50% |
| optimizer: analyses, SCCP, dead code, rewrite | 30.5 | 7.1% | 396 | 171.3 | 2.16 | 50% |
| lowering to the IR | 14.1 | 3.3% | 412 | 80.0 | 2.14 | 52% |
| inlining, wide integers, vector pieces, truth, if-conversion | 4.2 | 1.0% | 422 | 23.0 | 2.00 | 51% |
| straight-line functions' back end | 2.1 | 0.5% | 424 | 12.2 | 1.64 | 63% |
| arenas, publication, the rest | 0.8 | 0.2% | 425 | 4.2 | 2.34 | 52% |
| the pipeline | 298.6 | 70.0% | 127 | 1683.6 | 2.31 | 46% |

The same groups on Lua and musl, as shares of their pipelines: register allocation with the step between its calls
25.3% and 21.9%, records 12.0% and 14.7%, the six IR checks 10.1% and 9.0%, SSA construction 13.9% and 13.0%,
selection 11.2% and 11.2%, the optimizer 9.9% and 9.9%, lowering 5.1% and 5.7%.

Under `--tier1` the driver's own `check-program` stage is 31.6 ms against the default compile's 23.8
(`tables/sqlite-default-stages.tsv`), and its `tier0` row is the pipeline.

## 4. By function size

`scripts/tools/function_sizes.py` (`tables/CORPUS-sizes.txt`, every function in `CORPUS-functions.tsv`) and
`stage_by_size.py` (`CORPUS-stage-by-size.tsv`). `sqlite3.c`'s 2,668 functions are 406,765 typed entries, 625,409
lowered IR instructions, 494,571 after promotion and 387,334 after the optimizer, 244,380 intervals and 271,136
records; 447 are straight lines, 2,221 go through the CFG allocator, and 1,584 of those are allocated twice. The
pipeline costs 476.9 ns a lowered instruction, between 432 and 564 ns in every size class above 64 instructions and
995 ns below 16. `sqlite3VdbeExec` (28,541 instructions) is 20.7 ms, 6.9%; the eight functions of 4,096 and more are
16.3%. Allocation's two calls go from 4.2% of a function under 16 instructions to 39.2% of those eight; every other
phase's share is level or falls.

## 5. Counters by stage and by function

`scripts/stagecounters.sh sqlite GROUP`: six `--tier1 -c` compiles by the patched executable for each of four
leader-sampled groups, under `perf record -T -k CLOCK_MONOTONIC_RAW -c 100003` controlled from CPU 5, each run's own
lap log beside its samples. `scripts/tools/samples_reduce.py` turns a sample's time into a TSC through the log's
anchors and puts it in the lap it falls in, so every sample has a stage and a function.

The log's first anchor is late: the first `clock_gettime` of a process takes 1.8 to 4.1 us here, which would move the
start of every stage's samples into the stage before. `scripts/tools/anchor_fit.py` fits the delay per run as the one
that puts the most samples of functions that one stage alone runs into that stage (99.92% to 99.96% at the fit), and
`samples_reduce.py` applies it.

`tables/sqlite-counters-GROUP-stages.tsv`, `-groups.tsv` and `-sizes.tsv` are the reductions (the events are the
columns), `sqlite-counters-work-functions.tsv` each stage's functions by cycles, and `sqlite-stage-summary.md` and
`-stages.tsv` one table of times and counters. Per compile, in the pipeline's laps: 1,683.6 M cycles, 3,893.6 M
instructions (2.31 a cycle), 26.8 M mispredicted branches (6.9 per 1,000 instructions, 43 a lowered IR instruction),
16.6 M L1D demand fills (14.8 M from L2, 1.7 M from L3, 0.13 M from DRAM) and 181 M op-cache misses. Of the dispatch
slots (8 a cycle): 26% retire, 17% are bad speculation, 46% wait for the frontend and 11% for the backend; a load is
not complete at retirement in 24% of the cycles.

By the function's size (`sqlite-counters-*-sizes.tsv`), from under 32 lowered instructions to 4,096 and more: the
frontend's share of the slots 62.7% to 33.2%, op-cache misses 257 to 34 per 1,000 cycles, IPC 1.75 to 2.93,
mispredicted branches 8.1 to 4.5 per 1,000 instructions.

`scripts/tools/footprint.py`, `tables/sqlite-footprint.txt`: the pipeline's samples fall on 5,092 distinct 64-byte
lines of code (318 KiB, a lower bound) in 231 pages, of 146 functions; half the samples are in 285 lines.

By symbol (`sqlite-counters-work-functions.tsv`), M cycles a compile: `tier1_cfg_allocate_impl` 287.9,
`ssa_ir_promote_path` 182.6, `tier1_allocate_hinted` 130.8, `tier1_emit_cfg_records` 122.0, `ir_check_rows` 93.9,
`tier1_select_plan_checked` 71.8, `tier1_emit_cfg_problem` 60.3, `ir_optimize_rewrite` 55.7. Validation inside the
back end's stages: in the allocation problem `tier1_liveness_validate_plan` 15.8, `ir_check_rows` 13.9 and
`ir_cfg_validated` 2.4 (through `ir_build_cfg`); in the records `instruction_is_valid` 22.2, the template checks 5.3
and `x86_zen5_id` 4.4; `tier1_allocation_input_valid` 5.4 in the assignment.

## 6. Stages over batches of functions (not the design)

`scripts/laps4.patch` turns `check_tier1_compile` into phases over an item struct, so that
`BUSTER_T1_BATCH=N` runs each phase for N functions before the next, and `BUSTER_T1_BATCH_ENTRIES=N` closes a batch
at N typed entries. `scripts/batch.sh`, `raw/batch/`, `tables/batch.md`: `src` is the unpatched executable, `off` the
patched one with no batch (a function through every phase, as today), and every configuration's objects are the
unpatched executable's.

**sqlite3.c, functions a batch (bN; b1000000 is the whole unit)**

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src | 7 | 427.6 (426.4 to 460.5) | 2,261.2 | +0.00% | 5,278.7 | 97.9 | 294.6 |
| off | 7 | 426.2 (425.8 to 427.8) | 2,255.3 | -0.26% | 5,281.4 | 97.8 | 294.1 |
| b1000000 | 7 | 435.6 (435.1 to 435.7) | 2,219.1 | -1.86% | 5,290.7 | 185.4 | 703.4 |
| b1 | 7 | 427.8 (426.3 to 428.3) | 2,261.6 | +0.02% | 5,291.4 | 98.1 | 294.1 |
| b256 | 7 | 419.0 (418.2 to 420.0) | 2,200.8 | -2.67% | 5,290.7 | 112.5 | 353.5 |
| b4 | 7 | 428.6 (427.8 to 430.0) | 2,266.5 | +0.24% | 5,290.8 | 98.4 | 294.2 |
| b64 | 7 | 416.1 (415.2 to 419.9) | 2,197.6 | -2.81% | 5,290.7 | 98.8 | 302.5 |
| b16 | 7 | 425.8 (425.3 to 457.6) | 2,250.3 | -0.48% | 5,290.7 | 99.5 | 298.2 |

**sqlite3.c, typed entries a batch (eN)**

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src | 7 | 426.7 (425.8 to 428.6) | 2,260.9 | +0.00% | 5,278.7 | 96.8 | 294.6 |
| off | 7 | 425.9 (425.6 to 459.0) | 2,256.0 | -0.22% | 5,281.4 | 96.8 | 294.1 |
| e65536 | 7 | 421.4 (421.1 to 423.4) | 2,216.6 | -1.96% | 5,290.7 | 113.7 | 361.4 |
| e1024 | 7 | 426.7 (423.7 to 427.1) | 2,260.1 | -0.04% | 5,290.7 | 97.9 | 296.4 |
| e16384 | 7 | 413.1 (412.5 to 414.4) | 2,180.7 | -3.55% | 5,290.7 | 100.4 | 311.2 |
| e4096 | 7 | 421.5 (420.5 to 422.0) | 2,228.1 | -1.45% | 5,290.7 | 98.9 | 298.7 |

Lua and musl gain nothing at any batch size (`tables/batch.md`): at 64 functions a batch Lua takes 831.3 M user cycles against 828.8 M and 172.7 ms against 167.2, musl 6,258.0 M against 6,217.9 M.

`scripts/stagecounters2.sh sqlite GROUP 6 inst4 batch64 BUSTER_T1_BATCH=64`, `raw/stagecounters-batch64/`,
`tables/sqlite-batch64-stage-summary.md`: at 64 functions a batch the pipeline's laps take 1,621.3 M cycles against
1,683.6 M, and the frontend's share of the slots is 43% against 46%: selection 35% to 37% from 44% to 45%, records 38%
from 43%, while the second allocator call and the optimizer's input verification get slower.

## 7. A profile-guided build (not the design)

`scripts/pgo.sh build`: the same commit, unpatched, built with `BUSTER_PGO=1` and `scripts/train-tier1.sh` as its
training (the three corpora by `--tier1 -c` and by `-c`); `raw/logs/q-pgo.txt.log` has the build, 222.5 s in one hold.
`scripts/pgo.sh run CORPUS`, `raw/pgo/`, `tables/pgo.md`; the objects are the plain executable's. The profile is
trained on the inputs it is measured on, so this is the most a profile gives.

| corpus | compile | runs | plain, wall ms | profile-guided | change | plain, user cycles, M | profile-guided | change | objects |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| sqlite | `--tier1` | 7 | 426.4 | 403.5 | -5.4% | 2,258.9 | 2,133.7 | -5.5% | objects agree |
| sqlite | default | 7 | 124.3 | 117.8 | -5.2% | 599.5 | 566.7 | -5.5% | objects agree |
| lua | `--tier1` | 7 | 167.0 | 154.6 | -7.4% | 827.9 | 760.3 | -8.2% | objects agree |
| lua | default | 7 | 91.7 | 82.3 | -10.2% | 439.7 | 388.5 | -11.7% | objects agree |
| musl | `--tier1` | 5 | 1351.6 | 1187.9 | -12.1% | 6,207.4 | 5,335.5 | -14.0% | objects agree |
| musl | default | 5 | 1053.3 | 916.3 | -13.0% | 4,750.1 | 4,022.4 | -15.3% | objects agree |

## 8. One allocation: the design's prototypes

What the allocator does twice, from the lap logs' per-function rows (`scripts/laps3.patch`'s G lines,
`scripts/tools/second.py`, `tables/CORPUS-second-allocation.txt`): the second `tier1_cfg_allocate` is asked for in
1,584 functions of `sqlite3.c`, 725 of Lua and 863 of musl, and taken in every one; its intervals are the first
call's in every one (starts, ends and values compared); no problem has a fixed range; 243,410 of the final
allocations' intervals take the scan and 970 the coloring path; three functions of `sqlite3.c`, two of Lua and none
of musl run a third call, after a constraint.

Five prototypes, each an environment variable in one executable so that today's order and the prototype share their
code's layout, each with every configuration's objects and the functions that differ:

- `scripts/prototype.sh` (`laps3.patch`, `BUSTER_T1_PREFERRED_FIRST=1`, "one"): the preferred allocation first, the
  plain one only on a refusal. Not exact. `raw/prototype/`.
- `scripts/prototype5.sh` (`laps5.patch`, `=2`, "exact"): the same where the plain allocation provably meets no
  constraint, else today's order restarted. Exact, and no faster, since it builds the intervals a third time in the
  functions it doesn't cover. Its "two" logs' G lines (`pinned_end`, `required_most`) sized the verdict's prefix:
  `tables/prefix-share.txt`. `raw/prototype5/`.
- `scripts/prototype6.sh` (`laps6.patch`, `=3` "shared", `=4` "quiet"): both problems in one allocator call.
  `raw/prototype6/`.
- `scripts/prototype7.sh` (`laps7.patch`, `=5` "prefix"): the plain assignment's verdict from the events before the
  last bound definition interval's end, by a `tier1_allocate` call of its own, with the unpatched executable in the
  same design. `raw/prototype7/`, `tables/one-allocation-gains-laps7.md`.
- `scripts/prototype8.sh` (`laps8.patch`, `=6` "inline"): that verdict inside the preferred assignment's call, so that
  the intervals are validated and their events sorted once for both problems. `raw/prototype8/`.

`tables/one-allocation.md` has every run's table, `tables/CORPUS-one-allocation-stages.tsv` the stages by
configuration (`scripts/tools/variants.py`; `-laps6` and `-laps7` for the earlier executables),
`tables/CORPUS-one-allocation-allocator.md` the allocator's rows by what they do, and
`tables/CORPUS-one-allocation-differ.txt` the functions that differ. The last prototype's runs against the unpatched
executable (`scripts/tools/gains.py`, `tables/one-allocation-gains.md`):

| corpus | order | runs | wall ms | against src | user cycles, M | against src | user instructions, M | peak MB | objects that differ |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| sqlite | src | 9 | 425.9 |  | 2,258.1 |  | 5,278.7 | 295.9 | 0 of 1 |
| sqlite | two | 9 | 428.4 | +2.5 ms | 2,267.9 | +0.44% | 5,311.2 | 294.5 | 0 of 1 |
| sqlite | shared | 9 | 400.6 | -25.4 ms | 2,113.7 | -6.39% | 4,906.6 | 290.3 | 0 of 1 |
| sqlite | prefix | 9 | 397.5 | -28.4 ms | 2,097.4 | -7.11% | 4,850.4 | 288.4 | 0 of 1 |
| sqlite | inline | 9 | 393.0 | -32.9 ms | 2,071.7 | -8.25% | 4,773.7 | 288.4 | 0 of 1 |
| lua | src | 9 | 167.5 |  | 829.3 |  | 2,014.2 | 104.3 | 0 of 33 |
| lua | two | 9 | 168.6 | +1.1 ms | 833.9 | +0.55% | 2,022.6 | 102.8 | 0 of 33 |
| lua | shared | 9 | 162.9 | -4.6 ms | 806.3 | -2.78% | 1,953.3 | 90.9 | 0 of 33 |
| lua | prefix | 9 | 163.1 | -4.4 ms | 807.5 | -2.64% | 1,947.2 | 91.0 | 0 of 33 |
| lua | inline | 9 | 162.2 | -5.3 ms | 802.7 | -3.21% | 1,932.0 | 91.0 | 0 of 33 |
| musl | src | 5 | 1350.1 |  | 6,208.2 |  | 15,145.0 | 149.9 | 0 of 1336 |
| musl | two | 5 | 1359.0 | +8.9 ms | 6,259.7 | +0.83% | 15,177.5 | 148.3 | 0 of 1336 |
| musl | shared | 5 | 1344.4 | -5.8 ms | 6,184.8 | -0.38% | 15,017.0 | 147.3 | 0 of 1336 |
| musl | prefix | 5 | 1344.2 | -5.9 ms | 6,182.8 | -0.41% | 14,996.6 | 147.2 | 0 of 1336 |
| musl | inline | 5 | 1341.4 | -8.7 ms | 6,170.0 | -0.62% | 14,963.5 | 147.2 | 0 of 1336 |

Every configuration's objects are the unpatched executable's. In the one-call orders 2,218 of `sqlite3.c`'s functions
make one allocator call and the 3 with a constraint two; today 637 make one, 1,581 two and those 3 three.

The allocator by what it does, `sqlite3.c`, ms (`tables/sqlite-one-allocation-allocator.md`; in the one-call orders
lookup and edge moves are the allocation's that stands):

| ms | two | shared | prefix | inline |
| --- | ---: | ---: | ---: | ---: |
| validation to intervals, the first call | 20.7 | 20.8 | 20.9 | 20.8 |
| validation to intervals, the second call | 13.6 | 0.0 | 0.0 | 0.0 |
| the plain assignment, or its verdict | 14.9 | 15.0 | 8.5 | 1.1 |
| the preferred assignment | 10.0 | 9.6 | 10.6 | 14.2 |
| lookup columns and slot sharing | 3.1 | 1.8 | 1.8 | 1.8 |
| edge moves | 19.3 | 9.8 | 9.9 | 9.8 |
| the callee-saved step | 5.5 | 3.6 | 5.4 | 5.4 |
| **the allocator** | 86.9 | 60.7 | 57.1 | 53.3 |
| **the pipeline** | 300.5 | 272.5 | 268.9 | 265.3 |

In `laps7.patch`'s executable the pressure bound ("quiet") measured -6.74% user cycles on `sqlite3.c`, -2.78% on Lua
and -0.78% on musl against the unpatched executable. The preferred allocation first ("one") changes five functions,
all larger: `sqlite3GenerateRowDelete` (1,382 to 1,742 bytes), `sqlite3UniqueConstraint` (398 to 477) and
`windowIfNewPeer` (280 to 310) in `sqlite3.c`, `finishbinexpval` (219 to 226) and `newlabelentry` (205 to 210) in Lua.
They are the functions whose plain assignment meets a constraint.

How much of the plain assignment a prefix verdict needs (`scripts/tools/prefix_share.py`, `tables/prefix-share.txt`):
the positions before the last bound definition interval's end hold 11.6% of the plain assignment's time in
`sqlite3.c`'s functions with a preferred allocation, 25.8% in Lua's and 11.8% in musl's; the most required uses at one
position are 7, 6 and 7 against 8 general registers.

From `laps5.patch` on, the patched executable's own "two" also computes, in every function, whether the plain
assignment provably meets no constraint, which today's compiler doesn't: 1.9 ms of `sqlite3.c`'s callee-saved step.
The unpatched executable is the reference for that reason. The "prefix" and "inline" orders compute the most required
uses at a position with a pass of their own in that step, 1.8 ms on `sqlite3.c`.

The prototypes keep their state in globals and are right on one lane only (two lanes crash the patched compiler when
a prototype is switched on).

## 9. Limits

- One host, one commit, three corpora; `-c` only.
- The counters by stage are for `sqlite3.c` alone.
- Eight lanes are in the baseline only: no prototype was run on more than one.
- The profile-guided build is trained on what it is measured on.
- The stage clocks cost 0.1% with the log off; with it on, the log's writing after the last lap is in the process's
  time but in no stage's.
- The patched executables differ from the unpatched one in layout. Each prototype is compared with today's order in
  its own executable, and the last two also with the unpatched executable.
