# Current-main b8 intermediate combination

This is a frozen intermediate compatibility/performance screen, not the final
accepted batch. It still contains the subsequently rejected #653 directory
cache. Commit `da22a8a1` removes that experiment; later #628/#647 integration
is measured and tested separately. No speedup from this screen is transferred
to those later revisions.

Baseline is main `4165454ebadf9b96c2b40ab99c55f4c0b28ba975`; candidate is
`b8cd163ce33bb8042e42fd9fea7c675ae13fa487`. Both include #682's test-build
optimization. Native target binaries, Clang 23.1.1 / Ryzen 7 9700X:

- Base: `46bec1e120ca54b1ae99502136988cea0890e96f4af8eb704cdcd2b6cef748ed`.
- Candidate: `a8f126487810ad56139187ee49c266c883e6c017ab8a98ac5fce34ee994943d6`.

All builds, tests, timing and metadata/packaging work use the shared target
lock. No host settings change. Source manifest validation confirms all 672
tracked candidate paths. Build: 41 units / 28.9 s. Nine native test groups
pass in 45.0 s, 111.7 CPU seconds, four-CPU budget. Checker 488,765/zero;
deferred 1,147/zero; Tier 0 95,965/zero; c-testsuite 220/220. Full logs retain
all other group counts and process statuses.

## Fresh-process screen

`cohort.c` and `samples.c` use the exact frozen SQLite input/flags recorded in
the campaign's `method/COMMANDS.md`. The one-worker case has 21 rotated pairs
of one compile; eight workers have 11 pairs of 32 compiles each, pinned to
physical cores 0–7. The single worker uses CPU 2. Ordinary compilation forces
one internal lane in every child; output is written to real files.

| Workers | Baseline → candidate MB/s | Peak RSS KiB | Major faults, all samples |
| --- | ---: | ---: | ---: |
| 1 | 73.043807 → 74.043586 | 393,308 → 388,680 | 0 / 0 |
| 8 | 213.564621 → 219.693326 | 393,380 → 388,720 | 79 / 169 |

All 42 single-worker and 22 eight-worker cohorts succeed. Same-baseline A/A
controls use the identical protocol and retain every process:

| Workers | Role 0 → role 1 MB/s | Major faults, all samples |
| --- | ---: | ---: |
| 1 | 73.170418 → 73.090169 | 0 / 0 |
| 8 | 213.706141 → 213.205093 | 101 / 77 |

The observations are +1.37% / +2.87% throughput, against A/A role differences
about −0.11% / −0.23%. No placement/fresh-copy campaign was performed for this
intermediate source union, so these are screening results, not acceptance of
a small general throughput gain. All faults/outliers are retained. Different
RSS, throughput and fault statistics are not combined into a causal claim.

Every one of the **1,492 repeated SQLite objects** across A/B and A/A has
SHA-256 `cb578161715c2ecf83659069957077739447d8eccb7be54953faeb30990d9755`.
These are repeated compiles of one pinned workload, not 1,492 independent
semantic fixtures. Per-child statuses/resources/stderr and the full digest
manifest are in `target/results/`. Large objects remain on the target.

`current-b8-collect.sh` hashes outputs and creates the compact metadata archive
under the lock. The archive is preserved locally as `target-metadata.tar.gz`,
SHA-256 `b664a71576dfae31992e38e97b15e1fd952532d9a80d1e3e547db1c11734f4d3`.
The extracted text accompanies the report. Source/build/test/sample/queue
receipts and exact binary identities are retained alongside it. No PR or push
has been made.
