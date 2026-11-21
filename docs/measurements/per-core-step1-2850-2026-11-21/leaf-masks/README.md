# Leaf positions and declaration copies on body windows

SQLite's lean kernel took 26.430 cycles per taken identifier or lookup with the existing compressed position list. Keeping four 16-bit masks and extracting each position with a trailing-zero count took 29.282. Making the leaf while building the list took 30.968. Both raised the cost of the full pass in every round. All 192 runs matched the record, reconstructed-list and decoy oracles.

| Input and mode | Position list | Leaf masks | Make leaves during listing | Copy before fallback |
| --- | ---: | ---: | ---: | ---: |
| SQLite whole | 27.962 | 30.492 | 31.422 | 27.705 |
| SQLite lean | 26.430 | 29.282 | 30.968 | 26.127 |
| Lua whole | 21.672 | 24.825 | 22.168 | 21.352 |
| Lua lean | 21.142 | 23.508 | 22.035 | 20.737 |
| musl whole | 19.012 | 20.112 | 19.867 | 18.683 |
| musl lean | 17.790 | 19.163 | 19.027 | 17.450 |

Copying a declaration line before testing its rare fallback lowered the paired SQLite lean kernel difference by 0.140 cycles per taken record. The full pass cost 0.160 more cycles per window record in all four rounds. The given-only pass also rose, by a paired median of 0.2575. That change has no measured full-pass gain on SQLite lean.

Each table entry is the median of four symmetric round means on locked Ryzen 7 9700X CPU 2, with five passes per process. Each comparison starts from the combined packed-operand and call-conversion candidate. The 10-cycle Step 1 gate applies to the difference between the full and given-only passes normalized by taken leaves and lookups. The full and given-only measurements use all window records as their denominator. [Individual samples](samples.tsv) · [Paired results](paired.tsv) · [Native outputs](measurements.tar.xz) · [Source and executable hashes](builds.tsv)
