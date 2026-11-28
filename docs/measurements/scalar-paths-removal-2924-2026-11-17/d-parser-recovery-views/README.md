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
