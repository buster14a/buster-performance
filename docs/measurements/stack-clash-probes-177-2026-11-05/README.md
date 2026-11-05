# -fstack-clash-protection (#177, buster#1434)

The 9700X's record of buster14a/buster#1434, merged as `455786e9`: both tiers' frames and dynamic allocations probe the
stack a page at a time under `-fstack-clash-protection`, with the review's fix (`903c464e`) by which a frame with a
frame pointer probes its reservation whatever its size, so that an allocation after a fixed frame under a page starts
from a touched rsp.

- **Host:** benchpress (Ryzen 7 9700X, Arch Linux, clang 23.1.1), every step one hold of
  `~/buster-fast-bench/exclusive.sh`, timed runs pinned to CPU 2 (`taskset -c 2`). The compilers are built
  `BUSTER_HOST_ARCH=znver5` for the measurement (`probes177.sh`) and `native` for the review fix's checks
  (`fix177.sh`): both the vector path (full AVX-512).
- **Commits:** head `903c464e4c53708ea84cbaa699655d38d2916f5b` (#1434's last), base main
  `e7d3fc79e7528f987280b5b12b0e72fb65b8351a` (its first parent's merge). Pre-fix build for the demonstration:
  `42ad48b6a450eb78bb03538a464365dfe54150ca`.
- **Inputs:** `out/inputs.txt` (SHA-256 of `sqlite3.c`, `speedtest1-unity.c` and `speedtest1.c`); Lua 5.4.8 and its five
  scripts as in `tier1-frames-177-2026-11-05`.
- **Scripts:** `probes177.sh 903c464e e7d3fc79 e7d3fc79` (identity, builds, checks, timing), `fix177.sh` (the review
  fix on the vector path).

## Default output

`-c sqlite3.c` by Tier 0 and by `--tier1`, head against main `e7d3fc79`: the same bytes at both tiers, by the
`znver5` builds (`out/identity.txt`) and by the `native` ones (`out/fix-results.txt`). Every probe is behind the
option.

## The review's fix on the vector path (`out/fix-results.txt`)

- `test-checker-driver --part 11/64` (the stack-clash fixture), fixed compiler: 611 checks, 0 failures.
- The same test binary with `--executable` the pre-fix compiler (`42ad48b6`): 12 failures, each "an allocation after a
  fixed frame under a page faults on the guard page, as clang's": the tail fixture's twelve builds (Tier 0 and
  `--tier1` with and without rematerialization, each path, with a frame pointer and without) step over the guard.
- `test-tier0 --cross-check` 8,734,790 checks, 0 failed; `test-emitted-code --cross-check`, `test-tier1-frame`,
  `test-tier1-frame-execution`, `test-tier1-cfg` and `test-unwind` pass.

## The option's cost

Builds by head: t0 (Tier 0), t0p (Tier 0 `-fstack-clash-protection`), t1 (`--tier1
-fno-asynchronous-unwind-tables`), t1p (t1's and `-fstack-clash-protection`), and clang -O2 with and without the
option. speedtest1's `--verify` hash is the same for all
six (`out/speedtest1-verify.txt`), and each Lua script prints clang -O0's output by each (30 of 30,
`out/lua-compare.txt`). `time-runs`: 11 rounds after a warm-up, the builds rotating; speedtest1 from a fresh database
each run; Lua's five scripts, three copies each.

**speedtest1** (medians, `out/speedtest1-time-runs.txt`):

| Build | Wall | User cycles | Instructions |
| --- | ---: | ---: | ---: |
| t0 | 256.442 ms | 1,322.7M | 5,687.872M |
| t0p | 256.280 ms (−0.06%) | 1,321.4M | 5,687.873M |
| t1 | 200.461 ms | 1,013.8M | 3,686.412M |
| t1p | 201.947 ms (+0.74%) | 1,023.3M (+0.94%) | 3,686.412M |
| clang -O2 | 130.952 ms | 632.5M | 2,012.141M |
| clang -O2, the option | 131.653 ms (+0.54%) | 636.2M | 2,012.165M |

t1p's instructions are t1's to 1 in 10^6, and its cycles 0.94% more: the code's placement, not the probes' work.

**Lua** (the mean of the three copies' medians per script, `out/lua-time-runs-medians.txt`):

| Script | t0 → t0p | t1 → t1p | clang -O2 → the option |
| --- | ---: | ---: | ---: |
| `calls.lua` | 34.88 → 34.91 ms (+0.10%) | 31.20 → 30.95 ms (−0.82%) | 18.17 → 18.19 ms (+0.12%) |
| `tables.lua` | 66.63 → 66.47 ms (−0.24%) | 49.83 → 49.60 ms (−0.45%) | 32.88 → 33.28 ms (+1.20%) |
| `strings.lua` | 63.20 → 63.22 ms (+0.03%) | 52.32 → 51.60 ms (−1.38%) | 36.20 → 35.81 ms (−1.09%) |
| `arithmetic.lua` | 71.92 → 72.00 ms (+0.12%) | 56.52 → 56.52 ms (−0.01%) | 32.00 → 31.99 ms (−0.05%) |
| `closures.lua` | 96.92 → 101.37 ms (+4.59%) | 70.86 → 72.12 ms (+1.78%) | 45.64 → 45.93 ms (+0.63%) |
| All five | 333.55 → 337.98 ms (+1.33%) | 260.73 → 260.79 ms (+0.02%) | 164.91 → 165.20 ms (+0.18%) |

The cost is `closures.lua`'s: +4.59% by Tier 0 and +1.78% by Tier 1, against clang -O2's +0.63%. Across the five
scripts, Tier 0's instructions grow 0.15%, Tier 1's 0.05% and clang -O2's 0.006%. Every frame with a frame pointer now touches its reservation's bottom
whatever its size: one read-modify-write of a fresh stack line per call of such a function. Its cause in
`closures.lua` isn't profiled here. A load would probe a PROT_NONE page as well and is cheaper; whether the kernels'
stack growth takes a read as a write does is to be checked first.
