# SCCP's phi work on long joins, Buster #1729

Compiler issue: [#1729](https://github.com/buster14a/buster/issues/1729). Compiler PR:
[#1738](https://github.com/buster14a/buster/pull/1738).

## Sources

- `base`: main `8f3793059d1ba15576b3b11883cb07957679e03d`.
- `head`: the PR's `849db5098b389a60236ecdea0415cb5b0fb6124f` (code identical to `c7233a4a`; the last commit is
  documentation).
- `dbase` and `dhead`: the same with #1730's head `0be4045eea42e8b3c8bcbf4ae20d823003f6437a` (#1352's dominators)
  merged in by `git merge --no-edit` in the measurement trees (local merges, not pushed commits), as the issue's own
  table was measured on #1352's branch. `results/dom-1c3a8859.txt` and its profiles are of the PR's earlier head
  `1c3a88592b57332104af0ae86365961075c8682b`, whose queue deferred every phi; it differs from the final head in that
  queue's form, not in these inputs' work (both visit the join's phi a bounded number of times).

Each tree was built on the host with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`, one lock invocation
per build (`run-all.sh`, `dom.sh`, `run-final.sh`). `identities.sha256` has the inputs' and the executables' SHA-256
(`bin/base`, `bin/head` of the final head; `bin/dbase` and the first `bin/dhead` of `1c3a8859`'s pair, the last
`bin/dhead` the final head's with #1730).

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2 (governor and EPP `performance`), THP `always`, clang 23.1.1, CMake 4.4.4,
Ninja 1.13.2, perf 7.2.9 (`host.txt`, a snapshot of the host, not a per-sample receipt).

Inputs (`measure.sh`, the issue's generators and a third): one function `int g(int a)` each, N from 1,000 to 16,000:

- **ternary**: `return a == 0 ? 0 : a == 1 ? 2 : … : 0;`
- **ifs**: `if (a > i) { a += i;` nested N deep, then all N braces, then `return a; }`
- **same**: `return a == 0 ? 7 : a == 1 ? 7 : … : 7;`, every arm one constant.

`point.sh` holds the shared lock once per point (one input) and runs 5 rounds of whole-process `-c --tier1`
compiles, each round both executables in an order that alternates by round, pinned to CPU 2 (`taskset -c 2`), timed
by `date +%s%N` around the process; its lines are `LABEL binary round microseconds status`. After each point the two
objects are compared (`objects identical`). sqlite3.c (the frozen corpus's, the 9700X job's defines) is measured the
same way with 7 rounds, `-c --tier1 --lanes 1` and `-c --lanes 1`. The tables are medians of the rounds
(`summarize.awk`). `profile.sh` records `perf record -e cycles:u -c 200003` of each binary on the 16,000 inputs, one
lock hold per input.

Lock waits' messages, which name other sessions, are not kept: the result files keep only the lines the scripts
write (`grep -E` of their formats).

## Results

Final head against main (main's dominators), ms, medians (`results/main-849db509.txt`):

| input | main | head |
| --- | ---: | ---: |
| ternary, 1,000 | 8.3 | 7.3 |
| ternary, 4,000 | 84.8 | 69.6 |
| ternary, 16,000 | 1,096.1 | 845.8 |
| ifs, 1,000 | 7.2 | 6.4 |
| ifs, 4,000 | 45.4 | 35.1 |
| ifs, 16,000 | 645.3 | 463.8 |
| same, 1,000 | 7.3 | 6.1 |
| same, 4,000 | 81.6 | 66.0 |
| same, 16,000 | 1,034.8 | 760.6 |
| ternary 16,000, default tiers | 13.3 | 13.1 |
| sqlite3.c `-c --tier1 --lanes 1` | 406.4 | 406.6 |
| sqlite3.c `-c --lanes 1` | 119.6 | 119.8 |

All 17 pairs of objects are byte-identical.

With #1730's dominators, the final head (`results/dom-849db509.txt`; `results/dom-1c3a8859.txt` has the earlier
head's run, within 0.5 ms of these):

| N | ifs | ternary | same |
| ---: | ---: | ---: | ---: |
| 1,000 | 6.2 → 5.3 | 6.1 → 5.2 | 5.5 → 4.4 |
| 2,000 | 12.9 → 10.2 | 12.2 → 8.5 | 10.9 → 7.2 |
| 4,000 | 28.1 → 17.5 | 32.1 → 17.8 | 29.7 → 13.7 |
| 8,000 | 83.9 → 40.4 | 107.3 → 48.8 | 90.1 → 25.8 |
| 16,000 | 297.0 → 112.6 | 395.4 → 147.3 | 334.9 → 60.6 |

All 15 pairs of objects are byte-identical.

`ir_optimize_visit`'s share of `cycles:u` at 16,000 (`results/profiles-dom-1c3a8859.txt`): ternary 66.3% → 0.75%,
same 84.1% → 1.5%. What remains is `tier1_cfg_allocate_impl` and `dataflow_liveness_vector_rows` (#1384).

## Limitations

One executable placement per build; no A/A control. Each point's lock hold covers its 10 (or 14) compiles, not
each compile. The profiles are of the earlier head's pair. sqlite3.c's instruction counts (7940HS, `perf stat -e instructions:u`, not on this host): main 5,079.89M,
final head 5,081.03M (+0.02%); an intermediate form that routed phis in `enqueue_users` ran 5,090.75M (+0.21%) and
took 0.57% longer here, which is why the final form defers at dequeue.
