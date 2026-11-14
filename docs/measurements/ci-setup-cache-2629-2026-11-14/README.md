# The 9700X job's setup, before and after its cached records (buster#2629)

[buster#2629](https://github.com/buster14a/buster/issues/2629): the owner asked that the 9700X job spend no run fetching
what an earlier run already fetched. buster `d9add0d32` (on `main` since 2026-11-13) moved its last three downloads to
the runner's private cache (`BUSTER_CI_CACHE`):

- buster-performance's two pinned records, which `actions/checkout` fetched from GitHub on every run:
  - Tier 1's Lua scripts (`818cfbbc`);
  - the branch-sizing harness (`a00d16e4`).

  `tools/ci/fetch-performance.sh` now keeps them in a bare mirror and checks out the record's directory alone from it.
- `speedtest1.c` in "Time the direct forms against their helpers", which `curl` downloaded. It now comes through
  `cached-download.sh`, as the step before it already took it.

This record times the setup in two nightly snapshots of `main`, one from before the change and one from after, and
times the new script's routes on the 9700X.

## The runs (`logs/`, `results/steps-*.tsv`, `results/groups-*.tsv`)

| | before | after |
| --- | --- | --- |
| Run | [43341714661](https://github.com/buster14a/buster/actions/runs/43341714661) | [43538151259](https://github.com/buster14a/buster/actions/runs/43538151259) |
| Commit | `090b0faa` | `013ceb61` (buster#2633's merge) |
| Benchpress job | 131611530648 | 132272343159 |

`steps-*.tsv` are the job's steps from GitHub's API, in whole seconds. `groups-*.tsv` are the log's step starts,
from which the times below come, to the millisecond. Neither run's changes ran the branch-sizing qualification, so that
step was skipped in both.

| Input | before | after |
| --- | ---: | ---: |
| Tier 1's Lua scripts | `actions/checkout` from GitHub: 1.394 s | `fetch-performance.sh`: **6.656 s**, the mirror's first fill |
| `speedtest1.c` for the helpers | `curl`: 0.411 s (114 KB) | `cached-download.sh`: **0.004 s** |
| the triggering commit (`actions/checkout`) | 4.236 s | 3.908 s |
| the official Clang (`setup-benchpress.sh`) | 0.407 s | 0.406 s |
| c-testsuite's mirror | 0.055 s | 0.063 s |
| SQLite's mirror | 0.367 s | 0.377 s |

The after run is the one that created the mirror. The runner's cache (`results/runner-cache-2026-11-14T0745Z.txt`,
listed at 07:45 UTC):
- **The mirror:** `buster-performance.git`'s one pack, 132.8 MB, was written at 01:23:15. Its lock and its only ref,
  `refs/pinned/818cfbbc…`, are from that step (01:23:09 to 01:23:15).
- **Since then:** no run had reached the step by 07:45. The later nightly backlog runs, of older commits, failed
  before it.

So the after run shows the one-time fill, not the steady state. The next section times both.

The step's 6.66 s also includes its checkout from the new mirror. The `curl` time runs from the line before it
(`sqlite3.c: OK`) to its own `speedtest1.c: OK`. The `cached-download.sh` time runs from the same line to its
`reusing the verified copy` line.

## The routes on the 9700X (`scripts/fill-reuse.sh`, `results/fill-reuse.tsv`)

**The setup.** `fetch-performance.sh` came from `main` at `d9add0d32`. Everything ran as `david` in one hold of the lock,
with a fresh cache under `~/buster-fast-bench/2629-claude/`, not the runner's.

**The routes**, for each pinned commit:
- **GitHub:** without `BUSTER_CI_CACHE`, the script's sparse, partial, shallow checkout from GitHub (as
  `actions/checkout` did), 3 rounds;
- **fill:** the fresh mirror's first fetch;
- **reuse:** 5 rounds from the mirror.

| Commit | Directory | GitHub | fill | reuse |
| --- | --- | ---: | ---: | ---: |
| `818cfbbc` | Tier 1's Lua scripts (5 files) | 1.81, 1.37, 1.13 s | 5.58 s | **0.168 to 0.177 s** |
| `a00d16e4` | branch-sizing harness (48 files) | 0.96, 0.96, 0.96 s | 1.00 s | **0.069 to 0.134 s** |

- **The fill.** The mirror holds each pinned commit's whole tree, shallow, which `uploadpack.allowFilter` then serves
  partially. The first commit fetches buster-performance's tree, a 132.8 MB pack. A second pinned commit adds only the objects
  it doesn't share, 1.0 s here. The mirror then held both commits in 131,672 KiB.
- **The reuse.** Every later run's checkout comes from the mirror. It takes 0.17 s and 0.07 s, against 1.1–1.8 s and
  0.96 s from GitHub. Against the before run's 1.39 s, a run that reaches both records saves about 2.1 s of setup,
  and 2.5 s with the helpers' `speedtest1.c`.

## Nothing downloaded

The after run's log (`logs/after-excerpts.txt` and the full log of job 132272343159) names one URL it fetches, besides
those `cached-download.sh` reused: `https://github.com/buster14a/buster`, the triggering commit by `actions/checkout`.
That is the commit the job measures. It, and a pull request's base for `build-benchmarks.sh` and the branch-sizing
comparison, are what `docs/ci.md`'s cache list says the job still fetches.

Every input it keeps carries a pin that is checked on use:
- the corpus, `speedtest1.c` and Lua's release, by SHA-256, through `cached-download.sh`;
- c-testsuite, SQLite and buster-performance, by their commits, through Git's pack protocol, which checks every
  object's hash.

The pragma oracle is still built each run, in 2.3 s beside the compiler's 35 s unit. `docs/ci.md` says why a cache of it
would save nothing.
