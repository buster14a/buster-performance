# Carrying source inputs and caching member results

Carrying a second source word with every lookup, indexing a member plan by name, and caching fully checked arrow results each cost more than the packed-operand reference on SQLite lean. The four-round medians were 27.718, 28.638 and 29.090, compared with 27.638 cycles per taken identifier or lookup for the reference. The name plan and the result cache also increased full measured work in every lean SQLite round.

The direct-input variant carries the member name or argument-list mark beside the destination and operand. The name plan additionally validates the receiver type, operation and spelling before using a combined member row. The arrow cache memoizes a successful arrow rule for the exact type, name, standing and flags, including a use-position check on completeness. Each pass starts a new cache generation, so the first hit for each key requires its full proof. Other cases still execute the ordinary short path or rule.

| Input and record | factsoperands | factsinputs | factsnames | factsarrows |
| --- | ---: | ---: | ---: | ---: |
| sqlite whole | 28.580 | 28.817 | 29.440 | 29.562 |
| sqlite lean | 27.638 | 27.718 | 28.638 | 29.090 |
| lua whole | 22.010 | 22.683 | 22.502 | 22.082 |
| lua lean | 21.637 | 21.745 | 22.095 | 21.873 |
| musl whole | 19.210 | 19.770 | 19.463 | 20.510 |
| musl lean | 18.678 | 18.645 | 18.297 | 18.953 |

The name plan reduced the musl lean median to 18.297 from 18.678, but the SQLite lean paired difference was +0.988. The arrow cache added 1.453 SQLite cycles per taken record and 0.788 per window record in the full pass. None met the 10-cycle gate.

Each cell is the median of four symmetric round means on locked Ryzen 7 9700X CPU 2. Each process did five passes. Across 192 fresh processes, all taken records, lookup lists, fallback counts, and poison and decoy comparisons matched the reference for each corpus and mode. SQLite lean retained 93,682 identifiers and 51,973 of 52,013 lookups. The [paired intervals and full/given-only measurements](paired.tsv), [individual observations](samples.tsv), [source and binary hashes](builds.tsv), and [diagnostic outputs](measurements.tar.xz) accompany the source patches.
