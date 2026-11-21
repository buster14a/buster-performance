# Observable changes in the discarded-statement prototypes

A padded translation unit with `(void)__builtin_eh_return(a,p);` produced different x86-64 function and unwind bytes on all four experimental implementations. The parent object SHA-256 begins `5254b6695e1b`. Each candidate produced `6e25f09762fc`. Omitting the implicit statement conversion also removed rows printed by `--dump-typed -c`, including with `--scalar`. The fixtures contain enough ordinary declarations to reach the large-unit path.

| Implementation | Explicit-void EH object | Increment typed dump | Bare call typed dump |
| --- | --- | --- | --- |
| 5180639ec | differs | differs | matches |
| 642dd7c7f | differs | differs | differs |
| 49bb4d89d | differs | differs | differs |
| e822b812e | differs | differs | differs |

The comparisons used `fbef2d68d` as their parent. It differs from the native timing parent `0e1d5b825` only in documentation. For the first two rows, the local compilers included one additional test-inventory commit, respectively `a0b7aaa16` and `3370be43f`. Each compilation returned zero. The tables retain complete stdout and object hashes plus compiler hashes.

Extract the archive into an empty directory. For each compiler, run `compiler -c eh.c -o unit.o`, `compiler --dump-typed -c inc.c -o unit.o` and `compiler --dump-typed -c call.c -o unit.o`. The archive includes the observed ELF files and streams for each case, compiler and mode. [All 45 observations](results.tsv) · [Sources and compiler outputs](source-and-output.tar.xz)
