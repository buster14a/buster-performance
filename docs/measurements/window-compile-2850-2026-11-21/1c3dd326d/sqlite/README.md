# sqlite complete-corpus compilation

Each timed invocation compiled 1 translation unit(s) on CPU 2. All 62 end-to-end invocations produced the identical [complete object manifest](objects.tsv). Both binaries agreed on all [diagnostic streams](diagnostics.tsv). The corpus has 716,136 preprocessed tokens.

PMU faults ranged from 5,653 to 5,662. Wall minor faults ranged from 5,762 to 5,770. The measured wall processes had zero major faults. Every grouped PMU counter ran at 100% enabled time.

The [full trial order](order.tsv), [raw reports](reports.tar.xz), [per-position counters](samples.tsv), [round differences](paired.tsv) and [per-run manifest hashes](object-receipts.tsv) retain the individual observations.
