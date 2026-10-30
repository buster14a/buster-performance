<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# main.c's CI commands and the --symbols index (#129, #126)

What [buster#922](https://github.com/buster14a/buster/pull/922) adds to the
correctness runs costs on the locked Ryzen 7 9700X, and what its index of
`test-checker-corpus --symbols`' reasons saves there, against main.

- The two new correctness commands, run as the list has them through the
  `parallel` runner, pinned to CPU 2: **8.8 s** for main.c's checking and
  symbols against clang, **7.4 s** for its `-c`, `--lower-all` and scalar
  `--lower-all` compiles (two runs, 8.7 s and 7.3 s the second).
- main.c's `--symbols` comparison: **13.73 s** with main's binary, **8.76 s**
  with the index, medians of three interleaved rounds timed inside the lock;
  the paired savings are 4.90, 5.02 and 4.98 s (36%).
- musl's eight CI directories' comparison: 6.24 s with main's binary, 6.27 s
  with the index (+0.3%).
- Both binaries give the same counts on both inputs in every run.

## Sources

| Side | Commit | `git archive --format=tar --prefix=<side>/` SHA-256 |
| --- | --- | --- |
| main | [`d12fd5831f9c73bb7b30505da2ce9616e915143e`](https://github.com/buster14a/buster/tree/d12fd5831f9c73bb7b30505da2ce9616e915143e) | `b93b987bf1d7a08479a9f1fc84f6ce3266d1de4c682b6d0dbdee39ee4c93fca6` (prefix `main-d12fd583/`) |
| head | [`28a9c9253e5ec05b2d693dd0681d9fd984a6a2e5`](https://github.com/buster14a/buster/tree/28a9c9253e5ec05b2d693dd0681d9fd984a6a2e5) | `9677fea4a4f5fba14824e0ef07d575150b9b2440b7b4e0ee64231df51382c201` (prefix `head-28a9c925/`) |

Each tree was extracted from that archive on the host, with a `COMMIT` file
naming its commit. The head is buster#922's branch before any merge of main.

## Host and toolchain

[`logs/receipts.txt`](logs/receipts.txt): the host's kernel, CPU 2's governor
and energy preference (`performance`), the clang used, and both executables'
SHA-256. The toolchain is the official LLVM 23.1.4 release
(`clang-23` SHA-256 `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`),
staged where [the main.c lowering record](https://github.com/buster14a/buster-performance/tree/824a03c24f17805217e17065d2004eb541d12aa7/docs/measurements/rescued-126-main-lowering-2026-10-30)
staged it, the same files the 9700X job's `tools/ci/setup-benchpress.sh`
verifies. Each tree was built with `BUSTER_HOST_ARCH=znver5`,
`BUSTER_DEBUG_INFO=0` and `taskset -c 0-7 ./build.sh` under one hold of the
lock ([`logs/build`](logs/build)). The frozen corpus is the CI's
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`.

main.c's flags are `build.sh print-compile-flags` for that build
([`logs/flags.txt`](logs/flags.txt)), what both new commands pass.

## Method

[`harness/queue.sh`](harness/queue.sh), then
[`queue2.sh`](harness/queue2.sh) and [`queue3.sh`](harness/queue3.sh), ran
detached on the host. Every build and every run took its own hold of the
9700X's lock (`exclusive.sh`) and was pinned to CPU 2. Both binaries read
main's tree: main's `main.c`, which is the same input for both, and each finds
its own `src/buster/include`, the same files in both trees.

- **The new commands** (queue 1's end): the two commands, extracted from the
  head's `tools/ci/correctness.tests`
  ([`logs/main-gates.tests`](logs/main-gates.tests)), run in the head's tree by
  its `parallel --jobs 1 --timeout 600`, twice. The head's own `main.c`
  includes the index, so its comparison drops 11,850 differences, 5 more than
  main's `main.c`.
- **The comparison, timed inside the lock** (queue 3, rounds 6 to 8): main.c's
  and musl's `test-checker-corpus --symbols` by each binary, the binaries' order
  alternating by round. Each run's `TIMING` line, in
  [`logs/status3.log`](logs/status3.log) and its log, is the command's wall
  time between taking the lock and releasing it.
- **Earlier rounds** (queues 1 and 2, rounds 1 to 5) timed the run from before
  the lock was taken ([`logs/status.log`](logs/status.log),
  [`logs/status2.log`](logs/status2.log)). Six of them waited for another
  holder, whose time is in theirs: queue 1's runs that
  [`logs/lock-waits.txt`](logs/lock-waits.txt) lists (`run-*`: round 2's of
  main's binary and round 3's of both). Their times aren't comparisons; queue 3
  replaces them. Queue 3's runs waited too (the `run3-*` entries), but their
  timer starts inside the lock.

The run logs ([`logs/runs`](logs/runs)) keep only the lines the compiler and
its runner print (`checker-corpus:`, `parallel:`, `==` and `TIMING` lines):
the lock's waiting messages, which name other holders' commands, are left out.

## Results

main.c's comparison, milliseconds inside the lock:

| Round | Order | main's binary | head's binary | Saved |
| --- | --- | ---: | ---: | ---: |
| 6 | head, main | 14,001 | 9,105 | 4,896 |
| 7 | main, head | 13,729 | 8,713 | 5,016 |
| 8 | head, main | 13,732 | 8,755 | 4,977 |
| Median | | 13,732 | 8,755 | 4,977 |

musl's eight directories (`math`, `string`, `stdlib`, `fenv`, `legacy`,
`process`, `signal`, `multibyte`), milliseconds inside the lock:

| Round | main's binary | head's binary |
| --- | ---: | ---: |
| 6 | 6,242 | 6,267 |
| 7 | 6,249 | 6,258 |
| 8 | 6,244 | 6,267 |

Every run's counts are its binary's other runs': main.c compared 1, 12,016
differences, all explained (7 folded, 11,845 dropped, 164 inlined); musl
compared 496 of minimum 354 (447 folded, 75 unselected, 144 dropped; 78
unsupported). Queues 1 and 2's runs without a lock wait agree with queue 3's:
main.c 13,674 and 13,811 ms by main's binary (and 15,897 for the very first
run), 9,273, 8,764, 8,716 and 8,741 by the head's.

## Limitations

- Three rounds per comparison, one host, one CPU: enough to show a 5 s
  difference against run-to-run spreads of 0.3 s, not to resolve musl's
  0.3%.
- The times include clang's `-fsyntax-only` and `-O0 -c` of each input, which
  both binaries run alike.
- The 9700X's correctness step runs these commands unpinned beside others, on
  CPUs 0 to 7; this record's times are pinned and alone.
- The laptop runs mentioned in buster#922 (ASan+UBSan, MSan, the four
  corpora's counts) aren't part of this record.
