# Resource coordination for Buster #449, #450 and #451 part 1

The coordinator claimed three independent scopes before edits, assigned one writer and checkout to each branch,
and spawned at most three coding agents. No further agents were spawned. The owner later confirmed that local
validation and Benchpress were sufficient; independent cloud validation was not required.

| Scope | Claim | Branch | Compiler revision |
| --- | --- | --- | --- |
| #450 | [claim](https://github.com/buster14a/buster/issues/450#issuecomment-6413009928) | `codex/450-one-lane-dispatch` | prototype `b14e096a2c72db145143123f4b566da3729ab102`; helper follow-up `e2de00e9c0a485c4e13cfd0ff13489b67066fa99` |
| #449 | [claim](https://github.com/buster14a/buster/issues/449#issuecomment-6413010319) | `codex/449-label-address-hot-loops` | qualified source `f7af14f10cfb38fcbc384dcb2584ed846fe33860`; prototype `c79bc86e249de2d33c3dd89cd9bbda471888daef` retained |
| #451, part 1 only | [claim](https://github.com/buster14a/buster/issues/451#issuecomment-6413010697) | `codex/451-part1-window-process-cost` | unchanged `9de3d30ba437b381394095d7a77635a2e877435d` |

The primary comparisons use baseline `9de3d30ba437b381394095d7a77635a2e877435d`. During qualification the #113
enum-fixed-state correction merged as `31c4ced26abcf0393e8c8f4f138e42dfe1952ee4`; #450's helper follow-up includes
that correction and is compared against that exact new baseline. The original #113 arena/costliest-part follow-ups
had released their claims. #450 changes neither arenas nor assignment of the costliest part. Parts 2 and 3 of #451
are outside this campaign. The completed documentation-only [#451 part 1 PR](https://github.com/buster14a/buster/pull/462)
was merged outside this coordinator; the coordinator did not merge it.

## Coding and validation host

The local 7940HS has 16 permitted logical CPUs, eight physical cores, about 46.8 GiB RAM, and no ancestor CPU quota
or memory maximum below those physical resources. Initial available memory was about 35 GiB. The cgroup inspection
included the calling scope and its user-slice ancestors. The completed source builds and fixture validation used
the initial team gate, retained as `raw/local-resource-gate-before-shared-queue.sh`:

| Work | CPUs | CPU quota | Memory cap | Concurrency |
| --- | --- | --- | --- | --- |
| A compilers | 0,1 | 200% | 8 GiB | shared heavy-job permit |
| B compilers | 2,3 | 200% | 8 GiB | shared heavy-job permit |
| C compilers | 4,5 | 200% | 8 GiB | shared heavy-job permit |
| Tests with up to eight lanes | 0-7 | 800% | 8 GiB | exclusive shared heavy-job permit |

Only one CPU-intensive build/test command may hold the team's local permit at a time. Its descendants inherit the
task affinity, CPU quota and memory cap. The user scope does not delegate the cpuset controller; affinity is applied
with taskset, rather than a kernel cpuset restriction. Normal builds infer two compile jobs from that affinity. Call-graph
captures were explicitly capped at two. Coding, source reads and edits could overlap independently. There was no
duplicate full build of the same source revision; focused baseline/sanitizer harnesses reused source where safe.

**Scheduling deviation:** one early #450 correctness run created eight worker lanes inside the two-CPU build scope.
It was CPU-capped but did not meet the intended runnable-worker budget. The test scope was corrected to eight CPUs
under the same exclusive permit and the complete test was rerun successfully. Both logs are retained in #450's
local-validation directory. No performance measurements used that scope.

### New shared local queue

After the owner pointed out the new shared queue, the coordinator consulted current llm-memory and inspected the
installed `/home/david/dev/scripts/cores`. Future multicore work enters this actual global FIFO in addition to the
team's conservative one-heavy-job permit. It reserves physical cores through inherited slot descriptors, pins both
SMT threads of each granted core, and sets niceness 19 and best-effort I/O priority 7. The existing daytime policy
keeps cores 0 and 1 (CPUs 0,8,1,9) for interactive use; this session did not change that policy or the queue's state paths.

Build roles request two physical cores (two compile jobs, 200% CPU quota); eight-lane test roles request four physical
cores and use their eight SMT CPUs with an 800% quota. Both retain the 8 GiB memory cap. The latter refuses a grant
too small for eight runnable workers. Every descendant receives the granted CPU list, rather than the original fixed
CPU pins, and local wild linking explicitly uses at most the granted core count. Single-threaded report reading does
not require multicore tickets.

`raw/local-resource-gate.sh`, `raw/granted-job.sh` and `raw/limited-wild.sh` retain the updated gate. The live probe in
`raw/shared-queue-probe.txt` verified a two-core grant (CPUs 2,10,3,11), niceness 19, `cpu.max=200000 100000`, and
`memory.max=8589934592`. All slots were free again afterward. This migration does not retroactively describe earlier
runs as using the global queue. It does not replace Benchpress's separate shared lock.

## Benchpress

The Ryzen 7 9700X is a separate host with 15 online logical CPUs (CPU 10 offline), eight cores, about 62.4 GiB RAM,
and no restrictive user-slice CPU quota. No coding agent executed there. The coordinator alone schedules source
preparation, builds, acceptance, profiling and measurement commands. Only one heavy command owns its memory/CPU pool
at a time; six explicitly named CPUs are allowed for manual builds (0,1,3,4,5,6), leaving host headroom. Measurement
commands use CPU 2, or the issue's eight-lane list `2,0,1,3,4,5,6,7` with the calling thread on CPU 2.

The actual lock is `/var/lib/buster-9700x/lock`, entered exclusively through the existing
`/home/david/buster-fast-bench/exclusive.sh`. Its owner/title/link receipts are in the raw command logs. Runner job
hooks acquire the same lock. The primary campaigns released between individual benchmark commands, including failures;
no private replacement lock exists. For follow-up qualification the owner explicitly approved paired groups of separate
processes with lock holds capped at 60 seconds, overriding the repository's per-run release rule for this session.
The follow-up queue places each group under `timeout --signal=TERM --kill-after=1s 55s`, inside the actual shared
wrapper, and releases between groups. A timeout is a failed group, never an accepted partial result. Builds and
acceptance occupy separate holds from measurements. Unrelated CI jobs
interleaved at these boundaries, causing substantial queue waits, and never overlapped our locked commands.

The coordinator's FIFO measurement campaigns are #451 part 1, then #450, then #449. Separate record directories
contain each command, exact input and compiler identity, repetitions, raw observations and report-reader source.
The original baseline was built once and reused across the primary comparisons. The changed #450 baseline needs one
new native build, as does its helper candidate. An explicitly invalid-for-production #449 predicate ablation is built
separately and used only for attribution on label-free inputs. No identical source revision receives duplicate full builds.

## CI resource guard

The original workflow ran heavy test commands concurrently, and its call-graph command launched all 42 compiler
captures together. Before opening the code PRs, the session added a separate guard: one test command at a time, and
call-graph captures limited to the allowed core count with a failure on an unknown budget. Tests, compiler flags,
per-command deadlines and acceptance thresholds are unchanged. A two-CPU capture run, serial-runner probe and
zero-budget rejection passed locally. The original guard commit is
`d0a7426b4149e8a175d85bab75c28f29c139630f`; #449 carries it as
`1a529bc54c1977c0e2dec0881aa64396957ec03a`. Neither changes compiler source from the measured revisions.

No PR is automatically merged.

## Qualification checkpoint

#451 part 1 is complete and its documentation PR is merged. #449's final production candidate passes its native
identity/receipt checks and all 840 timed plus 220 counted processes. Frozen SQLite instructions are
1,718,752,973 → 1,688,577,437; wall is 147.964 → 146.825 ms and RSS 598,300 → 598,208 KiB. Required Lua and
label-dispatch wall/RSS observations show no consistent new cost. The record retains the local baseline oracle
and broader sanitizer findings separately; submitted-head CI remains a separate gate.

#450's direct-context prototypes remain unaccepted. Both the helper on `31c4ced2` and the outlined-phase experiment
pass correctness, but their whole SQLite medians increase. Their complete negative evidence is retained. The
issue's alternative of avoiding redundant affinity writes in the existing lane-team path is under investigation;
no acceptance is claimed for that unfinished candidate.

The completed measurement sequence so far is 40 individual holds for #451, 508 for the first #450 prototype,
30 for the first #449 candidate, nine for the #449 attribution, five approved grouped holds for the #450 helper,
five grouped holds for the final #449 candidate, then five for the outlined #450 trial: 602 measurement holds.
This excludes separate builds, source preparation, correctness and identity captures, and B's paired preflight
group. All completed grouped measurement holds last at most 38 seconds; the #449 groups last 11–12 seconds.

Publication filtering removes only queued-wait owner/title/link metadata (which can contain other sessions' private
links). Local FIFO grant IDs, CPU grants and elapsed waits, acquired host-lock receipts, commands, observations,
timestamps and statuses remain. The filter is retained in `raw/filter-waiting.awk`; unfiltered transport archives
remain with the coordinator. This filtering does not alter any measurement row or metric computation.
