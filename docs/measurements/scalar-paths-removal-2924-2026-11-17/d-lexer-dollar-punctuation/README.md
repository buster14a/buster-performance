# Dollar punctuation in the lexer and preprocessor

The parent is buster14a/buster@cc7d4ffb449c1f57d8d867c2ad2bf6dc6bfebc7f. The original preprocessor scans the existing token range for dollars and re-tokenizes matching contiguous runs when `-fno-dollars-in-identifiers` or assembler-with-cpp makes the dollar sign punctuation. A counter records complete scans and the work in the rare positive cases. All twelve preprocessing invocations exited successfully.

| Input | Dialect | Scan calls | Token rows | Positive byte scans | Calls with a run | Bytes in runs | Scalar re-lex calls |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| lua | default | 0 | 0 | 0 | 0 | 0 | 0 |
| lua | nodollars | 3,101 | 1,551,479 | 8 | 0 | 0 | 0 |
| lua | asm | 3,053 | 1,412,499 | 8 | 0 | 0 | 0 |
| sqlite | default | 0 | 0 | 0 | 0 | 0 | 0 |
| sqlite | nodollars | 160 | 1,234,862 | 2 | 1 | 33 | 0 |
| sqlite | asm | 156 | 1,230,352 | 2 | 1 | 33 | 0 |
| musl | default | 0 | 0 | 0 | 0 | 0 | 0 |
| musl | nodollars | 23,153 | 16,498,273 | 203 | 0 | 0 | 0 |
| musl | asm | 23,153 | 16,503,617 | 203 | 0 | 0 | 0 |
| dense | default | 0 | 0 | 0 | 0 | 0 | 0 |
| dense | nodollars | 2 | 1,804 | 1 | 1 | 49 | 0 |
| dense | asm | 2 | 1,808 | 1 | 1 | 49 | 0 |

## Complete preprocessing

The candidate passes the dialect to initial tokenization and removes the post-tokenization split. The vector property and kind tables distinguish dollar punctuation, and C++ standard literal-suffix recognition observes the same boundary. The fixture freezes Clang's raw tokens and checks kinds, start-of-line flags and both extents at 65 offsets across a lexer chunk boundary. Three 200,000-input lexer seeds passed. The Clang-backed preprocessor suite passed 419 fixed cases, 240 windowed sources, 24 complete units and 128 generated cases for each of C17 and C23.

Five paired rounds ran three processes per side on CPU 2 of the locked Ryzen 7 9700X. Each cell is the median change in user cycles. Preprocessed output SHA-256 and diagnostics matched separately in every cell. The parent always uses whole-file preparation in the two explicit dollar-punctuation dialects. The candidate also honors windowed preparation in those dialects.

| Dialect | Input | Default window | Whole file | 4 KiB window |
| --- | --- | ---: | ---: | ---: |
| default | lua | +0.284% | +0.185% | +0.116% |
| default | sqlite | +0.032% | +0.200% | +0.466% |
| default | musl | +0.258% | +0.277% | +0.295% |
| nodollars | lua | +0.125% | +0.458% | +4.044% |
| nodollars | sqlite | -34.091% | -32.179% | -27.963% |
| nodollars | musl | -0.008% | +0.289% | +1.109% |
| asm | lua | +0.516% | +0.452% | +4.222% |
| asm | sqlite | -35.398% | -33.048% | -28.954% |
| asm | musl | +0.031% | +0.279% | +1.020% |

## Guarded raw tokenization

The independent matrix places each input against an unreadable page. Ten byte distributions exercise dollars in words, numbers, C and C++ literals, standard suffixes, comments, splices, raw strings and Unicode. The 90 widths cover zero through 65 and boundaries through 65,536 bytes. Correctness runs twelve flag sets and checks kinds, start offsets and end offsets. Each series passed 43,200 comparisons per seed over three seeds. Timings use the no-dollar flag, nine within-seed rounds and the median of three seed-level ratios.

| Vector design | At or below parent dispatcher | At or below forced scalar | Median / forced scalar |
| --- | ---: | ---: | ---: |
| Dynamic dialect flags | 116/900 | 124/900 | 9.102 |
| Dialect lookup tables | 122/900 | 128/900 | 8.834 |
| Dollar presence scan | 118/900 | 126/900 | 8.877 |
| Word and punctuation packets | 225/900 | 220/900 | 6.717 |
| Packets with separated operators | 288/900 | 287/900 | 5.651 |
| Guarded word packets | 232/900 | 224/900 | 6.709 |
| Shared dialect loops | 117/900 | 125/900 | 8.904 |
| Shared loops with dollar presence scan | 125/900 | 129/900 | 8.908 |
| Property vectors selected at entry | 122/900 | 129/900 | 8.978 |

The complete compiler improves substantially on SQLite in the explicit dialects, but several Lua and musl comparisons and many raw input sizes remain slower. The deletion is under qualification.

[Sources, commands, reach counters, frozen oracles, protected inputs and native process logs](dollar-punctuation-native.tar.xz)
