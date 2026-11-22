# Emit native integer returns while the original source is open

Four SQLite functions emitted 18 machine-code bytes during preprocessing. The final encoder independently matched both instruction records per function and used the earlier bytes. Buster produced one speculative candidate and reused none.

The local Ryzen 9 7940HS compiled 716,136 SQLite tokens across 42 windows and 2,433,563 Buster tokens across 83 windows. The grammar emitted 709,161 and 2,421,290 tokens respectively before the original preprocessor reached EOF. The full native object, diagnostics and exit status matched the ordinary driver under both the default and maximum warning settings. All 57 directed source/policy comparisons matched. [Source against 40ae34f9d](source.patch), [revision](revision.tsv), [SQLite audit](sqlite.stderr), [Buster audit](main.stderr), [scripts and results](runs.tar.gz).
