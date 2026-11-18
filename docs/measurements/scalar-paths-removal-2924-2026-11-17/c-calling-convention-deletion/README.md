# The calling convention's deletion (#2924, C5)

buster's `c5-calling-convention` (the PR's branch) against main, on the 9700X: Release builds, every run under the
lock, timings on CPU 2 ([`run.sh`](run.sh), [`objects.sh`](objects.sh), [`disassembly/`](disassembly/)).

- **[`logs/`](logs/):** the final head `8a720d99e` against main `56e93bf02`, which is after #2954.
- **[`logs-first-head/`](logs-first-head/):** the first run, the deletion's head `71f6caa16` against `bd197b2a6`. It
  found the start-order regression below.

The gate is in [`../c-calling-convention-gate/`](../c-calling-convention-gate/).

## What the head is

| Commit | What |
| --- | --- |
| `8ddbc1e6e` | The tests check each route on its own and never against the other: the vector paths, and their fallbacks. |
| `86e7e8a4b` | The deletion. The benchmark times the vector paths alone. |
| `8ce3d732b` | The docs. |
| `84198009b` | The start order names `abi_classify_all` (below). |
| `8a720d99e` | A chain of records against the table's order, for the scheduler's scan (the mutation check, below). |

The tests' fallback routes:
- **classification:** `abi_classify_scalar`, driven as the scheduler's scan drives it;
- **assignment:** `abi_assign` with every scratch arena exhausted, which runs `abi_assign_call` per call.

**Deleted:**
- `abi_classify_all_scalar`;
- the classification scheduler's `scalar` parameter;
- the checker's three selections, which now call `abi_classify_all` and `abi_assign`:
  - classification by `--scalar`;
  - assignment by `--scalar`;
  - `va_start`'s single signature, which always took `abi_assign_scalar`.

**Kept** as the vector paths' fallbacks (phase D):
- `abi_classify_scalar`, for a level whose fold has no scratch room and for the scheduler's scan;
- `abi_assign_scalar` and `abi_assign_call`, for scratch exhaustion and for the calls the prefix sums can't place.

## Results ([`logs/`](logs/))

- **Tests:**
  - `test-calling-convention --cross-check` passes against clang and GCC at all three widths, Tier 0 and Tier 1,
    every check with 0 failures;
  - `test-calling-convention --seed 9 --count 600` passes.
- **Objects:** `-c` of sqlite3.c, Lua 5.4.8's 34 units and musl's 1,336 units, by base and head, default and
  `--scalar`. All 1,371 objects are identical in both modes.
- **Whole compiles:** `ab` around `time-runs`, 3 rounds of base, head and base-again, 9 runs each. Head's user
  cycles against base, by round:

  | List | Round 1 | Round 2 | Round 3 | base-again's range |
  | --- | --- | --- | --- | --- |
  | `-c` sqlite3.c | +0.03% | -0.12% | +0.12% | -0.09% to +0.14% |
  | `-fsyntax-only` sqlite3.c | -0.17% | +0.06% | -0.29% | -0.24% to +0.11% |
  | `-c` Lua | -0.20% | +0.13% | +0.13% | +0.30% to +0.53% |
  | `-c` musl | -0.47% | +0.01% | +0.37% | -0.37% to +0.13% |

  Head's deviations, at most 0.47% and of both signs, are the size of base-again's, at most 0.53%. Wall time
  follows.
- **`benchmark-calling-convention`:** the medians of three processes. The base runs both paths; the head runs the
  vector path alone and checks the frozen digests.

  | Row | Base's vector path | Base's twin | Head | Head / base's vector path |
  | --- | --- | --- | --- | --- |
  | classify-all, 16-byte vectors | 40.56 ns/type | 68.39 | 40.61 | 1.001 |
  | classify-all, 32-byte vectors | 44.80 | 69.62 | 45.04 | 1.005 |
  | classify-all, 64-byte vectors | 47.91 | 70.53 | 48.19 | 1.006 |
  | batches of 1 type | 35.36 ns/type | 54.68 | 34.75 | 0.983 |
  | batches of up to 4 | 32.43 | 55.86 | 31.24 | 0.963 |
  | batches of up to 16 | 29.96 | 54.98 | 28.97 | 0.967 |
  | assign | 3.45 ns/argument | 9.52 | 3.35 | 0.971 |
  | assign-simple | 2.90 | 8.85 | 2.88 | 0.993 |

  `assign` left 5.17% of its arguments (567 calls, 1.73%) to `abi_assign_call`: 219 inexact, 364 padded, 18 empty.
  Seed 7, with 20,000 types and calls, passes with no digests to match.
