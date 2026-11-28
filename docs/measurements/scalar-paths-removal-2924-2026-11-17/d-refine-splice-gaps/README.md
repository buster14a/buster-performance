# Line splices between C tokens

A counter on compiler revision `cc7d4ffb4` recorded calls to `refine_gap_is_splices` by caller, trigraph mode, result and gap length. It used an atomic increment in a shared mapping so that counts from all driver workers were included. For these six commands every call came from the vector token refiner. The table counts gaps that did or did not consist entirely of line splices.

| Input | Ordinary rejected | Ordinary accepted | Trigraphs rejected | Trigraphs accepted |
| --- | ---: | ---: | ---: | ---: |
| Lua 5.4.8 | 1 | 0 | 0 | 0 |
| SQLite amalgamation | 35 | 1 | 0 | 0 |
| musl C files | 0 | 0 | 4,124 | 0 |
| Spelling fixture | 0 | 240 | 0 | 0 |
| Fixture with trigraphs | 0 | 0 | 0 | 480 |
| Fixture with trigraphs and 64-byte windows | 0 | 0 | 0 | 480 |

SQLite accepted one two-byte splice. Most of the real calls came from musl's preprocessing jobs with trigraphs enabled, and every one of those gaps contained other input. The fixture covers ordinary backslashes, trigraphs, optional whitespace and both orders of the two-byte newline. Its accepted counts agreed between the ordinary and the 64-byte window configurations when both used trigraphs.

[Counter patch, invocations, generated input and raw count arrays](native-reach.tar.xz)

## Classifying the bytes in a splice gap

Each candidate agreed with an independent recognizer on 599,026 inputs. They include all strings of up to six bytes from a seven-byte alphabet, cuts inside newline pairs, randomized substitutions, trigraphs, and horizontal whitespace across vector boundaries. The native driver also compared both ends of a protected mapping. It measured 156 lengths from zero to 8,192 bytes and sixteen spellings at each length on the 9700X. Each timing cell used the median of three seed ratios, each based on seven randomized-order measurements.

| Method | Widths and spellings meeting baseline | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: |
| Horizontal runs | 2,002/2,496 | 0.2849 | 8.7229 |
| Adjacent-byte masks | 2,418/2,496 | 0.1696 | 2.1688 |
| Shuffled byte classes | 2,417/2,496 | 0.1520 | 1.9417 |
| Permitted byte pairs | 2,420/2,496 | 0.1226 | 1.5996 |
| Classify the opening boundary | 2,395/2,496 | 0.1338 | 1.4775 |
| Classify both boundaries | 2,422/2,496 | 0.1380 | 1.5184 |

The passing count includes ties. Each candidate still had individual losses. The six implementations and the unchanged baseline are retained in the measurement archive.

[All native timings, implementations, guard-page driver and independent recognizer](gap-kernel-comparisons.tar.xz)
