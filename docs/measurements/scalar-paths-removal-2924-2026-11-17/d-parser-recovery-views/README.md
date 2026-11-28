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

## Rebuilding structure repairs with the vector parser

The production candidate runs the ordinary vector grammar into the checker’s padded output columns, keeps interned custom attribute IDs, and restores the scratch arena before building the traversal. Native Clang-backed checker suites passed 10,539 malformed-call checks, 14,718 attribute-recovery checks and 6,642 initializer-diagnostic checks.

The microbenchmark times the complete tree rebuild on already prepared padded views, including resetting name meanings. Input preparation and traversal construction remain outside both timed regions. The baseline calls the existing scalar recovery parser on the same tokens and output columns. Each ratio divides candidate by baseline and takes the median of three paired rounds of 21 samples on the locked 9700X. Of 96 sizes, 45 met parity. Every nested-scope input and every seven-token function missed. This candidate remains experimental.

| Source family | Sizes at parity or faster | Minimum cycles/token ratio | Median | Maximum |
| --- | ---: | ---: | ---: | ---: |
| declaration | 16/24 | 0.3058 | 0.6293 | 3.3613 |
| record | 16/24 | 0.3453 | 0.7005 | 3.4914 |
| statement | 13/24 | 0.3057 | 0.8688 | 3.3739 |
| scopes | 0/24 | 1.8735 | 2.4036 | 2.9629 |

