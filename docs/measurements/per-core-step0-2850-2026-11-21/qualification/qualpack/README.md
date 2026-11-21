# Five-round qualification of the packed template key

On a locked Ryzen 7 9700X core the packed key met the issue's median targets of 20 cycles and 0.2 branch misses per taken node in each workload and cache condition. Musl after scalar work had the narrowest margin. Its five round means ranged from 19.41 to 20.61 cycles per taken node.

| Stream | Condition | Control cycles/node | Packed cycles/node | Packed branch misses/node | Matched entries |
| --- | --- | ---: | ---: | ---: | ---: |
| SQLite | Repeated | 14.878 | 14.168 | 0.0192 | 346,998 |
| SQLite | After 200 ms of scalar work | 20.054 | 19.172 | 0.0202 | 346,998 |
| musl | Repeated | 19.688 | 18.715 | 0.0447 | 154,132 |
| musl | After 200 ms of scalar work | 20.574 | 19.939 | 0.0592 | 154,132 |

Each of the 80 fresh processes ran 21 timed passes of the stand-alone sweeps. A round averages the two process medians for each variant in an ABBA or BAAB order. The table gives the median of five round means. The two executables used the same frozen inputs. The control uses the sparse context dependency and the earlier full-width key. The candidate uses the packed key and context encoding. Exact per-pass hardware counts and the paired ranges are in [counters.tsv](counters.tsv), [rounds.tsv](rounds.tsv) and [summary.tsv](summary.tsv).

The sweeps took the same 257,465 SQLite and 115,610 musl nodes as the scalar reference. Every process checked the type facts, contexts, conversion targets, templates and emitted entries. The packed row lookup also matched an independent four-way membership table on 2,400 learned keys and 307,200 unknown queries for SQLite and 2,396 keys and 306,688 unknown queries for musl. These measurements start from dumped nodes and prebuilt tables. End-to-end source compilation and fact production have their own gates.

[Native logs and binary/input hashes](native-receipts.tar.xz), [exact C sources and baked tables](sources.tar.xz), [measurement commands](qualify-packed.sh) and [aggregation](qualify-report.py).
