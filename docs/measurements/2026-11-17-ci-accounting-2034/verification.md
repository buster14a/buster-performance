# Independent raw interval reconciliation

PASS: raw job endpoint differences agree with every per-run resource total, every complete class/cohort phase total, completion proxy, occupied-wall union, outside-execution gap, unallocated count, and hosted overlap peak in summary.md.

Independent raw endpoint differences and interval unions; no production C/jq accounting functions imported.

Per-phase label semantics remain the declared heuristic. This audit proves execution and phase conservation, completion/wall decomposition, counts, concurrency, and agreement with individually reviewed raw feedback step endpoints, not a causal before/after effect. Most first-feedback endpoints here are early CI glue fixture checks, not completion of the compiler test suite.

| Run | Cohort | Outcome | Raw / allocated jobs | Execution (s) | Hosted (s) | Step union (s) | Uncovered (s) | Feedback (s) | Completion proxy (s) | Hosted peak |
| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| [43918005798](https://github.com/buster14a/buster/actions/runs/43918005798) | before | failure | 2 / 2 | 777 | 777 | 772 | 5 | 10 | 782 | 1 |
| [43964063203](https://github.com/buster14a/buster/actions/runs/43964063203) | before | cancelled | 17 / 7 | 181 | 181 | 164 | 17 | 27 | 95 | 4 |
| [43964225841](https://github.com/buster14a/buster/actions/runs/43964225841) | before | success | 54 / 26 | 4410 | 4410 | 4321 | 89 | 73 | 880 | 15 |
| [43968796098](https://github.com/buster14a/buster/actions/runs/43968796098) | before | success | 158 / 91 | 38137 | 38137 | 37824 | 313 | 18 | 1762 | 61 |
| [43982345178](https://github.com/buster14a/buster/actions/runs/43982345178) | before | success | 158 / 88 | 42000 | 42000 | 41704 | 296 | 23 | 2730 | 60 |
| [43984672220](https://github.com/buster14a/buster/actions/runs/43984672220) | after | success | 2 / 2 | 1933 | 1933 | 1925 | 8 | 12 | 1924 | 2 |
| [43987166748](https://github.com/buster14a/buster/actions/runs/43987166748) | after | success | 159 / 93 | 38728 | 38728 | 38428 | 300 | 21 | 1552 | 62 |
| [43994599478](https://github.com/buster14a/buster/actions/runs/43994599478) | after | success | 54 / 26 | 4379 | 4379 | 4292 | 87 | 35 | 845 | 14 |
| [44022415745](https://github.com/buster14a/buster/actions/runs/44022415745) | after | cancelled | 54 / 25 | 3408 | 3408 | 3330 | 78 | 33 | 590 | 14 |
| [44023518517](https://github.com/buster14a/buster/actions/runs/44023518517) | after | success | 54 / 26 | 4531 | 4531 | 4455 | 76 | 75 | 946 | 14 |
| [44032126732](https://github.com/buster14a/buster/actions/runs/44032126732) | after | failure | 11 / 6 | 312 | 69 | 290 | 22 | 35 | 280 | 4 |
| [44043517475](https://github.com/buster14a/buster/actions/runs/44043517475) | after | success | 158 / 91 | 38027 | 38027 | 37722 | 305 | 19 | 1707 | 61 |

Totals: 12 runs; 881 raw jobs; 483 allocated jobs; 176823 execution seconds; 176580 hosted execution seconds. Cross-run hosted peak: 64. All allocated execution intervals in this selected sample are known; unread CPU models and lock logs remain unknown.

Skipped/unallocated jobs with zero or null runner identifiers are excluded from consumed execution; their timestamps are not treated as occupied intervals. Run updated_at is never used as a completion endpoint. The JSON companion retains per-job arithmetic and exact raw step/job endpoints supporting the feedback numbers.
