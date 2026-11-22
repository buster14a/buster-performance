# Share backend and type classification across source-owned functions

The Release compiler reused its backend tables and classified newly appended ABI and lowerer types per source body. It emitted the identical 2,061,192-byte frozen SQLite ELF on the target machine. The independent ordinary compiler on the common base and the two modes of this experimental binary all passed the object preflight. The fresh ordinary comparison took 114.279 ms against 127.899 ms for the experiment. [Controlled 9700X results](9700x-individual/README.md)

The local Develop phase study measures the earlier full-body version and the three successive changes. Across the four instrumentation configurations the same SQLite translation unit produced the same reference ELF. [Local observations](local/develop.tsv), [phase breakdown](local/develop-phases.tsv), [patch against 0e1d5b825](source.patch).
