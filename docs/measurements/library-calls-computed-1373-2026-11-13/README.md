# #1373: plain `memcpy`, `memmove`, `memset`, `abs`, `fabs` and `copysign` computed inline, on the 9700X

Record for [buster#2671](https://github.com/buster14a/buster/pull/2671), part of
[buster#1373](https://github.com/buster14a/buster/issues/1373). A call of the unit's declaration of `memcpy`,
`memmove` or `memset` with a constant size of at most 32 bytes, or of `abs`, `labs`, `llabs`, `fabs`, `fabsf`, `fabsl`,
`copysign`, `copysignf` or `copysignl`, is computed in the call's place at both tiers, as clang -O0's code computes
their intrinsics; on main each is a PLT call.

## Sources and builds

- base: buster `b7a95eedbe16fbd8434654f192f8f7aab76c56e5` (main when the PR was opened);
- head: `8fad19cdf5f0232d3a3255f60095184401e968b2`, the PR's first commit (its next, `f3b7705d`, adds an
  `unused` attribute alone);
- fix: `1228e5398f423fd4b53ee3ea4a97875a8debb78a`, the asm-label test's column;
- fix2: `9e873bf64be0f59ae6898ee456fb3d9ec9f236c6`, the PR's head, which also gates the `no_builtin` walk and inlines
  the mark's test.

Each tree is `git archive` of its commit (`scripts/build-trees.sh` for base and head from GitHub; fix and fix2 from the
session's checkout before they were pushed, copied over), built with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0
./build.sh` in one lock hold per build (`logs/*.build.log`). `results/identities.txt` has each compiler's SHA-256, each
tree's commit and its source manifest (the SHA-256 of its files' sorted SHA-256 sums, `build/` left out), which match
the same manifest of `git archive` of each commit. `results/host.txt` has the kernel, clang 23.1.1, CPU 2's governor and
EPP (`performance`) and the kernels' binaries' and objects' SHA-256s.

## The kernels

`scripts/kern.c` has the issue's kernel (`copies`: `memcpy(d, s, 24); memcpy(d + 32, s + 8, 7);`), an unaligned load
written as `memcpy` into an integer (`load32`), a 12-byte `memmove` and a 16-byte `memset` (`moves`), the first
comment's `abs(x) + labs(y)` (`absolutes`) and `fabs(x) + copysign(1.0, x)` (`signs`), and the second comment's loops
over 4,096 elements (`sum_abs`, `sum_labs`, `sum_fabs`). `scripts/drv.c`, compiled once by clang -O2, calls each
kernel 20 M times (each loop 5,000 times) and prints the best of 5 repetitions. `scripts/prepare.sh` (one lock hold)
compiles `kern.c` by base's and head's compilers, by Tier 0 (`-c`) and Tier 1 (`--tier1 -c`), at the default `x86-64`
target, and by clang 23.1.1 `-O0` and `-O2`, each linked with the same driver object and `-lm`. `scripts/measure.sh`
ran 5 rounds, each one lock hold running every binary once on CPU 2 (`taskset -c 2`) in an order that rotates by round
(`results/round-*.txt`; `results/holds.txt` has each hold's own owner line, `results/busy-*.txt` the busiest
processes and the load average at each hold's start and end). `results/kernels.tsv` has each binary's five values and
their median:

| kernel, ms | main Tier 0 | main Tier 1 | PR Tier 0 | PR Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `copies` | 75.8 | 72.1 | 18.1 | 18.1 | 21.8 | 14.5 |
| `load32` | 36.1 | 36.1 | 14.5 | 14.4 | 18.2 | 14.4 |
| `moves` | 72.1 | 72.2 | 21.6 | 18.1 | 39.8 | 17.6 |
| `absolutes` | 64.9 | 61.3 | 24.0 | 24.1 | 24.2 | 23.4 |
| `signs` | 75.7 | 75.7 | 75.7 | 75.7 | 75.7 | 75.7 |
| `sum_abs` | 22.2 | 18.5 | 9.9 | 7.4 | 9.8 | 2.6 |
| `sum_labs` | 22.2 | 22.2 | 11.1 | 5.3 | 9.5 | 2.5 |
| `sum_fabs` | 77.3 | 44.2 | 11.1 | 7.4 | 44.0 | 7.3 |

`signs` takes 75.7 ms by every compiler, clang -O2's too: the driver's loop (its xorshift step, the conversion to
`double` and the sum's chain) is the floor there. The PR's Tier 1 code is as fast as clang -O0's or faster on every
kernel, and its Tier 0 code on all but the two integer loops (`sum_abs` 9.9 against 9.8 ms, `sum_labs` 11.1 against
9.5 ms; Tier 0's loops are 30 and 29 instructions, clang -O0's 25 and 24, its `abs` a `neg` and a `cmovns` where
this one is a shift, an `xor` and a `sub` beside the temporaries' moves); clang -O0 calls
`memset`, where the PR stores a small one's bytes (`moves`). `results/instructions.tsv` counts each kernel's
instructions in its object (`objdump -d`, without padding) and lists the calls it makes: main's objects call `memcpy`,
`memmove`, `memset`, `abs`, `labs`, `fabs` and `copysign` through the PLT, the PR's call none. fix's and fix2's kernel
objects are byte for byte head's (`logs/fix.log`, `logs/fix2.log`), so the table holds for the PR's head.

## Compile time

`scripts/compile.sh`, `fix.sh` and `fix2.sh` (each its generated `results/sqlite*.sh`, one lock hold) compile the
frozen `sqlite3.c` (SHA-256 in `results/sqlite.txt`) with the 9700X workflow's `compile_time` options (`-c
-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, the default target):
11 alternating whole processes of base and the other tree with `--time-stages` (`results/stages-*.tsv` for the fix
runs), then `perf stat -r 11` of each tree's `-c` and `-fsyntax-only` (`results/perf-*.csv`). Every compile exited 0.

| sqlite3.c `-c` | base | other |
| --- | ---: | ---: |
| head `8fad19cd`: wall, median of 11 (min to max) | 126.16 (125.28 to 126.83) ms | 187.65 (186.02 to 190.11) ms |
| head: user instructions, `-c` | 1,353,372,776 | 3,350,604,364 |
| head: user instructions, `-fsyntax-only` | 1,062,570,075 | 2,063,175,477 |
| fix `1228e539`: wall | 125.43 (124.96 to 125.76) ms | 126.53 (125.86 to 128.34) ms |
| fix: user instructions, `-c` | 1,353,367,805 | 1,357,994,826 |
| fix2 `9e873bf6`: wall | 125.82 (125.51 to 127.21) ms | 126.10 (125.30 to 126.66) ms |
| fix2: user instructions, `-c` | 1,353,367,756 | 1,353,724,288 |
| fix2: user instructions, `-fsyntax-only` | 1,062,570,093 | 1,063,669,000 |

The PR's first commit made the compile 49% slower. `--time-stages` put the difference in `check-program` (24.0 to
57.0 ms) and `lower.statements` (8.0 to 38.2 ms): `check_program_call_computed`'s asm-label test searched every token
of the unit for the callee's declarations, in a unit with an asm keyword, and every small `memcpy` and `memset` now
reaches it, in the references' pass and again in the lowering. fix makes the test read a column built once
(`CheckProgram.object_labelled`). A per-symbol profile of fix against base (`scripts/profile.sh`,
`results/profile/*-symbols.txt`, `perf record -e instructions:u -c 200003`) then showed the reader's `no_builtin` test
(`check_input_no_builtin`, which walks back to the body's brace for each marked call) and `check_program_call_computed`
itself among the few symbols that grew; fix2 skips the walk in a unit without the attribute and inlines the mark's
test. With fix2 the compile is 0.2% slower in wall time (0.28 ms of medians) and 0.03% in instructions, against an
object whose `.text` is 2,008 bytes larger (1,553,773 to 1,555,781 bytes, the inline copies, sets and signs); the
object is byte for byte head's at fix and fix2 (`results/sqlite-fix*.txt`).

`perf stat`'s task-clock and cycles run each tree's 11 processes in turn rather than alternating them, and they move
by 2 to 3% between batches of the same binary (base's task-clock 123.5, 123.8 and 127.1 ms in three batches); the
alternating wall medians and the instruction counts are the comparison.

## Limitations

- The kernels are synthetic loops of the issue's and its comments' shapes. One host (the 9700X), one clang (23.1.1),
  CPU 2 only; 5 rounds of one process per binary, each the best of 5 repetitions.
- The compile-time comparison is one unit (`sqlite3.c`), at the default target.
- fix and fix2 were measured from `git archive` of the session's commits before they were pushed; the source manifests
  in `results/identities.txt` tie each tree to its commit.
- The lock-wait messages that `exclusive.sh` writes, which name other sessions' commands, are removed from the logs and
  results by `scripts/strip_lock.py` (a waiting line and the lines of the holder's command up to this record's own
  next line); `results/round-*.err` held only those messages and are empty. Each file is otherwise as written.
