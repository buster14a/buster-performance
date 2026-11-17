# Scalar paths removed: the baseline host's gate (buster#2924, phase B2)

David decided on 2026-11-17 that buster keeps AVX-512 vector paths alone
([buster#2924](https://github.com/buster14a/buster/issues/2924)). A scalar path goes
once its vector path is at least as fast on the 9700X. For the baseline host's code
(`host_scalar*.h`, the `#else` arms of `#if BUSTER_HOST_VECTOR`, `BUSTER_HOST_ARCH=x86-64`)
the only common measure is the whole driver: the baseline build refuses every
`benchmark-*` command. This record times main's native Release build against its
x86-64 (baseline, scalar) Release build.

## Setup

- buster main `d1cf1fe` (logs/commit.txt), built twice on benchpress under
  `exclusive.sh` with `./build.sh --config Release`: once for the default
  `BUSTER_HOST_ARCH=native` (znver5), once for `BUSTER_HOST_ARCH=x86-64`
  (scripts/build.sh). Their hashes are in logs/compilers.sha256.
- Inputs are from the 9700X job's frozen corpus
  (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`):
  - list 1: `-c` of `sqlite3.c` (SHA-256 `0a409f16…`) with the 9700X job's
    `compile_time` options;
  - list 2: `-fsyntax-only` of the same file;
  - list 3: `-c` of Lua 5.4.8's 34 sources. The tarball (SHA-256 `4f18ddae…`)
    was downloaded fresh into the task's directory;
  - list 4: `-c` of musl's 1,336 units: the first source of each base name, as
    node-machine-census-2524-2026-11-12's census.sh took them.

  logs/inputs.txt has every input's hash.
- Each command runs on one lane (`--lanes 1`), pinned to CPU 2, writing its
  objects to `/dev/shm`. Commands: `ab --rounds 3 --cpu 2 --lock exclusive.sh`
  around `time-runs --runs 3 --copies 3` with the builds `native`, `x86-64` and
  `native-again`, in a Williams order (scripts/time.sh). That is 9 processes a
  build per round, and 3 rounds.
- A one-round trial ran first (logs/time-trial.log) and gives the same figures.

## Results

Medians over 9 processes in each round. "x86-64 vs native" is that round's
`time-runs` comparison; `native-again` is the floor.

| list | native wall (ms), rounds 1/2/3 | x86-64 wall (ms) | x86-64 vs native, wall | x86-64 vs native, user cycles | native-again vs native, wall |
| --- | --- | --- | --- | --- | --- |
| sqlite3.c `-c` | 122.5 / 122.3 / 122.2 | 400.8 / 400.3 / 401.0 | +227.2% / +227.2% / +228.2% | +257.2% / +256.6% / +258.0% | −0.24% / +0.17% / +0.05% |
| sqlite3.c `-fsyntax-only` | 99.8 / 99.9 / 99.7 | 349.2 / 348.3 / 348.3 | +250.0% / +248.8% / +249.2% | +288.2% / +288.2% / +288.0% | −0.45% / −0.58% / −0.19% |
| Lua, 34 units `-c` | 73.4 / 73.5 / 73.4 | 170.8 / 170.5 / 170.7 | +132.5% / +132.1% / +132.4% | +153.2% / +152.9% / +153.0% | −0.43% / −0.19% / −0.19% |
| musl, 1,336 units `-c` | 669.1 / 668.3 / 668.4 | 1,568.3 / 1,567.7 / 1,569.1 | +134.4% / +134.6% / +134.8% | +166.1% / +166.3% / +166.5% | +0.03% / −0.02% / −0.03% |

**The gate holds.** On every input, the baseline (scalar) build takes 2.3 to 3.5
times the native (vector) build's wall time. Copies and rounds agree within 1%.
Deleting the baseline host's code changes nothing on an AVX-512 host, which never
compiles it. The selectable twins (`--scalar`) and the fallbacks have their own
gates, module by module (#2924's phases C and D).

## Files

- scripts/build.sh and scripts/time.sh: the two steps, as run on benchpress in
  `~/buster-fast-bench/2924-claude`.
- logs/build-native.log and logs/build-x86-64.log: each build's output,
  including its wait for the lock.
- logs/time.log: the 3 rounds, every process's line and the medians.
- logs/time-trial.log: the 1-round trial.
- logs/inputs.txt, logs/compilers.sha256, logs/commit.txt: what was timed.

# B2's pull request: main against the head (b2-main-vs-head/)

Phase B2 removes the scalar host (the `#error` in `host_isa.h`, the scalar headers, every
`BUSTER_HOST_VECTOR` use resolved to the vector side). On an AVX-512 host it should change
nothing, and these two checks say it doesn't.

## Disassembly (disassembly/)

Main `2cb0a6779` (#2939's head, the same `src/` as main `05c5d95d7`) and B2's tree, both
`BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, built in a cloud
container with the same toolchain, then `objdump -d --no-show-raw-insn` per function
(`split.py`: addresses and symbol offsets masked; `compare.py`; `classify.py` without
objdump's annotations, which name whichever rodata symbol precedes an address and move with
the data's layout).

- 9,797 functions in main's executable, 9,787 in B2's. The 10 missing are command runners
  (`run_x86_zen5_tests`, `run_gnu_tests`, ...) that `main_command` now inlines: its dispatch
  lost the baseline build's benchmark refusal.
- Every other function is the same, instruction for instruction, but 12 (`classified.txt`):
  6 whose only difference is an immediate (`__LINE__` in asserts and tests whose files lost
  comment lines), and 6 test or command functions whose resolved conditions changed
  (`main_command`, `run_c_lexer_tests`, `run_checker_deferred_tests`, `run_node_census`,
  `check_test_transition_limit`, `ir_source_tests_command`). No compile path changed.

## Timing (scripts/, logs/)

Main `05c5d95d7` and the head `4348c3a18` (from a bundle; logs/commits.txt), each built on
benchpress under `exclusive.sh` with `./build.sh --config Release` (native, the 9700X), then
timed as the gate was: `ab --rounds 3 --cpu 2` around `time-runs --runs 3 --copies 3` with
`main`, `head` and `main-again`, one lane, objects to `/dev/shm`, on sqlite3.c (`-c` and
`-fsyntax-only`), Lua 5.4.8's 34 sources and musl's 1,336 units (logs/time.log).

| list | head vs main, wall (rounds 1/2/3) | main-again vs main, wall | head vs main, user cycles | main-again vs main, user cycles |
| --- | --- | --- | --- | --- |
| sqlite3.c `-c` | −0.12% / −0.24% / +0.51% | −0.20% / −0.15% / +0.28% | −0.17% / −0.31% / −0.03% | −0.08% / −0.15% / −0.16% |
| sqlite3.c `-fsyntax-only` | +0.22% / −0.48% / −0.57% | +0.13% / −0.53% / −0.60% | +0.18% / −0.08% / −0.60% | +0.11% / +0.11% / −0.39% |
| Lua, 34 units `-c` | −0.16% / −0.01% / −0.22% | −0.22% / +0.08% / −0.08% | −0.11% / −0.09% / −0.31% | −0.11% / +0.04% / −0.09% |
| musl, 1,336 units `-c` | −0.05% / −0.01% / −0.11% | +0.03% / +0.04% / −0.14% | +0.08% / +0.16% / −0.08% | +0.03% / +0.12% / −0.10% |

Main's medians over the three rounds: 122.2 to 122.8 ms for sqlite3.c `-c`, 99.5 to 100.1 ms
`-fsyntax-only`, 73.3 to 73.4 ms for Lua, 669.0 to 669.6 ms for musl. The head is within main-again's floor
on every list and round: unchanged, as the identical disassembly says.
