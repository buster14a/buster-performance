# Frame-object addresses in their users' memory operands (buster#982), 2026-11-01

Evidence for [buster#982](https://github.com/buster14a/buster/issues/982), implemented by
[buster#996](https://github.com/buster14a/buster/pull/996): a load, store or address whose walk reaches a frame
object's `IR_STACK_ADDR` takes the frame's base register in its memory operand, with the object's offset plus the
walked displacement, which the CFG consumer fills in at emission. It completes #982's remaining Done-when item, the
9700X run time and instruction counts of speedtest1's `--tier1` build against the head before. By OpenCode
(deepseek-v4.1-flash), at David's request.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `bad4a76a8c7709a95989881cef28666441949303` | main with buster#977's selection walks, the parent of #996's first commit |
| head | `083a247e5ab98a5ffa3446fef7795e82fa0ce371` | #996's two commits: the frame object's address folded into its users (`d83504ed`), then the entry-block preheader case and the single-candidate tie fix (`083a247e`) |

Both trees are `git archive`s of those commits, built on the 9700X with `BUSTER_DEBUG_INFO=0 ./build.sh`. Their
compiler binaries and the frozen inputs' hashes are in `identities.txt`.

## Commands

Every build, test and timing run held the 9700X's shared lock once, with the timed runs pinned to CPU 2. The harnesses
are `run982.sh` (the speedtest1 builds, the 21 rounds and `perf stat`) and `test982.sh` (the suites); the six builds use
the frozen `sqlite3.c` and SQLite 3.53.2's `test/speedtest1.c` through `speedtest1-unity.c`, with #136's flags and
options:

```sh
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
compiler $FLAGS -I$Q -o st-t0 speedtest1-unity.c -lm
compiler --tier1 --tier1-report -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1 speedtest1-unity.c -lm
compiler --tier1 --tier1-report --scalar -fno-asynchronous-unwind-tables $FLAGS -I$Q -o st-t1s speedtest1-unity.c -lm
```

Each build is named `t0-base`, `t1-base`, `t1s-base`, `t0-head`, `t1-head` and `t1s-head`. Each run uses a fresh
database on tmpfs; 21 rounds rotate the six builds. `perf stat -e instructions:u,cycles:u,task-clock` then measures
five rounds of `t0-base`, `t1-base`, `t0-head` and `t1-head` in a rotating order. The scripts leave out the lock's
waiting messages.

## Correctness

| Check | Result |
| --- | --- |
| `test-tier1-select`, head | 329,706 checks, 0 failures (`test-tier1-select.log`) |
| `test-tier1-emit`, head | 199,637 checks, 0 failures (`test-tier1-emit.log`) |
| `test-tier1-pipeline --cross-check`, head | 6,463 checks, 0 failures; 960 of them clang's (`test-tier1-pipeline.log`) |
| c-testsuite's 220-program subset by `--tier1`, both paths, head | 220 of 220 passed; Tier 1 compiled 350 of their 430 functions (`test-c-testsuite.log`) |
| speedtest1 `--verify`, every build | `34221272 cc784acae6e8154e2d9fba03dd8cb9ac7ae8f309abebbfd4` (`verify-*.txt`) |

## speedtest1

Wall time is the median of 21 rounds, in microseconds; the range is the fastest and slowest round. Each build's 21
runs print the same `--verify` output apart from its own total time.

| Build | base | head |
| --- | ---: | ---: |
| Tier 0 | 256,767 (255,770–257,692) | 257,884 (257,400–259,411) |
| `--tier1` | 227,392 (226,678–228,677) | 227,327 (226,288–228,215) |
| `--tier1 --scalar` | 226,024 (225,027–227,350) | 227,080 (226,197–229,190) |

`perf stat`, user-space instructions and cycles, median of five rounds:

| Build | base | head |
| --- | ---: | ---: |
| Tier 0 instructions | 5,694,001,464 | 5,694,001,489 |
| Tier 0 cycles | 1,320,821,110 | 1,330,594,711 |
| `--tier1` instructions | 4,589,148,152 | 4,588,745,332 |
| `--tier1` cycles | 1,161,018,056 | 1,159,073,930 |

## Code shape

`--tier1-report` on the frozen `sqlite3.c`, and the generated speedtest1 executables:

| Measure | base | head |
| --- | ---: | ---: |
| functions taken by Tier 1 | 2,210 of 2,709 | 2,210 of 2,709 |
| records | 163,925 | 163,820 (−105) |
| spill stores / reloads | 3,432 / 4,028 | 3,411 / 3,999 |
| call stores | 10,333 | 10,333 |
| edge moves | 10,511 | 10,467 |
| `--tier1` speedtest1 bytes | 1,615,976 | 1,615,400 (−576) |
| `lea` with an `rsp` base in it | 4,055 | 4,055 |

The lea total doesn't move: whole-executable counts include every `lea` from the frame pointer's home, and most
frame-object addresses that reach an access have another use that keeps their `lea` alive. The folded patterns remove
105 records and 576 bytes, and 21 stores plus 29 reloads, where an object is single-use.

## What the numbers say

The change is below speedtest1's run-time resolution: head's `--tier1` wall time is 0.03% lower, instructions 0.009%
lower and cycles 0.17% lower, all within the base's and head's round-to-round ranges. Tier 0's two builds, which run
none of the changed code, differ by 0.4% wall, and their instruction counts are equal to 25 instructions in 5.69
billion. The `--scalar` builds, which reach the same selection by the scalar twin, move in the opposite direction
(+0.5% wall), so this workload doesn't resolve the change's cost either.

speedtest1's hot function is `sqlite3VdbeExec`, which Tier 1 doesn't take; the change compiles the same 2,210
functions and most of its accesses through frame objects are multi-use. The record's purpose is the #982 Done-when
measurement, not a speedup claim: the fold is a code-shape improvement whose run-time effect on this program is below
noise. Larger single-use object traffic (Lua and the corpora) may benefit more; that is not measured here.

#142's campaigns at `cc3387f` (`tier1-reciprocal-141-2026-11-01`), a main that contains #996, pass 195 of 240
programs at both tiers; the other 45 fail in clang's own steps, none in Buster's. The #996 tree itself was not put
through the generator campaigns; #982's own checks above and that later campaign are the evidence.

## Files

- `run982.sh`, `test982.sh`: the timing and test harnesses.
- `identities.txt`: CPU, toolchain, source and binary hashes.
- `run.times`: round, build, wall microseconds, user and system seconds, speedtest1's TOTAL, 21 rounds.
- `runs/`: each run's speedtest1 output (21 per build).
- `counts.times`, `counts/`: the `perf stat` rounds' fields and full outputs.
- `build-t1-*.txt`, `build-t1s-*.txt`: `--tier1-report`.
- `verify-*.txt`: the `--verify` runs.
- `test-*.log`: the four suites.
