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
