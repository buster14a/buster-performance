# Integer literals' failed store-to-load forward, for #510

2026-10-26 and 27. [buster14a/buster#510](https://github.com/buster14a/buster/issues/510): every integer literal
lost a store-to-load forward in `check_literal_number_plain`. The branch `claude/510-literal-forward-71b5bf`
(head `faeb0afc`) has the literal functions write into their caller's `CheckLiteral` rather than return one. This
record compares it with main `e04462c1`, its merge base, on the 9700X. The comparison covers code placements of the
checker's unit and fresh copies of the executables. It includes the counters, the profiles and the checker's tests.

## What the change removes

`CheckLiteral` is 48 bytes (a `long double` member), so clang returned it through memory. On main the integer
path builds it in a stack temporary of `check_literal_number_plain`. It zeroes the temporary's tail with two
overlapping 8-byte stores, at `[rsp+0x95]` and `[rsp+0x90]`, then loads it back 8 bytes at a time to copy it into the
result. The load at `[rsp+0x90]` spans both stores, so it can't be forwarded, and the next store waits on it
(`logs/profile-instructions.txt`, "main: check_literal_number_plain around +0x9b1"):

```
10eb870: mov QWORD PTR [rsp+0x95],0x0
10eb87c: mov QWORD PTR [rsp+0x90],0x0
10eb888: vmovdqa xmm0,XMMWORD PTR [rsp+0x80]
10eb891: mov rdx,QWORD PTR [rsp+0x90]
10eb899: mov rcx,QWORD PTR [rsp+0x95]
10eb8a1: mov DWORD PTR [rdi],esi        <- 905 of the function's 1,369 cycle samples
```

The result then went up two more levels by value. `check_literal_number` copied its callee's result with two 32-byte
loads, over the callee's 4-, 8-, 16-, 2-, 1- and 8-byte field stores. `check_input_literal` copied it once more.
With the change, the integer path writes three fields into the caller's result, which `check_input_literal` zeroed:

```
10eb765: mov DWORD PTR [rcx],esi
10eb767: mov QWORD PTR [rcx+0x8],r11
10eb76b: mov BYTE PTR [rcx+0x22],0x1
```

## Executables and inputs

- Trees: `git archive` of `e04462c1` (main) and `faeb0afc` (head), sent by tar to
  `~/buster-fast-bench/literal-510/{main,head}`. They are identical, file for file, to the commits:
  `source-main-e04462c1.sha256` and `source-head-faeb0afc.sha256` list each file's sha256, compared with the
  trees on the host.
- Builds: #502's harness (`scripts/objects.sh`, `scripts/link.sh`, copied from
  `~/buster-fast-bench/checker-placement-502`). `objects.sh` compiles each source as `build.sh` does, without `-g`;
  `main_unit_checker.c` goes to assembly. `link.sh` reassembles the checker's unit with N bytes of `.text` before
  its code (N = 0, 16, 32, 48, 64, 1,024) and links as `build.sh` does with wild. Both trees' assembled code at
  N = 0 is the direct compile's, byte for byte (`logs/link.txt`). Each executable also has a fresh copy (`cp`);
  the timing used the copy at N = 0. The executables' sha256 are in `logs/sha.txt`. `logs/addresses.txt` has the
  addresses of `check_input_expressions` and the literal functions in each one.
- Input: the frozen SQLite amalgamation, `sqlite3.c` sha256 `0a409f16…f5e23d`. `-fsyntax-only` used the
  command line of `~/buster-fast-bench/pp-117-templates/args.sh` (#117's frozen headers, `-target x86_64-linux-gnu
  -march=znver5 -std=gnu17`). `benchmark-checker-source` used the 9700X job's command on the preprocessor oracle's
  corpus (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`).
- Machine: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, transparent huge pages `always`, clang 23.1.1, perf 7.2.9. Every
  run was pinned to CPU 2 (tests to CPUs 0-7) and took the machine's lock alone.

## Results

### `-fsyntax-only` of `sqlite3.c`

The command was `perf stat -r 15 -e cycles:u,instructions:u,ls_bad_status2.stli_other:u,ex_ret_brn_misp:u`,
pinned to CPU 2, with 14 executables per round. Two rounds ran, the second in an order rotated by 5. Each cell is
a mean over 15 processes, each with its own randomized stack (`scripts/stat-round.sh`, `logs/stat-*.txt`,
`summary.txt`):

| Placement | main cycles (rounds 1, 2) | head cycles (rounds 1, 2) | head - main | main stli_other | head stli_other |
| --- | ---: | ---: | ---: | ---: | ---: |
| s0 | 680.5, 677.2 M | 668.4, 671.3 M | -1.33% | 6.595 M | 6.104 M |
| s0, a fresh copy | 677.3, 678.0 M | 670.7, 669.9 M | -1.08% | 6.653 M | 6.129 M |
| s16 | 676.5, 674.2 M | 673.0, 672.1 M | -0.41% | 6.615 M | 6.185 M |
| s32 | 673.7, 672.8 M | 674.2, 674.8 M | +0.19% | 6.621 M | 6.112 M |
| s48 | 677.7, 682.5 M | 674.7, 674.6 M | -0.81% | 6.516 M | 6.116 M |
| s64 | 679.4, 676.0 M | 669.9, 670.1 M | -1.13% | 6.639 M | 6.215 M |
| s1024 | 678.4, 681.5 M | 670.8, 671.5 M | -1.30% | 6.528 M | 6.262 M |

