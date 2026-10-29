# After merging main, Buster #759

This follow-up to [the record](../README.md) measures
[buster#759](https://github.com/buster14a/buster/pull/759)'s head after the branch merged main, and keeps the
mutation check of the test that the PR's review asked for.

## Sources

Each measured tree is a `git archive` of its commit, extracted on the 9700X with a `COMMIT` file that names it:

- **m759, the base:** `397329903fc87176957f5de5a2b0d3a40803c489`, main, the merge-base of the branch's head and
  main;
- **h759, the head:** `d9a474cf837d615a6f6d5ad4cea810dcf460982b`, the branch's head. Its parent `047f1d42` merged
  main (`39732990`) into the branch, and `d9a474cf` adds the review's test.

`manifests/` has each commit's file manifest (the SHA-256 of every file of its `git archive`, sorted by path), and
`compare.txt` the comparison with the trees on the 9700X: the same files and bytes but for each tree's `build.log`,
the build's transcript (and `build/` and `COMMIT`, which the comparison leaves out).

## Method

As the record's: `scripts/queue-759.sh` built each tree (`scripts/build-tree.sh`, `BUSTER_DEBUG_INFO=0
./build.sh`) and then ran `scripts/measure.sh`, each in a hold of the host's lock of its own. The command is the
9700X job's `-c` of the frozen `sqlite3.c`, pinned to CPU 2. `measure.log` is the measurement's whole transcript:
the receipts (the date, `uname -a`, the CPU, CPU 2's governor, clang's and perf's versions, the lock's owner line,
the trees' commits, and the SHA-256 of both executables and of `sqlite3.c`), a drive check of each tree, and 8 rounds
in which each tree, in an order alternated by round, runs 3 times under `perf stat`, each run's exit status beside
its counters. `analysis.txt` is `scripts/analyze.py`'s output. The lock's waiting messages went to separate files,
which this record leaves out: they name other jobs.

## Results

Both trees exit 0 on the drive check and write byte-identical objects (SHA-256 `9048dda4…`, the object before the
merge). All 48 timed runs exit 0. The medians of the rounds' means, and the per-round ratios' median and range:

| | m759 | h759 | h759 against m759 |
|---|---:|---:|---:|
| instructions | 1,246,587,157 | 1,246,594,959 | +7,802 (+0.0006%) |
| cycles | 577.82 M | 576.96 M | −0.20% (−0.62% to +0.22%) |
| task clock | 122.63 ms | 122.43 ms | −0.19% (−0.79% to +0.62%) |

Each tree's instructions vary by at most 152 within a round. The cycles' and the task clock's per-round ratios
straddle zero: the measurement shows no cost of the branch on the default path.

## The review's test: cvtps2dq under MXCSR's rounding modes

The review asked for `cvtps2dq` to be tested under a rounding mode other than the default. `d9a474cf` adds to
`test-checker`'s `x86-sse` program a block that reads MXCSR, sets each of its four rounding modes with `ldmxcsr`
around `cvtps2dq`, and restores MXCSR after each. Its values are {1.75, −1.25, 2.5, −2.5}, which clang's code
converts to a different vector in each mode ({2, −1, 2, −2}, {1, −2, 2, −3}, {2, −1, 3, −2} and {1, −1, 2, −2}),
with the halfway vector and the random one.

`scripts/mutants.sh` built two trees locally (`mxcsr-mutants/results.txt` has the host's receipts, the builds and
the runs), each from the branch's head with LDMXCSR_M32's ModRM extension /2 made /3
(`mxcsr-mutants/ldmxcsr-as-stmxcsr.diff`): our code's `ldmxcsr` then stores MXCSR rather than loading it, so every
conversion runs in the default mode, as a lowering that ignored MXCSR's mode would. Then `test-checker
--program-vectors`:

- **new**, with the review's test: status 1, 2 failures, both `x86-sse`'s, one per path (at n = −3, ours
  −651836715 against clang's −800640171);
- **old**, with `c_check_program_x86_test.c` of `047f1d42`, before the test: status 0, 0 failures.

`--program-vectors` runs the vector and x86 builtin programs alone: the mutant was not run against the rest of the
suite.
