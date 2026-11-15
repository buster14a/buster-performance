# A conditional's constant arms converted in the arms, Buster #2678

Compiler issue: [#2678](https://github.com/buster14a/buster/issues/2678). Compiler PRs:
[#2838](https://github.com/buster14a/buster/pull/2838) (run 2) and its follow-up
[#2844](https://github.com/buster14a/buster/pull/2844) (run 3 and the random-data runs).

#2795 folded an integer constant's own conversion into its CONST
([constant-conversion-fold-2678-2026-11-14](../constant-conversion-fold-2678-2026-11-14)). A `?:`'s or an `&&`/`||`'s
value converted by its consumer kept its CONVERT: the arms meet at a label right before it, so it converts either arm's
value and can't fold into a constant arm's CONST (`jmp 1f; mov $0x1,%ecx; 1: movslq %ecx,%rcx`). #2838 puts that
conversion into the arms where an arm is a constant, so the constant's conversion folds. This record measures #2838's
head against its main (run 2), and the follow-up, which moves #2838's decisions out of the lowering's inlined copies and
keeps the join's conversion to a floating type, against main with #2838 (run 3); then the kernels again over elements in
a pseudo-random order (the random-data runs).

## Sources

| run | main | head |
| --- | --- | --- |
| 2 | `d356f725fbaec68ac93370d96ebdd8be9a627c96` | `d68ae342ad7447aed504145988cd34a5f8b1a7a3` (#2838, merged as it was) |
| 3 | `1b6461b7067bbce6f5c3b9a085418166889cde58` (with #2838) | `947ff1441f2178f033163acd54644e749ac081a3` (the follow-up's first commit) |

Each tree on the host is `git archive` of its commit (`COMMIT` holds the full hash), built with `BUSTER_DEBUG_INFO=0
./build.sh --config Release` (the host's native `znver5` path), one lock hold per build (`harness/run2/run2.sh`,
`harness/run3/run3.sh`; `results/run2/builds.log`, `results/run3/builds.log`). `manifests/` has each commit's `git
archive` manifest; the host trees' manifests (`results/run*/*.host.sha256`, taken under the lock; build outputs,
`build.log` and `COMMIT` left out) are identical to them: 2,818 files in run 2's trees, 2,847 in run 3's.

## Host

The Ryzen 7 9700X (`benchpress`), CPU 2. `results/run*/host-identity.txt` have the kernel (6.18.50-2-lts), governor and
EPP (`performance`), THP (`always`), the host's clang (23.1.1, which built the kernels' driver and the clang
references) and perf (7.2.9), taken under the lock.

## Method

Every build and timed run held the 9700X's lock, one hold per run, through `exclusive.sh`: the builds directly, every
later run through `harness/*/lock.sh`, whose holds append the holder's line to `results/run*/holds.txt` and the load and
the busiest processes, before and after, to `results/run*/busy.txt`. No hold's snapshot shows another process at 10% CPU
or more.

**Kernels** (`harness/run2/kernels.c`, the same file in both runs): each sums a value over 4,096 `int` elements;
`harness/run2/driver.c`, built by clang `-O2`, calls each one 20,000 times (81.92 M iterations) and prints the
milliseconds. The elements are -1, 5, 0 and 2000, repeating, so each branch's outcome repeats every four elements.

| kernel | sum | its conversion at main `d356f725` |
| --- | --- | --- |
| `both` | `long s += p[i] > 0 ? 1 : 2` | after the join, of either constant |
| `one` | `long s += p[i] > 0 ? p[i] : 1` | after the join, of the element or the constant |
| `logic` | `long s += p[i] > 0 && p[i] < 1000` | after the join, of the second compare's truth or the `&&`'s 0 |
| `dboth` | `double s += p[i] > 0 ? 3 : 1` | after the join, `cvtsi2sd` of either constant |

`harness/*/ab.sh` builds `kernels.c` with main's and head's compilers at Tier 0 (`-c`) and Tier 1 (`-c --tier1`) and
with clang at `-O0` and `-O2 -fno-vectorize -fno-slp-vectorize`, links each with the same `driver.o` (one hold), then
runs 11 rounds, each a hold of its own, every binary once per kernel, interleaved, pinned to CPU 2 (`runs.txt`); then
the checksums and hashes in a hold of their own. One cycle an iteration is 14.8 ms here.

**Compile** (`harness/*/compile-ab.sh`): `-c sqlite3.c` from CI's frozen corpus (`preprocessor-391e729af658`, the copy
`constant-conversion-fold-2678-2026-11-14` fetched into this task's directory) with CI's options, less
`--no-default-config`, which `-c` doesn't take. One hold builds each compiler's Tier 0 and Tier 1 objects and counts
their sizes, instructions and the constant-conversion pairs (`harness/*/pairs.c`: adjacent `mov $imm,%r32` or `xor
%r32,%r32` and `movslq` of the same register, and such a move and a `cvtsi2sd`/`cvtsi2ss` of it). Then three rounds
of `perf stat -r 11` (main, then head, each a hold), pinned to CPU 2, and three rounds of `benchmark-lowering-source
--passes 5` (warm lowering, in memory), the same way.

**Random data** (`harness/run3/ab-random.sh`, after run 3, with run 3's `kernels.c` objects): the same objects linked
with `driver-random.c`, 11 rounds the same way (`results/run3/ab-random.txt`, `results/run3/runs-random.txt`). Its
elements are -1, 5, 0 and 2000 in a pseudo-random order (xorshift64, a fixed seed): 1 Mi elements (4 MiB), and each
call takes the next of 256 windows of 4,096, so each branch's outcome is a coin's. A first version
(`harness/run3/repeating/driver-random.c`, `results/run3/ab-random-repeating.txt`, `runs-random-repeating.txt`) had one
random window of 4,096 for every call; the predictor learned its outcomes (no kernel slowed, Tier 0's branches
included), so it measured nothing the repeating pattern doesn't.

## Run 2: #2838 against its main

### Kernels

Milliseconds for 20,000 calls, best/median/worst of 11 rounds (`results/run2/ab.txt`, `results/run2/runs.txt`):

| kernel | main Tier 0 | head Tier 0 | main Tier 1 | head Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `both` | 42.1/44.6/48.0 | **37.2/37.7/41.5** | 29.7/29.7/29.8 | 29.7/29.7/30.2 | 42.1/42.1/43.2 | 14.9/14.9/14.9 |
| `one` | 51.8/51.9/52.0 | **39.6/42.7/45.1** | 24.7/24.7/25.3 | 26.1/26.1/26.2 | 51.6/51.7/51.9 | 15.4/15.5/15.5 |
| `logic` | 59.2/59.2/63.6 | **46.9/47.6/48.1** | 28.6/28.7/28.8 | 28.6/28.7/28.8 | 56.8/56.9/57.0 | 13.7/13.7/13.7 |
| `dboth` | 42.4/42.8/47.3 | 44.5/44.5/44.5 | 40.4/40.5/40.6 | **37.4/37.6/37.9** | 176.5/176.5/176.8 | 39.6/40.4/40.8 |

All six binaries print the same checksum.

- **Tier 0's integer kernels** lose the `movslq` after the join: `both` 0.85 times main's median, `one` 0.82 and
  `logic` 0.80, each now faster than clang -O0's.
- **Tier 1's `one`** takes 26.1 ms for main's 24.7: the arm's `movslq` load is copied to another register before the
  `cmovg` (`movslq (%rdi,%rcx,4),%rdx; mov %rdx,%r8; mov $0x1,%r9d; test %edx,%edx; cmovg %r8,%r9`), where main's
  `cmovg` reads `%rdx`. The narrow element (tested) and its extension (selected) are two values there; filed as
  [#2843](https://github.com/buster14a/buster/issues/2843).
- **`dboth`**: head's arms write `movabs $0x4008000000000000,%rax; movq %rax,%xmm1` (3.0) and the same for 1.0, where
  main's write `mov $0x3,%eax` and the join `cvtsi2sd %eax,%xmm1`. At Tier 0 that took 44.5 ms for main's 42.8; run 3
  shows that difference is code placement, not the code. At Tier 1, main selects with `cmovg` and converts; head
  branches around the two constants (Tier 1 has no select of floating values), 37.6 ms for 40.5 with this predictable
  pattern.

### Compile

`results/run2/compile.txt`; each `perf stat -r 11`'s CSV and each `benchmark-lowering-source` output is in
`results/run2/compile/`.

| | main | head |
| --- | ---: | ---: |
| user instructions, rounds 1, 2, 3 | 1,347,951,727 / 1,347,951,737 / 1,347,951,745 | 1,349,764,320 / 1,349,764,422 / 1,349,764,425 |
| user cycles, rounds 1, 2, 3 | 591.07 M / 589.96 M / 590.10 M | 590.55 M / 590.06 M / 590.20 M |
| task-clock, rounds 1, 2, 3 | 120.73 / 120.67 / 120.73 ms | 120.65 / 120.75 / 120.75 ms |
| `benchmark-lowering-source`'s lowering, rounds 1, 2, 3 | 19.30 / 18.99 / 19.04 ms | 19.01 / 19.12 / 18.93 ms |
| Tier 0 object: text, instructions | 1,383,394 B, 364,851 | 1,383,426 B, 364,884 |
| Tier 0 object: constant `mov`/`xor` + `movslq` pairs | 8 | **0** |
| Tier 1 object: text, instructions | 1,648,473 B, 377,091 | 1,648,489 B, 377,118 |
| Tier 1 object: constant pairs | 12 | 3 |

The head's compile runs 1,812,6xx more user instructions (+0.134%: 1,812,593, 1,812,685 and 1,812,680 by round);
its cycles and task-clock are main's within the rounds' spread, as is the lowering's time. The Tier 0 object's +33
instructions are alignment padding: six functions are one instruction shorter (`bytelengthFunc`, `sqlite3VdbeExec`,
`sqlite3VdbeMemSetStr`, `sqlite3_result_zeroblob`, `sqlite3_str_vappendf`, `walIteratorInit`) and none longer.

## Run 3: the follow-up against main with #2838

The follow-up moves #2838's decisions out of `check_lower_logical`, which `check_lower_expand`'s copies inline, behind
one inlined test (whether the task under the node's EXPRESSION is its consumer's conversion), and keeps the join's
conversion where the target is floating (`dboth`'s).

### Kernels

`results/run3/ab.txt`, `results/run3/runs.txt`:

| kernel | main Tier 0 | head Tier 0 | main Tier 1 | head Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `both` | 37.2/38.9/40.5 | 37.1/38.3/41.7 | 29.7/29.7/29.8 | 29.7/29.7/29.7 | 42.1/42.3/43.3 | 14.9/14.9/15.0 |
| `one` | 39.6/42.6/45.6 | 39.6/41.7/45.6 | 26.1/26.1/26.4 | 26.0/26.1/26.6 | 51.6/51.7/52.1 | 15.4/15.5/15.5 |
| `logic` | 47.0/47.8/48.1 | 45.4/47.6/48.0 | 28.6/28.7/28.7 | 28.6/28.7/28.8 | 56.8/56.9/57.1 | 13.7/13.7/13.7 |
| `dboth` | 44.5/44.5/44.7 | 46.0/51.9/52.1 | **37.4/37.7/38.0** | 40.4/40.5/40.7 | 176.5/176.5/176.7 | 38.9/40.3/41.0 |

Main's `kernels.c` objects are run 2's head's, byte for byte (`m0.o` `06fcc597`, `m1.o` `fbfb4cf6`), so the integer
kernels repeat run 2's head's within their spread. Head's `dboth` is main's at `d356f725` again, the same instructions
as run 2's main's Tier 0 `k_dboth`, but at offset 0x120 where run 2's was at 0x130 (the integer kernels before it are
#2838's, 16 bytes shorter): 51.9 ms there for 42.8 in run 2. #2838's `k_dboth`, at 0x120 in both runs, took 44.5 ms in
both. So Tier 0's `dboth` difference in run 2 was the function's placement; at one placement #2838's arms are faster.
Tier 1's `dboth` repeats run 2: the branch around the two constants, 37.7 ms for the select and `cvtsi2sd`'s 40.5,
with this pattern.

### Compile

`results/run3/compile.txt`, `results/run3/compile/`:

| | main | head |
| --- | ---: | ---: |
| user instructions, rounds 1, 2, 3 | 1,350,989,056 / 1,350,989,087 / 1,350,989,086 | 1,349,414,019 / 1,349,413,999 / 1,349,413,929 |
| user cycles, rounds 1, 2, 3 | 589.22 M / 588.94 M / 588.48 M | 588.24 M / 589.78 M / 589.99 M |
| task-clock, rounds 1, 2, 3 | 120.30 / 120.26 / 120.34 ms | 120.21 / 120.44 / 120.45 ms |
| `benchmark-lowering-source`'s lowering, rounds 1, 2, 3 | 19.32 / 19.15 / 19.12 ms | 19.35 / 18.90 / 18.83 ms |
| Tier 0 object: text, instructions, pairs | 1,383,426 B, 364,884, 0 | the same bytes |
| Tier 1 object: text, instructions, pairs | 1,636,385 B, 374,935, 3 | the same bytes |

The head's compile runs 1,575,1xx fewer user instructions than main's (-0.117%: 1,575,037, 1,575,088 and 1,575,157 by
round), most of #2838's +1,812,6xx; cycles, task-clock and the lowering's time are main's within the spread. sqlite3.c
has no conditional of constant arms converted to a floating type, so both objects are the same bytes (and the Tier 0
object is run 2's head's, `09c18d8e`). In the cloud container, `BUSTER_HOST_ARCH=x86-64` Release builds under callgrind
(`results/callgrind.txt`) count 1,469,662,224 instructions for `d356f725` and 1,469,662,388 for the follow-up's first
commit on `d68ae342` (`d0d54be7`, the same change before its rebase): 164 more.

## Random data

`results/run3/ab-random.txt`, best/median/worst of 11 rounds, ms; main `1b6461b7` (with #2838), head `947ff144`:

| kernel | main Tier 0 | head Tier 0 | main Tier 1 | head Tier 1 | clang -O0 | clang -O2 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `both` | 263.7/266.5/271.0 | 264.3/268.5/272.7 | 24.4/24.4/29.7 | 24.4/24.4/26.5 | 59.3/59.3/59.3 | 14.9/14.9/14.9 |
| `one` | 265.1/274.1/283.3 | 264.9/272.6/279.5 | 29.7/29.7/29.8 | 29.7/29.7/29.8 | 275.6/275.9/276.3 | 15.5/15.6/15.6 |
| `logic` | 266.5/273.9/282.0 | 266.4/273.2/289.2 | 28.7/28.7/28.8 | 28.7/28.7/28.8 | 283.3/288.7/292.1 | 13.7/13.7/13.8 |
| `dboth` | 260.6/260.8/261.4 | 260.4/261.0/261.7 | **222.6/223.4/228.6** | **40.5/40.5/40.7** | 176.5/176.5/176.5 | 39.7/40.1/40.2 |

All six binaries print the same checksum. Tier 0 branches around every conditional's arms, on both sides, and takes a
mispredict on about half the elements (some 250 ms against the repeating pattern's 40 to 50). At Tier 1, #2838's
`dboth` is the branch between the two `double` constants, 223.4 ms, 5.5 times the select and `cvtsi2sd`'s 40.5, which
the follow-up restores (Tier 1 has no select of floating values,
[#2842](https://github.com/buster14a/buster/issues/2842)). The integer kernels' Tier 1 selects are `cmov`s on both
sides.

## Limitations

- A Tier 0 kernel's time moves with the function's placement by more than these changes move it (`dboth`'s 42.8 and
  51.9 ms for one sequence of instructions); the A/B compares objects of one `kernels.c`, where the functions before
  a changed one move too.
- The follow-up's measured commit is `947ff144`; the PR's `d40da686` amends its comments, docs and the fixture's
  comment only.
- The callgrind counts come from the cloud container's scalar-path builds, of `d356f725` and of the follow-up's change
  on `d68ae342` (`d0d54be7`); `d68ae342` itself wasn't counted there.
- The correctness tests listed in the PRs ran in a cloud container, not on this host.
- The logs leave out the lines `exclusive.sh` printed while waiting for other sessions' holds (their commands, titles
  and links): `grep -v -E '^exclusive.sh: waiting|^  (title|link|pull request):'`.

Original material in this directory: Apache-2.0 WITH LLVM-exception.

