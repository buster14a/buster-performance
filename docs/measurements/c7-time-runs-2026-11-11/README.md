# C7 base-vs-head time-runs on the 9700X (2026-11-11)

Whole-process `time-runs` (11 runs per build, Williams order, warm-up included)
of Buster PRs from the C7 package of #1447, on `benchpress` (Ryzen 7 9700X),
each configuration under `~/buster-fast-bench/exclusive.sh` (`time.sh`,
pinned by the tool), Release builds with `BUSTER_DEBUG_INFO=0`. Input: the
frontend baseline's `sqlite3.c`. Each file ends with the base and head commits.

| Run | PR | base → head | `-fsyntax-only` | `-fsyntax-only -Wall` | `-c -o /dev/null` |
|---|---|---|---|---|---|
| `1953-c7.txt` | buster#2228 (-Wunsequenced) | d43c37e5 → 89da741a | 94.98 → 100.10 ms (+5.40%) | 113.45 → 118.24 ms (+4.22%) | 106.32 → 111.20 ms (+4.59%) |
| `1953-c7-prefilter-v1.txt` | buster#2228, tree-walk prefilter | 7535f243 → 2e693c9c | 96.36 → 99.94 ms (+3.72%) | 114.77 → 118.43 ms (+3.19%) | 107.43 → 111.79 ms (+4.06%) |
| `1953-c7-prefilter-v2.txt` | buster#2228, node-range name prefilter | 7be0864f → 7e24ead3 | 97.28 → 99.33 ms (+2.11%) | 116.08 → 117.90 ms (+1.56%) | 108.87 → 110.94 ms (+1.90%) |
| `1953-c7-prefilter-v3.txt` | buster#2228, cheaper range start, mark before reach | 7be0864f → 204f4e9c | 96.99 → 98.67 ms (+1.73%) | 115.14 → 116.55 ms (+1.22%) | 108.44 → 109.66 ms (+1.12%) |
| `1447-c7-enum.txt` | buster#2318 (enum-cast gate) | eefd3df7 → 7200f606 | 96.09 → 96.50 ms (+0.43%) | 114.29 → 114.60 ms (+0.27%) | 107.78 → 107.13 ms (−0.61%) |
| `1447-c7-uneval.txt` | buster#2323 (constant-reader sizeof) | 2d0756cf → e9690f33 | 96.38 → 95.89 ms (−0.51%) | 114.67 → 114.21 ms (−0.41%) | 106.89 → 107.18 ms (+0.27%) |

Medians of wall time; each file has every run's wall, rusage, cycles and
instructions, and the cycles' comparison. `-c` instructions: #2228
1,267.5M → 1,327.0M (+4.7%), #2318 1,279.15M → 1,280.99M (+0.14%), #2323
1,279.35M → 1,279.63M (+0.02%).

buster#2228's follow-ups (`rebuild.sh` builds base and head, then runs
`time.sh`): `-fsyntax-only` instructions 997.4M → 1,044.6M (+47.2M) at v1,
1,006.7M → 1,032.6M (+25.9M) at v2 and 1,006.7M → 1,026.7M (+19.9M) at v3;
`perf record -e instructions:u` put the original cost in `check_unseq_check`
(the SequenceChecker walk of nearly every statement).
