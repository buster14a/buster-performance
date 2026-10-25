# PR 415 review acceptance: native code identity and paired measurements

This supplement answers the [performance review](https://github.com/buster14a/buster/pull/415#pullrequestreview-5642320412) of Buster PR 415. Qualification compares original `e60251dfa1a1a61557688ba7490f86285b164e09` with final `cf147dc3257615680a7e694ffc25d87a3cc2576b`. It supersedes the earlier incomplete separate-executable attempt retained in the parent report.

**All twelve matrices completed successfully:** 72 A/B child invocations, 96 extracted process/list summaries, and 432 measured driver subprocesses, all with exit status zero. Across all sixteen wall-time comparisons, the largest absolute difference between final and original medians is **0.59%**. Native assembly and complete compiler executables are identical. Both inline review risks are addressed by restoring the original native expressions under the non-MSVC guard.

## Method and limits

Both normal compilers were built with Clang 23.1.1, `BUSTER_DEBUG_INFO=0 ./build.sh`, on the approved Ryzen 7 9700X. The measured complete executables have the same SHA-256, `7ceafdf3fca714384b8274313a288ed38dc1cecac68424915607b2d810085bdc`; [the parent report](../README.md#machine-code-identity) records the as-built hashes and the identical metadata rewrite during section inspection.

The repository's `head-tree/build/compiler ab --rounds 3 --cpu 2 --lock /home/david/buster-fast-bench/exclusive.sh baseline-tree head-tree -- ...` rotated base/head order by round. Each child took the shared lock separately; there was no outer lock around the series. CPU 2 used the performance governor. Its SMT sibling, CPU 10, was offline. Twelve matrices comprise 72 successful A/B child invocations. The lexer and preprocessor benchmarks each report 21-pass process medians. Whole-driver lists each have nine fresh measured subprocesses after one warm-up, giving 27 measured subprocesses per build/input/state/list and 432 measured subprocesses overall.

Tables report the median of the three process medians, followed by their minimum–maximum in brackets. These ranges describe observed spread; they are not confidence intervals. Positive head/base wall differences mean slower. Complete executable identity makes these comparisons same-code controls: differences below the observed spread do not support a speedup or a source-induced regression. No speedup is claimed. Available pass ranges and every measured subprocess remain in the logs; extracted process summaries are in `metrics.csv`.

`--after-scalar 200` runs an untimed 200 ms scalar loop on the same CPU before each timed fresh child. It applies to both whole-process preprocessing and whole-process parsing below. The preprocessor's internal 21-pass phase benchmark does not support that option; its ordinary phase numbers are reported separately. The parse list is `parse -fsyntax-only`, including process startup, input reading, preprocessing, parsing and teardown. It does not measure native code generation or linking.

## Lexer throughput, counters and correctness

Frozen inputs are identical for the two executables: repository C sources at the retained `8169810` input snapshot (446 files, 21,407,697 bytes), Zig 0.14.1 libc C/header corpus (8,983 files, 93,836,361 bytes), and C++ headers (8,935 files, 115,057,429 bytes). Full directory manifests are in [../final/inputs/](../final/inputs/). Each corpus was measured in its ordinary mode and with `--no-digit-separators`; C++ also uses `--cplusplus`. All 36 lexer invocations checked every selected file against the scalar oracle and reported zero differing files.

| Corpus / mode | Build | Wall ms | GB/s | Cycles/B | Instructions/B |
| --- | --- | ---: | ---: | ---: | ---: |
| Repository C | Original | 3.251 [3.225–3.268] | 6.58 [6.55–6.64] | 0.842 [0.835–0.845] | 2.993 [2.993–2.993] |
| Repository C | Final | 3.248 [3.236–3.261] | 6.59 [6.56–6.62] | 0.841 [0.838–0.844] | 2.993 [2.993–2.993] |
| libc C | Original | 13.494 [13.419–13.501] | 6.95 [6.95–6.99] | 0.796 [0.793–0.797] | 3.048 [3.048–3.048] |
| libc C | Final | 13.417 [13.326–13.419] | 6.99 [6.99–7.04] | 0.792 [0.786–0.792] | 3.048 [3.048–3.048] |
| C++ | Original | 19.324 [19.207–19.438] | 5.95 [5.92–5.99] | 0.930 [0.925–0.936] | 3.268 [3.268–3.268] |
| C++ | Final | 19.240 [19.197–19.440] | 5.98 [5.92–5.99] | 0.924 [0.924–0.937] | 3.268 [3.268–3.268] |
| Repository C, no separators | Original | 3.261 [3.210–3.264] | 6.56 [6.56–6.67] | 0.844 [0.831–0.845] | 2.993 [2.993–2.993] |
| Repository C, no separators | Final | 3.243 [3.239–3.253] | 6.60 [6.58–6.61] | 0.840 [0.838–0.843] | 2.993 [2.993–2.993] |
| libc C, no separators | Original | 13.453 [13.372–13.546] | 6.98 [6.93–7.02] | 0.794 [0.789–0.798] | 3.048 [3.048–3.048] |
| libc C, no separators | Final | 13.532 [13.364–13.598] | 6.93 [6.90–7.02] | 0.797 [0.789–0.802] | 3.048 [3.048–3.048] |
| C++, no separators | Original | 19.188 [19.165–19.208] | 6.00 [5.99–6.00] | 0.925 [0.923–0.926] | 3.268 [3.268–3.268] |
| C++, no separators | Final | 19.224 [19.210–19.331] | 5.99 [5.95–5.99] | 0.926 [0.925–0.931] | 3.268 [3.268–3.268] |

| Corpus / mode | Final/original median wall difference |
| --- | ---: |
| Repository C | -0.09% |
| libc C | -0.57% |
| C++ | -0.43% |
| Repository C, no separators | -0.55% |
| libc C, no separators | +0.59% |
| C++, no separators | +0.19% |

The six lexer instruction counts are identical at the printed precision in every process. The paired round wall differences span -1.24% to +1.34%; the largest difference of three-round medians is 0.59%. These are observed same-code timing controls, not an optimization claim.

## Optimized assembly, lane access and transpose

The complete 58,471-line lexer assembly is identical, without normalization: SHA-256 `97fa0cad6e1d39f12b76df3e071de856910eda3483bb27deeb0ed29ec0aaec07`. Both assembly files are retained under [../final/codegen/](../final/codegen/). Static counts cover the complete file and every generated lexer mode:

| Count | Original | Final | Added |
| --- | ---: | ---: | ---: |
| Instruction lines | 35,184 | 35,184 | 0 |
| 64-byte spill annotations | 536 | 536 | 0 |
| 64-byte reload annotations, including folded reloads | 956 | 956 | 0 |

Instruction-line regex: `^\t[a-z][a-z0-9]*([[:blank:]]|$)`. Annotation regexes: `64-byte.*Spill` and `64-byte.*Reload`. These count static assembly sites, not dynamically executed memory operations.

The final non-MSVC macros expand to the original lane operations, shifts and `__builtin_shufflevector` expressions. The original review's full-width local-array lane helpers and intrinsic transpose no longer replace the native path. All load/store, shuffle/shift selection, register allocation, loop instructions and constants are unchanged. The normal compiler's entire 20,131,051-byte `.text` and read-only data are identical too. The measured cycles/byte above qualify runtime behavior; no assembly difference remained to investigate with IBS.

MSVC retains the intrinsic-backed union operations behind `_MSC_VER`. The existing Windows-target `clang-cl` COFF probe and forced-intrinsic Linux correctness runs are retained in the parent report. Native Microsoft `cl.exe`, a complete Windows SDK build, and native MSVC performance remain unverified.

## Preprocessor phase measurements

Inputs are pinned SQLite **3.53.2** and the same frozen repository `main.c` used for both builds. This is the 9,507,037-byte SQLite amalgamation, not one of the host's differently versioned copies. Full flags are in `commands.txt`; each phase benchmark uses `benchmark-preprocessor --only vectorized`. Wall time excludes the separate release and printed-output measurements, which remain in the logs.

| Input | Build | Wall ms | Cycles/input token | Instructions/input token |
| --- | --- | ---: | ---: | ---: |
| SQLite 3.53.2 | Original | 10.530 [10.526–10.557] | 37.76 [37.73–37.95] | 118.74 [118.74–118.74] |
| SQLite 3.53.2 | Final | 10.550 [10.548–10.574] | 37.86 [37.81–37.92] | 118.74 [118.74–118.74] |
| main.c | Original | 47.016 [46.974–47.136] | 59.47 [59.43–59.61] | 222.82 [222.82–222.82] |
| main.c | Final | 47.039 [47.021–47.166] | 59.62 [59.59–59.73] | 222.82 [222.82–222.82] |

Median phase wall differences are +0.19% for SQLite and +0.05% for main.c. Retired instructions/input token are identical at printed precision.

## Whole-driver wall time and peak RSS

Each row compares the same command/input under both executables. RSS is Linux `wait4` peak resident memory in KB. The displayed RSS values are medians of the three nine-process RSS medians, with the range across those medians; individual subprocess RSS values are retained.

| Input / state / process | Original wall ms | Final wall ms | Difference | Original peak RSS KB | Final peak RSS KB |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite / ordinary / -E -P | 17.189 [17.187–17.266] | 17.211 [17.171–17.238] | +0.13% | 61816 [60248–61820] | 61812 [61808–61820] |
| SQLite / ordinary / parse | 19.396 [19.362–19.489] | 19.381 [19.344–19.407] | -0.08% | 145176 [143528–145184] | 145164 [145156–145168] |
| SQLite / after-scalar 200 / -E -P | 17.206 [17.177–17.213] | 17.121 [17.027–17.160] | -0.49% | 61804 [60244–61812] | 61812 [61804–61820] |
| SQLite / after-scalar 200 / parse | 19.510 [19.496–19.655] | 19.446 [19.408–19.534] | -0.33% | 145156 [143528–145160] | 145168 [145156–145176] |
| main.c / ordinary / -E -P | 78.240 [78.202–78.290] | 78.136 [78.073–78.178] | -0.13% | 172104 [172100–173636] | 172120 [172112–172124] |
| main.c / ordinary / parse | 88.101 [88.095–88.262] | 87.835 [87.790–87.860] | -0.30% | 469988 [469988–469996] | 470000 [469976–471512] |
| main.c / after-scalar 200 / -E -P | 78.091 [77.986–78.156] | 78.028 [77.752–78.123] | -0.08% | 172120 [172116–172124] | 172124 [172088–172124] |
| main.c / after-scalar 200 / parse | 87.968 [87.877–88.333] | 87.800 [87.681–87.889] | -0.19% | 470012 [469988–471380] | 470008 [469960–470012] |

The largest absolute whole-driver median wall difference is 0.49%; the largest difference between peak-RSS medians is 16 KB. The complete binaries are identical, and these results are within the observed same-code runtime spread. There is no added native computation, allocation or executable layout change to attribute a slowdown to. Ordinary and after-scalar results are both retained; neither condition is substituted for the other.

## Input identity, provenance and setup diagnostics

- SQLite source: official [3.53.2 amalgamation archive](https://www.sqlite.org/2026/sqlite-amalgamation-3530200.zip), archive SHA-256 `8a310d0a16c7a90cacd4c884e70faa51c902afed2a89f63aaa0126ab83558a32`; `sqlite3.c` SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
- Frozen `main.c` SHA-256 `659fe227ea39b18e3db2d80dcab84cac86ef42b44b7fb180a0db10dd42716dca`. Its include root is the retained repository source snapshot; the full manifest is in `../final/inputs/repo.sha256`.
- Pinned sysroot: `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers/usr`. Header manifests and package provenance are retained under `pinned/`: Clang 23.1.1-1, glibc 2.44+r50+g1848099f063e-1, linux-api-headers 7.2-1, libxcrypt 4.5.2-1 and util-linux-libs 2.42.4-1.
- The older pinned sysroot's include closure lacked Linux headers newly included by the frozen repository source. Initial main.c setup pilots failed on `linux/memfd.h`, then `asm/prctl.h`; those failures are preserved and excluded from timings. Before timed main.c runs, the host's complete `linux/`, `asm/` and `asm-generic/` directories were copied into a frozen additional include root, `review/uapi`. Its package identity and file manifest are retained. Both preprocessing and parsing then passed before the timed gate opened. The timed commands resolve no headers from a live `/usr/include` fallback.
- `predefines.h` is a retained Clang 23.1.1 predefined-macro dump generated under the lock with `clang -dM -E -march=znver5 -std=gnu17 -fwrapv -funsigned-char -x c /dev/null`. It is used by both builds. This generated LLVM metadata retains LLVM's Apache-2.0 WITH LLVM-exception terms; the existing [LLVM license](../../../../LICENSES/LLVM.txt) is retained. The original collector/report tools use the repository default terms. Header/corpus implementation bodies are external runtime inputs and are not incorporated here.
- The successful main.c `-E -P` setup pilot produced a large source-containing log (combined stdout/stderr). Its size, hash and zero exit status are retained instead of the external source text.
- One input-verification setup command ran the root-relative UAPI manifest from the wrong directory and failed to find its paths. The corrected root-relative check passed; the failed invocation is retained as a setup diagnostic. This did not change inputs or measured runs.

Repository, libc, C++ corpus, pinned sysroot, SQLite and final UAPI manifests all passed their applicable frozen-input verification. Final binary, source and primary-input identities were captured again after all timings. The native executable hashes, input hashes, CPU governor and offline SMT sibling state remained unchanged.

## Retained files and reproduction

`qualification.json` names revisions, binary identity, every matrix and its expected record count. `commands.txt` gives every reproduction command. `acceptance_metrics.c` validates six successful A/B invocations per matrix, all lexer oracle checks, and all 432 measured driver child exit statuses before producing `metrics.csv`. It rejects missing rounds, duplicate records, failed children and incomplete logs.

Published logs omit only `exclusive.sh` lock-owner wait messages and their title/link continuations, which can identify unrelated private sessions. Benchmark records and diagnostics are retained unchanged. `public_log_copy.c` implements that filter; original log hashes are retained, and the parser's output from original and published logs compares equal. Gzip uses `-n`; no benchmark whitespace is rewritten.

`logs/` retains the compressed matrix and setup-diagnostic logs; `status/` retains exit statuses. Log-tool build receipts retain their exit statuses; their queue-only output is omitted.

To regenerate extracted metrics after decompressing the twelve matrix logs into one directory, build the C parser and run it under the shared host lock:

```sh
EXCLUSIVE_OWNER=msvc415 EXCLUSIVE_TITLE=msvc415 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/415 \
  ~/buster-fast-bench/exclusive.sh clang -std=c17 -O2 -Wall -Wextra -Werror acceptance_metrics.c -o acceptance_metrics
EXCLUSIVE_OWNER=msvc415 EXCLUSIVE_TITLE=msvc415 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/415 \
  ~/buster-fast-bench/exclusive.sh ./acceptance_metrics lexer-*.log pp-*.log drivers-*.log >metrics.csv
```

Final PR head CI [40180197108](https://github.com/buster14a/buster/actions/runs/40180197108) passed. This report qualifies only `e60251d` versus `cf147dc`. If integrating newer main changes executable layout, repeat qualification for that integrated revision.
