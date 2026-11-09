# Sources, extraction and retained terms

Full revision and binary/input SHA256 identities are recorded in the two
`raw/*/identities-readable.txt` receipts and generated-file manifests. The
identities receipts were made readable by replacing NUL separators from
`build.sh print-compile-flags` with line feeds; raw receipt hashes are retained
in `raw/withheld-artifact-identities.txt`. For the replay only, that diagnostic
used default shell build variables. The actual host compiler flags are the
CMake **Release** command entries and build logs: pinned Clang 23.1.4,
`-march=znver5`, `-O3`, debug information disabled. The candidate diagnostic uses
the explicit build environment as well.

## Compiler and input pins

- Base commit: `d7ccc6a32a0621c40f600e3c46645846164531cb`, tree
  `92c0ae8d7395e75267144e9765b4f7b35db3b0f6`.
- Original head: `5f995cd78669c7d3dc2f0d94a27a4a0428ada333`, tree
  `ead4ff1df663e9f1674fdfff1c2dbdd7febb3b16`.
- Uncommitted candidate: that head plus the retained patch, SHA256
  `983606b5eb4f902ca0ad74b594c44ea5a220df7e06d8cd126f6f45f9f0a85960`.
- `src/buster/compiler/c_lexer.c`: blob
  `7d5fbea87cfa0a31d126bab8d1b9cc63c548099b`.
- `src/buster/compiler/c_lexer_benchmark.c`: blob
  `43c6bb51c144b5026b993bfb8b0ddffa8a18bc3a`.
- `src/buster/compiler/host_isa.h`: blob
  `139159e5dcabf1040212c42446e461b3ee850a85`.
- `src/buster/compiler/tier1_rows_measure.c`: blob
  `83b279d07de4a4669a79ad203bc2020031805428`.
- Clang 23.1.4: LLVM `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`, binary SHA256
  `c336d48383874cffaab0dc4c5c359456d871f21380b746520dde5c7f4c125a67`.

The measured lexer translation unit and corpus input are identical across these
revisions. Generated main/row/scan source hashes are in each generated manifest;
their source literals are in the pinned measurement command. No imported corpus
or complete generated source copy is added to this package.

## Component terms

The original report and candidate selection/test changes use the existing
project `Apache-2.0 WITH LLVM-exception` terms. **The derived lexer assembly is
mixed-source material, not wholly original Apache+LLVM code.**

The lexer/benchmark port comes from Accelerated-Zig-Parser revision
`f4482e2dd53413522d75d8c254b9a824021238ce`, with Niles Salter's 2023/2024
copyright and David Gonzalez Martin's 2026 local modifications. The benchmark
and its modifications retain MIT. Identified simdjson/simdjzon-derived portions
retain Apache-2.0 without the LLVM exception; the backslash algorithm comparison
pin is simdjson `9408298e0e64fbfe79b178278b58d81bc81eb7af` with retained AUTHORS
attribution. Clang-following scalar portions and identifier representation
retain LLVM's existing Apache-2.0 WITH LLVM-exception terms, comparison pin
`llvmorg-23.1.3` / `0d261d1ca552c95a8f007e061c787ac7132fbcbc`.
Identifier data also retains Unicode License V3 and Copyright 1991–2026
Unicode, Inc. The imported table generator recorded a Clang version rather
than a recovered toolchain hash; this archive makes no stronger assertion.

The source revision's unmodified [LICENSING.md](provenance/LICENSING.md),
[THIRD_PARTY_NOTICES.md](provenance/THIRD_PARTY_NOTICES.md), project license and
applicable retained texts under `provenance/LICENSES/` accompany the excerpts.
Source-relative links in those frozen documents resolve against the pinned
Buster checkout; they do not assert that the entire source tree is vendored.

System headers, libraries/startup files, perf, binutils and Clang are external
runtime/build dependencies. No complete executable assembly, startup code,
compiler binary, generated object or raw perf-data binary is included.

## Extraction and disposition

The original public CI log is reduced to exact lines bearing the measurement
step name. Local measurement, build and focused-test logs retain their bytes.
The six assembly files contain only named generated lexer functions, extracted
by objdump and the function-header/blank-line ranges documented in commands.txt.
The fourteen shortenable instruction lines were inspected manually and checked
independently; each is opcode `81` against zero at width four or eight.
Profile sample exports retain only lines whose DSO is the generated lexer;
the raw report/stderr preserve total samples and reported loss. Full captures,
objects and disassemblies remain under the owning session's Benchpress
`~/buster-fast-bench/1719-diagnostics-01a1b81e/` directory and the local receipt
directories; hashes and paths identify them without committing their contents.

The host metadata file was captured after the campaigns, with its own UTC
timestamp. It is not a contemporaneous temperature, throttle or background-load
trace. Each actual build, test, measurement and profile used its own shared-lock
grant; the recorded benchmark processes ran on CPU 2.
