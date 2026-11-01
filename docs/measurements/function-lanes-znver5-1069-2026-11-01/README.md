# Function lanes on znver5 code (#1069), 2026-11-01

[Buster #1069](https://github.com/buster14a/buster/issues/1069) measures `docs/function-lanes.md`'s 9700X table
again. The table was measured before [#1047](https://github.com/buster14a/buster/pull/1047), when
`benchmark-check-lanes` emitted baseline x86-64 code whatever `-march` said. From #1047 on, it emits code for the
target its options give: here `-march=znver5`, as `-c` compiles with those options.

The measurement is the 9700X CI job's `benchmark-check-lanes` step. No session had a shell on the host.
[Buster #1072](https://github.com/buster14a/buster/pull/1072) set that step to the table's lane counts
(`--lanes 1,2,3,4,6,8`, plus the rule's row); its own Benchpress run is the measurement.

## Sources

- **Measured:** `c8a4838bc3`, GitHub's merge of #1072's head `1c8dacaa1f249df09885e28954d8ae95b6172f15` into
  main's `f6a695c0b4f7a6cb619bb12e302e55078700e44b`.
  [Job 124905538469](https://github.com/buster14a/buster/actions/runs/41323959790/job/124905538469):
  `logs/c8a4838b-benchmark-check-lanes.log`.
- **Earlier run:** `5c31abc8b0`, the merge of #1047's head `3ca51defe59087bcd166dfbfee82c5aaa66f85ca` into
  `92252c3021fc856131d762304e33d15d80d27b09`, on 1, 2, 4 and 8 lanes. This is the first znver5 run of the step, for
  the run-to-run spread.
  [Job 124885588062](https://github.com/buster14a/buster/actions/runs/41305821424/job/124885588062):
  `logs/5c31abc8-benchmark-check-lanes.log`.

Each log holds the job's header lines (runner, CPU, checkout, the clang that built the compiler) and the step's
group, command and output, as the job's log has them. ANSI color codes are removed and nothing else is changed.

## Host and method

- AMD Ryzen 7 9700X (runner `buster-zen5-9700x`, machine `benchpress`), under the shared host lock, which the
  runner's job hooks take for each job.
- The compiler was built by the job (`BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`) with clang 23.1.4
  (`7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`).
- The input is the frozen `sqlite3.c` of corpus `preprocessor-391e729af658`, with its pinned predefines and system
  headers, and `-march=znver5 -std=gnu17`: 2,602 functions, 554,920 tokens in their bodies, the largest 28,603, and
  1,227,192 bytes of code.
- `--passes 11`: each row is the median, fastest and slowest of 11 runs after a warm-up, in an order that rotates by
  pass. Lane 0 runs on CPU 2 and the other lanes on one CPU of each other core (`--cpus 2,$others`, 7 others).
  Every run must emit the warm-up's code, and each lane count's object must be one lane's, byte for byte.

## Results (`c8a4838b`)

Times are in milliseconds.

| Lanes | Emission | Fastest | Slowest | Speedup | Preparation | Lanes' part | Merge |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 19.8 | 19.6 | 20.2 | 1.00 | 1.9 | 16.4 | 1.6 |
| 2 | 12.6 | 12.5 | 12.8 | 1.57 | 1.8 | 9.1 | 1.7 |
| 3 | 10.2 | 10.1 | 12.8 | 1.93 | 1.8 | 6.7 | 1.7 |
| 4 | 9.1 | 9.0 | 9.6 | 2.17 | 1.8 | 5.6 | 1.7 |
| 6 | 8.3 | 8.1 | 9.7 | 2.40 | 1.9 | 4.7 | 1.7 |
| 8 | 8.1 | 7.9 | 12.9 | 2.45 | 1.9 | 4.5 | 1.7 |
| The rule's (8) | 8.0 | 7.9 | 11.3 | 2.47 | 1.9 | 4.4 | 1.7 |

On 8 lanes the lanes' part takes 3.6 times less time than on one (16.4 against 4.5 ms). The preparation and the
merge stay serial, 3.6 ms together, 44% of 8 lanes' time.

## Run-to-run spread

`5c31abc8`'s run, on 1, 2, 4 and 8 lanes, agrees within 0.6% on 1, 2 and 4 lanes (19.8, 12.6 and 9.1 ms) and
on the rule's row (8.1 ms). Its forced 8-lane median is 8.8 ms (8.0 to 10.5 ms), and its lanes' part on 8 lanes is
5.2 ms, so its ratio for that part is 3.1 rather than 3.6. The 8-lane rows' slowest runs (10.5 to 12.9 ms) are
up to 60% over their medians in both runs. One run's 8-lane median can move by several percent; a figure derived
from it should be read as a range.

## Limitations

- These are two CI runs, each one process of 11 passes. They are not a campaign of independent processes.
- The compiler changed in many places between the table's earlier measurement (clang 23.1.1, baseline code) and
  these runs. The difference between the two tables mixes the target, the compiler's other changes and the
  toolchain, and is not the cost of znver5 code alone.
- The measurement covers the emission alone (lowering, Tier 0, branch sizing, encoding and the link's code), not
  the whole driver.
