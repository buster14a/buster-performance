## Self-host qualification

PASS: 43 units; 14 smoke commands; 5 probes; 10 byte comparisons; 10 executable runs.

| Phase | Wall seconds |
| --- | ---: |
| Sequential unit compilation | 18.525 |
| Host link | 0.222 |
| Stage 2 smoke | 55.222 |
| Probe compilation, comparison and execution | 1.052 |
| Total | 75.026 |

Stage 1: 183113432 bytes. Stage 2: 105179064 bytes. Per-command time, peak RSS and exit status are in `timings.tsv`.

This is probe-output equivalence, not a full stage-2/stage-3 compiler-binary fixed point or Tier 1 qualification.
