# MSVC-compatible lexer operations with original native code generation

Compiler PR: [buster#415](https://github.com/buster14a/buster/pull/415).

## Source and host

- Original implementation: Buster `e60251dfa1a1a61557688ba7490f86285b164e09`.
- Final implementation: Buster `cf147dc3257615680a7e694ffc25d87a3cc2576b`.
- Final lexer SHA-256: `9fc89d629433434a15e31cab6dc223cdc4fbda4bdbae96bf3449789240f69335`.
- Original lexer SHA-256: `44714f1ea75b3855215122e6af6a118fdc084ac057d6ca2741c969c93eea5b40`.
- Approved Ryzen 7 9700X host, Clang 23.1.1, optimized native builds without debug information. Timing is pinned to CPU 2; every build, test and measurement takes the shared `exclusive.sh` lock separately. Host, compiler, linker, CPU governor, SMT state and source fingerprints are retained below `final/`.

The final native path uses guarded `vector_size` expressions instead of implementation uses of `ext_vector_type`. Its operations expand to the original expressions. MSVC uses an intrinsic-backed union with eight addressable 64-bit lanes; size and alignment are checked at compile time. Input-language support and test source fixtures are unchanged.

## Machine-code identity

The complete standalone lexer assembly, including scalar paths and all vectorized language modes, is byte-identical: **58,471 lines** in each file, SHA-256 `97fa0cad6e1d39f12b76df3e071de856910eda3483bb27deeb0ed29ec0aaec07`. The compressed assembly and comparison receipts are in `final/codegen/`.

Normal, non-variant compiler builds also have identical **20,131,051-byte `.text` sections**, SHA-256 `d3203569883b1878f9e8384dcc2ba51985129a8a0b4ce46840b6649ab7890892`, and identical read-only data, SHA-256 `911feb1f6edf8a0db3d626b45487cd9525a4f859b0d7b981a271c6c55ffb3800`.

As-built executable hashes matched at `048677da2f38d005a25cd8b0db923629d648d10b550b2857f0e20f464c146316`. GNU `objcopy --dump-section` rewrote ELF metadata during inspection; after the same inspection both complete executables compared equal and hashed to `7ceafdf3fca714384b8274313a288ed38dc1cecac68424915607b2d810085bdc`. The receipts retain both observations. No bytes of machine code or read-only data were normalized or patched for comparison.

The final parser change replaces the unused typedef with a comment of the same line count. This preserves assertion line-number immediates as well as the functional code. An earlier build differed only in 36 bytes of those immediates; the final build removes even that difference.

## Correctness and workload coverage

The standard C lexer, C++ lexer, C lexer without digraphs/line comments, and `test-parser --clang` passed. The retained logs include random inputs, guarded page edges, raw strings, numeric fixtures, 307 parser snippets, 19,648 parser alignments and deep nesting.

The repository's lexer-variant harness checked the final native implementation, an identical-source control, the original implementation and a diagnostic copy forcing the MSVC vector-operation branch. All outputs matched the scalar oracle and each other on every file:

| Frozen input | Selected files | Bytes |
| --- | ---: | ---: |
| Repository C snapshot from `8169810` | 446 | 21,407,697 |
| Zig libc C corpus | 8,983 | 93,836,361 |
| C++ headers | 8,935 | 115,057,429 |

`final/inputs/` fingerprints the entire input directories, including files not selected by the benchmark's extension/text filters. Each variant measurement used three independent processes, each with 21 rotating passes. The diagnostic MSVC copy changes only the vector-operations conditional; GNU attributes and barriers remain appropriate for executing that copy on Linux. Its Clang timings are diagnostic, not native MSVC performance evidence.

The lexer source is identical between `50fa33d` (the variant build) and final `cf147dc`; the latter only restores parser source-line constants. Both parser fingerprints are in `final/variant-and-sources.sha256`.

Windows-target `clang-cl /TC /std:c11 /O2` compiled the full lexer wrapper to a COFF object with warnings treated as errors. This used freestanding standard-library declarations, not a Windows SDK integration build. Native Microsoft `cl.exe` execution and performance remain unverified.

## Performance acceptance and CI

The [completed review acceptance supplement](review-acceptance/README.md) records
twelve three-round repository `ab` matrices on frozen inputs: all lexer modes
requested by review, SQLite/main.c preprocessor phases, and whole-driver
preprocessing/parsing in ordinary and `--after-scalar 200` conditions with peak
RSS. All 432 measured driver subprocesses exited successfully. Across all
sixteen comparisons, the largest absolute difference of wall-time medians was
0.59%; the largest peak-RSS median difference was 16 KB. The report retains
counters, run-to-run ranges, complete logs and reproduction commands.

Native performance is preserved by **complete executable identity**, not by treating small timing differences between differently placed functions as an optimization. The normal original and final executables compare equal after identical section inspection; their as-built hashes also matched. No speedup is claimed.

The repeated same-binary variant logs are retained as correctness and code-placement controls. Baseline and identical-source control copies have the same generated code; their small timing differences illustrate placement and runtime noise. A diagnostic intrinsic-only copy has different Clang timings, which do not establish native Microsoft compiler performance.

An earlier separate-executable A/B attempt was stopped while queueing after its first baseline run. Its partial log is retained as `final/production-ab-incomplete.log.gz` for completeness and is **not** counted as a completed comparative timing experiment. The completed review acceptance supplement above supersedes that attempt.

[PR CI run 40180197108](https://github.com/buster14a/buster/actions/runs/40180197108) passed for final PR head `cf147dc3257615680a7e694ffc25d87a3cc2576b`. The full CI log is retained as `final/ci-final.log.gz`.

## Reproduction

Use separate Buster checkouts at the original and final revisions. For each, from its repository root:

```sh
EXCLUSIVE_OWNER=msvc415 EXCLUSIVE_TITLE=msvc415 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/415 \
  ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh
```

Standalone assembly was emitted from `src/buster/compiler/c_lexer_variant.c`, with the same exported name `c_lexer_variant_compare` and each lexer's absolute path supplied as `BUSTER_LEXER_VARIANT_SOURCE`. Flags were `-S -O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror`. Debug information was omitted from both captures. Compare the resulting assembly with `cmp`, without normalization.

For the variant check, use the repository's existing `./build.sh lexer-variant` with `control`, `baseline` and diagnostic `msvc` copies, then run `benchmark-lexer` on each frozen input under the shared lock and `taskset -c 2`. Corpus paths and full raw output are retained in the logs.

## Retained prior result and provenance

`initial-head/` retains the earlier `8169810` all-intrinsic implementation's measurements. Those showed small workload-dependent differences and did not establish performance neutrality. They are historical evidence, not the final implementation's acceptance results.

The assembly is generated from Buster's mixed-source lexer. It retains that component's MIT, applicable upstream Apache/LLVM and Unicode terms as identified in Buster's source header and `THIRD_PARTY_NOTICES.md`; it is not relabeled as wholly first-party material. The relevant license texts remain in this repository's `LICENSES/`. Original measurement reports and receipts use the repository's existing default terms. Clang was used as an external compiler; no external compiler implementation was imported. The corpus sources are external runtime inputs and are not incorporated here.
