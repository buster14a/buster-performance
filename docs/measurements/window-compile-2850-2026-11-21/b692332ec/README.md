# Complete function-close binding publication

Signed candidate `b692332ec4497ff05a58fe7fa9c8bd41ded1e26b`. The base is `40ae34f9d77afc42face58eff3338b7b1d1ba469`.

The checker fills missing canonical declaration and type entries for each source-ordered bound use when its function closes. It preserves existing type captures, tracks ambiguous same-token uses and refreshes a changed target type at the normal end-of-unit binding handoff. The ordinary source reader and object emitter consume the same canonical columns.

| Frozen input | Closed functions | Body token positions | Newly published uses | Raw declaration differences at close | Raw type differences at close |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 2,674 | 568,641 | 96,872 | 0 | 0 |
| Buster | 8,667 | 1,035,996 | 154,780 | 0 | 0 |

The observer read the actual body columns immediately after the production writes. GDB independently captured the complete final columns from the unchanged upstream executable with exactly the same source paths. Every one of the 1,604,637 positions matched at function close. The full final columns, native objects and diagnostic streams also matched. The independent source-data replay predicted the exact counts and zero residual discrepancies on both inputs.

In 57 extra source and option combinations with late declarations, all final columns, diagnostics, statuses and ELF bytes matched. A misspelled identifier in an invalid function is the concrete source-close exception. Three diagnostic and language policies each acquire one declaration/type pair during the later typo-correction pass. A streaming semantic consumer must retain that dependency until the correction is available.

The implementation passed 450 additional focused binding and native comparisons, 3,096 declaration controls, 4,116 frozen single-source controls and 850,926 checker assertions. Its standalone Ryzen 9 7940HS SQLite median wall difference was +3.4977 ms (13/36 faster). User instructions increased by 7.524 million and user cycles increased by 24.510 million (2/12 faster). This source handoff needs a downstream consumer to displace later work before it warrants target timing.

The [replay and evidence archive](source-use-proof.tar.xz) retains the implementation, native compiler identities, inputs, raw source receipts and all local measurements. Its SHA-256 is `b0594108e51c119883e60d6974a38fab9374f7beb7571bfa0162f91c862313b0`.

The local validation campaign reserved one physical core. Its elapsed-time script launched one ordinary compiler process per observation with Python’s monotonic clock, and its counter script launched one compiler process per perf invocation.
