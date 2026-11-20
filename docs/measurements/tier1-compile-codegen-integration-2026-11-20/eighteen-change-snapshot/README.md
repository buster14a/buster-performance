# Eighteen combined changes on main

[Main 3804c5e7](https://github.com/buster14a/buster/commit/3804c5e7b9468772d22209774843f06aabd70990) is the baseline. The [manifest](heads.tsv) identifies the eighteen separate PR heads through #3136. The candidate source tree is reproduced by applying the [full patch](combined.patch.gz) to that exact baseline. The patch passed `git apply --check` in the clean control checkout. A local integration commit identifies this build as `c62a7f5635c6ac9743a354fc0b046d6182e0fbfa`. It excludes #3138 and subsequent work.

The [single merge resolution](capacity-resolution.diff) combines #3124's sparse emitter bounds and #3136's per-use x87 constant references. The vector reference allowance is already included in `extra.references`. The combined bound adds `x87_references` once, and retains the sparse branch, copy and x87-node record bounds. Reviewers can reproduce the same source with the complete patch.

## Compilation

Eight alternated-order pairs per workload ran on the local Ryzen 9 7940HS with one internal lane. Percentages are medians of within-pair changes. The [release measurements](normal-summary.txt) and [debug measurements](debug-summary.txt) include ranges. Their process tables contain object digests and hardware counters.

| Translation unit | Retired instructions | User cycles |
|---|---:|---:|
| SQLite, Tier 1 release | −2.217% | −1.377%, mixed pairs |
| SQLite, Tier 1 with debug info at -O2 | −20.519% | −13.302%, all eight lower |
| Lua VM, Tier 1 with debug info | −32.117% | −24.339%, all eight lower |
| Lua parser, Tier 1 with debug info | −5.698% | −4.576%, all eight lower |

The [six compiler profiles](profiles/) cover release and debug compilation of SQLite, the Lua parser and the Lua VM. Each includes whole-compiler self and inclusive cycle weights, the source-line profile and sample weights. Unsymbolized lines use line zero. These are local measurements on the integrated candidate. The [separate fifteen-change clean Ninja results](../fifteen-change-snapshot/ninja/) include job counts 1, 2 and 4 and their release regressions.

## Compiler output and correctness

Both compilers rebuilt all 43 Buster release translation units, then rebuilt themselves with their own resulting executable. [Stage two and three](fixedpoints.tsv) produced bit-identical executables and objects per compiler. On common source the candidate reduced text by 13,124 bytes across the 43 objects. Of 10,476 matching function symbols, 685 became smaller and two became larger. On the same source, the executable linked from the candidate compiler's output used 14,464 fewer text bytes and occupied 12,288 fewer file bytes. [Totals](selfhost-totals.tsv) and [individual function changes](selfhost-function-changes.tsv).

The [24 suite results](suites/status.tsv) cover both release builds and the candidate under separate ASan/UBSan and MemorySanitizer configurations. The two sanitizer report audits were clean. The C suite passed 220 programs and 430 functions on each compiler. Its recorded code-size comparison remains above the Clang total on this corpus. The per-suite logs retain the exact expectations and non-enforced size comparison.

## Real JPEG applications

The upstream source is [libjpeg-turbo 3.1.3](https://github.com/libjpeg-turbo/libjpeg-turbo/tree/af9c1c268520a29adf98cad5138dafe612b3d318). Each Buster build compiled 135 source objects and used Clang for upstream's separate `strtest` helper. The [compiler ledger](jpeg/compilers.tsv) identifies every object, including the helper. SIMD was disabled in this scalar experiment.

Clang and both Buster builds each passed all 211 upstream tests using the upstream checksum for contracted 12-bit floating-point output. Automatic configuration initially selected the other official checksum and the same single test failed on all three compilers. The executable hashes were unchanged when the expected mode was corrected. Both sets of CTest logs are included.

All [216 command outputs](jpeg/applications/checks.tsv) across 18 operations, three compilers and four placements matched byte for byte. All [99 cross-decoder comparisons](jpeg/applications/cross-decodes.tsv) agreed. The [1,296 process observations](jpeg/applications/counters.tsv.gz) cover eight measured local pairs after warm-up. Lossless rotation used 3.632% fewer instructions with cycle changes from −0.582% to +1.275% across four placements. Floating IDCT used about 0.194% fewer instructions and 0.175–0.590% fewer cycles. The remaining cases were near neutral. [All paired counters](jpeg/applications/paired.tsv).

The [1,204 paired self-host compiler measurements](selfhost-compile-counters/) cover all 43 Buster release sources and compare both the fifteen-change and eighteen-change snapshots with their own controls.

A [new 256-seed Csmith and YARPGen campaign](generated-programs/) found the same 245 passes, nine Clang runtime limits and two Tier 0 argument-count limits in both compiler snapshots.

The [126 complete clean builds](ninja/) changed Buster compile wall time by −0.41%, −1.12% and −1.09% at one, two and four jobs. Lua debug wall time fell 4.82%, 5.75% and 5.48%. The distinct [single-file lane scaling experiment](scaling/) found SQLite debug wall time fell 13.6%, 15.4% and 19.1% at those lane counts. Its two-lane release Lua parser was 2.5% slower.

The [direct 9700X measurements](9700x/) cover all three real inputs, with three post-warm-up pairs and complete hardware counter and object receipts.