Means over the seven placements:

| Event | main | head | head - main |
| --- | ---: | ---: | ---: |
| `instructions:u` | 1,684.240 M | 1,682.365 M | -1.88 M (-0.11%) |
| `ls_bad_status2.stli_other:u` | 6.595 M | 6.160 M | -0.43 M (-6.6%) |
| `ex_ret_brn_misp:u` | 4.139 M | 4.063 M | -0.08 M (-1.8%) |
| `cycles:u` | 677.5 M | 671.9 M | -5.7 M (-0.84%) |

Placement doesn't move the instructions, and the failed forwards come out lower at every placement: 6.10 to
6.26 M against main's 6.52 to 6.65 M. The cycles are lower at 6 of the 7 placements. The per-placement deltas
average -0.84%, with a standard deviation of 0.55%. Main's own spread over these placements is 672.8 to 682.5 M,
1.4%. Its fresh copy at s0 differs from the original by 0.1 to 0.5% (#502 found 0.3%). The head's spread is 668.4
to 674.8 M. The two ranges overlap only at s32, where main is at its fastest and the head at its slowest. So the
cycles agree with the counters. However, the difference is smaller than the 2.2% that #502 found placement alone
can move this compile, and this sweep moved only the checker's unit, at 7 placements.

### Profiles

There were 16 compiles of `sqlite3.c` per executable at s0, sampled with `perf record -e cycles:u -c 100003` and with
`-e ls_bad_status2.stli_other:u -c 1009` (`scripts/profile.sh`, `logs/profile-*.txt`,
`logs/profile-instructions.txt`). The table gives each function's samples:

| Function | main cycles | head cycles | main stli_other | head stli_other |
| --- | ---: | ---: | ---: | ---: |
| `check_literal_number_plain` | 1,369 | 463 | 479 | 49 |
| `check_input_literal` | 1,938 | 1,105 | 918 | 182 |
| `check_literal_number` | 152 | 51 | 176 | 7 |
| `check_input_expressions` | 17,597 | 18,708 | 8,829 | 3,308 |
| all | 111K | 109K | 72K | 65K |

On main, 905 of `check_literal_number_plain`'s cycle samples and 250 of its failed-forward samples fall on the store
at +0x9b1. On the head, its largest instruction has 147. On main, `check_input_literal`'s largest instruction, with
840 cycle samples and 570 failed-forward samples, is the first 32-byte load copying `check_literal_number`'s result
(+0x1ed). The head has no such copy for numbers.

`check_input_expressions` lost most of its failed-forward samples at +0x1a5 (1,694 on main, 188 on the head). That
instruction is a load in a pointer-chasing loop, which the change doesn't touch. Its cycle samples are alike (6,053
and 6,166). The loop's conflicts depend on something other than this change, plausibly the stack's page offset
that #445 found. The record doesn't count them as the change's. The function's cycle samples are higher on the head
(+1,111). That may be where the time now goes while the literal's fields are read (`check_literal_value`), or the
profile's own variance; one profile per executable doesn't tell these apart.

### `benchmark-checker-source`

There was one run per executable and placement, and the trees' order swapped at each placement
(`scripts/source-round.sh`, `logs/source-*.txt`). The table gives body-graph cycles per node:

| Placement | main scalar | head scalar | main vector | head vector |
| --- | ---: | ---: | ---: | ---: |
| s0 | 279.5 | 279.0 | 307.7 | 300.4 |
| s16 | 281.4 | 278.7 | 301.8 | 300.8 |
| s32 | 282.3 | 280.0 | 305.3 | 301.3 |
| s48 | 292.7 | 277.1 | 315.3 | 300.7 |
| s64 | 278.4 | 280.3 | 300.9 | 301.7 |
| s1024 | 280.1 | 277.8 | 308.9 | 302.1 |

The benchmark reads the literals during preparation, outside its timing, so the change isn't in what it times.
Its body-graph numbers move with placement and with each process's stack offset (#445). One run each doesn't
separate the two trees; the head's numbers are no higher.

### Tests

The head's executable at s0 ran the checker's tests from the head's tree, as the 9700X job runs them
(`scripts/tests.sh`, `logs/tests.txt`). Every test passed with 0 failures:

- `test-checker --seed 133`: 253,545 checks;
- `test-checker-driver --executable ./build/compiler`, with and without `--lazy-system-headers`: 1,634 checks each;
- `test-checker-corpus` on musl's eight directories with `--symbols-minimum 348`: 351 compared;
- the semantic mutants of SQLite (8) and musl (96);
- `--deferred 8 --symbols` on SQLite;
- `test-checker-deferred`: 891 checks.

## Method notes

- The lock was contended: about 10 minutes per hold on 2026-10-26. `queue1.sh` linked main's executables and
  `queue2.sh` was stopped before it ran anything. `queue3.sh` did the rest, one hold per link, test and perf run,
  with `stat-round.sh` cut to two rounds of 14 executables and `source-round.sh` to one round. Both cuts are
  recorded in the scripts.
- The `exclusive.sh` lines saying a run was waiting for the lock, which name other sessions' runs, are removed from
  the logs.
- A local check on a Ryzen 9 7940HS (Zen 4) before the 9700X runs found the same pattern. The literal functions'
  failed-forward samples dropped from about 260 to 15 in one `-fsyntax-only` of the same input. That check isn't
  part of this record's numbers.
