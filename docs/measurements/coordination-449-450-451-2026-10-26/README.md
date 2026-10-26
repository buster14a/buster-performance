# Resource coordination for Buster #449, #450 and #451 part 1

The coordinator claimed three independent scopes before edits, assigned one writer and checkout to each branch,
and spawned at most three coding agents. No further agents were spawned. The owner later confirmed that local
validation and Benchpress were sufficient; independent cloud validation was not required.

| Scope | Claim | Branch | Compiler revision |
| --- | --- | --- | --- |
| #450 | [claim](https://github.com/buster14a/buster/issues/450#issuecomment-6413009928) | `codex/450-one-lane-dispatch` | qualified source `1d2b12c658807f466b989bcdfe2cdf548c1812d5`; rejected direct/helper/outlined/affinity trials retained |
| #449 | [claim](https://github.com/buster14a/buster/issues/449#issuecomment-6413010319) | `codex/449-label-address-hot-loops` | qualified source `f7af14f10cfb38fcbc384dcb2584ed846fe33860`; prototype `c79bc86e249de2d33c3dd89cd9bbda471888daef` retained |
| #451, part 1 only | [claim](https://github.com/buster14a/buster/issues/451#issuecomment-6413010697) | `codex/451-part1-window-process-cost` | unchanged `9de3d30ba437b381394095d7a77635a2e877435d` |

The primary comparisons use baseline `9de3d30ba437b381394095d7a77635a2e877435d`. During qualification the #113
enum-fixed-state correction merged as `31c4ced26abcf0393e8c8f4f138e42dfe1952ee4`; #450's follow-ups include
that correction and are compared against that exact new baseline. The original #113 arena/costliest-part follow-ups
had released their claims. #450 changes neither arenas nor assignment of the costliest part. Parts 2 and 3 of #451
are outside this campaign. The final #450 pair uses exact main `35f26f68d7caa9bf5f6248822100a51c06e2c878`,
including merged #449 and current checker fixes. It was integrated once, without chasing later unrelated revisions.
The completed documentation-only [#451 part 1 PR](https://github.com/buster14a/buster/pull/462)
was merged outside this coordinator. [#449 PR #491](https://github.com/buster14a/buster/pull/491) likewise
merged externally after all four submitted-head CI checks passed. The coordinator did not merge either PR.

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

The primary FIFO measurement campaigns are #451 part 1, then #450, then #449; the complete follow-up order appears
below. Separate record directories
contain each command, exact input and compiler identity, repetitions, raw observations and report-reader source.
The original baseline was built once and reused across the primary comparisons. The changed #450 baseline needs one
new native build, reused across three trial heads. Final #450 qualification uses a new exact35 baseline and its
minimal cold-utility candidate, built once each. An explicitly invalid-for-production #449 predicate ablation is built
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
and broader sanitizer findings separately. Submitted head `29e8e720` passed all four CI checks, including
native run `40354818145`; the code PR merged externally as `8177fdf9` at 16:20:01 UTC.

#450's direct-context prototypes remain unaccepted. Both the helper on `31c4ced2` and the outlined-phase experiment
pass correctness, but their whole SQLite medians increase. Their complete negative evidence is retained. The
issue's alternative of avoiding redundant affinity writes in the existing lane-team path is candidate `63844208`.
Its native lane/fixture/corpus checks and all eight bounded measurement groups passed, and all 226 source,
binary and input digest rows agree before/after. It nevertheless remains unaccepted: one-lane SQLite dispatch
is still 4,439 ns, and repeated whole-reader regressions remain. The complete rejected record is retained.
The checker-only count-one cold-utility candidate `1d2b12c6`, on exact baseline `35f26f68`, passes manual acceptance.
Local sanitizer validation has 56 fixtures/891 checks and no findings; native lane/deferred tests, all 220 C programs
and frozen SQLite agree. A fresh 42-unit graph has no disallowed cycles or split variables. The original 568 measurements
and a predeclared full 219-unit five-pair confirmation (2,190 additional processes) all exit zero; all 226 identity rows
remain unchanged. SQLite one-lane dispatch is 7,204 → 391 ns, small dispatch 30–40 ns, and whole-reader medians are
120.29 → 119.66 ns/token on one lane and 104.09 → 103.84 on eight. The complete confirmation has no unit slower in all
five pairs, while preserving 33 positive build-median ratios and 34 positive paired medians with mixed signs.
Tiny positive observations and earlier rejected candidates are retained, not normalized or discarded. The largest
positive confirmation ratio is 1.5749% on 24 tokens. This supports no repeatable measured regression under the recorded
protocol, not universal or per-sample speedups. Submitted-head CI remains separate from manual acceptance.

The coordinator's manual measurement campaigns entered the shared host queue in this order:

| Order | Scope and candidate | Measurement lock holds |
| --- | --- | ---: |
| 1 | #451 part 1, whole files versus windows | 40 |
| 2 | #450 direct-context prototype | 508 |
| 3 | #449 first candidate | 30 |
| 4 | #449 predicate ablation, attribution only | 9 |
| 5 | #450 helper, rejected | 5 |
| 6 | #449 final control-mask candidate | 5 |
| 7 | #450 outlined-phase trial, rejected | 5 |
| 8 | #450 affinity-check candidate, including three general-lane pairs | 8 |
| 9 | #450 existing-cold-utility candidate, exact35/1d2 | 5 |
| 10 | #450 predeclared complete five-pair corpus confirmation | 1 |
| Total | Ten sequential campaigns | 616 |

This excludes separate builds, source preparation, correctness and identity captures, B's paired preflight
group, and separate CI qualification jobs. All completed grouped measurement holds last at most 38 seconds;
the #449 groups last 11–12 seconds. Affinity holds last 37, 25, 2, 2, 4, 5, 5 and 4 seconds, all exit zero.
Final cold-utility groups last 37/24/1/2/3 seconds; the complete corpus confirmation lasts 36 seconds. All exit zero
and stay below the approved 60-second cap with the 55-second timeout and 1-second forced-cleanup allowance.

Publication filtering removes only queued-wait owner/title/link metadata (which can contain other sessions' private
links). Local FIFO grant IDs, CPU grants and elapsed waits, acquired host-lock receipts, commands, observations,
timestamps and statuses remain. The filter is retained in `raw/filter-waiting.awk`; unfiltered transport archives
remain with the coordinator. This filtering does not alter any measurement row or metric computation.
