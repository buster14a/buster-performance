# Common-warning checks on SQLite and long calls

The revised warning pass saved a median 0.164 ms of checker time per paired SQLite object compile. Without timing instrumentation, wall time favored the revision in 22 of 41 pairs. Removing a repeated argument-list search had a larger effect on long calls, reducing checker time from 13.270 to 0.783 ms at 8,192 arguments. [Compiler PR](https://github.com/buster14a/buster/pull/3543)

The original report measured 107.0 to 162.4 ms when common warnings first shipped. Three intervening changes had already reduced this regression before the direct comparison below. [Issue #1340](https://github.com/buster14a/buster/issues/1340) · [PR #1488](https://github.com/buster14a/buster/pull/1488) · [PR #1726](https://github.com/buster14a/buster/pull/1726) · [PR #2642](https://github.com/buster14a/buster/pull/2642)

Base `7515714d05caa655e8c2e1e2776e07aa9b8058df`, head `b9251ab3ea4f46234fe38d12d199709c67216c2d`. PR head `2cb41aa14fe23f118287feed84653009dc71a1e3` adds five lines of checker documentation to the measured head. The compiler source and build inputs are identical. Both measured executables are Release builds with Clang 23.1.4, `BUSTER_HOST_ARCH=znver5` and `BUSTER_DEBUG_INFO=0`. For the historical reference the campaign reused the archived pre-#1049 compiler at `aca9e53aa981bb3f61d21cdd5a408ce5167a06f8`. Its SHA-256 matches the [November 6 identity record](../common-warnings-1340-2026-11-06/zen5-9700x/identity.txt). Compiler features and other stages have changed since that revision.

## Frozen SQLite

Each sample ran a fresh process on CPU 2 of the Ryzen 7 9700X under the shared exclusive lock. The workload used the frozen `preprocessor-391e729af658` corpus, including its pinned headers and predefines, the four SQLite definitions and `--lanes 1`. The timing harness rotated the binaries each round. All times below are milliseconds. A paired delta is head minus base within a round.

| Action | Warning flags | Wall, base → head | Checker, base → head | Paired checker delta | Head faster |
|---|---|---:|---:|---:|---:|
| object | default | 113.608 → 113.510 | 23.023 → 22.896 | -0.164 | 25/31 |
| object | `-w` | 101.923 → 101.847 | 11.455 → 11.309 | -0.114 | 20/31 |
| object | `-Wall -Wextra` | 126.529 → 126.135 | 34.310 → 34.040 | -0.270 | 26/31 |
| syntax-only | default | 97.836 → 97.122 | 24.026 → 24.013 | -0.005 | 16/31 |
| syntax-only | `-w` | 85.937 → 85.172 | 12.228 → 12.137 | -0.091 | 27/31 |
| syntax-only | `-Wall -Wextra` | 109.404 → 108.601 | 35.604 → 35.437 | -0.233 | 23/31 |

With stage instrumentation disabled, default object wall time was 113.046 → 112.877 ms over 41 alternating pairs. The median paired difference was -0.113 ms, with head faster in 22 pairs.

The archived compiler took 107.838 ms wall and 10.360 ms in `check-program` in the same default object run. The head's wall time was 5.672 ms above that reference.

The default object compile was also measured in 11 rotated rounds with four user-mode events in one perf invocation. The raw counter logs report 100% running time for each event.

| User-mode event | Pre-#1049 | Base | Head | Median paired delta |
|---|---:|---:|---:|---:|
| instructions | 1,155,655,241 | 1,274,521,809 | 1,262,585,733 | -11,936,071 |
| cycles | 504,045,324 | 546,751,511 | 545,673,976 | -1,673,021 |
| branches | 176,451,744 | 190,325,446 | 188,204,495 | -2,120,950 |
| branch-misses | 3,130,567 | 3,317,539 | 3,297,401 | -19,560 |

## Call argument scaling

The fixture passes small integers to `float` parameters followed by one `16777217`. Only the last conversion changes the value. The original warning walk repeatedly searched for each argument in the same call. The tree path now uses the conversion slot already visited. These are 15 rotating rounds per size, using `-fsyntax-only --time-stages`.

| Arguments | Wall, base → head | Checker, base → head | Head faster in checker pairs |
|---:|---:|---:|---:|
| 256 | 0.791 → 0.763 | 0.133 → 0.113 | 15/15 |
| 1,024 | 1.184 → 0.952 | 0.399 → 0.166 | 15/15 |
| 4,096 | 5.356 → 2.153 | 3.674 → 0.470 | 15/15 |
| 8,192 | 15.982 → 3.484 | 13.270 → 0.783 | 15/15 |

Base and head produced the same warning at each size, including its location, text and ordering. [Input generator](scripts/arity-inputs.sh)

## Correctness

The six SQLite mode/action combinations produced byte-identical output streams between base and head. The object files also matched in each warning mode. The archived compiler's object is recorded separately.

All 1,355 frozen musl translation units compiled successfully with each compiler in four configurations, object and syntax-only with default warnings and `-Wall -Wextra`. Each pair matched in exit status, stdout, stderr and, for object mode, object bytes. The compressed TSVs give the result and hashes for every source. The checker passed 833,442 checks at seed 133. All 16 checker-driver shards passed 243,237 checks. The sign-comparison and uninitialized-only suites passed 828 and 710 checks respectively. The mixed-call fixture exercises distinct argument targets, an integer argument and a variadic argument. Clang 23.1.4, base and head emitted the same 28 primary diagnostic lines in the same order. [Validation receipts](validation)

## Reproduction and data

1. Extract the Buster base and head with `git archive`. The head archive's embedded commit ID was compared with the requested commit on the host before building. The build transcripts, Git IDs, binary hashes, source patch hash, SQLite hash and harness hashes are in the [qualified receipts](raw/qualified.tar.gz).
2. Build each revision under the machine lock using the Release settings above. Place the two executables at `base` and `head`, with the head source in `src` and the revision IDs in `base.commit` and `head.commit`. Save `git diff --binary BASE HEAD` as `head.patch`. The harness reads the frozen corpus and the historical compiler from the host paths in the [measurement script](scripts/measure.sh).
3. Run `bash measure.sh timing` and `bash measure.sh counters`. Generate the call inputs using `bash arity-inputs.sh`, then run `bash arity.sh`. Each invocation acquires a separate hold. [Scripts](scripts)
4. The qualified archive contains one row per process in each `time.tsv`, with its individual stage or perf log. [Medians and paired deltas](summary.tsv)

The [exploratory receipts](raw/experiments.tar.gz) retain the first batched-comparison build (`initial.tgz`), a dropped-range/token-screen variant (`1340-trial2.tgz`), the argument-slot fix in isolation (`1340-edge.tgz`), and the subsequent branch-truth and operator-screen experiments. The dropped-range variant showed no default SQLite gain. A later CFG and strided conversion-target experiment slowed the default checker in 23 of 25 pairs, then in 29 of 31 pairs on an independent build. Both experiments were discarded. The tables above use the fresh build of the identified head.

The base cycle profile sampled 25 default object compilations. Its largest warning functions by self samples were `check_input_warning_graph` (1.75%), `check_common_graph_warnings` (1.44%) and `check_driver_common_warnings` (1.41%). `check_common_emit_run` accounted for 0.19%. Inlined work is charged to the containing symbol. The profile and its script are included in the exploratory receipts and scripts directory.
