# Twenty-seven compiler PRs together

Main `a8604029966a07c5ebcc16aaf24c73b80a13695e` and local integration `407f2b9ec71ee0c5fcd46a7e60de47a131950347` were built for the Zen 5 host. Every public PR revision is pinned in the [27-head manifest](heads.tsv). The [source patch](combined.patch.gz) applies cleanly to the recorded main. The integration retains every fixture invocation and all calibrated rows at shared insertion points.

## Whole compiler throughput

The Ryzen 9 7940HS compiled the same sources with one internal lane. Each number is the median of eight within-pair changes after warm-up. The [90 processes](processes.tsv) include counter values, level, variant, object hash, time and machine load.

| Workload | Instructions | User cycles | Cycle range, % |
|---|---:|---:|---:|
| lua-lparser | -6.139% | -4.914% | -17.25,+4.46 |
| lua-lvm | -37.683% | -25.775% | -32.32,-23.68 |
| sqlite-O0 | -21.535% | -16.096% | -17.33,-11.98 |
| sqlite-O2 | -21.533% | -12.926% | -19.08,-6.71 |
| sqlite-tier1 | -2.350% | -1.085% | -5.23,+6.44 |

Six [compiler profiles](profiles/) cover debug and release SQLite, the Lua parser and the Lua VM. The [harness](harness/) records their sample commands.

## Code size and correctness

Both compilers reproduced all 43 of their own stage-two objects and the linked executable at stage three. The [88 comparisons](fixedpoints.tsv) give per-artifact hashes. When compiling identical main source, 807 of 10,476 matched functions shrank and 2 grew. Across the 43 object files, text decreased by 68,558 bytes. The resulting linked compiler used 68,976 fewer text bytes and 69,712 fewer file bytes. [Function sizes](selfhost-function-changes.tsv) and [ELF totals](selfhost-totals.tsv).

All 220 C tests and all 430 functions passed through Tier 1. Its non-enforced code-size comparison remains above Clang on the 380 matched functions, 62,298 versus 45,748 bytes. The combined debug, emitter, pipeline, selection, inliner and self-host checks passed. During the main-side stage-three build the host-busy heuristic affected an arena smoke test. The initial transcript is preserved. Repeating the full stage with the repository’s deterministic test setting passed and reproduced the same compiler binary. [Suite receipts](suites/).
