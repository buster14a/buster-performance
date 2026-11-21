# Type-sweep production of the packed template bytes

T writes the eight checked template-key bytes into the window while its operator and type facts are in vector registers. C supplies the context and conversion bytes after type propagation. A distant operand updates just the affected lanes after scalar repair. The template dictionary still compares the complete decision key and validates the representable domain.

| Stream | Condition | Previous cycles/node | Produced key cycles/node | Range of five round means | Branch misses/node |
| --- | --- | ---: | ---: | ---: | ---: |
| sqlite3 | warm | 14.086 | 13.763 | 13.746–13.775 | 0.0193 |
| sqlite3 | cold | 19.291 | 18.291 | 18.027–18.344 | 0.0200 |
| musl | warm | 18.377 | 18.048 | 17.998–18.369 | 0.0433 |
| musl | cold | 19.532 | 19.369 | 18.897–19.588 | 0.0555 |

On the locked Ryzen 7 9700X, all 20 round means met the cycles and branch-miss thresholds. The highest after-scalar round mean was 19.588 cycles per taken musl node. Both variants took every reference node in the frozen acceptance set. All 346,998 SQLite entries and 154,132 musl entries were identical to the scalar oracle. The membership test included every learned key and over 300,000 unknown queries per stream.

Each of 80 processes ran 21 measured passes. The reported value first takes the median in a process, then the mean of two symmetric positions within a round, and then the median of the five rounds. Cold runs interposed 200 ms of scalar work. The experiment starts from dumped node streams and prebuilt tables.

[Pass counters](counters.tsv), [paired estimates](summary.tsv), [native logs](native-receipts.tar.xz), [exact source](sources.tar.xz) and [measurement commands](qualify-produced.sh).
