# #2924 C12c-4 (d): the source rows and the units' lanes keep their vector paths alone

PR [#3489](https://github.com/buster14a/buster/pull/3489).

**Timing:** `time.sh` ran `benchmark-check-debug` three times on main's Release build (piece (a)'s base, whose changes
are tests only). Each run was one locked run on CPU 2 (`logs/check-debug-*.log`). The vector path wins every pass in
every round:

| Pass | Vector | Exact |
| --- | --- | --- |
| rows (ns an entry) | 0.309 to 0.318 | 0.332 to 0.346 |
| lines (ns a raw row) | 8.27 to 8.42 | 30.00 to 30.19 |
| keep (ns a raw row) | 0.348 to 0.364 | 0.543 to 0.548 |
| build (ns a raw row) | 35.4 to 36.2 | 57.6 to 58.5 |

By rule 3, check-debug's `exact` goes. The units' merge and link-check lanes change nothing by default: only
`--scalar` forced them to one lane.

**Local checks** (`local/`): the 32 blocks of `tools/ci/correctness.tests` naming test-check-debug, test-check-units,
test-check-lanes, test-checker, test-checker-driver, test-debug and test-lanes. All passed.

**Review fixes** (51cc646db): the kept-rows test compares each kept row's offset, file and line with the row
keeping's definition gives. `mutation/run.sh` mutates the vector path's stores on blocks after the first; all three
are killed (`mutation/results.txt`: lines +1, 178 failures; offsets +0x10000000, 227; keys +1, 178).

**Sanitizers** (`local/sanitizers.txt`): UBSan, ASan and MSan builds of 51cc646db, each running test-checker's 8
parts, test-check-debug, test-check-units and test-check-lanes: 33 of 33 passed.
