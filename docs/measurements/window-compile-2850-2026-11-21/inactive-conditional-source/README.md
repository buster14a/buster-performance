# Source tokens prepared inside skipped preprocessor groups

In one ordinary compilation of frozen SQLite, the preprocessor prepared 1,166,437 raw tokens in its 9,507,037-byte primary file. During expansion it skipped 1,915 disjoint conditional groups comprising 463,372 of those tokens (39.7%), 3,171,033 source bytes and 178,030 identifiers. Nested directive lines account for 23,311 of the skipped tokens. The largest single skipped range spanned raw tokens [1,026,645, 1,165,218) and bytes [8,609,775, 9,496,318). These figures measure work available to a frontend that can avoid preparing inactive regions. This instrumentation does extra scans and supplies no timing result.

The instrumented compiler counts every successful file preparation, then counts the cursor movement from the first token after the evaluated directive to the next selected directive. It excludes hidden directives requiring relexing. The primary SQLite file appears once in one inclusion. For headers and the compiler self-build, the tables group files by byte length, so equal-sized files can share a row and repeated visits can reuse a prior preparation.

| Workload | File preparations | Observed skips | Object SHA-256 |
| --- | ---: | ---: | --- |
| SQLite | 160 | 2,692 | `2238999c41e256cc9c14ddbe21e379f0b3c09df25fb642b056e18b8a7ea773a0` |
| Buster | 514 | 2,120 | `f6201b299a7bc6d7f7bc3945fa4fceb5be4835172503eb372375d01fabcc8a21` |

Production code at `0e1d5b825` plus the [instrumentation patch](instrumentation.patch) was built with `./build.sh`. Run an ordinary `-c` with `BUSTER_PP_GROUP_INVENTORY=1` and capture stderr. The SQLite source SHA-256 is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Its flags were `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`. The compiler self-build used the frozen local tree, `-march=native -fwrapv -funsigned-char`, its source include directory and the frozen predefines. For both units the compiler status, object, stdout and remaining stderr matched the uninstrumented local parent. The local reference differs from the timing parent only in documentation.

Rebuild each table with `gzip -dc sqlite.log.gz | python3 summarize.py` or the equivalent for main. [SQLite table](sqlite.tsv) · [SQLite raw records](sqlite.log.gz) · [Buster table](main.tsv) · [Buster raw records](main.log.gz) · [Summarizer](summarize.py)