| Family | Size | Tokens | Core cycles/token ratio | Instructions/token ratio |
| --- | ---: | ---: | ---: | ---: |
| declaration | 0 | 7 | 3.3613 | 2.0492 |
| declaration | 1 | 10 | 2.7929 | 1.5995 |
| declaration | 2 | 13 | 2.3716 | 1.3128 |
| declaration | 3 | 16 | 2.0777 | 1.1133 |
| declaration | 4 | 19 | 1.8362 | 0.9675 |
| declaration | 5 | 22 | 1.6334 | 0.8544 |
| declaration | 7 | 28 | 1.3919 | 0.6976 |
| declaration | 8 | 31 | 1.2796 | 0.6386 |
| declaration | 15 | 52 | 0.8615 | 0.4044 |
| declaration | 16 | 55 | 0.8211 | 0.3846 |
| declaration | 17 | 58 | 0.8052 | 0.3670 |
| declaration | 31 | 100 | 0.6420 | 0.2869 |
| declaration | 32 | 103 | 0.6165 | 0.2793 |
| declaration | 33 | 106 | 0.5994 | 0.2722 |
| declaration | 63 | 196 | 0.5149 | 0.2235 |
| declaration | 64 | 199 | 0.5092 | 0.2205 |
| declaration | 65 | 202 | 0.5042 | 0.2175 |
| declaration | 127 | 388 | 0.4087 | 0.1745 |
| declaration | 128 | 391 | 0.4070 | 0.1733 |
| declaration | 129 | 394 | 0.4014 | 0.1722 |
| declaration | 255 | 772 | 0.3513 | 0.1481 |
| declaration | 256 | 775 | 0.3503 | 0.1476 |
| declaration | 511 | 1,540 | 0.3222 | 0.1347 |
| declaration | 1024 | 3,079 | 0.3058 | 0.1279 |
| record | 0 | 8 | 3.4914 | 2.1004 |
| record | 1 | 11 | 2.9800 | 1.6712 |
| record | 2 | 14 | 2.4883 | 1.3907 |
| record | 3 | 17 | 2.1315 | 1.1930 |
| record | 4 | 20 | 1.9090 | 1.0439 |
| record | 5 | 23 | 1.7551 | 0.9284 |
| record | 7 | 29 | 1.4452 | 0.7613 |
| record | 8 | 32 | 1.3162 | 0.6983 |
| record | 15 | 53 | 0.8982 | 0.4479 |
| record | 16 | 56 | 0.8787 | 0.4260 |
| record | 17 | 59 | 0.8615 | 0.4066 |
| record | 31 | 101 | 0.7070 | 0.3194 |
| record | 32 | 104 | 0.6940 | 0.3109 |
| record | 33 | 107 | 0.6787 | 0.3029 |
| record | 63 | 197 | 0.5801 | 0.2497 |
| record | 64 | 200 | 0.5671 | 0.2462 |
| record | 65 | 203 | 0.5574 | 0.2429 |
| record | 127 | 389 | 0.4564 | 0.1955 |
| record | 128 | 392 | 0.4522 | 0.1942 |
| record | 129 | 395 | 0.4478 | 0.1928 |
| record | 255 | 773 | 0.3968 | 0.1661 |
| record | 256 | 776 | 0.3948 | 0.1655 |
| record | 511 | 1,541 | 0.3682 | 0.1511 |
| record | 1024 | 3,080 | 0.3453 | 0.1435 |
| scopes | 0 | 9 | 2.9629 | 1.7428 |
| scopes | 1 | 11 | 2.7478 | 1.5188 |
| scopes | 2 | 13 | 2.4204 | 1.3508 |
| scopes | 3 | 15 | 2.2074 | 1.2186 |
| scopes | 4 | 17 | 2.0460 | 1.1125 |
| scopes | 5 | 19 | 1.8735 | 1.0254 |
| scopes | 7 | 23 | 2.3496 | 1.1266 |
| scopes | 8 | 25 | 2.5338 | 1.1217 |
| scopes | 15 | 39 | 2.2356 | 0.9276 |
| scopes | 16 | 41 | 2.3134 | 0.9360 |
| scopes | 17 | 43 | 2.4523 | 0.9608 |
| scopes | 31 | 71 | 2.2141 | 0.8374 |
| scopes | 32 | 73 | 2.3933 | 0.8824 |
| scopes | 33 | 75 | 2.4679 | 0.9029 |
| scopes | 63 | 135 | 2.3535 | 0.8502 |
| scopes | 64 | 137 | 2.4234 | 0.8724 |
| scopes | 65 | 139 | 2.4703 | 0.8821 |
| scopes | 127 | 263 | 2.4780 | 0.8227 |
| scopes | 128 | 265 | 2.5141 | 0.8345 |
| scopes | 129 | 267 | 2.5279 | 0.8399 |
| scopes | 255 | 519 | 2.3780 | 0.8079 |
| scopes | 256 | 521 | 2.4114 | 0.8141 |
| scopes | 511 | 1,031 | 2.3918 | 0.8004 |
| scopes | 1024 | 2,057 | 2.3957 | 0.7982 |
| statement | 0 | 7 | 3.3739 | 2.0492 |
| statement | 1 | 9 | 2.9657 | 1.7428 |
| statement | 2 | 11 | 2.7267 | 1.5170 |
| statement | 3 | 13 | 2.4079 | 1.3440 |
| statement | 4 | 15 | 2.2516 | 1.2057 |
| statement | 5 | 17 | 2.0013 | 1.0903 |
| statement | 7 | 21 | 1.7572 | 0.9220 |
| statement | 8 | 23 | 1.6634 | 0.8548 |
| statement | 15 | 37 | 1.1369 | 0.5664 |
| statement | 16 | 39 | 1.0898 | 0.5403 |
| statement | 17 | 41 | 1.0373 | 0.5161 |
| statement | 31 | 69 | 0.8723 | 0.4134 |
| statement | 32 | 71 | 0.8653 | 0.4025 |
| statement | 33 | 73 | 0.8436 | 0.3918 |
| statement | 63 | 133 | 0.6196 | 0.2763 |
| statement | 64 | 135 | 0.6080 | 0.2724 |
| statement | 65 | 137 | 0.6006 | 0.2684 |
| statement | 127 | 261 | 0.4598 | 0.1971 |
| statement | 128 | 263 | 0.4676 | 0.1956 |
| statement | 129 | 265 | 0.4510 | 0.1941 |
| statement | 255 | 517 | 0.3697 | 0.1552 |
| statement | 256 | 519 | 0.3682 | 0.1546 |
| statement | 511 | 1,029 | 0.3311 | 0.1336 |
| statement | 1024 | 2,055 | 0.3057 | 0.1227 |

[Exact fixture sources, compiler patch, correctness and counter logs](complete-vector-repair-sizes.tar.xz)
