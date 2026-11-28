# Parser recovery views and binding replay

The measurement adds one 72-byte append after each scalar parser call in the four callers at `cc7d4ffb4`. On the Ryzen 7 9700X, the normal Release compiler ran the repository’s checker and binding suites under the exclusive lock with Clang 23.1.4. A separate local build reproduced every trace byte with the same Clang version. The trace records the caller, token count, scalar errors, diagnostic count, resource and classification flags, a hash of the token kinds, and a hash of every successful tree’s role, depth and parent columns.

| Suite | Calls | Passing checks |
| --- | ---: | ---: |
| bindings | 218 | 501,133 |
| attribute-recovery | 16,209 | 14,718 |
| malformed-calls | 26,290 | 10,539 |
| initializer-diagnostics | 1,960 | 6,642 |

| Caller | Calls | Tokens parsed | Calls reporting errors | Returned diagnostics |
| --- | ---: | ---: | ---: | ---: |
| edited prefix | 216 | 6,984 | 0 | 0 |
| resumed prefix | 23,055 | 1,038,537 | 11,925 | 13,171 |
| structure repair | 1,018 | 21,406 | 0 | 0 |
| checker driver recovery | 20,170 | 658,388 | 991 | 1,100 |
| binding replay | 218 | 158,206 | 0 | 0 |

All 1,018 structure repairs returned trees without syntax errors. Resumed prefixes returned errors on 11,925 views and the driver returned errors on another 991. These callers consume the repaired tree or its diagnostics. Binding replay also emits scope and declaration events. The trace counts that caller separately. All 44,677 calls completed without memory exhaustion, retyping or an undecided classification.

[Raw native traces, per-suite logs, source patch and verification script](native-recovery-views.tar.xz)

## Tree equivalence before repairing flagged declarations

Each nonbinding caller ran the existing AVX-512 kernels on padded copies of its recovery view in a private arena. This comparison bypassed the parser’s flagged-item and whole-unit repair step. For each accepted scalar tree, the probe compared every token’s role, depth and parent whenever the kernels returned a whole tree. All 44,459 native records matched an independent local run byte for byte and the checker and Clang suites passed on both computers. The binding suite emitted its original 218 census rows. It requires scope events and was excluded from the tree-only probe.

| Caller | Scalar result | Kernel result | Tree columns | Calls |
| --- | --- | --- | --- | ---: |
| edited prefix | valid | clean | equal | 216 |
| resumed prefix | invalid | flagged | uncompared | 5,677 |
| resumed prefix | invalid | whole | uncompared | 6,248 |
| resumed prefix | valid | clean | equal | 8,652 |
| resumed prefix | valid | flagged | different | 1,060 |
| resumed prefix | valid | flagged | equal | 1,418 |
| structure repair | valid | clean | equal | 1,018 |
| checker driver recovery | invalid | flagged | uncompared | 991 |
| checker driver recovery | valid | clean | equal | 15,948 |
| checker driver recovery | valid | flagged | different | 1,544 |
| checker driver recovery | valid | flagged | equal | 1,687 |

Here “clean” means that the kernels covered the whole view without flagging any token. “Flagged” means that the kernels produced tree columns and asked for selected declarations to be repaired. “Whole” means they asked for the complete input to be reparsed. The raw kernels reproduced all 1,018 structure-repair trees. They produced different columns on 1,060 valid resumed prefixes and 1,544 valid driver recovery views. The error-producing and whole-unit rows were counted without comparing partial trees. The ordinary parser’s diagnostic path still matters for those inputs.

[Native comparison records, suite logs, instrumentation and decoder](raw-vector-recovery-trees.tar.xz)
