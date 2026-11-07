# Target-feature emission isolation, issue #891 / PR #1313

This bounded record compares source snapshot main `25a3fdb1d76ed4f440e8b4e99e10722a0f1304a7`, the original PR head `5929d0e2e2ab5a179313c082811b59a3ccdd0e0d` integrated with that main, and the current isolated-test head `eb40d4a401d4dc696df0ea7e5ba3e09d7fe7cc1a`.

The current head retains every original fixture record and the preamble byte for byte, and compiles the emission oracle module separately from the production checker. The private callback interface reuses the existing process helpers and test state. It changes no fixture expectation or production warning walk.

## Results

Ryzen 7 9700X, pinned CPU 2, official Clang 23.1.4, CMake 4.4.3, Ninja 1.13.2, Release `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`. The GitHub runner's start/completion hooks held and released the shared hardware lock. The native comparison took one bounded CI job; it was not run concurrently with another host user.

| Mode | Main median instructions | Original PR integrated median | Current head median | Original paired delta vs main | Current paired delta vs main |
| --- | ---: | ---: | ---: | ---: | ---: |
| whole compile, seven pairs | 1331266582 | 1331265702 | 1331266248 | -880 | -328 |
| syntax only, three pairs | 1057548530 | 1057547492 | 1057548175 | -1038 | -354 |
| preprocessing, three pairs | 197999446 | 197999552 | 197999515 | +106 | +70 |

The current head's whole-compile paired deltas were **-359, -333, -296, -328, -303, -367, -322** instructions. The median is **-328 (-0.00002464%)**. All seven were below main. Four initial main A/A counts were 1,331,266,605 / 1,331,266,606 / 1,331,266,600 / 1,331,266,603. Later main counts varied over a wider 33-instruction range, retained in the raw data.

Every measured object had SHA-256 `191eae04d79d452b48af6f49907eefb8dac4709f935f49fc2ae63a6a7fe4cb33`. Preprocessing outputs also agreed byte for byte. Every instruction counter ran for 100% of its interval. Binary hashes were checked again at the end.

**Limits:** whole-process numerical equality was not observed. This is no observed instruction regression on the specified no-target-attribute input, not a general throughput or speedup claim. The isolated head also counts more instructions than the original PR integrated with the same main; isolation is not claimed as a speedup. The checker string pools have identical string multisets but different byte ordering, confirmed by an independent hosted artifact inspection; their hashes differ. Binary/data placement can change unrelated executed library paths. These observations do not attribute every residual.

## Inputs and identities

- Frozen SQLite: `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
- Frozen predefines: `provenance/gnu17-pinned-predefines.txt`, SHA-256 `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
- Main tree: `3be16b2d1910c27040f0db6350576bbb29b2d5f6`.
- Original PR integration tree: `668c2e7b486d17b346594f209c3cc189aa8945af`.
- Current head tree: `a8f009a1e65c8bb92f68efe37fc0c453a609da06`.
- Main binary SHA-256: `4efdc40e4f05fa15b7fc6e266071f892146dfd457ad5602f98ca352dbd42c006`.
- Original integration binary SHA-256: `901c844133c9a26ed198617a3741cd372c5373bdc8c5fa2148a5312c1d4a288f`.
- Current head binary SHA-256: `28c93a9852941ab12e47c6b88cb896df77de80062ba86b1b1a419f4c924d226e`.
- Kernel: `6.18.50-2-lts`. perf: `7.2.9-1`. The full native log records toolchain revision and executable paths.

## Method and reproduction

[Native run 42372623025](https://github.com/buster14a/buster/actions/runs/42372623025/job/128403712819) used the immutable workflow at Buster commit `535880184f4f055048600fa743720b8ad5bee542`. Its admission job required the two successful hosted validations of the exact source head from run `42370777091`.

See [native.sh](harness/native.sh) and [qualification.yml](harness/qualification.yml). The inline native script is copied with only a shebang and license header added. Reproduction requires the approved host, the runner account's private cached trees, the official toolchain environment, a fresh `RUNNER_TEMP`, and `GITHUB_RUN_ID`. Run through the existing CI hook lock; a direct session must follow the repository's per-run exclusive-lock rules rather than holding the host across a campaign.

The script checks all three source tree identities before builds, verifies SQLite and records the predefines hash, copies each checked binary to one common executable path, uses identical argv and output paths, warms each copied binary before its sample, and alternates main/PR/head order by triplet. Each measurement runs `taskset -c 2 perf stat -x, -e instructions:u`; nonnumeric counts or multiplexing fail the run. It verifies object/preprocessing identity and rereads binary hashes.

The frozen predefines/header paths and the four SQLite configuration macros are preserved in the exact argv. Clang's `--no-default-config` is absent: the benchmark adapter filters that oracle-only option, while the compiler's C driver rejects it.

## Correctness

Both hosted builds of `eb40d4a4` passed:

| Build | Focused program selection | Complete checker driver | Standalone CC compatibility |
| --- | ---: | ---: | ---: |
| x86-64 | 5702 / 0 failures | 69233 / 0 failures | 394 / 0 failures |
| native | 5702 / 0 failures | 69223 / 0 failures | 394 / 0 failures |

The integrated CC compatibility section passed 397 checks in each driver run. The current PR also passed all eight required hosted correctness shards, the build/PGO and self-host bootstrap checks, and policy/DCO checks. A draft's required aggregate withholds hardware readiness; that is separate from these observed passes.

## Retained evidence

- [counts.csv](counts.csv): all 43 uninstrumented measurements, without duplicating the log's final CSV echo.
- [raw/native-measurement.log](raw/native-measurement.log): full runner log including every raw perf event, interval, hashes, lock receipt, command, and source identity.
- [raw/validation-native.log](raw/validation-native.log) and [raw/validation-x86-64.log](raw/validation-x86-64.log): full hosted source validation logs.
- [raw/diagnostic-inspection.log](raw/diagnostic-inspection.log): rejection of the oracle-only flag and string-multiset comparison.
- The original native artifact is linked from run `42372623025` (artifact `13573794198`, ZIP SHA-256 `145f4911e86bb3930230f3be92df70e20cccf0a81c330ff30cd018e1764681a3`); its original retention is 14 days. Binary string-pool dumps and full build captures are in that artifact and are reproducible from the source pins; no permanent-archive claim is made for that temporary artifact.
- Failed setup attempts `42371322942` and `42372086806` produced no instruction measurements; they are not silently counted as successful samples.

## Provenance

Original measurement harness, analysis and test-isolation changes by a maintainer-directed agent session. Clang is the behavioral oracle; the system compiler, debugger and perf are external tools. No external implementation or fixture corpus is incorporated here. Existing source/component terms remain unchanged.

---
Agent session: 01a1b5d1-925f-70a4-9d45-2288a31f7043 (OpenAI Codex session ID; no private share URL is exposed)
Model: OpenAI / GPT-6 (Codex)
