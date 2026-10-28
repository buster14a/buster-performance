# Preprocessor printer prefix offsets, issue 649

Baseline: Buster `bc1b486150850fe00bad1361a19f57d67706bb3b`.
Implementation: `123d22aef6f9298541dbe869ba00e794805322c4`.
All new implementation, fixtures and adapters are original project material.
The repository's existing lexer/benchmark notices remain applicable; no
external code, tables or fixture corpus is imported. Clang and installed
headers run or are read externally.

The change targets `-P` batches whose spellings each have 1–64 bytes and which
have no pragma end or streamed embed. Two 32-word prefix sums compute each
copy's address. A single gap-byte store replaces the per-token break/space
stores. The independent scalar printer is unchanged. Marker and exceptional
batches retain the original route. No new producer metadata is stored.

## Validation

- The complete 41-unit release build passes (`BUSTER_DEBUG_INFO=0`).
- Call graph: 41 units, 25,111 functions, 149,510 calls, zero disallowed cycles,
  three existing allowed cycles and zero split variables.
- `test-preprocessor --clang -Isrc -march=native MAIN SQLITE` passes on
  5,570,349 tokens. Its file mode compares exact scalar/vector printer bytes
  with markers and without, and spellings against Clang.
- The new permanent prefix fixtures pass ASan/UBSan with leak detection:
  325 guarded batches, all 0–64 counts, inactive gap bits, zero/64/65/large
  lengths, and output canaries. Full printer fixtures cover all 64 pragma
  alignments, continuation into ordinary batches, >1 MiB output rollover,
  both marker modes, long literals, splices, trigraphs, UCNs, generated
  integers and embeds.
- The separate full `test-preprocessor --clang` fixture/fuzz suite passes:
  377 fixtures, 36 exact Clang diagnostic histories, both new printer groups,
  all option/header/semantic tests and 3,000 C17/C23 differential fuzz cases.
  It is recorded in `preprocessor-fixtures-clang.log`; corpus/file mode does
  not run that suite.

## Local performance screen

These are laptop Ryzen 9 7940HS screening observations, not 9700X claims.
`benchmark.c` includes the actual repository benchmark as a standalone adapter.
It preserves its 21-pass timing/validation method and was built from each
source revision with `-O3 -march=native -fwrapv -funsigned-char
-fno-strict-aliasing -Wall -Werror`. Every process acquired one core through
the shared local core queue. Other jobs used other cores, so total package
load and power state were not isolated.

Three fresh-process pairs on the same frozen SQLite path rotated which
compiler ran first. The existing benchmark reports printing separately:

| Round | Baseline printing ms | Candidate printing ms | Baseline full -E-P ms | Candidate full -E-P ms |
| --- | ---: | ---: | ---: | ---: |
| 1 | 6.394 | 5.374 | 23.305 | 22.172 |
| 2 | 6.385 | 5.376 | 23.318 | 22.237 |
| 3 | 6.355 | 5.347 | 23.368 | 22.221 |

The complete standard compiler executable's existing benchmark confirms the
direction in an additional local pair: printing **6.236 → 5.275 ms**, full
`-E -P` benchmark **22.948 → 22.298 ms**. Its image/layout differs from the
standalone adapter, so those results remain separate.

The main.c input also uses one common source tree and include path. Printing
was 43.806 → 39.417 ms and, with compiler order reversed, 46.906 → 37.842 ms.
Full-pipeline time varied with package load: 131.737 → 133.644 ms in the first
pair, 136.310 → 121.723 ms in the second. These do not establish a broad
whole-process gain. Initial main.c attempts omitted its required include path
and then native target; those failed runs remain in `main-*.log` explicitly.

## Target reproduction

Use the full compiler's unchanged `benchmark-preprocessor --only vectorized`
on frozen SQLite, and optionally `-march=native -Isrc .../main.c`. For main.c,
point both compilers at the same frozen input tree/include path. Acquire the
9700X exclusive lock separately for every build, test or benchmark run and
pin single-threaded timing to CPU 2. Compare whole fresh-process `-E -P` too;
printing-only observations do not establish startup/preprocessing neutrality.

`sanitize.c` includes the actual permanent tests through main.c's frontend
unit; `lexer.c` exposes the actual lexer to it. Build with `-O1 -g
-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror
-fsanitize=address,undefined -ffunction-sections -fdata-sections`, linking
`-Wl,--gc-sections -lm -pthread`. No implementation is copied into the adapters.
