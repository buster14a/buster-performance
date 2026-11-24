# Replaying the SQLite checker comparisons for Buster #2037

Three bounded comparisons from Benchpress exercise the first-party paired verdict reader. Each invocation timed the same three relative checker offsets for the base, candidate and another copy of the base. Three copies at each offset ran for three measured rounds in Williams order. The independent-unit count is **three per invocation**. The three invocations revisited the same layouts.

| Session | Candidate wall effect | Candidate interval | A/A interval | Verdict at 1% |
| --- | ---: | ---: | ---: | --- |
| 1 | −0.303% | −0.644% to +0.039% | −0.259% to +0.509% | Pass |
| 2 | −0.419% | −1.150% to +0.318% | −0.864% to +0.455% | Pass |
| 3 | −0.404% | −1.319% to +0.519% | −1.109% to +1.027% | Inconclusive |

**A/A produced zero regression alerts in three comparisons.** Two controls stayed within the symmetric practical budget. The third crossed it, so its candidate comparison is inconclusive. These runs share source, hardware, layouts and session conditions. They give little information about rare false alerts or other workloads. The 1% budget is retrospective here. This replay provides no production baseline.

## Provenance and replay

The original log, recipes, machine receipt and binary hashes are in [the archived #892 measurement](https://github.com/buster14a/buster-performance/tree/99fafe600aef55173f54158bfc11c652c9903887/docs/measurements/branch-free-sites-892-2026-11-13). The original command used the pinned preprocessor corpus on CPU 2 under the Benchpress lock. The base is a commit and the candidate is the original working tree's Git tree. The original receipt identifies Release, optimization and target flags. It lacks the exact Clang version. Each imported manifest preserves this limitation.

Each observations file is a contiguous byte range in the original `results/abtr-p1/ab.txt`. The manifest records the log digest, commit, byte offset and length. The recorded timestamp is the corresponding native lock receipt. The recipe, harness and host IDs hash `scripts/placements.sh`, `scripts/abtr.sh` and `results/main/host.txt` respectively. The toolchain ID hashes the UTF-8 toolchain description in the manifest without a trailing newline. The corpus ID is the original frozen manifest digest. Each report includes the unit medians in milliseconds, paired log effects and the control outcome. Wall time is primary. User time is diagnostic.

From the Buster checkout containing the #2037 reader, set `evidence` to this directory and run:

```sh
bash tools/performance/build.sh
for n in 1 2 3; do
    build/performance/paired report "$evidence/plan.json" "$evidence/session-$n/manifest.bmf.json" |
        cmp - "$evidence/session-$n/report.json"
done
```
