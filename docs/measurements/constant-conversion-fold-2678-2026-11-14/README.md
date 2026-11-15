# An int constant's conversion folded into its CONST, Buster #2678

Compiler issue: [#2678](https://github.com/buster14a/buster/issues/2678). Compiler PR:
[#2795](https://github.com/buster14a/buster/pull/2795).

When C's conversions convert an integer constant (`i + 1` with `unsigned long i`, `x == 0` with `long x`, `d + 1` with
`double d`), the lowering wrote a CONST of the constant's own type and a CONVERT, so Tier 0 moved the constant to a
register and converted it every time the code ran (`mov $1,%ecx; movslq %ecx,%rcx; add %rcx,%rax`, `mov $1,%eax;
cvtsi2sd %eax,%xmm1`). The head folds the constant's own conversion into its CONST, which Tier 0 takes as an immediate
(`inc %rax`, `test %rdi,%rdi`, `imul $0x8,%rdi,%rax`), and a `double` or `float` constant's bits where the value is exact.

## Sources

- Main: `2ebfe68a856613e300231520af5e7ec5627708b6`.
- Head: `e79a63382b67f6decc149a423df4d16eb3d25f9c`, #2795's first commit, all of its compiler code but the frame
  verifier's. Its later commits, `002797d1` and `2da0fddd`, change tests and `--verify`'s frame verifier
  (`emitted_verify_frames`), which no measured command runs; they were not measured.

Each tree on the host is `git archive` of its commit (`COMMIT` holds the full hash), built with `BUSTER_DEBUG_INFO=0
./build.sh --config Release` (the host's native `znver5` path, the 9700X job's own toolchain), one lock hold per build
(`harness/build.sh`, `results/builds.log`). `manifests/` has each commit's `git archive` manifest, the host trees'
manifests (taken under the lock; build outputs, `build.log` and `COMMIT` left out) and their comparison: identical, 2,732
and 2,737 files. The compilers' SHA-256 are in `results/builds.log`, `results/ab.txt` and `results/compile.txt`.

## Host

The Ryzen 7 9700X (`benchpress`), CPU 2. `results/host-identity.txt` (and `results/host.txt`) have the kernel
(6.18.50-2-lts), governor and EPP (`performance`), THP (`always`), the host's clang (23.1.1, which built the kernels'
driver and the clang references) and perf (7.2.9), taken under the lock.

## Method

Every build and timed run held the 9700X's lock, one hold per run, through `exclusive.sh`: the builds directly, every
later run through `harness/lock.sh`, whose holds append the holder's line to `results/holds.txt` and the load and the
busiest processes, before and after, to `results/busy.txt`. No hold's snapshot shows another busy process (one runnable
task, `ps` itself); load averages of up to 6.2 are the previous holders' runs.

