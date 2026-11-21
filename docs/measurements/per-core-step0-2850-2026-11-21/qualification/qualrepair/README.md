# Distant operands with one template pass

The first packed template implementation reruns the scalar twin for an expression with a distant operand. This version keeps scalar typing and context propagation for that expression, copies back the corrected facts and uses the same checked template lookup and output sweep as the rest of the window. Both paths took the same nodes and matched all 346,998 SQLite and 154,132 musl entries in every process.

| 9700X cycles per taken node | Control | Corrected facts | Five round means, min–max | Corrected branch misses/node |
| --- | ---: | ---: | ---: | ---: |
| SQLite repeated | 14.128 | 14.120 | 14.100–14.280 | 0.0193 |
| SQLite after scalar work | 19.155 | 19.146 | 18.834–19.247 | 0.0202 |
| musl repeated | 18.798 | 18.404 | 18.345–18.545 | 0.0429 |
| musl after scalar work | 20.142 | 19.857 | 19.362–19.937 | 0.0546 |

Every round mean for the revised path met 20 cycles per taken node in all four conditions. The control's musl after-scalar median had measured 19.939 in the previous qualification and crossed 20 in this run. Correcting the operand facts and reusing the output sweep saved a paired median of 0.682 cycles per taken node on cold musl, with all five differences below zero. There were 80 fresh measurement processes, 21 passes per process, 200 ms of scalar work before each cold pass, and two positions per variant in each symmetric round.

The frozen inputs, prebuilt tables and checked output delimit this stand-alone gate. Local ASan/UBSan verification covered windows of 64 and 4,096 records and the full unit. The dictionary also matched the original four-way lookup on the learned keys and over 300,000 unknowns per input.

[Exact per-pass counters](counters.tsv), [paired summaries and ranges](summary.tsv), [native receipts](native-receipts.tar.xz), [sources and baked tables](sources.tar.xz), [sanitizer checks](local-sanitizers.tar.xz) and [native commands](qualify-repair.sh).
