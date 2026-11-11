# #1447 package C2: segment address spaces, base vs head on the 9700X (2026-11-11)

Raw evidence for buster14a/buster PRs #2106, #2118, #2123 and the attempted follow-up of #2278. Host: benchpress, the
Ryzen 7 9700X, CPU 2 pinned, governor performance, clang 23.1.1 (receipt.txt). Every build and run took the shared
lock (`~/buster-fast-bench/exclusive.sh`).

Trees (receipt.txt, COMMIT files): base1 `d43c37e5` (base of #2106 and #2118), pr2106 `1aff3051`, pr2118 `ddae5c3b`,
base3 `2f18cac0` (base of #2123), pr2123 `917d164d`; for #2278's attempt, base4 `66e05fbfba750aad1639887e87c38f89fdc9de79` and gate `d0c1ee08`
(branch claude/segment-arrow-lookup-gate). Release builds (`BUSTER_DEBUG_INFO=0 ./build.sh`).

Workload: `-c` of the 9700X corpus's sqlite3.c (preprocessor-391e729af658) and of base1's own main.c, the same
input for every build; flags in all.sh / perf.sh.

- objects.sha256, compile.log: every build's objects are byte-identical (sqlite3.o `5c6e1e7b…`, main.o `805d3ce5…`).
- perf.tsv (perf.sh): user instructions, cycles and task-clock, 3 interleaved rounds in one lock hold.
- gate-perf.tsv, gate-objects.sha256 (gate.sh, gate-perf.sh): the same for base4 and gate.
- run.log: all.sh's log. Its `ab --rounds 15` was abandoned after round 1: every run queued for the lock behind other
  sessions, so 15 rounds would have taken hours.

Results: #2118 and #2123 are within noise of their bases (instructions −0.0006% and +0.021% on sqlite3.c). #2106 adds
+0.224% instructions on sqlite3.c and +0.055% on main.c (cycles within noise); the gate attempt gives −0.098% on
sqlite3.c and +0.026% on main.c against base4, so it was not proposed (#2278).