**Kernels** (`harness/kernels.c`): each sums over an array of 4,096 elements; `harness/driver.c`, built by clang `-O2`,
calls each one 20,000 times (81.92 M iterations) and prints the milliseconds. The first three are #1386's record's
(`power-two-division-1386-2026-11-13`): the index kernel `p[i / 8 * 8 + i % 8]` (`unsigned long i`), `p[i] * 8 + 1`
(`unsigned long`) and `p[i] * 2` (`double`); the last two only this pattern: `(p[i] == 0) + (p[i] < 0)` (`long`) and
`p[i] * 2 + 1` (`float`). `harness/ab.sh` builds `kernels.c` with main's and head's compilers at Tier 0 (`-c`) and
Tier 1 (`-c --tier1`) and with clang at `-O0` and `-O2 -fno-vectorize -fno-slp-vectorize`, links each with the same
`driver.o` (one hold), then runs 11 rounds, each a hold of its own, every binary once per kernel, interleaved, pinned to
CPU 2 (`results/runs.txt`); then the checksums and hashes in a hold of their own (#1386's record ran them outside one).

**Compile** (`harness/compile-ab.sh`, run by `harness/compile-run.sh`): `-c sqlite3.c` from CI's frozen corpus
(`preprocessor-391e729af658`, fetched by the head tree's `tools/ci/fetch-corpus.sh` into this task's directory, in a
hold) with CI's options, less `--no-default-config`, which `-c` doesn't take. One hold builds each compiler's Tier 0 and
Tier 1 objects and counts their sizes, instructions and the constant-conversion pairs (`harness/pairs.c`: adjacent
`mov $imm,%r32` or `xor %r32,%r32` and `movslq` of the same register, and such a move and a `cvtsi2sd`/`cvtsi2ss` of
it). Then three rounds of `perf stat -r 11` (main, then head, each a hold), pinned to CPU 2, and three rounds of
`benchmark-lowering-source --passes 5` (warm lowering of the selected definitions, in memory), the same way.

## Kernel results

Milliseconds for 20,000 calls, best/median/worst of 11 rounds (`results/ab.txt`, `results/runs.txt`):

| kernel | main Tier 0 | head Tier 0 | main Tier 1 | head Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `unsigned long i`: `s += p[i / 8 * 8 + i % 8]` | 43.4/43.5/43.7 | **35.6/35.6/35.8** | 26.8/26.8/26.9 | 26.8/26.8/26.8 | 42.1/42.2/42.3 | 14.7/14.7/14.7 |
| `unsigned long`: `s += p[i] * 8 + 1` | 59.2/59.3/59.4 | **33.5/35.0/35.0** | 16.1/16.1/16.2 | 16.1/16.1/16.2 | 44.5/44.5/44.6 | 18.4/18.4/18.4 |
| `double`: `s += p[i] * 2` | 40.5/40.5/40.6 | **38.4/38.5/38.6** | 38.3/38.9/39.3 | 38.2/38.6/39.1 | 176.0/176.1/176.2 | 29.1/29.1/29.3 |
| `long`: `s += (p[i] == 0) + (p[i] < 0)` | 59.2/59.3/59.3 | 59.2/59.3/59.3 | 28.6/28.6/29.2 | 28.6/28.6/29.1 | 63.2/63.2/63.3 | 14.8/14.8/14.9 |
| `float`: `s += p[i] * 2 + 1` | 44.6/44.7/45.7 | **43.0/43.0/53.6** | 43.1/43.2/43.3 | 43.1/43.1/43.2 | 176.1/176.2/176.3 | 29.3/29.3/29.4 |

All six binaries print the same checksum. Main's and head's Tier 1 objects of `kernels.c` are the same bytes (Tier 1
folded these conversions already), so the Tier 1 columns differ by run-to-run spread alone.

In Tier 0, the index kernel takes 0.82 times main's median and is now faster than clang -O0's (35.6 against 42.2 ms):
#1386's third kernel, whose `* 8` was the last thing keeping it behind. `p[i] * 8 + 1` takes 0.59 times main's, the
`double` and `float` kernels 0.95 and 0.96 times. The `long` compares' kernel writes four fewer instructions an
iteration (`xor; movslq; cmp` twice became `test` twice) and takes the same time: 59.3 ms is four cycles an iteration
(one is 14.8 ms here), the loop's induction chain through its moves (`mov %r8,%rax; mov %rax,%rcx; inc %rcx; mov
%rcx,%r8`), which the compares were never on.

Spread: head's `p[i] * 8 + 1` took 35.0 ms in nine rounds and 34.2 and 33.5 in two; its `float` kernel 43.0 ms in nine
and 49.4 and 53.6 in two (rounds 1 and 4, whose holds' snapshots show nothing else busy). Main's index kernel took 59.2
ms in #1386's record (main `b7a95eed`, a `kernels.c` of ten kernels) and 43.5 here: #1386's record saw 44.5 and 59.2
from one compiler at two code placements, so a difference of that size between those builds says nothing of this
change, which this record's A/B measures between objects of one `kernels.c`.

## Compile results

`results/compile.txt`; each `perf stat -r 11`'s CSV and each `benchmark-lowering-source` output is in
`results/compile/`.

| | main | head |
| --- | ---: | ---: |
| user instructions, rounds 1, 2, 3 | 1,350,062,863 / 1,350,062,887 / 1,350,062,889 | 1,349,116,777 / 1,349,116,777 / 1,349,116,773 |
| user cycles, rounds 1, 2, 3 | 588.72 M / 592.11 M / 589.73 M | 590.27 M / 591.08 M / 590.35 M |
| task-clock, rounds 1, 2, 3 | 120.51 / 121.12 / 120.64 ms | 120.63 / 120.84 / 120.71 ms |
| `benchmark-lowering-source`'s lowering, rounds 1, 2, 3 | 21.38 / 19.31 / 19.17 ms | 21.23 / 19.09 / 19.19 ms |
| Tier 0 object: text | 1,437,138 B | 1,383,314 B (-3.75%) |
| Tier 0 object: instructions | 382,586 | 364,835 (-4.64%) |
| Tier 0 object: constant `mov`/`xor` + `movslq` pairs, `cvtsi2s` of a constant | 7,305, 8 | 8, 0 |
| Tier 1 object: text | 1,681,737 B | 1,683,329 B (+0.09%) |
| Tier 1 object: instructions (pairs: 12 each) | 384,609 | 384,912 (+0.08%) |
| lowered objects' bytes (`benchmark-lowering-source`'s `referenced_object_bytes`) | 2,059,000 | 2,005,272 (-2.61%) |

The head's compile runs 946,100 fewer user instructions (-0.070%). Its cycles against the main round before each are
+0.26%, -0.17% and +0.10%, against perf's ±0.09% to ±0.16% a round, and its task-clock is main's within 0.3 ms: no
difference the rounds resolve. The lowering's own time is main's too, within each round's spread (the first round of
each side is about 2 ms slower than its later ones).

The 8 pairs left in the Tier 0 object are conditionals whose arms join at a label right before the CONVERT (for example
`jmp b8e; mov $0x1,%ecx; b8e: movslq %ecx,%rcx` in `sqlite3_db_status64`): the CONVERT converts either arm's value, so
it doesn't fold into the constant's CONST.

The Tier 1 object's +303 instructions are inlining decisions: without the CONVERTs, more static callees fit Tier 1's
inlining size, so head's callers call fewer of them and carry the callees' bodies, and some functions shrink. In the
cloud container's Develop builds of both commits (`results/tier1-functions.txt`, where the net is +294): 26 functions
differ, 14 larger and 12 smaller; `strftimeFunc` makes 16 calls to local functions where main's makes 19, `dateFunc` 3
where 4 (and a `memset` an inlined body brings), and `timediffFunc` has 237 instructions where main's has 443.

## Limitations

- The compile A/B's first attempt crashed before it timed anything: the #1386 record's corpus copy
  (`~/buster-fast-bench/corpus-391e729af658`) had been removed from the host, and main's compiler segfaults on a missing
  `--predefines` file instead of reporting it ([#2828](https://github.com/buster14a/buster/issues/2828);
  `results/compile-first-attempt.txt`, `results/diagnose.txt` with gdb's backtrace, from `harness/diagnose.sh`, one
  hold). `harness/compile-run.sh` then fetched the corpus into this task's directory and ran the whole compile A/B
  again; `results/compile.txt` is that run's.
- The Release builds ran twice: a first launch of `harness/build.sh`, by `setsid nohup` from a `tailscale ssh` call,
  survived the call's end, which the session didn't see, and a second launch, as a `systemd-run --user` unit, built the
  same trees again, each build in its own hold, the second ones incremental. `results/builds.log` is the one both
  wrote over (its two `done` lines). The measured compilers are the trees' last builds, whose hashes `ab.txt` and
  `compile.txt` give.
- A Tier 0 kernel's time comes in whole cycles an iteration (14.8 ms each here) and moves with code placement (see
  "Spread" above); the A/B compares objects built from one placement each.
- The correctness tests listed in #2795 ran in a cloud container, not on this host.
- The logs leave out the lines `exclusive.sh` printed while waiting for other sessions' holds (their commands, titles
  and links): `grep -v -E '^exclusive.sh: waiting|^  (title|link|pull request):'`.

Original material in this directory: Apache-2.0 WITH LLVM-exception.
