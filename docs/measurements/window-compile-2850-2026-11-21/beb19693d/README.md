# Native ELF from one pass of the local source checker

The compiler reads and checks each supported function in its own graph, emits typed operations with unresolved call identities, then retires its graph and check stream. The normal symbol selector receives those identities, the old body writer is skipped and the normal native encoder, unwind writer and object builder finish the object. The same compilation handles unowned bodies through the ordinary graph. The source graph for a substituted body is evaluated once.

A complete eleven-function translation unit with two extern calls builds using one reserved whole-unit expression slot and zero emitted whole-unit nodes. It produces the exact ordinary ELF object, including unwind information and relocations. Native execution agrees with independently compiled Clang. On frozen SQLite the one-pass compiler eliminates 278 of the ordinary graph's 323,623 nodes, builds the same 2,061,200-byte object, and skips 57 complete function writers. A source-first body may be omitted by ordinary reachability, so the source and emitted counts differ.

| Input | Source functions | Owned source bodies | Local nodes | Persistent graph nodes | Writers skipped | Typed operations | Call relocations |
|---|---:|---:|---:|---:|---:|---:|---:|
| fixture | 11 | 11 | 38 | 0 | 11 | 38 | 2 |
| generated | 400 | 152 | 881 | 2880 | 152 | 515 | 37 |
| sqlite | 2674 | 60 | 278 | 323345 | 57 | 266 | 24 |
| main | 8667 | 37 | 195 | 1407221 | 6 | 45 | 5 |

The pure-integer generated unit runs 400 compiled functions over 1,365 pairs (546,000 calls); unsupported functions use the ordinary compiler. The handwritten mixed integer/pointer/member/extern fixture runs 43,485 input pairs. All native execution checksums agree across the source-first compiler, ordinary Buster and clang version 23.1.4 (https://github.com/llvm/llvm-project 7a941dfb2877a0b8cf30323fefa85ad019e0b0f5). [Digests and actual results](native-execution.tsv)

The source-first and ordinary full objects, diagnostics and standard output match for the default, `-Wall -Wextra`, and `-Weverything -Wno-c++-compat` policies for all four inputs. A generated warning probe initially exposed a lost tautological range diagnostic, so comparisons use the existing whole-unit diagnostic path. [Default object and producer receipts](one-pass.tsv) [Warning-policy receipts](policies.tsv)

Source revision `beb19693d324765c0301d8279182752714a3af43` was tested with checker translation unit at -O0 and existing optimized driver units. All paired compilers used the same executable (SHA-256 `312d1898afcc0911cbc1c17f829c7ed7852070c5fc7b308fdc91fb3f74056d90`) and selected their mode at process start. The complete-coverage fixture additionally requests one slot for the unit graph. 9700X throughput remains open. The mixed production corpus retains its unit graph allocation for other functions. [Full source against 0e1d5b825](source.patch) [Direct producer changes above 22736211a](producer.patch) [Raw process output, commands and fixtures](one-pass-raw.tar.gz)
