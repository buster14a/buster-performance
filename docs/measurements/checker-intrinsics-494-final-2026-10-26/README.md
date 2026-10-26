# Final-head SQLite check for the bounded intrinsic fallback

2026-10-26, [buster #494](https://github.com/buster14a/buster/issues/494) and [PR #506](https://github.com/buster14a/buster/pull/506). Baseline `7e3782ada38379f972f244a5f6b89ed0b2d4ed4a`; candidate `de060e85103b907c0d5f27dc2e5f93cfaae727cc`. AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, Clang 23.1.1, perf 7.2.9-1; both `BUSTER_DEBUG_INFO=0 ./build.sh`. Source, predefines and binary hashes are in `sha256.txt`. The command, frozen SQLite corpus, options, pinned CPU 2 and individual shared lock are the same as [the earlier six-pair campaign](../checker-intrinsics-494-2026-10-26/README.md). The follow-up [cache-clear study](../checker-intrinsics-494-review-2026-10-26/README.md) applies to the earlier `5535b291` head.

One baseline/candidate pair completed, with other host work between them. Each run succeeded with empty standard output. `*.stat` contains raw perf CSV; `*.elapsed` contains lock wait messages followed by bash elapsed time, including perf startup. A second baseline started, but its candidate was still waiting behind other CI jobs when the campaign was stopped; it is excluded. This single pair is a final-head sanity check, not statistical evidence for elapsed-time or general speedup claims.

| | Baseline | Candidate |
|---|---:|---:|
| User instructions | 1,690,248,160 | 1,623,295,499 |
| Task-clock | 150.19 ms | 143.43 ms |
| Elapsed including perf | 202 ms | 148 ms |

The candidate retired 3.96% fewer user instructions in this pair. The elapsed and task-clock differences cannot establish a repeatable improvement from one observation. The final change replaces the exceptional zero-scratch quadratic earlier-token search with a linear operand scan and batched catalog searches; the usual cached path still deduplicates names. On the 9700X `test-checker --seed 133` passed 253,700 checks. The new 100,000-distinct-name no-scratch fixture asserts a two CPU-second upper bound for both paths and checks a deferred/final hit. On the 7940HS laptop, the same fixture failed the bound in both paths with the preceding quadratic implementation and passed with the final implementation.
