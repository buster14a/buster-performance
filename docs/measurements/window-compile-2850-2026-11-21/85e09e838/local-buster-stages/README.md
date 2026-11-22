# Local Buster source-stage comparison

Three rounds on one pinned Ryzen 9 7940HS core compared Develop binaries from 18eca8d81 and 85e09e838. Each round launched four ordinary single-lane compiler invocations on the local frozen Buster source and hashed the entire emitted native object. The process order alternated between rounds. [Source identity](../qualification/local-source-inputs.tsv) · [Stage deltas](summary.tsv) · [Individual observations](samples.tsv) · [Complete reports](reports.tar.xz)

The root revision folder reports the separate 9700X SQLite experiment.
