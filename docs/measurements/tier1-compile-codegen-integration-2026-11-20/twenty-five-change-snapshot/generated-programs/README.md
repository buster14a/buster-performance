# 256 fresh generated C programs

The two snapshot compilers and pinned Clang 23.1.4 compiled identical Csmith and YARPGen inputs, seeds 5140–5267 in each family. Both Buster tiers and both Clang optimization levels ran through the project differential harness. Each source hash, command status and available output hash appears in the [seed-level ledger](observations.tsv). 238 seeds passed both compiler snapshots. The ledger records 0 differences in classification or output among common passes. The [exception ledger](exceptions.tsv) preserves limits and their diagnostic text.

| Generator | Control | Candidate | Seeds |
|---|---|---|---:|
| csmith | clang-o0-run:timeout | clang-o0-run:timeout | 13 |
| csmith | passed | passed | 115 |
| yarpgen | buster-tier0-compile:exit | buster-tier0-compile:exit | 5 |
| yarpgen | passed | passed | 123 |
