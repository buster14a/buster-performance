# Track counted pointer members on main

Clean main revision `85acac5ade4aca97a68fac6aa2624cfee6afcf3b` applies the first-counted-pointer declaration fact to `40ae34f9d77afc42face58eff3338b7b1d1ba469`. The checker tests a type-table field before inspecting counted reads and assignments. Type copies preserve the index and speculative rollback clears it precisely when the first declaration was withdrawn. [Production change and synthetic tests](implementation.patch) and [both optimized compiler identities](builds.tsv).

188 ordinary process observations recorded 0 parent/candidate differences across frozen SQLite and Buster, parsed counted attributes, negative diagnostics and graph dumps. [Outputs and ELF hashes](oracle/comparisons.tsv), [Clang diagnostics](oracle/clang.tsv) and [all directed programs and raw streams](oracle/raw.tar.gz).

| Input | Scope | Paired wall | Faster wall rounds | Paired instructions | Paired cycles | Faster counter rounds |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| sqlite | ordinary | +0.108 ms | 1/5 | +951,046 | -1,376,342 | 2/3 |
| main | ordinary | +7.470 ms | 1/5 | +4,679,661 | -1,495,090 | 2/3 |

Paired local Ryzen 9 7940HS trials used exact Develop builds of the parent and candidate under the same flags. Five alternating ABBA/BAAB wall rounds and three counter rounds emitted the identical frozen native ELF. [Paired results](stage/paired.tsv), [raw observations and ELF hashes](stage/samples.tsv) and [counter streams](stage/raw.tar.gz).

Regression suite exit statuses include 0 failing commands out of 9. [Suite statuses](suites/status.tsv) and [complete suite output](suites/raw.tar.gz).

Across 4,116 SQLite, Buster, Lua and musl file/policy combinations, 0 parent-versus-candidate native status, diagnostic or ELF comparisons differed. [Corpus tables and streams](per-file/raw.tar.gz).

The debugger observed the production declaration fact on parsed counted-pointer input. With the recorded member the ordinary compiler issued 4 read and 1 assignment errors. Zeroing only the declaration fact before the checker ran yielded 0 read and 0 assignment errors. [Guarded diagnostic outcomes](mutation/results.tsv) and [sources, layouts and debugger traces](mutation/raw.tar.gz).

The per-source Clang check found matching ordered diagnostic locations and severities in 22 of 22 comparisons. Exact messages are recorded separately. [Clang event comparisons](oracle/clang-locations.tsv).
