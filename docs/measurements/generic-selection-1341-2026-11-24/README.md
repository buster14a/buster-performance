# Static-selection checking on the Ryzen 7 9700X

On November 24 main (`7515714d0`), `check-program` scaled approximately linearly from 250 to 4,000 functions containing one `_Generic` each. On the historical self-compile workload, median wall time fell from **4.434 s to 1.686 s**. The pre-#1049 compiler took **1.443 s** on the same bytes. Current main recovered **91.9%** of the wall-time regression and remained **0.243 s (16.8%)** above that baseline. [Buster issue #1341](https://github.com/buster14a/buster/issues/1341)

## Generated functions

Median `check-program` time in milliseconds, three successful processes per cell, from the repository’s `generic-scaling` benchmark on CPU 2. Each doubling of the function count cost 1.81–2.11× on current main. The regressed compiler took 3.99× as long for its last doubling.

| Functions | Before #1049, `aca9e53aa` | Regressed, `9e7f918f3` | November 24 main, `7515714d0` |
| ---: | ---: | ---: | ---: |
| 250 | 0.118 | 1.017 | 0.212 |
| 500 | 0.291 | 3.194 | 0.400 |
| 1,000 | 0.382 | 10.759 | 0.725 |
| 2,000 | 0.784 | 40.816 | 1.367 |
| 4,000 | 1.881 | 162.809 | 2.881 |

## Historical self-compile

The official `ab-self` benchmark rotated the three builds across three rounds on one regenerated, preprocessed input from the historical `9e7f918f3` source. Each process exited successfully. The regressed build emitted 85 `-Wunused-value` warnings per run on this input. The pre-#1049 and current builds were diagnostic-free. Wall time measures the whole process. Stage times come from the compiler.

| Build | Wall median, ms | Wall range, ms | check-input median, ms | check-program median, ms |
| --- | ---: | ---: | ---: | ---: |
| Before #1049 | 1,443.018 | 1,441.651–1,448.176 | 888.040 | 101.632 |
| Regressed | 4,434.291 | 4,428.717–4,468.110 | 1,086.092 | 2,891.171 |
| November 24 main | 1,685.552 | 1,682.315–1,688.937 | 917.860 | 419.461 |

