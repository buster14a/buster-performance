# Resource coordination for Buster #449, #450 and #451 part 1

The coordinator claimed three independent scopes before edits, assigned one writer and checkout to each branch,
and spawned at most three coding agents. No further agents were spawned. The owner later confirmed that local
validation and Benchpress were sufficient; independent cloud validation was not required.

| Scope | Claim | Branch | Compiler revision |
| --- | --- | --- | --- |
| #450 | [claim](https://github.com/buster14a/buster/issues/450#issuecomment-6413009928) | `codex/450-one-lane-dispatch` | `b14e096a2c72db145143123f4b566da3729ab102` |
| #449 | [claim](https://github.com/buster14a/buster/issues/449#issuecomment-6413010319) | `codex/449-label-address-hot-loops` | `c79bc86e249de2d33c3dd89cd9bbda471888daef` |
| #451, part 1 only | [claim](https://github.com/buster14a/buster/issues/451#issuecomment-6413010697) | `codex/451-part1-window-process-cost` | unchanged `9de3d30ba437b381394095d7a77635a2e877435d` |

All comparisons use baseline `9de3d30ba437b381394095d7a77635a2e877435d`. The two unfinished #113 lane-cost
branches had released their claims; #450 changes neither arenas nor assignment of the costliest part. Parts 2 and 3
of #451 are outside this campaign.

## Coding and validation host

The local 7940HS has 16 permitted logical CPUs, eight physical cores, about 46.8 GiB RAM, and no ancestor CPU quota
or memory maximum below those physical resources. Initial available memory was about 35 GiB. The cgroup inspection
included the calling scope and its user-slice ancestors. `raw/local-resource-gate.sh` is the actual execution gate.

| Work | CPUs | CPU quota | Memory cap | Concurrency |
| --- | --- | --- | --- | --- |
| A compilers | 0,1 | 200% | 8 GiB | shared heavy-job permit |
| B compilers | 2,3 | 200% | 8 GiB | shared heavy-job permit |
| C compilers | 4,5 | 200% | 8 GiB | shared heavy-job permit |
| Tests with up to eight lanes | 0-7 | 800% | 8 GiB | exclusive shared heavy-job permit |

Only one CPU-intensive build/test command may hold the local permit at a time. Its descendants inherit the cgroup
cpuset, quota and memory cap. Normal builds infer two compile jobs from the constrained affinity. Call-graph
captures were explicitly capped at two. Coding, source reads and edits could overlap independently. There was no
duplicate full build of the same source revision; focused baseline/sanitizer harnesses reused source where safe.

**Scheduling deviation:** one early #450 correctness run created eight worker lanes inside the two-CPU build scope.
It was CPU-capped but did not meet the intended runnable-worker budget. The test scope was corrected to eight CPUs
under the same exclusive permit and the complete test was rerun successfully. Both logs are retained in #450's
local-validation directory. No performance measurements used that scope.

## Benchpress

The Ryzen 7 9700X is a separate host with 15 online logical CPUs (CPU 10 offline), eight cores, about 62.4 GiB RAM,
and no restrictive user-slice CPU quota. No coding agent executed there. The coordinator alone schedules source
preparation, builds, acceptance, profiling and measurement commands. Only one heavy command owns its memory/CPU pool
at a time; six explicitly named CPUs are allowed for manual builds (0,1,3,4,5,6), leaving host headroom. Measurement
commands use CPU 2, or the issue's eight-lane list `2,0,1,3,4,5,6,7` with the calling thread on CPU 2.

The actual lock is `/var/lib/buster-9700x/lock`, entered exclusively through the existing
`/home/david/buster-fast-bench/exclusive.sh`. Its owner/title/link receipts are in the raw command logs. Runner job
hooks acquire the same lock. The wrapper releases between individual benchmark commands, including failures; no
private replacement lock exists. Builds and acceptance occupy separate holds from measurements. Unrelated CI jobs
interleaved at these boundaries, causing substantial queue waits, and never overlapped our locked commands.

The coordinator's FIFO measurement campaigns are #451 part 1, then #450, then #449. Separate record directories
contain each command, exact input and compiler identity, repetitions, raw observations and report-reader source.
The baseline is built once for all comparisons. Each candidate has one native target build.

## CI resource guard

The original workflow ran heavy test commands concurrently, and its call-graph command launched all 42 compiler
captures together. Before opening the code PRs, the session added a separate guard: one test command at a time, and
call-graph captures limited to the allowed core count with a failure on an unknown budget. Tests, compiler flags,
per-command deadlines and acceptance thresholds are unchanged. A two-CPU capture run, serial-runner probe and
zero-budget rejection passed locally. The original guard commit is
`d0a7426b4149e8a175d85bab75c28f29c139630f`; #449 carries it as
`1a529bc54c1977c0e2dec0881aa64396957ec03a`. Neither changes compiler source from the measured revisions.

No PR is automatically merged.
