### the instrumented executable against the unpatched one (sqlite3.c)

| configuration | runs | wall ms (range) | user cycles, M | against the first | user instructions, M | kernel cycles, M | peak MB |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| src-tier1 | 7 | 426.2* (425.4 to 426.6) | 2,258.9 | +0.00% | 5,278.7 | 98.2 |  |
| inst-tier1 | 7 | 425.8* (424.6 to 427.0) | 2,261.0 | +0.10% | 5,278.0 | 97.7 |  |
| inst-default | 7 | 123.3* (122.9 to 123.4) | 600.3 | -73.43% | 1,347.6 | 82.4 |  |
| inst-laps | 7 | 439.2* (438.4 to 470.1) | 2,314.5 | +2.46% | 5,551.2 | 117.1 |  |
| src-default | 7 | 123.1* (122.8 to 123.8) | 599.3 | -73.47% | 1,347.5 | 83.2 |  |

\* The task clock: these runs' wall times weren't read.