- **Disassembly:** only the calling convention's functions and the checker's callers differ ([`logs/compare.txt`](logs/compare.txt)).
  `check_input_count_tokens.specialized.2` differs too: clang specialized it otherwise, with the same objects.

## The start order

**The regression** ([`logs-first-head/`](logs-first-head/)). Without its `scalar` parameter, `abi_classify_levels`
inlines into its one caller, `abi_classify_all`, which `cmake/BusterStartOrder.txt` didn't name.
- The checker's copy landed in cold `.text` (0x1f8c560), where base's `abi_classify_levels` had been in
  `.text.buster_start` (0x1088af0).
- `abi_assign_call` stayed in the start's section and lost only its `.buster_split` alias.

**The fix** (`84198009b`). The list names `abi_classify_all` before `abi_classify_levels`. In the final run the
functions only base has in `.text.buster_start` are `abi_classify_levels` and the two aliases, and the only ones head
alone has there are `abi_classify_all` and its alias (`logs/*-functions.txt`, `logs/*-sections.txt`).

## The benchmark's frozen digests ([`digests/`](digests/))

The digests were made on main `bd197b2a6`, where each vector path still had its twin.
- **The method:** [`benchmark-digests.patch`](digests/benchmark-digests.patch), with
  [`driver.c`](digests/driver.c) to build the benchmark unit alone:

  ```sh
  clang -march=native -O3 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_HOST_STATIC=1 \
      src/buster/compiler/calling_convention_benchmark.c driver.c
  ```

- **The digests:** at the default seed and count, both paths gave the same digest of each classify-all table and of
  each assignment mix ([`benchmark-digests-bd197b2a6.txt`](digests/benchmark-digests-bd197b2a6.txt)).
- **The tests' digests:** made the same way with [`test-digests.patch`](digests/test-digests.patch)
  ([`test-digests-bd197b2a6.txt`](digests/test-digests-bd197b2a6.txt)).

## The mutation check ([`mutation/`](mutation/))

[`mutants.py`](mutation/mutants.py) and [`run.py`](mutation/run.py). Each mutant was built in an archived copy of the
tree and run against `test-calling-convention` at the default seed and at seed 9 with a count of 600.
- **Round 1** ([`pr.results`](mutation/pr.results)), on the deletion's tests: 12 of 13 failed. s1 survived: the
  scheduler's scan was given only tables in dependency order, where one pass in index order classifies everything.
- **Round 2** ([`pr2.results`](mutation/pr2.results)), on the final tests: all 14 fail. The fixture
  `abi_test_reversed_chain` (`8a720d99e`) is a chain of 80 records completed from the last, which the scan takes a
  pass per link for. s2 drops the scan's classification altogether. Its first form kept `progress = true` and looped
  until the runner's 600 s timeout (`pr2-s2-scan-classifies-nothing-loops.test`). The form in `mutants.py` ends the
  scan, so the checks themselves fail it.

| Mutant | Where | Failed by |
| --- | --- | --- |
| f1, a misaligned record member isn't MEMORY | scalar classification | both seeds |
| f2, a misaligned array isn't MEMORY | scalar classification | both seeds |
| f3, a union past 16 bytes is MEMORY | scalar classification | both seeds |
| c1, stack slots aligned to 8 alone | per-call assignment | both seeds |
| c2, the hidden pointer takes no counted register | per-call assignment | the default seed's digests |
| c3, an EMPTY argument takes a slot | per-call assignment | both seeds |
| v1, a member off its alignment by one byte isn't packed | vector fold's parts | both seeds |
| v2, no padding i8 at offset 14 | vector fold's parts | both seeds |
| a1, a second vector register isn't advanced | vector assignment | the default seed's digests |
| a2, a call's stack alignment off by one | vector assignment | the default seed's digests |
| a3, inexact lanes deferred only in lane 0 | vector assignment | both seeds |
| a4, padded lanes not deferred | vector assignment | the default seed's digests |
| s1, the scan stops after 64 types | scheduler's scan | both seeds (round 2) |
| s2, the scan classifies nothing | scheduler's scan | both seeds: the short-scratch fixtures and the chain |

Four mutants fail only by the default seed's frozen digests: c2, a1, a2 and a4. Hosted CI runs that seed, and
`--cross-check` checks every assignment against clang and GCC on the 9700X.

## Sanitizers

Built locally (`BUSTER_HOST_ARCH=vector`, Release) on the final head: AddressSanitizer with UBSan, MemorySanitizer and
ThreadSanitizer. Each passes these tests:
- `test-calling-convention`, both seeds;
- `test-check-varargs`;
- `test-tier0-variadic-frame`.
