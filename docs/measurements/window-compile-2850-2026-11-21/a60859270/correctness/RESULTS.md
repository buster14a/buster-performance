# Corrected arithmetic reader

The signed production candidate at `a60859270d960707df809d310ae895b0672d4fef` preserves static assertions' original trees for requirement text and operand-value notes. It uses a flag on the existing constant-context bytes as the reader classifies assertions. The other required-integer contexts continue to admit qualified operands. A dedicated 18-expression × 3-declaration-context × 6-policy grid compares 13 failed-assertion forms per source. Of those 324 compiler comparisons, 216 detected a diagnostic difference on the [first snapshot](https://github.com/buster14a/buster-performance/tree/9b98c0af25851229791537c0c5ecfa4b91fb3a99/docs/measurements/window-compile-2850-2026-11-21/5882f7c2a). All match on the repair.

All 21,474 three-way compilation comparisons agree on exit status, complete stdout and stderr, and object bytes when emitted. This entails 64,422 driver invocations across 5,488 frozen-corpus, 11,826 tracked-file and 4,160 generated cases under the policies in `commands/driver.py`. A separate deterministic reference executable runs 144 functions built with Clang and with all three Buster modes under six policies. Every program returned the expected result. On that fixture, the ordinary CLI reported 324 physically compressed children and removed 1,484 graph nodes.

| Corpus | Units | Qualified source arithmetic | Ordinary graph nodes removed |
|---|---:|---:|---:|
| SQLite | 1 | 2,356 | 4,759 |
| Lua | 34 | 781 | 1,986 |
| musl | 1,336 | 2,895 | 4,005 |
| Buster compiler source | 1 | 27,201 | 67,186 |

These are actual single-lane object compilations on the canonical source inputs. Across the four corpora, the reader published 33,233 checked children and removed 77,936 graph nodes. The printed workload totals are separately tied to each input and complete ELF hash in the stage receipt. The current compiler-self excludes 24 static-assertion children that the first snapshot compressed.

On the local Ryzen 7940HS, the candidate with the option retired 1.939 million fewer user instructions on SQLite and 90.128 million fewer on the Buster compiler source, compared with its own ordinary compile. Lua cost 0.071 million more and musl cost 10.452 million more. Separate pristine-parent and default-image controls are included. The machine's wall-time ranges, high fault behavior and output manifests are reported for each observation. See the dedicated locked-9700X record for the independent hardware qualification.

The actual released `--dump-typed -g -c` driver verifies every surviving source token, printed value and conversion, warning, fault, store and variable-argument record in order across all 1,372 inputs. The compiler-self graph shrinks by 67,200 rows in total. Seven ordinary prefetch calls elide another two separately synthesized builtin-immediate copies each after receiving the new checked VALUE directly. Each of the fourteen otherwise absent immediate witnesses has identical corresponding source token, value, flags, standing, warnings and faults. `deletions/` retains the complete comparison. The option's `removed` counter measures the nodes removed directly from the 27,201 operand spans.

The diagnostic backend-only patch adds a witness at the actual object emitter before its body-local scratch is recycled. All 5,488 option/ordinary comparisons preserve the complete emitted words, source positions where requested, local-slot classes and flags, and direct call/argument records across four policies. All eight normal checker shards passed. The MemorySanitizer checker part passed all 210,617 checks. Both are additional to the full ordinary-driver three-way grid.
