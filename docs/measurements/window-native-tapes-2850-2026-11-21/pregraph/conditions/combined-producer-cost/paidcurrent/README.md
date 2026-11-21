# Paying for source-window condition production on public main d335da08d

Three symmetric rounds on Ryzen 7 9700X CPU 2 compared the unmodified public compiler, the instrumented compiler with condition production off, and the same executable with production on. Each measurement used a fresh process to compile the frozen source and write its relocatable object. PMU and elapsed observations used separate processes.

On SQLite the enabled producer generated 310,975 graph nodes and 33,720 arguments, compared with 323,623 nodes and 34,220 arguments with the producer off. The complete native stream, object bytes and diagnostic comparisons matched. Against the production-disabled mode it added 97.050 million user instructions and 13.590 ms by paired median. Against the unmodified public compiler it added 100.859 million instructions and 12.8165 ms. All three rounds agreed on both regressions. The instrumented but disabled executable itself retired 3.808 million more instructions than the public compiler.

[SQLite pairs](sqlite/paired.tsv) · [Graph and native hashes](sqlite/oracles.tsv) · [Per-process measurements](sqlite/samples.tsv) · [Receipts](sqlite/native-receipts.tar.xz) · [Exact source patch and command](source-and-builds.tar.xz)
