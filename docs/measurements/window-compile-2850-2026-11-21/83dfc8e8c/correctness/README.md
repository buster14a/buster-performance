# Arithmetic source-map integration at 83dfc8e8c

The compiler uses its normal parser source-index accessor when decoding hexadecimal and octal operands for an opt-in integer window. The source-read audit covers the full change relative to merged main at `325883abf`. Two direct source-index reads also remain in separate historical source-probe branches from before the parser change, as listed in `direct-source-diff.tsv`.

On an unmodified contiguous parser stream, the pre-integration build lost the fold for `0x20 | 7`. It accepted three roots and removed eight graph nodes. On a stream remapped by a pragma, the same binary accepted four and removed ten. The corrected driver accepts four and removes ten on both inputs. Its normal fixture asserts the source-map representation, the source-token correspondence, the integer value 39, native entries, and each source token. Ordinary, option, contiguous, and remapped cases agree on the whole debug object. Both maps also pass with poisoned arenas. The before/after source, data, driver commands and exact patches accompany the report. The production code changes are the full patch between `325883abf` and `83dfc8e8c`. The native observer is a separate signed child.

| Evidence | Real comparisons or checks | Result |
|---|---:|---|
| All tracked, generated and frozen inputs, actual -c | 21,483 true-parent/ordinary/option triples (64,449 compiles) | Every status, diagnostic, stdout and ELF matched |
| Source-map stress | 2,520 triples across three token-map constructions and six flag/policy combinations | Every status, diagnostic and ELF matched |
| Staged ordinary arithmetic counters | 1,372 corpus translation units | SQLite 2,356/4,759 roots/removed, Lua 781/1,986, musl 2,895/4,005, Buster self 27,201/67,186 |
| Sourced backend input | 5,488 plain/option pairs | Every emitted native row, source position, local slot, call descriptor, argument class, ELF and diagnostic matched |
| Uninstrumented typed graph and source dump | 1,372 units with -g | Every surviving value, standing, operand conversion and source position compared in order |
| Complete checker and driver shards | 848,429 and 151,324 assertions respectively | All 16 passed |
| Release MemorySanitizer | 210,637 checker shard 5 assertions plus ordinary, remapped, and poisoned source probes | All passed with identical objects |
| Registration | 28 checks | Attested field catalog passed |

Each of four diagnostic/debug policies independently covers 991,860 native entries in 8,010 bodies, 55,159 local slots, 37,029 call descriptors and 89,601 argument classes. The driver paths in the TSVs use `FROZEN/` for the canonical native input collection, `COMPILER_SOURCE/` for the frozen Buster source tree, and `work/` for the session's experiment directories. The local comparisons were made with Clang 23.1.4. The hardware preflight, PMUs, true wall, complete ELF manifests, and independent fixture and checker results are separately pinned. [Integrated 9700X record](https://github.com/buster14a/buster-performance/tree/87ff749714d4d6770e48df43969301f63c8c9efb/docs/measurements/window-compile-2850-2026-11-21/83dfc8e8c)
