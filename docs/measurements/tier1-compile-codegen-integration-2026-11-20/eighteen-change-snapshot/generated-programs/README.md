# Differential compilation of 256 fresh programs

The official differential runner tested both Buster tiers against pinned Clang 23.1.4 at -O0 and -O2. The baseline and eighteen-change compiler received identical generated sources. The [seed-level ledger](observations.tsv) checks the source hashes and records both sides of each command. All 256 classifications matched. For passing seeds the two snapshots and references also produced the same output per the harness.

Csmith passed on 119 of 128 seeds per compiler. Nine seeds exceeded the 15-second Clang -O0 runtime limit on both sides. YARPGen passed on 126 of 128 per compiler. Both remaining seeds used calls with more than 239 arguments, which both Buster versions rejected at Tier 0. The [shared limitations](limits.tsv) and the four independent campaign summaries preserve these outcomes. In all, 245 fresh programs passed both Buster compilers and eleven seeds did not qualify.
