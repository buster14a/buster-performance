## Self-host qualification

PASS: 43 units; 14 smoke commands; 5 probes; 10 byte comparisons; 10 executable runs.

| Phase | Wall seconds |
| --- | ---: |
| Sequential unit compilation | 17.901 |
| Host link | 0.221 |
| Stage 2 smoke | 56.726 |
| Probe compilation, comparison and execution | 1.094 |
| Total | 75.960 |

Stage 1: 182223736 bytes. Stage 2: 106302000 bytes. Per-command time, peak RSS and exit status are in `timings.tsv`.

This is probe-output equivalence, not a full stage-2/stage-3 compiler-binary fixed point or Tier 1 qualification.
