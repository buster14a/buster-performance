# musl complete-corpus compilation

Each timed invocation compiled 1,336 translation unit(s) on CPU 2. All 62 end-to-end invocations produced the identical [complete object manifest](objects.tsv). Both binaries agreed on all [diagnostic streams](diagnostics.tsv). The corpus has 5,039,639 preprocessed tokens.

PMU faults ranged from 271,011 to 271,021. Wall minor faults ranged from 271,075 to 271,082. The measured wall processes had zero major faults. Every grouped PMU counter ran at 100% enabled time.

Independent one-unit stage compiles supply the [per-file token counts](per-unit-tokens.tsv). Each separately compiled unit produced the very same object as the corresponding output of the combined driver invocation.

The zero-token translation units were `longjmp.o`, `setjmp.o`, `sigsetjmp.o`, `syscall_cp.o`, `tls.o`. These units still produced the listed complete ELF outputs.

The [full trial order](order.tsv), [raw reports](reports.tar.xz), [per-position counters](samples.tsv), [round differences](paired.tsv) and [per-run manifest hashes](object-receipts.tsv) retain the individual observations.
