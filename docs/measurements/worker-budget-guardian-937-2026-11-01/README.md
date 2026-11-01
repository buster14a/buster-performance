# Worker budget: one jobserver guardian per session or per lease, Buster #937

[Issue #937](https://github.com/buster14a/buster/issues/937) asks whether the
GNU make worker-budget guardian should live for a command instead of being
spawned and waited for on every lease. Its decision rule is measurement first:
keep the per-lease guardian with its cost stated unless a session-long guardian
saves a measurable amount.

**Decision: keep the per-lease guardian. No session-long prototype and no
production change.** On the 9700X, a one-file `-c` command has one lease and a
three-unit link has four; the four guardians together cost 1.65 ms of
instrumented lease work (1.31% of the link's 126.40 ms) and 2.25 ms of paired
wall time (1.81%). A session-long guardian can remove at most three of the
four, about 1.2 to 1.7 ms (0.9 to 1.3% of the link), and saves nothing on the
one-lease `-c` command that dominates a build. That ceiling is below the
whole-driver resolution documented in `docs/profiling.md` (builds compared in
turn about 2%; single rounds 5 to 10% off) and far below the lane policy's own
saving (the serial link control is 135.42 ms against 126.40 ms). The extra
long-lived process, message protocol and between-lease failure handling are not
justified.

## Sources and host

- Buster head: `1cd79711a1fe2526c70f3f331b4aa8f1e8e599a8` (`origin/main`,
  2026-11-01), built on the 9700X by `BUSTER_DEBUG_INFO=0 ./build.sh` with
  Clang 23.1.1, producing the 41 MB `-no-pie` executable named by the issue
  (`ac48f9759bca032f65b973ba532619718a2d46b792bda4aee7903a8e230e0bf8`).
- The tree is unmodified except for a temporary environment-gated timing patch
  in `src/buster/compiler/worker_budget.c` (`scripts/timing.patch`, 36 added
  lines): `clock_gettime(CLOCK_MONOTONIC_RAW)` around acquire (function entry
  through the grant read) and release (close of the control pipe through
  `waitpid`), printed only when `BUSTER_WORKER_BUDGET_TIMING` is set. The
  patch was never committed; `trees/trees.txt` records both file hashes.
- Host: AMD Ryzen 7 9700X, 8 physical cores, Linux 6.18.50-2-lts, GNU Make
  4.4.1, Python 3.14.7. CPU 2 has governor and energy preference `performance`;
  commands run on CPUs 0 to 7, one per core. The standalone lease runs are
  pinned to CPU 2.
- Inputs: the frozen `sqlite3.c` from the 9700X job's preprocessor corpus
  (`/home/david/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c`,
  SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`),
  plus `scripts/main.c` and `scripts/helper.c`. The corpus's `shell.c` is from
  a different SQLite release and exits on its version check; the three-unit
  link uses `sqlite3.c`, `main.c` and `helper.c` instead, so the link is still a
  full SQLite translation unit plus two tiny units and takes the same four
  leases (units, merge, link check, write). The resulting program runs with
  status 0.

## Method

- **One lease alone** (`scripts/lease_cost.c`): the harness performs the same
  protocol as `worker_budget_acquire` and `worker_budget_release`: create a
  GNU make style token pipe, create the control and reply pipes, `posix_spawn`
  the compiler with `--buster-worker-budget-guardian` and four inherited
  descriptors, read the grant, close the control pipe, read the acknowledgement
  and `waitpid`; it then checks that every token byte returned. 51 samples per
  token count (1, 2 and 7), pinned to CPU 2, each group in a hold of the host's
  lock.
- **Commands** (`scripts/measure_commands.py`): a synthetic GNU make jobserver,
  a pipe holding seven token bytes and
  `MAKEFLAGS=" -j8 --jobserver-auth=READ,WRITE"`, exactly what make gives a `+`
  recipe with seven spare slots. The command runs with that server and with
  `MAKEFLAGS` removed; both take the same lane rule (one lane per core, eight
  lanes here). Two warm-up rounds precede 41 measured runs per cohort, in a
  rotation that changes each cohort's position. The instrumented compiler's
  lease lines are parsed and the harness verifies that all seven tokens return.
  The `--lanes 1` controls (5 runs) are serial references only.
- **Real make** (`scripts/run_make.py` and `scripts/Makefile`): `make -j8 -s`
  with `+` recipes, 5 runs of the one-file compile and of the link, to confirm
  the lease counts and the protocol under GNU make itself. The times include
  make's own overhead and are not the primary figures.
- Every group (standalone leases, commands, real make, the byte-identity check
  and `test-check-lanes`) ran in its own hold of
  `~/buster-fast-bench/exclusive.sh`; the raw logs are under `logs/`.

## Results

One lease alone, medians of 51 samples (microseconds):

| Extra tokens | Acquire | Release | Total |
| ---: | ---: | ---: | ---: |
| 1 | 139.3 | 24.3 | 163.9 |
| 2 | 136.7 | 24.2 | 160.9 |
| 7 | 138.4 | 24.0 | 162.2 |

The cost is width-independent: spawn, exec of the 41 MB executable, the token
transfer and the wait dominate. This is lower than the earlier 7940HS
measurement's 470 to 525 microseconds because that harness used a 106 MB
debug-info build as an upper bound; this record uses the release executable
the issue names.

Commands, medians of 41 runs (milliseconds for wall; microseconds for lease
parts; `share` is the instrumented lease sum over the jobserver wall):

| Cohort | Leases | Wall | p10 | p90 | Acquire | Release | Lease | Share |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite.c` `-c`, jobserver | 1 | 122.829 | 121.381 | 124.013 | 550.2 | 140.3 | 689.6 | 0.56% |
| `sqlite.c` `-c`, no jobserver | 0 | 121.371 | 120.438 | 122.446 | 0 | 0 | 0 | 0 |
| three-unit link, jobserver | 4 | 126.402 | 125.458 | 136.505 | 1,424.3 | 255.3 | 1,651.2 | 1.31% |
| three-unit link, no jobserver | 0 | 124.243 | 123.376 | 124.927 | 0 | 0 | 0 | 0 |

Paired wall difference, jobserver minus no-jobserver at the same run index
(milliseconds):

| Command | Median | Minimum | Maximum |
| --- | ---: | ---: | ---: |
| `sqlite.c` `-c` | +1.253 | -1.282 | +4.248 |
| three-unit link | +2.252 | -0.112 | +29.259 |

The one-file command's negative minimum shows that a single lease's wall cost
is at the noise level; the link's positive median is consistent with four
leases. The paired medians are larger than the instrumented sums by about 0.6
ms per command (one-file 1.25 ms against 0.69 ms; link 2.25 ms against 1.65
ms), the exec's effect on the parent's instruction and page caches, which a
session-long guardian would still pay once.

Serial controls, medians of 5 runs:

| Cohort | Wall | p10 | p90 |
| --- | ---: | ---: | ---: |
| `sqlite.c` `-c`, `--lanes 1` | 133.151 | 132.479 | 133.665 |
| three-unit link, `--lanes 1` | 135.423 | 134.617 | 135.992 |

The default lane policy is 7.8% faster than serial for `-c` and 6.7% faster
for the link; the guardian's share is an order of magnitude smaller.

Real `make -j8` confirmation, medians of 5 (including make's own overhead):

| Target | Leases | Wall | Lease |
| --- | ---: | ---: | ---: |
| `compile` | 1 | 124.980 | 691.2 µs |
| `link` | 4 | 140.676 | 1,477.7 µs |

## Decision and the session-long ceiling

A session-long guardian is spawned at a command's first lease and kept until
the command ends. It therefore still pays one spawn and exec; the saving is
the later leases:

- **one-file `-c`:** one lease, saving **0**;
- **three-unit link:** four leases, saving at most three. The instrumented
  total is 1.65 ms, so three quarters is about **1.24 ms (0.98%)**; the paired
  wall total is 2.25 ms, so the upper bound is **1.69 ms (1.34%)**. The first
  guardian also carries the cache effect, so the actual saving is at the lower
  end.

That upper bound is below the whole-driver resolution documented in
`docs/profiling.md` ("Comparing two versions": builds in turn about 2%,
single rounds 5 to 10% off) and applies only to multi-unit link commands; the
one-lease `-c` commands that dominate a build save nothing. The #673
qualification's same-head one-file control also found the jobserver and the
unrestricted build within noise (134.221 ms against 134.277 ms). The earlier
7940HS measurement reached the same conclusion with a larger upper-bound
binary; this record supplies the missing locked-9700X qualification.

The per-lease model therefore stays. No timing patch, no protocol change and
no new process lifetime land. The existing guarantees remain those
`worker_budget_test.c` checks: every borrowed byte returns after each region
and on compiler death, the full-pipe recovery, the implicit slot never
returned, one lane when the guardian cannot start, `make -n` unchanged, and
compiler-thread accounting apart from the guardian.

## Checks

- Both cohorts produce byte-identical outputs: the `-c` objects are both
  SHA-256 `25d96bd3b0e2bc4dc7a709301388520eb9afbd11da6bc9ad7c56afc9941ca450`
  and the linked programs both
  `e4d961c9f014409e3492c4ecb7e0cb45d9ea2bf3c5b11ef118c9da9e4d7f5511`; both
  programs exit 0 (`logs/identity.txt`).
- `test-check-lanes` on the instrumented tree: 3,760 checks, 0 failures,
  including 221 worker-budget checks (`logs/test-check-lanes.log`).
- Both the jobserver and the matched no-jobserver command use eight active
  lanes (`worker-budget mode=jobserver requested=8 granted=8 active=8` and
  `mode=none requested=8 granted=8 active=8`); `logs/ts-*.txt` retain the
  `--time-stages` runs that show it.

## Limits

- One host and one placement. CPU 2 has `performance`; CPUs 0, 1 and 3 to 7
  run `powersave` with EPP `balance_performance`, and a lane that wakes from
  idle can read slow for a short while. The link's p90 (136.5 ms) and one
  paired run (+29.3 ms) show such outliers; the medians and the paired median
  are the primary figures, and the instrumented lease sums do not depend on the
  lanes' wake state.
- The release build only. A debug-info build's guardian exec is larger; the
  earlier 7940HS record's 106 MB upper bound found the same decision, so this
  record does not repeat it on the 9700X.
- The synthetic jobserver is GNU make's protocol, not make's scheduler; the
  real `make -j8` runs confirm the same one- and four-lease counts and the
  expected wall range. The link's make median (140.7 ms) includes make
  overhead and cold outliers and is not compared with the synthetic figure.
- The link workload is `sqlite3.c` plus two tiny units, not the corpus's
  mismatched `shell.c`. The four lease sites (units, merge, link check, write)
  are the ones the issue names.
- No session-long implementation was built: the decision rule did not pass,
  so there is no A/B of the two policies. The ceiling above is derived from
  the per-lease measurements and the four-lease count.

## Reproduction

The scripts are in `scripts/`; the tree is head `1cd79711` plus
`timing.patch`. On the 9700X, with the lock held per group:

```sh
cd ~/buster-937-measure
EXCLUSIVE_OWNER=solve-937 EXCLUSIVE_TITLE="solve 937: guardian measurement" \
  EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/937" \
  ~/buster-fast-bench/exclusive.sh bash run_lease.sh > lease.txt
EXCLUSIVE_OWNER=solve-937 EXCLUSIVE_TITLE="solve 937: guardian measurement" \
  EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/937" \
  taskset -c 0-7 ~/buster-fast-bench/exclusive.sh bash run_commands.sh > commands.txt
EXCLUSIVE_OWNER=solve-937 EXCLUSIVE_TITLE="solve 937: guardian measurement" \
  EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/937" \
  ~/buster-fast-bench/exclusive.sh bash run_make.sh > make.txt
python3 scripts/summarize.py
```

`run_commands.sh` defaults to 15 runs; the record's 41-run figures used
`RUNS=41`, and the serial controls used
`measure_commands.py ... --runs 5 --only serials`.
