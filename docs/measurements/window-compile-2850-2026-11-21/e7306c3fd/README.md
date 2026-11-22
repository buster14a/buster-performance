# A checked body that publishes native operations

The source reader recognizes a single return expression over integer and pointer parameters, checked direct calls with up to six integer or pointer arguments, member and indirection loads, constants, and a bounded group of arithmetic operations. It constructs the Tier 0 producer's typed entries, SysV ABI locations, and unresolved call identity. A unit with globals resolves that identity through its ordinary object-symbol table. Unsupported expressions continue through the ordinary writer.

The source-first entry builds each function's checked graph directly, emits the operation record while the graph and check stream are live, and retires both before the next function. The whole-unit expression graph has capacity one and zero nodes in that run. A separate fresh process injects those saved operations into ordinary ELF publication, skipping the entire original writer for every injected function. A third fresh process uses the same producer directly on its ordinary checked input in one invocation (which still retains the ordinary graph for other statements and symbols). Managed switches are in the reproduction script. The runs establish correctness for these operations. The 1 GB/s criterion requires a timed complete ordinary compilation.

| Translation unit | Source functions | Records produced | Writers replaced | Final typed operations | Native bytes from replaced writers | Call relocations |
|---|---:|---:|---:|---:|---:|---:|
| fixture | 11 | 11 | 11 | 38 | 120 | 2 |
| generated | 400 | 391 | 391 | 2059 | 7873 | 104 |
| sqlite | 2674 | 62 | 59 | 277 | 1325 | 26 |
| main | 8667 | 37 | 6 | 45 | 269 | 5 |

Every substitutable typed row, selected function's machine bytes and relocation (field offset, type, symbol and addend) matched ordinary Buster. Some inline-only functions in the source have no emitted ELF symbol. The oracle verifies ELF's ordinary conversion of a static function's target to its section plus displacement. Whole objects and ordinary stdout and diagnostics match for source-first publication and single-invocation direct compilation. [Object digests and counts](receipts.tsv)

The source-first fixture was also independently assembled from its exact emitted hex and relocations. Native calls into its 11 functions evaluated 43,485 input pairs. The generated corpus ran 400 functions over 1,365 input pairs (546,000 function calls), with wraparound arithmetic explicitly enabled. Independently linked clang version 23.1.4 (https://github.com/llvm/llvm-project 7a941dfb2877a0b8cf30323fefa85ad019e0b0f5) reference executables produced the same respective results. Checked source, normal Buster, and Clang all returned 754756008178910939 for the handwritten fixture and 3535655553877645477 for the generated corpus. The generated corpus includes 49 lines of ordinary Buster diagnostics under the default policy, identical across the three compile modes.

The local iteration executable was linked from the experimental checker unit at -O0 and existing optimized driver units. Its SHA-256 is `1bcf9fe007b0bfd25c0f1c95a68fe69bc2b0fa8eadc34e2f1a868c70b5b0a107`. All three invocation modes used this identical binary. The experiment uses source revision `e7306c3fd5fb86264fbe7512571df768de057182` and frozen baseline `0e1d5b825801135bf50e79da9d546bc95209ab30`. [Full source patch](source.patch) [Producer changes above checked-source revision 22736211a](direct-producer.patch) [Raw per-function output, commands and native fixtures](raw-receipts.tar.gz)

The SQLite unit has 381,191 typed operations in its ordinary native backend. These 277 accepted operations cover 0.073 percent of them. Buster's frozen unit has many inline functions omitted by ordinary symbol selection. A direct runtime speed claim calls for a substantially wider producer and one fresh full compilation that owns the checker, control flow, data, and symbol publication.
