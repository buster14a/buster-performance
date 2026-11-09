# psABI gaps (#1832) and Tier 1's empty byval argument (#1879): 9700X evidence

Compiler issues:
- [#1832](https://github.com/buster14a/buster/issues/1832), PR [#1863](https://github.com/buster14a/buster/pull/1863), merged.
- [#1879](https://github.com/buster14a/buster/issues/1879), PR [#1939](https://github.com/buster14a/buster/pull/1939).

## Host

- The Ryzen 7 9700X (`benchpress`), kernel 6.18.50-2-lts, governor `performance`, measurements pinned to CPU 2.
- Toolchain: clang 23.1.1 and GCC 16.2.1 20260810.
- Every run took the shared lock through `~/buster-fast-bench/exclusive.sh`.
- The coordinator's direction of 2026-11-09 asked sessions to keep at most one command queued and to put an A/B in one lock hold. So `1879-ab.sh` runs its whole A/B under one hold of about 2 minutes, and `1832-run.sh` took one hold per command.

## `benchmark-calling-convention`, #1832 (`1832-benchmark-calling-convention.log`, `1832-run.sh`)

- **Base:** main `cb608c1f616f8fe26234bcaaa869caccc571de63`.
- **Head:** `7c431bac95` (PR #1863).
- **Build:** each tree was built on the host with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`.
- **Run:** `taskset -c 2 ./build/compiler benchmark-calling-convention` (seed 1, 32,768 types and calls, medians of 21 interleaved passes).
- **Rounds:** two rounds per tree, alternating base, head, base, head. The planned third round was cut when the lock queue had to be shortened.

| vector path | base | head |
| --- | --- | --- |
| classify-all 16 B, ns/type | 40.06, 40.20 | 40.93, 40.29 |
| classify-all 16 B, instructions/type | 616.14 | 620.28 |
| classify-all 64 B, ns/type | 47.56, 47.44 | 48.86, 47.97 |
| batches-16, ns/type | 30.20, 28.87 | 29.21, 29.33 |
| assign, ns/argument | 3.28, 3.27 | 3.29, 3.28 |

- The head runs 4.1 more instructions per type (+0.7%), from its two new tests in `abi_finish_passing`.
- Its times are within the spread of the two rounds.

## GCC 16 cross-check of #1863's head (`1832-gcc16-cross-check.log`)

- **Command:** `./build/compiler test-calling-convention --cross-check --seed N` for seeds 1 to 40, 10 seeds per lock hold.
- **Stopped at seed 40,** once #1863 merged.
- **GCC runs:** every one passes, at 16, 32 and 64 bytes.
- **Failures:** the only one is seed 33's compiled clang Tier 1 run, which is #1879.
- **Scope:** clang's own seeds 1 to 100 ran in a cloud container, not here.

## Tier 1 compile of sqlite3.c, #1879 (`1879-tier1-sqlite-ab.log`, `1879-ab.sh`)

**Binaries:** both built in a cloud container with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` and copied to the host.
- **Base:** main `cb608c1f616f8fe26234bcaaa869caccc571de63`, SHA-256 `9a35372f280926bcd888beb1f80f02c5105696fef8b7ac9f6f053f5a975a7c88`.
- **Head:** `dd4ec474163ea35a8140e0ec8a7da9b97219b29f` (PR #1939 before its merge of main), SHA-256 `6ec5d5b27e905a7145a30c4496790aec7e6b9c0be51364dda6f5514a571d330d`.

**Workload:**
- **Command:** `-c --tier1 -o out.o sqlite3.c`.
- **Input:** the SQLite 3.53.4 amalgamation at `~/buster-fast-bench/refine-claude/inputs/sqlite3.c`, SHA-256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189`. It's an external runtime input and isn't copied here.
- **Runner:** `taskset -c 2 ./base time-runs --runs 7 --warmups 1`, in a Williams-design order.

| | base | head |
| --- | --- | --- |
| median wall, ms (range) | 399.609 (399.226 to 400.530) | 400.424 (399.853 to 401.153) |
| median user cycles, millions | 2111.913 | 2115.159 |
| instructions | 4,936,648,3xx | 4,937,016,19x |

- Wall time is +0.20% and user cycles +0.15%; the two ranges overlap.
- The head executes 368,000 more instructions (+0.0075%). That's the new per-argument test in `ir_typed_aggregate_call`, which runs only in functions that pass aggregates.

## Limitations

- These are single-host, single-input measurements.
- The #1832 benchmark has two rounds per tree, not three.
- The #1879 A/B measures the head before main was merged into it. The merged head's change to `ir_lower.c` is the same.

## #1832 item 5: `abi_result` from a table, not kept (`1832-result-table-ab.log`, `1832-result-table-ab.sh`)

- **Base:** main `48c0839` with #1960's two-line build fix, the only change. SHA-256 `4bde44245f4f4b881c87793581407b1d172d45e7e3ea79291269616d64d177e6`.
- **Head:** the same plus `4da833f` (branch `claude/psabi-result-table-1832`). There, `abi_result` takes its registers from 64 `AbiReturn` templates indexed by the classes as they pass. SHA-256 `e02399ac8091f05155654e3c7f8b0af87991b06ac5df784e877956d8a5201a96`.
- **Build:** both with znver5 in a cloud container, copied to the host.
- **Run:** `taskset -c 2 ./X benchmark-calling-convention --only classification`, three alternating rounds in one lock hold.

| vector path | base (rounds 1–3) | head (rounds 1–3) |
| --- | --- | --- |
| classify-all 16 B, ns/type | 40.07, 40.10, 39.77 | 40.23, 39.71, 39.74 |
| classify-all 16 B, instructions/type | 620.28 | 623.28 |
| classify-all 16 B, mispredicts/type | 2.888, 2.900, 2.894 | 2.933, 2.859, 2.859 |
| batches-16, ns/type | 28.64, 28.61, 28.68 | 28.76, 28.88, 28.83 |

- **Result:** no gain.
  - classify-all is within noise; batches-16 is 0.5% slower in every round.
  - The head runs 3 more instructions per type.
  - Mispredicts are unchanged, so `abi_result`'s branches on the classes weren't the cost.
- **Decision:** not proposed for merge.
