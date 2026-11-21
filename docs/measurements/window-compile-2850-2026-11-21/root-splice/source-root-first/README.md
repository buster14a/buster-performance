# Source-derived graph and native roots

A real single-lane SQLite object build replaced 1,556 complete constant return expressions with their source-derived semantic roots. The compiler published 322,058 graph nodes, 1,565 fewer than the uninstrumented ordinary path's 323,623. It emitted the retained native tape at all 1,556 requested roots. Each admission was also independently observed in the original set of 4,866 successful native splices. The producer disabled post-numbering comparison, graph binding and the reference type execution throughout the translation unit.

The compiler's source front reads postorder and resolved token/identifier/literal facts, computes the operand and return conversion, checks source warning and reference requirements, then forms native entries. Its reader verifies the source interval and suppresses the ordinary graph-making actions there. The fallback checker executes on the resulting dense graph. The source tapes retain their original return opcode and source tokens. A reciprocal root identity makes actual emission mandatory for a physically compacted expression requested by the writer.

All 322,058 surviving semantic values, including complete integer and floating payloads, object, offset and fault fields, matched ordinary compilation. Every retained node's diagnostics and warning bits matched. Every remaining ordinary conversion, member offset, and all 263,230 remaining ordinary direct/argument edges matched. Default ELF, debug ELF and the default native bytes all matched ordinary compiling. The original experiment binary used an incomplete debug-native logging hook, so the debug check in this packet uses exact ELF and graph comparison. A later backend-input witness supports an independent debug-native comparison.

The 257-function generated corpus includes file-scope reads and assignments, arithmetic, conditional expressions, casts, local reads, calls, and fallback branches. It took 124 roots under default, debug, verify, two lanes, scalar, Tier 1 and C23. Explicit warning policies stayed ordinary in this first experiment. All object bytes and diagnostics matched. This packet establishes correctness for the indicated roots. End-to-end speed is a separate measurement.

## Independent native cohort

The second source layer binds source-known string objects and fills decay/address rows from canonical pointer types already present in the type registry. Six ordinary object-producing invocations compare the two dependencies. Each command produced the same default ELF and native bytes. The independent producer recovered all 4,866 former source keys and emitted another 16; code was still produced for all remaining expressions by the ordinary fallback.

| Source-side configuration | Retained tapes | Actually used native roots | Missing former roots | Extra |
|---|---:|---:|---:|---:|
| Old producer with post-numbering shadow | 26,303 | 4,866 | 0 | 0 |
| Source-only | 18,480 | 4,763 | 103 | 0 |
| Source-only with string objects | 18,480 | 4,763 | 103 | 0 |
| Source-only with canonical pointer rows | 21,529 | 4,805 | 74 | 13 |
| Source-only with both | 21,529 | 4,882 | 0 | 16 |

The 4,866 original source keys comprise 1,556 constant returns, 1,107 other returns and 2,203 assignments. The model grants at most 9,514 deleted ordinary nodes to this particular cohort if every complete root can replace its ordinary tree. The source-bank and native recollection are separate from the 1,556 real graph removals in the first experiment.

## Reproduction

Apply `source/compile.patch` to Buster `84a7d3d76891d6c393497e62e6aff38f2b162fc2` and build with `./build.sh`. This recreates candidate `c21a03f8f4ff50484bc819207a006c7886a9eef2`. Run `python3 source/reproduce.py COMPILER SQLITE_DIR RESULTS_DIR`. The SQLite amalgamation SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Unpack the Zstandard and gzip files under `sqlite` and run `python3 source/graph_check.py sqlite plain full original` for a standalone survivor comparison. The binary graph dumps were written only after each independent process completed ordinary graph checking. The compaction stage never reads a reference dump.

For the native-cohort experiment, additionally apply `source/registry-and-strings.patch` to recreate `8208feedbe9362313389b47b777a342ab9697f3c`. Run `python3 source/string-controls.py COMPILER RESULTS_DIR` followed by the five frozen SQLite arguments used in `source/reproduce.py`. The `controls` directory retains each producer's source keys and counters for recomputing the intersection.
