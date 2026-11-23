# #1373 leftovers: plain `memmove` of 33 to 128 bytes and `__builtin_copysign` computed in place, on the 9700X

This is the record for [buster#3327](https://github.com/buster14a/buster/pull/3327), part of
[buster#1373](https://github.com/buster14a/buster/issues/1373). It follows
[library-calls-computed-1373-2026-11-13](../library-calls-computed-1373-2026-11-13), which reused its kernel driver's
shape and its `sqlite3.c` step.

The change, on its own:

- A plain `memmove` of a constant size of 33 to 128 bytes is computed in place at both tiers, through `COPY`'s new move
  form. Every 16-byte piece is loaded before any is stored. On main this is a PLT call.
- `__builtin_copysign` and `__builtin_copysignf` are computed in place. On main they called their math helper.

## Sources and builds

Every tree is a `git worktree` of buster `1f7ce98f172397c6e201cab02b90cd8a333524b8` (main when the work started).
Each variant is that commit plus a patch from `patches/`:

| tree | what it is |
| --- | --- |
| `base` | main |
| `stack` | memmove from 16 bytes by vector values held on the typed stack: each piece's destination address, then its loaded vector, then all the `SET`s |
| `temp` | the same, with each piece held in a vector frame local |
| `copy2` | two `COPY`s through a frame buffer |
| `move` | the PR's design, `COPY`'s move form. Its patch leaves out the test files |
| `head` | the PR's commit, applied with `git am` (commit `418119ee` here, tree `00c11d21a70eec04ac229234ac00bb6f5208c218`, the same tree as the PR's `bcf26b70`) |

All six trees carry the `__builtin_copysign` change.

Each tree was built with `./build.sh --config Release`, the 9700X's own toolchain and the native host, in one lock hold
per build (`scripts/builds.sh`, `logs/build-*.log`). `results/host.txt` has each compiler's and binary's SHA-256.
`results/head-kernels.txt` confirms that the head compiler's kernel objects are byte for byte the `move` tree's at
both tiers and both targets.

## The kernels

`scripts/kern.c` holds five loops:

- **Overlapping chains**: `loop_move40`, `loop_move64` and `loop_move128` move 40, 64 or 128 bytes within a
  192-byte buffer. Each move's ranges overlap by a varying amount, forward or backward, so each move reads bytes
  the move before it just stored: a store-to-load chain.
- **Throughput**: `loop_far64` and `loop_far128` move 64 or 128 bytes between two 4 KB regions and never read a recent
  store.
- **copysign**: `sum_copysign` and `sum_copysignf` sum `__builtin_copysign(p[i], q[i])` over 4,096 elements.

`scripts/drv.c` is compiled once by clang -O2. It runs each move loop for 20 M moves and each copysign loop 5,000
times, and prints the best of 5 repetitions in ms.

`scripts/prepare.sh` (one lock hold) compiles the kernels with each tree's compiler, at Tier 0 (`-c`) and Tier 1
(`--tier1 -c`), at `-march=x86-64` and `-march=znver5`. It also compiles them with clang 23.1.1 at -O0 and -O2, and
links each object with the same driver object. `results/check.txt` holds one run of each binary. Every binary prints
the same hash of its buffers and the same sum.

`scripts/measure.sh` was to run 5 rounds, each one lock hold that runs every binary once on CPU 2, in an order that
rotates by round. Rounds 0 to 2 completed (`results/round-*.txt`, 24 binaries each). After round 2 the script was no
longer running: the session's `tailscale ssh` call that started it had timed out. So the table is the median of 3
rounds (`results/kernels.tsv`). `results/holds.txt` holds each hold's owner line, and `results/busy-*.txt` the
busiest processes and the load average at each hold's start and end.

Medians of 3 rounds, ms:

| binary | move40 | move64 | move128 | far64 | far128 | sum_copysign | sum_copysignf |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| main Tier 0, x86-64 | 55.2 | 65.4 | 60.8 | 22.5 | 22.5 | 77.4 | 77.4 |
| main Tier 1, x86-64 | 55.2 | 62.0 | 60.9 | 22.1 | 22.6 | 44.3 | 44.3 |
| PR (`move`) Tier 0, x86-64 | 55.4 | 69.9 | 75.7 | 13.9 | 22.0 | 14.8 | 13.0 |
| PR (`move`) Tier 1, x86-64 | 57.2 | 63.6 | 70.4 | 12.5 | 23.7 | 10.3 | 10.2 |
| PR (`move`) Tier 0, znver5 | 55.4 | 69.9 | 75.7 | 13.9 | 21.9 | 14.8 | 13.0 |
| PR (`move`) Tier 1, znver5 | 57.1 | 63.6 | 70.3 | 11.0 | 21.6 | 10.3 | 10.2 |
| clang -O0, x86-64 | 53.4 | 70.8 | 75.6 | 19.9 | 34.7 | 44.1 | 44.1 |
| clang -O2, x86-64 | 53.5 | 65.9 | 74.0 | 10.9 | 21.2 | 7.3 | 7.3 |
| clang -O0, znver5 | 53.4 | 57.2 | 64.1 | 14.8 | 21.0 | 44.1 | 44.1 |
| clang -O2, znver5 | 53.4 | 57.2 | 65.4 | 6.3 | 11.0 | 7.3 | 7.3 |
| `stack` Tier 0, x86-64 | 87.1 | 96.2 | 146.3 | 24.5 | 105.1 | 13.1 | 14.8 |
| `stack` Tier 1, znver5 | 55.3 | 57.2 | 63.3 | 6.2 | 11.6 | 11.1 | 11.1 |
| `temp` Tier 0, znver5 | 183.4 | 187.2 | 221.6 | 26.5 | 52.7 | 14.8 | 13.0 |
| `copy2` Tier 0, x86-64 | 112.0 | 95.2 | 97.2 | 23.9 | 44.6 | 14.8 | 13.0 |

`results/kernels.tsv` has every row.

What the table shows:

- **copysign.** `__builtin_copysign` is 5.2× faster at Tier 0 (77.4 to 14.8 ms) and 4.3× at Tier 1 (44.3 to 10.3 ms).
  Both tiers now beat clang -O0's 44.1 ms. clang -O2 vectorizes the loop.
- **Throughput loops (`far*`).** The PR's code moves 64 bytes 1.6 to 2.0 times as fast as main's call, and 128 bytes
  as fast as the call. Every PR row matches or beats clang -O0's; at x86-64 Tier 0 moves 128 bytes in 22.0 ms
  against clang -O0's 34.7.
- **Overlapping chains (`move*`).** Here the library's call is the fastest code of all. Its 64- and 128-byte moves
  take 61 to 65 ms. Every inline form is slower: clang -O0's and -O2's (64.1 to 75.6 ms at 128 bytes) and the PR's
  (70.3 to 75.7 ms). The PR's Tier 0 is as fast as clang -O0 at x86-64.
- **Why `move` and not a typed-stream recipe.** Tier 0 keeps a vector value in a frame slot, so each piece of
  `stack`, `temp` and `copy2` took a store and a load more. That made Tier 0's chains 1.6 to 3.6 times as slow as the
  library call. With 8 pieces at x86-64, `stack`'s addresses and values also overflowed Tier 0's 15-register integer
  stack (`far128` 105 ms). `COPY`'s move form holds the pieces in XMM registers instead.
- **What remains.** The move form moves 16-byte pieces at every target. At znver5 `stack`'s Tier 1 used 64-byte
  pieces and was 1.8 to 1.9 times as fast on `far*`. Wider pieces where the target has them are a follow-up.

`results/instructions.tsv` counts each kernel's instructions in its object and lists its PLT calls. main's move
loops call `memmove`; the PR's call nothing.

## Compile time

`scripts/compile.sh` (one lock hold, generating `results/sqlite.sh`) compiles the frozen `sqlite3.c` with the 9700X
workflow's `compile_time` options at the default target. Its SHA-256 is in `results/sqlite.txt`. The script runs:

- 11 alternating whole processes of base and head;
- `perf stat -r 11` of each tree's `-c` and `-fsyntax-only` (`results/perf-*.csv`).

| sqlite3.c | base | head |
| --- | ---: | ---: |
| `-c` wall, median of 11 (min to max) | 114.38 (113.86 to 144.64) ms | 114.19 (113.58 to 146.49) ms |
| `-c` user instructions | 1,247,313,109 | 1,247,186,768 |
| `-fsyntax-only` user instructions | 1,036,784,434 | 1,036,785,896 |
| `.text` bytes | 1,285,757 | 1,285,757 |

Both trees' first process ran cold, at 145 ms. The objects are byte for byte the same: `sqlite3.c` has no `memmove`
of a constant 33 to 128 bytes and no `__builtin_copysign`. Its 29 `memmove`, 180 `memcpy` and 219 `memset` calls stay
in both.

## Limitations

- The kernels are synthetic loops. Results come from one host (the 9700X) and one clang (23.1.1), on CPU 2 only:
  3 rounds of one process per binary, each binary the best of 5 repetitions.
- The compile-time comparison is one unit, at the default target.
- `scripts/strip_lock.py` removed `exclusive.sh`'s waiting messages, which name other sessions' jobs, from the logs and
  results: each waiting line and its indented title and link lines. Each file is otherwise as written.
