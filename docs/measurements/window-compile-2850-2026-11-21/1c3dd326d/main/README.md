# main complete-corpus compilation

Each timed invocation compiled 1 translation unit(s) on CPU 2. All 62 end-to-end invocations produced the identical [complete object manifest](objects.tsv). Both binaries agreed on all [diagnostic streams](diagnostics.tsv). The corpus has 2,433,922 preprocessed tokens.

PMU faults ranged from 16,487 to 16,512. Wall minor faults ranged from 16,841 to 16,871. The measured wall processes had zero major faults. Every grouped PMU counter ran at 100% enabled time.

The [full trial order](order.tsv), [raw reports](reports.tar.xz), [per-position counters](samples.tsv), [round differences](paired.tsv) and [per-run manifest hashes](object-receipts.tsv) retain the individual observations.
