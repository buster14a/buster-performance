# Expression profiling through the public driver

Source `29f478aafc3dc6218654f7007fb68da28d13cc72` and its parent `b86eadcbd3d6c5cdf687f6b67b0281df2ac34034` produced identical status, stdout, diagnostics and ELF in 4,116 process pairs. The four corpora comprise 1,372 translation units under the default, `-Wall -Wextra` and `-Weverything -Wno-c++-compat` policies. [Unit counts](corpora.tsv)

On the node-window fixture, tracing both executable images with and without the window counted two process resource queries in ordinary parent compiles and zero in the candidate. Each timed compile made 33 calls and reported the expression stage. All eight objects agreed. The binding benchmark produced the same per-class and per-mode counts. The two targeted checker shards passed 210,614 and 86,654 checks. [Process traces](trace.tsv) · [Benchmark counts](benchmark-counts.txt) · [Scripts, hashes and raw receipts](receipts.tar.gz)

Timings in these local receipts are diagnostic. The [locked 9700X study](../README.md) measures the complete fresh driver.
