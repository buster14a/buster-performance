# Expression profiling through the public driver

Source `74f29bd50bd75f519e053c3edd148381a300147d` and its parent `325883abf9607ac726966a0af2097377832d53ac` produced identical status, stdout, diagnostics and ELF in 4,116 process pairs. The four corpora comprise 1,372 translation units under the default, `-Wall -Wextra` and `-Weverything -Wno-c++-compat` policies. [Unit counts](corpora.tsv)

On the node-window fixture, tracing both executable images with and without the window counted two process resource queries in ordinary parent compiles and zero in the candidate. Each timed compile made 33 calls and reported the expression stage. All eight objects agreed. The binding benchmark produced the same per-class and per-mode counts. The two targeted checker shards passed 210,629 and 86,654 checks. [Process traces](trace.tsv) · [Benchmark counts](benchmark-counts.txt) · [Scripts, hashes and raw receipts](receipts.tar.gz)

Seventy-two additional pairs compiled two sources on the ordinary, scalar and deferred public paths with the window off, the regular window, or assignment windows, crossed with debug and timing. Every status, ELF and ordinary diagnostic matched, and both images emitted stage records in every timed run. [Driver matrix](driver-paths.tsv)

Timings in these local receipts are diagnostic. The [locked 9700X study](../README.md) measures the complete fresh driver.
