## Self-host qualification

PASS: 43 units; 14 smoke commands; 5 probes; 10 byte comparisons; 10 executable runs.

| Phase | Wall seconds |
| --- | ---: |
| Sequential unit compilation | 17.769 |
| Host link | 0.242 |
| Stage 2 smoke | 67.109 |
| Probe compilation, comparison and execution | 1.114 |
| Total | 86.240 |

Stage 1: 178275832 bytes. Stage 2: 127661384 bytes. Per-command time, peak RSS and exit status are in `timings.tsv`.

This is probe-output equivalence, not a full stage-2/stage-3 compiler-binary fixed point or Tier 1 qualification.