In a second rotated run on the same input and current binary, default warnings took 1,680.533 ms and `-w` took 1,370.606 ms. `check-program` fell from 420.703 to 114.074 ms. This control measures the combined cost of warnings. A separate `perf record -e cycles:u -c 100003` run attributed 26 of 89,837 samples (0.029%) directly to `check_common_unselected_roots_indexed`, with zero lost samples. Its predecessor accounted for 37.5% of a November 6 self-compile profile. [Earlier profile](https://github.com/buster14a/buster/issues/1341#issuecomment-6680462914)

An independently locked pre-#1049 control took 2,848.619 ms, including 1,412.573 ms of system time and 328,138 minor faults. The three rotated pre-#1049 runs each had about 36,500 minor faults. All standalone controls, including this outlier, are recorded separately in `runs.tsv`.

**What the inputs exercise.** The regenerated historical source has 389 text matches for `_Generic`. Clang’s token dump yielded zero `_Generic` keywords and 381 `__extension__` tokens. For example, the input contains C test programs stored as string literals. Buster also represents `__extension__` as a selection. The generated workloads directly exercise `_Generic`; Clang independently counted 250 and 4,000 keyword tokens at the endpoints. The November 24 self input has zero `_Generic` keywords and 276 `__extension__` tokens. The token counts apply to the measured files. [Selection implementation](https://github.com/buster14a/buster/pull/1516)

November 24 main also compiled its own 11,664,987-byte preprocessed source in **513.522 ms** median, including **73.683 ms** in `check-program` (three runs). The separate historical workload above preserves the roughly 36 MB comparison used by the issue.

## November 23 measurements across the merge

The previous issue claimant collected these runs on benchpress. I recovered the original logs and checked all 123 for a complete stage table and diagnostics. The 33 self-compile logs also record successful process exit codes. The 90 generated-unit logs contain stage output but the older driver did not save individual exit codes for them. Its generator produced byte-identical files to `uarch generate-generic` at all five sizes. [Claim and scope](https://github.com/buster14a/buster/issues/1341#issuecomment-7087790113)

| Buster revision | Historical source, wall ms | Historical source, check-program ms | November 22 source, wall ms | November 22 source, check-program ms |
| --- | ---: | ---: | ---: | ---: |
| `437ccbbc3`, first parent of the #2669 merge | 1,725.1 | 401.7 | 564.3 | 100.8 |
| `ad415ef91`, #2669 merged | 1,720.4 | 403.6 | 563.3 | 100.0 |
| `4704727a1`, November 22 main | 1,652.1 | 360.7 | 513.2 | 63.4 |

Wall and stage times are medians of five rotated rounds on the historical source and six on the November 22 source. On the historical source the last round included a 4.25 s merge-revision outlier. The first round on the November 22 source also logged three disk-full errors while the lock wrapper wrote its owner file. Its compiler processes exited successfully. Every observation is included in the medians. The two inputs have different sizes and separate rows in the raw table.

| Functions | Before #2669, ms | #2669 merged, ms | November 22 main, ms |
| ---: | ---: | ---: | ---: |
| 1,000 | 0.738 | 0.724 | 0.582 |
| 2,000 | 1.365 | 1.358 | 1.145 |
| 4,000 | 2.917 | 2.881 | 2.656 |
| 8,000 | 6.156 | 5.746 | 5.112 |
| 16,000 | 12.545 | 11.758 | 10.513 |

These are median `check-program` times across six rounds. The flat generated workload already scaled approximately linearly before #2669. That PR covered nested selections and chosen-arm diagnostics. [#1516](https://github.com/buster14a/buster/pull/1516) · [#2669](https://github.com/buster14a/buster/pull/2669)

## Method and reproduction

All measurements used CPU 2 on `benchpress`, an AMD Ryzen 7 9700X. Its governor and energy-performance preference were both `performance` and its SMT sibling was offline. The November 24 build used the pinned Clang 23.1.4 toolchain. The shared host lock covered each benchmark step. The archived November 23 run took the same lock once per rotated round.

1. Build Buster `7515714d05caa655e8c2e1e2776e07aa9b8058df` with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release`. The November 23 builds used `./build.sh --config Release` with the default native host target. Their build logs and binary hashes are in the evidence archive.
2. Fetch the November 4 executable archive and verify its published SHA-256 manifest. The `pre1049` and `regression` binaries are the released `compiler-pre1049-znver5` and `compiler-znver5`, at `aca9e53aa` and `9e7f918f3` respectively. [Original release](https://github.com/buster14a/buster-performance/releases/tag/microarchitecture-two-hosts-2026-11-04)
3. For the historical workload, preprocess `src/buster/compiler/main.c` from `9e7f918f3` using the November 22 compiler `4704727a1` and `-E -march=znver5 -Isrc -fwrapv -funsigned-char`. The saved 36,138,597-byte file contains 389 text matches for `_Generic`. Every compiler in the same-input comparison read this file, SHA-256 `9c0a4c3f35c1024255cb3b910eb83eed01620c2271b471635620fc51c43af8c7`. Both days used the same predefines, SHA-256 `40c31757e3ffd1ce3f95f79ee9ba347ba97ba893aa66f6e69df4cc9e3b344c58`.
4. The November 4 record used a 36,149,566-byte file from the same source, SHA-256 `ff2cd38f71e54cc63669006cf9e84dae1a5eac79c79613e8646f937abe941489`. An independent preprocessing attempt with its released `compiler-znver4` and the host headers and the pinned Clang 23.1.4 predefines produced a third hash. The tables compare like bytes within each date. [November 4 input and host identities](../microarchitecture-two-hosts-2026-11-04/zen5-9700x/env/sha256.txt)
5. Build `tools/microarch/uarch.c` from `7515714d0` with `clang -std=c17 -O2 -Wall -Wextra -Werror -o uarch tools/microarch/uarch.c -lm`. Generate each unit with `./uarch generate-generic N > inputs/generic-N.c`, substituting the function count for N. The November 24 campaign used Buster’s `tools/microarch/run.sh` and its shipped 9700X profile. Its `ab-self` step rotates the order of the three binaries each round and records whole-process wall time and `--time-stages`. Its `generic-scaling` step runs each size three times, writes a completion marker only after a successful exit, and records stage times. `runs.tsv` includes every sample. The rows labeled `standalone-reference` are individually locked preliminary observations and are excluded from the three-round tables.
6. For reproduction, extract the released binaries under `historical/`, place the November 24 checkout under `src/`, and put the files from step 3 under `inputs/reference.i` and `inputs/predefines-znver5.h`. Preprocess November 24 main under the lock from the checkout directory with its own compiler and `--predefines ../inputs/predefines-znver5.h -march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing -Isrc -E -o ../inputs/current.i src/buster/compiler/main.c`. Run `bash campaign.sh` from the measurement directory. The supplied profile wraps the host’s existing lock to save before/after load and memory snapshots. [Campaign](campaign.sh) · [Profile](host.sh)

The warning control reused the reference campaign in a fresh root with `AB_BUILDS="current current-w"` and the same `ab-self` step. `compiler-current-w` runs `exec "$REPOSITORY/build/compiler" -w "$@"`; its complete wrapper is in the archive. The separate user-cycle profile ran `taskset -c 2 perf record -q -e cycles:u -c 100003 -o logs/profile.data -- src/build/compiler -fsyntax-only --predefines inputs/profile-predefines.h -march=znver5 -fwrapv -funsigned-char -fno-strict-aliasing --time-stages inputs/profile.i` on copies of the reference input and predefines. The `perf report` table uses direct symbol samples.

The token counts used Debian Clang 22.1.8 on the saved inputs. Run `clang -std=gnu17 -fsyntax-only -Xclang -dump-tokens -x cpp-output FILE` and count the first column equal to `_Generic`, `__extension__` or `__builtin_choose_expr`. All four token dumps reached EOF.

The archive includes the stage logs, compiler and input identities, build records, lock and load observations, and the flat user-cycle profile. The November 23 data came from the original claimant’s `/tmp/c1341/w/s1341` directory on benchpress. Wait notices identifying unrelated lock holders are omitted. Blank wall time or exit status fields mean the original driver did not record them. [All runs](runs.tsv) · [November 23 raw evidence](nov23.tar.gz) · [November 24 raw evidence](nov24.tar.gz)
