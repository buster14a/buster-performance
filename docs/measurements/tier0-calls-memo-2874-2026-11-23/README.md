# Tier 0: a call's records from a memo of the thread's (buster#2874's piece 3), 2026-11-23

[buster#2874](https://github.com/buster14a/buster/issues/2874)'s piece 3, as
[its specification](https://github.com/buster14a/buster/issues/2874#issuecomment-7097890142) has it: each `CALL`
entry's records counted and written from a per-thread table keyed by every input `tier0_emit_call` reads, with the save
area's base and displacement and the callee's symbol patched in. Asm bodies, aggregates, result objects, snapshots and
masks take today's emitter. Gate: `tier0` 0.30 ms lower or more on `-c sqlite3.c`, refuted under 0.15, every object
unchanged.

**Result: exact, and 0.200 ms lower on main `9d927943`, 0.258 ms lower on main `e5c975f1`, where the pull request is
rebased: the gate missed, not refuted.**

## What was measured

- **Revisions:** buster main `9d927943` (`bin/main`), and the piece on it (`scripts/calls-memo.patch`, the pull request's
  commit; `bin/memo3`). Two earlier forms were measured on the way (`bin/memo`, `bin/memo2`), below.
- **Builds:** Release, `BUSTER_HOST_ARCH=znver5`, built in a cloud container with CI's staged toolchain (LLVM 23.1.4) and
  copied to the 9700X stripped (`binaries.sha256`).
- **Runs:** the 9700X, CPU 2, under the lock, one hold a set (`scripts/ab.sh`). Main and the piece compile `sqlite3.c`
  in turn, 9 rounds; `scripts/abtable.sh` prints the medians. The flags and corpus are
  [the row's record](../tier0-row-main-2874-2026-11-23/)'s.

## The A/B (`results/ab-memo3`, medians of 9, ms)

| stage | main | the piece | change |
| --- | ---: | ---: | ---: |
| `tier0` | 4.787 | 4.587 | -0.200 |
| `emit-setup` | 1.045 | 1.010 | -0.035 |
| `branch-sizing` | 0.421 | 0.431 | +0.010 |
| `encode` | 0.339 | 0.339 | 0.000 |
| `unwind` | 0.215 | 0.221 | +0.006 |
| the compile | 115.264 | 115.047 | -0.217 |

Every round: main's `tier0` 4.744 to 4.808, the piece's 4.563 to 4.773. Both objects hash `ea9b6d14…8088`.

## On today's main (`results/ab-branch`, medians of 9, ms)

Main moved to `e5c975f1` before the pull request went up. #3388 had added a `vzeroupper` before a dirty function's calls
(`Tier0Function.zero_upper`), an input of the call's records, and the key now holds it (`tier0_call_zeroes_upper`).
`bin/main2` is main `e5c975f1`; `bin/branch` is the pull request's commit on it.

| stage | main `e5c975f1` | the pull request | change |
| --- | ---: | ---: | ---: |
| `tier0` | 5.032 | 4.774 | -0.258 |
| `emit-setup` | 1.034 | 1.013 | -0.021 |
| the compile | 116.155 | 115.892 | -0.263 |

Every round: main's `tier0` 5.002 to 5.079, the pull request's 4.755 to 4.821. Both objects hash `f4149786…3e3f`. On
the rebased tree, 2,928 compiles gave every object as today's main does, and `test-tier0 --cross-check` passed 21,675,526
checks. Its new check (a function compiled again with an empty table must get the same code) fails on 221 functions
when the key lacks the vzeroupper's bit, with the twins' check (`tier0_compile_scalar`, which #2924 removes) taken out.

## The forms measured

| form | the hit's path | `tier0`, main to it | |
| --- | --- | --- | --- |
| first (`bin/memo`, `results/ab-memo`) | a byte key built an argument at a time, hashed a word at a time, `memcmp` and `memcpy` | 4.784 to 4.696 | -0.088 |
| second (`bin/memo2`, `results/ab-memo2`) | the key one 512-bit vector (masked loads of the locations and classes, `valignq`), hashed by `vpmullq` and a sum, compared by one `vpcmpq`; the records written four a masked store, the saves' displacement and base by masks from `pdep` | 4.780 to 4.578 | -0.202 |
| the commit (`bin/memo3`, `results/ab-memo3`) | the second, its arena's size in whole pages | 4.787 to 4.587 | -0.200 |

The repeat knob of [the row's record](../tier0-row-main-2874-2026-11-23/) puts a call's count and emission at about 175
cycles warm. On `sqlite3.c` 12,851 calls take their records from the table, and the emitter runs 1,656 times (the keys'
first calls and the calls with no key; gdb's counts of `tier0_call_memo_write` and `tier0_emit_call`, one lane). The
first form saves about 37 cycles a call and the second about 85. The second's gain over the first is its loops' and libc calls' branches and its chains of dependent
loads, gone from the hit's path; what it keeps of a call's cost is the entry's value, its call row and its arguments,
loaded one after another.

## Exactness

- `results/exact/`: `-c` by main and by each form, the objects compared byte for byte (`scripts/exact.sh`, in a cloud
  container, `native` builds). The inputs are `sqlite3.c` with and without `-g`, Lua 5.4.8's 34 files, musl's 1,337
  units, the compiler's `main.c` and `tests/**/*.c`: 2,913 compiles. Every one gave the same object, or failed with the
  same output on both (1,922 built).
- `results/test-tier0-v*.txt`: `test-tier0 --cross-check`, 21,620,886 checks, none failed.
- The correctness inventory's 36 blocks that name Tier 0, the emission, c-testsuite, the executables and the lowering:
  35 passed, one skipped (SQLite's Tcl suite, which needs `testfixture`).
